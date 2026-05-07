-- Fix infinite recursion in RLS policies between classes and class_enrollments.
--
-- The cycle:
--   classes_student_select (on classes) queries class_enrollments with RLS
--   enrollments_teacher_select (on class_enrollments) queries classes with RLS
--   → infinite recursion
--
-- Fix: use SECURITY DEFINER functions for both cross-table checks.
-- SECURITY DEFINER runs as the function owner (postgres superuser), which
-- bypasses RLS on the queried table, breaking the cycle.

CREATE OR REPLACE FUNCTION public.is_teacher_of_class(p_class_id uuid)
RETURNS boolean
LANGUAGE sql SECURITY DEFINER STABLE SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.classes
    WHERE id = p_class_id AND teacher_id = auth.uid()
  );
$$;

CREATE OR REPLACE FUNCTION public.is_enrolled_in_class(p_class_id uuid)
RETURNS boolean
LANGUAGE sql SECURITY DEFINER STABLE SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.class_enrollments
    WHERE class_id = p_class_id AND student_id = auth.uid()
  );
$$;

-- Fix classes_student_select: use helper so it doesn't trigger class_enrollments RLS
DROP POLICY IF EXISTS "classes_student_select" ON public.classes;
CREATE POLICY "classes_student_select" ON public.classes
  FOR SELECT USING (public.is_enrolled_in_class(id));

-- Fix enrollments_teacher_select: use helper so it doesn't trigger classes RLS
DROP POLICY IF EXISTS "enrollments_teacher_select" ON public.class_enrollments;
CREATE POLICY "enrollments_teacher_select" ON public.class_enrollments
  FOR SELECT USING (public.is_teacher_of_class(class_id));

-- Fix enrollments_teacher_delete: same fix
DROP POLICY IF EXISTS "enrollments_teacher_delete" ON public.class_enrollments;
CREATE POLICY "enrollments_teacher_delete" ON public.class_enrollments
  FOR DELETE USING (public.is_teacher_of_class(class_id));

-- Allow any logged-in user to look up a class (needed so students can find a
-- class by code before they are enrolled in it).
DROP POLICY IF EXISTS "classes_any_auth_select" ON public.classes;
CREATE POLICY "classes_any_auth_select" ON public.classes
  FOR SELECT USING (auth.uid() IS NOT NULL);
