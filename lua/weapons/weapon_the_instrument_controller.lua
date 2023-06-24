SWEP.Base					= midifier_base_class
SWEP.Spawnable				= false

SWEP.SpeakerSize = 1
SWEP.SpeakerPos = Vector(0,0,0)
SWEP.SpeakerAng = Angle(0,0,0)
SWEP.HoldType = "normal"
if CLIENT then
	SWEP.ViewModelFOV 			= 0
end

function SWEP:ControllerDrawSpeaker(vm,wep,own,root_note,mode,sharp)
	if IsValid(own) then
		if not IsValid(self.Controller) then
			return
		end
		-- print(self:GetController())
		-- print(self:GetController())
		local scrnPos,scrnAng = LocalToWorld(self.SpeakerPos,self.SpeakerAng,self:GetController():GetPos(),self:GetController():GetAngles())
		cam.Start3D2D(scrnPos,scrnAng,1)
			-- print(scrnPos)
			self:DrawWorldModelMonitorScreen(mode,true,self.SpeakerSize,100,100)
		cam.End3D2D()
	end
end

-- function SWEP:Initialize()
	-- self:SetHoldType("normal")
-- end

function SWEP:SetController(ent)
	local veh = ent:GetParent()
	if IsValid(veh) then
		self.Controller = veh
	else
		self.Controller = ent
	end
end

function SWEP:GetController()
	return self.Controller
end

-- function SWEP:DrawWorldModel()
-- end

function SWEP:PostDrawViewModel(vm,wep,own)
	-- self:DrawWorldModel()
end

-- function SWEP:DrawModel(vm,wep,own)
	-- self:DrawWorldModel()
-- end