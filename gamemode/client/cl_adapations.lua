
function draw.SimpleTextOffest(str, txt, x,y, xalig, yalig, col1, col2)
	if !xalig then xalig = 0 end
	if !yalig then yalig = 0 end
	
	if !col1 then col1 = color_white end
	if !col2 then col2 = color_black end
	
	draw.SimpleText(str, txt, x+1, y+1, col2, xalig, yalig)
	draw.SimpleText(str, txt, x, y, col1, xalig, yalig)
end


function AdaptationsPanel()
	local pnl = vgui.Create("DFrame")
	pnl:SetSize(640, 380)
	pnl:Center()
	pnl:ShowCloseButton(false)
	pnl:MakePopup()
	pnl.Paint = function(self,w, h) 
		draw.SimpleTextOffest("DNA Points:"  .. LocalPlayer():GetDNA(), "DermaDefault",w-14, h-14, 2, 2)
	end
	local adapations = LocalPlayer():GetAdptations()
	local slotcount = ADAPTATIONS[LocalPlayer().stats["Body"]].slots
	
	pnl:SetAlpha(0)
	pnl:AlphaTo( 255, 0.5, 0, function(info, pnl) 
	end)
	
	adapationsscroll = vgui.Create("DScrollPanel", pnl)
	adapationsscroll:SetSize(640/2,640/2)
	local lastpos = 0
	local x = 1
	for index, info in pairs(adapations) do

		local pnl2 = vgui.Create("DButton", adapationsscroll)
		yy = 50
		pnl2:SetSize(315, yy)
		pnl2:SetText("")
		pnl2:SetPos(0,lastpos)
		pnl2.Paint = function(self, w,h)
			
			surface.SetDrawColor(255/2,255/2,255/2)
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor(255,255,255)
			surface.DrawOutlinedRect(0,0, w,h)
			surface.SetDrawColor(0,0,0)
			surface.DrawOutlinedRect(1,1,w-2,h-2)
			draw.SimpleTextOffest("Name:"  .. info.Name, "DermaDefault", 5, 5)
			draw.SimpleTextOffest("Cost: " .. info.cost, "DermaDefault", w-5, 5, 2, 2)
			draw.SimpleTextOffest("Desc: " .. info.desc, "DermaDefault", 5, 5+23)
			surface.SetDrawColor(255,255,255)
			surface.DrawLine(0,22, w,22)
		--	surface.SetDrawColor(255/2,255/2,255/2)
			surface.SetDrawColor(0,0,0)
			surface.DrawLine(1,21, w-2,21)
			surface.DrawLine(1,23, w-2,23)
			
		end
		pnl2.DoClick = function()
			SelectedItem = info
		end
		lastpos = lastpos + yy + 5
		x = x +1
	end
	slotscroll = vgui.Create("DScrollPanel", pnl)
	slotscroll:SetSize(640/2,640/2)
	slotscroll:SetPos(ScrW()/4)
	
	local NormalSlots = {
		[1] = "Body",
		[2] = "Teeth",
		[3] = "Fin",
		[4] = "Gullet",
	}
	
	local offest = 0
	for index, scar in pairs(NormalSlots) do
		local pnl2 = vgui.Create("DButton", slotscroll)
		yy = 50
		pnl2:SetSize(315, yy)
		
		if index == 1 then
			pnl2:SetPos(0,50* (index -1))
		else
		
			pnl2:SetPos(0,55* (index -1))
			offest = offest + 1
		
		end
		pnl2.Paint = function(self, w,h)
			surface.SetDrawColor(0,0,0)
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor(255,255,255)
			surface.DrawOutlinedRect(0,0, w,h)
			surface.SetDrawColor(255/2,255/2,255/2)
			surface.DrawOutlinedRect(1,1,w-2,h-2)
			draw.SimpleText(scar, "DermaDefault", 5, 5)
			surface.SetDrawColor(255,255,255)
			surface.DrawLine(0,22, w,22)
			surface.SetDrawColor(255/2,255/2,255/2)
			surface.DrawLine(1,21, w-2,21)
			surface.DrawLine(1,23, w-2,23)
			
			--draw.SimpleText("Adaptation: " .. LocalPlayer().stats.Body, "DermaDefault", 5, 28)
			draw.SimpleTextOffest("Adaptation: " .. LocalPlayer().stats[scar], "DermaDefault", 5, 28)
		end
		pnl2:SetText("")
		pnl2.DoClick = function()
			if !SelectedItem then
				chat.AddText(color_white, "You have not selected an adaptation for your creature!")
				return
			end
			if SelectedItem.type != scar then 
				chat.AddText(color_white, "You have not selected a " .. scar .." adaptation for your creature!")
				return
			end
			net.Start("Request_Adapations")
				net.WriteString(scar)
				net.WriteString(SelectedItem.Name)
			net.SendToServer()
		end
	end
	for index, info in pairs(slotcount) do
		local pnl2 = vgui.Create("DButton", slotscroll)
		yy = 50
		pnl2:SetSize(315, yy)
		pnl2:SetPos(0,55* (index + offest))
		pnl2.Paint = function(self, w,h)
			surface.SetDrawColor(0,0,0)
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor(255,255,255)
			surface.DrawOutlinedRect(0,0, w,h)
			surface.SetDrawColor(255/2,255/2,255/2)
			surface.DrawOutlinedRect(1,1,w-2,h-2)
			draw.SimpleText("Slot: "  .. index, "DermaDefault", 5, 5)
			surface.SetDrawColor(255,255,255)
			surface.DrawLine(0,22, w,22)
			surface.SetDrawColor(255/2,255/2,255/2)
			surface.DrawLine(1,21, w-2,21)
			surface.DrawLine(1,23, w-2,23)
			if LocalPlayer().stats[index] then
				draw.SimpleText("Equipped: " .. LocalPlayer().Stats[index].Name, "DermaDefault", 5, 28)
			else
				draw.SimpleText("Equipped: Nothing", "DermaDefault", 5, 28)
			end
			
		end
		pnl2:SetText("")
		pnl2.DoClick = function()
			if !SelectedItem then
				chat.AddText(color_white, "You have not selected an adaptation for your creature!")
			end
			if SelectedItem.type == "Body" then
				chat.AddText(color_white, "You have selected the wrong type of adaptation for this slot!")
			end
		end
	end
	
	
	QMENU = pnl
end
concommand.Add("adapations_test", AdaptationsPanel)


hook.Add("OnSpawnMenuOpen", "test", function()
	if IsValid(QMENU) then
		return
	end
	AdaptationsPanel()
end)

hook.Add("OnSpawnMenuClose", "test", function()
	if IsValid(QMENU) then
		QMENU:AlphaTo( 0, 0.25, 0, function(info, pnl) 
			pnl:Remove()
			QMENU = nil
	    end)
	end
end)


