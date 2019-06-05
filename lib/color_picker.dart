import 'package:flutter/cupertino.dart';




void showColorPicker(BuildContext context, Color selectedColor, ValueChanged<Color> chooseColor) {
  Color _tempChooseColor = selectedColor;
  showCupertinoDialog(
    context: context,
    builder: (_) {
      return CupertinoAlertDialog(
        title: Text("选择颜色"),
        content: ColorChooseWidget((color) {
          _tempChooseColor = color;
        }, selectedColor),
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
              chooseColor(_tempChooseColor);
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}

Color blackColor = Color(0xFF000000);
Color redColor = Color(0xFFFF3B30);

const List<Color> materialColors = const <Color>[
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
    // 270 是 CupertinoAlertDialog 固定的宽度
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
          children: _buildListColorForGridView(),
        ));
  }

  List<Widget> _buildListColorForGridView() {
    List<Widget> circles = [];
    for (final color in materialColors) {
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
    print("on color change " + color.toString());
    if (widget.onColorChange != null) {
      widget.onColorChange(color);
    }
    setState(() {
      _selectedColor = color;
    });
  }
}
