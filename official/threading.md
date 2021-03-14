## threading

<!-- toc -->

### 创建多线程的几种方法

`threading` 库主要有两种创建多线程的方法，和 `Java` 中的多线程类似，一种是面向方法的，一种是面向对象的。

1. 创建一个 `threading.Thread` 的实例，将子线程逻辑调用函数作为参数传入，然后调用 `start` 方法创建子线程。
2. 从 `threading.Thread` 派生出一个子类，实现这个类的 `run` 方法，在 `run` 方法中实现子线程逻辑，然后创建这个子类的实例。
> 还有第三种，创建一个 `threading.Thread` 的实例，传给它一个可调用的类实例，其实原理是和第一种一样的。

#### 参数传入

```python
# coding=utf-8

import threading
from time import ctime,sleep

def loop(nloop,nsec):
	print "loop",nloop," start at: ",ctime()
	sleep(nsec)
	print "loop",nloop,"end    at: ",ctime()

print "all start at: ",ctime()
loops = [4,2]
threads = []
nloops = range(len(loops))

#创建两个线程
for i in nloops:
	t = threading.Thread(target=loop,args=(i,loops[i]))
	threads.append(t)

#让两个线程同时开始
for i in nloops:
	threads[i].start()

print "all end   at: ",ctime()
```

保存为 `threading_start.py`，运行，看一下结果。

```
$ python threading_start.py
all start at:  Wed Oct  7 15:13:32 2020
loop 0  start at:  Wed Oct  7 15:13:32 2020
 loop 1  start at:  Wed Oct  7 15:13:32 2020
 all end   at:  Wed Oct  7 15:13:32 2020

loop 1 end    at:  Wed Oct  7 15:13:34 2020
loop 0 end    at:  Wed Oct  7 15:13:36 2020
```

两个分别耗时2秒和4秒的函数同时开始，然后总共耗时还是4秒，程序运行结束。

> 这里需要注意，按照代码逻辑主线程在唤起两个子线程之后，其实已经运行至最后一行并输出结束时间
> 但是此时程序还未结束，直至所有的子线程运行结束之后，主线程才真正结束。

接下来是第三种使用实例调用的方式

```python
# coding=utf-8

import threading
from time import ctime,sleep

class ThreadFunc(object):
	def __init__(self, func, args, name=""):
		self.args = args
		self.func = func
		self.name = name

	def __call__(self):
		apply(self.func, self.args)

def loop(nloop,nsec):
	print "loop",nloop," start at: ",ctime()
	sleep(nsec)
	print "loop",nloop,"end    at: ",ctime()

print "all start at: ",ctime()

loops = [4,2]
threads = []
nloops = range(len(loops))

for i in nloops:
	t = threading.Thread(target=ThreadFunc(loop,(i,loops[i]),loop.__name__))
	threads.append(t)

for i in nloops:
	threads[i].start()

for i in nloops:
	threads[i].join()

print "all end   at: ",ctime()
```

保存为 `threading_class.py`，运行，看一下结果。

![threading_class.jpg](/images/threading_class.jpg)

这里虽然传入的是对象实例，但是其实还是按照参数传入的方式进行的，主要的差异在于主线程被子线程阻塞，在子线程都运行结束之后，在运行至最后一行输出结束时间。

为什么在这里主线程会阻塞至子线程运行结束呢？因为在调用 `start` 函数唤起子线程之后，我们还调用了 `join` 函数，让子线程加入主线程，让主线程强行等待。

> 这里其实有一个小细节，第一个线程 `join` 方法之后，主线程已经进入阻塞状态，那么为什么第二个线程还能继续 `join` 呢？  
> 因为 `jion` 之后，子线程会阻塞主线程，或者说调用的线程，但是不影响其他的线程，所以其他的子线程可以继续 `join`    
> 其他子线程的创建和启动都是在主线程中执行的，但是其他子线程的 `join` 操作，其实是在子线程中执行的

