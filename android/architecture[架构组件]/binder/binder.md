# Binder































## binder导出的日志文件

### 节点介绍

- debugfs挂载

  debugfs文件系统默认挂载在节点`/sys/kernel/debug`，binder驱动初始化的过程会在该节点下先创建`/binder`目录，然后在该目录下创建下面文件和目录：

  - proc/
  - stats (整体以及各个进程的线程数,事务个数等的统计信息)
  - state (整体以及各个进程的thread/node/ref/buffer的状态信息)
  - transactions (遍历所有进程的buffer分配情况)
  - transaction_log (记录32条最近的传输事件)
  - failed_transaction_log (记录32条最近的传输失败事件)

  另外，`/d`其实是指向`/sys/kernel/debug`的链接，因此，也可以通过节点`/d/binder`来访问。

- debugfs在androidR之后，可能会被关闭

  android R之后，google要求关闭debugfs，但可以使用/dev/binderfs/binder_logs来查看。

- 内核编译选项

  如果系统关闭了debugfs，则通过编辑`kernel/arch/arm/configs/×××_defconfig`来打开：

  ```c
  //开启debugfs
  CONFIG_DEBUG_FS=y
  //有时，可能还需要配置fs的白名单列表，例如：
  CONFIG_DEBUG_FS_WHITE_LIST=":/tracing:/binder:/wakeup_sources:"
  ```

### stats

执行上述语句，所对应的函数`binder_stats_show`，所输出结果分两部分：

1. 整体统计信息
   - 所有BC_XXX命令的次数；
   - 所有BR_XXX命令的次数；
   - 输出`binder_stat_types`各个类型的active和total；
2. 遍历所有进程的统计信息：
   - 当前进程相关的统计信息；
   - 所有BC_XXX命令的次数；
   - 所有BR_XXX命令的次数；

其中active是指当前系统存活的个数，total是指系统从开机到现在总共创建过的个数。

- 整体信息

  ```
  binder stats:
  BC_TRANSACTION: 235258
  BC_REPLY: 163048
  BC_FREE_BUFFER: 397853
  BC_INCREFS: 22573
  BC_ACQUIRE: 22735
  BC_RELEASE: 15840
  BC_DECREFS: 15810
  BC_INCREFS_DONE: 9517
  BC_ACQUIRE_DONE: 9518
  BC_REGISTER_LOOPER: 421
  BC_ENTER_LOOPER: 284
  BC_REQUEST_DEATH_NOTIFICATION: 4696
  BC_CLEAR_DEATH_NOTIFICATION: 3707
  BC_DEAD_BINDER_DONE: 400
  BR_TRANSACTION: 235245
  BR_REPLY: 163045
  BR_DEAD_REPLY: 3
  BR_TRANSACTION_COMPLETE: 398300
  BR_INCREFS: 9517
  BR_ACQUIRE: 9518
  BR_RELEASE: 5448
  BR_DECREFS: 5447
  BR_SPAWN_LOOPER: 462
  BR_DEAD_BINDER: 400
  BR_CLEAR_DEATH_NOTIFICATION_DONE: 3707
  BR_FAILED_REPLY: 3
  
  proc: active 78 total 382
  thread: active 530 total 3196
  node: active 1753 total 8134
  ref: active 2604 total 13422
  death: active 530 total 3991
  transaction: active 0 total 195903
  transaction_complete: active 0 total 195903
  ```

  可知：

  - 当前系统binder_proc个数为78，binder_thread个数为530，binder_node为1753等信息；
  - 从开机到现在共创建过382个binder_proc，3196个binder_thread等；
  - transaction active等于零，目前没有活动的transaction事务

  规律：BC_TRANSACTION + BC_REPLY = BR_TRANSACTION_COMPLETE + BR_DEAD_REPLY + BR_FAILED_REPLY

  为什么是会是这样呢,因为每次BC_TRANSACTION或着BC_REPLY,都是有相应的BR_TRANSACTION_COMPLETE,在传输不出异常的情况下这个次数是相等,有时候并能transaction成功, 所以还需要加上BR_DEAD_REPLY和BR_FAILED_REPLY的情况。

