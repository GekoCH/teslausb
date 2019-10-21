# teslausb

## Install with rclone working

1.	Downloade img von https://github.com/marcone/teslausb/releases
1.	Burn img to SD via Etcher
1.	Edit teslausb_setup_variables.conf.sample and past teslausb_setup_variables.conf inside, don’t rename it yet
1.	Copy wpa_supplicant.conf.sample to wpa_supplicant.conf and add Wifi settings to the file. Add WIFI_ENABLED to /boot folder
1.	Boot device
1.	Connect via ssh
1.	Install rclone via curl https://rclone.org/install.sh | sudo bash
1.	go to sudo -i and launch rclone config
1.	add nextcloud as webdav
1.	rename teslausb_setup_variables.conf.sample in /boot to teslausb_setup_variables.conf
1.	reboot


This config is used with a 128GB SD-Card
```
## Config teslausb_setup_variables.conf

#####################################################################
# SAMPLE CONFIGURATION FILE FOR TESLAUSB Pi Setup
#
# Example config file for teslausb_setup. Lines with "#" are comments/ignored.
# Remove the "#" before "export" to activate a line. Be sure to rename this file
# to "teslausb_setup_variables.conf" and place it in the "boot" folder of your
# SD card.
#
######################################################################

# Default variables for CIFS (Windows/Mac file sharing) setup
export ARCHIVE_SYSTEM=rclone
export RCLONE_DRIVE=nextcloud
export RCLONE_PATH=tesla/TeslaCam
export RCLONE_MUSIC=tesla/Music_tesla

export RCLONENAME=nextcloud
export RCLONETYPE=webdav
export RCLONEVENDOR=nextcloud
export RCLONEURL=https://URL:443/remote.php/webdav/FOLDER_TO_GO/
export RCLONEUSER=
export RCLONEPASS=

# export cifs_version="3.0"
export camsize=25%

# if you set camsize to less than 100%, but don't want music to use
# all the remaining space, you can specify how much space you want
# music to use by setting this variable
# export musicsize=4G

# If you want to automatically copy music from a CIFS share every time
# the Pi connects to wifi, set the following variable. The share is
# assumed to exist on the same server as the archive share. It can
# be the same share as the share used for backing up recordings, but
# the folder needs to be different.
# export musicsharename=Media/Music


# Wifi setup information. Note that Raspberry Pi Zero W only supports 2.4 GHz wifi
# export SSID=''
# export WIFIPASS=''

# If doing a headless (i.e. automatic) setup
export HEADLESS_SETUP=true

# uncomment to enable a samba server that exports the recordings
#export SAMBA_ENABLED=true
# uncomment to enable guest access to the samba server
#export SAMBA_GUEST=true

# uncomment if you want to set the time zone to something other than the default 'BST'
# Can be an actual timezone, or "auto" to attempt automatic timezone detection
export timezone="Europe/Zurich"

# By default there is a 20 second delay between connecting to wifi and
# starting the archiving of recorded clips. Uncomment this to change
# the duration of that delay
export archivedelay=60

# Uncomment if you want to override the default hostname of "teslausb"
# export TESLAUSB_HOSTNAME=teslausb-Model3

# Uncomment if setting up Pushover push notifications
# export pushover_enabled=false
# export pushover_user_key=
# export pushover_app_key=

# Uncomment if setting up Gotify push notifications
# export gotify_enabled=false
# export gotify_domain=https://gotify.domain.com
# export gotify_app_token=put_your_token_here
# export gotify_priority=5

# Uncomment if setting up IFTTT push notifications
# export ifttt_enabled=false
# export ifttt_event_name=put_your_event_name_here
# export ifttt_key=put_your_key_here

# TeslaUSB can optionally use the Tesla API to keep your car awake, so it can
# power the Pi long enough for the archiving process to complete. To enable
# that, please provide your Tesla account email and password below.
# TeslaUSB will only send your credentials to the Tesla API itself.
# export tesla_email=
# export tesla_password=
# Please also provide your vehicle's VIN, so TeslaUSB can keep the correct
# vehicle awake.
# export tesla_vin=

# Uncomment and change if you want setup scripts to be pulled
# from a different repo than github.com/marcone/teslausb
export REPO=GekoCH

# Uncomment and change if you want a different branch than main-dev
# export BRANCH=main-dev

```


