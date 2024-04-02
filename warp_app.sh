#!/bin/bash
cd "$OLDPWD" && pwd

printf 'init termux env and install wget python3 zip android-tools? (y/n)? '
read -r answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo "start upgrade pkg and install wget python3 zip android-tools"
    pkg upgrade -y;
    pkg install wget python3 zip android-tools -y;
else
    echo "skip upgrade pkg and install wget python3 zip android-tools"
fi

if [ ! -f ~/replace_ip.py ]; then
        echo "replace_ip.py not found,start download..."
        wget "https://github.com/xlzhen-940218/TermuxWARPShell/raw/main/replace_ip.py" -O ~/replace_ip.py
else
        echo "replace_ip.py downloaded."
fi

printf "please open developer mode and enable wifi usb debug,and input adb wifi port: "
read -r answer_port
adb connect localhost:"$answer_port"

minimum_size=8660
actual_size=$(du -k "wireguard.apk" | cut -f 1)
if [ "$actual_size" -ge $minimum_size ]; then
    echo "wireguard apk size is $actual_size,ready install..."
else
    echo "wireguard apk size is $actual_size,need retry download..."
    rm -rf ~/wireguard.apk
fi

if [ ! -f ~/wireguard.apk ]; then
        echo "wireguard not found,start download..."
        wget "https://download.wireguard.com/android-client/com.wireguard.android-1.0.20231018.apk" -O ~/wireguard.apk
else
        echo "wireguard apk downloaded,open there"
fi

cp ~/wireguard.apk /storage/emulated/0/wireguard.apk

printf 'install wireguard app? (y/n)? '
read -r answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo "install wireguard app"
    termux-open /storage/emulated/0/wireguard.apk
    adb install wireguard.apk
    adb shell monkey -p 'com.wireguard.android' -v 1
else
    echo "skip install wireguard app"
fi

minimum_size=74120
actual_size=$(du -k "telegram.apk" | cut -f 1)
if [ "$actual_size" -ge $minimum_size ]; then
    echo "telegram apk size is $actual_size,ready install..."
else
    echo "telegram apk size is $actual_size,need retry download..."
    rm -rf ~/telegram.apk
fi

if [ ! -f ~/telegram.apk ]; then
	echo "telegram not found,start download..."
	wget https://telegram.org/dl/android/apk -O ~/telegram.apk
else
	echo "telegram apk downloaded,open there"
fi

cp ~/telegram.apk /storage/emulated/0/telegram.apk

printf 'install telegram app? (y/n)? '
read -r answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo "install telegram app"
    termux-open /storage/emulated/0/telegram.apk
    adb install telegram.apk
    adb shell monkey -p 'org.telegram.messenger.web' -v 1
else
    echo "skip install telegram app"
fi

printf 'open telegram warp+bot link (y/n)? '
read -r answer

if [ "$answer" != "${answer#[Yy]}" ] ;then 
    echo "ok, start link"
    termux-open https://t.me/generatewarpplusbot
else
    echo "skip open link"
fi

echo "check warp account"
if [ -f /storage/emulated/0/Telegram/wg-config.conf ]; then
	echo "have account,ready replace the ip"
else
	echo "not have account,please follow warp+bot link"
fi

printf "use warp ip 优选...(y/n)? "
read -r answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
	wget -N https://gitlab.com/Misaka-blog/warp-script/-/raw/main/files/warp-yxip/warp-yxip.sh && bash warp-yxip.sh
else
	echo 'skip warp ip 优选.'
fi

python replace_ip.py result.csv /storage/emulated/0/Telegram/
cd /storage/emulated/0/Telegram && zip -rv Telegram.zip .
echo "please open wireguard app and select Telegram.zip from /storage/emulated/0/Telegram/"