```python
#coding=utf-8

import threading
from time import ctime,sleep

class ThreadFunc(object):
	def __init__(self, func ,args,name=""):
		self.args = args
		self.func = func
		self.name = name

	def __call__(self):
		apply(self.func,self.args)

def loop(nloop,nsec):
	print "loop",nloop," start at: ",ctime()
	sleep(nsec)
	print "loop",nloop,"end    at: ",ctime()

print "all start at: ",ctime()

loops = [4,2]
threads = []
nloops = range(len(loops))

for i in nloops:
	t = threading.Thread(target=ThreadFunc(loop,(i,loops[i]),loop.__name__))
	threads.append(t)	

for i in nloops:
	threads[i].start()

# for i in nloops:
# 	threads[i].join()
# 	print i, "is joined at: ", ctime()

# 甚至一个一个 join
threads[0].join()
print "0 is joined at: ", ctime()
threads[1].join()
print "1 is joined at: ", ctime()

print "all end   at: ",ctime()
```

看下结果，`join` 调用都是正常的，但是输出 `join` 时间都在主线程里被阻塞到最后了。

```
$ python code/threading_class_2.py
all start at:  Wed Oct  7 15:34:05 2020
loop 0loop 1  start at:  Wed Oct  7 15:34:05 2020
  start at:  Wed Oct  7 15:34:05 2020
loop 1 end    at:  Wed Oct  7 15:34:07 2020
loop 0 end    at:  Wed Oct  7 15:34:09 2020
0 is joined at:  Wed Oct  7 15:34:09 2020
1 is joined at:  Wed Oct  7 15:34:09 2020
all end   at:  Wed Oct  7 15:34:09 2020
```

#### 派生子类

```python
# coding=utf-8

import threading
from time import ctime,sleep

class MyThread(threading.Thread):
	def __init__(self, func, args, name=""):
		threading.Thread.__init__(self)
		self.name = name
		self.func = func
		self.args = args

	def run(self):
		apply(self.func, self.args)

def loop(nloop,nsec):
	print "loop",nloop," start at: ",ctime()
	sleep(nsec)
	print "loop",nloop,"end    at: ",ctime()

print "all start at: ",ctime()

loops = [4,2]
threads = []
nloops = range(len(loops))

for i in nloops:
	t = MyThread(loop,(i,loops[i]),loop.__name__)
	threads.append(t)

for i in nloops:
	threads[i].start()

for i in nloops:
	threads[i].join()

print "all end   at: ",ctime()
```

保存为threading_class_MyThread.py，运行，看一下结果是和我们预期的一样。

![threading_class_MyThread.jpg](/images/threading_class_MyThread.jpg)

上面的代码如果还是有函数传入的部分，如果有些理解混淆的话，也可以写成这样

```python
#coding=utf-8

import threading
from time import ctime,sleep


class ThreadDemo(threading.Thread):
	def __init__(self, nloop, nsec, name=""):
		threading.Thread.__init__(self)
		self.name = name
		self.nloop = nloop
		self.nsec = nsec

	def run(self):
		print "loop", self.nloop, "start  at: ", ctime()
		sleep(self.nsec)
		print "loop", self.nloop, "end    at: ", ctime()


print "all start at: ",ctime()

loops = [4,2]
threads = []
nloops = range(len(loops))

for i in nloops:
	t = ThreadDemo(i, loops[i], "loop")
	threads.append(t)	

for i in nloops:
	threads[i].start()

for i in nloops:
	threads[i].join()

print "all end   at: ", ctime()
```

这里为什么创建子类实例了之后，还是需要调用 `start` 方法呢？因为子线程 `threading.Thread` 的唤起就是需要使用 `start` 方法。

具体运行的子线程逻辑无论是参数传入，还是子类覆盖重写，子线程启动都需要 `start` 一下，其实看下库代码就能够理解了。

