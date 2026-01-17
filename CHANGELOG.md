## 0.0.6

### Fixed

- **Missing Temperature Unit Conversions**
  - Added Fahrenheit to Kelvin conversion (F → K): K = (F + 459.67) / 1.8
  - Added Kelvin to Fahrenheit conversion (K → F): F = K × 1.8 - 459.67
  - Previously, these conversions would fail or return incorrect results
  - Now all 9 possible temperature conversion directions are supported (3 units × 3 units)

## 0.0.5

### Fixed

- **Temperature Unit Identity Conversion Bug**
  - Added missing identity conversions for temperature units (Celsius→Celsius, Fahrenheit→Fahrenheit, Kelvin→Kelvin)
  - Previously, converting between the same temperature unit would produce incorrect results (e.g., 25°C → 0.015534 instead of 25°C)
  - Now correctly returns the same value when source and target units are identical
  - Example: 100°C now correctly converts to 100°C, 77°F to 77°F, 298K to 298K

## 0.0.4

### Added

#### Unit Converter Suggested Values Feature

- **New API: Suggested Values**
  - `unit_converter_get_suggested_count()` - Get the count of suggested conversion values
  - `unit_converter_get_suggested_value()` - Get individual suggested value with unit name
  - Suggested values include both common units (cups, pints, ounces) and whimsical units (coffee cups, bathtubs, swimming pools)
  - Example: When converting 1 Liter, returns suggestions like "4.23 US cups", "2.11 US pints", "☕ 4.23 Metric cups"

### Fixed

- **Unit Name Display Bug**
  - Fixed `addRatio()` function to use complete `Unit` objects instead of empty ones
  - Added `m_unitById` mapping to store complete unit information (id, name, abbreviation)
  - Previously suggested values showed numeric values but had empty unit names
  - Now correctly displays: "4.23 Metric cups" instead of "4.23 "

### Changed

- **Enhanced Unit Converter Data Loader**
  - Internal refactor to properly maintain Unit object references
  - Improved conversion ratio mapping with complete Unit metadata

## 0.0.3

### Fixed

- **Memory Clear Display Update Issue**
  - Fixed `calculator_memory_clear_at()` not updating the display layer when clearing a memorized number

## 0.0.2

### Added

#### Programmer Mode Bitwise Operation Features

- **New Enum: `CalcWordType`**
  - Added word size type enumeration for programmer mode
  - Supports QWORD (64-bit), DWORD (32-bit), WORD (16-bit), and BYTE (8-bit)
  - Includes `fromValue()` method for safe enum conversion

- **Word Width Management Functions**
  - `calculator_set_word_width()` - Set the current word size for programmer mode
  - `calculator_get_word_width()` - Get the current word size setting
  - Word width commands (CMD_QWORD, CMD_DWORD, CMD_WORD, CMD_BYTE) now properly tracked

- **Carry Flag Management Functions**
  - `calculator_set_carry_flag()` - Set the carry flag for rotate-through-carry operations
  - `calculator_get_carry_flag()` - Get the current carry flag value
  - Carry flag is automatically clamped to 0 or 1

- **Enhanced Bitwise Operations**
  - All bitwise operations (AND, OR, XOR, NOT, NAND, NOR) are available via `calculator_send_command()`
  - Bit shift operations: Left Shift (LSH), Right Shift (RSH), Logical Right Shift (RSHL)
  - Rotate operations: Rotate Left (ROL), Rotate Right (ROR)
  - Rotate-through-carry: ROLC, RORC

- **Radix Display Functions**
  - `calculator_get_result_hex()` - Get result in hexadecimal format
  - `calculator_get_result_dec()` - Get result in decimal format
  - `calculator_get_result_oct()` - Get result in octal format
  - `calculator_get_result_bin()` - Get result in binary format
  - `calculator_get_binary_display()` - Get 64-bit binary representation for bit panel

- **Bit Position Commands**
  - `CMD_BINPOS(n)` - Toggle bit at position n (0-63) for direct bit manipulation

### Changed

- **Enhanced `calculator_send_command()`**
  - Now properly tracks word width changes when sending CMD_QWORD, CMD_DWORD, CMD_WORD, or CMD_BYTE commands
  - Improved state synchronization between wrapper and native engine

## 0.0.1

- Initial version.
