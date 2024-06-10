import 'package:chat_genius/model/message.dart';
import 'package:chat_genius/provider/theme_notifier.dart';
import 'package:chat_genius/widgets/chat/chat_app_bar.dart';
import 'package:chat_genius/widgets/chat/message_lists.dart';
import 'package:chat_genius/widgets/chat/user_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  bool _isLoading = false;

  callGeminiModel() async {
    try {
      if (_controller.text.isNotEmpty) {
        _messages.add(Message(text: _controller.text, isUser: true));
        _isLoading = true;
      }

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
    } catch (e) {
      debugPrint("Error : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: ChatAppBar(currentTheme: currentTheme, ref: ref),
      body: Column(
        children: [
          Expanded(
            child: MessageLists(messages: _messages),
          ),

          // user input
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
