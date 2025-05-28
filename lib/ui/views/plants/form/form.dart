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
  final TextEditingController _lastWateredDate = TextEditingController();
  final TextEditingController _nextWateringDate = TextEditingController();
  final TextEditingController _plantCare = TextEditingController();
  final TextEditingController _plantLocation = TextEditingController();
  final TextEditingController _plantName = TextEditingController();
  final TextEditingController _plantSpecies = TextEditingController();
  final TextEditingController _wateringFrequencyDays = TextEditingController();
  final TextEditingController _wateringSchedule = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate) {
      setPreviousData();
    }
  }

  void setPreviousData() {
    if (widget.plant != null) {
      _plantName.text = widget.plant?.plantName ?? '';
      _plantSpecies.text = widget.plant?.species ?? '';
      _lastWateredDate.text = widget.plant?.lastWateredDate ?? '';
      _nextWateringDate.text = widget.plant?.nextWateringDate ?? '';
      _plantCare.text = widget.plant?.plantCare ?? '';
      // TODO(Sebastian): Validate images
      // _plantImage.text = widget.plant?.plantImage ?? '';
      _plantLocation.text = widget.plant?.plantLocation ?? '';
      _wateringFrequencyDays.text = '${widget.plant?.wateringFrequencyDays}';
      _wateringSchedule.text = widget.plant?.wateringSchedule ?? '';
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    required BuildContext context,
    TextInputType? inputType,
    int maxLines = 1,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
      keyboardType: inputType ?? TextInputType.name,
      decoration: InputDecoration(
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
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        widget.isUpdate ? 'Actualizar planta' : 'Agregar planta',
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    ),
    backgroundColor: Theme.of(context).colorScheme.onPrimary,
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
                _buildTextField(
                  label: 'Nombre de la planta',
                  controller: _plantName,
                  validator: (String? p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Please add the plant name';
                    }
                    return null;
                  },
                  context: context,
                ),
                _buildTextField(
                  label: 'Especie de planta',
                  controller: _plantSpecies,
                  validator: (String? p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Please add the Author name';
                    }
                    return null;
                  },
                  context: context,
                ),
                _buildTextField(
                  label: 'Localización de la planta',
                  controller: _plantLocation,
                  validator: (String? p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Please add the recipe image';
                    }
                    return null;
                  },
                  context: context,
                ),
                _buildTextField(
                  label: 'En que horario riegas la planta?',
                  controller: _wateringSchedule,
                  validator: (String? p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Please add the recipe image';
                    }
                    return null;
                  },
                  context: context,
                ),
                _buildTextField(
                  label: 'Cada cuanto riegas la planta',
                  controller: _wateringFrequencyDays,
                  inputType: TextInputType.number,
                  validator: (String? p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Please add the recipe image';
                    }
                    return null;
                  },
                  context: context,
                ),
                _buildTextField(
                  label: 'Siguiente fecha de riego',
                  controller: _nextWateringDate,
                  inputType: TextInputType.datetime,
                  validator: (String? p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Please add the recipe image';
                    }
                    return null;
                  },
                  context: context,
                ),
                _buildTextField(
                  label: 'Ultima fecha de riego',
                  controller: _lastWateredDate,
                  inputType: TextInputType.datetime,
                  validator: (String? p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Please add the recipe image';
                    }
                    return null;
                  },
                  context: context,
                ),
                _buildTextField(
                  label: 'Cuidados de la planta',
                  controller: _plantCare,
                  maxLines: 4,
                  validator: (String? p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Please add the recipe description';
                    }
                    return null;
                  },
                  context: context,
                ),
                const SizedBox(height: 4),
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
              color: widget.plant?.color ?? '',
              icon: widget.plant?.color ?? '',
              lastWateredDate: _lastWateredDate.text,
              nextWateringDate: _nextWateringDate.text,
              plantCare: _plantCare.text,
              plantImage: widget.plant?.plantImage ?? '',
              plantLocation: _plantLocation.text,
              plantName: _plantName.text,
              species: _plantSpecies.text,
              wateringFrequencyDays: toNumeric(_wateringFrequencyDays.text),
              wateringSchedule: _wateringSchedule.text,
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
