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

  /// Día tocado en el calendario; filtra la lista a las plantas que tocan
  /// (o se regaron) ese día. `null` = sin filtro.
  DateTime? _selectedDay;

  static final DateFormat _selectedDayFormat = DateFormat('EEE dd/MM', 'es');

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
                size: 13,
                spacing: 2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'TOCA + PARA AGREGAR TU PRIMERA PLANTA',
              textAlign: TextAlign.center,
              style: AppTextStyles.label(size: 11, spacing: 1),
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
            child: HomeWeekCalendar(
              plants: provider.allPlants,
              selectedDay: _selectedDay,
              onDaySelected: (DateTime day) => setState(() {
                _selectedDay =
                    _selectedDay != null && _isSameDay(_selectedDay!, day)
                    ? null
                    : day;
              }),
            ),
          ),
          _buildSectionHeader(provider.allPlants.length),
          if (_selectedDay != null) _buildDayFilter(),
          _buildSearchField(),
          Expanded(
            child: RefreshIndicator(
              color: BlueprintColors.accentOrange,
              onRefresh: () => provider.getPlantsData(showLoading: false),
              child: sortedPlants.isEmpty
                  ? _buildNoResultsState()
                  : _buildPlantGrid(sortedPlants),
            ),
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
          size: 15,
        ),
        const SizedBox(width: 8),
        Text(
          'Mis plantas',
          style: AppTextStyles.label(
            color: BlueprintColors.accentOrange,
            size: 12,
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
            style: AppTextStyles.label(size: 11, spacing: 0.5),
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
                style: AppTextStyles.label(size: 11, spacing: 1.5),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.unfold_more_rounded,
                size: 15,
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
        Icon(icon, size: 16, color: BlueprintColors.accentOrange),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.label(
            color: _currentSortCriteria == value
                ? BlueprintColors.accentOrange
                : BlueprintColors.textMuted,
            size: 12,
            spacing: 1,
          ),
        ),
      ],
    ),
  );

  Widget _buildDayFilter() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
    child: Row(
      children: <Widget>[
        const Icon(
          Icons.filter_alt_outlined,
          size: 15,
          color: BlueprintColors.accentOrange,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            'RIEGOS DEL '
            '${_selectedDayFormat.format(_selectedDay!).toUpperCase()}',
            style: AppTextStyles.label(
              color: BlueprintColors.accentOrange,
              size: 11,
              spacing: 1,
            ),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _selectedDay = null),
          style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
          child: const Text('Quitar filtro'),
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

  Widget _buildNoResultsState() => ListView(
    // Scrollable para que el pull-to-refresh funcione también aquí.
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.only(top: 48),
    children: <Widget>[
      const Icon(
        Icons.search_off_rounded,
        color: BlueprintColors.textMuted,
        size: 28,
      ),
      const SizedBox(height: 12),
      Text(
        'NO_RESULTS_FOUND',
        textAlign: TextAlign.center,
        style: AppTextStyles.label(size: 12, spacing: 2),
      ),
      const SizedBox(height: 4),
      Text(
        _searchQuery.isNotEmpty
            ? '"$_searchQuery"'
            : 'Ninguna planta para este día',
        textAlign: TextAlign.center,
        style: AppTextStyles.label(
          color: BlueprintColors.accentOrange,
          size: 11,
          spacing: 0.5,
        ),
      ),
    ],
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
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 8, bottom: 88),
          itemCount: plants.length,
          itemBuilder: (BuildContext context, int index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: BasicPlantCard(plant: plants[index]),
          ),
        );
      }
      return GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisExtent: 96,
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
    String query = _searchQuery.trim().toLowerCase();
    List<PlantModel> result = plants
        .where(
          (PlantModel plant) =>
              _matchesSelectedDay(plant) &&
              (query.isEmpty ||
                  plant.plantName.toLowerCase().contains(query) ||
                  plant.species.toLowerCase().contains(query) ||
                  plant.plantLocation.toLowerCase().contains(query)),
        )
        .toList();
    switch (_currentSortCriteria) {
      case PlantSortCriteria.byLocation:
        result.sort(
          (PlantModel a, PlantModel b) => a.plantLocation
              .toLowerCase()
              .compareTo(b.plantLocation.toLowerCase()),
        );
        break;
      case PlantSortCriteria.byNextWatering:
        // Las fechas se guardan como `dd/MM/yyyy`, así que se comparan como
        // DateTime; las inválidas van al final.
        DateTime far = DateTime(9999);
        result.sort(
          (PlantModel a, PlantModel b) => (a.getNextWateringDate ?? far)
              .compareTo(b.getNextWateringDate ?? far),
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

  /// La planta toca o se regó el día seleccionado. Si es hoy, también entran
  /// las atrasadas, porque también hay que regarlas hoy.
  bool _matchesSelectedDay(PlantModel plant) {
    DateTime? day = _selectedDay;
    if (day == null) return true;
    DateTime? next = plant.getNextWateringDate;
    DateTime? last = plant.getLastWateredDate;
    DateTime now = DateTime.now();
    bool isToday = _isSameDay(day, now);
    bool isDue =
        next != null &&
        (_isSameDay(next, day) ||
            (isToday && next.isBefore(DateTime(now.year, now.month, now.day))));
    return isDue || (last != null && _isSameDay(last, day));
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
