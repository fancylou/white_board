import 'package:flutter/cupertino.dart';
import 'wp_painter.dart';
import 'color_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
  Color _paintColor = blackColor;
  double _paintStokeWidth = 1.0;
  double _bottomBarLeft = 44.0;
//  var lastOr;



  ///旋转屏幕的时候转换位置
//  void rotationPoints(Orientation current, Size size) {
//    if (lastOr != null) {
//      if (lastOr != current && _points!=null) {
//        var newHeight = size.height;
//        var newWidth = size.width;
//        for(var i=0;i<_points.length;i++) {
//          var p = _points[i];
//          if (p == null) {
//            continue;
//          }
//          var old = p.point;
//          //todo 这个有问题
//          //往左旋转 x：（newWidth - oldY） y:(oldX)
//          //往右旋转 x：（oldY） y：（newHeight - oldX）
//          //上下颠倒：x:(newWidth - oldX) y:(newHeight - oldY)
//          p.point = Offset((newWidth - old.dy), (newHeight - old.dx));
//        }
//      }
//    }
//    lastOr = current;
//  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CupertinoPageScaffold(
      child: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            _bottomBarLeft = 16.0;
          } else {
            _bottomBarLeft = 44.0;
          }
          Color color3 = materialColors[0];
          if (_paintColor.value != blackColor.value &&
              _paintColor.value != redColor.value) {
            color3 = _paintColor;
          }
//          rotationPoints(orientation, size);
          return Container(
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
                //黑色按钮
                bottomCircleColorButton(blackColor, 0),
                //红色按钮
                bottomCircleColorButton(redColor, 1),
                //其他颜色
                bottomCircleColorButton(color3, 2),
                //画笔大小
                bottomPencilWidthButton(0),
                bottomPencilWidthButton(1),
                bottomPencilWidthButton(2),
                bottomPencilWidthButton(3),
                bottomPencilWidthButton(4),
                bottomPencilWidthButton(5),
              ],
            ),
          );
        },
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  ///
  /// @param color 按钮颜色
  /// @param index 第一个黑色 第二个红色 第三个选择
  ///
  Widget bottomCircleColorButton(Color color, int index) {
    double left = _bottomBarLeft + index * 48 + 10 * index;
    return Positioned(
      bottom: 44,
      left: left,
      child: GestureDetector(
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
              color: color,
              boxShadow: _paintColor.value == color.value
                  ? [
                      BoxShadow(
                        color: Color(0xFF8E8E93),
                        spreadRadius: 2.0,
                      ),
                    ]
                  : [],
              borderRadius: BorderRadius.all(Radius.circular(24))),
        ),
        onTap: () {
          if (index == 0) {
            _setPaintColor(blackColor);
          } else if (index == 1) {
            _setPaintColor(redColor);
          } else {
            _pickerColor();
          }
        },
      ),
    );
  }

  ///
  /// 笔尖大小
  ///
  Widget bottomPencilWidthButton(int index) {
    double left = _bottomBarLeft + (3 + index) * 48 + 5 * (3 + index) + 20;
    double size = 12.0 + (index * 3);
    double bottom = 44.0 + (48.0 - size) / 2;
    bool isChecked = false;
    switch (index) {
      case 0:
        if (_paintStokeWidth == 1.0) {
          isChecked = true;
        }
        break;
      case 1:
        if (_paintStokeWidth == 2.0) {
          isChecked = true;
        }
        break;
      case 2:
        if (_paintStokeWidth == 3.0) {
          isChecked = true;
        }
        break;
      case 3:
        if (_paintStokeWidth == 6.0) {
          isChecked = true;
        }
        break;
      case 4:
        if (_paintStokeWidth == 9.0) {
          isChecked = true;
        }
        break;
      case 5:
        if (_paintStokeWidth == 12.0) {
          isChecked = true;
        }
        break;
    }
    return Positioned(
      bottom: bottom,
      left: left,
      child: GestureDetector(
        child: Container(
          width: size,
          height: size,
          decoration: ShapeDecoration(
              shape:
                  CircleBorder(side: BorderSide(width: isChecked ? 4.0 : 1.0))
          ),
        ),
        onTap: () {
          switch (index) {
            case 0:
              _paintStokeWidth = 1.0;
              break;
            case 1:
              _paintStokeWidth = 2.0;
              break;
            case 2:
              _paintStokeWidth = 3.0;
              break;
            case 3:
              _paintStokeWidth = 6.0;
              break;
            case 4:
              _paintStokeWidth = 9.0;
              break;
            case 5:
              _paintStokeWidth = 12.0;
              break;
          }
          setState(() {});
        },
      ),
    );
  }

  ///打开颜色选择器
  void _pickerColor() {
    showColorPicker(context, _paintColor, (color) {
      _setPaintColor(color);
    });
  }

  ///设置颜色
  void _setPaintColor(color) {
    if (color != null) {
      setState(() {
        _paintColor = color;
      });
    }
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
