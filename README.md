git init# nail_finder_store

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

# Nail Finder Store (Flutter)

App Flutter para control de cuentas y acceso (login/registro/recuperación) con UI basada en imágenes hero + bottom sheets.

## Stack
- Flutter (stable)
- `go_router` para navegación
- Assets locales (`assets/ui/*`)

## Requisitos
- Flutter SDK instalado (`flutter --version`)
- Android SDK / Xcode según plataforma

## Configuración rápida
1. Declarar assets en `pubspec.yaml`:
   ```yaml
   flutter:
     uses-material-design: true
     assets:
       - assets/ui/

2. nstalar dependencias:
flutter pub get

3. Ejecutar:
flutter run -d <device>

4. Scripts útiles
flutter format . --set-exit-if-changed   # formato
flutter analyze                           # análisis estático
flutter test                              # tests

5. Estructura
lib/features/auth/presentation/*: pantallas de Login, Registro, Nueva contraseña
assets/ui/*: imágenes de fondo y logos
app_router.dart: rutas con go_router