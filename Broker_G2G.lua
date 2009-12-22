-- TODO: Fix the interface between G2G and the broker

local G2G = _G.CreateFrame("Frame", "Broker_G2G")
local tip = LibStub("tektip-1.0").new(3, "LEFT", "CENTER", "RIGHT")

G2G.OnlineUsers = {}
do
	local tmpList = Guild2Guild:getOnlineUsers({})
	for _, v in ipairs(tmpList) do
		G2G.OnlineUsers[v.name] = {
			guild = v.guild or "",
			note = v.note or ""
		}
	end
end

G2G.obj = _G.LibStub("LibDataBroker-1.1"):NewDataObject("Broker_G2G", {
	type = "data source",
	icon = "Interface\\Addons\\Broker_G2G\\icon",
	text = "G2G",
	--[[
	OnTooltipShow = function(tooltip)
    		local txt = L["Guild2Guild"]..VER..self.tooltip..L["Hint"]

			if tooltip and tooltip.AddLine then
				tooltip:AddLine(txt)
			end
		end
	]]--
	}
)

function G2G.obj.OnLeave() tip:Hide() end
function G2G.obj.OnEnter(self)
	tip:AnchorTo(self)

	tip:AddLine("Guild2Guild")
	tip:AddLine(" ")

	local online
	for name, info in pairs(G2G.OnlineUsers) do
		tip:AddMultiLine("|cffffffff" .. name .. FONT_COLOR_CODE_CLOSE,
						 "|cffffff00" .. info.note .. FONT_COLOR_CODE_CLOSE,
						 "|cff0070dd" .. info.guild .. FONT_COLOR_CODE_CLOSE )
	end

	tip:Show()
end

function G2G.obj.OnClick(self, button)
	GameTooltip:Hide()
	Guild2Guild:RequestPlayerInfos()
end

function G2G:playerOnline(event, player, guild, note)
	G2G.OnlineUsers[player] = G2G.OnlineUsers[player] or {}
	G2G.OnlineUsers[player].guild = guild or ""
	G2G.OnlineUsers[player].note = note or ""
end

function G2G:playerOffline(event, player)
	G2G.OnlineUsers[player] = nil
end

Guild2Guild.infocb.RegisterCallback(G2G, "PLAYERONLINE", "playerOnline")
Guild2Guild.infocb.RegisterCallback(G2G, "PLAYEROFFLINE", "playerOffline")
