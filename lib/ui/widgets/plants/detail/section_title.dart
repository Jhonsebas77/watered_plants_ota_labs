part of com.watered_plants_ota_labs.app.widgets;

/// Encabezado de sección de las tarjetas de detalle: label HUD naranja +
/// divider que completa el ancho.
class DetailSectionTitle extends StatelessWidget {
  const DetailSectionTitle({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      Text(
        label.toUpperCase(),
        style: AppTextStyles.label(
          color: BlueprintColors.accentOrange,
          size: 11,
          spacing: 2,
          weight: FontWeight.w700,
        ),
      ),
      const SizedBox(width: 12),
      const Expanded(
        child: CustomDivider(
          color: BlueprintColors.outlineVariant,
          isDash: true,
        ),
      ),
    ],
  );
}
