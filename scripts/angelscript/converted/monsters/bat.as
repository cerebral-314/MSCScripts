#pragma context server

// Converted from monsters/bat.script by msc_transpiler.
// Thothie - attempting to see if can create better death sequence
// Bat

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bat_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MonstersBat
{
	// Constants
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_PAIN = "monsters/rat/squeak1.wav";
	string SOUND_IDLE = "monsters/rat/squeak2.wav";
	string SOUND_DEATH = "monsters/rat/squeak3.wav";
	string ATTACK_DAMAGE = "1";
	int FLEE_HEALTH = 0;
	string FLEE_CHANCE = "100%";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK = "IdleFlyNormal";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_IDLE_HANG = "IdleHang";
	string ANIM_IDLE_FLY = "IdleFlyNormal";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string ATTACK_HITCHANCE = "ATTACK_HITCHANCE";
	float NPC_GIVE_EXP = 0.0f;
	string CAN_FLEE = "CAN_FLEE";
	string CAN_HUNT = "CAN_HUNT";
	int BAT_STATUS = 0;

	// unnamed block (first think)
	void MonstersBat_FirstThink()
	{
		ANIM_WALK = "IdleFlyNormal";
		ANIM_RUN = ANIM_WALK;
		ANIM_ATTACK = "bite";
		ANIM_IDLE_HANG = "IdleHang";
		ANIM_IDLE_FLY = "IdleFlyNormal";
		ANIM_DEATH = "IdleFlyNormal"; // use normal flight for death anim (see end of script)

		MOVE_RANGE = "30";
		ATTACK_RANGE = 65.0f;
		ATTACK_HITRANGE = 100.0f;
		ATTACK_HITCHANCE = "60%";
		if (ToLowerCase(MapName()) == "catacombs")
			ATTACK_HITCHANCE = "80%";
		NPC_GIVE_EXP = 5.0f;

		CAN_FLEE = "1"; // base_npc_attack - Whether I run away
	}

	// bat_spawn
	void MonstersBat_OnBatSpawn()
	{
		int myHp = 0;

		SetName("Bat");
		// game.serverside as I am not sure if $lcase or game.map.name function client side and
		// spawn functions are always shared or the client does not receive the model
		string mapName = ToLowerCase(MapName());
		if (mapName == "edanasewers")
			myHp = 8;
		if (mapName != "edanasewers")
			myHp = 20;
		if (mapName == "nightmare_edana")
			SetMonsterClip(false);
		SetHealth(myHp);

		SetWidth(16);
		SetHeight(16);
		SetHearingSensitivity(3.5f);
		SetVolume(5);
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 0)));
		SetModel("monsters/bat.mdl");
	}

	// game_postspawn
	void MonstersBat_OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		SetBoundingBox("animsize");
	}

	// bat_drop_down
	// Drop down from the ceiling
	void MonstersBat_OnBatDropDown()
	{
		CAN_HUNT = "1";
		BAT_STATUS = (BAT_FLYING ? 1 : 0);
		SetIdleAnim(ANIM_IDLE_FLY);
	}

	// bite1
	// Deal damage
	void MonstersBat_OnBite1()
	{
		if (!(RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE))
			return;
		DoDamage(NPCATK_TARGET, "direct", ATTACK_DAMAGE, ATTACK_HITCHANCE, ENT_ME, "pierce");
	}

	// npc_struck
	// Hit by someone
	void MonstersBat_OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(0, 10, SOUND_PAIN, SOUND_STRUCK2, SOUND_PAIN);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_postspawn
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		BaseSelfAdjust_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_self_adjust
		BaseNpc_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_npc
		MonstersBat_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params);
	}

	void OnBatSpawn() { MonstersBat_OnBatSpawn(); } // bat_spawn
	void OnBatDropDown() { MonstersBat_OnBatDropDown(); } // bat_drop_down
	void OnBite1() { MonstersBat_OnBite1(); } // bite1
	void OnNpcStruck(float damage = 0.0f) { MonstersBat_OnNpcStruck(damage); } // npc_struck

	// This file's events and timers by their .script names
	bool MonstersBat_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bat_drop_down") { OnBatDropDown(); return true; }
		if (name == "bat_spawn") { OnBatSpawn(); return true; }
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/bat"]
shared class MonstersBatScript : BatBaseScript, MonstersBat
{
	// Variables declared by included files, with the value they start with in this script
	MonstersBatScript()
	{
		ANIM_WALK = "IdleFlyNormal";
		ANIM_IDLE_HANG = "IdleHang";
		ANIM_IDLE_FLY = "IdleFlyNormal";
		SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
		SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
		SOUND_DEATH = "monsters/rat/squeak3.wav";
		ATTACK_DAMAGE = "1";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/bat.mdl");
		CallEventDelayed(0.5f, "BatBase_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MonstersBat_FirstThink();
		BatBase_FirstThink();
		BaseFlyer_FirstThink();
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
		return MonstersBat_DispatchEvent(name, params)
			|| BatBaseScript::DispatchEvent(name, params);
	}
}
