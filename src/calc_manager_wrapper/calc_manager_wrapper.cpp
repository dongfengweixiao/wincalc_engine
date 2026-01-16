// calc_manager_wrapper.cpp
// C++ implementation of the C wrapper for Microsoft Calculator's CalcManager
// Copyright (c) 2024. MIT License.

#include "calc_manager_wrapper.h"

#include <cstring>
#include <memory>
#include <string>
#include <unordered_map>
#include <vector>
#include <codecvt>
#include <locale>

// CalcManager headers
#include <CalculatorManager.h>
#include <CalculatorResource.h>
#include <EngineStrings.h>
#include <ExpressionCommandInterface.h>
#include <ICalcDisplay.h>
#include <UnitConverter.h>
#include "Header Files/CCommand.h"  // For IDC_EQU

// ============================================================================
// Helper: Wide string to UTF-8 conversion
// ============================================================================

static std::string wstring_to_utf8(const std::wstring& wstr) {
    if (wstr.empty()) return std::string();

    std::string result;
    result.reserve(wstr.size() * 3);

    for (wchar_t wc : wstr) {
        if (wc <= 0x7F) {
            result.push_back(static_cast<char>(wc));
        } else if (wc <= 0x7FF) {
            result.push_back(static_cast<char>(0xC0 | ((wc >> 6) & 0x1F)));
            result.push_back(static_cast<char>(0x80 | (wc & 0x3F)));
        } else if (wc <= 0xFFFF) {
            result.push_back(static_cast<char>(0xE0 | ((wc >> 12) & 0x0F)));
            result.push_back(static_cast<char>(0x80 | ((wc >> 6) & 0x3F)));
            result.push_back(static_cast<char>(0x80 | (wc & 0x3F)));
        } else {
            result.push_back(static_cast<char>(0xF0 | ((wc >> 18) & 0x07)));
            result.push_back(static_cast<char>(0x80 | ((wc >> 12) & 0x3F)));
            result.push_back(static_cast<char>(0x80 | ((wc >> 6) & 0x3F)));
            result.push_back(static_cast<char>(0x80 | (wc & 0x3F)));
        }
    }
    return result;
}

static int copy_to_buffer(const std::string& str, char* buffer, int buffer_size) {
    if (!buffer || buffer_size <= 0) return -1;

    int len = static_cast<int>(str.length());
    if (len >= buffer_size) {
        // Buffer too small, copy what we can
        std::memcpy(buffer, str.c_str(), buffer_size - 1);
        buffer[buffer_size - 1] = '\0';
        return buffer_size - 1;
    }

    std::memcpy(buffer, str.c_str(), len + 1);
    return len;
}

// ============================================================================
// Resource Provider Implementation
// ============================================================================

class ResourceProviderImpl : public CalculationManager::IResourceProvider {
public:
    std::wstring GetCEngineString(std::wstring_view id) override {
        // Locale-specific strings
        if (id == L"sDecimal") return L".";
        if (id == L"sThousand") return L",";
        if (id == L"sGrouping") return L"3;0";

        // Engine strings mapping
        static const std::unordered_map<std::wstring_view, std::wstring> engineStrings = {
            {SIDS_PLUS_MINUS, L"\u00B1"},
            {SIDS_CLEAR, L"C"},
            {SIDS_CE, L"CE"},
            {SIDS_BACKSPACE, L"\u232B"},
            {SIDS_DECIMAL_SEPARATOR, L"."},
            {SIDS_EMPTY_STRING, L""},
            {SIDS_AND, L"AND"},
            {SIDS_OR, L"OR"},
            {SIDS_XOR, L"XOR"},
            {SIDS_LSH, L"Lsh"},
            {SIDS_RSH, L"Rsh"},
            {SIDS_DIVIDE, L"\u00F7"},
            {SIDS_MULTIPLY, L"\u00D7"},
            {SIDS_PLUS, L"+"},
            {SIDS_MINUS, L"-"},
            {SIDS_MOD, L"Mod"},
            {SIDS_YROOT, L"yroot"},
            {SIDS_POW_HAT, L"^"},
            {SIDS_INT, L"int"},
            {SIDS_ROL, L"rol"},
            {SIDS_ROR, L"ror"},
            {SIDS_NOT, L"NOT"},
            {SIDS_SIN, L"sin"},
            {SIDS_COS, L"cos"},
            {SIDS_TAN, L"tan"},
            {SIDS_SINH, L"sinh"},
            {SIDS_COSH, L"cosh"},
            {SIDS_TANH, L"tanh"},
            {SIDS_LN, L"ln"},
            {SIDS_LOG, L"log"},
            {SIDS_SQRT, L"\u221A"},
            {SIDS_XPOW2, L"sqr"},
            {SIDS_XPOW3, L"cube"},
            {SIDS_NFACTORIAL, L"fact"},
            {SIDS_FACT, L"fact"},
            {SIDS_RECIPROCAL, L"1/"},
            {SIDS_RECIPROC, L"1/"},
            {SIDS_DMS, L"dms"},
            {SIDS_DEGREES, L"degrees"},
            {SIDS_CUBEROOT, L"\u221B"},
            {SIDS_SQR, L"sqr"},
            {SIDS_CUBE, L"cube"},
            {SIDS_CUBERT, L"\u221B"},
            {SIDS_POWTEN, L"10^"},
            {SIDS_PERCENT, L"%"},
            {SIDS_SCIENTIFIC_NOTATION, L"e"},
            {SIDS_PI, L"\u03C0"},
            {SIDS_EQUAL, L"="},
            {SIDS_MC, L"MC"},
            {SIDS_MR, L"MR"},
            {SIDS_MS, L"MS"},
            {SIDS_MPLUS, L"M+"},
            {SIDS_MMINUS, L"M-"},
            {SIDS_EXP, L"exp"},
            {SIDS_OPEN_PAREN, L"("},
            {SIDS_CLOSE_PAREN, L")"},
            {SIDS_0, L"0"},
            {SIDS_1, L"1"},
            {SIDS_2, L"2"},
            {SIDS_3, L"3"},
            {SIDS_4, L"4"},
            {SIDS_5, L"5"},
            {SIDS_6, L"6"},
            {SIDS_7, L"7"},
            {SIDS_8, L"8"},
            {SIDS_9, L"9"},
            {SIDS_A, L"A"},
            {SIDS_B, L"B"},
            {SIDS_C, L"C"},
            {SIDS_D, L"D"},
            {SIDS_E, L"E"},
            {SIDS_F, L"F"},
            {SIDS_FRAC, L"frac"},
            {SIDS_NEGATE, L"negate"},
            {SIDS_DIVIDEBYZERO, L"Cannot divide by zero"},
            {SIDS_DOMAIN, L"Invalid input"},
            {SIDS_UNDEFINED, L"Result is undefined"},
            {SIDS_POS_INFINITY, L"Positive infinity"},
            {SIDS_NEG_INFINITY, L"Negative infinity"},
            {SIDS_ABORTED, L"Aborted"},
            {SIDS_NOMEM, L"Out of memory"},
            {SIDS_TOOMANY, L"Too many"},
            {SIDS_OVERFLOW, L"Overflow"},
            {SIDS_NORESULT, L"No result"},
            {SIDS_INSUFFICIENT_DATA, L"Insufficient data"},
            // Trig functions by angle mode
            {SIDS_SIND, L"sin"},
            {SIDS_COSD, L"cos"},
            {SIDS_TAND, L"tan"},
            {SIDS_ASIND, L"asin"},
            {SIDS_ACOSD, L"acos"},
            {SIDS_ATAND, L"atan"},
            {SIDS_SINR, L"sin"},
            {SIDS_COSR, L"cos"},
            {SIDS_TANR, L"tan"},
            {SIDS_ASINR, L"asin"},
            {SIDS_ACOSR, L"acos"},
            {SIDS_ATANR, L"atan"},
            {SIDS_SING, L"sin"},
            {SIDS_COSG, L"cos"},
            {SIDS_TANG, L"tan"},
            {SIDS_ASING, L"asin"},
            {SIDS_ACOSG, L"acos"},
            {SIDS_ATANG, L"atan"},
            // Hyperbolic
            {SIDS_ASINH, L"asinh"},
            {SIDS_ACOSH, L"acosh"},
            {SIDS_ATANH, L"atanh"},
            {SIDS_POWE, L"e^"},
            {SIDS_TWOPOWX, L"2^"},
            {SIDS_ABS, L"abs"},
            {SIDS_FLOOR, L"floor"},
            {SIDS_CEIL, L"ceil"},
            {SIDS_NAND, L"NAND"},
            {SIDS_NOR, L"NOR"},
            // Sec, Csc, Cot by angle mode
            {SIDS_SECD, L"sec"},
            {SIDS_ASECD, L"asec"},
            {SIDS_CSCD, L"csc"},
            {SIDS_ACSCD, L"acsc"},
            {SIDS_COTD, L"cot"},
            {SIDS_ACOTD, L"acot"},
            {SIDS_SECR, L"sec"},
            {SIDS_ASECR, L"asec"},
            {SIDS_CSCR, L"csc"},
            {SIDS_ACSCR, L"acsc"},
            {SIDS_COTR, L"cot"},
            {SIDS_ACOTR, L"acot"},
            {SIDS_SECG, L"sec"},
            {SIDS_ASECG, L"asec"},
            {SIDS_CSCG, L"csc"},
            {SIDS_ACSCG, L"acsc"},
            {SIDS_COTG, L"cot"},
            {SIDS_ACOTG, L"acot"},
            {SIDS_SECH, L"sech"},
            {SIDS_ASECH, L"asech"},
            {SIDS_CSCH, L"csch"},
            {SIDS_ACSCH, L"acsch"},
            {SIDS_COTH, L"coth"},
            {SIDS_ACOTH, L"acoth"},
            {SIDS_LOGBASEY, L"log"},
        };

        auto it = engineStrings.find(id);
        if (it != engineStrings.end()) {
            return it->second;
        }

        return L"";
    }
};

