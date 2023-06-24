AddCSLuaFile()
DEFINE_BASECLASS("base_anim")

ENT.PrintName = "Medium Instrument"
ENT.Author = "Pinhead Larry"
ENT.Information = "A playable Instrument that cannot be carried in the player's inventory"
ENT.Category = "Musical Instruments"

ENT.Editable = false
ENT.Spawnable = true
ENT.AdminOnly = false



ENT.BaseModel = "models/hunter/tubes/circle2x2.mdl"

function ENT:Initialize()
	self:SetModel(self.BaseModel)
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
	 
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
		self:SetUseType(SIMPLE_USE)
		local mdl = self:GetModel()
		if mdl != nil then
			local spawn_tbl = self.SpawnOffsets[self:GetModel()]
			if spawn_tbl != nil then
				local spawnpos,spawnang = LocalToWorld(spawn_tbl[1],spawn_tbl[2],self:GetPos(),self:GetAngles())
				self:SetPos(spawnpos)
				self:SetAngles(spawnang)
			end
		end
	end
end


if SERVER then
	util.AddNetworkString("MidinatorSetControllerClient")
	util.AddNetworkString("MidinatorControllerClearClient")
	util.AddNetworkString("MidinatorControllerSetClient")
	util.AddNetworkString("MidinatorControllerPlayerSelectWeapon")
else
	net.Receive("MidinatorSetControllerClient",function(len)
		local ent = net.ReadEntity()
		local wep = net.ReadEntity()
		print("MidinatorSetControllerClient",ent,wep)
		if IsValid(ent) and IsValid(wep) then
			wep:SetEnabled()
			wep:SetController(ent)
			ent:SetController(wep)
		end
	end)
	net.Receive("MidinatorControllerClearClient",function(len)
		local ent = net.ReadEntity()
		if IsValid(ent) and ent.ClearController != nil then
			ent:ClearController()
		end
	end)
	net.Receive("MidinatorControllerPlayerSelectWeapon",function(len)
		local ply = LocalPlayer()
		local cls = net.ReadString()
		-- LocalPlayer():ChatPrint("spawn")
		if IsValid(ply) then
			timer.Simple(0,function()
				local wep = ply:GetWeapon(cls)
				if wep != nil and IsValid(wep) then
					input.SelectWeapon(wep)
				end
			end)
		end
	end)
end

function ENT:SetController(wep)
	-- print("controller set")
	self.Controller = wep
end

function ENT:GetController()
	return self.Controller
end

function ENT:ClearController()
	self.Controller = nil
end

function ENT:Use(ply,caller)
	if self:GetController() == nil then
		local wep = ply:Give(midifier_seat_class)
		if IsValid(wep) then
			-- ply:SetActiveWeapon(wep)
			-- wep:SetEnabled()
			wep:SetController(self)
			self:SetController(wep)
			timer.Simple(1,function()
				if IsValid(self) and IsValid(wep) then
					net.Start("MidinatorSetControllerClient")
						net.WriteEntity(self)
						net.WriteEntity(wep)
					net.Broadcast()
				end
			end)
		end
	else
		ply:ChatPrint("Someone is already using this")
	end
end


ENT.ScreenInfo = {
	["models/hunter/tubes/circle2x2.mdl"] = {
		[1] = {Vector(-46.75,46.75,2),Angle(0,0,0),0.365,1},
		[2] = {Vector(-46.75,-46.75,-2),Angle(180,180,0),0.365,1}
	},
	["models/props_c17/streetsign001c.mdl"] = {
		[1] = {Vector(-11.5,0.5,-11.5),Angle(0,0,-90),0.09,1},
		[2] = {Vector(-11.5,-0.5,11.5),Angle(0,0,90),0.09,1}
	},
	["models/hunter/tubes/circle4x4.mdl"] = {
		[1] = {Vector(-93.5,93.5,2),Angle(0,0,0),0.73,1},
		[2] = {Vector(-93.5,-93.5,-2),Angle(180,180,0),0.73,1}
	}
}
ENT.SpawnOffsets = {
	["models/hunter/tubes/circle2x2.mdl"] = {
		Vector(0,0,0),
		Angle(0,0,0)
	},
	["models/props_c17/streetsign001c.mdl"] = {
		Vector(0,0,10),
		Angle(0,90,90)
	},
	["models/hunter/tubes/circle4x4.mdl"] = {
		Vector(0,0,0),
		Angle(0,0,0)
	}
}

ENT.degree_colors = {
	Color(255,0,0,255),
	Color(255,176,20,255),
	Color(228,221,15,255),
	Color(5,177,5,255),
	Color(64,128,255,255),
	Color(184,96,229,255),
	Color(255,96,203,255)
}



function ENT:Draw()
	self:SetMaterial("vgui/black")
	self:DrawModel()
	local ply = LocalPlayer()
	if not IsValid(ply) then
		return
	end
	if self:GetController() == nil then
		for screen = 1,2 do
			local scrn_tbl = self.ScreenInfo[self:GetModel()][screen]
			local scrnPos,scrnAng = LocalToWorld(scrn_tbl[1],scrn_tbl[2],self:GetPos(),self:GetAngles())
			cam.Start3D2D(scrnPos,scrnAng,scrn_tbl[3])
				DrawSpeakerCircle(220,220,Color(196,196,196),18,18,1)
				DrawSpeakerCircle(220,220*0.95,Color(0,0,0),18,18,1)
				DrawSpeakerCircle(220,220*0.85,Color(196,196,196),18,18,1)
				DrawSpeakerCircle(220,220*0.80,Color(0,0,0),18,18,1)
				DrawSpeakerCircle(220,220*0.35,Color(196,196,196),18,18,1)
				-- DrawSpeakerCircle(220,220*(1.00+math.Rand(0,0.2)),table.Random(self.degree_colors),18,18,1)
				-- DrawSpeakerCircle(220,220*0.95,Color(0,0,0),18,18,1)
				-- DrawSpeakerCircle(220,220*0.85,table.Random(self.degree_colors),18,18,1)
				-- DrawSpeakerCircle(220,220*(0.80-math.Rand(0,0.2)),Color(0,0,0),18,18,1)
				-- DrawSpeakerCircle(220,220*(0.35+math.Rand(0,0.2)),table.Random(self.degree_colors),18,18,1)
				-- draw.DrawText(self:GetController() or "text","RadioModelFont",0,0,Color(0,255,0,255),TEXT_ALIGN_CENTER)
			cam.End3D2D()
		end
	end
end

function ENT:Think()
	if SERVER then
		local controller = self:GetController()
		if not IsValid(controller) then
			self:ClearController()
			net.Start("MidinatorControllerClearClient")
				net.WriteEntity(self)
			net.Broadcast()
		else
			local own = controller:GetOwner()
			if IsValid(own) and own:IsPlayer() then
				own:SetActiveWeapon(controller)
				net.Start("MidinatorControllerPlayerSelectWeapon")
					net.WriteString(controller:GetClass())
				net.Send(own)
			end
		end
	end
end