import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final String data;

  const EmptyView(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(data));
  }
}
