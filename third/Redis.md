## redis

<!-- toc -->

redis 是一个基于内存的 键值对 存储系统，是 NoSQL 的两大代表之一，另一个是 mongoDB 。它不仅能做数据库，还能做缓存，消息代理等，功能十分强大。它支持的数据结构有 字符串, 列表, 集合, 字典, 散列, 有序集合, 位图, 地理位置，等多种数据结构，同时它的数据存储在内存中，也可以持久化到硬盘。

常见的五种数据结构与 Python 中的数据结构的对应 字符串(STRING) == 字符串 (String), 列表(LIST) == 列表 (List), 集合(SET) == 集合 (Set), 散列(HASH) == 字典 (Dict), 有序集合(ZSET) == 有序集合 (Dict), 在 Python 中没有 有序集合 的概念，所以只能当做一个有顺序的集合。

redis 的 服务器端是 `redis-server` ，客户端是 `redis-cli`。

一般常用的命令有 `set [key] [value]`(增值, 改值), `get [key]`(取值), `del [key]`(删值), `type [key]`(查看数据类型), `keys *`(查找键), `rename [key] [key]`(改名) 等。

其中 `del`, `type`, `rename` 是对所有数据类型通用的。

### 基础使用

- `redis.Redis(self, host='localhost', port=6379, db=0, password=None, socket_timeout=None, socket_connect_timeout=None, socket_keepalive=None, socket_keepalive_options=None, connection_pool=None, unix_socket_path=None, encoding='utf-8', encoding_errors='strict', charset=None, errors=None, decode_responses=False, retry_on_timeout=False, ssl=False, ssl_keyfile=None, ssl_certfile=None, ssl_cert_reqs=None, ssl_ca_certs=None, max_connections=None)` 连接数据库
- `redis.Redis.set(self, name, value, ex=None, px=None, nx=False, xx=False)`  在数据库中增加键值对
- `redis.Redis.get(self, name)` 从数据库中获得键值对

```
# coding=utf-8

import redis

r = redis.Redis()

r.set('name', 'windard')

print r.get('name'), type(r.get('name'))

r.set('windard_infomation', {'name': 'windard', 'year': 21, 'school': 'xidian'})

print r.get('windard_infomation'), type(r.get('windard_infomation'))

r.set('num', [7, 8, 9, 10])

print r.get('num'), type(r.get('num'))
```

输出

```
windard <type 'str'>
{'school': 'xidian', 'name': 'windard', 'year': 21} <type 'str'>
[7, 8, 9, 10] <type 'str'>
```

... 为什么跟我想象的不一样，数组和字典，输出都是 字符串 结构的吖，难道还要自行转换一下。

在使用 `set` 和 `get` 的时候，还可以使用 `mset` 和 `mget` 来批量导入导出，使用字符串还有很多其他的操作，如获得字符串长度，获得部分字符串等。

- `redis.Redis.mset(self, *args, **kwargs)`
- `redis.Redis.mget(self, keys, *args)`
- `redis.Redis.strlen(self, name)`
- `redis.Redis.substr(self, name, start, end=-1)`
- `redis.Redis.incr(self, name, amount=1)`
- `redis.Redis.decr(self, name, amount=1)`
- `redis.Redis.incrby(self, name, amount=1)`
- `redis.Redis.decr(self, name, amount=1)`

```
# coding=utf-8

import redis

r = redis.Redis()

r.mset({'country:name': 'China', 'country:location': 'Asia', 'country:area': '960'})

print r.mget({'country:name', 'country:area'})

r.set('school', 'xidian')

print r.get('school')

print r.strlen('school')

print r.substr('school', 0, 3)

r.set('num', 1)

print r.incr('num')

print r.get('num')

print r.incrby('num', 4)

print r.get('num')

print r.decr('num')

print r.get('num')
```

输出

```
['China', '960']
xidian
6
xidi
2
2
6
6
5
5
```

### 使用列表

