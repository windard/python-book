## pdb

打断点神器，再也不用依靠 pycharm 来打断点了。

标准用法

```python
import pdb
pdb.set_trace()
```

或者简化到一行

```python
import pdb;pdb.set_trace()
```

然后再次运行，就会停在当前位置，可以查看当前位置的变量，环境和堆栈等相关信息。
> 还可以使用 `python -m pdb file.py` 使用 pdb 调试代码，默认停在第一行

pdb 中的命令

0. `help [command]` 显示相关语句帮助
1. `n`|`next` 下一步，不进入函数内部
7. `j`|`jump [lineno]` 跳转至某一行
2. `c`|`continue` 继续运行,没有断点则退出 pdb 调试
3. `q`|`exit`|`quit` 报错退出
4. `l`|`list` 列出上下文相关代码
5. `w`|`where` 显示堆栈信息
6. `b`|`break [lineno]` 打断点
8. `cl`|`clear` 清除所有断点
9. `a`|`args` 当前环境变量
10. `r`|`return` 退出当前函数
11. `whatis [arg]` 查看变量类型
12. `s`|`step` 下一步，进入函数内部

在 pdb 中可以设置变量，可以修改变量，可以侵入代码。
> 注意 `a,b,c` 都被占用了，不要再给 `a,b,c` 赋值了
