# SPDX-License-Identifier: Apache-2.0

if(CONFIG_LLVM_USE_LD)
  set(LINKER ld)
elseif(CONFIG_LLVM_USE_LLD)
  set(LINKER lld)
endif()

if("${ARCH}" STREQUAL "arm")
  if(DEFINED CONFIG_ARMV8_M_MAINLINE)
    # ARMv8-M mainline is ARMv7-M with additional features from ARMv8-M.
    set(triple armv8m.main-none-eabi)
  elseif(DEFINED CONFIG_ARMV8_M_BASELINE)
    # ARMv8-M baseline is ARMv6-M with additional features from ARMv8-M.
    set(triple armv8m.base-none-eabi)
  elseif(DEFINED CONFIG_ARMV7_M_ARMV8_M_MAINLINE)
    # ARMV7_M_ARMV8_M_MAINLINE means that ARMv7-M or backward compatible ARMv8-M
    # processor is used.
    set(triple armv7m-none-eabi)
  elseif(DEFINED CONFIG_ARMV6_M_ARMV8_M_BASELINE)
    # ARMV6_M_ARMV8_M_BASELINE means that ARMv6-M or ARMv8-M supporting the
    # Baseline implementation processor is used.
    set(triple armv6m-none-eabi)
  else()
    # Default ARM target supported by all processors.
    set(triple arm-none-eabi)
  endif()

  if(CONFIG_LLVM_USE_LD)
    set(CMAKE_EXE_LINKER_FLAGS_INIT "--specs=nosys.specs")
  endif()

elseif("${ARCH}" STREQUAL "x86")
  if(CONFIG_64BIT)
    set(triple x86_64-pc-none-elf)
  else()
    set(triple i686-pc-none-elf)
  endif()
endif()

if(DEFINED triple)
  set(CMAKE_C_COMPILER_TARGET   ${triple})
  set(CMAKE_ASM_COMPILER_TARGET ${triple})
  set(CMAKE_CXX_COMPILER_TARGET ${triple})

  unset(triple)
endif()

if(CONFIG_LIBGCC_RTLIB)
  set(runtime_lib "libgcc")
elseif(CONFIG_COMPILER_RT_RTLIB)
  set(runtime_lib "compiler_rt")
endif()

if(NOT CONFIG_LLVM_USE_LLD)
list(APPEND TOOLCHAIN_C_FLAGS --config
	${ZEPHYR_BASE}/cmake/toolchain/llvm/clang_${runtime_lib}.cfg)
list(APPEND TOOLCHAIN_LD_FLAGS --config
	${ZEPHYR_BASE}/cmake/toolchain/llvm/clang_${runtime_lib}.cfg)
endif()
