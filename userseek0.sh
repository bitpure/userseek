#!/bin/bash
# Coded by: thelinuxchoice
# Github: https://github.com/thelinuxchoice/userseek
# Instagram: @thelinuxchoice

trap 'exit 1' 2

dependencies() {


command -v curl > /dev/null 2>&1 || { echo >&2 "I require curl but it's not installed. Aborting."; exit 1; }
command -v crunch > /dev/null 2>&1 || { echo >&2 "I require crunch but it's not installed.Aborting."; exit 1; }


}

menu() {
start
main
}

banner() {


printf "Search posible username valid in twitter and instagram at the same time\n"

}


function start() {
if [[ -e available.txt ]]; then
rm -rf available.txt
fi
default_wl_user="users.txt"
read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Username List: \e[0m' wl_user
wl_user="${wl_user:-${default_wl_user}}"
default_threads="10"
read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Threads (Default 10): \e[0m' threads
threads="${threads:-${default_threads}}"
#fi
}

checktor() {

check=$(curl --socks5-hostname localhost:9050 -s https://check.torproject.org > /dev/null; echo $?)

if [[ "$check" -gt 0 ]]; then
printf "\e[1;91mPlease, check your TOR Connection! Just type tor or service tor start\n\e[0m"
exit 1
fi

}

function changeip() {
killall -HUP tor
}

function main() {

count_user=$(wc -l $wl_user | cut -d " " -f1)
printf "\e[1;92mWordlist:\e[0m\e[1;77m %s (%s)\e[0m\n" $wl_user $count_user
printf "\e[1;91m[*] Press Ctrl + C to stop or save session\n\e[0m"
token=0
startline=1
endline="$threads"
while [ $token -lt $count_user ]; do
IFS=$'\n'
for user in $(sed -n ''$startline','$endline'p' $wl_user); do

IFS=$'\n'
countuser=$(grep -n -x "$user" "$wl_user" | cut -d ":" -f1)
let token++
printf "\e[1;77mChecking user (%s/%s):\e[0m\e[1;92m %s\e[0m\n" $countuser $count_user $user
{(trap '' SIGINT && var1=$(curl -s "https://www.twitter.com/$user" -L -H "Accept-Language: en" | grep -c 'page doesn’t exist') && var=$(curl -L -s https://www.instagram.com/$user/ | grep -c "the page may have been removed"); if [[ $var == "1" && $var1 == "1" ]]; then printf "%s\n" $user >> available.txt ; fi ;) } & done; wait $!;
let startline+=$threads
let endline+=$threads

done
if [[ -e available.txt ]]; then
result=$(wc -l available.txt | cut -d " " -f1 )
printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] available: %s\n" $result
printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Saved: available.txt\n"
fi
exit 1
}

ask_name() {
  default_base_username=""
  read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Base username: \e[0m' base_username
  base_username="${base_username:-${default_base_username}}"
  printf $base_username
}

case "$1" in --resume) resume ;; *)
dependencies
banner
menu
esac
