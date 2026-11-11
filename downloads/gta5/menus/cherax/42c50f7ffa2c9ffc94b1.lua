local mySettingFile = "Default.json"
local translationFile = "Cherax_Korean_Translation.json"
local listHash = 476570075
local buttonHash = 1079343186
local targetName = "Korean"
local initTime = Time.GetEpocheMs()
local transData = {}
local executionStep = 0

local function LoadData(content)
    local data = {}
    for key, value in content:gmatch('"(-?%d+)"%s*:%s*"(.-)"') do
        local cleanVal = value:gsub("\\n", "\n")
        data[key] = cleanVal 
    end
    return data
end

local function TranslateListOptions()
    local root = FileMgr.GetMenuRootPath() .. "\\Translations\\"
    local content = FileMgr.ReadFileContent(root .. translationFile)
    
    if not content then return end
    transData = LoadData(content)
    
    local features = FeatureMgr.GetAllFeatures()
    
    for _, feat in pairs(features) do
        pcall(function()
            local fType = feat:GetType()
            if fType >= 11 and fType <= 14 then
                local originalList = feat:GetList()
                if originalList then
                    local newList = {}
                    local changed = false
                    for _, optName in ipairs(originalList) do
                        local hash = Utils.Joaat(optName)
                        local hashStr = string.format("%.0f", hash)
                        if hash < 0 then hashStr = string.format("%.0f", hash + 4294967296) end
                        
                        if transData[hashStr] then
                            table.insert(newList, transData[hashStr])
                            changed = true
                        else
                            table.insert(newList, optName)
                        end
                    end
                    if changed then
                        feat:SetList(newList)
                    end
                end
            end
        end)
    end
end

local function ApplyTranslationAndTheme()
    TranslateListOptions()

    local listFeature = FeatureMgr.GetFeature(listHash)
    if listFeature then
        pcall(function()
            local files = listFeature:GetList()
            local targetIndex = -1
            for i, fileName in ipairs(files) do
                if string.find(fileName, targetName) then
                    targetIndex = i - 1
                    break
                end
            end
            if targetIndex ~= -1 then
                listFeature:SetListIndex(targetIndex)
            end
        end)
    end

    local loadBtn = FeatureMgr.GetFeature(buttonHash)
    if loadBtn then
        pcall(function() loadBtn:OnClick() end)
    end

    pcall(function() ClickGUI.LoadTheme("Mine") end)
    pcall(function() ListGUI.LoadTheme("Mine.json") end)

    if GUI then GUI.AddToast("Auto Setup", "Translation & Theme Applied", 2000, 0) end
end

local function OnPresentLoop()
    if executionStep == 2 then return end
    
    local currentTime = Time.GetEpocheMs()
    local elapsed = currentTime - initTime

    if executionStep == 0 and elapsed > 1000 then
        pcall(function()
            if FeatureMgr.LoadSettings(mySettingFile) then
                 if GUI then GUI.AddToast("Auto Setup", "Settings Loaded: " .. mySettingFile, 1000, 0) end
            else
                 if GUI then GUI.AddToast("Error", "Config Not Found!", 3000, 0) end
            end
        end)
        executionStep = 1
    end

    if executionStep == 1 and elapsed > 4000 then
        ApplyTranslationAndTheme()
        executionStep = 2
    end
end

EventMgr.RegisterHandler(eLuaEvent.ON_PRESENT, OnPresentLoop)