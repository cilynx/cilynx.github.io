---
layout: post
title:  "Building Candyhouse SSAs"
tags: cisco linksys e4200v2 candyhouse router firmware reverse_engineering perl binwalk
redirect_from: 
    - "/projects/candyhouse/ssa/"
    - "/projects/candyhouse/firmware/"
---
## Tools

These "perl" scripts are pretty much bastardized shell scripts based on [`binwalk`](http://code.google.com/p/binwalk/) and inspired by [Neubsi's SSA->JFFS->SSA utility scripts](http://www.neubsi.at/blog/). They could use a whole lot of touching up, but they do the job.

* [E4200v2 Firmware Assembler](/assets/candyhouse-ssa-assemble.pl) - Assemble a kernel and filesystem into an SSA.
* [E4200v2 Firmware Extractor](/assets/candyhouse-ssa-extract.pl) - Extract the kernel and filesystem from an SSA.
* [Perl wrapper for binwalk](/assets/candyhouse-ssa-binwalk.pm)

Here's what they look like in practice:

```
rcw@initiative:~/Projects/E4200v2/firmware$ ls
assemble.pl  Binwalk.pm  extract.pl  images
rcw@initiative:~/Projects/E4200v2/firmware$ ./extract.pl images/FW_E4200_2.1.39.145204.SSA 
Image images/FW_E4200_2.1.39.145204.SSA is 19925875 bytes ...
Binwalking images/FW_E4200_2.1.39.145204.SSA ...
JFFS2 offset is 2752512 ...
Reading images/FW_E4200_2.1.39.145204.SSA ...
Writing 2752512 bytes to FW_E4200_2.1.39.145204.kernel ...
Writing 17173363 bytes to FW_E4200_2.1.39.145204.jffs2 ...
Mounting FW_E4200_2.1.39.145204.jffs2 ...
Copying JFFS2 filesystem so we can unmount it ...
Unmounting FW_E4200_2.1.39.145204.jffs2 ...
Cleaning up ...
rcw@initiative:~/Projects/E4200v2/firmware$ du -hs *
4.0K    assemble.pl
4.0K    Binwalk.pm
4.0K    extract.pl
38M     FW_E4200_2.1.39.145204.jffs2
2.7M    FW_E4200_2.1.39.145204.kernel
117M    images
rcw@initiative:~/Projects/E4200v2/firmware$ ./assemble.pl
Using JFFS2: FW_E4200_2.1.39.145204.jffs2
Using kernel: ../build/publication/src/linux/extracted/linux-2.6.35.9/arch/arm/boot/uImage
Copying ../build/publication/src/linux/extracted/linux-2.6.35.9/arch/arm/boot/uImage to ./FW_E4200_2.1.39.145204.kernel ...
FW_E4200_2.1.39.145204.kernel is 2769772 bytes ...
Next boundry at 2883584 bytes ...
Padding FW_E4200_2.1.39.145204.kernel by 113812 bytes ...
Adding build date (20130623222909) to FW_E4200_2.1.39.145204.jffs2/etc/builddate ...
Adding build tag (wolfteck-20130623222909) to FW_E4200_2.1.39.145204.jffs2/etc/version ...
Squashing JFFS2 filesystem to FW_E4200_2.1.39.145204.jffs2.tmp ...
Concatinating FW_E4200_2.1.39.145204.kernel and FW_E4200_2.1.39.145204.jffs2.tmp to FW_E4200_2.1.39.145204-wolfteck-20130623222909.ssa ...
Removing FW_E4200_2.1.39.145204.jffs2.tmp ...
rcw@initiative:~/Projects/E4200v2/firmware$ du -hs *
4.0K    assemble.pl
4.0K    Binwalk.pm
4.0K    extract.pl
43M     FW_E4200_2.1.39.145204.jffs2
2.8M    FW_E4200_2.1.39.145204.kernel
22M     FW_E4200_2.1.39.145204-wolfteck-20130623222909.ssa
117M    images
rcw@initiative:~/Projects/E4200v2/firmware$
```

## Theory

Hat tip to Hugh Dachbach for generously explaining what he remembered of the stock burn and boot processes -- thank you for getting me over several hurdles.

### MTD Partitions

The E4200v2 has no less than seven NAND flash partitions:

```
~ # cat /proc/mtd 
dev:    size   erasesize  name
mtd0: 00080000 00020000 "uboot"
mtd1: 00020000 00020000 "u_env"
mtd2: 00020000 00020000 "s_env"
mtd3: 01a00000 00020000 "kernel"
mtd4: 01720000 00020000 "rootfs"
mtd5: 01a00000 00020000 "alt_kernel"
mtd6: 01760000 00020000 "alt_rootfs"
mtd7: 04a00000 00020000 "syscfg"
~ #
```

They range from 128K for `u_env` to a whopping 74M for `syscfg`:

```
~ # for x in 0 1 2 3 4 5 6 7 ; do echo /dev/mtd$x ; echo ; mtd_debug info /dev/mtd$x ; 
done
/dev/mtd0

mtd.type = MTD_NANDFLASH
mtd.flags = MTD_CAP_ROM
mtd.size = 524288 (512K)
mtd.erasesize = 131072 (128K)
mtd.writesize = 2048 (2K)
mtd.oobsize = 64 
regions = 0

/dev/mtd1

mtd.type = MTD_NANDFLASH
mtd.flags = MTD_CAP_NANDFLASH
mtd.size = 131072 (128K)
mtd.erasesize = 131072 (128K)
mtd.writesize = 2048 (2K)
mtd.oobsize = 64 
regions = 0

/dev/mtd2

mtd.type = MTD_NANDFLASH
mtd.flags = MTD_CAP_NANDFLASH
mtd.size = 131072 (128K)
mtd.erasesize = 131072 (128K)
mtd.writesize = 2048 (2K)
mtd.oobsize = 64 
regions = 0

/dev/mtd3

mtd.type = MTD_NANDFLASH
mtd.flags = MTD_CAP_NANDFLASH
mtd.size = 27262976 (26M)
mtd.erasesize = 131072 (128K)
mtd.writesize = 2048 (2K)
mtd.oobsize = 64 
regions = 0

/dev/mtd4

mtd.type = MTD_NANDFLASH
mtd.flags = MTD_CAP_NANDFLASH
mtd.size = 24248320 (23M)
mtd.erasesize = 131072 (128K)
mtd.writesize = 2048 (2K)
mtd.oobsize = 64 
regions = 0

/dev/mtd5

mtd.type = MTD_NANDFLASH
mtd.flags = MTD_CAP_NANDFLASH
mtd.size = 27262976 (26M)
mtd.erasesize = 131072 (128K)
mtd.writesize = 2048 (2K)
mtd.oobsize = 64 
regions = 0

/dev/mtd6

mtd.type = MTD_NANDFLASH
mtd.flags = MTD_CAP_NANDFLASH
mtd.size = 24510464 (23M)
mtd.erasesize = 131072 (128K)
mtd.writesize = 2048 (2K)
mtd.oobsize = 64 
regions = 0
/dev/mtd7

mtd.type = MTD_NANDFLASH
mtd.flags = MTD_CAP_NANDFLASH
mtd.size = 77594624 (74M)
mtd.erasesize = 131072 (128K)
mtd.writesize = 2048 (2K)
mtd.oobsize = 64 
regions = 0

~ #  
```

### Boot Process

The E4200v2 can boot from either `kernel` using `rootfs` for the file system or from `alt_kernel` using `alt_rootfs` for the file system. This was designed to make it easy to rollback if a firmware update fails. The early boot process keeps track of failed boots and after 4 or 5, it'll switch which partitions it tries to load. Yes, that means you can unbrick the device by just power cycling it a handful of times.

### Burning to Flash

Unlike many devices which split the firmware file into kernel and rootfs images to burn individually to their respective partitions, the E4200v2 burns the entire image to the kernel partition, which happens to overlap with the rootfs partition. The big takeaways are that the entire images is burned to the kernel portion of the partition pair and the JFFS2 filesystem embedded in the image must start on a boundary that is a multiple of the MTD erase block size.

From `linux-2.6.35.8-lgmrvl_041-support-for-single-image-updates.patch` in the build tree:

```
From: Hugh Daschbach 
Date: Mon, 9 May 2011 17:22:46 -0700
Subject: [PATCH] Kernel support for single image updates.

This patch allows MTD partitioning routine to dynamically find the start of the root filesystem.

The underlying implementations still requires two partitions: one for the kernel and one for the root filesystem.  But the expectation is that during boot both filesystems will share the same offset and size.  The root filesystem partitions is expected to be marked with a new attribute: "fs".

During boot, any partition marked "fs" will be scanned looking for the start of a JFFS2 filesystem.  The starting location of the partition will be adjusted to point to the beginning of the filesystem.  

So, for example, the following mtdparts definition:

mtdparts=nand_mtd:640k(uboot)ro,128k@640k(u_env),128k@768k(s_env),\
23m@1m(kernel),23m@1m(rootfs)fs,\
23m@24m(alt_kernel),23m@24m(alt_rootfs)fs,\
23m@47m(downloads),42m@70m(syscfg)

defines two pairs of overlapping partitions: the primary and alternate boot partitions.  Both pairs are 23 MB is size.  Since the rootfs entries in the pairs terminate with the string "fs", the starting offset of these partitions will be adjusted, skipping past the kernel.  It is expected that firmware updates will write a single image of both a kernel and root filesystem image.  This image be written to the "kernel" partition of the pair.  And it is assumed that the JFFS2 filesystem embedded in the image will start a boundary that is an multiple of the MTD erase block size.
```

Once we know that, it's pretty easy to calculate the padding needed to make everything work:
(from [E4200v2 Firmware Assembler](/assets/candyhouse-ssa-assemble.pl))

```
my $size = -s $kernel;
print "$k is $size bytes ...\n";

my $nextBlock = (int($size/$eraseBlockSize)+1)*$eraseBlockSize;
print "Next boundry at $nextBlock bytes ...\n";

my $pad = $nextBlock-$size;
print "Padding $kernel by $pad bytes ...\n";
```

Yeah, this implementation will waste `$eraseBlockSize` bytes on a useless pad if `$kernel` happens to land perfectly on a boundary instead of just leaving the boundary as-was, but I'm lazy and it will likely never happen anyway.