// ============================================================================
// Calculator Display Implementation
// ============================================================================

class CalcDisplayImpl : public ICalcDisplay {
public:
    std::wstring primaryDisplay;
    std::wstring expression;
    bool hasError = false;
    unsigned int parenthesisCount = 0;
    std::vector<std::wstring> memorizedNumbers;

    void SetPrimaryDisplay(const std::wstring& displayString, bool isError) override {
        primaryDisplay = displayString;
        hasError = isError;
    }

    void SetIsInError(bool isInError) override {
        hasError = isInError;
    }

    void SetExpressionDisplay(
        _Inout_ std::shared_ptr<std::vector<std::pair<std::wstring, int>>> const& tokens,
        _Inout_ std::shared_ptr<std::vector<std::shared_ptr<IExpressionCommand>>> const& /*commands*/) override {
        expression.clear();
        if (tokens) {
            for (const auto& token : *tokens) {
                expression += token.first;
                expression += L" ";
            }
        }
    }

    void SetParenthesisNumber(unsigned int count) override {
        parenthesisCount = count;
    }

    void OnNoRightParenAdded() override {}
    void MaxDigitsReached() override {}
    void BinaryOperatorReceived() override {}
    void OnHistoryItemAdded(unsigned int /*addedItemIndex*/) override {}

    void SetMemorizedNumbers(const std::vector<std::wstring>& memorizedNums) override {
        memorizedNumbers = memorizedNums;
    }

    void MemoryItemChanged(unsigned int /*indexOfMemory*/) override {}
    void InputChanged() override {}
};

// ============================================================================
// Calculator Instance Structure
// ============================================================================

struct CalculatorInstance {
    std::unique_ptr<CalculationManager::CalculatorManager> manager;
    std::unique_ptr<ResourceProviderImpl> resourceProvider;
    std::unique_ptr<CalcDisplayImpl> display;
    CalcMode currentMode = CALC_MODE_STANDARD;
    CalcRadixType currentRadix = CALC_RADIX_DECIMAL;
    CalcAngleType currentAngleType = CALC_ANGLE_DEGREES;
    CalcWordType currentWordType = CALC_WORD_QWORD;
    uint64_t carryFlag = 0;
    bool isInHistoryLoadMode = false;  // Track history item load mode
};

// ============================================================================
// Calculator Instance Functions Implementation
// ============================================================================

CalculatorInstance* calculator_create(void) {
    auto instance = new CalculatorInstance();
    instance->resourceProvider = std::make_unique<ResourceProviderImpl>();
    instance->display = std::make_unique<CalcDisplayImpl>();
    instance->manager = std::make_unique<CalculationManager::CalculatorManager>(
        instance->display.get(), instance->resourceProvider.get());
    instance->manager->SetStandardMode();
    instance->currentMode = CALC_MODE_STANDARD;
    return instance;
}

void calculator_destroy(CalculatorInstance* instance) {
    delete instance;
}

void calculator_set_standard_mode(CalculatorInstance* instance) {
    if (instance && instance->manager) {
        instance->manager->SetStandardMode();
        instance->currentMode = CALC_MODE_STANDARD;
    }
}

void calculator_set_scientific_mode(CalculatorInstance* instance) {
    if (instance && instance->manager) {
        instance->manager->SetScientificMode();
        instance->currentMode = CALC_MODE_SCIENTIFIC;
    }
}

void calculator_set_programmer_mode(CalculatorInstance* instance) {
    if (instance && instance->manager) {
        instance->manager->SetProgrammerMode();
        instance->currentMode = CALC_MODE_PROGRAMMER;
    }
}

int calculator_get_current_mode(CalculatorInstance* instance) {
    if (instance) {
        return static_cast<int>(instance->currentMode);
    }
    return CALC_MODE_STANDARD;
}

void calculator_send_command(CalculatorInstance* instance, CalculatorCommand command) {
    if (!instance || !instance->manager) return;

    // If we're in history load mode, just clear the flag and continue normally
    // Don't try to recreate the deleted history entry as it may cause display issues
    if (instance->isInHistoryLoadMode) {
        instance->isInHistoryLoadMode = false;
    }

    // Track word width changes via commands
    switch (command) {
        case CMD_QWORD:
            instance->currentWordType = CALC_WORD_QWORD;
            break;
        case CMD_DWORD:
            instance->currentWordType = CALC_WORD_DWORD;
            break;
        case CMD_WORD:
            instance->currentWordType = CALC_WORD_WORD;
            break;
        case CMD_BYTE:
            instance->currentWordType = CALC_WORD_BYTE;
            break;
        default:
            break;
    }

    instance->manager->SendCommand(static_cast<CalculationManager::Command>(command));
}

int calculator_get_primary_display(CalculatorInstance* instance, char* buffer, int buffer_size) {
    if (!instance || !instance->display) return -1;

    std::string utf8 = wstring_to_utf8(instance->display->primaryDisplay);
    return copy_to_buffer(utf8, buffer, buffer_size);
}

int calculator_get_expression(CalculatorInstance* instance, char* buffer, int buffer_size) {
    if (!instance || !instance->display) return -1;

    std::string utf8 = wstring_to_utf8(instance->display->expression);
    return copy_to_buffer(utf8, buffer, buffer_size);
}

int calculator_has_error(CalculatorInstance* instance) {
    if (instance && instance->display) {
        return instance->display->hasError ? 1 : 0;
    }
    return 0;
}

void calculator_reset(CalculatorInstance* instance, int clear_memory) {
    if (instance && instance->manager) {
        instance->manager->Reset(clear_memory != 0);
    }
}

int calculator_is_input_empty(CalculatorInstance* instance) {
    if (instance && instance->manager) {
        return instance->manager->IsInputEmpty() ? 1 : 0;
    }
    return 1;
}

// ============================================================================
// Programmer Mode Functions Implementation
// ============================================================================

void calculator_set_radix(CalculatorInstance* instance, CalcRadixType radix) {
    if (!instance || !instance->manager) return;

    ::RadixType engineRadix;
    switch (radix) {
        case CALC_RADIX_HEX:     engineRadix = ::RadixType::Hex; break;
        case CALC_RADIX_DECIMAL: engineRadix = ::RadixType::Decimal; break;
        case CALC_RADIX_OCTAL:   engineRadix = ::RadixType::Octal; break;
        case CALC_RADIX_BINARY:  engineRadix = ::RadixType::Binary; break;
        default:                 engineRadix = ::RadixType::Decimal; break;
    }

    instance->manager->SetRadix(engineRadix);
    instance->currentRadix = radix;
}

