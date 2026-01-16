// calc_manager_wrapper.h
// C-style wrapper for Microsoft Calculator's CalcManager
// Copyright (c) 2024. MIT License.

#pragma once

// Windows DLL export macro
#ifdef _WIN32
#ifdef CALC_MANAGER_EXPORTS
#define CALC_API __declspec(dllexport)
#else
#define CALC_API __declspec(dllimport)
#endif
#else
#define CALC_API
#endif

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

// ============================================================================
// Type Definitions
// ============================================================================

typedef int32_t CalculatorCommand;

// Opaque pointer types
typedef struct CalculatorInstance CalculatorInstance;
typedef struct UnitConverterInstance UnitConverterInstance;

// ============================================================================
// Calculator Commands - Numbers
// ============================================================================

#define CMD_0 ((CalculatorCommand)130)
#define CMD_1 ((CalculatorCommand)131)
#define CMD_2 ((CalculatorCommand)132)
#define CMD_3 ((CalculatorCommand)133)
#define CMD_4 ((CalculatorCommand)134)
#define CMD_5 ((CalculatorCommand)135)
#define CMD_6 ((CalculatorCommand)136)
#define CMD_7 ((CalculatorCommand)137)
#define CMD_8 ((CalculatorCommand)138)
#define CMD_9 ((CalculatorCommand)139)

// Hex digits (for programmer mode)
#define CMD_A ((CalculatorCommand)140)
#define CMD_B ((CalculatorCommand)141)
#define CMD_C ((CalculatorCommand)142)
#define CMD_D ((CalculatorCommand)143)
#define CMD_E ((CalculatorCommand)144)
#define CMD_F ((CalculatorCommand)145)

// ============================================================================
// Calculator Commands - Basic Operations
// ============================================================================

#define CMD_DECIMAL ((CalculatorCommand)84)    // .
#define CMD_NEGATE ((CalculatorCommand)80)     // +/-
#define CMD_ADD ((CalculatorCommand)93)        // +
#define CMD_SUBTRACT ((CalculatorCommand)94)   // -
#define CMD_MULTIPLY ((CalculatorCommand)92)   // *
#define CMD_DIVIDE ((CalculatorCommand)91)     // /
#define CMD_MOD ((CalculatorCommand)95)        // mod
#define CMD_EQUALS ((CalculatorCommand)121)    // =

// ============================================================================
// Calculator Commands - Clear/Control
// ============================================================================

#define CMD_CLEAR ((CalculatorCommand)81)      // C (clear all)
#define CMD_CENTR ((CalculatorCommand)82)      // CE (clear entry)
#define CMD_BACKSPACE ((CalculatorCommand)83)  // Backspace

// ============================================================================
// Calculator Commands - Standard Functions
// ============================================================================

#define CMD_PERCENT ((CalculatorCommand)118)   // %
#define CMD_SQUARE ((CalculatorCommand)111)    // x^2
#define CMD_SQRT ((CalculatorCommand)110)      // sqrt(x)
#define CMD_RECIPROCAL ((CalculatorCommand)114) // 1/x

// ============================================================================
// Calculator Commands - Scientific Functions
// ============================================================================

// Trigonometric
#define CMD_SIN ((CalculatorCommand)102)
#define CMD_COS ((CalculatorCommand)103)
#define CMD_TAN ((CalculatorCommand)104)
#define CMD_ASIN ((CalculatorCommand)202)
#define CMD_ACOS ((CalculatorCommand)203)
#define CMD_ATAN ((CalculatorCommand)204)

// Hyperbolic
#define CMD_SINH ((CalculatorCommand)105)
#define CMD_COSH ((CalculatorCommand)106)
#define CMD_TANH ((CalculatorCommand)107)
#define CMD_ASINH ((CalculatorCommand)206)
#define CMD_ACOSH ((CalculatorCommand)207)
#define CMD_ATANH ((CalculatorCommand)208)

// Additional trig functions
#define CMD_SEC ((CalculatorCommand)400)
#define CMD_CSC ((CalculatorCommand)402)
#define CMD_COT ((CalculatorCommand)404)
#define CMD_ASEC ((CalculatorCommand)401)
#define CMD_ACSC ((CalculatorCommand)403)
#define CMD_ACOT ((CalculatorCommand)405)

