-- TABLE courses
create table courses (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  code text not null unique,
  description text,
  created_at timestamptz not null default now()
);

-- TABLE resources
create table resources (
  id uuid primary key default gen_random_uuid(),
  course_id uuid not null references courses(id) on delete cascade,
  title text not null,
  type text not null check (type in ('pdf','link','video','doc')),
  url text not null,
  created_at timestamptz not null default now()
);

create index idx_resources_course_id on resources(course_id);

-- RLS
alter table courses enable row level security;
alter table resources enable row level security;

-- Lecture publique pour tout utilisateur authentifié
create policy "authenticated read courses"
on courses for select
to authenticated
using (true);

create policy "authenticated read resources"
on resources for select
to authenticated
using (true);

-- Pas d'insert/update/delete côté client (géré uniquement en dashboard/admin)

-- SEED DEMO
insert into courses (title, code, description) values
('Algorithmique', 'ALG101', 'Introduction aux algorithmes et structures de données'),
('Bases de données', 'BDD201', 'Modélisation relationnelle et SQL'),
('Réseaux', 'RES301', 'Fondamentaux des réseaux TCP/IP');

insert into resources (course_id, title, type, url)
select id, 'Cours PDF - Chapitre 1', 'pdf', 'https://example.com/alg101-ch1.pdf'
from courses where code = 'ALG101';

insert into resources (course_id, title, type, url)
select id, 'Slides Intro SQL', 'pdf', 'https://example.com/bdd201-slides.pdf'
from courses where code = 'BDD201';

insert into resources (course_id, title, type, url)
select id, 'Vidéo TCP/IP', 'video', 'https://example.com/res301-video.mp4'
from courses where code = 'RES301';