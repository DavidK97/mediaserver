import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/constants/ms_urls.dart';
import '../../../config/routes/routes.dart';
import '../../../data/models/media.dart';
import '../../../logic/blocs/multi_media/multi_media_bloc.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MultiMediaBloc, MultiMediaState>(
      builder: (context, state) {
        if (state is MediaIdsLoadedState) {
          final List<Media> media = state.media;
          return RefreshIndicator(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        (MediaQuery.of(context).size.width / 150).round()),
                itemCount: media.length,
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, Routes.media,
                        arguments: [media, i]),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4.0)),
                        child: Stack(
                          children: [
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: Image.network(
                                MSUrls.mediaThumb(media[i].id),
                                errorBuilder: (context, error, stackTrace) {
                                  return Column(
                                    children: const [
                                      Icon(Icons.error_outline),
                                      Text('Keine Vorschau gefunden'),
                                    ],
                                  );
                                },
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              ),
                            ),
                            Visibility(
                              visible: (media[i].type == 'Video'),
                              child: const Align(
                                alignment: Alignment.topRight,
                                child: Icon(Icons.play_arrow),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              onRefresh: () async {
                BlocProvider.of<MultiMediaBloc>(context).add(FetchMediaIds());
              });
        } else {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
