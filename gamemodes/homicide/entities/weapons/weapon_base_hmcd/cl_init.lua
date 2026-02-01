include( "ai_translations.lua" )
include( "sh_anim.lua" )
include( "shared.lua" )

SWEP.Slot				= 0						-- Slot in the weapon selection menu
SWEP.SlotPos			= 10					-- Position in the slot
SWEP.DrawAmmo			= true					-- Should draw the default HL2 ammo counter
SWEP.DrawCrosshair		= true					-- Should draw the default crosshair
SWEP.DrawWeaponInfoBox	= true					-- Should draw the weapon info box
SWEP.BounceWeaponIcon	= true					-- Should the weapon icon bounce?
SWEP.SwayScale			= 1.0					-- The scale of the viewmodel sway
SWEP.BobScale			= 1.0					-- The scale of the viewmodel bob

SWEP.RenderGroup		= RENDERGROUP_OPAQUE

-- Override this in your SWEP to set the icon in the weapon selection
SWEP.WepSelectIcon		= surface.GetTextureID( "weapons/swep" )

-- This is the corner of the speech bubble
SWEP.SpeechBubbleLid	= surface.GetTextureID( "gui/speech_lid" )

--[[---------------------------------------------------------
	You can draw to the HUD here - it will only draw when
	the client has the weapon deployed..
-----------------------------------------------------------]]
function SWEP:DrawHUD()
end

--[[---------------------------------------------------------
	Checks the objects before any action is taken
	This is to make sure that the entities haven't been removed
-----------------------------------------------------------]]
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )

	-- Set us up the texture
	surface.SetDrawColor( 255, 255, 255, alpha )
	if isnumber( self.WepSelectIcon ) then
		surface.SetTexture( self.WepSelectIcon )
	else
		surface.SetMaterial( self.WepSelectIcon )
	end

	-- Lets get a sin wave to make it bounce
	local fsin = 0

	if ( self.BounceWeaponIcon == true ) then
		fsin = math.sin( CurTime() * 10 ) * 5
	end

	-- Borders
	y = y + 10
	x = x + 10
	wide = wide - 20

	-- Draw that mother
	surface.DrawTexturedRect( x + fsin, y - fsin,  wide - fsin * 2 , ( wide / 2 ) + fsin )

	-- Draw weapon info box
	self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )

end

--[[---------------------------------------------------------
	This draws the weapon info box
-----------------------------------------------------------]]

SWEP.InfoMarkup = nil

function SWEP:PrintWeaponInfo( x, y, alpha )
	if ( self.DrawWeaponInfoBox == false ) then return end

	if ( self.InfoMarkup == nil ) then
		local title_color = "<color=230,230,230,255>"
		local text_color = "<color=180,180,180>"

		local str = "<font=MersRadial_WeaponHUD>"
		if ( self.Author != "" ) then str = str .. title_color .. "Author:</color>\t" .. text_color .. self.Author .. "</color>\n" end
		if ( self.Contact != "" ) then str = str .. title_color .. "Contact:</color>\t" .. text_color .. self.Contact .. "</color>\n\n" end
		if ( self.Purpose != "" ) then str = str .. title_color .. "Purpose:</color>\n" .. text_color .. self.Purpose .. "</color>\n\n" end
		if ( self.Instructions != "" ) then str = str .. title_color .. "Instructions:</color>\n" .. text_color .. self.Instructions .. "</color>\n" end
		str = str .. "</font>"

		self.InfoMarkup = markup.Parse( str, 250 )
	end

	--x = ScrW() * 0.85
	--y = ScrH() * 0.055

	draw.RoundedBox( 1, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color( 0, 0, 0, alpha - 15 ) )

	self.InfoMarkup:Draw( x + 5, y + 5, nil, nil, alpha )
end

--[[---------------------------------------------------------
	Name: SWEP:FreezeMovement()
	Desc: Return true to freeze moving the view
-----------------------------------------------------------]]
function SWEP:FreezeMovement()
	return false
