AmiUI = {
    log = function(self, text) 
        cecho("AmiUI: " .. text .. "\n")
    end
}

AmiUI:log("Initializing AmiUI...")
tempTimer( 0, function () raiseEvent( "AmiUI.Loaded" ) end )