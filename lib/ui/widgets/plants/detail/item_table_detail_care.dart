part of com.watered_plants_ota_labs.app.widgets;

class ItemTableDetailCare extends StatelessWidget {
  const ItemTableDetailCare({
    required this.label,
    required this.item,
    super.key,
  });

  final String label;
  final Widget item;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[Text(label), item],
    ),
  );
}