end

--[[---------------------------------------------------------
	Name: SWEP:ViewModelDrawn( viewModel )
	Desc: Called straight after the viewmodel has been drawn
-----------------------------------------------------------]]
function SWEP:ViewModelDrawn( vm )
end

--[[---------------------------------------------------------
	Name: OnRestore
	Desc: Called immediately after a "load"
-----------------------------------------------------------]]
function SWEP:OnRestore()
end

--[[---------------------------------------------------------
	Name: CustomAmmoDisplay
	Desc: Return a table
-----------------------------------------------------------]]
function SWEP:CustomAmmoDisplay()
end

--[[---------------------------------------------------------
	Name: GetViewModelPosition
	Desc: Allows you to re-position the view model
-----------------------------------------------------------]]
function SWEP:GetViewModelPosition( pos, ang )

	return pos, ang

end

--[[---------------------------------------------------------
	Name: TranslateFOV
	Desc: Allows the weapon to translate the player's FOV (clientside)
-----------------------------------------------------------]]
function SWEP:TranslateFOV( current_fov )

	return current_fov

end

--[[---------------------------------------------------------
	Name: DrawWorldModel
	Desc: Draws the world model (not the viewmodel)
-----------------------------------------------------------]]
function SWEP:DrawWorldModel()

	self:DrawModel()

end

--[[---------------------------------------------------------
	Name: DrawWorldModelTranslucent
	Desc: Draws the world model (not the viewmodel)
-----------------------------------------------------------]]
function SWEP:DrawWorldModelTranslucent()

	self:DrawModel()

end

--[[---------------------------------------------------------
	Name: AdjustMouseSensitivity
	Desc: Allows you to adjust the mouse sensitivity.
-----------------------------------------------------------]]
function SWEP:AdjustMouseSensitivity()

	return nil

end

--[[---------------------------------------------------------
	Name: GetTracerOrigin
	Desc: Allows you to override where the tracer comes from (in first person view)
		 returning anything but a vector indicates that you want the default action
-----------------------------------------------------------]]
function SWEP:GetTracerOrigin()

	--[[
		local ply = self:GetOwner()
		local pos = ply:EyePos() + ply:EyeAngles():Right() * -5
		return pos
	--]]

end

--[[---------------------------------------------------------
	Name: FireAnimationEvent
	Desc: Allows you to override weapon animation events
-----------------------------------------------------------]]

function SWEP:FireAnimationEvent( pos, ang, event, options )
	
	if ( !self.CSMuzzleFlashes ) then return end

	-- CS Muzzle flashes
	if ( event == 5001 or event == 5011 or event == 5021 or event == 5031 ) then

		local data = EffectData()
		data:SetFlags( 0 )
		data:SetEntity( self:GetOwner():GetViewModel() )
		data:SetAttachment( math.floor( ( event - 4991 ) / 10 ) )
		data:SetScale( 1 )

		if ( self.CSMuzzleX ) then
			util.Effect( "CS_MuzzleFlash_X", data )
		else
			util.Effect( "CS_MuzzleFlash", data )
		end

		return true
	end

end

