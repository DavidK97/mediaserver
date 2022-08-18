import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediaserver/logic/blocs/manage_media/manage_media_bloc.dart';

import '../../../../data/data.dart';
import '../../../../logic/blocs/album/album_bloc.dart';
import '../../../../logic/blocs/creator/creator_bloc.dart';
import '../../../../logic/blocs/tag/tag_bloc.dart';
import '../../../widgets/ms_albums_filter.dart';
import '../../../widgets/ms_creators_filter.dart';
import '../../../widgets/ms_tags_filter.dart';

class MSEditMediaDialog extends StatefulWidget {
  final Media media;
  final VoidCallback onClosePressed;
  const MSEditMediaDialog(this.media, {required this.onClosePressed, Key? key})
      : super(key: key);

  @override
  State<MSEditMediaDialog> createState() => _MSEditMediaDialogState();
}

class _MSEditMediaDialogState extends State<MSEditMediaDialog> {
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _albumController = TextEditingController();
  final TextEditingController _creatorController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {},
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.shade800),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Bearbeiten',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        IconButton(
                          onPressed: widget.onClosePressed,
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                hintText: 'Filter Tags...',
                                prefixIcon: const Icon(Icons.search),
                                contentPadding: const EdgeInsets.all(0),
                              ),
                              controller: _tagController,
                              onChanged: (val) {
                                setState(() {});
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            BlocProvider(
                              create: (context) => TagBloc(TagRepository()),
                              child: MSTagsFilter(
                                _tagController.text,
                                onAddTag: (val) {
                                  setState(() {
                                    BlocProvider.of<ManageMediaBloc>(context)
                                        .add(AddTagToMedia(
                                            widget.media.id, val));
                                    widget.media.tags.add(val);
                                  });
                                },
                                onRemoveTag: (val) {
                                  setState(() {
                                    BlocProvider.of<ManageMediaBloc>(context)
                                        .add(RemoveTagFromMedia(
                                            widget.media.id, val));
                                    widget.media.tags.remove(val);
                                  });
                                },
                                selectedTags: widget.media.tags,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                hintText: 'Filter Creators...',
                                prefixIcon: const Icon(Icons.search),
                                contentPadding: const EdgeInsets.all(0),
                              ),
                              controller: _creatorController,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            BlocProvider(
                              create: (context) =>
                                  CreatorBloc(CreatorRepository()),
                              child: MSCreatorsFilter(
                                _creatorController.text,
                                onAddCreator: (creator) => setState(() {
                                  BlocProvider.of<ManageMediaBloc>(context).add(
                                      AddCreatorToMedia(
                                          widget.media.id, creator));
                                  widget.media.creators.add(creator);
                                }),
                                onRemoveCreator: (creator) => setState(() {
                                  BlocProvider.of<ManageMediaBloc>(context).add(
                                      RemoveCreatorFromMedia(
                                          widget.media.id, creator));
                                  widget.media.creators.remove(creator);
                                }),
                                selectedCreators: widget.media.creators,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                hintText: 'Filter Albums...',
                                prefixIcon: const Icon(Icons.search),
                                contentPadding: const EdgeInsets.all(0),
                              ),
                              controller: _albumController,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            BlocProvider(
                              create: (context) => AlbumBloc(AlbumRepository()),
                              child: MSAlbumsFilter(
                                _albumController.text,
                                onAddAlbum: (album) => setState(() {
                                  BlocProvider.of<ManageMediaBloc>(context).add(
                                      AddMediaToAlbum(widget.media.id, album));
                                  widget.media.albums.add(album);
                                }),
                                onRemoveAlbum: (album) => setState(() {
                                  BlocProvider.of<ManageMediaBloc>(context).add(
                                      RemoveMediaFromAlbum(
                                          widget.media.id, album));
                                  widget.media.albums.remove(album);
                                }),
                                selectedAlbums: widget.media.albums,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
