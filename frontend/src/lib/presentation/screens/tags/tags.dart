import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediaserver/presentation/screens/tags/widgets/tags_list.dart';

import '../../../logic/blocs/tag/tag_bloc.dart';

class TagsScreen extends StatefulWidget {
  const TagsScreen({Key? key}) : super(key: key);

  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                hintText: 'Tag...',
                prefixIcon: const Icon(Icons.tag),
                contentPadding: const EdgeInsets.all(0),
              ),
              controller: _controller,
              focusNode: _focus,
              onChanged: (val) => setState(() {}),
              onSubmitted: (val) {
                BlocProvider.of<TagBloc>(context).add(AddTag(val));
                _focus.requestFocus();
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TagList(
              _controller.text,
              onDeleteTag: (tag) => _showAction(
                  context,
                  "Tag '$tag' entfernen?",
                  () => BlocProvider.of<TagBloc>(context).add(RemoveTag(tag))),
            ),
          ],
        ),
      ),
    );
  }

  void _showAction(
      BuildContext context, String message, VoidCallback onSubmit) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                onSubmit.call();
                Navigator.of(context).pop();
              },
              child: const Text('Weiter'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Abbrechen'),
            ),
          ],
        );
      },
    );
  }
}
