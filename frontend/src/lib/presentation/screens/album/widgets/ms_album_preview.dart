import 'package:flutter/material.dart';
import 'package:mediaserver/data/models/album_info.dart';

import '../../../../config/constants/ms_urls.dart';

class MSAlbumPreview extends StatelessWidget {
  final AlbumInfo albumInfo;
  const MSAlbumPreview(this.albumInfo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          child: Stack(
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: Image.network(
                  MSUrls.mediaThumb(albumInfo.preview),
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(Icons.error_outline),
                          Text('Keine Vorschau gefunden'),
                        ],
                      ),
                    );
                  },
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(albumInfo.name),
        Text('${albumInfo.count} Elemente')
      ],
    );
  }
}
