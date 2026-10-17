
create type public.app_role as enum ('reader','writer','moderator','admin');
create type public.book_status as enum ('draft','published','unpublished','archived','under_review');

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text unique,
  display_name text,
  bio text,
  avatar_url text,
  created_at timestamptz not null default now()
);
grant select on public.profiles to anon, authenticated;
grant insert, update on public.profiles to authenticated;
grant all on public.profiles to service_role;
alter table public.profiles enable row level security;
create policy "profiles readable" on public.profiles for select using (true);
create policy "own profile insert" on public.profiles for insert to authenticated with check (auth.uid() = id);
create policy "own profile update" on public.profiles for update to authenticated using (auth.uid() = id);

create table public.user_roles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  role public.app_role not null,
  unique (user_id, role)
);
grant select on public.user_roles to authenticated;
grant all on public.user_roles to service_role;
alter table public.user_roles enable row level security;
create policy "read own roles" on public.user_roles for select to authenticated using (auth.uid() = user_id);

create or replace function public.has_role(_user_id uuid, _role public.app_role)
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.user_roles where user_id = _user_id and role = _role)
$$;

create or replace function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, display_name, username)
  values (new.id, coalesce(new.raw_user_meta_data->>'display_name', split_part(new.email,'@',1)),
          lower(regexp_replace(split_part(new.email,'@',1),'[^a-zA-Z0-9]','','g')) || '-' || substr(new.id::text,1,4));
  insert into public.user_roles (user_id, role) values (new.id, 'reader');
  return new;
end $$;
create trigger on_auth_user_created after insert on auth.users for each row execute function public.handle_new_user();

create table public.authors (
  id uuid primary key default gen_random_uuid(),
  user_id uuid unique,
  username text unique not null,
  display_name text not null,
  bio text,
  website text,
  is_demo boolean not null default false,
  created_at timestamptz not null default now()
);
grant select on public.authors to anon, authenticated;
grant insert, update on public.authors to authenticated;
grant all on public.authors to service_role;
alter table public.authors enable row level security;
create policy "authors readable" on public.authors for select using (true);
create policy "become author" on public.authors for insert to authenticated with check (auth.uid() = user_id and is_demo = false);
create policy "edit own author" on public.authors for update to authenticated using (auth.uid() = user_id);

create or replace function public.grant_writer_role() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if new.user_id is not null then
    insert into public.user_roles (user_id, role) values (new.user_id, 'writer') on conflict do nothing;
  end if;
  return new;
end $$;
create trigger on_author_created after insert on public.authors for each row execute function public.grant_writer_role();

create table public.genres (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  name text not null,
  description text
);
grant select on public.genres to anon, authenticated;
grant insert, update, delete on public.genres to authenticated;
grant all on public.genres to service_role;
alter table public.genres enable row level security;
create policy "genres readable" on public.genres for select using (true);
create policy "admins manage genres" on public.genres for all to authenticated using (public.has_role(auth.uid(),'admin')) with check (public.has_role(auth.uid(),'admin'));

create table public.books (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  author_id uuid not null references public.authors(id) on delete cascade,
  title text not null,
  subtitle text,
  synopsis text,
  cover_color text not null default 'forest',
  language text not null default 'English',
  tags text[] not null default '{}',
  status public.book_status not null default 'draft',
  is_free boolean not null default false,
  currency text not null default 'USD',
  digital_price_cents integer check (digital_price_cents is null or digital_price_cents >= 0),
  physical_price_cents integer check (physical_price_cents is null or physical_price_cents >= 0),
  physical_stock integer not null default 0 check (physical_stock >= 0),
  view_count integer not null default 0,
  published_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index on public.books(status);
create index on public.books(author_id);

create or replace function public.owns_book(_book uuid, _user uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.books b join public.authors a on a.id = b.author_id where b.id = _book and a.user_id = _user)
$$;

grant select on public.books to anon, authenticated;
grant insert, update, delete on public.books to authenticated;
grant all on public.books to service_role;
alter table public.books enable row level security;
create policy "published books readable" on public.books for select using (status = 'published' or exists (select 1 from public.authors a where a.id = author_id and a.user_id = auth.uid()) or public.has_role(auth.uid(),'admin'));
create policy "writers create own books" on public.books for insert to authenticated with check (exists (select 1 from public.authors a where a.id = author_id and a.user_id = auth.uid()));
create policy "writers edit own books" on public.books for update to authenticated using (exists (select 1 from public.authors a where a.id = author_id and a.user_id = auth.uid()) or public.has_role(auth.uid(),'admin'));
create policy "writers delete own drafts" on public.books for delete to authenticated using (status = 'draft' and exists (select 1 from public.authors a where a.id = author_id and a.user_id = auth.uid()));

create table public.book_genres (
  book_id uuid references public.books(id) on delete cascade,
  genre_id uuid references public.genres(id) on delete cascade,
  primary key (book_id, genre_id)
);
grant select on public.book_genres to anon, authenticated;
grant insert, delete on public.book_genres to authenticated;
grant all on public.book_genres to service_role;
alter table public.book_genres enable row level security;
create policy "bg readable" on public.book_genres for select using (true);
create policy "bg owner write" on public.book_genres for insert to authenticated with check (public.owns_book(book_id, auth.uid()));
create policy "bg owner delete" on public.book_genres for delete to authenticated using (public.owns_book(book_id, auth.uid()));

create table public.library_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null,
  book_id uuid not null references public.books(id) on delete cascade,
  source text not null check (source in ('free','purchase','author')),
  shelf text not null default 'want_to_read' check (shelf in ('want_to_read','reading','completed')),
  favorite boolean not null default false,
  progress_chapter integer not null default 1,
  progress_pct integer not null default 0,
  updated_at timestamptz not null default now(),
  unique (user_id, book_id)
);
grant select, insert, update, delete on public.library_entries to authenticated;
grant all on public.library_entries to service_role;
alter table public.library_entries enable row level security;
create policy "own library read" on public.library_entries for select to authenticated using (auth.uid() = user_id);
create policy "save free books" on public.library_entries for insert to authenticated with check (
  auth.uid() = user_id and source = 'free' and exists (select 1 from public.books b where b.id = book_id and b.is_free and b.status = 'published'));
