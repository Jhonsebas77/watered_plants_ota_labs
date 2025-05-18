part of com.watered_plants_ota_labs.app.widgets;

class PlantAvatar extends StatelessWidget {
  const PlantAvatar({
    required this.plantColorString,
    required this.plantIconString,
    super.key,
  });
  final String plantColorString;
  final String plantIconString;

  @override
  Widget build(BuildContext context) => Padding(
    key: Key('plant_avatar_$plantColorString\_$plantIconString'),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: CircleAvatar(
      backgroundColor: getColorFromString(plantColorString),
      foregroundColor: Colors.black,
      child: Icon(getIconDataFromString(plantIconString)),
    ),
  );
}
