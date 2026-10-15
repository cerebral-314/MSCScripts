#pragma context server

// Converted from monsters/rabid_skele_base.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class RabidSkeleBase
{
	// Constants
	string ANIM_IDLE1 = "idle1";
	string ANIM_IDLE2 = "idle2";
	string ANIM_IDLE3 = "idle3";
	string ANIM_DUCK = "crouch";
	string ANIM_JUMP = "jump";
	string ANIM_SUMMON1 = "updown";
	string ANIM_SUMMON2 = "downup";
	string ANIM_SUMMON_FLYER = "jabber";
	string ANIM_PARRY = "right";
	string ANIM_SLASH = "attack1";
	string ANIM_PROJECTILE = "zapattack1";
	string ANIM_FLINCH1 = "flinch2";
	string ANIM_FLINCH2 = "laflinch";
	string ANIM_FLINCH3 = "raflinch";
	string ANIM_FLINCH4 = "llflinch";
	string ANIM_FLINCH5 = "rlflinch";
	string ANIM_DEATH_FINAL = "diebackward";
	string ANIM_DEATH_FAKE = "dieheadshot";
	string ANIM_IDLE_DEAD = "cw_sleep_headshot";
	string ANIM_GET_UP = "cw_awake_headshot";
	float FREQ_IDLE = 0.0f;
	int TURN_REQ = 5;
	string ANIM_BEG = "collar1";
	string ANIM_ANGRY1 = "collar2";
	string ANIM_ANGRY2 = "jibber";
	string ANIM_TEASE = "cw_pepsiidle";
	string ANIM_PLAY_DEAD1 = "cw_sleep_head";
	string ANIM_AWAKE1 = "cw_awake_head";
	string ANIM_PLAY_DEAD2 = "cw_sleep_back";
	string ANIM_AWAKE2 = "cw_awake_back";
	string SOUND_ALERT1 = "monsters/kelly_sounds/slv_alert1.wav";
	string SOUND_ALERT2 = "monsters/kelly_sounds/slv_alert3.wav";
	string SOUND_ALERT3 = "monsters/kelly_sounds/slv_alert4.wav";
	string SOUND_ATTACK = "monsters/kelly_sounds/hc_attack3.wav";
	string SOUND_DEATH1 = "monsters/kelly_sounds/slv_die1.wav";
	string SOUND_DEATH2 = "monsters/kelly_sounds/slv_die2.wav";
	string SOUND_STRUCK1 = "xxx";
	string SOUND_STRUCK2 = "xxx";
	string SOUND_PAIN1 = "monsters/kelly_sounds/slv_pain1.wav";
	string SOUND_PAIN2 = "monsters/kelly_sounds/slv_pain2.wav";
	string SOUND_IDLE1 = "monsters/kelly_sounds/slv_word1.wav";
	string SOUND_IDLE2 = "monsters/kelly_sounds/slv_word2.wav";
	string SOUND_IDLE3 = "monsters/kelly_sounds/slv_word3.wav";
	string SOUND_IDLE4 = "monsters/kelly_sounds/slv_word4.wav";
	string SOUND_IDLE5 = "monsters/kelly_sounds/slv_word5.wav";
	string SOUND_IDLE6 = "monsters/kelly_sounds/slv_word6.wav";
	string SOUND_IDLE7 = "monsters/kelly_sounds/slv_word7.wav";
	string SOUND_IDLE8 = "monsters/kelly_sounds/slv_word8.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_RUN = "run1";
	string ANIM_WALK = "walk1";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_IDLE = "ANIM_IDLE";
	float ATTACK_MOVERANGE = 0.0f;
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	bool DID_WARCRY = false;

	// unnamed block (first think)
	void RabidSkeleBase_FirstThink()
	{
		// base anims
		ANIM_RUN = "run1";
		ANIM_WALK = "walk1";
		ANIM_ATTACK = ANIM_SLASH;
		ANIM_IDLE = ANIM_IDLE3;

		// base stats
		ATTACK_MOVERANGE = 30.0f;
		ATTACK_RANGE = 60.0f;
		ATTACK_HITRANGE = 164.0f;
	}

	// npc_spawn
	void RabidSkeleBase_OnNpcSpawn(string npc = "")
	{
		SetDamageTaken("poison", 0);
		OnRabidSkeleSpawn();
		CallEventDelayed(0.1f, "idle_loop");
	}

	// rabid_skele_spawn
	void RabidSkeleBase_OnRabidSkeleSpawn()
	{
		SetName("Rabid Poisonbone");
		SetModel("monsters/rabid_skelly.mdl");
		SetRace("undead");
		SetBlood("none");
		SetHearingSensitivity(4);
		NPC_GIVE_EXP = 60.0f;
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		PlayAnim("once", ANIM_IDLE);
		SetWidth(32);
		SetHeight(64);
		SetProp(ENT_ME, "skin", 3);

		SetHealth(200);
		SetDamageTaken("holy", 2);
	}

	// idle_loop
	void RabidSkeleBase_OnIdleLoop()
	{
		CallEventDelayed(FREQ_IDLE, "idle_loop");

		int rndSound = RandomInt(1, 8);
		if (rndSound == 1)
			PlaySound(2, 10, SOUND_IDLE1);
		if (rndSound == 2)
			PlaySound(2, 10, SOUND_IDLE2);
		if (rndSound == 3)
			PlaySound(2, 10, SOUND_IDLE3);
		if (rndSound == 4)
			PlaySound(2, 10, SOUND_IDLE4);
		if (rndSound == 5)
			PlaySound(2, 10, SOUND_IDLE5);
		if (rndSound == 6)
			PlaySound(2, 10, SOUND_IDLE6);
		if (rndSound == 7)
			PlaySound(2, 10, SOUND_IDLE7);
		if (rndSound == 8)
			PlaySound(2, 10, SOUND_IDLE8);

		int rndAnim = RandomInt(1, 3);
		if (rndAnim == 1)
			PlayAnim("once", ANIM_IDLE1);
		if (rndAnim == 3)
			PlayAnim("once", ANIM_IDLE3);
	}

	// game_takedamage
	// PARAM1=attacker  PARAM2=inflictor? PARAM3=dmg PARAM4=dmg_type - use return to alter incoming damage
	string RabidSkeleBase_OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		bool exitSub = false;
		string result = "";
		PlayRandomSound(2, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_PAIN1, SOUND_PAIN2);
		if (Contains(damageType, "effect"))
			exitSub = true;
		if (exitSub)
			return result;
		if (RandomInt(1, 5) != 1)
			return result;
		OnNpcatkFlee(EntityId(EntityOf(ENT_LASTSTRUCK)), "1024", "5.0");
		return result;
	}

	// npcatk_lost_sight
	void RabidSkeleBase_OnNpcatkLostSight()
	{
		PlayAnim("once", "idle1");
		DID_WARCRY = false;
	}

	// my_target_died
	void RabidSkeleBase_OnMyTargetDied(string offender = "")
	{
		DID_WARCRY = false;
	}

	// npc_targetsighted
	void RabidSkeleBase_OnNpcTargetsighted(string target = "")
	{
		if (!DID_WARCRY)
		{
			DID_WARCRY = true;
			OnDoWarcry();
		}
		OnCheckProjectile();
	}

	// do_warcry
	void RabidSkeleBase_OnDoWarcry()
	{
		PlayAnim("once", "idle2");
		PlayRandomSound(0, 10, SOUND_ALERT1, SOUND_ALERT2, SOUND_ALERT3);
	}

	// turn_undead
	void RabidSkeleBase_OnTurnUndead(float holyDamage = 0.0f, CBaseEntity@ exorcist = null)
	{
		PlaySound(0, 10, SOUND_PAIN1);
		if (RandomInt(1, int(holyDamage)) < TURN_REQ)
			OnNpcatkFlee(EntityId(exorcist), "1024", "5.0");
	}

	// check_projectile
	void RabidSkeleBase_OnCheckProjectile()
	{
	}

	// npc_death
	// fake death ala skeleton
	void RabidSkeleBase_OnNpcDeath()
	{
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// turn_undead
	void OnTurnUndead(float holyDamage = 0.0f, CBaseEntity@ exorcist = null)
	{
		MonstersExternals_OnTurnUndead(holyDamage, exorcist); // monsters/externals
		RabidSkeleBase_OnTurnUndead(holyDamage, exorcist);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		RabidSkeleBase_OnNpcSpawn(npc);
	}

	// npcatk_lost_sight
	void OnNpcatkLostSight()
	{
		BaseNpcAttackNew_OnNpcatkLostSight(); // monsters/base_npc_attack_new
		RabidSkeleBase_OnNpcatkLostSight();
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		RabidSkeleBase_OnMyTargetDied(offender);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		RabidSkeleBase_OnNpcTargetsighted(target);
	}

	void OnRabidSkeleSpawn() { RabidSkeleBase_OnRabidSkeleSpawn(); } // rabid_skele_spawn
	void OnIdleLoop() { RabidSkeleBase_OnIdleLoop(); } // idle_loop
	string OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "") { return RabidSkeleBase_OnGameTakedamage(attacker, inflictor, damage, damageType); } // game_takedamage
	void OnDoWarcry() { RabidSkeleBase_OnDoWarcry(); } // do_warcry
	void OnCheckProjectile() { RabidSkeleBase_OnCheckProjectile(); } // check_projectile
	void OnNpcDeath() { RabidSkeleBase_OnNpcDeath(); } // npc_death
	void OnFreqIdle() {} // FREQ_IDLE

	// This file's events and timers by their .script names
	bool RabidSkeleBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "check_projectile") { OnCheckProjectile(); return true; }
		if (name == "do_warcry") { OnDoWarcry(); return true; }
		if (name == "game_takedamage") { Return(OnGameTakedamage(EntityParam(params, 0), EntityParam(params, 1), Float(Param(params, 2)), Param(params, 3))); return true; }
		if (name == "idle_loop") { OnIdleLoop(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_lost_sight") { OnNpcatkLostSight(); return true; }
		if (name == "rabid_skele_spawn") { OnRabidSkeleSpawn(); return true; }
		if (name == "turn_undead") { OnTurnUndead(Float(Param(params, 0)), EntityParam(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/rabid_skele_base"]
shared class RabidSkeleBaseScript : BaseMonsterNewScript, RabidSkeleBase
{
	// Variables every script that includes this file declares
	bool AM_CLOAKED = false;
	bool BEAMS_INITED = false;
	string BEAM_ID1 = "BEAM_ID1";
	string BEAM_ID2 = "BEAM_ID2";
	string BEAM_TARG = "BEAM_TARG";
	string BEAM_TARGET = "BEAM_TARGET";
	float DUR_CLOAK = 0.0f;
	float FREQ_CLOAK = 0.0f;
	float FREQ_PROJECTILE = 0.0f;
	string PLAYER_LIST = "PLAYER_LIST";

	// Variables declared by included files, with the value they start with in this script
	RabidSkeleBaseScript()
	{
		ANIM_RUN = "run1";
		ANIM_WALK = "walk1";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/rabid_skelly.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		RabidSkeleBase_FirstThink();
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
		return RabidSkeleBase_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
