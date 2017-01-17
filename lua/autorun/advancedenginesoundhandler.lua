ADVENGDEF = {}
ADVENGDEF.Name = ""
ADVENGDEF.Dir = ""

ADVENGDEF.Sounds = {}
ADVENGDEF.RPM = {}
ADVENGDEF.LowRPM = {}
ADVENGDEF.HighRPM = {}

ADVENGDEF.NrOfSounds = 0
ADVENGDEF.Dir = "sound/"
ADVENGDEF.SndDir = ""
ADVENGDEF.SoundFiles = {}

ADVENGDEF.PlyUser = nil
ADVENGDEF.UseDelay = CurTime()
ADVENGDEF.UseTime = 0.5

ADVENGDEF.MaxRev = 100
ADVENGDEF.CurRev = 1
ADVENGDEF.RevInc = 0.2
ADVENGDEF.RevDec = 1

ADVENGDEF.Snd1 = 1
ADVENGDEF.Snd2 = 2

ADVENGDEF.AllRPMMin = 0
ADVENGDEF.AllRPMDiff = 0

ADVENGDEF.On = false
ADVENGDEF.FirstTimePlay = false
ADVENGDEF.Ent = nil

ADVENGDEF.TmpRev = 0

ADVENGDEF.Volume1 = 0
ADVENGDEF.Volume2 = 0
ADVENGDEF.Percent1 = 0
ADVENGDEF.Percent2 = 0

ADVENGDEF.OldSnd1 = 1
ADVENGDEF.OldSnd2 = 2

function ADVENGDEF:Initiate( ent, dir )

	self.Sounds = {}
	self.RPM = {}
	self.LowRPM = {}
	self.HighRPM = {}

	self.Ent = ent
	self.SndDir = dir

	local SoundFiles = {}
	self.NrOfSounds = 0

	SoundFiles = file.Find( self.Dir..self.SndDir.."*.wav", "GAME")
	self.NrOfSounds = table.Count( SoundFiles )

	if self.NrOfSounds <= 1 then
		SCarsReportError("Initiating Adv SCar sound failed!")
		if self.SndDir then
			SCarsReportError("\tDir: "..self.SndDir)
		end

		SCarsReportError("Sound files found: "..self.NrOfSounds)
		self.Play = self.Empty
		self.Stop = self.Empty
		self.ChangePitch = self.Empty
		return
	end

	local id  = ""
	local index = 0
	for k, v in pairs( SoundFiles  ) do
		id = string.Explode(" ", v)
		index = tonumber(id[1])
		self.Sounds[index] = CreateSound(self.Ent, self.SndDir..v)
		id = string.Explode("_", v)
		id = string.Explode(".", id[2])
		self.RPM[index] = tonumber(id[1])
	end

	for i = 1, self.NrOfSounds do
		if i ~= self.NrOfSounds then
			self.HighRPM[i] = self.RPM[i+1] / self.RPM[i]  - 1
		else
			self.HighRPM[i] = 0.5
		end

		if i ~= 1 then
			self.LowRPM[i] = 1 - ( self.RPM[i-1] / self.RPM[i]  )
		else
			self.LowRPM[i] = 0.5
		end
	end

	self.RPM[self.NrOfSounds + 1] = self.RPM[self.NrOfSounds] - self.RPM[self.NrOfSounds-1]

	self.AllRPMMin = self.RPM[1]
	self.AllRPMDiff = self.RPM[self.NrOfSounds] - self.AllRPMMin

end

function ADVENGDEF:Play()
	if self.On == false then
		self.On = true

		self:FirstSoundInit()
		self.Play = self.RealPlay
	end
end

function ADVENGDEF:RealPlay()
	if self.On == false then
		self.On = true

		self:ChangePitch( self.CurRev * 2 + 40, 0 )
	end
end

function ADVENGDEF:Stop()
	if self.On == true then
		for i = 1, self.NrOfSounds do
			self.Sounds[i]:Stop()
		end

		self.On = false
	end
end

