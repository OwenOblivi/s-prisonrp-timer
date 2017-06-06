--[[-------------------------------------------------------------------------
Si tu vois ce message c'est que tu est surrement Développeur/Configurateur,

Sache que si tu cherche des backdoors ou autre chose, je ne mettrais rien 
	dans mes addons car je suis la pour aider la communauté à ce développer, 
						pas pour la detruit.

					Et n'oublie pas que je t'aime <3

Steam: 		https://steamcommunity.com/id/slownls/
Site Web:	http://slownls.fr
---------------------------------------------------------------------------]]

surface.CreateFont("SlownLS-Font20", {
    font = "Arial", 
    size = 20, 
    weight = 2000
})

local Period = {}

net.Receive('S-PrisonRP-Timer:OpenConfigMenu',function()
	local ChatCommand = net.ReadString()
	local Period = net.ReadTable()
	local HUDConfig = net.ReadFloat()

	if LocalPlayer():IsSuperAdmin() then
		local Base = vgui.Create( "DFrame" )
		Base:SetSize( 500, 300 )
		Base:SetTitle('Timer configuration')
		Base:Center()
		Base:MakePopup()

		local Category = vgui.Create( "DPropertySheet", Base )
		Category:Dock( FILL )

		local PanelPeriod = vgui.Create( "DPanel", Category )
		PanelPeriod.Paint = function( self, w, h ) end
		Category:AddSheet( "Period", PanelPeriod, "icon16/application.png" )

		local PanelConfig = vgui.Create( "DPanel", Category )
		PanelConfig.Paint = function( self, w, h ) end
		Category:AddSheet( "Config", PanelConfig, "icon16/cog.png" )

	    PeriodListView = vgui.Create("DListView", PanelPeriod )
		PeriodListView:AddColumn("Period ID")
		PeriodListView:AddColumn("Period Name")
		PeriodListView:AddColumn("Period Time")
		PeriodListView:SetPos(5,5)
		PeriodListView:SetSize(Base:GetWide()-37,110)
		for k,v in pairs(Period) do
			PeriodListView:AddLine(k, v.PName, v.PTime .. " minutes")
		end
		PeriodListView.OnRowRightClick = function (self, lineID, line)
			local option = DermaMenu()
			option:SetParent(PeriodListView)
			option:Open()

			local DeleteLine = option:AddOption("Delete")
			DeleteLine:SetIcon("icon16/cross.png")

			function DeleteLine:DoClick()
				if PeriodListView:GetSelectedLine() then
					PeriodListView:RemoveLine(lineID)
					net.Start('S-PrisonRP-Timer:DelPeriod')
					net.WriteFloat( tonumber(line:GetColumnText(1)) )
					net.SendToServer()
				end
			end
		end

		local AddPeriodID = vgui.Create("DTextEntry", PanelPeriod )
		AddPeriodID:SetPos(5,120)
		AddPeriodID:SetSize(Base:GetWide()-37,20)
		AddPeriodID:SetValue("Enter period unique id...")
		AddPeriodID:SetNumeric(true)
		AddPeriodID.OnGetFocus = function(self)
			if self:GetText() == "Enter period unique id..." then
				self:SetText("")
			end
		end
		AddPeriodID.OnLoseFocus = function(self)
			if self:GetText() == "" then
				self:SetText("Enter period unique id...")
			end
		end	

		local AddPeriodName = vgui.Create("DTextEntry", PanelPeriod )
		AddPeriodName:SetPos(5,145)
		AddPeriodName:SetSize(Base:GetWide()-37,20)
		AddPeriodName:SetValue("Enter period name...")
		AddPeriodName.OnGetFocus = function(self)
			if self:GetText() == "Enter period name..." then
				self:SetText("")
			end
		end
		AddPeriodName.OnLoseFocus = function(self)
			if self:GetText() == "" then
				self:SetText("Enter period name...")
			end
		end	

		local AddPeriodTime = vgui.Create("DTextEntry", PanelPeriod )
		AddPeriodTime:SetPos(5,170)
		AddPeriodTime:SetSize(Base:GetWide()-37,20)
		AddPeriodTime:SetValue("Enter period time (minutes)...")
		AddPeriodTime:SetNumeric(true)
		AddPeriodTime.OnGetFocus = function(self)
			if self:GetText() == "Enter period time (minutes)..." then
				self:SetText("")
			end
		end
		AddPeriodTime.OnLoseFocus = function(self)
			if self:GetText() == "" then
				self:SetText("Enter period time (minutes)...")
			end
		end	

		local AddPeriod = vgui.Create( "DButton", PanelPeriod )
		AddPeriod:SetPos(5,195)
		AddPeriod:SetSize(Base:GetWide()-37,30)
		AddPeriod:SetText("Add")
		AddPeriod.DoClick = function()
			if AddPeriodID:GetValue() != "Enter period unique id..." && AddPeriodName:GetValue() != "Enter period name..." && AddPeriodTime:GetValue() != "Enter period time (minutes)..." then
				net.Start('S-PrisonRP-Timer:AddPeriod')
				net.WriteFloat(AddPeriodID:GetValue())
				net.WriteString(AddPeriodName:GetValue())
				net.WriteFloat(AddPeriodTime:GetValue())
				net.SendToServer()

				Base:Remove()
			end
		end

		--[[-------------------------------------------------------------------------
									Configuration partie
		---------------------------------------------------------------------------]]

		local CommandToOpenConfigPanel = vgui.Create("DLabel", PanelConfig )
		CommandToOpenConfigPanel:SetText("Command to open config panel:")
		CommandToOpenConfigPanel:SetFont('SlownLS-Font20')
		CommandToOpenConfigPanel:SetTextColor(color_white)
		CommandToOpenConfigPanel:SetSize(300,30)
		CommandToOpenConfigPanel:SetPos(5,5)

		local CommandToOpenConfigPanelDTextEntry = vgui.Create("DTextEntry", PanelConfig )
		CommandToOpenConfigPanelDTextEntry:SetPos(260,10)
		CommandToOpenConfigPanelDTextEntry:SetSize(150,20)
		CommandToOpenConfigPanelDTextEntry:SetValue(ChatCommand)
		CommandToOpenConfigPanelDTextEntry.OnGetFocus = function(self)
			if self:GetText() == ChatCommand then
				self:SetText("")
			end
		end
		CommandToOpenConfigPanelDTextEntry.OnLoseFocus = function(self)
			if self:GetText() == "" then
				self:SetText(ChatCommand)
			end
		end		

		local ActivateDisableDefaultTimerHUDText = vgui.Create("DLabel", PanelConfig )
		ActivateDisableDefaultTimerHUDText:SetText("Activate / Disable default Timer:")
		ActivateDisableDefaultTimerHUDText:SetFont('SlownLS-Font20')
		ActivateDisableDefaultTimerHUDText:SetTextColor(color_white)
		ActivateDisableDefaultTimerHUDText:SetSize(300,30)
		ActivateDisableDefaultTimerHUDText:SetPos(5,35)

		local ActivateDisableDefaultTimerHUD = vgui.Create( "DCheckBoxLabel", PanelConfig )
		ActivateDisableDefaultTimerHUD:SetPos( 260, 43 )
		ActivateDisableDefaultTimerHUD:SetText( "" )
		ActivateDisableDefaultTimerHUD:SetValue( HUDConfig )	
		ActivateDisableDefaultTimerHUD:SizeToContents()	

		local ConfigButtonSave = vgui.Create( "DButton", PanelConfig )
		ConfigButtonSave:SetPos(5,160)
		ConfigButtonSave:SetSize(Base:GetWide()-37,30)
		ConfigButtonSave:SetText("Reset Timer")
		ConfigButtonSave.DoClick = function()
			net.Start('S-PrisonRP-Timer:ResetTimer')
			net.SendToServer()
		end		

		local ConfigButtonSave = vgui.Create( "DButton", PanelConfig )
		ConfigButtonSave:SetPos(5,195)
		ConfigButtonSave:SetSize(Base:GetWide()-37,30)
		ConfigButtonSave:SetText("Save")
		ConfigButtonSave.DoClick = function()
			if CommandToOpenConfigPanelDTextEntry:GetValue() != "" then
				net.Start('S-PrisonRP-Timer:SaveConfig')
				net.WriteString(CommandToOpenConfigPanelDTextEntry:GetValue())
				if ActivateDisableDefaultTimerHUD:GetChecked() == true then
					net.WriteFloat(1)
				elseif ActivateDisableDefaultTimerHUD:GetChecked() == false then
					net.WriteFloat(0)
				end
				net.SendToServer()
			end
		end
	else
		LocalPlayer():ChatPrint("You don't have access to this.")
	end
end)

