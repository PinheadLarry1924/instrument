# The Instrument - Virtual Synthesizer
The file 'weapon_the_instrument.lua' contains the bulk of the code


The most important function is Prepare Instrument Sound

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
					
					-- LocalPlayer():ChatPrint(tostring(chord_root))
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
							
							-- print(,tone_degree,"/n")
							local chord_degree_adjusted = (chord_degree+mode-1-1)%7+1
							local degree = chord_degree+tone_degree-1
							-- local degree = tone_degree
							-- PrintTable(distance_degrees)
							-- local degree = distance_degrees[mode][root_dist+tone_dist]
							
							if not skip then
								-- LocalPlayer():ChatPrint("Trace 2")
								--PLAY CHORD
								self:EmitInstrumentSound(self.Config[self.setting_instrument_chord],pitch,distnace_from_c4,2,degree,pitch_display,self.Config[self.setting_vol_chord])
								self.KeysLastPressed[distnace_from_c4] = CurTime()
								self:UpdateKeyPressTime(key)
							end
							if tone == 1 and (not self.Config[self.setting_arp_chords] or last_arp_tone%(self.Config[self.setting_arp_bass_rate]*self.Config[self.setting_arp_chord_rate]) == 0) then
								local chord_inversion_distance_from_root = chord[4]
								-- LocalPlayer():ChatPrint(tostring(chord_inversion_distance_from_root))
								if chord_inversion_distance_from_root != -100 then
									bass_distance_from_c4 = root_dist+chord_inversion_distance_from_root-24+mode_offset
								end
								-- LocalPlayer():ChatPrint(tostring(bass_distance_from_c4))
								-- if bass_distance_from_c4 < root_dist-24 then
									-- bass_distance_from_c4 = bass_distance_from_c4+12
								-- end
								local bass_distance_from_c4_adjusted = bass_distance_from_c4
								if bass_raise then
									bass_distance_from_c4_adjusted = bass_distance_from_c4_adjusted + 12
								end
								
								degree = chord_degree
								if chord[5] != -100 then
									degree = (chord[5]-mode)%7+1
								end
								
								local pitch,pitch_display = self:GetPitchFromDistance(bass_distance_from_c4_adjusted)
								-- local degree = distance_degrees[mode][tone_dist]
								-- LocalPlayer():ChatPrint("Trace 2")
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