- 各进程信息

  ```
  proc 14328
    threads: 3 //binder_thread个数
    requested threads: 0+1/15 //requested_threads(请求线程数) + requested_threads_started(已启动线程数) / max_threads(最大线程数)
    ready threads 2 // ready_threads(准备就绪的线程数)
    free async space 520192 //可用的异步空间约为520k
    nodes: 3 //binder_node个数
    refs: 9 s 9 w 9 //引用次数，强引用次数，弱引用次数次数
    buffers: 0 //allocated_buffers(已分配的buffer个数)
    pending transactions: 0 //proc的todo队列事务个数
  
    //该进程中BC_XXX 和BR_XXX命令执行次数
    BC_TRANSACTION: 21
    BC_FREE_BUFFER: 24
    BC_INCREFS: 9
    BC_ACQUIRE: 9
    BC_INCREFS_DONE: 3
    BC_ACQUIRE_DONE: 3
    BC_REGISTER_LOOPER: 1
    BC_ENTER_LOOPER: 1
    BC_REQUEST_DEATH_NOTIFICATION: 1
    BR_TRANSACTION: 4
    BR_REPLY: 20
    BR_TRANSACTION_COMPLETE: 21
    BR_INCREFS: 3
    BR_ACQUIRE: 3
    BR_SPAWN_LOOPER: 1
  ```

  可知进程14328：

  - 共有3个binder_thread，最大线程个数上限为15.
  - 共有3个binder_node， 9个binder_ref。
  - 已分配binder_buffer为零，异步可用空间约为520k；
  - proc->todo队列为空；

  **Debug Tips：**

  - 当binder内存紧张时，可查看`free async space`和`buffers:`字段；
  - 当系统空闲时，一般来说`ready_threads` = `requested_threads_started` + `BC_ENTER_LOOPER`； 当系统繁忙时`ready_threads`可能为0.
  - 例如system_server进程的`ready_threads`线程个数越少，系统可能处于越繁忙的状态；
  - 绝大多数的进程`max_threads` = 15，而surfaceflinger最大线程个数为4，servicemanager最大线程个数为0(只有主线程)；
  - `pending transactions`:是指该进程的todo队列事务个数

  例如，想查看当前系统所有进程的异步可用内存情况，可执行：

  ```
  adb shell cat /d/binder/stats | egrep "proc |free async space"
  ```

  #相关说明#

  ```
  ----- kernel/msm-4.19/drivers/android/binder.c -----
  struct binder_stats {
  	int br[_IOC_NR(BR_FAILED_REPLY) + 1]; //统计各个binder响应码的个数
  	int bc[_IOC_NR(BC_DEAD_BINDER_DONE) + 1]; //统计各个binder请求码的个数
  	int obj_created[BINDER_STAT_COUNT]; //统计各种obj的创建个数
  	int obj_deleted[BINDER_STAT_COUNT]; //统计各种obj的删除个数
  };
  ```

  其中obj的个数由一个枚举变量`binder_stat_types`定义。

  统计创建与删除的对象

  `binder_stat_types`中定义的量：

  | 类型                             | 含义             |
  | :------------------------------- | :--------------- |
  | BINDER_STAT_PROC                 | binder进程       |
  | BINDER_STAT_THREAD               | binder线程       |
  | BINDER_STAT_NODE                 | binder节点       |
  | BINDER_STAT_REF                  | binder引用       |
  | BINDER_STAT_DEATH                | binder死亡       |
  | BINDER_STAT_TRANSACTION          | binder事务       |
  | BINDER_STAT_TRANSACTION_COMPLETE | binder已完成事务 |

  每个类型相应的调用方法：

  | 类型                             | 创建调用                | 删除调用                                                     |
  | :------------------------------- | :---------------------- | :----------------------------------------------------------- |
  | BINDER_STAT_PROC                 | binder_open             | binder_deferred_release                                      |
  | BINDER_STAT_THREAD               | binder_get_thread       | binder_free_thread                                           |
  | BINDER_STAT_NODE                 | binder_new_node         | binder_thread_read / binder_node_release  / binder_dec_node  |
  | BINDER_STAT_REF                  | binder_get_ref_for_node | binder_delete_ref                                            |
  | BINDER_STAT_DEATH                | binder_thread_write     | binder_thread_read / binder_release_work / binder_delete_ref |
  | BINDER_STAT_TRANSACTION          | binder_transaction      | binder_thread_read / binder_transaction / binder_release_work/ binder_pop_transaction |
  | BINDER_STAT_TRANSACTION_COMPLETE | binder_transaction      | binder_thread_read / binder_transaction / binder_release_work |

### state

