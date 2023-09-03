import 'package:flutter/material.dart';

class AriForm extends StatefulWidget {
  const AriForm({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  State<StatefulWidget> createState() => AriFormState();
}

class AriFormState extends State<AriForm> {
  @override
  Widget build(BuildContext context) {
    List<Widget> elements = [];
    for (var i = 0; i < widget.children.length; i++) {
      elements.add(widget.children[i]);
      if (i != widget.children.length - 1) {
        elements.add(SizedBox(height: 40));
      }
    }

    return Form(
      child: AutofillGroup(
        child: Column(
          children: elements,
        ),
      ),
    );
  }
}
