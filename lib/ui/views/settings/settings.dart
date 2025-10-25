part of com.watered_plants_ota_labs.app.views;

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Ajustes')),
    body: Consumer<SettingsProvider>(
      builder: (
        BuildContext context,
        SettingsProvider settings,
        Widget? child,
      ) {
        if (!settings.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }
        List<int> reminderOptions = <int>[0, 1, 2, 3];
        return ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Card(
              child: SwitchListTile.adaptive(
                title: const Text('Recordatorios de riego'),
                subtitle: const Text(
                  '''Recibe notificaciones cuando llegue el momento de regar tus plantas.''',
                ),
                value: settings.notificationsEnabled,
                onChanged: (bool value) {
                  settings.updateNotificationsEnabled(value);
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                title: const Text('Aviso con anticipación'),
                subtitle: const Text(
                  'Define cuántos días antes recibirás un recordatorio.',
                ),
                trailing: DropdownButton<int>(
                  value: settings.reminderDaysBefore,
                  onChanged:
                      settings.notificationsEnabled
                          ? (int? value) {
                            if (value != null) {
                              settings.updateReminderDaysBefore(value);
                            }
                          }
                          : null,
                  items:
                      reminderOptions
                          .map(
                            (int days) => DropdownMenuItem<int>(
                              value: days,
                              child: Text(_describeReminderOption(days)),
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Horarios preferidos',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...scheduleOptions.map(
              (String schedule) => Card(
                child: ListTile(
                  leading: Icon(getIconTimeDataFromString(schedule)),
                  title: Text(getWateringScheduleFromString(schedule)),
                  subtitle: const Text(
                    'Selecciona la hora en la que deseas recibir el aviso.',
                  ),
                  trailing: Text(
                    settings.getScheduleTime(schedule).format(context),
                  ),
                  onTap: () async {
                    TimeOfDay initialTime = settings.getScheduleTime(schedule);
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: initialTime,
                    );
                    if (selectedTime != null) {
                      await settings.updateScheduleTime(schedule, selectedTime);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            const VersionWidget(),
          ],
        );
      },
    ),
  );

  String _describeReminderOption(int value) {
    switch (value) {
      case 0:
        return 'El mismo día';
      case 1:
        return '1 día antes';
      default:
        return '$value días antes';
    }
  }
}
