midifier_base_class = "weapon_the_instrument"
midifier_seat_class = "weapon_the_instrument_controller"
midifier_amp_class = "sent_instrument_speaker"
midifier_amp_class_small = "sent_instrument_terminal"
midifier_controller_range = 196

local midifier_aim_pitch_base = -25

local plymeta = FindMetaTable("Player")

function plymeta:SetActiveInstrument(instrument)
	self.ActiveInstrument = instrument
end

function plymeta:ExitActiveInstrument()
	self.ActiveInstrument = nil
end

function plymeta:ToggleActiveInstrument(instrument)
	if self.ActiveInstrument == instrument then
		self.ActiveInstrument = nil
	else
		self.ActiveInstrument = instrument
	end
end

function plymeta:GetActiveInstrument()
	return self.ActiveInstrument
end

if SERVER then
	util.AddNetworkString("music_mode_force_player_enter")
	util.AddNetworkString("music_mode_toggle_player_state")
	util.AddNetworkString("music_mode_force_player_exit")
	util.AddNetworkString("music_mode_note_play_pitch_mod")
	util.AddNetworkString("music_mode_note_play_server")
	util.AddNetworkString("music_mode_note_play_client")
	-- util.AddNetworkString("music_swep_player_update_active_weapon")
	net.Receive("music_mode_note_play_pitch_mod",function(len,ply)
		local own = net.ReadEntity()
		local pitch = net.ReadInt(32)
		if IsValid(own) then
			local yaw = own:EyeAngles().y
			own:SetRenderAngles(Angle(pitch+midifier_aim_pitch_base,yaw,0))
		end
	end)
	net.Receive("music_mode_note_play_server",function(len,ply)
		local wep = net.ReadEntity()
		local own = net.ReadEntity()
		local sound_file = net.ReadString()
		local level = net.ReadInt(32)
		local pitch = net.ReadInt(32)
		local volume = net.ReadFloat()
		local channel = net.ReadInt(32)
		local abs_pitch = net.ReadFloat()
		local inst_id = net.ReadInt(32)
		local degree = net.ReadInt(32)
		local speaker = net.ReadEntity()
		-- print("Attempting to send sound")
		-- print(wep,own,sound_file,level,pitch,volume,channel)
		if IsValid(wep) and IsValid(own) and sound_file != nil and level != nil and pitch != nil and volume != nil and channel != nil then
			-- print("\tValidated sound variables")
			net.Start("music_mode_note_play_client")
				net.WriteEntity(wep)
				net.WriteEntity(own)
				net.WriteString(sound_file)
				net.WriteInt(level,32)
				net.WriteInt(pitch,32)
				net.WriteFloat(volume)
				net.WriteInt(channel,32)
				net.WriteFloat(abs_pitch)
				net.WriteInt(inst_id,32)
				net.WriteInt(degree,32)
				net.WriteEntity(speaker)
			net.Broadcast()
		end
	end)
else
	net.Receive("music_mode_note_play_client",function(len,ply)
		-- LocalPlayer():ChatPrint("Recieved Sound request")
		local wep = net.ReadEntity()
		local own = net.ReadEntity()
		local sound_file = net.ReadString()
		local level = net.ReadInt(32)
		local pitch = net.ReadInt(32)
		local volume = net.ReadFloat()
		local channel = net.ReadInt(32)
		local abs_pitch = net.ReadFloat()
		local inst_id = net.ReadInt(32)
		local degree = net.ReadInt(32)
		local speaker = net.ReadEntity(32)
		-- LocalPlayer():ChatPrint(tostring(wep))
		-- LocalPlayer():ChatPrint(tostring(own))
		-- LocalPlayer():ChatPrint(tostring(sound_file))
		-- -- LocalPlayer():ChatPrint(tostring(level))
		-- LocalPlayer():ChatPrint(tostring(pitch))
		-- LocalPlayer():ChatPrint(tostring(volume))
		-- LocalPlayer():ChatPrint(tostring(channel))
		if wep != nil and own != nil and IsValid(wep) and IsValid(own) and sound_file != nil and level != nil and pitch != nil and volume != nil and channel != nil then
			-- LocalPlayer():ChatPrint("Validated Client sound variables")
			if LocalPlayer() != own then
				local pos  = wep:GetPos()
				if speaker != nil and IsValid(speaker) then
					pos = speaker:WorldSpaceCenter()
				end
				-- LocalPlayer():ChatPrint("Playing Sound")
				-- wep:EmitSound(sound_file,level,pitch,volume,channel)
				sound.Play(sound_file,pos,75,pitch,volume)
				wep:UpdatePitchFireTime(abs_pitch,degree)
				wep:UpdateInstrumentFireTime(inst_id,abs_pitch,degree)
			end
		end
	end)
	net.Receive("music_mode_force_player_enter",function(len,ply)
		local own = net.ReadEntity()
		local instrument = net.ReadEntity()
		if IsValid(own) then
			own:SetActiveInstrument(instrument)
		end
	end)
	net.Receive("music_mode_toggle_player_state",function(len,ply)
		local own = net.ReadEntity()
		local instrument = net.ReadEntity()
		if IsValid(own) then
			own:ToggleActiveInstrument(instrument)
		end
	end)
	net.Receive("music_mode_force_player_exit",function(len,ply)
		local own = net.ReadEntity()
		if IsValid(own) then
			own:ExitActiveInstrument()
		end
	end)
	-- net.Receive("music_swep_player_update_active_weapon",function(len,ply)
		-- local own = net.ReadEntity()
		-- local wep = net.ReadEntity()
		-- if IsValid(own) and own:IsPlayer() and IsValid(wep) and wep:IsWeapon() then
			-- input.SelectWeapon(wep)
		-- end
	-- end)
