-- The Hustle Studio: one-time visual editor settings table
create table if not exists public.store_settings (
  id integer primary key default 1 check (id = 1),
  settings jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.store_settings enable row level security;

drop policy if exists "Public can read store settings" on public.store_settings;
create policy "Public can read store settings"
on public.store_settings for select
to anon, authenticated
using (true);

drop policy if exists "Admins manage store settings" on public.store_settings;
create policy "Admins manage store settings"
on public.store_settings for all
to authenticated
using (public.is_store_admin())
with check (public.is_store_admin());

grant select on public.store_settings to anon, authenticated;
grant insert, update, delete on public.store_settings to authenticated;

insert into public.store_settings (id, settings)
values (1, '{}'::jsonb)
on conflict (id) do nothing;


-- Public sample PDFs are stored as URLs on each product.
alter table public.products add column if not exists sample_pdf_url text;
