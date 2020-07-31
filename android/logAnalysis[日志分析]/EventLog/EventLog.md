# EventLog



## 基础知识

查看手机上所有的eventTag：`adb shell cat /system/etc/event-log-tags`

结果如下所示：

```
30001 am_finish_activity (User|1|5),(Token|1|5),(Task ID|1|5),(Component Name|3),(Reason|3)
30002 am_task_to_front (User|1|5),(Task|1|5)
30003 am_new_intent (User|1|5),(Token|1|5),(Task ID|1|5),(Component Name|3),(Action|3),(MIME Type|3),(URI|3),(Flags|1|5)
30004 am_create_task (User|1|5),(Task ID|1|5)
30005 am_create_activity (User|1|5),(Token|1|5),(Task ID|1|5),(Component Name|3),(Action|3),(MIME Type|3),(URI|3),(Flags|1|5)
30006 am_restart_activity (User|1|5),(Token|1|5),(Task ID|1|5),(Component Name|3)
30007 am_resume_activity (User|1|5),(Token|1|5),(Task ID|1|5),(Component Name|3)
30008 am_anr (User|1|5),(pid|1|5),(Package Name|3),(Flags|1|5),(reason|3)
```

格式说明 & 日志解读：（以am_proc_start举例）

```
# tag格式 # adb shell cat /system/etc/event-log-tags查询到
am_proc_start (User|1|5),(PID|1|5),(UID|1|5),(Process Name|3),(Type|3),(Component|3)

格式为：(<名字>|数据类型[|数据单位])
数据类型：1: int、2: long、3: string、4: list
数据单位：1: Number of objects(对象个数)、2: Number of bytes(字节数)、3: Number of milliseconds(毫秒)、4: Number of allocations(分配个数)、5: Id、6: Percent(百分比)
例如：User|1|5，则表示该字段语义为userId，数据类型是int，数据单位是Id

# event日志 # adb logcat -v threadtime -t 4096 -b events
am_proc_start:[0,9227,10002,com.android.browser,contentprovider,com.android.browser/.provider.BrowserProvider2]
=====>
进程启动: UserId=0, pid=9227, uid=10002, ProcessName=com.android.browser, Type=ContentProvider, Component=com.android.browser/.provider.BrowserProvider2
```



## 常见的EventTag

### ActivityManager相关