执行`cat /d/binder/state`，所对应的函数`binder_state_show`，输出当前系统binder_proc, binder_node等信息；

- 整体信息

  输出所有死亡节点的信息

  ```
  dead nodes:
    node 24713573: u0000007f9fe0c6c0 c0000007f9fe63700 hs 1 hw 1 ls 0 lw 0 is 1 iw 1 proc 12396
    node 24712275: u0000007f9d5f0a80 c0000007fa82d1880 hs 1 hw 1 ls 0 lw 0 is 1 iw 1 proc 12396
  ```

- 各进程信息

  ```
  proc 18650
    thread 18650: l 00
    thread 18658: l 00
    thread 18663: l 12
    thread 18665: l 11
    node 24805986: u00000000e153f070 c00000000e197dd80 hs 1 hw 1 ls 0 lw 0 is 1 iw 1 proc 12396
    node 24805990: u00000000e153f090 c00000000e197dda0 hs 1 hw 1 ls 0 lw 0 is 1 iw 1 proc 12396
    ref 24804528: desc 0 node 1 s 1 w 1 d 0000000000000000
    ref 24804531: desc 1 node 24532956 s 1 w 1 d 0000000000000000
    buffer 24805817: ffffff8018e00050 size 1896:0 delivered
    buffer 24806788: ffffff8018e00808 size 152:0 delivered
  ```

  遍历进程的thread/node/ref/buffer信息. 当然如果存在,还会有pending transaction信息.

  Tips:

  - pending transaction: 记录当前所有进程和线程 TODO队列的transaction.
  - outgoing transaction: 当前线程transaction_stack, 由该线程发出的事务;
  - incoming transaction: 当前线程transaction_stack, 由需要线程接收的事务;
  - pending transactions: 记录当前进程总的pending事务;

### transactions

```
binder transactions:
proc 20256
  buffer 348035: ffffff800a280050 size 212:0 delivered
...
```

解释：

- pid=20256进程，buffer的data_size=212，offsets_size=0，delivered代表已分发的内存块
- 该命令遍历输出所有进程的情况，可以看出每个进程buffer的分发情况。

其实, state的信息是transactions的超集, 拥有比这个更为全面, 详细的信息。比如binder_ref信息只在state里面才有。

### transaction_log

输出结果：

```
357140: async from 8963:9594 to 10777:0 node 145081 handle 717 size 172:0
357141: call  from 8963:9594 to 435:0 node 1 handle 0 size 80:0
357142: reply from 435:435 to 8963:9594 node 0 handle 0 size 24:8
```

解释：

`debug_id`: `call_type` from `from_proc`:`from_thread` to `to_proc`:`to_thread` node `to_node` handle `target_handle` size `data_size`:`offsets_size`



call_type：有3种，分别为async, call, reply.

此处的data_size单位是字节数.

`transaction_log`以及还有`binder_transaction_log_failed`会只会记录最近的32次的transaction过程.

### failed_transaction_log

```
24423418: async from 713:713 to 1731:0 node 1809 handle 1 size 156:0
24423419: reply from 733:5038 to 1731:4738 node 0 handle -1 size 0:0
0: async from 782:1138 to 0:0 node 974 handle 8 size 88:8
```

解释: 跟transaction_log是一个原理, 不同的时此处有时候to_proc=0,代表着远程进程已挂.



### binder调试信息

- **binder_thread**

  调用方法:print_binder_thread_ilocked()

  ```
  thread 1278: l 12 need_return 0 tr 0
  ```

  关于looper状态值:

  ```
  BINDER_LOOPER_STATE_REGISTERED  = 0x01, // 创建注册线程BC_REGISTER_LOOPER
  BINDER_LOOPER_STATE_ENTERED     = 0x02, // 创建主线程BC_ENTER_LOOPER
  BINDER_LOOPER_STATE_EXITED      = 0x04, // 已退出
  BINDER_LOOPER_STATE_INVALID     = 0x08, // 非法
  BINDER_LOOPER_STATE_WAITING     = 0x10, // 等待中
  BINDER_LOOPER_STATE_NEED_RETURN = 0x20, // 需要返回
  ```

  所以`0x12` = `BINDER_LOOPER_STATE_ENTERED | BINDER_LOOPER_STATE_WAITING`，代表的是等待就绪状态且由为binder主线程. 简单说,looper值, 十位为1代表处于binder_thread_read()状态, 个位为1代表已注册的binder线程,个位为2代表binder主线程.

