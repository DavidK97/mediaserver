import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/blocs/creator/creator_bloc.dart';
import 'widgets/creator_list.dart';

class CreatorsScreen extends StatefulWidget {
  const CreatorsScreen({Key? key}) : super(key: key);

  @override
  State<CreatorsScreen> createState() => _CreatorsScreenState();
}

class _CreatorsScreenState extends State<CreatorsScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
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
          onChanged: (val) => setState(() {}),
          onSubmitted: (val) =>
              BlocProvider.of<CreatorBloc>(context).add(AddCreator(val)),
        ),
        const SizedBox(
          height: 10,
        ),
        CreatorList(
          _controller.text,
          onDeleteCreator: (creator) => _showAction(
              context,
              "Creator '$creator' entfernen?",
              () => BlocProvider.of<CreatorBloc>(context)
                  .add(RemoveCreator(creator))),
        ),
      ],
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
