import 'package:chat_genius/bloc/cubit/theme_cubit.dart';
import 'package:chat_genius/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screen/bloc_onboarding_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  runApp(
    BlocProvider(
      create: (context) => ThemeCubit(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          title: 'Flutter Demo',
          themeMode: themeMode,
          theme: lightMode,
          darkTheme: darkMode,
          home: BlocOnboardingScreen(),
        );
      },
    );
  }
}
