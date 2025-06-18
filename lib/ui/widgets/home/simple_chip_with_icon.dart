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
    children: <Widget>[
      Icon(iconData, color: Colors.grey[400], size: 14),
      const SizedBox(width: 4),
      Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[400],
          fontWeight: FontWeight.normal,
        ),
      ),
    ],
  );
}