```python

class Thread(_Verbose):
    def __init__(self, group=None, target=None, name=None,
                 args=(), kwargs=None, verbose=None):
        """This constructor should always be called with keyword arguments. Arguments are:

        *group* should be None; reserved for future extension when a ThreadGroup
        class is implemented.

        *target* is the callable object to be invoked by the run()
        method. Defaults to None, meaning nothing is called.

        *name* is the thread name. By default, a unique name is constructed of
        the form "Thread-N" where N is a small decimal number.

        *args* is the argument tuple for the target invocation. Defaults to ().

        *kwargs* is a dictionary of keyword arguments for the target
        invocation. Defaults to {}.

        If a subclass overrides the constructor, it must make sure to invoke
        the base class constructor (Thread.__init__()) before doing anything
        else to the thread.

"""
        assert group is None, "group argument must be None for now"
        _Verbose.__init__(self, verbose)
        if kwargs is None:
            kwargs = {}
        self.__target = target
        self.__name = str(name or _newname())
        self.__args = args
        self.__kwargs = kwargs
        self.__daemonic = self._set_daemon()
        self.__ident = None
        self.__started = Event()
        self.__stopped = False
        self.__block = Condition(Lock())
        self.__initialized = True
        # sys.stderr is not stored in the class like
        # sys.exc_info since it can be changed between instances
        self.__stderr = _sys.stderr

    def run(self):
        """Method representing the thread's activity.

        You may override this method in a subclass. The standard run() method
        invokes the callable object passed to the object's constructor as the
        target argument, if any, with sequential and keyword arguments taken
        from the args and kwargs arguments, respectively.

        """
        try:
            if self.__target:
                self.__target(*self.__args, **self.__kwargs)
        finally:
            # Avoid a refcycle if the thread is running a function with
            # an argument that has a member that points to the thread.
            del self.__target, self.__args, self.__kwargs

```

> 这里还有一个小细节，我们其实有连续三次的循环 `append`,`start`,`join` 操作，那么能否放在一个循环里呢？   
> 将 `append` 和 `start` 放一起是可以的，因为 `start` 唤起子线程之后，不会阻塞主线程，可以继续 `start` 下一个   
> 但是不能将 `join` 也放一起，因为 `join` 之后之后会阻塞，只有下一个 `join` 才能继续    
> 如果 `join` 之后是创建新的子线程或者 `start` 操作都是会被阻塞的，因为这些操作是在主线程里，就没用到多线程，而是变成了同步操作       

```python
#coding=utf-8

import threading
from time import ctime,sleep


class ThreadDemo(threading.Thread):
	def __init__(self, nloop, nsec, name=""):
		threading.Thread.__init__(self)
		self.name = name
		self.nloop = nloop
		self.nsec = nsec

	def run(self):
		print "loop", self.nloop, "start  at: ", ctime()
		sleep(self.nsec)
		print "loop", self.nloop, "end    at: ", ctime()


print "all start at: ",ctime()

loops = [4,2]
threads = []
nloops = range(len(loops))

for i in nloops:
	t = ThreadDemo(i, loops[i], "loop")
	threads.append(t)	
	t.start()

for i in nloops:
	threads[i].join()

print "all end   at: ",ctime()

```

或者参数传入的方式

```python
# coding=utf-8

import threading
from time import ctime,sleep

def loop(nloop,nsec):
	print "loop",nloop," start at: ",ctime()
	sleep(nsec)
	print "loop",nloop,"end    at: ",ctime()

print "all start at: ",ctime()
loops = [4,2]
threads = []
nloops = range(len(loops))

#创建两个线程
for i in nloops:
	t = threading.Thread(target=loop,args=(i,loops[i]))
	threads.append(t)

#让两个线程同时开始
for i in nloops:
	threads[i].start()

#将两个线程加入主线程
#如果将join和start在一起的话
#就会阻塞主线程的执行
#没有产生另一个子线程
#所以并没有开启多线程
#还是一个线程一个线程的执行
for i in nloops:
	threads[i].join()

print "all end   at: ",ctime()
```

保存为threading_demo.py，运行，看一下结果。

![threading_demo.jpg](/images/threading_demo.jpg)

### 高阶使用

Python 中还要一个较为基础的 `thread` 库，这个库里还需要我们自己的去设定锁，并且在主线程里阻塞主线程的进行来判断锁是否已经释放, `threading` 是比 `thread` 更高级易于操作的多线程库。

在 `threading` 库中创建的子线程都是非守护线程，因为创建的子线程的 `Daemon` 属性继承父线程，而我们一般直接运行 Python 代码都是非守护线程的方式。

1. 对于非守护线程，主线程会等待全部线程结束再结束。
2. 而如果是守护线程，主线程运行结束之后就会立即终止，并不关心子线程的运行情况,守护进程也被强行终止。

我们可以通过 `threading.Thread.setDaemon(True)` 的方式来将子线程设置为守护线程

