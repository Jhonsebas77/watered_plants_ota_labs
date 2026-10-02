part of com.watered_plants_ota_labs.app.widgets;

class InformationDetailCard extends StatelessWidget {
  const InformationDetailCard({required this.plant, super.key});

  final PlantModel plant;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const DetailSectionTitle(label: 'Información de la planta'),
          const SizedBox(height: 12),
          Text(plant.plantCare, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 16),
          LocationPlantChip(plantLocation: plant.plantLocation),
        ],
      ),
    ),
  );
}
