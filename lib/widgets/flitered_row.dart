import 'package:flutter/material.dart';

import '../components/filtered_row_component.dart';

class FilteredRow extends StatefulWidget {
  const FilteredRow({
    super.key,
    required this.onChange,
    required this.onTaped,
  });

  final Function(String value) onChange;
  final Function(String value) onTaped;

  @override
  State<FilteredRow> createState() => _FilteredRowState();
}

class _FilteredRowState extends State<FilteredRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 7),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            FilteredRowComponent(
              title: 'Cars',
              imgUrl: 'assets/images/cars.jpg',
              onTap: () {
                widget.onChange('cars');
                widget.onTaped('cars');
              },
            ),
            FilteredRowComponent(
              title: 'Nature',
              imgUrl: 'assets/images/nature.jpg',
              onTap: () {
                widget.onChange('nature');
                widget.onTaped('nature');
              },
            ),
            FilteredRowComponent(
              title: 'WildLife',
              imgUrl: 'assets/images/wildlife.jpg',
              onTap: () {
                widget.onChange('wildLife');
                widget.onTaped('wildLife');
              },
            ),
            FilteredRowComponent(
              title: 'Space',
              imgUrl: 'assets/images/space.jpg',
              onTap: () {
                widget.onChange('space');
                widget.onTaped('space');
              },
            ),
            FilteredRowComponent(
              title: 'Night',
              imgUrl: 'assets/images/night.jpg',
              onTap: () {
                widget.onChange('night');
                widget.onTaped('night');
              },
            ),
            FilteredRowComponent(
              title: 'Roads',
              imgUrl: 'assets/images/roads.jpg',
              onTap: () {
                widget.onChange('roads');
                widget.onTaped('roads');
              },
            ),
          ],
        ),
      ),
    );
  }
}
