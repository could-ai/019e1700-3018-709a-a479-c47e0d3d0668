import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const LinearRegressionApp());
}

class LinearRegressionApp extends StatelessWidget {
  const LinearRegressionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Regresi Linear',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const RegressionHomePage(),
      },
    );
  }
}

class RegressionHomePage extends StatefulWidget {
  const RegressionHomePage({super.key});

  @override
  State<RegressionHomePage> createState() => _RegressionHomePageState();
}

class _RegressionHomePageState extends State<RegressionHomePage> {
  // Titik-titik data awal
  List<Point<double>> points = [
    const Point(10, 20),
    const Point(20, 40),
    const Point(30, 50),
    const Point(40, 70),
    const Point(50, 80),
  ];

  RegressionResult? result;

  @override
  void initState() {
    super.initState();
    _calculateRegression();
  }

  void _calculateRegression() {
    if (points.length < 2) {
      setState(() {
        result = null;
      });
      return;
    }

    double sumX = 0;
    double sumY = 0;
    double sumXY = 0;
    double sumX2 = 0;
    int n = points.length;

    for (var p in points) {
      sumX += p.x;
      sumY += p.y;
      sumXY += p.x * p.y;
      sumX2 += p.x * p.x;
    }

    double denominator = (n * sumX2 - sumX * sumX);
    if (denominator == 0) {
      setState(() {
        result = null;
      });
      return;
    }

    double m = (n * sumXY - sumX * sumY) / denominator;
    double b = (sumY - m * sumX) / n;

    // Menghitung R-squared (Koefisien Determinasi)
    double meanY = sumY / n;
    double ssTot = 0; // Total sum of squares
    double ssRes = 0; // Residual sum of squares

    for (var p in points) {
      double predictedY = m * p.x + b;
      ssTot += pow(p.y - meanY, 2);
      ssRes += pow(p.y - predictedY, 2);
    }

    double rSquared = ssTot == 0 ? 1.0 : 1 - (ssRes / ssTot);
    double percentage = rSquared * 100;

    setState(() {
      result = RegressionResult(m: m, b: b, rSquared: rSquared, percentage: percentage);
    });
  }

  void _addPoint(TapUpDetails details, BoxConstraints constraints) {
    // Mengubah koordinat layar ke koordinat grafik
    // Kita asumsikan X dari 0 sampai 100, Y dari 0 sampai 100 untuk kesederhanaan pada tampilan grafik
    double chartWidth = constraints.maxWidth;
    double chartHeight = constraints.maxHeight;

    double x = (details.localPosition.dx / chartWidth) * 100;
    double y = 100 - ((details.localPosition.dy / chartHeight) * 100);

    setState(() {
      points.add(Point(x, y));
    });
    _calculateRegression();
  }

  void _clearPoints() {
    setState(() {
      points.clear();
      result = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garis Best Fit & Regresi'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearPoints,
            tooltip: 'Hapus Semua Titik',
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Hasil Regresi Linear',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    if (result != null) ...[
                      Text('Persamaan: Y = ${result!.m.toStringAsFixed(2)}X + ${result!.b.toStringAsFixed(2)}'),
                      Text(
                        'Kecocokan (R²): ${result!.percentage.toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: result!.percentage > 70 ? Colors.green : Colors.orange,
                        ),
                      ),
                    ] else ...[
                      const Text('Tambahkan minimal 2 titik data yang berbeda'),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Sentuh area grafik di bawah untuk menambahkan titik data'),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GestureDetector(
                    onTapUp: (details) => _addPoint(details, constraints),
                    child: CustomPaint(
                      size: Size(constraints.maxWidth, constraints.maxHeight),
                      painter: RegressionPainter(points, result),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RegressionResult {
  final double m;
  final double b;
  final double rSquared;
  final double percentage;

  RegressionResult({
    required this.m,
    required this.b,
    required this.rSquared,
    required this.percentage,
  });
}

class RegressionPainter extends CustomPainter {
  final List<Point<double>> points;
  final RegressionResult? result;

  RegressionPainter(this.points, this.result);

  @override
  void paint(Canvas canvas, Size size) {
    final pointPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final linePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;

    // Gambar Grid
    for (int i = 0; i <= 10; i++) {
      double x = (size.width / 10) * i;
      double y = (size.height / 10) * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Fungsi konversi koordinat nilai (0-100) ke ukuran kanvas
    Offset getOffset(Point<double> p) {
      double x = (p.x / 100) * size.width;
      double y = size.height - ((p.y / 100) * size.height);
      return Offset(x, y);
    }

    // Gambar titik
    for (var p in points) {
      canvas.drawPoints(PointMode.points, [getOffset(p)], pointPaint);
    }

    // Gambar garis best fit
    if (result != null) {
      // Titik X = 0
      double y1 = result!.b;
      // Titik X = 100
      double y2 = result!.m * 100 + result!.b;

      Offset startLine = getOffset(Point(0, y1));
      Offset endLine = getOffset(Point(100, y2));

      canvas.drawLine(startLine, endLine, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant RegressionPainter oldDelegate) {
    return true;
  }
}
