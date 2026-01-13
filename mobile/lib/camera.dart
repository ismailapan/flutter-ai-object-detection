import 'package:bitirme_project/infoFruit.dart';
import 'package:bitirme_project/model/detection_result.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

Interpreter? interpreter;
List<String> labels = [];

class cameraScreen extends StatefulWidget {
  const cameraScreen({super.key});

  @override
  State<cameraScreen> createState() => _cameraScreenState();
}

class _cameraScreenState extends State<cameraScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool ready = false;

  @override
  void initState() {
    super.initState();
    loadModelAndLabels();
    initCamera();
  }

  Future<void> loadModelAndLabels() async {
    labels = (await rootBundle.loadString("assets/models/labels.txt")).split("\n");
    interpreter = await Interpreter.fromAsset("assets/models/best_float32.tflite");
    print("Model Loaded Successfully");

    var inputTensor = interpreter!.getInputTensor(0);
    print("INPUT SHAPE = ${inputTensor.shape}");
    print("INPUT TYPE  = ${inputTensor.type}");

    var outputTensor = interpreter!.getOutputTensor(0);
    print("OUTPUT SHAPE = ${outputTensor.shape}");
    print("OUTPUT TYPE  = ${outputTensor.type}");

  }

  Future<void> initCamera() async {
    _cameras = await availableCameras();

    _cameraController = CameraController(
      _cameras![0],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController!.initialize();

    setState(() => ready = true);
  }

  img.Image fixToRGB(img.Image src) {
    final rgb = img.Image(width: src.width, height: src.height);
  
    for (int y = 0; y < src.height; y++) {
      for (int x = 0; x < src.width; x++) {
        final p = src.getPixel(x, y);

        rgb.setPixelRgba(
          x,
          y,
          p.r, 
          p.g, 
          p.b, 
          255, 
        );
      }
    }

    return rgb;
  }

  img.Image letterbox(
  img.Image src, {
  int targetSize = 640,
  int padColor = 114, // YOLO default gray
}) {
  final srcW = src.width;
  final srcH = src.height;

  // Ölçek oranı
  final scale = targetSize / (srcW > srcH ? srcW : srcH);

  final newW = (srcW * scale).round();
  final newH = (srcH * scale).round();

  // Oranı bozmadan resize
  final resized = img.copyResize(
    src,
    width: newW,
    height: newH,
    interpolation: img.Interpolation.linear,
  );

  // 640x640 boş canvas
  final canvas = img.Image(
    width: targetSize,
    height: targetSize,
  );

  // Arka planı doldur
  img.fill(canvas, color: img.ColorRgb8(114, 114, 114));

  // Padding hesapla (ortala)
  final dx = ((targetSize - newW) / 2).round();
  final dy = ((targetSize - newH) / 2).round();

  // Resized görüntüyü canvas ortasına yapıştır
  img.compositeImage(
    canvas,
    resized,
    dstX: dx,
    dstY: dy,
  );

  return canvas;
}


  Future<DetectionResult> runModelOnImage(String imagePath) async {
    final fileBytes = await File(imagePath).readAsBytes();
    img.Image? original = img.decodeImage(fileBytes);

    original = fixToRGB(original!);

    //final resized = img.copyResize(original, width: 640, height: 640);
    final letterboxed = letterbox(original);

    final input = List.generate(
      1,
      (_) => List.generate(640, (y) {
        return List.generate(640, (x) {
          final p = letterboxed.getPixel(x, y);
          return [
            p.r / 255.0,
            p.g / 255.0,
            p.b / 255.0,
          ];
        });
      }),
    );

    final output = List.generate(
      1,
      (_) => List.generate(14, (_) => List.filled(8400, 0.0)),
    );

    interpreter!.run(input, output);

    final preds = parseYolo(output);
    if (preds.isEmpty) return DetectionResult("No detected", 0.0);

    return DetectionResult(
      getTopLabel(preds),
      getTopConfidence(preds),
    );
  }

  List<List<double>> parseYolo(List output) {
    List<List<double>> results = [];
    final channels = output[0].length;
    final numBoxes = output[0][0].length;

    for (int i = 0; i < numBoxes; i++) {
      //double obj = output[0][4][i];
      //if (obj < 0.25) continue;

      double bestScore = 0;
      int bestClass = -1;

      for (int c = 5; c < channels; c++) {
        double score = output[0][c][i];
        if (score > bestScore) {
          bestScore = score;
          bestClass = c - 5;
        }
      }

      if (bestClass > 0.15) {
        results.add([bestClass.toDouble(), bestScore]);
      }
    }

    return results;
  }

  String getTopLabel(List<List<double>> preds) {
    preds.sort((a, b) => b[1].compareTo(a[1]));
    return labels[preds.first[0].toInt()];
  }

  double getTopConfidence(List<List<double>> preds) {
    preds.sort((a, b) => b[1].compareTo(a[1]));
    return preds.first[1];
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ready
          ? Stack(
              children: [
                Align(
                  alignment: Alignment.center,             
                    child: SizedBox(  
                      child: AspectRatio(
                        aspectRatio: 4/6,
                        child: CameraPreview(_cameraController!),
                      ),
                    ),
                ),
                Padding(
                  padding: EdgeInsets.all(25),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () async {
                        final XFile file = await _cameraController!.takePicture();
                        final result = await runModelOnImage(file.path);
                        print("Final result = ${result.label}, ${result.confidence}");
                  
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (_) => Infofruit(
                            fruitName: result.label,
                            conf: result.confidence,
                          )));
                      },
                      child:  _shutterButton(),
                    ),
                  ),
                )
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

Widget _shutterButton(){
  return Container(
    height: 78,
    width: 78,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withOpacity(0.18),
      border: Border.all(color: Colors.white60, width: 4)
    ),
  );
}