int calculator_get_radix(CalculatorInstance* instance) {
    if (instance) {
        return instance->currentRadix;
    }
    return CALC_RADIX_DECIMAL;
}

static int get_result_for_radix(CalculatorInstance* instance, uint32_t radix, char* buffer, int buffer_size) {
    if (!instance || !instance->manager) return -1;

    std::wstring result = instance->manager->GetResultForRadix(radix, 64, true);
    std::string utf8 = wstring_to_utf8(result);
    return copy_to_buffer(utf8, buffer, buffer_size);
}

int calculator_get_result_hex(CalculatorInstance* instance, char* buffer, int buffer_size) {
    return get_result_for_radix(instance, 16, buffer, buffer_size);
}

int calculator_get_result_dec(CalculatorInstance* instance, char* buffer, int buffer_size) {
    return get_result_for_radix(instance, 10, buffer, buffer_size);
}

int calculator_get_result_oct(CalculatorInstance* instance, char* buffer, int buffer_size) {
    return get_result_for_radix(instance, 8, buffer, buffer_size);
}

int calculator_get_result_bin(CalculatorInstance* instance, char* buffer, int buffer_size) {
    return get_result_for_radix(instance, 2, buffer, buffer_size);
}

int calculator_get_binary_display(CalculatorInstance* instance, char* buffer, int buffer_size) {
    if (!instance || !instance->manager || buffer_size < 65) return -1;

    std::wstring binResult = instance->manager->GetResultForRadix(2, 64, false);

    // Pad to 64 characters
    std::string result(64, '0');
    std::string binUtf8 = wstring_to_utf8(binResult);

    // Remove any spaces or other formatting
    std::string cleanBin;
    for (char c : binUtf8) {
        if (c == '0' || c == '1') {
            cleanBin += c;
        }
    }

    // Copy from the end (least significant bits)
    int srcLen = static_cast<int>(cleanBin.length());
    int startPos = 64 - srcLen;
    if (startPos < 0) startPos = 0;

    for (int i = startPos, j = 0; i < 64 && j < srcLen; i++, j++) {
        result[i] = cleanBin[j];
    }

    return copy_to_buffer(result, buffer, buffer_size);
}

// ============================================================================
// Word Size Functions (for Programmer Mode)
// ============================================================================

void calculator_set_word_width(CalculatorInstance* instance, CalcWordType word_type) {
    if (!instance || !instance->manager) return;

    CalculationManager::Command cmd;
    switch (word_type) {
        case CALC_WORD_QWORD: cmd = CalculationManager::Command::CommandQword; break;
        case CALC_WORD_DWORD: cmd = CalculationManager::Command::CommandDword; break;
        case CALC_WORD_WORD:  cmd = CalculationManager::Command::CommandWord; break;
        case CALC_WORD_BYTE:  cmd = CalculationManager::Command::CommandByte; break;
        default:              cmd = CalculationManager::Command::CommandQword; break;
    }

    instance->manager->SendCommand(cmd);
    instance->currentWordType = word_type;
}

int calculator_get_word_width(CalculatorInstance* instance) {
    if (instance) {
        return static_cast<int>(instance->currentWordType);
    }
    return CALC_WORD_QWORD;
}

// ============================================================================
// Carry Flag Functions (for Rotate Through Carry)
// ============================================================================

void calculator_set_carry_flag(CalculatorInstance* instance, int carry) {
    if (instance) {
        instance->carryFlag = carry ? 1 : 0;
    }
}

int calculator_get_carry_flag(CalculatorInstance* instance) {
    if (instance) {
        return static_cast<int>(instance->carryFlag);
    }
    return 0;
}

// ============================================================================
// Scientific Mode Functions Implementation
// ============================================================================

void calculator_set_angle_type(CalculatorInstance* instance, CalcAngleType angle_type) {
    if (!instance || !instance->manager) return;

    CalculationManager::Command cmd;
    switch (angle_type) {
        case CALC_ANGLE_DEGREES:  cmd = CalculationManager::Command::CommandDEG; break;
        case CALC_ANGLE_RADIANS:  cmd = CalculationManager::Command::CommandRAD; break;
        case CALC_ANGLE_GRADIANS: cmd = CalculationManager::Command::CommandGRAD; break;
        default:                  cmd = CalculationManager::Command::CommandDEG; break;
    }

    instance->manager->SendCommand(cmd);
    instance->currentAngleType = angle_type;
}

int calculator_get_angle_type(CalculatorInstance* instance) {
    if (instance) {
        return instance->currentAngleType;
    }
    return CALC_ANGLE_DEGREES;
}

// ============================================================================
// Memory Functions Implementation
// ============================================================================

void calculator_memory_store(CalculatorInstance* instance) {
    if (instance && instance->manager) {
        instance->manager->MemorizeNumber();
    }
}

void calculator_memory_recall(CalculatorInstance* instance) {
    if (instance && instance->manager) {
        instance->manager->MemorizedNumberLoad(0);
    }
}

void calculator_memory_add(CalculatorInstance* instance) {
    if (instance && instance->manager) {
        instance->manager->MemorizedNumberAdd(0);
    }
}

void calculator_memory_subtract(CalculatorInstance* instance) {
    if (instance && instance->manager) {
        instance->manager->MemorizedNumberSubtract(0);
    }
}

void calculator_memory_clear(CalculatorInstance* instance) {
    if (instance && instance->manager) {
        instance->manager->MemorizedNumberClearAll();
    }
}

int calculator_memory_get_count(CalculatorInstance* instance) {
    if (instance && instance->display) {
        return static_cast<int>(instance->display->memorizedNumbers.size());
    }
    return 0;
}

int calculator_memory_get_at(CalculatorInstance* instance, int index, char* buffer, int buffer_size) {
    if (!instance || !instance->display) return -1;

    if (index < 0 || index >= static_cast<int>(instance->display->memorizedNumbers.size())) {
        return -1;
    }

    std::string utf8 = wstring_to_utf8(instance->display->memorizedNumbers[index]);
    return copy_to_buffer(utf8, buffer, buffer_size);
}

void calculator_memory_load_at(CalculatorInstance* instance, int index) {
    if (instance && instance->manager && index >= 0) {
        instance->manager->MemorizedNumberLoad(static_cast<unsigned int>(index));
    }
}

void calculator_memory_add_at(CalculatorInstance* instance, int index) {
    if (instance && instance->manager && index >= 0) {
        instance->manager->MemorizedNumberAdd(static_cast<unsigned int>(index));
    }
}

void calculator_memory_subtract_at(CalculatorInstance* instance, int index) {
    if (instance && instance->manager && index >= 0) {
        instance->manager->MemorizedNumberSubtract(static_cast<unsigned int>(index));
    }
}

void calculator_memory_clear_at(CalculatorInstance* instance, int index) {
    if (instance && instance->manager && index >= 0) {
        unsigned int uIndex = static_cast<unsigned int>(index);

        instance->manager->MemorizedNumberClear(uIndex);

        if (uIndex < instance->display->memorizedNumbers.size()) {
            instance->display->memorizedNumbers.erase(
                instance->display->memorizedNumbers.begin() + index
            );

            instance->manager->SetMemorizedNumbersString();
        }
    }
}

void calculator_memory_clear_all(CalculatorInstance* instance) {
    if (instance && instance->manager) {
        instance->manager->MemorizedNumberClearAll();
    }
}

// ============================================================================
// History Functions Implementation
// ============================================================================

int calculator_history_get_count(CalculatorInstance* instance) {
    if (instance && instance->manager) {
        return static_cast<int>(instance->manager->GetHistoryItems().size());
    }
    return 0;
}

int calculator_history_get_expression_at(CalculatorInstance* instance, int index, char* buffer, int buffer_size) {
    if (!instance || !instance->manager) return -1;

    const auto& history = instance->manager->GetHistoryItems();
    if (index < 0 || index >= static_cast<int>(history.size())) {
        return -1;
    }

    std::string utf8 = wstring_to_utf8(history[index]->historyItemVector.expression);
    return copy_to_buffer(utf8, buffer, buffer_size);
}

