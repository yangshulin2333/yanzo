-- Target source exporter.
-- Paste into Roblox Studio Command Bar while the group project "吃东西测试服" is open.
-- It exports full source for the key scripts needed to understand animation, sound, eat, and speed flows.

local TARGET_PATHS = {
	"ReplicatedStorage/Tool/AnimationModule",
	"ReplicatedFirst/FirstPreload/AnimationModule",
	"ReplicatedStorage/Tool/SoundModule",
	"ReplicatedStorage/Tool/PlaySoundModule",
	"StarterPlayer/StarterPlayerScripts/Sound",
	"ReplicatedStorage/System/SystemDefaultAnime",
	"ServerStorage/System/SystemEatPlr",
	"ServerScriptService/吃食物",
	"ServerScriptService/按键加速",
	"StarterPlayer/StarterCharacterScripts/本地检测吃东西",
	"StarterPlayer/StarterCharacterScripts/自动吃东西",
	"ReplicatedStorage/Tool/宠物动画",
	"ReplicatedStorage/Tool/教练动画",
	"ReplicatedStorage/Tool/RankUpLocal",
}

local SERVICE_NAMES = {
	"Workspace",
	"ReplicatedStorage",
	"ReplicatedFirst",
	"ServerScriptService",
	"ServerStorage",
	"StarterGui",
	"StarterPlayer",
	"StarterPack",
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
local function row(values)
	for i, v in ipairs(values) do
		values[i] = esc(v)
	end
	add("| " .. table.concat(values, " | ") .. " |")
end
local function scriptType(x)
	if x:IsA("LocalScript") then
		return "LocalScript"
	elseif x:IsA("ModuleScript") then
		return "ModuleScript"
	elseif x:IsA("Script") then
		return "Script"
	end
	return nil
end
local function lineCount(source)
	local count = 0
	for _ in (tostring(source) .. "\n"):gmatch("(.-)\n") do
		count = count + 1
	end
	return count
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

local scriptsByPath = {}
for _, root in ipairs(roots) do
	for _, child in ipairs(root:GetDescendants()) do
		if scriptType(child) then
			scriptsByPath[pathOf(child)] = child
		end
	end
end

add("# Roblox Target Source Export")
add("")
add("## Project Context")
add("")
add("| Field | Value |")
add("|---|---|")
row({ "GameId", game.GameId })
row({ "PlaceId", game.PlaceId })
row({ "CreatorId", game.CreatorId })
row({ "CreatorType", game.CreatorType })
row({ "TargetCount", #TARGET_PATHS })
add("")

add("## Target Source Summary")
add("")
add("| Status | ScriptType | ScriptPath | Lines | SourceLength |")
add("|---|---|---|---:|---:|")

local foundItems = {}
for _, targetPath in ipairs(TARGET_PATHS) do
	local scriptObj = scriptsByPath[targetPath]
	if not scriptObj then
		row({ "Missing", "", targetPath, "", "" })
	else
		local ok, source = pcall(function()
			return scriptObj.Source
		end)
		if not ok then
			row({ "Unreadable", scriptType(scriptObj), targetPath, "", tostring(source) })
		else
			row({ "Found", scriptType(scriptObj), targetPath, lineCount(source), #source })
			table.insert(foundItems, {
				path = targetPath,
				kind = scriptType(scriptObj),
				source = tostring(source),
			})
		end
	end
end

add("")
add("## Sources")
for _, item in ipairs(foundItems) do
	add("")
	add("### " .. item.path)
	add("")
	add("| Field | Value |")
	add("|---|---|")
	row({ "ScriptType", item.kind })
	row({ "Lines", lineCount(item.source) })
	row({ "SourceLength", #item.source })
	add("")
	add("```luau")
	local lineNumber = 0
	for line in (item.source .. "\n"):gmatch("(.-)\n") do
		lineNumber = lineNumber + 1
		add(string.format("%04d: %s", lineNumber, line))
	end
	add("```")
end

add("")
add("## End")

print(table.concat(out, "\n"))
