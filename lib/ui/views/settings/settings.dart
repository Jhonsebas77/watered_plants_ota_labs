part of com.watered_plants_ota_labs.app.views;

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  Future<void> _confirmLogout() async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('SALIR'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await Provider.of<AuthProvider>(context, listen: false).signOut();
      if (!mounted) return;
      Navigator.of(context).popUntil((Route<dynamic> route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) => BlueprintScaffold(
    appBar: const BlueprintFormAppBar(title: 'Ajustes'),
    body: Consumer<SettingsProvider>(
      builder: (BuildContext context, SettingsProvider settings, Widget? _) {
        if (!settings.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }
        List<int> reminderOptions = <int>[0, 1, 2, 3];
        // Las notificaciones locales no existen en web (NotificationService
        // es no-op ahí), así que las opciones se muestran deshabilitadas en
        // vez de prometer algo que no funciona.
        bool notificationsAvailable = !kIsWeb;
        return ResponsiveContainer(
          maxWidth: Breakpoints.formMaxWidth,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              const DetailSectionTitle(label: 'Notificaciones'),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Recordatorios de riego'),
                subtitle: Text(
                  notificationsAvailable
                      ? '''Recibe notificaciones cuando llegue el momento de regar tus plantas.'''
                      : 'No disponible en la versión web.',
                ),
                value: notificationsAvailable && settings.notificationsEnabled,
                onChanged: notificationsAvailable
                    ? settings.updateNotificationsEnabled
                    : null,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                enabled: notificationsAvailable,
                title: const Text('Aviso con anticipación'),
                subtitle: const Text(
                  'Define cuántos días antes recibirás un recordatorio.',
                ),
                trailing: DropdownButton<int>(
                  value: settings.reminderDaysBefore,
                  dropdownColor: BlueprintColors.surfaceContainerLow,
                  style: AppTextStyles.bodyMedium,
                  underline: const SizedBox.shrink(),
                  onChanged:
                      notificationsAvailable && settings.notificationsEnabled
                      ? (int? value) {
                          if (value != null) {
                            settings.updateReminderDaysBefore(value);
                          }
                        }
                      : null,
                  items: reminderOptions
                      .map(
                        (int days) => DropdownMenuItem<int>(
                          value: days,
                          child: Text(_describeReminderOption(days)),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 24),
              const DetailSectionTitle(label: 'Horarios preferidos'),
              const SizedBox(height: 8),
              ...scheduleOptions.map(
                (String schedule) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  enabled: notificationsAvailable,
                  leading: Icon(
                    getIconTimeDataFromString(schedule),
                    color: BlueprintColors.textMuted,
                  ),
                  title: Text(getWateringScheduleFromString(schedule)),
                  subtitle: const Text(
                    'Hora en la que deseas recibir el aviso.',
                  ),
                  trailing: CustomBadge(
                    label: settings.getScheduleTime(schedule).format(context),
                    color: notificationsAvailable
                        ? BlueprintColors.accentOrange
                        : BlueprintColors.textMuted,
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
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: _confirmLogout,
                icon: const Icon(Icons.logout_outlined),
                label: const Text('Cerrar sesión'),
              ),
              const SizedBox(height: 24),
              const Center(child: VersionWidget()),
            ],
          ),
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