- **binder_node**

  关于binder_node的输出信息:print_binder_node_nilocked()

  ```
  node 21147: u00000000e3788000 c00000000e3784004 pri 0:139 hs 1 hw 1 ls 0 lw 0 is 5 iw 5 tr 1 proc 13534 4924 3307 3937 1750
  ```

  含义：

  | value             | field                     | desc |
  | ----------------- | ------------------------- | ---- |
  | node 21147        | debug_id                  |      |
  | u00000000e3788000 | ptr                       |      |
  | c00000000e3784004 | cookie                    |      |
  | pri 0:139         | sched_policy:min_priority |      |
  | hs 1              | has_strong_ref            |      |
  | hw 1              | has_weak_ref              |      |
  | ls 0              | local_strong_refs         |      |
  | lw 0              | local_weak_refs           |      |
  | is 5              | internal_strong_refs      |      |
  | iw 5              | internal_weak_refs        |      |
  | tr 1              | tmp_refs                  |      |
  | proc %d %d …………   | refs[*]->proc->pid        |      |

  对照起来看，binder_node#21147被进程13534 4924 3307 3937 1750，因此强引用为5，弱引用为5

- **binder_ref**

  调用方法: print_binder_ref_olocked()

  ```
  ref 1620: desc 0 node 1 s 1 w 1 d 0000000000000000
  ```

  含义：

  | value              | field                     | desc                     |
  | ------------------ | ------------------------- | ------------------------ |
  | ref 1620           | data.debug_id             |                          |
  | desc 0             | data.desc                 |                          |
  |                    | node->proc ? "" : "dead " |                          |
  | node 1             | node->debug_id            |                          |
  | s 1                | data.strong               |                          |
  | w 1                | data.weak                 |                          |
  | d 0000000000000000 | death                     | linkToDeath后，此域不为0 |

  > ？疑问？
  >
  > 从真机上导出的d节点都是0，难道都没有注册死亡通知？答案是否定的。
  >
  > 因为打印时用的格式字符串为"%pK"，出于安全的考虑，地址会被有限输出，受控于kptr_restrict
  >
  > | kptr_restrict |                      許可權描述                       |
  > | :-----------: | :---------------------------------------------------: |
  > |       2       | 核心將符號地址列印為全0, root和普通使用者都沒有許可權 |
  > |       1       |     root使用者有許可權讀取, 普通使用者沒有許可權      |
  > |       0       |              root和普通使用者都可以讀取               |
  >
  > 参考文章：https://www.itread01.com/content/1550440653.html
  >
  > 两种做法（需要root权限）之后，重新抓取binder节点信息即可
  >
  > 1）sysctl -w kernel.kptr_restrict=0
  >
  > 2）echo 0> /proc/sys/kernel/kptr_restrict

- **binder_buffer**

  调用方法：print_binder_buffer() // binder_alloc.c

  ```
  buffer 298181: 0000000000000000 size 88:16:16 delivered
  ```

  含义：

  | value            | field                                     | desc |
  | ---------------- | ----------------------------------------- | ---- |
  | buffer 298181    | debug_id                                  |      |
  | 0000000000000000 | user_data                                 |      |
  | size 88:16:16    | data_size:offsets_size:extra_buffers_size |      |
  | delivered        | transaction ? "active" : "delivered"      |      |

- **binder_transaction**

  调用方法：print_binder_transaction_ilocked()

  ```
  outgoing transaction 38552333: 0000000000000000 from 20406:20559 to 20300:22563 code 3 flags 12 pri 0:120 r1
  incoming transaction 38552333: 0000000000000000 from 20406:20559 to 20300:22563 code 3 flags 12 pri 0:120 r1 node 436685 size 316:0 data 0000000000000000
  
  pending transaction 38552372: 0000000000000000 from 930:930 to 4642:0 code 1 flags 10 pri 0:120 r1 node 75626 size 52:0 data 0000000000000000
  ```

  前缀prefix可能有所不同，剩下的内容含义：

  | value                 | field                                                  | desc                                                   |
  | --------------------- | ------------------------------------------------------ | ------------------------------------------------------ |
  | 38552333              | debug_id                                               |                                                        |
  | 0000000000000000      | t                                                      | 全是0的原因和上面的死亡通知一样，需要打开kptr_restrict |
  | from 20406:20559      | (from ? from->proc-pid : 0):from->pid                  |                                                        |
  | to 20300:22563        | to_proc->pid:to_thread->pid                            |                                                        |
  | code 3                | code                                                   |                                                        |
  | flags 12              | flags                                                  |                                                        |
  | pri 0:120             | priority.sched_policy:priority.prio                    |                                                        |
  | r1                    | need_reply                                             |                                                        |
  | node 436685           | if (buffer->target_node) buffer->target_node->debug_id |                                                        |
  | size 316:0            | buffer->data_size:buffer->offsets_size                 |                                                        |
  | data 0000000000000000 | buffer->user_data                                      | 全是0的原因和上面的死亡通知一样，需要打开kptr_restrict |

