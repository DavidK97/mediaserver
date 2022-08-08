part of 'authentication_bloc.dart';

enum AuthenticationStatus { unauthenticated, authenticated }

abstract class AuthenticationState extends Equatable {
  const AuthenticationState(this.status);

  final AuthenticationStatus status;

  @override
  List<Object> get props => [status];
}

class AuthenticationInitial extends AuthenticationState {
  const AuthenticationInitial() : super(AuthenticationStatus.unauthenticated);
}

class Authenticating extends AuthenticationState {
  const Authenticating() : super(AuthenticationStatus.unauthenticated);
}

class Authenticated extends AuthenticationState {
  const Authenticated() : super(AuthenticationStatus.authenticated);
}

class Unauthenticated extends AuthenticationState {
  final String message;

  const Unauthenticated(this.message)
      : super(AuthenticationStatus.unauthenticated);

  @override
  List<Object> get props => [message];
}
