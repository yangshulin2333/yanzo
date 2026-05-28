-- Source asset search exporter.
-- Paste into Roblox Studio Command Bar while the group project "吃东西测试服" is open.
-- It searches Script/LocalScript/ModuleScript source for known failing asset IDs and asset-loading keywords.

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
	["102814554762972"] = "Sound",
	["114216952350666"] = "Sound",
	["124084081676266"] = "Sound",
	["12870804641"] = "Sound",
	["12948869757"] = "Sound",
	["12948869835"] = "Sound",
	["12948869918"] = "Sound",
	["12948870057"] = "Sound",
	["12948870634"] = "Sound",
	["12948870701"] = "Sound",
	["12948870756"] = "Sound",
	["12948870849"] = "Sound",
	["12948893024"] = "Sound",
	["130124802169027"] = "Sound",
	["132824621769597"] = "Sound",
	["13729764428"] = "Sound",
	["13729765050"] = "Sound",
	["13729765161"] = "Sound",
	["137731412329263"] = "Sound",
	["13807704092"] = "Sound",
	["139096410428474"] = "Animation",
	["140213505389116"] = "Sound",
	["18407173712"] = "Sound",
	["18407174112"] = "Sound",
	["18407174514"] = "Sound",
	["18407174851"] = "Sound",
	["18407175306"] = "Sound",
	["18407175645"] = "Sound",
	["18407176357"] = "Sound",
	["18407177042"] = "Sound",
	["18407177374"] = "Sound",
	["18451496611"] = "Sound",
	["18721735423"] = "Sound",
	["18846073707"] = "Sound",
	["74841059300115"] = "Sound",
	["85695794590263"] = "Animation",
	["89441660388960"] = "Animation",
}

local KEYWORDS = {
	"rbxassetid://",
	"asset/?id=",
	"assetdelivery.roblox.com",
	"AnimationId",
	"SoundId",
	"LoadAnimation",
	"Instance.new(\"Animation\")",
	"Instance.new('Animation')",
	"Instance.new(\"Sound\")",
	"Instance.new('Sound')",
	"PlaySound",
	"PlaySoundEvent",
	"SoundModule",
	"PlaySoundModule",
	"AnimationModule",
	"DrawAnimaModule",
	"DmgAni",
	"FightEvent",
}

local MAX_EXACT_ROWS = 300
local MAX_KEYWORD_ROWS = 180
local MAX_KEYWORD_ROWS_PER_SCRIPT = 8
local MAX_SUMMARY_ROWS = 160
local MAX_SNIPPET_LEN = 180

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
local function snippet(line)
	line = tostring(line or ""):gsub("^%s+", ""):gsub("%s+$", "")
	if #line > MAX_SNIPPET_LEN then
		return line:sub(1, MAX_SNIPPET_LEN) .. "..."
	end
	return line
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

local scripts = {}
for _, root in ipairs(roots) do
	for _, child in ipairs(root:GetDescendants()) do
		local kind = scriptType(child)
		if kind then
			table.insert(scripts, child)
		end
	end
end
table.sort(scripts, function(a, b)
	return pathOf(a) < pathOf(b)
end)

local exactRows = {}
local keywordRows = {}
local summaryRows = {}
local unreadableRows = {}

for _, scriptObj in ipairs(scripts) do
	local ok, source = pcall(function()
		return scriptObj.Source
	end)
	local scriptPath = pathOf(scriptObj)
	local kind = scriptType(scriptObj)
	if not ok then
		table.insert(unreadableRows, { kind, scriptPath, tostring(source) })
	else
		local exactCount = 0
		local keywordCount = 0
		local keywordAddedForThisScript = 0
		local lineNumber = 0
		for line in (tostring(source) .. "\n"):gmatch("(.-)\n") do
			lineNumber = lineNumber + 1
			local lowerLine = line:lower()

			for assetId, assetType in pairs(PROBLEM_IDS) do
				if line:find(assetId, 1, true) then
					exactCount = exactCount + 1
					if #exactRows < MAX_EXACT_ROWS then
						table.insert(exactRows, { assetType, assetId, kind, scriptPath, lineNumber, snippet(line) })
					end
				end
			end

			for _, keyword in ipairs(KEYWORDS) do
				if lowerLine:find(keyword:lower(), 1, true) then
					keywordCount = keywordCount + 1
					if #keywordRows < MAX_KEYWORD_ROWS and keywordAddedForThisScript < MAX_KEYWORD_ROWS_PER_SCRIPT then
						table.insert(keywordRows, { keyword, kind, scriptPath, lineNumber, snippet(line) })
						keywordAddedForThisScript = keywordAddedForThisScript + 1
					end
					break
				end
			end
		end

		if exactCount > 0 or keywordCount > 0 then
			table.insert(summaryRows, { kind, scriptPath, exactCount, keywordCount })
		end
	end
end

table.sort(summaryRows, function(a, b)
	if a[3] ~= b[3] then
		return a[3] > b[3]
	end
	if a[4] ~= b[4] then
		return a[4] > b[4]
	end
	return a[2] < b[2]
end)

add("# Roblox Source Asset Search Export")
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
row({ "ScriptCount", #scripts })
row({ "ExactRowsPrinted", #exactRows })
row({ "KeywordRowsPrinted", #keywordRows })
row({ "CandidateScriptCount", #summaryRows })
row({ "CandidateRowsPrinted", math.min(#summaryRows, MAX_SUMMARY_ROWS) })
add("")

add("## Exact Problem AssetId Matches")
add("")
add("| AssetType | AssetId | ScriptType | ScriptPath | Line | Snippet |")
add("|---|---:|---|---|---:|---|")
for _, r in ipairs(exactRows) do
	row(r)
end
add("")

add("## Candidate Scripts Summary")
add("")
add("| ScriptType | ScriptPath | ExactAssetIdHits | KeywordHits |")
add("|---|---|---:|---:|")
for i, r in ipairs(summaryRows) do
	if i > MAX_SUMMARY_ROWS then
		break
	end
	row(r)
end
add("")

add("## Keyword Matches")
add("")
add("| Keyword | ScriptType | ScriptPath | Line | Snippet |")
add("|---|---|---|---:|---|")
for _, r in ipairs(keywordRows) do
	row(r)
end
add("")

add("## Unreadable Scripts")
add("")
add("| ScriptType | ScriptPath | Error |")
add("|---|---|---|")
for _, r in ipairs(unreadableRows) do
	row(r)
end
add("")
add("## End")

print(table.concat(out, "\n"))
