local GM = require("Ami-UI.MDK.gradientmaker")

local initialise = function()
    AUITriggers.NameDB = AUITriggers.NameDB or {}
    db:create("AmiUI.NameDB", {
        namedb={
            name="",
            fullname="",
            level="",
            race="",
            faction="",
            city="",
            guild="",
            description="",
            kills="",
            deaths="",
            explorerrank="",
            rank="",
            _index={"name", "city"},
            _unique={"name"},
            _violations="REPLACE"
        }
    })
  
    AmiUI.NameDB = {
        db = db:get_database("AmiUI.NameDB"),
        colours = {
            gaudiguch = "#ad1d2d",
            celest = "#2997b7",
            serenwilde = "#00FF00",
            glomdoring = "#8C198C",
            magnagora = "#800000",
            hallifax = "#bbffff"
        },
        triggers = {},

        get = function (self, name) 
            local c = db:fetch(self.db.namedb, "name == '" .. name .. "'")
            if c then
              return c[1]
            end
        end,

        add = function (self, name)
            if self:get(name) == nil then
                AmiUI:log("No NameDB entry for " .. name .. ", downloading it now.")
                downloadFile(getMudletHomeDir().."/character-" .. name .. ".json", "https://api.lusternia.com/characters/" .. name .. ".json")
                return
            end

            if AUITriggers.NameDB[name] then
                killTrigger(AUITriggers.NameDB[name])
            end

            local trigger = function ()
                selectString(name, 1)
                local str, start, stop = getSelection()
                
                local character = self:get(name)
                
                local colour = self.colours[character.faction]
                
                if name == "Amirae" then
                    colour = "rainbow"
                end
                
                replace("")
                moveCursor(start, getLineNumber())
                
                if colour == "rainbow" then
                    hinsertText(GM.hgradient(name, {255,0,0}, {255,128,0}, {255,255,0}, {0,255,0}, {0,255,255}, {0,128,255}, {128,0,255}))
                elseif colour then
                    hinsertText(colour .. "" .. name)
                else
                    hinsertText(name)
                end
            end

            AUITriggers.NameDB[name] = tempTrigger(name, trigger)
        end
    }

    for _, c in ipairs(db:fetch(AmiUI.NameDB.db.namedb)) do
        AmiUI.NameDB:add(c.name)
    end

    local downloaded_character = function (_, filename) 
        if not filename:find("character") then return end

        local f, s, character = io.open(filename)

        if not f then return end

        character = f:read("*a")
        io.close(f)
        os.remove(filename)
        
        character = yajl.to_value(character)

        if not AmiUI.NameDB:get(character.name) or AmiUI.NameDB:get(character.name).faction ~= character.faction then
            hecho(AmiUI.NameDB.colours[character.faction] .. character.name .. " is from " .. character.faction .. ".\n")
        end

        db:add(AmiUI.NameDB.db.namedb, character)
        AmiUI.NameDB:add(character.name)
    end

    registerAnonymousEventHandler("sysDownloadDone", downloaded_character)
    
    local add_player = function ()
      AmiUI.NameDB:add(gmcp.Room.AddPlayer.name)
    end
    
    registerAnonymousEventHandler("gmcp.Room.AddPlayer", add_player)
end

registerAnonymousEventHandler("AmiUI.Loaded", initialise)