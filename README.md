## QDAC3

Main repository address: http://code.qdac.cc:3000

mirror address in China: https://gitee.com/z-proj/qdac

mirror address in Github: https://github.com/chinawsb/qdac

QDAC(Quick Data Access Components) is an open-source component library for Delphi/C++ Builder developed by Zuoyou Software Development Co., Ltd. It supports Rad Studio Delphi/C++ Builder 2007 and above, The goal is to provide an efficient and stable cross-platform rapid data access component to replace the low-performance components implemented by the system.

As a rapid data access component, QDAC places great emphasis on speed, but due to cross-platform considerations, QDAC is written in pure Pascal source code, which may use assembly code on Windows platforms. Therefore, in most cases, its performance is not superior to versions optimized using pure assembly, but it is far superior to ordinary implementations. At the same time, QDAC also places great emphasis on stability, so we hope that you can participate in testing and ensure that there are no stability issues while optimizing for speed.

Currently, the QDAC project includes the following components (QDB will no longer be updated):

## QWorker

QWorker is an job-based perspective parallel programming framework that provides a wealth of functions and interfaces. For more information, Please visit the QDAC website and read the QWorker topic.

## QJson

QJson is a fast cross-platform unit for JSON paser that provides  a wealth of functions and interfaces. Compared with SuperObject and other solutions, it is even faster. For more information, Please visit the QDAC website and read the QJson topic.

## QXML

QXML is a fast cross-platform unit for XML paser that provides  a wealth of functions and interfaces. Compared with NativeXML and other solutions, it is even faster. For more information, please refer to the relevant comments in the source code.

## QMsgPack

QMsgPack is a cross-platform and fast Message Pack protocol that provides  a wealth of functions and interfaces.  and fully supports the extended data types of the Message Pack protocol. It is still the fastest implementation of the Message Pack protocol in Delphi. For more information, Please visit the QDAC website and read the QMsgPack topic.

## QLog

QLog is a cross-platform asynchronous pacal log unit that supports the Linux standard SyslogD. By adopting an asynchronous approach, the impact on the program speed is minimized. It also has the function of automatically compressing and splitting log files.

## QMacros

QMacros is a cross-platform template substitution library that outperforms the original StringReplace function as the amount of content to be replaced increases. For more information, Please visit the QDAC website and read the QMacros topic.

## QAES

QAES is an AES encryption implementation that provides simple and easy-to-use interfaces. For more information, please refer to the relevant comments in the source code.

## QDigest

QDigest is a MD5 and SHA hash digest implementation that also includes simple and easy-to-use interfaces. For more information, please refer to the relevant comments in the source code.

## QMemStatics

QMemStatics is a Windows-based memory allocation analysis tool used to analyze the allocation of different-sized memory blocks in memory,  facilitate the rational planning and design of object pool types and sizes when designing service programs.

## QRBTree

QRBTree includes implementations of both red-black trees and hash buckets, two data structures whose information is easily searchable online. Many units such as QWorker in this project are based on QRBTree units. 

## QSimplePool

QSimplePool provides a simple pool implementation that can be used for memory pools and object pools.

## QPlugins

QPlugins is a new plugin framework that was designed based on the philosophy of "everything as a service" to achieve comprehensive decoupling of software design processes.

## QDB

QDB provides an open-source cross-platform database direct access solution that plans to support common databases such as SQLite, PostgreSQL, MSSQL, Oracle, and MySQL. Additionally, the TQDataSet will provide support for a wealth of functions such as copy, clone, filter, group, import, export, etc. 

## QConsoleLooper
QConsoleLooper is used to achieve a console loop effect with built-in Linux systemd service installation and runtime support.

# What's New

    * Fixed compatibility issues with Delphi/C++ Builder 12.
## QWorker

    * Fixed the counting issue with FSignalJobCount.
    * Fixed a bug in the processing of year for scheduled tasks.
## QJson
    * Add functions: NameArray, ValueArray, CatNames, CateValues, NameToStrings, ValueToStrings, ValuesFromStrings, ValuesFromIntegers, ValuesFromInt64s, ValueFromFloats.
    * Change JsonCat parameter.
## QDigest
    * Fixed a warning for compiler.
## QConsoleLooper

    * Added SIGQUIT, SIGNINT, SIGUSR1 signals for Linux.
    * Supports systemd service installation and configuration reload.