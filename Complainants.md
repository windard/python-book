# Gitbook

虽然我也和想用 Gitbook 官网，但是官网上也不能改主体，也不能改头像，👤还要收费。太过分了，不行就用 GitHub Pages

没得选，用 Gitbook + GitHub Page 吧，算了，累了。Gitbook 官网默认的主题太丑了。

而且 Gitbook 还强行给我改文件结构，垃圾，🌶🐔 没人用就算了，不要放弃吖。

## Plugins

受不了了，安装插件好慢吖。Gitbook 故意的么？已安装的插件还要再安装一遍。

> 可以通过 `npm install gitbook-plugin-tbfed-pagefooter` 的方式单独安装插件，使用 `gitbook install` 会安装全部插件

### highlight

自带的插件，代码高亮

### lunr
自带的插件，搜索引擎

### search

自带的插件，导航栏查询，不能识别中文

### sharing

自带的插件，右上角分享功能

### font-settings

自带的插件，左上角的字体设置，"A" 键

### livereload

自带的插件，文件改动自动加载

### theme-default

自带的插件，默认主题，可以配置展示层次编号


```json
{
    "plugins": [
        "theme-default"
    ],
    "pluginsConfig": {
        "theme-default": {
            "showLevel": true
        }
    }
}
```

### search-pro

高级搜索，支持中文

```json
{
    "plugins": [
        "-lunr", 
        "-search",
        "search-pro"
    ]
}
```

### search-plus
增强版的 search ，支持中文，感觉不出来和上面的区别👆，但是上面那个似乎用的人更多

```json
{
    "plugins": ["-lunr", "-search", "search-plus"]
}
```

### ga

Google 统计
> 如果报错 `GitBook doesn't satisfy the requirements of this plugin: >=4.0.0-alpha.0.`，试下使用 `ga@1.0.1`

```json
{
    "plugins": [
        "ga"
     ],
    "pluginsConfig": {
        "ga": {
            "token": "UA-XXXX-Y"
        }
    }
}
```

### baidu

百度统计


```json
{
    "plugin": ["baidu"],
    "pluginsConfig": {
        "baidu": {
            "token": "YOUR TOKEN"
        }
    }
}
```
### sharing-plus
增强版的分享按钮，支持一些中国的社交网站，比如豆瓣，微信，微博等

