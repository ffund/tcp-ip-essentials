# Get a list of all experiment interfaces
ifs=$(netstat -i | tail -n+3 | grep -Ev "lo|eth0" | cut -d' ' -f1 | tr '\n' ' ')

# remove InstaGENI-generated automatic routes
for i in $ifs; do 
  sudo ifconfig $i down
  sudo ifconfig $i up
  # Turn on IPv4 and IPv6 forwarding
  sudo sysctl -w net.ipv4.conf.$i.forwarding=1
  sudo sysctl -w net.ipv6.conf.$i.forwarding=1
done
