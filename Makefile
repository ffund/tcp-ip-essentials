SOURCES := $(wildcard fabric-snippets/*.md)


all: lab-l2-arp/setup.ipynb \
	lab-l2-bridge/setup.ipynb

clean:
	rm lab-l2-arp/setup.ipynb \
	rm lab-l2-bridge/setup.ipynb

L2_ARP_SOURCES := $(wildcard lab-l2-arp/fabric-*.md)
lab-l2-arp/setup.ipynb: $(SOURCES) $(L2_ARP_SOURCES)
	pandoc --wrap=none \
                -i lab-l2-arp/fabric-intro-l2-arp.md fabric-snippets/fab-config.md \
                lab-l2-arp/fabric-define-l2-arp.md \
                fabric-snippets/reserve-resources.md fabric-snippets/configure-resources.md \
				fabric-snippets/draw-topo-detailed-labels.md fabric-snippets/log-in.md \
				lab-l2-arp/fabric-transfer-l2-arp.md \
				fabric-snippets/delete-slice.md \
                -o lab-l2-arp/setup.ipynb  

L2_BRIDGE_SOURCES := $(wildcard lab-l2-bridge/fabric-*.md)
lab-l2-bridge/setup.ipynb: $(SOURCES) $(L2_BRIDGE_SOURCES)
	pandoc --wrap=none \
                -i lab-l2-bridge/fabric-intro-l2-bridge.md fabric-snippets/fab-config.md \
                lab-l2-bridge/fabric-define-l2-bridge.md \
                fabric-snippets/reserve-resources.md fabric-snippets/configure-resources.md \
				fabric-snippets/draw-topo-detailed-labels.md fabric-snippets/log-in.md \
				lab-l2-bridge/fabric-transfer-l2-bridge.md \
				fabric-snippets/delete-slice.md \
                -o lab-l2-bridge/setup.ipynb