#!/bin/bash
# put this file in bin dir
# ./restart.sh (without clear cache)
# ./restart.sh 1 (To clear cache)

echo "Stopping Secure Transport"
./stop_all

echo "Killing Process"
pids=$(ps -ef | grep SecureTransport | grep -v grep | awk '{print$2}')
if [ -z "$pids" ];then 
    echo "No Process of Secure Transport Remain after running stop_all"
else
    echo "Killing remaining process..."
    count=$(echo "$pids" | wc -l)
    echo "Total $count process remained to stop"
    echo "$pids" | xargs kill -9
    echo "All process killed"
fi  

clear_cache=$1
if [ "$clear_cache" == "1" ];then 
    echo "Removing content of run dir"
    ls ../var/run/
    rm -rf ../var/run/*
    echo "Removing content of temp dir"
    ls ../var/tmp/
    rm -rf ../var/tmp/*
else 
    echo "You choose don't clear Cache"
fi 


echo "Starting Secure Transport"
./start_all 

adminui=false
webclient=false
ip=$(hostname -i)

while [ "$adminui" = false ] || [ "$webclient" = false ];do 
if [ "$adminui" = false ] && ss -tulnp | grep -q ":444 "; then
    if curl -sk --max-time 2 https://$ip:444/ -o /dev/null;then 
        adminui=true
        echo "Admin UI Responding"
    else
        echo "Port open 444 waiting for Admin UI...."
    fi 
fi
if [ "$webclient" = false ] && ss -tulnp | grep -q ":443 ";then 
    if curl -sk --max-time 2 https://$ip:443/ -o /dev/null;then 
        webclient=true
        echo "Web Client Responding"
    else
        echo "Port 443 open waiting for Web Client UI...." 
    fi 
fi 
if [ "$adminui" = false ] || [ "$webclient" = false ]; then
    echo "Waiting 2 Seconds........."
    sleep 2
fi
done 

echo "Both Admin UI and Web Client are Running......"