create policy "update own library" on public.library_entries for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "remove free entries" on public.library_entries for delete to authenticated using (auth.uid() = user_id and source = 'free');
create or replace function public.lock_library_source() returns trigger language plpgsql set search_path = public as $$
begin
  if new.source <> old.source or new.book_id <> old.book_id or new.user_id <> old.user_id then
    raise exception 'Cannot change entitlement';
  end if;
  new.updated_at = now();
  return new;
end $$;
create trigger lock_library before update on public.library_entries for each row execute function public.lock_library_source();

create or replace function public.can_read_book(_book uuid, _user uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select public.owns_book(_book, _user)
    or exists (select 1 from public.library_entries l where l.book_id = _book and l.user_id = _user)
    or exists (select 1 from public.books b where b.id = _book and b.is_free and b.status = 'published')
$$;

create table public.chapters (
  id uuid primary key default gen_random_uuid(),
  book_id uuid not null references public.books(id) on delete cascade,
  position integer not null,
  title text not null,
  content text not null default '',
  is_preview boolean not null default false,
  created_at timestamptz not null default now(),
  unique (book_id, position)
);
grant select on public.chapters to anon, authenticated;
grant insert, update, delete on public.chapters to authenticated;
grant all on public.chapters to service_role;
alter table public.chapters enable row level security;
create policy "read permitted chapters" on public.chapters for select using (
  (is_preview and exists (select 1 from public.books b where b.id = book_id and b.status='published'))
  or public.can_read_book(book_id, auth.uid()));
create policy "owner insert chapters" on public.chapters for insert to authenticated with check (public.owns_book(book_id, auth.uid()));
create policy "owner update chapters" on public.chapters for update to authenticated using (public.owns_book(book_id, auth.uid()));
create policy "owner delete chapters" on public.chapters for delete to authenticated using (public.owns_book(book_id, auth.uid()));

create table public.reviews (
  id uuid primary key default gen_random_uuid(),
  book_id uuid not null references public.books(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  rating integer not null check (rating between 1 and 5),
  body text check (char_length(body) <= 5000),
  spoiler boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (book_id, user_id)
);
grant select on public.reviews to anon, authenticated;
grant insert, update, delete on public.reviews to authenticated;
grant all on public.reviews to service_role;
alter table public.reviews enable row level security;
create policy "reviews readable" on public.reviews for select using (true);
create policy "write own review" on public.reviews for insert to authenticated with check (auth.uid() = user_id);
create policy "edit own review" on public.reviews for update to authenticated using (auth.uid() = user_id);
create policy "delete own review" on public.reviews for delete to authenticated using (auth.uid() = user_id or public.has_role(auth.uid(),'admin'));

create view public.book_ratings with (security_invoker = on) as
  select book_id, round(avg(rating)::numeric, 1) as avg_rating, count(*)::int as review_count from public.reviews group by book_id;
grant select on public.book_ratings to anon, authenticated;

create table public.wishlist (
  user_id uuid not null, book_id uuid not null references public.books(id) on delete cascade,
  created_at timestamptz not null default now(), primary key (user_id, book_id));
grant select, insert, delete on public.wishlist to authenticated;
grant all on public.wishlist to service_role;
alter table public.wishlist enable row level security;
create policy "own wishlist" on public.wishlist for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

create table public.author_follows (
  follower_id uuid not null, author_id uuid not null references public.authors(id) on delete cascade,
  created_at timestamptz not null default now(), primary key (follower_id, author_id));
grant select on public.author_follows to anon, authenticated;
grant insert, delete on public.author_follows to authenticated;
grant all on public.author_follows to service_role;
alter table public.author_follows enable row level security;
create policy "follows readable" on public.author_follows for select using (true);
create policy "own follow" on public.author_follows for insert to authenticated with check (auth.uid() = follower_id);
create policy "own unfollow" on public.author_follows for delete to authenticated using (auth.uid() = follower_id);

create table public.cart_items (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null,
  book_id uuid not null references public.books(id) on delete cascade,
  format text not null check (format in ('digital','physical')),
  quantity integer not null default 1 check (quantity between 1 and 20),
  created_at timestamptz not null default now(),
  unique (user_id, book_id, format)
);
grant select, insert, update, delete on public.cart_items to authenticated;
grant all on public.cart_items to service_role;
alter table public.cart_items enable row level security;
create policy "own cart" on public.cart_items for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

create table public.orders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null,
  status text not null default 'pending' check (status in ('pending','paid','failed','canceled','refunded')),
  is_sandbox boolean not null default true,
  currency text not null default 'USD',
  subtotal_cents integer not null,
  shipping_cents integer not null default 0,
  total_cents integer not null,
  shipping_address jsonb,
  idempotency_key text unique,
  created_at timestamptz not null default now()
);
grant select on public.orders to authenticated;
grant all on public.orders to service_role;
alter table public.orders enable row level security;
create policy "own orders" on public.orders for select to authenticated using (auth.uid() = user_id or public.has_role(auth.uid(),'admin'));

create table public.order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  book_id uuid references public.books(id) on delete set null,
  title_snapshot text not null,
  format text not null,
  quantity integer not null,
  unit_price_cents integer not null,
  commission_bps integer not null
);
grant select on public.order_items to authenticated;
grant all on public.order_items to service_role;
alter table public.order_items enable row level security;
create policy "own order items" on public.order_items for select to authenticated using (
  exists (select 1 from public.orders o where o.id = order_id and (o.user_id = auth.uid() or public.has_role(auth.uid(),'admin')))
  or public.owns_book(book_id, auth.uid()));

