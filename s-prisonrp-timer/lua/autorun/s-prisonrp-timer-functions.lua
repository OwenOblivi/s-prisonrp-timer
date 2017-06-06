--[[-------------------------------------------------------------------------
Si tu vois ce message c'est que tu est surrement Développeur/Configurateur,

Sache que si tu cherche des backdoors ou autre chose, je ne mettrais rien 
	dans mes addons car je suis la pour aider la communauté à ce développer, 
						pas pour la detruit.

					Et n'oublie pas que je t'aime <3

Steam: 		https://steamcommunity.com/id/slownls/
Site Web:	http://slownls.fr
---------------------------------------------------------------------------]]

local ConvarPrisonRPTimerTime = CreateConVar( "S-PrisonRP-Timer:Time", 0)
local ConvarPrisonRPTimerPeriod = CreateConVar( "S-PrisonRP-Timer:Period", "Nil")

net.Receive("S-PrisonRP-Timer:TimeUpdate", function()
    PeriodTime = net.ReadFloat()
    ConvarPrisonRPTimerTime:SetInt( tonumber(PeriodTime) )
end)

net.Receive("S-PrisonRP-Timer:PeriodUpdate", function()
    PeriodName = net.ReadString()
    ConvarPrisonRPTimerPeriod:SetString( PeriodName )
end)

--[[-------------------------------------------------------------------------
								Timer Time
---------------------------------------------------------------------------]]

function GetPrisonRPTimerTime()
	return ConvarPrisonRPTimerTime:GetInt()
end

function SetPrisonRPTimeTime( time )
	ConvarPrisonRPTimerTime:SetInt( tonumber(time) )
end

--[[-------------------------------------------------------------------------
								Timer Period
---------------------------------------------------------------------------]]

function GetPrisonRPTimerPeriod()
	return ConvarPrisonRPTimerPeriod:GetString()
end

function SetPrisonRPTimePeriod( name )
	ConvarPrisonRPTimerPeriod:SetString( name )
end
--[[-------------------------------------------------------------------------
								Chat Command
---------------------------------------------------------------------------]]

function GetPrisonRPTimerChatCommand()
	return file.Read("s-prisonrp-timer/config/chatcommand.txt", "DATA")
end

function SetPrisonRPTimerChatCommand( value )
	file.Write("s-prisonrp-timer/config/chatcommand.txt", tonumber(value) )
end

--[[-------------------------------------------------------------------------
								HUD
---------------------------------------------------------------------------]]

function GetPrisonRPTimerHUD()
	return file.Read("s-prisonrp-timer/config/hud.txt", "DATA")
end

function SetPrisonRPTimerHUD( value )
	file.Write("s-prisonrp-timer/config/hud.txt", tonumber(value) )
end