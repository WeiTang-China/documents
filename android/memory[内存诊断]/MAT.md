# MAT

## Hprof文件的获取

- 方式一：通过代码获取

  通过API直接获取当前进程的hprof文件，由于比较耗时，需要在子线程进行。

  ```java
  String path;
  android.os.Debug.dumpHprofData(path);
  
  /**
   * Dump hprof data to the specified file. This may cause a GC.
   */
  public static void dumpHprofData(String fileName) throws IOException;
  ```

- 方式二：adb命令获取

  ```shell
  # am dumpheap 4941
  File: /data/local/tmp/heapdump-20210101-195502.prof
  Waiting for dump to finish...
  ```

  > 注意，需要进程可调试，比如debug的app或者debug版本
  >
  > 否则，会得到如下异常：
  >
  > Security exception: Process not debuggable: ProcessRecord{f23cc4a 6194:android.process.media/u0a31}

- 方式三：Profiler工具获取

  Profiler是Android Studio提供的一个性能分析工具，可以分析应用的内存、CPU、网络、耗电。

- 方式四：DDMS获取

  DDMS全称Dalvik Debug Monitor Server，可以通过android device monitor进行可视化操作。

  1、打开Android Studio -> tools -> android device monitor，进入DDMS

  2、选中所需的进程，点击heap updates

## Hprof文件转换

从手机获取到的prof文件是不能被MAT工具直接打开的，需要使用SDK工具进行格式转换（platform-conv/hprof-conv）



## MAT工具的使用

Histogram：可以直观的看出内存中不同类型的buffer的数量和占用内存大小

DominatorTree：把内存中的对象按照从大到小的顺序进行排序，并且可以分析对象之间的引用关系



如果要分析某个类是否存在泄漏，只需要点击右键 -> Merge Shortest Paths to GC Roots -> exclude all phantom/weak/soft etc. references



## 常见的内存泄漏

### 动画导致内存泄漏

动画需要在退出时调用cancel

泄漏的根本原因是AnimationHandler对象是ThreadLocal上创建的

### 广播导致内存泄漏

Activity中动态注册的广播，需要在退出Activity后unregister

泄漏的根本原因是LoadedApk保存的mReceivers集合，保存了注册过receiver的对象，而LoadedApk又会被Application对象持有，导致无法释放

### 匿名内部类Handler导致内存泄漏

Looper线程持有Message对象，Message对象持有Handler，Handler此时如果持有Activity对象，则会造成Activity对象的泄漏

有两种方法可以避免此问题：

1、更改Handler为静态内部类，如果要访问Activity中的成员，则使用WeakReference包一下

2、在Activity退出时，调用Handler的removeCallbacksAndMessages(null)

### 单例导致

静态变量存储在方法区的静态区中，还有静态块（比如静态初始化的代码）

方法区是GC root之一，导致无法释放





# OutOfMemory触发场景

- Java堆内存溢出

  申请的内存大小超过虚拟机中堆内存的可用空间

- 无足够连续内存空间

  申请内存空间时，如果找不到一段连续的内存，即使可用空间大于申请的内存大小，也会抛异常

- FD数量超过上限

- 线程数量超过限制































































# References

- [利用MAT进行内存泄露分析](https://blog.csdn.net/yxz329130952/article/details/50288145)

