注意，在再次使用中设置一个已有键的值，如果两次设置的值的数据类型不一致，会报错 `redis.exceptions.ResponseError: WRONGTYPE Operation against a key holding the wrong kind of value`

可以尽量不要使用同一个键，或者在再次使用中删除该键值对。

- `redis.Redis.lpush(self, name, *values)` 往某个键中从左往右填入列表
- `redis.Redis.rpush(self, name, *values)` 往某个键中从右往左填入列表
- `redis.Redis.lpop(self, name)` 从某个键中从左往右取出值
- `redis.Redis.rpop(self, name)` 从某个键中从右往左取出值
- `redis.Redis.lrange(self, name, start, end)` 从某个键取出某些值

```
# coding=utf-8

import redis

r = redis.Redis()

r.delete('num')

# 填入一个值
r.rpush('num', 1)

r.rpush('num', 9)

# 索引从第一个到最后一个的值
result = r.lrange('num', 0, -1)

print result, type(result)

# 从另一个方向填值
r.lpush('num', 1)

r.lpush('num', 9)

result = r.lrange('num', 0, -1)

print result, type(result)
```

输出

```
['1', '9'] <type 'list'>
['9', '1', '1', '9'] <type 'list'>
```

这才是我们想要的列表类型，对列表类型的操作都是以栈的形式进行的。

- `redis.Redis.lindex(self, name, index)`
- `redis.Redis.ltrim(self, name, start, end)`
- `redis.Redis.llen(self, name)`

```
# coding=utf-8

import redis

r = redis.Redis()

r.delete('num')

# 一次填充多个数值
r.rpush('num', *[1, 6, 9])

# 从另一个方向填值, 这样填入就会被当成字符串
r.lpush('num', [3, 2, 1])

result = r.lrange('num', 0, -1)
print result, type(result)

# 从左边索引到 序号为3 的值

index = r.lindex('num', 3)
print index

# 对列表进行修剪，将第一个去掉
r.ltrim('num', 1, -1)

result = r.lrange('num', 0, -1)
print result, type(result)

# pop 最左边的元素

print r.lpop('num')

# pop 最右边的元素

print r.rpop('num')

result = r.lrange('num', 0, -1)
print result, type(result)
```

有几点需注意：
- 虽然我们推进去的是列表，但是每个列表的值，本来是数字，结果还是逃不掉变成字符串的命运，不过还是可以进行加减操作
- 若要一次推入多个数值，需要使用 `*[list]` ，而不是直接推入数组，否则也是字符串
- 只有 `push` 和 `pop` 有左边，有右边操作，可以双边操作，其他的 `index`, `range`, `trim` 等都只有左边

### 使用集合

在 Python 中，集合与列表的区别就是 不能有重复的值 ，在 redis 同理。

列表可以存储多个相同的字符串，而集合通过散列来保证自己的每个字符串都是各不相同的。

列表是有序的，而集合是无序的。所以列表有左右之分，而集合则是直接添加。

- `redis.Redis.sadd(self, name, *values)`
- `redis.Redis.scard(self, name)`
- `redis.Redis.smembers(self, name)`
- `redis.Redis.sismember(self, name, value)`

```
# coding=utf-8

import redis

r = redis.Redis()

r.delete('name')

r.sadd('name', 'mary', 'heny')

r.sadd('name', 'john', 'anny')

print r.smembers('name')

# 查看集合中值的数量
print r.scard('name')

print r.sismember('name', 'john')

print r.sismember('name', 'venr')

```

输出

```
4
set(['john', 'heny', 'anny', 'mary'])
True
False
```

### 使用有序集合

- `redis.Redis.zrem(self, name, *values)`
- `redis.Redis.zadd(self, name, *args, **kwargs)`
- `redis.Redis.zrank(self, name, value)`
- `redis.Redis.zcard(self, name)`
- `redis.Redis.zscore(self, name, value)`
- `redis.Redis.zcount(self, name, min, max)`
- `redis.Redis.zrange(self, name, start, end, desc=False, withscores=False, score_cast_func=<type 'float'>)`
- `redis.Redis.zrangebyscore(self, name, min, max, start=None, num=None, withscores=False, score_cast_func=<type 'float'>)`
- `redis.Redis.zremrangebyrank(self, name, min, max)`
- `redis.Redis.zincrby(self, name, amount, value)`

