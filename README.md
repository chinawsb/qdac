## QDAC3

QDAC 是 Quick Data Access Components 的简称，包括多种功能组合支持。具体可以参考 https://blog.qdac.cc 。

主库地址：http://code.qdac.cc:3000

国内镜像地址：https://gitee.com/z-proj/qdac

国外镜像地址：https://github.com/chinawsb/qdac

# 更新说明

* 修正与 Delphi/C++ Builder 12 的兼容性
## QWorker

* 修正 FSignalJobCount 的计数错误问题
* 修正了计划任务年份处理的缺陷
## QJson
* 增加多个辅助函数:NameArray/ValueArray/CatNames/CateValues/NameToStrings/ValueToStrings/ValuesFromStrings/ValuesFromIntegers/ValuesFromInt64s/ValueFromFloats
* JsonCat 参数变更
## QDigest
* 修正编译警告
## QConsoleLooper
* Linux 增加 SIGQUIT/SIGNINT/SIGUSR1 信号
* 支持 systemd 服务安装及重载配置文件