create table public.app_settings (key text primary key, value jsonb not null, updated_at timestamptz not null default now());
grant select on public.app_settings to anon, authenticated;
grant update on public.app_settings to authenticated;
grant all on public.app_settings to service_role;
alter table public.app_settings enable row level security;
create policy "settings readable" on public.app_settings for select using (true);
create policy "admin update settings" on public.app_settings for update to authenticated using (public.has_role(auth.uid(),'admin'));

create table public.hubs (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  name text not null,
  description text,
  topic text,
  tags text[] not null default '{}',
  book_id uuid references public.books(id) on delete set null,
  visibility text not null default 'public' check (visibility in ('public','private')),
  rules text,
  created_by uuid,
  created_at timestamptz not null default now()
);
create table public.hub_members (
  hub_id uuid not null references public.hubs(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  role text not null default 'member' check (role in ('member','moderator','owner')),
  status text not null default 'active' check (status in ('active','pending','muted','removed')),
  last_read_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  primary key (hub_id, user_id)
);
create or replace function public.is_hub_member(_hub uuid, _user uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.hub_members where hub_id=_hub and user_id=_user and status in ('active','muted'))
$$;
create or replace function public.is_hub_mod(_hub uuid, _user uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.hub_members where hub_id=_hub and user_id=_user and status='active' and role in ('moderator','owner'))
$$;
create or replace function public.can_view_hub(_hub uuid, _user uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.hubs where id=_hub and visibility='public') or public.is_hub_member(_hub,_user) or public.has_role(_user,'admin')
$$;

grant select on public.hubs to anon, authenticated;
grant insert, update on public.hubs to authenticated;
grant all on public.hubs to service_role;
alter table public.hubs enable row level security;
create policy "hubs listed" on public.hubs for select using (true);
create policy "create hub" on public.hubs for insert to authenticated with check (auth.uid() = created_by);
create policy "mods edit hub" on public.hubs for update to authenticated using (public.is_hub_mod(id, auth.uid()));

create or replace function public.hub_owner_membership() returns trigger language plpgsql security definer set search_path = public as $$
begin
  if new.created_by is not null then
    insert into public.hub_members (hub_id,user_id,role,status) values (new.id,new.created_by,'owner','active') on conflict do nothing;
  end if;
  return new;
end $$;
create trigger on_hub_created after insert on public.hubs for each row execute function public.hub_owner_membership();

grant select, insert, update, delete on public.hub_members to authenticated;
grant select on public.hub_members to anon;
grant all on public.hub_members to service_role;
alter table public.hub_members enable row level security;
create policy "members visible" on public.hub_members for select using (public.can_view_hub(hub_id, auth.uid()) or user_id = auth.uid());
create policy "join hub" on public.hub_members for insert to authenticated with check (
  auth.uid() = user_id and role = 'member' and (
    (status = 'active' and exists (select 1 from public.hubs h where h.id = hub_id and h.visibility='public'))
    or status = 'pending'));
create policy "mods manage members" on public.hub_members for update to authenticated using (public.is_hub_mod(hub_id, auth.uid()) or user_id = auth.uid());
create policy "leave or remove" on public.hub_members for delete to authenticated using (auth.uid() = user_id or public.is_hub_mod(hub_id, auth.uid()));
create or replace function public.guard_member_update() returns trigger language plpgsql security definer set search_path = public as $$
begin
  if not public.is_hub_mod(old.hub_id, auth.uid()) and (new.role <> old.role or new.status <> old.status) then
    raise exception 'Not allowed';
  end if;
  if new.role = 'owner' and old.role <> 'owner' then raise exception 'Not allowed'; end if;
  return new;
end $$;
create trigger guard_member before update on public.hub_members for each row execute function public.guard_member_update();

create table public.hub_posts (
  id uuid primary key default gen_random_uuid(),
  hub_id uuid not null references public.hubs(id) on delete cascade,
  author_id uuid references public.profiles(id) on delete set null,
  author_label text,
  kind text not null default 'discussion' check (kind in ('discussion','theory','character','announcement','event')),
  title text not null check (char_length(title) between 1 and 200),
  body text not null check (char_length(body) between 1 and 10000),
  spoiler boolean not null default false,
  pinned boolean not null default false,
  created_at timestamptz not null default now()
);
grant select on public.hub_posts to anon, authenticated;
grant insert, update, delete on public.hub_posts to authenticated;
grant all on public.hub_posts to service_role;
alter table public.hub_posts enable row level security;
create policy "view posts" on public.hub_posts for select using (public.can_view_hub(hub_id, auth.uid()));
create policy "members post" on public.hub_posts for insert to authenticated with check (auth.uid() = author_id and exists (select 1 from public.hub_members m where m.hub_id = hub_posts.hub_id and m.user_id = auth.uid() and m.status='active'));
create policy "mods pin" on public.hub_posts for update to authenticated using (public.is_hub_mod(hub_id, auth.uid()) or auth.uid() = author_id);
create policy "delete posts" on public.hub_posts for delete to authenticated using (auth.uid() = author_id or public.is_hub_mod(hub_id, auth.uid()));

create table public.hub_comments (
  id uuid primary key default gen_random_uuid(),
  post_id uuid not null references public.hub_posts(id) on delete cascade,
  author_id uuid references public.profiles(id) on delete set null,
  author_label text,
  body text not null check (char_length(body) between 1 and 4000),
  created_at timestamptz not null default now()
);
grant select on public.hub_comments to anon, authenticated;
grant insert, delete on public.hub_comments to authenticated;
grant all on public.hub_comments to service_role;
alter table public.hub_comments enable row level security;
create policy "view comments" on public.hub_comments for select using (exists (select 1 from public.hub_posts p where p.id = post_id and public.can_view_hub(p.hub_id, auth.uid())));
create policy "members comment" on public.hub_comments for insert to authenticated with check (auth.uid() = author_id and exists (select 1 from public.hub_posts p join public.hub_members m on m.hub_id = p.hub_id where p.id = post_id and m.user_id = auth.uid() and m.status='active'));
create policy "delete comments" on public.hub_comments for delete to authenticated using (auth.uid() = author_id or exists (select 1 from public.hub_posts p where p.id = post_id and public.is_hub_mod(p.hub_id, auth.uid())));

create table public.hub_messages (
  id uuid primary key default gen_random_uuid(),
  hub_id uuid not null references public.hubs(id) on delete cascade,
  sender_id uuid not null references public.profiles(id) on delete cascade,
  body text not null check (char_length(body) between 1 and 2000),
  hidden boolean not null default false,
  created_at timestamptz not null default now()
);
create index on public.hub_messages(hub_id, created_at);
grant select, insert, update on public.hub_messages to authenticated;
grant all on public.hub_messages to service_role;
alter table public.hub_messages enable row level security;
create policy "members read chat" on public.hub_messages for select to authenticated using (public.is_hub_member(hub_id, auth.uid()) and (not hidden or public.is_hub_mod(hub_id, auth.uid())));
create policy "active members send" on public.hub_messages for insert to authenticated with check (auth.uid() = sender_id and exists (select 1 from public.hub_members m where m.hub_id = hub_messages.hub_id and m.user_id = auth.uid() and m.status='active'));
create policy "mods hide" on public.hub_messages for update to authenticated using (public.is_hub_mod(hub_id, auth.uid()));
create or replace function public.rate_limit_messages() returns trigger language plpgsql security definer set search_path = public as $$
begin
  if (select count(*) from public.hub_messages where sender_id = new.sender_id and created_at > now() - interval '30 seconds') >= 10 then
    raise exception 'You are sending messages too quickly. Please wait a moment.';
  end if;
  return new;
end $$;
create trigger rl_messages before insert on public.hub_messages for each row execute function public.rate_limit_messages();
alter publication supabase_realtime add table public.hub_messages;

create table public.user_blocks (
  blocker_id uuid not null, blocked_id uuid not null, created_at timestamptz not null default now(),
  primary key (blocker_id, blocked_id), check (blocker_id <> blocked_id));
grant select, insert, delete on public.user_blocks to authenticated;
grant all on public.user_blocks to service_role;
alter table public.user_blocks enable row level security;
create policy "own blocks" on public.user_blocks for all to authenticated using (auth.uid() = blocker_id) with check (auth.uid() = blocker_id);

create table public.reports (
  id uuid primary key default gen_random_uuid(),
  reporter_id uuid not null,
  target_type text not null check (target_type in ('book','review','hub_post','hub_comment','hub_message','story_suggestion','user','copyright')),
  target_id uuid not null,
  reason text not null check (char_length(reason) between 3 and 2000),
  status text not null default 'open' check (status in ('open','actioned','dismissed')),
  resolution_note text,
  resolved_by uuid,
  created_at timestamptz not null default now()
);
grant select, insert, update on public.reports to authenticated;
grant all on public.reports to service_role;
alter table public.reports enable row level security;
create policy "file report" on public.reports for insert to authenticated with check (auth.uid() = reporter_id and status = 'open');
create policy "see own or admin" on public.reports for select to authenticated using (auth.uid() = reporter_id or public.has_role(auth.uid(),'admin') or public.has_role(auth.uid(),'moderator'));
create policy "admin resolve" on public.reports for update to authenticated using (public.has_role(auth.uid(),'admin') or public.has_role(auth.uid(),'moderator'));

create table public.audit_logs (
  id uuid primary key default gen_random_uuid(),
  actor_id uuid, action text not null, target_type text, target_id uuid, note text,
  created_at timestamptz not null default now());
grant select, insert on public.audit_logs to authenticated;
grant all on public.audit_logs to service_role;
alter table public.audit_logs enable row level security;
create policy "admin audit read" on public.audit_logs for select to authenticated using (public.has_role(auth.uid(),'admin'));
create policy "staff audit write" on public.audit_logs for insert to authenticated with check (auth.uid() = actor_id and (public.has_role(auth.uid(),'admin') or public.has_role(auth.uid(),'moderator')));

create table public.story_projects (
  id uuid primary key default gen_random_uuid(),
  book_id uuid not null references public.books(id) on delete cascade,
  title text not null,
  focus text,
  brief text not null,
  visibility text not null default 'public' check (visibility in ('public','private','invite')),
  allow_suggestions boolean not null default true,
  allow_voting boolean not null default true,
  allow_cowriting boolean not null default false,
  status text not null default 'open' check (status in ('open','reviewing','closed','published')),
  deadline date,
  contributor_terms text not null default 'Contributors keep the moral right to be credited. By submitting, you grant the author a non-exclusive licence to adapt your idea in this story. Commercial use of accepted contributions requires a separate written agreement.',
  base_text text not null default '',
  published_text text,
  created_at timestamptz not null default now()
);
create or replace function public.owns_project(_p uuid, _u uuid) returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.story_projects p where p.id=_p and public.owns_book(p.book_id,_u))
$$;
grant select on public.story_projects to anon, authenticated;
grant insert, update, delete on public.story_projects to authenticated;
grant all on public.story_projects to service_role;
alter table public.story_projects enable row level security;
create policy "author creates" on public.story_projects for insert to authenticated with check (public.owns_book(book_id, auth.uid()));
create policy "author edits" on public.story_projects for update to authenticated using (public.owns_book(book_id, auth.uid()));
create policy "author deletes" on public.story_projects for delete to authenticated using (public.owns_book(book_id, auth.uid()));

