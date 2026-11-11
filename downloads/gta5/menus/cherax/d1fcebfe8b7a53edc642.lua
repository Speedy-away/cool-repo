
local function cheraxOutfitsFeature()
    return FeatureMgr.GetFeatureByName("Cherax Outfits")
end

local function outfitNameFeature()
    return FeatureMgr.GetFeature(760994232)
end

local function gameOutfitsFeature()
    return FeatureMgr.GetFeatureByName("Game Outfits")
end

local function saveFeature()
    return FeatureMgr.GetFeature(3761804643)
end

local function deleteFeature()
    return FeatureMgr.GetFeature(3381466999)
end

local function suscribedScriptsFeature()
    return FeatureMgr.GetFeature(Utils.Joaat("SubscribedScriptsList"))
end

local function runScriptFeature()
    return FeatureMgr.GetFeature(Utils.Joaat("SubscribedScriptRun"))
end

FeatureMgr.AddFeature(Utils.Joaat("SaveOutfitsInGame"), "Save Outfits In Game", eFeatureType.Button, "Converts the cherax outfits to the in game outfits.", function(f)

    local restoreString = outfitNameFeature():GetStringValue()

    for int, string in ipairs(cheraxOutfitsFeature():GetList()) do
        cheraxOutfitsFeature():SetListIndex(int - 1)
        gameOutfitsFeature():SetListIndex(int - 1)
        outfitNameFeature():SetStringValue(string)
        saveFeature():OnClick()
    end

    outfitNameFeature():SetStringValue(restoreString)
    gameOutfitsFeature():SetListIndex(0)

    GUI.AddToast("Outfit Manager", "Succesfully saved outfits.", 7000)

end)

FeatureMgr.AddFeature(Utils.Joaat("DeleteInGameOutfits"), "Delete In Game Outfits", eFeatureType.Button, "Deletes the in game outfits.", function(f)

    for int, string in ipairs(gameOutfitsFeature():GetList()) do
        gameOutfitsFeature():SetListIndex(int - 1)
        deleteFeature():OnClick()

        if string == "Empty" then
            break
        end

    end

    gameOutfitsFeature():SetListIndex(0)
    GUI.AddToast("Outfit Manager", "Succesfully deleted outfits.", 7000)

end)

FeatureMgr.AddFeature(Utils.Joaat("LoadCodax"), "Load Codax", eFeatureType.Button, "", function()

    for int, string in ipairs(suscribedScriptsFeature():GetList()) do
        if string.find(string, "Codax") then
            suscribedScriptsFeature():SetListIndex(int - 1)
            runScriptFeature():OnClick()
            break
        end
    end

    Script.Yield(1000)

    if not cheraxOutfitsFeature() then
        GUI.AddToast("OutfitManager", "Codax could not be found!", 7000)
        Logger.Log(eLogColor.RED, "OutfitManager", "Codax could not be found!")
    else
        GUI.AddToast("OutfitManager", "Codax has been succesfully loaded.", 7000)
        Logger.Log(eLogColor.GREEN, "OutfitManager", "Codax has been succesfully loaded.")
    end

end)

ClickGUI.AddTab("OutfitManager", function()
    if ImGui.BeginTabBar("OutfitManager") then

        if ImGui.BeginTabItem("Manage Outfits") then

            local columns = 2
            if ImGui.BeginTable("Outfits", columns, ImGuiTableFlags.SizingStretchSame) then
                ImGui.TableNextRow()

                for column = 0, columns - 1 do
                    ImGui.TableSetColumnIndex(column)

                    if column == 0 and ClickGUI.BeginCustomChildWindow("Outfits") then

                        if not cheraxOutfitsFeature() then
                            ImGui.Text("Codax needs to be loaded for this!")
                            ClickGUI.RenderFeature(Utils.Joaat("LoadCodax"))
                        else
                            ClickGUI.RenderFeature(Utils.Joaat("SaveOutfitsInGame"))
                            ClickGUI.RenderFeature(Utils.Joaat("DeleteInGameOutfits"))
                        end

                        ClickGUI.EndCustomChildWindow()
                    end

                    if column == 1 and ClickGUI.BeginCustomChildWindow("Current Outfits") then

                        if not cheraxOutfitsFeature() then
                            ImGui.Text("Codax needs to be loaded for this!")
                            ClickGUI.RenderFeature(Utils.Joaat("LoadCodax"))
                        else
                            ClickGUI.RenderFeature(cheraxOutfitsFeature():GetHash())
                            ClickGUI.RenderFeature(outfitNameFeature():GetHash())
                            ClickGUI.RenderFeature(gameOutfitsFeature():GetHash())
                            ClickGUI.RenderFeature(saveFeature():GetHash())
                            ImGui.SameLine()
                            ClickGUI.RenderFeature(deleteFeature():GetHash())
                        end

                        ClickGUI.EndCustomChildWindow()
                    end

                end

                ImGui.EndTable()
            end

            ImGui.EndTabItem()
        end

        ImGui.EndTabBar()
    end
end)

GUI.AddToast("OutfitManager", "Succesfully loaded!", 7000)

--print(Stats.GetInt(Utils.Joaat("MP0_MPSV_MODEL_158")))