### 常见进程的分析

#### mediaserver

```
USER            PID   TID   PPID     VSZ    RSS WCHAN            ADDR S CMD            
media          1293  1293      1  104764  12392 binder_ioctl_write_read 0 S mediaserver
media          1293  1404      1  104764  12392 binder_ioctl_write_read 0 S Binder:1293_1
media          1293  4051      1  104764  12392 binder_ioctl_write_read 0 S Binder:1293_2
media          1293  4052      1  104764  12392 binder_ioctl_write_read 0 S Binder:1293_3
media          1293  4660      1  104764  12392 binder_ioctl_write_read 0 S Binder:1293_4
media          1293 10223      1  104764  12392 binder_ioctl_write_read 0 S Binder:1293_5
```

stats

```
proc 1293
context binder
  threads: 6
  requested threads: 0+4/15
  ready threads 6
  free async space 1044480
  nodes: 6
  refs: 8 s 8 w 8
  buffers: 0
  pages: 0:0:510
  pages high watermark: 8
  pending transactions: 0
```

state

```
proc 1293
context binder
  thread 1293: l 12 need_return 0 tr 0
  thread 1404: l 12 need_return 0 tr 0
  thread 4051: l 11 need_return 0 tr 0
  thread 4052: l 11 need_return 0 tr 0
  thread 4660: l 11 need_return 0 tr 0
  thread 10223: l 11 need_return 0 tr 0
```

此时的状态描述：

- 处于ready状态的线程6个
- BC_ENTER_LOOPER创建2个binder线程：1293、1404
- BC_REGISTER_LOOPER创建4个binder线程：4051、4052、4660、10223

#### servicemanager

```
----- ps -AT -----
USER            PID   TID   PPID     VSZ    RSS WCHAN            ADDR S CMD            
system          640   640      1 2129492   3088 SyS_epoll_wait      0 S servicemanager

----- stats -----
proc 640
context binder
  threads: 1
  requested threads: 0+0/0
  ready threads 0
  free async space 1044480
  nodes: 1
  refs: 238 s 238 w 238
  buffers: 0
  pages: 0:1:509
  pages high watermark: 1
  pending transactions: 0

----- state -----
proc 640
context binder
  thread 640: l 22 need_return 0 tr 0
  node 1: u0000000000000000 c0000000000000000 pri 0:120 hs 1 hw 1 ls 1 lw 1 is 96 iw 96 tr 1 proc 28735 28543 26596 ………………
```

该binder_thread是由BC_ENTER_LOOPER所创建的binder主线程, 只有一个binder_node对象, 被96个进程所使用.servicemanager作为服务管家,被系统大量进程所使用.

#### system_server

```
USER            PID   TID   PPID     VSZ    RSS WCHAN            ADDR S CMD            
system         1808  1898    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_1
system         1808  1900    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_2
system         1808  3025    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_4
system         1808  3292    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_5
system         1808  3301    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_6
system         1808  3624    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_7
system         1808  3647    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_8
system         1808  3845    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_9
system         1808  3847    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_A
system         1808  3848    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_B
system         1808  3849    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_C
system         1808  4096    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_D
system         1808  4258    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_E
system         1808  4259    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_F
system         1808  4318    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_10
system         1808  4960    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_11
system         1808  4963    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_12
system         1808  4972    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_13
system         1808  5030    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_14
system         1808  5033    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_15
system         1808  5626    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_16
system         1808  5629    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_17
system         1808  5677    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_18
system         1808  6894    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_19
system         1808 14820    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_1A
system         1808  5234    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_1B
system         1808 24432    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_1C
system         1808 24599    813 11730396 377480 binder_ioctl_write_read 0 S Binder:1808_1D
```

stats

