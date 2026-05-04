-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- TABLES (all created first, before any cross-referencing policies)
-- ============================================================

CREATE TABLE public.profiles (
  id          uuid        PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email       text        NOT NULL,
  full_name   text        NOT NULL DEFAULT '',
  role        text        NOT NULL CHECK (role IN ('teacher', 'student')),
  avatar_url  text,
  created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.classes (
  id          uuid        PRIMARY KEY DEFAULT uuid_generate_v4(),
  name        text        NOT NULL,
  code        text        NOT NULL UNIQUE,
  teacher_id  uuid        NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.class_enrollments (
  id          uuid        PRIMARY KEY DEFAULT uuid_generate_v4(),
  class_id    uuid        NOT NULL REFERENCES public.classes(id) ON DELETE CASCADE,
  student_id  uuid        NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  enrolled_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (class_id, student_id)
);

CREATE TABLE public.todo_lists (
  id          uuid        PRIMARY KEY DEFAULT uuid_generate_v4(),
  class_id    uuid        NOT NULL REFERENCES public.classes(id) ON DELETE CASCADE,
  teacher_id  uuid        NOT NULL REFERENCES public.profiles(id),
  title       text        NOT NULL,
  description text,
  due_date    timestamptz,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.todo_items (
  id          uuid        PRIMARY KEY DEFAULT uuid_generate_v4(),
  list_id     uuid        NOT NULL REFERENCES public.todo_lists(id) ON DELETE CASCADE,
  title       text        NOT NULL,
  description text,
  due_date    timestamptz,
  position    integer     NOT NULL DEFAULT 0,
  created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.todo_completions (
  id           uuid        PRIMARY KEY DEFAULT uuid_generate_v4(),
  item_id      uuid        NOT NULL REFERENCES public.todo_items(id) ON DELETE CASCADE,
  student_id   uuid        NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  completed_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (item_id, student_id)
);

-- ============================================================
-- FUNCTIONS & TRIGGERS
-- ============================================================

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, role)
  VALUES (
    new.id,
    new.email,
    COALESCE(new.raw_user_meta_data->>'full_name', ''),
    COALESCE(new.raw_user_meta_data->>'role', 'student')
  );
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS trigger AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER todo_lists_updated_at
  BEFORE UPDATE ON public.todo_lists
  FOR EACH ROW EXECUTE PROCEDURE public.update_updated_at();

-- ============================================================
-- ROW LEVEL SECURITY (enabled on all tables)
-- ============================================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.classes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.class_enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.todo_lists ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.todo_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.todo_completions ENABLE ROW LEVEL SECURITY;

-- profiles
CREATE POLICY "profiles_select" ON public.profiles
  FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY "profiles_insert_own" ON public.profiles
  FOR INSERT WITH CHECK (id = auth.uid());
CREATE POLICY "profiles_update_own" ON public.profiles
  FOR UPDATE USING (id = auth.uid());

-- classes
CREATE POLICY "classes_teacher_all" ON public.classes
  FOR ALL USING (teacher_id = auth.uid());
CREATE POLICY "classes_student_select" ON public.classes
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.class_enrollments e
      WHERE e.class_id = id AND e.student_id = auth.uid()
    )
  );

-- class_enrollments
CREATE POLICY "enrollments_teacher_select" ON public.class_enrollments
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.classes c
      WHERE c.id = class_id AND c.teacher_id = auth.uid()
    )
  );
CREATE POLICY "enrollments_student_own" ON public.class_enrollments
  FOR SELECT USING (student_id = auth.uid());
CREATE POLICY "enrollments_student_insert" ON public.class_enrollments
  FOR INSERT WITH CHECK (student_id = auth.uid());
CREATE POLICY "enrollments_teacher_delete" ON public.class_enrollments
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM public.classes c
      WHERE c.id = class_id AND c.teacher_id = auth.uid()
    )
  );

-- todo_lists
CREATE POLICY "todo_lists_teacher_all" ON public.todo_lists
  FOR ALL USING (teacher_id = auth.uid());
CREATE POLICY "todo_lists_student_select" ON public.todo_lists
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.class_enrollments e
      WHERE e.class_id = todo_lists.class_id AND e.student_id = auth.uid()
    )
  );

-- todo_items
CREATE POLICY "todo_items_teacher_all" ON public.todo_items
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM public.todo_lists l
      WHERE l.id = list_id AND l.teacher_id = auth.uid()
    )
  );
CREATE POLICY "todo_items_student_select" ON public.todo_items
  FOR SELECT USING (
    EXISTS (
      SELECT 1
      FROM public.todo_lists l
      JOIN public.class_enrollments e ON e.class_id = l.class_id
      WHERE l.id = list_id AND e.student_id = auth.uid()
    )
  );

-- todo_completions
CREATE POLICY "completions_student_own" ON public.todo_completions
  FOR ALL USING (student_id = auth.uid())
  WITH CHECK (student_id = auth.uid());
CREATE POLICY "completions_teacher_select" ON public.todo_completions
  FOR SELECT USING (
    EXISTS (
      SELECT 1
      FROM public.todo_items i
      JOIN public.todo_lists l ON l.id = i.list_id
      WHERE i.id = item_id AND l.teacher_id = auth.uid()
    )
  );

-- ============================================================
-- ENABLE REALTIME
-- ============================================================
ALTER PUBLICATION supabase_realtime ADD TABLE public.todo_lists;
ALTER PUBLICATION supabase_realtime ADD TABLE public.todo_items;
ALTER PUBLICATION supabase_realtime ADD TABLE public.todo_completions;
