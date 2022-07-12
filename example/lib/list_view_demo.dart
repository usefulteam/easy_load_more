import 'package:flutter/material.dart';

class ListViewDemo extends StatefulWidget {
  const ListViewDemo({Key? key}) : super(key: key);

  @override
  State<ListViewDemo> createState() => _ListViewDemoState();
}

class _ListViewDemoState extends State<ListViewDemo> {
  var count = 10;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: count + 1,
      itemBuilder: _buildItem,
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index == count) {
      return const Text('No more items');
    }

    return Text(index.toString());
  }
}
