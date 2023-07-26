--play intro sounds 6 times at once
--fix note arpeggiation rate :(

-- if SERVER then AddCSLuaFile("skins/windows95.lua") else include("skins/windows95.lua") end

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.MIDIFIER_DATA = "music_swep_user_settings.txt"
SWEP.MIDIFIER_TITLE = "The Instrument"
SWEP.HomeURL		= "https://www.hooktheory.com/theorytab"

SWEP.PrintName				= SWEP.MIDIFIER_TITLE		
SWEP.Author					= "Pinhead Larry"

SWEP.Category				= "Musical Instruments"

SWEP.Instructions			= ""

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.DrawCrosshair          = false
SWEP.NoSights               = true
SWEP.DrawAmmo 				= false
SWEP.DrawCrosshair          = false
SWEP.ViewModelFlip          = false

SWEP.UseHands               = true
SWEP.ViewModel              = Model("models/weapons/cstrike/c_c4.mdl")
SWEP.WorldModel             = Model("models/props_lab/monitor01b.mdl")
SWEP.HoldType				= "physgun"

if CLIENT then
	SWEP.ViewModelFOV 			= 35
	SWEP.BounceWeaponIcon		= false
	SWEP.WepSelectIcon 			= surface.GetTextureID("the_instrument/icon_the_instrument")
end

SWEP.GuitarCableLength = 256

SWEP.DrawTime = 0

function SWEP:SetupDataTables()
	self:NetworkVar("Entity",0,"ParentAmp")
	self:NetworkVar("Bool",1,"HasParentAmp")
	if SERVER then
		self:SetParentAmp(nil)
		self:SetHasParentAmp(false)
	end
end

function SWEP:Equip(own)
	if self:GetClass() == midifier_seat_class then
		timer.Simple(1,function()
			net.Start("MidinatorEnableClient")
				net.WriteEntity(own)
				net.WriteEntity(self)
			net.Send(own)
		end)
	end
end

SWEP.Primary.ClipSize       = 100
SWEP.Primary.DefaultClip    = 100
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "StriderMinigun"
SWEP.Primary.Delay          = 0.1

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.Delay        = 0.1

SWEP.ArpMin					= 0.25
SWEP.ArpMax					= 1.5
SWEP.ArpBassMin				= 1
SWEP.ArpBassMax				= 8
SWEP.ArpNoteMin				= 1
SWEP.ArpNoteMax				= 4
SWEP.ArpChordMin			= 1
SWEP.ArpChordMax			= 4

-- SWEP.pitch_ratios = {
	-- [0] = 1,
	-- [1] = 16/15,
	-- [2] = 9/8,
	-- [3] = 6/5,
	-- [4] = 5/4,
	-- [5] = 4/3,
	-- [6] = 45/32,
	-- [7] = 3/2,
	-- [8] = 8/5,
	-- [9] = 5/3,
	-- [10] = 7/4,
	-- [11] = 15/8,
	-- [12] = 2
-- }

SWEP.pitch_ratios = {
	[0] = 1,
	[1] = 16/15,
	[2] = 9/8,
	[3] = 600/501,
	[4] = 101/80,
	[5] = 4040/3000,
	[6] = 91/64,
	[7] = 3/2,
	[8] = 320/201,
	[9] = 101/60,
	[10] = 143/80,
	[11] = 303/160,
	[12] = 2
}

SWEP.pitch_ratios_display = {
	[0] = 1,
	[1] = 16/15,
	[2] = 9/8,
	[3] = 6/5,
	[4] = 5/4,
	[5] = 4/3,
	[6] = 45/32,
	[7] = 3/2,
	[8] = 8/5,
	[9] = 5/3,
	[10] = 7/4,
	[11] = 15/8,
	[12] = 2
}


for _,tbl in pairs({SWEP.pitch_ratios,SWEP.pitch_ratios_display}) do
	for i = 13,24 do
		tbl[i] = tbl[i-12]*2
	end
	for i = 25,36 do
		tbl[i] = tbl[i-24]*4
	end
	for i = -12,-1 do
		tbl[i] = tbl[i+12]/2
	end
	for i = -24,-13 do
		tbl[i] = tbl[i+24]/4
	end
	for i = -36,-25 do
		tbl[i] = tbl[i+36]/8
	end
end

function SWEP:GetPitchFromDistance(dist_from_c4)
	local pitch = self.pitch_ratios[dist_from_c4]
	local pitch_display = self.pitch_ratios_display[dist_from_c4]
	return pitch,pitch_display
end
-- PrintTable(SWEP.pitch_ratios)

SWEP.simple_note_names = {"A","B","C","D","E","F","G"}

SWEP.letter_numbers = {
	["A"] = 1,
	["B"] = 2,
	["C"] = 3,
	["D"] = 4,
	["E"] = 5,
	["F"] = 6,
	["G"] = 7
}
-- simple_note_names
-- local 

SWEP.note_names = {
	[-6]	= {"Abbb","Bbbbbb","Cxxx","Dxx","Ex","F#","Gb"},
	[-5]	= {"Abb","Bbbbb","Cbbbbb","D#xx","E#x","Fx","G"},
	[-4]	= {"Ab","Bbbb","Cbbbb","Dxxx","Exx","F#x","G#"},
	[-3]	= {"A","Bbb","Cbbb","Dbbbbb","E#xx","Fxx","Gx"},
	[-2]	= {"A#","Bb","Cbb","Dbbbb","Exxx","F#xx","G#x"},
	[-1]	= {"Ax","B","Cb","Dbbb","Ebbbbb","Fxxx","Gxx"},
	[0]		= {"A#x","B#","C","Dbb","Ebbbb","Fbbbbb","G#xx"},
	[1]		= {"Axx","Bx","C#","Db","Ebbb","Fbbbb","Gxxx"},
	[2]		= {"A#xx","B#x","Cx","D","Ebb","Fbbb","Gbbbbb"},
	[3]		= {"Axxx","Bxx","C#x","D#","Eb","Fbb","Gbbbb"},
	[4]		= {"Abbbbb","B#xx","Cxx","Dx","E","Fb","Gbbb"},
	[5]		= {"Abbbb","Bbbbbbb","C#xx","D#x","E#","F","Gbb"},
	[6]		= {"Abbb","Bbbbbb","Cxxx","Dxx","Ex","F#","Gb"}
}

SWEP.note_distances = {}

for distance,tbl in pairs(SWEP.note_names) do
	for _,name in pairs (tbl) do
		SWEP.note_distances[name] = distance
	end
end
SWEP.note_distances["F#"] = 6
-- print(SWEP.note_distances["F#"])

SWEP.ModeTable = {
	[1] = {"Major (Ionian)",0,0,"red"},
	[2] = {"Dorian",-2,-1,"orange"},
	[3] = {"Phrygian",-4,-2,"yellow"},
	[4] = {"Lydian",-5,-3,"green"},
	[5] = {"Mixolydian",5,3,"blue"},
	[6] = {"Minor (Aeolian)",3,2,"purple"},
	[7] = {"Locrian",1,1,"pink"}
}

SWEP.modes_from_names = {}
for k,v in pairs(SWEP.ModeTable) do
	SWEP.modes_from_names[v[1]] = k
end

-- PrintTable(SWEP.note_distances)

SWEP.table_of_usable_degrees = {
	{5,-6},
	{5,-5},
	{5,-4},
	{6,-4},
	{6,-3},
	{6,-2},
	{7,-2},
	{7,-1},
	{1,0},
	{1,1},
	{2,1},
	{2,2},
	{2,3},
	{3,3},
	{3,4},
	{4,5},
	{4,6}
}

SWEP.degree_colors = {
	Color(255,0,0,255),
	Color(255,176,20,255),
	Color(228,221,15,255),
	Color(5,177,5,255),
	Color(64,128,255,255),
	Color(184,96,229,255),
	Color(255,96,203,255)
}

--bullet color from in game menu
-- SWEP.degree_colors = {
	-- Color(250,113,113,255),
	-- Color(255,169,115,255),
	-- Color(251,204,113,255),
	-- Color(125,197,123,255),
	-- Color(113,182,251,255),
	-- Color(164,112,251,255),
	-- Color(252,127,251,255)
-- }
SWEP.title_indents = {
	-52,
	-43,
	-34,
	-34,
	-23,
	-16,
	-7,
	1,
	7,
	14,
	26,
	37,
	46,
	54
}

SWEP.root_distances = {
	["Gb"] = -6,
	["G"] = -5,
	["G#"] = -4,
	["Ab"] = -4,
	["A"] = -3,
	["A#"] = -2,
	["Bb"] = -2,
	["B"] = -1,
	["C"] = 0,
	["C#"] = 1,
	["Db"] = 1,
	["D"] = 2,
	["D#"] = 3,
	["Eb"] = 3,
	["E"] = 4,
	["F"] = 5,
	["F#"] = 6
}

SWEP.valid_roots = {
	"A","B","C","D","E","F","G",
	"A#","B#","C#","D#","E#","F#","G#",
	"Ab","Bb","Cb","Db","Eb","Fb","Gb"
}

SWEP.root_shortened_distances = {
	[-6] = "F#",
	[-5] = "G",
	[-4] = "Ab",
	[-3] = "A",
	[-2] = "Bb",
	[-1] = "B",
	[0] = "C",
	[1] = "Db",
	[2] = "D",
	[3] = "Eb",
	[4] = "E",
	[5] = "F",
	[6] = "F#"
}

function SWEP:GetNoteName(root,distance,degree)
	-- print(note_distance)
	if distance > 6 then
		distance = distance - 12
	elseif distance < -6 then
		distance = distance + 12
	end
	if distance > 6 then
		distance = distance - 12
	elseif distance < -6 then
		distance = distance + 12
	end
	
	local note_distance = self.note_distances[root]+distance
	
	if note_distance > 6 then
		note_distance = note_distance - 12
	elseif note_distance < -6 then
		note_distance = note_distance + 12
	end
	if note_distance > 6 then
		note_distance = note_distance - 12
	elseif note_distance < -6 then
		note_distance = note_distance + 12
	end
	-- print(distance,note_distance)
	-- print(note_distance)
	local root_letter_number = self.letter_numbers[root[1]]
	
	local degree_letter_number
	local degree_letter
		
	if isnumber(degree) then
		degree_letter_number = (root_letter_number + degree - 2)%7+1
		degree_letter = self.simple_note_names[degree_letter_number]	
	else
		degree_letter = degree
		degree_letter_number = self.letter_numbers[degree]
	end
	-- print(note_distance,degree_letter)
	local name = self.note_names[note_distance][degree_letter_number]
	return name
end


SWEP.icon_loud = "icon16/sound.png"
SWEP.icon_quiet = "icon16/sound_none.png"

local i_loud = SWEP.icon_loud
local i_quiet = SWEP.icon_quiet

SWEP.Instruments = {
	[1] = {"epiano","Electric Piano",{i_loud,i_loud,i_loud}},
	[2] = {"frenchhorn","French Horn",{i_quiet,i_loud,i_loud}},
	[3] = {"guitar","Guitar",{i_quiet,i_loud,i_loud}},
	[4] = {"harpsichord","Harpsichord",{i_loud,i_loud,i_loud}},
	[5] = {"musicbox","Music Box",{i_quiet,i_loud,i_loud}},
	[6] = {"organ","Organ",{i_loud,i_loud,i_loud}},
	[7] = {"pizzicato","Pizzicato",{i_quiet,i_loud,i_loud}},
	[8] = {"sitar","Sitar",{i_quiet,i_loud,i_loud}},
	[9] = {"steeldrum","Steel Drum",{i_quiet,i_loud,i_loud}},
	[10] = {"voice","Voice",{i_loud,i_loud,i_loud}},
	[11] = {"accordion","Accordion",{i_quiet,i_loud,i_loud}},
	[12] = {"strings","Strings",{i_quiet,i_loud,i_loud}},
	[13] = {"choir","Choir",{i_quiet,i_loud,i_loud}},
	[14] = {"bass","Bass",{i_loud,i_loud,i_loud}},
	[15] = {"piano","Piano",{i_loud,i_loud,i_loud}},
	[16] = {"flute","Flute",{i_quiet,i_loud,i_loud}},
	[17] = {"pungi","Pungi",{i_quiet,i_loud,i_loud}}
}

SWEP.ChordTable = {
	[1] = {"Major","Maj",{0,4,7},{1,3,5}},
	[2] = {"Minor","min",{0,3,7},{1,3,5}},
	[3] = {"7th (Dominant)","7th",{0,4,7,10},{1,3,5,7}},
	[4] = {"Major 7th","Maj7",{0,4,7,11},{1,3,5,7}},
	[5] = {"Minor 7th","min7",{0,3,7,10},{1,3,5,7}},
	[6] = {"Diminished","dim!o",{0,3,6},{1,3,5}},
	[7] = {"Augmented","Aug!+",{0,4,8},{1,3,5}},
	[8] = {"Perfect 5th","5th",{0,7},{1,5}},
	[9] = {"Suspended 4th","sus4",{0,5,7},{1,4,5}},
	[10] = {"Suspended 2nd","sus2",{0,2,7},{1,2,5}},
	[11] = {"Major 6th","Maj6",{0,3,7,9},{1,3,5,6}},
	[12] = {"Major 9th","Maj9",{0,4,7,15},{1,3,5,9}},
	[13] = {"Minor 9th","min9",{0,3,7,14},{1,3,5,9}}
}

SWEP.ChordStringTableKeys = {}

for key,tbl in pairs(SWEP.ChordTable) do
	SWEP.ChordStringTableKeys[tbl[1]] = key
end


SWEP.setting_chord_1 = 1
SWEP.setting_chord_2 = 2
SWEP.setting_chord_3 = 3
SWEP.setting_chord_4 = 4
SWEP.setting_chord_5 = 5
SWEP.setting_chord_6 = 6
SWEP.setting_chord_7 = 7
SWEP.setting_chord_8 = 8
SWEP.setting_chord_9 = 9
SWEP.setting_chord_10 = 10
SWEP.setting_chord_11 = 11
SWEP.setting_chord_12 = 12
SWEP.setting_root_note = 13
SWEP.setting_arp_delay = 14
SWEP.setting_arp_notes = 15
SWEP.setting_arp_chords = 16
SWEP.setting_arp_scale = 17
SWEP.setting_arp_interrupt = 18
SWEP.setting_arp_bass_rate = 19
SWEP.setting_note_order = 20
SWEP.setting_instrument_chord = 21
SWEP.setting_instrument_bass = 22
SWEP.setting_instrument_notes = 23
SWEP.setting_advanced_settings = 24
SWEP.setting_mode = 25
SWEP.setting_raise_chords = 26
SWEP.setting_raise_bass = 27
SWEP.setting_browser_open = 28
SWEP.setting_browser_url = 29
SWEP.setting_arp_note_rate = 30
SWEP.setting_vol_bass = 31
SWEP.setting_vol_chord = 32
SWEP.setting_vol_note = 33
SWEP.setting_edit_chord = 34
SWEP.setting_arp_chord_rate = 35

SWEP.Config = {
	[SWEP.setting_chord_1] = {11,6,7,-100,-100},
	[SWEP.setting_chord_2] = {3,1,3,-100,-100},
	[SWEP.setting_chord_3] = {10,1,7,-100,-100},
	[SWEP.setting_chord_4] = {5,1,4,-100,-100},
	[SWEP.setting_chord_5] = {0,1,1,-100,-100},
	[SWEP.setting_chord_6] = {7,1,5,-100,-100},
	[SWEP.setting_chord_7] = {2,2,2,-100,-100},
	[SWEP.setting_chord_8] = {9,2,6,-100,-100},
	[SWEP.setting_chord_9] = {4,2,3,-100,-100},
	[SWEP.setting_chord_10] = {2,1,2,-100,-100},
	[SWEP.setting_chord_11] = {9,1,6,-100,-100},
	[SWEP.setting_chord_12] = {4,1,3,-100,-100},
	[SWEP.setting_root_note] = "C",
	[SWEP.setting_arp_delay] = 0.5,
	[SWEP.setting_arp_notes] = false,
	[SWEP.setting_arp_chords] = false,
	[SWEP.setting_arp_scale] = true,
	[SWEP.setting_arp_interrupt] = true,
	[SWEP.setting_arp_bass_rate] = 1,
	[SWEP.setting_note_order] = 1,
	[SWEP.setting_instrument_chord] = 15,
	[SWEP.setting_instrument_bass] = 10,
	[SWEP.setting_instrument_notes] = 1,
	[SWEP.setting_advanced_settings] = false,
	[SWEP.setting_mode] = 1,
	[SWEP.setting_raise_chords] = false,
	[SWEP.setting_raise_bass] = false,
	[SWEP.setting_browser_open] = false,
	[SWEP.setting_browser_url] = SWEP.HomeURL,
	[SWEP.setting_arp_note_rate] = 4,
	[SWEP.setting_vol_bass] = 0.5,
	[SWEP.setting_vol_chord] = 0.5,
	[SWEP.setting_vol_note] = 0.5,
	[SWEP.setting_edit_chord] = false,
	[SWEP.setting_arp_chord_rate] = 2
}

SWEP.ConfigNames = {
	[SWEP.setting_chord_1] = "Chord 1",
	[SWEP.setting_chord_2] = "Chord 2",
	[SWEP.setting_chord_3] = "Chord 3",
	[SWEP.setting_chord_4] = "Chord 4",
	[SWEP.setting_chord_5] = "Chord 5",
	[SWEP.setting_chord_6] = "Chord 6",
	[SWEP.setting_chord_7] = "Chord 7",
	[SWEP.setting_chord_8] = "Chord 8",
	[SWEP.setting_chord_9] = "Chord 9",
	[SWEP.setting_chord_10] = "Chord 10",
	[SWEP.setting_chord_11] = "Chord 11",
	[SWEP.setting_chord_12] = "Chord 12",
	[SWEP.setting_root_note] = "Root Note",
	[SWEP.setting_arp_delay] = "ARP Dealy",
	[SWEP.setting_arp_notes] = "ARP Notes",
	[SWEP.setting_arp_chords] = "ARP Chords",
	[SWEP.setting_arp_scale] = "ARP Scale",
	[SWEP.setting_arp_interrupt] = "Arp Interrupt (unused)",
	[SWEP.setting_arp_bass_rate] = "ARP Bass Rate",
	[SWEP.setting_note_order] = "Note Order (unused)",
	[SWEP.setting_instrument_chord] = "Chord Instrument",
	[SWEP.setting_instrument_bass] = "Bass Instrument",
	[SWEP.setting_instrument_notes] = "Notes Instrument",
	[SWEP.setting_advanced_settings] = "Advanced Settings",
	[SWEP.setting_mode] = "Mode",
	[SWEP.setting_raise_chords] = "Raise Chords",
	[SWEP.setting_raise_bass] = "Rasise Bass",
	[SWEP.setting_browser_open] = "Browser Open",
	[SWEP.setting_browser_url] = "Browser URL",
	[SWEP.setting_arp_note_rate] = "ARP Note Rate",
	[SWEP.setting_vol_bass] = "Bass Volume",
	[SWEP.setting_vol_chord] = "Chord Volume",
	[SWEP.setting_vol_note] = "Note Volume",
	[SWEP.setting_edit_chord] = "Edit Chords",
	[SWEP.setting_arp_chord_rate] = "ARP Chord Rate"
}

SWEP.ChordTableNames = {
	[1] = "distance",
	[2] = "type",
	[3] = "degree",
	[4] = "inv. distance",
	[5] = "inv. degree"
}

SWEP.KeySettings = {SWEP.setting_root_note,SWEP.setting_mode}
SWEP.ChordSettings = {SWEP.setting_chord_1,SWEP.setting_chord_2,SWEP.setting_chord_3,SWEP.setting_chord_4,SWEP.setting_chord_5,SWEP.setting_chord_6,SWEP.setting_chord_7,SWEP.setting_chord_8,SWEP.setting_chord_9,SWEP.setting_chord_10,SWEP.setting_chord_11,SWEP.setting_chord_12}
SWEP.InstrumentSettings = {SWEP.setting_instrument_chord,SWEP.setting_instrument_bass,SWEP.setting_instrument_notes,SWEP.setting_vol_bass,SWEP.setting_vol_chord,SWEP.setting_vol_note}
SWEP.ARPSettings = {SWEP.setting_arp_delay,SWEP.setting_arp_notes,SWEP.setting_arp_chords,SWEP.setting_arp_scale,SWEP.setting_arp_bass_rate,SWEP.setting_arp_note_rate}

SWEP.BoolSettings = {}
for k,v in pairs(SWEP.Config) do
	if isbool(v) then
		table.insert(SWEP.BoolSettings,k)
	end
end

SWEP.ChordClipboard = SWEP.Config[SWEP.setting_chord_5]
SWEP.default_settings = table.Copy(SWEP.Config)

-- for k,v in pairs(SWEP.default_settings) do
	-- print(SWEP.ConfigNames[k].." "..tostring(v))
-- end

if CLIENT then
	function SWEP:RefreshSettingsMenu()
		if self.SettingsMenu != nil then
			self.SettingsMenu:Remove()
			self:ShowSettings()
		end
	end

	function SWEP:SaveSettings()
		local own = self:GetOwner()
		local ply = LocalPlayer()
		if IsValid(own) and IsValid(ply) and own == ply then
			local saved_settings = util.TableToJSON(self.Config)
			file.Write(self.MIDIFIER_DATA,saved_settings)
			if IsValid(LocalPlayer()) then
				LocalPlayer():ChatPrint(self.MIDIFIER_TITLE.." settings saved.")
			end
		end
	end

	function SWEP:ClearSettings()
		local tbl = self.default_settings
		for setting,value in pairs(tbl) do
			if setting == self.setting_browser_open or setting == self.setting_browser_url then
				continue
			end
			self:UpdateSetting(setting,value)
		end
		self:RefreshSettingsMenu()
	end

	function SWEP:ClearSettingCategory(settings)
		for _,setting in pairs(settings) do
			self:UpdateSetting(setting,self.default_settings[setting])
		end
		self:RefreshSettingsMenu()
	end
	
	SWEP.LoadedSettings = false
	
	function SWEP:ValidateSettings(tbl)
		local error_string = ""
		local errors = 0
		local loads = 0
		
		for i = self.setting_chord_1,self.setting_arp_chord_rate do
			if tbl[i] == nil then
				return self.default_settings,errors,error_string
			end
		end
		
		for setting = self.setting_chord_1,self.setting_chord_12 do
			local def_chord = self.default_settings[setting]
			
			local chord_tbl = tbl[setting]
			local chord_dist = chord_tbl[1]
			local chord_type = chord_tbl[2]
			local chord_degree = chord_tbl[3]
			local inv_dist = chord_tbl[4]
			local inv_degree = chord_tbl[5]
			
			if chord_dist < 0 or chord_dist > 11 then
				errors = errors + 1
				error_string = error_string..self.ConfigNames[setting].." "..self.ChordTableNames[1].." = "..tostring(chord_dist).."|"
				chord_dist = def_chord[1]
			end
			if self.ChordTable[chord_type] == nil then
				errors = errors + 1
				error_string = error_string..self.ConfigNames[setting].." "..self.ChordTableNames[2].." = "..tostring(chord_dist).."|"
				chord_type = def_chord[2]
			end
			if chord_degree < 1 or chord_degree > 7 then
				errors = errors + 1
				error_string = error_string..self.ConfigNames[setting].." "..self.ChordTableNames[3].." = "..tostring(chord_dist).."|"
				chord_degree = def_chord[3]
			end
			if (inv_dist < 0 or inv_dist > 11) and inv_dist != -100 then
				errors = errors + 1
				error_string = error_string..self.ConfigNames[setting].." "..self.ChordTableNames[4].." = "..tostring(chord_dist).."|"
				inv_dist = def_chord[4]
			end
			if (inv_degree < 1 or inv_degree > 7) and inv_dist != -100 then
				errors = errors + 1
				error_string = error_string..self.ConfigNames[setting].." "..self.ChordTableNames[5].." = "..tostring(chord_dist).."|"
				inv_degree = def_chord[5]
			end
		end
		
		if not table.HasValue(self.valid_roots,tbl[self.setting_root_note]) then
			errors = errors + 1
			error_string = error_string..self.ConfigNames[self.setting_root_note].." = "..tostring(tbl[self.setting_root_note]).."|"
			tbl[self.setting_root_note] = self.default_settings[self.setting_root_note]
		end
		
		if tbl[self.setting_arp_delay] < self.ArpMin or tbl[self.setting_arp_delay] > self.ArpMax then
			errors = errors + 1
			error_string = error_string..self.ConfigNames[self.setting_arp_delay].." = "..tostring(tbl[self.setting_arp_delay]).."|"
			tbl[self.setting_arp_delay] = self.default_settings[self.setting_arp_delay]
		end
		
		for _,setting in pairs(self.BoolSettings) do
			if not isbool(tbl[setting]) then
				errors = errors + 1
				error_string = error_string..self.ConfigNames[setting].." = "..tostring(tbl[setting]).."|"
				tbl[setting] = self.default_settings[setting]
			end
		end
		
		if tbl[self.setting_arp_bass_rate] < self.ArpBassMin or tbl[self.setting_arp_bass_rate] > self.ArpBassMax then
			errors = errors + 1
			error_string = error_string..self.ConfigNames[self.setting_arp_bass_rate].." = "..tostring(tbl[self.setting_arp_bass_rate]).."|"
			tbl[self.setting_arp_bass_rate] = self.default_settings[self.setting_arp_bass_rate]
		end
		
		for _,setting in pairs({self.setting_instrument_chord,self.setting_instrument_bass,self.setting_instrument_notes}) do
			local instrument = tbl[setting]
			if self.Instruments[instrument] == nil then
				errors = errors + 1
				error_string = error_string..self.ConfigNames[setting].." = "..tostring(tbl[setting]).."|"
				tbl[setting] = self.default_settings[setting]
			end
		end
		
		if tbl[self.setting_arp_note_rate] < self.ArpNoteMin or tbl[self.setting_arp_note_rate] > self.ArpNoteMax then
			errors = errors + 1
			error_string = error_string..self.ConfigNames[self.setting_arp_note_rate].." = "..tostring(tbl[self.setting_arp_note_rate]).."|"
			tbl[self.setting_arp_note_rate] = self.default_settings[self.setting_arp_note_rate]
		end
		
		if tbl[self.setting_arp_chord_rate] == nil or tbl[self.setting_arp_chord_rate] < self.ArpChordMin or tbl[self.setting_arp_chord_rate] > self.ArpChordMax then
			errors = errors + 1
			error_string = error_string..self.ConfigNames[self.setting_arp_chord_rate].." = "..tostring(tbl[self.setting_arp_chord_rate]).."|"
			tbl[self.setting_arp_chord_rate] = self.default_settings[self.setting_arp_chord_rate]
		end
		
		for _,setting in pairs({self.setting_vol_bass,self.setting_vol_chord,self.setting_vol_note}) do
			local vol = tbl[setting]
			if vol < 0 or vol > 1.0 then
				errors = errors + 1
				error_string = error_string..self.ConfigNames[setting].." = "..tostring(tbl[setting]).."|"
				tbl[setting] = self.default_settings[setting]
			end
		end
		
		if self.ModeTable[tbl[self.setting_mode]] == nil then
			errors = errors + 1
			error_string = error_string..self.ConfigNames[self.setting_mode].." = "..tostring(tbl[self.setting_mode]).."|"
			tbl[self.setting_mode] = self.default_settings[self.setting_mode]
		end
		-- for k,setting in pairs({self.setting_arp_bass_rate,self.setting_note_order,self.setting_instrument_chord,self.setting_instrument_bass,self.setting_instrument_notes,self.setting_mode}) do
			-- if not isnumber(tbl[setting]) then
				-- tbl[setting] = self.default_settings[setting]
			-- end
		-- end
		return tbl,errors,error_string
	end
	
	function SWEP:LoadSettings()
		local own = self:GetOwner()
		if not (IsValid(own) and IsValid(LocalPlayer()) and own == LocalPlayer()) then
			return
		end
		local JSON = file.Read(self.MIDIFIER_DATA,"DATA")
		if JSON == nil then
			JSON = util.TableToJSON(self.default_settings)
		end
		-- print(JSON)
		local tbl = util.JSONToTable(JSON)
		local message = ""
		if tbl == nil then
			tbl = self.default_settings
			message = self.MIDIFIER_TITLE.." settings corrupted, restoring defaults"
		else
			tbl,errors,error_string = self:ValidateSettings(tbl)
			message = "Restored "..self.MIDIFIER_TITLE.." settings with "..tostring(errors).." errors.\n"..error_string
		end
		-- PrintTable(tbl)
		--Primitive Settings validation (only works for numbers)
		
		
		for setting,value in pairs(tbl) do
			self:UpdateSetting(setting,value)
		end
		self.LoadedSettings = true
		self:RefreshSettingsMenu()
		if IsValid(LocalPlayer()) then
			LocalPlayer():ChatPrint(message)
		end
	end
	
	

end


function SWEP:OnRemove()
	local amp = self:GetParentAmp()
	local own = self:GetOwner()
	if IsValid(amp) and amp:GetClass() == midifier_amp_class then
		amp:ResetGuitarPlayer()
	end
	if CLIENT then
		local ply = LocalPlayer()
		if IsValid(own) and own:IsPlayer() and own == ply then
			self:SetDisabled()
			own:ConCommand("lastinv")
		end
		if self.LoadedSettings then
			self:SaveSettings()
		end
	end
end

SWEP.key_assignments = {
	[KEY_1] = {SWEP.setting_chord_1},
	[KEY_2] = {SWEP.setting_chord_2},
	[KEY_3] = {SWEP.setting_chord_3},
	[KEY_Q] = {SWEP.setting_chord_4},
	[KEY_W] = {SWEP.setting_chord_5},
	[KEY_E] = {SWEP.setting_chord_6},
	[KEY_A] = {SWEP.setting_chord_7},
	[KEY_S] = {SWEP.setting_chord_8},
	[KEY_D] = {SWEP.setting_chord_9},
	[KEY_Z] = {SWEP.setting_chord_10},
	[KEY_X] = {SWEP.setting_chord_11},
	[KEY_C] = {SWEP.setting_chord_12},
	
	[KEY_4] = {-24,-24,-24,-24,-24,-24,-24},
	[KEY_5] = {-22,-22,-23,-22,-22,-22,-23},
	[KEY_6] = {-20,-21,-21,-20,-20,-21,-21},
	[KEY_7] = {-19,-19,-19,-18,-19,-19,-19},
	[KEY_8] = {-17,-17,-17,-17,-17,-17,-18},
	[KEY_9] = {-15,-15,-16,-15,-15,-16,-16},
	[KEY_0] = {-13,-14,-14,-13,-14,-14,-14},
	
	[KEY_R] = {-12,-12,-12,-12,-12,-12,-12},
	[KEY_T] = {-10,-10,-11,-10,-10,-10,-11},
	[KEY_Y] = {-8,-9,-9,-8,-8,-9,-9},
	[KEY_U] = {-7,-7,-7,-6,-7,-7,-7},
	[KEY_I] = {-5,-5,-5,-5,-5,-5,-6},
	[KEY_O] = {-3,-3,-4,-3,-3,-4,-4},
	[KEY_P] = {-1,-2,-2,-1,-2,-2,-2},
	
	[KEY_F] = {0,0,0,0,0,0,0},
	[KEY_G] = {2,2,1,2,2,2,1},
	[KEY_H] = {4,3,3,4,4,3,3},
	[KEY_J] = {5,5,5,6,5,5,5},
	[KEY_K] = {7,7,7,7,7,7,6},
	[KEY_L] = {9,9,8,9,9,8,8},
	[KEY_SEMICOLON] = {11,10,10,11,10,10,10},
	
	[KEY_V] = {12,12,12,12,12,12,12},
	[KEY_B] = {14,14,13,14,14,14,13},
	[KEY_N] = {16,15,15,16,16,15,15},
	[KEY_M] = {17,17,17,18,17,17,17},
	[KEY_COMMA] = {19,19,19,19,19,19,18},
	[KEY_PERIOD] = {21,21,20,21,21,20,20},
	[KEY_SLASH] = {23,22,22,23,22,22,22}
}

SWEP.key_names = {
	[KEY_1] = "1",
	[KEY_2] = "2",
	[KEY_3] = "3",
	[KEY_Q] = "Q",
	[KEY_W] = "W",
	[KEY_E] = "E",
	[KEY_A] = "A",
	[KEY_S] = "S",
	[KEY_D] = "D",
	[KEY_Z] = "Z",
	[KEY_X] = "X",
	[KEY_C] = "C",
	
	[KEY_4] = "4",
	[KEY_5] = "5",
	[KEY_6] = "6",
	[KEY_7] = "7",
	[KEY_8] = "8",
	[KEY_9] = "9",
	[KEY_0] = "0",
	
	[KEY_R] = "R",
	[KEY_T] = "T",
	[KEY_Y] = "Y",
	[KEY_U] = "U",
	[KEY_I] = "I",
	[KEY_O] = "O",
	[KEY_P] = "P",
	
	[KEY_F] = "F",
	[KEY_G] = "G",
	[KEY_H] = "H",
	[KEY_J] = "J",
	[KEY_K] = "K",
	[KEY_L] = "L",
	[KEY_SEMICOLON] = ";",
	
	[KEY_V] = "V",
	[KEY_B] = "B",
	[KEY_N] = "N",
	[KEY_M] = "M",
	[KEY_COMMA] = "<",
	[KEY_PERIOD] = ">",
	[KEY_SLASH] = "?"
}

SWEP.note_keys = {
	KEY_4,KEY_5,KEY_6,KEY_7,KEY_8,KEY_9,KEY_0,KEY_R,KEY_T,KEY_Y,KEY_U,KEY_I,KEY_O,KEY_P,KEY_F,KEY_G,KEY_H,KEY_J,KEY_K,KEY_L,KEY_SEMICOLON,KEY_V,KEY_B,KEY_N,KEY_M,KEY_COMMA,KEY_PERIOD,KEY_SLASH,
}


SWEP.key_distances = {
}

for mode,_ in pairs(SWEP.ModeTable) do
	local key_distance_table = {}
	for k,key in pairs(SWEP.note_keys) do
		if SWEP.key_assignments[key][mode] != nil then
			key_distance_table[SWEP.key_assignments[key][mode]] = key
		end
	end
	SWEP.key_distances[mode] = key_distance_table
end

-- PrintTable(SWEP.key_distances)

SWEP.KeysLastPressed = {}
for i = -64,64 do
	SWEP.KeysLastPressed[i] = 0
end

SWEP.KeyIsChord = {}
SWEP.ChordKeys = {}

for k,v in pairs(SWEP.key_assignments) do
	if #v == 1 then
		SWEP.KeyIsChord[k] = true
		SWEP.ChordKeys[k] = true
	else
		SWEP.KeyIsChord[k] = false
	end
end

-- if CLIENT then
SWEP.chord_numbers = {
	[KEY_1] = 1,[KEY_2] = 2,[KEY_3] = 3,
	[KEY_Q] = 4,[KEY_W] = 5,[KEY_E] = 6,
	[KEY_A] = 7,[KEY_S] = 8,[KEY_D] = 9,
	[KEY_Z] = 10,[KEY_X] = 11,[KEY_C] = 12,
}

SWEP.chord_keys = {}
for k,v in pairs(SWEP.chord_numbers) do
	SWEP.chord_keys[v] = k
end

SWEP.key_degrees = {
	[KEY_4] = 1,[KEY_5] = 2,[KEY_6] = 3,[KEY_7] = 4,[KEY_8] = 5,[KEY_9] = 6,[KEY_0] = 7,
	[KEY_R] = 1,[KEY_T] = 2,[KEY_Y] = 3,[KEY_U] = 4,[KEY_I] = 5,[KEY_O] = 6,[KEY_P] = 7,
	[KEY_F] = 1,[KEY_G] = 2,[KEY_H] = 3,[KEY_J] = 4,[KEY_K] = 5,[KEY_L] = 6,[KEY_SEMICOLON] = 7,
	[KEY_V] = 1,[KEY_B] = 2,[KEY_N] = 3,[KEY_M] = 4,[KEY_COMMA] = 5,[KEY_PERIOD] = 6,[KEY_SLASH] = 7
}

local distance_degrees = {[1]={},[2]={},[3]={},[4]={},[5]={},[6]={},[7]={}}

for key,degree in pairs(SWEP.key_degrees) do
	for mode,distance in pairs(SWEP.key_assignments[key]) do
		distance_degrees[mode][distance] = degree
		if distance < 0 then
			distance_degrees[mode][distance-24] = degree
		elseif distance > 0 then
			distance_degrees[mode][distance+24] = degree
		end
	end
end
-- end

function SWEP:SendInstrumentSoundToServer(sound_file,level,pitch,volume,channel,own,abs_pitch,inst_id,degree,speaker)
	net.Start("music_mode_note_play_server")
		net.WriteEntity(self)
		net.WriteEntity(own)
		net.WriteString(sound_file)
		net.WriteInt(level,32)
		net.WriteInt(pitch,32)
		net.WriteFloat(volume)
		net.WriteInt(channel,32)
		net.WriteFloat(abs_pitch,32)
		net.WriteInt(inst_id,32)
		net.WriteInt(degree,32)
		net.WriteEntity(speaker)
	net.SendToServer()
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
		-- pitch = pitch / 2
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

function SWEP:UpdateKeyPressTime(key)
	local time = CurTime()
	self.KeyFireTime[key] = time
	-- net.Start("MidinatorUpdateKeyPressTime")
		-- net.WriteEntity(self)
		-- net.WriteInt(key,32)
		-- net.WriteFloat(time)
	-- net.SendToServer()
end

function SWEP:UpdatePitchFireTime(freq,degree)
	local time = CurTime()
	self.PitchFireTime[freq] = {time,degree}
	-- net.Start("MidinatorUpdatePitchFireTime")
		-- net.WriteEntity(self)
		-- net.WriteFloat(freq)
		-- net.WriteFloat(time)
	-- net.SendToServer()
end

function SWEP:UpdateInstrumentFireTime(inst_id,abs_pitch,degree)
	local time = CurTime()
	self.InstrumentFireTime[inst_id] = {time,abs_pitch,degree}
	-- net.Start("MidinatorUpdateInstrumentFireTime")
		-- net.WriteEntity(self)
		-- net.WriteInt(inst_id,32)
		-- net.WriteFloat(time)
	-- net.SendToServer()
end

SWEP.tone_adjust_max_iters = 5
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


SWEP.PressedKeys = {}
for i = 0,256 do
	SWEP.PressedKeys[i] = false
end

SWEP.PressedKeysHud = {}
for i = 0,256 do
	SWEP.PressedKeysHud[i] = false
end

SWEP.KeyFireTime = {}
for i = 0,256 do
	SWEP.KeyFireTime[i] = 0
end

SWEP.PitchFireTime = {}
SWEP.PitchDisplayTime = 1

SWEP.InstrumentFireTime = {{0,1,1},{0,1,1},{0,1,1}}
SWEP.InstrumentDisplayTime = 0.5

SWEP.LastBeat = 0
SWEP.LastSubBeatNotes = 0
SWEP.LastSubBeatChords = 0

SWEP.NextWholeBeat = 0
SWEP.NextHalfBeat = 0
SWEP.NextThirdBeat = 0
SWEP.NextQuarterBeat = 0

SWEP.LastArpChordTime = 0
SWEP.LastArpNoteTime = 0

SWEP.LastArpChordTone = 1
SWEP.LastArpNoteTone = 1

SWEP.MostRecentChordKey = nil

SWEP.VoiceEnabled = false

SWEP.ChordPressTimes = {}

-- SWEP.ChordRate = 2

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
	
	
	-- local one_chord_down = true
	-- for k,v in pairs(self.ChordKeys) do
		-- if input.IsKeyDown(k) then
			
			-- num_chords_down = num_chords_down + 1
		-- else
			-- self.ChordPressTimes[k] = CurTime()
		-- end
		-- if num_chords_down > 1 then
			-- one_chord_down = false
			-- break
		-- end
	-- end
	-- local num_chords_down = 0
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
	
	
	-- LocalPlayer():ChatPrint("recent: "..tostring(most_recent_chord_key))
	
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
			
			-- local will_arp = false
			-- if (self.Config[self.setting_arp_chords] and self.KeyIsChord[key] and self.MostRecentChordKey == key) or (self.Config[self.setting_arp_notes] and not self.KeyIsChord[key]) then
				-- will_arp = true
			-- end
			-- if self.KeyIsChord[key] and ((not self.PressedKeys[key]) or one_chord_down) then
				-- if self.Config[self.setting_arp_chords] then
					-- self.MostRecentChordKey = key
				-- else
					-- self.MostRecentChordKey = nil
				-- end
			-- end
			-- local arp_conditions = false
			-- if self.KeyIsChord[key] then
				-- arp_conditions = will_arp and ((self.LastArp + self.Config[self.setting_arp_delay]/self.Config[self.setting_arp_chord_rate]) < CurTime())
			-- else
				-- arp_conditions = will_arp and (self.LastArpNote + self.Config[self.setting_arp_delay]/self.Config[self.setting_arp_note_rate]) < CurTime()
			-- end
			
			
			
			-- if arp_conditions or not (self.PressedKeys[key] or will_arp or self.MostRecentChordKey == key) then
				
				-- self.PressedKeys[key] = true
				-- self:PrepareInstrumentSound(key,sharp)
				-- if arp_conditions then
					-- if self.KeyIsChord[key] then
						-- update_arp = true
					-- else
						-- update_arp_note = true
					-- end
				-- end
			-- end
			
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
	-- if update_arp then
		-- self.LastArp = CurTime()
		-- if (self.LastArpChordTone/self.Config[self.setting_arp_chord_rate])%self.Config[self.setting_arp_note_rate] == 0 then
			-- self.LastArpNote = CurTime()-arp_note_time
		-- end
		-- self.LastArpChordTone = self.LastArpChordTone + 1
	-- end
	-- if update_arp_note then
		-- self.LastArpNote = CurTime()
	-- end
end


SWEP.IsActive = false

function SWEP:SetEnabled()
	self.IsActive = true
	if CLIENT then
		if not self.LoadedSettings then
			self:LoadSettings()
		end
		self:RefreshChordsAnimation(true)
		self:RefreshNotesAnimation(true)
	end
end
function SWEP:SetDisabled()
	if CLIENT then
		if self:GetClass() == midifier_seat_class then
			-- self:Remove()
			net.Start("MidinatorRemoveOnServer")
				net.WriteEntity(self)
			net.SendToServer()
		end
	end
	self.IsActive = false
end
function SWEP:ToggleEnabled()
	if not self.IsActive then
		self:SetEnabled()
	else
		self:SetDisabled()
	end
end
function SWEP:GetEnabled()
	return self.IsActive
end

function SWEP:Think()
	local own = self:GetOwner()
	
	for freq,tbl in pairs(self.PitchFireTime) do
		local time = tbl[1]
		if CurTime()-time > self.PitchDisplayTime then
			table.remove(self.PitchFireTime,freq)
		end
	end
	
	if not IsValid(own) then
		return
	end
	
	if self:GetEnabled() then
		if CLIENT then
			self:IterateInputs(own,KEY_0,KEY_SLASH)
		end
	end
	if SERVER then
		if self:GetClass() == midifier_seat_class then
			local controller = self:GetController()
			if IsValid(controller) and midifier_controller_range != nil then
				if own:GetPos():Distance(controller:WorldSpaceCenter()) > midifier_controller_range then
					self:Remove()
				end
			else
				self:Remove()
			end
		end
	end
end

function SWEP:Holster(wep)
	if not IsFirstTimePredicted() then return end
	if SERVER then
		if self:GetClass() == midifier_seat_class then
			self:Remove()
		end
		local own = self:GetOwner()
		if IsValid(own) then
			self:SetDisabled()
			net.Start("music_mode_force_player_exit")
				net.WriteEntity(own)
			net.Send(own)
		end
	end
	return true
end

if CLIENT then
	function SWEP:RefreshChordsAnimation(order,time_delay)
		local time_diff = 0
		if time_delay == nil then
			time_delay = 0.1
		end
		if order then
			time_diff = 0.025
			time_delay = 0
		end
		for k,v in pairs(self.chord_numbers) do
			self.KeyFireTime[k] = CurTime()+v*time_diff+time_delay
		end
	end
	function SWEP:RefreshNotesAnimation(order,time_delay)
		local time_diff = 0
		if time_delay == nil then
			time_delay = 0.1
		end
		if order then
			time_diff = 0.05
			time_delayw = 0
		end
		for k,v in pairs(self.key_degrees) do
			self.KeyFireTime[k] = CurTime()+v*time_diff+time_delay
		end
	end
	
	SWEP.arp_settings = {
		[SWEP.setting_arp_notes] = {1,nil},
		[SWEP.setting_arp_note_rate] = {1,0.05},
		[SWEP.setting_arp_chords] = {2,nil},
		[SWEP.setting_arp_scale] = {2,nil},
		[SWEP.setting_arp_bass_rate] = {2,0.05},
		[SWEP.setting_arp_chord_rate] = {2,0.05}
	}
	function SWEP:UpdateSettingAnimation(setting,relative)
		if relative == nil then
			relative = false
		end
		
		if setting == self.setting_instrument_chord or setting == self.setting_instrument_bass then
			self:RefreshChordsAnimation(false)
		elseif setting == self.setting_instrument_notes then
			self:RefreshNotesAnimation(false)
		elseif setting == self.setting_root_note or setting == self.setting_mode then
			if not relative then
				self:RefreshChordsAnimation(true)
			end
			self:RefreshNotesAnimation(true)
		elseif setting >= 1 and setting <= 12 then
			self.KeyFireTime[self.chord_keys[setting]] = CurTime()+0.1
		elseif setting == self.setting_raise_chords or setting == self.setting_raise_bass then
			self:RefreshChordsAnimation(false)
		elseif self.arp_settings[setting] != nil then
			if self.arp_settings[setting][1] == 1 then
				self:RefreshNotesAnimation(false,self.arp_settings[setting][2])
			else			
				self:RefreshChordsAnimation(false,self.arp_settings[setting][2])
			end
		end
		
		
-- local self.setting_chord_1 = 1
-- local self.setting_chord_2 = 2
-- local self.setting_chord_3 = 3
-- local self.setting_chord_4 = 4
-- local self.setting_chord_5 = 5
-- local self.setting_chord_6 = 6
-- local self.setting_chord_7 = 7
-- local self.setting_chord_8 = 8
-- local self.setting_chord_9 = 9
-- local self.setting_chord_10 = 10
-- local self.setting_chord_11 = 11
-- local self.setting_chord_12 = 12
-- local self.setting_root_note = 13
-- local self.setting_note_order = 20
-- local self.setting_instrument_chord = 21
-- local self.setting_instrument_bass = 22
-- local self.setting_instrument_notes = 23
-- local self.setting_advanced_settings = 24
-- local self.setting_mode = 25
-- local self.setting_raise_chords = 26
-- local self.setting_raise_bass = 27
-- local self.setting_browser_open = 28
-- local self.setting_browser_url = 29
-- local self.setting_vol_bass = 31
-- local self.setting_vol_chord = 32
-- local self.setting_vol_note = 33
-- local self.setting_edit_chord = 34
		
		
	end
	function SWEP:UpdateSetting(index,value,relative)
		if relative == nil then
			relative = false
		end
		local own = self:GetOwner()
		if IsValid(own) and own:IsPlayer() then
			self.Config[index] = value
			self:UpdateSettingAnimation(index,relative)
			if isstring(value) then
				net.Start("MidinatorUpdateSettingString")
					net.WriteEntity(self)
					net.WriteInt(index,32)
					net.WriteString(value)
				net.SendToServer()
				-- print(value,value,value)
			elseif isnumber(value) then
				net.Start("MidinatorUpdateSettingNumber")
					net.WriteEntity(self)
					net.WriteInt(index,32)
					net.WriteFloat(value)
				net.SendToServer()
			elseif isbool(value) then
				net.Start("MidinatorUpdateSettingBool")
					net.WriteEntity(self)
					net.WriteInt(index,32)
					net.WriteBool(value)
				net.SendToServer()
			elseif istable(value) then
				net.Start("MidinatorUpdateSettingTable")
					net.WriteEntity(self)
					net.WriteInt(index,32)
					net.WriteInt(value[1],32)
					net.WriteInt(value[2],32)
					net.WriteInt(value[3],32)
					net.WriteInt(value[4],32)
					net.WriteInt(value[5],32)
				net.SendToServer()
			end
			-- PrintTable(self.Config)
		end
	end
end


if CLIENT then
	surface.CreateFont("SettingsMenuHelp",{font = "Roboto",extended = false,size = 30,weight = 1200,blursize = 0,scanlines = 0,antialias = true,underline = false,italic = false,strikeout = false,symbol = false,rotary = false,shadow = false,additive = false,outline = false})
	
	function DrawCategoryBox(parent,x,y,w,h,title,icon,title_length)
		local CatBGOutline = vgui.Create("DPanel",parent)
		CatBGOutline:SetPos(x,y)
		CatBGOutline:SetSize(w,h)
		CatBGOutline:SetBackgroundColor(Color(196,196,196))
		local CatBGFill = vgui.Create("DPanel",parent)
		CatBGFill:SetPos(x+1,y+1)
		CatBGFill:SetSize(w-2,h-2)
		CatBGFill:SetBackgroundColor(Color(120,124,127))
		local CatBGClip = vgui.Create("DPanel",parent)
		CatBGClip:SetPos(x+5,y-10)
		CatBGClip:SetSize(title_length,11)
		CatBGClip:SetBackgroundColor(Color(120,124,127))
		local CatLabel = vgui.Create("DLabel",parent)
		CatLabel:SetPos(x+30,y-11)
		CatLabel:SetText(title..":")
		local CatIcon = vgui.Create("DImage",parent)
		CatIcon:SetPos(x+10,y-9)
		CatIcon:SetSize(16,16)
		CatIcon:SetImage(icon)
		if title == "Edit Chords" then
			CatBGFill:SetBackgroundColor(Color(0,0,0))
			CatBGClip:SetBackgroundColor(Color(0,0,0))
		end
	end
end

if CLIENT then
	local sm_icon_size = 24

	local sm_chord_pos_x = 13
	local sm_chord_pos_y = 46
	local sm_chord_start_x = sm_chord_pos_x+11
	local sm_chord_start_y = sm_chord_pos_y+11
	local sm_chord_width = 72
	local sm_chord_height = sm_chord_width
	local sm_chord_gap_x = sm_chord_width/6
	local sm_chord_gap_y = sm_chord_gap_x
	local sm_chord_distance_x = sm_chord_width+sm_chord_gap_x
	local sm_chord_distance_y = sm_chord_height+sm_chord_gap_y
	local sm_chord_row_height = (sm_chord_height-sm_icon_size)/3
	
	local sm_chord_indent_x = 381

	local sm_reset_chord_start_x = 50
	local sm_reset_chord_start_y = 200
	local sm_reset_chord_width = sm_chord_row_height
	local sm_reset_chord_height = sm_reset_chord_width
	local sm_reset_chord_gap_x = sm_reset_chord_width/4
	local sm_reset_chord_gap_y = sm_reset_chord_gap_x
	local sm_reset_chord_distance_x = sm_reset_chord_width+sm_reset_chord_gap_x
	local sm_reset_chord_distance_y = sm_reset_chord_height+sm_reset_chord_gap_y

	local sm_no_inversion = "No Inver."

	local sm_row_indents = {
		[0] = 0,
		[1] = 0.5,
		[2] = 0.75,
		[3] = 1.25,
	}
	
	function SWEP:ShowSettings()
		local wep = self
		local edit_chords = wep.Config[wep.setting_edit_chord]
		local sm_offset_x = 0
		if not edit_chords then
			sm_offset_x = -sm_chord_indent_x
		end
		
		local browser_open = wep.Config[wep.setting_browser_open]
		
		local settings_menu_width = 737+sm_offset_x
		local settings_menu_height = 404
		local settings_menu_modal_width = 256
		local settings_menu_modal_height = 96
		local settings_menu_modal_button_width = 64
		local settings_menu_modal_button_height = 24
		
	
		local sm_key_pos_x = 390+sm_offset_x
		local sm_key_pos_y = 46
		local sm_misc_pos_x = 390+sm_offset_x
		local sm_misc_pos_y = 141
		local sm_inst_pos_x = 546+sm_offset_x
		local sm_inst_pos_y = 46
		local sm_arp_pos_x = 390+sm_offset_x
		local sm_arp_pos_y = 215
		local sm_file_pos_x = 606+sm_offset_x
		local sm_file_pos_y = 302
		local sm_web_pos_x = 606+sm_offset_x
		local sm_web_pos_y = 215
		local sm_state_pos_x = 407+sm_offset_x
		local sm_state_pos_y = 347
		
		local InstrumentTable = wep.Instruments
		
		if IsValid(wep.SettingsMenu) then
			wep.SettingsMenu:Remove()
		end
		
		wep.SettingsMenu = vgui.Create("DFrame")
		local SettingsMaster = wep.SettingsMenu
		-- SettingsMaster:SetSkin("Windows 95")
		SettingsMaster:SetSize(settings_menu_width,settings_menu_height)
		SettingsMaster:SetTitle("Configuration")
		SettingsMaster:SetIcon("icon16/music.png")
		SettingsMaster:MakePopup()
		SettingsMaster:Center()
		-- SettingsMaster:SetBGColor(Color(90,90,90))
		-- SettingsMaster:SetDraggable(true)
		local SettingsThinker = vgui.Create("DPanel",SettingsMaster)
		SettingsThinker:SetSize(settings_menu_width,settings_menu_height-24)
		SettingsThinker:SetPos(0,24)
		SettingsThinker:SetBackgroundColor(Color(88,88,88))
		SettingsThinker.Think = function(self)
			if not IsValid(wep) then
				SettingsMaster:Remove()
			end
		end
		
		local chord_edit_offset = 0
		if edit_chords then
			DrawCategoryBox(SettingsMaster,sm_chord_pos_x,sm_chord_pos_y,368,345,"Edit Chords","icon16/color_swatch.png",90)
		end
		DrawCategoryBox(SettingsMaster,sm_key_pos_x,sm_key_pos_y,147,76,"Key/Mode","icon16/key.png",80)
		DrawCategoryBox(SettingsMaster,sm_misc_pos_x,sm_misc_pos_y,147,54,"Chords","icon16/color_swatch.png",66)
		DrawCategoryBox(SettingsMaster,sm_inst_pos_x,sm_inst_pos_y,182,149,"Instruments","icon16/sound.png",90)
		DrawCategoryBox(SettingsMaster,sm_arp_pos_x,sm_arp_pos_y,207,119,"Repeater","icon16/control_fastforward_blue.png",77)
		DrawCategoryBox(SettingsMaster,sm_file_pos_x,sm_file_pos_y,122,89,"File","icon16/drive_disk.png",48)
		DrawCategoryBox(SettingsMaster,sm_web_pos_x,sm_web_pos_y,122,68,"Learn Songs","icon16/world.png",91)
		
		
		
		SettingsMaster.RebuildChordLabels = function(_,chord_number)
			if not edit_chords then
				return
			end
			if not IsValid(wep) then return end
			local mode = wep.Config[wep.setting_mode]
			
			local mode_distance_offset = wep.ModeTable[mode][2]
			local mode_degree_offset = wep.ModeTable[mode][3]
			local adv_settings = self.Config[wep.setting_advanced_settings]
			local chord = 1
			for y = 0,3 do
				for x = 0,2 do
					if chord_number == nil or chord == chord_number then
						for _,v in pairs(SettingsMaster:GetChildren()) do
							if v.ChordNumber == chord then
								v:Remove()
							end
						end
						local x_pos = sm_chord_start_x + x*sm_chord_distance_x + sm_row_indents[y]*sm_chord_distance_x
						local y_pos = sm_chord_start_y + y*sm_chord_distance_y
						local ChordBG = vgui.Create("DPanel",SettingsMaster)
						ChordBG:SetPos(x_pos,y_pos)
						ChordBG:SetSize(sm_chord_width,sm_chord_height)
						ChordBG.ChordNumber = chord
						
						
						local ChordRoot = vgui.Create("DComboBox",ChordBG)
						ChordRoot:SetPos(0,sm_icon_size)
						ChordRoot:SetSize(sm_chord_width,sm_chord_row_height)
						
						local root_distance = wep.Config[chord][1]+mode_distance_offset
						local root_degree = wep.Config[chord][3]+mode_degree_offset
						local inversion_root_distance = wep.Config[chord][4]
						if inversion_root_distance != -100 then
							inversion_root_distance = inversion_root_distance+mode_distance_offset
						end
						
						local inversion_root_degree = wep.Config[chord][5]
						if inversion_root_degree != -100 then
							inversion_root_degree = inversion_root_degree+mode_degree_offset
						end
						
						ChordRoot:SetSortItems(true)
						ChordRoot:SetValue(wep:GetNoteName(wep.Config[wep.setting_root_note],root_distance,root_degree))
						for k,v in pairs(wep.table_of_usable_degrees) do
							-- print(k+mode_degree_offsets[mode]-1%#table_of_usable_degrees+1)
							-- v = table_of_usable_degrees[(k+mode_degree_offsets[mode]-1)%#table_of_usable_degrees+1]
							-- print(v[1],(v[1]-(6-mode)+1)%7+1)
							ChordRoot:AddChoice(wep:GetNoteName(wep.Config[wep.setting_root_note],(v[2]+mode_distance_offset),(v[1]+mode_degree_offset-1)%7+1))
							-- ChordRoot:AddChoice(v[2])
						end
						-- print("")
						ChordRoot.ChordNumber = chord
						ChordRoot.OnSelect = function(self,index,value)
							if not IsValid(wep) then return end
							local mode = wep.Config[wep.setting_mode]
							
							local mode_distance_offset = wep.ModeTable[mode][2]
							local mode_degree_offset = wep.ModeTable[mode][3]
							local value_distance = wep.note_distances[value] - wep.note_distances[wep.Config[wep.setting_root_note]]
							
							local chord_settings = wep.Config[ChordRoot.ChordNumber]
							-- chord_settings[1] = (wep.note_distances[value] + note_distances[wep.Config[wep.setting_root_note]]+mode_distance_offset-1)%12+1
							chord_settings[1] = (wep.note_distances[value] - wep.note_distances[wep.Config[wep.setting_root_note]]-mode_distance_offset)%12
							-- LocalPlayer():ChatPrint(tostring(chord_settings[1]))
							local root_number = wep.letter_numbers[wep.Config[wep.setting_root_note][1]]
							local note_number = wep.letter_numbers[value[1]]
							chord_settings[3] = (note_number - root_number-mode_degree_offset)%7+1
							chord_settings[4] = -100
							chord_settings[5] = -100
							wep:UpdateSetting(ChordRoot.ChordNumber,chord_settings)
							SettingsMaster:RebuildChordLabels(ChordRoot.ChordNumber)
							-- if IsValid(ChordBG.ChordCover) and ChordBG.ChordCover.ChordNumber == self.ChordNumber then
								-- ChordBG.ChordCover:Remove()
							-- end
						end
						local ChordType = vgui.Create("DComboBox",ChordBG)
						ChordType:SetPos(0,sm_icon_size+sm_chord_row_height)
						ChordType:SetSize(sm_chord_width,sm_chord_row_height)
						ChordType:SetValue(wep.ChordTable[wep.Config[chord][2]][1])
						ChordType:SetSortItems(false)
						for k = 1,#wep.ChordTable do
							local v = wep.ChordTable[k]
							ChordType:AddChoice(v[1])
						end
						ChordType.ChordNumber = chord
						ChordType.OnSelect = function(_,index,value)	
							if not IsValid(wep) then return end
							local chord_settings = wep.Config[ChordRoot.ChordNumber]
							chord_settings[2] = wep.ChordStringTableKeys[value]
							wep:UpdateSetting(ChordType.ChordNumber,chord_settings)
							SettingsMaster:RebuildChordLabels(ChordType.ChordNumber)
						end
						-- local ChordRootLock = vgui.Create("DButton",ChordBG)
						-- ChordRootLock:SetPos(sm_chord_row_height*2,sm_chord_row_height*2)
						-- ChordRootLock:SetSize(sm_chord_row_height,sm_chord_row_height)
						-- ChordRootLock:SetText("")
						-- ChordRootLock:SetImage("icon16/lock.png")
						local ChordInversion = vgui.Create("DComboBox",ChordBG)
						ChordInversion.BaseRoot = ChordRoot
						ChordInversion:SetPos(0,sm_icon_size+sm_chord_row_height*2)
						ChordInversion:SetSize(sm_chord_width,sm_chord_row_height)
						ChordInversion:SetSortItems(true)
						ChordInversion:AddChoice(sm_no_inversion)
						for k,v in pairs(wep.table_of_usable_degrees) do
							ChordInversion:AddChoice(wep:GetNoteName(wep.Config[wep.setting_root_note],(v[2]+mode_distance_offset),(v[1]+mode_degree_offset-1)%7+1))
						end
						if inversion_root_distance == -100 then
							ChordInversion:SetValue(sm_no_inversion)
						else
							ChordInversion:SetValue(wep:GetNoteName(wep.Config[wep.setting_root_note],inversion_root_distance,inversion_root_degree))
						end
						ChordInversion:SetEnabled(adv_settings)
						if not adv_settings then
							ChordInversion:SetToolTip("Enable Adv. Settings (bottom left)")
						end
						ChordInversion.ChordNumber = chord
						ChordInversion.OnSelect = function(_,index,value)
							if not IsValid(wep) then return end
							local mode = wep.Config[wep.setting_mode]
							local mode_distance_offset = wep.ModeTable[mode][2]
							local mode_degree_offset = wep.ModeTable[mode][3]
							
							local chord_settings = wep.Config[ChordInversion.ChordNumber]
							-- if value == sm_no_inversion or (wep.note_distances[value] - wep.note_distances[wep.Config[wep.setting_root_note]]) == chord_settings[1] or (wep.note_distances[value] - wep.note_distances[wep.Config[wep.setting_root_note]])+12-mode_distance_offset == chord_settings[1] then
							if value == sm_no_inversion or (_.BaseRoot != nil and value == _.BaseRoot:GetValue()) then
								chord_settings[4] = -100
								chord_settings[5] = -100
								wep:UpdateSetting(ChordInversion.ChordNumber,chord_settings)
								_:SetValue(sm_no_inversion)
							else
								local value_distance = (wep.note_distances[value] - wep.note_distances[wep.Config[wep.setting_root_note]] - 1)%12+1
								chord_settings[4] = (wep.note_distances[value] - wep.note_distances[wep.Config[wep.setting_root_note]]-mode_distance_offset)%12
								-- LocalPlayer():ChatPrint(tostring(chord_settings[1]))
								local root_number = wep.letter_numbers[wep.Config[wep.setting_root_note][1]]
								local note_number = wep.letter_numbers[value[1]]
								chord_settings[5] = (note_number - root_number-mode_degree_offset)%7+1
								wep:UpdateSetting(ChordInversion.ChordNumber,chord_settings)
							end
							SettingsMaster:RebuildChordLabels(ChordInversion.ChordNumber)
						end
						
						
						-- local reset_x_pos = sm_reset_chord_start_x + x*sm_reset_chord_distance_x + sm_row_indents[y]*sm_reset_chord_distance_x
						-- local reset_y_pos = sm_reset_chord_start_y + y*sm_reset_chord_distance_y
						local ChordReset = vgui.Create("DButton",ChordBG)
						ChordReset.ChordNumber = chord
						ChordReset:SetPos(0,0)
						ChordReset:SetSize(sm_icon_size,sm_icon_size)
						ChordReset:SetText("")
						ChordReset:SetImage("icon16/arrow_rotate_clockwise.png")
						ChordReset:SetToolTip("Reset Chord")
						ChordReset.DoClick = function()
							if not IsValid(wep) then return end
							local def_settings = wep.default_settings[ChordReset.ChordNumber]
							-- LocalPlayer():ChatPrint("char_num: "..tostring(ChordReset.ChordNumber))
							def_settings = {def_settings[1],def_settings[2],def_settings[3],def_settings[4],def_settings[5]}
							-- LocalPlayer():ChatPrint("distance: "..tostring(def_settings[1]))
							-- LocalPlayer():ChatPrint("Chord type: "..tostring(def_settings[2]))
							-- LocalPlayer():ChatPrint("Degree: "..tostring(def_settings[3]))
							-- LocalPlayer():ChatPrint(tostring(def_settings[4]))
							-- LocalPlayer():ChatPrint(tostring(def_settings[5]))
							wep:UpdateSetting(ChordReset.ChordNumber,def_settings)
							SettingsMaster:RebuildChordLabels()
						end
						
						local ChordCopy = vgui.Create("DButton",ChordBG)
						-- ChordCopy:SetEnabled(adv_settings)
						ChordCopy.ChordNumber = chord
						ChordCopy:SetPos(sm_icon_size,0)
						ChordCopy:SetSize(sm_icon_size,sm_icon_size)
						ChordCopy:SetText("")
						ChordCopy:SetImage("icon16/page_copy.png")
						ChordCopy:SetToolTip("Copy Chord")
						ChordCopy.DoClick = function()
							if not IsValid(wep) then return end
							wep.ChordClipboard = wep.Config[ChordCopy.ChordNumber]
						end
						
						local ChordPaste = vgui.Create("DButton",ChordBG)
						-- ChordPaste:SetEnabled(adv_settings)
						ChordPaste.ChordNumber = chord
						ChordPaste:SetPos(sm_icon_size*2,0)
						ChordPaste:SetSize(sm_icon_size,sm_icon_size)
						ChordPaste:SetText("")
						ChordPaste:SetImage("icon16/page_paste.png")
						ChordPaste:SetToolTip("Paste Chord")
						ChordPaste.DoClick = function()
							if not IsValid(wep) then return end
							local clip_settings = wep.ChordClipboard
							clip_settings = {clip_settings[1],clip_settings[2],clip_settings[3],clip_settings[4],clip_settings[5]}
							wep:UpdateSetting(ChordReset.ChordNumber,clip_settings)
							SettingsMaster:RebuildChordLabels()
						end
						-- ChordBG:Remove()
						ChordBG.Think = function(self)
							if not IsValid(wep) then return end
							local hovered = false
							local x_min,y_min = SettingsMaster:LocalToScreen(self:GetX(),self:GetY())
							local x_max = x_min+sm_chord_width
							local y_max = y_min+sm_chord_height
							-- print(x_min,y_min,x_max,y_max)
							if (gui.MouseX() >= x_min and gui.MouseX() <= x_max and gui.MouseY() >= y_min and gui.MouseY() <= y_max) or self:IsChildHovered() then
								hovered = true
							end							
							if not hovered then
								-- LocalPlayer():ChatPrint("ChordTHink")
								if not IsValid(self.ChordCover) then
								
									-- LocalPlayer():ChatPrint("Child is not hovered")
									self.ChordCover = vgui.Create("DPanel",ChordBG)
									self.ChordCover.ChordNumber = self.ChordNumber
									self.ChordCover:SetSize(sm_chord_width,sm_chord_height)
									-- self.ChordCover.Think = function(_)
										-- if _:IsHovered() or _:IsChildHovered() then
											-- _:Remove()
										-- end
									-- end
									
									local mode = wep.Config[wep.setting_mode]
									local mode_distance_offset = wep.ModeTable[mode][2]
									local mode_degree_offset = wep.ModeTable[mode][3]
									-- local adv_settings = self.Config[wep.setting_advanced_settings]
									local chord = self.ChordNumber
									-- print("PPP",wep.Config[chord][3])
									
									local root_distance = wep.Config[chord][1]+mode_distance_offset
									local root_degree = wep.Config[chord][3]
									local inversion_root_degree = wep.Config[chord][5]
									
									local root_name = wep:GetNoteName(wep.Config[wep.setting_root_note],root_distance,root_degree+mode_degree_offset)
									
									local root_color = inversion_root_degree
									if root_color == -100 then
										root_color = root_degree
									end
									self.ChordCover:SetBackgroundColor(wep.degree_colors[(root_color-1)%7+1])
									
									self.ChordCover.NoteName = vgui.Create("DLabel",self.ChordCover)
									self.ChordCover.NoteName:SetPos(7,5)
									self.ChordCover.NoteName:SetSize(sm_chord_width-7,sm_chord_height-15)
									self.ChordCover.NoteName:SetFont("SettingsMenuChordLetter")
									self.ChordCover.NoteName:SetText(root_name[1])
									self.ChordCover.NoteName:SetTextColor(Color(0,0,0,255))
									
									local chord_type = wep.ChordTable[wep.Config[chord][2]][2]
									local caret_pos = string.find(chord_type,"!")
									if caret_pos != nil then
										self.ChordCover.ChordTypeAccent = vgui.Create("DLabel",self.ChordCover)
										self.ChordCover.ChordTypeAccent:SetPos(60,40)
										self.ChordCover.ChordTypeAccent:SetSize(sm_chord_width-25,sm_chord_height-45)
										self.ChordCover.ChordTypeAccent:SetFont("SettingsMenuChordType")
										self.ChordCover.ChordTypeAccent:SetText(chord_type[caret_pos+1])
										self.ChordCover.ChordTypeAccent:SetTextColor(Color(0,0,0,255))
										chord_type = string.sub(chord_type,1,caret_pos-1)
									end
									self.ChordCover.ChordType = vgui.Create("DLabel",self.ChordCover)
									self.ChordCover.ChordType:SetPos(35,45)
									self.ChordCover.ChordType:SetSize(sm_chord_width-25,sm_chord_height-45)
									self.ChordCover.ChordType:SetFont("SettingsMenuChordType")
									self.ChordCover.ChordType:SetText(chord_type)
									self.ChordCover.ChordType:SetTextColor(Color(0,0,0,255))
									
									
									if string.len(root_name) > 1 then
										local acc_string = string.sub(root_name,2,string.len(root_name))
										-- print(root_name,acc_string)
										self.ChordCover.Accidental = vgui.Create("DLabel",self.ChordCover)
										self.ChordCover.Accidental:SetPos(40,4)
										if acc_string == "#" then
											acc_string = " #"
											self.ChordCover.Accidental:SetPos(35,4)
										end
										self.ChordCover.Accidental:SetSize(sm_chord_width-25,sm_chord_height/2)
										self.ChordCover.Accidental:SetFont("SettingsMenuAccidental")
										self.ChordCover.Accidental:SetText(acc_string)
										self.ChordCover.Accidental:SetTextColor(Color(0,0,0,255))
									end
								end
					
					
							else
								if IsValid(self.ChordCover) then
									self.ChordCover:Remove()
									-- self.ChordCover = nil
								end
							end
						end
					end
					chord = chord + 1
				end
			end
		end
		
		local settings_key_y_offset = 28
		
		local RootNote = vgui.Create("DComboBox",SettingsMaster)
		RootNote:SetPos(sm_key_pos_x+11,sm_key_pos_y+17)
		RootNote:SetSize(79,24)
		RootNote:SetSortItems(true)
		RootNote:SetValue(wep.Config[wep.setting_root_note])
		for k,v in pairs(wep.root_distances) do
			RootNote:AddChoice(k)
		end
		RootNote.OnSelect = function(_,index,value)
			if not IsValid(wep) then return end
			wep:UpdateSetting(wep.setting_root_note,value)
			SettingsMaster:RebuildChordLabels()
		end
		
		
		local Mode = vgui.Create("DComboBox",SettingsMaster)
		Mode:SetPos(sm_key_pos_x+11,sm_key_pos_y+41)
		Mode:SetSize(79,24)
		Mode:SetSortItems(false)
		Mode.ShortenTitle = function(self,mode_number)
			if not IsValid(wep) then return end
			local text = wep.ModeTable[mode_number][1]
			if text == "Major (Ionian)" then
				text = "Major"
			elseif text == "Minor (Aeolian)" then
				text = "Minor"
			end
			self:SetText(text)
		end
		Mode:SetValue(wep.ModeTable[wep.Config[wep.setting_mode]][1])
		Mode:ShortenTitle(wep.Config[wep.setting_mode])
		-- Mode:SetSortItems(false)
		for k = 1,7 do
			local v = wep.ModeTable[k]
			-- print(v[1])
			Mode:AddChoice(v[1],nil,nil,"icon16/bullet_"..v[4]..".png")
		end
		Mode.OnSelect = function(self,index,value)
			if not IsValid(wep) then return end
			local mode_number = wep.modes_from_names[value]
			wep:UpdateSetting(wep.setting_mode,mode_number)
			SettingsMaster:RebuildChordLabels()
			self:ShortenTitle(mode_number)
			-- Mode:Clear()
			-- Mode:SetText("Thank you for your feedback!")
		end
		
		local ModeLeftButton = vgui.Create("DButton",SettingsMaster)
		ModeLeftButton:SetPos(sm_key_pos_x+90,sm_key_pos_y+17)
		ModeLeftButton:SetSize(24,48)
		ModeLeftButton:SetText("") 
		ModeLeftButton:SetImage("icon16/resultset_previous.png")
		ModeLeftButton.DoClick = function()
			if not IsValid(wep) then return end
			local mode_number = wep.Config[wep.setting_mode]
			new_mode_number = (mode_number-2)%7+1
			wep:UpdateSetting(wep.setting_mode,new_mode_number,true)
			Mode:SetValue(wep.ModeTable[new_mode_number][1])
			Mode:ShortenTitle(new_mode_number)
			local new_root = wep:GetNoteName(wep.Config[wep.setting_root_note],wep.key_assignments[KEY_P][mode_number],7)
			if not table.HasValue(wep.valid_roots,new_root) then
				new_root = wep.root_shortened_distances[wep.note_distances[new_root]]
			end
			wep:UpdateSetting(wep.setting_root_note,new_root,true)
			RootNote:SetValue(new_root)
			SettingsMaster:RebuildChordLabels()
		end
		ModeLeftButton.DoRightClick = function()
			if not IsValid(wep) then return end
			ModeLeftButton:DoClick()
			wep:PlayIntroTune(true)
		end
		
		local ModeRightButton = vgui.Create("DButton",SettingsMaster)
		ModeRightButton:SetPos(sm_key_pos_x+114,sm_key_pos_y+17)
		ModeRightButton:SetSize(24,48)
		ModeRightButton:SetText("") 
		ModeRightButton:SetImage("icon16/resultset_next.png")
		ModeRightButton.DoClick = function()
			if not IsValid(wep) then return end
			local mode_number = wep.Config[wep.setting_mode]
			new_mode_number = (mode_number)%7+1
			wep:UpdateSetting(wep.setting_mode,new_mode_number,true)
			Mode:SetValue(wep.ModeTable[new_mode_number][1])
			Mode:ShortenTitle(new_mode_number)
			local new_root = wep:GetNoteName(wep.Config[wep.setting_root_note],wep.key_assignments[KEY_G][mode_number],2)
			if not table.HasValue(wep.valid_roots,new_root) then
				new_root = wep.root_shortened_distances[wep.note_distances[new_root]]
			end
			wep:UpdateSetting(wep.setting_root_note,new_root,true)
			RootNote:SetValue(new_root)
			SettingsMaster:RebuildChordLabels()
		end
		ModeRightButton.DoRightClick = function()
			if not IsValid(wep) then return end
			ModeRightButton:DoClick()
			wep:PlayIntroTune(true)
		end
		
		
		
		local EditChords = vgui.Create("DButton",SettingsMaster)
		EditChords:SetPos(sm_misc_pos_x+13,sm_misc_pos_y+17)
		EditChords:SetSize(120,24)
		EditChords:SetText("    Edit Chords")
		EditChords:SetIcon("icon16/application_side_contract.png")
		EditChords.DoClick = function()
			if not IsValid(wep) then return end
			wep:UpdateSetting(wep.setting_edit_chord,true)
			self:RefreshSettingsMenu()
		end
		if edit_chords then
			EditChords:SetText("    Hide Chords")
			EditChords:SetIcon("icon16/application_side_expand.png")
			EditChords.DoClick = function()
				if not IsValid(wep) then return end
				wep:UpdateSetting(wep.setting_edit_chord,false)
				self:RefreshSettingsMenu()
			end
		end

		
		
		local settings_instrument_y_offset = sm_inst_pos_y-17
		
		local instrument_gap = 48
		
		local inst_diff = {
			[1] = {"     Bass",wep.setting_instrument_bass,wep.setting_vol_bass,"(left hand)"},
			[2] = {"   Chords",wep.setting_instrument_chord,wep.setting_vol_chord,"(left hand)"},
			[3] = {"    Notes",wep.setting_instrument_notes,wep.setting_vol_note,"(right hand)"},
		}
		SettingsMaster.cur_inst = {}
		for i = 1,3 do
			local set_inst = inst_diff[i][2]
			local set_vol = inst_diff[i][3]
			local instrument_offset = (i-1)*instrument_gap
			
			local InstrumentLabel = vgui.Create("DLabel",SettingsMaster)
			InstrumentLabel:SetPos(sm_inst_pos_x+8,34+settings_instrument_y_offset+instrument_offset)
			InstrumentLabel:SetText(inst_diff[i][1])
			InstrumentLabel:SetSize(183,20)

			local Instrument = vgui.Create("DComboBox",SettingsMaster)
			
			
			Instrument:SetPos(sm_inst_pos_x+71,26+settings_instrument_y_offset+instrument_offset)
			Instrument:SetSize(100,20)
			SettingsMaster.cur_inst[i] = wep.Config[set_inst]
			local inst_tbl = InstrumentTable[SettingsMaster.cur_inst[i]]
			if inst_tbl == nil then
				inst_tbl = InstrumentTable[1]
			end
			-- PrintTable(inst_tbl)
			Instrument.OnSelect = function(self,index,value,data)
				if not IsValid(wep) then return end
				wep:UpdateSetting(set_inst,data)
				self:RefreshChoices()
			end
			Instrument.RefreshChoices = function(self)
				if not IsValid(wep) then return end
				SettingsMaster.cur_inst[i] = wep.Config[set_inst]
				self:Clear()
				for k,v in pairs(InstrumentTable) do
					local icon = nil
					if k == SettingsMaster.cur_inst[i] then
						icon = "icon16/bullet_go.png"
					end
					Instrument:AddChoice(v[2],k,nil,icon)
				end
				self:SetValue(InstrumentTable[SettingsMaster.cur_inst[i]][2])
			end
			Instrument:RefreshChoices()
			-- local InstrumentRandom = vgui.Create("DButton",SettingsMaster)
			-- InstrumentRandom:SetPos(sm_inst_pos_x+147,24+settings_instrument_y_offset+instrument_offset)
			-- InstrumentRandom:SetSize(24,24)
			-- InstrumentRandom:SetText("") 
			-- InstrumentRandom:SetImage("icon16/arrow_switch.png")
			-- InstrumentRandom.DoClick = function()
				-- for k,v in RandomPairs(InstrumentTable) do
					-- if k != SettingsMaster.cur_inst[i] then
						-- wep:UpdateSetting(wep.set_inst,k)
						-- Instrument:RefreshChoices()
						-- break
					-- end
				-- end
			-- end
			
			local InstrumentVolume = vgui.Create("DNumSlider",SettingsMaster)
			InstrumentVolume:SetPos(sm_inst_pos_x+24,47+settings_instrument_y_offset+instrument_offset)
			InstrumentVolume:SetSize(165,20)
			InstrumentVolume:SetText("")
			
			local vol_factor = 200
			
			local InstrumentVolumeLabel = vgui.Create("DLabel",SettingsMaster)
			InstrumentVolumeLabel:SetPos(sm_inst_pos_x+71,48+settings_instrument_y_offset+instrument_offset)
			InstrumentVolumeLabel:SetSize(170,20)
			InstrumentVolumeLabel:SetText("Vol.                          %")
			-- NumArpDelay:SetIcon("Arpeggiator Delay (ms)")
			InstrumentVolume:SetMin(0.1*vol_factor)
			InstrumentVolume:SetMax(1*vol_factor)
			InstrumentVolume:SetDecimals(0)
			InstrumentVolume:SetValue(wep.Config[set_vol]*vol_factor)
			InstrumentVolume.OnValueChanged = function(self,val)
				if not IsValid(wep) then return end
				wep:UpdateSetting(set_vol,val/vol_factor)
			end
			if i != 1 then
				local InstrumentDivider = vgui.Create("DPanel",SettingsMaster)
				InstrumentDivider:SetPos(sm_inst_pos_x,47+settings_instrument_y_offset+instrument_offset-26)
				InstrumentDivider:SetSize(182,1)
			end
		end
		
		
		
		local link_pos_x = sm_web_pos_x+9
		local link_pos_y = sm_web_pos_y+11
		local HookTheoryLink = vgui.Create("DButton",SettingsMaster)
		HookTheoryLink:SetPos(link_pos_x,link_pos_y)
		HookTheoryLink:SetSize(104,24)
		-- HookTheoryLink:SetColor(Color(255,255,255,255)) 
		HookTheoryLink:SetText("   Learn Songs") 
		HookTheoryLink:SetImage("icon16/world_link.png")
		HookTheoryLink.DoClick = function()
			if not IsValid(wep) then return end
			wep:UpdateSetting(wep.setting_browser_open,true)
			local url = wep.Config[wep.setting_browser_url]
			if url == "chrome://chromewebdata/" then
				url = wep.default_settings[wep.setting_browser_url]
			end
			
			local x_mult = 2.5
	
			
			
			local browser_width = 657
			local browser_height = settings_menu_height-26
			local browser_frame_denominator = 1.5
			local browser_frame_width = browser_width/browser_frame_denominator
			local browser_frame_height = browser_height/browser_frame_denominator
			local browser_controls_height = 36
			
			local browserWarning = vgui.Create("DPanel",SettingsMaster)
			browserWarning:SetPos(settings_menu_width+2,24)
			browserWarning:SetSize(browser_width,browser_height)
			browserWarning:SetBackgroundColor(Color(108,111,114,255))
			
			local browserWarningLoading = vgui.Create("DLabel",browserWarning)
			browserWarningLoading:SetText("Loading...")
			browserWarningLoading:SetFont("SettingsMenuHelp")
			browserWarningLoading:SetSize(128,64)
			browserWarningLoading:Center()
			timer.Simple(2, function()
				if not IsValid(wep) then return end
				if IsValid(browserWarning) then
					local browserWarningHTML = vgui.Create("HTML",browserWarning)
					browserWarningHTML:SetSize(browser_width,browser_height)
					browserWarningHTML:SetPos(0,browser_controls_height)
					browserWarningHTML:OpenURL("https://i.imgur.com/RFIEcK3.png")
				end
			end)
			
			-- browserWarning:OpenURL("https://i.imgur.com/lBYdurl.png")
			local browser = vgui.Create("HTML",SettingsMaster)
			browser:SetPos(settings_menu_width+2,24+browser_controls_height)
			browser:SetSize(browser_width,browser_height-browser_controls_height)
			browser:OpenURL(url)
			browser.OnFinishLoadingDocument = function(_,url)
				if not IsValid(wep) then return end
				wep:UpdateSetting(wep.setting_browser_url,url)
			end
			browser.Think = function(self)
				if not IsValid(wep) then return end
					-- print("HOVERED")
				if browser:IsHovered() then
					browser:SetKeyboardInputEnabled(true)
				else
					browser:SetKeyboardInputEnabled(false)
				end
			end
			local browserControls = vgui.Create("DHTMLControls",SettingsMaster)
			browserControls:SetSize(browser_width,browser_controls_height)
			browserControls:SetPos(settings_menu_width+2,24)
			browserControls:SetHTML(browser)
			browserControls.HomeURL = wep.HomeURL
			SettingsMaster:SetSize(settings_menu_width+browser_width+4,settings_menu_height)
			local sm_x,sm_y = SettingsMaster:GetPos()
			SettingsMaster:Center()
		
			local HookTheoryLinkClose = vgui.Create("DButton",SettingsMaster)
			HookTheoryLinkClose:SetPos(link_pos_x,link_pos_y)
			HookTheoryLinkClose:SetSize(104,24)
			HookTheoryLinkClose:SetText("   Close Web") 
			HookTheoryLinkClose:SetImage("icon16/cross.png")
			
			HookTheoryLinkClose.DoClick = function()
				if not IsValid(wep) then return end
				wep:UpdateSetting(wep.setting_browser_open,false)
				if HookTheoryLinkClose != nil then
					HookTheoryLinkClose:Remove()
				end
				if LinkLabelClose != nil then
					LinkLabelClose:Remove()
				end
				if browser != nil then
					browser:Remove()
				end
				if browserWarning != nil then
					browserWarning:Remove()
				end
				local sm_x,sm_y = SettingsMaster:GetPos()
				SettingsMaster:SetPos(sm_x+((x_mult*settings_menu_width)-settings_menu_width)/2-227,sm_y)
				SettingsMaster:SetSize(settings_menu_width,settings_menu_height)
				SettingsMaster:Center()
			end
			-- print(browserControls.StopButton)
			browserControls.StopButton.DoClick = function()
				if not IsValid(wep) then return end
				if IsValid(HookTheoryLinkClose) then
					HookTheoryLinkClose:DoClick()
				end
			end
			
		end
		
		if browser_open then
			HookTheoryLink:DoClick()
		end
		
		local HookTheoryInstructions = vgui.Create("DButton",SettingsMaster)
		HookTheoryInstructions:SetPos(link_pos_x,link_pos_y+24)
		HookTheoryInstructions:SetSize(104,24)
		HookTheoryInstructions:SetText("Web Help ") 
		HookTheoryInstructions:SetImage("icon16/help.png")
		HookTheoryInstructions.DoClick = function()
			if not IsValid(wep) then return end
			local image_width = 459
			local image_height = 403
			local modal_width = image_width+2
			local modal_height = image_height+66
			local WebHelpModal = vgui.Create("DFrame")
			WebHelpModal:SetSize(modal_width,modal_height)
			WebHelpModal:SetTitle("Web Help")
			WebHelpModal:SetIcon("icon16/help.png")
			WebHelpModal:MakePopup()
			WebHelpModal:Center()
			WebHelpModal.Pages = {
				[1] = "https://i.imgur.com/qTrsX12.png",
				[2] = "https://i.imgur.com/0gDLqrt.png",
				[3] = "https://i.imgur.com/w0vS4YF.png"
			}
			WebHelpModal.URLKey = 1
			WebHelpModal.PageIcon = "icon16/bullet_picture.png"
			WebHelpModal.PageIconCurrent = "icon16/picture.png"
			local WebHelpModalThinker = vgui.Create("DPanel",WebHelpModal)
			WebHelpModalThinker:SetSize(1,1)
			WebHelpModalThinker.Think = function(self)
				if not IsValid(wep) then return end
				if not IsValid(SettingsMaster) then
					WebHelpModal:Remove()
				end
				-- WebHelpModalThinker.Think = function(self)
				-- end
			end
			
			local icon_center = (modal_width-16)/2
			local icon_gap = 8
			WebHelpModal.PageTicks = {}
			for i = 1,3 do
				local icon_x = icon_center+(i-2)*(icon_gap+16)
				WebHelpModal.PageTicks[i] = vgui.Create("DImageButton",WebHelpModal)
				WebHelpModal.PageTicks[i]:SetPos(icon_x,modal_height-27)
				WebHelpModal.PageTicks[i]:SetSize(16,16)
				WebHelpModal.PageTicks[i]:SetImage(WebHelpModal.PageIcon)	
				WebHelpModal.PageTicks[i].DoClick = function()
					if not IsValid(wep) then return end
					WebHelpModal:SetPage(i)
				end
			end
			
			local HelpImage = vgui.Create("HTML",WebHelpModal)
			HelpImage:SetPos(1,24)
			HelpImage:SetSize(image_width,image_height)
			local url = WebHelpModal.Pages[WebHelpModal.URLKey]
			if url != nil then
				HelpImage:OpenURL(url)
			end
			
			WebHelpModal.SetPage = function(self,page)
				if not IsValid(wep) then return end
				self.URLKey = page
				url = self.Pages[page]
				if url != nil then
					HelpImage:OpenURL(url)
				end
				for k,v in pairs(self.PageTicks) do
					if k == self.URLKey then
						v:SetImage(self.PageIconCurrent)
					else
						v:SetImage(self.PageIcon)
					end
				end
			end
			
			WebHelpModal.ChangePage = function(self,dist)
				if not IsValid(wep) then return end
				self:SetPage((WebHelpModal.URLKey-1+dist)%#WebHelpModal.Pages+1)
			end
			
			local PrevPage = vgui.Create("DButton",WebHelpModal)
			PrevPage:SetSize(24,24)
			PrevPage:SetPos(151,436)
			PrevPage:SetText("")
			PrevPage:SetImage("icon16/resultset_previous.png")
			PrevPage.DoClick = function()
				if not IsValid(wep) then return end
				WebHelpModal:ChangePage(-1)
			end
			local NextPage = vgui.Create("DButton",WebHelpModal)
			NextPage:SetSize(24,24)
			NextPage:SetPos(285,436)
			NextPage:SetText("")
			NextPage:SetImage("icon16/resultset_next.png")
			NextPage.DoClick = function()
				if not IsValid(wep) then return end
				WebHelpModal:ChangePage(1)
			end
			WebHelpModal:ChangePage(0)
		end
		
		
		if edit_chords then
			local BoolRaiseBass = vgui.Create("DCheckBoxLabel",SettingsMaster)
			BoolRaiseBass:SetPos(sm_chord_pos_x+14,sm_chord_pos_y+314)
			BoolRaiseBass:SetText("Raise Bass")
			BoolRaiseBass:SetValue(wep.Config[wep.setting_raise_chords])
			BoolRaiseBass:SizeToContents()
			BoolRaiseBass:SetEnabled(wep.Config[wep.setting_advanced_settings] and wep.Config[wep.setting_raise_chords])
			BoolRaiseBass.OnChange = function(self,bool)
				if not IsValid(wep) then return end
				wep:UpdateSetting(wep.setting_raise_bass,bool)
			end
			
			
			local BoolRaiseChords = vgui.Create("DCheckBoxLabel",SettingsMaster)
			BoolRaiseChords:SetPos(sm_chord_pos_x+14,sm_chord_pos_y+292)
			BoolRaiseChords:SetText("Raise Chords")
			BoolRaiseChords:SetValue(wep.Config[wep.setting_raise_chords])
			BoolRaiseChords:SizeToContents()
			BoolRaiseChords:SetEnabled(wep.Config[wep.setting_advanced_settings])
			BoolRaiseChords.OnChange = function(self,bool)
				if not IsValid(wep) then return end
				wep:UpdateSetting(wep.setting_raise_chords,bool)
				BoolRaiseBass:SetEnabled(bool and wep.Config[wep.setting_raise_chords])
				if bool == false then
					BoolRaiseBass:SetValue(false)
				end
			end
			
			
			local BoolAdvSettings = vgui.Create("DCheckBoxLabel",SettingsMaster)
			BoolAdvSettings:SetPos(sm_chord_pos_x+14,sm_chord_pos_y+270)
			BoolAdvSettings:SetText("Adv. Settings")
			BoolAdvSettings:SetValue(wep.Config[wep.setting_advanced_settings])
			BoolAdvSettings:SizeToContents()
			BoolAdvSettings.OnChange = function(self,bool)
				if not IsValid(wep) then return end
				wep:UpdateSetting(wep.setting_advanced_settings,bool)
				BoolRaiseChords:SetEnabled(bool)
				BoolRaiseBass:SetEnabled(bool and wep.Config[wep.setting_raise_chords])
				SettingsMaster:RebuildChordLabels()
			end
		end
		
		
		local SaveSettings = vgui.Create("DButton",SettingsMaster)
		SaveSettings:SetPos(sm_file_pos_x+6,sm_file_pos_y+11)
		SaveSettings:SetSize(110,24)
		-- HookTheoryLink:SetColor(Color(255,255,255,255)) 
		SaveSettings:SetText("    Save Settings") 
		SaveSettings:SetImage("icon16/disk.png")
		SaveSettings.DoClick = function()
			if not IsValid(wep) then return end
			wep:SaveSettings()
		end
		local LoadSettings = vgui.Create("DButton",SettingsMaster)
		LoadSettings:SetPos(sm_file_pos_x+6,sm_file_pos_y+35)
		LoadSettings:SetSize(110,24)
		-- HookTheoryLink:SetColor(Color(255,255,255,255)) 
		LoadSettings:SetText("    Load Settings") 
		LoadSettings:SetImage("icon16/folder_page.png")
		LoadSettings.DoClick = function()
			if not IsValid(wep) then return end
			wep:LoadSettings()
		end
		local ClearSettings = vgui.Create("DButton",SettingsMaster)
		ClearSettings:SetPos(sm_file_pos_x+6,sm_file_pos_y+59)
		ClearSettings:SetSize(110,24)
		-- HookTheoryLink:SetColor(Color(255,255,255,255)) 
		ClearSettings:SetText("   Clear Settings") 
		ClearSettings:SetImage("icon16/arrow_rotate_clockwise.png")
		ClearSettings.DoClick = function()
			if not IsValid(wep) then return end
			-- wep:SaveSettings()
			local Menu = DermaMenu()
			
			local ResetKey = Menu:AddOption("Reset Key / Mode")
			ResetKey:SetIcon("icon16/key.png")
			ResetKey.DoClick = function()
			if not IsValid(wep) then return end
				wep:ClearSettingCategory(wep.KeySettings)
			end
			local ResetInstruments = Menu:AddOption("Reset Instruments")
			ResetInstruments:SetIcon("icon16/sound.png")
			ResetInstruments.DoClick = function()
				if not IsValid(wep) then return end
				wep:ClearSettingCategory(wep.InstrumentSettings)
			end
			local ResetChords = Menu:AddOption("Reset Chords")
			ResetChords:SetIcon("icon16/color_swatch.png")
			ResetChords.DoClick = function()
				if not IsValid(wep) then return end
				wep:ClearSettingCategory(wep.ChordSettings)
			end
			local ResetARP = Menu:AddOption("Reset Repeater")
			ResetARP:SetIcon("icon16/control_fastforward_blue.png")
			ResetARP.DoClick = function()
				if not IsValid(wep) then return end
				wep:ClearSettingCategory(wep.ARPSettings)
			end
			local ResetAll = Menu:AddOption("Reset Everything")
			ResetAll:SetIcon("icon16/wand.png")
			ResetAll.DoClick = function()
				if not IsValid(wep) then return end
				local ResetModal = vgui.Create("DFrame")
				ResetModal:SetSize(settings_menu_modal_width,settings_menu_modal_height)
				ResetModal:SetTitle("Reset Everything?")
				ResetModal:SetIcon("icon16/delete.png")
				ResetModal:MakePopup()
				ResetModal:Center()
				local ResetModalThinker = vgui.Create("DPanel",ResetModal)
				ResetModalThinker:SetSize(1,1)
				ResetModalThinker.Think = function(self)
					if not IsValid(wep) then return end
					if not ResetModal:HasFocus() then
						timer.Simple(1,function()
							if IsValid(ResetModal) and not ResetModal:HasFocus() then
								ResetModal:Remove()
							end
						end)
					end
					if not IsValid(SettingsMaster) then
						ResetModal:Remove()
					end
					-- ResetModalThinker.Think = function(self)
					-- end
				end
				local ResetModelYes = vgui.Create("DButton",ResetModal)
				ResetModelYes:SetSize(settings_menu_modal_button_width,settings_menu_modal_button_height)
				ResetModelYes:SetPos(48,45)
				ResetModelYes:SetText("Yes")
				ResetModelYes.DoClick = function()
					if not IsValid(wep) then return end
					wep:ClearSettings()
					if IsValid(ResetModal) then
						ResetModal:Remove()
					end
				end
				local ResetModelNo = vgui.Create("DButton",ResetModal)
				ResetModelNo:SetSize(settings_menu_modal_button_width,settings_menu_modal_button_height)
				ResetModelNo:SetPos(140,45)
				ResetModelNo:SetText("No")
				ResetModelNo.DoClick = function()
					if not IsValid(wep) then return end
					if IsValid(ResetModal) then
						ResetModal:Remove()
					end
				end
				-- wep:ClearSettings()
			end
			Menu:Open()
		end
			-- wep:LoadSettings()
		-- end
		
		
		local settings_arp_offset = sm_arp_pos_y-347
		local arp_row_height = 20
		local bpm_mod = 60
		
		local NumArpDelayLabel = vgui.Create("DLabel",SettingsMaster)
		NumArpDelayLabel:SetPos(sm_arp_pos_x+11,351+settings_arp_offset)
		NumArpDelayLabel:SetSize(200,32)
		NumArpDelayLabel:SetText("Beats Per Minute")
		local NumArpDelay = vgui.Create("DNumSlider",SettingsMaster)
		NumArpDelay:SetPos(sm_arp_pos_x+11,350+settings_arp_offset)
		NumArpDelay:SetSize(200,32)
		NumArpDelay:SetText("")
		-- NumArpDelay:SetIcon("Arpeggiator Delay (ms)")
		NumArpDelay:SetMin(bpm_mod/wep.ArpMax)
		NumArpDelay:SetMax(bpm_mod/wep.ArpMin)
		NumArpDelay:SetDecimals(0)
		NumArpDelay:SetValue(bpm_mod/wep.Config[wep.setting_arp_delay])
		NumArpDelay.OnValueChanged = function(self,val)
			if not IsValid(wep) then return end
			wep:UpdateSetting(wep.setting_arp_delay,1/(val/bpm_mod))
		end
		
		
		local BoolArpScale = vgui.Create("DCheckBoxLabel",SettingsMaster)
		BoolArpScale:SetPos(sm_arp_pos_x+11,359+settings_arp_offset+arp_row_height*2)
		BoolArpScale:SetText("Scale chords (one note at a time)")
		BoolArpScale:SetValue(wep.Config[wep.setting_arp_scale])
		BoolArpScale:SizeToContents()
		BoolArpScale:SetEnabled(wep.Config[wep.setting_arp_chords])
		BoolArpScale.OnChange = function(self,bool)
			if not IsValid(wep) then return end
			-- print("BOOL:"..tostring(bool))
			wep:UpdateSetting(wep.setting_arp_scale,bool)
		end
		
		local BassRateLabel = vgui.Create("DLabel",SettingsMaster)
		BassRateLabel:SetPos(sm_arp_pos_x+11,351+settings_arp_offset+arp_row_height*3)
		BassRateLabel:SetSize(240,32)
		BassRateLabel:SetText("Bass plays every                        beats")
		BassRateLabel.SetEnabled = function(self,bool)
			if not IsValid(wep) then return end
			if bool then
				BassRateLabel:SetTextColor(Color(210,210,210,255))
			else
				BassRateLabel:SetTextColor(Color(150,150,150,255))
			end
		end
		
		BassRateLabel:SetEnabled(wep.Config[wep.setting_arp_chords])
		
		
		local NumBassRate = vgui.Create("DNumSlider",SettingsMaster)
		NumBassRate:SetPos(sm_arp_pos_x+28,350+settings_arp_offset+arp_row_height*3)
		NumBassRate:SetSize(165,32)
		NumBassRate:SetText("")
		NumBassRate:SetMin(wep.ArpBassMin)
		NumBassRate:SetMax(wep.ArpBassMax)
		NumBassRate:SetDecimals(0)
		NumBassRate:SetValue(wep.Config[wep.setting_arp_bass_rate])
		NumBassRate.OldValue = wep.Config[wep.setting_arp_bass_rate]
		NumBassRate:SetEnabled(wep.Config[wep.setting_arp_chords])
		NumBassRate.OnValueChanged = function(self,val)
			if not IsValid(wep) then return end
			local new_value = math.Round(val)
			self:SetValue(new_value)
			if new_value != self.OldValue then
				wep:UpdateSetting(wep.setting_arp_bass_rate,new_value)
				self.OldValue = new_value
			end
		end
		
		
		
		
		local ArpChordLabel = vgui.Create("DLabel",SettingsMaster)
		ArpChordLabel:SetPos(sm_arp_pos_x+120,359+settings_arp_offset+arp_row_height)
		ArpChordLabel:SetSize(100,16)
		ArpChordLabel:SetText("chords per beat")
		ArpChordLabel:SetEnabled(wep.Config[wep.setting_arp_chords])
		
		local NumChordRate = vgui.Create("DNumSlider",SettingsMaster)
		NumChordRate:SetPos(sm_arp_pos_x-4,350+settings_arp_offset+arp_row_height)
		NumChordRate:SetSize(150,32)
		NumChordRate:SetText("")
		-- NumArpDelay:SetIcon("Arpeggiator Delay (ms)")
		NumChordRate:SetMin(wep.ArpNoteMin)
		NumChordRate:SetMax(wep.ArpNoteMax)
		NumChordRate:SetDecimals(0)
		NumChordRate:SetValue(wep.Config[wep.setting_arp_chord_rate])
		NumChordRate.OldValue = wep.Config[wep.setting_arp_chord_rate]
		NumChordRate:SetEnabled(wep.Config[wep.setting_arp_chords])
		NumChordRate.OnValueChanged = function(self,val)
			if not IsValid(wep) then return end
			local new_value = math.Round(val)
			self:SetValue(new_value)
			if new_value != self.OldValue then
				wep:UpdateSetting(wep.setting_arp_chord_rate,new_value)
				self.OldValue = new_value
			end
		end
		
		local BoolArpChords = vgui.Create("DCheckBoxLabel",SettingsMaster)
		BoolArpChords:SetPos(sm_arp_pos_x+11,359+settings_arp_offset+arp_row_height)
		BoolArpChords:SetText("Play")
		BoolArpChords:SetValue(wep.Config[wep.setting_arp_chords])
		BoolArpChords:SizeToContents()
		BoolArpChords.OnChange = function(self,bool)
			if not IsValid(wep) then return end
			-- print("BOOL:"..tostring(bool))
			wep:UpdateSetting(wep.setting_arp_chords,bool)
			BoolArpScale:SetEnabled(bool)
			BassRateLabel:SetEnabled(bool)
			NumBassRate:SetEnabled(bool)
			NumChordRate:SetEnabled(bool)
		end
		
		
		local ArpNotesLabel = vgui.Create("DLabel",SettingsMaster)
		ArpNotesLabel:SetPos(sm_arp_pos_x+120,359+settings_arp_offset+arp_row_height*4)
		ArpNotesLabel:SetSize(100,16)
		ArpNotesLabel:SetText("notes per beat")
		ArpNotesLabel:SetEnabled(wep.Config[wep.setting_arp_notes])
		
		local NumNoteRate = vgui.Create("DNumSlider",SettingsMaster)
		NumNoteRate:SetPos(sm_arp_pos_x-4,350+settings_arp_offset+arp_row_height*4)
		NumNoteRate:SetSize(150,32)
		NumNoteRate:SetText("")
		-- NumArpDelay:SetIcon("Arpeggiator Delay (ms)")
		NumNoteRate:SetMin(wep.ArpNoteMin)
		NumNoteRate:SetMax(wep.ArpNoteMax)
		NumNoteRate:SetDecimals(0)
		NumNoteRate:SetValue(wep.Config[wep.setting_arp_note_rate])
		NumNoteRate.OldValue = wep.Config[wep.setting_arp_note_rate]
		NumNoteRate:SetEnabled(wep.Config[wep.setting_arp_notes])
		NumNoteRate.OnValueChanged = function(self,val)
			if not IsValid(wep) then return end
			local new_value = math.Round(val)
			self:SetValue(math.Round(val))
			if new_value != self.OldValue then
				wep:UpdateSetting(wep.setting_arp_note_rate,new_value)
				self.OldValue = new_value
			end
		end
		
		local BoolArpNotes = vgui.Create("DCheckBoxLabel",SettingsMaster)
		BoolArpNotes:SetPos(sm_arp_pos_x+11,359+settings_arp_offset+arp_row_height*4)
		BoolArpNotes:SetText("Play")
		BoolArpNotes:SetValue(wep.Config[wep.setting_arp_notes])
		BoolArpNotes:SizeToContents()
		BoolArpNotes.OnChange = function(self,bool)
			if not IsValid(wep) then return end
			wep:UpdateSetting(wep.setting_arp_notes,bool)
			NumNoteRate:SetEnabled(bool)
			ArpNotesLabel:SetEnabled(bool)
		end
		
		
		-- local ForceStopButton = vgui.Create("DButton",SettingsMaster)
		-- ForceStopButton:SetPos(610,323)
		-- ForceStopButton:SetSize(116,24)
		-- ForceStopButton:SetText("Force Stop")
		-- ForceStopButton:SetImage("icon16/stop.png")
		-- ForceStopButton:SetToolTip("Force Stop")
		-- ForceStopButton.DoClick = function(self,val)
			-- local ply = LocalPlayer()
			-- -- ply:ChatPrint("JKJKJ")
			-- if IsValid(ply) and IsValid(wep) then
				-- net.Start("music_mode_force_player_exit")
					-- net.WriteEntity(ply)
				-- net.SendToServer()
				-- wep:SetDisabled()
			-- end
		-- end
		
		-- local ForceStartButton = vgui.Create("DButton",SettingsMaster)
		-- ForceStartButton:SetPos(610,299)
		-- ForceStartButton:SetSize(116,24)
		-- ForceStartButton:SetText("Force Start")
		-- ForceStartButton:SetImage("icon16/accept.png")
		-- ForceStartButton:SetToolTip("Force Start")
		-- ForceStartButton.DoClick = function(self,val)
			-- local ply = LocalPlayer()
			-- -- ply:ChatPrint("JKJKJ")
			-- if IsValid(ply) and IsValid(wep) then
				-- net.Start("music_mode_force_player_enter")
					-- net.WriteEntity(ply)
					-- net.WriteEntity(wep)
				-- net.SendToServer()
				-- wep:SetEnabled()
			-- end
		-- end
		
		local ToggleStateButton = vgui.Create("DButton",SettingsMaster)
		ToggleStateButton:SetPos(sm_state_pos_x,sm_state_pos_y)
		ToggleStateButton:SetSize(175,40)
		ToggleStateButton:SetText("Toggle Active")
		-- ToggleStateButton:SetImage("icon16/keyboard.png")
		ToggleStateButton:SetToolTip("Toggle Active")
		ToggleStateButton.DoClick = function(self,val)
			if not IsValid(wep) then return end
			local ply = LocalPlayer()
			-- ply:ChatPrint("JKJKJ")
			if IsValid(ply) and IsValid(wep) then
				net.Start("music_mode_toggle_player_state")
					net.WriteEntity(ply)
					net.WriteEntity(wep)
				net.SendToServer()
				wep:ToggleEnabled()
			end
		end
		
		SettingsMaster:RebuildChordLabels()

		SettingsMaster:SetDraggable(true)
	end
end

-- SWEP.TuneTable = {}

SWEP.ModalTuning = {
	[1] = {0,0,0,0,0,0,0},
	[2] = {0,0,-1,0,0,0,-1},
	[3] = {0,-1,-1,0,0,-1,-1},
	[4] = {0,0,0,1,0,0,0},
	[5] = {0,0,0,0,0,0,-1},
	[6] = {0,0,-1,0,0,-1,-1},
	[7] = {0,-1,-1,0,-1,-1,-1}
}

SWEP.TuneChords = {
	[1] = {{1,-12},{1,0},{3,4},{5,7}},
	[2] = {{2,-10},{2,2},{4,5},{6,9}},
	[3] = {{3,-8},{3,4},{5,7},{7,11}},
	[4] = {{4,-7},{4,4},{6,7},{1,0}},
	[5] = {{5,-5},{5,7},{7,11},{2,2}},
	[6] = {{6,-3},{6,9},{1,0},{3,4}},
	[7] = {{7,-1},{7,11},{2,2},{4,5}}
}

SWEP.TuneTable = {
	[1] = {
		{1,-12,1},
		{1,0,1},
		{1.1,4,3},
		{1.2,7,5},
		{3,-7,4},
		{3,0,1},
		{3.1,5,4},
		{3.2,9,6},
		{5,-5,5},
		{5,2,2},
		{5.1,7,5},
		{5.2,11,7},
		{7,0,1},
		{7,4,3},
		{7,7,5},
		{7,12,1}
	},
	[2] = {
		{7,-12,1},
		{7,0,1},
		{7.1,4,3},
		{7.2,7,5},
		{5,-7,4},
		{5,0,1},
		{5.1,5,4},
		{5.2,9,6},
		{3,-5,5},
		{3,2,2},
		{3.1,7,5},
		{3.2,11,7},
		{1,0,1},
		{1,4,3},
		{1,7,5},
		{1,12,1}
	},
	[3] = {
		{1,-12,1},
		{1,0,1},
		{1.1,4,3},
		{1.2,7,5},
		{5,-7,4},
		{5,0,1},
		{5.1,5,4},
		{5.2,9,6},
		{3,-5,5},
		{3,2,2},
		{3.1,7,5},
		{3.2,11,7},
		{7,0,1},
		{7,4,3},
		{7,7,5},
		{7,12,1}
	},
	[4] = {
		{7,-12,1},
		{7,0,1},
		{7.1,4,3},
		{7.2,7,5},
		{3,-7,4},
		{3,0,1},
		{3.1,5,4},
		{3.2,9,6},
		{5,-5,5},
		{5,2,2},
		{5.1,7,5},
		{5.2,11,7},
		{1,0,1},
		{1,4,3},
		{1,7,5},
		{1,12,1}
	}
}

SWEP.TimeScale = 0.1
SWEP.TuneLength = 0.7
SWEP.LastTimeTunePlayed = 0

function SWEP:PlayIntroTune(draw)
	if CLIENT then
		local own = self:GetOwner()
		if not IsValid(own) then
			return
		end
		-- own:ChatPrint("CLIENT playing tune")
		if draw then
			self.DrawTime = CurTime()
		end
		
		
		if not self.LoadedSettings then
			self:LoadSettings()
		end
		
		
		local mode = self.Config[self.setting_mode]
		local drawtime = self.DrawTime
		if CurTime() > self.LastTimeTunePlayed then
			for k,tbl in pairs(self.TuneTable[math.random(#self.TuneTable)]) do
				timer.Simple(tbl[1]*self.TimeScale,function()
					if IsValid(self) and own:GetActiveWeapon() == self and self.DrawTime == drawtime then
						local dist = tbl[2]
						local degree = tbl[3]
						if istable(dist) then
							dist = table.Random(dist)
						end
						dist = dist + self.root_distances[self.Config[self.setting_root_note]]
						dist = dist + self.ModalTuning[mode][degree]
						local octave = 4
						if dist >= 12 then
						else
							dist = dist-12
							octave = octave+1
						end
						-- local inst = self.Instruments[self.Config[self.setting_instrument_notes]][1]
						local inst = "pizzicato"
						sound.Play("instrument/"..inst.."/c"..tostring(octave)..".wav",self:GetPos(),75,self:GetPitchFromDistance(dist)*100,1)
					end
				end)
			end
		end
		self.LastTimeTunePlayed = CurTime()
	end
end

function SWEP:SetDrawTime(init)
	-- table.Empty(self.TuneTable)
	local own = self:GetOwner()
	if not IsValid(own) then
		return
	end
	if not init then
		if own:IsPlayer() then
			if game.SinglePlayer() and SERVER then
				net.Start("MidinatorUpdateDeployTime")
					net.WriteEntity(self)
				net.Send(own)
			else
				-- own:ChatPrint("TEST1")
			end
		end
	end
	self:PlayIntroTune(true)
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.HoldPos = Vector(19, -3.8, -7.4)
	self.HoldAng = Angle(-16, 182, 94)
	self.HoldBone = "ValveBiped.Bip01_Spine2"
	self:SetDrawTime(true)
end

function SWEP:Deploy()
	self:SetDrawTime(false)
	-- if CLIENT then
		-- if not self.LoadedSettings then
			-- self:LoadSettings()
		-- end
	-- end
	return true
end

if SERVER then
	util.AddNetworkString("MidinatorSinglePlayerPrimaryAttack")
	util.AddNetworkString("MidinatorSinglePlayerSecondaryAttack")
	util.AddNetworkString("MidinatorEnableClient")
	util.AddNetworkString("MidinatorRemoveOnClient")
	util.AddNetworkString("MidinatorRemoveOnServer")
	util.AddNetworkString("MidinatorUpdateSettingString")
	util.AddNetworkString("MidinatorUpdateSettingNumber")
	util.AddNetworkString("MidinatorUpdateSettingBool")
	util.AddNetworkString("MidinatorUpdateSettingTable")
	util.AddNetworkString("MidinatorLoadSettings")
	util.AddNetworkString("MidinatorUpdateKeyPressTime")
	util.AddNetworkString("MidinatorUpdatePitchFireTime")
	util.AddNetworkString("MidinatorUpdateInstrumentFireTime")
	util.AddNetworkString("MidinatorUpdateModeBroadcast")
	util.AddNetworkString("MidinatorUpdateRootBroadcast")
	util.AddNetworkString("MidinatorUpdateDeployTime")
	
	net.Receive("MidinatorUpdateSettingString",function(len,ply)
		-- print("MidinatorUpdateSettingString")
		local wep = net.ReadEntity()
		local setting = net.ReadInt(32)
		local str = net.ReadString()
		if IsValid(wep) and isnumber(setting) and isstring(str) then
			wep.Config[setting] = str
			if setting == wep.setting_root_note then
				if IsValid(ply) then
					net.Start("MidinatorUpdateRootBroadcast")
						net.WriteEntity(ply)
						net.WriteEntity(wep)
						net.WriteString(str)
					net.Broadcast()
					timer.Simple(1,function()
						if IsValid(ply) and IsValid(wep) and str != nil then
							net.Start("MidinatorUpdateRootBroadcast")
								net.WriteEntity(ply)
								net.WriteEntity(wep)
								net.WriteString(str)
							net.Broadcast()
						end
					end)
				end
			end
			-- print("Updated String value to "..str)
		end
	end)
	net.Receive("MidinatorUpdateSettingNumber",function(len,ply)
		local wep = net.ReadEntity()
		local setting = net.ReadInt(32)
		local num = net.ReadFloat()
		if IsValid(wep) and isnumber(setting) and isnumber(num) then
			wep.Config[setting] = num
			if setting == wep.setting_mode then
				if IsValid(ply) then
					net.Start("MidinatorUpdateModeBroadcast")
						net.WriteEntity(ply)
						net.WriteEntity(wep)
						net.WriteInt(num,32)
					net.Broadcast()
					timer.Simple(1,function()
						if IsValid(ply) and IsValid(wep) and num != nil then
							net.Start("MidinatorUpdateModeBroadcast")
								net.WriteEntity(ply)
								net.WriteEntity(wep)
								net.WriteInt(num,32)
							net.Broadcast()
						end
					end)
				end
			end
		end
	end)
	net.Receive("MidinatorUpdateSettingBool",function(len,ply)
		local wep = net.ReadEntity()
		local setting = net.ReadInt(32)
		local bool = net.ReadBool()
		if IsValid(wep) and isnumber(setting) and isbool(bool) then
			wep.Config[setting] = bool
		end
	end)
	net.Receive("MidinatorUpdateSettingTable",function(len,ply)
		local wep = net.ReadEntity()
		local setting = net.ReadInt(32)
		local offset = net.ReadInt(32)
		local chord = net.ReadInt(32)
		local degree = net.ReadInt(32)
		local inversion_dist = net.ReadInt(32)
		local inversion_deg = net.ReadInt(32)
		if IsValid(wep) and isnumber(setting) and istable(tbl) then
			wep.Config[setting] = {offset,chord,degree,inversion_dist,inversion_deg}
		end
	end)
	net.Receive("MidinatorUpdateKeyPressTime",function(len,ply)
		local wep = net.ReadEntity()
		local key = net.ReadInt(32)
		local time = net.ReadFloat()
		wep.KeyFireTime[key] = time
	end)
	net.Receive("MidinatorUpdatePitchFireTime",function(len,ply)
		local wep = net.ReadEntity()
		local freq = net.ReadFloat()
		local time = net.ReadFloat()
		wep.PitchFireTime[freq] = {time}
	end)
	net.Receive("MidinatorRemoveOnServer",function(len,ply)
		local wep = net.ReadEntity()
		if IsValid(wep) and wep:GetClass() == midifier_seat_class then
			wep:Remove()
			-- for k,p in pairs(player.GetAll()) do
				-- if p != ply then
					-- net.Start("MidinatorRemoveOnClient")
						-- net.WriteEntity(wep)
					-- net.Send(p)
				-- end
			-- end
		end
	end)
else
	net.Receive("MidinatorRemoveOnClient",function(len,ply)
		local wep = net.ReadEntity()
		if IsValid(wep) and wep:GetClass() == midifier_seat_class then
			wep:Remove()
		end
	end)
	net.Receive("MidinatorSinglePlayerPrimaryAttack",function(len)
		local own = net.ReadEntity()
		local wep = net.ReadEntity()
		if IsValid(own) and IsValid(wep) then
			wep:ToggleEnabled(wep)
		end
	end)
	net.Receive("MidinatorSinglePlayerSecondaryAttack",function(len)
		local wep = net.ReadEntity()
		if IsValid(wep) then
			if not wep.LoadedSettings then
				wep:LoadSettings()
			end
			wep:ShowSettings()
		end
	end)
	net.Receive("MidinatorEnableClient",function(len)
		local own = net.ReadEntity()
		local wep = net.ReadEntity()
		if IsValid(own) and IsValid(wep) then
			wep:SetEnabled()
		end
	end)
	net.Receive("MidinatorLoadSettings",function(len)
		local own = net.ReadEntity()
		local wep = net.ReadEntity()
		-- local wep = LocalPlayer():GetWeapon(midifier_guitar_class)
		-- LocalPlayer():ChatPrint(tostring(midifier_guitar_class))
		-- LocalPlayer():ChatPrint("CLIENT: "..tostring(own))
		-- LocalPlayer():ChatPrint("CLIENT: "..tostring(wep))
		if IsValid(wep) then
			wep:LoadSettings()
		end
	end)
	net.Receive("MidinatorUpdateModeBroadcast",function(len)
		local own = net.ReadEntity()
		local wep = net.ReadEntity()
		local mode = net.ReadInt(32)
		local ply = LocalPlayer()
		if IsValid(own) and IsValid(wep) and IsValid(ply) and own != ply and mode != nil and wep.Config != nil then
			wep.Config[wep.setting_mode] = mode
		end
	end)
	net.Receive("MidinatorUpdateRootBroadcast",function(len)
		local own = net.ReadEntity()
		local wep = net.ReadEntity()
		local root = net.ReadString()
		local ply = LocalPlayer()
		if IsValid(own) and IsValid(wep) and IsValid(ply) and own != ply and root != nil and wep.Config != nil then
			wep.Config[wep.setting_root_note] = root
		end
	end)
	net.Receive("MidinatorUpdateDeployTime",function(len)
		local wep = net.ReadEntity()
		if IsValid(wep) then
			-- wep.DrawTime = CurTime()
			if wep.PlayIntroTune != nil then
				wep:PlayIntroTune(true)
			end
		end
	end)
end

function SWEP:PrimaryAttack()
	local own = self:GetOwner()
	if IsValid(own) and own:IsPlayer() then
		if SERVER then
			net.Start("MidinatorSinglePlayerPrimaryAttack")
				net.WriteEntity(own)
				net.WriteEntity(self)
			net.Send(own)
		else
			-- self:ToggleEnabled()
		end
	end
end


function SWEP:SecondaryAttack()
	local own = self:GetOwner()
	if IsValid(own) and own:IsPlayer() then
		if SERVER then
			net.Start("MidinatorSinglePlayerSecondaryAttack")
				net.WriteEntity(self)
			net.Send(own)
		else
			-- self:ShowSettings()
		end
	end
end

function SWEP:Reload()

end




SWEP.ViewModelBone = "v_weapon.c4"


SWEP.ViewModelMdl = "models/props_lab/reciever01d.mdl"
SWEP.ViewModelScale = 0.5
SWEP.ViewModelPos = Vector(-4.3,1.1,-1.4)
SWEP.ViewModelAng = Angle(0,90,0)




SWEP.ViewModelScreenPos = Vector(-2.6,3.7,1.35)
SWEP.ViewModelScreenAng = Angle(180,0,-90)
SWEP.ViewModelTip = "  Mouse 1:   |    Mouse 2:\n  Activate    |    Settings"
SWEP.ViewModelTip2 = SWEP.MIDIFIER_TITLE
SWEP.ViewModelTip3 = "|"

SWEP.WorldModelPos = Vector(8,-6,-2)
SWEP.WorldModelAng = Angle(0,40,-160)
SWEP.WorldModelScale = 0.75
SWEP.WorldModelBone = "ValveBiped.Bip01_R_Hand"
SWEP.BaseModel = "models/props_lab/monitor01b.mdl"
SWEP.ScreenPos = Vector(4.85,-4.25,3.925)
SWEP.ScreenAng = Angle(0,90,89.65)
SWEP.MedalPos = Vector(4.43,4,2.925)
SWEP.MedalAng = Angle(0,90,89.65)
SWEP.TopModel = "models/props_lab/reciever01d.mdl"
SWEP.Screen2Pos = Vector(4.425,-3.85,-1.225)
SWEP.Screen2Ang = Angle(180,270,90)
SWEP.Screen3Pos = Vector(4.6,1.89,0.2565)
SWEP.Screen3Ang = Angle(180,270,270)
-- SWEP.ScreenColor = Color()
SWEP.WMScrn1Width = 248
SWEP.WMScrn1Height = 256
SWEP.WMScrn2Width = 128
SWEP.WMScrn2Height = 64
SWEP.WMScrn3Width = 60
SWEP.WMScrn3Height = 24

-- hook.Add( "PlayerSay", "CoinFlip", function( ply, text )
	-- for k,v in pairs(ents.FindByClass("weapon_the_instrument")) do
		-- v.ScreenSprite2 = text
	-- end
-- end)

if CLIENT then
	surface.CreateFont("WorldModelModeFont",{font = "Roboto",extended = false,size = 25,weight = 1200,blursize = 0,scanlines = 2,antialias = true,underline = false,italic = false,strikeout = false,symbol = false,rotary = false,shadow = false,additive = false,outline = false})
	surface.CreateFont("ViewModelFont",{font = "Roboto",extended = false,size = 13,weight = 1200,blursize = 0,scanlines = 2,antialias = true,underline = false,italic = false,strikeout = false,symbol = false,rotary = false,shadow = false,additive = false,outline = false})
	surface.CreateFont("ViewModelTitleFont",{font = "Roboto",extended = false,size = 20,weight = 1200,blursize = 0,scanlines = 4,antialias = true,underline = false,italic = true,strikeout = false,symbol = false,rotary = false,shadow = false,additive = false,outline = false})
	-- local WorldModelPos = SWEP.WorldModelPos
	-- local WorldModelAng = SWEP.WorldModelAng
	-- local WorldModelScale = SWEP.WorldModelScale
	-- local WorldModelBone = "ValveBiped.Bip01_R_Hand"
	local bar_count = 32
	local bar_gap_prop = 0
	local bar_width = SWEP.WMScrn2Width/(bar_count+bar_count*bar_gap_prop)
	local bar_start_x = bar_gap_prop*bar_width/2
	local bar_start_y = (SWEP.WMScrn2Height)/2
	local bar_gap = bar_width*bar_gap_prop
	local bar_dist = bar_width+bar_gap
	local speaker_min_width = 24
	local speaker_size = 220
	
	local speaker_bg_color = Color(0,0,0,255)
	
	local speaker_start_y = SWEP.WMScrn1Height/2-speaker_size/2
	
	local speaker_start_x = SWEP.WMScrn1Width/2-speaker_size/2
	
	local scanline_height = 4
	local scaline_max_y = SWEP.WMScrn1Height-scanline_height
	local scanline_grad_rows = 8
	local scanline_count = 4
	local scanline_mults = {}
	for i = 1,scanline_count do
		scanline_mults[i] = math.Rand(50,150)
	end
	
	local dead_pixel_size = 10
	local dead_pixel_max_x = SWEP.WMScrn1Width-dead_pixel_size
	local dead_pixel_max_y = SWEP.WMScrn1Height-dead_pixel_size
	
	function DrawSpeakerCircle(speaker_size,size,color,x,y,scale)
		local offset = (speaker_size-size)/2
		draw.RoundedBox(size/2,x+offset,y+offset,size,size,color)
	end
	
	SWEP.ExtraModels = {
		{"models/props_lab/monitor01b.mdl",Vector(0,0,0),Angle(0,0,0),1},
		{"models/props_lab/reciever01d.mdl",Vector(-1.2990112304688,0.23222351074219,4.71875),Angle(-35.321029663086,-0.19068551063538,-0.1580186188221),1},
		{"models/props_canal/winch02d.mdl",Vector(20.46875,19.255859375,-41.931640625),Angle(0.076906405389309,90.010971069336,-0.021973717957735),1},
		{"models/props_c17/trappropeller_lever.mdl",Vector(-0.0328369140625,4.7088775634766,2.5322265625),Angle(89.984718322754,21.22008895874,0),1},
		{"models/props_lab/monitor01b.mdl",Vector(0,0,0),Angle(1.0422042118208e-09,1.7075473124351e-06,-2.0844083403748e-10),1},
		{"models/props_wasteland/panel_leverhandle001a.mdl",Vector(1.3426208496094,0.62825012207031,0),Angle(0.010986854322255,-179.99450683594,-90),1}
	}
	
	
	SWEP.UserIcons = {
		["STEAM_0:0:44326512"] = Material("icon16/award_star_gold_3.png"),--me
		["STEAM_0:0:26882932"] = Material("icon16/palette.png"),--dekor
		["STEAM_0:1:14376588"] = Material("icon16/bug.png"),--clyde
		["STEAM_0:0:57652372"] = Material("icon16/bug.png"),--tall
		["STEAM_0:0:114863350"] = Material("icon16/bug.png"),--peace
		["STEAM_0:1:48707013"] = Material("icon16/cog.png")--cogs
	}
	-- SWEP.CreatorIcon = Material("icon16/heart.png")
	-- SWEP.Des = Material("icon16/star.png")
	
	-- -- SWEP.ScreenSprite = 
	-- SWEP.ScreenSprites
	-- SWEP.ScreenSpriteString = "effects/bluelaser1"
	-- table.Empty(SWEP.ScreenOverlays)
	SWEP.ScreenOverlays = {
		-- {Material("decals/extinguish1"),Color(255,255,255,255),1},
		-- {Material("effects/flicker_256"),Color(255,255,255,255),1},
		{Material("models/props_c17/frostedglass_01a_dx60"),Color(255,255,255,255),1}
	}
	-- SWEP.ScreenColor = Color(255,255,255,64)
	-- SWEP.ScreenSprite = Material("effects/flicker_256")
	-- SWEP.ScreenSprite = Material("dev/dev_prisontvoverlay004")
	-- SWEP.SpritePasses = 1
	-- SWEP.ScreenColor2 = Color(255,255,255,255)
	-- SWEP.ScreenSprite2 = Material("models/props_c17/frostedglass_01a_dx60")
	-- SWEP.SpritePasses2 = 1
	-- SWEP.ScreenSprite = CreateMaterial( Material(SWEP.ScreenSpriteString):GetName(), "UnlitGeneric", {
	  -- ["$basetexture"] = SWEP.ScreenSpriteString,
	  -- ["$alphatest"] = 1,
	  -- -- ["$translucent"] = 1,
	  -- -- ["$vertexalpha"] = 1,
	  -- -- ["$vertexcolor"] = 1
	-- } )
	
	SWEP.ScreenSpeakerColor = Color(197,197,197)
	SWEP.ScreenSpeakerBGColor = Color(0,0,0)
	-- SWEP.ScreenSprite = CreateMaterial( Material(SWEP.ScreenSpriteString):GetName(), "UnlitGeneric", {
	  -- ["$basetexture"] = SWEP.ScreenSpriteString,
	  -- ["$alphatest"] = 1,
	  -- -- ["$translucent"] = 1,
	  -- -- ["$vertexalpha"] = 1,
	  -- -- ["$vertexcolor"] = 1
	-- } )
	
	function SWEP:DrawWorldModelRecieverScreen1(mode,vm,scale,x,y)
		local width = self.WMScrn2Width*scale
		local height = self.WMScrn2Height*scale
		local bar_count = 32
		local speed = 1/4
		if vm then
			-- bar_count = 64
			-- speed = 1/4
			-- width = width*2
			-- height = height*0.75
			-- bar_height = bar_width
			-- bar_corner = bar_height/2
		end
		local bar_gap_prop = 0
		local bar_width = width/(bar_count+bar_count*bar_gap_prop)
		local bar_start_x = bar_gap_prop*bar_width/2
		local bar_start_y = (height)/2
		local bar_gap = bar_width*bar_gap_prop
		local bar_dist = bar_width+bar_gap
		local bar_height = bar_width*2
		local bar_corner = 0
		
		-- if vm then
			-- bar_height = bar_width
			-- bar_corner = bar_height/2
		-- else
		draw.RoundedBox(1,x,y,width,height,Color(math.random(0,0),math.random(0,0),math.random(0,16),255))
		-- end

		for freq,tbl in pairs(self.PitchFireTime) do
			
			local time = tbl[1]
			local degree = tbl[2]
			local color = self.degree_colors[(degree+mode-2)%7+1]
			
			if CurTime()-time < self.PitchDisplayTime then
				-- table.remove(self.PitchFireTime,freq)\
				local time_proportion = (CurTime()-time)/self.PitchDisplayTime
				for i = 0,bar_count-1 do
					local sin_height = math.sin(i*freq/1000+CurTime()*freq*speed)*25*scale-bar_height/2
					local degree_color = self.degree_colors[(math.random(1,7))%7+1]
					draw.RoundedBox(bar_corner,x+bar_start_x+i*bar_dist,y+bar_start_y+sin_height,bar_width,bar_height,Color(color.r,color.g,color.b,255-255*time_proportion))
				end
			else
				table.remove(self.PitchFireTime,freq)
			end
		end
		if not vm then
			for k,tbl in pairs(self.ScreenOverlays) do
				surface.SetDrawColor(tbl[2])
				surface.SetMaterial(tbl[1])
				for i = 1,math.random(1,2) do
					surface.DrawTexturedRectRotated(width/2,height/2,width,height,0)
				end
			end
		end
	end
	function SWEP:DrawMedals(scale,steamid)
		-- draw.RoundedBox(1,(400*scale)+15,5,20,20,Color(255,255,255,255))
		-- surface.SetDrawColor(0,0,0,255)
		if self.UserIcons[steamid] != nil then		
			surface.SetMaterial(self.UserIcons[steamid])
			surface.DrawTexturedRect(0,0,16,16)
		end
		-- surface.DrawTexturedRect(0,24,16,16)
		-- surface.DrawTexturedRect(0,48,16,16)
		-- surface.DrawTexturedRect(0,72,16,16)
	end
	function SWEP:DrawWorldModelRecieverScreen2(mode,vm,scale,x,y,steamid)
		local font = "WorldModelModeFont"
		-- if vm then
			-- font = "HudNoteSquareRootLetter"
		-- end
		local mode_name = self.ModeTable[self.Config[self.setting_mode]][1]
		mode_name = mode_name[1]..mode_name[2]..mode_name[3]
		local m_c = self.degree_colors[self.Config[self.setting_mode]]
		-- local m_c = mode_color
		-- mode_color = Color(m_c.r,m_c.g,m_c.b,math.random(255,255))
		-- draw.RoundedBox(1,x,y,self.WMScrn3Width*scale,self.WMScrn3Height*scale,Color(math.random(0,0),math.random(0,0),math.random(0,16),255))
		draw.DrawText(self.Config[self.setting_root_note],font,x+8,y+5,m_c,TEXT_ALIGN_LEFT)
		draw.DrawText(mode_name,font,x+(40*scale)+15,y+5,m_c,TEXT_ALIGN_LEFT)
		-- surface.SetDrawColor(255,255,255,255)
		-- draw.RoundedBox(1,x+(400*scale)+15,y+5,20,20,m_c)
		-- surface.SetDrawColor(0,0,0,255)
		-- surface.SetMaterial(self.CreatorIcon)
		-- surface.DrawTexturedRect(x+(400*scale)+15,y+5,16,16)
		if steamid != nil then
			if self.UserIcons[steamid] != nil then		
				surface.SetMaterial(self.UserIcons[steamid])
				surface.DrawTexturedRect(220,16,16,16)
			end
		end
	end
	function SWEP:DrawWorldModelMonitorScreen(mode,vm,scale,x,y)
		local width = self.WMScrn1Width*scale
		local height = self.WMScrn1Height*scale
		local bg_corner = 0
		if vm then
			width = height
			-- height = width
			bg_corner = height/2
		end
		local speaker_min_width = 24*scale
		local speaker_size = 220*scale
		local speaker_start_x = width/2-speaker_size/2
		local speaker_start_y = height/2-speaker_size/2
		speaker_bg_color = Color(0,0,0,255)
		spkr_r = self.ScreenSpeakerColor.r
		spkr_g = self.ScreenSpeakerColor.g
		spkr_b = self.ScreenSpeakerColor.b
		if not vm then
			speaker_bg_color = self.ScreenSpeakerBGColor
			spkr_r = self.ScreenSpeakerColor.r
			spkr_g = self.ScreenSpeakerColor.g
			spkr_b = self.ScreenSpeakerColor.b
		end
		local speaker_color_dark = speaker_bg_color
		
		draw.RoundedBox(bg_corner,x,y,width,height,speaker_bg_color)

		local time_proportions = {}
		for i = 1,3 do
			local freq = self.InstrumentFireTime[i][2]
			local time_prop = (1-math.Clamp((CurTime()-self.InstrumentFireTime[i][1])/self.InstrumentDisplayTime,0,1))
			time_proportions[i] = {time_prop,time_prop/2+time_prop*math.sin(CurTime()*freq)*time_prop/2}
		end
		local time_proportion_1 = time_proportions[1][2]
		local time_proportion_2 = time_proportions[2][2]
		local time_proportion_3 = time_proportions[3][2]
		
		local instrument_colors = {}
		for i = 1,3 do
			local degree = self.InstrumentFireTime[i][3]
			-- local degree = i
			local d_c = self.degree_colors[(degree+mode-2)%7+1]
			local prop = time_proportions[i][1]
			local color = Color(
				d_c.r*prop+spkr_r*(1-prop),
				d_c.g*prop+spkr_g*(1-prop),
				d_c.b*prop+spkr_b*(1-prop),
				-- 100,100,100,
				255-d_c.a*prop/2)
			instrument_colors[i] = color
		end
		local instrument_color_1 = instrument_colors[1]
		local instrument_color_2 = instrument_colors[2]
		local instrument_color_3 = instrument_colors[3]
		
		local speaker_color_mid_1 = speaker_color_dark
		local speaker_color_mid_2 = speaker_color_dark
		
		local speaker_x = x+speaker_start_x
		local speaker_y = y+speaker_start_y
		
		-- print(speaker_size,speaker_x,speaker_y,scale)
		
		DrawSpeakerCircle(speaker_size,speaker_size*(1+time_proportion_1*.2),instrument_color_1,speaker_x,speaker_y,scale)
		DrawSpeakerCircle(speaker_size,speaker_size*.95,speaker_color_mid_1,speaker_x,speaker_y,scale)
		DrawSpeakerCircle(speaker_size,speaker_size*.85,instrument_color_2,speaker_x,speaker_y,scale)
		DrawSpeakerCircle(speaker_size,speaker_size*(.8-time_proportion_2*.2),speaker_color_mid_2,speaker_x,speaker_y,scale)
		DrawSpeakerCircle(speaker_size,speaker_size*(.35+time_proportion_3*.2),instrument_color_3,speaker_x,speaker_y,scale)
		
		if not vm then
			for k,tbl in pairs(self.ScreenOverlays) do
				surface.SetDrawColor(tbl[2])
				surface.SetMaterial(tbl[1])
				for i = 1,math.random(1,2) do
					surface.DrawTexturedRectRotated(height/2,width/2,height,width,90)
				end
			end
		end
	end
	function SWEP:DrawViewModelScreen(enabled)
		draw.DrawText(self.ViewModelTip,"ViewModelFont",0,3,Color(255,255,255,255),TEXT_ALIGN_LEFT)
		draw.DrawText(self.ViewModelTip3,"ViewModelFont",60,9,Color(255,255,255,255),TEXT_ALIGN_LEFT)
		local seconds = math.max(0,CurTime()-self.DrawTime-0)
		local alpha = 255
		local tune_over = false
		if seconds > self.TuneLength then
			alpha = 255-(seconds-self.TuneLength)*512
			tune_over = true
		end
		draw.DrawText(self.ViewModelTip2,"ViewModelTitleFont",61,30,Color(255,255,255,255-alpha),TEXT_ALIGN_CENTER)
		for i = 1,14 do
			local i_mod = (i-1)*2
			local i_col = (math.ceil((i-20*seconds)/2)-1)%7+1
			if tune_over then
				i_col = math.ceil(i/2)
			elseif i_col < 1 and i_col > -7 then
				i_col = i_col + 7
			end
			i_col = (i_col + self.Config[self.setting_mode]-2)%7+1
			
			local color = self.degree_colors[i_col]
			local color = Color(color.r,color.g,color.b,alpha)
			local string = self.ViewModelTip2[0+i]
			draw.DrawText(string,"ViewModelTitleFont",self.title_indents[i]+61,30,color,TEXT_ALIGN_CENTER)
		end
	end
	
	
	local ClientSideModels = {}
	for k,tbl in pairs(SWEP.ExtraModels) do
		local new_model = ClientsideModel(tbl[1])
		new_model:SetSkin(0)
		new_model:SetNoDraw(true)
		ClientSideModels[k] = new_model
	end
	
	function SWEP:DrawWorldModel()
		local own = self:GetOwner()
		local mode = self.Config[self.setting_mode]
		if IsValid(own) then
			if self:GetClass() == midifier_seat_class then
				local amp = self:GetController()
				if IsValid(amp) then
					local amp_cls = amp:GetClass()
					local amp_mdl = amp:GetModel()
					-- if self.WorldModelBone == nil then
						-- return
					-- end
					-- local boneid = own:LookupBone(self.WorldModelBone)
					-- if !boneid then
						-- return
					-- end
					-- local matrix = own:GetBoneMatrix(boneid)
					for k,mdl_tbl in pairs(amp.ScreenInfo[amp_mdl]) do
						if mdl_tbl != nil then
							local offsetVec = mdl_tbl[1]
							local offsetAng = mdl_tbl[2]
							
							local scrnPos,scrnAng = LocalToWorld(offsetVec,offsetAng,amp:GetPos(),amp:GetAngles())

							local scrnscl = mdl_tbl[3]
							local scrntype = mdl_tbl[4]
							
							if scrntype == 1 then
								cam.Start3D2D(scrnPos,scrnAng,scrnscl)
									self:DrawWorldModelMonitorScreen(mode,true,1,0,0)
								cam.End3D2D()
							elseif scrntype == 2 then
								cam.Start3D2D(scrnPos,scrnAng,scrnscl)
									self:DrawWorldModelRecieverScreen1(mode,true,1,0,0)
								cam.End3D2D()
							elseif scrntype == 3 then
								cam.Start3D2D(scrnPos,scrnAng,scrnscl)
									self:DrawWorldModelRecieverScreen2(mode,true,1,0,0)
								cam.End3D2D()
							end
						end
					end
				end
			else
				if self.WorldModelBone == nil then
					return
				end
				local boneid = own:LookupBone(self.WorldModelBone)
				if !boneid then
					return
				end
				local matrix = own:GetBoneMatrix(boneid)
				for k,mdl in pairs(ClientSideModels) do
					
					local mdl_tbl = self.ExtraModels[k]
					
					if !matrix then
						continue
					end
					local new_scale = self.WorldModelScale*own:GetModelScale()
					local offsetVec = mdl_tbl[2]*new_scale
					local offsetAng = mdl_tbl[3]
					local newPos,newAng = LocalToWorld(self.WorldModelPos*own:GetModelScale(),self.WorldModelAng,matrix:GetTranslation(),matrix:GetAngles())
					local newPos,newAng = LocalToWorld(offsetVec,offsetAng,newPos,newAng)
					mdl:SetPos(newPos)
					mdl:SetAngles(newAng)
					mdl:SetupBones()
					mdl:SetModelScale(mdl_tbl[4]*new_scale)
					mdl:DrawModel()
					mdl:SetLOD(0)
					if mdl:GetModel() == self.TopModel then
						local scrnPos,scrnAng = LocalToWorld(self.Screen2Pos*own:GetModelScale(),self.Screen2Ang,newPos,newAng)
						cam.Start3D2D(scrnPos,scrnAng,0.0285*own:GetModelScale())
							self:DrawWorldModelRecieverScreen1(mode,false,1,0,0)
						cam.End3D2D()
						
						-- local scrnPos,scrnAng = LocalToWorld(self.Screen3Pos*own:GetModelScale(),self.Screen3Ang,newPos,newAng)
						-- cam.Start3D2D(scrnPos,scrnAng,0.0285*own:GetModelScale())
							-- self:DrawWorldModelRecieverScreen2(mode,false,1,0,0)
						-- cam.End3D2D()
					end
					if mdl:GetModel() == self.BaseModel then
						local scrnPos,scrnAng = LocalToWorld(self.ScreenPos*own:GetModelScale(),self.ScreenAng,newPos,newAng)
						-- print(scrnPos,scrnAng)
						cam.Start3D2D(scrnPos,scrnAng,0.028*own:GetModelScale())
							self:DrawWorldModelMonitorScreen(mode,false,1,0,0)
							self:DrawWorldModelRecieverScreen2(mode,true,0.5,0,220,own:SteamID())
						cam.End3D2D()
						local medalPos,medalAng = LocalToWorld(self.MedalPos*own:GetModelScale(),self.MedalAng,newPos,newAng)
						-- cam.Start3D2D(medalPos,medalAng,0.028*own:GetModelScale())
							-- self:DrawMedals(1,own:SteamID())
						-- cam.End3D2D()
						-- self:DrawEffects(scrnPos,scrnAng)
					end
				end
			end
		else
			for k,mdl in pairs(ClientSideModels) do
				
				local mdl_tbl = self.ExtraModels[k]
				local offsetVec = mdl_tbl[2]*self.WorldModelScale
				local offsetAng = mdl_tbl[3]
				
				local newPos,newAng = LocalToWorld(offsetVec,offsetAng,self:GetPos(),self:GetAngles())
				mdl:SetPos(newPos)
				mdl:SetAngles(newAng)
				mdl:SetupBones()
				mdl:SetModelScale(mdl_tbl[4]*self.WorldModelScale)
				mdl:DrawModel()
				local t = CurTime()
				
				-- local speed_outer = 25
				-- local speed_mid = 50
				-- local speed_inner = 150
				
				-- local cs1 = 1
				-- local cs2 = 2
				-- local cs3 = 3
				
				-- local ci1 = self.degree_colors[(math.Round(t*cs1)+0)%7+1]
				-- local ci2 = self.degree_colors[(math.Round(t*cs2)+1)%7+1]
				-- local ci3 = self.degree_colors[(math.Round(t*cs3)+2)%7+1]
				
				if k == 5 then
					local scrnPos,scrnAng = LocalToWorld(self.ScreenPos,self.ScreenAng,self:GetPos(),self:GetAngles())
					cam.Start3D2D(scrnPos,scrnAng,0.028)
						
						-- draw.RoundedBox(0,0,0,248,256,Color(32,32,32,255))
						-- DrawSpeakerCircle(220,220*(1.05+math.sin(t*speed_outer)*0.05),ci1,18,18,1)
						-- DrawSpeakerCircle(220,220*(0.95),Color(32,32,32),18,18,1)
						-- DrawSpeakerCircle(220,220*(0.85),ci2,18,18,1)
						-- DrawSpeakerCircle(220,220*(0.75-math.sin(t*speed_mid)*0.05),Color(32,32,32),18,18,1)
						-- DrawSpeakerCircle(220,220*(0.4+math.sin(t*speed_inner)*0.075),ci3,18,18,1)
						
						draw.RoundedBox(0,0,0,248,256,Color(32,32,32,255))
						DrawSpeakerCircle(220,220,Color(196,196,196),18,18,1)
						DrawSpeakerCircle(220,220*0.95,Color(32,32,32),18,18,1)
						DrawSpeakerCircle(220,220*0.85,Color(196,196,196),18,18,1)
						DrawSpeakerCircle(220,220*0.80,Color(32,32,32),18,18,1)
						DrawSpeakerCircle(220,220*0.35,Color(196,196,196),18,18,1)
						
						for k,tbl in pairs(self.ScreenOverlays) do
							surface.SetDrawColor(tbl[2])
							surface.SetMaterial(tbl[1])
							for i = 1,math.random(1,2) do
								surface.DrawTexturedRectRotated(124,128,248,256,90)
							end
						end
					cam.End3D2D()
				elseif k == 2 then
					local scrnPos,scrnAng = LocalToWorld(self.Screen2Pos,self.Screen2Ang,newPos,newAng)
					cam.Start3D2D(scrnPos,scrnAng,0.028)
						
						draw.RoundedBox(0,0,0,128,64,Color(32,32,32,255))
						-- -- DrawSpeakerCircle(220,220,Color(196,196,196),18,18,1)
						-- -- DrawSpeakerCircle(220,220*0.95,Color(32,32,32),18,18,1)
						-- -- DrawSpeakerCircle(220,220*0.85,Color(196,196,196),18,18,1)
						-- -- DrawSpeakerCircle(220,220*0.80,Color(32,32,32),18,18,1)
						-- -- DrawSpeakerCircle(220,220*0.35,Color(196,196,196),18,18,1)
						-- local scale = 1
						-- local width = self.WMScrn2Width*scale
						-- local height = self.WMScrn2Height*scale
						-- local bar_count = 32
						-- local speed = 1/4
						
						-- local bar_gap_prop = 0
						-- local bar_width = width/(bar_count+bar_count*bar_gap_prop)
						-- local bar_start_x = bar_gap_prop*bar_width/2
						-- local bar_start_y = (height)/2
						-- local bar_gap = bar_width*bar_gap_prop
						-- local bar_dist = bar_width+bar_gap
						-- local bar_height = bar_width*2
						-- local bar_corner = 0
						-- local x = 0
						-- local y = 0
						-- for j = 1,3 do
							-- local color = self.degree_colors[(math.Round(CurTime()*3)+1*j)%7+1]
							-- local freq = 50*j
							-- for i = 0,bar_count-1 do
								-- local sin_height = math.sin(i*freq/1000+CurTime()*freq*speed)*25*scale-bar_height/2
								-- draw.RoundedBox(bar_corner,x+bar_start_x+i*bar_dist,y+bar_start_y+sin_height,bar_width,bar_height,color)
							-- end
						-- end
						
						for k,tbl in pairs(self.ScreenOverlays) do
							surface.SetDrawColor(tbl[2])
							surface.SetMaterial(tbl[1])
							for i = 1,math.random(1,2) do
								surface.DrawTexturedRectRotated(64,32,128,64,0)
							end
						end
						
						
					cam.End3D2D()
				end
			end
			-- self:DrawEffects()
		end
		
		
	end
end



if CLIENT then
	local resolution_scale = ScrH()/1080
	local resolution_scale_x = ScrW()/1920
	
	local debug_keyboard_scale = 1

	surface.CreateFont("SettingsMenuChordType",{font = "Roboto",extended = false,size = 18,weight = 1200,blursize = 0,scanlines = 0,antialias = true,underline = false,italic = true,strikeout = false,symbol = false,rotary = false,shadow = false,additive = false,outline = false,})
	surface.CreateFont("SettingsMenuAccidental",{font = "Roboto",extended = false,size = 30,weight = 1200,blursize = 0,scanlines = 0,antialias = true,underline = false,italic = true,strikeout = false,symbol = false,rotary = false,shadow = false,additive = false,outline = false,})
	surface.CreateFont("SettingsMenuChordLetter",{font = "Roboto",extended = false,size = 58,weight = 1200,blursize = 0,scanlines = 0,antialias = true,underline = false,italic = true,strikeout = false,symbol = false,rotary = false,shadow = false,additive = false,outline = false,})
	
	surface.CreateFont("HudNoteSquareRootLetter",{font = "Roboto",extended = false,size = 40*resolution_scale,weight = 1200,blursize = 0,scanlines = 0,antialias = true,underline = false,italic = true,strikeout = false,symbol = false,rotary = false,shadow = false,additive = false,outline = false,})
	surface.CreateFont("HudNoteSquareRootNumber",{font = "Roboto",extended = false,size = 30*resolution_scale,weight = 1200,blursize = 0,scanlines = 0,antialias = true,underline = false,italic = true,strikeout = false,symbol = false,rotary = false,shadow = false,additive = false,outline = false,})
	surface.CreateFont("HudNoteSquareAccidental",{font = "Roboto",extended = false,size = 20*resolution_scale,weight = 1200,blursize = 0,scanlines = 0,antialias = true,underline = false,italic = true,strikeout = false,symbol = false,rotary = false,shadow = false,additive = false,outline = false,})
	surface.CreateFont("HudNoteSquareChord",{font = "Roboto",extended = false,size = 13*resolution_scale,weight = 1200,blursize = 0,scanlines = 0,antialias = true,underline = false,italic = true,strikeout = false,symbol = false,rotary = false,shadow = false,additive = false,outline = false,})
	surface.CreateFont("HudNoteSquareChordRaised",{font = "Roboto",extended = false,size = 10*resolution_scale,weight = 1200,blursize = 0,scanlines = 0,antialias = true,underline = false,italic = true,strikeout = false,symbol = false,rotary = false,shadow = false,additive = false,outline = false,})
	surface.CreateFont("HudNoteSquareMode",{font = "Roboto",extended = false,size = 23*resolution_scale,weight = 1200,blursize = 0,scanlines = 0,antialias = true,underline = false,italic = true,strikeout = false,symbol = false,rotary = false,shadow = false,additive = false,outline = false,})
	surface.CreateFont("HudPianoKeyLabel",{font = "Roboto",extended = false,size = 20*resolution_scale,weight = 1200,blursize = 0,scanlines = 0,antialias = true,underline = false,italic = true,strikeout = false,symbol = false,rotary = false,shadow = false,additive = false,outline = false,})
	surface.CreateFont("HudVcIcon",{font = "Roboto",extended = false,size = 15*resolution_scale,weight = 1200,blursize = 0,scanlines = 0,antialias = true,underline = false,italic = true,strikeout = false,symbol = false,rotary = false,shadow = false,additive = false,outline = false,})
	-- local degree_colors = {
		-- Color(255,0,0,255),
		-- Color(255,176,20,255),
		-- Color(239,230,0,255),
		-- Color(0,211,0,255),
		-- Color(72,0,255,255),
		-- Color(184,0,229,255),
		-- Color(255,0,203,255)
	-- }
	-- local degree_colors = {
		-- Color(255,0,78,255),
		-- Color(255,137,14,255),
		-- Color(231,196,11,255),
		-- Color(69,180,0,255),
		-- Color(62,198,255,255),
		-- Color(116,95,231,255),
		-- Color(240,95,254,255)
	-- }
	-- local degree_colors = {
		-- Color(255,255,255,255),
		-- Color(255,255,255,255),
		-- Color(255,255,255,255),
		-- Color(255,255,255,255),
		-- Color(255,255,255,255),
		-- Color(255,255,255,255),
		-- Color(255,255,255,255)
	-- }
	
	local hud_piano_color_black = Color(0,0,0,255)
	local hud_piano_color_white = Color(255,255,255,255)
	local hud_keyboard_bg_color = Color(0,0,0,255)
	
	local hud_keyboard_spacebar_color = Color(196,196,196,255)
	local hud_keyboard_spacebar_label_color = Color(0,0,0,255)
	
	local hud_piano_num_keys = 31
	local hud_piano_key_width = 48*resolution_scale
	local hud_piano_key_height = hud_piano_key_width*5.8
	local hud_piano_key_margin = hud_piano_key_width/8
	local hud_piano_key_distance = hud_piano_key_width+hud_piano_key_margin
	local hud_piano_key_corner = hud_piano_key_margin
	local hud_piano_key_square_start = hud_piano_key_height-hud_piano_key_width+hud_piano_key_margin
	local hud_piano_key_start_y = hud_piano_key_margin
	
	local hud_piano_key_label_offest_x = hud_piano_key_width/2
	local hud_piano_key_label_offest_y = hud_piano_key_height*0.7
	
	
	local hud_piano_black_key_width = hud_piano_key_width*0.75
	local hud_piano_black_key_height = hud_piano_key_width*2.9
	local hud_piano_black_key_start = hud_piano_key_width+hud_piano_key_margin/2-(hud_piano_black_key_width/2)
	local hud_piano_black_key_square_start_x = hud_piano_key_distance/2
	local hud_piano_black_key_square_start_y = hud_piano_key_margin
	
	local hud_piano_black_key_highlight_margin = hud_piano_key_margin
	local hud_piano_black_key_highlight_width = hud_piano_black_key_width-hud_piano_black_key_highlight_margin*2
	local hud_piano_black_key_highlight_height = hud_piano_black_key_height-hud_piano_black_key_highlight_margin*2-hud_piano_key_start_y
	local hud_piano_black_key_highlight_start_y = hud_piano_black_key_highlight_margin+hud_piano_key_start_y
	
	local hud_piano_black_key_label_offest_x = hud_piano_black_key_start+hud_piano_black_key_width/2
	local hud_piano_black_key_label_offest_y = hud_piano_key_height*0.3
	
	local hud_piano_key_fade_max = 148
	local hud_piano_key_fade_time = 0.3
	local hud_keyboard_key_fade_max = 222
	
	local hud_piano_black_key_fade_max = 196
	
	local hud_piano_width = hud_piano_key_distance*hud_piano_num_keys+hud_piano_key_margin
	local hud_piano_height = hud_piano_key_height+hud_piano_key_margin*2
	
	local hud_piano_start_x = ScrW()/2-hud_piano_width/2
	local hud_piano_start_y = 0
	
	local hud_piano_degree_offset = -3
	

	local hud_keyboard_num_columns = 10
	local hud_keyboard_num_rows = 4
	
	
	local hud_keyboard_row_indents = {
		[1] = 0,
		[2] = 0.5,
		[3] = 0.75,
		[4] = 1.25,
		[5] = 1.5
	}
	
	local hud_keyboard_key_size = debug_keyboard_scale*hud_piano_key_width
	local hud_keyboard_key_gap = hud_keyboard_key_size*(9/24)
	local hud_keyboard_key_gap_large = hud_keyboard_key_gap*(8/7)
	local hud_keyboard_key_distance = hud_keyboard_key_size+hud_keyboard_key_gap
	local hud_keyboard_key_distance_large = hud_keyboard_key_size+hud_keyboard_key_gap_large
	local hud_keyboard_row_width = (hud_keyboard_num_columns)*hud_keyboard_key_distance+hud_keyboard_key_gap_large+hud_keyboard_key_gap
	local hud_keybord_text_color = Color(128,128,128,255)
	local hud_keyboard_text_margin = 4
	
	
	local hud_keyboard_vc_height = hud_keyboard_key_size*0.8
	local hud_keyboard_vc_width = hud_keyboard_key_size*2
	local hud_keyboard_vc_offset_y = hud_keyboard_vc_height+hud_keyboard_key_gap
	
	local hud_keyboard_spacebar_height = hud_keyboard_key_size*0.8
	local hud_keyboard_spacebar_width = hud_keyboard_key_distance*5+hud_keyboard_key_size
	local hud_keyboard_spacebar_offset_y = hud_keyboard_spacebar_height+hud_keyboard_key_gap
	
	local hud_keyboard_row_height = hud_keyboard_key_distance+hud_keyboard_key_gap
	local hud_keyboard_width = hud_keyboard_row_width+hud_keyboard_row_indents[4]*hud_keyboard_key_size
	local hud_keyboard_height = hud_keyboard_key_distance*4+hud_keyboard_key_gap+hud_keyboard_spacebar_offset_y
	local hud_keyboard_start_x = ScrW()/2-hud_keyboard_width/2
	local hud_keyboard_start_y = ScrH()-hud_keyboard_height
	
	
	local hud_keyboard_vc_start_x = hud_keyboard_start_x+hud_keyboard_row_indents[5]*hud_keyboard_key_distance+hud_keyboard_key_distance
	local hud_keyboard_vc_start_y = hud_keyboard_start_y+hud_keyboard_height-hud_keyboard_vc_offset_y
	
	local hud_keyboard_vc_icon = Material("voice/icntlk_sv")
	local hud_keyboard_vc_icon_size = hud_keyboard_vc_height*.75
	local hud_keyboard_vc_icon_start_y = hud_keyboard_vc_start_y+(hud_keyboard_vc_height-hud_keyboard_vc_icon_size)/2
	local hud_keyboard_vc_icon_start_x = hud_keyboard_vc_start_x+(hud_keyboard_vc_height-hud_keyboard_vc_icon_size)/2

	local hud_keyboard_vc_label_start_x = hud_keyboard_vc_start_x+hud_keyboard_vc_width*.66
	local hud_keyboard_vc_label_start_y = hud_keyboard_vc_start_y+hud_keyboard_vc_height/2
	local hud_keyboard_vc_label_real_x = hud_keyboard_vc_start_x-hud_keyboard_key_size*.15
	local hud_keyboard_vc_label_real_y = hud_keyboard_vc_start_y
	
	local hud_keyboard_spacebar_start_x = hud_keyboard_start_x+hud_keyboard_row_indents[5]*hud_keyboard_key_distance+hud_keyboard_key_distance*2+hud_keyboard_key_distance_large-3
	local hud_keyboard_spacebar_start_y = hud_keyboard_start_y+hud_keyboard_height-hud_keyboard_spacebar_offset_y
	
	local hud_keyboard_spacebar_label_start_x = hud_keyboard_spacebar_start_x+hud_keyboard_spacebar_width/2
	local hud_keyboard_spacebar_label_start_y = hud_keyboard_spacebar_start_y+hud_keyboard_spacebar_height/2
	
	local hud_keyboard_mode_start_x = hud_keyboard_spacebar_start_x+hud_keyboard_spacebar_width+hud_keyboard_key_gap
	local hud_keyboard_mode_start_y = hud_keyboard_start_y+hud_keyboard_height-hud_keyboard_spacebar_offset_y
	local hud_keyboard_mode_height = hud_keyboard_spacebar_height
	local hud_keyboard_mode_width = hud_keyboard_key_size*1.6
	
	local hud_keyboard_mode_label_root_start_x = hud_keyboard_mode_start_x+hud_piano_key_width/16
	local hud_keyboard_mode_label_root_start_y = hud_keyboard_mode_start_y+hud_keyboard_mode_height/2
	
	local hud_keyboard_press_distance_x = hud_keyboard_key_size/32
	local hud_keyboard_press_distance_y = hud_keyboard_press_distance_x*2
	local hud_keyboard_press_alpha = 96
	
	
	local hud_no_sharp = 1
	local hud_no_flat = 2
	local hud_sharp_and_flat = 3
	
	local hud_sharps_flats = {
		["A"] = hud_sharp_and_flat,
		["B"] = hud_no_sharp,
		["C"] = hud_no_flat,
		["D"] = hud_sharp_and_flat,
		["E"] = hud_no_sharp,
		["F"] = hud_no_flat,
		["G"] = hud_sharp_and_flat		
	}
	
	local hud_square_letter_x_offset = 0.06
	local hud_square_letter_y_offset = 0.05
	
	local hud_square_accidental_x_offset = hud_square_letter_x_offset+0.45
	local hud_square_accidental_y_offset = 0
	local hud_square_accidental_distances = {
		["b"] = 0.125,
		["#"] = 0.2,
		["x"] = 0.125
	}

	local hud_square_accidental_start_offsets = {
		["b"] = 0.10,
		["#"] = 0.1,
		["x"] = 0.15,
		["xx"] = 0.075
	}

	local hud_square_number_x_offset = 0.55
	local hud_square_number_y_offset = 0.35
	
	local hud_square_chord_offset_x = 0.95
	local hud_square_chord_offset_y = 0.6625
	
	local hud_chord_raised_offset_y = -0.075
	
	function SWEP:HudDrawToneSquare(x_pos,y_pos,scale,outline,degree,root_name,mode,cnum,alpha,chord_inversion_degree)
		outline = outline
		local outline2 = outline*2
		draw.RoundedBox(0,x_pos-outline,y_pos-outline,scale+outline2,scale+outline2,hud_piano_color_black)
		
		if chord_inversion_degree != nil and chord_inversion_degree != -100 then
			degree = chord_inversion_degree
		end
		
		local color_index = (degree+mode-2)%7+1
		local color = self.degree_colors[color_index]
		
		if alpha != nil then
			color = Color(color.r,color.g,color.b,alpha)
		end
		
		draw.RoundedBox(0,x_pos,y_pos,scale,scale,color)
		local letter_x_offset = hud_square_letter_x_offset*scale
		local letter_y_offset = hud_square_letter_y_offset*scale
		draw.Text({
			text = root_name[1],
			pos = {x_pos+letter_x_offset,y_pos+letter_y_offset},
			font = "HudNoteSquareRootLetter",
			color = hud_piano_color_black
		})
		
		if #root_name > 1 then
			local accidentals = string.Right(root_name,#root_name-1)
			local accidental_x_start = hud_square_accidental_x_offset*scale
			local accidental_y_start = hud_square_accidental_y_offset*scale
			
			if hud_square_accidental_start_offsets[accidentals] != nil then
				accidental_x_start = accidental_x_start+hud_square_accidental_start_offsets[accidentals]*scale
			end
			
			for a = 1,#accidentals do
				-- local accidental_x_offset = 
				-- local accidental_y_offset = 
				local text = accidentals[a]
				local accidental_offset = 0
				if a > 1 then
					accidental_offset = hud_square_accidental_distances[accidentals[a-1]]
				end
				
				draw.Text({
					text = text,
					pos = {x_pos+accidental_x_start+accidental_offset*(a-1)*scale,y_pos+accidental_y_start},
					font = "HudNoteSquareAccidental",
					color = hud_piano_color_black
				})
			end
		end
		
		if isnumber(cnum) then
			local number_x_offset = hud_square_number_x_offset*scale
			local number_y_offset = hud_square_number_y_offset*scale
			draw.Text({
				text = tostring(cnum),
				pos = {x_pos+number_x_offset,y_pos+number_y_offset},
				font = "HudNoteSquareRootNumber",
				color = hud_piano_color_black
			})
		elseif isstring(cnum) then
			local chord_x_offset = hud_square_chord_offset_x*scale
			local chord_y_offset = hud_square_chord_offset_y*scale
			if #cnum == 3 then
				cnum = cnum.." "
			elseif #cnum == 2 then
				cnum = cnum.."  "
			end
			
			local raise_pos = 0
			
			for i = 1,#cnum do
				if cnum[i] == "!" then
					raise_pos = i
					break
				end
			end
			
			local raised_text = nil
			
			if raise_pos != nil and raise_pos > 0 then
				-- LocalPlayer():ChatPrint(raise_pos)
				raised_text = cnum[raise_pos+1]
				if raised_text != nil then
					cnum = string.Left(cnum,-raise_pos+1).."  "
				end
			end
			
			draw.Text({
				text = cnum,
				pos = {x_pos+chord_x_offset,y_pos+chord_y_offset},
				font = "HudNoteSquareChord",
				color = hud_piano_color_black,
				xalign = TEXT_ALIGN_RIGHT
			})
			
			if raised_text != nil then
				draw.Text({
					text = raised_text,
					pos = {x_pos+chord_x_offset,y_pos+chord_y_offset+hud_chord_raised_offset_y*scale},
					font = "HudNoteSquareChordRaised",
					color = hud_piano_color_black,
					xalign = TEXT_ALIGN_RIGHT
				})
			end
		end
	end
	
	local distance_octaves = {}
	for i = 36,47 do
		distance_octaves[i] = 7
	end
	for i = 24,35 do
		distance_octaves[i] = 6
	end
	for i = 12,23 do
		distance_octaves[i] = 5
	end
	for i = 0,11 do
		distance_octaves[i] = 4
	end
	for i = -12,-1 do
		distance_octaves[i] = 3
	end
	for i = -24,-13 do
		distance_octaves[i] = 2
	end
	for i = -36,-25 do
		distance_octaves[i] = 1
	end
	
	
	
	-- local distance_degrees = {
		-- [-48] = 1, [-46] = 2, [-44] = 3, [-43] = 4, [-41] = 5, [-39] = 6, [-37] = 7,
		-- [-36] = 1, [-34] = 2, [-32] = 3, [-31] = 4, [-29] = 5, [-27] = 6, [-25] = 7,
		-- [-24] = 1, [-22] = 2, [-20] = 3, [-19] = 4, [-17] = 5, [-15] = 6, [-13] = 7,
		-- [-12] = 1, [-10] = 2, [-8] = 3, [-7] = 4, [-5] = 5, [-3] = 6, [-1] = 7,
		-- [0] = 1, [2] = 2, [4] = 3, [5] = 4, [7] = 5, [9] = 6, [11] = 7,
		-- [12] = 1, [14] = 2, [16] = 3, [17] = 4, [19] = 5, [21] = 6, [23] = 7,
		-- [24] = 1, [26] = 2, [28] = 3, [29] = 4, [31] = 5, [33] = 6, [35] = 7,
		-- [36] = 1, [38] = 2, [40] = 3, [41] = 4, [43] = 5, [45] = 6, [47] = 7
	-- }

	local hud_keyboard_button_assignments = {
		[1] = {
			[1] = KEY_1,
			[2] = KEY_Q,
			[3] = KEY_A,
			[4] = KEY_Z
		},
		[2] = {
			[1] = KEY_2,
			[2] = KEY_W,
			[3] = KEY_S,
			[4] = KEY_X
		},
		[3] = {
			[1] = KEY_3,
			[2] = KEY_E,
			[3] = KEY_D,
			[4] = KEY_C
		},
		[4] = {
			[1] = KEY_4,
			[2] = KEY_R,
			[3] = KEY_F,
			[4] = KEY_V
		},
		[5] = {
			[1] = KEY_5,
			[2] = KEY_T,
			[3] = KEY_G,
			[4] = KEY_B
		},
		[6] = {
			[1] = KEY_6,
			[2] = KEY_Y,
			[3] = KEY_H,
			[4] = KEY_N
		},
		[7] = {
			[1] = KEY_7,
			[2] = KEY_U,
			[3] = KEY_J,
			[4] = KEY_M
		},
		[8] = {
			[1] = KEY_8,
			[2] = KEY_I,
			[3] = KEY_K,
			[4] = KEY_COMMA
		},
		[9] = {
			[1] = KEY_9,
			[2] = KEY_O,
			[3] = KEY_L,
			[4] = KEY_PERIOD
		},
		[10] = {
			[1] = KEY_0,
			[2] = KEY_P,
			[3] = KEY_SEMICOLON,
			[4] = KEY_SLASH
		}
	}
	
	local degree_distances = {}
	
	for k,v in pairs(distance_degrees) do
		degree_distances[v] = k
	end
	-- print(GetNoteName("D",0,1))
	
	function SWEP:DrawPiano(own,root_note,mode,sharp)
		draw.RoundedBox(0,hud_piano_start_x,hud_piano_start_y,hud_piano_width,hud_piano_height,hud_piano_color_black)
		
		local root_distance = self.note_distances[root_note]
		
		local hud_piano_root_letter = -self.letter_numbers[root_note[1]]+hud_piano_degree_offset
		local white_key_distance = self.note_distances[root_note[1]]-24
		
		
		
		for key = 1,hud_piano_num_keys do
			local key_name = self.simple_note_names[-(hud_piano_root_letter-key-1)%7+1]
			
			if key == 1 then
				if hud_sharps_flats[key_name] == hud_no_sharp then
					white_key_distance = white_key_distance-1
				else
					white_key_distance = white_key_distance-2
				end			
			else
				if hud_sharps_flats[key_name] == hud_no_flat then
					white_key_distance = white_key_distance+1
				else
					white_key_distance = white_key_distance+2
				end
			end
			
			
			
			local key_start_x = hud_piano_start_x+hud_piano_key_margin+hud_piano_key_distance*(key-1)
			local key_start_y = hud_piano_key_start_y
			local distance_from_root = white_key_distance-root_distance
			
			local rgb = 255
			
			local seconds_since_pressed = CurTime() - self.KeysLastPressed[white_key_distance]
			
			if seconds_since_pressed < hud_piano_key_fade_time then
				rgb = (rgb-hud_piano_key_fade_max)+(seconds_since_pressed/hud_piano_key_fade_time)*hud_piano_key_fade_max
			end
			
			local key_color = Color(rgb,rgb,rgb,255)
			
			
			
			draw.RoundedBox(hud_piano_key_corner,key_start_x,key_start_y,hud_piano_key_width,hud_piano_key_height,key_color)
			-- print(self.Config[self.setting_mode])
			local real_key = self.key_distances[mode][distance_from_root+sharp]
			-- print(real_key)
			local real_key_name = ""
			if real_key != nil then
				real_key_name = self.key_names[real_key]
			end

			if real_key_name != "" then
				
				local key_degree = distance_degrees[mode][distance_from_root+sharp]
				if key_degree != nil then
					local note_name = self:GetNoteName(root_note,distance_from_root,key_degree)
					self:HudDrawToneSquare(key_start_x,hud_piano_key_square_start,hud_piano_key_width,hud_piano_key_margin,key_degree,note_name,mode,distance_octaves[white_key_distance],rgb)
				end
				
				draw.Text({
					font = "HudPianoKeyLabel",
					text = tostring(real_key_name),
					-- text = tostring(white_key_distance),
					-- text = tostring(key_distance)..tostring(key_name)..tostring(octave),
					pos = {key_start_x+hud_piano_key_label_offest_x,hud_piano_key_label_offest_y},
					color = hud_piano_color_black,
					xalign = TEXT_ALIGN_CENTER
				})
			end
		end
		
		local black_key_distance = self.note_distances[root_note[1]]-24+1
		for black_key = 1,hud_piano_num_keys do
			local draw_black_key = true
			local key_name = self.simple_note_names[-(hud_piano_root_letter-black_key-1)%7+1]
			
			if black_key == 1 then
				if hud_sharps_flats[key_name] == hud_no_sharp then
					black_key_distance = black_key_distance-1
				else
					black_key_distance = black_key_distance-2
				end			
			else
				if hud_sharps_flats[key_name] == hud_no_flat then
					black_key_distance = black_key_distance+1
				else
					black_key_distance = black_key_distance+2
				end
			end
			
			if hud_sharps_flats[key_name] == hud_no_sharp or black_key == hud_piano_num_keys then
				continue
			end
			local note_name = key_name.."#"
			
			local key_start_x = hud_piano_start_x+hud_piano_key_margin+hud_piano_key_distance*(black_key-1)
			
			
			if draw_black_key then
				draw.RoundedBox(hud_piano_key_corner,key_start_x+hud_piano_black_key_start,0,hud_piano_black_key_width,hud_piano_black_key_height,hud_piano_color_black)

				local rgb = 0
				
				local seconds_since_pressed = CurTime() - self.KeysLastPressed[black_key_distance]
				
				if seconds_since_pressed < hud_piano_key_fade_time then
					rgb = (rgb+hud_piano_black_key_fade_max)-(seconds_since_pressed/hud_piano_key_fade_time)*hud_piano_black_key_fade_max
				end
				
				local key_highlight_color = Color(rgb,rgb,rgb,255)
				draw.RoundedBox(hud_piano_key_corner,key_start_x+hud_piano_black_key_start+hud_piano_black_key_highlight_margin,hud_piano_black_key_highlight_start_y,hud_piano_black_key_highlight_width,hud_piano_black_key_highlight_height,key_highlight_color)
				
				local distance_from_root = black_key_distance-root_distance
				local real_key = self.key_distances[mode][distance_from_root+sharp]
				local real_key_name = ""
				if real_key != nil then
					real_key_name = self.key_names[real_key]
				end
				if real_key_name != "" then
					draw.Text({
						font = "HudPianoKeyLabel",
						text = tostring(real_key_name),
						-- text = tostring(black_key_distance),
						-- text = tostring(key_distance)..tostring(note_name)..tostring(octave),
						pos = {key_start_x+hud_piano_black_key_label_offest_x,hud_piano_black_key_label_offest_y},
						color = hud_piano_color_white,
						xalign = TEXT_ALIGN_CENTER
					})
				end
				
				local key_degree = distance_degrees[mode][distance_from_root+sharp]
				if key_degree != nil then
					local note_name = self:GetNoteName(root_note,distance_from_root,key_degree)
					self:HudDrawToneSquare(key_start_x+hud_piano_black_key_square_start_x,hud_piano_start_y+hud_piano_black_key_square_start_y,hud_piano_key_width,hud_piano_key_margin,key_degree,note_name,mode,distance_octaves[black_key_distance],255-rgb)
				end
			end
			-- self:HudDrawToneSquare(key_start_x+hud_piano_black_key_square_start_x,hud_piano_start_y+hud_piano_black_key_square_start_y,hud_piano_key_width,hud_piano_key_margin,1,note_name,1)
		end
	end
	
	function SWEP:DrawKeyboard(own,root_note,mode,sharp,vc)
		local column_gap = 0
		local root_string = self.Config[self.setting_root_note]
		local mode_string = self.ModeTable[mode][1]
		local mode_string = mode_string[1]..mode_string[2]..mode_string[3]
		
		for row = 1,hud_keyboard_num_rows+1 do
			local row_indent = hud_keyboard_row_indents[row]*hud_keyboard_key_size
			local row_x = hud_keyboard_start_x+row_indent
			local row_y = hud_keyboard_start_y+hud_keyboard_key_distance*(row-1)
			local row_margin = 0
			if row == 5 then
				row_margin = hud_keyboard_key_gap
			end
			draw.RoundedBox(0,row_x,row_y,hud_keyboard_row_width+row_margin,hud_keyboard_row_height,hud_keyboard_bg_color)
		end
		-- draw.RoundedBox(0,hud_keyboard_start_x,hud_keyboard_start_y,hud_keyboard_width,hud_keyboard_height,hud_piano_color_black)
		
		for column = 1,hud_keyboard_num_columns do
			if column == 4 then
				column_gap = hud_keyboard_key_gap_large
			end
			for row = 1,hud_keyboard_num_rows do
			
				local button_indent_x = 0
				local button_indent_y = 0
			
				local row_indent = hud_keyboard_row_indents[row]*hud_keyboard_key_size
				
				local row_y = hud_keyboard_start_y+hud_keyboard_key_distance*(row-1)
				
				local key = hud_keyboard_button_assignments[column][row]
				
				
				if self.PressedKeysHud[key] then
					button_indent_x = hud_keyboard_press_distance_x
					button_indent_y = hud_keyboard_press_distance_y
					alpha = hud_keyboard_press_alpha
				end
				
				
				local alpha = 255
			
				local seconds_since_pressed = CurTime() - self.KeyFireTime[key]
				
				if seconds_since_pressed < hud_piano_key_fade_time then
					alpha = (alpha-hud_keyboard_key_fade_max)+(seconds_since_pressed/hud_piano_key_fade_time)*hud_keyboard_key_fade_max
				end
				
				
				local button_x = column_gap+hud_keyboard_start_x+row_indent+hud_keyboard_key_gap+hud_keyboard_key_distance*(column-1)
				local button_y = row_y+hud_keyboard_key_gap
				
				local key_distance_from_root = self.key_assignments[key][mode]
				if not self.KeyIsChord[key] then
					-- key_distance_from_root = key_distance_from_root-sharp
					-- local distnace_from
					-- print(mode)
					local note_name = self:GetNoteName(root_note,key_distance_from_root-sharp,column-3)
					local key_degree = distance_degrees[mode][key_distance_from_root]
					if key_degree != nil then
						self:HudDrawToneSquare(button_x+button_indent_x,button_y+button_indent_y,hud_keyboard_key_size,0,key_degree,note_name,mode,distance_octaves[key_distance_from_root+self.note_distances[root_note]],alpha)
					end
				else
					local chord = self.Config[self.key_assignments[key][1]]
					
					local chord_name = self.ChordTable[chord[2]][2]
					local chord_root_distance = chord[1]+self.ModeTable[mode][2]
					
					local chord_degree = chord[3]+self.ModeTable[mode][3]
					
					local chord_inversion_degree = chord[5]
					if chord_inversion_degree != -100 then
						chord_inversion_degree = chord[5]+self.ModeTable[mode][3]
					end
					
					local note_name = self:GetNoteName(root_note,chord_root_distance,chord_degree)
					-- print(chord_degree)
					self:HudDrawToneSquare(button_x+button_indent_x,button_y+button_indent_y,hud_keyboard_key_size,0,chord_degree,note_name,mode,chord_name,alpha,chord_inversion_degree)
				end
				
				local real_key_name = self.key_names[key]
				if real_key_name != nil then
					draw.Text({
						font = "HudPianoKeyLabel",
						text = tostring(real_key_name),
						-- text = tostring(white_key_distance),
						-- text = tostring(key_distance)..tostring(key_name)..tostring(octave),
						pos = {button_x-hud_keyboard_text_margin,button_y},
						color = hud_keybord_text_color,
						xalign = TEXT_ALIGN_RIGHT
					})
				end					
			end
		end
		--VC Indicator
		local vc_indent = -vc*hud_keyboard_press_distance_x
		draw.RoundedBox(0,hud_keyboard_vc_start_x+vc_indent,hud_keyboard_vc_start_y+vc_indent,hud_keyboard_vc_width,hud_keyboard_vc_height,hud_keyboard_spacebar_color)
		surface.SetDrawColor(Color(0,0,0,255))
		surface.SetMaterial(hud_keyboard_vc_icon)
		surface.DrawTexturedRect(hud_keyboard_vc_icon_start_x+vc_indent,hud_keyboard_vc_icon_start_y+vc_indent,hud_keyboard_vc_icon_size,hud_keyboard_vc_icon_size)
		draw.Text({
			font = "HudVcIcon",
			text = "Voice",
			-- text = tostring(white_key_distance),
			-- text = tostring(key_distance)..tostring(key_name)..tostring(octave),
			pos = {hud_keyboard_vc_label_start_x+vc_indent,hud_keyboard_vc_label_start_y+vc_indent},
			color = hud_keyboard_spacebar_label_color,
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER
		})
		draw.Text({
			font = "HudPianoKeyLabel",
			text = "ALT",
			-- text = tostring(white_key_distance),
			-- text = tostring(key_distance)..tostring(key_name)..tostring(octave),
			pos = {hud_keyboard_vc_label_real_x,hud_keyboard_vc_label_real_y},
			color = hud_keybord_text_color,
			xalign = TEXT_ALIGN_RIGHT
		})
		--SPacebar
		local spacebar_indent = -sharp*hud_keyboard_press_distance_x
		draw.RoundedBox(0,hud_keyboard_spacebar_start_x+spacebar_indent,hud_keyboard_spacebar_start_y+spacebar_indent,hud_keyboard_spacebar_width,hud_keyboard_spacebar_height,hud_keyboard_spacebar_color)
		draw.Text({
			font = "HudNoteSquareRootLetter",
			text = "#",
			-- text = tostring(white_key_distance),
			-- text = tostring(key_distance)..tostring(key_name)..tostring(octave),
			pos = {hud_keyboard_spacebar_label_start_x+spacebar_indent,hud_keyboard_spacebar_label_start_y+spacebar_indent},
			color = hud_keyboard_spacebar_label_color,
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER
		})
		--MODE (bottom right)
		-- draw.RoundedBox(0,hud_keyboard_mode_start_x,hud_keyboard_mode_start_y,hud_keyboard_mode_width,hud_keyboard_mode_height,self.degree_colors[mode])
		draw.Text({
			font = "HudNoteSquareRootLetter",
			text = root_string[1],
			-- text = tostring(white_key_distance),
			-- text = tostring(key_distance)..tostring(key_name)..tostring(octave),
			pos = {hud_keyboard_mode_label_root_start_x,hud_keyboard_mode_label_root_start_y},
			color = self.degree_colors[mode],
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_CENTER
		})
		if root_string[2] != nil then
			local acc_x_offset = hud_square_accidental_x_offset*hud_keyboard_key_size
			local acc_y_offset = -hud_keyboard_key_size/2.5
			-- local accidental_y_start = hud_square_accidental_y_offset*scale
			draw.Text({
				text = root_string[2],
				pos = {hud_keyboard_mode_label_root_start_x+acc_x_offset,hud_keyboard_mode_label_root_start_y+acc_y_offset},
				font = "HudNoteSquareAccidental",
				color = self.degree_colors[mode]
			})
		end
		draw.Text({
			font = "HudNoteSquareMode",
			text = mode_string,
			-- text = tostring(white_key_distance),
			-- text = tostring(key_distance)..tostring(key_name)..tostring(octave),
			pos = {hud_keyboard_mode_label_root_start_x+hud_keyboard_key_size/1.4,hud_keyboard_mode_label_root_start_y},
			color = self.degree_colors[mode],
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_CENTER
		})
	end
	
	function SWEP:DrawSettingsTip()
		draw.Text({
			font = "HudNoteSquareRootNumber",
			text = "Settings Menu: Right mouse",
			-- text = tostring(white_key_distance),
			-- text = tostring(key_distance)..tostring(key_name)..tostring(octave),
			pos = {256,512},
			color = Color(128+math.sin(CurTime()-1)*128,128+math.sin(CurTime())*128,128+math.sin(CurTime()-2)*128,255),
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER
		})
	end
	
	SWEP.sharp_distance = {
		[true] = -1,
		[false] = 0
	}
	
	function SWEP:DrawHUD()
		local own = LocalPlayer()
		if IsValid(own) then
			local root_note = self.Config[self.setting_root_note]
			local mode = self.Config[self.setting_mode]
			local sharp = self.sharp_distance[input.IsKeyDown(KEY_SPACE)]
			local vc = self.sharp_distance[input.IsKeyDown(KEY_LALT)]
			if self:GetEnabled() then
				self:DrawPiano(own,root_note,mode,sharp)
				self:DrawKeyboard(own,root_note,mode,sharp,vc)
				if self:GetClass() != midifier_seat_class then
					self:DrawWorldModelMonitorScreen(mode,true,resolution_scale*1,ScrW()-536*resolution_scale_x,ScrH()-316*resolution_scale)
					self:DrawWorldModelRecieverScreen1(mode,true,resolution_scale*2,303*resolution_scale_x,ScrH()-188*resolution_scale)
				end
			end
		end
		
	end
	
	function SWEP:PostDrawViewModel(vm,wep,own)
		-- if true then return end
		if IsValid(own) then
			local root_note = self.Config[self.setting_root_note]
			local mode = self.Config[self.setting_mode]
			local sharp = self.sharp_distance[input.IsKeyDown(KEY_SPACE)]
			-- local bone = vm:LookupBone("v_weapon.c4")
			if self:GetClass() == midifier_seat_class then
				-- self:ControllerDrawSpeaker(vm,wep,own,root_note,mode,sharp)
			else
				if self.ViewModelBone == nil then
					return
				end
				local boneid = vm:LookupBone(self.ViewModelBone)
				if !boneid then
					return
				end
				local matrix = vm:GetBoneMatrix(boneid)
				if !matrix then
					return
				end
				-- print("VM2")
				local scrnPos,scrnAng = LocalToWorld(self.ViewModelScreenPos,self.ViewModelScreenAng,matrix:GetTranslation(),matrix:GetAngles())
				cam.Start3D2D(scrnPos,scrnAng,0.028)
					self:DrawViewModelScreen(self:GetEnabled())
				cam.End3D2D()
				local vmPos,vmAng = LocalToWorld(self.ViewModelPos,self.ViewModelAng,matrix:GetTranslation(),matrix:GetAngles())
				
				local vmReciever = ClientsideModel(self.ViewModelMdl)
				vmReciever:SetSkin(0)
				vmReciever:SetNoDraw(true)
				vmReciever:SetPos(vmPos)
				vmReciever:SetAngles(vmAng)
				vmReciever:SetupBones()
				vmReciever:SetModelScale(self.ViewModelScale)
				vmReciever:DrawModel()
				vmReciever:Remove()
			end
		end
	end
end

SWEP.LightSize = 32
SWEP.LightColor = Color(196,196,196)

local matLight = Material( "sprites/light_ignorez" )
--local matBeam = Material( "effects/lamp_beam" )
function SWEP:DrawEffects(pos,ang)

	-- No glow if we're not switched on!
	-- if ( !self:GetOn() ) then return end
	if pos == nil then pos = self:GetPos() end
	if ang == nil then ang = self:GetAngles() end
	
	
	local LightNrm = ang:Forward()*5.4+ang:Right()*0.62+ang:Up()*0.32
	-- local LightNrm = ang:Forward()+ang:Right()*0.62+ang:Up()*0.32
	local ViewNormal = pos - EyePos()
	-- if owned and pos != nil then
		-- LightNrm = 
		-- ViewNormal = 
	-- end
	
	if pos != nil and ang != nil then
		LightNrm = ang:Forward()*5.4+ang:Right()*0.62+ang:Up()*0.32
		ViewNormal = pos - EyePos()
	end
	
	local Distance = ViewNormal:Length()
	ViewNormal:Normalize()
	local ViewDot = ViewNormal:Dot( LightNrm * -1 )
	local LightPos = pos + LightNrm * 1

	-- glow sprite
	--[[
	render.SetMaterial( matBeam )

	local BeamDot = BeamDot = 0.25

	render.StartBeam( 3 )
		render.AddBeam( LightPos + LightNrm * 1, 128, 0.0, Color( r, g, b, 255 * BeamDot) )
		render.AddBeam( LightPos - LightNrm * 100, 128, 0.5, Color( r, g, b, 64 * BeamDot) )
		render.AddBeam( LightPos - LightNrm * 200, 128, 1, Color( r, g, b, 0) )
	render.EndBeam()
	--]]

	if ( ViewDot >= 0 ) then

		render.SetMaterial( matLight )
		local Visibile = 1
		-- print(Visibile)
		if ( !Visibile ) then return end

		local Size = math.Clamp( Distance * Visibile * ViewDot * 2, 4, 32 )

		Distance = math.Clamp( Distance, 32, 800 )
		local Alpha = math.Clamp( ( 1000 - Distance ) * Visibile * ViewDot, 0, 32 )
		local Col = self:GetColor()
		Col.a = Alpha
		local light_color = Color(self.LightColor.r,self.LightColor.g,self.LightColor.b,Alpha)
		render.DrawSprite( LightPos, Size, Size, Col )
		render.DrawSprite( LightPos, Size * 0.4, Size * 0.4,light_color)

	end

end