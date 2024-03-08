import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class NullPoint extends Point {
  NullPoint() : super(Offset.zero, Colors.transparent, 0.0);
}

class Point {
  Offset offset;
  Color color;
  double strokeWidth;

  Point(this.offset, this.color, this.strokeWidth);
}

class DrawPage extends StatefulWidget {
  @override
  _DrawPageState createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  List<Point> points = [];
  Color selectedColor = Colors.black;
  double strokeWidth = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drawing Page'),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            points.add(Point(
              renderBox.globalToLocal(details.globalPosition),
              selectedColor,
              strokeWidth,
            ));
          });
        },
        onPanEnd: (details) {
          points.add(NullPoint()); // Add a NullPoint when touch is lifted
        },
        child: CustomPaint(
          painter: DrawingPainter(points),
          size: Size.infinite,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.color_lens),
              onPressed: () => _selectColor(context),
            ),
            _buildColorTemplates(),
            Container(
              width: 100,
              child: _buildStrokeSlider(),
            ),
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => setState(() => points.clear()),
            ),
          ],
        ),
      ),
    );
  }

  void _selectColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() => selectedColor = color);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildColorTemplates() {
    List<Color> colors = [
      // Colors.black,
      Colors.red,
      Colors.green,
      Colors.blue,
      // Colors.yellow,
      // Colors.purple,
    ];

    return Row(
      children: colors
          .map((color) => IconButton(
                icon: Icon(Icons.circle),
                color: color,
                onPressed: () {
                  setState(() => selectedColor = color);
                },
              ))
          .toList(),
    );
  }

  Widget _buildStrokeSlider() {
    return Slider(
      value: strokeWidth,
      min: 1.0,
      max: 20.0,
      onChanged: (value) {
        setState(() {
          strokeWidth = value;
        });
      },
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Point> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] is NullPoint || points[i + 1] is NullPoint) {
        continue; // Skip drawing a line if either point is a NullPoint
      }

      Paint paint = Paint()
        ..color = points[i].color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = points[i].strokeWidth;

      canvas.drawLine(points[i].offset, points[i + 1].offset, paint);
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
