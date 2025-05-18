part of com.watered_plants_ota_labs.app.widgets;

class LocationPlantChip extends StatelessWidget {
  const LocationPlantChip({required this.plantLocation, super.key});
  final String plantLocation;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      const Divider(),
      Text('Ubicación', style: Paragraphs.smallSemiBold),
      Row(
        children: <Widget>[
          const Icon(Icons.location_on),
          const SizedBox(width: 4),
          Text(plantLocation),
        ],
      ),
    ],
  );
}
