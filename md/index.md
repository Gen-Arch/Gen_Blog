# Ruby Array
配列の代入方法を備忘録として記述

#### 特定の値の抽出
```Ruby:通常
a = ["aaa", "bbb", "ccc"]

ary1 = []
ary2 = []
a.each do |t|
  case s
  when /aaa/
      ary1 << t
  else
      ary2 << t
  end
end
```
```:結果
ary1 #=> aaa
ary2 #=> bbb, ccc
```
長い・・・

```Ruby:select
a = ["aaa", "bbb", "ccc"]
ary1 = a.select { |t| t =~ /aaa/ }
ary2 = a - ary1
```
よくなった

```Ruby:partition
a = ["aaa", "bbb", "ccc"]
ary1,ary2 = a.partition { |t| t =~ /aaa/ }

```
よき
