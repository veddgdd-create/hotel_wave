class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthLoadingState extends AuthStates {}

class AuthSuccessState extends AuthStates {
  final String role;

  AuthSuccessState({required this.role});
}

class AuthFailureState extends AuthStates {
  final String error;

  AuthFailureState({required this.error});
}

class UpdateLoadingState extends AuthStates {}

class UpdateSucessState extends AuthStates {}

class UpdateErrorState extends AuthStates {
  final String error;

  UpdateErrorState({required this.error});
}
