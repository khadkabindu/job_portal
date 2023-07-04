import 'package:flutter/material.dart';

class SelectedJobChip extends StatefulWidget {
  final List<String> selectedKeys;
  final Function(String) onChipDeleted;
  SelectedJobChip({required this.selectedKeys, required this.onChipDeleted});

  @override
  State<SelectedJobChip> createState() => _SelectedJobChipState();
}

class _SelectedJobChipState extends State<SelectedJobChip> {


  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        children: widget.selectedKeys.map((key) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Chip(

              onDeleted: () {
                setState(() {
                  widget.selectedKeys.remove(key);
                });
                widget.onChipDeleted(key);
                // setState(() {
                //
                // });
              },
              label: Text(key),

              // Customize the chip as needed
            ),
          );
        }).toList(),
      ),

    );

  }
}