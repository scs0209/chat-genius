import 'package:chat_genius/provider/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({
    super.key,
    required this.currentTheme,
    required this.ref,
  });

  final ThemeMode currentTheme;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 1,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset('assets/gpt-robot.png'),
              const SizedBox(
                width: 10,
              ),
              Text(
                "Gemini Gpt",
                style: Theme.of(context).textTheme.titleLarge,
              )
            ],
          ),
          GestureDetector(
            child: currentTheme == ThemeMode.dark
                ? Icon(
                    Icons.light_mode,
                    color: Theme.of(context).colorScheme.secondary,
                  )
                : const Icon(
                    Icons.dark_mode,
                    color: Colors.black54,
                  ),
            onTap: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
