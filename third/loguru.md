## loguru

<!-- toc -->


一般我们在使用 `logging` 打印日志的时候，都要配置一大坨复杂的东西，输出格式，文件位置，日志分割之类的，使用 `loguru` 可以更快更方便的实现这些。

> 还有就是 `loguru` 由 C 语言重写，性能也更好。

而且使用 `logging` 的时候，如果没有配置，使用的是 warning 级别，输出的日志格式也不好看。

> 猛男落泪, `loguru` 只支持 python3

### 简单使用

```python
# coding=utf-8

from loguru import logger


logger.debug("Hi")
logger.info("hello world")
logger.warning("I'm comming")
logger.error("Be careful")

```

运行看下

```
2020-10-18 11:37:54.804 | DEBUG    | __main__:<module>:6 - Hi
2020-10-18 11:37:54.805 | INFO     | __main__:<module>:7 - hello world
2020-10-18 11:37:54.805 | WARNING  | __main__:<module>:8 - I'm comming
2020-10-18 11:37:54.805 | ERROR    | __main__:<module>:9 - Be careful
```

输出格式清晰大方，还有不同的颜色，比 `logging` 好看一百倍。


### 常用配置

同样的，默认只有输出到屏幕，我们也可以配置输出格式和输出到文件。

```python
# coding=utf-8

import sys
from loguru import logger


logger.add("file_{time}.log")
logger.info("hello, world!")

logger.add(sys.stderr, colorize=True, format="<green>{time}</green> <level>{message}</level>", level="INFO")
logger.debug("not important message")
logger.info("aha, I'm here")


```

也可以对日志文件做分配和压缩

```
logger.add(LOG_FILE, rotation = "200KB", compression="zip")
```

如果想删除历史文件，只保留最后一份压缩文件，也可以指定保留数量

```python
# coding=utf-8

import sys
from loguru import logger


logger.add("file_{time}.log", rotation = "200KB", compression="zip", retention=1)
logger.info("hello, world!")

for i in range(10000):
	logger.debug("not important message")
	logger.info("aha, I'm here")

```

使用 `logger.remove()` 删除默认的 `handle`, 传入每次 `add` 的 `handle_id` 删除指定 `handle`

### 异常展示

一般我们知道在打印异常的时候,使用 `logger.exception` 能够得到比 `logger.error` 更多的异常堆栈信息，如果使用 `loguru` 能够让你得到更多的异常追溯信息。

```python
# coding=utf-8

from loguru import logger


def division(a, b):
	try:
		c = a / b
		return c
	except Exception as e:
		logger.exception(e)



if __name__ == '__main__':
	division(3, 0)


```

运行结果

```python
python loguru_exception.py
2020-10-18 15:29:55.401 | ERROR    | __main__:division:11 - division by zero
Traceback (most recent call last):

  File "loguru_exception.py", line 16, in <module>
    division(3, 0)
    └ <function division at 0x7ff37d568ef0>

> File "loguru_exception.py", line 8, in division
    c = a / b
        │   └ 0
        └ 3

ZeroDivisionError: division by zero
```

### 兼容处理

在 `loguru.add` 中可以直接使用 `logging.Handler` 那么在 `loguru` 中可以继续使用 `logging` 项目的 `handle` 配置, 反过来也是同理

```
# -*- coding: utf-8 -*-

import logging
from loguru import logger
from logging.config import dictConfig

logging_config = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {"default": {"format": "%(asctime)s %(levelname)-8s %(filename)s:%(lineno)d %(message)s"}},
    "handlers": {
        "console": {"level": "INFO", "class": "logging.StreamHandler", "formatter": "default"},
        "file_logger": {"level": "INFO", "class": "logging.FileHandler", "formatter": "default", "filename": "file.log"}
    },
    "root": {"handlers": ["file_logger", "console"], "level": "INFO"},
}
dictConfig(logging_config)
logger.remove()

for handle in logging.root.handlers:
    logger.add(handle)

# logger = logging.getLogger(__name__)

# class InterceptHandler(logging.Handler):
#     def emit(self, record):
#         try:
#             level = logger.level(record.levelname).name
#         except ValueError:
#             level = record.levelno
#
#         frame, depth = logging.currentframe(), 2
#         while frame.f_code.co_filename == logging.__file__:
#             frame = frame.f_back
#             depth += 1
#
#         logger.opt(depth=depth, exception=record.exc_info).log(level, record.getMessage())
#
#
# logging.basicConfig(handlers=[InterceptHandler()], level=0)


if __name__ == '__main__':

    logger.info("Test in Fusion")

```

### 参考

[loguru](https://github.com/Delgan/loguru)  
[不想手动再配置logging？那可以试试loguru](https://mp.weixin.qq.com/s/l-p6pMntOLrIl17d1GOvFw)  

