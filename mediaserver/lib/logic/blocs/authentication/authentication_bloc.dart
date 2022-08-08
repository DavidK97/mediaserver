import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/data.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(const AuthenticationInitial()) {
    on<OnAuthenticationStatusChanged>((event, emit) {
      emit(const Authenticating());
      if (event.user.username == 'MSPC' &&
          event.user.password == 'rootaccess') {
        emit(const Authenticated());
      } else {
        emit(const Unauthenticated('Username oder Passwort falsch!'));
      }
    });
  }
}
