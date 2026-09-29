part of com.watered_plants_ota_labs.app.theme;

/// Clase de tamaño de ventana para el layout adaptativo (web/tablet/móvil).
enum WindowSize {
  /// Móvil: bottom nav bar + contenido a una columna.
  compact,

  /// Tablet / ventana angosta: riel lateral compacto + top app bar.
  medium,

  /// Escritorio: sidebar completo (logo, labels, ajustes) sin top app bar.
  expanded,
}

/// Breakpoints y anchos máximos del layout adaptativo. Valores alineados con
/// las pantallas desktop del proyecto de Stitch "Panel Vehicular Colombia".
class Breakpoints {
  Breakpoints._();

  /// Ancho desde el cual se usa [WindowSize.medium].
  static const double medium = 600;

  /// Ancho desde el cual se usa [WindowSize.expanded].
  static const double expanded = 1024;

  /// Ancho máximo de los inputs/columna de los formularios.
  static const double formMaxWidth = 500;

  /// Ancho máximo del área de contenido de los tabs en web.
  static const double contentMaxWidth = 1280;

  /// Umbral desde el cual el layout se trata como escritorio (home de
  /// plantas).
  static const double desktop = 1200;

  /// Ancho cómodo de lectura para formularios y pantallas de detalle.
  static const double content = 720;

  /// Ancho máximo del formulario de login.
  static const double compact = 420;

  /// Ancho mínimo de una tarjeta de planta dentro del grid responsive.
  static const double plantCardMinWidth = 340;

  static WindowSize windowSizeOf(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    if (width >= expanded) return WindowSize.expanded;
    if (width >= medium) return WindowSize.medium;
    return WindowSize.compact;
  }
}
