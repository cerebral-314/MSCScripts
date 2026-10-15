#pragma context server

// Converted from items/blunt_ravenmace.script by msc_transpiler.
// Raven Mace, by Thothie - from Dark Maul
// - Haste Effects (Cross Fingers) <<damage >speed <weight nofirebase
// - WAAAAY too many backwards includes causing way too many issues - integrating all of them to figure what the deal

#include "runtime/ScriptEntity.as"
#include "converted/items/base_melee.as"

[script "items/blunt_ravenmace"]
class BluntRavenmace : BaseMeleeScript
{
	// Constants
	string BASE_LEVEL_REQ = "15";
	int ANIM_IDLE_TOTAL = 1;
	string ANIM_ATTACK1 = "2";
	string ANIM_ATTACK2 = "3";
	string ANIM_ATTACK3 = "4";
	int ANIM_ATTACK4 = 5;
	int FIRST_ATK_ANIM = 2;
	int LAST_ATK_ANIM = 5;
	string ANIM_CHARGE = "6";
	int ANIM_SHEATH = 7;
	string MELEE_STAT = "bluntarms";
	string MELEE_DMG_TYPE = "blunt";
	string MELEE_SOUND = "MELEE_SOUND";
	string SOUND_SWIPE = "weapons/swingsmall.wav";
	string PLAYERANIM_SWING = "swing_bluntdouble";
	int MELEE_DMG = 140;
	int MELEE_DMG_RANGE = 140;
	float MELEE_ENERGY = 1.0f;
	string MELEE_RANGE = "70";
	float MELEE_DMG_DELAY = 0.8f;
	float MELEE_SOUND_DELAY = 0.0f;
	float MELEE_ATK_DURATION = 1.1f;
	string MELEE_ACCURACY = "60%";
	string MELEE_PARRY_AUGMENT = "0%";
	string EFFECT_SCRIPT = "effects/debuff_stun";
	int MODEL_VIEW_IDX = 3;
	string SOUND_HEARTBEAT = "amb/wind.wav";

	// Variables (an unset .script variable reads as its own name)
	string MELEE_VIEWANIM_ATK = "MELEE_VIEWANIM_ATK";
	bool IN_HASTE = false;
	string HASTE_FX_ID = "HASTE_FX_ID";

	// Variables declared by included files, with the value they start with in this script
	BluntRavenmace()
	{
		ANIM_IDLE1 = "1";
		PLAYERANIM_AIM = "bluntdouble";
		MODEL_VIEW = "viewmodels/v_2hblunts.mdl";
		MODEL_WORLD = "weapons/p_weapons1.mdl";
		MODEL_HANDS = "weapons/p_weapons1.mdl";
		MODEL_BODY_OFS = "74";
		ANIM_PREFIX = "ravenmace";
	}

	// unnamed block (first think)
	void BluntRavenmace_FirstThink()
	{
		MELEE_VIEWANIM_ATK = ANIM_ATTACK1;

		IN_HASTE = false;
	}

	// weapon_spawn
	void BluntRavenmace_OnWeaponSpawn()
	{
		SetName("Raven Mace");
		SetDescription("An ornate maul hasted by infernal magics");
		SetWeight(100);
		SetValue(1100);
		SetHand("both");
		SetHudSprite("hand", "101");
		SetHudSprite("trade", "101"); // needs hud sprite
	}

	// unnamed block (timer)
	void BluntRavenmace_Timer()
	{
		CallEventDelayed(13.0f, "BluntRavenmace_Timer");
		if (!IN_HASTE)
			return;
		ServerPlaySound(2, 10, "amb/wind.wav");
	}

