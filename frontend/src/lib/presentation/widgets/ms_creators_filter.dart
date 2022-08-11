import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/blocs/creator/creator_bloc.dart';

class MSCreatorsFilter extends StatefulWidget {
  final String input;
  final Function(String tag) onAddCreator;
  final Function(String tag) onRemoveCreator;
  final List<String> selectedCreators;

  const MSCreatorsFilter(this.input,
      {required this.onAddCreator,
      required this.onRemoveCreator,
      required this.selectedCreators,
      Key? key})
      : super(key: key);

  @override
  State<MSCreatorsFilter> createState() => _MSCreatorsFilterState();
}

class _MSCreatorsFilterState extends State<MSCreatorsFilter> {
  late List<String> selectedCreators = widget.selectedCreators;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CreatorBloc>(context).add(FetchCreators());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatorBloc, CreatorState>(
      builder: ((context, state) {
        if (state is CreatorsLoaded) {
          List<String> filteredCreators = state.creators
              .where((element) => element.startsWith(widget.input))
              .where((element) => !selectedCreators.contains(element))
              .take(10)
              .toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Auswahl'),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: (selectedCreators.isNotEmpty)
                    ? Row(
                        children: selectedCreators
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: InputChip(
                                  avatar: const Icon(Icons.remove),
                                  label: Text(e),
                                  onSelected: (val) =>
                                      widget.onRemoveCreator.call(e),
                                ),
                              ),
                            )
                            .toList(),
                      )
                    : const Text('-'),
              ),
              const Text('Vorschläge'),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: (filteredCreators.isNotEmpty)
                    ? Row(
                        children: filteredCreators
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: InputChip(
                                  avatar: const Icon(Icons.add),
                                  label: Text(e),
                                  onSelected: (val) =>
                                      widget.onAddCreator.call(e),
                                ),
                              ),
                            )
                            .toList(),
                      )
                    : const Text('-'),
              ),
            ],
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
