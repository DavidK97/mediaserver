import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediaserver/logic/blocs/authentication/authentication_bloc.dart';

import 'app.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthenticationBloc()),
      ],
      child: const App(),
    ),
  );
}
