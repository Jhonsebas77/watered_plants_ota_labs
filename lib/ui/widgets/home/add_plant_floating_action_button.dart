part of com.watered_plants_ota_labs.app.widgets;

class AddPlantFloatingActionButton extends StatelessWidget {
  const AddPlantFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) => FloatingActionButton(
    onPressed: () {
      CustomNavigator().push(context, const PlantFormView());
    },
    tooltip: 'Agregar Planta',
    child:  const Icon(Icons.add_circle_outline),
  );
}