![](https://i.niupic.com/images/2020/09/23/8Ios.png)

```json
{
    "plugins": [
        "-sharing",
        "sharing-plus"
    ],
    "pluginsConfig": {
        "sharing": {
            "douban": false,
            "facebook": false,
            "google": true,
            "pocket": false,
            "qq": false,
            "qzone": true,
            "twitter": false,
            "weibo": true,
            "all": [
                "douban",
                "facebook",
                "google",
                "instapaper",
                "linkedin",
                "twitter",
                "weibo",
                "messenger",
                "qq",
                "qzone",
                "viber",
                "whatsapp"
            ]
        }
    }
}
```

### sitemap

生成 sitemap, 访问 `/sitemap.xml` 即可查看

```json
{
    "plugins": [
        "sitemap"
    ],
    "sitemap": {
        "hostname": "https://python-book.windard.com/"
    }
}
```

### hide-element

可以隐藏不不想看到的元素
> 比如默认的 gitbook 左侧提示：`Published with GitBook`

![](https://i.niupic.com/images/2020/09/23/8IgR.png)

```json
{
    "plugins": [
        "hide-element"
    ],
    "pluginsConfig": {
        "hide-element": {
            "elements": [".gitbook-link"]
        }
    }
}
```

### back-to-top-button

回到顶部

![](https://i.niupic.com/images/2020/09/23/8IgS.png)

```json
{
    "plugins": [
         "back-to-top-button"
    ]
}
```

### donate
赞赏👍

![](https://i.niupic.com/images/2020/09/23/8Ilr.png)

```json
{
    "plugins": [
         "back-to-top-button"
    ],
    "pluginsConfig": {
        "donate": {
            "wechat": "https://xxx.jpg",
            "alipay": "https://xxx.jpg",
            "title": "写的不错~ 👍",
            "button": "打赏",
            "alipayText": "支付宝打赏",
            "wechatText": "微信打赏"
        }
    }
}
```

### github

展示一个 GitHub 头像在右上角
> 如果报错 `GitBook doesn't satisfy the requirements of this plugin: >=4.0.0-alpha.0.`，试下使用 `github@2.0.0`

![](https://i.niupic.com/images/2020/09/23/8IkT.png)

```json
{
    "plugins": [ "github" ],
    "pluginsConfig": {
        "github": {
            "url": "https://github.com/your/repo"
        }
    }
}
```

### github-buttons

右上角展示 GitHub 标签, 可以指定 GitHub 仓库和标签类型，详见 [GitHub:buttons](https://buttons.github.io/)

![](https://i.niupic.com/images/2020/09/24/8Iue.png)

```json
{
  "plugins": [
    "github-buttons"
  ],
  "pluginsConfig": {
    "github-buttons": {
      "buttons": [{
        "user": "windard",
        "repo": "python-book",
        "type": "star",
        "size": "small"
      }, {
        "user": "windard",
        "type": "follow",
        "width": "160",
        "count": true,
        "size": "small"
      }]
    }
  }
}
```

### disqus
使用 disqus 的评论体系,填入在 disqus 的站点名称即可。
> 如果报错 `GitBook doesn't satisfy the requirements of this plugin: >=4.0.0-alpha.0.`，试下使用 `disqus@0.1.0`

```json
{
    "plugins": ["disqus"],
    "pluginsConfig": {
        "disqus": {
            "shortName": "XXXXXXX"
        }
    }
}
```

### edit-link

在文章左上角展示一个 `Edit on GitHub` 的标签

![](https://i.niupic.com/images/2020/09/23/8IkV.png)

```json
{
    "plugins": [ "edit-link" ],
    "pluginsConfig": {
        "edit-link": {
            "base": "https://github.com/itswl/gitbook/edit/master",
            "label": "Edit This Page"
        }
    }
}
```

### chapter-fold

默认导航栏是没有折贴的，一级标题和二级标题都默认展开，这个插件可以折叠导航栏

![](https://i.niupic.com/images/2020/09/23/8IoD.png)

```json
{
    "plugins": ["chapter-fold"]
}
```

### expandable-chapters-small

上面 👆 的导航栏折叠据说有问题，用这个插件组合使用可以修复，但是实际使用起来好像没啥问题。😂

```json
{
    "plugins": [
         "expandable-chapters-small"
    ]
}
```

### expandable-chapters

和上面 👆 的插件功能一样，点击箭头才能收缩，但是箭头比上面那个大

### code

为代码模块增加复制按钮，为代码块增加行号

![](https://i.niupic.com/images/2020/09/24/8IzP.png)

```json
{
    "plugins" : ["code" ]
}
```

### copy-code-button

同样的复制按钮，但是傻大黑粗不好看

![](https://i.niupic.com/images/2020/09/23/8IkS.png)

```json
{
    "plugins" : [ "copy-code-button" ]
}
```

### splitter

左侧导航栏宽度动态可拖动

![](https://i.niupic.com/images/2020/09/23/8IoG.png)

```json
{
    "plugins": [
        "splitter"
    ]
}
```

### pageview-count

页面阅读量计数器

![](https://i.niupic.com/images/2020/09/23/8Iop.png)

```json
{
  "plugins": ["pageview-count"]
}
```

### tbfed-pagefooter

展示页面最后更新时间

![](https://i.niupic.com/images/2020/09/23/8Ilu.png)

```json
{
    "plugins": [
        "tbfed-pagefooter"
    ],
    "pluginsConfig": {
        "tbfed-pagefooter": {
            "copyright": "Copyright &copy 2020",
            "modify_label": "该文件最后修改时间：",
            "modify_format": "YYYY-MM-DD HH:mm:ss"
        }
    }
}
```

### image-captions

抓取图片的 `alt` 或者 `title` 字段并展示在图片下，但是展示效果并不太好

```json
{
  "plugins": ["image-captions"]
}
```

### anchors

对文章标题都生成锚点，展示效果类似于 GitHub

```json
{
  "plugins": ["anchors"]
}
```

### popup

点击会在新标签页打开图片链接，其实这样并不太好，最好是在当前页面放大图片即可。

```json
{
  "plugins": [ "popup" ]
}
```

### lightbox

能够在页面上弹框展示图片，就是浮层出现的有点慢

```json
{
  "plugins": [ "popup" ]
}
```

### custom-favicon

更改页面 icon ，设置自定义 icon
> 会有 `TypeError [ERR_INVALID_ARG_TYPE]: The "path" argument must be of type string. Received undefined` 异常，无法修复
> 算了，就默认 icon 吧，也不是不能用
>

```json
{
    "plugins" : ["custom-favicon"],
    "pluginsConfig" : {
        "favicon": "path/to/favicon.ico"
    }
}
```

类似的还有 , 所以都有同样的问题
- [favicon-custom](https://www.npmjs.com/package/gitbook-plugin-favicon-custom)
- [custom-favicon-new](https://www.npmjs.com/package/gitbook-plugin-custom-favicon-new)
- [custom-favicon-fix](https://www.npmjs.com/package/gitbook-plugin-custom-favicon-fix)
- [custom-favicon-pro](https://www.npmjs.com/package/gitbook-plugin-custom-favicon-pro)

### favicon

和上面👆的类似，不过没有异常了，但是不能用，页面出现了两个 icon，最终显示的还是默认的 Gitbook icon

```json
{
    "plugins": ["favicon"],
    "pluginsConfig": {
        "favicon":{
            "shortcut": "assets/images/favicon.ico",
            "bookmark": "assets/images/favicon.ico",
            "appleTouch": "assets/images/apple-touch-icon.png",
            "appleTouchMore": {
                "120x120": "assets/images/apple-touch-icon-120x120.png",
                "180x180": "assets/images/apple-touch-icon-180x180.png",
            }
        }
    }
}
```

### toc
支持目录展示，在需要的地方插入目录 

![](https://i.niupic.com/images/2020/09/24/8IzQ.png)
> 在这里我没有办法把上面👆那行代码写出来贴这里，😂，因为它会被识别成要插入目录

![](https://i.niupic.com/images/2020/09/24/8Iv5.png)

```json
{
  "plugins": [ "toc" ]
}
```

### atoc

使用和配置都与上面👆的一致。但是在我这里使用时有问题，导致页面展示异常

```json
{
  "plugins": [ "atoc" ]
}
```

### page-toc

展示目录，通过另一种方式配置和展示，在文章头部配置，然后在文章右边就会出现目录，不会跟随滚动。

```text
---
showToc: true
---
```

![](https://i.niupic.com/images/2020/09/24/8Iv7.png)

```json
{
  "plugins": [ "page-toc" ]
}
```

