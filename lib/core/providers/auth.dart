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
      _errorMessage = e.message;
      _isAuthenticated = false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
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
      _errorMessage = 'Error signing out. Please try again.';
    }

    _isLoading = false;
    notifyListeners();
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
