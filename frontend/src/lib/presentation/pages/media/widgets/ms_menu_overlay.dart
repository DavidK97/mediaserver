import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/cubits/menu/menu_cubit.dart';

class MSMenuOverlay extends StatefulWidget {
  final VoidCallback onEditPressed;
  final VoidCallback onFavoritePressed;
  final VoidCallback onDeletePressed;
  final bool isFavorite;

  const MSMenuOverlay(
      {required this.onEditPressed,
      required this.onFavoritePressed,
      required this.onDeletePressed,
      required this.isFavorite,
      Key? key})
      : super(key: key);

  @override
  State<MSMenuOverlay> createState() => _MSMenuOverlayState();
}

class _MSMenuOverlayState extends State<MSMenuOverlay> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuCubit, bool>(
      builder: (context, state) {
        return Visibility(
          visible: state,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: widget.onFavoritePressed,
                        icon: Icon((widget.isFavorite)
                            ? Icons.favorite
                            : Icons.favorite_border),
                      ),
                      IconButton(
                        onPressed: widget.onDeletePressed,
                        icon: const Icon(Icons.delete),
                      ),
                      IconButton(
                        onPressed: widget.onEditPressed,
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
