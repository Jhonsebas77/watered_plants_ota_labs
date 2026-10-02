part of com.watered_plants_ota_labs.app.widgets;

/// Chip/etiqueta genérico de borde + texto de color, para indicadores de
/// estado cortos (tanque lleno, gasolina extra, día de hoy, restricción de
/// placa, etc.). Unifica lo que antes eran `FullTankBadge`, `ExtraFuelBadge`
/// y `_DayFlagChip`: visualmente son el mismo componente, solo cambian el
/// label, el color y (en el caso de `_DayFlagChip`) el relleno/esquinas.
class CustomBadge extends StatelessWidget {
  const CustomBadge({
    required this.label,
    required this.color,
    this.filled = false,
    this.borderRadius = 0,
    this.bold = false,
    super.key,
  });

  final String label;
  final Color color;

  /// `false` (default, look de `FullTankBadge`/`ExtraFuelBadge`): sin
  /// relleno, borde de [color] a opacidad completa.
  /// `true` (look de `_DayFlagChip`): relleno de [color] al 15% de opacidad,
  /// borde al 60%, y padding un poco más chico.
  final bool filled;

  /// Radio de las esquinas. `0` (default) = esquinas cuadradas, consistente
  /// con el resto del design system "Engineering Blueprint".
  final double borderRadius;

  /// Texto en negrita + letter-spacing extra (look de `_DayFlagChip`).
  final bool bold;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(
      horizontal: filled ? 6 : 8,
      vertical: filled ? 2 : 3,
    ),
    decoration: BoxDecoration(
      color: filled ? color.withValues(alpha: 0.15) : null,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: filled ? color.withValues(alpha: 0.6) : color),
    ),
    child: Text(
      label,
      style: AppTextStyles.labelSmall.copyWith(
        color: color,
        fontWeight: bold ? FontWeight.w700 : null,
        letterSpacing: bold ? 0.4 : null,
      ),
    ),
  );
}
