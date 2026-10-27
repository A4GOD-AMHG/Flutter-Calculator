# Flutter Calculator

Calculadora básica desarrollada en Flutter por **Alexis Manuel Hurtado Garcia**. Evalúa expresiones completas con paréntesis, porcentajes y decimales, muestra el resultado en tiempo real mientras escribes y permite alternar entre modo claro y oscuro, recordando tu preferencia.

## Tech Stack

<div style="display: flex; align-items: center;">
  <img src="https://raw.githubusercontent.com/A4GOD-AMHG/Utils-for-repos/refs/heads/main/icons/dart/dart-original.svg" alt="dart" width="65" height="65" />
  <img src="https://raw.githubusercontent.com/A4GOD-AMHG/Utils-for-repos/refs/heads/main/icons/flutter/flutter-original.svg" alt="flutter" width="65" height="65" />
</div>

## Características

- **Operaciones básicas**: suma, resta, multiplicación y división con precedencia correcta.
- **Paréntesis inteligentes**: un solo botón `( )` abre o cierra según el contexto; los paréntesis sin cerrar se cierran solos al calcular.
- **Porcentaje**: `50%` = 0.5 y `10%50` = 5 (el 10 % de 50).
- **Decimales sin ruido**: `0.1 + 0.2` da `0.3`, y no se permite escribir `1.2.3`.
- **Operaciones encadenadas**: tras `=` puedes seguir operando con el resultado o empezar otra cuenta tecleando un número.
- **Errores claros**: aviso de división entre 0 o expresión incompleta en lugar de fallar en silencio.
- **Resultado en vivo**: vista previa del resultado mientras escribes.
- **Edición con cursor**: inserta o borra en cualquier posición de la expresión.
- **Modo claro / oscuro**: tema Material 3 que se guarda con Shared Preferences.
- **Diseño adaptable**: el teclado se ajusta al alto disponible y se limita el ancho en tablet/escritorio.

## Dependencias

### Dependencias Principales

- `provider`: gestión de estado de la calculadora y del tema.
- `shared_preferences`: persistencia del modo claro/oscuro.
- `cupertino_icons`: iconos estilo iOS.

### Dependencias de Desarrollo

- `flutter_test`: tests unitarios del motor de cálculo y test de widgets.
- `flutter_lints`: reglas de análisis estático recomendadas.
- `flutter_launcher_icons`: generación del icono de la app.

## Cómo usar

1. Clona el repositorio:

   ```bash
   git clone https://github.com/A4GOD-AMHG/Flutter-Calculator.git
   cd Flutter-Calculator
   ```

2. Instala las dependencias (requiere Flutter con Dart 3.8 o superior):

   ```bash
   flutter pub get
   ```

3. Ejecuta la app:

   ```bash
   flutter run
   ```

4. Ejecuta los tests:

   ```bash
   flutter test
   ```

5. Genera el APK de release:

   ```bash
   flutter build apk --release
   ```

   Para regenerar el icono tras cambiar `assets/icon/icon.png`: `dart run flutter_launcher_icons`.

No necesita variables de entorno.

## Estructura del Proyecto

```
Flutter-Calculator/
├── assets/icon/icon.png           # Icono de la app
├── lib/
│   ├── main.dart                  # Arranque: preferencias y providers
│   ├── app.dart                   # MaterialApp con tema claro/oscuro
│   ├── logic/
│   │   └── calculator.dart        # Motor de cálculo puro (parser, formato, reglas de entrada)
│   ├── providers/
│   │   ├── calc_provider.dart     # Estado de la pantalla: texto, cursor, resultado y errores
│   │   └── theme_provider.dart    # Modo claro/oscuro persistido
│   ├── screens/
│   │   └── calc_screen.dart       # Pantalla principal
│   ├── shared_preferences/
│   │   └── shared_preferences.dart # Acceso a Shared Preferences
│   ├── theme/
│   │   └── app_theme.dart         # Paleta y temas Material 3
│   └── widgets/
│       ├── create_button.dart     # Botón del teclado
│       ├── grid_view_buttons.dart # Teclado adaptable
│       └── header.dart            # Pantalla de la expresión, vista previa y menú
├── test/
│   ├── calculator_test.dart       # Tests del motor de cálculo
│   └── widget_test.dart           # Test de la interfaz
├── screenshots/                   # Capturas para el README
└── pubspec.yaml
```

## Capturas de Pantalla

<div align="center" style="display: flex; justify-content: center; flex-wrap: wrap;">
  <img src="./screenshots/ScreenshotDarkMode.jpg" style="width: 250px; margin: 10px;"/>
  <img src="./screenshots/ScreenshotLightMode.jpg" style="width: 250px; margin: 10px;"/>
</div>

## Licencia

Este proyecto es de código abierto y está disponible para uso educativo y personal.

## Autor

**Alexis Manuel Hurtado Garcia** - [GitHub](https://github.com/A4GOD-AMHG)
