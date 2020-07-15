local TextGauges = require('Ami-UI.MDK.TextGauges')

local initialise = function()
    AmiUI.Gauges = {
        health = TextGauges:new(),
        mana = TextGauges:new(),
        ego = TextGauges:new(),
        power = TextGauges:new(),

        print = function (self, gauge) 
            AmiUI:log(self[gauge]:print())
        end
    }
end

if AUITriggers.Gauges then
    killAnonymousEventHandler(AUITriggers.Gauges)
end

AUITriggers.Gauges = registerAnonymousEventHandler("AmiUI.Loaded", initialise)