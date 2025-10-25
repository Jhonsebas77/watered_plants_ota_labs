part of com.watered_plants_ota_labs.app.views;

class HomePlantsView extends StatefulWidget {
  const HomePlantsView({super.key});

  @override
  State<HomePlantsView> createState() => _HomePlantsViewState();
}

class _HomePlantsViewState extends State<HomePlantsView> {
  PlantSortCriteria _currentSortCriteria = PlantSortCriteria.byNextWatering;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Consumer<FirebaseProvider>(
    builder: (BuildContext context, FirebaseProvider provider, Widget? child) {
      if (provider.isLoading) {
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
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
                  Center(
                    child: Text(
                      '''No plants added yet.\nTap the + button to add your first plant!''',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: HomeWeekCalendar(plants: provider.allPlants),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Mis plantas (${provider.allPlants.length})',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  PopupMenuButton<PlantSortCriteria>(
                    icon: const Icon(Icons.sort),
                    tooltip: 'Ordenar plantas',
                    onSelected: (PlantSortCriteria result) {
                      setState(() {
                        _currentSortCriteria = result;
                      });
                    },
                    itemBuilder:
                        (
                          BuildContext context,
                        ) => <PopupMenuEntry<PlantSortCriteria>>[
                          const PopupMenuItem<PlantSortCriteria>(
                            value: PlantSortCriteria.byName,
                            child: SimpleChipWithIcon(
                              iconData: Icons.sort_by_alpha,
                              text: 'Nombre',
                            ),
                          ),
                          const PopupMenuItem<PlantSortCriteria>(
                            value: PlantSortCriteria.byLocation,
                            child: SimpleChipWithIcon(
                              iconData: Icons.location_on,
                              text: 'Locación',
                            ),
                          ),
                          const PopupMenuItem<PlantSortCriteria>(
                            value: PlantSortCriteria.byNextWatering,
                            child: SimpleChipWithIcon(
                              iconData: Icons.calendar_month,
                              text: 'Fecha de siguiente riego',
                            ),
                          ),
                          const PopupMenuItem<PlantSortCriteria>(
                            value: PlantSortCriteria.byWateringFrequencyDays,
                            child: SimpleChipWithIcon(
                              iconData: Icons.water_drop_rounded,
                              text: 'Frecuencia de riego',
                            ),
                          ),
                        ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: TextField(
                  controller: _searchController,
                  maxLines: 1,
                  autofocus: false,
                  focusNode: FocusNode(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Buscar por el nombre de la planta',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontFamily: 'Quicksand',
                    ),
                    hintText: 'Ingresa el nombre de la planta...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon:
                        _searchQuery.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: _searchController.clear,
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Builder(
                builder: (BuildContext context) {
                  List<PlantModel> sortedPlants = provider.allPlants;
                  if (_searchQuery.isNotEmpty) {
                    sortedPlants =
                        sortedPlants.where((PlantModel plant) {
                          String plantName = plant.plantName.toLowerCase();
                          String query = _searchQuery.toLowerCase();
                          return plantName.contains(query);
                        }).toList();
                  }
                  switch (_currentSortCriteria) {
                    case PlantSortCriteria.byLocation:
                      sortedPlants.sort(
                        (PlantModel a, PlantModel b) => a.plantLocation
                            .toLowerCase()
                            .compareTo(b.plantLocation.toLowerCase()),
                      );
                      break;
                    case PlantSortCriteria.byNextWatering:
                      sortedPlants.sort(
                        (PlantModel a, PlantModel b) => a.nextWateringDate
                            .toLowerCase()
                            .compareTo(b.nextWateringDate.toLowerCase()),
                      );
                      break;
                    case PlantSortCriteria.byWateringFrequencyDays:
                      sortedPlants.sort(
                        (PlantModel a, PlantModel b) => a.wateringFrequencyDays
                            .compareTo(b.wateringFrequencyDays),
                      );
                      break;
                    default:
                      sortedPlants.sort(
                        (PlantModel a, PlantModel b) =>
                            a.plantName.compareTo(b.plantName),
                      );
                      break;
                  }
                  if (sortedPlants.isEmpty) {
                    return Center(
                      child: Text(
                        'No plants found for "$_searchQuery".',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: sortedPlants.length,
                    itemBuilder:
                        (BuildContext context, int index) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: BasicPlantCard(plant: sortedPlants[index]),
                        ),
                  );
                },
              ),
            ),
          ],
        );
      }
    },
  );
}
