import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;

  SearchWidget({required this.hintText, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
