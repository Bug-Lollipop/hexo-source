---
title: UTC 时区 转 本地时区
date: 2017-12-15 18:47:58
tags:
---
今天在做账单详情的时候，需要将 `2017-12-05` 这样的日期转化为时间戳，发现转完的时间戳是 2017-12-05 08:00:00，与实际的时间差了八个小时。而`2017-12-5` 这样的日期转化的时间戳就是对的。 研究了发现问题所在：

在ES5之中，如果日期采用连词线（-）格式分隔，且具有前导0，JavaScript会认为这是一个ISO格式的日期字符串，导致返回的时间是以`UTC`时区计算的:
```
new Date('2017-11-05')
Sun Nov 05 2017 08:00:00 GMT+0800 (CST)
new Date('2017-11-5')
Sun Nov 05 2017 00:00:00 GMT+0800 (CST)
```
上面代码中，日期字符串有没有前导 0，返回的结果是不一样的。如果没有前导 0，JavaScript 引擎假设用户处于本地时区，所以本例返回 0 点 0 分。如果有前导 0（即如果你以 ISO格式表示日期），就假设用户处于格林尼治国际标准时的时区，所以返回 8 点 0 分。但是，ES6 改变了这种做法，规定凡是没有指定时区的日期字符串，一律认定用户处于本地时区。
因此此时要想拿到准确的时间戳，就需要`getTimezoneOffset() ` 方法，返回格林威治时间和本地时间之间的时差,以分钟为单位（为负值）。最后再加上该时间差，就是 UTC 时区的时间
```
const time = '2017-11-05'
const offsetTime = new Date().getTimezoneOffset() * 60 * 1000
const localDate = new Date(time).getTime() 
const UTCDate = new Date(localDate + offset) 
const resultTime = new Date(UTCDate).getTime() 
```
