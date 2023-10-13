# Get a list of all experiment interfaces, excluding loopback
ifs=$(netstat -i | tail -n+3 | grep -Ev "lo" | cut -d' ' -f1 | tr '\n' ' ')

# Turn off offloading of all kinds, if possible!
for i in $ifs; do 
  sudo ethtool -K $i gro off  
  sudo ethtool -K $i gso off  
  sudo ethtool -K $i tso off
done