create table public.story_collaborators (
  project_id uuid not null references public.story_projects(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  status text not null default 'requested' check (status in ('requested','approved','declined')),
  accepted_terms_at timestamptz not null default now(),
  primary key (project_id, user_id));
grant select, insert, update, delete on public.story_collaborators to authenticated;
grant all on public.story_collaborators to service_role;
alter table public.story_collaborators enable row level security;
create policy "see collabs" on public.story_collaborators for select to authenticated using (auth.uid() = user_id or public.owns_project(project_id, auth.uid()));
create policy "request collab" on public.story_collaborators for insert to authenticated with check (auth.uid() = user_id and status = 'requested');
create policy "author decides" on public.story_collaborators for update to authenticated using (public.owns_project(project_id, auth.uid()));
create policy "withdraw" on public.story_collaborators for delete to authenticated using (auth.uid() = user_id or public.owns_project(project_id, auth.uid()));

create or replace function public.is_collaborator(_p uuid, _u uuid) returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.story_collaborators where project_id=_p and user_id=_u and status='approved')
$$;
create policy "view projects" on public.story_projects for select using (visibility = 'public' or public.owns_book(book_id, auth.uid()) or public.is_collaborator(id, auth.uid()));

create table public.story_suggestions (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.story_projects(id) on delete cascade,
  author_id uuid references public.profiles(id) on delete set null,
  author_label text,
  kind text not null check (kind in ('dialogue','character_decision','plot_twist','scene','ending')),
  body text not null check (char_length(body) between 5 and 5000),
  rationale text,
  status text not null default 'open' check (status in ('open','selected','declined')),
  created_at timestamptz not null default now());
