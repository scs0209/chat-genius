import 'package:chat_genius/bloc/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_genius/model/message.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class BlocChatScreen extends StatefulWidget {
  const BlocChatScreen({Key? key}) : super(key: key);

  @override
  State<BlocChatScreen> createState() => _BlocChatScreenState();
}

class _BlocChatScreenState extends State<BlocChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  bool _isLoading = false;

  callGeminiModel() async {
    try {
      if (_controller.text.isNotEmpty) {
        setState(() {
          _messages.add(Message(text: _controller.text, isUser: true));
          _isLoading = true;
        });

        final model = GenerativeModel(
            model: 'gemini-pro', apiKey: dotenv.env['GOOGLE_API_KEY']!);
        final prompt = _controller.text.trim();
        final content = [Content.text(prompt)];
        final response = await model.generateContent(content);

        setState(() {
          _messages.add(Message(text: response.text!, isUser: false));
          _isLoading = false;
        });
        _controller.clear();
      }
    } catch (e) {
      debugPrint("Error : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: ChatAppBar(),
      body: Column(
        children: [
          Expanded(child: MessageList(messages: _messages)),
          UserInput(
            controller: _controller,
            isLoading: _isLoading,
            onSend: callGeminiModel,
          ),
        ],
      ),
    );
  }
}

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final currentTheme = context.watch<ThemeCubit>().state;

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
              const SizedBox(width: 10),
              Text(
                "Gemini Gpt",
                style: Theme.of(context).textTheme.titleLarge,
              ),
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
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class MessageList extends StatelessWidget {
  final List<Message> messages;

  const MessageList({required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return MessageBubble(message: message);
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Align(
        alignment:
            message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: message.isUser
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            message.text,
            style: message.isUser
                ? Theme.of(context).textTheme.bodyMedium
                : Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}

class UserInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSend;

  const UserInput({
    required this.controller,
    required this.isLoading,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 32, top: 16.0, left: 16.0, right: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: Theme.of(context).textTheme.titleSmall,
                decoration: InputDecoration(
                  hintText: 'Write your messages',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
            SizedBox(width: 8),
            isLoading
                ? Padding(
                    padding: EdgeInsets.all(8),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      child: Image.asset('assets/send.png'),
                      onTap: onSend,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
