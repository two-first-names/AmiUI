local EMCO = require("Ami-UI.MDK.EMCO")

local initialise = function()
    local fontSize = 9
    local fontWidth, fontHeight = calcFontSize(fontSize)
    local width = 120

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
          "Tells",
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
    
    AmiUI.Chat.channels = {
      ct = "City",
      emotes = "Local",
      gt = "Guild",
      says = "Local",
      market = "Misc",
      newbie = "Misc",
      oto = "Order",
      otc = "Order",
    }

    local capture_chat = function ()
        local text = ansi2decho(gmcp.Comm.Channel.Text.text)
        local channel = AmiUI.Chat.channels[gmcp.Comm.Channel.Text.channel]
        if gmcp.Comm.Channel.Text.channel:match("clt") then channel = "Clans" end
        if gmcp.Comm.Channel.Text.channel:match("tell") then channel = "Tells" end
        if not channel then
          channel = "Misc"
          text = "(" .. gmcp.Comm.Channel.Text.channel .. ") " .. text
        end
        AmiUI.Chat:decho(channel, text .. "\n")
        if channel ~= "Local" then tempTrigger(text:gsub("<r><%w+,%w+,%w+:>", ""), function () deleteLine() end, true) end
    end
    
    if AUITriggers.chat then
      killAnonymousEventHandler(AUITriggers.chat)
    end
    
    AUITriggers.chat = registerAnonymousEventHandler("gmcp.Comm.Channel.Text", capture_chat)
end

AUITriggers = AUITriggers or {}

if AUITriggers.Chat then
    killAnonymousEventHandler(AUITriggers.Chat)
end

AUITriggers.Chat = registerAnonymousEventHandler("AmiUI.Loaded", initialise)