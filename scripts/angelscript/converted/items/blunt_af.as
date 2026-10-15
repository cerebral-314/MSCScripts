#pragma context server

// Converted from items/blunt_af.script by msc_transpiler.
// Bludgeon Bludgeon ^_^
// - Hammer typically used by the Bludgeon tribes

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_base_twohanded.as"

[script "items/blunt_af"]
class BluntAf : BluntBaseTwohandedScript
{
	// Constants
	int MANA_SKULL = 50;
	int MANA_STUN = 20;
	float FREQ_SKULL = 5.0f;
	string BASE_LEVEL_REQ = "20";
	int AOE_STUN_REQ = 25;
	int SKULL_REQ = 20;
	float DEMON_DMG_DELAY = 0.25f;
	float DEMON_ATK_DURATION = 0.7f;

	// Variables (an unset .script variable reads as its own name)
	float NEXT_SKULL = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	BluntAf()
	{
		ANIM_LIFT1 = 5;
		ANIM_IDLE1 = "0";
		ANIM_IDLE2 = "6";
		ANIM_IDLE_TOTAL = 2;
		ANIM_ATTACK1 = "1";
		ANIM_ATTACK2 = "1";
		MODEL_VIEW = "viewmodels/v_2hblunts.mdl";
		MODEL_WORLD = "weapons/p_weapons3.mdl";
		MODEL_BODY_OFS = "10";
		ANIM_PREFIX = "standard";
		MELEE_RANGE = "80";
		MELEE_DMG_DELAY = 0.5f;
		MELEE_ATK_DURATION = 1.1f;
		MELEE_ENERGY = 2.0f;
		MELEE_DMG = 400;
		MELEE_DMG_RANGE = 40;
		MELEE_ACCURACY = "75%";
		MELEE_PARRY_AUGMENT = "20%";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded
		BluntBaseTwohanded_OnWeaponSpawn(); // items/blunt_base_twohanded

		SetName("Mace of Affliction");
		SetDescription("A skull encrusted club forged by goblin shamans");
		SetWeight(80);
		SetValue(3000);
		SetHudSprite("hand", "hammer");
		SetHudSprite("trade", "maul");
	}

	// bash
	// AOE Stun
	void OnBash()
	{
		if (!Truthy(Eval("game.item.attacking"))) // Just in case player dies
			return;
		PlayViewAnim(Int(MELEE_VIEWANIM_ATK));
		PlayOwnerAnim("once", PLAYERANIM_SWING, "global.anim.combatwalk", 3);
		ServerPlaySound(2, 10, ScriptVarOf(ENT_OWNER, "PLR_SOUND_SHOUT1"));
	}

	// special_02_strike
	void OnSpecial02Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		if (ManaOf(ENT_OWNER) >= MANA_STUN)
			PlayerMessageDark(ENT_OWNER, "Stun Burst: Insufficient Mana");

		if (!(ManaOf(ENT_OWNER) >= MANA_STUN))
			return;
		GiveMana(ENT_OWNER, -MANA_STUN);

		Vector3 spawnPoint = OriginOf(ENT_OWNER);
		Vector3 myAngles = AnglesOf(ENT_OWNER);
		float myYaw = myAngles.y;
		spawnPoint += RelativePosition(Vector3(0, myYaw, 0), Vector3(0, 64, 0));
		float dmgStun = SkillOf(ENT_OWNER, "bluntarms") * 2.0f;
		CreateNpc(Text(spawnPoint), Vec("monsters/summon/stun_burst"), @EntityOf(ENT_OWNER), 128, 1, dmgStun, "bluntarms");
	}

	// game_+attack2
	// mouse2 for skullz
	void OnGamePressAttack2()
	{
		if (!CanAttack(ENT_OWNER))
			return;

		if (!(GameTime() > NEXT_SKULL))
			return;

		NEXT_SKULL = GameTime() + FREQ_SKULL;

		if (ManaOf(ENT_OWNER) < MANA_SKULL)
			PlayerMessageDark(ENT_OWNER, "Venom Skull: Insufficient Mana");
		if (!(ManaOf(ENT_OWNER) >= MANA_SKULL))
			return;

		GiveMana(ENT_OWNER, -MANA_SKULL);

		Vector3 spawnPoint = OriginOf(ENT_OWNER);
		Vector3 myAngles = AnglesOf(ENT_OWNER);
		float myYaw = myAngles.y;
		spawnPoint += RelativePosition(Vector3(0, myYaw, 0), Vector3(0, 64, 0));
		float dmgStun = SkillOf(ENT_OWNER, "bluntarms") * 2.0f;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons3.mdl");
		Precache("viewmodels/v_2hblunts.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bash") { OnBash(); return true; }
		if (name == "game_+attack2") { OnGamePressAttack2(); return true; }
		if (name == "special_02_strike") { OnSpecial02Strike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BluntBaseTwohandedScript::DispatchEvent(name, params);
	}
}
