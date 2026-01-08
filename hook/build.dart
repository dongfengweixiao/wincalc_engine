import 'package:hooks/hooks.dart';
import 'package:native_toolchain_c/native_toolchain_c.dart';

const String libcalcManagerPath = 'src/calculator/src/CalcManager';

void main(List<String> args) async {
  await build(args, (input, output) async {
    final builders = [
      // 编译 calc_manager
      CBuilder.library(
        name: 'calc_manager',
        assetName: 'calc_manager',
        language: Language.cpp,
        std: 'c++17',
        forcedIncludes: ['src/include/pch.h'],
        sources: [
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
        ],
        includes: [
          'src/include',
          libcalcManagerPath,
          '$libcalcManagerPath/Header Files',
          '$libcalcManagerPath/Ratpack',
        ],
      ),
      CBuilder.library(
        name: 'calc_manager_wrapper',
        language: Language.cpp,
        std: 'c++17',
        assetName: 'calc_manager_wrapper.dart',
        sources: ['src/calc_manager_wrapper/calc_manager_wrapper.cpp'],
        libraries: ['calc_manager'],
        includes: [
          'src/include',
          libcalcManagerPath,
          '$libcalcManagerPath/Header Files',
          '$libcalcManagerPath/Ratpack',
        ],
      ),
    ];

    for (final builder in builders) {
      await builder.run(input: input, output: output);
    }
  });
}
