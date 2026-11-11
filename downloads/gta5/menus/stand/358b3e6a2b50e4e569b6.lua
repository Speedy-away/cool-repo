--[[
    == Collection Manager ==

    * Release Date: September 27th, 2022.
    * Author: Dangerman ¯\_(ツ)_/¯
]]

util.keep_running()
util.require_natives(1663599433)


-- Globals.

local strformat <const> = string.format
local tconcat <const> = table.concat
local tcontains <const> = table.contains
local tinsert <const> = table.insert
local tsort <const> = table.sort
local type <const> = type
local util <const> = util


-- Collection Manager Menu.

local CollectionManager <const> = {
    menu = nil,
    awaiting_restart = false,
    is_busy = false,
    collectibles = nil,
    collectibles_keys = nil,
}


function CollectionManager:init(parent_menu)
    self.menu = menu.list(parent_menu, "Collection Manager", {}, "Allows you to lock the game's collectibles and enjoy hunting for them again.")

    self:register_collectibles()

    local toggle_states = {}

    local reset_menu = menu.list(self.menu, "Reset Collections", {}, "Resets all of the selected collections below.")

    local reset_confirm_menu = menu.action(reset_menu, "Confirm Reset", {}, "Please go back and select which collectibles you want to reset.", function()
        if self.is_busy then
            util.toast("Please wait for the current operation to finish.")
            return false
        end

        local to_reset = {}
        for key, state in pairs(toggle_states) do
            if state then
                tinsert(to_reset, key)
            end
        end

        self.is_busy = true
        local status, result = pcall(self.uncollect, self, to_reset, true)
        if not status then
            util.toast(strformat("Error: %s", result))
        end
        self.is_busy = false
    end)

    local function update_help()
        local help_lines = {"Resets the following collections:"}
        for _, key in ipairs(self.collectibles_keys) do
            if toggle_states[key] then
                tinsert(help_lines, strformat("- %s.", key))
            end
        end
        if #help_lines < 2 then
            help_lines = {"Please go back and select which collectibles you want to reset."}
        else
            tinsert(help_lines, "WARNING: The game will restart automatically!")
        end
        menu.set_help_text(reset_confirm_menu, tconcat(help_lines, "\n"))
    end

    for _, key in ipairs(self.collectibles_keys) do
        menu.toggle(self.menu, key, {}, strformat("Reset %s.", key), function(on, click_type)
            toggle_states[key] = on
            update_help()
        end, false)
    end
end


