import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/blocs/creator/creator_bloc.dart';

class CreatorList extends StatelessWidget {
  final String input;
  final Function(String creator) onDeleteCreator;

  const CreatorList(this.input, {required this.onDeleteCreator, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatorBloc, CreatorState>(
      builder: ((context, state) {
        if (state is CreatorsLoaded) {
          List<String> filteredCreators = state.creators
              .where((element) => element.startsWith(input))
              .take(40)
              .toList();
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: (filteredCreators.isNotEmpty)
                      ? Wrap(
                          runSpacing: 0.0,
                          spacing: 4,
                          children: filteredCreators
                              .map(
                                (e) => InputChip(
                                  avatar: const Icon(Icons.remove),
                                  label: Text(e),
                                  onSelected: (val) => onDeleteCreator.call(e),
                                ),
                              )
                              .toList(),
                        )
                      : const Text('keine Creators gefunden'),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
