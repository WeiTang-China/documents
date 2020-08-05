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

# event日志 # adb logcat -v threadtime -b events
am_proc_start:[0,9227,10002,com.android.browser,contentprovider,com.android.browser/.provider.BrowserProvider2]
=====>
进程启动: UserId=0, pid=9227, uid=10002, ProcessName=com.android.browser, Type=ContentProvider, Component=com.android.browser/.provider.BrowserProvider2
```



## 常见的EventTag

### ActivityManager相关

定义文件：`frameworks/base/services/core/java/com/android/server/am/EventLogTags.logtags`

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
| 30044 | am_home_stack_moved             | User, To Front, Top Stack Id, Focused Stack Id, Reason       | Stack focus<br/>位于ActivityStackSupervisor.moveHomeStack()<br/>0,1,0,0, 是指userId=0, home栈顶的StackId=0, 当前focusedStackId=0 |
| 30045 | am_pre_boot                     | User, Package                                                | Running pre boot receiver                                    |
| 30046 | am_meminfo                      | Cached, Free, Zram, Kernel, Native                           | Report collection of global memory state                     |
| 30047 | am_pss                          | Pid, UID, ProcessName, Pss, Uss                              | Report collection of memory used by a process                |
| 30048 | am_stop_activity                | User, Token, Component Name                                  | Attempting to stop an activity                               |
| 30049 | am_on_stop_called               | User, Component Name, Reason                                 | The activity's onStop() has been called                      |
| 30050 | am_mem_factor                   | Current, Previous                                            | Report changing memory conditions (Values are ProcessStats.ADJ_MEM_FACTOR* constants) |
| 30051 | am_user_state_changed           | id, state                                                    | UserState has changed                                        |
| 30052 | am_uid_running                  | UID                                                          | Note when any processes of a uid have started running        |
| 30053 | am_uid_stopped                  | UID                                                          | Note when all processes of a uid have stopped                |
| 30054 | am_uid_active                   | UID                                                          | Note when the state of a uid has become active               |
| 30055 | am_uid_idle                     | UID                                                          | Note when the state of a uid has become idle (background check enforced) |
| 30056 | am_stop_idle_service            | UID, Component Name                                          | Note when a service is being forcibly stopped because its app went idle |
| 30057 | am_on_create_called             | User, Component Name, Reason                                 | The activity's onCreate() has been called                    |
| 30058 | am_on_restart_called            | User, Component Name, Reason                                 | The activity's onRestart() has been called                   |
| 30059 | am_on_start_called              | User, Component Name, Reason                                 | The activity's onStart() has been called                     |
| 30060 | am_on_destroy_called            | User, Component Name, Reason                                 | The activity's onDestroy() has been called                   |
| 30061 | am_remove_task                  | Task ID, Stack ID                                            | The task is being removed from its parent stack              |
| 30062 | am_on_activity_result_called    | User, Component Name, Reason                                 | The activity's onActivityResult() has been called            |
| 30063 | am_compact                      | Pid, Process Name, Action, BeforeRssTotal, BeforeRssFile, BeforeRssAnon, BeforeRssSwap, DeltaRssTotal, DeltaRssFile, DeltaRssAnon, DeltaRssSwap, Time, LastAction, LastActionTimestamp, setAdj, procState, BeforeZRAMFree, DeltaZRAMFree | The task is being compacted                                  |
| 30064 | am_on_top_resumed_gained_called | User, Component Name, Reason                                 | The activity's onTopResumedActivityChanged(true) has been called |
| 30065 | am_on_top_resumed_lost_called   | User, Component Name, Reason                                 | The activity's onTopResumedActivityChanged(false) has been called |
| 30066 | am_add_to_stopping              | User, Token, Component Name, Reason                          | An activity been add into stopping list                      |

#### Activity启动实例

以一个activity的生命周期为例说明：

```c
// 创建activity在stack<2>
01-06 11:26:33.437  1235  5057 I am_create_activity: [0,203658924,2,com.opera.browser/com.opera.Opera,android.intent.action.MAIN,NULL,NULL,270532608]
// pause pre-activity
01-06 11:26:33.444  1235  5057 I am_pause_activity: [0,194842374,com.oppo.launcher/.Launcher,userLeaving=true,pause-stack]
// pre-activity onTopResumedActivityChanged(false)
01-06 11:26:33.454  3912  3912 I am_on_top_resumed_lost_called: [0,com.oppo.launcher.Launcher,topStateChangedWhenResumed]
// pre-activity onPaused()
01-06 11:26:33.457  3912  3912 I am_on_paused_called: [0,com.oppo.launcher.Launcher,performPause]
// pre-activity add into stopping list
01-06 11:26:33.465  1235  4098 I am_add_to_stopping: [0,194842374,com.oppo.launcher/.Launcher,makeInvisible]
// next-activity's uid is running
01-06 11:26:33.474  1235  1996 I am_uid_running: 10195
// next-activity's process is created
01-06 11:26:33.514  1235  2070 I am_proc_start: [0,13085,10195,com.opera.browser,activity,{com.opera.browser/com.opera.Opera}]
// next-activity's process call attachApplicationLocked()
01-06 11:26:33.560  1235  3067 I am_proc_bound: [0,13085,com.opera.browser]
// next-activity is scheduled in realStartActivityLocked()
01-06 11:26:33.568  1235  3067 I am_restart_activity: [0,203658924,2,com.opera.browser/com.opera.Opera]
01-06 11:26:33.586  1235  3067 I am_set_resumed_activity: [0,com.opera.browser/com.opera.Opera,minimalResumeActivityLocked]
// next-activity onCreate()、onStart()、onResume()
01-06 11:26:34.157 13085 13085 I am_on_create_called: [0,com.opera.Opera,performCreate]
01-06 11:26:34.221 13085 13085 I am_on_start_called: [0,com.opera.Opera,handleStartActivity]
01-06 11:26:34.316 13085 13085 I am_on_resume_called: [0,com.opera.Opera,RESUME_ACTIVITY]
// next-activity onTopResumedActivityChanged(true)
01-06 11:26:34.447 13085 13085 I am_on_top_resumed_gained_called: [0,com.opera.Opera,topStateChangedWhenResumed]
// counter launch time -- start activity finished
01-06 11:26:34.476  1235  2044 I am_activity_launch_time: [0,203658924,com.opera.browser/com.opera.Opera,1061]
```


### PowerManagerService相关

定义文件：`frameworks/base/services/core/java/com/android/server/EventLogTags.logtags`

| No.   | TagName                        | 格式简写                                                     | 说明                                                         |
| ----- | ------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 2724  | power_sleep_requested          | wakeLocksCleared                                             | This is logged when the device is being forced to sleep (typically by the user pressing the power button) |
| 2725  | power_screen_broadcast_send    | wakelockCount                                                | This is logged when the screen on broadcast has completed    |
| 2726  | power_screen_broadcast_done    | on, broadcastDuration, wakelockCount                         | This is logged when the screen broadcast has completed       |
| 2727  | power_screen_broadcast_stop    | which, wakelockCount                                         | This is logged when the screen on broadcast has completed    |
| 2728  | power_screen_state             | offOrOn, becauseOfUser, totalTouchDownTime, touchCycles, latency | This is logged when the screen is turned on or off<br/>offOrOn：1亮屏、2灭屏<br/>becauseOfUser（灭屏）：1deviceAdmin、2userPowerButton、3screenTimeout、4proximitySensor<br/>位于Notifier.handleLateInteractiveChange() |
| 2729  | power_partial_wake_state       | releasedorAcquired, tag                                      | This is logged when the partial wake lock (keeping the device awake regardless of whether the screen is off) is acquired or released |
| 2731  | power_soft_sleep_requested     | savedwaketimems                                              | The device is being asked to go into a soft sleep (typically by the ungaze gesture).<br/>It logs the time remaining before the device would've normally gone to sleep without the request. |
| 2739  | battery_saver_mode             | fullPrevOffOrOn, adaptivePrevOffOrOn, fullNowOffOrOn, adaptiveNowOffOrOn, interactive, features, reason | Power save state has changed. See BatterySaverController.java for the details |
| 27390 | battery_saving_stats           | batterySaver, interactive, doze, delta_duration, delta_battery_drain, delta_battery_drain_percent, total_duration, total_battery_drain, total_battery_drain_percent |                                                              |
| 27391 | user_activity_timeout_override | override                                                     | Note when the user activity timeout has been overriden by ActivityManagerService |
| 27392 | battery_saver_setting          | threshold                                                    |                                                              |



### NotificationManagerService相关

定义文件：`frameworks/base/services/core/java/com/android/server/EventLogTags.logtags`

| No.    | TagName                         | 格式简写                                                     | 说明                                                         |
| ------ | ------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 2750   | notification_enqueue            | uid, pid, pkg, id, tag, userid, notification, status         | when a NotificationManager.notify is called. status: 0=post, 1=update, 2=ignored |
| 2751   | notification_cancel             | uid, pid, pkg, id, tag, userid, required_flags, forbidden_flags, reason, listener | when someone tries to cancel a notification, the notification manager sometimes calls this with flags too |
| 2752   | notification_cancel_all         | uid, pid, pkg, userid, required_flags, forbidden_flags, reason, listener | when someone tries to cancel all of the notifications for a particular package |
| 27500  | notification_panel_revealed     | items                                                        | when the notification panel is shown<br/>Note: New tag range starts here since 2753+ have been used below |
| 27501  | notification_panel_hidden       |                                                              | when the notification panel is hidden                        |
| 27510  | notification_visibility_changed | newlyVisibleKeys, noLongerVisibleKeys                        | when notifications are newly displayed on screen, or disappear from screen |
| 27511  | notification_expansion          | key, user_action, expanded, lifespan, freshness, exposure    | when notifications are expanded, or contracted               |
| 27520  | notification_clicked            | key, lifespan, freshness, exposure, rank, count              | when a notification has been clicked                         |
| 27521  | notification_action_clicked     | key, action_index, lifespan, freshness, exposure, rank, count | when a notification action button has been clicked           |
| 27530  | notification_canceled           | key, reason, lifespan, freshness, exposure, rank, count, listener | when a notification has been canceled                        |
| 27531  | notification_visibility         | key, visibile, lifespan, freshness, exposure, rank           | replaces 27510 with a row per notification                   |
| 27532  | notification_alert              | key, buzz, beep, blink                                       | a notification emited noise, vibration, or light             |
| 27533  | notification_autogrouped        | key                                                          | a notification was added to a autogroup                      |
| 275534 | notification_unautogrouped      | key                                                          | notification was removed from an autogroup                   |



### Watchdog相关

定义文件：`frameworks/base/services/core/java/com/android/server/EventLogTags.logtags`

| No.  | TagName                   | 格式简写                                                     | 说明 |
| ---- | ------------------------- | ------------------------------------------------------------ | ---- |
| 2802 | watchdog                  | Service                                                      |      |
| 2803 | watchdog_proc_pss         | Process, Pid, Pss                                            |      |
| 2804 | watchdog_soft_reset       | Process, Pid, MaxPss, Pss, Skip                              |      |
| 2805 | watchdog_hard_reset       | Process, Pid, MaxPss, Pss                                    |      |
| 2806 | watchdog_pss_stats        | EmptyPss, EmptyCount, BackgroundPss, BackgroundCount, ServicePss, ServiceCount, VisiblePss, VisibleCount, ForegroundPss, ForegroundCount, NoPssCount |      |
| 2807 | watchdog_proc_stats       | DeathsInOne, DeathsInTwo, DeathsInThree, DeathsInFour, DeathsInFive |      |
| 2808 | watchdog_scheduled_reboot | Now, Interval, StartTime, Window, Skip                       |      |
| 2809 | watchdog_meminfo          | MemFree, Buffers, Cached, Active, Inactive, AnonPages, Mapped, Slab, SReclaimable, SUnreclaim, PageTables |      |
| 2810 | watchdog_vmstat           | runtime, pgfree, pgactivate, pgdeactivate, pgfault, pgmajfault |      |
| 2811 | watchdog_requested_reboot | NoWait, ScheduleInterval, RecheckInterval, StartTime, Window, MinScreenOff, MinNextAlarm |      |




### PackageManagerService相关

定义文件：`frameworks/base/services/core/java/com/android/server/EventLogTags.logtags`

| No.  | TagName                             | 格式简写                                                     | 说明                                                         |
| ---- | ----------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 3060 | boot_progress_pms_start             | time                                                         | Package Manager starts:                                      |
| 3070 | boot_progress_pms_system_scan_start | time                                                         | Package Manager .apk scan starts:                            |
| 3080 | boot_progress_pms_data_scan_start   | time                                                         | Package Manager .apk scan starts:                            |
| 3090 | boot_progress_pms_scan_end          | time                                                         | Package Manager .apk scan ends:                              |
| 3100 | boot_progress_pms_ready             | time                                                         | Package Manager ready:                                       |
| 3110 | unknown_sources_enabled             | value                                                        | check activity_launch_time for Home app Value of "unknown sources" setting at app install time |
| 3120 | pm_critical_info                    | msg                                                          | Package Manager critical info                                |
| 3121 | pm_package_stats                    | manual_time, quota_time, manual_data, quota_data, manual_cache, quota_cache | Disk usage stats for verifying quota correctness             |



### WindowManagerService相关

定义文件：`frameworks/base/services/core/java/com/android/server/EventLogTags.logtags`

|       |                        |                        |                                            |
| ----- | ---------------------- | ---------------------- | ------------------------------------------ |
| 31000 | wm_no_surface_memory   | Window, PID, Operation | Out of memory for surfaces.                |
| 31001 | wm_task_created        | TaskId, StackId        | Task created.                              |
| 31002 | wm_task_moved          | TaskId, ToTop, Index   | Task moved to top (1) or bottom (0).       |
| 31003 | wm_task_removed        | TaskId, Reason         | Task removed with source explanation.      |
| 31004 | wm_stack_created       | StackId                | Stack created.                             |
| 31005 | wm_home_stack_moved    | ToTop                  | Home stack moved to top (1) or bottom (0). |
| 31006 | wm_stack_removed       | StackId                | Stack removed.                             |
| 31007 | wm_boot_animation_done | time                   | bootanim finished:                         |



## 开机Boot启动实例解析

### 【android R】

```c
// Process 596 is serviceManager
01-06 12:02:52.092   596   596 I auditd  : SELinux: Loaded service_contexts from:
01-06 12:02:52.092   596   596 I auditd  :     /system/etc/selinux/plat_service_contexts
01-06 12:02:52.092   596   596 I auditd  :     /system_ext/etc/selinux/system_ext_service_contexts
01-06 12:02:52.092   596   596 I auditd  :     /product/etc/selinux/product_service_contexts
// Process 770 is zygote
08-01 18:02:43.886   770   770 I boot_progress_start: 25136
08-01 18:02:44.709   770   770 I boot_progress_preload_start: 25959
08-01 18:02:46.706   770   770 I boot_progress_preload_end: 27956
// Process 1662 is system_server
08-01 18:02:47.243  1662  1662 I system_server_start: [1,28487,28487]
08-01 18:02:47.243  1662  1662 I boot_progress_system_run: 28493
08-01 18:02:48.717  1662  1662 I boot_progress_pms_start: 29967
08-01 18:02:49.699  1662  1662 I boot_progress_pms_system_scan_start: 30949
08-01 18:02:50.994  1662  1662 I boot_progress_pms_data_scan_start: 32244
08-01 18:02:51.722  1662  1662 I boot_progress_pms_scan_end: 32972
08-01 18:02:51.883  1662  1662 I boot_progress_pms_ready: 33133
08-01 18:02:52.791  1662  2058 I battery_status: [2,2,1,2,Li-ion]
08-01 18:02:52.791  1662  2058 I battery_level: [88,4224,315]
08-01 18:02:54.177  1662  1662 I boot_progress_ams_ready: 35427
08-01 18:02:54.671  1662  1935 I am_proc_start: [0,2836,10174,com.android.systemui,service,{com.android.systemui/com.android.systemui.ImageWallpaper}]
08-01 18:02:54.672  1662  1723 I am_proc_bound: [0,2836,com.android.systemui]
08-01 18:02:55.074  1662  1662 I wm_task_created: [2,0]
08-01 18:02:55.074  1662  1662 I wm_stack_created: 2
08-01 18:02:55.077  1662  1662 I wm_create_task: [0,2]
08-01 18:02:55.077  1662  1662 I wm_create_activity: [0,210442508,2,com.oppo.launcher/.Launcher,android.intent.action.MAIN,NULL,NULL,268435712]
08-01 18:02:55.606  1662  1935 I am_proc_start: [0,3344,10106,com.oppo.launcher,top-activity,{com.oppo.launcher/com.oppo.launcher.Launcher}]
08-01 18:02:55.683  1662  3267 I am_proc_bound: [0,3344,com.oppo.launcher]
08-01 18:02:55.712  1662  3267 I wm_restart_activity: [0,210442508,2,com.oppo.launcher/.Launcher]
08-01 18:02:55.727  1662  3267 I wm_set_resumed_activity: [0,com.oppo.launcher/.Launcher,minimalResumeActivityLocked]
// Process 3344 is launcher APP
08-01 18:02:56.590  3344  3344 I wm_on_create_called: [210442508,com.oppo.launcher.Launcher,performCreate]
08-01 18:02:56.594  3344  3344 I wm_on_start_called: [210442508,com.oppo.launcher.Launcher,handleStartActivity]
08-01 18:02:56.602  3344  3344 I wm_on_resume_called: [210442508,com.oppo.launcher.Launcher,RESUME_ACTIVITY]
08-01 18:02:56.610  3344  3344 I wm_on_top_resumed_gained_called: [210442508,com.oppo.launcher.Launcher,topStateChangedWhenResumed]
08-01 18:02:56.778  1662  1864 I boot_progress_enable_screen: 38027
```















