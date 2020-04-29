



































# 小技巧

## avc日志不显示

内核属性/proc/fs/selinux/enable_audit控制是否显示denied log，开关方法如下所示：

```s
generic_arm64:/ # cat /proc/fs/selinux/enable_audit
selinux denied log enable is: 0
generic_arm64:/ #
generic_arm64:/ #
generic_arm64:/ # echo 1 > /proc/fs/selinux/enable_audit
generic_arm64:/ #
generic_arm64:/ # cat /proc/fs/selinux/enable_audit
selinux denied log enable is: 1
```



## 快速调试selinux

参考[selinux.cpp](http://www.aospxref.com/android-10.0.0_r2/xref/system/core/init/selinux.cpp)的文件头注释：

如果有这个precompiled文件且hash和system/product下的一致，就用precompiled文件； 

如果把odm或者vendor下的precompiled删除了，它就重新编译并加载所有的cil文件

```
This file contains the functions that initialize SELinux during boot as well as helper functions
for SELinux operation for init.

When the system boots, there is no SEPolicy present and init is running in the kernel domain.
Init loads the SEPolicy from the file system, restores the context of /system/bin/init based on
this SEPolicy, and finally exec()'s itself to run in the proper domain.

The SEPolicy on Android comes in two variants: monolithic and split.

The monolithic policy variant is for legacy non-treble devices that contain a single SEPolicy
file located at /sepolicy and is directly loaded into the kernel SELinux subsystem.

The split policy is for supporting treble devices.  It splits the SEPolicy across files on
/system/etc/selinux (the 'plat' portion of the policy) and /vendor/etc/selinux (the 'nonplat'
portion of the policy).  This is necessary to allow the system image to be updated independently
of the vendor image, while maintaining contributions from both partitions in the SEPolicy.  This
is especially important for VTS testing, where the SEPolicy on the Google System Image may not be
identical to the system image shipped on a vendor's device.

The split SEPolicy is loaded as described below:
1) There is a precompiled SEPolicy located at either /vendor/etc/selinux/precompiled_sepolicy or
   /odm/etc/selinux/precompiled_sepolicy if odm parition is present.  Stored along with this file
   are the sha256 hashes of the parts of the SEPolicy on /system and /product that were used to
   compile this precompiled policy.  The system partition contains a similar sha256 of the parts
   of the SEPolicy that it currently contains.  Symmetrically, product paritition contains a
   sha256 of its SEPolicy.  System loads this precompiled_sepolicy directly if and only if hashes
   for system policy match and hashes for product policy match.
2) If these hashes do not match, then either /system or /product (or both) have been updated out
   of sync with /vendor and the init needs to compile the SEPolicy.  /system contains the
   SEPolicy compiler, secilc, and it is used by the LoadSplitPolicy() function below to compile
   the SEPolicy to a temp directory and load it.  That function contains even more documentation
   with the specific implementation details of how the SEPolicy is compiled if needed.
```

可以参考其他配置，直接修改cil文件，push回手机并reboot，快速验证效果。



具体操作可以参考如下步骤：

1. remount system/vendor分区（需要root和unlock设备）

   adb disable-verity

   adb reboot

   adb remount



2. 替换相关selinux policy改动的文件：

  - te

    需要修改/vendor/etc/selinux/vendor_sepolicy_debug.cil或者/system/etc/selinux/plat_sepolicy_debug.cil （AOSP原始版本不带debug后缀）

- file_contexts

  需要修改/vendor/etc/selinux/vendor_file_contexts或者/system/etc/selinux/plat_file_contexts, 针对这个修改，通过下面命令使目标文件selabel生效

  adb shell restorecon

- property_contexts

  需要修改/vendor/etc/selinux/vendor_property_contexts或者 /system/etc/selinux/plat_property_contexts

- service_contexts

  需要修改/system/etc/selinux/plat_service_contexts

- vndservice_contexts

  需要修改/vendor/etc/selinux/vndservice_contexts

- hwservice_contexts

  需要修改/vendor/etc/selinux/vendor_hwservice_contexts或者 /system/etc/selinux/plat_hwservice_contexts

- seapp_contexts

  需要修改/vendor/etc/selinux/vendor_seapp_contexts或者/system/etc/selinux/plat_seapp_contexts



3. 验证策略改动没有问题（否则会导致不开机），方法有如下2种

- 单独编译selinux_policy，确保没有nerverallow, 编译命令如下

  ./mk_android.sh -t user -m selinux_policy -N

- 手机端编译修改，确保没有policy编译错误，命令如下

  adb shell secilc /system/etc/selinux/plat_sepolicy_debug.cil -m -M true -G -N -c 30 -o /dev/sepolicy.bin -f /dev/null /system/etc/selinux/mapping/29.0.cil  /vendor/etc/selinux/vendor_sepolicy_debug.cil  /vendor/etc/selinux/plat_pub_versioned_debug.cil

 

4. 重启手机生效selinux policy修改







