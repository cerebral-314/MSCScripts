#pragma context server

// Converted from sfor/undamael.script by msc_transpiler.
// Thothie - Atholo is not working, remaking based on Blacksmith
// -Atttempt to keep lighting effect and HP - add fire damage effect
// -Removing goofy sound references in BS
// -IMO he drops too much stuff, although I dunno how you kill him, reducing none the less
// -(Orignally droppped: swords_lostblade, swords_skullblade4, bows_swiftbow, smallarms_huggerdagger4, armor_knight, axes_greataxe)
// -(Now just lostblade)
// -Noteable Differences from Blacksmith: Sounds, <Attack Damge, >Reach, <hp, >hitchance, Glows, Taunt(?), Invulnerable, burn effect damage
// -I *think* whoever did this was trying to use the nihilanth sounds
// -They can be replaced in the MSC folder without need to alter the script, if we get some unique sounds for him
// -Can be made vulnerable via sending ms_npcscript event 'vulnerable'
// Altholo (from Blacksmith)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Undamael
{
	// Constants
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_PAIN = "controller/con_pain2.wav";
	string SOUND_ATTACK1 = "zombie/claw_miss1.wav";
	string SOUND_ATTACK2 = "zombie/claw_miss2.wav";
	string SOUND_TAUNT = "nihilanth/nil_die.wav";
	string SOUND_IDLE = "garg/gar_idle2.wav";
	string SOUND_DEATH = "nihilanth/nil_done.wav";
	int DAMAGE_ATTACK1 = 0;
	int DAMAGE_ATTACK2 = 0;
	string MONSTER_MODEL = "monsters/skeleton_boss2.mdl";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_RUN = "run";
	string ANIM_IDLE = "idle1";
	string ANIM_WALK = "walk";
	string ATTACK_HITCHANCE = "90%";
	bool SEE_ENEMY = false;
	bool IGNORE_ENEMY = false;
	string SOUND_PISSED = "garg/gar_die1.wav";
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_RANGE = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string MOVE_RANGE = "MOVE_RANGE";
	string CAN_FLINCH = "CAN_FLINCH";
	string FLINCH_DELAY = "FLINCH_DELAY";
	string NPC_MOVE_TARGET = "NPC_MOVE_TARGET";
	float NPC_GIVE_EXP = 0.0f;
	float SWIPES = 0.0f;
	bool DID_WARCRY = false;

	// unnamed block (first think)
	void Undamael_FirstThink()
	{
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ATTACK_HITRANGE = 600.0f;
		ATTACK_RANGE = 120.0f;
		ANIM_ATTACK = "";

		ATTACK_HITCHANCE = "90%";
		MOVE_RANGE = "100";
		SEE_ENEMY = false;
		IGNORE_ENEMY = false;
		CAN_FLINCH = "0";
		FLINCH_DELAY = "12";
		NPC_MOVE_TARGET = "enemy";
		GiveItem("ring_light2"); // makes him glow

		// Precache
		// the play command for it isn't in this file (it's
		// in base_monster.script)
		SOUND_PISSED = "garg/gar_die1.wav"; // added for invul script
	}

	// npc_spawn
	void Undamael_OnNpcSpawn(string npc = "")
	{
		SetUniqueName("boss_atholo");

		SetName("Atholo");
		SetInvincible(true);
		SetHealth(2200);
		SetGold(250);

		SetDamageTaken("all", 0.5f);
		SetDamageTaken("holy", 2);
		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 0.1f);
		SetDamageTaken("lightning", 0.5f);

		// ov 359
		SetWidth(40);
		SetHeight(128);
		SetRace("undead");
		SetRoam(false);
		SetHearingSensitivity(6);
		NPC_GIVE_EXP = 400.0f;
		SetModelBody(1, 4);
		SetModel(MONSTER_MODEL);
		SetModelBody(0, 0);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		ANIM_ATTACK = "attack1";

		PlaySound(2, 10, SOUND_TAUNT);

		SWIPES = 0.0f;
	}

	// attack_1
	void Undamael_OnAttack12()
	{
		DoDamage(ENT_LASTSEEN, 600, DAMAGE_ATTACK1, "75%");

		// burn effect 100%
		ApplyEffect(ENT_LASTSTRUCKBYME, "effects/dot_fire", 5, self, RandomInt(50, 100));
		SWIPES += 1.0f;
		if (!(SWIPES > 10.0f))
			return;
		SWIPES = 0.0f;
		ANIM_ATTACK = "attack2";
	}

	// attack_2
	void Undamael_OnAttack22()
	{
		DoDamage(ENT_LASTSEEN, "ATTACK2_RANGE", DAMAGE_ATTACK2, "100%");

		ApplyEffect(ENT_LASTSTRUCKBYME, "effects/dot_cold_freeze", 5, self, RandomInt(25, 50));
		ANIM_ATTACK = "attack1";
	}

	// npc_struck
	// Hit by someone
	void Undamael_OnNpcStruck(float damage = 0.0f)
	{
		SetVolume(5);
		PlayRandomSound(2, SOUND_STRUCK1, SOUND_STRUCK2);
	}

	// npcatk_targetvalidate
	void Undamael_OnNpcatkTargetvalidate(string target = "")
	{
		if (DID_WARCRY)
			return;
		DID_WARCRY = true;
		SetRoam(true);
	}

	// death
	// ported from original,edited
	void Undamael_OnDeath()
	{
		// Only ONE perfect or unique item per Boss PLEASE! :D
		PlaySound(2, 10, SOUND_DEATH);
	}

	// wander
	void Undamael_OnWander()
	{
		CallEventDelayed(15.0f, "wander");

		PlaySound(2, 10, SOUND_TAUNT);
		SetMoveAnim(ANIM_WALK);
		SEE_ENEMY = false;
	}

	// vulnerable
	// attempt to make vulnerable via msnpc_script
	void Undamael_OnVulnerable()
	{
		SetInvincible(false);
		PlaySound(2, 10, SOUND_PISSED);
		SetSayTextRange(1024);
		SetAnimMoveSpeed(2);
		SetAnimFrameRate(1.5f);
		CAN_FLINCH = "1";
		SayText("Fools! I shall destroy you all!");
	}

	// turn_undead
	void Undamael_OnTurnUndead(float holyDamage = 0.0f, CBaseEntity@ exorcist = null)
	{
		// Can be damaged by Holy Light, but not turned
		// PARAM1 - incoming Holy damage
		// PARAM2 - exorcist
		CBaseEntity@ meMe = self;

		DoDamage(meMe, "direct", holyDamage, 100, @exorcist);

		Effect("glow", ENT_ME, Vector3(255, 255, 0), 512, 1, 1);
	}

	// my_target_died
	void Undamael_OnMyTargetDied(string offender = "")
	{
		PlaySound(0, 10, SOUND_TAUNT);
	}

	// game_death
	void Undamael_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
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
		Undamael_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// turn_undead
	void OnTurnUndead(float holyDamage = 0.0f, CBaseEntity@ exorcist = null)
	{
		MonstersExternals_OnTurnUndead(holyDamage, exorcist); // monsters/externals
		Undamael_OnTurnUndead(holyDamage, exorcist);
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttack_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack
		Undamael_OnNpcatkTargetvalidate(target);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttack_OnMyTargetDied(offender); // monsters/base_npc_attack
		Undamael_OnMyTargetDied(offender);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		Undamael_OnNpcSpawn(npc);
	}

	void OnAttack12() { Undamael_OnAttack12(); } // attack_1
	void OnAttack22() { Undamael_OnAttack22(); } // attack_2
	void OnNpcStruck(float damage = 0.0f) { Undamael_OnNpcStruck(damage); } // npc_struck
	void OnDeath() { Undamael_OnDeath(); } // death
	void OnWander() { Undamael_OnWander(); } // wander
	void OnVulnerable() { Undamael_OnVulnerable(); } // vulnerable

	// This file's events and timers by their .script names
	bool Undamael_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "death") { OnDeath(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "turn_undead") { OnTurnUndead(Float(Param(params, 0)), EntityParam(params, 1)); return true; }
		if (name == "vulnerable") { OnVulnerable(); return true; }
		if (name == "wander") { OnWander(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "sfor/undamael"]
shared class UndamaelScript : BaseMonsterScript, Undamael
{
	// Variables declared by included files, with the value they start with in this script
	UndamaelScript()
	{
		SOUND_DEATH = "nihilanth/nil_done.wav";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skeleton_boss2.mdl");
		Precache("lgtning.spr");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Undamael_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return Undamael_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
