-- Gokul Before & After: shared storage setup
-- Run this once in Supabase: SQL Editor -> New query -> paste -> Run.

-- 1) The 5 image sets (images are stored inside the table, so no Storage bucket is needed)
create table if not exists public.sets (
  id          int primary key check (id between 0 and 4),
  before_img  text,
  before_name text,
  after_img   text,
  after_name  text,
  prompt      text default '',
  updated_at  timestamptz default now()
);
insert into public.sets (id) select generate_series(0, 4) on conflict do nothing;

-- Everyone can READ the sets. Nobody can write directly; writing goes through the functions below.
alter table public.sets enable row level security;
drop policy if exists "public read" on public.sets;
create policy "public read" on public.sets for select using (true);

-- 2) Admin login (kept on the server, never inside the website code)
create table if not exists public.admin_login (
  username text primary key,
  password text not null
);
alter table public.admin_login enable row level security;
revoke all on public.admin_login from anon, authenticated;

-- Change the password here any time and run this block again.
insert into public.admin_login (username, password) values ('Gokul', '2003')
on conflict (username) do update set password = excluded.password;

-- 3) Functions the website calls. Each one checks the username and password first.
create or replace function public.check_admin(p_user text, p_pw text)
returns boolean language sql security definer set search_path = public as $$
  select exists (select 1 from admin_login where username = p_user and password = p_pw);
$$;

create or replace function public.save_image(p_user text, p_pw text, p_id int, p_slot text, p_data text, p_name text)
returns void language plpgsql security definer set search_path = public as $$
begin
  if not exists (select 1 from admin_login where username = p_user and password = p_pw) then
    raise exception 'Wrong username or password';
  end if;
  if p_slot = 'before' then
    update sets set before_img = p_data, before_name = p_name, updated_at = now() where id = p_id;
  elsif p_slot = 'after' then
    update sets set after_img = p_data, after_name = p_name, updated_at = now() where id = p_id;
  else
    raise exception 'Bad slot';
  end if;
end $$;

create or replace function public.save_prompt(p_user text, p_pw text, p_id int, p_text text)
returns void language plpgsql security definer set search_path = public as $$
begin
  if not exists (select 1 from admin_login where username = p_user and password = p_pw) then
    raise exception 'Wrong username or password';
  end if;
  update sets set prompt = p_text, updated_at = now() where id = p_id;
end $$;

create or replace function public.swap_images(p_user text, p_pw text, p_id int)
returns void language plpgsql security definer set search_path = public as $$
begin
  if not exists (select 1 from admin_login where username = p_user and password = p_pw) then
    raise exception 'Wrong username or password';
  end if;
  update sets set
    before_img = after_img, before_name = after_name,
    after_img = before_img, after_name = before_name,
    updated_at = now()
  where id = p_id;
end $$;

grant execute on function public.check_admin(text, text) to anon, authenticated;
grant execute on function public.save_image(text, text, int, text, text, text) to anon, authenticated;
grant execute on function public.save_prompt(text, text, int, text) to anon, authenticated;
grant execute on function public.swap_images(text, text, int) to anon, authenticated;