grant select on public.story_suggestions to anon, authenticated;
grant insert, update, delete on public.story_suggestions to authenticated;
grant all on public.story_suggestions to service_role;
alter table public.story_suggestions enable row level security;
create policy "see suggestions" on public.story_suggestions for select using (exists (select 1 from public.story_projects p where p.id = project_id));
create policy "suggest" on public.story_suggestions for insert to authenticated with check (auth.uid() = author_id and status='open' and exists (select 1 from public.story_projects p where p.id = project_id and p.allow_suggestions and p.status='open'));
create policy "author marks" on public.story_suggestions for update to authenticated using (public.owns_project(project_id, auth.uid()));
create policy "delete own suggestion" on public.story_suggestions for delete to authenticated using (auth.uid() = author_id);

create table public.story_votes (
  suggestion_id uuid not null references public.story_suggestions(id) on delete cascade,
  user_id uuid not null, created_at timestamptz not null default now(),
  primary key (suggestion_id, user_id));
grant select on public.story_votes to anon, authenticated;
grant insert, delete on public.story_votes to authenticated;
grant all on public.story_votes to service_role;
alter table public.story_votes enable row level security;
create policy "votes readable" on public.story_votes for select using (true);
create policy "vote" on public.story_votes for insert to authenticated with check (auth.uid() = user_id and exists (select 1 from public.story_suggestions s join public.story_projects p on p.id = s.project_id where s.id = suggestion_id and p.allow_voting and p.status='open'));
create policy "unvote" on public.story_votes for delete to authenticated using (auth.uid() = user_id);

