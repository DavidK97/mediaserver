import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/blocs/tag/tag_bloc.dart';

class TagList extends StatelessWidget {
  final String input;
  final Function(String tag) onDeleteTag;

  const TagList(this.input, {required this.onDeleteTag, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagBloc, TagState>(
      builder: ((context, state) {
        if (state is TagsLoaded) {
          List<String> filteredTags = state.tags
              .where((element) => element.startsWith(input))
              .take(40)
              .toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tags'),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Wrap(
                  runSpacing: 10.0,
                  children: filteredTags
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: InputChip(
                            avatar: const Icon(Icons.remove),
                            label: Text(e),
                            onSelected: (val) => onDeleteTag.call(e),
                          ),
                        ),
                      )
                      .toList(),
                ),
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