int calculator_history_get_result_at(CalculatorInstance* instance, int index, char* buffer, int buffer_size) {
    if (!instance || !instance->manager) return -1;

    const auto& history = instance->manager->GetHistoryItems();
    if (index < 0 || index >= static_cast<int>(history.size())) {
        return -1;
    }

    std::string utf8 = wstring_to_utf8(history[index]->historyItemVector.result);
    return copy_to_buffer(utf8, buffer, buffer_size);
}

int calculator_is_in_history_load_mode(CalculatorInstance* instance) {
    if (instance) {
        return instance->isInHistoryLoadMode ? 1 : 0;
    }
    return 0;
}

void calculator_set_history_load_mode(CalculatorInstance* instance, int enabled) {
    if (instance) {
        instance->isInHistoryLoadMode = (enabled != 0);
    }
}

void calculator_history_load_at(CalculatorInstance* instance, int index) {
    if (!instance || !instance->manager) return;

    const auto& history = instance->manager->GetHistoryItems();
    if (index < 0 || index >= static_cast<int>(history.size())) return;

    auto& historyItem = history[index];
    auto& commands = historyItem->historyItemVector.spCommands;

    if (!commands || commands->empty()) return;

    // Reset calculator to clear current state (but keep memory)
    instance->manager->Reset(false);

    // Resend all commands from the history item
    for (auto& command : *commands) {
        auto commandType = command->GetCommandType();

        switch (commandType) {
            case CalculationManager::CommandType::UnaryCommand: {
                auto unaryCmd = static_cast<IUnaryCommand*>(command.get());
                const auto& cmdList = unaryCmd->GetCommands();
                if (cmdList && !cmdList->empty()) {
                    for (int cmd : *cmdList) {
                        instance->manager->SendCommand(static_cast<CalculationManager::Command>(cmd));
                    }
                }
                break;
            }
            case CalculationManager::CommandType::BinaryCommand: {
                auto binaryCmd = static_cast<IBinaryCommand*>(command.get());
                instance->manager->SendCommand(static_cast<CalculationManager::Command>(binaryCmd->GetCommand()));
                break;
            }
            case CalculationManager::CommandType::OperandCommand: {
                auto opndCmd = static_cast<IOpndCommand*>(command.get());
                const auto& cmdList = opndCmd->GetCommands();
                if (cmdList && !cmdList->empty()) {
                    for (int cmd : *cmdList) {
                        instance->manager->SendCommand(static_cast<CalculationManager::Command>(cmd));
                    }
                }
                break;
            }
            case CalculationManager::CommandType::Parentheses: {
                auto parenCmd = static_cast<IParenthesisCommand*>(command.get());
                instance->manager->SendCommand(static_cast<CalculationManager::Command>(parenCmd->GetCommand()));
                break;
            }
            default:
                break;
        }
    }

    // Send equals to update display and create history entry
    instance->manager->SendCommand(static_cast<CalculationManager::Command>(IDC_EQU));

    // Immediately remove the history entry that was just created
    // This matches Microsoft Calculator's behavior where clicking history
    // doesn't create a new entry until the user continues with an operator
    const auto& newHistory = instance->manager->GetHistoryItems();
    if (!newHistory.empty()) {
        instance->manager->RemoveHistoryItem(static_cast<unsigned int>(newHistory.size() - 1));
    }

    // Set flag to track that we're in "history load" state
    // When user clicks an operator, we'll stay in this mode so no new entry is created
    // for that operator, but instead the loaded expression will be finalized in history
    instance->isInHistoryLoadMode = true;
}

int calculator_history_remove_at(CalculatorInstance* instance, int index) {
    if (instance && instance->manager && index >= 0) {
        return instance->manager->RemoveHistoryItem(static_cast<unsigned int>(index)) ? 1 : 0;
    }
    return 0;
}

void calculator_history_clear(CalculatorInstance* instance) {
    if (instance && instance->manager) {
        instance->manager->ClearHistory();
    }
}

// ============================================================================
// Per-Mode History Functions (NEW)
// ============================================================================

int calculator_history_get_count_for_mode(CalculatorInstance* instance, CalcMode mode) {
    if (instance && instance->manager) {
        CalculationManager::CalculatorMode calcMode;
        switch (mode) {
            case CALC_MODE_STANDARD:
                calcMode = CalculationManager::CalculatorMode::Standard;
                break;
            case CALC_MODE_SCIENTIFIC:
                calcMode = CalculationManager::CalculatorMode::Scientific;
                break;
            case CALC_MODE_PROGRAMMER:
                // Programmer mode uses Standard mode history
                calcMode = CalculationManager::CalculatorMode::Standard;
                break;
            default:
                return 0;
        }
        return static_cast<int>(instance->manager->GetHistoryItems(calcMode).size());
    }
    return 0;
}

int calculator_history_get_expression_at_for_mode(CalculatorInstance* instance, CalcMode mode, int index, char* buffer, int buffer_size) {
    if (!instance || !instance->manager) return -1;

    CalculationManager::CalculatorMode calcMode;
    switch (mode) {
        case CALC_MODE_STANDARD:
            calcMode = CalculationManager::CalculatorMode::Standard;
            break;
        case CALC_MODE_SCIENTIFIC:
            calcMode = CalculationManager::CalculatorMode::Scientific;
            break;
        case CALC_MODE_PROGRAMMER:
            // Programmer mode uses Standard mode history
            calcMode = CalculationManager::CalculatorMode::Standard;
            break;
        default:
            return -1;
    }

    const auto& history = instance->manager->GetHistoryItems(calcMode);
    if (index < 0 || index >= static_cast<int>(history.size())) {
        return -1;
    }

    std::string utf8 = wstring_to_utf8(history[index]->historyItemVector.expression);
    return copy_to_buffer(utf8, buffer, buffer_size);
}

int calculator_history_get_result_at_for_mode(CalculatorInstance* instance, CalcMode mode, int index, char* buffer, int buffer_size) {
    if (!instance || !instance->manager) return -1;

    CalculationManager::CalculatorMode calcMode;
    switch (mode) {
        case CALC_MODE_STANDARD:
            calcMode = CalculationManager::CalculatorMode::Standard;
            break;
        case CALC_MODE_SCIENTIFIC:
            calcMode = CalculationManager::CalculatorMode::Scientific;
            break;
        case CALC_MODE_PROGRAMMER:
            // Programmer mode uses Standard mode history
            calcMode = CalculationManager::CalculatorMode::Standard;
            break;
        default:
            return -1;
    }

    const auto& history = instance->manager->GetHistoryItems(calcMode);
    if (index < 0 || index >= static_cast<int>(history.size())) {
        return -1;
    }

    std::string utf8 = wstring_to_utf8(history[index]->historyItemVector.result);
    return copy_to_buffer(utf8, buffer, buffer_size);
}

void calculator_history_set_from_vector(CalculatorInstance* instance, const char* json_data) {
    // This function would restore history from serialized data
    // For now, we'll implement a simpler approach using the existing SetHistoryItems
    // Note: A full implementation would require JSON parsing and reconstruction of HISTORYITEM objects
    // This is a placeholder for future implementation
    if (!instance || !instance->manager || !json_data) return;

    // TODO: Implement JSON deserialization and history restoration
    // For now, this function is a no-op as the complex HISTORYITEM structure
    // with spCommands makes serialization challenging
}

void calculator_history_clear_for_mode(CalculatorInstance* instance, CalcMode mode) {
    if (!instance || !instance->manager) return;

    CalculationManager::CalculatorMode calcMode;
    switch (mode) {
        case CALC_MODE_STANDARD:
            calcMode = CalculationManager::CalculatorMode::Standard;
            break;
        case CALC_MODE_SCIENTIFIC:
            calcMode = CalculationManager::CalculatorMode::Scientific;
            break;
        case CALC_MODE_PROGRAMMER:
            // Programmer mode uses Standard mode history
            calcMode = CalculationManager::CalculatorMode::Standard;
            break;
        default:
            return;
    }

    // Clear history by switching to that mode, clearing, then switching back
    auto currentMode = instance->currentMode;

    // Temporarily switch to the target mode
    switch (mode) {
        case CALC_MODE_STANDARD:
            instance->manager->SetStandardMode();
            break;
        case CALC_MODE_SCIENTIFIC:
            instance->manager->SetScientificMode();
            break;
        case CALC_MODE_PROGRAMMER:
            instance->manager->SetProgrammerMode();
            break;
    }

    // Clear the history
    instance->manager->ClearHistory();

    // Switch back to the original mode
    switch (currentMode) {
        case CALC_MODE_STANDARD:
            instance->manager->SetStandardMode();
            break;
        case CALC_MODE_SCIENTIFIC:
            instance->manager->SetScientificMode();
            break;
        case CALC_MODE_PROGRAMMER:
            instance->manager->SetProgrammerMode();
            break;
    }
}