// Additional hyperbolic functions
#define CMD_SECH ((CalculatorCommand)406)
#define CMD_CSCH ((CalculatorCommand)408)
#define CMD_COTH ((CalculatorCommand)410)
#define CMD_ASECH ((CalculatorCommand)407)
#define CMD_ACSCH ((CalculatorCommand)409)
#define CMD_ACOTH ((CalculatorCommand)411)

// Logarithmic/Exponential
#define CMD_LN ((CalculatorCommand)108)        // ln(x)
#define CMD_LOG ((CalculatorCommand)109)       // log10(x)
#define CMD_LOGBASEY ((CalculatorCommand)500)  // log_y(x)
#define CMD_POW10 ((CalculatorCommand)117)     // 10^x
#define CMD_POW2 ((CalculatorCommand)412)      // 2^x
#define CMD_POWE ((CalculatorCommand)205)      // e^x
#define CMD_EXP ((CalculatorCommand)127)       // Scientific notation (EE)

// Power/Root
#define CMD_POWER ((CalculatorCommand)97)      // x^y
#define CMD_ROOT ((CalculatorCommand)96)       // y-root of x
#define CMD_CUBE ((CalculatorCommand)112)      // x^3
#define CMD_CUBEROOT ((CalculatorCommand)116)  // x^(1/3)

// Other scientific
#define CMD_FACTORIAL ((CalculatorCommand)113) // n!
#define CMD_ABS ((CalculatorCommand)413)       // |x|
#define CMD_FLOOR ((CalculatorCommand)414)     // floor(x)
#define CMD_CEIL ((CalculatorCommand)415)      // ceil(x)
#define CMD_DMS ((CalculatorCommand)115)       // Degrees-Minutes-Seconds

// Constants
#define CMD_PI ((CalculatorCommand)120)        // pi
#define CMD_EULER ((CalculatorCommand)601)     // e
#define CMD_RAND ((CalculatorCommand)600)      // random

// Parentheses
#define CMD_OPENP ((CalculatorCommand)128)     // (
#define CMD_CLOSEP ((CalculatorCommand)129)    // )

// Toggle
#define CMD_INV ((CalculatorCommand)146)       // Inverse toggle
#define CMD_FE ((CalculatorCommand)119)        // Fixed/Engineering toggle
#define CMD_HYP ((CalculatorCommand)325)       // Hyperbolic toggle

// ============================================================================
// Calculator Commands - Angle Modes
// ============================================================================

#define CMD_DEG ((CalculatorCommand)321)       // Degrees mode
#define CMD_RAD ((CalculatorCommand)322)       // Radians mode
#define CMD_GRAD ((CalculatorCommand)323)      // Gradians mode
#define CMD_DEGREES ((CalculatorCommand)324)   // Degrees function (convert DMS to decimal degrees)

// ============================================================================
// Calculator Commands - Programmer Mode (Bitwise)
// ============================================================================

#define CMD_AND ((CalculatorCommand)86)
#define CMD_OR ((CalculatorCommand)87)
#define CMD_XOR ((CalculatorCommand)88)
#define CMD_NOT ((CalculatorCommand)101)
#define CMD_NAND ((CalculatorCommand)501)
#define CMD_NOR ((CalculatorCommand)502)

// Bit shifts
#define CMD_LSH ((CalculatorCommand)89)        // Left shift
#define CMD_RSH ((CalculatorCommand)90)        // Right shift (arithmetic)
#define CMD_RSHL ((CalculatorCommand)505)      // Right shift (logical)
#define CMD_ROL ((CalculatorCommand)99)        // Rotate left
#define CMD_ROR ((CalculatorCommand)100)       // Rotate right
#define CMD_ROLC ((CalculatorCommand)416)      // Rotate left through carry
#define CMD_RORC ((CalculatorCommand)417)      // Rotate right through carry

// ============================================================================
// Calculator Commands - Radix (Number Base)
// ============================================================================

