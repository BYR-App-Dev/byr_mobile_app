import 'dart:typed_data';

class ImageFile {
  String ext;
  Uint8List bytes;
  String path;
  ImageFile({
    this.ext,
    this.bytes,
    this.path,
  });
}
