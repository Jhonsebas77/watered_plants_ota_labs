part of com.watered_plants_ota_labs.app.providers;

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _initialize();
  }

  bool _isAuthenticated = false;
  bool _isLoading = true;
  String? _errorMessage;
  StreamSubscription<AuthState>? _authSubscription;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _initialize() {
    Session? currentSession =
        Supabase.instance.client.auth.currentSession;
    _isAuthenticated = currentSession != null;
    _isLoading = false;

    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((
      AuthState state,
    ) {
      bool wasAuthenticated = _isAuthenticated;
      _isAuthenticated = state.session != null;
      if (wasAuthenticated != _isAuthenticated) {
        notifyListeners();
      }
    });

    notifyListeners();
  }

  Future<void> signIn(String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: hardcodedEmail,
        password: password,
      );
      _isAuthenticated = true;
    } on AuthException catch (e) {
      _errorMessage = _describeAuthError(e);
      _isAuthenticated = false;
    } catch (e) {
      _errorMessage = 'Ocurrió un error inesperado. Intenta de nuevo.';
      _isAuthenticated = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Supabase.instance.client.auth.signOut();
      _isAuthenticated = false;
    } catch (e) {
      _errorMessage = 'No se pudo cerrar sesión. Intenta de nuevo.';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Supabase devuelve los mensajes en inglés; se traducen los casos
  /// conocidos y el resto cae en un mensaje genérico.
  String _describeAuthError(AuthException error) {
    if (error is AuthRetryableFetchException) {
      return 'Sin conexión. Revisa tu internet e intenta de nuevo.';
    }
    if (error.code == 'invalid_credentials') {
      return 'Contraseña incorrecta.';
    }
    if (error.code == 'over_request_rate_limit') {
      return 'Demasiados intentos. Espera un momento e intenta de nuevo.';
    }
    return 'No se pudo iniciar sesión. Intenta de nuevo.';
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
