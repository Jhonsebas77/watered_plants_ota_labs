part of com.watered_plants_ota_labs.app.views;

class HomePlantsView extends StatelessWidget {
  const HomePlantsView({super.key});

  @override
  Widget build(BuildContext context) => Consumer<FirebaseProvider>(
    builder: (BuildContext context, FirebaseProvider provider, Widget? child) {
      if (provider.isLoading) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.deepOrangeAccent),
        );
      } else if (provider.allPlants.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(8),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.error_outline_rounded),
                  SizedBox(width: 8),
                  Text('No hay nada'),
                ],
              ),
            ),
          ),
        );
      } else {
        return ListView.builder(
          itemCount: provider.allPlants.length,
          itemBuilder:
              (BuildContext context, int index) =>
                  BasicPlantCard(plant: provider.allPlants[index]),
        );
      }
    },
  );
}