#define CMD_HEX ((CalculatorCommand)313)       // Hexadecimal
#define CMD_DEC ((CalculatorCommand)314)       // Decimal
#define CMD_OCT ((CalculatorCommand)315)       // Octal
#define CMD_BIN ((CalculatorCommand)316)       // Binary

// ============================================================================
// Calculator Commands - Word Size
// ============================================================================

#define CMD_QWORD ((CalculatorCommand)317)     // 64-bit
#define CMD_DWORD ((CalculatorCommand)318)     // 32-bit
#define CMD_WORD ((CalculatorCommand)319)      // 16-bit
#define CMD_BYTE ((CalculatorCommand)320)      // 8-bit

// ============================================================================
// Calculator Commands - Memory
// ============================================================================

#define CMD_MC ((CalculatorCommand)122)        // Memory Clear
#define CMD_MR ((CalculatorCommand)123)        // Memory Recall
#define CMD_MS ((CalculatorCommand)124)        // Memory Store
#define CMD_MPLUS ((CalculatorCommand)125)     // Memory Add
#define CMD_MMINUS ((CalculatorCommand)126)    // Memory Subtract

// ============================================================================
// Calculator Commands - Bit Position Toggle (Programmer Mode)
// ============================================================================

#define CMD_BINPOS(n) ((CalculatorCommand)(700 + (n)))  // Toggle bit at position n (0-63)

// ============================================================================
// Enumerations
// ============================================================================

// Calculator modes
typedef enum {
    CALC_MODE_STANDARD = 0,
    CALC_MODE_SCIENTIFIC = 1,
    CALC_MODE_PROGRAMMER = 2
} CalcMode;

// Radix types (number bases)
typedef enum {
    CALC_RADIX_DECIMAL = 10,
    CALC_RADIX_HEX = 16,
    CALC_RADIX_OCTAL = 8,
    CALC_RADIX_BINARY = 2
} CalcRadixType;

// Angle types
typedef enum {
    CALC_ANGLE_DEGREES = 0,
    CALC_ANGLE_RADIANS = 1,
    CALC_ANGLE_GRADIANS = 2
} CalcAngleType;

// Word size types (for programmer mode)
typedef enum {
    CALC_WORD_QWORD = 0,  // 64-bit
    CALC_WORD_DWORD = 1,  // 32-bit
    CALC_WORD_WORD = 2,   // 16-bit
    CALC_WORD_BYTE = 3    // 8-bit
} CalcWordType;

// Memory commands
typedef enum {
    MEM_CMD_STORE = 330,
    MEM_CMD_LOAD = 331,
    MEM_CMD_ADD = 332,
    MEM_CMD_SUBTRACT = 333,
    MEM_CMD_CLEAR_ALL = 334,
    MEM_CMD_CLEAR = 335
} MemoryCommand;

// ============================================================================
// Calculator Instance Functions
// ============================================================================

// Lifecycle
CALC_API CalculatorInstance* calculator_create(void);
CALC_API void calculator_destroy(CalculatorInstance* instance);

// History load mode management
CALC_API int calculator_is_in_history_load_mode(CalculatorInstance* instance);
CALC_API void calculator_set_history_load_mode(CalculatorInstance* instance, int enabled);

// Mode settings
CALC_API void calculator_set_standard_mode(CalculatorInstance* instance);
CALC_API void calculator_set_scientific_mode(CalculatorInstance* instance);
CALC_API void calculator_set_programmer_mode(CalculatorInstance* instance);
CALC_API int calculator_get_current_mode(CalculatorInstance* instance);

// Commands
CALC_API void calculator_send_command(CalculatorInstance* instance, CalculatorCommand command);

// Results
CALC_API int calculator_get_primary_display(CalculatorInstance* instance, char* buffer, int buffer_size);
CALC_API int calculator_get_expression(CalculatorInstance* instance, char* buffer, int buffer_size);
CALC_API int calculator_has_error(CalculatorInstance* instance);

// State
CALC_API void calculator_reset(CalculatorInstance* instance, int clear_memory);
CALC_API int calculator_is_input_empty(CalculatorInstance* instance);

// ============================================================================
// Programmer Mode Functions
// ============================================================================

