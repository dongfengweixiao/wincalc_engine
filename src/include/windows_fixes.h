#pragma once

// This file is force-included via pch.h to fix Windows compilation issues
// with third-party code without modifying the third-party source files

#if defined(_WIN32) && defined(_MSC_VER)

// Include Windows headers early
#include <winerror.h>
#include <sal.h>

// Define missing SAL macros
#ifndef _Frees_ptr_opt_
#define _Frees_ptr_opt_
#endif

// Ensure all HRESULT macros are defined
#ifndef E_BOUNDS
#define E_BOUNDS 0x8000000B
#endif

#ifndef S_OK
#define S_OK 0x0
#endif

#ifndef SUCCEEDED
#define SUCCEEDED(hr) (((HRESULT)(hr)) >= 0)
#endif

#ifndef FAILED
#define FAILED(hr) (((HRESULT)(hr)) < 0)
#endif

#ifndef SCODE_CODE
#define SCODE_CODE(sc) ((sc)&0xFFFF)
#endif

// Define HRESULT if not already defined
#ifndef HRESULT
typedef long HRESULT;
#endif

#endif
