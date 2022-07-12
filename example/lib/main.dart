import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:easy_load_more/easy_load_more.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Load More',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ExamplePage(title: 'Easy Load More'),
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  int get count => list.length;

  List<int> list = [];

  @override
  void initState() {
    super.initState();

    list.addAll(
      List.generate(20, (i) => i + 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        color: Colors.blue[50],
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: EasyLoadMore(
            isFinished: count >= 60,
            onLoadMore: _loadMore,
            runOnEmptyResult: false,
            child: ListView.separated(
              separatorBuilder: ((context, index) => const SizedBox(
                    height: 20.0,
                  )),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 100.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  child: Text(
                    list[index].toString(),
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
              itemCount: count,
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _loadMore() async {
    log("onLoadMore callback run");

    await Future.delayed(
      const Duration(
        seconds: 0,
        milliseconds: 2000,
      ),
    );

    _loadItems();
    return true;
  }

  Future<void> _refresh() async {
    await Future.delayed(
      const Duration(
        seconds: 0,
        milliseconds: 2000,
      ),
    );

    list.clear();
    _loadItems();
  }

  void _loadItems() {
    log("loading items");

    setState(() {
      list.addAll(List.generate(20, (i) => i + 1));
      log("data count = ${list.length}");
      log("----------");
    });
  }
}
