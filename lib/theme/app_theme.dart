import 'package:flutter/material.dart';

ThemeData buildDarkTheme() {
  const bg = Color(0xFF0B0F14); // deep sporty dark
  const surface = Color(0xFF121821);
  const brand = Color(0xFF0E5F76); // teal‑blue sport
  const accent = Color(0xFFD7263D); // tournament red

  final colorScheme = const ColorScheme.dark().copyWith(
    primary: brand,
    secondary: accent,
    surface: surface,
    background: bg,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: bg,
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 160, fontWeight: FontWeight.w800),
      displayMedium: TextStyle(fontSize: 120, fontWeight: FontWeight.w800),
      headlineLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
    ),
    dividerTheme: DividerThemeData(
      color: Colors.white.withOpacity(.06),
      thickness: 1,
    ),
    cardTheme: CardThemeData(
      color: surface, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
    ),
  );
}