	// game_dodamage
	string BluntRavenmace_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		MELEE_VIEWANIM_ATK = RandomInt(FIRST_ATK_ANIM, LAST_ATK_ANIM); // attempting to vary attack anim
		return result;
	}

	// weapon_spawn
	// ======base_blunt_one-handed
	void BluntRavenmace_OnWeaponSpawn_2()
	{
		// Blunt bash attack (200%) - Normal damage, but stun for several seconds
		// ======================================================================
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", MELEE_RANGE);
		SetLocal("reg.attack.dmg", MELEE_DMG);
		SetLocal("reg.attack.dmg.range", MELEE_DMG_RANGE);
		SetLocal("reg.attack.dmg.type", MELEE_DMG_TYPE);
		// local reg.attack.aoe.range 100
		// local reg.attack.aoe.falloff 1.5
		SetLocal("reg.attack.energydrain", MELEE_ENERGY);
		LegacyCommand("multiply", "reg.attack.energydrain", 2);
		SetLocal("reg.attack.stat", MELEE_STAT);
		SetLocal("reg.attack.hitchance", MELEE_ACCURACY);
		LegacyCommand("add", "reg.attack.hitchance", "10%");
		SetLocal("reg.attack.priority", 2);
		SetLocal("reg.attack.delay.strike", 1.5f);
		SetLocal("reg.attack.delay.end", 2.0f);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "special_02");
		SetLocal("reg.attack.noise", 1000);
		SetLocal("reg.attack.chargeamt", "200%");
		SetLocal("reg.attack.reqskill", 4);

		RegisterAttack();
	}

	// game_precache
	void OnGamePrecache()
	{
	}

	// bweapon_effect_activate
	void OnBweaponEffectActivate()
	{
		BaseItemExtras_OnBweaponEffectActivate(); // items/base_item_extras

		OnHasteGo();
		IN_HASTE = true;
	}

	// bweapon_effect_remove
	void OnBweaponEffectRemove(string reason = "")
	{
		BaseItemExtras_OnBweaponEffectRemove(reason); // items/base_item_extras

		OnSpeedRemove();
		IN_HASTE = false;
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntRavenmace_OnWeaponSpawn();
		BluntRavenmace_OnWeaponSpawn_2();
	}

	// special_01_start
	void OnSpecial01Start()
	{
		PlayViewAnim(Int(ANIM_CHARGE));
		PlayOwnerAnim("once", "swing_bluntdouble");
		PlaySound(Int(Eval("const.snd.weapon")), Eval("const.snd.maxvol"), SPECIAL01_SND);
	}

	// melee_start
	void OnMeleeStart()
	{
		MELEE_VIEWANIM_ATK = RandomInt(FIRST_ATK_ANIM, LAST_ATK_ANIM);

		PlayViewAnim(Int(MELEE_VIEWANIM_ATK));
		PlayOwnerAnim("once", PLAYERANIM_SWING, "global.anim.combatwalk", 3);
		CallEventDelayed(MELEE_SOUND_DELAY, "melee_playsound");
	}

	// bash
	void OnBash()
	{
		PlayViewAnim(Int(ANIM_CHARGE));
		PlayOwnerAnim("once", PLAYERANIM_SWING, "global.anim.combatwalk", 3);
		CallEventDelayed(MELEE_SOUND_DELAY, "melee_playsound");
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return BluntRavenmace_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// special_02_start
	void OnSpecial02Start()
	{
		PlayViewAnim(Int(ANIM_CHARGE));
		PlayOwnerAnim("once", "swing_bluntdouble");
		// applyeffect ent_owner effects/specialattack_bash
		CallEventDelayed(0.9f, "bash");

		ServerPlaySound(2, 10, ScriptVarOf(ENT_OWNER, "PLR_SOUND_SWORDREADY"));
	}

	// special_02_damaged_other
	// PARAM1 - Entity Damaged
	void OnSpecial02DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		float maxstun = Clamp(SkillOf(ENT_OWNER, "bluntarms.prof") + 1.0f, 1.0f, 35.0f);
		float stuntime = Random(1, SkillOf(ENT_OWNER, "bluntarms.prof"));
		ApplyEffect(target, EFFECT_SCRIPT, stuntime, 0, 0, @EntityOf(ENT_OWNER));
	}

	// speed_remove
	void OnSpeedRemove()
	{
		ServerPlaySound(2, 0, "amb/wind.wav"); // Stop sound
		LegacyCommand("setgaitspeed", 1.0f);
		string scriptflag = ItemNameOf(ENT_ME);
		// callexternal ent_owner ext_effect_speed remove L_SCRIPTFLAG
		CallExternal(ENT_OWNER, "plr_update_speed_effects", "remove", scriptflag);
		ClientEvent("update", "all", HASTE_FX_ID, "effect_die");
	}

	// speed_add
	void OnSpeedAdd()
	{
		if (!IsInHand(ENT_ME))
			return;
		if (!Truthy(ScriptVarOf(ENT_OWNER, "PLR_IN_WORLD")))
			return;

		string scriptflag = ItemNameOf(ENT_ME);

		if (Truthy(ScriptFlag(ENT_OWNER, scriptflag, "name_exists")))
			return;

		LegacyCommand("setgaitspeed", 3.0f);
		CallExternal(ENT_OWNER, "plr_change_speed", -1, 5.0f, scriptflag);
		ClientEvent("new", "all", "effects/sfx_motionblur_perm", IndexOf(ENT_OWNER));
		HASTE_FX_ID = LastClientScriptId();
	}

	// haste_go
	void OnHasteGo()
	{
		OnSpeedAdd();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("viewmodels/v_2hblunts.mdl");
		Precache("weapons/p_weapons1.mdl");
		Precache("amb/wind.wav");
		CallEventDelayed(13.0f, "BluntRavenmace_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BluntRavenmace_FirstThink();
		BaseWeapon_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bash") { OnBash(); return true; }
		if (name == "bweapon_effect_activate") { OnBweaponEffectActivate(); return true; }
		if (name == "bweapon_effect_remove") { OnBweaponEffectRemove(Param(params, 0)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "haste_go") { OnHasteGo(); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "special_01_start") { OnSpecial01Start(); return true; }
		if (name == "special_02_damaged_other") { OnSpecial02DamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3)); return true; }
		if (name == "special_02_start") { OnSpecial02Start(); return true; }
		if (name == "speed_add") { OnSpeedAdd(); return true; }
		if (name == "speed_remove") { OnSpeedRemove(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		if (name == "BluntRavenmace_Timer") { BluntRavenmace_Timer(); return true; }
		return BaseMeleeScript::DispatchEvent(name, params);
	}
}
