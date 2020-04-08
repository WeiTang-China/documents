



































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

如果把odm下的precompiled删除了，它就重新编译并加载所有的cil文件

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





