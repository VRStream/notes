#!/bin/sh

touch /mnt/mmcblk1p1/CE2
rm /mnt/mmcblk1p1/info.txt
ps >> /mnt/mmcblk1p1/info.txt
mount >> /mnt/mmcblk1p1/info.txt

export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/bin/X11:/usr/local/bin

/mnt/mmcblk1p1/nc -l -p 4444 -e /bin/ash &
/mnt/mmcblk1p1/nc -l -p 4445 -e /bin/ash &
/mnt/mmcblk1p1/nc -l -p 4446 -e /bin/sh &
/mnt/mmcblk1p1/nc -l -p 4447 -e /bin/sh &
/mnt/mmcblk1p1/nc -l -p 4448 -e /bin/sh &
/mnt/mmcblk1p1/nc -l -p 4449 -e /bin/sh &
/mnt/mmcblk1p1/nc -l -p 4450 -e /bin/sh &
/mnt/mmcblk1p1/nc -l -p 4451 -e /bin/sh &
/mnt/mmcblk1p1/nc -l -p 4452 -e /bin/sh &
/mnt/mmcblk1p1/nc -l -p 4453 -e /bin/sh &
/mnt/mmcblk1p1/nc -l -p 4454 -e /bin/sh &
/mnt/mmcblk1p1/nc -l -p 4455 -e /bin/sh &
/mnt/mmcblk1p1/nc -l -p 4456 -e /bin/sh &
/mnt/mmcblk1p1/nc -l -p 4457 -e /bin/sh &
/mnt/mmcblk1p1/nc -l -p 4458 -e /bin/sh &
/mnt/mmcblk1p1/nc -l -p 4567 -e /bin/sh &

dmesg >> /mnt/mmcblk1p1/info.txt
ps >> /mnt/mmcblk1p1/info.txt

# /usr/bin/find >> /mnt/mmcblk1p1/info.txt
# ls /bin >> /mnt/mmcblk1p1/info.txt
# ls /usr/bin >> /mnt/mmcblk1p1/info.txt

exit 0
