import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediaserver/config/config.dart';
import 'package:mediaserver/logic/blocs/multi_media/multi_media_bloc.dart';
import 'package:mediaserver/logic/cubits/navigation/navigation_cubit.dart';

class MSBottomNavigationBar extends StatefulWidget {
  const MSBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<MSBottomNavigationBar> createState() => _MSBottomNavigationBarState();
}

class _MSBottomNavigationBarState extends State<MSBottomNavigationBar> {
  late int _selectedIndex = 0;

  static const List<String> _routes = [
    Routes.gallery,
    Routes.search,
    Routes.album,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        BlocProvider.of<MultiMediaBloc>(context).add(FetchMediaIds());
      }
      BlocProvider.of<NavigationCubit>(context).navigateTo(_routes[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, String>(
      builder: (context, state) {
        int index = _routes.indexOf(context.read<NavigationCubit>().state);
        _selectedIndex = (index != -1) ? index : _selectedIndex;

        return BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.image_outlined), label: 'Gallery'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Suche'),
            BottomNavigationBarItem(
                icon: Icon(Icons.photo_album_outlined), label: 'Alben'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        );
      },
    );
  }
}
