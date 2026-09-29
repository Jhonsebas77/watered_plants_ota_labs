part of com.watered_plants_ota_labs.app.widgets;

void showInformationSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    CustomSnackBar(
      context: context,
      label: message,
      type: SnackbarType.information,
    ),
  );
}

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    CustomSnackBar(context: context, label: message, type: SnackbarType.error),
  );
}

void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    CustomSnackBar(
      context: context,
      label: message,
      type: SnackbarType.success,
    ),
  );
}

Color accentColorType(SnackbarType type) => switch (type) {
  SnackbarType.information => BlueprintColors.infoBlue,
  SnackbarType.success => BlueprintColors.successGreen,
  SnackbarType.error => BlueprintColors.danger,
};

IconData defaultIcon(SnackbarType type) => switch (type) {
  SnackbarType.error => Icons.error_outline_outlined,
  SnackbarType.information => Icons.info_outline_rounded,
  _ => Icons.check_circle_outline_outlined,
};

class CustomSnackBar extends SnackBar {
  CustomSnackBar({
    required BuildContext context,
    required String label,
    SnackbarType type = SnackbarType.information,
    IconData? prefixIcon,
    ThemeData? themeData,
    Key? key,
  }) : super(
         key: key,
         elevation: 2,
         shape: RoundedRectangleBorder(
           side: BorderSide(color: accentColorType(type)),
         ),
         behavior: SnackBarBehavior.floating,
         margin: kIsWeb ? null : const EdgeInsetsGeometry.all(16),
         width: kIsWeb ? 556 : null,
         backgroundColor: BlueprintColors.surfaceContainerLow,
         content: Theme(
           data: themeData ?? Theme.of(context),
           child: SnackBarContent(
             label: label,
             type: type,
             prefixIcon: prefixIcon,
           ),
         ),
       );
}

class SnackBarContent extends StatelessWidget {
  const SnackBarContent({
    required this.label,
    required this.type,
    this.prefixIcon,
    super.key,
  });

  final String label;
  final SnackbarType type;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      Icon(prefixIcon ?? defaultIcon(type), color: accentColorType(type)),
      const SizedBox(width: 8),
      Expanded(
        child: Text(label, softWrap: true, style: AppTextStyles.bodyMedium),
      ),
      const SizedBox(width: 8),
    ],
  );
}