> 关于 zadd 需要注意一点，如果使用 `redis.Redis` 那么参数顺序是 `value score` ，但是实际的 redis 命令与之相反，即 `redis.StrictRedis` 的 add 顺序是 `value score`.
> `zadd` 的请求参数好像又改了，传入是一个 dict mapping。😂
> `zincrby` 好的，可以试下。

```
# coding=utf-8

import redis

r = redis.Redis()

r.delete('name')

# mary 的分数是 1.1
# lily 的分数是 3.3
# john 的分数是 2.2
# heny 的分数是 4.4
r.zadd('name', 'mary', 1.1, 'lily', 3.3, john=2.2, heny=4.4)
# 实际的 redis 命令，value 在后，score 在前

# 查看所有元素
print r.zrange('name', 0, -1)

# 查看某个元素的位置
print r.zrank('name', 'lily')

# 查看所有元素，并显示分数
print r.zrange('name', 0, -1, withscores=True)

# 查看分数在 2-4 之间的元素
print r.zrangebyscore('name', 2, 4)

# 计数，统计所有元素的数量
print r.zcard('name')

# 计数，统计分数在 0-3 之间的数目
print r.zcount('name', 0, 3)

# 删除元素
r.zrem('name', 'mary')

print r.zrange('name', 0, -1)

# 通过索引删除元素
r.zremrangebyrank('name', 0, 1)

print r.zrange('name', 0, -1)

# 通过分数删除元素
r.zremrangebyscore('name', 1, 2)

print r.zrange('name', 0, -1)

```

输出

```
['mary', 'john', 'lily', 'heny']
2
[('mary', 1.1), ('john', 2.2), ('lily', 3.3), ('heny', 4.4)]
['john', 'lily']
4
2
['john', 'lily', 'heny']
['heny']
['heny']
```

### 使用散列

- `redis.Redis.hset(self, name, key, value)`
- `redis.Redis.hget(self, name, key)`
- `redis.Redis.hdel(self, name, *keys)`
- `redis.Redis.hmset(self, name, mapping)`
- `redis.Redis.hmget(self, name, keys, *args)`
- `redis.Redis.hgetall(self, name)`
- `redis.Redis.hscan(self, name, cursor=0, match=None, count=None)`
- `redis.Redis.hkeys(self, name)`
- `redis.Redis.hvals(self, name)`

```
# coding=utf-8

import redis

r = redis.Redis()

r.delete('school')

# 在一个键值对中设置一个键值对
r.hset('school', 'name', 'xidian')

print r.hget('school', 'name')

# 在一个键值对中设置多个键值对
r.hmset('school', {'year': 86, 'location': 'Shannxi'})

# 一次获得多个键的值
print r.hmget('school', ['name', 'year']), type(r.hmget('school', ['name', 'year']))

# 一次获得全部的键值对
print r.hgetall('school'), type(r.hgetall('school'))

# 扫描全部键值对
print r.hscan('school')

# 删除字典的某个键值对
r.hdel('school', 'name')

print r.hgetall('school'), type(r.hgetall('school'))

# 字典的长度
print r.hlen('school')

# 字典的所有键
print r.hkeys('school')

#字典的所有值
print r.hvals('school')

```

输出

```
xidian
['xidian', '86'] <type 'list'>
{'year': '86', 'name': 'xidian', 'location': 'Shannxi'} <type 'dict'>
(0L, {'year': '86', 'name': 'xidian', 'location': 'Shannxi'})
{'location': 'Shannxi', 'year': '86'} <type 'dict'>
2
['location', 'year']
['Shannxi', '86']
```

