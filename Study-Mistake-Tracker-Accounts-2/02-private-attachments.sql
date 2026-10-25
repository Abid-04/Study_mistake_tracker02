-- Run this in Supabase SQL Editor after the mistakes table setup.
-- This bucket is private; paths begin with the signed-in user's UUID.
begin;

insert into storage.buckets
  (id, name, public, file_size_limit, allowed_mime_types)
values (
  'mistake-attachments',
  'mistake-attachments',
  false,
  10485760,
  array[
    'image/jpeg', 'image/png', 'image/webp', 'image/gif',
    'audio/webm', 'audio/ogg', 'audio/mp4', 'audio/mpeg',
    'audio/wav', 'audio/x-wav', 'audio/aac', 'video/webm'
  ]
)
on conflict (id) do nothing;

-- Re-running this setup is safe; do not alter other storage policies.
do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'mistake_attachments_owner_access'
  ) then
    create policy "mistake_attachments_owner_access"
      on storage.objects
      for all
      to authenticated
      using (
        bucket_id = 'mistake-attachments'
        and (storage.foldername(name))[1] = (select auth.uid())::text
      )
      with check (
        bucket_id = 'mistake-attachments'
        and (storage.foldername(name))[1] = (select auth.uid())::text
      );
  end if;
end $$;

commit;
