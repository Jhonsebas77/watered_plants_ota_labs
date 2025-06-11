part of com.watered_plants_ota_labs.app.widgets;

class PlantImageAvatar extends StatelessWidget {
  const PlantImageAvatar({required this.plant, super.key});

  final PlantModel plant;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Image.network(
      plant.plantImage,
      width: 50,
      height: 50,
      fit: BoxFit.cover,
    ),
  );
}
