-- Animation/Sound focused exporter.
-- Paste into Roblox Studio Command Bar while the group project "吃东西测试服" is open.
-- It scans project services only and prints Animation/Sound paths and IDs.

local SERVICE_NAMES = {
	"Workspace",
	"ReplicatedStorage",
	"ServerScriptService",
	"ServerStorage",
	"StarterGui",
	"StarterPlayer",
	"StarterPack",
	"ReplicatedFirst",
	"Lighting",
	"SoundService",
}

local PROBLEM_IDS = {
	["102814554762972"] = true,
	["114216952350666"] = true,
	["124084081676266"] = true,
	["12870804641"] = true,
	["12948869757"] = true,
	["12948869835"] = true,
	["12948869918"] = true,
	["12948870057"] = true,
	["12948870634"] = true,
	["12948870701"] = true,
	["12948870756"] = true,
	["12948870849"] = true,
	["12948893024"] = true,
	["130124802169027"] = true,
	["132824621769597"] = true,
	["13729764428"] = true,
	["13729765050"] = true,
	["13729765161"] = true,
	["137731412329263"] = true,
	["13807704092"] = true,
	["139096410428474"] = true,
	["140213505389116"] = true,
	["18407173712"] = true,
	["18407174112"] = true,
	["18407174514"] = true,
	["18407174851"] = true,
	["18407175306"] = true,
	["18407175645"] = true,
	["18407176357"] = true,
	["18407177042"] = true,
	["18407177374"] = true,
	["18451496611"] = true,
	["18721735423"] = true,
	["18846073707"] = true,
	["74841059300115"] = true,
	["85695794590263"] = true,
	["89441660388960"] = true,
}

local out = {}
local function add(s)
	table.insert(out, s or "")
end
local function esc(v)
	return tostring(v or ""):gsub("\r", "\\r"):gsub("\n", "\\n"):gsub("|", "\\|")
end
local function pathOf(x)
	local t = {}
	while x and x ~= game do
		table.insert(t, 1, x.Name)
		x = x.Parent
	end
	return table.concat(t, "/")
end
local function prop(x, p)
	local ok, v = pcall(function()
		return x[p]
	end)
	if ok and v ~= nil and tostring(v) ~= "" then
		return tostring(v)
	end
	return ""
end
local function assetIdOf(value)
	local text = tostring(value or "")
	local id = text:match("rbxassetid://(%d+)") or text:match("asset%?id=(%d+)")
	return id or ""
end
local function row(values)
	for i, v in ipairs(values) do
		values[i] = esc(v)
	end
	add("| " .. table.concat(values, " | ") .. " |")
end

local roots = {}
for _, serviceName in ipairs(SERVICE_NAMES) do
	local ok, service = pcall(function()
		return game:GetService(serviceName)
	end)
	if ok and service then
		table.insert(roots, service)
	end
end

local items = {}
for _, root in ipairs(roots) do
	for _, child in ipairs(root:GetDescendants()) do
		if child:IsA("Animation") or child:IsA("Sound") then
			table.insert(items, child)
		end
	end
end
table.sort(items, function(a, b)
	return pathOf(a) < pathOf(b)
end)

add("# Roblox Animation Sound Export")
add("")
add("## Project Context")
add("")
add("| Field | Value |")
add("|---|---|")
row({ "GameId", game.GameId })
row({ "PlaceId", game.PlaceId })
row({ "CreatorId", game.CreatorId })
row({ "CreatorType", game.CreatorType })
row({ "ScannedServices", table.concat(SERVICE_NAMES, ", ") })
add("")

add("## Animation And Sound References")
add("")
add("| Type | Path | Property | Value | AssetId | InErrorLog |")
add("|---|---|---|---|---:|---|")
for _, item in ipairs(items) do
	local propertyName = item:IsA("Animation") and "AnimationId" or "SoundId"
	local value = prop(item, propertyName)
	local assetId = assetIdOf(value)
	row({
		item.ClassName,
		"`" .. pathOf(item) .. "`",
		propertyName,
		"`" .. value .. "`",
		assetId,
		PROBLEM_IDS[assetId] and "Yes" or "No",
	})
end
add("")
add("## End")

print(table.concat(out, "\n"))
