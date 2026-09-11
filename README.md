# StudyHub

Application mobile Flutter de partage de ressources universitaires (cours, documents, vidéos), développée avec Clean Architecture, Riverpod, Dio et Supabase.

## Fonctionnalités

- Authentification (register / login / logout) via Supabase Auth
- Liste et détail des cours
- Liste des ressources par cours (PDF, vidéo, lien, document)
- Recherche/filtrage des cours par titre ou code
- Favoris sur les ressources (stockage local)
- Mode hors ligne avec fallback sur cache local (Hive)
- Gestion d'erreurs réseau avec retry

## Stack technique

| Domaine | Techno |
|---|---|
| Framework | Flutter 3.47 |
| State management | Riverpod (manuel, sans codegen) |
| HTTP client | Dio (appels REST vers Supabase PostgREST) |
| Auth & session | Supabase Auth (JWT géré automatiquement) |
| Backend | Supabase (PostgreSQL + PostgREST) |
| Cache local | Hive |
| Tests | flutter_test + mocktail |
| CI | GitHub Actions |

## Architecture

Clean Architecture en Feature-First, 3 couches par feature :

```
presentation → domain ← data
```

- **domain** : entités, interfaces repository, use cases. Aucune dépendance Flutter/Dio/Supabase.
- **data** : modèles (Hive), datasources (remote via Dio, local via Hive), implémentations repository.
- **presentation** : écrans Flutter + providers Riverpod.

```
lib/
├── core/
│   ├── config/       # config Supabase
│   ├── network/      # Dio client, interceptor auth, connectivité
│   ├── error/        # Failure + mapping des exceptions Dio
│   ├── cache/        # init Hive
│   └── widgets/       # widgets partagés (ErrorView)
├── features/
│   ├── auth/
│   ├── courses/
│   └── resources/
└── main.dart
```

### Flux de données (online)

```
UI → Riverpod → UseCase → Repository (interface)
   → RepositoryImpl → RemoteDataSource (Dio) → Supabase REST → PostgreSQL
   → cache mis à jour dans Hive au passage
```

### Flux de données (offline)

```
UI → Riverpod → UseCase → Repository → RepositoryImpl
   → DioException catché → LocalDataSource (Hive) → données en cache retournées
   → si aucun cache : Failure claire remontée à l'UI
```

## Authentification & sécurité

- Le JWT Supabase est injecté automatiquement dans chaque requête Dio via un interceptor (`Authorization: Bearer <token>`).
- Le refresh de session est géré nativement par le SDK `supabase_flutter`, pas de réimplémentation manuelle.
- Les données `courses`/`resources` sont protégées par Row Level Security (RLS) : lecture réservée aux utilisateurs authentifiés (`to authenticated`).
- Seule la clé publique (`anon`/`publishable`) est utilisée côté client — jamais la `service_role`.

## Configuration Supabase

1. Créer un projet sur [supabase.com](https://supabase.com).
2. Exécuter le script SQL fourni dans `supabase/schema.sql` (tables `courses`/`resources`, RLS, seed).
3. Récupérer `Project URL` et clé `anon`/`publishable` depuis **Project Settings → API**.
4. Renseigner ces valeurs dans `lib/core/config/supabase_config.dart`.

## Écrans de l'application (data-driven)

| Écran | Source de données |
|---|---|
| LoginScreen | Supabase Auth (signInWithPassword) |
| RegisterScreen | Supabase Auth (signUp) |
| CourseListScreen | REST API via Dio → table `courses` |
| CourseDetailScreen | REST API via Dio → `courses` + `resources` |

## Gestion du JWT et de la session

- Supabase Auth émet un JWT à la connexion/inscription, stocké et géré par `supabase_flutter`.
- Le refresh du token avant expiration est **entièrement géré par le SDK Supabase** (aucune réimplémentation manuelle nécessaire ni recommandée).
- À chaque appel Dio, l'interceptor (`lib/core/network/dio_client.dart`) lit `Supabase.instance.client.auth.currentSession?.accessToken` et l'injecte en header `Authorization: Bearer <token>`.
- Les tables `courses`/`resources` sont protégées par RLS (`to authenticated`) : sans JWT valide, l'API REST renvoie un résultat vide ou une erreur 401/403.

## Tests

9 tests unitaires sur la couche repository :
- `test/repositories/auth_repository_impl_test.dart` (3 tests)
- `test/repositories/course_repository_impl_test.dart` (3 tests)
- `test/repositories/resource_repository_impl_test.dart` (3 tests)

Scénarios couverts : succès + mise en cache, fallback offline avec cache, fallback offline sans cache (erreur typée).

## Lancer le projet

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Tests

```bash
flutter test
```

9 tests unitaires couvrent les repositories `auth` , `courses` et `resources` : succès + cache, fallback offline avec cache, fallback offline sans cache (erreur).

## CI

GitHub Actions (`.github/workflows/ci.yml`) exécute à chaque push/PR sur `main` :
- `dart format` (formatage)
- `flutter analyze` (lints statiques)
- `flutter test` (tests unitaires)

## Limitations connues

- Pas de pagination sur la liste des cours (hors scope pédagogique).
- Favoris non synchronisés entre appareils (stockage local uniquement).
- Pas de gestion de rôles (admin/étudiant) — lecture seule pour tous les utilisateurs authentifiés.