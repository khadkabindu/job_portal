import 'package:flutter/material.dart';

class JobChip extends StatefulWidget {
  final List<String> jobTags;
  final Function(String) onKeywordTap;

  JobChip(this.jobTags, {required this.onKeywordTap});

  @override
  State<JobChip> createState() => _JobChipState();
}

class _JobChipState extends State<JobChip> {
  late List<String> tags;
  late List<bool> isSelected;

  _JobChipState();

  @override
  void initState() {
    super.initState();
    tags = widget.jobTags;

    isSelected = List<bool>.filled(20, false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 100,
      color: Colors.white,
      child: ListView.builder(
        itemCount: widget.jobTags.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final keyword = widget.jobTags[index];

          return Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSelected[index] = !isSelected[index];
                    widget.onKeywordTap(keyword);
                  });
                },
                child: Chip(
                  backgroundColor: isSelected[index]
                      ? Color(0xff6A9EA0)
                      : Colors.transparent,
                  label: Text(
                    widget.jobTags[index],
                    style: TextStyle(
                      color:
                      isSelected[index] ? Colors.white : Color(0xff6A9EA0),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
            ],
          );
        },
      ),
    );
  }
}