# CDNet
一个网络交互类库

# 介绍
1.WFRequest
基于NSURLConnection的封装，自定义了基于接口的缓存处理，类型如下：
```Objc
typedef enum : NSUInteger {
    WFRequestCacheTypeNone,//不缓存
    WFRequestCacheTypeOffLineShow,//离线时展示缓存
    WFRequestCachePriorShow,//优先展示缓存
} WFRequestCacheType_t;
```
返回结果添加了类型过滤，过滤掉内容为：nil、(null)、<null>、[NSNull null]以及空字符；有效避免因类型不匹配导致的崩溃问题。

2.CDDApi组
设计了一套网络交互层封装，实现网络交互状态的跟踪；
添加了异常处理模块

# 代码示例
1.发起一个网络请求
```objc
[CDDApiManager shareManager].SYS_ROOT = @"https://www.haomaishou.com/";

NSString *name = numTex.text;
NSString *pwd = passTex.text;
    
NSMutableDictionary *para = [[NSMutableDictionary alloc]init];
[para setObject:name forKey:@"username"];
[para setObject:pwd forKey:@"password"];
[para setObject:@"signin" forKey:@"act"];
    
@WeakObj(self);
[[CDDApiManager shareManager]signin:para callback:^(NSDictionary *info) {
    [selfp dealLogin:info];
}];
```
2.添加异常处理
```objc
CDDApiExceptionHandler *sessionDisableHandler = [[CDDApiExceptionHandler alloc]initWithId:@"99" target:self Selector:@selector(gotoLogin:) Object:nil];
    [[CDDApiManager shareManager]addExceptionHandler:sessionDisableHandler];
```

不尽之处，请联系我。