--[[-------------------------------------------------------------------------
							Default Timer Design
---------------------------------------------------------------------------]]

net.Receive("S-PrisonRP-Timer:HUD",function()
	local HUDActivate = net.ReadFloat()

	hook.Add("HUDPaint",'S-PrisonRP-Timer:HUD',function()
		if HUDActivate == 1 then
		    draw.RoundedBox(1, ScrW()-15-200, 15, 200, 90,  Color(245, 248, 250))

		    draw.RoundedBox(1, ScrW()-15-200, 15, 200, 25, Color(255, 255, 255))
		    draw.RoundedBox(1, ScrW()-15-200, 40, 200,1, Color(0, 0, 0, 80))

			draw.SimpleText("Current Tasks","SlownLS-Font20",ScrW()-170,18,color_black)
			draw.SimpleText("Name: " .. GetPrisonRPTimerPeriod(),"SlownLS-Font20",ScrW()-7-200,50,color_black)
			local PrisonRPTimeTime = string.FormattedTime( GetPrisonRPTimerTime(), "%02i:%02i" )
			draw.SimpleText("Time: " .. PrisonRPTimeTime .. " minute(s)","SlownLS-Font20",ScrW()-7-200,75,color_black)
		else
			hook.Remove("HUDPaint", "S-PrisonRP-Timer:HUD")
		end
	end)
end)