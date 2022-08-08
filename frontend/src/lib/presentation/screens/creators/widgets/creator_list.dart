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
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Creators'),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Wrap(
                    children: filteredCreators
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: InputChip(
                              avatar: const Icon(Icons.remove),
                              label: Text(e),
                              onSelected: (val) => onDeleteCreator.call(e),
                            ),
                          ),
                        )
                        .toList(),
                  ),
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
