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
