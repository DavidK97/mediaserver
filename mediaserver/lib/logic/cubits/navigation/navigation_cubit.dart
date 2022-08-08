import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediaserver/config/config.dart';

class NavigationCubit extends Cubit<String> {
  NavigationCubit() : super(Routes.gallery);

  navigateTo(String route) {
    emit(route);
  }
}
