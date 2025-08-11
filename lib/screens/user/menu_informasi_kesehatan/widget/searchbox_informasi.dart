import 'package:flutter/material.dart';

class SearchboxInformasi extends StatelessWidget {
  final TextEditingController searchController;
  const SearchboxInformasi({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: searchController,
        onChanged: (value) {
          print("Search: $value"); // Ganti dengan logika pencarian kamu
        },
        decoration: InputDecoration(
          hintText: 'Cari Informasi...',
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