```python
# -*- coding: utf-8 -*-

import threading
from time import ctime, sleep


def loop(nloop, nsec):
    print("loop", nloop, " start at: ", ctime())
    sleep(nsec)
    print("loop", nloop, "end    at: ", ctime())


if __name__ == '__main__':

    print("all start at: ", ctime())
    loops = [4, 2]
    threads = []
    nloops = range(len(loops))

    # 创建两个线程
    for i in nloops:
        t = threading.Thread(target=loop, args=(i, loops[i]))
        t.setDaemon(True)
        threads.append(t)

    # 让两个线程同时开始
    for i in nloops:
        threads[i].start()

    print("all end   at: ", ctime())


```

运行结果就是只有开始，没有结束.

```
$ python threading_start_daemon.py
all start at:  Thu Oct  8 10:28:57 2020
loop 0loop 1  start at:  Thu Oct  8 10:28:57 2020
 all end   at:  Thu Oct  8 10:28:57 2020
  start at:  Thu Oct  8 10:28:57 2020
```

> 多线程中，子线程创建后，`start` 即开始子线程，主线程继续进行，`join` 即阻塞主线程，等待子线程结束后再继续主线程。  
> 在手动的将子线程加入(join)到主线程中后，主线程就会等待子线程全部结束才会继续之后的程序。    
> 在 `join` 被加入到主线程之后，虽然主线程被阻塞，但是并不影响其他线程，其他线程可以继续 `join` 到主线程。  
> 在未设置守护线程，未 `join` 到主线程中的时候，主线程会先运行结束，但是主程序未结束，等待子线程结束后程序才会结束。  
> 守护线程的意思就是说这个线程独立于主线程，主线程可以先于守护线程结束而不用等候守护线程结束，主进程结束，全部子进程都会结束。

对于守护线程，也可以使用 `join` 方法，同样可以阻塞主线程。
> 这里需要注意，只能对未启动(start)的子线程设置守护进程，对于已经启动子线程不能再设置为守护线程

```python
# -*- coding: utf-8 -*-

from threading import Thread
import os
import time


def sleeper(name, seconds):
    print 'starting child process with id: ', os.getpid()
    print 'parent process:', os.getppid()
    print 'sleeping for %s ' % seconds
    time.sleep(seconds)
    print "%s done sleeping" % name


if __name__ == '__main__':
    print "in parent process (id %s)" % os.getpid()
    p = Thread(target=sleeper, args=('bob', 5))
    print 'daemon?', p.isDaemon()
    p.setDaemon(not p.isDaemon())
    print 'daemon?', p.isDaemon()
    p.start()
    print "in parent process after child process start"
    print "parent process about to join child process"
    p.join()
    print "in parent process after child process join"
    print "parent process exiting with id ", os.getpid()
    print "The parent's parent process:", os.getppid()

```

或者这样

```python
#coding=utf-8

import threading
from time import ctime,sleep


class DaemonThreadDemo(threading.Thread):
	def __init__(self, nloop, nsec, name=""):
		threading.Thread.__init__(self)
		self.name = name
		self.nloop = nloop
		self.nsec = nsec

	def run(self):
		print "loop", self.nloop, "start  at: ", ctime()
		sleep(self.nsec)
		print "loop", self.nloop, "end    at: ", ctime()


print "all start at: ",ctime()

loops = [4,2]
threads = []
nloops = range(len(loops))

for i in nloops:
	t = DaemonThreadDemo(i, loops[i], "loop")
	t.setDaemon(True)
	t.start()
	threads.append(t)	

for i in nloops:
	threads[i].join()

print "all end   at: ",ctime()
```

### 生产者-消费者模式

然后我们再来介绍一种多线程模式，生产者-消费者模式，这也是现实生活中最常用的多线程模式。  
假设我们有这样一条工程，一共有两道工序。必须等到第一道工序结束了才能进行第二道工序。这时我们就引入了生产者和消费者的概念，第一道工序是生产者，第二道工序是消费者，分别是两个线程。

首先我们需要使用Queue队列模块，让多个线程之间共享数据。生产者不停的往队列里面加入货物，消费者不停的从队列里消费货物。   
假设我们一共有100个货物，生产者与消费者所需时间都是1秒以内的随机时间。