function CollectionManager:register_collectibles()
    -- This is the full list of PERMANENT collectibles, which has been
    -- confirmed via update.rpf's `mpstatssetup.xml`.
    self.collectibles = {
        ["Action Figures"] = {
            {
                -- Range: 26811 - 26910, Length: 100.
                ["type"] = "packed_stat_bool",
                ["process"] = "range",
                ["start"] = 26811,
                ["end"] = 26910,
            },
            {
                ["type"] = "stat_int",
                ["process"] = "values",
                ["values"] = {
                    -- Global_2826809[8299 /*3*/][0] = joaat("mp0_action_fig_collected");
                    -- Global_2826809[8299 /*3*/][1] = joaat("mp1_action_fig_collected");
                    "action_fig_collected",
                },
            },
        },
        ["LD Organics Product"] = {
            {
                -- Range: 34262 - 34361, Length: 100.
                ["type"] = "packed_stat_bool",
                ["process"] = "range",
                ["start"] = 34262,
                ["end"] = 34361,
            },
            {
                ["type"] = "stat_int",
                ["process"] = "values",
                ["values"] = {
                    -- Global_2826809[10376 /*3*/][0] = joaat("mp0_ldorganics_collected");
                    -- Global_2826809[10376 /*3*/][1] = joaat("mp1_ldorganics_collected");
                    "ldorganics_collected",
                },
            },
        },
        ["Movie Props"] = {
            {
                -- Range: 30230 - 30239, Length: 10.
                ["type"] = "packed_stat_bool",
                ["process"] = "range",
                ["start"] = 30230,
                ["end"] = 30239,
            },
            {
                ["type"] = "stat_int",
                ["process"] = "values",
                ["values"] = {
                    -- Global_2826809[9382 /*3*/][0] = joaat("mp0_movie_props_collected");
                    -- Global_2826809[9382 /*3*/][1] = joaat("mp1_movie_props_collected");
                    "movie_props_collected",
                },
            },
        },
        ["Playing Cards"] = {
            {
                -- Range: 26911 - 26964, Length: 54.
                ["type"] = "packed_stat_bool",
                ["process"] = "range",
                ["start"] = 26911,
                ["end"] = 26964,
            },
            {
                ["type"] = "stat_int",
                ["process"] = "values",
                ["values"] = {
                    -- Global_2826809[8300 /*3*/][0] = joaat("mp0_playing_card_collected");
                    -- Global_2826809[8300 /*3*/][1] = joaat("mp1_playing_card_collected");
                    "playing_card_collected",
                },
            },
        },
        ["Signal Jammers"] = {
            {
                -- Range: 28099 - 28148, Length: 50.
                ["type"] = "packed_stat_bool",
                ["process"] = "range",
                ["start"] = 28099,
                ["end"] = 28148,
            },
            {
                ["type"] = "stat_int",
                ["process"] = "values",
                ["values"] = {
                    -- Global_2826809[8727 /*3*/][0] = joaat("mp0_signal_jammers_collected");
                    -- Global_2826809[8727 /*3*/][1] = joaat("mp1_signal_jammers_collected");
                    "signal_jammers_collected",
                },
            },
        },
        ["USB Media Player"] = {
            {
                ["type"] = "stat_int",
                ["process"] = "values",
                ["values"] = {
                    -- How many USB sticks have been found. Default is 0.
                    -- Global_2826809[9608 /*3*/][0] = joaat("MP0_USB_RADIO_COLLECTED");
                    -- Global_2826809[9608 /*3*/][1] = joaat("MP1_USB_RADIO_COLLECTED");
                    "usb_radio_collected",
                },
            },
            {
                ["type"] = "stat_int",
                ["process"] = "values",
                ["values"] = {
                    -- The currently selected USB station in the interaction menu.
                    -- Global_2826809[9832 /*3*/][0] = joaat("MP0_CURRENT_USB_MUSIC_MIX");
                    -- Global_2826809[9832 /*3*/][1] = joaat("MP1_CURRENT_USB_MUSIC_MIX");
                    "current_usb_music_mix",
                },
                ["new_value"] = 6,  -- The default "None (Off)" radio station, which is number 6.
            },
            {
                ["type"] = "function",
                ["func"] = function(char_slot)
                    if char_slot == nil then error("Missing char_slot argument."); end

                    -- Complete list of all collectible Media Player stations.
                    local usb_stations = {
                        -- The game identifies each station in multiple ways:
                        -- * A number which is used internally, between 0-10,
                        --   to identify each station by Media Player index.
                        -- * A packed stat boolean which indicates that the
                        --   station is unlocked (controls visibility in the
                        --   interaction menu's Media Player list).
                        -- * A packed stat boolean which indicates that the
                        --   USB stick has been picked up (controls its world
                        --   object visibility).
                        -- * A station name which is used for locking/unlocking
                        --   that station (doesn't seem to affect the GUI or be
                        --   necessary whatsoever, but we'll emulate that too).

                        [0] = {
                            -- 0: CircoLoco Records - Blue EP.
                            -- Location: Casino Roof Terrace.
                            ["stat_idx_station"] = 31708,
                            ["stat_idx_usb_stick"] = 31730,  -- Item ID 14.
                            ["name"] = "TUNER_AP_MIX3_PARTA",
                        },

                        [1] = {
                            -- 1: CircoLoco Records - Green EP.
                            -- Location: Arcade Bar Table.
                            ["stat_idx_station"] = 31709,
                            ["stat_idx_usb_stick"] = 31723,  -- Item ID 7.
                            ["name"] = "TUNER_AP_MIX3_PARTB",
                        },

                        [2] = {
                            -- 2: CircoLoco Records - Violet EP.
                            -- Location: Nightclub Office Table.
                            ["stat_idx_station"] = 31710,
                            ["stat_idx_usb_stick"] = 31726,  -- Item ID 10.
                            ["name"] = "TUNER_AP_MIX3_PARTC",
                        },

                        [3] = {
                            -- 3: CircoLoco Records - Black EP.
                            -- Location: LS Car Meet at Mechanic's Workbench.
                            ["stat_idx_station"] = 31711,
                            ["stat_idx_usb_stick"] = 31733,  -- Item ID 17.
                            ["name"] = "TUNER_AP_MIX3_PARTD",
                        },

                        [4] = {
                            -- 4: Moodymann - Kenny's Backyard Boogie.
                            -- Location: LS Car Meet in Moodymann's Car Trunk.
                            ["stat_idx_station"] = 31712,
                            ["stat_idx_usb_stick"] = 31758,  -- Item ID 18.
                            ["name"] = "TUNER_AP_MIX1",
                        },

                        [5] = {
                            -- 5: CircoLoco Records - CLR Launch Party (Seth Troxler).
                            -- Location: Automatically unlocked after getting all
                            -- four color EPs (which also gives the Circoloco Tee unlock).
                            -- NOTE: The game automatically sets this station's packed
                            -- stat to TRUE after collecting all 4 color EPs.
                            -- NOTE: This station doesn't have any USB stick in the world.
                            ["stat_idx_station"] = 31757,
                            ["stat_idx_usb_stick"] = nil,  -- DOESN'T HAVE ANY USB STICK ITEM.
                            ["name"] = "TUNER_AP_MIX2",
                        },

                        --[[ IMPORTANT: WE NEVER RESET THIS DEFAULT "OFF" STATION!
                        [6] = {
                            -- 6: "None" (off/no radio station).
                            -- This station is always available, and the stat-bool
                            -- is always FALSE since it cannot be "collected".
                            -- NOTE: This station doesn't have any USB stick in the world.
                            ["stat_idx_station"] = 31715,
                            ["stat_idx_usb_stick"] = nil,  -- DOESN'T HAVE ANY USB STICK ITEM.
                            ["name"] = "TUNER_AP_SILENCE_MUSIC",
                        },
                        ]]

                        [7] = {
                            -- 7: Dr. Dre.
                            -- Location: Player's Desk at F. Clinton and Partner, but only
                            -- becomes available after completing all Dr. Dre missions.
                            ["stat_idx_station"] = 32287,
                            ["stat_idx_usb_stick"] = 32294,  -- Item ID 0.
                            ["name"] = "RADIO_AP_DRE",
                        },

                        -- Yes, the 8th station is missing. The game files indicate that
                        -- it was originally planned as "FIXER_AP_LOWRIDERS_MIX" but was
                        -- removed from the game, and doesn't have any packed stat boolean.

                        [9] = {
                            -- 9: NEZ - You Wanna? (Single).
                            -- Location: Record A Studios Roof Terrace.
                            ["stat_idx_station"] = 31713,
                            ["stat_idx_usb_stick"] = 31732,  -- Item ID 16.
                            ["name"] = "FIXER_AP_DSCVRBl_MIX_1",
                        },

                        [10] = {
                            -- 10: NEZ ft. Schoolboy Q - Let's Get It (Single).
                            -- Location: Franklin's House Terrace.
                            ["stat_idx_station"] = 31714,
                            ["stat_idx_usb_stick"] = 31722,  -- Item ID 6.
                            ["name"] = "FIXER_AP_DSCVRBl_MIX_2",
                        },
                    }

                    -- Lock all of the USB media stations again.
                    -- NOTE: We don't lock any of the special rewards (such
                    -- as clothes) since those don't matter.
                    for station_idx, station_info in pairs(usb_stations) do
                        -- Lock the track list for that station.
                        -- NOTE: This doesn't have any visible changes regardless
                        -- of whether we lock/unlock a station here, and doesn't seem
                        -- necessary whatsoever. But we do it anyway, to perfectly
                        -- emulate how the game locks/unlocks USB media collectibles.
                        AUDIO.LOCK_RADIO_STATION_TRACK_LIST("RADIO_36_AUDIOPLAYER", station_info.name);

                        -- Lock the station from the Media Player again.
                        -- NOTE: Removes it from the inventory's Media Player list,
                        -- and makes it re-appear in the game world again.
                        STATS.SET_PACKED_STAT_BOOL_CODE(station_info.stat_idx_station, false, char_slot)

                        -- Make the associated USB stick visible in the world again.
                        -- NOTE: Some stations are unlocked via rewards, and are `nil` here.
                        -- NOTE: The stick stays invisible unless we also remove the
                        -- Media Player station's bool (above). Both control the world
                        -- object visibility together.
                        if station_info.stat_idx_usb_stick ~= nil then
                            STATS.SET_PACKED_STAT_BOOL_CODE(station_info.stat_idx_usb_stick, false, char_slot)
                        end
                    end

                    -- Remove the "Media Player" from the list of vehicle radio choices.
                    -- NOTE: Fresh online characters don't have it until they find a USB.
                    -- NOTE: The game calls this with "false" to unlock it every time
                    -- you find a USB media stick, so it will be unlocked again the
                    -- next time that you collect any USB stick.
                    -- NOTE: If the Media Player is currently selected, the game will
                    -- immediately select another vehicle radio station automatically.
                    AUDIO.LOCK_RADIO_STATION("RADIO_36_AUDIOPLAYER", true);
                end,
            },
        },
    }

    self.collectibles_keys = {}
    for collectible_type, instructions in pairs(self.collectibles) do
        tinsert(self.collectibles_keys, collectible_type)
    end
    tsort(self.collectibles_keys)
end


function CollectionManager:uncollect(to_reset, auto_restart)
    if self.collectibles == nil then error("Missing collectibles information."); end
    if type(to_reset) ~= "table" then error("Missing to_reset table."); end

    if not util.is_session_started() then
        util.toast("This feature only works in online sessions.")
        return false
    end

    if self.awaiting_restart then
        util.toast("Waiting for the game to restart...")
        return false
    end


    -- HOW COLLECTIBLES ARE TRACKED, AND HOW WE RESET THEM:
    --
    -- The game's official `freemode.c` scripts perform several actions when
    -- collecting an item:
    --
    -- * Sets that item's "packed bool" in the character save file to true,
    --   which controls whether that item is treated as collected, and
    --   whether it's visible in the world.
    -- * Sets a stat integer for that "collection type" in your character
    --   save file. Basically the "1/100 Action Figures collected" stats.
    -- * Updates a ton of flags and integers in the game client's in-memory
    --   state to remove the item from the world, increment the interaction
    --   menu's counter for that "Inventory Collection" type, etc.
    -- * Shows messages on screen about your progress, plays sounds, etc.
    -- * Triggers XP and GTA$ gains and sends a playstats message to the
    --   Rockstar servers, with information about which item you picked up,
    --   your progress (such as 1/100), and which game character slot you
    --   picked up the item on.
    -- * In the case of the USB media player, which is more complex than
    --   the other collectibles, there are also a few additional variables
    --   and states (see its custom function notes for details).
    --
    -- To reset the progress, the two most important things are the packed
    -- bool indicating the exact items you've collected, and the stat integer
    -- which says how many items you've collected overall of that type.
    -- They're both part of your character saves, and can be safely edited
    -- since the per-character saves are separate from the "account achievements".
    --
    -- Several collections end with unlocking certain game awards, such as
    -- new areas/pins on the map to indicate that you've completed something,
    -- or giving you the Highroller outfit for finding all 50 playing cards,
    -- or adding Avi Schwartzman as a Casino Heist crew member, but some of
    -- those unlocks automatically revert to locked simply via the packed
    -- bools; and others (such as outfit rewards) will stay unlocked even
    -- when the collectibles are reset. We won't re-lock the actual rewards,
    -- since there's no harm in keeping the rewards, and the player may be
    -- using them in outfits or for other purposes. The collectible code
    -- doesn't care if the player already has the rewards, and they will
    -- simply re-unlock the exact same reward variables when finishing the,
    -- hunt again. Since they already have the rewards, nothing will change.
    --
    -- All other game data seems to be temporary, in-memory data which is
    -- freshly reloaded from the cloud save every time GTA is restarted.
    --
    -- As for the Rockstar server "playstats", those are used as anticheat
    -- metrics, and they also control the account-wide achievements which are
    -- given out by Rockstar's servers to your social club's profile page,
    -- and they CANNOT be reset. But they don't matter.
    --
    -- In fact, constantly resetting your per-character unlocks and redoing
    -- the same collectibles is probably completely safe from a "playstats"
    -- perspective, since you're basically just doing what would also happen
    -- if you deleted your characters and made new ones and collected the
    -- items again. Although I wouldn't recommend repeatedly clearing
    -- collectibles and doing repeated "collectible RP drops" on the account,
    -- since THAT may trigger server-side detections of "too frequent playstats".


    -- Fetch the current multiplayer character slot (0 or 1).
    local char_slot = util.get_char_slot()

    -- Reset the chosen collectibles.
    local reset_count = 0
    for collectible_type, instructions in pairs(self.collectibles) do
        if tcontains(to_reset, collectible_type) == nil then pluto_continue; end
        reset_count += 1

        util.toast(strformat("Uncollecting: %s.", collectible_type))

        for _, instr in ipairs(instructions) do
            -- Determine what action we'll perform on each index.
            -- IMPORTANT: These actions write the changes to the user's save,
            -- but not to the currently active memory. User MUST restart the
            -- entire game to refresh the game/world state and character data.
            local cb = nil
            pluto_switch instr.type do
                pluto_case "function":
                    cb = instr.func
                    break
                pluto_case "packed_stat_bool":
                    cb = function(char_slot, stat_idx, new_value)
                        -- Set boolean stat to false (if no value provided).
                        if new_value == nil then new_value = false; end
                        STATS.SET_PACKED_STAT_BOOL_CODE(stat_idx, new_value, char_slot)
                    end
                    break
                pluto_case "stat_int":
                    cb = function(char_slot, stat_data, new_value)
                        -- Reset integer back to 0 (if no value provided).
                        if new_value == nil then new_value = 0; end
                        local stat_idx = nil
                        if type(stat_data) == "string" then
                            -- It's a string which needs the `mp0_` or `mp1_` prefix (lowercase).
                            stat_idx = strformat("mp%d_%s", char_slot, stat_data)
                        else
                            -- It's a table which must have two values, which
                            -- are either joaat strings or actual joaat hash numbers.
                            stat_idx = stat_data[char_slot + 1]  -- Tables are 1-indexed. Slot is 0 or 1.
                        end
                        if stat_idx == nil then
                            error(strformat("No stat_data for character slot %d.", char_slot))
                        end
                        if type(stat_idx) ~= "number" then
                            -- Convert hash name to integer.
                            stat_idx = util.joaat(stat_idx)
                        end
                        -- NOTE: Param 3 is named `BOOL save` in decompile, but the
                        -- actual native code doesn't seem to use that parameter,
                        -- so it doesn't seem like any cloud save is auto-triggered.
                        STATS.STAT_SET_INT(stat_idx, new_value, true);
                    end
                    break
                pluto_default:
                    error(strformat("Unsupported Instruction: %s", instr.type))
            end

            -- Execute the callback for every value.
            if instr.type == "function" then
                -- Just execute the instruction's function directly.
                cb(char_slot)
            else
                -- Process the given instruction for every memory value.
                pluto_switch instr.process do
                    pluto_case "range":
                        for value = instr.start, instr.end do
                            cb(char_slot, value, instr.new_value)
                        end
                        break
                    pluto_case "values":
                        for _, value in ipairs(instr.values) do
                            cb(char_slot, value, instr.new_value)
                        end
                        break
                    pluto_default:
                        error(strformat("Unsupported Process: %s", instr.process))
                end
            end
        end
    end

    if reset_count == 0 then
        util.toast("Please select which collectibles you want to reset.")
        return true
    end


    -- We MUST trigger a cloud save, to upload the new character save data.
    local save_ready = false
    for i = 1, 30 do
        -- Wait for up to 30s until the game is ready to do a cloud save.
        util.yield(1000)  -- Waits for a minimum of 1s no matter what, to ensure our tweaks have applied.
        util.toast(strformat("Step 1/3: Please wait... Preparing cloud save... %ds elapsed...", i))
        if NETWORK.NETWORK_IS_CLOUD_AVAILABLE()
            and (not STATS.STAT_LOAD_PENDING(-1))
            and (not STATS.STAT_SAVE_PENDING())
            and (not STATS.STAT_SAVE_PENDING_OR_REQUESTED()) then
                save_ready = true
                break
        end
    end
    if not save_ready then
        util.toast("Unable to begin cloud save. Game is busy.")
        return false
    end

    local save_finished = false
    menu.trigger_commands("forcecloudsave")
    for i = 1, 30 do
        -- Wait for up to 30s until the game has finished our cloud save.
        util.yield(1000)
        util.toast(strformat("Step 2/3: Please wait... Saving character data to cloud... %ds elapsed...", i))
        if (not STATS.STAT_LOAD_PENDING(-1))
            and (not STATS.STAT_SAVE_PENDING())
            and (not STATS.STAT_SAVE_PENDING_OR_REQUESTED()) then
                save_finished = true
                break
        end
    end
    if not save_finished then
        util.toast("Game saving seems to be stuck. Please try again later.")
        return false
    end


    -- Lastly, we need to completely wipe out the game's current, in-memory world
    -- state, which still remembers various bit-flags and states about the current
    -- collectibles. The ONLY 100% SAFE WAY to refresh the world is by restarting
    -- the entire game process, so that it reads the cloud save and makes the
    -- collectibles visible in the world again.
    -- NOTE: Doing an "Online Character Swap" seems to be reliable too, but MAY
    -- have some hidden game-state issues, and can also get STUCK on very slowly
    -- joining the random public session it picks after you choose a character,
    -- so it's definitely SAFEST to restart the entire game process instead.
    -- NOTE: Switching to another public session, or an invite-only, or going
    -- to story mode and then back online, DOESN'T WORK MOST OF THE TIME.
    if auto_restart then
        -- Trigger the game's "restart after benchmarking" API. It's only called
        -- by their benchmarking code, but works in online mode too and shows
        -- a black screen with "Disconnecting from GTA Online" and then quits.
        -- NOTE: We'll wait 5 more seconds, since we'll be really tight against
        -- the just-finished cloud save otherwise. Also gives them time to read.
        util.toast("Step 3/3: Collectibles have been reset! The game will now restart itself to load the new world state.")
        util.yield(5000)
        self.awaiting_restart = true
        MISC.RESTART_GAME()
    else
        -- Tell the user to restart manually.
        util.toast("Step 3/3: Collectibles have been reset! You MUST EXIT THE GAME COMPLETELY and restart GTA now! Press Alt-F4 and exit the game!")
    end

    return true
end


CollectionManager:init(menu.my_root())
