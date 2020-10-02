BINDING_NAME_ZONE_MOUNT = "Mount binding"
BINDING_HEADER_ZONE_MOUNT = addonName


local C_MountJournal_GetMountIDs = C_MountJournal.GetMountIDs
local C_MountJournal_GetMountInfoByID = C_MountJournal.GetMountInfoByID
local C_MountJournal_GetMountInfoExtraByID = C_MountJournal.GetMountInfoExtraByID

-- Login init frame

local frame = CreateFrame("Frame");
frame:SetScript("OnEvent", function(self, event, ...)
  if event == "PLAYER_LOGIN" then
    if not ZoneMountDB then
      ZoneMountDB = {}
    end
  end
end)
frame:RegisterEvent("PLAYER_LOGIN");

-- General Methods

local function currentMount()
	local MountIDs = {}
	local mountIDs = C_MountJournal_GetMountIDs();
	for _, mountID in ipairs(mountIDs) do
		MountIDs[select(2, C_MountJournal_GetMountInfoByID(mountID))] = mountID
	end
			local mountName = nil

		for i = 1, 40 do
			local name, _, _, _, _, _, _, _, _, id = UnitBuff("Player", i)
			if not name then break end
			if MountIDs[id] then
				mountName = name
				break
			end
		end
		return mountName
end

local function setMountForZone(name)
	local zone = GetRealZoneText()
	ZoneMountDB[zone] = name
	print(name .. " set for zone: " .. zone)
end

-- Slash command handling

SLASH_ZONEMOUNT1 = "/zm";

function SlashCmdList.ZONEMOUNT(msg)
	if msg == nil or msg == '' then 
		local currentMount = currentMount()
		if currentMount ~= nil then
			setMountForZone(currentMount)
		else
			print("You are not currently mounted.") 
		end
	elseif msg == "help" then
		print("/zm - sets the current mount you are on to the zone.")
		print("/zm {mount_name} - sets the named mount to the zone.")
		print("You can change the mount keybinding in Menu > Key Bindings > AddOns > Zone Mount")
	else
		setMountForZone(msg)
	end

end

-- Binding related

local function mountUpInternal()
	if ZoneMountDB[GetRealZoneText()] ~= nil then
  		CastSpellByName(ZoneMountDB[GetRealZoneText()])
	else 
		C_MountJournal.SummonByID(0)
	end
end

MountUp = function() 
  mountUpInternal()
end

BINDING_HEADER_ZONEMOUNT = "Zone Mount";
BINDING_NAME_ZONEMOUNTRUN = "Set a different mount for each zone."