// ============================================================================
// Parenthesis
// ============================================================================

int calculator_get_parenthesis_count(CalculatorInstance* instance) {
    if (instance && instance->display) {
        return static_cast<int>(instance->display->parenthesisCount);
    }
    return 0;
}

// ============================================================================
// Unit Converter Data Loader Implementation
// ============================================================================

class UnitConverterDataLoader : public UnitConversionManager::IConverterDataLoader {
public:
    void LoadData() override {
        if (m_loaded) return;

        // Define categories
        m_categories = {
            {0, L"Length", true},
            {1, L"Weight and Mass", true},
            {2, L"Temperature", true},
            {3, L"Energy", true},
            {4, L"Area", true},
            {5, L"Speed", true},
            {6, L"Time", true},
            {7, L"Power", true},
            {8, L"Data", false},
            {9, L"Pressure", true},
            {10, L"Angle", true},
            {11, L"Volume", true},
        };

        // Define units for each category
        initLengthUnits();
        initWeightUnits();
        initTemperatureUnits();
        initEnergyUnits();
        initAreaUnits();
        initSpeedUnits();
        initTimeUnits();
        initPowerUnits();
        initDataUnits();
        initPressureUnits();
        initAngleUnits();
        initVolumeUnits();

        m_loaded = true;
    }

    std::vector<UnitConversionManager::Category> GetOrderedCategories() override {
        return m_categories;
    }

    std::vector<UnitConversionManager::Unit> GetOrderedUnits(const UnitConversionManager::Category& c) override {
        auto it = m_categoryUnits.find(c.id);
        if (it != m_categoryUnits.end()) {
            return it->second;
        }
        return {};
    }

    std::unordered_map<UnitConversionManager::Unit, UnitConversionManager::ConversionData, UnitConversionManager::UnitHash>
    LoadOrderedRatios(const UnitConversionManager::Unit& u) override {
        auto it = m_ratios.find(u.id);
        if (it != m_ratios.end()) {
            return it->second;
        }
        return {};
    }

    bool SupportsCategory(const UnitConversionManager::Category& target) override {
        for (const auto& cat : m_categories) {
            if (cat.id == target.id) return true;
        }
        return false;
    }

private:
    bool m_loaded = false;
    std::vector<UnitConversionManager::Category> m_categories;
    std::unordered_map<int, std::vector<UnitConversionManager::Unit>> m_categoryUnits;
    std::unordered_map<int, std::unordered_map<UnitConversionManager::Unit, UnitConversionManager::ConversionData, UnitConversionManager::UnitHash>> m_ratios;
    std::unordered_map<int, UnitConversionManager::Unit> m_unitById; // Map unit ID to complete Unit object

    void addUnit(int categoryId, int unitId, const std::wstring& name, const std::wstring& abbr, bool isWhimsical = false) {
        UnitConversionManager::Unit unit(unitId, name, abbr, true, true, isWhimsical);
        m_categoryUnits[categoryId].push_back(unit);
        m_unitById[unitId] = unit; // Store complete unit object
    }

    void addRatio(int fromUnitId, int toUnitId, double ratio, double offset = 0.0, bool offsetFirst = false) {
        // Use complete Unit objects from m_unitById instead of creating empty ones
        // The structure is: m_ratios[fromUnitId][toUnit] = conversionData
        m_ratios[fromUnitId][m_unitById[toUnitId]] = UnitConversionManager::ConversionData(ratio, offset, offsetFirst);
    }

    // Helper function to automatically add bidirectional conversions between all units in a category
    // based on conversion factors to a base unit (like the original Windows Calculator implementation)
    void addBidirectionalConversions(int categoryId, std::vector<std::pair<int, double>> unitFactors) {
        // unitFactors: vector of (unitId, factorToBaseUnit)
        // For each pair of units, calculate the conversion ratio: factor_A / factor_B
        for (size_t i = 0; i < unitFactors.size(); i++) {
            for (size_t j = 0; j < unitFactors.size(); j++) {
                int fromUnitId = unitFactors[i].first;
                int toUnitId = unitFactors[j].first;
                double fromFactor = unitFactors[i].second;
                double toFactor = unitFactors[j].second;

                if (i == j) {
                    // Same unit: add identity conversion (ratio = 1.0)
                    addRatio(fromUnitId, toUnitId, 1.0);
                } else {
                    // Different units: calculate conversion ratio
                    double ratio = fromFactor / toFactor;
                    addRatio(fromUnitId, toUnitId, ratio);
                }
            }
        }
    }

    void initLengthUnits() {
        // Length units (category 0)
        addUnit(0, 100, L"Meters", L"m");
        addUnit(0, 101, L"Kilometers", L"km");
        addUnit(0, 102, L"Centimeters", L"cm");
        addUnit(0, 103, L"Millimeters", L"mm");
        addUnit(0, 104, L"Micrometers", L"μm");
        addUnit(0, 105, L"Nanometers", L"nm");
        addUnit(0, 106, L"Miles", L"mi");
        addUnit(0, 107, L"Yards", L"yd");
        addUnit(0, 108, L"Feet", L"ft");
        addUnit(0, 109, L"Inches", L"in");

        // Use automatic bidirectional conversion based on factors to meters (base unit)
        // Factors are relative to meters: 1 m = 1.0, 1 km = 1000 m, etc.
        std::vector<std::pair<int, double>> lengthFactors;
        lengthFactors.push_back(std::make_pair(100, 1.0));          // Meters (base)
        lengthFactors.push_back(std::make_pair(101, 1000.0));       // Kilometers
        lengthFactors.push_back(std::make_pair(102, 0.01));         // Centimeters
        lengthFactors.push_back(std::make_pair(103, 0.001));        // Millimeters
        lengthFactors.push_back(std::make_pair(104, 0.000001));     // Micrometers
        lengthFactors.push_back(std::make_pair(105, 0.000000001));  // Nanometers
        lengthFactors.push_back(std::make_pair(106, 1609.344));     // Miles
        lengthFactors.push_back(std::make_pair(107, 0.9144));       // Yards
        lengthFactors.push_back(std::make_pair(108, 0.3048));       // Feet
        lengthFactors.push_back(std::make_pair(109, 0.0254));       // Inches
        addBidirectionalConversions(0, lengthFactors);
    }

    void initWeightUnits() {
        // Weight units (category 1)
        addUnit(1, 200, L"Kilograms", L"kg");
        addUnit(1, 201, L"Grams", L"g");
        addUnit(1, 202, L"Milligrams", L"mg");
        addUnit(1, 203, L"Metric tons", L"t");
        addUnit(1, 204, L"Pounds", L"lb");
        addUnit(1, 205, L"Ounces", L"oz");
        addUnit(1, 206, L"Stones", L"st");

        // Use automatic bidirectional conversion based on factors to kilograms (base unit)
        std::vector<std::pair<int, double>> weightFactors;
        weightFactors.push_back(std::make_pair(200, 1.0));          // Kilograms (base)
        weightFactors.push_back(std::make_pair(201, 0.001));        // Grams
        weightFactors.push_back(std::make_pair(202, 0.000001));     // Milligrams
        weightFactors.push_back(std::make_pair(203, 1000.0));       // Metric tons
        weightFactors.push_back(std::make_pair(204, 0.45359237));   // Pounds
        weightFactors.push_back(std::make_pair(205, 0.028349523125)); // Ounces
        weightFactors.push_back(std::make_pair(206, 6.35029318));    // Stones
        addBidirectionalConversions(1, weightFactors);
    }