// Radix (number base)
CALC_API void calculator_set_radix(CalculatorInstance* instance, CalcRadixType radix);
CALC_API int calculator_get_radix(CalculatorInstance* instance);

// Get result in specific radix
CALC_API int calculator_get_result_hex(CalculatorInstance* instance, char* buffer, int buffer_size);
CALC_API int calculator_get_result_dec(CalculatorInstance* instance, char* buffer, int buffer_size);
CALC_API int calculator_get_result_oct(CalculatorInstance* instance, char* buffer, int buffer_size);
CALC_API int calculator_get_result_bin(CalculatorInstance* instance, char* buffer, int buffer_size);

// Binary representation for bit panel (64 chars: '0' or '1')
CALC_API int calculator_get_binary_display(CalculatorInstance* instance, char* buffer, int buffer_size);

// Word size (for programmer mode)
CALC_API void calculator_set_word_width(CalculatorInstance* instance, CalcWordType word_type);
CALC_API int calculator_get_word_width(CalculatorInstance* instance);

// Carry flag (for rotate through carry operations)
CALC_API void calculator_set_carry_flag(CalculatorInstance* instance, int carry);
CALC_API int calculator_get_carry_flag(CalculatorInstance* instance);

// ============================================================================
// Scientific Mode Functions
// ============================================================================

// Angle mode
CALC_API void calculator_set_angle_type(CalculatorInstance* instance, CalcAngleType angle_type);
CALC_API int calculator_get_angle_type(CalculatorInstance* instance);

// ============================================================================
// Memory Functions
// ============================================================================

// Memory operations
CALC_API void calculator_memory_store(CalculatorInstance* instance);
CALC_API void calculator_memory_recall(CalculatorInstance* instance);
CALC_API void calculator_memory_add(CalculatorInstance* instance);
CALC_API void calculator_memory_subtract(CalculatorInstance* instance);
CALC_API void calculator_memory_clear(CalculatorInstance* instance);

// Extended memory (multiple slots)
CALC_API int calculator_memory_get_count(CalculatorInstance* instance);
CALC_API int calculator_memory_get_at(CalculatorInstance* instance, int index, char* buffer, int buffer_size);
CALC_API void calculator_memory_load_at(CalculatorInstance* instance, int index);
CALC_API void calculator_memory_add_at(CalculatorInstance* instance, int index);
CALC_API void calculator_memory_subtract_at(CalculatorInstance* instance, int index);
CALC_API void calculator_memory_clear_at(CalculatorInstance* instance, int index);
CALC_API void calculator_memory_clear_all(CalculatorInstance* instance);

// ============================================================================
// History Functions
// ============================================================================

// Get history count for current mode
CALC_API int calculator_history_get_count(CalculatorInstance* instance);
CALC_API int calculator_history_get_expression_at(CalculatorInstance* instance, int index, char* buffer, int buffer_size);
CALC_API int calculator_history_get_result_at(CalculatorInstance* instance, int index, char* buffer, int buffer_size);
CALC_API void calculator_history_load_at(CalculatorInstance* instance, int index);
CALC_API int calculator_history_remove_at(CalculatorInstance* instance, int index);
CALC_API void calculator_history_clear(CalculatorInstance* instance);

// Per-mode history functions (NEW)
// Get history count for a specific mode
CALC_API int calculator_history_get_count_for_mode(CalculatorInstance* instance, CalcMode mode);

// Get history expression/result for a specific mode
CALC_API int calculator_history_get_expression_at_for_mode(CalculatorInstance* instance, CalcMode mode, int index, char* buffer, int buffer_size);
CALC_API int calculator_history_get_result_at_for_mode(CalculatorInstance* instance, CalcMode mode, int index, char* buffer, int buffer_size);

// Set history items for current mode (used when switching back to a mode)
CALC_API void calculator_history_set_from_vector(CalculatorInstance* instance, const char* json_data);

// Clear history for a specific mode
CALC_API void calculator_history_clear_for_mode(CalculatorInstance* instance, CalcMode mode);

// ============================================================================
// Parenthesis
// ============================================================================

