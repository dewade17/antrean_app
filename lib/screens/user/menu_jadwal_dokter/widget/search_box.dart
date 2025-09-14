import 'package:antrean_app/provider/dokter/dokter_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController searchController;
  const SearchBox({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: searchController,
        onChanged: (value) {
          // set query ke provider (tanpa debounce, sesuai permintaan)
          context.read<DokterProvider>().setSearch(value);
        },
        decoration: InputDecoration(
          hintText: 'Cari dokter...',
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
