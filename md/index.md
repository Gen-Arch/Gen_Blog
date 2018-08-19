#前置き

自分がArchをインストールした際詰まった箇所を見直すためと
自分自身とても詰まったブート方式の違いについて（64bitUEFI・32bitUEFI・BIOS）
これからArchLinuxをインストールする方の力に少しでも力に慣れたらと思い記事を書かせていただきました。

本文はブート方式ごとの設定を記述しており、各項目ごとに64bitUEFI・32bitUEFI・BIOSの設定があります。
自分の環境にあったものを選択してください。

初投稿で文章力もないので読みづらい文書となっていますがご了承ください

ArchLinuxをインストールする際[Archの公式wiki](https://wiki.archlinuxjp.org/index.php/%E3%83%93%E3%82%AE%E3%83%8A%E3%83%BC%E3%82%BA%E3%82%AC%E3%82%A4%E3%83%89#.E6.9C.80.E6.96.B0.E3.81.AE.E3.82.A4.E3.83.B3.E3.82.B9.E3.83.88.E3.83.BC.E3.83.AB.E3.83.A1.E3.83.87.E3.82.A3.E3.82.A2.E3.82.92.E6.BA.96.E5.82.99.E3.81.99.E3.82.8B )のビギナーズガイドが優秀なのでこちらを見ながらの作業をおすすめします。






#インストールディスクの作成
インストールディスクはUSBで作るほうが色々便利なのでUSBでの作り方のみ記述します。
PCのブート方式によって作成手順が違うので自分のPCのブート方式をよく調べてから作業してください。

[USBインストールガイド](https://wiki.archlinuxjp.org/index.php/USB_%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%83%A1%E3%83%87%E3%82%A3%E3%82%A2 )
####64bitUEFI・BIOSブート
・[Arch Linux Downloads](https://www.archlinux.org/download/ "Arch Linux Downloads")からisoの入手
・ddコマンドか[Rufus](http://rufus.akeo.ie/)を使いisoファイルを書き込む

※/dev/sdx1 ではなく /dev/sdx を使い。x はあなたの使うデバイスに置き換える。

```ruby:ddコマンド
dd bs=4M if=/path/to/archlinux.iso of=/dev/sdx && sync
```



####32bitUEFIブート
・[Arch Linux Downloads](https://www.archlinux.org/download/ "Arch Linux Downloads")からisoの入手
・[Rufus](http://rufus.akeo.ie/)を使いisoファイルを書き込む　※USBラベルは「ARCHISO」に設定しておく
・[bootia32](https://github.com/jfwells/linux-asus-t100ta/blob/master/boot/bootia32.efi)をダウンロードする
・書き込んだUSBのEFIディレクトリを開き、ダウンロードしたbootia32を配置
・/boot/grub/grub.cfgを作成し以下を記述　※ディレクトリがない場合は作成

```ruby:grub.cfg
menuentry 'Arch Linux i686'{
echo 'Loading Linux core repo kernel ...'
linux /arch/boot/i686/vmlinuz noefi nomodeset archisobasedir=arch archisolabel=ARCHISO
echo 'Loading initial ramdisk ...'
initrd /arch/boot/i686/archiso.img
}
menuentry 'Arch Linux x86_64'{
echo 'Loading Linux core repo kernel ...'
linux /arch/boot/x86_64/vmlinuz noefi nomodeset archisobasedir=arch archisolabel=ARCHISO
echo 'Loading initial ramdisk ...'
initrd /arch/boot/x86_64/archiso.img
}
```

#インストール作業
USBの準備ができたらいよいよインストールに入ります。現在2015年10月29日に記事を作成していますが
年数が経つとインストール方法が変わったりする場合があるので[Archインストールガイド](https://wiki.archlinuxjp.org/index.php/%E3%83%93%E3%82%AE%E3%83%8A%E3%83%BC%E3%82%BA%E3%82%AC%E3%82%A4%E3%83%89)をよくみながら作業をしてください。

起動画面にてどちらのアーキテクチャか選択できるので、自分のPCにあったほうを選択してください。
Boot Arch Linux (x86_64)　
Boot Arch Linux (i386)　  ※32bitUEFIはこちらを選択

##キーボードレイアウトの設定
Archが立ち上がったらデフォルトのキーレイアウトがUSになっているので変更

```ruby:
loadkeys jp106
```

##インターネットの設定
無線

```ruby:
wifi-menu
```

有線
自動接続

※固定IPを設定する場合は下記参照
[ネットワーク設定](https://wiki.archlinuxjp.org/index.php/%E3%83%8D%E3%83%83%E3%83%88%E3%83%AF%E3%83%BC%E3%82%AF%E8%A8%AD%E5%AE%9A#.E5.9B.BA.E5.AE.9A_IP_.E3.82.A2.E3.83.89.E3.83.AC.E3.82.B9)

##システムクロックの更新
systemd-timesyncd を使ってシステムクロックを設定

```ruby:
timedatectl set-ntp true
```

```ruby:サービスの状態確認
timedatectl status
```


##パーティショニング
パーティニングにおいて必須なのは下記の二つ
・ルートディレクトリ / のパーティション。
・UEFI が有効になっている場合、EFI システムパーティション。
※詳細は[パーティショニング](https://wiki.archlinux.jp/index.php/%E3%83%91%E3%83%BC%E3%83%86%E3%82%A3%E3%82%B7%E3%83%A7%E3%83%8B%E3%83%B3%E3%82%B0)参照

今回の構成
/dev/sda1  ・・・  /boot　
/dev/sda2  ・・・ swap　　
/dev/sda3 ・・・ /root　　
/dev/sda4 ・・・ /home　　

※UEFIブートの場合、EFI System Partitionというものを作成しなければいけないのだが今回は/bootと統合して作成する

####現在のパーティション確認

```ruby:
fdisk -l
```

####起動モードの確認
UEFIブートで立ち上がっているか確認できます。

```ruby:
ls /sys/firmware/efi/efivars
```

※ディレクトリが存在しない場合、BIOS (または CSM) モードで起動しています。




####パーティション作成
partedの起動

```ruby:
parted /dev/sda
```


```ruby:BIOSブートの場合
(parted)mklabel msdos
(parted)mkpart primary ext4 1MiB 100MiB
(parted)mkpart primary linux-swap 100MiB  2GiB
(parted)mkpart primary ext4 2GiB 10GiB
(parted)mkpart primary ext4 10GiB 100% 
(parted)q
```

```ruby:UEFIブートの場合
(parted)mklabel gpt
(parted)mkpart ESP fat32 1MiB 513MiB
(parted)mkpart primary linux-swap 513MiB  2.5GiB
(parted)mkpart primary ext4 2.5GiB 10GiB
(parted)mkpart primary ext4 10GiB 100%
(parted)q 
```
※各パーティションのサイズは自分の環境に置き換えてください

作成後、パーティションを確認したい場合は下記コマンド実行

```ruby:
fdisk -l
```

##ファイルシステム作成
ファイルシステムとスワップ領域の作成を行う

```ruby:BIOSブートの場合
mkfs.ext4 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mkfs.ext4 /dev/sda3
mkfs.ext4 /dev/sda4
```

UEFIの場合bootディレクトリはfat32で作成する

```ruby:UEFIブートの場合
mkfs.vfat -F32 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mkfs.ext4 /dev/sda3
mkfs.ext4 /dev/sda4
```




##インストール

ベースシステムのインストールになります。
マウントしないとインストールができないので以下を実行

####マウント
```ruby:
mount /dev/sda3 /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/sda1 /mnt/boot
mount /dev/sda4 /mnt/home
```

####ミラーリスト選択

```ruby:
nano /etc/pacman.d/mirrorlist
```

```ruby:
##
## Arch Linux repository mirrorlist
## Sorted by mirror score from mirror status page
## Generated on YYYY-MM-DD
##
#japan
Server = http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch
...
```
・Ctrl+W で「japan」と入力しURLを検索
・Ctrl+K で Server 行を切り取り。
・PageUp キーで上にスクロール。
・Ctrl+U でリストの一番上にペースト。
・Ctrl+X で終了、保存するか聞かれたら、Y を押し Enter で上書き保存。


####ベースシステムインストール

```ruby:
pacstrap /mnt base base-devel
```

####fstab作成

```ruby:
genfstab -U /mnt >> /mnt/etc/fstab
```

##システムの設定
インストールが完了したらいよいよそのシステムに入ります。

```ruby:
arch-chroot /mnt /bin/bash
```

####ロケールの設定
locale.gen ファイルのコメントアウトを解除します

```rudy:
nano /etc/locale.gen
```

```rudy:locale.gen
...
#en_SG ISO-8859-1
en_US.UTF-8 UTF-8
#en_US ISO-8859-1
...
#ja_JP.EUC-JP EUC-JP
ja_JP.UTF-8 UTF-8
#ka_GE.UTF-8 UTF-8
...
```

解除後、以下を実行

```ruby:
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
```

####コンソールフォントとキーマップ

```ruby:
nano /etc/vconsole.conf
```

以下を追記

```ruby:console.conf
KEYMAP=jp106
FONT=lat9w-16
```

####タイムゾーンとハードウェアクロック
タイムゾーンの設定

```ruby:
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
```

ハードウェアクロックの設定

```ruby:
hwclock --systohc --utc
```

####ホスト名

```ruby:
echo ホスト名 > /etc/hostname
```

同じホスト名を /etc/hosts に追加

```ruby:
nano /etc/hosts
```

```ruby:hosts
#<ip-address> <hostname.domain.org> <hostname>
127.0.0.1 localhost.localdomain localhost ホスト名
::1   localhost.localdomain localhost ホスト名
```


####ネットワークとパスワード
今回ネットワークの設定は有線の動的IPにします。
固定IPの場合は[ネットワーク設定](https://wiki.archlinuxjp.org/index.php/%E3%83%8D%E3%83%83%E3%83%88%E3%83%AF%E3%83%BC%E3%82%AF%E8%A8%AD%E5%AE%9A#.E5.9B.BA.E5.AE.9A_IP_.E3.82.A2.E3.83.89.E3.83.AC.E3.82.B9)を参照

ネットワークの設定

```ruby:
systemctl enable dhcpcd
```

パスワードの設定

```ruby:
passwd
```

##GRUBのインストール

GRUBはそれぞれのブート方式で違うので順番に書いていきます

####BIOSブート

```ruby:
pacman -S os-prober grub
grub-install --target=i386-pc --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
```

####32bitUEFIブート

```ruby:
pacman -S grub dosfstools efibootmgr
grub-install --target=i386-efi --efi-directory=/boot --bootloader-id=grub --recheck
mkdir /boot/EFI/boot
cp /boot/EFI/grub/grubia32.efi /boot/EFI/boot/bootia32.efi
grub-mkconfig -o /boot/grub/grub.cfg
```


####64bitUEFIブート

```ruby:
pacman -S grub dosfstools efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub --recheck
mkdir /boot/EFI/boot
cp /boot/EFI/grub/grubx64.efi  /boot/EFI/boot/bootx64.efi
grub-mkconfig -o /boot/grub/grub.cfg
```

GRUBのインストールが無事終わったらシステムから出て再起動

```ruby:
exit
umount -R /mnt
reboot
```

無事起動したら成功です。
お疲れ様でした！！


##追記

もしこれでインストールできないとき、ArchのブートUSBを使ってシステムに入る方法を記述しておきます。
この方法は結構色んなトラブルで使うのでもし起動できなくなってシステムをに入れなくなったらやってみてください

Archiso起動後以下コマンド実行

```ruby:
mount /dev/sda3 /mnt
mount /dev/sda1 /mnt/boot
mount /dev/sda4 /mnt/home
arch-chroot /mnt /bin/bash
```

※マウントはパーティションを分けてる場合全部やってください