    void initTemperatureUnits() {
        // Temperature units (category 2)
        addUnit(2, 300, L"Celsius", L"°C");
        addUnit(2, 301, L"Fahrenheit", L"°F");
        addUnit(2, 302, L"Kelvin", L"K");

        // Temperature conversions are special (offset-based)
        addRatio(300, 301, 1.8, 32.0, false);    // C to F: F = C * 1.8 + 32
        addRatio(300, 302, 1.0, 273.15, false);  // C to K: K = C + 273.15
        addRatio(301, 300, 1.0/1.8, -32.0/1.8, true); // F to C: C = (F - 32) / 1.8
        addRatio(302, 300, 1.0, -273.15, false); // K to C: C = K - 273.15
    }

    void initEnergyUnits() {
        // Energy units (category 3)
        addUnit(3, 400, L"Joules", L"J");
        addUnit(3, 401, L"Kilojoules", L"kJ");
        addUnit(3, 402, L"Calories", L"cal");
        addUnit(3, 403, L"Kilocalories", L"kcal");
        addUnit(3, 404, L"Watt-hours", L"Wh");
        addUnit(3, 405, L"Kilowatt-hours", L"kWh");
        addUnit(3, 406, L"Electronvolts", L"eV");
        addUnit(3, 407, L"British thermal units", L"BTU");

        addRatio(400, 401, 0.001);
        addRatio(400, 402, 0.239006);
        addRatio(400, 403, 0.000239006);
        addRatio(400, 404, 0.000277778);
        addRatio(400, 405, 2.77778e-7);
        addRatio(400, 407, 0.000947817);
    }

    void initAreaUnits() {
        // Area units (category 4)
        addUnit(4, 500, L"Square meters", L"m²");
        addUnit(4, 501, L"Square kilometers", L"km²");
        addUnit(4, 502, L"Square centimeters", L"cm²");
        addUnit(4, 503, L"Hectares", L"ha");
        addUnit(4, 504, L"Square miles", L"mi²");
        addUnit(4, 505, L"Square yards", L"yd²");
        addUnit(4, 506, L"Square feet", L"ft²");
        addUnit(4, 507, L"Square inches", L"in²");
        addUnit(4, 508, L"Acres", L"ac");

        // Use automatic bidirectional conversion (factors to square meters as base)
        std::vector<std::pair<int, double>> areaFactors;
        areaFactors.push_back(std::make_pair(500, 1.0));         // Square meters (base)
        areaFactors.push_back(std::make_pair(501, 1000000.0));   // Square kilometers
        areaFactors.push_back(std::make_pair(502, 0.0001));      // Square centimeters
        areaFactors.push_back(std::make_pair(503, 10000.0));     // Hectares
        areaFactors.push_back(std::make_pair(504, 2589988.110336)); // Square miles
        areaFactors.push_back(std::make_pair(505, 0.83612736));   // Square yards
        areaFactors.push_back(std::make_pair(506, 0.09290304));   // Square feet
        areaFactors.push_back(std::make_pair(507, 0.00064516));   // Square inches
        areaFactors.push_back(std::make_pair(508, 4046.8564224)); // Acres
        addBidirectionalConversions(4, areaFactors);
    }

    void initSpeedUnits() {
        // Speed units (category 5)
        addUnit(5, 600, L"Meters per second", L"m/s");
        addUnit(5, 601, L"Kilometers per hour", L"km/h");
        addUnit(5, 602, L"Miles per hour", L"mph");
        addUnit(5, 603, L"Feet per second", L"ft/s");
        addUnit(5, 604, L"Knots", L"kn");
        addUnit(5, 605, L"Mach", L"Ma");

        // Use automatic bidirectional conversion (factors to m/s as base, scaled by 100)
        std::vector<std::pair<int, double>> speedFactors;
        speedFactors.push_back(std::make_pair(600, 100.0));      // m/s (base scaled)
        speedFactors.push_back(std::make_pair(601, 27.77777777777778)); // km/h
        speedFactors.push_back(std::make_pair(602, 44.704));     // mph
        speedFactors.push_back(std::make_pair(603, 30.48));      // ft/s
        speedFactors.push_back(std::make_pair(604, 51.444));     // knots
        speedFactors.push_back(std::make_pair(605, 340.3));      // Mach
        addBidirectionalConversions(5, speedFactors);
    }

    void initTimeUnits() {
        // Time units (category 6)
        addUnit(6, 700, L"Seconds", L"s");
        addUnit(6, 701, L"Milliseconds", L"ms");
        addUnit(6, 702, L"Microseconds", L"μs");
        addUnit(6, 703, L"Nanoseconds", L"ns");
        addUnit(6, 704, L"Minutes", L"min");
        addUnit(6, 705, L"Hours", L"h");
        addUnit(6, 706, L"Days", L"d");
        addUnit(6, 707, L"Weeks", L"wk");
        addUnit(6, 708, L"Years", L"yr");

        // Use automatic bidirectional conversion (factors to seconds as base)
        std::vector<std::pair<int, double>> timeFactors;
        timeFactors.push_back(std::make_pair(700, 1.0));           // Seconds (base)
        timeFactors.push_back(std::make_pair(701, 0.001));        // Milliseconds
        timeFactors.push_back(std::make_pair(702, 0.000001));     // Microseconds
        timeFactors.push_back(std::make_pair(703, 0.000000001));  // Nanoseconds
        timeFactors.push_back(std::make_pair(704, 60.0));         // Minutes
        timeFactors.push_back(std::make_pair(705, 3600.0));       // Hours
        timeFactors.push_back(std::make_pair(706, 86400.0));      // Days
        timeFactors.push_back(std::make_pair(707, 604800.0));     // Weeks
        timeFactors.push_back(std::make_pair(708, 31557600.0));   // Years (using 365.25 days)
        addBidirectionalConversions(6, timeFactors);
    }

    void initPowerUnits() {
        // Power units (category 7)
        addUnit(7, 800, L"Watts", L"W");
        addUnit(7, 801, L"Kilowatts", L"kW");
        addUnit(7, 802, L"Megawatts", L"MW");
        addUnit(7, 803, L"Horsepower (metric)", L"hp");
        addUnit(7, 804, L"BTU per minute", L"BTU/min");

        // Use automatic bidirectional conversion (factors to Watts as base)
        std::vector<std::pair<int, double>> powerFactors;
        powerFactors.push_back(std::make_pair(800, 1.0));         // Watts (base)
        powerFactors.push_back(std::make_pair(801, 1000.0));      // Kilowatts
        powerFactors.push_back(std::make_pair(802, 1000000.0));   // Megawatts
        powerFactors.push_back(std::make_pair(803, 735.49875));   // Horsepower
        powerFactors.push_back(std::make_pair(804, 17.58426466666667)); // BTU/min
        addBidirectionalConversions(7, powerFactors);
    }

    void initDataUnits() {
        // Data units (category 8)
        addUnit(8, 900, L"Bytes", L"B");
        addUnit(8, 901, L"Kilobytes", L"KB");
        addUnit(8, 902, L"Megabytes", L"MB");
        addUnit(8, 903, L"Gigabytes", L"GB");
        addUnit(8, 904, L"Terabytes", L"TB");
        addUnit(8, 905, L"Petabytes", L"PB");
        addUnit(8, 906, L"Bits", L"b");
        addUnit(8, 907, L"Kibibytes", L"KiB");
        addUnit(8, 908, L"Mebibytes", L"MiB");
        addUnit(8, 909, L"Gibibytes", L"GiB");

        addRatio(900, 901, 0.001);
        addRatio(900, 902, 0.000001);
        addRatio(900, 903, 1e-9);
        addRatio(900, 904, 1e-12);
        addRatio(900, 905, 1e-15);
        addRatio(900, 906, 8);
        addRatio(900, 907, 1.0/1024.0);
        addRatio(900, 908, 1.0/1048576.0);
        addRatio(900, 909, 1.0/1073741824.0);
    }

    void initPressureUnits() {
        // Pressure units (category 9)
        addUnit(9, 1000, L"Pascals", L"Pa");
        addUnit(9, 1001, L"Kilopascals", L"kPa");
        addUnit(9, 1002, L"Bars", L"bar");
        addUnit(9, 1003, L"Atmospheres", L"atm");
        addUnit(9, 1004, L"Pounds per square inch", L"psi");
        addUnit(9, 1005, L"Millimeters of mercury", L"mmHg");

        addRatio(1000, 1001, 0.001);
        addRatio(1000, 1002, 0.00001);
        addRatio(1000, 1003, 9.8692e-6);
        addRatio(1000, 1004, 0.000145038);
        addRatio(1000, 1005, 0.00750062);
    }

