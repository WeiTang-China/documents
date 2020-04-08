# Android.mk

本页介绍了 `ndk-build` 所使用的 `Android.mk` 编译文件的语法。

## 概览



`Android.mk` 文件位于项目 `jni/` 目录的子目录中，用于向编译系统描述源文件和共享库。它实际上是编译系统解析一次或多次的微小 GNU makefile 片段。`Android.mk` 文件用于定义 [`Application.mk`](https://developer.android.com/ndk/guides/application_mk?hl=zh-cn)、编译系统和环境变量所未定义的项目范围设置。它还可替换特定模块的项目范围设置。

`Android.mk` 的语法支持将源文件分组为模块。模块是静态库、共享库或独立的可执行文件。您可在每个 `Android.mk` 文件中定义一个或多个模块，也可在多个模块中使用同一个源文件。编译系统只将共享库放入您的应用软件包。此外，静态库可生成共享库。

除了封装库之外，编译系统还可为您处理各种其他事项。例如，您无需在 `Android.mk` 文件中列出头文件或生成的文件之间的显式依赖关系。NDK 编译系统会自动计算这些关系。因此，您应该能够享受到未来 NDK 版本中新工具链/平台支持带来的益处，而无需处理 `Android.mk` 文件。

此文件的语法与随整个 [Android 开源项目](https://source.android.com/?hl=zh-cn)分发的 `Android.mk` 文件中使用的语法非常接近。虽然使用这些语法的编译系统实现并不相同，但通过有意将语法设计得相似，可使应用开发者更轻松地将源代码重复用于外部库。

## 基础知识

在详细了解语法之前，最好先了解 `Android.mk` 文件所含内容的基本信息。为此，本部分使用 Hello-JNI 示例中的 `Android.mk` 文件解释文件中每一行的作用。

`Android.mk` 文件必须先定义 `LOCAL_PATH` 变量：

```makefile
LOCAL_PATH := $(call my-dir)
    
```

此变量表示源文件在开发树中的位置。在这行代码中，编译系统提供的宏函数 `my-dir` 将返回当前目录（`Android.mk` 文件本身所在的目录）的路径。

下一行声明 `CLEAR_VARS` 变量，其值由编译系统提供。

```makefile
include $(CLEAR_VARS)
    
```

`CLEAR_VARS` 变量指向一个特殊的 GNU Makefile，后者会清除许多 `LOCAL_XXX` 变量，例如 `LOCAL_MODULE`、`LOCAL_SRC_FILES` 和 `LOCAL_STATIC_LIBRARIES`。请注意，GNU Makefile 不会清除 `LOCAL_PATH`。此变量必须保留其值，因为系统在单一 GNU Make 执行环境（其中的所有变量都是全局变量）中解析所有编译控制文件。在描述每个模块之前，必须声明（重新声明）此变量。

接下来，`LOCAL_MODULE` 变量存储您要编译的模块的名称。请在应用的每个模块中使用一次此变量。

```makefile
LOCAL_MODULE := hello-jni
    
```

每个模块名称必须唯一，且不含任何空格。编译系统在生成最终共享库文件时，会对您分配给 `LOCAL_MODULE` 的名称自动添加正确的前缀和后缀。例如，上述示例会生成名为 `libhello-jni.so` 的库。

**注意**：如果模块名称的开头已经是 `lib`，则编译系统不会附加额外的 `lib` 前缀；而是按原样采用模块名称，并添加 `.so` 扩展名。因此，比如原来名为 `libfoo.c` 的源文件仍会生成名为 `libfoo.so` 的共享对象文件。此行为是为了支持 Android 平台源文件根据 `Android.mk` 文件生成的库；所有这些库的名称都以 `lib` 开头。

下一行会列举源文件，以空格分隔多个文件：

```makefile
LOCAL_SRC_FILES := hello-jni.c
    
```

`LOCAL_SRC_FILES` 变量必须包含要编译到模块中的 C 和/或 C++ 源文件列表。

最后一行帮助系统将所有内容连接到一起：

```makefile
include $(BUILD_SHARED_LIBRARY)
    
```

`BUILD_SHARED_LIBRARY` 变量指向一个 GNU Makefile 脚本，该脚本会收集您自最近 `include` 以来在 `LOCAL_XXX` 变量中定义的所有信息。此脚本确定要编译的内容以及编译方式。

示例目录中有更为复杂的示例，包括带有注释的 `Android.mk` 文件供您参考。此外，[示例：native-activity](https://developer.android.com/ndk/samples/sample_na?hl=zh-cn) 详细介绍了该示例的 `Android.mk` 文件。最后，[变量和宏](https://developer.android.com/ndk/guides/android_mk?hl=zh-cn#var)提供了关于本部分中变量的更多信息。

## 变量和宏



编译系统提供了许多可在 `Android.mk` 文件中使用的变量。其中许多变量已预先赋值。另一些变量由您赋值。

除了这些变量之外，您还可以自己定义任意变量。在定义变量时请注意，NDK 编译系统保留了下列变量名称：

- 以 `LOCAL_` 开头的名称，例如 `LOCAL_MODULE`。
- 以 `PRIVATE_`、`NDK_` 或 `APP` 开头的名称。编译系统在内部使用这些变量名。
- 小写名称，例如 `my-dir`。编译系统也是在内部使用这些变量名。

如果您为了方便而需要在 `Android.mk` 文件中定义自己的变量，建议在名称前附加 `MY_`。

## NDK 定义的 include 变量



本部分探讨了编译系统在解析 `Android.mk` 文件前定义的 GNU Make 变量。在某些情况下，NDK 可能会多次解析 `Android.mk` 文件，每次使用其中某些变量的不同定义。

### CLEAR_VARS

此变量指向的编译脚本用于取消定义下文“开发者定义的变量”部分中列出的几乎所有 `LOCAL_XXX` 变量。在描述新模块之前，请使用此变量来包含此脚本。使用它的语法为：

```makefile
include $(CLEAR_VARS)
    
```

### BUILD_EXECUTABLE

此变量指向的编译脚本用于收集您在 `LOCAL_XXX` 变量中提供的模块的所有相关信息，以及确定如何根据您列出的源文件编译目标可执行文件。请注意，使用此脚本要求您至少已经为 `LOCAL_MODULE` 和 `LOCAL_SRC_FILES` 赋值（要详细了解这些变量，请参阅[模块描述变量](https://developer.android.com/ndk/guides/android_mk?hl=zh-cn#mdv)）。

使用此变量的语法为：

```makefile
include $(BUILD_EXECUTABLE)
    
```

**注意：**大多数 Android 应用不包含可执行文件，但它们对于创建单元测试和其他调试工具很有用。

### BUILD_SHARED_LIBRARY

此变量指向的编译脚本用于收集您在 `LOCAL_XXX` 变量中提供的模块的所有相关信息，以及确定如何根据您列出的源文件编译目标共享库。请注意，使用此脚本要求您至少已经为 `LOCAL_MODULE` 和 `LOCAL_SRC_FILES` 赋值（要详细了解这些变量，请参阅模[块描述变量](https://developer.android.com/ndk/guides/android_mk?hl=zh-cn#mdv)）。

使用此变量的语法为：

```makefile
include $(BUILD_SHARED_LIBRARY)
    
```

共享库变量会导致编译系统生成扩展名为 `.so` 的库文件。

### BUILD_STATIC_LIBRARY

用于编译静态库的 `BUILD_SHARED_LIBRARY` 的变体。编译系统不会将静态库复制到您的项目/软件包中，但可以使用静态库编译共享库（请参阅下文的 `LOCAL_STATIC_LIBRARIES` 和 `LOCAL_WHOLE_STATIC_LIBRARIES`）。使用此变量的语法为：

```makefile
include $(BUILD_STATIC_LIBRARY)
    
```

静态库变量会导致编译系统生成扩展名为 `.a` 的库。

### PREBUILT_SHARED_LIBRARY

指向用于指定预编译共享库的编译脚本。与 `BUILD_SHARED_LIBRARY` 和 `BUILD_STATIC_LIBRARY` 的情况不同，这里的 `LOCAL_SRC_FILES` 值不能是源文件，而必须是指向预编译共享库的一个路径，例如 `foo/libfoo.so`。使用此变量的语法为：

```makefile
include $(PREBUILT_SHARED_LIBRARY)
    
```

您也可以使用 `LOCAL_PREBUILTS` 变量引用另一个模块中的预编译库。要详细了解如何使用预编译库，请参阅[使用预编译库](https://developer.android.com/ndk/guides/prebuilts?hl=zh-cn)。

### PREBUILT_STATIC_LIBRARY

与 `PREBUILT_SHARED_LIBRARY` 相同，但用于预编译静态库。要详细了解如何使用预编译库，请参阅[使用预编译库](https://developer.android.com/ndk/guides/prebuilts?hl=zh-cn)。

## 目标信息变量



编译系统会根据 `APP_ABI` 变量所指定的每个 ABI 解析 `Android.mk` 一次，该变量通常在 `Application.mk` 文件中定义。如果 `APP_ABI` 为 `all`，则编译系统会根据 NDK 支持的每个 ABI 解析 `Android.mk` 一次。本部分介绍了编译系统每次解析 `Android.mk` 时定义的变量。

### TARGET_ARCH

编译系统解析此 `Android.mk` 文件时面向的 CPU 系列。此变量是 `arm`、`arm64`、`x86` 或 `x86_64` 之一。

### TARGET_PLATFORM

编译系统解析此 `Android.mk` 文件时面向的 Android API 级别编号。例如，Android 5.1 系统映像对应于 Android API 级别 22：`android-22`。如需平台名称和对应 Android 系统映像的完整列表，请参阅 [Android NDK 原生 API](https://developer.android.com/ndk/guides/stable_apis?hl=zh-cn)。以下示例演示了使用此变量的语法：

```makefile
ifeq ($(TARGET_PLATFORM),android-22)
        # ... do something ...
    endif
    
```

### TARGET_ARCH_ABI



编译系统解析此 `Android.mk` 文件时面向的 ABI。表 1 显示用于每个受支持 CPU 和架构的 ABI 设置。

**表 1.** 不同 CPU 和架构的 ABI 设置。

| CPU 和架构    | 设置          |
| :------------ | :------------ |
| ARMv7         | `armeabi-v7a` |
| ARMv8 AArch64 | `arm64-v8a`   |
| i686          | `x86`         |
| x86-64        | `x86_64`      |

以下示例演示了如何检查 ARMv8 AArch64 是否为目标 CPU 与 ABI 的组合：

```makefile
ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
      # ... do something ...
    endif
    
```

要详细了解架构 ABI 和相关兼容性问题，请参阅 [ABI 管理](https://developer.android.com/ndk/guides/abis?hl=zh-cn)。

未来的新目标 ABI 将使用不同的值。

### TARGET_ABI

目标 Android API 级别与 ABI 的连接，特别适用于要针对实际设备测试特定目标系统映像的情况。例如，要检查搭载 Android API 级别 22 的 64 位 ARM 设备：

```makefile
ifeq ($(TARGET_ABI),android-22-arm64-v8a)
      # ... do something ...
    endif
    
```

## 模块描述变量



本部分中的变量会向编译系统描述您的模块。每个模块描述都应遵守以下基本流程：

1. 使用 `CLEAR_VARS` 变量初始化或取消定义与模块相关的变量。
2. 为用于描述模块的变量赋值。
3. 使用 `BUILD_XXX` 变量设置 NDK 编译系统，使其将适当的编译脚本用于该模块。

### LOCAL_PATH

此变量用于指定当前文件的路径。必须在 `Android.mk` 文件开头定义此变量。以下示例演示了如何定义此变量：

```makefile
LOCAL_PATH := $(call my-dir)
    
```

`CLEAR_VARS` 所指向的脚本不会清除此变量。因此，即使 `Android.mk` 文件描述了多个模块，您也只需定义它一次。

### LOCAL_MODULE

此变量用于存储模块名称。指定的名称必须唯一，并且不得包含任何空格。必须在包含任何脚本（`CLEAR_VARS` 的脚本除外）之前定义此变量。无需添加 `lib` 前缀或者 `.so` 或 `.a` 文件扩展名；编译系统会自动进行这些修改。在整个 `Android.mk` 和 [`Application.mk`](https://developer.android.com/ndk/guides/application_mk?hl=zh-cn) 文件中，请通过未经修改的名称引用模块。例如，以下行会导致生成名为 `libfoo.so` 的共享库模块：

```makefile
LOCAL_MODULE := "foo"
    
```

如果希望生成的模块使用除“`lib` + `LOCAL_MODULE` 的值”以外的名称，您可使用 `LOCAL_MODULE_FILENAME` 变量为生成的模块指定自己选择的名称。

### LOCAL_MODULE_FILENAME

此可选变量使您能够替换编译系统为其生成的文件默认使用的名称。例如，如果 `LOCAL_MODULE` 的名称为 `foo`，您可以强制系统将它生成的文件命名为 `libnewfoo`。以下示例演示了如何完成此操作：

```makefile
LOCAL_MODULE := foo
    LOCAL_MODULE_FILENAME := libnewfoo
    
```

对于共享库模块，此示例将生成一个名为 `libnewfoo.so` 的文件。

**注意**：您无法替换文件路径或文件扩展名。

### LOCAL_SRC_FILES

此变量包含编译系统生成模块时所用的源文件列表。只列出编译系统实际传递到编译器的文件，因为编译系统会自动计算所有相关的依赖关系。请注意，您可以使用相对（相对于 `LOCAL_PATH`）和绝对文件路径。

建议避免使用绝对文件路径；相对路径可以提高 `Android.mk` 文件的移植性。

**注意**：务必在编译文件中使用 Unix 样式的正斜杠 (/)。编译系统无法正确处理 Windows 样式的反斜杠 (\)。

### LOCAL_CPP_EXTENSION

可以使用此可选变量为 C++ 源文件指明 `.cpp` 以外的文件扩展名。例如，以下行将扩展名更改为 `.cxx`。（设置必须包含点。）

```makefile
LOCAL_CPP_EXTENSION := .cxx
    
```

您可以使用此变量指定多个扩展名。例如：

```makefile
LOCAL_CPP_EXTENSION := .cxx .cpp .cc
    
```

### LOCAL_CPP_FEATURES

您可使用此可选变量指明您的代码依赖于特定 C++ 功能。它会在编译过程中启用正确的编译器标记和链接器标记。对于预编译二进制文件，此变量还会声明二进制文件依赖于哪些功能，从而确保最终链接正常运行。建议您使用此变量，而不要直接在 `LOCAL_CPPFLAGS` 定义中启用 `-frtti` 和 `-fexceptions`。

使用此变量可让编译系统对每个模块使用适当的标记。使用 `LOCAL_CPPFLAGS` 会导致编译器将所有指定的标记用于所有模块，而不管实际需求如何。

例如，要指明您的代码使用 RTTI（运行时类型信息），请输入：

```makefile
LOCAL_CPP_FEATURES := rtti
    
```

要指明您的代码使用 C++ 异常，请输入：

```makefile
LOCAL_CPP_FEATURES := exceptions
    
```

您还可以为此变量指定多个值。例如：

```makefile
LOCAL_CPP_FEATURES := rtti features
    
```

描述值的顺序无关紧要。

### LOCAL_C_INCLUDES

可以使用此可选变量指定相对于 NDK `root` 目录的路径列表，以便在编译所有源文件（C、C++ 和 Assembly）时添加到 include 搜索路径。例如：

```makefile
LOCAL_C_INCLUDES := sources/foo
    
```

或者甚至：

```makefile
LOCAL_C_INCLUDES := $(LOCAL_PATH)/<subdirectory>/foo
    
```

请在通过 `LOCAL_CFLAGS` 或 `LOCAL_CPPFLAGS` 设置任何对应的包含标记前定义此变量。

在使用 ndk-gdb 启动原生调试时，编译系统也会自动使用 `LOCAL_C_INCLUDES` 路径。

### LOCAL_CFLAGS

此可选变量用于设置在编译 C 和 C++ 源文件时编译系统要传递的编译器标记。这样，您就可以指定额外的宏定义或编译选项。可以使用 `LOCAL_CPPFLAGS` 仅为 C++ 指定标记。

请勿尝试在 `Android.mk` 文件中更改优化/调试级别。编译系统可以使用 [`Application.mk`](https://developer.android.com/ndk/guides/application_mk?hl=zh-cn) 文件中的相关信息自动处理此设置。这样，编译系统就可以生成供调试期间使用的有用数据文件。

您可通过输入以下代码指定额外的 include 路径：

```makefile
LOCAL_CFLAGS += -I<path>,
    
```

但是，最好使用 `LOCAL_C_INCLUDES`，因为这样也可以使用可用于 ndk-gdb 原生调试的路径。

### LOCAL_CPPFLAGS

只编译 C++ 源文件时将传递的一组可选编译器标记。它们将出现在编译器命令行中的 `LOCAL_CFLAGS` 后面。使用 `LOCAL_CFLAGS` 为 C 和 C++ 指定标记。

### LOCAL_STATIC_LIBRARIES

此变量用于存储当前模块依赖的静态库模块列表。

如果当前模块是共享库或可执行文件，此变量将强制这些库链接到生成的二进制文件。

如果当前模块是静态库，此变量只是指出依赖于当前模块的其他模块也会依赖于列出的库。

### LOCAL_SHARED_LIBRARIES

此变量会列出此模块在运行时依赖的共享库模块。此信息是链接时必需的信息，用于将相应的信息嵌入到生成的文件中。

### LOCAL_WHOLE_STATIC_LIBRARIES

此变量是 `LOCAL_STATIC_LIBRARIES` 的变体，表示链接器应将相关的库模块视为*完整归档*。要详细了解完整归档，请参阅 [GNU ld 文档](http://ftp.gnu.org/old-gnu/Manuals/ld-2.9.1/html_node/ld_3.html)的 `--whole-archive` 标记部分。

多个静态库之间存在循环依赖关系时，此变量很有用。使用此变量编译共享库时，它将强制编译系统将静态库中的所有对象文件添加到最终二进制文件。但是，生成可执行文件时不会发生这种情况。

### LOCAL_LDLIBS

此变量列出了在编译共享库或可执行文件时使用的额外链接器标记。利用此变量，您可使用 `-l` 前缀传递特定系统库的名称。例如，以下示例指示链接器生成在加载时链接到 `/system/lib/libz.so` 的模块：

```makefile
LOCAL_LDLIBS := -lz
    
```

如需了解此 NDK 版本中可以链接的公开系统库列表，请参阅 [Android NDK 原生 API](https://developer.android.com/ndk/guides/stable_apis?hl=zh-cn)。

**注意**：如果为静态库定义此变量，编译系统会忽略此变量，并且 `ndk-build` 会显示一则警告。

### LOCAL_LDFLAGS

此变量列出了编译系统在编译共享库或可执行文件时使用的其他链接器标记。例如，要在 ARM/X86 上使用 `ld.bfd` 链接器：

```makefile
LOCAL_LDFLAGS += -fuse-ld=bfd
    
```

**注意**：如果为静态库定义此变量，编译系统会忽略此变量，并且 ndk-build 会显示一则警告。

### LOCAL_ALLOW_UNDEFINED_SYMBOLS

默认情况下，如果编译系统在尝试编译共享库时遇到未定义的引用，将会抛出“未定义的符号”错误。此错误可帮助您捕获源代码中的错误。

要停用此检查，请将此变量设置为 `true`。请注意，此设置可能会导致共享库在运行时加载。

**注意**：如果为静态库定义此变量，编译系统会忽略此变量，并且 ndk-build 会显示一则警告。

### LOCAL_ARM_MODE

默认情况下，编译系统会在 *thumb* 模式下生成 ARM 目标二进制文件，其中每条指令都是 16 位宽，并与 `thumb/` 目录中的 STL 库关联。将此变量定义为 `arm` 会强制编译系统在 32 位 `arm` 模式下生成模块的对象文件。以下示例演示了如何执行此操作：

```makefile
LOCAL_ARM_MODE := arm
    
```

您也可以对源文件名附加 `.arm` 后缀，指示编译系统在 `arm` 模式下仅编译特定的源文件。例如，以下示例指示编译系统在 ARM 模式下始终编译 `bar.c`，但根据 `LOCAL_ARM_MODE` 的值编译 `foo.c`。

```makefile
LOCAL_SRC_FILES := foo.c bar.c.arm
    
```

**注意**：您也可以在 [`Application.mk`](https://developer.android.com/ndk/guides/application_mk?hl=zh-cn) 文件中将 `APP_OPTIM` 设置为 `debug`，以强制编译系统生成 ARM 二进制文件。指定 `debug` 会强制执行 ARM 编译，因为工具链调试程序无法正确处理 Thumb 代码。

### LOCAL_ARM_NEON

此变量仅在以 `armeabi-v7a` ABI 为目标时才有意义。它允许在 C 和 C++ 源代码中使用 ARM Advanced SIMD (NEON) 编译器内建函数，以及在 Assembly 文件中使用 NEON 指令。

请注意，并非所有基于 ARMv7 的 CPU 都支持 NEON 扩展指令集。因此，必须执行运行时检测，以便在运行时安全地使用此代码。详情请参阅 [NEON 支持](https://developer.android.com/ndk/guides/cpu-arm-neon?hl=zh-cn)和 [cpufeatures](https://developer.android.com/ndk/guides/cpu-features?hl=zh-cn) 库。

此外，您也可以使用 `.neon` 后缀，指定编译系统仅以 NEON 支持编译特定源文件。在以下示例中，编译系统以 Thumb 和 NEON 支持编译 `foo.c`，以 Thumb 支持编译 `bar.c`，并以 ARM 和 NEON 支持编译 `zoo.c`：

```makefile
LOCAL_SRC_FILES = foo.c.neon bar.c zoo.c.arm.neon
    
```

如果同时使用这两个后缀，则 `.arm` 必须在 `.neon` 前面。

### LOCAL_DISABLE_FORMAT_STRING_CHECKS

默认情况下，编译系统会在编译代码时保护格式字符串。这样的话，如果 `printf` 样式的函数中使用了非常量格式的字符串，就会强制引发编译器错误。此保护默认启用，但您也可通过将此变量的值设置为 `true` 将其停用。如果没有必要的原因，我们不建议停用。

### LOCAL_EXPORT_CFLAGS

此变量用于记录一组 C/C++ 编译器标记，这些标记将添加到通过 `LOCAL_STATIC_LIBRARIES` 或 `LOCAL_SHARED_LIBRARIES` 变量使用此模块的任何其他模块的 `LOCAL_CFLAGS` 定义中。

例如，假设有下面这一对模块：`foo` 和 `bar`，bar 依赖于 `foo`：

```makefile
include $(CLEAR_VARS)
    LOCAL_MODULE := foo
    LOCAL_SRC_FILES := foo/foo.c
    LOCAL_EXPORT_CFLAGS := -DFOO=1
    include $(BUILD_STATIC_LIBRARY)

    include $(CLEAR_VARS)
    LOCAL_MODULE := bar
    LOCAL_SRC_FILES := bar.c
    LOCAL_CFLAGS := -DBAR=2
    LOCAL_STATIC_LIBRARIES := foo
    include $(BUILD_SHARED_LIBRARY)
    
```

在此例中，编译系统在编译 `bar.c` 时会向编译器传递 `-DFOO=1` 和 `-DBAR=2` 标记。它还会在模块的 `LOCAL_CFLAGS` 前面加上导出的标记，以便您轻松进行替换。

此外，模块之间的关系也具有传递性：如果 `zoo` 依赖于 `bar`，而后者依赖于 `foo`，那么 `zoo` 也会继承从 `foo` 导出的所有标记。

最后，编译系统在执行局部编译时（即，编译要导出标记的模块时），不使用导出的标记。因此，在上面的示例中，编译 `foo/foo.c` 时不会将 `-DFOO=1` 传递到编译器。要执行局部编译，请改用 `LOCAL_CFLAGS`。

### LOCAL_EXPORT_CPPFLAGS

此变量与 `LOCAL_EXPORT_CFLAGS` 相同，但仅适用于 C++ 标记。

### LOCAL_EXPORT_C_INCLUDES

此变量与 `LOCAL_EXPORT_CFLAGS` 相同，但适用于 C include 路径。例如，当 `bar.c` 需要包含模块 `foo` 的头文件时，此变量很有用。

### LOCAL_EXPORT_LDFLAGS

此变量与 `LOCAL_EXPORT_CFLAGS` 相同，但适用于链接器标记。

### LOCAL_EXPORT_LDLIBS

此变量与 `LOCAL_EXPORT_CFLAGS` 相同，告诉编译系统将特定系统库的名称传递给编译器。请在您指定的每个库名称前附加 `-l`。

请注意，编译系统会将导入的链接器标记附加到模块的 `LOCAL_LDLIBS` 变量值上。其原因在于 Unix 链接器的工作方式。

当模块 `foo` 是静态库并且具有依赖于系统库的代码时，此变量通常很有用。然后，您可以使用 `LOCAL_EXPORT_LDLIBS` 导出依赖关系。例如：

```makefile
include $(CLEAR_VARS)
    LOCAL_MODULE := foo
    LOCAL_SRC_FILES := foo/foo.c
    LOCAL_EXPORT_LDLIBS := -llog
    include $(BUILD_STATIC_LIBRARY)

    include $(CLEAR_VARS)
    LOCAL_MODULE := bar
    LOCAL_SRC_FILES := bar.c
    LOCAL_STATIC_LIBRARIES := foo
    include $(BUILD_SHARED_LIBRARY)
    
```

在此示例中，编译系统在编译 `libbar.so` 时，在链接器命令的末尾指定了 `-llog`。这样就会告知链接器，由于 `libbar.so` 依赖于 `foo`，因此它也依赖于系统日志记录库。

### LOCAL_SHORT_COMMANDS

当模块有很多源文件和/或依赖的静态或共享库时，请将此变量设置为 `true`。这样会强制编译系统将 `@` 语法用于包含中间对象文件或链接库的归档。

此功能在 Windows 上可能很有用，在 Windows 上，命令行最多只接受 8191 个字符，这对于复杂的项目来说可能太少。它还会影响个别源文件的编译，而且将几乎所有编译器标记都放在列表文件内。

请注意，`true` 以外的任何值都将恢复为默认行为。您也可以在 [`Application.mk`](https://developer.android.com/ndk/guides/application_mk?hl=zh-cn) 文件中定义 `APP_SHORT_COMMANDS`，以对项目中的所有模块强制实施此行为。

不建议默认启用此功能，因为它会减慢编译速度。

### LOCAL_THIN_ARCHIVE

编译静态库时，请将此变量设置为 `true`。这样会生成一个**瘦归档**，即一个库文件，其中不含对象文件，而只包含它通常包含的实际对象的文件路径。

这对于减小编译输出的大小非常有用。但缺点是，这样的库无法移至其他位置（其中的所有路径都是相对路径）。

有效值为 `true`、`false` 或空白。您可在 [`Application.mk`](https://developer.android.com/ndk/guides/application_mk?hl=zh-cn) 文件中通过 `APP_THIN_ARCHIVE` 变量设置默认值。

**注意**：在非静态库模块或预编译的静态库模块中，将会忽略此变量。

### LOCAL_FILTER_ASM

请将此变量定义为一个 shell 命令，供编译系统用于过滤根据您为 `LOCAL_SRC_FILES` 指定的文件提取或生成的汇编文件。定义此变量会导致发生以下情况：

1. 编译系统从任何 C 或 C++ 源文件生成临时汇编文件，而不是将它们编译到对象文件中。
2. 编译系统在任何临时汇编文件以及 `LOCAL_SRC_FILES` 中所列任何汇编文件的 `LOCAL_FILTER_ASM` 中执行 shell 命令，因此会生成另一个临时汇编文件。
3. 编译系统将这些过滤的汇编文件编译到对象文件中。

例如：

```makefile
LOCAL_SRC_FILES  := foo.c bar.S
    LOCAL_FILTER_ASM :=

    foo.c --1--> $OBJS_DIR/foo.S.original --2--> $OBJS_DIR/foo.S --3--> $OBJS_DIR/foo.o
    bar.S                                 --2--> $OBJS_DIR/bar.S --3--> $OBJS_DIR/bar.o
    
```

“1”对应于编译器，“2”对应于过滤器，“3”对应于汇编程序。过滤器必须是一个独立的 shell 命令，它接受输入文件名作为第一个参数，接受输出文件名作为第二个参数。例如：

```makefile
myasmfilter $OBJS_DIR/foo.S.original $OBJS_DIR/foo.S
    myasmfilter bar.S $OBJS_DIR/bar.S
    
```

## NDK 提供的函数宏



本部分介绍了 NDK 提供的 GNU Make 函数宏。使用 `$(call )` 可以对这些宏进行求值；它们将返回文本信息。

### my-dir

这个宏返回最后包含的 makefile 的路径，通常是当前 `Android.mk` 的目录。`my-dir` 可用于在 `Android.mk` 文件的开头定义 `LOCAL_PATH`。例如：

```makefile
LOCAL_PATH := $(call my-dir)
    
```

由于 GNU Make 的工作方式，这个宏实际返回的是编译系统解析编译脚本时包含的最后一个 makefile 的路径。因此，包含其他文件后就不应调用 `my-dir`。

例如：

```makefile
LOCAL_PATH := $(call my-dir)

    # ... declare one module

    include $(LOCAL_PATH)/foo/`Android.mk`

    LOCAL_PATH := $(call my-dir)

    # ... declare another module
    
```

该示例的问题在于，对 `my-dir` 的第二次调用将 `LOCAL_PATH` 定义为 `$PATH/foo`，而不是 `$PATH`，因为这是其最近的 include 所指向的位置。

在 `Android.mk` 文件中的所有其他内容后添加额外的 include 可避免此问题。例如：

```makefile
LOCAL_PATH := $(call my-dir)

    # ... declare one module

    LOCAL_PATH := $(call my-dir)

    # ... declare another module

    # extra includes at the end of the Android.mk file
    include $(LOCAL_PATH)/foo/Android.mk
    
```

如果以这种方式构造文件不可行，请将第一个 `my-dir` 调用的值保存到另一个变量中。例如：

```makefile
MY_LOCAL_PATH := $(call my-dir)

    LOCAL_PATH := $(MY_LOCAL_PATH)

    # ... declare one module

    include $(LOCAL_PATH)/foo/`Android.mk`

    LOCAL_PATH := $(MY_LOCAL_PATH)

    # ... declare another module
    
```

### all-subdir-makefiles

返回位于当前 `my-dir` 路径所有子目录中的 `Android.mk` 文件列表。

利用此函数，您可以为编译系统提供深度嵌套的源目录层次结构。默认情况下，NDK 只在 `Android.mk` 文件所在的目录中查找文件。

### this-makefile

返回当前 makefile（编译系统从中调用函数）的路径。

### parent-makefile

返回包含树中父 makefile 的路径（包含当前 makefile 的 makefile 的路径）。

### grand-parent-makefile

返回包含树中祖父 makefile 的路径（包含当前父 makefile 的 makefile 的路径）。

### import-module

此函数用于按模块名称查找和包含模块的 `Android.mk` 文件。典型的示例如下所示：

```makefile
$(call import-module,<name>)
    
```

在此示例中，编译系统在 `NDK_MODULE_PATH` 环境变量所引用的目录列表中查找具有 `` 标记的模块，并且自动包含其 `Android.mk` 文件。

































# Reference

- [官方guides](https://developer.android.com/ndk/guides/android_mk?hl=zh-cn)