import 'package:flutter/material.dart';

import '../main.dart';

void main() => runApp(MyApp());

class SubscirbeScreen extends StatefulWidget {
  SubscirbeScreen({Key? key}) : super(key: key);

  @override
  State<SubscirbeScreen> createState() => _SubscirbeScreenState();
}

class _SubscirbeScreenState extends State<SubscirbeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
} 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Container(
            child: Text('Hello World'),
          ),
        ),
      ),
    );
  }
