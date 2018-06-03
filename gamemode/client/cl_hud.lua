
function GM:HUDPaint()
	PaintStats()
end

function PaintStats()
	-- oxygen, temperature, ph, hunger, food, dnapoint
	
	local oxy = GetOxygen()
	local lvl, nextlevel, lastlevel = LocalPlayer():GetFoodLevel()
	local food = LocalPlayer():GetFood()
	local hung = LocalPlayer():GetHunger()
	surface.SetDrawColor(0,0,0, 200)
	surface.DrawRect(40, 40,100, 30)
	surface.DrawRect(40, 90,100, 30)
	surface.DrawRect(40, 90 + 50,100, 30)
	surface.SetDrawColor(255,255,255)
	surface.DrawRect(40, 40, (oxy/OXYGEN_MAX )* 100, 30)
	draw.SimpleText(oxy, "DermaDefault", 90, 55, Color(255,0,0), 1, 1)
	surface.DrawRect(40, 40 + 50, (hung/HUNGER_MAX)*100, 30)
	draw.SimpleText(hung, "DermaDefault", 90, 105, Color(255,0,0), 1, 1)
	
	surface.DrawRect(40, 40 + 100, ((food-lastlevel)/(nextlevel-lastlevel) )*100, 30)
	draw.SimpleText(lvl, "DermaDefault", 90, 155, Color(255,0,0), 1, 1)
end

function GM:CalcView( ply, pos, angles, fov)
	if !ply.FakeEntity then return end
	local view = {}
	view.pos = ply.FakeEntity:GetPos() - (ply:EyeAngles():Forward() * 100)
	view.angles = angles
	view.fov = fov
	return view
end
