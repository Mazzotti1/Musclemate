
import 'package:flutter/material.dart';

class PlaceholderPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 50,),
      Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 200,
            height: 50,
            color: Colors.grey[300],
          ),
        ],
      ),
      SizedBox(height: 10),
      Container(
        width: double.infinity,
        height: 16,
        color: Colors.grey[300],
      ),
      SizedBox(height: 10),
      Container(
        width: double.infinity,
        height: 16,
        color: Colors.grey[300],
      ),
      SizedBox(height: 10),
      Container(
        width: double.infinity,
        height: 16,
        color: Colors.grey[300],
      ),
      SizedBox(height: 50,),
      Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 200,
            height: 50,
            color: Colors.grey[300],
          ),
        ],
      ),
      SizedBox(height: 10),
      Container(
        width: double.infinity,
        height: 16,
        color: Colors.grey[300],
      ),
      SizedBox(height: 10),
      Container(
        width: double.infinity,
        height: 16,
        color: Colors.grey[300],
      ),
      SizedBox(height: 10),
      Container(
        width: double.infinity,
        height: 16,
        color: Colors.grey[300],
      ),
    ],
  ),
);

  }
}
