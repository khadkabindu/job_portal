import 'package:flutter/material.dart';

class SelectedJobChip extends StatefulWidget {
  final List<String> selectedKeys;
  final Function(String) onChipDeleted;
  final VoidCallback onClear;
  SelectedJobChip({required this.selectedKeys, required this.onChipDeleted, required this.onClear});

  @override
  State<SelectedJobChip> createState() => _SelectedJobChipState();
}

class _SelectedJobChipState extends State<SelectedJobChip> {
  @override
  Widget build(BuildContext context) {
    if (widget.selectedKeys.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: widget.selectedKeys.map((key) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Chip(
                    onDeleted: () {
                      setState(() {
                        widget.selectedKeys.remove(key);
                      });
                      widget.onChipDeleted(key);
                    },
                    label: Text(key),
                  ),
                );
              }).toList(),
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    widget.selectedKeys.clear();
                    widget.onClear();

                  });
                },
                child: Text('Clear all')),
          ],
        ),
      );
    }
    return Container(
      height: 0,
      width: 0,
    );
  }
}