end

hook.Add("PlayerSpawn","player_spawn_disable_music_mode",function(ply)
	net.Start("music_mode_force_player_exit")
		net.WriteEntity(ply)
	net.Send(ply)
end)

hook.Add("PlayerDeath","player_death_disable_music_mode",function(ply)
	net.Start("music_mode_force_player_exit")
		net.WriteEntity(ply)
	net.Send(ply)
end)

function plymeta:EmitInstrumentSound(dir,pitch,dist)
	local ang = -dist*1
	
	-- self:ChatPrint(tostring(ang))
	
	local EyeAng = self:EyeAngles()
	net.Start("music_mode_note_play_pitch_mod")
		net.WriteEntity(self)
		net.WriteInt(ang,32)
	net.SendToServer()
	
	local instrument = self.ActiveInstrument
	
	if not (instrument:GetClass() == midifier_base_class or instrument:GetClass() == midifier_seat_class) then
		return
	end
	
	if instrument:GetHasParentAmp() then
		local amp = instrument:GetParentAmp()
		if IsValid(amp) then
			instrument = amp
		end
	end
	
	dir_prefix = "instrument/"
	dir_suffix = "/c4.wav"
	
	if pitch < 50 then
		dir_suffix = "/c2.wav"
		pitch = pitch * 4
	elseif pitch >= 50 and pitch < 100 then
		dir_suffix = "/c3.wav"
		pitch = pitch * 2
	elseif pitch >= 100 and pitch < 200 then
		dir_suffix = "/c4.wav"
		-- pitch = pitch / 2
	elseif pitch >= 200 and pitch < 400 then
		dir_suffix = "/c5.wav"
		pitch = pitch / 2
	elseif pitch >= 400 then
		dir_suffix = "/c6.wav"
		pitch = pitch / 4
	end
	
	sound_file = dir_prefix..dir..dir_suffix
	-- print(pitch)
	instrument:EmitSound(sound_file,75,pitch,1,CHAN_STATIC)
end

local blocked_keys = {
	[KEY_MINUS] = true,
	[KEY_EQUAL] = true,
	[KEY_LALT] = true,
	-- [KEY_TAB] = true,
	[KEY_SPACE] = true
}

local blocked_binds = {
	["invnext"] = true,
	["invprev"] = true,
	["lastinv"] = true
}

hook.Add("PlayerBindPress","player_block_bindings_in_music_mode",function(ply,bind,pressed)
	local inst = ply:GetActiveWeapon()
	-- ply:ChatPrint(bind)
	if IsValid(inst) and (inst:GetClass() == midifier_base_class or inst:GetClass() == midifier_seat_class) and inst:GetEnabled() then
		local key = input.GetKeyCode(input.LookupBinding(bind,true))
		if (key >= KEY_0 and key <= KEY_SLASH) or blocked_keys[key] or blocked_binds[bind] then
			-- ply:ChatPrint(tostring(blocked_binds[bind]))
			return true
		end
	end
end)

hook.Add("PostDrawTranslucentRenderables","midi_controller_draw_wm_firstperson",function(bDepth,bSkybox)
	local ply = LocalPlayer()
	if IsValid(ply) then
		-- local wep = ply:GetActiveWeapon()
		-- if IsValid(wep) and wep:GetClass() == midifier_seat_class then
			-- wep:DrawWorldModel()
		-- end
		for k,wep in pairs(ents.FindByClass(midifier_seat_class)) do
			-- if v != wep then
			wep:DrawWorldModel()
			-- end
		end
	end
end)

hook.Add("PlayerCanPickupWeapon","instrument_block_double_pickup",function(ply,wep)
    if wep:GetClass() == midifier_base_class and ply:HasWeapon(wep:GetClass()) then
		return false
	end
end)
