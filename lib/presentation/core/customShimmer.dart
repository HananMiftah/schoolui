import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatefulWidget {
  const CustomShimmer({Key? key}) : super(key: key);

  @override
  State<CustomShimmer> createState() => _CustomShimmerState();
}

class _CustomShimmerState extends State<CustomShimmer> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Color.fromARGB(255, 224, 224, 224),
      highlightColor: Color.fromARGB(255, 245, 245, 245),
      child: ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: const Icon(Icons.person, size: 40, color: Colors.orange),
            title: Text(''),
            subtitle: Text(''),
          ),
        );
      },
    )
    );
  }
}