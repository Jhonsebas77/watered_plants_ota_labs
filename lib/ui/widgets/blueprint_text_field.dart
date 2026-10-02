part of com.watered_plants_ota_labs.app.widgets;

class BlueprintTextField extends StatelessWidget {
  const BlueprintTextField({
    required this.label,
    super.key,
    this.controller,
    this.focusNode,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.readOnly = false,
    this.enabled = true,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength,
    this.maxLines = 1,
    this.inputFormatters,
  });

  final String label;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final bool readOnly;
  final bool enabled;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final Widget? suffixIcon;
  final TextCapitalization textCapitalization;
  final int? maxLength;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    focusNode: focusNode,
    obscureText: obscureText,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    validator: validator,
    readOnly: readOnly,
    enabled: enabled,
    onTap: onTap,
    onChanged: onChanged,
    onFieldSubmitted: onFieldSubmitted,
    textCapitalization: textCapitalization,
    maxLength: maxLength,
    maxLines: maxLines,
    inputFormatters: inputFormatters,
    style: AppTextStyles.bodyLarge,
    decoration: InputDecoration(label: Text(label), suffixIcon: suffixIcon),
  );
}