| No.   | TagName                         | 格式简写                                                     | 说明                                                         |
| ----- | ------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 30001 | am_finish_activity              | User, Token, TaskID, ComponentName, Reason                   | An activity is being finished<br/>位于ActivityStack.finishActivityLocked(), removeHistoryRecordsForAppLocked() |
| 30002 | am_task_to_front                | User, Task                                                   | A task is being brought to the front of the screen<br/>位于ActivityStack.moveTaskToFrontLocked() |
| 30003 | am_new_intent                   | User, Token, TaskID, ComponentName, Action, MIMEType, URI, Flags | An existing activity is being given a new intent             |
| 30004 | am_create_task                  | User, Task ID                                                | A new task is being created                                  |
| 30005 | am_create_activity              | User, Token, TaskID, ComponentName, Action, MIMEType, URI, Flags | A new activity is being created in an existing task<br/>位于ActivityStackSupervisor.startActivityUncheckedLocked() |
| 30006 | am_restart_activity             | User, Token, TaskID, ComponentName                           | An activity has been resumed into the foreground but was not already running<br/>位于ActivityStackSupervisor.realStartActivityLocked() |
| 30007 | am_resume_activity              | User, Token, TaskID, ComponentName                           | An activity has been resumed and is now in the foreground<br/>位于ActivityStack.resumeTopActivityInnerLocked() |
| 30008 | am_anr                          | User, pid, Package Name, Flags, reason                       | Application Not Responding<br/>位于AMS.appNotResponding()    |
| 30009 | am_activity_launch_time         | User, Token, ComponentName, time                             | Activity launch time<br/>位于ActivityRecord.reportLaunchTimeLocked()，后面两个参数分别是thisTime和 totalTime.(在这里特殊解释一下最后的两个time表示什么，在一部分应用中，我们可能先启动一个activity进行一些判断操作等之后再启动新的activity，totalTime包含这两次activity启动时间的总和，而thisTime，只表示最后一个activity的启动时间) |
| 30010 | am_proc_bound                   | User, PID, ProcessName                                       | Application process bound to work<br/>位于AMS.attachApplicationLocked() |
| 30011 | am_proc_died                    | User, PID, ProcessName                                       | Application process died                                     |
| 30012 | am_failed_to_pause              | User, Token, Wanting to pause, Currently pausing             | The Activity Manager failed to pause the given activity      |
| 30013 | am_pause_activity               | User, Token, ComponentName                                   | Attempting to pause the current activity<br/>位于ActivityStack.startPausingLocked() |
| 30014 | am_proc_start                   | User, PID, UID, ProcessName, Type, Component                 | Application process has been started<br/>位于AMS.startProcessLocked() |
| 30015 | am_proc_bad                     | User, UID, ProcessName                                       | An application process has been marked as bad                |
| 30016 | am_proc_good                    | User, UID, ProcessName                                       | An application process that was bad is now marked as good    |
| 30017 | am_low_memory                   | NumProcesses                                                 | Reporting to applications that memory is low<br/>位于AMS.killAllBackgroundProcesses()或者AMS.appDiedLocked()，记录当前Lru进程队列长度 |
| 30018 | am_destroy_activity             | User, Token, TaskID, ComponentName, Reason                   | An activity is being destroyed<br/>位于ActivityStack.destroyActivityLocked() |
| 30019 | am_relaunch_resume_activity     | User, Token, TaskID, ComponentName                           | An activity has been relaunched, resumed, and is now in the foreground |
| 30020 | am_relaunch_activity            | User, Token, TaskID, ComponentName                           | An activity has been relaunched                              |
| 30021 | am_on_paused_called             | User, ComponentName                                          | The activity’s onPause has been called                       |
| 30022 | am_on_resume_called             | User, ComponentName                                          | The activity’s onResume has been called                      |
| 30023 | am_kill                         | User, PID, ProcessName, OomAdj, Reason                       | Kill a process to reclaim memory<br/>位于ProcessRecord.kill() |
| 30024 | am_broadcast_discard_filter     | User, Broadcast, Action, ReceiverNumber, BroadcastFilter     | Discard an undelivered serialized broadcast (timeout/ANR/crash)<br/>位于BroadcastQueue.logBroadcastReceiverDiscardLocked() |
| 30025 | am_broadcast_discard_app        | User, Broadcast, Action, ReceiverNumber, App                 | 位于BroadcastQueue.logBroadcastReceiverDiscardLocked()       |
| 30030 | am_create_service               | User, ServiceRecord, Name, UID, PID                          | A service is being created                                   |
| 30031 | am_destroy_service              | User, ServiceRecord, PID                                     | A service is being destroyed                                 |
| 30032 | am_process_crashed_too_much     | User, Name, PID                                              | A process has crashed too many times, it is being cleared    |
| 30033 | am_drop_process                 | PID                                                          | An unknown process is trying to attach to the activity manager |
| 30034 | am_service_crashed_too_much     | User, Crash Count, ComponentName, PID                        | A service has crashed too many times, it is being stopped    |
| 30035 | am_schedule_service_restart     | User, ComponentName, Time                                    | A service is going to be restarted after its process went away |
| 30036 | am_provider_lost_process        | User, Package Name, UID, Name                                | A client was waiting for a content provider, but its process was lost |
| 30037 | am_process_start_timeout        | User, PID, UID, ProcessName                                  | The activity manager gave up on a new process taking too long to start |
| 30039 | am_crash                        | User, PID, ProcessName, Flags, Exception, Message, File, Line | Unhandled exception<br/>位于AMS.handleApplicationCrashInner() |
| 30040 | am_wtf                          | User, PID, ProcessName, Flags, Tag, Message                  | Log.wtf() called<br/>位于AMS.handleApplicationWtf()          |
| 30041 | am_switch_user                  | id                                                           | User switched                                                |
| 30042 | am_activity_fully_drawn_time    | User, Token, ComponentName, time                             | Activity fully drawn time<br/>位于ActivityRecord.reportFullyDrawnLocked(), 后面两个参数分别是thisTime和 totalTime |
| 30043 | am_focused_activity             | User, ComponentName                                          | Activity focused                                             |
| 30044 | am_home_stack_moved             | User, To Front, Top Stack Id, Focused Stack Id, Reason       |                                                              |
| 30045 | am_pre_boot                     | User, Package                                                | Running pre boot receiver                                    |
| 30046 | am_meminfo                      | Cached, Free, Zram, Kernel, Native                           | Report collection of global memory state                     |
| 30047 | am_pss                          | Pid, UID, ProcessName, Pss, Uss                              | Report collection of memory used by a process                |
| 30048 | am_stop_activity                | User, Token, Component Name                                  |                                                              |
| 30049 | am_on_stop_called               | User, Component Name, Reason                                 |                                                              |
| 30050 | am_mem_factor                   | Current, Previous                                            |                                                              |
| 30051 | am_user_state_changed           | id, state                                                    |                                                              |
| 30052 | am_uid_running                  | UID                                                          |                                                              |
| 30053 | am_uid_stopped                  | UID                                                          |                                                              |
| 30054 | am_uid_active                   | UID                                                          |                                                              |
| 30055 | am_uid_idle                     | UID                                                          |                                                              |
| 30056 | am_stop_idle_service            | UID, Component Name                                          |                                                              |
| 30057 | am_on_create_called             | User, Component Name, Reason                                 |                                                              |
| 30058 | am_on_restart_called            | User, Component Name, Reason                                 |                                                              |
| 30059 | am_on_start_called              | User, Component Name, Reason                                 |                                                              |
| 30060 | am_on_destroy_called            | User, Component Name, Reason                                 |                                                              |
| 30061 | am_remove_task                  | Task ID, Stack ID                                            |                                                              |
| 30062 | am_on_activity_result_called    | User, Component Name, Reason                                 |                                                              |
| 30063 | am_compact                      | Pid, Process Name, Action, BeforeRssTotal, BeforeRssFile, BeforeRssAnon, BeforeRssSwap, DeltaRssTotal, DeltaRssFile, DeltaRssAnon, DeltaRssSwap, Time, LastAction, LastActionTimestamp, setAdj, procState, BeforeZRAMFree, DeltaZRAMFree |                                                              |
| 30064 | am_on_top_resumed_gained_called | User, Component Name, Reason                                 |                                                              |
| 30065 | am_on_top_resumed_lost_called   | User, Component Name, Reason                                 |                                                              |
| 30066 | am_add_to_stopping              | User, Token, Component Name, Reason                          |                                                              |





















