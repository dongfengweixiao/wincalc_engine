import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';
import 'package:native_toolchain_c/native_toolchain_c.dart';

const String libcalcManagerPath = 'src/calculator/src/CalcManager';

void main(List<String> args) async {
  await build(args, (input, output) async {
    final targetOS = input.config.code.targetOS;
    final flags = <String>[];
    if (targetOS == OS.android) {
      // 16KB page size alignment for Android 15 compatibility
      flags.add('-Wl,-z,max-page-size=16384');
    }
    if (targetOS == OS.windows) {
      flags.add('/EHsc');
    }
    // Combine calc_manager and wrapper into a single library to avoid linking issues
    final builder = CBuilder.library(
      name: 'calc_manager_wrapper',
      assetName: 'wincalc_engine.dart',
      language: Language.cpp,
      std: 'c++17',
      forcedIncludes: ['$libcalcManagerPath/pch.h'],
      defines: {
        'CALC_MANAGER_EXPORTS': null, // Enable DLL exports on Windows
      },
      flags: flags,
      sources: [
        // CalcManager sources
        '$libcalcManagerPath/CEngine/calc.cpp',
        '$libcalcManagerPath/CEngine/CalcInput.cpp',
        '$libcalcManagerPath/CEngine/CalcUtils.cpp',
        '$libcalcManagerPath/CEngine/History.cpp',
        '$libcalcManagerPath/CEngine/Number.cpp',
        '$libcalcManagerPath/CEngine/Rational.cpp',
        '$libcalcManagerPath/CEngine/RationalMath.cpp',
        '$libcalcManagerPath/CEngine/scicomm.cpp',
        '$libcalcManagerPath/CEngine/scidisp.cpp',
        '$libcalcManagerPath/CEngine/scifunc.cpp',
        '$libcalcManagerPath/CEngine/scioper.cpp',
        '$libcalcManagerPath/CEngine/sciset.cpp',
        '$libcalcManagerPath/Ratpack/basex.cpp',
        '$libcalcManagerPath/Ratpack/conv.cpp',
        '$libcalcManagerPath/Ratpack/exp.cpp',
        '$libcalcManagerPath/Ratpack/fact.cpp',
        '$libcalcManagerPath/Ratpack/itrans.cpp',
        '$libcalcManagerPath/Ratpack/itransh.cpp',
        '$libcalcManagerPath/Ratpack/logic.cpp',
        '$libcalcManagerPath/Ratpack/num.cpp',
        '$libcalcManagerPath/Ratpack/rat.cpp',
        '$libcalcManagerPath/Ratpack/support.cpp',
        '$libcalcManagerPath/Ratpack/trans.cpp',
        '$libcalcManagerPath/Ratpack/transh.cpp',
        '$libcalcManagerPath/CalculatorHistory.cpp',
        '$libcalcManagerPath/CalculatorManager.cpp',
        '$libcalcManagerPath/ExpressionCommand.cpp',
        '$libcalcManagerPath/NumberFormattingUtils.cpp',
        '$libcalcManagerPath/pch.cpp',
        '$libcalcManagerPath/UnitConverter.cpp',
        // Wrapper sources
        'src/calc_manager_wrapper/calc_manager_wrapper.cpp',
      ],
      includes: [
        libcalcManagerPath,
        '$libcalcManagerPath/Header Files',
        '$libcalcManagerPath/Ratpack',
      ],
    );

    await builder.run(input: input, output: output);
  });
}
