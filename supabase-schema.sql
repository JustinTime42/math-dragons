-- Math Dragons Landing Page - Supabase Schema
-- Run this in the Supabase SQL Editor to create the required tables

-- Email signups for testing track access
create table if not exists email_signups (
  id uuid default gen_random_uuid() primary key,
  email text not null,
  created_at timestamptz default now() not null
);

-- Add unique constraint so duplicate emails get a friendly error
alter table email_signups add constraint email_signups_email_unique unique (email);

-- General feedback form submissions
create table if not exists feedback (
  id uuid default gen_random_uuid() primary key,
  name text,
  email text not null,
  message text not null,
  created_at timestamptz default now() not null
);

-- Row Level Security: allow anonymous inserts only, no reads
alter table email_signups enable row level security;
alter table feedback enable row level security;

create policy "Allow anonymous inserts" on email_signups
  for insert with check (true);

create policy "Allow anonymous inserts" on feedback
  for insert with check (true);
