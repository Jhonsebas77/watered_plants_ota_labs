part of com.watered_plants_ota_labs.app.widgets;

class AddPlantFloatingActionButton extends StatelessWidget {
  const AddPlantFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) => FloatingActionButton(
    onPressed: () {
      CustomNavigator().push(context, const PlantFormView());
    },
    tooltip: 'Agregar Planta',
    backgroundColor: BlueprintColors.primaryContainer,
    foregroundColor: BlueprintColors.onPrimaryFixed,
    elevation: 0,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    child: const Icon(Icons.add),
  );
}
