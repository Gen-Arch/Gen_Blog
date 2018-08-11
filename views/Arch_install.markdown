# Ruby Array
---
配列の代入方法を備忘録として記述

#### 特定の値の抽出

```
a = ["aaa", "bbb", "ccc"]
ary1 = a.select { |t| t =~ /aaa/ }
ary2 = a - ary1
```

よくなった

```
a = ["aaa", "bbb", "ccc"]
ary1,ary2 = a.partition { |t| t =~ /aaa/ }
```

よき
