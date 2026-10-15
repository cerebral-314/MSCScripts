#pragma context server

// Converted from monsters/lslime.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.
// Thothie - Wrong death animation
// - Adding attack sounds
// Lightning slime

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Lslime
{
	// Variables (an unset .script variable reads as its own name)
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_ATTACK1 = "weapons/electro4.wav";
	string SOUND_ATTACK2 = "weapons/electro5.wav";
	string SOUND_ATTACK3 = "weapons/electro6.wav";
	string SOUND_DEATH = "monsters/sludge/bio.wav";
	string SOUND_IDLE1 = "weapons/gauss2.wav";
	string ANIM_IDLE = "walk";
	string ANIM_RUN = "run";
	string ANIM_WALK = "walk";
	string ATTACK_HITCHANCE = "80%";
	string ATTACK_DAMAGE = "10";
	string FLEE_CHANCE = "25%";
	string MY_ENEMY = "enemy";
	string RETALIATE_CHANGETARGET_CHANCE = "75%";
	string LIGHTNING_SPRITE = "lgtning.spr";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string CAN_FLEE = "CAN_FLEE";
	float NPC_GIVE_EXP = 0.0f;

	// unnamed block (first think)
	void Lslime_FirstThink()
	{
		SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
		SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
		// setvar SOUND_STRUCK3		monsters\sludge\null.wav //had wrong slashes here + double define
		SOUND_ATTACK1 = "weapons/electro4.wav";
		SOUND_ATTACK2 = "weapons/electro5.wav";
		SOUND_ATTACK3 = "weapons/electro6.wav";
		SOUND_DEATH = "monsters/sludge/bio.wav";
		SOUND_IDLE1 = "weapons/gauss2.wav";
		ANIM_IDLE = "walk";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "attack";
		ANIM_DEATH = "die";
		MOVE_RANGE = "150";
		ATTACK_RANGE = 200.0f;
		ATTACK_HITRANGE = 230.0f;
		ATTACK_HITCHANCE = "80%";
		ATTACK_DAMAGE = "10";
		FLEE_CHANCE = "25%"; // base_npc_attack - Chance I run away
		MY_ENEMY = "enemy"; // base_npc_attack - Premptive attack
		RETALIATE_CHANGETARGET_CHANCE = "75%"; // base_npc_attack - Automatically switch targets to the last damaging player
		CAN_FLEE = "0"; // base_npc_attack - Whether I run away at low health
		LIGHTNING_SPRITE = "lgtning.spr";
	}

	// npc_spawn
	void Lslime_OnNpcSpawn(string npc = "")
	{
		SetHealth(15);
		// ov 120
		SetWidth(40);
		SetHeight(64);
		SetRace("wildanimal");
		SetName("Electrified slime");
		if (!Truthy(GetVar("ME_NO_WANDER")))
			SetRoam(true);
		if (Truthy(GetVar("ME_NO_WANDER")))
			SetRoam(false);
		SetHearingSensitivity(4);
		NPC_GIVE_EXP = 20.0f;

		SetBlood("green");

		SetDamageTaken("lightning", 0);

		SetModel("monsters/slime.mdl");
		SetModelBody(0, 4);
		SetIdleAnim("idle1");
		SetMoveAnim(ANIM_WALK);

		Effect("glow", ENT_ME, Vector3(255, 255, 0), 64, -1, 0);
	}

	// unnamed block (timer)
	// Idling
	void Lslime_Timer()
	{
		CallEventDelayed(10.0f, "Lslime_Timer");

		if (RandomInt(0, 1) != 0)
			return;
		PlaySound(Int(Eval("game.sound.voice")), 5, SOUND_IDLE1);
	}

	// bite1
	// Deal damage
	void Lslime_OnBite1()
	{
		if (!CanSee("enemy"))
			return;
		DoDamageEx(ENT_LASTSEEN, ATTACK_HITRANGE, ATTACK_DAMAGE, ATTACK_HITCHANCE, ENT_ME, ENT_ME, "none", "lightning", "dmgevent:bite");
	}

	// bite_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	void Lslime_OnBiteDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		PlayRandomSound(2, 5, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		Effect("beam", "point", LIGHTNING_SPRITE, 30, RelativePosition(Vector3(0, 0, -22)), end, Vector3(255, 255, 0), 150, 50, 0.2f);
	}

	// npc_struck
	// Hit by someone
	void Lslime_OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(Int(Eval("game.sound.body")), 5, "SOUND_PAIN", SOUND_STRUCK2, "SOUND_PAIN");
	}

	// cycle_up
	void Lslime_OnCycleUp(string reason = "")
	{
		if (!Truthy(GetVar("ME_NO_WANDER")))
			return;
		SetRoam(true);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttack_OnCycleUp(reason); // monsters/base_npc_attack
		Lslime_OnCycleUp(reason);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		Lslime_OnNpcSpawn(npc);
	}

	void OnBite1() { Lslime_OnBite1(); } // bite1
	void OnBiteDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { Lslime_OnBiteDodamage(hit, target, start, end, damageType, damageText); } // bite_dodamage
	void OnNpcStruck(float damage = 0.0f) { Lslime_OnNpcStruck(damage); } // npc_struck

	// This file's events and timers by their .script names
	bool Lslime_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "bite_dodamage") { OnBiteDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "Lslime_Timer") { Lslime_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/lslime"]
shared class LslimeScript : BaseMonsterScript, Lslime
{
	// Variables declared by included files, with the value they start with in this script
	LslimeScript()
	{
		SOUND_DEATH = "monsters/sludge/bio.wav";
		ANIM_IDLE = "walk";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/slime.mdl");
		CallEventDelayed(10.0f, "Lslime_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Lslime_FirstThink();
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
		return Lslime_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