create table public.story_revisions (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.story_projects(id) on delete cascade,
  contributor_id uuid references public.profiles(id) on delete set null,
  version integer not null,
  content text not null,
  summary text not null,
  status text not null default 'pending' check (status in ('pending','accepted','rejected','published')),
  reviewed_at timestamptz,
  created_at timestamptz not null default now(),
  unique (project_id, version));
grant select, insert, update on public.story_revisions to authenticated;
grant all on public.story_revisions to service_role;
alter table public.story_revisions enable row level security;
create policy "see revisions" on public.story_revisions for select to authenticated using (auth.uid() = contributor_id or public.owns_project(project_id, auth.uid()) or status='published');
create policy "collab submits" on public.story_revisions for insert to authenticated with check (auth.uid() = contributor_id and status='pending' and (
  public.owns_project(project_id, auth.uid()) or (public.is_collaborator(project_id, auth.uid()) and exists (select 1 from public.story_projects p where p.id = project_id and p.allow_cowriting))));
create policy "author reviews" on public.story_revisions for update to authenticated using (public.owns_project(project_id, auth.uid()));

create table public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null, kind text not null, body text not null, link text,
  read boolean not null default false, created_at timestamptz not null default now());
grant select, update, delete on public.notifications to authenticated;
grant all on public.notifications to service_role;
alter table public.notifications enable row level security;
create policy "own notifications" on public.notifications for select to authenticated using (auth.uid() = user_id);
create policy "mark read" on public.notifications for update to authenticated using (auth.uid() = user_id);
create policy "dismiss" on public.notifications for delete to authenticated using (auth.uid() = user_id);

