#pragma context server

// Converted from calruin/cavetroll.script by msc_transpiler.
// Thothie - this script, is insanely overpowered, and his location in Calruin makes him useles.
// - Just thought I'd overstate the obvious
// - Lots of fixes (sound changes, animations, attacks)
// - Added throw attack, case shield abuse
// Calrian's Blacksmith

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Cavetroll
{
	// Constants
	float NPC_BOSS_REGEN_RATE = 0.1f;
	float NPC_BOSS_RESTORATION = 1.0f;
	string SOUND_STRUCK1 = "controller/con_pain2.wav";
	string SOUND_STRUCK2 = "controller/con_pain3.wav";
	string SOUND_ATTACK1 = "zombie/claw_strike1.wav";
	string SOUND_ATTACK2 = "zombie/claw_strike2.wav";
	string SOUND_ATTACK3 = "zombie/claw_strike3.wav";
	string SOUND_DEATH = "garg/gar_die2.wav";
	string SOUND_SPAWN = "garg/gar_alert2.wav";
	string SOUND_FLINCH1 = "garg/gar_pain3.wav";
	string SOUND_FLINCH2 = "garg/gar_pain2.wav";
	string SOUND_PUSH = "garg/gar_attack3.wav";
	string SOUND_FALL = "weapons/mortarhit.wav";
	string ANIM_FULLRUN = "run";
	int SLASH_RANGE = 150;
	int SMASH_RANGE = 100;
	int SLASH_HITRANGE = 200;
	int SMASH_HITRANGE = 125;
	string MAIN_MODEL = "monsters/skeleton_hood.mdl";
	string ALT_MODEL = "monsters/skeleton_boss2.mdl";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_RUN = "walk";
	string ANIM_IDLE = "idle1";
	string ANIM_WALK = "walk";
	bool NPC_IS_BOSS = false;
	string NPC_EXP_MULTI = "NPC_EXP_MULTI";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_SMASH = "ANIM_SMASH";
	string ANIM_SLASH = "ANIM_SLASH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	int THROW_RANGE = 0;
	float ATTACK_RANGE = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float THROW_FREQ = 0.0f;
	string NPC_MUST_SEE_TARGET = "NPC_MUST_SEE_TARGET";
	bool I_AM_TURNABLE = false;
	string ANIM_THROW = "ANIM_THROW";
	int THROW_TIME = 0;
	float THROW_DELAY = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	float THROW_COUNT = 0.0f;
	bool ROAM_ON = false;
	bool STUN_ATTACK = false;
	string CAN_FLINCH = "CAN_FLINCH";
	bool DELAY_NEXT_THROW = false;
	string THROW_TARGET = "THROW_TARGET";
	bool AM_GERIC = false;
	bool SET_GREEK = false;

	// unnamed block (first think)
	void Cavetroll_FirstThink()
	{
		if (ToLowerCase(MapName()) == "calruin2")
			NPC_IS_BOSS = true;
		if (ToLowerCase(MapName()) == "calruin")
			NPC_IS_BOSS = true;
		if (ToLowerCase(MapName()) == "ww3d")
			NPC_IS_BOSS = true;
		if (!NPC_IS_BOSS)
			NPC_EXP_MULTI = "0.25";

		ANIM_DEATH = "diesimple";
		ANIM_RUN = "walk";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_SMASH = "attack2"; // these are reversed in model events! ><
		ANIM_SLASH = "attack1";
		ANIM_ATTACK = ANIM_SLASH;
		THROW_RANGE = 250;
		ATTACK_RANGE = SMASH_RANGE;
		ATTACK_MOVERANGE = 50.0f;
		ATTACK_HITRANGE = SLASH_HITRANGE;
		THROW_FREQ = 10.0f; // min seconds between throws

		NPC_MUST_SEE_TARGET = "0"; // he cant see through himself if yer on his head
	}

	// npc_spawn
	void Cavetroll_OnNpcSpawn(string npc = "")
	{
		string mapName = ToLowerCase(MapName());

		I_AM_TURNABLE = false;

		if (mapName == "ww3d")
			OnGericMode();

		if (FORCE_GERIC)
			OnGericMode();

		if (!AM_GERIC)
		{
			SetName("Garonhroth the Blacksmith");
			SetModel(MAIN_MODEL);
			ANIM_THROW = "throw_scientist";
			THROW_TIME = 15; // throw every 15th hit
			THROW_DELAY = 2.0f;
			THROW_FREQ = 20.0f;
			if (NPC_IS_BOSS)
				NPC_GIVE_EXP = 2000.0f;
			if (!NPC_IS_BOSS)
				NPC_GIVE_EXP = 1000.0f;
		}

		SetHealth(6000);
		SetGold(RandomInt(100, 300));
		SetWidth(40);
		SetHeight(120);
		SetRace("undead");
		SetBoundingBox("npcsize");
		SetSolid("box");

		SetRoam(false);
		SetHearingSensitivity(12);
		// setmodelbody	0 0
		string currentMap = MapName();
		if (currentMap == "calruin2")
			SetModelBody(0, 1);
		if (currentMap == "calruin2_1")
			SetModelBody(0, 1);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		PlayAnim("once", ANIM_IDLE);
		SetDamageTaken("all", 0.6f);

		SetDamageTaken("holy", 1.5f);
		// takedmg dark 0.25 //oops
		SetDamageTaken("poison", 0);

		THROW_COUNT = 0.0f;

		PlaySound(0, 10, SOUND_SPAWN);
	}

	// npcatk_get_postspawn_properties
	void Cavetroll_OnNpcatkGetPostspawnProperties()
	{
		if (!AM_GERIC)
			return;
		ANIM_RUN = ANIM_FULLRUN;
	}

	// npcatk_targetvalidate
	void Cavetroll_OnNpcatkTargetvalidate(string target = "")
	{
		if (ROAM_ON)
			return;
		ROAM_ON = true;
		SetRoam(true);
	}

	// attack_1
	// called by model anim attack1
	void Cavetroll_OnAttack12()
	{
		if (RangeTo(NPCATK_TARGET) < SLASH_HITRANGE)
			OnNpcatkDodamage(NPCATK_TARGET, "direct", Text(Random(40, 55)), "75%", EntityId(self), "slash");

		if (RandomInt(1, 10) != 1)
			return;
		ANIM_ATTACK = ANIM_SMASH;
		ATTACK_RANGE = SMASH_RANGE;
		ATTACK_HITRANGE = SMASH_HITRANGE;
	}

	// attack_2
	// called by model anim attack2
	void Cavetroll_OnAttack22()
	{
		if (RangeTo(NPCATK_TARGET) < SMASH_HITRANGE)
			OnNpcatkDodamage(NPCATK_TARGET, "direct", Text(Random(30, 40)), "100%", EntityId(self), "blunt");
		STUN_ATTACK = true;
		PlaySound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		ANIM_ATTACK = ANIM_SLASH;
		ATTACK_RANGE = SLASH_RANGE;
		ATTACK_HITRANGE = SLASH_HITRANGE;
	}

	// npc_struck
	// Hit by someone
	void Cavetroll_OnNpcStruck(float damage = 0.0f)
	{
		float myCurrentHp = HealthOf(ENT_ME);

		if (myCurrentHp < 2000.0f)
			CAN_FLINCH = "1";

		PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2);
	}

	// npc_flinch
	void Cavetroll_OnNpcFlinch(float damage = 0.0f)
	{
		if (!Truthy(CAN_FLINCH))
			return;
		PlayAnim("critical", "ANIM_FLINCH");
		PlayRandomSound(0, 10, SOUND_FLINCH1, SOUND_FLINCH2);
	}

	// game_death
	void Cavetroll_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (ToLowerCase(MapName()) == "ww3d")
			CallExternal("players", "ext_clear_valid_gauntlets");
		OnKaboomBs();
	}

	// kaboom_bs
	void Cavetroll_OnKaboomBs()
	{
		// screenshake <position> <amplitude> <frequency> <duration> <radius>
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 50, 10, 2, 1024);
		PlaySound(Int(GetVar("CHAN_VOICE")), 10, SOUND_FALL);
	}

	// give_clubs
	void Cavetroll_OnGiveClubs()
	{
		// to be called by external ms_npcscript
		SetModelBody(0, 1);
	}

	// invincible_on
	void Cavetroll_OnInvincibleOn()
	{
		// to be called by external ms_npcscript
		SetInvincible(true);
	}

	// vulnerable
	void Cavetroll_OnVulnerable()
	{
		// to be called by external ms_npcscript
		SetInvincible(false);
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string Cavetroll_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;

		if (ANIM_ATTACK != "attack1")
			return result;

		THROW_COUNT += 1.0f;

		if (THROW_COUNT > THROW_TIME)
		{
			THROW_COUNT = 0.0f;
			if (!DELAY_NEXT_THROW)
			{
				DELAY_NEXT_THROW = true;
				CallEventDelayed(THROW_FREQ, "reset_throw");
				PlayAnim("break");
				PlayAnim("critical", ANIM_THROW);
				PlaySound(Int(GetVar("CHAN_VOICE")), 10, SOUND_PUSH);
				THROW_TARGET = EntityId(target); // cant pass params via params
				OnNpcatkSuspendAi("2.0");
				CallEventDelayed(THROW_DELAY, "throw_chummer");
			}
		}
		return result;
	}

	// reset_throw
	void Cavetroll_OnResetThrow()
	{
		DELAY_NEXT_THROW = false;
	}

	// throw_chummer
	void Cavetroll_OnThrowChummer()
	{
		// //dbg ThrowChummerGot p1 PARAM1 range NME_DIST vs SMASH_RANGE
		if (!(RangeTo(THROW_TARGET) < THROW_RANGE))
			return;
		ApplyEffect(THROW_TARGET, "effects/effect_push", 3, RelativeVelocity(Vector3(0, 800, 800)), 0);
	}

	// geric_mode
	void Cavetroll_OnGericMode()
	{
		AM_GERIC = true;
		THROW_TIME = 10; // throw every 10th hit
		ANIM_THROW = "bigflinch";
		THROW_DELAY = 0.5f;
		THROW_FREQ = 8.0f;
		SetMoveSpeed(2); // model isnt setup right
		SetName("The Dread Knight Sir Geric");
		SetDamageTaken("fire", 0.1f);
		SetModel(ALT_MODEL);
		SetModelBody(0, 9);
		SetModelBody(1, 4);
		ANIM_RUN = ANIM_FULLRUN;
		SetStat("parry", 100);
		if (NPC_IS_BOSS) // v.hard to get to, make it worth it for the folks escorting the nubs
			NPC_GIVE_EXP = 5000.0f;
		if (!NPC_IS_BOSS) // subject to gangbang
			NPC_GIVE_EXP = 800.0f;
		SetRoam(true);

		if (ToLowerCase(MapName()) == "thanatos")
			SET_GREEK = true;
		if (SET_GREEK)
			SetModelBody(0, 10);
	}

	// game_damaged_other
	string Cavetroll_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		if (!STUN_ATTACK)
			return result;
		STUN_ATTACK = false;
		ApplyEffect(target, "effects/effect_push", 1, RelativeVelocity(Vector3(0, 200, 30)), 0);
		return result;
	}

	// go_greek
	void Cavetroll_OnGoGreek()
	{
		SetModelBody(0, 10);
		SET_GREEK = true;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		Cavetroll_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, Cavetroll_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// npcatk_get_postspawn_properties
	void OnNpcatkGetPostspawnProperties()
	{
		BaseNpc_OnNpcatkGetPostspawnProperties(); // monsters/base_npc
		BaseNpcAttackNew_OnNpcatkGetPostspawnProperties(); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkGetPostspawnProperties(); // monsters/base_monster_shared
		Cavetroll_OnNpcatkGetPostspawnProperties();
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		Cavetroll_OnNpcSpawn(npc);
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		Cavetroll_OnNpcatkTargetvalidate(target);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, Cavetroll_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	void OnAttack12() { Cavetroll_OnAttack12(); } // attack_1
	void OnAttack22() { Cavetroll_OnAttack22(); } // attack_2
	void OnNpcStruck(float damage = 0.0f) { Cavetroll_OnNpcStruck(damage); } // npc_struck
	void OnNpcFlinch(float damage = 0.0f) { Cavetroll_OnNpcFlinch(damage); } // npc_flinch
	void OnKaboomBs() { Cavetroll_OnKaboomBs(); } // kaboom_bs
	void OnGiveClubs() { Cavetroll_OnGiveClubs(); } // give_clubs
	void OnInvincibleOn() { Cavetroll_OnInvincibleOn(); } // invincible_on
	void OnVulnerable() { Cavetroll_OnVulnerable(); } // vulnerable
	void OnResetThrow() { Cavetroll_OnResetThrow(); } // reset_throw
	void OnThrowChummer() { Cavetroll_OnThrowChummer(); } // throw_chummer
	void OnGericMode() { Cavetroll_OnGericMode(); } // geric_mode
	void OnGoGreek() { Cavetroll_OnGoGreek(); } // go_greek
	void OnThrowDelay() {} // THROW_DELAY
	void OnThrowFreq() {} // THROW_FREQ

	// This file's events and timers by their .script names
	bool Cavetroll_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "geric_mode") { OnGericMode(); return true; }
		if (name == "give_clubs") { OnGiveClubs(); return true; }
		if (name == "go_greek") { OnGoGreek(); return true; }
		if (name == "invincible_on") { OnInvincibleOn(); return true; }
		if (name == "kaboom_bs") { OnKaboomBs(); return true; }
		if (name == "npc_flinch") { OnNpcFlinch(Float(Param(params, 0))); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npcatk_get_postspawn_properties") { OnNpcatkGetPostspawnProperties(); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "reset_throw") { OnResetThrow(); return true; }
		if (name == "throw_chummer") { OnThrowChummer(); return true; }
		if (name == "vulnerable") { OnVulnerable(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "calruin/cavetroll"]
shared class CavetrollScript : BaseMonsterNewScript, Cavetroll
{
	// Variables every script that includes this file declares
	bool FORCE_GERIC = false;

	// Variables declared by included files, with the value they start with in this script
	CavetrollScript()
	{
		NPC_BOSS_RESTORATION = 1.0f;
		SOUND_DEATH = "garg/gar_die2.wav";
		ANIM_RUN = "walk";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skeleton_boss2.mdl");
		Precache("monsters/skeleton_hood.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Cavetroll_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return Cavetroll_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
