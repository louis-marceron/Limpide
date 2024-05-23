import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4279003008),
      surfaceTint: Color(4279003008),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4290439935),
      onPrimaryContainer: Color(4278198057),
      secondary: Color(4283196011),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4291815153),
      onSecondaryContainer: Color(4278656550),
      tertiary: Color(4284177278),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4293058559),
      onTertiaryContainer: Color(4279769143),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      background: Color(4294310653),
      onBackground: Color(4279704607),
      surface: Color(4294310653),
      onSurface: Color(4279704607),
      surfaceVariant: Color(4292666600),
      onSurfaceVariant: Color(4282402892),
      outline: Color(4285560957),
      outlineVariant: Color(4290824396),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281086260),
      inverseOnSurface: Color(4293784053),
      inversePrimary: Color(4287221997),
      primaryFixed: Color(4290439935),
      onPrimaryFixed: Color(4278198057),
      primaryFixedDim: Color(4287221997),
      onPrimaryFixedVariant: Color(4278209890),
      secondaryFixed: Color(4291815153),
      onSecondaryFixed: Color(4278656550),
      secondaryFixedDim: Color(4289972949),
      onSecondaryFixedVariant: Color(4281682515),
      tertiaryFixed: Color(4293058559),
      onTertiaryFixed: Color(4279769143),
      tertiaryFixedDim: Color(4291085291),
      onTertiaryFixedVariant: Color(4282664037),
      surfaceDim: Color(4292271070),
      surfaceBright: Color(4294310653),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293981431),
      surfaceContainer: Color(4293586674),
      surfaceContainerHigh: Color(4293192172),
      surfaceContainerHighest: Color(4292797414),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4278208861),
      surfaceTint: Color(4279003008),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4281433496),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4281419343),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4284643458),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4282400864),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4285690261),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      background: Color(4294310653),
      onBackground: Color(4279704607),
      surface: Color(4294310653),
      onSurface: Color(4279704607),
      surfaceVariant: Color(4292666600),
      onSurfaceVariant: Color(4282139720),
      outline: Color(4283981924),
      outlineVariant: Color(4285824128),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281086260),
      inverseOnSurface: Color(4293784053),
      inversePrimary: Color(4287221997),
      primaryFixed: Color(4281433496),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4278543486),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4284643458),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4283064169),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4285690261),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4284045691),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292271070),
      surfaceBright: Color(4294310653),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293981431),
      surfaceContainer: Color(4293586674),
      surfaceContainerHigh: Color(4293192172),
      surfaceContainerHighest: Color(4292797414),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4278199858),
      surfaceTint: Color(4279003008),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4278208861),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4279182637),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4281419343),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4280229694),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4282400864),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      background: Color(4294310653),
      onBackground: Color(4279704607),
      surface: Color(4294310653),
      onSurface: Color(4278190080),
      surfaceVariant: Color(4292666600),
      onSurfaceVariant: Color(4280100137),
      outline: Color(4282139720),
      outlineVariant: Color(4282139720),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281086260),
      inverseOnSurface: Color(4294967295),
      inversePrimary: Color(4292080127),
      primaryFixed: Color(4278208861),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4278202688),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4281419343),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4279906104),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4282400864),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4280887881),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292271070),
      surfaceBright: Color(4294310653),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293981431),
      surfaceContainer: Color(4293586674),
      surfaceContainerHigh: Color(4293192172),
      surfaceContainerHighest: Color(4292797414),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4287221997),
      surfaceTint: Color(4287221997),
      onPrimary: Color(4278203716),
      primaryContainer: Color(4278209890),
      onPrimaryContainer: Color(4290439935),
      secondary: Color(4289972949),
      onSecondary: Color(4280169276),
      secondaryContainer: Color(4281682515),
      onSecondaryContainer: Color(4291815153),
      tertiary: Color(4291085291),
      onTertiary: Color(4281150797),
      tertiaryContainer: Color(4282664037),
      onTertiaryContainer: Color(4293058559),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      background: Color(4279178263),
      onBackground: Color(4292797414),
      surface: Color(4279178263),
      onSurface: Color(4292797414),
      surfaceVariant: Color(4282402892),
      onSurfaceVariant: Color(4290824396),
      outline: Color(4287271574),
      outlineVariant: Color(4282402892),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292797414),
      inverseOnSurface: Color(4281086260),
      inversePrimary: Color(4279003008),
      primaryFixed: Color(4290439935),
      onPrimaryFixed: Color(4278198057),
      primaryFixedDim: Color(4287221997),
      onPrimaryFixedVariant: Color(4278209890),
      secondaryFixed: Color(4291815153),
      onSecondaryFixed: Color(4278656550),
      secondaryFixedDim: Color(4289972949),
      onSecondaryFixedVariant: Color(4281682515),
      tertiaryFixed: Color(4293058559),
      onTertiaryFixed: Color(4279769143),
      tertiaryFixedDim: Color(4291085291),
      onTertiaryFixedVariant: Color(4282664037),
      surfaceDim: Color(4279178263),
      surfaceBright: Color(4281678397),
      surfaceContainerLowest: Color(4278849297),
      // surfaceContainerLow: Color(4279704607),
      surfaceContainerLow: Color(0xFF171C1F),
      surfaceContainer: Color(4279967779),
      surfaceContainerHigh: Color(4280625965),
      surfaceContainerHighest: Color(4281349688),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4287485170),
      surfaceTint: Color(4287221997),
      onPrimary: Color(4278196514),
      primaryContainer: Color(4283538101),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4290301657),
      onSecondary: Color(4278393121),
      secondaryContainer: Color(4286485662),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4291413999),
      onTertiary: Color(4279440177),
      tertiaryContainer: Color(4287532466),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      background: Color(4279178263),
      onBackground: Color(4292797414),
      surface: Color(4279178263),
      onSurface: Color(4294441983),
      surfaceVariant: Color(4282402892),
      onSurfaceVariant: Color(4291087569),
      outline: Color(4288455849),
      outlineVariant: Color(4286350473),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292797414),
      inverseOnSurface: Color(4280691501),
      inversePrimary: Color(4278210404),
      primaryFixed: Color(4290439935),
      onPrimaryFixed: Color(4278195227),
      primaryFixedDim: Color(4287221997),
      onPrimaryFixedVariant: Color(4278205260),
      secondaryFixed: Color(4291815153),
      onSecondaryFixed: Color(4278195227),
      secondaryFixedDim: Color(4289972949),
      onSecondaryFixedVariant: Color(4280564034),
      tertiaryFixed: Color(4293058559),
      onTertiaryFixed: Color(4279045420),
      tertiaryFixedDim: Color(4291085291),
      onTertiaryFixedVariant: Color(4281545555),
      surfaceDim: Color(4279178263),
      surfaceBright: Color(4281678397),
      surfaceContainerLowest: Color(4278849297),
      surfaceContainerLow: Color(4279704607),
      surfaceContainer: Color(4279967779),
      surfaceContainerHigh: Color(4280625965),
      surfaceContainerHighest: Color(4281349688),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4294376447),
      surfaceTint: Color(4287221997),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4287485170),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294376447),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4290301657),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294834687),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4291413999),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      background: Color(4279178263),
      onBackground: Color(4292797414),
      surface: Color(4279178263),
      onSurface: Color(4294967295),
      surfaceVariant: Color(4282402892),
      onSurfaceVariant: Color(4294376447),
      outline: Color(4291087569),
      outlineVariant: Color(4291087569),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292797414),
      inverseOnSurface: Color(4278190080),
      inversePrimary: Color(4278201916),
      primaryFixed: Color(4291227135),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4287485170),
      onPrimaryFixedVariant: Color(4278196514),
      secondaryFixed: Color(4292143862),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4290301657),
      onSecondaryFixedVariant: Color(4278393121),
      tertiaryFixed: Color(4293387519),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4291413999),
      onTertiaryFixedVariant: Color(4279440177),
      surfaceDim: Color(4279178263),
      surfaceBright: Color(4281678397),
      surfaceContainerLowest: Color(4278849297),
      surfaceContainerLow: Color(4279704607),
      surfaceContainer: Color(4279967779),
      surfaceContainerHigh: Color(4280625965),
      surfaceContainerHighest: Color(4281349688),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary,
    required this.surfaceTint,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixedVariant,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerLowest: surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow,
      surfaceContainer: surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh,
      surfaceContainerHighest: surfaceContainerHighest,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}

