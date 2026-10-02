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
        return _buildLoadingState();
      } else if (provider.allPlants.isEmpty) {
        return _buildEmptyState();
      }
      return _buildContent(provider);
    },
  );

  Widget _buildLoadingState() => const PlantListSkeleton();

  Widget _buildEmptyState() => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: BlueprintColors.surfaceContainerLow,
          border: Border.all(color: BlueprintColors.outlineVariant, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.eco_rounded,
              color: BlueprintColors.accentOrange,
              size: 32,
            ),
            const SizedBox(height: 16),
            Text(
              'NO_PLANTS_REGISTERED',
              style: AppTextStyles.label(
                color: BlueprintColors.accentOrange,
                size: 11,
                spacing: 2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'TAP + TO ADD YOUR FIRST PLANT',
              style: AppTextStyles.label(size: 9, spacing: 1),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildContent(FirebaseProvider provider) {
    List<PlantModel> sortedPlants = _getSortedPlants(provider.allPlants);
    return ResponsiveContainer(
      maxWidth: Breakpoints.desktop,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: HomeWeekCalendar(plants: provider.allPlants),
          ),
          _buildSectionHeader(provider.allPlants.length),
          _buildSearchField(),
          Expanded(
            child: sortedPlants.isEmpty
                ? _buildNoResultsState()
                : _buildPlantGrid(sortedPlants),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(int count) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
    child: Row(
      children: <Widget>[
        const Icon(
          Icons.eco_rounded,
          color: BlueprintColors.accentOrange,
          size: 13,
        ),
        const SizedBox(width: 8),
        Text(
          'Mis plantas',
          style: AppTextStyles.label(
            color: BlueprintColors.accentOrange,
            size: 10,
            spacing: 2,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            border: Border.all(color: BlueprintColors.outlineVariant, width: 1),
          ),
          child: Text(
            '$count',
            style: AppTextStyles.label(size: 9, spacing: 0.5),
          ),
        ),
        const Spacer(),
        PopupMenuButton<PlantSortCriteria>(
          tooltip: 'Ordenar plantas',
          onSelected: (PlantSortCriteria result) {
            setState(() {
              _currentSortCriteria = result;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'ORDENAR',
                style: AppTextStyles.label(size: 9, spacing: 1.5),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.unfold_more_rounded,
                size: 13,
                color: BlueprintColors.textMuted,
              ),
            ],
          ),
          itemBuilder: (BuildContext context) =>
              <PopupMenuEntry<PlantSortCriteria>>[
                _buildSortItem(
                  PlantSortCriteria.byName,
                  Icons.sort_by_alpha,
                  'Nombre',
                ),
                _buildSortItem(
                  PlantSortCriteria.byLocation,
                  Icons.location_on,
                  'Locación',
                ),
                _buildSortItem(
                  PlantSortCriteria.byNextWatering,
                  Icons.calendar_month,
                  'Fecha de siguiente riego',
                ),
                _buildSortItem(
                  PlantSortCriteria.byWateringFrequencyDays,
                  Icons.water_drop_rounded,
                  'Frecuencia de riego',
                ),
              ],
        ),
      ],
    ),
  );

  PopupMenuItem<PlantSortCriteria> _buildSortItem(
    PlantSortCriteria value,
    IconData icon,
    String label,
  ) => PopupMenuItem<PlantSortCriteria>(
    value: value,
    child: Row(
      children: <Widget>[
        Icon(icon, size: 13, color: BlueprintColors.accentOrange),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.label(
            color: _currentSortCriteria == value
                ? BlueprintColors.accentOrange
                : BlueprintColors.textMuted,
            size: 9,
            spacing: 1,
          ),
        ),
      ],
    ),
  );

  Widget _buildSearchField() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: BlueprintTextField(
      label: 'Buscar planta',
      controller: _searchController,
      textInputAction: TextInputAction.search,
      suffixIcon: _searchQuery.isNotEmpty
          ? IconButton(
              tooltip: 'Limpiar búsqueda',
              icon: const Icon(Icons.close, color: BlueprintColors.textMuted),
              onPressed: _searchController.clear,
            )
          : const Icon(Icons.search, color: BlueprintColors.textMuted),
    ),
  );

  Widget _buildNoResultsState() => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(
          Icons.search_off_rounded,
          color: BlueprintColors.textMuted,
          size: 28,
        ),
        const SizedBox(height: 12),
        Text(
          'NO_RESULTS_FOUND',
          style: AppTextStyles.label(size: 10, spacing: 2),
        ),
        const SizedBox(height: 4),
        Text(
          '"$_searchQuery"',
          style: AppTextStyles.label(
            color: BlueprintColors.accentOrange,
            size: 9,
            spacing: 0.5,
          ),
        ),
      ],
    ),
  );

  Widget _buildPlantGrid(List<PlantModel> plants) => LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      // Discount the horizontal padding before deciding how many columns fit.
      double available = constraints.maxWidth - 32;
      int crossAxisCount = (available / Breakpoints.plantCardMinWidth)
          .floor()
          .clamp(1, 4);
      // A single column keeps the original full-width list feel on phones.
      if (crossAxisCount == 1) {
        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          itemCount: plants.length,
          itemBuilder: (BuildContext context, int index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: BasicPlantCard(plant: plants[index]),
          ),
        );
      }
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisExtent: 86,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: plants.length,
        itemBuilder: (BuildContext context, int index) =>
            BasicPlantCard(plant: plants[index]),
      );
    },
  );

  List<PlantModel> _getSortedPlants(List<PlantModel> plants) {
    List<PlantModel> result = plants.toList();
    if (_searchQuery.isNotEmpty) {
      result = result
          .where(
            (PlantModel plant) => plant.plantName.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ),
          )
          .toList();
    }
    switch (_currentSortCriteria) {
      case PlantSortCriteria.byLocation:
        result.sort(
          (PlantModel a, PlantModel b) => a.plantLocation
              .toLowerCase()
              .compareTo(b.plantLocation.toLowerCase()),
        );
        break;
      case PlantSortCriteria.byNextWatering:
        result.sort(
          (PlantModel a, PlantModel b) => a.nextWateringDate
              .toLowerCase()
              .compareTo(b.nextWateringDate.toLowerCase()),
        );
        break;
      case PlantSortCriteria.byWateringFrequencyDays:
        result.sort(
          (PlantModel a, PlantModel b) =>
              a.wateringFrequencyDays.compareTo(b.wateringFrequencyDays),
        );
        break;
      default:
        result.sort(
          (PlantModel a, PlantModel b) => a.plantName.compareTo(b.plantName),
        );
        break;
    }
    return result;
  }
}