```
proc 1808
context binder
  threads: 110
  requested threads: 0+27/31
  ready threads 28
  free async space 1044480
  nodes: 2751
  refs: 2442 s 2442 w 2442
  buffers: 10
  pages: 5:12:493
  pages high watermark: 30
  pending transactions: 0
```

进程system_server:

- 处于ready状态的binder线程个数为28（当ready数量很低时，就是系统很繁忙的表现）
- BC_ENTER_LOOPER创建1个binder线程：1898
- BC_REGISTER_LOOPER创建27个binder线程

#### surfaceflinger

```
USER            PID   TID   PPID     VSZ    RSS WCHAN            ADDR S CMD            
system         1019  1117      1 2662668  30876 binder_ioctl_write_read 0 S Binder:1019_1
system         1019  1119      1 2662668  30876 binder_ioctl_write_read 0 S Binder:1019_2
system         1019  1777      1 2662668  30876 binder_ioctl_write_read 0 S Binder:1019_3
system         1019  3009      1 2662668  30876 binder_ioctl_write_read 0 S Binder:1019_4
system         1019  3010      1 2662668  30876 binder_ioctl_write_read 0 S Binder:1019_5
system         1019  4661      1 2662668  30876 do_sys_poll         0 S Binder:1019_1  //同名线程，但非binder线程，可能是binder操作的过程中创建的新线程
```

stats

```
proc 1019
context binder
  threads: 8
  requested threads: 0+4/4
  ready threads 5
  free async space 1044480
  nodes: 146
  refs: 18 s 18 w 18
  buffers: 1
  pages: 1:3:506
  pages high watermark: 4
  pending transactions: 0
```

state

```
proc 1019
context binder
  thread 1019: l 00 need_return 0 tr 0
  thread 1117: l 12 need_return 0 tr 0
  thread 1119: l 11 need_return 0 tr 0
  thread 1121: l 00 need_return 1 tr 0
  thread 1172: l 00 need_return 0 tr 0
  thread 1777: l 11 need_return 0 tr 0
  thread 3009: l 11 need_return 0 tr 0
  thread 3010: l 11 need_return 0 tr 0
```

从state也可以看到thead 4661并不是binder线程

进程surfaceflinger:

- 处于ready状态的binder线程个数为5
- BC_ENTER_LOOPER创建1个binder主线程：1117
- BC_REGISTER_LOOPER创建4个binder线程：1119、1777、3009、3010
- max_threads = 4
- binder_thread个数为8
- 已分配的buffer个数为1

#### 小结

- `mediaserver`和`servicemanager`的主线程都是binder线程; `surfaceflinger`和`system_server`的主线程并非binder线程
- binder线程分为binder主线程和binder普通线程, binder主线程一般是`binder_1`或者进程的主线程
- `cat /d/binder/stats`和`cat /d/binder/proc/<pid>`是分析系统binder状态的重要信息
- androidR之后，debugfs可能被关闭，改为`/dev/binderfs/binder_logs/stats`

| 进程           | max  | BC_REGISTER_LOOPER | BC_ENTER_LOOPER |
| :------------- | :--- | :----------------- | :-------------- |
| surfaceflinger | 4    | 4                  | 1               |
| mediaserver    | 15   | 4                  | 2               |
| servicemanager | 0    | 1                  | 0               |
| system_server  | 31   | 27                 | 1               |

BC_REGISTER_LOOPER + BC_ENTER_LOOPER = max + 1，则代表该进程中的binder线程已达上限。 可见, mediaserver和system_server具有继续创建新线程的能力。



























## 几个小问题

### binder的server端线程是如何调度管理的？

### 同进程直接调用、不同进程跨进程IPC是在哪里分流的？







































# References

