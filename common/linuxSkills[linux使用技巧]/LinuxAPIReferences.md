# Linux API References (sorted by alphabet)

## [access(2)](https://man7.org/linux/man-pages/man2/access.2.html)

int access(const char *pathname, int mode);

检查文件是否有权限。

mode: R_OK, W_OK, X_OK,  F_OK(文件是否存在)

返回值：

0，有对应的权限，或者F_OK时，文件存在

非0，失败