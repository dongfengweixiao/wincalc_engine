// calc_manager_wrapper.cpp
// C++包装层的实现

#include "calc_manager_wrapper.h"

#include <cstring>
#include <memory>
#include <string>

// 引入CalcManager的头文件
#include <CalculatorManager.h>
#include <CalculatorResource.h>
#include <EngineStrings.h>
#include <ICalcDisplay.h>

// 实现IResourceProvider接口
class ResourceProviderImpl : public CalculationManager::IResourceProvider {
 public:
  virtual ~ResourceProviderImpl() {}
  std::wstring GetCEngineString(std::wstring_view id) override {
    // 提供必要的资源字符串
    if (id == L"sDecimal") return L".";
    if (id == L"sThousand") return L",";
    if (id == L"sGrouping") return L"3";

    static std::unordered_map<std::wstring_view, std::wstring> engineStrings = {
        {SIDS_PLUS_MINUS, L"±"},
        {SIDS_CLEAR, L"C"},
        {SIDS_CE, L"CE"},
        {SIDS_BACKSPACE, L"⌫"},
        {SIDS_DECIMAL_SEPARATOR, L"."},
        {SIDS_EMPTY_STRING, L""},
        {SIDS_AND, L"AND"},
        {SIDS_OR, L"OR"},
        {SIDS_XOR, L"XOR"},
        {SIDS_DIVIDE, L"÷"},
        {SIDS_MULTIPLY, L"×"},
        {SIDS_PLUS, L"+"},
        {SIDS_MINUS, L"-"},
        {SIDS_MOD, L"mod"},
        {SIDS_EQUAL, L"="},
        {SIDS_PI, L"π"},
        {SIDS_PERCENT, L"%"}};

    auto it = engineStrings.find(id);
    if (it != engineStrings.end()) {
      return it->second;
    }

    // 返回空字符串作为默认值
    return L"";
  }
};

// 实现ICalcDisplay接口
class CalcDisplayImpl : public ICalcDisplay {
 public:
  std::wstring result;
  bool hasError;

  CalcDisplayImpl() : hasError(false) {}

  void SetPrimaryDisplay(const std::wstring& pszText, bool isError) override {
    result = pszText;
    hasError = isError;
  }

  void SetIsInError(bool isInError) override { hasError = isInError; }

  void SetExpressionDisplay(
      _Inout_ std::shared_ptr<std::vector<std::pair<std::wstring, int>>> const&
          tokens,
      _Inout_ std::shared_ptr<
          std::vector<std::shared_ptr<IExpressionCommand>>> const& commands)
      override {
    // 可以在这里处理表达式显示
  }

  void SetParenthesisNumber(_In_ unsigned int count) override {}
  void OnNoRightParenAdded() override {}
  void MaxDigitsReached() override {}
  void BinaryOperatorReceived() override {}
  void OnHistoryItemAdded(_In_ unsigned int addedItemIndex) override {}
  void SetMemorizedNumbers(
      const std::vector<std::wstring>& memorizedNumbers) override {}
  void MemoryItemChanged(unsigned int indexOfMemory) override {}
  void InputChanged() override {}
};

// 计算器实例结构体
struct CalculatorInstance {
  std::unique_ptr<CalculationManager::CalculatorManager> manager;
  std::unique_ptr<ResourceProviderImpl> resourceProvider;
  std::unique_ptr<CalcDisplayImpl> display;
  std::string lastResult;
};

// 初始化计算器实例
CalculatorInstance* calculator_init() {
  CalculatorInstance* instance = new CalculatorInstance();
  instance->resourceProvider = std::make_unique<ResourceProviderImpl>();
  instance->display = std::make_unique<CalcDisplayImpl>();
  instance->manager = std::make_unique<CalculationManager::CalculatorManager>(
      instance->display.get(), instance->resourceProvider.get());
  instance->manager->SetStandardMode();
  instance->lastResult = "0";
  return instance;
}

// 释放计算器实例
void calculator_free(CalculatorInstance* instance) {
  if (instance) {
    delete instance;
  }
}

// 设置标准模式
void calculator_set_standard_mode(CalculatorInstance* instance) {
  if (instance) {
    instance->manager->SetStandardMode();
  }
}

// 设置科学模式
void calculator_set_scientific_mode(CalculatorInstance* instance) {
  if (instance) {
    instance->manager->SetScientificMode();
  }
}

// 发送命令
void calculator_send_command(CalculatorInstance* instance,
                             CalculatorCommand command) {
  if (instance) {
    instance->manager->SendCommand(
        static_cast<CalculationManager::Command>(command));
  }
}

// 获取结果长度
int calculator_get_result_length(CalculatorInstance* instance) {
  if (!instance) return -1;

  std::wstring& wresult = instance->display->result;
  size_t len = 0;
  for (wchar_t c : wresult) {
    if (c <= 0x7F) {
      len++;
    } else if (c <= 0x7FF) {
      len += 2;
    } else if (c <= 0xFFFF) {
      len += 3;
    } else {
      len += 4;
    }
  }
  return static_cast<int>(len);
}

// 获取结果（转换为UTF-8字符串）
int calculator_get_result(CalculatorInstance* instance, char* buffer,
                          int bufferSize) {
  if (!instance || !buffer || bufferSize <= 0) return -1;

  std::wstring& wresult = instance->display->result;
  std::string result(wresult.begin(), wresult.end());

  if (result.length() >= static_cast<size_t>(bufferSize)) {
    return -2;
  }

  strcpy(buffer, result.c_str());
  return static_cast<int>(result.length());
}

// 检查是否有错误
int calculator_has_error(CalculatorInstance* instance) {
  if (instance) {
    return instance->display->hasError ? 1 : 0;
  }
  return 0;
}

// 重置计算器
void calculator_reset(CalculatorInstance* instance) {
  if (instance) {
    instance->manager->Reset();
  }
}