CALC_API int calculator_get_parenthesis_count(CalculatorInstance* instance);

// ============================================================================
// Unit Converter Instance Functions
// ============================================================================

// Lifecycle
CALC_API UnitConverterInstance* unit_converter_create(void);
CALC_API void unit_converter_destroy(UnitConverterInstance* instance);

// Category management
CALC_API int unit_converter_get_category_count(UnitConverterInstance* instance);
CALC_API int unit_converter_get_category_name(UnitConverterInstance* instance, int index, char* buffer, int buffer_size);
CALC_API int unit_converter_get_category_id(UnitConverterInstance* instance, int index);
CALC_API void unit_converter_set_category(UnitConverterInstance* instance, int category_id);
CALC_API int unit_converter_get_current_category(UnitConverterInstance* instance);

// Unit management
CALC_API int unit_converter_get_unit_count(UnitConverterInstance* instance);
CALC_API int unit_converter_get_unit_name(UnitConverterInstance* instance, int index, char* buffer, int buffer_size);
CALC_API int unit_converter_get_unit_abbreviation(UnitConverterInstance* instance, int index, char* buffer, int buffer_size);
CALC_API int unit_converter_get_unit_id(UnitConverterInstance* instance, int index);
CALC_API int unit_converter_is_unit_whimsical(UnitConverterInstance* instance, int index);

// Current unit selection
CALC_API void unit_converter_set_from_unit(UnitConverterInstance* instance, int unit_id);
CALC_API void unit_converter_set_to_unit(UnitConverterInstance* instance, int unit_id);
CALC_API int unit_converter_get_from_unit(UnitConverterInstance* instance);
CALC_API int unit_converter_get_to_unit(UnitConverterInstance* instance);

// Swap units
CALC_API void unit_converter_swap_units(UnitConverterInstance* instance);

// Input/Output
CALC_API void unit_converter_send_command(UnitConverterInstance* instance, CalculatorCommand command);
CALC_API int unit_converter_get_from_value(UnitConverterInstance* instance, char* buffer, int buffer_size);
CALC_API int unit_converter_get_to_value(UnitConverterInstance* instance, char* buffer, int buffer_size);

// Reset
CALC_API void unit_converter_reset(UnitConverterInstance* instance);

// Suggested values (from CalculateSuggested)
CALC_API int unit_converter_get_suggested_count(UnitConverterInstance* instance);
CALC_API int unit_converter_get_suggested_value(UnitConverterInstance* instance, int index, char* value_buffer, int value_buffer_size, char* unit_buffer, int unit_buffer_size);

// ============================================================================
// Unit Converter Commands (same as number input)
// ============================================================================

#define UNIT_CMD_0 ((CalculatorCommand)0)
#define UNIT_CMD_1 ((CalculatorCommand)1)
#define UNIT_CMD_2 ((CalculatorCommand)2)
#define UNIT_CMD_3 ((CalculatorCommand)3)
#define UNIT_CMD_4 ((CalculatorCommand)4)
#define UNIT_CMD_5 ((CalculatorCommand)5)
#define UNIT_CMD_6 ((CalculatorCommand)6)
#define UNIT_CMD_7 ((CalculatorCommand)7)
#define UNIT_CMD_8 ((CalculatorCommand)8)
#define UNIT_CMD_9 ((CalculatorCommand)9)
#define UNIT_CMD_DECIMAL ((CalculatorCommand)10)
#define UNIT_CMD_NEGATE ((CalculatorCommand)11)
#define UNIT_CMD_BACKSPACE ((CalculatorCommand)12)
#define UNIT_CMD_CLEAR ((CalculatorCommand)13)
#define UNIT_CMD_RESET ((CalculatorCommand)14)

// ============================================================================
// Backward Compatibility (old function names)
// ============================================================================

CALC_API CalculatorInstance* calculator_init(void);
CALC_API void calculator_free(CalculatorInstance* instance);
CALC_API int calculator_get_result_length(CalculatorInstance* instance);
CALC_API int calculator_get_result(CalculatorInstance* instance, char* buffer, int buffer_size);

#ifdef __cplusplus
}
#endif
