import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/blocs/tag/tag_bloc.dart';

class MSTagsFilter extends StatefulWidget {
  final String input;
  final Function(String tag) onAddTag;
  final Function(String tag) onRemoveTag;
  final List<String> selectedTags;

  const MSTagsFilter(
    this.input, {
    required this.onAddTag,
    required this.onRemoveTag,
    required this.selectedTags,
    Key? key,
  }) : super(key: key);

  @override
  State<MSTagsFilter> createState() => _MSTagsFilterState();
}

class _MSTagsFilterState extends State<MSTagsFilter> {
  late List<String> selectedTags = widget.selectedTags;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TagBloc>(context).add(FetchTags());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagBloc, TagState>(
      builder: ((context, state) {
        if (state is TagsLoaded) {
          List<String> filteredTags = state.tags
              .where((element) => element.startsWith(widget.input))
              .where((element) => !selectedTags.contains(element))
              .take(20)
              .toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Auswahl'),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: (selectedTags.isNotEmpty)
                    ? Row(
                        children: selectedTags
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: InputChip(
                                  avatar: const Icon(Icons.remove),
                                  label: Text(e),
                                  onSelected: (val) =>
                                      widget.onRemoveTag.call(e),
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
                child: (filteredTags.isNotEmpty)
                    ? Row(
                        children: filteredTags
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: InputChip(
                                  avatar: const Icon(Icons.add),
                                  label: Text(e),
                                  onSelected: (val) => widget.onAddTag.call(e),
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
