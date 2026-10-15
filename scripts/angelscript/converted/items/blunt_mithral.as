#pragma context server

// Converted from items/blunt_mithral.script by msc_transpiler.
// Bludgeon Bludgeon ^_^
// - Hammer typically used by the Bludgeon tribes

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_base_twohanded.as"
#include "converted/items/base_vampire.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BluntMithral
{
	// Constants
	int DEMON_CHARGES = 4;
	float VAMPIRE_RATIO = 0.75f;
	int ANIM_LIFT1 = 15;
	string ANIM_IDLE1 = "16";
	string ANIM_IDLE2 = "17";
	int ANIM_IDLE_TOTAL = 2;
	string ANIM_ATTACK1 = "18";
	string ANIM_ATTACK2 = "19";
	string ANIM_ATTACK3 = "20";
	string ANIM_RAGE = "21";
	string BASE_LEVEL_REQ = "20";
	string MODEL_VIEW = "viewmodels/v_2hblunts.mdl";
	int MODEL_VIEW_IDX = 6;
	string MODEL_WORLD = "weapons/p_weapons3.mdl";
	string MODEL_BODY_OFS = "10";
	string ANIM_PREFIX = "standard";
	string MELEE_RANGE = "80";
	float MELEE_DMG_DELAY = 0.5f;
	float MELEE_ATK_DURATION = 1.1f;
	float DEMON_DMG_DELAY = 0.25f;
	float DEMON_ATK_DURATION = 0.7f;
	float MELEE_ENERGY = 2.0f;
	int MELEE_DMG = 400;
	int DEMON_DMG = 750;
	int MELEE_DMG_RANGE = 40;
	string MELEE_ACCURACY = "75%";
	string MELEE_PARRY_AUGMENT = "20%";
	string SOUND_RAGE = "monsters/bludgeon/bludgeon_gaz_bat2.wav";
	string SOUND_RAGE1 = "monsters/bludgeon/bludgeon_gaz_bat1.wav";
	string SOUND_RAGE2 = "monsters/bludgeon/bludgeon_gaz_answer.wav";
	string SOUND_RAGE3 = "monsters/bludgeon/bludgeon_gaz_spell.wav";
	string SOUND_RAGE4 = "monsters/bludgeon/bludgeon_gaz_pain.wav";
	string SOUND_DEATH = "monsters/bludgeon/bludgeon_gaz_death.wav";
	float DEMON_DURATION = 20.0f;
	float RAGE_DELAY = 40.0f;
	string MELEE_DMG_TYPE = "blunt";

	// Variables (an unset .script variable reads as its own name)
	float M_ATTACK = 0.0f;
	float LAST_ERR = 0.0f;
	float LAST_RAGE = 0.0f;
	bool DEMON_RAGE_ON = false;
	bool OUT_O_CHARGES = false;

	// weapon_spawn
	void BluntMithral_OnWeaponSpawn()
	{
		SetName("Bludgeon Hammer");
		SetDescription("A massive Bludgeon hammer, its former owner's soul is imprisoned within");
		SetWeight(80);
		SetValue(3750);
		SetHudSprite("hand", "126");
		SetHudSprite("trade", "126");

		M_ATTACK = 1.0f;
	}

	// game_+attack2
	// mouse2 for rage
	void BluntMithral_OnGamePressAttack2()
	{
		bool exitSub = false;

		if (!CanAttack(ENT_OWNER))
			return;

		if (DEMON_RAGE_ON)
			return;

		if (SkillOf(ENT_OWNER, "spellcasting") < 12.0f)
			PlayerMessageDark(ENT_OWNER, "Bludgeon Hammer: Insufficient magic skill for demonic rage.");
		if (!(SkillOf(ENT_OWNER, "spellcasting") >= 12.0f))
			return;

		DebugPrint("rage " + Text(GameTime()) + " vs " + Text(LAST_RAGE));
		if (GameTime() < LAST_RAGE)
		{
			exitSub = true;
			if (GameTime() > LAST_ERR)
			{
				if (!OUT_O_CHARGES)
					PlayerMessageDark(ENT_OWNER, "Bludgeon Rage: You've not yet recovered from the previous bludgeon rage");
				if (OUT_O_CHARGES)
					PlayerMessageDark(ENT_OWNER, "Bludgeon Rage: Out of charges");
				LAST_ERR = GameTime() + 2.0f;
			}
		}
		if (exitSub)
			return;
		LAST_RAGE = GameTime() + RAGE_DELAY;

		// here the game master stores the owner's STEAM_ID in a token string
		// and the number of times he has used the charge in another token string
		// if he's used the charge less than three times, it calls the demon_rage event on this item
		// otherwise it calls demon_rage_maxed
		CallExternal(GetVar("GAME_MASTER"), "item_demon_rage", self, @EntityOf(ENT_OWNER), DEMON_CHARGES);
	}

	// demon_rage
	void BluntMithral_OnDemonRage(float charges = 0.0f)
	{
		OwnerMessage("Bludgeon rage: " + int(charges) + " charges remaining");

		PlayItemViewAnim(ENT_ME, Int(ANIM_RAGE));
		PlaySound(0, 10, SOUND_RAGE);

		// applyeffect ent_owner effects/demon_rage DEMON_DURATION 150 2.0 //duration speed_multi dmg_multi
		SetAttackProp(ENT_ME, 0, "delay.strike", DEMON_DMG_DELAY);
		SetAttackProp(ENT_ME, 0, "delay.end", DEMON_ATK_DURATION);
		SetAttackProp(ENT_ME, 0, "dmg", DEMON_DMG);
		float demonDmg = DEMON_DMG * 2.0f;
		SetAttackProp(ENT_ME, 1, "dmg", demonDmg);
		// setvard BWEAPON_NO_PERCENT_CHARGE 1
		DEMON_RAGE_ON = true;
		CallEventDelayed(DEMON_DURATION, "demon_rage_end");
		OnDemonRageLoop();
		Effect("glow", ENT_OWNER, Vector3(255, 0, 0), 64, DEMON_DURATION, DEMON_DURATION);
	}

	// demon_rage_loop
	void BluntMithral_OnDemonRageLoop()
	{
		if (!DEMON_RAGE_ON)
			return;
		Effect("screenfade", ENT_OWNER, 2.0f, 1.0f, Vector3(255, 0, 0), RandomInt(64, 128), "fadin");
		if (RandomInt(1, 10) == 1)
			PlayRandomSound(0, 10, SOUND_RAGE1, SOUND_RAGE2, SOUND_RAGE3, SOUND_RAGE4);
		CallEventDelayed(1.0f, "demon_rage_loop");
	}

	// demon_rage_end
	void BluntMithral_OnDemonRageEnd()
	{
		DEMON_RAGE_ON = false;
		// setvard BWEAPON_NO_PERCENT_CHARGE 0
		SetAttackProp(ENT_ME, 0, "delay.strike", MELEE_DMG_DELAY);
		SetAttackProp(ENT_ME, 0, "delay.end", MELEE_ATK_DURATION);
		SetAttackProp(ENT_ME, 0, "dmg", MELEE_DMG);
		float meleeDmg = MELEE_DMG * 2.0f;
		SetAttackProp(ENT_ME, 1, "dmg", meleeDmg);
	}

	// demon_rage_maxed
	void BluntMithral_OnDemonRageMaxed()
	{
		OUT_O_CHARGES = true;
		PlayerMessageDark(ENT_OWNER, "Bludgeon Rage: Out of charges");
	}

	// game_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end) PARAM5=DmgType PARAM6=DmgAmt
	string BluntMithral_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!DEMON_RAGE_ON)
			return result;

		if (!hit)
			return result;

		float healAmt = Float(ScriptVarOf(target, "LAST_STRUCK_FOR"));
		healAmt *= VAMPIRE_RATIO;

		Effect("glow", ENT_OWNER, Vector3(255, 0, 0), 60, 1, 1);
		PlaySound(0, 10, "player/heartbeat_noloop.wav");

		OnTryVampireTarget(EntityOf(ENT_OWNER), target, Text(healAmt));
		return result;
	}

	// melee_strike
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void BluntMithral_OnMeleeStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		if (!DEMON_RAGE_ON)
			return;

		if (!IsAlive(hitEntity))
			return;

		if (MaxHealthOf(hitEntity) < 3000.0f)
		{
			float r = RandomInt(50, 200);
			if (RandomInt(1, 2) == 1)
				r = -r;

			Vector3 pushVel = RelativeVelocity(Vector3(r, 300, 10));
			AddVelocity(hitEntity, pushVel);
		}
	}

	// melee_start
	void BluntMithral_OnMeleeStart()
	{
		if (!DEMON_RAGE_ON)
		{
			PlayItemViewAnim(ENT_ME, Int(MELEE_VIEWANIM_ATK));
			if (PLAYERANIM_SWING != "PLAYERANIM_SWING")
				PlayOwnerAnim("once", PLAYERANIM_SWING, "global.anim.combatwalk", 3);
			CallEventDelayed(MELEE_SOUND_DELAY, "melee_playsound");
		}

		if (!DEMON_RAGE_ON)
			return;
		if (M_ATTACK == 1.0f)
			PlayItemViewAnim(ENT_ME, Int(ANIM_ATTACK1));
		if (M_ATTACK == 2.0f)
			PlayItemViewAnim(ENT_ME, Int(ANIM_ATTACK2));
		if (M_ATTACK == 3.0f)
		{
			PlayItemViewAnim(ENT_ME, Int(ANIM_ATTACK3));
			M_ATTACK = 1.0f;
		}
		M_ATTACK += 1.0f;
	}

	// item_idle
	void BluntMithral_OnItemIdle()
	{
		if (DEMON_RAGE_ON)
			return;

		if (Truthy(Eval("game.item.attacking")))
			return;
		if (!IsInHand(ENT_ME))
			return;
		// (never true here, the rest is skipped) if baseitem.canidle
	}

	// bs_global_command
	void BluntMithral_OnBsGlobalCommand(CBasePlayer@ deadPlayer = null, string command = "", string reason = "")
	{
		if (reason != "death")
			return;
		if (deadPlayer !is EntityOf(ENT_OWNER))
			return;
		DEMON_RAGE_ON = false;
		PlaySound(0, 10, "monsters/bludgeon/bludgeon_gaz_death.wav");
	}

	// game_removefromowner
	void BluntMithral_OnGameRemovefromowner()
	{
		if (DEMON_RAGE_ON)
			OnDemonRageEnd();
	}

	// game_putinpack
	void BluntMithral_OnGamePutinpack()
	{
		if (DEMON_RAGE_ON)
			OnDemonRageEnd();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_putinpack
	void OnGamePutinpack()
	{
		BaseItemExtras_OnGamePutinpack(); // items/base_item_extras
		BluntMithral_OnGamePutinpack();
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded
		BluntBaseTwohanded_OnWeaponSpawn(); // items/blunt_base_twohanded
		BluntMithral_OnWeaponSpawn();
	}

	// game_removefromowner
	void OnGameRemovefromowner()
	{
		BaseMelee_OnGameRemovefromowner(); // items/base_melee
		BluntMithral_OnGameRemovefromowner();
	}

	void OnGamePressAttack2() { BluntMithral_OnGamePressAttack2(); } // game_+attack2
	void OnDemonRage(float charges = 0.0f) { BluntMithral_OnDemonRage(charges); } // demon_rage
	void OnDemonRageLoop() { BluntMithral_OnDemonRageLoop(); } // demon_rage_loop
	void OnDemonRageEnd() { BluntMithral_OnDemonRageEnd(); } // demon_rage_end
	void OnDemonRageMaxed() { BluntMithral_OnDemonRageMaxed(); } // demon_rage_maxed
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return BluntMithral_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage
	void OnMeleeStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false) { BluntMithral_OnMeleeStrike(hitType, endPos, hitEntity, hit); } // melee_strike
	void OnMeleeStart() { BluntMithral_OnMeleeStart(); } // melee_start
	void OnItemIdle() { BluntMithral_OnItemIdle(); } // item_idle
	void OnBsGlobalCommand(CBasePlayer@ deadPlayer = null, string command = "", string reason = "") { BluntMithral_OnBsGlobalCommand(deadPlayer, command, reason); } // bs_global_command
	void OnDemonDuration() {} // DEMON_DURATION

	// This file's events and timers by their .script names
	bool BluntMithral_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bs_global_command") { OnBsGlobalCommand(PlayerParam(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "demon_rage") { OnDemonRage(Float(Param(params, 0))); return true; }
		if (name == "demon_rage_end") { OnDemonRageEnd(); return true; }
		if (name == "demon_rage_loop") { OnDemonRageLoop(); return true; }
		if (name == "demon_rage_maxed") { OnDemonRageMaxed(); return true; }
		if (name == "game_+attack2") { OnGamePressAttack2(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_putinpack") { OnGamePutinpack(); return true; }
		if (name == "game_removefromowner") { OnGameRemovefromowner(); return true; }
		if (name == "item_idle") { OnItemIdle(); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "melee_strike") { OnMeleeStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/blunt_mithral"]
shared class BluntMithralScript : BluntBaseTwohandedScript, BluntMithral, BaseVampire
{
	// Variables every script that includes this file declares
	int FIRE_WAVE_MP = 0;
	Vector3 FIRE_WAVE_START_POS = Vector3();
	string FIRE_WAVE_TARGS = "FIRE_WAVE_TARGS";
	float FIRE_WAVE_YAW = 0.0f;
	int GAME_PVP = 0;

	// Variables declared by included files, with the value they start with in this script
	BluntMithralScript()
	{
		ANIM_LIFT1 = 15;
		ANIM_IDLE1 = "16";
		ANIM_IDLE2 = "17";
		ANIM_IDLE_TOTAL = 2;
		ANIM_ATTACK1 = "18";
		ANIM_ATTACK2 = "19";
		ANIM_ATTACK3 = "20";
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
		return BluntMithral_DispatchEvent(name, params)
			|| BaseVampire_DispatchEvent(name, params)
			|| BluntBaseTwohandedScript::DispatchEvent(name, params);
	}
}
