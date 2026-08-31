#!/bin/sh
# Name : iptables.sh
# Author : Statler
# Description : Firewall configuration (iptables)
# Require : iptables
# License : BSD
# Version : 0.2
#
# CHANGELOG
#
# -- [0.0.2] --
#       + Options
#       + Help message
#       + Version message
#       + Error function
#
# -- [0.0.1] --
#       + Checking if is it root (id=0)
#       + Some parameters (IPTABLES binary, interface, config to use, DROPorREJECT)
#       + Cleaning function (reset)
#       + Initializing function (DROP all)
#       + AcceptLoopback function
#       + Scan protection function (protect against various scan methods)
#       + Configurations

# Default Parameters
NAME='iptables.sh'
IPTABLES='/usr/sbin/iptables'
INTERFACE='wlp5s0'
DROPorREJECT='DROP'
CONFIG=1
VERSION='0.2'
COLOR=1
MODIFICATION=0

# Functions
function Error
{
        echo "$NAME v$VERSION: $@" >&2
}
function PrintHelp
{
        echo "Usage : $0 [OPTIONS]"
        echo "          -h, --help                              Show this help message and exit"
        echo "          -V, --version                           Show program's version and exit"
        echo "          -n, --no-colors                         Don't use color in output"
        echo "          -c, --config NUM                        Configuration number to use (Default : 1)"
        echo "          -i, --interface INTERFACE               Interface (Default : wlan0)"
        echo "          -b, --binary BINARY                     Iptables's binary (Default : /usr/sbin/iptables)"
        echo "          -a, --action-to-refuse ACTION           What will do the script to refuse a connection. DROP or REJECT (Default : DROP)"
        echo "          -oc, --open-client PORT PROTOCOL        Open a PORT with the PROTOCOL as client"
        echo "          -os, --open-server PORT PROTOCOL        Open a PORT with the PROTOCOL as server"
        exit 0
}
function PrintVersion
{
        echo $VERSION
        exit 0
}
function ClientAccept
{
        # $1 : Port
        # $2 : Protocol
        # $3 : Service's name (Optionnal)
        if [ $# -eq 3 ];then
                echo "[*] Accept to connect to $3 as a Client"
        else
                echo "[*] Accept to connect to $1 as Client"
        fi
        $IPTABLES -A INPUT -i $INTERFACE -p $2 -m $2 --sport $1 -m conntrack --ctstate ESTABLISHED -j ACCEPT
        $IPTABLES -A OUTPUT -o $INTERFACE -p $2 -m $2 --dport $1 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
}
function ServerAccept
{
	# $1 : Port
	# $2 : Protocol

        if [ $# -eq 3 ];then
                echo "[*] Accept to connect to $3 as a Server"
        else
                echo "[*] Accept to connect to $1 as Server"
        fi
        $IPTABLES -A INPUT -i $INTERFACE -p $2 -m $2 --dport $1 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
        $IPTABLES -A OUTPUT -o $INTERFACE -p $2 -m $2 --sport $1 -m conntrack --ctstate ESTABLISHED -j ACCEPT
}
function OpenClient
{
	# $1 : Port
	# $2 : Protocol (Optionnal)
	if [ -z $2 ]; then
		ClientAccept $1 tcp "$1 (TCP)"
		ClientAccept $1 udp "$1 (UDP)"
	else
		ClientAccept $1 $2
	fi
}
function OpenServer
{
	# $1 : Port
	# $2 : Protocol (Optionnal)
	if [ -z $2 ]; then
		ServerAccept $1 tcp "$1 (TCP)"
		ServerAccept $1 udp "$1 (UDP)"
	else
		ServerAccept $1 $2
	fi
}
function Cleaning
{
        echo '[*] Cleaning...'
        # Reset counters
        $IPTABLES -Z
        # Flush all previous firewall rules
        $IPTABLES -t filter -F
        $IPTABLES -t filter -X
        $IPTABLES -t mangle -F
        $IPTABLES -t mangle -X
        $IPTABLES -t nat -F
        $IPTABLES -t nat -X
        $IPTABLES -t raw -F
        $IPTABLES -t raw -X
}
function Initializing
{
        echo '[*] Initializing...'
        $IPTABLES -t filter -P INPUT $DROPorREJECT
        $IPTABLES -t filter -P OUTPUT $DROPorREJECT
        $IPTABLES -t filter -P FORWARD $DROPorREJECT
        $IPTABLES -t nat -P PREROUTING ACCEPT
        $IPTABLES -t nat -P OUTPUT ACCEPT
        $IPTABLES -t nat -P POSTROUTING ACCEPT
        $IPTABLES -t mangle -P PREROUTING ACCEPT
        $IPTABLES -t mangle -P INPUT ACCEPT
        $IPTABLES -t mangle -P FORWARD ACCEPT
        $IPTABLES -t mangle -P OUTPUT ACCEPT
        $IPTABLES -t mangle -P POSTROUTING ACCEPT
}
function AcceptLoopback
{
        echo '[*] Accept Loopback traffic...'
        $IPTABLES -A INPUT -i lo -j ACCEPT
        $IPTABLES -A OUTPUT -o lo -j ACCEPT
        $IPTABLES -A FORWARD -i lo -o lo -j ACCEPT
}
function ClientAcceptFTP
{
        echo '[*] Accept FTP as Client'
        modprobe ip_conntrack_ftp
        $IPTABLES -A INPUT -i $INTERFACE -p tcp -m tcp --sport 21 -m conntrack --ctstate ESTABLISHED -j ACCEPT
        $IPTABLES -A INPUT -i $INTERFACE -p tcp -m tcp --sport 20 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
        $IPTABLES -A OUTPUT -o $INTERFACE -p tcp -m tcp --dport 21 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
        $IPTABLES -A OUTPUT -o $INTERFACE -p tcp -m tcp --dport 20 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
}
function ServerAcceptHTTP
{
        echo '[*] Accept HTTP as Server'
        $IPTABLES -A INPUT -i $INTERFACE -p tcp -m tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
        $IPTABLES -A OUTPUT -o $INTERFACE -p tcp -m tcp --sport 80 -m conntrack --ctstate ESTABLISHED -j ACCEPT
        # FastCGI
        $IPTABLES -A INPUT -i $INTERFACE -s 127.0.0.1 -p tcp -m tcp --dport 9000 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
        $IPTABLES -A OUTPUT -o $INTERFACE -d 127.0.0.1 -p tcp -m tcp --sport 9000 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
}
function ServerAcceptMPD
{
        echo '[*] Accept MPD as Server'
        $IPTABLES -A INPUT -i $INTERFACE -p tcp -m tcp --dport 6600 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
        $IPTABLES -A OUTPUT -o $INTERFACE -p tcp -m tcp --sport 6600 -m conntrack --ctstate ESTABLISHED -j ACCEPT
}
function ServerAcceptMinecraft
{
        echo '[*] Accept Minecraft as Server'
        $IPTABLES -A INPUT -i $INTERFACE -p tcp -m tcp --dport 25565 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
        $IPTABLES -A OUTPUT -o $INTERFACE -p tcp -m tcp --sport 25565 -m conntrack --ctstate ESTABLISHED -j ACCEPT
}
function ServerAcceptPentest
{
        echo '[*] Accept Pentest as Server'
        $IPTABLES -A INPUT -i $INTERFACE -p tcp -m tcp --dport 4444 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
        $IPTABLES -A OUTPUT -o $INTERFACE -p tcp -m tcp --sport 4444 -m conntrack --ctstate ESTABLISHED -j ACCEPT
        $IPTABLES -A INPUT -i $INTERFACE -p tcp -m tcp --dport 8080 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
        $IPTABLES -A OUTPUT -o $INTERFACE -p tcp -m tcp --sport 8080 -m conntrack --ctstate ESTABLISHED -j ACCEPT
        #$IPTABLES -A INPUT -i $INTERFACE -p tcp -m tcp --dport 18211 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
        #$IPTABLES -A OUTPUT -o $INTERFACE -p tcp -m tcp --sport 18211 -m conntrack --ctstate ESTABLISHED -j ACCEPT
}
function ServerAcceptSSH
{
        echo '[*] Accept SSH as Server'
        $IPTABLES -A INPUT -p tcp --destination-port 22 -j ACCEPT
        $IPTABLES -A OUTPUT -p tcp --source-port 22 -j ACCEPT
}
function ServerAcceptHamachi
{
        echo '[*] Accept Hamachi as Server'
        $IPTABLES -A INPUT -i $INTERFACE -p tcp -m tcp --dport 12975 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
        $IPTABLES -A OUTPUT -o $INTERFACE -p tcp -m tcp --sport 12975 -m conntrack --ctstate ESTABLISHED -j ACCEPT
        $IPTABLES -A INPUT -i $INTERFACE -p tcp -m tcp --dport 32976 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
        $IPTABLES -A OUTPUT -o $INTERFACE -p tcp -m tcp --sport 32976 -m conntrack --ctstate ESTABLISHED -j ACCEPT
        $IPTABLES -A INPUT -i $INTERFACE -p udp -m udp --dport 17771 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
        $IPTABLES -A OUTPUT -o $INTERFACE -p udp -m udp --sport 17771 -m conntrack --ctstate ESTABLISHED -j ACCEPT
}
function DropScan
{
        echo '[*] Scan protection'
        $IPTABLES -A INPUT -p tcp -m conntrack --ctstate NEW,INVALID ! --syn -j $DROPorREJECT
        $IPTABLES -A INPUT -p tcp -m conntrack --ctstate ESTABLISHED --syn -j $DROPorREJECT
        # Null Scan
        $IPTABLES -A INPUT -i $INTERFACE -p tcp --tcp-flags ALL NONE -j $DROPorREJECT
        # NMAP FIN Stealth
        $IPTABLES -A INPUT -i $INTERFACE -p tcp --tcp-flags ALL FIN -j $DROPorREJECT
        # Xmas Scan (FIN/URG/PSH)
        $IPTABLES -A INPUT -i $INTERFACE -p tcp --tcp-flags ALL FIN,URG,PSH -j $DROPorREJECT
        # SYN/RST/ACK/FIN/URG
        $IPTABLES -A INPUT -i $INTERFACE -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j $DROPorREJECT
        # ALL/ALL Scan
        $IPTABLES -A INPUT -i $INTERFACE -p tcp --tcp-flags ALL ALL -j $DROPorREJECT
        # SYN/RST
        $IPTABLES -A INPUT -i $INTERFACE -p tcp --tcp-flags SYN,RST SYN,RST -j $DROPorREJECT
        # SYN/FIN -- Scan(probably)
        $IPTABLES -A INPUT -i $INTERFACE -p tcp --tcp-flags SYN,FIN SYN,FIN -j $DROPorREJECT
        # Invalid packets
        $IPTABLES -A INPUT -i $INTERFACE -m conntrack --ctstate INVALID -j $DROPorREJECT
        # Fragmented packets
        $IPTABLES -A INPUT -i $INTERFACE -f -j $DROPorREJECT
}
function ClientAcceptICMP
{
        echo '[*] Accept ICMP as Client'
        $IPTABLES -A INPUT -i $INTERFACE -p icmp --icmp-type any -m conntrack --ctstate ESTABLISHED -j ACCEPT
        $IPTABLES -A OUTPUT -o $INTERFACE -p icmp --icmp-type any -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
}
function Config1
{
        # Normal Rules
#       ClientAccept 69 udp TFTP
        ClientAccept 80 tcp 'HTTP (TCP)'
        ClientAccept 80 udp 'HTTP (UDP)'
#       ClientAccept 8080 tcp
#	ClientAccept 8000 tcp
        ClientAccept 443 tcp 'HTTPS (TCP)'
        ClientAccept 443 udp 'HTTPS (UDP)'
        ClientAccept 53 tcp 'DNS (TCP)'
        ClientAccept 53 udp 'DNS (UDP)'
#       ClientAccept 23399 tcp Skype
       	ClientAccept 22 tcp SSH
        ClientAccept 587 tcp SMTP
        ClientAccept 995 tcp POP3S
#       ClientAccept 143 tcp IMAP
        ClientAccept 465 tcp 'SMTPS (Enseirb)' 
        ClientAccept 993 tcp 'IMAPS (Enseirb)'
#       ClientAccept 25 tcp SMTP
#	ClientAccept 14210 tcp "GIT Statler"
	ClientAccept 10000 tcp "Azanarel.no-ip.biz http"
	ClientAccept 10001 tcp "Azanarel.no-ip.biz ssh"
	ClientAccept 29109 tcp "Emeraude ssh"
	ClientAccept 500 udp "VPN cisco 500 (UDP)"
	ClientAccept 4500 udp "VPN cisco 4500 (UDP)"
	ClientAccept 10000 udp "VPN cisco 10000 (UDP)"
#       ClientAcceptFTP
        ClientAcceptICMP
#       ClientAccept 12975 tcp Hamachi
#       ClientAccept 32976 tcp Hamachi
#       ClientAccept 17771 udp Hamachi
#       ClientAccept 6600 tcp MPD
 	modprobe ip_conntrack_irc
        ClientAccept 6667 tcp IRC
#       ClientAccept 9999 tcp IRC-SSL
#       ClientAccept 9418 tcp "GIT (TCP)"
        ClientAccept 25565 tcp "Minecraft (TCP)"
#       ServerAcceptHTTP
#       ServerAcceptMPD
#       ServerAcceptPentest
#       ServerAcceptMinecraft
#       ServerAcceptHamachi
#	ServerAcceptSSH
        DropScan
}
function Config2
{
        # Audit Rules
        $IPTABLES -A OUTPUT -j ACCEPT
        echo '[*] Accept all OUTPUT traffic'
        $IPTABLES -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
        echo '[*] Accept all INPUT traffic, which was established'
        ServerAcceptPentest
}
function Config3
{
        # Audit Rules
        $IPTABLES -A OUTPUT -j ACCEPT
        echo '[*] Accept all OUTPUT traffic'
        $IPTABLES -A INPUT -j ACCEPT
        echo '[*] Accept all INPUT traffic'
}

# Need Root Privileges
if [ -n $UID ] && [ $UID -ne 0 ]; then
        Error 'You must be root'
        exit 1
elif [ `id -u` -ne 0 ]; then
        Error 'You must be root'
        exit 1
fi
# Check PID file
if [ -f /var/run/$NAME.pid ]; then
        Error "The script is already running, if isn't the case, then remove /var/run/$NAME.pid and run the script."
        exit 1
else
        echo $$ > /var/run/$NAME.pid
        /bin/chmod 600 /var/run/$NAME.pid
fi

# Parameters
while [ $# -gt 0 ]; do
        case $1 in
                --help | -h)
                        PrintHelp
                ;;
                --binary | -b)
                        shift
                        IPTABLES=$1
                ;;
                --interface | -i)
                        shift
                        INTERFACE=$1
                ;;
                --action-to-refuse | -a)
                        shift
                        DROPorREJECT=$1
                ;;
                --version | -V)
                        PrintVersion
                ;;
                --config | -c)
                        shift
                        CONFIG=$1
                ;;
                --no-colors | -n)
                        COLOR=0
                ;;
		--open-client | -oc)
			shift
			PORT=$1
			shift
			PROTOCOL=$1
			OpenClient $PORT $PROTOCOL 
			MODIFICATION=1
                ;;
		--open-server | -os)
			shift
			PORT=$1
			shift
			PROTOCOL=$1
			OpenServer $PORT $PROTOCOL 
			MODIFICATION=1
                ;;
                *)
                        PrintHelp
                ;;
        esac
        shift
done
if [ $MODIFICATION -eq 0 ]; then
	# Starting...
	modprobe ip_conntrack
	Cleaning
	Initializing
	AcceptLoopback
	Config$CONFIG
fi
rm /var/run/$NAME.pid
exit 0

