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
  DateTime? _lastWateredDate;
  final TextEditingController _nextWateringDateController =
      TextEditingController();
  DateTime? _nextWateringDate;
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
  String? _plantImageData;
  int? _plantImageSizeBytes;
  bool? _isBase64Recommended;
  bool? _wasImageCompressed;
  bool _saving = false;

  static const int _base64SoftLimitBytes = 200 * 1024;

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
      _lastWateredDateController.text = toYYYYMMdd(_lastWateredDate!);
      _plantImageData = null;
      _plantImageSizeBytes = null;
      _isBase64Recommended = null;
      _wasImageCompressed = null;
    }
    // Se registra después de cargar los datos iniciales para que solo
    // reaccione a cambios del usuario.
    _wateringFrequencyDaysController.addListener(_recalculateNextWateringDate);
  }

  /// Siguiente riego = último riego + frecuencia. Se recalcula cuando cambia
  /// cualquiera de los dos; el usuario puede ajustarlo después a mano.
  void _recalculateNextWateringDate() {
    DateTime? lastWatered = toDateTime(_lastWateredDateController.text);
    int? frequencyDays = int.tryParse(_wateringFrequencyDaysController.text);
    if (lastWatered == null || frequencyDays == null || frequencyDays < 1) {
      return;
    }
    String next = toYYYYMMdd(lastWatered.add(Duration(days: frequencyDays)));
    if (_nextWateringDateController.text != next) {
      _nextWateringDateController.text = next;
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
      _plantImageSizeBytes = null;
      _isBase64Recommended = null;
      _wasImageCompressed = null;
      _plantNameController.text = widget.plant?.plantName ?? '';
      _plantSpeciesController.text = widget.plant?.species ?? '';
      _lastWateredDateController.text = widget.plant?.lastWateredDate ?? '';
      _lastWateredDate = toDateTime(widget.plant!.lastWateredDate);
      _nextWateringDateController.text = widget.plant?.nextWateringDate ?? '';
      _nextWateringDate = toDateTime(widget.plant!.nextWateringDate);
      _plantCareController.text = widget.plant?.plantCare ?? '';
      _plantImageData = widget.plant?.plantImage;
      if (isBase64Image(_plantImageData)) {
        _plantImageSizeBytes = estimateBase64SizeBytes(_plantImageData);
        _isBase64Recommended =
            (_plantImageSizeBytes ?? 0) <= _base64SoftLimitBytes;
      }
      _wasImageCompressed = null;
      _plantLocationController.text = widget.plant?.plantLocation ?? '';
      _wateringFrequencyDaysController.text =
          '${widget.plant?.wateringFrequencyDays}';
      _selectedIcon = widget.plant?.icon ?? '';
      _selectedColor = getColorFromString(widget.plant?.color ?? '');
      String schedule = widget.plant?.wateringSchedule ?? '';
      _selectedSchedule = scheduleOptions.contains(schedule)
          ? schedule
          : scheduleOptions.first;
      _wateringScheduleController.text = _selectedSchedule!;
    }
  }

  Future<void> _presentDatePicker({
    required TextEditingController controllerTextDate,
    required String helpText,
    DateTime? selectedDate,
  }) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      // Abre en la fecha ya elegida en el campo, no en la original.
      initialDate:
          toDateTime(controllerTextDate.text) ?? selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      helpText: helpText,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (pickedDate == null) return;
    controllerTextDate.text = toYYYYMMdd(pickedDate);
    if (controllerTextDate == _lastWateredDateController) {
      _recalculateNextWateringDate();
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    required BuildContext context,
    TextInputType? inputType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    double? fieldWidth,
  }) => SizedBox(
    width: fieldWidth ?? double.infinity,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: BlueprintTextField(
        label: label,
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        keyboardType: inputType ?? TextInputType.name,
        inputFormatters: inputFormatters,
        textCapitalization: TextCapitalization.sentences,
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
    width: fieldWidth ?? double.infinity,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: BlueprintTextField(
        label: label,
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        keyboardType: inputType ?? TextInputType.name,
        // La fecha se elige solo con el selector; así no se abre el teclado
        // encima del calendario ni se escriben formatos inválidos.
        readOnly: true,
        onTap: () {
          _presentDatePicker(
            selectedDate: selectedDate,
            controllerTextDate: controller,
            helpText: helpText!,
          );
        },
        suffixIcon: const Icon(
          Icons.calendar_today,
          color: BlueprintColors.textMuted,
        ),
      ),
    ),
  );

  Widget _buildIconSelector() => Wrap(
    spacing: 4,
    runSpacing: 4,
    children: iconsNameOptions
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
          border: Border.all(
            color: isSelected
                ? BlueprintColors.accentOrange
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: PlantAvatar(
            plantIconString: iconName,
            plantColorString: isSelected
                ? getColorName(_selectedColor!)
                : 'white',
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: DetailSectionTitle(label: title),
  );

  Widget _buildColorSelector() => Wrap(
    spacing: 12,
    runSpacing: 12,
    children: colorOptions.map((Color color) {
      bool isSelected = _selectedColor == color;
      return GestureDetector(
        onTap: () {
          setState(() {
            _selectedColor = color;
          });
        },
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: isSelected
                  ? BlueprintColors.accentOrange
                  : BlueprintColors.outlineVariant,
              width: isSelected ? 3 : 1,
            ),
          ),
        ),
      );
    }).toList(),
  );

  Widget _buildDropdown({double? fieldWidth}) => SizedBox(
    width: fieldWidth ?? double.infinity,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        initialValue: _selectedSchedule,
        onChanged: (String? newValue) {
          setState(() {
            _selectedSchedule = newValue;
            _wateringScheduleController.text = _selectedSchedule!;
          });
        },
        style: AppTextStyles.bodyLarge,
        dropdownColor: BlueprintColors.surfaceContainerLow,
        items: scheduleOptions
            .map<DropdownMenuItem<String>>(
              (String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(getWateringScheduleFromString(value)),
              ),
            )
            .toList(),
        decoration: const InputDecoration(label: Text('Horario de riego')),
        validator: (String? p0) {
          if (p0 == null || p0.isEmpty) {
            return '''Por favor agrega el horario en que riegas la planta''';
          }
          return null;
        },
      ),
    ),
  );

  String _formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      XFile? imageFile = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1280,
        imageQuality: 75,
      );
      if (imageFile == null) {
        return;
      }
      Uint8List bytes = await imageFile.readAsBytes();
      ImageCompressionResult compression =
          await compressImageToFitLimitInBackground(
            bytes,
            maxBytes: _base64SoftLimitBytes,
          );
      if (!mounted) {
        return;
      }
      Uint8List selectedBytes = compression.bytes;
      bool recommended = compression.fitsWithinLimit;
      setState(() {
        _plantImageData = base64Encode(selectedBytes);
        _plantImageSizeBytes = selectedBytes.lengthInBytes;
        _isBase64Recommended = recommended;
        _wasImageCompressed = compression.wasCompressed;
      });
      if (!mounted) {
        return;
      }
      String message = recommended
          ? (compression.wasCompressed
                ? '''La imagen fue comprimida y se almacenará en Firebase como Base64.'''
                : 'La imagen se almacenará en Firebase como Base64.')
          : '''La imagen es muy pesada incluso tras la compresión. Considera usar Firebase Storage y guardar solo la URL pública.''';
      if (recommended) {
        showSuccessSnackBar(context, message);
      } else {
        showInformationSnackBar(context, message);
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      showErrorSnackBar(
        context,
        'No se pudo seleccionar la foto de la planta: $e',
      );
    }
  }

  void _showImageSourcePicker() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Tomar foto'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image_outlined),
                title: const Text('Elegir de galería'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStorageEvaluation(BuildContext context) {
    if (_plantImageSizeBytes == null) {
      return const SizedBox.shrink();
    }
    bool isRecommended = _isBase64Recommended ?? true;
    String sizeLabel = _formatBytes(_plantImageSizeBytes!);
    Color statusColor = isRecommended
        ? BlueprintColors.successGreen
        : BlueprintColors.warning;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Icon(
              Icons.data_usage,
              size: 18,
              color: BlueprintColors.accentOrange,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Tamaño estimado de la imagen: $sizeLabel',
                style: AppTextStyles.bodyMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_wasImageCompressed == true)
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              '''La imagen se comprimió automáticamente para cumplir con el límite recomendado.''',
              style: AppTextStyles.bodySmall,
            ),
          ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.08),
            border: Border.all(color: statusColor),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(
                isRecommended ? Icons.check_circle : Icons.lightbulb,
                size: 18,
                color: statusColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isRecommended
                      ? '''El tamaño es adecuado para guardarlo como Base64 en Firebase Realtime Database.'''
                      : '''La imagen es pesada para la base de datos. Usa Firebase Storage para alojarla y guarda solo la URL en la planta.''',
                  style: AppTextStyles.bodySmall.copyWith(color: statusColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _savePlant() async {
    if (!_formKey.currentState!.validate()) return;
    FirebaseProvider firebaseProvider = Provider.of<FirebaseProvider>(
      context,
      listen: false,
    );
    setState(() => _saving = true);
    PlantModel _plant = PlantModel(
      color: getColorName(_selectedColor ?? Colors.white),
      icon: _selectedIcon ?? 'default',
      lastWateredDate: _lastWateredDateController.text,
      nextWateringDate: _nextWateringDateController.text,
      plantCare: _plantCareController.text,
      plantImage: _plantImageData ?? widget.plant?.plantImage ?? '',
      plantLocation: _plantLocationController.text,
      plantName: _plantNameController.text,
      species: _plantSpeciesController.text,
      wateringFrequencyDays: toNumeric(_wateringFrequencyDaysController.text),
      wateringSchedule: _wateringScheduleController.text,
      justWatered: widget.plant?.justWatered ?? false,
    );
    String? uuid = widget.plant?.uuid;
    bool saved = widget.isUpdate && uuid != null && uuid.isNotEmpty
        ? await firebaseProvider.updatePlant(uuid, _plant)
        : await firebaseProvider.addPlant(_plant);
    if (!mounted) return;
    setState(() => _saving = false);
    if (!saved) {
      showErrorSnackBar(
        context,
        widget.isUpdate
            ? 'No se pudo actualizar la planta'
            : 'No se pudo crear la planta',
      );
      return;
    }
    showSuccessSnackBar(
      context,
      widget.isUpdate ? 'Planta actualizada' : 'Planta creada',
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => BlueprintScaffold(
    appBar: BlueprintFormAppBar(
      title: widget.isUpdate ? 'Actualizar planta' : 'Agregar planta',
    ),
    body: BlueprintFormBody(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 4),
            _buildSectionTitle('Imagen de la planta'),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: PlantImage(
                        plantImage:
                            (_plantImageData != null &&
                                _plantImageData!.isNotEmpty)
                            ? _plantImageData
                            : widget.plant?.plantImage ?? '',
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: kIsWeb
                          ? () => _pickImage(ImageSource.gallery)
                          : _showImageSourcePicker,
                      icon: kIsWeb
                          ? const Icon(Icons.image_outlined)
                          : const Icon(Icons.photo_camera_outlined),
                      label: kIsWeb
                          ? const Text('Seleccionar imagen')
                          : const Text('Cambiar foto'),
                    ),
                    if (_plantImageData != null && _plantImageData!.isNotEmpty)
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _plantImageData = null;
                            _plantImageSizeBytes = null;
                            _isBase64Recommended = null;
                            _wasImageCompressed = null;
                          });
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          color: BlueprintColors.danger,
                        ),
                        label: const Text(
                          'Eliminar foto',
                          style: TextStyle(color: BlueprintColors.danger),
                        ),
                      ),
                    const SizedBox(height: 16),
                    _buildIconSelector(),
                    const SizedBox(height: 16),
                    const CustomDivider(color: BlueprintColors.outlineVariant),
                    const SizedBox(height: 16),
                    _buildColorSelector(),
                    const SizedBox(height: 4),
                    _buildStorageEvaluation(context),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: _buildDropdown()),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    label: 'Frecuencia de riego',
                    controller: _wateringFrequencyDaysController,
                    inputType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (String? p0) {
                      if (p0 == null || p0.isEmpty) {
                        return '''Por favor agrega cada cuantos días riegas la planta''';
                      }
                      int? days = int.tryParse(p0);
                      if (days == null || days < 1 || days > 365) {
                        return 'Ingresa un número de días entre 1 y 365';
                      }
                      return null;
                    },
                    context: context,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: _buildDatePickerTextField(
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
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDatePickerTextField(
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
                ),
              ],
            ),
            _buildTextField(
              label: 'Cuidados de la planta',
              controller: _plantCareController,
              maxLines: 4,
              validator: (String? p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Por favor agrega los cuidados de la planta';
                }
                return null;
              },
              context: context,
            ),
          ],
        ),
      ),
    ),
    bottomNavigationBar: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Align(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.formMaxWidth,
            ),
            child: BlueprintPrimaryButton(
              label: widget.isUpdate ? 'ACTUALIZAR PLANTA' : 'CREAR PLANTA',
              icon: widget.isUpdate ? Icons.update : Icons.add_circle_outlined,
              loading: _saving,
              onPressed: _savePlant,
            ),
          ),
        ),
      ),
    ),
  );
}
