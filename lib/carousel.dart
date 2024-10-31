// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({
    super.key,
    required this.controller,
  });

  final ScrollController controller;

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> with WidgetsBindingObserver {
  late ScrollController _controller;
  final _carousel = GlobalKey();
  double top = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _controller = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateData();
    });
  }

  @override
  void didChangeMetrics() {
    _updateData();
  }

  void _updateData() {
    if (_carousel.currentContext?.findRenderObject() != null) {
      final renderBox = _carousel.currentContext?.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      setState(() {
        top = position.dy;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _controller,
        child: Row(
          key: _carousel,
          children: List.generate(
            20,
            (index) => _itemCarousel(index: index + 1),
          ),
        ),
      ),
    );
  }

  Widget _itemCarousel({int index = 0}) {
    return Focus(
      autofocus: index == 1 ? true : false,
      onKey: (node, event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
          if (kDebugMode) {
            print("top $top");
          }
          widget.controller.animateTo(
            top + 50,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
          );
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
          widget.controller.animateTo(
            top - 50,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
          );
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          _controller.animateTo(
            _controller.offset + 120 / 1.3 - 8,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
          );
        }
        return KeyEventResult.ignored;
      },
      child: Builder(builder: (context) {
        bool hasFocus = Focus.of(context).hasFocus;
        return Container(
          decoration: BoxDecoration(
            color: index % 2 == 0 ? Colors.blue : Colors.cyan,
            border: Border.all(
              width: hasFocus ? 5 : 0,
              color: hasFocus ? Colors.red : Colors.yellow,
            ),
          ),
          alignment: Alignment.center,
          width: 100,
          height: 100,
          // color: Colors.green,
          child: Text("item $top"),
        );
      }),
    );
  }
}
