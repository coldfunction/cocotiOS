# cocotiOS
A simple OS implementation for x86_64


# Prerequisites
* QEMU simulator or bochs
* I only know QEMU...
* nasm compiler
* dd tool


# How to compile
```
$ cd boot
```
```
$ nasm -o mbr.bin mbr.S
```
```
$ dd if=./mbr.bin of=../img/cocotiOS.img bs=512 count=1 conv=notrunc
```
```
$ cd ../img/
```
```
$ qemu-system-x86_64 cocotiOS.img
```

# Current results

![](https://i.imgur.com/B3Ra9U8.png)

