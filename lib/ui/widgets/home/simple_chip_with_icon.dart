part of com.watered_plants_ota_labs.app.widgets;

class SimpleChipWithIcon extends StatelessWidget {
  const SimpleChipWithIcon({
    required this.text,
    required this.iconData,
    super.key,
  });

  final String text;
  final IconData iconData;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Icon(iconData, color: BlueprintColors.textDim, size: 13),
      const SizedBox(width: 4),
      Text(
        text,
        style: CustomStyles().customLabelTextStyle(size: 9, spacing: 0.5),
      ),
    ],
  );
}