## Changes

This fork contains the following changes compared to the upstream [cimryan/teslausb](https://github.com/cimryan/teslausb):
1. Supports Tesla firmware 2019.x
1. Supports exporting the recordings as a CIFS share
1. Supports saving more than one hour of recordings
1. Supports automatically syncing music from a CIFS share folder
1. Supports using the Tesla API to keep the car awake during archiving
1. Status indicator while running
1. Easier and more flexible way to specify sizes of camera and music disks
1. Support for Gotify, IFTTT and AWS SNS in addition to Pushover for notifications

It is recommended to use the [prebuilt image](https://github.com/marcone/teslausb/releases) and [one step setup instructions](https://github.com/marcone/teslausb/blob/main-dev/doc/OneStepSetup.md) to get started, as the instructions below may be outdated.


## Intro

You can configure a Raspberry Pi Zero W so that your Tesla thinks it's a USB drive and will write dashcam footage to it. Since it's a computer:
* Scripts running on the Pi can automatically copy the clips to an archive server when you get home.
* The Pi can hold both dashcam clips and music files.
* The Pi can automatically repair filesystem corruption produced by the Tesla's current failure to properly dismount the USB drives before cutting power to the USB ports.

Archiving the clips can take from seconds to hours depending on how many clips you've saved and how strong the WiFi signal is in your Tesla. If you find that the clips aren't getting completely transferred before the car powers down after you park or before you leave you can use the Tesla app to turn on the Climate control. This will send power to the Raspberry Pi, allowing it to complete the archival operation.

Alternatively, you can provide your Tesla account credentials and VIN in TeslaUSB's settings, which will allow it to use the [Tesla API](https://tesla-api.timdorr.com) to keep the car awake while the files transfer. Instructions are available in the [one step setup instructions](https://github.com/marcone/teslausb/blob/main-dev/doc/OneStepSetup.md)

## Contributing
You're welcome to contribute to this repo by submitting pull requests and creating issues.

## Prerequisites

### Assumptions
* You park in range of your wireless network.
* Your wireless network is configured with WPA2 PSK access.

### Hardware

Required:
* [Raspberry Pi Zero W](https://www.raspberrypi.org/products/raspberry-pi-zero-w/):  [Adafruit](https://www.adafruit.com/product/3400) or [Amazon](https://www.amazon.com/Raspberry-Pi-Zero-Wireless-model/dp/B06XFZC3BX/)
  > Note: Of the many varieties of Raspberry Pi avaiable only the Raspberry Pi Zero and Raspberry Pi Zero W can be used as simulated USB drives. It may be possible to use a Pi Zero with a USB Wifi adapter to achieve the same result as the Pi Zero W but this hasn't been confirmed.

* A Micro SD card, at least 16 GB in size, and an adapter (if necessary) to connect the card to your computer.
* A mechanism to connect the Pi to the Tesla. Either:
  * A USB A/Micro B cable: [Adafruit](https://www.adafruit.com/product/898) or [Amazon](https://www.amazon.com/gp/product/B013G4EAEI/), or
  * A USB A Add-on Board if you want to plug your Pi into your Tesla like a USB drive instead of using a cable. [Amazon](https://www.amazon.com/gp/product/B07BK2BR6C/), or
  * A PCB kit if you want the lowest profile possible and you're able to solder. [Sparkfun](https://www.sparkfun.com/products/14526)

Optional:
* A case. The "Official" case: [Adafruit](https://www.adafruit.com/product/3446) or [Amazon](https://www.amazon.com/gp/product/B06Y593MHV). There are many others to choose from. Note that the official case won't work with the USB A Add-on board or the PCB kit.
* USB Splitter if you don't want to lose a front USB port. [The Onvian Splitter](https://www.amazon.com/gp/product/B01KX4TKH6) has been reported working by multiple people on reddit.

### Software
Download: [Raspbian Stretch Lite](https://www.raspberrypi.org/downloads/raspbian/)

**NOTE:** it is highly recommended that you use the [prebuilt teslausb image](https://github.com/marcone/teslausb/releases) instead and follow the [one step headless setup process](https://github.com/marcone/teslausb/blob/main-dev/doc/OneStepSetup.md).

Download and install: [Etcher](http://etcher.io)

## Set up the Raspberry Pi
There are four phases to setting up the Pi:
1. Get the OS onto the micro sd card.
1. Get a shell on the Pi.
1. Set up the archive for dashcam clips.
1. Set up the USB storage functionality.

There is a streamlined process for setting up the Pi which can currently be used if you plan to use Windows file shares, MacOS Sharing, or Samba on Linux for your video archive. [Instructions](doc/OneStepSetup.md).

If you'd like to host the archive using another technology or would like to set the Pi up, yourself, continue these instructions.

### Get the OS onto the MicroSD card
[These instructions](https://www.raspberrypi.org/documentation/installation/installing-images/README.md) tell you how to get Raspbian onto your MicroSD card. Basically:
1. Connect your SD card to your computer.
2. Use Etcher to write the zip file you downloaded to the SD card.
   > Note: you don't need to uncompress the zip file you downloaded.

### Get a shell on the Pi
Follow the instructions corresponding to the OS you used to flash the OS onto the MicroSD card:
* Windows: [Instructions](doc/GetShellWithoutMonitorOnWindows.md).
* MacOS or Linux: [Instructions](doc/GetShellWithoutMonitorOnLinux.md).

Whichever instructions you followed above will leave you in a command shell on the Pi. Use this shell for the rest of the steps in these instructions.

### Become root on the Pi

First you need to get into a root shell on the Pi:
```
sudo -i
```

You'll stay in this root shell until you run the "halt" command in the "Set up USB storage functionality" below.

### Set up the archive for dashcam clips
Follow the instructions corresponding to the technology you'd like to use to host the archive for your dashcam clips. You must choose just one of these technologies; don't follow more than one of these sets of instructions:
* Windows file share, MacOS Sharing, or Samba on Linux: [Instructions](doc/SetupShare.md).
* SFTP/rsync: [Instructions](doc/SetupRSync.md)
* **Experimental:** Google Drive, Amazon S3, DropBox, Microsoft OneDrive: [Instructions](doc/SetupRClone.md)

### Optional: Allocate SD Card Storage
Indicate how much of the sd card you want to allocate to the car for recording dashcam footage and music by running this command:

```
 export camsize=<number or percentage>
```

For example, using `export camsize=100%` would allocate 100% of the space to recording footage from your car and would not create a separate music partition. `export camsize=50%` would allocate half of the space for a dashcam footage drive and allocates the other half to for a music storage drive, unless otherwise specified. If you don't set `camsize`, the script will allocate 90% of the total space to the dashcam by default. Size can be specified as a percentage or as an absolute value, e.g. `export camsize=16G` would allocate 16 gigabytes for dashcam footage.
If you want limit music storage so it doesn't use up all the remaining storage after camera storage has been allocated, use `export musicsize=<number or percentage>` to specify the size.
For example, if there is 100 gigabyte of free space, then
```
 export camsize=50%
 export musicsize=10%
```
would allocate 50 gigabytes for camera and 10 gigabytes for music, leaving 40 gigabytes free.

Note: since the car records about 5.5 gigabyte per hour, and throws away non-saved recordings after an hour, it is not very useful to make 'camsize' very large. In fact, it is better to use a relatively small size, so that teslausb has space to preserve recordings that are older than 1 hour, which would otherwise be discarded by the car.
As an example, if your normal use case is driving to work in the morning, enabling Sentry while parked, and going back home in the evening, with the car reporting up to 10 Sentry events, then 16 GB is a good size to use. This allows the car to keep about 2 hours worth of Sentry mode recordings, in addition to the normal recordings. If you anticipate needing more space for saved recordings, for example if your car generally reports much more Sentry events, you manually save recordings a lot, or if you're going to be away from wifi for multiple days, then increase size as needed.
In order for teslausb to preserve recordings older than an hour, there needs to be enough free space on the sd card, at least 'camsize' worth, preferably much more.

### Optional: Configure push notification via Pushover, Gotify, IFTTT, or AWS SNS
If you'd like to receive a notification when your Pi finishes archiving clips follow these [Instructions](doc/ConfigureNotificationsForArchive.md).

### Optional: Configure a hostname
The default network hostname for the Pi will become `teslausb`.  If you want to have more than one TeslaUSB devices on your network (for example you have more than one Tesla in your houseold), then you can specify an alternate hostname for the Pi by running this command:

```
 export TESLAUSB_HOSTNAME=<new hostname>
```

For example, you could use `export TESLAUSB_HOSTNAME=teslausb-ModelX`

Make sure that whatever you speicfy for the new hostname is compliant with the rules for DNS hostnames; for example underscore (_) is not allowed, but dash (-) is allowed.  Full rules are in RFC 1178 at https://tools.ietf.org/html/rfc1178

### Set up the USB storage functionality
1. Run these commands:
    ```
    mkdir -p /root/bin
    cd /root/bin
    wget https://raw.githubusercontent.com/marcone/teslausb/main-dev/setup/pi/setup-teslausb
    chmod +x setup-teslausb
    ./setup-teslausb
    ```
1. Run this command:
    ```
    halt
    ```
1. Disconnect the Pi from the computer.

On the next boot, the Pi hostname will become `teslausb`, so future `ssh` sessions will be `ssh pi@teslausb.local`.   If you specified your own hostname, be sure to use that name (for example `ssh pi@teslausb-ModelX.local`)

Your Pi is now ready to be plugged into your Tesla. If you want to add music to the Pi, follow the instructions in the next section.

## Optional: Add music to the Pi
> Note: If you set `camsize` to `100%` then skip this step.

Connect the Pi to a computer. If you're using a cable be sure to use the port labeled "USB" on the circuitboard.
1. Wait for the Pi to show up on the computer as a USB drive.
1. Copy any music you'd like to the drive labeled MUSIC.
1. Eject the drives.
1. Unplug the Pi from the computer.
1. Plug the Pi into your Tesla.

Alternatively, you can configure the Pi to automatically copy from a CIFS share. To do this, define the "musicsharename" variable to point at a CIFS share and folder. The share currently must exist on the same server as the one where recordings will be backed up, and use the same credentials. The Pi will sync down ALL music it finds under the specified folder, so be sure there is enough space on the Pi's music drive.
For example, if you have your music on a share called 'Music', and on that share have a folder called 'CarMusic' where you copied all the songs that you want to have available in the car, use `export musicsharename=Music/CarMusic` in the setup file.


## Optional: Making changes to the system after setup
The setup process configures the Pi with read-only file systems for the operating system but with read-write
access through the USB interface. This means that you'll be able to record dashcam video and add and remove
music files but you won't be able to make changes to files on / or on /boot. This is to protect against
corruption of the operating system when the Tesla cuts power to the Pi.

To make changes to the system partitions:
```
ssh pi@teslausb.
sudo -i
/root/bin/remountfs_rw
```
Then make whatever changes you need to. The next time the system boots the partitions will once again be read-only.

## Meta
This repo contains steps and scripts originally from [this thread on Reddit]( https://www.reddit.com/r/teslamotors/comments/9m9gyk/build_a_smart_usb_drive_for_your_tesla_dash_cam/)

Many people in that thread suggested that the scripts be hosted on Github but the author didn't seem interested in making that happen. I've hosted the scripts here with his/her permission.
