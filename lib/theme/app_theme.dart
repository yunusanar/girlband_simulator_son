import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static bool dark = true;

  // ── Zemin & yüzeyler (temaya göre) ──
  static Color get background => dark
      ? const Color(0xFF0F040A)
      : const Color(0xFFF1E3F0); // Bizim derin siyah/bordo
  static Color get surface => dark
      ? const Color(0xFF1E0B19)
      : const Color(0xFFFFFFFF); // Bizim koyu kart rengi
  static Color get surfaceHigh =>
      dark ? const Color(0xFF2E1226) : const Color(0xFFF4E7F0);
  static Color get border =>
      dark ? const Color(0xFF4A1340) : const Color(0xFFEAD3E2);
  static Color get ink => dark
      ? const Color(0xFFFFFFFF)
      : const Color(0xFF2E1226); // Koyu modda bembeyaz metin
  static const inkAlways = Color(0xFF2E1226);

  // ── Marka vurguları (bordo + mor + altın) ──
  static const bordo = Color(0xFF9E1F4B); // Bizim canlı şarap bordosu
  static const primary = Color(0xFFA22CDA); // Parlak neon orkide
  static const secondary = Color(0xFFF03A76); // Neon gül
  static const accentBlue = Color(0xFF5A4FCF);
  static const accentCyan = Color(0xFF21B5C4);
  static const gold = Color(0xFFFFC107); // Parlak altın

  // ── Metin (temaya göre) ──
  static Color get textPrimary =>
      dark ? const Color(0xFFFFFFFF) : const Color(0xFF2E1226);
  static Color get textSecondary =>
      dark ? const Color(0xFFD0B8C8) : const Color(0xFF8A6E81);
  static Color get action => dark ? const Color(0xFFE0A9EF) : primary;

  // ── Rarity & Durum ──
  static const rarityCommon = Color(0xFF9AA3AF);
  static const rarityRare = Color(0xFF3DA5E0);
  static const rarityEpic = Color(0xFFA24CE0);
  static const rarityLegendary = Color(0xFFFFC107);
  static const success = Color(0xFF2FA86A);
  static const danger = Color(0xFFE5484D);
  static const warning = Color(0xFFFFC107);

  // ── Gradyanlar ──
  static const _headerGradientLight = LinearGradient(
    colors: [Color(0xFF6E1838), Color(0xFF8C2470), primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  // Bizim Premium Dark başlık gradyanımız
  static const _headerGradientDark = LinearGradient(
    colors: [Color(0xFF3B0D1F), Color(0xFF59114A), Color(0xFF301040)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static LinearGradient get headerGradient =>
      dark ? _headerGradientDark : _headerGradientLight;

  static const buttonGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const goldGradient = LinearGradient(
    colors: [Color(0xFFFFF27E), Color(0xFFFFC107), Color(0xFFD48B00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const _bgGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF7EAF5),
      Color(0xFFF1E3F0),
      Color(0xFFEAD9EC),
      Color(0xFFF4E7F0)
    ],
    stops: [0.0, 0.4, 0.7, 1.0],
  );
  // Bizim Premium Dark zemin gradyanımız
  static const _bgGradientDark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF160314), Color(0xFF2C0B25), Color(0xFF10020D)],
    stops: [0.0, 0.5, 1.0],
  );
  static LinearGradient get bgGradient =>
      dark ? _bgGradientDark : _bgGradientLight;

  static Color get onBgStrong => dark ? Colors.white : textPrimary;
  static Color get onBgSoft => dark ? const Color(0xFFDCC9E4) : textSecondary;
  static Color get onBgAccent => dark ? gold : bordo;
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = AppColors.dark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
      ),
      cardColor: AppColors.surface,
      cardTheme: CardThemeData(
        color: AppColors.dark
            ? AppColors.surface.withAlpha(220)
            : AppColors.surface,
        elevation: AppColors.dark ? 8 : 3,
        shadowColor:
            AppColors.dark ? Colors.black54 : AppColors.primary.withAlpha(40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.border, width: 1.5),
        ),
      ),
      textTheme: GoogleFonts.baloo2TextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.baloo2(
            fontSize: 38,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: 1.2),
        displayMedium: GoogleFonts.baloo2(
            fontSize: 27,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary),
        headlineMedium: GoogleFonts.baloo2(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary),
        headlineSmall: GoogleFonts.baloo2(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary),
        titleMedium: GoogleFonts.baloo2(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary),
        bodyLarge: GoogleFonts.baloo2(
            fontSize: 16,
            color: AppColors.textPrimary,
            height: 1.45,
            fontWeight: FontWeight.w500),
        bodyMedium: GoogleFonts.baloo2(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.4,
            fontWeight: FontWeight.w400),
        labelLarge: GoogleFonts.baloo2(
            fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.3),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle:
              GoogleFonts.baloo2(fontSize: 15, fontWeight: FontWeight.w600),
          elevation: AppColors.dark ? 6 : 3,
          shadowColor: AppColors.primary.withAlpha(110),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.action,
          backgroundColor: AppColors.dark
              ? AppColors.surfaceHigh.withAlpha(150)
              : AppColors.surface,
          side: BorderSide(color: AppColors.action, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle:
              GoogleFonts.baloo2(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.action,
          textStyle: GoogleFonts.baloo2(fontWeight: FontWeight.w600),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.baloo2(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.3),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.inkAlways,
        contentTextStyle: GoogleFonts.baloo2(
            color: Colors.white, fontWeight: FontWeight.w500),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: AppColors.dark ? 24 : 12,
        shadowColor: AppColors.dark
            ? AppColors.primary.withAlpha(100)
            : AppColors.bordo.withAlpha(80),
        titleTextStyle: GoogleFonts.baloo2(
            fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.ink),
        contentTextStyle: GoogleFonts.baloo2(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.ink,
            height: 1.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
              color: AppColors.border, width: AppColors.dark ? 2 : 1.5),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
      ),
      dividerTheme: DividerThemeData(color: AppColors.border, thickness: 1.5),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: AppColors.primary),
      tabBarTheme: TabBarThemeData(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withAlpha(150),
        indicatorColor: AppColors.gold,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle:
            GoogleFonts.baloo2(fontWeight: FontWeight.w700, fontSize: 13),
        unselectedLabelStyle:
            GoogleFonts.baloo2(fontWeight: FontWeight.w500, fontSize: 13),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: AppColors.surfaceHigh,
        selectedColor: AppColors.primary.withAlpha(40),
        side: BorderSide(color: AppColors.border),
        labelStyle: GoogleFonts.baloo2(
            fontWeight: FontWeight.w600, color: AppColors.ink),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static Color rarityColor(String name) {
    switch (name) {
      case 'rare':
        return AppColors.rarityRare;
      case 'epic':
        return AppColors.rarityEpic;
      case 'legendary':
        return AppColors.rarityLegendary;
      default:
        return AppColors.rarityCommon;
    }
  }
}