```python
# coding=utf-8

import threading
from Queue import Queue
from random import random
from time import ctime,sleep

def writeQ(queue):
	for i in range(100):
		print "Producting project for Q..."
		sleep(random())
		# sleep(random()/2.0)
		queue.put('xxx',1)
		print "Size now",queue.qsize()

def readQ(queue):
	for i in range(100):
		print "Consuming project from Q..."
		sleep(random())
		queue.get(1)
		print "Size now",queue.qsize()

print "all start at: ",ctime()

funcs = [writeQ,readQ]
nfunc = range(len(funcs))

q = Queue(48)
threads = []

for i in nfunc:
	t = threading.Thread(target=funcs[i],args=(q,))
	threads.append(t)

for i in nfunc:
	threads[i].start()

for i in nfunc:
	threads[i].join()

print "all end   at: ",ctime()
```

保存为为threading_queue.py，运行，看一下结果。

#### 八个线程
最后总花费大概50秒左右，已经能够把效率提高一倍了。可是仅仅这样怎么够，这才两个线程，让我们来开八个线程试一下，生产者和消费者各四个线程。   

可以看到在把生产者消费者线程增多的时候，果然相比较效率提高了很多。

```python
# coding=utf-8

import threading
from Queue import Queue
from random import random
from time import ctime,sleep

def writeQ(queue):
	for i in range(25):
		print "Producting project for Q..."
		sleep(random())
		queue.put('xxx',1)
		print "Size now",queue.qsize()

def readQ(queue):
	for i in range(25):
		print "Consuming project from Q..."
		sleep(random())
		queue.get(1)
		print "Size now",queue.qsize()

print "all start at: ",ctime()

funcs = [writeQ,readQ]
nfunc = range(len(funcs))

q = Queue(48)
threads = []

for i in nfunc:
	for j in range(4):
		t = threading.Thread(target=funcs[i],args=(q,))
		threads.append(t)

for i in range(8):
	threads[i].start()

for i in range(8):
	threads[i].join()

print "all end   at: ",ctime()
```

保存为threading_queue_last.py。
我们这是把生产者消费者同时执行，如果在生产者花费时间较短，只要时间在消费者的时候，我们可以先让生产者生产全部的货物，然后开多个子线程让消费者将其消费完为止。

### 资源锁定
前面我们已经看到因为线程同步的原因，输出的时候总是显得不那么整齐，就是因为多线程在抢占同一个资源的原因。而如果我们在对同一个数据进行操作时，因为多线程的原因，可能一个线程对其进行操作还未结束另一个线程就强行进行了下一轮更改，这样的话肯定会有一些问题。
所以这就需要资源锁定，当一个资源被锁定的时候，同时只能有一个资源对其进行操作，这样就保证了多线程的安全性。

我们先来看一下没有资源锁的情况

```python
# coding=utf-8

import threading
from time import ctime,sleep

counter = 0

class MyThread1(threading.Thread):
	def __init__(self):
		threading.Thread.__init__(self)

	def run(self):
		global counter
		counter += 1
		print "  "+str(counter)+"  "

class MyThread2(threading.Thread):
	def __init__(self):
		threading.Thread.__init__(self)

	def run(self):
		global counter
		counter -= 1
		print "  "+str(counter)+"  "

if __name__ == '__main__':
	threads = []
	for i in range(20):
		if i%2:
			t = MyThread1()
		else:
			t = MyThread2()
		threads.append(t)

	for t in threads:
		t.start()
```

保存为Threading_nolock.py，运行，看一下结果。

![threading_nolock.jpg](/images/threading_nolock.jpg)

现在我们将其上锁。

```python
# coding=utf-8

import threading
from time import ctime,sleep

counter = 0
lock = threading.Lock()

class MyThread1(threading.Thread):
	def __init__(self):
		threading.Thread.__init__(self)

	def run(self):
		if lock.acquire():
			global counter
			counter += 1
			print "  "+str(counter)+"  "
			lock.release()

class MyThread2(threading.Thread):
	def __init__(self):
		threading.Thread.__init__(self)

	def run(self):
		if lock.acquire():
			global counter
			counter -= 1
			print "  "+str(counter)+"  "
			lock.release()

if __name__ == '__main__':
	threads = []
	for i in range(20):
		if i%2:
			t = MyThread1()
		else:
			t = MyThread2()
		threads.append(t)

	for t in threads:
		t.start()
```

