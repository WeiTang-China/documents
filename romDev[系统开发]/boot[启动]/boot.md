



# 启动顺序

```
$ adb shell dmesg | grep "processing action"
[    4.376074] init: processing action 0x35480 (init)
[    4.440537] init: processing action 0x38c58 (init)
[    4.450009] init: processing action 0x35708 (early-fs)
[    5.531812] init: processing action 0x39c38 (console_init)
[    5.575831] init: processing action 0x2de70 (fs)
[    5.597799] init: processing action 0x35890 (fs)
[    7.089157] init: processing action 0x2df58 (post-fs)
[    7.091550] init: processing action 0x38cb8 (post-fs)
[    7.091818] init: processing action 0x2e288 (post-fs-data)
[    7.100189] init: processing action 0x39c80 (property_service_init)
[    7.110080] init: processing action 0x39cc8 (signal_init)
[    7.110177] init: processing action 0x39d10 (check_startup)
[    7.110248] init: processing action 0x2ea18 (boot)
[    7.126205] init: processing action 0x397e0 (boot)
[    8.183090] init: processing action 0x39d58 (queue_property_triggers)
[    8.183232] init: processing action 0x2f8f8 (nonencrypted)
[    8.183810] init: processing action 0x2fd98 (property:ro.debuggable=1)
[    8.184463] init: processing action 0x328f8 (property:sys.usb.config=none)
[   14.438626] init: processing action 0x2ffd0 (property:sys.sensors=1)
[   28.192393] init: processing action 0x31860 (property:sys.boot_completed=1)
```































































