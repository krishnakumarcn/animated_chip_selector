import 'package:flutter/material.dart';

class AnimatedChipSelector extends StatefulWidget {
  final String label;
  final value;
  final height;
  final MaterialColor dotColor;
  final TextStyle textStyle;

  AnimatedChipSelector(
      {@required this.label,
      this.value,
      @required this.dotColor,
      this.height = 48.0,
      this.textStyle = const TextStyle(
        fontSize: 14.0,
      )});

  @override
  State<StatefulWidget> createState() {
    return _AnimatedChipSelectorState(this.height);
  }
}

class _AnimatedChipSelectorState extends State<AnimatedChipSelector>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _textLeftPaddingAnimation;
  Animation<double> _textRightPaddingAnimation;
  Animation<Color> _textColorAnimation;
  Animation<double> _closeButtonAnimation;
  Animation<double> _dotHeightAnimation;
  Animation<double> _dotLeftPositionAnimation;
  Animation<double> _dotTopPositionAnimation;
  final GlobalKey _parentContainerKey =
      GlobalKey(debugLabel: 'parent container');

  double height;

  _AnimatedChipSelectorState(this.height);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _textLeftPaddingAnimation =
        Tween<double>(begin: 34.0, end: 12.0).animate(_controller);
    _textRightPaddingAnimation =
        Tween<double>(begin: 6.0, end: 12.0).animate(_controller);
    _textColorAnimation =
        ColorTween(begin: Colors.black, end: Colors.white).animate(_controller);
    _closeButtonAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _dotHeightAnimation =
        Tween<double>(begin: height / 2, end: height).animate(_controller);
    _dotLeftPositionAnimation =
        Tween<double>(begin: 6.0, end: 0.0).animate(_controller);
    _dotTopPositionAnimation =
        Tween<double>(begin: 12, end: -1.0).animate(_controller);
  }

  Animation<double> getDotWidthAnimation() {
    var width = height / 2;
    if (_parentContainerKey.currentContext != null) {
      final RenderBox renderBox =
          _parentContainerKey.currentContext.findRenderObject();
      width = renderBox.size.width;
    }

    return Tween<double>(begin: height / 2, end: width - 2)
        .animate(_controller);
  }

  Widget getWidget(BuildContext context, widget) {
    return InkWell(
      onTap: () {
        animationStatus ? _controller.reverse() : _controller.forward();
      },
      child: (Container(
        key: _parentContainerKey,
        height: height,
        constraints: BoxConstraints(maxWidth: 240),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(height / 2)),
          border: Border.all(
              color: animationStatus ? this.widget.dotColor : Colors.black,
              width: 1.0),
        ),
        child: Stack(
          children: <Widget>[
            // circular dot
            Positioned(
              left: _dotLeftPositionAnimation.value,
              top: _dotTopPositionAnimation.value,
              child: Container(
                height: _dotHeightAnimation.value,
                width: getDotWidthAnimation().value,
                decoration: BoxDecoration(
                  color: this.widget.dotColor,
//                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(
                    Radius.circular(height / 2),
                  ),
                ),
              ),
            ),
            Align(
              widthFactor: 1.0,
              alignment: Alignment.center,
              child: Container(
                  padding: EdgeInsets.only(
                      left: _textLeftPaddingAnimation.value,
                      right: _textRightPaddingAnimation.value),
                  child: Text(
                    this.widget.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: this
                        .widget
                        .textStyle
                        .copyWith(color: _textColorAnimation.value),
                  )),
            ),
//            Positioned(
//              right: 5.0,
//              top: 7.0,
//              child: ScaleTransition(
//                scale: _closeButtonAnimation,
//                child: Container(
//                  padding: EdgeInsets.all(2.0),
//                  decoration: BoxDecoration(
//                      shape: BoxShape.circle, color: Colors.grey.shade500),
//                  child: Icon(
//                    Icons.close,
//                    size: 20.0,
//                    color: Colors.white,
//                  ),
//                ),
//              ),
//            )
          ],
        ),
      )),
    );
  }

  bool get animationStatus {
    AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: getWidget,
      animation: _controller,
    );
  }
}
