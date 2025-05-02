import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioPlayerService {
  static AudioPlayer player = AudioPlayer();

  static Future<void> playBase64Audio(Uint8List bytes) async {
    try {
      await player.play(BytesSource(convertPcmToWav(bytes)));
    } catch (e) {
      log(e.toString());
    }
  }

// PCM -> WAV dönüşümü
  static Uint8List convertPcmToWav(Uint8List pcmData) {
    int sampleRate = 44100; // Örnekleme hızı
    int numChannels = 2; // Kanal sayısı (stereo)
    int bitsPerSample = 16; // Her örnek için bit sayısı (16-bit)
    int byteRate = 128000; // Byte rate

    int blockAlign =
        numChannels * (bitsPerSample ~/ 8); // Block align hesaplama

    // WAV başlığı oluşturuluyor
    List<int> wavHeader = [
      0x52, 0x49, 0x46, 0x46, // "RIFF" başlığı
      ..._intToBytes(36 + pcmData.length, 4), // Dosya boyutu
      0x57, 0x41, 0x56, 0x45, // "WAVE" başlığı
      0x66, 0x6D, 0x74, 0x20, // "fmt " başlığı
      0x10, 0x00, 0x00, 0x00, // Subchunk1Size (16)
      0x01, 0x00, // AudioFormat (PCM)
      ..._intToBytes(numChannels, 2), // Kanal sayısı
      ..._intToBytes(sampleRate, 4), // Örnekleme hızı
      ..._intToBytes(byteRate, 4), // Byte rate
      ..._intToBytes(blockAlign, 2), // Block align
      ..._intToBytes(bitsPerSample, 2), // Bits per sample (16-bit)
      0x64, 0x61, 0x74, 0x61, // "data" başlığı
      ..._intToBytes(pcmData.length, 4), // Data chunk boyutu
    ];

    // WAV dosyasının başlığını PCM verisiyle birleştir
    return Uint8List.fromList([...wavHeader, ...pcmData]);
  }

  static List<int> _intToBytes(int value, int byteCount) {
    return List.generate(byteCount, (index) => (value >> (index * 8)) & 0xFF);
  }
}
