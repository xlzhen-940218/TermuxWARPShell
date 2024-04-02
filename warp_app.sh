#!/bin/bash
cd "$OLDPWD" && pwd

printf 'init termux env and install wget python3 zip ? (y/n)? '
read -r answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo "start upgrade pkg and install wget python3 zip"
    pkg upgrade -y;
    pkg install wget python3 zip -y;
else
    echo "skip upgrade pkg and install wget python3 zip"
fi

if [ ! -f ~/replace_ip.py ]; then
        echo "replace_ip.py not found,start download..."
        wget "https://github.com/xlzhen-940218/TermuxWARPShell/raw/main/replace_ip.py" -O ~/replace_ip.py
else
        echo "replace_ip.py downloaded."
fi

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

cp ~/wireguard.apk /sdcard/Download/wireguard.apk

printf 'install wireguard app? (y/n)? '
read -r answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo "install wireguard app"
    termux-open /sdcard/Download/wireguard.apk
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

cp ~/telegram.apk /sdcard/Download/telegram.apk

printf 'install telegram app? (y/n)? '
read -r answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo "install telegram app"
    termux-open /sdcard/Download/telegram.apk
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
if [ -f /sdcard/Download/Telegram/wg-config.conf ]; then
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

python replace_ip.py result.csv /sdcard/Download/Telegram/
zip -rv /sdcard/Download/Telegram.zip /sdcard/Download/Telegram/
echo "please open wireguard app and select Telegram.zip from /sdcard/Download/"
