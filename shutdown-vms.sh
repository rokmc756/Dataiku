#!/bin/bash

UBT_NET=6
RH_NET=7
SS_NET=17

_NET=$RH_NET

ssh root@192.168.0.90 "shutdown -h now"

for i in `seq 1 7`; do ssh root@192.168.$_NET$i "shutdown -h now" ;done

