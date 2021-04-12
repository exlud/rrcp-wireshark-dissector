# rrcp-wireshark-dissector
## ---[Note]---
only implementd rrcp(Realtek Remote Control Protocol) sub-protocol of rl2p(Realtek Layer 2 Protocols) protocol family

## ---[Note]---
only test on lua 5.2.4 version. bits operations has changed since lua 5.2, that means this dissector cannot work on lua version older than 5.2. Or someone can just change the source code a little bit(bits operations API)

## ---[Note]---
only fulfilled register[0x0217] attributes. it's boring and waste of time to fulfill all registers' attributes, unless I figure out how to [automatically] scan datasheet pdf and generate specified data structure.  
