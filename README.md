# The Instrument - Virtual Synthesizer
The file 'weapon_the_instrument.lua' contains the bulk of the code


The most important functions are Prepare Instrument Sound, Emit Instrument Sound and Iterate Inputs:
```
function SWEP:IterateInputs(ply,start,stop)
	if stop == nil then
		stop = start
	end
	
	--Voice Chat
	
	local voice = input.IsKeyDown(KEY_LALT)
	
	
	
	if voice then
		if not self.VoiceEnabled then
			timer.Simple(0.05,function()permissions.EnableVoiceChat(true)end)
		end
		self.VoiceEnabled = true
	else
		if self.VoiceEnabled then
			timer.Simple(0.05,function()permissions.EnableVoiceChat(false)end)
		end
		self.VoiceEnabled = false
	end
	
	local update_last_beat = false
	local update_last_sub_beat_chords = false
	local update_last_sub_beat_notes = false
	local update_arp_note = false
	local arp_note_time = self.Config[self.setting_arp_delay]/self.Config[self.setting_arp_note_rate]

	for k,v in pairs(self.ChordKeys) do
		if not input.IsKeyDown(k) then
			self.ChordPressTimes[k] = CurTime()
		end
	end
	
	local most_recent_chord_key = 0
	local most_recent_chord_time = 0
	for k,time in pairs(self.ChordPressTimes) do
		if time > most_recent_chord_time and input.IsKeyDown(k) then
			most_recent_chord_key = k
			most_recent_chord_time = time
		end
	end
	
	
	local sharp = input.IsKeyDown(KEY_SPACE)
	
	
	local arp_dealy = self.Config[self.setting_arp_delay]
	
	local arp_chords = self.Config[self.setting_arp_chords]
	local arp_chord_rate = self.Config[self.setting_arp_chord_rate]
	
	local arp_note_rate = self.Config[self.setting_arp_note_rate]
	local arp_notes = self.Config[self.setting_arp_notes]
	
	
	for key = start,stop do
		if key == 57 then
			continue
		end
		if input.IsKeyDown(key) then
			self.PressedKeysHud[key] = true
			if self.KeyIsChord[key] then
				if arp_chords then
					if key == most_recent_chord_key then
						if self.LastBeat + arp_dealy <= CurTime() then
							self:PrepareInstrumentSound(key,sharp)
							self.LastArpChordTone = self.LastArpChordTone + 1
							self.PressedKeys[key] = true
							update_last_beat = true
						elseif self.LastSubBeatChords + arp_dealy/arp_chord_rate <= CurTime() then
							self:PrepareInstrumentSound(key,sharp)
							self.LastArpChordTone = self.LastArpChordTone + 1
							self.PressedKeys[key] = true
							update_last_sub_beat_chords = true
						end
					end
				else
					if not self.PressedKeys[key] then
						self:PrepareInstrumentSound(key,sharp)
						self.PressedKeys[key] = true
					end
				end
			else
				if arp_notes then
					if self.LastBeat + arp_dealy <= CurTime() then
						self:PrepareInstrumentSound(key,sharp)
						self.LastArpNoteTone = self.LastArpNoteTone + 1
						self.PressedKeys[key] = true
						update_last_beat = true
					elseif self.LastSubBeatNotes + arp_dealy/arp_note_rate <= CurTime() then
						self:PrepareInstrumentSound(key,sharp)
						self.LastArpNoteTone = self.LastArpNoteTone + 1
						self.PressedKeys[key] = true
						update_last_sub_beat_notes = true
					end
				else
					if not self.PressedKeys[key] then
						self:PrepareInstrumentSound(key,sharp)
						self.PressedKeys[key] = true
					end
				end
			end
			
		else
			self.PressedKeys[key] = false
			self.PressedKeysHud[key] = false
		end
	end
	if update_last_beat then
		self.LastBeat = CurTime()
		update_last_sub_beat_chords = true
		update_last_sub_beat_notes = true
	end
	if update_last_sub_beat_chords then
		self.LastSubBeatChords = CurTime()
	end
	if update_last_sub_beat_notes then
		self.LastSubBeatNotes = CurTime()
	end
end

function SWEP:PrepareInstrumentSound(key,sharp)
	local own = self:GetOwner()
	if IsValid(own) then
		local tbl = self.key_assignments[key]
		-- PrintTable(self.key_assignments)
		
		if tbl != nil then
			local root = self.Config[self.setting_root_note]
			local mode = self.Config[self.setting_mode]
			local root_dist = self.note_distances[root]
			local chord_raise = self.Config[self.setting_raise_chords]
			local bass_raise = self.Config[self.setting_raise_bass]
			if not self.KeyIsChord[key] then
				local dist = tbl[self.Config[self.setting_mode]]
				if dist != "" then
					local distnace_from_c4 = root_dist+dist
					
					if sharp then
						distnace_from_c4 = distnace_from_c4 + 1
					end
					
					local pitch,pitch_display = self:GetPitchFromDistance(distnace_from_c4)
					local degree = distance_degrees[mode][dist]
					-- print(root_dist,dist)
					-- LocalPlayer():ChatPrint("Trace 2")
					--PLAY NOTE
					self:EmitInstrumentSound(self.Config[self.setting_instrument_notes],pitch,distnace_from_c4,3,degree,pitch_display,self.Config[self.setting_vol_note])
					self.KeysLastPressed[distnace_from_c4] = CurTime()
					self:UpdateKeyPressTime(key)
				end
			else
				local last_arp_tone = self.LastArpChordTone
				
				chord = self.Config[tbl[1]]
				if chord != nil then
					local chord_degree = (chord[3]-mode)%7+1
					local mode_offset = self.ModeTable[mode][2]
					local chord_root = chord[1]+mode_offset
					
					chord_type = self.ChordTable[chord[2]]
					chord_tbl = chord_type[3]
					local chord_deg_tbl = chord_type[4]
					if chord_root != nil and chord_type != nil and chord_tbl != nil then
				
						local bass_distance_from_c4 = root_dist+chord_root
						local iters = 0
						while bass_distance_from_c4 >= root_dist-12 do
							bass_distance_from_c4 = bass_distance_from_c4-12
							iters = iters + 1
							if iters > self.tone_adjust_max_iters then
								break
							end
						end
						
						local num_tones = #chord_tbl
						local chord_tone_min_distance_from_c4 = root_dist-12
						local chord_tone_max_distance_from_c4 = root_dist+4
						for tone,tone_dist in pairs(chord_tbl) do
							local skip = false
							-- print(last_arp_tone,tone,last_arp_tone%(#chord_tbl))
							if self.Config[self.setting_arp_chords] and self.Config[self.setting_arp_scale] and last_arp_tone%(#chord_tbl) != tone-1 then
								skip = true
							end
							local distnace_from_c4 = chord_tone_min_distance_from_c4+chord_root+tone_dist
							
							if distnace_from_c4 >= root_dist then
								local adjusted_distance = distnace_from_c4-12
								if adjusted_distance >= chord_tone_min_distance_from_c4 then
									distnace_from_c4 = adjusted_distance
								end
							end
							
							if distnace_from_c4 <= bass_distance_from_c4 then
								distnace_from_c4 = distnace_from_c4 + 12
							end
							
							if chord_raise then
								distnace_from_c4 = distnace_from_c4 + 12
							end
							
							local pitch,pitch_display = self:GetPitchFromDistance(distnace_from_c4)
							local tone_degree = chord_deg_tbl[tone]
							
							local chord_degree_adjusted = (chord_degree+mode-1-1)%7+1
							local degree = chord_degree+tone_degree-1
							
							if not skip then
								self:EmitInstrumentSound(self.Config[self.setting_instrument_chord],pitch,distnace_from_c4,2,degree,pitch_display,self.Config[self.setting_vol_chord])
								self.KeysLastPressed[distnace_from_c4] = CurTime()
								self:UpdateKeyPressTime(key)
							end
							if tone == 1 and (not self.Config[self.setting_arp_chords] or last_arp_tone%(self.Config[self.setting_arp_bass_rate]*self.Config[self.setting_arp_chord_rate]) == 0) then
								local chord_inversion_distance_from_root = chord[4]
								if chord_inversion_distance_from_root != -100 then
									bass_distance_from_c4 = root_dist+chord_inversion_distance_from_root-24+mode_offset
								end
								local bass_distance_from_c4_adjusted = bass_distance_from_c4
								if bass_raise then
									bass_distance_from_c4_adjusted = bass_distance_from_c4_adjusted + 12
								end
								
								degree = chord_degree
								if chord[5] != -100 then
									degree = (chord[5]-mode)%7+1
								end
								
								local pitch,pitch_display = self:GetPitchFromDistance(bass_distance_from_c4_adjusted)
								--PLAY BASS
								self:EmitInstrumentSound(self.Config[self.setting_instrument_bass],pitch,bass_distance_from_c4_adjusted,1,degree,pitch_display,self.Config[self.setting_vol_bass])
								self.KeysLastPressed[bass_distance_from_c4_adjusted] = CurTime()
								self:UpdateKeyPressTime(key)
							end
						end
					end
				end
			end
		end
	end
end

function SWEP:EmitInstrumentSound(inst,pitch,dist,inst_id,degree,pitch_display,volume)
	local own = self:GetOwner()
	if not IsValid(own) then
		return
	end
	
	pitch = pitch*100
	local abs_pitch = pitch_display*100
	
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
	elseif pitch >= 200 and pitch < 400 then
		dir_suffix = "/c5.wav"
		pitch = pitch / 2
	elseif pitch >= 400 then
		dir_suffix = "/c6.wav"
		pitch = pitch / 4
	end
	
	local inst_tbl = self.Instruments[inst]
	if inst_tbl == nil then
		inst_tbl = self.Instruments[1]
	end
	sound_file = dir_prefix..inst_tbl[1]..dir_suffix
	
	
	local speaker = nil
	local pos = self:GetPos()
	if self:GetClass() == midifier_seat_class then
		speaker = self:GetController()
		if IsValid(speaker) then
			pos = speaker:WorldSpaceCenter()
		end
	end
	
	
	sound.Play(sound_file,pos,75,pitch,volume)
	self:SendInstrumentSoundToServer(sound_file,75,pitch,volume,CHAN_STATIC,own,abs_pitch,inst_id,degree,speaker)
	self:UpdatePitchFireTime(abs_pitch,degree)
	self:UpdateInstrumentFireTime(inst_id,abs_pitch,degree)
end

```
