#!/usr/bin/env bash

#stopping chef

echo "stopping chef-client"
echo ""
/etc/init.d/chef-client stop

sleep +2

# umount the current home nfs-home:/exports/home
echo " umounting home"
umount -f /home

if [ $? -gt 1 ]; then
	   echo " UMOUNT FAILED check /home/operations/failed_home.txt";
	      echo `hostname -f` >> /home/operations/failed_home.txt;
	         exit;
	 fi

	 # making oldhome dir
	 echo " making /oldhome dir"
	 echo""

	 if [ -d /oldhome ]; then
		    echo "directory already exist"
	    else
		       mkdir /oldhome

	       fi
	       # renaming /home to /oldhome
	       echo "changing /home to /oldhome"
	       echo ""

	       sed -i "s: /home: /oldhome:g" /etc/fstab

	       # adding the new home mount
	       echo " adding new /home"
	       echo ""

	       echo "netapp01.720.rdio:/vol/home /home  nfs rw,wsize=524288,rsize=131072,soft,intr 0 2" >> /etc/fstab

	       # mounting the mounts
	       echo "Doing a mount -a"
	       echo ""
	       mount -a


	       # start chef-client

	       /etc/init.d/chef-client start
	       sleep +2

	       #######  running mount command to verify the mounts are correct.
	       echo " Doing a mount command to verify mounts"
	       echo ""

	       mount | grep home


	       ####### verifying fstab
	       echo " verifying fstab"
	       echo ""

	       cat /etc/fstab | grep home
