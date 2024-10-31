import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testfocus/carousel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loading = false;
  ScrollController scrollController = ScrollController();

  FocusNode button1 = FocusNode();
  FocusNode button2 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.bottomCenter,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: List.generate(
              10,
              (index) => CarouselWidget(controller: scrollController),
            ),
          ),
        ),
      ),
    );
  }

  Widget _button(FocusNode focus, {required int index}) {
    return Focus(
      autofocus: true,
      focusNode: focus,
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          button2.requestFocus();
          setState(() {});
        } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          button1.requestFocus();
          setState(() {});
        }
        return KeyEventResult.ignored;
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.orange,
          border: Border.all(
            width: focus.hasFocus ? 5 : 0,
            color: focus.hasFocus ? Colors.red : Colors.yellow,
          ),
        ),
        alignment: Alignment.center,
        width: 100,
        height: 50,
        // color: Colors.green,
        child: Text("Botão $index"),
      ),
    );
  }
}
