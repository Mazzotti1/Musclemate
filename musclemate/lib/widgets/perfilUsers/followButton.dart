import 'package:flutter/material.dart';

class FollowButton extends StatefulWidget {
  final String userName;
  final List<String> nomesFolloweds;

  const FollowButton({required this.userName, required this.nomesFolloweds});

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();

    isFollowing = widget.nomesFolloweds.contains(widget.userName);
  }

  void follow() {

    setState(() {
      isFollowing = true;
    });
  }

  void unfollow() {

    setState(() {
      isFollowing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (isFollowing) {
          unfollow();
        } else {
          follow();
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          isFollowing
              ? Color.fromARGB(209, 240, 225, 91) // cor para unfollow
              : Colors.blue, // cor para follow
        ),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        minimumSize: MaterialStateProperty.all<Size>(const Size(30, 30)),
      ),
      child: Text(isFollowing ? 'Deixar de Seguir' : 'Seguir'),
    );
  }
}
