--[ realtek layer 2 protocols --]
local rl2p = Proto("rl2p", "Realtek Layer 2 Protocols")

function rl2p.init()
    DissectorTable.get("ethertype"):add(0x8899, rl2p)
end

local fields = rl2p.fields

local subproto = setmetatable(
    {
        [1]="Realtek Remote Control Protocol",
        [2]="Realtek Echo Protocol"
    },
    {
        __index = function(table, key)
            return "Unknown";
        end
    }
)

fields.subproto = ProtoField.uint8("rl2p.subproto", "SubProtocol", base.DEC, subproto)

local subdissectors = {
    [1] = Dissector.get("rrcp"),
--[    [2] = Dissector.get("rep"), --]
}

function rl2p.dissector(tvb, pinfo, tree)
    if(tvb:len() ~= 46) then return end  --[ must be fixed len 46--]
    pinfo.cols.protocol = rl2p.name

    local rl2ptree = tree:add(rl2p, tvb(0, 1))
    rl2ptree:add(fields.subproto, tvb(0, 1))
    local subdissector = subdissectors[tvb(0, 1):uint()]
    if subdissector ~= nil then
        subdissector:call(tvb(1):tvb(), pinfo, tree)
    end
end
