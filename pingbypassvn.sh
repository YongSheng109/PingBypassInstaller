#set some variables
apt install python3-pip -y
apt install iproute2 -y
apt install screen -y
cd ~ && wget -q https://github.com/3arthqu4ke/HeadlessMc/releases/download/1.5.2/headlessmc-launcher-1.5.2.jar
clear
internalip=$( ip -o route get to 10.0.0.0 | sed -n 's/.*src \([0-9.]\+\).*/\1/p' ) # the ip ok
javadir=~/jdk8u345-b01/bin
hmcdir=~/HeadlessMC
modsdir=~/.minecraft/mods
mcdir=~/.minecraft/versions/1.12.2
playitcheck=~playit
launch=~pb
clear

#print the credits first, every installer ALWAYS has a stupid splash screen
echo 'Được tạo bởi HAV0X , được viết lại code bởi zYongSheng_ và được dịch bởi Thuy2y2c'
echo  '                                                                           
██╗░░░██╗░█████╗░███╗░░██╗░██████╗░██████╗░██╗░░░██╗██████╗░░█████╗░░██████╗░██████╗
╚██╗░██╔╝██╔══██╗████╗░██║██╔════╝░██╔══██╗╚██╗░██╔╝██╔══██╗██╔══██╗██╔════╝██╔════╝
░╚████╔╝░██║░░██║██╔██╗██║██║░░██╗░██████╦╝░╚████╔╝░██████╔╝███████║╚█████╗░╚█████╗░
░░╚██╔╝░░██║░░██║██║╚████║██║░░╚██╗██╔══██╗░░╚██╔╝░░██╔═══╝░██╔══██║░╚═══██╗░╚═══██╗
░░░██║░░░╚█████╔╝██║░╚███║╚██████╔╝██████╦╝░░░██║░░░██║░░░░░██║░░██║██████╔╝██████╔╝
░░░╚═╝░░░░╚════╝░╚═╝░░╚══╝░╚═════╝░╚═════╝░░░░╚═╝░░░╚═╝░░░░░╚═╝░░╚═╝╚═════╝░╚═════╝░             
'
sleep 2
echo ''
echo "Hãy chạy lại script này nếu bạn gặp lỗi HeadlessMc."
sleep 1

#make sure this is being run in the home dir and not anywhere else
if [ $PWD != ~ ]; then
	echo "Vui lòng nhập lệnh | cd ~ | rồi chạy lại script. ( Vì bạn đang ở một danh mục khác, script cần phải được chạy ở danh mục home! )"
	exit 0
fi

#ask for user input for ip, port, password, and OS type
read -p 'Hãy nhập Internal Port (cổng port nỗi bộ) của bạn >> ' openport
read -p 'Hãy nhập mật khẩu PingBypass của bạn >> ' pass
read -p 'Hãy nhập mail tài khoản Minecraft của bạn (Microsoft) >> ' email
read -p 'Hãy nhập mật khẩu tài khoản Minecraft của bạn (Microsoft) >> ' password
internalport=$openport

#install java if it hasnt been installed before
if [ ! -d "$javadir" ]; then
	echo 'Đang cài đặt Java...'
	wget -q https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u345-b01/OpenJDK8U-jdk_x64_linux_hotspot_8u345b01.tar.gz
	tar -xf OpenJDK8U-jdk_x64_linux_hotspot_8u345b01.tar.gz
	echo 'Đã thành công cài đặt Java!'
  clear
fi

#make config files, directories and input relevant configs if they dont exist
if [ ! -d "$hmcdir" ]; then
	mkdir ~/HeadlessMC -p && touch ~/HeadlessMC/config.properties && cat >> ~/HeadlessMC/config.properties<<EOL 
hmc.java.versions=$javadir/java
hmc.invert.jndi.flag=true
hmc.invert.lookup.flag=true
hmc.invert.lwjgl.flag=true
hmc.invert.pauls.flag=true
hmc.jvmargs=-Xmx1700M -Dheadlessforge.no.console=true
EOL

	mkdir ~/.minecraft/earthhack -p && touch ~/.minecraft/earthhack/pingbypass.properties && cat >> ~/.minecraft/earthhack/pingbypass.properties<<EOL
pb.server=true
pb.ip=$internalip
pb.port=$openport
pb.password=$pass
EOL
fi

#download mods and hmc and move them to the proper places if not already downloaded
if [ ! -d "$modsdir" ]; then
	echo 'Đang cài đặt mods... (gói chính sửa mã gì đó tao chịu)'
	mkdir ~/.minecraft/mods -p
	wget -q https://github.com/3arthqu4ke/3arthh4ck/releases/download/1.8.4/3arthh4ck-1.8.4-release.jar && mv 3arthh4ck-1.8.4-release.jar ~/.minecraft/mods
	wget -q https://github.com/3arthqu4ke/HMC-Specifics/releases/download/1.0.3/HMC-Specifics-1.12.2-b2-full.jar && mv HMC-Specifics-1.12.2-b2-full.jar ~/.minecraft/mods
	wget -q https://github.com/3arthqu4ke/HeadlessForge/releases/download/1.2.0/headlessforge-1.2.0.jar && mv headlessforge-1.2.0.jar ~/.minecraft/mods
	wget -q https://github.com/lordofwizard/mcserver/raw/main/startAfk
	echo 'Đã thành công cài đặt xong mods!'
	sleep 2
	clear
fi

#download minecraft and forge if not already done and login
if [ ! -d "$mcdir" ]; then
	$javadir/java -jar headlessmc-launcher-1.5.2.jar --command download 1.12.2
	$javadir/java -jar headlessmc-launcher-1.5.2.jar --command forge 1.12.2
	clear
fi
	$javadir/java -jar headlessmc-launcher-1.5.2.jar --command login $email $password
	clear

#download playit.gg if it hasnt been already
if [ ! -d "$playitcheck" ]; then
	echo 'Đang cài đặt Playit...'
	wget -q https://playit.gg/downloads/playit-0.8.1-beta -O playit && chmod +x playit
	echo 'Đã thành công cài đặt xong Playit!'
	sleep 2
	clear
fi

#make launch file for pb server if it hasnt been made already
if [ ! -d "$launch" ]; then
	touch pb && cat >>~/pb<<EOL
$javadir/java -jar headlessmc-launcher-1.5.2.jar --command $@
EOL
chmod +x pb
chmod +x playit
fi

clear
cd ~ && git clone https://github.com/carrot69/keep-presence.git
pip3 install pynput
pip3 install bpytop
./startAfk
clear
screen -S server -d -m jdk8u345-b01/bin/java -jar headlessmc-launcher-1.5.2.jar --command launch 0 -id
screen -S playit -d -m ./playit
screen -S afk2 -d -m python3 /usr/local/lib/python3.9/dist-packages/bpytop.py
screen -S afk -d -m python3 keep-presence/src/keep-presence.py --seconds 30 && cd ~
notify-send -t 0 $internalip
notify-send -t 0 $internalport
screen -ls
sleep 2
screen -r playit
