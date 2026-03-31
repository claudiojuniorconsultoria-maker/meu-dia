-- ================================================
--  MEU DIA — Execute este SQL no Supabase
--  Menu lateral: SQL Editor → New query → Cole aqui → Run
-- ================================================

-- 1. Tabela de tarefas
create table if not exists public.tasks (
  id         bigserial primary key,
  user_id    uuid references auth.users(id) on delete cascade not null,
  emoji      text not null default '⭐',
  label      text not null,
  time       text not null,
  color      text not null default '#60A5FA',
  created_at timestamptz default now()
);

-- 2. Tabela de itens concluídos por dia
create table if not exists public.done_items (
  id         bigserial primary key,
  user_id    uuid references auth.users(id) on delete cascade not null,
  task_id    bigint references public.tasks(id) on delete cascade not null,
  done_date  date not null default current_date,
  created_at timestamptz default now(),
  unique(task_id, done_date)
);

-- 3. Ativar segurança por linha (RLS)
alter table public.tasks      enable row level security;
alter table public.done_items enable row level security;

-- 4. Políticas para tasks
create policy "Ver próprias tarefas"    on public.tasks for select using (auth.uid() = user_id);
create policy "Criar próprias tarefas"  on public.tasks for insert with check (auth.uid() = user_id);
create policy "Editar próprias tarefas" on public.tasks for update using (auth.uid() = user_id);
create policy "Apagar próprias tarefas" on public.tasks for delete using (auth.uid() = user_id);

-- 5. Políticas para done_items
create policy "Ver próprios itens"    on public.done_items for select using (auth.uid() = user_id);
create policy "Criar próprios itens"  on public.done_items for insert with check (auth.uid() = user_id);
create policy "Apagar próprios itens" on public.done_items for delete using (auth.uid() = user_id);