create or replace function public.notify_follow() returns trigger language plpgsql security definer set search_path = public as $$
declare uid uuid;
begin
  select user_id into uid from public.authors where id = new.author_id;
  if uid is not null then insert into public.notifications (user_id, kind, body, link) values (uid,'follow','You have a new follower','/studio'); end if;
  return new;
end $$;
create trigger on_follow after insert on public.author_follows for each row execute function public.notify_follow();

create or replace function public.notify_suggestion() returns trigger language plpgsql security definer set search_path = public as $$
declare uid uuid;
begin
  select a.user_id into uid from public.story_projects p join public.books b on b.id=p.book_id join public.authors a on a.id=b.author_id where p.id=new.project_id;
  if uid is not null then insert into public.notifications (user_id,kind,body,link) values (uid,'story_lab','New Story Lab suggestion received','/story-lab/'||new.project_id); end if;
  return new;
end $$;
create trigger on_suggestion after insert on public.story_suggestions for each row execute function public.notify_suggestion();

insert into public.app_settings (key, value) values ('commission_bps', '1500'::jsonb), ('launch_currency', '"USD"'::jsonb);

insert into public.genres (slug, name, description) values
 ('literary-fiction','Literary Fiction','Character-driven stories with lasting resonance.'),
 ('mystery','Mystery & Thriller','Puzzles, suspense, and late-night page turning.'),
 ('romance','Romance','Love stories in every shape.'),
 ('fantasy','Fantasy','Other worlds, quietly built.'),
 ('science-fiction','Science Fiction','Futures, near and far.'),
 ('historical','Historical','The past, reimagined.'),
 ('poetry','Poetry','Small forms, large feelings.'),
 ('nonfiction','Nonfiction','Essays, memoir, and ideas.');

insert into public.authors (username, display_name, bio, is_demo) values
 ('amara-voss','Amara Voss','Fictional demo author. Writes quiet mysteries set in coastal towns.', true),
 ('teo-marchetti','Teo Marchetti','Fictional demo author. Speculative fiction about cities and memory.', true),
 ('lin-okafor','Lin Okafor','Fictional demo author. Romance and found family.', true),
 ('hana-sato','Hana Sato','Fictional demo author. Poetry and short essays.', true);

insert into public.books (slug, author_id, title, subtitle, synopsis, cover_color, language, tags, status, is_free, digital_price_cents, physical_price_cents, physical_stock, published_at, view_count)
select v.slug, a.id, v.title, v.subtitle, v.synopsis, v.color, v.lang, v.tags, 'published', v.free, v.dp, v.pp, v.stock, now() - (v.days || ' days')::interval, v.views
from (values
 ('the-lighthouse-ledger','amara-voss','The Lighthouse Ledger','A Saltmarsh Mystery','When the keeper of Saltmarsh Light vanishes, his logbook is the only witness — and someone has torn out the last page.','forest','English', array['mystery','coastal','slow-burn'], false, 899, 1899, 24, 5, 412),
 ('fog-over-pell-harbour','amara-voss','Fog Over Pell Harbour',null,'A ferry arrives with one passenger too many. Detective Ines Calder has until the fog lifts.','sage','English', array['mystery','detective'], false, 699, null, 0, 40, 233),
 ('cartographers-of-ash','teo-marchetti','Cartographers of Ash',null,'In a city that redraws itself every night, a mapmaker finds a street that remembers her.','charcoal','English', array['speculative','city','memory'], false, 1099, 2299, 8, 12, 518),
 ('the-quiet-orbit','teo-marchetti','The Quiet Orbit','Stories','Seven short stories about the people who stay behind when the ships leave.','gold','English', array['short-stories','space'], true, null, null, 0, 90, 640),
 ('letters-to-the-tea-shop','lin-okafor','Letters to the Tea Shop',null,'An anonymous pen pal, a failing tea shop, and a neighbourhood that refuses to let either close.','parchment','English', array['romance','cozy','found-family'], false, 499, 1499, 50, 2, 301),
 ('summer-of-small-hours','lin-okafor','The Summer of Small Hours',null,'Two night-shift bakers, one shared playlist, and the slow realisation that home might be a person.','taupe','English', array['romance','contemporary'], true, null, null, 0, 60, 455),
 ('salt-and-margin','hana-sato','Salt and Margin','Poems','Poems written in the margins of borrowed books.','forest','English', array['poetry','margins'], false, 399, 1299, 15, 20, 120),
 ('la-casa-de-papel-azul','hana-sato','La casa de papel azul',null,'Ensayos breves sobre la lectura, la memoria y las casas donde vivimos.','sage','Spanish', array['essays','memory'], true, null, null, 0, 30, 88)
) as v(slug, author, title, subtitle, synopsis, color, lang, tags, free, dp, pp, stock, days, views)
join public.authors a on a.username = v.author;

