if SERVER then
	AddCSLuaFile("shared.lua")
	resource.AddFile("sound/siege/big_explosion.wav")
	resource.AddFile("sound/siege/jihad.wav")
	resource.AddFile("models/weapons/v_jb.mdl")
	resource.AddFile("models/weapons/w_jb.mdl")
	resource.AddFile("materials/vgui/ttt/icon_c4.vmt")
	resource.AddFile("materials/vgui/entities/weapon_jihadbomb.vmt")
	resource.AddFile("materials/vgui/entities/weapon_jihadbomb.vtf")
	resource.AddFile("materials/models/weapons/w_models/pr0d.c4/bomb1.vmt")
	resource.AddFile("materials/models/weapons/w_models/pr0d.c4/bomb1_planted.vmt")
	resource.AddFile("materials/models/weapons/w_models/pr0d.c4/bomb2.vmt")
	resource.AddFile("materials/models/weapons/w_models/pr0d.c4/bomb3b.vmt")
	resource.AddFile("materials/models/weapons/w_models/pr0d.c4/hand.vmt")
	resource.AddFile("materials/models/weapons/w_models/pr0d.c4/screen_04.vmt")
	resource.AddFile("materials/models/weapons/w_models/pr0d.c4/screen_45.vmt")
	resource.AddFile("materials/models/weapons/w_models/pr0d.c4/screen_active.vmt")
	resource.AddFile("materials/models/weapons/w_models/pr0d.c4/screen_off.vmt")
	resource.AddFile("materials/models/weapons/w_models/pr0d.c4/screen_on.vmt")
	resource.AddFile("materials/models/weapons/v_models/pr0d.c4/bomb1.vmt")
	resource.AddFile("materials/models/weapons/v_models/pr0d.c4/bomb1.vtf")
	resource.AddFile("materials/models/weapons/v_models/pr0d.c4/bomb1_planted.vtf")
	resource.AddFile("materials/models/weapons/v_models/pr0d.c4/bomb1_ref.vtf")
	resource.AddFile("materials/models/weapons/v_models/pr0d.c4/bomb2.vmt")
	resource.AddFile("materials/models/weapons/v_models/pr0d.c4/bomb2.vtf")
	resource.AddFile("materials/models/weapons/v_models/pr0d.c4/bomb3b.vmt")
	resource.AddFile("materials/models/weapons/v_models/pr0d.c4/bomb3b.vtf")
	resource.AddFile("materials/models/weapons/v_models/pr0d.c4/hand.vmt")
	resource.AddFile("materials/models/weapons/v_models/pr0d.c4/hand.vtf")
	resource.AddFile("materials/models/weapons/v_models/pr0d.c4/screen_04.vmt")
	resource.AddFile("materials/models/weapons/v_models/pr0d.c4/screen_04.vtf")
	resource.AddFile("materials/models/weapons/v_models/pr0d.c4/screen_45.vmt")
	resource.AddFile("materials/models/weapons/v_models/pr0d.c4/screen_45.vtf")
	resource.AddFile("materials/models/weapons/v_models/pr0d.c4/screen_active.vmt")
	resource.AddFile("materials/models/weapons/v_models/pr0d.c4/screen_active.vtf")
	resource.AddFile("materials/models/weapons/v_models/pr0d.c4/screen_off.vmt")
	resource.AddFile("materials/models/weapons/v_models/pr0d.c4/screen_off.vtf")
	resource.AddFile("materials/models/weapons/v_models/pr0d.c4/screen_off_ref.vtf")
	resource.AddFile("materials/models/weapons/v_models/pr0d.c4/screen_on.vmt")
	resource.AddFile("materials/models/weapons/v_models/pr0d.c4/screen_on.vtf")
	resource.AddFile("materials/models/weapons/v_models/pr0d.c4/screen_ref.vtf")
	resource.AddFile("materials/vgui/ttt/icon_z_jihad.vmt")
end

SWEP.HoldType				= "slam"

if CLIENT then
	SWEP.PrintName			= "Jihad"
	SWEP.Slot				= 7

	SWEP.EquipMenuData = {
		type				= "item_weapon",
		name				= "Jihad Bomb",
		desc				= "Kill yourself and everyone around you with a bomb!"
	};

	SWEP.Icon				= "vgui/ttt/icon_z_jihad"
end

SWEP.Base 					= "weapon_tttbase"

SWEP.Kind 					= WEAPON_EQUIP2
SWEP.CanBuy 				= {ROLE_TRAITOR}
SWEP.WeaponID 				= AMMO_C4
SWEP.AllowDrop				= false

SWEP.ViewModel				= Model("models/weapons/v_jb.mdl")
SWEP.WorldModel 			= Model("models/weapons/w_jb.mdl")

SWEP.DrawCrosshair 			= false
SWEP.ViewModelFlip 			= false
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay			= 5.0

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.NoSights				= true

function SWEP:Reload()
end 

function SWEP:Initialize()
	 util.PrecacheSound("siege/big_explosion.wav")
	 util.PrecacheSound("siege/jihad.wav")
end

function SWEP:Think() 
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + 2)	

	local effectdata = EffectData()
	effectdata:SetOrigin(self.Owner:GetPos())
	effectdata:SetNormal(self.Owner:GetPos())
	effectdata:SetMagnitude(8)
	effectdata:SetScale(1)
	effectdata:SetRadius(76)
	util.Effect("Sparks", effectdata)
	self.BaseClass.ShootEffects(self)
		
	-- The rest is only done on the server
	if (SERVER) then
		self.Owner:EmitSound(self.Owner.JihadSound or "siege/jihad.wav")

		timer.Simple(2, function() 
			local ent = ents.Create("env_explosion")
			ent:SetPos(self.Owner:GetPos())
			ent:SetOwner(self.Owner)
			ent:SetKeyValue("iMagnitude", "150")
			ent:Spawn()
			ent:Fire("Explode", 0, 0)
			ent:EmitSound("siege/big_explosion.wav", 500, 500)
			self:Remove()
		end)
	end
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextSecondaryFire(CurTime() + 1)
	local TauntSound = Sound("vo/npc/male01/overhere01.wav")
	self.Weapon:EmitSound(TauntSound)
end