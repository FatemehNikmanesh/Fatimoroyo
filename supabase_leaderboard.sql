-- جدول امتیازها برای بازی «دخترک ماجراجو»
create table if not exists public.leaderboard (
  id bigint generated always as identity primary key,
  player_name text not null check (char_length(player_name) between 1 and 20),
  score integer not null check (score >= 0 and score <= 2000),
  level_reached integer not null default 1 check (level_reached between 1 and 3),
  created_at timestamptz not null default now()
);

alter table public.leaderboard enable row level security;

-- همه می‌توانند جدول امتیازها را بخوانند
create policy "Public can read leaderboard"
  on public.leaderboard for select
  to anon
  using (true);

-- همه می‌توانند امتیاز خودشان را ثبت کنند (فقط insert، بدون امکان ویرایش/حذف امتیاز دیگران)
create policy "Public can insert score"
  on public.leaderboard for insert
  to anon
  with check (
    char_length(player_name) between 1 and 20
    and score >= 0 and score <= 2000
  );

create index if not exists leaderboard_score_idx on public.leaderboard (score desc);