### 订阅和收听

使用 redis 可以作为消息队列使用，并不需要使用 RQ(Redis Queue) 就可以使用 订阅和收听 来作为消息队列。

在一个 redis 的终端中开始收听

```
127.0.0.1:6379> subscribe hello
Reading messages... (press Ctrl-C to quit)
1) "subscribe"
2) "hello"
3) (integer) 1
1) "message"
2) "hello"
3) "world"
1) "message"
2) "hello"
3) "suibianme"
1) "message"
2) "hello"
3) "nihao"
```

在另一个终端中发布消息

```
127.0.0.1:6379> publish hello world
(integer) 1
127.0.0.1:6379> publish hello suibianme
(integer) 1
127.0.0.1:6379> publish hello nihao
(integer) 1
```

收听时也可以选择批量收听

```
subscribe hello*
```

### 高级使用

redis 也是有不同的库 (database) 的，默认是使用 0 号库，切换数据库是 `select [tablenum]`

删除当前库所有键值对是 `flushdb`, 删除所有库的所有数据 `flushall`

redis 还有一个神奇的特性是可以设置生存时间，默认生存时间为 -1 ，即无穷，在超过生存时间之后即会自动消失。

```
# coding=utf-8

import time
import redis

r = redis.Redis(db=1)

# 查看所有键
print r.keys('*')

# 情况当前数据库
r.flushdb()

print r.keys('*')

# 设置超时时间为 10 秒
r.set('name', 'windard', ex=15)

# 设置超时时间 5 秒
r.set('school', 'xidian')
r.expire('school', 5)

# 对某个键重命名
r.rename('school', 'university')

print r.keys("*")

# 查看某个键值对的类型或者值
r.type('name')

# 随机获得一个键名
print r.randomkey()

# 查看某个键的剩余超时时间
print r.ttl('university')

time.sleep(5)

# 查看某个键值对是否还存在
r.exists('university')

# 将某个键值对持久化
r.persist('name')

print r.exists('name')
print r.ttl('name')

# 将数据移到另一个数据库
r.move('name', 0)

print r.exists('name')
```

输出

```
['name']
[]
['university', 'name']
university
5
True
None
False
```

再来一些应用

```
# coding=utf-8

import redis

r = redis.Redis()

# 查看数据库信息
# for key, value in r.info().items():
    # print key, ":", value

# 查看数据库大小，即当前数据库的键值对数
print r.dbsize()

# 查看链接
print r.ping()

r.set('name', 'windard')

# 获得一个值的同时改变它
print r.getset('name', 'others')

print r.get('name')

# 关闭 redis 数据库
# r.shutdown()

r.delete('click')

# 设置一个键，让它每次自加一
r.incr('click')

print r.get('click')
r.incr('click')

print r.get('click')

# 还能自减一
r.decr('click')
print r.get('click')

```

输出

```
55
True
windard
others
1
2
1
```

### 分布式锁

在多线程或多进程中锁的应用十分常见，但是在不同服务或不同机器之间的资源锁定就需要分布式锁。

常见的分布式锁实现方式有 redis 和 ZooKeeper ，原理都是利用通用的服务组件，做到跨服务之间的资源锁定。

使用 redis 做分布式锁的核心命令是 `setnx` 表示 `set if not exits`， 当键值不存在是返回1，当键值存在是返回0.

通过对同一个键的赋值操作，即可抢占分布式资源，达到分布式锁的效果。当某一个服务率先设定kv，即表示抢占到资源，可以给资源设定过期时间，表明锁定时间，也可以在服务挂掉之后不会造成死锁，当服务完成之后即删除kv，之后的服务继续抢占分布式锁。

```
127.0.0.1:6379> setnx coo 1
(integer) 1
127.0.0.1:6379> setnx coo 1
(integer) 0
127.0.0.1:6379> get coo
"1"
127.0.0.1:6379> del coo
(integer) 1
127.0.0.1:6379> setnx coo 1
(integer) 1
```

