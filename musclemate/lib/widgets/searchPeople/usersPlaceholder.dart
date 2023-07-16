
import 'package:flutter/material.dart';

class UsersPlaceholder extends StatelessWidget {
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
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 200,
            height: 25,
            color: Colors.grey[300],

          ),
        ],
      ),
          Padding(
            padding: const EdgeInsets.only(left:80.0),
            child: Container(
              width: 200,
              height: 15,
              color: Colors.grey[300],
            ),
          ),

   SizedBox(height: 50,),
      Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 200,
            height: 25,
            color: Colors.grey[300],

          ),
        ],
      ),
          Padding(
            padding: const EdgeInsets.only(left:80.0),
            child: Container(
              width: 200,
              height: 15,
              color: Colors.grey[300],
            ),
          )
        ]
      )
    );

  }
}
