#!/bin/bash

read _ _ gateway _ < <(ip route list match 0/0)

sudo route add -net    0.0.0.0/5 gw $gateway
sudo route add -net    8.0.0.0/7 gw $gateway
sudo route add -net   11.0.0.0/8 gw $gateway
sudo route add -net   12.0.0.0/6 gw $gateway
sudo route add -net   16.0.0.0/4 gw $gateway
sudo route add -net   32.0.0.0/3 gw $gateway
sudo route add -net   64.0.0.0/2 gw $gateway
sudo route add -net  128.0.0.0/1 gw $gateway

sudo route del default gw $gateway