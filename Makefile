SOURCES := $(wildcard fabric-snippets/*.md)


all: lab-l2-arp/setup.ipynb \
	lab-l2-bridge/setup.ipynb \
    lab-stp/setup.ipynb \
	lab-static-basic/setup.ipynb \
	lab-static-design/setup.ipynb \
	lab-dynamic-basic/setup.ipynb \
	lab-multicast-basic/setup.ipynb

clean:
	rm lab-l2-arp/setup.ipynb \
	rm lab-l2-bridge/setup.ipynb \
    rm lab-stp/setup.ipynb \
	rm lab-static-basic/setup.ipynb \
	rm lab-static-design/setup.ipynb \
	rm lab-dynamic-basic/setup.ipynb \
	rm lab-multicast-basic/setup.ipynb

L2_ARP_SOURCES := $(wildcard lab-l2-arp/fabric-*.md)
lab-l2-arp/setup.ipynb: $(SOURCES) $(L2_ARP_SOURCES)
	pandoc --wrap=none \
                -i lab-l2-arp/fabric-intro-l2-arp.md fabric-snippets/fab-config.md \
                lab-l2-arp/fabric-define-l2-arp.md \
                fabric-snippets/reserve-resources.md fabric-snippets/configure-resources.md fabric-snippets/offload-off.md \
				fabric-snippets/draw-topo-detailed-labels.md fabric-snippets/log-in.md \
				lab-l2-arp/fabric-transfer-l2-arp.md \
				fabric-snippets/delete-slice.md \
                -o lab-l2-arp/setup.ipynb  

L2_BRIDGE_SOURCES := $(wildcard lab-l2-bridge/fabric-*.md)
lab-l2-bridge/setup.ipynb: $(SOURCES) $(L2_BRIDGE_SOURCES)
	pandoc --wrap=none \
                -i lab-l2-bridge/fabric-intro-l2-bridge.md fabric-snippets/fab-config.md \
                lab-l2-bridge/fabric-define-l2-bridge.md \
                fabric-snippets/reserve-resources.md fabric-snippets/configure-resources.md fabric-snippets/offload-off.md \
				fabric-snippets/draw-topo-detailed-labels.md fabric-snippets/log-in.md \
				lab-l2-bridge/fabric-transfer-l2-bridge.md \
				fabric-snippets/delete-slice.md \
                -o lab-l2-bridge/setup.ipynb

STP_SOURCES := $(wildcard lab-stp/fabric-*.md)
lab-stp/setup.ipynb: $(SOURCES) $(STP_SOURCES)
	pandoc --wrap=none \
                -i lab-stp/fabric-intro-stp.md fabric-snippets/fab-config.md \
                lab-stp/fabric-define-stp.md \
                fabric-snippets/reserve-resources.md fabric-snippets/configure-resources.md fabric-snippets/offload-off.md \
				fabric-snippets/draw-topo-detailed-labels.md fabric-snippets/log-in.md \
				lab-stp/fabric-transfer-stp.md \
				fabric-snippets/delete-slice.md \
                -o lab-stp/setup.ipynb

STATIC_BASIC_SOURCES := $(wildcard lab-static-basic/fabric-*.md)
lab-static-basic/setup.ipynb: $(SOURCES) $(STATIC_BASIC_SOURCES)
	pandoc --wrap=none \
                -i lab-static-basic/fabric-intro-static-basic.md fabric-snippets/fab-config.md \
                lab-static-basic/fabric-define-static-basic.md \
                fabric-snippets/reserve-resources.md fabric-snippets/configure-resources.md fabric-snippets/offload-off.md \
				fabric-snippets/draw-topo-detailed-labels.md fabric-snippets/log-in.md \
				lab-static-basic/fabric-transfer-static-basic.md \
				fabric-snippets/delete-slice.md \
                -o lab-static-basic/setup.ipynb

STATIC_DESIGN_SOURCES := $(wildcard lab-static-design/fabric-*.md)
lab-static-design/setup.ipynb: $(SOURCES) $(STATIC_DESIGN_SOURCES)
	pandoc --wrap=none \
                -i lab-static-design/fabric-intro-static-design.md fabric-snippets/fab-config.md \
                lab-static-design/fabric-define-static-design.md \
                fabric-snippets/reserve-resources.md fabric-snippets/configure-resources.md fabric-snippets/offload-off.md \
				fabric-snippets/draw-topo-detailed-labels.md fabric-snippets/log-in.md \
				fabric-snippets/delete-slice.md \
                -o lab-static-design/setup.ipynb

DYNAMIC_BASIC_SOURCES := $(wildcard lab-dynamic-basic/fabric-*.md)
lab-dynamic-basic/setup.ipynb: $(SOURCES) $(DYNAMIC_BASIC_SOURCES)
	pandoc --wrap=none \
                -i lab-dynamic-basic/fabric-intro-dynamic-basic.md fabric-snippets/fab-config.md \
                lab-dynamic-basic/fabric-define-dynamic-basic.md \
                fabric-snippets/reserve-resources.md fabric-snippets/configure-resources.md fabric-snippets/offload-off.md \
				fabric-snippets/draw-topo-detailed-labels.md fabric-snippets/log-in.md \
				lab-dynamic-basic/fabric-transfer-dynamic-basic.md \
				fabric-snippets/delete-slice.md \
                -o lab-dynamic-basic/setup.ipynb

MULTICAST_BASIC_SOURCES := $(wildcard lab-multicast-basic/fabric-*.md)
lab-multicast-basic/setup.ipynb: $(SOURCES) $(MULTICAST_BASIC_SOURCES)
	pandoc --wrap=none \
                -i lab-multicast-basic/fabric-intro-multicast-basic.md fabric-snippets/fab-config.md \
                lab-multicast-basic/fabric-define-multicast-basic.md \
                fabric-snippets/reserve-resources.md fabric-snippets/configure-resources.md fabric-snippets/offload-off.md \
				fabric-snippets/draw-topo-detailed-labels.md fabric-snippets/log-in.md \
				lab-multicast-basic/fabric-transfer-multicast-basic.md \
				fabric-snippets/delete-slice.md \
                -o lab-multicast-basic/setup.ipynb