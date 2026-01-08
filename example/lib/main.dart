import 'package:flutter/material.dart';
import 'dart:ffi';
import 'package:calc_manager/calc_manager_wrapper.dart';
import 'package:ffi/ffi.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '计算器',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _input = '';
  String _result = '0';
  late Pointer<CalculatorInstance> _calculator;

  @override
  void initState() {
    super.initState();
    // 初始化计算器实例
    _calculator = calculator_init();
    calculator_set_standard_mode(_calculator);
    // 获取初始显示值
    _updateDisplay();
  }

  @override
  void dispose() {
    // 释放计算器实例
    calculator_free(_calculator);
    super.dispose();
  }

  // 更新显示
  void _updateDisplay() {
    // 创建一个足够大的缓冲区
    final buffer = calloc<Char>(1024);
    try {
      // 获取结果长度
      final length = calculator_get_result(_calculator, buffer, 1024);
      if (length > 0) {
        _result = buffer.cast<Utf8>().toDartString(length: length);
      }
    } finally {
      calloc.free(buffer);
    }
    setState(() {});
  }

  // 发送命令并更新显示
  void _sendCommand(int command) {
    calculator_send_command(_calculator, command);
    _updateDisplay();
  }

  void _onButtonPressed(String buttonText) {
    setState(() {
      // 更新输入显示
      if (buttonText == 'C' || buttonText == 'CE') {
        _input = '';
        _sendCommand(CMD_CLEAR);
      } else if (buttonText == 'DEL') {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
        _sendCommand(CMD_BACKSPACE);
      } else if (buttonText == '=') {
        _input += ' =';
        _sendCommand(CMD_EQUALS);
      } else if (buttonText == '.') {
        _input += buttonText;
        _sendCommand(CMD_DECIMAL);
      } else if (buttonText == '±') {
        _sendCommand(CMD_NEGATE);
      } else if (buttonText == '1/x') {
        _input += ' 1/x';
        _sendCommand(CMD_RECIPROCAL);
      } else if (buttonText == 'x²') {
        _input += ' x²';
        _sendCommand(CMD_SQUARE);
      } else if (buttonText == '√x') {
        _input += ' √x';
        _sendCommand(CMD_SQUARE_ROOT);
      } else if (buttonText == '%') {
        _input += ' %';
        _sendCommand(CMD_PERCENT);
      } else if (buttonText == '÷') {
        _input += ' ÷';
        _sendCommand(CMD_DIVIDE);
      } else if (buttonText == '×') {
        _input += ' ×';
        _sendCommand(CMD_MULTIPLY);
      } else if (buttonText == '-') {
        _input += ' -';
        _sendCommand(CMD_SUBTRACT);
      } else if (buttonText == '+') {
        _input += ' +';
        _sendCommand(CMD_ADD);
      } else if (buttonText == '0') {
        _input += buttonText;
        _sendCommand(CMD_0);
      } else if (buttonText == '1') {
        _input += buttonText;
        _sendCommand(CMD_1);
      } else if (buttonText == '2') {
        _input += buttonText;
        _sendCommand(CMD_2);
      } else if (buttonText == '3') {
        _input += buttonText;
        _sendCommand(CMD_3);
      } else if (buttonText == '4') {
        _input += buttonText;
        _sendCommand(CMD_4);
      } else if (buttonText == '5') {
        _input += buttonText;
        _sendCommand(CMD_5);
      } else if (buttonText == '6') {
        _input += buttonText;
        _sendCommand(CMD_6);
      } else if (buttonText == '7') {
        _input += buttonText;
        _sendCommand(CMD_7);
      } else if (buttonText == '8') {
        _input += buttonText;
        _sendCommand(CMD_8);
      } else if (buttonText == '9') {
        _input += buttonText;
        _sendCommand(CMD_9);
      }
      // 处理内存相关按键
      else if (buttonText.startsWith('M')) {
        // 内存功能暂时只更新UI，不实际调用API
        _input = '$buttonText: $_result';
      }
    });
  }

  Widget _buildButton(String text, {Color? color, Function()? onPressed}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: onPressed ?? () => _onButtonPressed(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.symmetric(vertical: 20),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: Text(text),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('计算器'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // 显示区域
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _input,
                    style: const TextStyle(fontSize: 24, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _result,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          // 按键区域
          Column(
            children: [
              // 内存功能键行（5个按键）
              Row(
                children: [
                  _buildButton('MC', color: Colors.grey),
                  _buildButton('MR', color: Colors.grey),
                  _buildButton('M+', color: Colors.grey),
                  _buildButton('M-', color: Colors.grey),
                  _buildButton('MS', color: Colors.grey),
                ],
              ),

              // 清除功能键行（4个按键）
              Row(
                children: [
                  _buildButton('%', color: Colors.grey),
                  _buildButton('CE', color: Colors.grey),
                  _buildButton('C', color: Colors.grey),
                  _buildButton('DEL', color: Colors.grey),
                ],
              ),

              // 函数键行
              Row(
                children: [
                  _buildButton('1/x', color: Colors.grey),
                  _buildButton('x²', color: Colors.grey),
                  _buildButton('√x', color: Colors.grey),
                  _buildButton('÷', color: Colors.orange),
                ],
              ),

              // 数字键行 7-9
              Row(
                children: [
                  _buildButton('7'),
                  _buildButton('8'),
                  _buildButton('9'),
                  _buildButton('×', color: Colors.orange),
                ],
              ),

              // 数字键行 4-6
              Row(
                children: [
                  _buildButton('4'),
                  _buildButton('5'),
                  _buildButton('6'),
                  _buildButton('-', color: Colors.orange),
                ],
              ),

              // 数字键行 1-3
              Row(
                children: [
                  _buildButton('1'),
                  _buildButton('2'),
                  _buildButton('3'),
                  _buildButton('+', color: Colors.orange),
                ],
              ),

              // 最后一行
              Row(
                children: [
                  _buildButton('±'),
                  _buildButton('0'),
                  _buildButton('.'),
                  _buildButton('=', color: Colors.orange),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
