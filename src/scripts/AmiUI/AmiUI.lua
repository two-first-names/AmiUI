AmiUI = {
    log = function(self, text) 
        cecho("AmiUI: " .. text .. "\n")
    end
}

AUITriggers = AUITriggers or {}

AmiUI:log("Initializing AmiUI...")
tempTimer( 0, function () raiseEvent( "AmiUI.Loaded" ) end )