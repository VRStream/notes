### Hacks for Victor Reader Stream (VRStream)

Note: These hacks require a Linux machine. A Debian/Ubuntu box works well.

The required software packages can be installed on a Ubuntu box with the
following command,

```
sudo apt-get install gparted docker.io netcat-openbsd
```


#### Cloning the internal storage

Here are the steps to clone the internal MicroSD card to a new, bigger MicroSD
card for Victor Reader Stream (New Generation).

Note: Read and understand the steps carefully before executing them.

1. Connect the internal MicroSD card to a Linux box, and create a disk image of
   the internal MicroSD card.

   ```
   sudo dd if=/dev/sdb of=disk_image.raw
   ```

   Note: The "/dev/sdb" part may change on your system, use "dmesg | tail"
   command to find your device identifier. Use the correct device
   identifier here, and in the following steps as well.

2. Remove the original internal MicroSD card, and connect the new, bigger
   MicroSD card. Restore the disk image to the new MicroSD card.

   ```
   sudo dd if=disk_image.raw of=/dev/sdb
   ```

3. Use GParted to resize /dev/sdb4 partition to maximum size (minus 1 MB at the
   end) first. Once this is done, resize /dev/sdb7 partition to the maximum
   size (minus 1 MB at the end).

4. Safely eject your newly cloned MicroSD card and plug it into Victor Reader
   Stream.

5. Enjoy the increased internal free space ;)


#### Getting a shell on VRStream

ATTENTION: Do not connect VRStream to insecure/public/non-private WiFi networks
while using this hack.

0. Gain physical access to the *internal* MicroSD card. Rough steps to do this
   are listed below,

   - Remove the battery.

   - Remove a thick flat rectangular sticker from the battery compartment. A
     flat screwdriver or a finger nail inserted beneath the thick sticker can
     help in doing so. Some use of force may be required here.

     Note: This sticker covers the top half portion of the battery compartment.

   - The MicroSD card is under a little metal slider door (slightly smaller than the
     card itself) that slides up (up being the top of the player) and pops up.

1. Attach the internal MicroSD card to the Linux machine, and execute the
   following commands (after understanding them):

   ```
   $ mkdir mnt  # execute one time

   $ sudo mount /dev/sdb3 mnt  # device numbering might be different for you

   $ sudo rm -rf mnt/usr/local/share/fr  # make some space, assumes you don't need french ;)

   $ sudo mv ./mnt/usr/share/udhcpc/default.script ./mnt/usr/share/udhcpc/default.script.bak

   $ sudo cp default.script ./mnt/usr/share/udhcpc/default.script

   $ sync

   $ sudo umount mnt
   ```

2. Insert the internal MicroSD card back into the device.

3. Attach the *external* SD card to the Linux machine. Copy `nc` (see build
   steps below to generate your own) and `script.sh` files to root of
   the SD card.

4. Insert the external SD card back into the device.

5. Boot the device and let it connect to the WiFi.

6. Find the IP address of the device.

7. Use `netcat` on your Linux machine to connect the device. Example:

   ```
   $ nc 192.168.1.7 4444
   ```

   Note: The `telnet` command will not work - use netcat.


#### Building your own netcat binary

1. Get Ubuntu 14.04 container running in Docker.

   ```
   $ docker run -it ubuntu:trusty bash
   ```

2. Install an ARM cross-compiler inside the Docker container.

   ```
   # apt-get update

   # apt-get install gcc-arm-linux-gnueabi
   ```

3. Fetch and extract the netcat tarball inside the container.

4. Compile netcat using the following command inside the container.

   ```
   # arm-linux-gnueabi-gcc -DGAPING_SECURITY_HOLE -DLINUX -static -o nc netcat.c
   ```

5. The netcat binary's file name is `nc`.

6. Note: This toolchain is not 100% compatible with VRStream. It works for
   simpler things only.


#### Building compiler toolchain for VRStream

1. Get Ubuntu 14.04 container running in Docker.

   ```
   $ docker run -it ubuntu:trusty bash
   ```

2. Build `crosstool-NG` (included in repository) based toolchain inside the
   container.

   ```
   # apt-get update

   $ sudo apt-get install libexpat1-dev python-dev gawk curl cvs subversion gcj-jdk \
       automake libtool bison flex texinfo build-essential libncurses5-dev

   # cd ~

   # tar -xjf crosstool-ng-1.9.3.tar.bz2

   # cat ../crosstool-ng-1.9.3-trusty-tahr-build.patch | patch -p1
   patching file scripts/build/binutils/binutils.sh
   patching file scripts/build/debug/200-duma.sh
   patching file scripts/build/debug/300-gdb.sh
   patching file scripts/build/debug/500-strace.sh
   patching file scripts/build/kernel/linux.sh

   $ ./configure --local  # toolchain will be installed at ~/x-tools/arm-davinci-linux-gnueabi/bin/

   $ make

   $ make install

   $ ./ct-ng list-samples

   $ ./ct-ng arm-davinci-linux-gnueabi

   $ ./ct-ng menuconfig  # select gcc 4.3.3, and mpfr 3.0.0 (this is required and is not optional)

   $ ./ct-ng build

   ```

3. Save this Docker container with `docker commit` command.


#### Build OpenSSL using crosstool-NG based toolchain


1. Fetch OpenSSL tarball inside the container.

   ```
   $ cd ~

   $ wget https://www.openssl.org/source/openssl-1.0.2q.tar.gz
   ```

2. Build OpenSSL inside the container with crosstool-NG based toolchain.

   ```
   $ tar -xzf openssl-1.0.2q.tar.gz

   $ cd openssl-1.0.2q

   $ export PATH=~/x-tools/arm-davinci-linux-gnueabi/bin:$PATH

   $ ./Configure linux-generic32 shared --cross-compile-prefix=arm-davinci-linux-gnueabi- \
       -march=armv5te -mabi=aapcs-linux -msoft-float

   $ make
   ```


#### Test compiled binaries using QEMU

1. Install QEMU stuff inside the Ubuntu 14.04 Docker container.

   ```
   # apt-get install qemu-user -y
   ```

2. Copy the required libraries and binaries from VRStream to the Docker container.

   One example,

   ```
   # cp <...>/lib/ld-linux.so.3 /lib
   ```

3. Test the binary. We are using VRStream's `wget` binary.

   ```
   # MALLOC_CHECK_=0 LD_LIBRARY_PATH=. qemu-arm ./wget --no-check-certificate https://localhost:4443/msg.txt
   ```

   ```
   $ MALLOC_CHECK_=0 LD_LIBRARY_PATH=. qemu-arm ./wget http://69.163.153.149
   ```


#### Make space on the MicroSD root partition

To make space on the MicroSD root partition, delete files from the
`/usr/share/locale` folder.

```
$ rm -rf /usr/share/locale/zh*

$ rm -rf /usr/share/locale/yi

$ rm -rf /usr/share/locale/xh

$ rm -rf /usr/share/locale/pl

... and other similar folders.
```
