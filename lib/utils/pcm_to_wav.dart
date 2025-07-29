import 'dart:typed_data';
import 'dart:convert';

Uint8List pcmToWav({
  required Uint8List pcmBytes,
  int sampleRate = 24000,
  int channels = 1,
  int bitsPerSample = 16,
}) {
  final byteRate = sampleRate * channels * bitsPerSample ~/ 8;
  final blockAlign = channels * bitsPerSample ~/ 8;
  final subchunk2Size = pcmBytes.length;
  final chunkSize = 36 + subchunk2Size;

  final header = BytesBuilder();
  header.add(ascii.encode('RIFF'));
  header.add(_intToBytes(chunkSize, 4));
  header.add(ascii.encode('WAVE'));

  header.add(ascii.encode('fmt '));
  header.add(_intToBytes(16, 4));
  header.add(_intToBytes(1, 2));
  header.add(_intToBytes(channels, 2));
  header.add(_intToBytes(sampleRate, 4));
  header.add(_intToBytes(byteRate, 4));
  header.add(_intToBytes(blockAlign, 2));
  header.add(_intToBytes(bitsPerSample, 2));

  header.add(ascii.encode('data'));
  header.add(_intToBytes(subchunk2Size, 4));

  final wavBytes = BytesBuilder();
  wavBytes.add(header.toBytes());
  wavBytes.add(pcmBytes);

  return wavBytes.toBytes();
}

Uint8List _intToBytes(int value, int byteCount) {
  final bytes = ByteData(byteCount);
  if (byteCount == 2) {
    bytes.setInt16(0, value, Endian.little);
  } else if (byteCount == 4) {
    bytes.setInt32(0, value, Endian.little);
  } else {
    throw ArgumentError('Only 2 or 4 byte sizes supported');
  }
  return bytes.buffer.asUint8List();
}
