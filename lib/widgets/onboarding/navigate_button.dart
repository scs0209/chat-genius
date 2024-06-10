import 'package:chat_genius/screen/chat_screen.dart';
import 'package:flutter/material.dart';

class NavigateButton extends StatelessWidget {
  const NavigateButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ChatScreen()),
          (route) => false,
        );
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 32,
        ),
        backgroundColor: Colors.blue,
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Continue',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Icon(
            Icons.arrow_forward,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