insert into public.book_genres (book_id, genre_id)
select b.id, g.id from (values
 ('the-lighthouse-ledger','mystery'),('fog-over-pell-harbour','mystery'),('cartographers-of-ash','fantasy'),('cartographers-of-ash','literary-fiction'),
 ('the-quiet-orbit','science-fiction'),('letters-to-the-tea-shop','romance'),('summer-of-small-hours','romance'),('salt-and-margin','poetry'),('la-casa-de-papel-azul','nonfiction')
) v(bs, gs) join public.books b on b.slug=v.bs join public.genres g on g.slug=v.gs;

insert into public.chapters (book_id, position, title, content, is_preview)
select b.id, c.pos, c.title, c.content, c.preview from public.books b
cross join lateral (values
 (1, 'Chapter One', 'The first thing anyone noticed was the silence.' || chr(10) || chr(10) || 'For thirty-one years the lamp at the top of the tower had turned without complaint, and the town had set its clocks, its tides and its arguments by it. Now the glass was dark, the door was unlatched, and on the desk lay a ledger, open, its final page torn cleanly along the spine.' || chr(10) || chr(10) || 'She ran a finger down the ragged edge. Someone had wanted the ending gone.', true),
 (2, 'Chapter Two', 'By morning the rumours had found their way into every kitchen on the harbour road.' || chr(10) || chr(10) || 'Some said the keeper had walked into the sea. Others said he had simply caught the early ferry and never looked back. She listened to all of them, wrote down none of them, and went back up the stairs with a pencil and a magnifying glass.', false),
 (3, 'Chapter Three', 'The torn page turned up in the least likely place: pressed between the hymnals of a church that had not held a service in a decade.' || chr(10) || chr(10) || 'It held a single line, written in a hand that was not the keeper''s.', false)
) as c(pos, title, content, preview);

insert into public.hubs (slug, name, description, topic, tags, book_id, visibility, rules) values
 ('saltmarsh-sleuths','Saltmarsh Sleuths','Theories, clues and red herrings from The Lighthouse Ledger.','Book', array['mystery','theories'], (select id from public.books where slug='the-lighthouse-ledger'), 'public', 'Mark spoilers. Be kind to wrong theories — they are half the fun.'),
 ('cozy-romance-corner','Cozy Romance Corner','Low-stakes love stories, tea recommendations and found family.','Genre', array['romance','cozy'], null, 'public', 'No ending spoilers without a spoiler tag.'),
 ('margin-writers-circle','Margin Writers Circle','A private critique circle for poets. Request to join.','Writing', array['poetry','critique'], null, 'private', 'What is shared in the circle stays in the circle.');

insert into public.hub_posts (hub_id, author_label, kind, title, body, spoiler, pinned)
select h.id, v.label, v.kind, v.title, v.body, v.spoiler, v.pinned from (values
 ('saltmarsh-sleuths','Hub team (demo)','announcement','Welcome to Saltmarsh Sleuths','Introduce yourself and tell us which chapter you are on. Please use the spoiler toggle for anything past Chapter One.', false, true),
 ('saltmarsh-sleuths','Demo reader','theory','The torn page was never taken from the tower','Hear me out: the ledger binding is too clean. I think the page was removed before the keeper left.', true, false),
 ('cozy-romance-corner','Demo reader','discussion','Best tea to pair with Letters to the Tea Shop?','I went with a smoky lapsang and regret nothing.', false, false),
 ('margin-writers-circle','Demo reader','discussion','Private: draft feedback thread','Members-only critique thread.', false, false)
) v(hs,label,kind,title,body,spoiler,pinned) join public.hubs h on h.slug = v.hs;

insert into public.story_projects (book_id, title, focus, brief, allow_suggestions, allow_voting, allow_cowriting, base_text, deadline)
values ((select id from public.books where slug='the-lighthouse-ledger'), 'Who wrote the torn page?', 'Chapter Four · the church scene',
 'Chapter Four opens with the single line on the torn page. I have three endings in mind, but I want to hear yours. Suggest the line, the writer, or what happens next.',
 true, true, false, 'She unfolded the page beneath the cracked rose window. The line read: ', current_date + 30);

insert into public.story_suggestions (project_id, author_label, kind, body, rationale)
select p.id, v.label, v.kind, v.body, v.why from public.story_projects p,
 (values ('Demo reader','plot_twist','The line is in the keeper''s daughter''s handwriting — she was the one keeping the ledger for the last year.','It explains why the hand is unfamiliar yet the details are perfect.'),
         ('Demo reader','dialogue','"If the light goes dark, look where nobody prays."','A clue pointing to the church itself; nicely circular.')) v(label,kind,body,why);