保存为threading_lock.py，运行，看一下结果。

![threading_lock.jpg](/images/threading_lock.jpg)

使用线程锁的话需要手动的获取和释放，也可以采用简洁的方法,使用 上下文管理器。

```
def run(self):
	with lock:
		global counter
		counter -= 1
		print "  "+str(counter)+"  "
```

Lock 与 RLock 的区别，Lock 只能锁一次，再次请求就会挂起，RLock 自带计数器，在一个线程中可以请求多次，等计数器全部释放之后，其他线程才能取得资源。

### 本地变量

threadLocal 线程局部变量，又称线程上下文，避免了使用全局变量需加锁的困境和局部变量调用不清的麻烦。保证在每个线程中的变量都是在线程内可读可写的，而不会被其他线程污染。

```python
# -*- coding: utf-8 -*-

import threading


local = threading.local()


def process_name():
    print "hello %s, in %s" % (local.name, threading.current_thread().name)


def process_local(name):
    local.name = name
    process_name()


if __name__ == '__main__':
    local.name = 'Cli'
    process_name()
    t1 = threading.Thread(target=process_local, args=('Bob', ), name='Target-A')  # noqa
    t2 = threading.Thread(target=process_local, args=('Alice', ), name='Target-B')  # noqa

    t1.start()
    t2.start()

    t1.join()
    t2.join()

```



线程变量是只能在当前线程中使用，在 flask 中即当前请求。但是 flask 不仅仅是只支持多线程，还有多进程，甚至单线程。

如何在单线程中使每个请求都获得一份局部变量。
- 将局部变量变成实例属性。

**注意，线程上下文中的变量不仅不能在两个子线程之间传递，也不能在主线程和子线程之间传递**

```python
# -*- coding: utf-8 -*-

import threading
local = threading.local()


def show_local():
    print "I'm child"
    print "local is %r" % local
    print "local value %s" % hasattr(local, "name")


if __name__ == '__main__':
    print "I'm child"
    print "local is %r" % local
    print "local value %s" % hasattr(local, "name")
    local.name = "father"
    print "local value %s" % local.name

    threading.Thread(target=show_local).start()

    print "local value %s" % local.name

```

### 线程数量

获得仍然存活的线程数量，其中包括主线程

```python
# -*- coding: utf-8 -*-

import os
import time
import random
import threading

def long_time_task(name):
    print 'Running task %s (%s)' % (name, os.getpid())
    start = time.time()
    time.sleep(random.random() * 5)
    end = time.time()
    print 'Task %s run %0.2f econds.' % (name, end - start)


if __name__ == '__main__':
    for i in xrange(10):
        threading.Thread(target=long_time_task, args=(str(i))).start()

    for i in xrange(10):
        print threading.enumerate(), len(threading.enumerate())
        time.sleep(1)

```

### 线程事件

线程事件 event 像是一个线程间的共享变量，可以做并发控制。

```python
# -*- coding: utf-8 -*-

import time
import logging
from threading import Thread, Event
from logging.config import dictConfig


logging_config = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {"default": {"format": "%(asctime)s %(levelname)-8s %(filename)s:%(lineno)d %(message)s"}},
    "handlers": {
        "console": {"level": "INFO", "class": "logging.StreamHandler", "formatter": "default"},
        "file_logger": {
            "level": "INFO",
            "class": "logging.FileHandler",
            "formatter": "default",
            "filename": "threading.log",
        },
    },
    "root": {"handlers": ["file_logger", "console"], "level": "INFO"},
}
dictConfig(logging_config)
stop_event = Event()


def continue_thread_run():
    logger = logging.getLogger(__name__)
    while True:
        if stop_event.is_set():
            break
        logger.info("wait for stop_event")
        time.sleep(1)


def wait_for_time():
    logger = logging.getLogger(__name__)
    while True:
        if int(time.time()) > 1615711196:
            stop_event.set()
            break
        logger.info("stop_event not ready:%d" % int(time.time()))
        time.sleep(1)


if __name__ == '__main__':
    thread_list = [Thread(target=continue_thread_run), Thread(target=wait_for_time)]
    for thread in thread_list:
        # thread.setDaemon(True)
        thread.start()

    for thread in thread_list:
        thread.join()

```

