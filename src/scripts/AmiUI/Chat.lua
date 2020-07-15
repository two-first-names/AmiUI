local EMCO = require("Ami-UI.MDK.EMCO")

local initialise = function()
    local fontSize = 9
    local fontWidth, fontHeight = calcFontSize(fontSize)
    local width = 80

    AmiUI.Chat = EMCO:new({
        name = "AmiUI.Chat",
        x = width * fontWidth * -1,
        y = "0",
        width = width * fontWidth,
        height = "100%",
        allTab = true,
        allTabName = "All",
        gap = 2,
        consoles = {
          "All", 
          "Local",
          "City",
          "Guild",
          "Order",
          "Clans",
          "Misc",
          "Map",
        },
        mapTabName = "Map",
        mapTab = true,
        fontSize = fontSize
    })

    local capture_chat = function ()
        display(gmcp.Comm.Channel.Text)
    end

    registerAnonymousEventHandler("gmcp.Comm.Channel.Text", capture_chat)
end

registerAnonymousEventHandler("AmiUI.Loaded", initialise)