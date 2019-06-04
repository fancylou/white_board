import 'package:flutter/cupertino.dart';
import 'wp_painter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: CupertinoThemeData(primaryColor: CupertinoColors.white),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<WPPainter> _points = <WPPainter>[];
  Color _paintColor = materialColors[0];
  Color _tempChooseColor = materialColors[0];
  double _paintStokeWidth = 1.0;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double center = (size.width - 48) / 2;
    return CupertinoPageScaffold(
      child: Container(
        constraints: BoxConstraints.expand(),
        child: Stack(
          children: <Widget>[
            GestureDetector(
              child: CustomPaint(
                size: size,
                painter: _MyPainter(_points),
              ),
              onPanUpdate: (detail) {
                RenderBox referenceBox = context.findRenderObject();
                Offset localPosition =
                    referenceBox.globalToLocal(detail.globalPosition);

                setState(() {
                  _points = new List.from(_points)
                    ..add(WPPainter(
                        localPosition, _paintColor, _paintStokeWidth));
                });
              },
              onPanEnd: (detail) => _points.add(null),
            ),
            Positioned(
              bottom: 44,
              left: center,
              child: GestureDetector(
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                      color: _paintColor,
                      borderRadius: BorderRadius.all(Radius.circular(24))),
                ),
                onTap: _changeColor,
              ),
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _changeColor() {
    _tempChooseColor = _paintColor;
    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: Text("选择颜色"),
          content: ColorChooseWidget((color) {
            _tempChooseColor = color;
          }, _paintColor),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('确定'),
              isDefaultAction: true,
              onPressed: () {
                _setPaintColor(_tempChooseColor);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _setPaintColor(color) {
    if (color != null) {
      setState(() {
        _paintColor = color;
      });
    }
  }
}

const List<Color> materialColors = const <Color>[
  Color(0xFFF44336),
  Color(0xFFE91E63),
  Color(0xFF9C27B0),
  Color(0xFF673AB7),
  Color(0xFF3F51B5),
  Color(0xFF2196F3),
  Color(0xFF03A9F4),
  Color(0xFF00BCD4),
  Color(0xFF009688),
  Color(0xFF4CAF50),
  Color(0xFF8BC34A),
  Color(0xFFCDDC39),
  Color(0xFFFFEB3B),
  Color(0xFFFFC107),
  Color(0xFFFF9800),
  Color(0xFFFF5722),
  Color(0xFF795548),
  Color(0xFF9E9E9E),
  Color(0xFF607D8B),
  Color(0xFF000000),
];

class ColorChooseWidget extends StatefulWidget {
  final ValueChanged<Color> onColorChange;
  final Color selectedColor;
  ColorChooseWidget(this.onColorChange, this.selectedColor);

  @override
  State<StatefulWidget> createState() {
    return _ColorChooseWidgetState();
  }
}

class _ColorChooseWidgetState extends State<ColorChooseWidget> {
  static const double _kPadding = 9.0;
  static const double _kContainerPadding = 16.0;
  static const double _kCircleColorSize = 60.0;
  Color _selectedColor = materialColors[0];

  @override
  void initState() {
    _selectedColor =
        widget.selectedColor == null ? materialColors[0] : widget.selectedColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size ;
    final int crossCount = ((270 - _kContainerPadding * 2) / (_kCircleColorSize + _kPadding)).floor();
    print("crosscount: "+crossCount.toString());
    final int row = (materialColors.length / crossCount).floor();
    print("row:"+row.toString());
    double height = (_kCircleColorSize + _kPadding) * row + _kContainerPadding * 2;
    if (height > size.height * 0.7 ) {
      height = size.height * .7;
    }
    print("height:"+height.toString());
    return Container(
        width: 270,
        height: height,
        child: GridView.count(
          padding: const EdgeInsets.all(_kContainerPadding),
          crossAxisSpacing: _kPadding,
          mainAxisSpacing: _kPadding,
          crossAxisCount: crossCount,
          childAspectRatio: 1.0,
          children: _buildListMainColor(materialColors),
        ));
  }

  List<Widget> _buildListMainColor(List<Color> colors) {
    List<Widget> circles = [];
    for (final color in colors) {
      final isSelected = _selectedColor.value == color.value;
      circles.add(_circleColor(color, isSelected));
    }
    return circles;
  }

  Widget _circleColor(Color color, bool isSelected) {
    return GestureDetector(
        onTap: () => _onColorSelected(color),
        child: Container(
          width: _kCircleColorSize,
          height: _kCircleColorSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(_kCircleColorSize/2))),
          child: isSelected ? Icon(CupertinoIcons.check_mark, size: _kCircleColorSize*0.7,) : null,
        ));
  }

  void _onColorSelected(Color color) {
    print("onmain color change " + color.toString());
    if (widget.onColorChange != null) {
      widget.onColorChange(color);
    }
    setState(() {
      _selectedColor = color;
    });
  }
}

class _MyPainter extends CustomPainter {
  _MyPainter(this.points);

  final List<WPPainter> points;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()..strokeCap = StrokeCap.round;

    for (var i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        var wp = points[i];
        var nextWp = points[i + 1];
        paint.color = wp.color;
        paint.strokeWidth = wp.strokeWidth;
        canvas.drawLine(wp.point, nextWp.point, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_MyPainter oldDelegate) {
    return oldDelegate.points != this.points;
  }
}
