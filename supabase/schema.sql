-- Esquema de las encuestas de la web (ya aplicado en el proyecto Supabase "web-francisco-recaite").
-- Solo hace falta volver a ejecutarlo si se crea un proyecto nuevo.

create table public.encuesta_respuestas (
  id bigint generated always as identity primary key,
  slug text not null check (slug ~ '^[a-z0-9-]{3,60}$'),
  respondent uuid not null,
  answers smallint[] not null check (array_length(answers,1) = 3 and 0 <= all(answers) and 5 > all(answers)),
  created_at timestamptz not null default now()
);
create index encuesta_respuestas_slug_resp_idx on public.encuesta_respuestas (slug, respondent, created_at desc);
alter table public.encuesta_respuestas enable row level security;
create policy "cualquiera puede responder" on public.encuesta_respuestas for insert to anon, authenticated with check (true);

create table public.encuesta_notas (
  id bigint generated always as identity primary key,
  slug text not null check (slug ~ '^[a-z0-9-]{3,60}$'),
  respondent uuid not null,
  texto text not null check (char_length(texto) between 1 and 600),
  created_at timestamptz not null default now()
);
alter table public.encuesta_notas enable row level security;
create policy "cualquiera puede comentar" on public.encuesta_notas for insert to anon, authenticated with check (true);

-- Devuelve solo totales por pregunta (cuenta la última respuesta de cada persona).
create or replace function public.encuesta_resultados(p_slug text)
returns jsonb language sql stable security definer set search_path = public as $$
  with latest as (
    select distinct on (respondent) answers from public.encuesta_respuestas
    where slug = p_slug order by respondent, created_at desc, id desc
  ),
  grid as (
    select qi, o, (select count(*) from latest l where l.answers[qi] = o) as c
    from generate_series(1,3) qi, generate_series(0,4) o
  ),
  per_q as (select qi, jsonb_agg(c order by o) as q from grid group by qi)
  select jsonb_build_object('n', (select count(*) from latest),
    'counts', coalesce((select jsonb_agg(q order by qi) from per_q), '[]'::jsonb));
$$;
revoke execute on function public.encuesta_resultados(text) from public;
grant execute on function public.encuesta_resultados(text) to anon, authenticated;