    void initAngleUnits() {
        // Angle units (category 10)
        addUnit(10, 1100, L"Degrees", L"°");
        addUnit(10, 1101, L"Radians", L"rad");
        addUnit(10, 1102, L"Gradians", L"grad");
        addUnit(10, 1103, L"Turns", L"tr");

        addRatio(1100, 1101, 0.0174533);
        addRatio(1100, 1102, 1.11111);
        addRatio(1100, 1103, 0.00277778);
    }

    void initVolumeUnits() {
        // Volume units (category 11)
        addUnit(11, 1200, L"Liters", L"L");
        addUnit(11, 1201, L"Milliliters", L"mL");
        addUnit(11, 1202, L"Cubic meters", L"m³");
        addUnit(11, 1203, L"Cubic centimeters", L"cm³");
        addUnit(11, 1204, L"US gallons", L"gal");
        addUnit(11, 1205, L"US quarts", L"qt");
        addUnit(11, 1206, L"US pints", L"pt");
        addUnit(11, 1207, L"US cups", L"cup");
        addUnit(11, 1208, L"US fluid ounces", L"fl oz");
        addUnit(11, 1209, L"US tablespoons", L"tbsp");
        addUnit(11, 1210, L"US teaspoons", L"tsp");
        addUnit(11, 1211, L"Imperial gallons", L"imp gal");
        addUnit(11, 1212, L"Cubic feet", L"ft³");
        addUnit(11, 1213, L"Cubic inches", L"in³");
        addUnit(11, 1214, L"Cubic yards", L"yd³");
        addUnit(11, 1215, L"Imperial fluid ounces", L"imp fl oz");
        addUnit(11, 1216, L"Imperial pints", L"imp pt");
        addUnit(11, 1217, L"Imperial quarts", L"imp qt");
        addUnit(11, 1218, L"Imperial teaspoons", L"imp tsp");   // UK teaspoons
        addUnit(11, 1219, L"Imperial tablespoons", L"imp tbsp"); // UK tablespoons

        // Whimsical units (fun units for educational purposes)
        addUnit(11, 1220, L"Metric cups", L"metric cup", true);       // Same as CoffeeCup in original
        addUnit(11, 1221, L"Bathtubs", L"bathtub", true);             // Large volume
        addUnit(11, 1222, L"Swimming pools", L"pool", true);          // Very large volume

        // Use automatic bidirectional conversion based on factors to cubic centimeters (base unit)
        // Factors are from original Windows Calculator code (cm³ = 1 as base)
        std::vector<std::pair<int, double>> volumeFactors;
        volumeFactors.push_back(std::make_pair(1200, 1000.0));        // Liters
        volumeFactors.push_back(std::make_pair(1201, 1.0));           // Milliliters
        volumeFactors.push_back(std::make_pair(1202, 1000000.0));     // Cubic meters
        volumeFactors.push_back(std::make_pair(1203, 1.0));           // Cubic centimeters (base)
        volumeFactors.push_back(std::make_pair(1204, 3785.411784));   // US gallons
        volumeFactors.push_back(std::make_pair(1205, 946.352946));    // US quarts
        volumeFactors.push_back(std::make_pair(1206, 473.176473));    // US pints
        volumeFactors.push_back(std::make_pair(1207, 236.588237));    // US cups
        volumeFactors.push_back(std::make_pair(1208, 29.5735295625)); // US fluid ounces
        volumeFactors.push_back(std::make_pair(1209, 14.78676478125));// US tablespoons
        volumeFactors.push_back(std::make_pair(1210, 4.92892159375)); // US teaspoons
        volumeFactors.push_back(std::make_pair(1211, 4546.09));       // Imperial gallons
        volumeFactors.push_back(std::make_pair(1212, 28316.846592));  // Cubic feet
        volumeFactors.push_back(std::make_pair(1213, 16.387064));     // Cubic inches
        volumeFactors.push_back(std::make_pair(1214, 764554.857984)); // Cubic yards
        volumeFactors.push_back(std::make_pair(1215, 28.4130625));    // Imperial fluid ounces
        volumeFactors.push_back(std::make_pair(1216, 568.26125));     // Imperial pints
        volumeFactors.push_back(std::make_pair(1217, 1136.5225));     // Imperial quarts
        volumeFactors.push_back(std::make_pair(1218, 3.5516328125));  // Imperial teaspoons (UK tsp)
        volumeFactors.push_back(std::make_pair(1219, 17.7581640625)); // Imperial tablespoons (UK tbsp)
        volumeFactors.push_back(std::make_pair(1220, 236.5882));      // Metric cups (whimsical)
        volumeFactors.push_back(std::make_pair(1221, 378541.2));      // Bathtubs (whimsical)
        volumeFactors.push_back(std::make_pair(1222, 3750000000.0));  // Swimming pools (whimsical)
        addBidirectionalConversions(11, volumeFactors);
    }
};

// ============================================================================
// Unit Converter VM Callback Implementation
// ============================================================================

class UnitConverterVMCallbackImpl : public UnitConversionManager::IUnitConverterVMCallback {
public:
    std::wstring fromValue;
    std::wstring toValue;
    std::vector<std::tuple<std::wstring, UnitConversionManager::Unit>> suggestedValues;

    void DisplayCallback(const std::wstring& from, const std::wstring& to) override {
        fromValue = from;
        toValue = to;
    }

    void SuggestedValueCallback(const std::vector<std::tuple<std::wstring, UnitConversionManager::Unit>>& suggestedValues) override {
        this->suggestedValues = suggestedValues;
    }
    void MaxDigitsReached() override {}
};

// ============================================================================
// Unit Converter Instance Structure
// ============================================================================

struct UnitConverterInstance {
    std::shared_ptr<UnitConversionManager::UnitConverter> converter;
    std::shared_ptr<UnitConverterDataLoader> dataLoader;
    std::shared_ptr<UnitConverterVMCallbackImpl> callback;
    std::vector<UnitConversionManager::Category> categories;
    std::vector<UnitConversionManager::Unit> currentUnits;
    int currentCategoryId = -1;
    int fromUnitId = -1;
    int toUnitId = -1;
};

// ============================================================================
// Unit Converter Functions Implementation
// ============================================================================

UnitConverterInstance* unit_converter_create(void) {
    auto instance = new UnitConverterInstance();

    instance->dataLoader = std::make_shared<UnitConverterDataLoader>();
    instance->callback = std::make_shared<UnitConverterVMCallbackImpl>();
    instance->converter = std::make_shared<UnitConversionManager::UnitConverter>(instance->dataLoader);

    instance->converter->Initialize();
    instance->converter->SetViewModelCallback(instance->callback);

    instance->categories = instance->converter->GetCategories();

    // Set default category
    if (!instance->categories.empty()) {
        instance->currentCategoryId = instance->categories[0].id;
        auto [units, fromUnit, toUnit] = instance->converter->SetCurrentCategory(instance->categories[0]);
        instance->currentUnits = units;
        instance->fromUnitId = fromUnit.id;
        instance->toUnitId = toUnit.id;
    }

    return instance;
}

void unit_converter_destroy(UnitConverterInstance* instance) {
    delete instance;
}

int unit_converter_get_category_count(UnitConverterInstance* instance) {
    if (instance) {
        return static_cast<int>(instance->categories.size());
    }
    return 0;
}

int unit_converter_get_category_name(UnitConverterInstance* instance, int index, char* buffer, int buffer_size) {
    if (!instance || index < 0 || index >= static_cast<int>(instance->categories.size())) {
        return -1;
    }

    std::string utf8 = wstring_to_utf8(instance->categories[index].name);
    return copy_to_buffer(utf8, buffer, buffer_size);
}

int unit_converter_get_category_id(UnitConverterInstance* instance, int index) {
    if (!instance || index < 0 || index >= static_cast<int>(instance->categories.size())) {
        return -1;
    }
    return instance->categories[index].id;
}

