class LoginState {
  final bool isLoading;
  final String? error;
  final bool showRegister;
  LoginState({this.isLoading = false, this.showRegister = false, this.error});

  LoginState copyWith({bool? isLoading, bool? showRegister, String? error}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      showRegister: showRegister ?? this.showRegister,
      error: error,
    );
  }
}
