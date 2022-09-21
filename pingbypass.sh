#set some variables
apt install iproute2 -y
apt install screen -y
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
echo 'brought you to the HAV0X PingBypass Rewrite by zYongSheng_'
echo  '                                                                           
██╗░░░██╗░█████╗░███╗░░██╗░██████╗░██████╗░██╗░░░██╗██████╗░░█████╗░░██████╗░██████╗
╚██╗░██╔╝██╔══██╗████╗░██║██╔════╝░██╔══██╗╚██╗░██╔╝██╔══██╗██╔══██╗██╔════╝██╔════╝
░╚████╔╝░██║░░██║██╔██╗██║██║░░██╗░██████╦╝░╚████╔╝░██████╔╝███████║╚█████╗░╚█████╗░
░░╚██╔╝░░██║░░██║██║╚████║██║░░╚██╗██╔══██╗░░╚██╔╝░░██╔═══╝░██╔══██║░╚═══██╗░╚═══██╗
░░░██║░░░╚█████╔╝██║░╚███║╚██████╔╝██████╦╝░░░██║░░░██║░░░░░██║░░██║██████╔╝██████╔╝
░░░╚═╝░░░░╚════╝░╚═╝░░╚══╝░╚═════╝░╚═════╝░░░░╚═╝░░░╚═╝░░░░░╚═╝░░╚═╝╚═════╝░╚═════╝░             
'
sleep 2
echo "If you get an error while logging into HeadlessMC, re-run the script."
sleep 1

#make sure this is being run in the home dir and not anywhere else
if [ $PWD != ~ ]; then
	echo "**This script MUST be run in the home directory!**\n**This script will NOT work elsewhere!**"
	exit 0
fi

#ask for user input for ip, port, password, and OS type
read -p 'What port would you like to use for Pingbypass? >> ' openport
read -p 'What password would you like the Pingbypass server to use? >> ' pass
read -p 'Input the email of the Minecraft account you want on the server. >> ' email
read -p 'Input the password of the Minecraft account you want on the server. >> ' password

#install java if it hasnt been installed before
if [ ! -d "$javadir" ]; then
	wget https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u345-b01/OpenJDK8U-jdk_x64_linux_hotspot_8u345b01.tar.gz
	tar -xf OpenJDK8U-jdk_x64_linux_hotspot_8u345b01.tar.gz
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
	mkdir ~/.minecraft/mods -p
	wget https://github.com/3arthqu4ke/3arthh4ck/releases/download/1.8.4/3arthh4ck-1.8.4-release.jar && mv 3arthh4ck-1.8.4-release.jar ~/.minecraft/mods
	wget https://github.com/3arthqu4ke/HMC-Specifics/releases/download/1.0.3/HMC-Specifics-1.12.2-b2-full.jar && mv HMC-Specifics-1.12.2-b2-full.jar ~/.minecraft/mods
	wget https://github.com/3arthqu4ke/HeadlessForge/releases/download/1.2.0/headlessforge-1.2.0.jar && mv headlessforge-1.2.0.jar ~/.minecraft/mods
	wget https://github.com/3arthqu4ke/HeadlessMc/releases/download/1.5.2/headlessmc-launcher-1.5.2.jar
fi

#download minecraft and forge if not already done and login
if [ ! -d "$mcdir" ]; then
	$javadir/java -jar headlessmc-launcher-1.5.2.jar --command download 1.12.2
	$javadir/java -jar headlessmc-launcher-1.5.2.jar --command forge 1.12.2
fi
	$javadir/java -jar headlessmc-launcher-1.5.2.jar --command login $email $password


#download playit.gg if it hasnt been already
if [ ! -d "$playitcheck" ]; then
	wget wget -q "https://playit.gg/downloads/playit-0.8.1-beta" -O playit && chmod +x playit
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
echo 'Open a screen using the command "screen -S PingBypass", this should bring you to a brand new screen, now in this screen, type ./pb to launch the pingbypass, you should see 1.12.2 and Forge 1.12.2'
echo ''
echo 'There should be a number beside Forge 1.12.2 (It should be 0) If it's 0 then type "launch 0 -id" it should launch minecraft, if it's not 0, then type "launch 1 -id"'
echo ''
echo 'After that, ctrl + a + d to exit the screen, now you need to open a new screen by typing the command "screen -S Port", after opening a screen, type ./playit'
echo ''
echo 'You should see a link in your screen, copy it and paste it in your browser, get the domain and check its ip and port in mcsrvstat.us, change the internal ip and port.'
ip -o route get to 10.0.0.0 | sed -n 's/.*src \([0-9.]\+\).*/\1/p' && echo $openport