void unit_converter_set_category(UnitConverterInstance* instance, int category_id) {
    if (!instance || !instance->converter) return;

    for (const auto& cat : instance->categories) {
        if (cat.id == category_id) {
            instance->currentCategoryId = category_id;
            auto [units, fromUnit, toUnit] = instance->converter->SetCurrentCategory(cat);
            instance->currentUnits = units;
            instance->fromUnitId = fromUnit.id;
            instance->toUnitId = toUnit.id;
            break;
        }
    }
}

int unit_converter_get_current_category(UnitConverterInstance* instance) {
    if (instance) {
        return instance->currentCategoryId;
    }
    return -1;
}

int unit_converter_get_unit_count(UnitConverterInstance* instance) {
    if (instance) {
        return static_cast<int>(instance->currentUnits.size());
    }
    return 0;
}

int unit_converter_get_unit_name(UnitConverterInstance* instance, int index, char* buffer, int buffer_size) {
    if (!instance || index < 0 || index >= static_cast<int>(instance->currentUnits.size())) {
        return -1;
    }

    std::string utf8 = wstring_to_utf8(instance->currentUnits[index].name);
    return copy_to_buffer(utf8, buffer, buffer_size);
}

int unit_converter_get_unit_abbreviation(UnitConverterInstance* instance, int index, char* buffer, int buffer_size) {
    if (!instance || index < 0 || index >= static_cast<int>(instance->currentUnits.size())) {
        return -1;
    }

    std::string utf8 = wstring_to_utf8(instance->currentUnits[index].abbreviation);
    return copy_to_buffer(utf8, buffer, buffer_size);
}

int unit_converter_get_unit_id(UnitConverterInstance* instance, int index) {
    if (!instance || index < 0 || index >= static_cast<int>(instance->currentUnits.size())) {
        return -1;
    }
    return instance->currentUnits[index].id;
}

int unit_converter_is_unit_whimsical(UnitConverterInstance* instance, int index) {
    if (!instance || index < 0 || index >= static_cast<int>(instance->currentUnits.size())) {
        return 0;
    }
    return instance->currentUnits[index].isWhimsical ? 1 : 0;
}

void unit_converter_set_from_unit(UnitConverterInstance* instance, int unit_id) {
    if (!instance || !instance->converter) return;

    for (const auto& unit : instance->currentUnits) {
        if (unit.id == unit_id) {
            instance->fromUnitId = unit_id;
            // Find the current "to" unit
            for (const auto& toUnit : instance->currentUnits) {
                if (toUnit.id == instance->toUnitId) {
                    instance->converter->SetCurrentUnitTypes(unit, toUnit);
                    break;
                }
            }
            break;
        }
    }
}

void unit_converter_set_to_unit(UnitConverterInstance* instance, int unit_id) {
    if (!instance || !instance->converter) return;

    for (const auto& unit : instance->currentUnits) {
        if (unit.id == unit_id) {
            instance->toUnitId = unit_id;
            // Find the current "from" unit
            for (const auto& fromUnit : instance->currentUnits) {
                if (fromUnit.id == instance->fromUnitId) {
                    instance->converter->SetCurrentUnitTypes(fromUnit, unit);
                    break;
                }
            }
            break;
        }
    }
}

int unit_converter_get_from_unit(UnitConverterInstance* instance) {
    if (instance) {
        return instance->fromUnitId;
    }
    return -1;
}

int unit_converter_get_to_unit(UnitConverterInstance* instance) {
    if (instance) {
        return instance->toUnitId;
    }
    return -1;
}

void unit_converter_swap_units(UnitConverterInstance* instance) {
    if (!instance || !instance->converter) return;

    int temp = instance->fromUnitId;
    instance->fromUnitId = instance->toUnitId;
    instance->toUnitId = temp;

    instance->converter->SwitchActive(L"");
}

void unit_converter_send_command(UnitConverterInstance* instance, CalculatorCommand command) {
    if (!instance || !instance->converter) return;

    UnitConversionManager::Command cmd;
    switch (command) {
        case 0: cmd = UnitConversionManager::Command::Zero; break;
        case 1: cmd = UnitConversionManager::Command::One; break;
        case 2: cmd = UnitConversionManager::Command::Two; break;
        case 3: cmd = UnitConversionManager::Command::Three; break;
        case 4: cmd = UnitConversionManager::Command::Four; break;
        case 5: cmd = UnitConversionManager::Command::Five; break;
        case 6: cmd = UnitConversionManager::Command::Six; break;
        case 7: cmd = UnitConversionManager::Command::Seven; break;
        case 8: cmd = UnitConversionManager::Command::Eight; break;
        case 9: cmd = UnitConversionManager::Command::Nine; break;
        case 10: cmd = UnitConversionManager::Command::Decimal; break;
        case 11: cmd = UnitConversionManager::Command::Negate; break;
        case 12: cmd = UnitConversionManager::Command::Backspace; break;
        case 13: cmd = UnitConversionManager::Command::Clear; break;
        case 14: cmd = UnitConversionManager::Command::Reset; break;
        default: cmd = UnitConversionManager::Command::None; break;
    }

    instance->converter->SendCommand(cmd);
}

int unit_converter_get_from_value(UnitConverterInstance* instance, char* buffer, int buffer_size) {
    if (!instance || !instance->callback) return -1;

    std::string utf8 = wstring_to_utf8(instance->callback->fromValue);
    return copy_to_buffer(utf8, buffer, buffer_size);
}

int unit_converter_get_to_value(UnitConverterInstance* instance, char* buffer, int buffer_size) {
    if (!instance || !instance->callback) return -1;

    std::string utf8 = wstring_to_utf8(instance->callback->toValue);
    return copy_to_buffer(utf8, buffer, buffer_size);
}

void unit_converter_reset(UnitConverterInstance* instance) {
    if (instance && instance->converter) {
        instance->converter->SendCommand(UnitConversionManager::Command::Reset);
    }
}

// ============================================================================
// Backward Compatibility (old function names)
// ============================================================================

// These are kept for backward compatibility with existing code
CalculatorInstance* calculator_init() {
    return calculator_create();
}

void calculator_free(CalculatorInstance* instance) {
    calculator_destroy(instance);
}

int calculator_get_result_length(CalculatorInstance* instance) {
    if (!instance || !instance->display) return -1;
    return static_cast<int>(wstring_to_utf8(instance->display->primaryDisplay).length());
}

int calculator_get_result(CalculatorInstance* instance, char* buffer, int buffer_size) {
    return calculator_get_primary_display(instance, buffer, buffer_size);
}

// ============================================================================
// Suggested Values Functions (from CalculateSuggested)
// ============================================================================

int unit_converter_get_suggested_count(UnitConverterInstance* instance) {
    if (!instance) {
        return -1;
    }
    if (!instance->callback) {
        return -2;
    }
    return static_cast<int>(instance->callback->suggestedValues.size());
}

int unit_converter_get_suggested_value(UnitConverterInstance* instance, int index, char* value_buffer, int value_buffer_size, char* unit_buffer, int unit_buffer_size) {
    if (!instance) return -1;
    if (!instance->callback) return -2;
    if (!value_buffer || value_buffer_size <= 0) return -3;
    if (!unit_buffer || unit_buffer_size <= 0) return -4;

    const auto& suggested = instance->callback->suggestedValues;
    if (index < 0 || index >= static_cast<int>(suggested.size())) {
        return -5;  // Index out of range
    }

    const auto& [valueStr, unit] = suggested[index];

    // Convert value to UTF-8
    std::string valueUtf8 = wstring_to_utf8(valueStr);
    if (valueUtf8.empty() && !valueStr.empty()) {
        return -6;  // Conversion failed
    }
    int valueLen = copy_to_buffer(valueUtf8, value_buffer, value_buffer_size);
    if (valueLen < 0) return -7;

    // Convert unit name to UTF-8
    std::string unitUtf8 = wstring_to_utf8(unit.name);
    if (unitUtf8.empty() && !unit.name.empty()) {
        return -8;  // Conversion failed
    }
    int unitLen = copy_to_buffer(unitUtf8, unit_buffer, unit_buffer_size);
    if (unitLen < 0) return -9;

    // Return unit ID on success (>= 0)
    return unit.id;
}
