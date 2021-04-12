rtl8316b = {}

local registers = {}

registers[0x0000] = { name = "System Reset"}
registers[0x0001] = { name = "Switch Parameter Register"}
registers[0x0002] = { name = "E2PROM Check ID"}
registers[0x0003] = { name = "Reserved"}
registers[0x0004] = { name = "LED MODE"}
registers[0x0005] = { name = "LED Display Configuration 0"}
registers[0x0006] = { name = "LED Display Configuration 1"}

registers[0x0100] = { name = "Board Trapping Status"}
registers[0x0101] = { name = "Loop Detech Status Register(32 bit Reg)"}
registers[0x0102] = { name = "System Fault Flag Register"}

registers[0x0200] = { name = "Realtek Protocol Control"}
registers[0x0201] = { name = "RRCP Security Mask Configuration (0)"}
registers[0x0202] = { name = "RRCP Security Mask Configuration (1)"}
registers[0x0203] = { name = "Switch MAC ID (0)"}
registers[0x0204] = { name = "Switch MAC ID (1)"}
registers[0x0205] = { name = "Switch MAC ID (2)"}
registers[0x0206] = { name = "Chip ID (RO)"}
registers[0x0207] = { name = "Vendor ID(0) (RO)"}
registers[0x0208] = { name = "Vendor ID(1) (RO)"}
registers[0x0209] = { name = "RRCP Password"}
registers[0x020a] = { name = "Port Rate Control Register"}
registers[0x020b] = { name = "Port Rate Control Register"}
registers[0x020c] = { name = "Port Rate Control Register"}
registers[0x020d] = { name = "Port Rate Control Register"}
registers[0x020e] = { name = "Port Rate Control Register"}
registers[0x020f] = { name = "Port Rate Control Register"}
registers[0x0210] = { name = "Port Rate Control Register"}
registers[0x0211] = { name = "Port Rate Control Register"}
registers[0x0212] = { name = "Port Rate Control Register"}
registers[0x0213] = { name = "Port Rate Control Register"}
registers[0x0214] = { name = "Port Rate Control Register"}
registers[0x0215] = { name = "Port Rate Control Register"}
registers[0x0216] = { name = "Reserved"}
registers[0x0217] = {
    name = "EEPROM RW Command Register",
    { attr = "EEPROM Address", pos = 0, wid = 8},
    { attr = "Chip_sel[2:0]", pos = 8, wid = 3},
    { attr = "Read/Write Operation", pos = 11, wid = 1},
    { attr = "Status", pos = 12, wid = 1},
    { attr = "Operation Succeeded status", pos = 13, wid = 1},
}
registers[0x0218] = { name = "E2PROM RW Data Register"}
registers[0x0219] = { name = "Port Mirror Control Register for P15-P0"}
registers[0x021a] = { name = "Port Mirror Control Register for P23-P16"}
registers[0x021b] = { name = "RX Mirror port mask for P15-P0"}
registers[0x021c] = { name = "RX Mirror port mask for P23-P16"}
registers[0x021d] = { name = "TX Mirror port mask for P15-P0"}
registers[0x021e] = { name = "TX Mirror port mask for P23-P16"}

registers[0x0300] = { name = "ALT Configuration"}
registers[0x0301] = { name = "Address Learning Control(0)"}
registers[0x0302] = { name = "Address Learning Control(1)"}
registers[0x0303] = { name = "Unknown SA Management 0 (RO) 0"}
registers[0x0304] = { name = "Unknown SA Management 0 (RO) 1"}
registers[0x0305] = { name = "Unknown SA Management 0 (RO) 2"}
registers[0x0306] = { name = "Unknown SA Management 1 (RO)"}
registers[0x0307] = { name = "Port Trunking Configuration"}
registers[0x0308] = { name = "IGMP Control Register"}
registers[0x0309] = { name = "IP Multicast Router Discovery"}
registers[0x030a] = { name = "RSVD"}
registers[0x030b] = { name = "VLAN Control Register"}
registers[0x030c] = { name = "Port VLAN ID Assignment (0)"}
registers[0x030d] = { name = "Port VLAN ID Assignment (1)"}
registers[0x030e] = { name = "Port VLAN ID Assignment (2)"}
registers[0x030f] = { name = "Port VLAN ID Assignment (3)"}
registers[0x0310] = { name = "Port VLAN ID Assignment (4)"}
registers[0x0311] = { name = "Port VLAN ID Assignment (5)"}
registers[0x0312] = { name = "Port VLAN ID Assignment (6)"}
registers[0x0313] = { name = "Port VLAN ID Assignment (7)"}
registers[0x0314] = { name = "Reserved"}
registers[0x0315] = { name = "Reserved"}
registers[0x0316] = { name = "Reserved"}
registers[0x0317] = { name = "Reserved"}
registers[0x0318] = { name = "Reserved"}

registers[0x0400] = { name = "Qos Control Register"}
registers[0x0401] = { name = "Port Priority Configuration(0)"}
registers[0x0402] = { name = "Port Priority Configuration(1)"}
registers[0x0408] = { name = "Reserved(Used by RRCP software)"}

registers[0x0500] = { name = "PHY Access Addressing Control"}
registers[0x0501] = { name = "PHY Access Write Data"}
registers[0x0502] = { name = "PHY Access Read Data"}

registers[0x0608] = { name = "Port Access Authority Control(0)"}
registers[0x0609] = { name = "Port Access Authority Control(1)"}
registers[0x060a] = { name = "Port Property Configuration Register 0 (Port 0}1)"}
registers[0x060b] = { name = "Port Property Configuration Register 1 (Port 2}3)"}
registers[0x060c] = { name = "Port Property Configuration Register 3 (Port 4}5)"}
registers[0x060d] = { name = "Port Property Configuration Register 4 (Port 6}7)"}
registers[0x060e] = { name = "Port Property Configuration Register 5 (Port 8}9)"}
registers[0x060f] = { name = "Port Property Configuration Register 6 (Port 10}11)"}
registers[0x0610] = { name = "Port Property Configuration Register 7 (Port 12}13)"}
registers[0x0611] = { name = "Port Property Configuration Register 8 (Port 14}15)"}


function rtl8316b.attributes(index, data)
    if(registers[index] == nil) then return end

    local attributes = registers[index]
    local ret = {}
    for i = 1, #attributes do
        local attr = attributes[i]
        if(attr.attr ~= nil) then
            table.insert(ret, string.format("%s : %d", attr.attr, bit32.extract(data, attr.pos, attr.wid))) --[ can only run on Lua V5.2 or above--]
        end
    end
    return ret
end

function rtl8316b.name(index)
    if(registers[index] ~= nil and registers[index].name ~= nil) then
        return registers[index].name
    end
end

return rtl8316b

