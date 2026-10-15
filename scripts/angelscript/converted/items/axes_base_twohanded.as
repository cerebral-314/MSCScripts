#pragma context server

// Converted from items/axes_base_twohanded.script by msc_transpiler.
// Two handed axe
// Uses ANIM_ATTACK1-3

#include "runtime/ScriptEntity.as"
#include "converted/items/base_melee.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class AxesBaseTwohanded
{
	// Constants
	string PLAYERANIM_AIM = "axe_twohand";
	string PLAYERANIM_SWING = "axe_twohand_swing";
	string SOUND_HITWALL1 = "weapons/cbar_hit1.wav";
	string SOUND_HITWALL2 = "weapons/cbar_hit2.wav";
	bool CUSTOM_REGISTER_CHARGE1 = true;
	float BWEAPON_DBL_CHARGE_ADJ = 2.5f;

	// game_spawn
	void AxesBaseTwohanded_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetHand("both");
	}

	// special_02_start
	void AxesBaseTwohanded_OnSpecial02Start()
	{
		Effect("screenfade", ENT_OWNER, 1, 2, Vector3(200, 10, 10), 100, "fadein");
		ServerPlaySound(2, 10, ScriptVarOf(ENT_OWNER, "PLR_SOUND_SWORDREADY"));

		CallEventDelayed(1.0f, "swing_in_air");
	}

	// swing_in_air
	void AxesBaseTwohanded_OnSwingInAir()
	{
		PlayViewAnim(Int(MELEE_VIEWANIM_ATK));
		PlayOwnerAnim("once", PLAYERANIM_SWING, "squatwalk1", 3);

		if (IsOnGround(ENT_OWNER))
		{
			Vector3 forwardangles = AnglesOf(ENT_OWNER);
			forwardangles = Vector3(0, forwardangles.y, 0);

			Vector3 vel = RelativeVelocity(forwardangles, Vector3(0, 430, 0));
			int up = 240;
			AddVelocity(ENT_OWNER, Vector3(vel.x, vel.y, up), "override");
		}

		ServerPlaySound(2, 10, ScriptVarOf(ENT_OWNER, "PLR_SOUND_SHOUT1"));
	}

	// special_02_strike
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void AxesBaseTwohanded_OnSpecial02Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		if (hitType != "npc")
			return;

		Vector3 dir = DirectionTo(OriginOf(ENT_ME), OriginOf(hitEntity)) * 300.0f;

		AddVelocity(hitEntity, Vector3(dir.x, dir.y, 200));
	}

	// game_spawn
	void AxesBaseTwohanded_OnGameSpawn_2(string playerRace = "", string playerGender = "")
	{
		// thothie made seperate so can override
		// Default charge up attack - Double damage for holding to 100%
		// ============================================================
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", MELEE_RANGE);
		SetLocal("reg.attack.dmg", MELEE_DMG);
		LegacyCommand("multiply", "reg.attack.dmg", BWEAPON_DBL_CHARGE_ADJ);
		SetLocal("reg.attack.dmg.range", MELEE_DMG_RANGE);
		SetLocal("reg.attack.dmg.type", MELEE_DMG_TYPE);
		SetLocal("reg.attack.energydrain", MELEE_ENERGY);
		LegacyCommand("multiply", "reg.attack.energydrain", BWEAPON_DBL_CHARGE_ADJ);
		SetLocal("reg.attack.stat", MELEE_STAT);
		SetLocal("reg.attack.hitchance", MELEE_ACCURACY);
		SetLocal("reg.attack.priority", 1);
		SetLocal("reg.attack.delay.strike", MELEE_DMG_DELAY);
		SetLocal("reg.attack.delay.end", MELEE_ATK_DURATION);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "special_01");
		SetLocal("reg.attack.noise", MELEE_NOISE);
		SetLocal("reg.attack.chargeamt", "100%");
		SetLocal("reg.attack.reqskill", 2);

		if (Float(BASE_LEVEL_REQ) > 0.0f)
			LegacyCommand("add", "reg.attack.reqskill", BASE_LEVEL_REQ);

		RegisterAttack();

		if (Truthy(GetVar("CUSTOM_AXE_SECONDARY")))
			return;

		// sethand both
		// Two-handed axe charge up attack (200%) - Lunge forward, deal 3x dmg and splash dmg
		// ==================================================================================
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", 90);
		SetLocal("reg.attack.dmg", MELEE_DMG);
		LegacyCommand("multiply", "reg.attack.dmg", 3);
		SetLocal("reg.attack.dmg.range", MELEE_DMG_RANGE);
		SetLocal("reg.attack.dmg.type", MELEE_DMG_TYPE);
		SetLocal("reg.attack.aoe.range", 100);
		SetLocal("reg.attack.aoe.falloff", 1.5f);
		SetLocal("reg.attack.energydrain", MELEE_ENERGY);
		LegacyCommand("multiply", "reg.attack.energydrain", 2);
		SetLocal("reg.attack.stat", MELEE_STAT);
		SetLocal("reg.attack.hitchance", MELEE_ACCURACY);
		LegacyCommand("add", "reg.attack.hitchance", "10%");
		SetLocal("reg.attack.priority", 2);
		SetLocal("reg.attack.delay.strike", 1.7f);
		SetLocal("reg.attack.delay.end", 2.2f);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "special_02");
		SetLocal("reg.attack.noise", 1000);
		SetLocal("reg.attack.chargeamt", "200%");
		SetLocal("reg.attack.reqskill", 4);

		if (Float(BASE_LEVEL_REQ) > 0.0f)
			LegacyCommand("add", "reg.attack.reqskill", BASE_LEVEL_REQ);

		RegisterAttack();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseItem_OnGameSpawn(playerRace, playerGender); // items/base_item
		AxesBaseTwohanded_OnGameSpawn(playerRace, playerGender);
		AxesBaseTwohanded_OnGameSpawn_2(playerRace, playerGender);
	}

	void OnSpecial02Start() { AxesBaseTwohanded_OnSpecial02Start(); } // special_02_start
	void OnSwingInAir() { AxesBaseTwohanded_OnSwingInAir(); } // swing_in_air
	void OnSpecial02Strike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false) { AxesBaseTwohanded_OnSpecial02Strike(hitType, endPos, hitEntity, hit); } // special_02_strike

	// This file's events and timers by their .script names
	bool AxesBaseTwohanded_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "special_02_start") { OnSpecial02Start(); return true; }
		if (name == "special_02_strike") { OnSpecial02Strike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "swing_in_air") { OnSwingInAir(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/axes_base_twohanded"]
shared class AxesBaseTwohandedScript : BaseMeleeScript, AxesBaseTwohanded
{
	// Variables every script that includes this file declares
	string ANIM_ATTACK1 = "ANIM_ATTACK1";
	string ANIM_ATTACK2 = "ANIM_ATTACK2";
	string BASE_LEVEL_REQ = "BASE_LEVEL_REQ";
	string MELEE_ACCURACY = "MELEE_ACCURACY";
	float MELEE_ATK_DURATION = 0.0f;
	int MELEE_DMG = 0;
	float MELEE_DMG_DELAY = 0.0f;
	int MELEE_DMG_RANGE = 0;
	string MELEE_DMG_TYPE = "MELEE_DMG_TYPE";
	float MELEE_ENERGY = 0.0f;
	string MELEE_PARRY_CHANCE = "MELEE_PARRY_CHANCE";
	string MELEE_RANGE = "MELEE_RANGE";
	string MELEE_SOUND = "MELEE_SOUND";
	float MELEE_SOUND_DELAY = 0.0f;
	string MELEE_STAT = "MELEE_STAT";
	string MELEE_VIEWANIM_ATK = "MELEE_VIEWANIM_ATK";
	int MODEL_VIEW_IDX = 0;
	string SOUND_SWIPE = "SOUND_SWIPE";

	// Variables declared by included files, with the value they start with in this script
	AxesBaseTwohandedScript()
	{
		PLAYERANIM_AIM = "axe_twohand";
		BWEAPON_DBL_CHARGE_ADJ = 2.5f;
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return AxesBaseTwohanded_DispatchEvent(name, params)
			|| BaseMeleeScript::DispatchEvent(name, params);
	}
}
