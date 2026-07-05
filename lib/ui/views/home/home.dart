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

  Widget _buildLoadingState() => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: BlueprintColors.primaryContainer,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'LOADING_PLANT_DATA...',
          style: CustomStyles().customLabelTextStyle(size: 10, spacing: 2),
        ),
      ],
    ),
  );

  Widget _buildEmptyState() => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: BlueprintColors.surfaceContainerLow,
          border: Border.all(
            color: BlueprintColors.outline.withAlpha(40),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.eco_rounded,
              color: BlueprintColors.primaryContainer,
              size: 32,
            ),
            const SizedBox(height: 16),
            Text(
              'NO_PLANTS_REGISTERED',
              style: CustomStyles().customLabelTextStyle(
                color: BlueprintColors.primaryContainer,
                size: 11,
                spacing: 2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'TAP + TO ADD YOUR FIRST PLANT',
              style: CustomStyles().customLabelTextStyle(size: 9, spacing: 1),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildContent(FirebaseProvider provider) {
    List<PlantModel> sortedPlants = _getSortedPlants(provider.allPlants);
    return Column(
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
              : _buildPlantList(sortedPlants),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(int count) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
    child: Row(
      children: <Widget>[
        const Icon(
          Icons.eco_rounded,
          color: BlueprintColors.primaryContainer,
          size: 13,
        ),
        const SizedBox(width: 8),
        Text(
          'Mis plantas',
          style: CustomStyles().customLabelTextStyle(
            color: BlueprintColors.primaryContainer,
            size: 10,
            spacing: 2,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            border: Border.all(
              color: BlueprintColors.outline.withAlpha(60),
              width: 1,
            ),
          ),
          child: Text(
            '$count',
            style: CustomStyles().customLabelTextStyle(size: 9, spacing: 0.5),
          ),
        ),
        const Spacer(),
        PopupMenuButton<PlantSortCriteria>(
          tooltip: 'Ordenar plantas',
          color: BlueprintColors.surfaceContainerLow,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
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
                style: CustomStyles().customLabelTextStyle(
                  size: 9,
                  spacing: 1.5,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.unfold_more_rounded,
                size: 13,
                color: BlueprintColors.textDim,
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
        Icon(icon, size: 13, color: BlueprintColors.primaryContainer),
        const SizedBox(width: 8),
        Text(
          label,
          style: CustomStyles().customLabelTextStyle(
            color: _currentSortCriteria == value
                ? BlueprintColors.primaryContainer
                : BlueprintColors.textDim,
            size: 9,
            spacing: 1,
          ),
        ),
      ],
    ),
  );

  Widget _buildSearchField() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: TextField(
      controller: _searchController,
      maxLines: 1,
      autofocus: false,
      style: GoogleFonts.jetBrainsMono(
        color: BlueprintColors.textPrimary,
        fontSize: 12,
        letterSpacing: 1,
      ),
      decoration: InputDecoration(
        hintText:  'Buscar por el nombre de la planta',
        hintStyle: GoogleFonts.jetBrainsMono(
          color: BlueprintColors.textDim.withAlpha(120),
          fontSize: 11,
          letterSpacing: 1.5,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: BlueprintColors.textDim,
          size: 16,
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 44),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 14,
                  color: BlueprintColors.textDim,
                ),
                onPressed: _searchController.clear,
              )
            : null,
        filled: true,
        fillColor: BlueprintColors.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: BlueprintColors.outline.withAlpha(80),
            width: 1,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: BlueprintColors.primaryContainer,
            width: 1.5,
          ),
        ),
        border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
      ),
    ),
  );

  Widget _buildNoResultsState() => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(
          Icons.search_off_rounded,
          color: BlueprintColors.textDim,
          size: 28,
        ),
        const SizedBox(height: 12),
        Text(
          'NO_RESULTS_FOUND',
          style: CustomStyles().customLabelTextStyle(size: 10, spacing: 2),
        ),
        const SizedBox(height: 4),
        Text(
          '"$_searchQuery"',
          style: CustomStyles().customLabelTextStyle(
            color: BlueprintColors.primaryContainer,
            size: 9,
            spacing: 0.5,
          ),
        ),
      ],
    ),
  );

  Widget _buildPlantList(List<PlantModel> plants) => ListView.builder(
    padding: const EdgeInsets.only(top: 8, bottom: 16),
    itemCount: plants.length,
    itemBuilder: (BuildContext context, int index) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: BasicPlantCard(plant: plants[index]),
    ),
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
