-- admerl memories: open board (no sign-in)
-- Run after setup.sql. Anyone who has the website link can view, add, move
-- and delete things. Share the link only with people you trust.

-- Items: anyone can add, change and delete.
drop policy if exists "Editors can add items"    on public.items;
drop policy if exists "Editors can change items" on public.items;
drop policy if exists "Editors can delete items" on public.items;
drop policy if exists "Anyone can add items"     on public.items;
drop policy if exists "Anyone can change items"  on public.items;
drop policy if exists "Anyone can delete items"  on public.items;

create policy "Anyone can add items"    on public.items for insert to anon, authenticated with check (true);
create policy "Anyone can change items" on public.items for update to anon, authenticated using (true) with check (true);
create policy "Anyone can delete items" on public.items for delete to anon, authenticated using (true);

-- Photos: anyone can upload and delete in the photos bucket.
drop policy if exists "Editors can upload photos" on storage.objects;
drop policy if exists "Editors can delete photos" on storage.objects;
drop policy if exists "Anyone can upload photos"  on storage.objects;
drop policy if exists "Anyone can delete photos"  on storage.objects;

create policy "Anyone can upload photos" on storage.objects for insert to anon, authenticated with check (bucket_id = 'photos');
create policy "Anyone can delete photos" on storage.objects for delete to anon, authenticated using (bucket_id = 'photos');

-- Keep uploads to images up to 20 MB.
update storage.buckets
set file_size_limit = 20971520,
    allowed_mime_types = array['image/jpeg','image/png','image/webp','image/gif']
where id = 'photos';
