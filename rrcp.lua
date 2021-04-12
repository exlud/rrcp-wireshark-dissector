local rrcp = Proto("rrcp", "Realtek Remote Control Protocol")

function rrcp.init()
    require "rtl8316b"
end

local fields = rrcp.fields

local command = setmetatable(
{
    [0x00] = "Hello",
    [0x80] = "Hello Reply",
    [0x01] = "Register Get",
    [0x81] = "Register Get Reply",
    [0x02] = "Register Set"
},
{
    __index = function(table, key)
        return string.format("0x%x", key)
    end
}
)

fields.cmd = ProtoField.uint8("rrcp.cmd", "Operation Command", base.HEX, command)

local mo = setmetatable(
{
    [0]="Hello",
    [1]="register Get",
    [2]="register Set"
},
{
    __index = function(table, key)
        return "Unknown"
    end
}
)
fields.mo = ProtoField.uint8("rrcp.mo", "Management Operation", base.DEC, mo, 0x7f)

local reply = {
    [0]="Other",
    [1]="Reply from Switch to Station",
}
fields.reply = ProtoField.uint8("rrcp.reply", "Reply Flag", base.DEC, reply, 0x80)

local authentication = setmetatable(
{
    [0x2379] = "Default"
},
{
    __index = function(table, key)
        return string.format("0x%x", key)
    end
}
)
fields.auth = ProtoField.uint16("rrcp.auth", "Authentication", base.HEX, authentication)

fields.reg = ProtoField.uint16("rrcp.reg", "Register Address", base.HEX)
fields.data = ProtoField.uint16("rrcp.data", "Register Data", base.HEX)
fields.pad = ProtoField.bytes("rrcp.pad", "_PAD", base.DOT)
fields.down = ProtoField.uint8("rrcp.down", "Downlink Port", base.DEC)
fields.up = ProtoField.uint8("rrcp.up", "Uplink Port", base.DEC)
fields.wmac = ProtoField.ether("rrcp.wmac", "Uplink MAC")
fields.id = ProtoField.uint16("rrcp.id", "Chip ID", base.DEC)
fields.vid = ProtoField.uint32("rrcp.vid", "Vendor ID")
fields.crc = ProtoField.uint32("rrcp.crc", "CRC", base.HEX)


function rrcp.dissector(tvb, pinfo, tree)
    local rrcptree = tree:add(rrcp, tvb(0))
    pinfo.cols.protocol = rrcp.name

    local cmditem = rrcptree:add(fields.cmd, tvb(0, 1))
    cmditem:add(fields.mo, tvb(0, 1))
    cmditem:add(fields.reply, tvb(0, 1))
    rrcptree:add(fields.auth, tvb(1, 2))

    local cmd = tvb(0, 1):uint()
    local regitem
    local dataitem
    if(cmd == 0x00) then --[ station send hello--]
        rrcptree:add(fields.pad, tvb(3)):set_hidden(true)
        pinfo.cols.info:set("Hello")
    elseif(cmd == 0x80) then --[ switch reply hello--]
        pinfo.cols.info:set("Hello Reply")
        rrcptree:add(fields.down, tvb(3, 1))
        rrcptree:add(fields.up, tvb(4, 1))
        rrcptree:add(fields.wmac, tvb(5, 6))
        rrcptree:add(fields.id, tvb(11, 2))
        rrcptree:add(fields.vid, tvb(13, 4))
        rrcptree:add(fields.pad, tvb(17, 24)):set_hidden(true)
        rrcptree:add(fields.crc, tvb(41))
    elseif(cmd == 0x01) then --[ station get register--]
        pinfo.cols.info:set("Read Register Request")
        regitem = rrcptree:add_le(fields.reg, tvb(3, 2))
        local name = rtl8316b.name(tvb(3, 2):le_uint())
        if(name ~= nil) then
            regitem:set_text("Register: " .. name)
        end
        rrcptree:add(fields.pad, tvb(5)):set_hidden(true)
    elseif(cmd == 0x81) then --[ switch reply get--]
        pinfo.cols.info:set("Read Register Reply")
        regitem = rrcptree:add_le(fields.reg, tvb(3, 2))
        local name = rtl8316b.name(tvb(3, 2):le_uint())
        if(name ~= nil) then
            regitem:set_text("Register: " .. name)
        end
        dataitem = rrcptree:add(fields.data, tvb(5, 2))
        local attrs = rtl8316b.attributes(tvb(3, 2):le_uint(), tvb(5, 2):le_uint())
        if(attrs ~= nil) then
            for k, v in ipairs(attrs)
            do
                local one = dataitem:add(fields.data, tvb(5,2))
                one:set_text(v)
            end
        end
        rrcptree:add(fields.pad, tvb(7)):set_hidden(true)
    elseif(cmd == 0x02) then --[ station set register--]
        pinfo.cols.info:set("Write Register Request")
        regitem = rrcptree:add_le(fields.reg, tvb(3, 2))
        local name = rtl8316b.name(tvb(3, 2):le_uint())
        if(name ~= nil) then
            regitem:set_text("Register: " .. name)
        end
        dataitem = rrcptree:add(fields.data, tvb(5, 2))
        local attrs = rtl8316b.attributes(tvb(3, 2):le_uint(), tvb(5, 2):le_uint())
        if(attrs ~= nil) then
            for k, v in ipairs(attrs)
            do
                local one = dataitem:add(fields.data, tvb(5,2))
                one:set_text(v)
            end
        end
        rrcptree:add(fields.pad, tvb(7)):set_hidden(true)
    end
end
