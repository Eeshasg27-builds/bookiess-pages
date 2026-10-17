export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.18"
  }
  public: {
    Tables: {
      app_settings: {
        Row: {
          key: string
          updated_at: string
          value: Json
        }
        Insert: {
          key: string
          updated_at?: string
          value: Json
        }
        Update: {
          key?: string
          updated_at?: string
          value?: Json
        }
        Relationships: []
      }
      audit_logs: {
        Row: {
          action: string
          actor_id: string | null
          created_at: string
          id: string
          note: string | null
          target_id: string | null
          target_type: string | null
        }
        Insert: {
          action: string
          actor_id?: string | null
          created_at?: string
          id?: string
          note?: string | null
          target_id?: string | null
          target_type?: string | null
        }
        Update: {
          action?: string
          actor_id?: string | null
          created_at?: string
          id?: string
          note?: string | null
          target_id?: string | null
          target_type?: string | null
        }
        Relationships: []
      }
      author_follows: {
        Row: {
          author_id: string
          created_at: string
          follower_id: string
        }
        Insert: {
          author_id: string
          created_at?: string
          follower_id: string
        }
        Update: {
          author_id?: string
          created_at?: string
          follower_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "author_follows_author_id_fkey"
            columns: ["author_id"]
            isOneToOne: false
            referencedRelation: "authors"
            referencedColumns: ["id"]
          },
        ]
      }
      authors: {
        Row: {
          bio: string | null
          created_at: string
          display_name: string
          id: string
          is_demo: boolean
          user_id: string | null
          username: string
          website: string | null
        }
        Insert: {
          bio?: string | null
          created_at?: string
          display_name: string
          id?: string
          is_demo?: boolean
          user_id?: string | null
          username: string
          website?: string | null
        }
        Update: {
          bio?: string | null
          created_at?: string
          display_name?: string
          id?: string
          is_demo?: boolean
          user_id?: string | null
          username?: string
          website?: string | null
        }
        Relationships: []
      }
      book_genres: {
        Row: {
          book_id: string
          genre_id: string
        }
        Insert: {
          book_id: string
          genre_id: string
        }
        Update: {
          book_id?: string
          genre_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "book_genres_book_id_fkey"
            columns: ["book_id"]
            isOneToOne: false
            referencedRelation: "books"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "book_genres_genre_id_fkey"
            columns: ["genre_id"]
            isOneToOne: false
            referencedRelation: "genres"
            referencedColumns: ["id"]
          },
        ]
      }
      books: {
        Row: {
          author_id: string
          cover_color: string
          created_at: string
          currency: string
          digital_price_cents: number | null
          id: string
          is_free: boolean
          language: string
          physical_price_cents: number | null
          physical_stock: number
          published_at: string | null
          slug: string
          status: Database["public"]["Enums"]["book_status"]
          subtitle: string | null
          synopsis: string | null
          tags: string[]
          title: string
          updated_at: string
          view_count: number
        }
        Insert: {
          author_id: string
          cover_color?: string
          created_at?: string
          currency?: string
          digital_price_cents?: number | null
          id?: string
          is_free?: boolean
          language?: string
          physical_price_cents?: number | null
          physical_stock?: number
          published_at?: string | null
          slug: string
          status?: Database["public"]["Enums"]["book_status"]
          subtitle?: string | null
          synopsis?: string | null
          tags?: string[]
          title: string
          updated_at?: string
          view_count?: number
        }
        Update: {
          author_id?: string
          cover_color?: string
          created_at?: string
          currency?: string
          digital_price_cents?: number | null
          id?: string
          is_free?: boolean
          language?: string
          physical_price_cents?: number | null
          physical_stock?: number
          published_at?: string | null
          slug?: string
          status?: Database["public"]["Enums"]["book_status"]
          subtitle?: string | null
          synopsis?: string | null
          tags?: string[]
          title?: string
          updated_at?: string
          view_count?: number
        }
        Relationships: [
          {
            foreignKeyName: "books_author_id_fkey"
            columns: ["author_id"]
            isOneToOne: false
            referencedRelation: "authors"
            referencedColumns: ["id"]
          },
        ]
      }
      cart_items: {
        Row: {
          book_id: string
          created_at: string
          format: string
          id: string
          quantity: number
          user_id: string
        }
        Insert: {
          book_id: string
          created_at?: string
          format: string
          id?: string
          quantity?: number
          user_id: string
        }
        Update: {
          book_id?: string
          created_at?: string
          format?: string
          id?: string
          quantity?: number
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "cart_items_book_id_fkey"
            columns: ["book_id"]
            isOneToOne: false
            referencedRelation: "books"
            referencedColumns: ["id"]
          },
        ]
      }
      chapters: {
        Row: {
          book_id: string
          content: string
          created_at: string
          id: string
          is_preview: boolean
          position: number
          title: string
        }
        Insert: {
          book_id: string
          content?: string
          created_at?: string
          id?: string
          is_preview?: boolean
          position: number
          title: string
        }
        Update: {
          book_id?: string
          content?: string
          created_at?: string
          id?: string
          is_preview?: boolean
          position?: number
          title?: string
        }
        Relationships: [
          {
            foreignKeyName: "chapters_book_id_fkey"
            columns: ["book_id"]
            isOneToOne: false
            referencedRelation: "books"
            referencedColumns: ["id"]
          },
        ]
      }
      genres: {
        Row: {
          description: string | null
          id: string
          name: string
          slug: string
        }
        Insert: {
          description?: string | null
          id?: string
          name: string
          slug: string
        }
        Update: {
          description?: string | null
          id?: string
          name?: string
          slug?: string
        }
        Relationships: []
      }
      hub_comments: {
        Row: {
          author_id: string | null
          author_label: string | null
          body: string
          created_at: string
          id: string
          post_id: string
        }
        Insert: {
          author_id?: string | null
          author_label?: string | null
          body: string
          created_at?: string
          id?: string
          post_id: string
        }
        Update: {
          author_id?: string | null
          author_label?: string | null
          body?: string
          created_at?: string
          id?: string
          post_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "hub_comments_author_id_fkey"
            columns: ["author_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "hub_comments_post_id_fkey"
            columns: ["post_id"]
            isOneToOne: false
            referencedRelation: "hub_posts"
            referencedColumns: ["id"]
          },
        ]
      }
      hub_members: {
        Row: {
          created_at: string
          hub_id: string
          last_read_at: string
          role: string
          status: string
          user_id: string
        }
        Insert: {
          created_at?: string
          hub_id: string
          last_read_at?: string
          role?: string
          status?: string
          user_id: string
        }
        Update: {
          created_at?: string
          hub_id?: string
          last_read_at?: string
          role?: string
          status?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "hub_members_hub_id_fkey"
            columns: ["hub_id"]
            isOneToOne: false
            referencedRelation: "hubs"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "hub_members_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      hub_messages: {
        Row: {
          body: string
          created_at: string
          hidden: boolean
          hub_id: string
          id: string
          sender_id: string
        }
        Insert: {
          body: string
          created_at?: string
          hidden?: boolean
          hub_id: string
          id?: string
          sender_id: string
        }
        Update: {
          body?: string
          created_at?: string
          hidden?: boolean
          hub_id?: string
          id?: string
          sender_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "hub_messages_hub_id_fkey"
            columns: ["hub_id"]
            isOneToOne: false
            referencedRelation: "hubs"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "hub_messages_sender_id_fkey"
            columns: ["sender_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      hub_posts: {
        Row: {
          author_id: string | null
          author_label: string | null
          body: string
          created_at: string
          hub_id: string
          id: string
          kind: string
          pinned: boolean
          spoiler: boolean
          title: string
        }
        Insert: {
          author_id?: string | null
          author_label?: string | null
          body: string
          created_at?: string
          hub_id: string
          id?: string
          kind?: string
          pinned?: boolean
          spoiler?: boolean
          title: string
        }
        Update: {
          author_id?: string | null
          author_label?: string | null
          body?: string
          created_at?: string
          hub_id?: string
          id?: string
          kind?: string
          pinned?: boolean
          spoiler?: boolean
          title?: string
        }
        Relationships: [
          {
            foreignKeyName: "hub_posts_author_id_fkey"
            columns: ["author_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "hub_posts_hub_id_fkey"
            columns: ["hub_id"]
            isOneToOne: false
            referencedRelation: "hubs"
            referencedColumns: ["id"]
          },
        ]
      }
      hubs: {
        Row: {
          book_id: string | null
          created_at: string
          created_by: string | null
          description: string | null
          id: string
          name: string
          rules: string | null
          slug: string
          tags: string[]
          topic: string | null
          visibility: string
        }
        Insert: {
          book_id?: string | null
          created_at?: string
          created_by?: string | null
          description?: string | null
          id?: string
          name: string
          rules?: string | null
          slug: string
          tags?: string[]
          topic?: string | null
          visibility?: string
        }
        Update: {
          book_id?: string | null
          created_at?: string
          created_by?: string | null
          description?: string | null
          id?: string
          name?: string
          rules?: string | null
          slug?: string
          tags?: string[]
          topic?: string | null
          visibility?: string
        }
        Relationships: [
          {
            foreignKeyName: "hubs_book_id_fkey"
            columns: ["book_id"]
            isOneToOne: false
            referencedRelation: "books"
            referencedColumns: ["id"]
          },
        ]
      }
      library_entries: {
        Row: {
          book_id: string
          favorite: boolean
          id: string
          progress_chapter: number
          progress_pct: number
          shelf: string
          source: string
          updated_at: string
          user_id: string
        }
        Insert: {
          book_id: string
          favorite?: boolean
          id?: string
          progress_chapter?: number
          progress_pct?: number
          shelf?: string
          source: string
          updated_at?: string
          user_id: string
        }
        Update: {
          book_id?: string
          favorite?: boolean
          id?: string
          progress_chapter?: number
          progress_pct?: number
          shelf?: string
          source?: string
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "library_entries_book_id_fkey"
            columns: ["book_id"]
            isOneToOne: false
            referencedRelation: "books"
            referencedColumns: ["id"]
          },
        ]
      }
      notifications: {
        Row: {
          body: string
          created_at: string
          id: string
          kind: string
          link: string | null
          read: boolean
          user_id: string
        }
        Insert: {
          body: string
          created_at?: string
          id?: string
          kind: string
          link?: string | null
          read?: boolean
          user_id: string
        }
        Update: {
          body?: string
          created_at?: string
          id?: string
          kind?: string
          link?: string | null
          read?: boolean
          user_id?: string
        }
        Relationships: []
      }
      order_items: {
        Row: {
          book_id: string | null
          commission_bps: number
          format: string
          id: string
          order_id: string
          quantity: number
          title_snapshot: string
          unit_price_cents: number
        }
        Insert: {
          book_id?: string | null
          commission_bps: number
          format: string
          id?: string
          order_id: string
          quantity: number
          title_snapshot: string
          unit_price_cents: number
        }
        Update: {
          book_id?: string | null
          commission_bps?: number
          format?: string
          id?: string
          order_id?: string
          quantity?: number
          title_snapshot?: string
          unit_price_cents?: number
        }
        Relationships: [
          {
            foreignKeyName: "order_items_book_id_fkey"
            columns: ["book_id"]
            isOneToOne: false
            referencedRelation: "books"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "order_items_order_id_fkey"
            columns: ["order_id"]
            isOneToOne: false
            referencedRelation: "orders"
            referencedColumns: ["id"]
          },
        ]
      }
      orders: {
        Row: {
          created_at: string
          currency: string
          id: string
          idempotency_key: string | null
          is_sandbox: boolean
          shipping_address: Json | null
          shipping_cents: number
          status: string
          subtotal_cents: number
          total_cents: number
          user_id: string
        }
        Insert: {
          created_at?: string
          currency?: string
          id?: string
          idempotency_key?: string | null
          is_sandbox?: boolean
          shipping_address?: Json | null
          shipping_cents?: number
          status?: string
          subtotal_cents: number
          total_cents: number
          user_id: string
        }
        Update: {
          created_at?: string
          currency?: string
          id?: string
          idempotency_key?: string | null
          is_sandbox?: boolean
          shipping_address?: Json | null
          shipping_cents?: number
          status?: string
          subtotal_cents?: number
          total_cents?: number
          user_id?: string
        }
        Relationships: []
      }
      profiles: {
        Row: {
          avatar_url: string | null
          bio: string | null
          created_at: string
          display_name: string | null
          id: string
          username: string | null
        }
        Insert: {
          avatar_url?: string | null
          bio?: string | null
          created_at?: string
          display_name?: string | null
          id: string
          username?: string | null
        }
        Update: {
          avatar_url?: string | null
          bio?: string | null
          created_at?: string
          display_name?: string | null
          id?: string
          username?: string | null
        }
        Relationships: []
      }
      reports: {
        Row: {
          created_at: string
          id: string
          reason: string
          reporter_id: string
          resolution_note: string | null
          resolved_by: string | null
          status: string
          target_id: string
          target_type: string
        }
        Insert: {
          created_at?: string
          id?: string
          reason: string
          reporter_id: string
          resolution_note?: string | null
          resolved_by?: string | null
          status?: string
          target_id: string
          target_type: string
        }
        Update: {
          created_at?: string
          id?: string
          reason?: string
          reporter_id?: string
          resolution_note?: string | null
          resolved_by?: string | null
          status?: string
          target_id?: string
          target_type?: string
        }
        Relationships: []
      }
      reviews: {
        Row: {
          body: string | null
          book_id: string
          created_at: string
          id: string
          rating: number
          spoiler: boolean
          updated_at: string
          user_id: string
        }
        Insert: {
          body?: string | null
          book_id: string
          created_at?: string
          id?: string
          rating: number
          spoiler?: boolean
          updated_at?: string
          user_id: string
        }
        Update: {
          body?: string | null
          book_id?: string
          created_at?: string
          id?: string
          rating?: number
          spoiler?: boolean
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "reviews_book_id_fkey"
            columns: ["book_id"]
            isOneToOne: false
            referencedRelation: "books"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "reviews_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      story_collaborators: {
        Row: {
          accepted_terms_at: string
          project_id: string
          status: string
          user_id: string
        }
        Insert: {
          accepted_terms_at?: string
          project_id: string
          status?: string
          user_id: string
        }
        Update: {
          accepted_terms_at?: string
          project_id?: string
          status?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "story_collaborators_project_id_fkey"
            columns: ["project_id"]
            isOneToOne: false
            referencedRelation: "story_projects"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "story_collaborators_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      story_projects: {
        Row: {
          allow_cowriting: boolean
          allow_suggestions: boolean
          allow_voting: boolean
          base_text: string
          book_id: string
          brief: string
          contributor_terms: string
          created_at: string
          deadline: string | null
          focus: string | null
          id: string
          published_text: string | null
          status: string
          title: string
          visibility: string
        }
        Insert: {
          allow_cowriting?: boolean
          allow_suggestions?: boolean
          allow_voting?: boolean
          base_text?: string
          book_id: string
          brief: string
          contributor_terms?: string
          created_at?: string
          deadline?: string | null
          focus?: string | null
          id?: string
          published_text?: string | null
          status?: string
          title: string
          visibility?: string
        }
        Update: {
          allow_cowriting?: boolean
          allow_suggestions?: boolean
          allow_voting?: boolean
          base_text?: string
          book_id?: string
          brief?: string
          contributor_terms?: string
          created_at?: string
          deadline?: string | null
          focus?: string | null
          id?: string
          published_text?: string | null
          status?: string
          title?: string
          visibility?: string
        }
        Relationships: [
          {
            foreignKeyName: "story_projects_book_id_fkey"
            columns: ["book_id"]
            isOneToOne: false
            referencedRelation: "books"
            referencedColumns: ["id"]
          },
        ]
      }
      story_revisions: {
        Row: {
          content: string
          contributor_id: string | null
          created_at: string
          id: string
          project_id: string
          reviewed_at: string | null
          status: string
          summary: string
          version: number
        }
        Insert: {
          content: string
          contributor_id?: string | null
          created_at?: string
          id?: string
          project_id: string
          reviewed_at?: string | null
          status?: string
          summary: string
          version: number
        }
        Update: {
          content?: string
          contributor_id?: string | null
          created_at?: string
          id?: string
          project_id?: string
          reviewed_at?: string | null
          status?: string
          summary?: string
          version?: number
        }
        Relationships: [
          {
            foreignKeyName: "story_revisions_contributor_id_fkey"
            columns: ["contributor_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "story_revisions_project_id_fkey"
            columns: ["project_id"]
            isOneToOne: false
            referencedRelation: "story_projects"
            referencedColumns: ["id"]
          },
        ]
      }
      story_suggestions: {
        Row: {
          author_id: string | null
          author_label: string | null
          body: string
          created_at: string
          id: string
          kind: string
          project_id: string
          rationale: string | null
          status: string
        }
        Insert: {
          author_id?: string | null
          author_label?: string | null
          body: string
          created_at?: string
          id?: string
          kind: string
          project_id: string
          rationale?: string | null
          status?: string
        }
        Update: {
          author_id?: string | null
          author_label?: string | null
          body?: string
          created_at?: string
          id?: string
          kind?: string
          project_id?: string
          rationale?: string | null
          status?: string
        }
        Relationships: [
          {
            foreignKeyName: "story_suggestions_author_id_fkey"
            columns: ["author_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "story_suggestions_project_id_fkey"
            columns: ["project_id"]
            isOneToOne: false
            referencedRelation: "story_projects"
            referencedColumns: ["id"]
          },
        ]
      }
      story_votes: {
        Row: {
          created_at: string
          suggestion_id: string
          user_id: string
        }
        Insert: {
          created_at?: string
          suggestion_id: string
          user_id: string
        }
        Update: {
          created_at?: string
          suggestion_id?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "story_votes_suggestion_id_fkey"
            columns: ["suggestion_id"]
            isOneToOne: false
            referencedRelation: "story_suggestions"
            referencedColumns: ["id"]
          },
        ]
      }
      user_blocks: {
        Row: {
          blocked_id: string
          blocker_id: string
          created_at: string
        }
        Insert: {
          blocked_id: string
          blocker_id: string
          created_at?: string
        }
        Update: {
          blocked_id?: string
          blocker_id?: string
          created_at?: string
        }
        Relationships: []
      }
      user_roles: {
        Row: {
          id: string
          role: Database["public"]["Enums"]["app_role"]
          user_id: string
        }
        Insert: {
          id?: string
          role: Database["public"]["Enums"]["app_role"]
          user_id: string
        }
        Update: {
          id?: string
          role?: Database["public"]["Enums"]["app_role"]
          user_id?: string
        }
        Relationships: []
      }
      wishlist: {
        Row: {
          book_id: string
          created_at: string
          user_id: string
        }
        Insert: {
          book_id: string
          created_at?: string
          user_id: string
        }
        Update: {
          book_id?: string
          created_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "wishlist_book_id_fkey"
            columns: ["book_id"]
            isOneToOne: false
            referencedRelation: "books"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      book_ratings: {
        Row: {
          avg_rating: number | null
          book_id: string | null
          review_count: number | null
        }
        Relationships: [
          {
            foreignKeyName: "reviews_book_id_fkey"
            columns: ["book_id"]
            isOneToOne: false
            referencedRelation: "books"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Functions: {
      can_read_book: {
        Args: { _book: string; _user: string }
        Returns: boolean
      }
      can_view_hub: { Args: { _hub: string; _user: string }; Returns: boolean }
      has_role: {
        Args: {
          _role: Database["public"]["Enums"]["app_role"]
          _user_id: string
        }
        Returns: boolean
      }
      is_collaborator: { Args: { _p: string; _u: string }; Returns: boolean }
      is_hub_member: { Args: { _hub: string; _user: string }; Returns: boolean }
      is_hub_mod: { Args: { _hub: string; _user: string }; Returns: boolean }
      owns_book: { Args: { _book: string; _user: string }; Returns: boolean }
      owns_project: { Args: { _p: string; _u: string }; Returns: boolean }
    }
    Enums: {
      app_role: "reader" | "writer" | "moderator" | "admin"
      book_status:
        | "draft"
        | "published"
        | "unpublished"
        | "archived"
        | "under_review"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends (DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never) = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends (PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never) = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      app_role: ["reader", "writer", "moderator", "admin"],
      book_status: [
        "draft",
        "published",
        "unpublished",
        "archived",
        "under_review",
      ],
    },
  },
} as const
