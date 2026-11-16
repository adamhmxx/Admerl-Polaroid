-- admerl memories: Supabase setup
-- Run this once in Supabase → SQL Editor → New query → Run.
-- Before running, replace the two emails at the bottom with the editors' emails.

-- 1. Who may edit the board -------------------------------------------------
create table if not exists public.board_editors (
  email text primary key
);
alter table public.board_editors enable row level security;
-- Nobody can read or change this list from the website; it's managed here in SQL.

create or replace function public.is_editor()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.board_editors
    where lower(email) = lower(coalesce(auth.jwt() ->> 'email', ''))
  );
$$;
grant execute on function public.is_editor() to anon, authenticated;

-- 2. Board items (polaroids, notes, pen strokes, chapters) -----------------
create table if not exists public.items (
  id         text primary key,
  data       jsonb not null,
  updated_at timestamptz not null default now()
);
alter table public.items enable row level security;

drop policy if exists "Anyone can view items"  on public.items;
drop policy if exists "Editors can add items"    on public.items;
drop policy if exists "Editors can change items" on public.items;
drop policy if exists "Editors can delete items" on public.items;

create policy "Anyone can view items"    on public.items for select using (true);
create policy "Editors can add items"    on public.items for insert to authenticated with check (public.is_editor());
create policy "Editors can change items" on public.items for update to authenticated using (public.is_editor()) with check (public.is_editor());
create policy "Editors can delete items" on public.items for delete to authenticated using (public.is_editor());

-- Live updates: changes from one device show up on the others right away.
do $$
begin
  alter publication supabase_realtime add table public.items;
exception when duplicate_object then null;
end $$;

-- 3. Photo storage ---------------------------------------------------------
insert into storage.buckets (id, name, public)
values ('photos', 'photos', true)
on conflict (id) do update set public = true;

drop policy if exists "Anyone can view photos"   on storage.objects;
drop policy if exists "Editors can upload photos" on storage.objects;
drop policy if exists "Editors can delete photos" on storage.objects;

create policy "Anyone can view photos"    on storage.objects for select using (bucket_id = 'photos');
create policy "Editors can upload photos" on storage.objects for insert to authenticated with check (bucket_id = 'photos' and public.is_editor());
create policy "Editors can delete photos" on storage.objects for delete to authenticated using (bucket_id = 'photos' and public.is_editor());

-- 4. The editors ------------------------------------------------------------
-- Replace these two emails, then run. To add or remove someone later, edit this
-- table in Supabase → Table Editor → board_editors.
insert into public.board_editors (email) values
  ('your-email@example.com'),
  ('partner-email@example.com')
on conflict do nothing;