if CLIENT then
	local c_oang, c_dang = Angle(0, 0, 0), Angle(0, 0, 0)
	local c_jump, c_look, c_move, c_sight = 0, 0, 0, 0
	local angdelta = Angle()

	function SWEP:Sway(pos, ang, ft)
		local owner = self:GetOwner()
		if not IsValid(self or owner) then return end
		local sway = 30 * (owner:OnGround() and 1 or 1.5)

		angdelta = LerpAngle(ft * 6, angdelta, owner:EyeAngles() - c_oang)
		if angdelta.y >= 180 then
			angdelta.y = angdelta.y - 360
		elseif angdelta.y <= -180 then
			angdelta.y = angdelta.y + 360
		end

		--print(angdelta)
		angdelta.p = math.Clamp(angdelta.p, -1, 1)
		angdelta.y = math.Clamp(angdelta.y, -0.5, 0.5)
		angdelta.r = math.Clamp(angdelta.r, -1, 1)
		if self.ViewModelFlip then
			angdelta = -angdelta
		end
		angdelta = angdelta * 0.6

		local newang = LerpAngle(ft * 4, c_dang, angdelta)
		c_dang = newang
		c_oang = owner:EyeAngles()

		ang:RotateAroundAxis(ang:Right(), -c_dang.p * sway * 1.2)
		ang:RotateAroundAxis(ang:Up(), c_dang.y * sway)
		ang:RotateAroundAxis(ang:Forward(), c_dang.y * sway * 1.2)
		pos = pos + ang:Right() * c_dang.y * sway + ang:Up() * c_dang.p * sway
		return pos, ang
	end

	function SWEP:Movement(pos, ang, ct, ft)
		local owner = self:GetOwner()
		if not IsValid(self or owner) then return end
		local bob = 0.2 * (owner:OnGround() and 1 or 1.5)
		local idle = 1 * (owner:OnGround() and 1 or 1.5)

		local move = Vector(owner:GetVelocity().x, owner:GetVelocity().y, 0)
		local movement = move:LengthSqr()
		local movepercent = math.Clamp(movement / owner:GetRunSpeed() ^ 2, 0, 1)
		local vel = move:GetNormalized()
		local rd = owner:GetRight():Dot(vel)
		local fd = (owner:GetForward():Dot(vel) + 1) / 2
		local ft8 = ft * 4
		c_move = Lerp(ft8, c_move or 0, owner:OnGround() and movepercent or 0)
		c_sight = Lerp(ft8, c_sight or 0, 1)
		c_jump = Lerp(ft8, c_jump or 0, owner:GetMoveType() == MOVETYPE_NOCLIP and 0 or math.Clamp(owner:GetVelocity().z / 120, -1.5, 1))
		if rd > 0.5 then
			c_look = Lerp(math.Clamp(ft * 5, 0, 1), c_look, 5 * c_move)
		elseif rd < -0.5 then
			c_look = Lerp(math.Clamp(ft * 5, 0, 1), c_look, -5 * c_move)
		else
			c_look = Lerp(math.Clamp(ft * 5, 0, 1), c_look, 0)
		end

		pos = pos + ang:Up() * c_jump
		ang.p = ang.p + (c_jump or 0) * 2
		ang.r = ang.r + c_look
		if bob ~= 0 and c_move > 0 then
			local p = c_move * c_sight * bob
			pos = pos - ang:Forward() * c_move * c_sight * fd - ang:Up() * 0.75 * c_move * c_sight
			local viewmul = view and 5 or 1
			ang.y = ang.y + math.sin(ct * 8.4 * viewmul) * 3.2 * p
			ang.p = ang.p + math.sin(ct * 16 * viewmul) * 3.3 * p
			ang.r = ang.r + math.cos(ct * 8.4 * viewmul) * 8 * p
		end

		if idle ~= 0 then
			local p = (1 - c_move) * c_sight * idle
			ang.p = ang.p + math.sin(ct * 1.5) * 1.2 * p
			ang.y = ang.y + math.sin(ct * 1) * 0.7 * p
			ang.r = ang.r + math.sin(ct * 3) * 0.6 * p
		end
		return pos, ang
	end

	function SWEP:GetVMPos2(pos, ang)
		return pos, ang
	end

	function SWEP:GetViewModelPosition(pos, ang)
		local FT = FrameTime()
		pos, ang = self:Sway(pos, ang, FT)
		pos, ang = self:Movement(pos, ang, CurTime(), FT * 2)
		pos, ang = self:GetVMPos2(pos, ang)

		return pos, ang
	end
end