--[[-------------------------------------------------------------------------
Si tu vois ce message c'est que tu est surrement Développeur/Configurateur,

Sache que si tu cherche des backdoors ou autre chose, je ne mettrais rien 
	dans mes addons car je suis la pour aider la communauté à ce développer, 
						pas pour la detruit.

					Et n'oublie pas que je t'aime <3

Steam: 		https://steamcommunity.com/id/slownls/
Site Web:	http://slownls.fr
---------------------------------------------------------------------------]]

AddCSLuaFile()

util.AddNetworkString("S-PrisonRP-Timer:OpenConfigMenu")
util.AddNetworkString("S-PrisonRP-Timer:ResetTimer")
util.AddNetworkString("S-PrisonRP-Timer:SaveConfig")
util.AddNetworkString("S-PrisonRP-Timer:AddPeriod")
util.AddNetworkString("S-PrisonRP-Timer:DelPeriod")
util.AddNetworkString("S-PrisonRP-Timer:TimeUpdate")
util.AddNetworkString("S-PrisonRP-Timer:PeriodUpdate")
util.AddNetworkString("S-PrisonRP-Timer:HUD")

local Periode =  {}
local TableNumber = 1
local Time = 0

timer.Simple(1,function()
	if !file.IsDir("s-prisonrp-timer","DATA") then
		file.CreateDir("s-prisonrp-timer")
		file.CreateDir("s-prisonrp-timer/config")
		file.Write("s-prisonrp-timer/config/chatcommand.txt","!timer")
		file.Write("s-prisonrp-timer/config/hud.txt","1")
		file.Write("s-prisonrp-timer/period.txt","[]")
	end
end)

hook.Add( "PlayerSay", "S-PrisonRP-Timer:OpenConfigMenu", function( ply, text, public )
	if ( text == GetPrisonRPTimerChatCommand() ) then
		if ply:IsSuperAdmin() then
			local Period = {}
			if file.Exists( "s-prisonrp-timer/period.txt", "DATA" ) then
				Period = util.JSONToTable(file.Read( "s-prisonrp-timer/period.txt" ))
			end

			net.Start('S-PrisonRP-Timer:OpenConfigMenu')
			net.WriteString(GetPrisonRPTimerChatCommand())
			net.WriteTable(Period)
			net.WriteFloat(tonumber(GetPrisonRPTimerHUD()))
			net.Send(ply)
		else
			ply:ChatPrint("You don't have access to this.")
		end

		return ""
	end
end)

net.Receive('S-PrisonRP-Timer:SaveConfig',function(lenght,ply)
	local NewCommand = net.ReadString()
	local HUDConfig = net.ReadFloat()

	if ply:IsSuperAdmin() then
		if NewCommand != GetPrisonRPTimerChatCommand() then
			SetPrisonRPTimerChatCommand( NewCommand )
		end
		
		if HUDConfig != GetPrisonRPTimerHUD() then
			SetPrisonRPTimerHUD( HUDConfig )
		end
	else
		ply:ChatPrint("You don't have access to this.")
	end

	if GetPrisonRPTimerHUD() == 1 then
		net.Start("S-PrisonRP-Timer:HUD")
		net.WriteFloat(GetPrisonRPTimerHUD())
		net.Broadcast()
	end
end)

net.Receive('S-PrisonRP-Timer:AddPeriod',function(lenght,ply)
	local PeriodID = tonumber(net.ReadFloat())
	local PeriodName = net.ReadString()
	local PeriodTime = net.ReadFloat()
	local Period = {}

	if ply:IsSuperAdmin() then
		local PrevID = PeriodID - 1 

		if file.Exists( "s-prisonrp-timer/period.txt", "DATA" ) then
			Period = util.JSONToTable(file.Read( "s-prisonrp-timer/period.txt" ))
		end	

		if type( PeriodID ) == "number" then
			if PeriodID > 0 && PeriodID <= 50 then
				if Period[PrevID] || PeriodID == 1 then
					Period[PeriodID] = {
						PName = PeriodName, 
						PTime = PeriodTime, 
					}
				
					file.Write("s-prisonrp-timer/period.txt", util.TableToJSON(Period))
				else
					ply:ChatPrint("You must put the identifiers in a row.")
				end
			else
				ply:ChatPrint("Please enter a number between 0 and 50.")
			end
		else
			ply:ChatPrint("Please enter a number between 0 and 50.")
		end
	else
		ply:ChatPrint("You don't have access to this.")
	end
end)

net.Receive('S-PrisonRP-Timer:DelPeriod',function(lenght,ply)
	local PeriodID = tonumber(net.ReadFloat())
	local Period = {}

	if ply:IsSuperAdmin() then
		if file.Exists( "s-prisonrp-timer/period.txt", "DATA" ) then
			Period = util.JSONToTable(file.Read( "s-prisonrp-timer/period.txt" ))
		end

		if Period[PeriodID] then
			Period[PeriodID] = nil
		end

		file.Write("s-prisonrp-timer/period.txt", util.TableToJSON(Period))
	else
		ply:ChatPrint("You don't have access to this.")
	end
end)

net.Receive('S-PrisonRP-Timer:ResetTimer',function(lenght,ply)
	if ply:IsSuperAdmin() then
		TableNumber = 1
		Time = 0
	end
end)

if file.Exists( "s-prisonrp-timer/period.txt", "DATA" ) then
	Periode = util.JSONToTable(file.Read( "s-prisonrp-timer/period.txt" ))
end

timer.Create("S-PrisonRP-Timer:Update", 1, 0, function()
	if file.Exists( "s-prisonrp-timer/period.txt", "DATA" ) then
		Periode = util.JSONToTable(file.Read( "s-prisonrp-timer/period.txt" ))
	end

	net.Start("S-PrisonRP-Timer:HUD")
	net.WriteFloat(GetPrisonRPTimerHUD())
	net.Broadcast()

	if not Periode[TableNumber] then
		TableNumber = Periode
		return
	end

	Time = Time + 1

	Periode[TableNumber].TimeLeft = Periode[TableNumber].PTime * 60 - Time

	if (Time > Periode[TableNumber].PTime * 60) then
		Time = 0

	 	if TableNumber > #Periode then
	    	TableNumber = 1
	  	else
	    	TableNumber = TableNumber + 1
	  	end

		if TableNumber == #Periode + 1 then 
			TableNumber = 1
		end

	    Periode[TableNumber].TimeLeft = Periode[TableNumber].PTime * 60
	  
	    net.Start("S-PrisonRP-Timer:PeriodUpdate")
	    net.WriteString(Periode[TableNumber].PName)
	    net.Broadcast()

	    net.Start("S-PrisonRP-Timer:TimeUpdate")
	    net.WriteFloat(Periode[TableNumber].TimeLeft)
	    net.Broadcast()
	else
	    net.Start("S-PrisonRP-Timer:PeriodUpdate")
	    net.WriteString(Periode[TableNumber].PName)
	    net.Broadcast()

	    net.Start("S-PrisonRP-Timer:TimeUpdate")
	    net.WriteFloat(Periode[TableNumber].TimeLeft)
	    net.Broadcast()
	end
end)