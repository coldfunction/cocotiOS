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
$ nasm -I ../include/ -o mbr.bin mbr.S
```
```
$ nasm -I ../include/ -o loader.bin loader.S
```
```
$ dd if=./mbr.bin of=../img/cocotiOS.img bs=512 count=1 conv=notrunc
```
```
$ dd if=./loader.bin of=../img/cocotiOS.img bs=512 count=1 seek=1 conv=notrunc
```

```
$ cd ../img/
```
```
$ qemu-system-x86_64 cocotiOS.img
```

# Current results

![](https://i.imgur.com/vUXCwZU.png)

# Reference

1. [mikeos: write your own os](http://mikeos.sourceforge.net/write-your-own-os.html#gofurther)
2. [wiki: int 10h](https://www.wikiwand.com/en/INT_10H)
3. [x86 Assembly/Control Flow](https://en.wikibooks.org/wiki/X86_Assembly/Control_Flow)
4. [Writing a boot loader in Assembly and C](https://www.codeproject.com/Articles/664165/Writing-a-boot-loader-in-Assembly-and-C-Part)
