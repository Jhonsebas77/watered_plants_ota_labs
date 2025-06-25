part of com.watered_plants_ota_labs.app.views;

class PlantFormView extends StatefulWidget {
  const PlantFormView({this.plant, this.isUpdate = false, super.key});
  static const String route = '/plants/form';
  final PlantModel? plant;
  final bool isUpdate;

  @override
  State<PlantFormView> createState() => _PlantFormViewState();
}

class _PlantFormViewState extends State<PlantFormView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _lastWateredDateController =
      TextEditingController();
  late final DateTime? _lastWateredDate;
  final TextEditingController _nextWateringDateController =
      TextEditingController();
  late final DateTime? _nextWateringDate;
  final TextEditingController _plantCareController = TextEditingController();
  final TextEditingController _plantLocationController =
      TextEditingController();
  final TextEditingController _plantNameController = TextEditingController();
  final TextEditingController _plantSpeciesController = TextEditingController();
  final TextEditingController _wateringFrequencyDaysController =
      TextEditingController();
  final TextEditingController _wateringScheduleController =
      TextEditingController();
  String? _selectedSchedule;
  String? _selectedIcon;
  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate) {
      setPreviousData();
    } else {
      _selectedSchedule = scheduleOptions[0];
      _selectedIcon = iconsNameOptions.last;
      _selectedColor = Colors.white;
      _nextWateringDate = DateTime.now();
      _lastWateredDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _lastWateredDateController.dispose();
    _nextWateringDateController.dispose();
    _plantCareController.dispose();
    _plantLocationController.dispose();
    _plantNameController.dispose();
    _plantSpeciesController.dispose();
    _wateringFrequencyDaysController.dispose();
    _wateringScheduleController.dispose();
    super.dispose();
  }

  void setPreviousData() {
    if (widget.plant != null) {
      _plantNameController.text = widget.plant?.plantName ?? '';
      _plantSpeciesController.text = widget.plant?.species ?? '';
      _lastWateredDateController.text = widget.plant?.lastWateredDate ?? '';
      _lastWateredDate = toDateTime(widget.plant!.lastWateredDate);
      _nextWateringDateController.text = widget.plant?.nextWateringDate ?? '';
      _nextWateringDate = toDateTime(widget.plant!.nextWateringDate);
      _plantCareController.text = widget.plant?.plantCare ?? '';
      // TODO(Sebastian): Validate images
      // _plantImage.text = widget.plant?.plantImage ?? '';
      _plantLocationController.text = widget.plant?.plantLocation ?? '';
      _wateringFrequencyDaysController.text =
          '${widget.plant?.wateringFrequencyDays}';
      _selectedIcon = widget.plant?.icon ?? '';
      _selectedColor = getColorFromString(widget.plant?.color ?? '');
      _selectedSchedule = widget.plant?.wateringSchedule ?? '';
      _wateringScheduleController.text = widget.plant?.wateringSchedule ?? '';
    }
  }

  Future<void> _presentDatePicker({
    required TextEditingController controllerTextDate,
    required String helpText,
    DateTime? selectedDate,
  }) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      helpText: helpText,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        controllerTextDate.text = DateFormat(
          'dd/MM/yyyy',
        ).format(selectedDate!);
      });
    }
  }

  InputDecoration _getDecorator(
    String label,
    IconData? suffixIcon,
    BuildContext context,
  ) => InputDecoration(
    labelText: label,
    labelStyle: TextStyle(
      color: Theme.of(context).colorScheme.onPrimaryContainer,
      fontFamily: 'Quicksand',
    ),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
  );

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    required BuildContext context,
    TextInputType? inputType,
    int maxLines = 1,
    double? fieldWidth,
  }) => SizedBox(
    width: fieldWidth ?? MediaQuery.sizeOf(context).width,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        keyboardType: inputType ?? TextInputType.name,
        decoration: _getDecorator(label, null, context),
      ),
    ),
  );

  Widget _buildDatePickerTextField({
    required String label,
    required DateTime selectedDate,
    required TextEditingController controller,
    required String? Function(String?) validator,
    required BuildContext context,
    String? helpText = 'Selecciona una fecha',
    TextInputType? inputType,
    int maxLines = 1,
    double? fieldWidth,
  }) => SizedBox(
    width: fieldWidth ?? (MediaQuery.sizeOf(context).width * 0.45),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        keyboardType: inputType ?? TextInputType.name,
        onTap: () {
          _presentDatePicker(
            selectedDate: selectedDate,
            controllerTextDate: controller,
            helpText: helpText!,
          );
        },
        decoration: _getDecorator(label, Icons.calendar_today, context),
      ),
    ),
  );

  Widget _buildIconSelector() => Wrap(
    spacing: 4,
    runSpacing: 4,
    children:
        iconsNameOptions
            .map((String icon) => _buildIconChip(iconName: icon))
            .toList(),
  );

  Widget _buildIconChip({required String iconName}) {
    bool isSelected = _selectedIcon == iconName;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIcon = iconName;
        });
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.grey, width: 2) : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: PlantAvatar(
            plantIconString: iconName,
            plantColorString:
                isSelected ? getColorName(_selectedColor!) : 'white',
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Text(
    title,
    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  );

  Widget _buildColorSelector() => Wrap(
    spacing: 15,
    runSpacing: 4,
    children:
        colorOptions.map((Color color) {
          bool isSelected = _selectedColor == color;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = color;
              });
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border:
                    isSelected
                        ? Border.all(color: Colors.grey, width: 2)
                        : null,
              ),
            ),
          );
        }).toList(),
  );

  Widget _buildDropdown({double? fieldWidth}) => SizedBox(
    width: fieldWidth ?? MediaQuery.sizeOf(context).width,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: _selectedSchedule,
        onChanged: (String? newValue) {
          setState(() {
            _selectedSchedule = newValue;
            _wateringScheduleController.text = _selectedSchedule!;
          });
        },
        items:
            scheduleOptions
                .map<DropdownMenuItem<String>>(
                  (String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(getWateringScheduleFromString(value)),
                  ),
                )
                .toList(),
        decoration: _getDecorator(
          'En que horario riegas la planta?',
          null,
          context,
        ),
        validator: (String? p0) {
          if (p0 == null || p0.isEmpty) {
            return '''Por favor agrega el horario en que riegas la planta''';
          }
          return null;
        },
      ),
    ),
  );
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.isUpdate ? 'Actualizar planta' : 'Agregar planta'),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.all(8),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 4),
                _buildSectionTitle('Imagen de la planta'),
                Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: PlantImage(
                            plantImage:
                                widget.plant?.plantImage ?? placeHolderImage,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildIconSelector(),
                        const SizedBox(height: 4),
                        const Divider(thickness: 2, color: Colors.grey),
                        const SizedBox(height: 4),
                        _buildColorSelector(),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                _buildSectionTitle('Información de la planta'),
                _buildTextField(
                  label: 'Nombre de la planta',
                  controller: _plantNameController,
                  validator: (String? p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Por favor agrega el nombre de la planta';
                    }
                    return null;
                  },
                  context: context,
                ),
                _buildTextField(
                  label: 'Especie de planta',
                  controller: _plantSpeciesController,
                  validator: (String? p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Por favor agrega la especie de la planta';
                    }
                    return null;
                  },
                  context: context,
                ),
                _buildTextField(
                  label: 'Ubicación de la planta',
                  controller: _plantLocationController,
                  validator: (String? p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Por favor agrega la ubicación de la planta';
                    }
                    return null;
                  },
                  context: context,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildDropdown(
                      fieldWidth: MediaQuery.sizeOf(context).width * 0.45,
                    ),
                    _buildTextField(
                      label: 'Frecuencia de riego',
                      controller: _wateringFrequencyDaysController,
                      inputType: TextInputType.number,
                      validator: (String? p0) {
                        if (p0 == null || p0.isEmpty) {
                          return '''Por favor agrega cada cuantos días riegas la planta''';
                        }
                        return null;
                      },
                      context: context,
                      fieldWidth: MediaQuery.sizeOf(context).width * 0.45,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildDatePickerTextField(
                      label: 'Siguiente fecha de riego',
                      selectedDate: _nextWateringDate ?? DateTime.now(),
                      helpText: 'Siguiente fecha de riego',
                      controller: _nextWateringDateController,
                      inputType: TextInputType.datetime,
                      validator: (String? p0) {
                        if (p0 == null || p0.isEmpty) {
                          return 'Por favor selecciona una fecha valida';
                        }
                        return null;
                      },
                      context: context,
                    ),
                    _buildDatePickerTextField(
                      label: 'Ultima fecha de riego',
                      selectedDate: _lastWateredDate ?? DateTime.now(),
                      helpText: 'Ultima fecha de riego',
                      controller: _lastWateredDateController,
                      inputType: TextInputType.datetime,
                      validator: (String? p0) {
                        if (p0 == null || p0.isEmpty) {
                          return 'Por favor selecciona una fecha valida';
                        }
                        return null;
                      },
                      context: context,
                    ),
                  ],
                ),
                _buildTextField(
                  label: 'Cuidados de la planta',
                  controller: _plantCareController,
                  maxLines: 4,
                  validator: (String? p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Please add the recipe description';
                    }
                    return null;
                  },
                  context: context,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    bottomNavigationBar: Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () async {
          FirebaseProvider firebaseProvider = Provider.of<FirebaseProvider>(
            context,
            listen: false,
          );
          if (_formKey.currentState!.validate()) {
            PlantModel _plant = PlantModel(
              color: getColorName(_selectedColor ?? Colors.white),
              icon: _selectedIcon ?? 'default',
              lastWateredDate: _lastWateredDateController.text,
              nextWateringDate: _nextWateringDateController.text,
              plantCare: _plantCareController.text,
              plantImage: widget.plant?.plantImage ?? '',
              plantLocation: _plantLocationController.text,
              plantName: _plantNameController.text,
              species: _plantSpeciesController.text,
              wateringFrequencyDays: toNumeric(
                _wateringFrequencyDaysController.text,
              ),
              wateringSchedule: _wateringScheduleController.text,
              justWatered: widget.plant?.justWatered ?? false,
            );
            firebaseProvider.isLoading = true;
            if (widget.isUpdate &&
                (widget.plant != null) &&
                (widget.plant?.uuid != null)) {
              String _uuid = widget.plant!.uuid!;
              await firebaseProvider.updatePlant(_uuid, _plant);
              await firebaseProvider.getOnePlant(_uuid);
            } else {
              await firebaseProvider.addPlant(_plant);
            }
            await firebaseProvider.getPlantsData();
            firebaseProvider.isLoading = false;
            if (context.mounted) Navigator.pop(context);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(widget.isUpdate ? 'Actualizar planta' : 'Crear planta'),
            const SizedBox(width: 4),
            Icon(widget.isUpdate ? Icons.update : Icons.add_circle_outlined),
          ],
        ),
      ),
    ),
  );
}
