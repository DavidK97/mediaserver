part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class OnAuthenticationStatusChanged extends AuthenticationEvent {
  final User user;

  const OnAuthenticationStatusChanged(this.user);
}
