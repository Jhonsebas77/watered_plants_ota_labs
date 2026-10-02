[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/Jhonsebas77/watered_plants_ota_labs)

# watered_plants_ota_labs

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Configuration

Credentials are passed at build time with `--dart-define`. They are never
committed.

```bash
cp config/dart_defines.example.json config/dart_defines.local.json
# then edit config/dart_defines.local.json
```

| Key | Description |
| --- | --- |
| `SUPABASE_URL` | Project URL (`https://<ref>.supabase.co`) |
| `SUPABASE_PUBLISHABLE_KEY` | Publishable (anon) key |
| `AUTH_EMAIL` | Email used to sign in |
| `FIREBASE_DATABASE_URL` | Realtime Database URL (`https://<project>-default-rtdb.firebaseio.com/watered_plants`) |

`config/dart_defines.local.json` is gitignored. The app throws a
`StateError` at startup if any key is missing.

## Running

```bash
flutter pub get
flutter run --dart-define-from-file=config/dart_defines.local.json
```

### Building

```bash
flutter build apk --dart-define-from-file=config/dart_defines.local.json
flutter build ipa --dart-define-from-file=config/dart_defines.local.json
```

To Update splash image
`dart run flutter_native_splash:create`