- 袁辉辉blog：[【开篇】](http://gityuan.com/2015/10/31/binder-prepare/) [【Driver初探】](http://gityuan.com/2015/11/01/binder-driver/) [【Driver再探】](http://gityuan.com/2015/11/02/binder-driver-2/) [【启动ServiceManager】](http://gityuan.com/2015/11/07/binder-start-sm/) [【获取ServiceManager】](http://gityuan.com/2015/11/08/binder-get-sm/) [【addService】](http://gityuan.com/2015/11/14/binder-add-service/) [【getService】](http://gityuan.com/2015/11/15/binder-get-service/) [【framework层分析】](http://gityuan.com/2015/11/21/binder-framework/) [【如何使用Binder】](http://gityuan.com/2015/11/22/binder-use/) [【如何使用AIDL】](http://gityuan.com/2015/11/23/binder-aidl/) [【总结】](http://gityuan.com/2015/11/28/binder-summary/) [【理解Refbase强弱引用】](http://gityuan.com/2015/12/05/android-refbase/)
- 听说你Binder机制学的不错，来面试下这几个问题：[【一】](https://www.jianshu.com/p/adaa1a39a274)  [【二】](https://www.jianshu.com/p/fa652f57a552)  [【三】](https://www.jianshu.com/p/9128f1b65586)
- [【透彻】【精华】Android Bander设计与实现 - 设计篇](https://blog.csdn.net/universus/article/details/6211589)
- [魅族kernal大佬的技术分享](http://kernel.meizu.com/android-binder.html)
- Android Binder 分析 [【原理】](http://light3moon.com/2015/01/28/Android%20Binder%20%E5%88%86%E6%9E%90%E2%80%94%E2%80%94%E5%8E%9F%E7%90%86/) [【通信模型】](http://light3moon.com/2015/01/28/Android%20Binder%20%E5%88%86%E6%9E%90%E2%80%94%E2%80%94%E9%80%9A%E4%BF%A1%E6%A8%A1%E5%9E%8B/) [【数据传递者（Parcel）】](http://light3moon.com/2015/01/28/Android%20Binder%20%E5%88%86%E6%9E%90%E2%80%94%E2%80%94%E6%95%B0%E6%8D%AE%E4%BC%A0%E9%80%92%E8%80%85[Parcel]/) [【匿名共享内存（Ashmem）】](http://light3moon.com/2015/01/28/Android%20Binder%20%E5%88%86%E6%9E%90%E2%80%94%E2%80%94%E5%8C%BF%E5%90%8D%E5%85%B1%E4%BA%AB%E5%86%85%E5%AD%98[Ashmem]/) [【内存管理】](http://light3moon.com/2015/01/28/Android%20Binder%20%E5%88%86%E6%9E%90%E2%80%94%E2%80%94%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86/) [【系统服务 Binder 对象的传递】](http://light3moon.com/2015/01/28/Android%20Binder%20%E5%88%86%E6%9E%90%E2%80%94%E2%80%94%E7%B3%BB%E7%BB%9F%E6%9C%8D%E5%8A%A1%20Binder%20%E5%AF%B9%E8%B1%A1%E7%9A%84%E4%BC%A0%E9%80%92/) [【普通服务 Binder 对象的传递】](http://light3moon.com/2015/01/28/Android%20Binder%20%E5%88%86%E6%9E%90%E2%80%94%E2%80%94%E6%99%AE%E9%80%9A%E6%9C%8D%E5%8A%A1%20Binder%20%E5%AF%B9%E8%B1%A1%E7%9A%84%E4%BC%A0%E9%80%92/) [【多线程支持】](http://light3moon.com/2015/01/28/Android%20Binder%20%E5%88%86%E6%9E%90%E2%80%94%E2%80%94%E5%A4%9A%E7%BA%BF%E7%A8%8B%E6%94%AF%E6%8C%81/) [【懒人的工具（AIDL）】](http://light3moon.com/2015/01/28/Android%20Binder%20%E5%88%86%E6%9E%90%E2%80%94%E2%80%94%E6%87%92%E4%BA%BA%E7%9A%84%E5%B7%A5%E5%85%B7[AIDL]/) [【死亡通知（DeathRecipient）】](http://light3moon.com/2015/01/28/Android%20Binder%20%E5%88%86%E6%9E%90%E2%80%94%E2%80%94%E6%AD%BB%E4%BA%A1%E9%80%9A%E7%9F%A5[DeathRecipient]/)
- [binder驱动-------之内存映射篇](https://blog.csdn.net/xiaojsj111/article/details/31422175)
- 袁辉辉blob：Binder调试分析 [【一】](http://gityuan.com/2016/08/27/binder-debug/) [【二】](http://gityuan.com/2016/08/28/binder-debug-2/) [【三】](http://gityuan.com/2016/09/03/binder-debug-3/) [【整体架构理解】](http://gityuan.com/2016/09/04/binder-start-service/)
- 解释BinderProxy被GC回收后，BpBinder才析构：[【NativeAllocationRegistry】](https://www.jianshu.com/p/6f042f9e47a8) [【Binder对象分析】](https://juejin.cn/post/6844903970251472910)



