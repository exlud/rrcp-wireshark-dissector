# rrcp-wireshark-dissector

## a toy

Once I had a switch, TL-SG108 if I remember it correctely, which needs Windows GUI application to configure the VLAN.
But running that GUI application seems tricky (it's **THE** Windows :smile: ).
So I captured the sample packets of operations, modify some parameters as needed then replay the packets, to do the configuration. 
That switch uses RRCP Protocol (Realtek Remote Control Protocol), which is a sub-protocol of RL2P (Realtek Layer 2 Protocols) family.
Protocol detail: [wiki](https://en.wikipedia.org/wiki/Realtek_Remote_Control_Protocol)

## status
Tested on lua 5.2.4 version.
Cannot work on lua version older than 5.2(due to bit operations has changed since lua 5.2). 