function ADVENGDEF:FirstSoundInit()

	self.CurRev = 1

	self.TmpRev = self.AllRPMDiff * (self.CurRev / self.MaxRev) + self.AllRPMMin

	for i = 1, self.NrOfSounds do
		if self.RPM[i] <= self.TmpRev and (i == self.NrOfSounds or self.RPM[i+1] > self.TmpRev) then
			self.Snd1 = i
			self.Snd2 = self.Snd1 + 1
			break
		end
	end

	self.OldSnd1 = self.Snd1
	self.OldSnd2 = self.Snd2

	if self.Sounds[self.Snd1]:IsPlaying() == false then
		self.Sounds[self.Snd1]:Play()
	end

	if  self.OldSnd2 <= self.NrOfSounds and self.Sounds[self.Snd2]:IsPlaying() == false then
		self.Sounds[self.Snd2]:Play()
	end

	self.Volume1 = (self.TmpRev - self.RPM[self.Snd1]) / (self.RPM[self.Snd1+1] - self.RPM[self.Snd1])
	self.Volume2 = 1 - self.Volume1

	self.Percent1 = self.Volume1 * self.HighRPM[self.Snd1] * 100

	self.Sounds[self.Snd1]:ChangePitch(math.Clamp(100 + self.Percent1, 1, 255), 0.1)
	self.Sounds[self.Snd1]:ChangeVolume(1-self.Volume1,0)

	if self.Snd2 <= self.NrOfSounds then
		self.Percent2 = self.Volume2 * self.LowRPM[self.Snd2] * 100

		self.Sounds[self.Snd2]:ChangePitch(math.Clamp(100-self.Percent2, 1, 255), 0.1)
		self.Sounds[self.Snd2]:ChangeVolume(1-self.Volume2,0)
	end
end

function ADVENGDEF:ChangePitch( rev, tm )

	self.CurRev = (rev - 40) * 0.5 --Change the pitch into percent to fit this type of special sound

	if self.On then
		self.TmpRev = self.AllRPMDiff * (self.CurRev / self.MaxRev) + self.AllRPMMin

		--//Try to avoid fetching the sound ids if we already got the correct ones
		if self.RPM[self.Snd1] > self.TmpRev or self.Snd1 < self.NrOfSounds and self.RPM[self.Snd2] < self.TmpRev then
			for i = 1, self.NrOfSounds do
				if self.RPM[i] <= self.TmpRev and (i == self.NrOfSounds or self.RPM[i+1] > self.TmpRev) then
					self.Snd1 = i
					self.Snd2 = self.Snd1 + 1
					break
				end
			end
		end

		--//Remember to only play and stop sounds when you have to in order to avoid stuttering
		if self.OldSnd1 ~= self.Snd1 then

			if self.Snd2 ~= self.OldSnd1 then
				self.Sounds[self.OldSnd1]:Stop()
			end

			if self.OldSnd2 <= self.NrOfSounds and self.Snd1 ~= self.OldSnd2 and self.Snd2 ~= self.OldSnd2 then
				self.Sounds[self.OldSnd2]:Stop()
			end

			self.OldSnd1 = self.Snd1
			self.OldSnd2 = self.Snd2

			if self.Sounds[self.Snd1]:IsPlaying() == false then
				self.Sounds[self.Snd1]:Play()
			end

			if  self.OldSnd2 <= self.NrOfSounds and self.Sounds[self.Snd2]:IsPlaying() == false then
				self.Sounds[self.Snd2]:Play()
			end
		end

		self.Volume1 = (self.TmpRev - self.RPM[self.Snd1]) / (self.RPM[self.Snd1+1] - self.RPM[self.Snd1])
		self.Volume2 = 1 - self.Volume1

		self.Percent1 = self.Volume1 * self.HighRPM[self.Snd1] * 100

		self.Sounds[self.Snd1]:ChangePitch(math.Clamp(100 + self.Percent1, 1, 255), tm)
		self.Sounds[self.Snd1]:ChangeVolume(1-self.Volume1, tm)

		if self.Snd2 <= self.NrOfSounds then
			self.Percent2 = self.Volume2 * self.LowRPM[self.Snd2] * 100


			self.Sounds[self.Snd2]:ChangePitch(math.Clamp(100-self.Percent2, 1, 255), tm)
			self.Sounds[self.Snd2]:ChangeVolume(1-self.Volume2, tm)
		end
	end
end

function ADVENGDEF:Empty()
end

ADVENG_DEF = { __index = ADVENGDEF }

function CreateAdvancedSCarSound( ent, dir )
	local newSound = {}
	setmetatable(newSound, ADVENG_DEF)
	newSound:Initiate( ent, dir )

	return newSound
end
