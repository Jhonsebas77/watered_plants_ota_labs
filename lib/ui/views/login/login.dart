part of com.watered_plants_ota_labs.app.views;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  bool _obscureText = true;
  String _appName = '...';
  String _version = '...';
  String _buildNumber = '...';

  void _handleSignIn(AuthProvider authProvider) {
    if (_passwordController.text.isEmpty) return;
    HapticFeedback.mediumImpact();
    authProvider
      ..clearError()
      ..signIn(_passwordController.text);
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _initPackageInfo() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _appName = info.appName;
      _version = info.version;
      _buildNumber = info.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: BlueprintColors.background,
    body: Consumer<AuthProvider>(
      builder:
          (BuildContext context, AuthProvider authProvider, Widget? child) =>
              GridBackground(
                child: Stack(
                  children: <Widget>[
                    const ScanlineOverlay(),
                    const Positioned.fill(
                      child: IgnorePointer(
                        child: CornerBrackets(size: 28, inset: 24),
                      ),
                    ),
                    SafeArea(
                      child: Column(
                        children: <Widget>[
                          const BackgroundHeader(),
                          Expanded(child: _buildBody(authProvider)),
                          const BackgroundFooter(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    ),
  );

  Widget _buildBody(AuthProvider authProvider) => SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 32),
    child: ResponsiveContainer(
      maxWidth: Breakpoints.compact,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 16),
          _buildLogoCluster()
              .animate()
              .fadeIn(duration: 700.ms, delay: 200.ms)
              .scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1, 1),
                duration: 700.ms,
                curve: Curves.easeOut,
              ),
          const SizedBox(height: 24),
          _buildTitle().animate().fadeIn(duration: 500.ms, delay: 400.ms),
          const SizedBox(height: 40),
          _buildForm(authProvider)
              .animate()
              .fadeIn(duration: 500.ms, delay: 550.ms)
              .slideY(
                begin: 0.2,
                end: 0,
                duration: 500.ms,
                curve: Curves.easeOut,
              ),
          const SizedBox(height: 24),
        ],
      ),
    ),
  );

  Widget _buildLogoCluster() => SchematicRing(
    size: 128,
    child: Container(
      width: 128,
      height: 128,
      decoration: BoxDecoration(
        color: BlueprintColors.background,
        border: Border.all(color: BlueprintColors.outlineVariant),
      ),
      child: const ColorFiltered(
        colorFilter: ColorFilter.mode(Colors.white, BlendMode.modulate),

        child: Icon(
          Icons.eco_rounded,
          size: 64,
          color: BlueprintColors.accentOrange,
        ),
      ),
    ),
  );

  Widget _buildTitle() => Column(
    children: <Widget>[
      Text(
        _appName.toUpperCase(),
        style: AppTextStyles.headlineMedium.copyWith(
          color: BlueprintColors.accentOrange,
          fontWeight: FontWeight.w700,
          height: 1.1,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        'v$_version($_buildNumber)',
        style: AppTextStyles.label(size: 9, spacing: 1),
      ),
    ],
  );

  Widget _buildForm(AuthProvider authProvider) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        children: <Widget>[
          const Icon(
            Icons.lock_outline,
            color: BlueprintColors.textMuted,
            size: 14,
          ),
          const SizedBox(width: 8),
          Text(
            'AUTHENTICATION_PROTOCOL',
            style: AppTextStyles.label(size: 10, spacing: 2),
          ),
          const Spacer(),
          Text(
            'ENCRYPTED_AES_256',
            style: AppTextStyles.label(size: 8, spacing: 0.5),
          ),
        ],
      ),
      const SizedBox(height: 16),
      _buildUserDisplay(),
      const SizedBox(height: 16),
      Text(
        'SECURE_CREDENTIAL',
        style: AppTextStyles.label(size: 9, spacing: 1.5),
      ),
      const SizedBox(height: 8),
      _buildPasswordInput(authProvider),
      if (authProvider.errorMessage != null) ...<Widget>[
        const SizedBox(height: 8),
        Text(
          'ERR: ${authProvider.errorMessage!}',
          style: AppTextStyles.label(
            color: BlueprintColors.danger,
            size: 9,
            spacing: 0.5,
          ),
        ),
      ],
      const SizedBox(height: 20),
      _buildActionButton(authProvider),
    ],
  );

  Widget _buildUserDisplay() => Container(
    decoration: BoxDecoration(
      border: Border.all(color: BlueprintColors.outlineVariant),
      color: BlueprintColors.surfaceContainerLow,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    child: Row(
      children: <Widget>[
        const Icon(
          Icons.person_outline,
          color: BlueprintColors.accentOrange,
          size: 16,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'SYSTEM_USER',
              style: AppTextStyles.label(size: 8, spacing: 1.5),
            ),
            const SizedBox(height: 2),
            Text(
              hardcodedEmail.replaceAll('@gmail.com', ''),
              style: AppTextStyles.label(
                color: BlueprintColors.textPrimary,
                size: 11,
                spacing: 0.3,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _buildPasswordInput(AuthProvider authProvider) => Stack(
    clipBehavior: Clip.none,
    children: <Widget>[
      TextField(
        controller: _passwordController,
        focusNode: _passwordFocus,
        obscureText: _obscureText,
        enabled: !authProvider.isLoading,
        style: AppTextStyles.bodyMedium.copyWith(
          color: BlueprintColors.textPrimary,
          fontSize: 13,
          letterSpacing: 4,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'INPUT_PASSWORD',
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 12, right: 8),
            child: Icon(
              Icons.terminal,
              color: BlueprintColors.accentOrange,
              size: 18,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 44),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 16,
              color: BlueprintColors.textMuted,
            ),
            onPressed: () => setState(() => _obscureText = !_obscureText),
          ),
        ),
        onChanged: (_) {
          if (authProvider.errorMessage != null) authProvider.clearError();
        },
        onSubmitted: (_) => _handleSignIn(authProvider),
        textInputAction: TextInputAction.go,
      ),
      Positioned(
        right: -12,
        top: 0,
        child: Column(
          children: <Widget>[
            Container(
              width: 1,
              height: 24,
              color: BlueprintColors.outline.withAlpha(80),
            ),
            Container(
              width: 10,
              height: 1,
              color: BlueprintColors.outline.withAlpha(80),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _buildActionButton(AuthProvider authProvider) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: authProvider.isLoading
          ? null
          : () => _handleSignIn(authProvider),
      style: ElevatedButton.styleFrom(
        backgroundColor: BlueprintColors.accentOrange,
        foregroundColor: BlueprintColors.onAccent,
        disabledBackgroundColor: BlueprintColors.accentOrange.withAlpha(120),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        side: const BorderSide(color: BlueprintColors.accentOrange, width: 1),
      ),
      child: authProvider.isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: BlueprintColors.onAccent,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'AUTHENTICATING...',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.5,
                    color: BlueprintColors.onAccent,
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'AUTHENTICATE',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.5,
                    color: BlueprintColors.onAccent,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.bolt,
                  size: 16,
                  color: BlueprintColors.onAccent,
                ),
              ],
            ),
    ),
  );
}