### 线程池

线程池：基本思想还是一种对象池的思想，开辟一块内存空间，里面存放了众多(未死亡)的线程，池中线程执行调度由池管理器来处理。当有线程任务时，从池中取一个，执行完成后线程对象归池，这样可以避免反复创建线程对象所带来的性能开销，节省了系统的资源。

线程池的优点
1. 避免线程的创建和销毁带来的性能开销。   
2. 避免大量的线程间因互相抢占系统资源导致的阻塞现象。   
3. 能够对线程进行简单的管理并提供定时执行、间隔执行等功能。   

需要执行的线程数大于同时执行的线程。如果需要执行的线程数与同时执行的线程数相同，即线程池大小相同，线程池是不是就没有太大意义？

所以线程池的应用场景就和队列的应用场景类似   
- 如果执行的函数的参数由生产者提供，数量不定，即使用队列，将生产者也起一个线程，消费者多个线程
- 如果执行的函数的参数由主线程提供，数量固定，即使用线程池，将总参数和总线程数都放入线程池中，从线程池中取线程执行函数。

如果执行函数的结果需要传出，使用队列或者线程池不如使用消息队列的发布订阅模式
- 多个生产者的执行结果传入队列，单个消费者从队列中取出数据，但是如果消费者的速度大于生产者的速度，可能造成队列为空，消费者自行结束的情况
- 将函数放入线程池中执行，从线程池中取结果，对结果顺序要求不大的可以采用线程池
- 多个生产者的执行结果发布至消息队列，消费者从消息队列中监听数据。

线程池可以使用 Python 官方自带的 `concurrent` 库

### 多线程的结束

在多线程中,使用 `Ctrl + C` 一般不能结束子线程，因为发出的 kill signal 只能够被主线程 main 接收到，而不能够被子线程接收到，在 Mac 上可以使用 `Ctrl + \` 结束子线程，强行 quit 掉

这样也可以结束,但是感觉很奇怪

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys, time, threading, abc
from optparse import OptionParser

def parse_options():
    parser = OptionParser()
    parser.add_option("-t", action="store", type="int", dest="threadNum", default=1,
                      help="thread count [1]")
    (options, args) = parser.parse_args()
    return options

class thread_sample(threading.Thread):
    def __init__(self, name):
        threading.Thread.__init__(self)
        self.name = name
        self.kill_received = False

    def run(self):

        while not self.kill_received:
            # your code
            print self.name, "is active"
            time.sleep(1)

def has_live_threads(threads):
    return True in [t.isAlive() for t in threads]

def main():
    options = parse_options()
    threads = []

    for i in range(options.threadNum):
            thread = thread_sample("thread#" + str(i))
            thread.start()
            threads.append(thread)

    while has_live_threads(threads):
        try:
            # synchronization timeout of threads kill
            [t.join(1) for t in threads
             if t is not None and t.isAlive()]
        except KeyboardInterrupt:
            # Ctrl-C handling and send kill to threads
            print "Sending kill to threads..."
            for t in threads:
                t.kill_received = True

    print "Exited"

if __name__ == '__main__':
   main()
```


### 多线程的异常输出

多线程中虽然是与主线程共享变量，但是有自己的堆栈，而子线程异常信息是保存在堆栈上，主线程无法输出。

所以在某些多线程中子线程异常是无法察觉到的，没有报错信息，悄无声息的就死掉了。

需要借助一些子线程和主线程数据沟通的方式将子线程的异常输出，或者是使用日志记录。

### 线程定时器

多线程中自带一个异步的定时器，可以指定线程定时执行，甚至可以间隔执行。

默认定时器只执行一次，如果需要间隔执行，需要多次调用。

```python
# -*- coding: utf-8 -*-
import time
import threading


def on_timer():
    print time.time()
    set_timer()


def set_timer():
    _timer = threading.Timer(10, on_timer)
    _timer.start()


set_timer()
while 1:
    time.sleep(5)
    print 'sleep', time.time()

```
