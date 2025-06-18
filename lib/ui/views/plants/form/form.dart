// ignore_for_file: lines_longer_than_80_chars

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

  @override
  void dispose() {
    _lastWateredDate.dispose();
    _nextWateringDate.dispose();
    _plantCare.dispose();
    _plantLocation.dispose();
    _plantName.dispose();
    _plantSpecies.dispose();
    _wateringFrequencyDays.dispose();
    _wateringSchedule.dispose();
    super.dispose();
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
                // const MyDatePickerInput(),
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

// class MyDatePickerInput extends StatefulWidget {
//   const MyDatePickerInput({super.key});

//   @override
//   State<MyDatePickerInput> createState() => _MyDatePickerInputState();
// }

// class _MyDatePickerInputState extends State<MyDatePickerInput> {
//   // Controller for the TextFormField to display the date
//   final TextEditingController _dateController = TextEditingController();
//   // Variable to store the selected date
//   DateTime? _selectedDate;

//   // Function to present the date picker
//   Future<void> _presentDatePicker() async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       // Use the current selected date as initial, or today's date if none is selected
//       initialDate: _selectedDate ?? DateTime.now(),
//       // Set a reasonable range for selectable dates
//       firstDate: DateTime(2000), // Example: Start from year 2000
//       lastDate: DateTime(2101), // Example: End at year 2101
//       helpText: 'Select a date', // Optional: Custom help text
//       // You can also customize the theme of the date picker here if needed
//       // builder: (context, child) {
//       //   return Theme(
//       //     data: Theme.of(context).copyWith(
//       //       colorScheme: const ColorScheme.light(
//       //         primary: Colors.green, // header background color
//       //         onPrimary: Colors.white, // header text color
//       //         onSurface: Colors.black, // body text color
//       //       ),
//       //       textButtonTheme: TextButtonThemeData(
//       //         style: TextButton.styleFrom(
//       //           foregroundColor: Colors.green, // button text color
//       //         ),
//       //       ),
//       //     ),
//       //     child: child!,
//       //   );
//       // },
//     );

//     if (pickedDate != null && pickedDate != _selectedDate) {
//       setState(() {
//         _selectedDate = pickedDate;
//         // Format the date and update the controller
//         _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _dateController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Given current date is Wednesday, May 28, 2025
//     // If _dateController.text is empty, the hintText will show.
//     // If a date is selected, it will be formatted and displayed.

//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           TextFormField(
//             controller: _dateController,
//             readOnly: true, // Make the field read-only
//             decoration: InputDecoration(
//               labelText: 'Selected Date',
//               hintText: 'DD/MM/YYYY (e.g., 28/05/2025)',
//               border: const OutlineInputBorder(),
//               suffixIcon: IconButton(
//                 icon: const Icon(Icons.calendar_today),
//                 onPressed:
//                     _presentDatePicker, // Open picker when icon is pressed
//               ),
//             ),
//             onTap:
//                 _presentDatePicker, // Also open picker when the field itself is tapped
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _presentDatePicker,
//             child: const Text('Pick a Date'),
//           ),
//           if (_selectedDate != null)
//             Padding(
//               padding: const EdgeInsets.only(top: 20),
//               child: Text(
//                 '''Formatted using intl: ${DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate!)}''',
//                 style: const TextStyle(fontSize: 16),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
