#pragma once

#ifdef __cplusplus
extern "C" {
#endif

typedef int CalculatorCommand;
#define CMD_0           ((CalculatorCommand)130)
#define CMD_1           ((CalculatorCommand)131)
#define CMD_2           ((CalculatorCommand)132)
#define CMD_3           ((CalculatorCommand)133)
#define CMD_4           ((CalculatorCommand)134)
#define CMD_5           ((CalculatorCommand)135)
#define CMD_6           ((CalculatorCommand)136)
#define CMD_7           ((CalculatorCommand)137)
#define CMD_8           ((CalculatorCommand)138)
#define CMD_9           ((CalculatorCommand)139)
#define CMD_DECIMAL     ((CalculatorCommand)84)
#define CMD_ADD         ((CalculatorCommand)93)
#define CMD_SUBTRACT    ((CalculatorCommand)94)
#define CMD_MULTIPLY    ((CalculatorCommand)92)
#define CMD_DIVIDE      ((CalculatorCommand)91)
#define CMD_EQUALS      ((CalculatorCommand)121)
#define CMD_CLEAR       ((CalculatorCommand)81)
#define CMD_BACKSPACE   ((CalculatorCommand)83)
#define CMD_NEGATE      ((CalculatorCommand)80)
#define CMD_SQUARE      ((CalculatorCommand)111)
#define CMD_SQUARE_ROOT ((CalculatorCommand)110)
#define CMD_RECIPROCAL  ((CalculatorCommand)114)
#define CMD_PERCENT     ((CalculatorCommand)118)

// 计算器实例的不透明指针类型
typedef struct CalculatorInstance CalculatorInstance;

// 初始化计算器实例
CalculatorInstance* calculator_init();

// 释放计算器实例
void calculator_free(CalculatorInstance* instance);

// 设置计算器模式
void calculator_set_standard_mode(CalculatorInstance* instance);
void calculator_set_scientific_mode(CalculatorInstance* instance);

// 发送命令到计算器
void calculator_send_command(CalculatorInstance* instance,
                             CalculatorCommand command);

// 获取结果长度
int calculator_get_result_length(CalculatorInstance* instance);
// 获取当前显示的结果
int calculator_get_result(CalculatorInstance* instance, char* buffer,
                          int bufferSize);

// 判断是否有错误
int calculator_has_error(CalculatorInstance* instance);

// 重置计算器
void calculator_reset(CalculatorInstance* instance);

#ifdef __cplusplus
}
#endif