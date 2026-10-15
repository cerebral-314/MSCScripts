#pragma context server

// Converted from NPCs/default_human.script by msc_transpiler.
// *** Default human script ***

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_civilian.as"
#include "converted/monsters/base_xmass.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class NPCsDefaultHuman
{
	// Constants
	string CAN_HUNT = "0";
	string HUNT_AGRO = "0";
	string CAN_ATTACK = "0";
	int FLEE_HEALTH = 25;
	string FLEE_CHANCE = "100%";
	string CAN_HEAR = "1";
	string CAN_RETALIATE = "1";
	string RETALIATE_CHANGETARGET_CHANCE = "75%";
	string CAN_FLINCH = "1";
	string FLINCH_ANIM = "flinch1";
	string FLINCH_CHANCE = "50%";
	string FLINCH_DELAY = "1";
	bool NO_CHAT = true;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK = "walk";
	string ANIM_RUN = "run";
	float ATTACK_RANGE = 90.0f;
	string CAN_FLEE = "1";
	string ANIM_DEATH = "ANIM_DEATH";
	string MOVE_RANGE = "MOVE_RANGE";
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool AM_SCARED = false;

	// unnamed block (first think)
	void NPCsDefaultHuman_FirstThink()
	{
		ANIM_DEATH = "diesimple";
		MOVE_RANGE = "64";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "beatdoor";
		ANIM_DEATH = "diesimple";
		ATTACK_RANGE = 90.0f;
		CAN_FLEE = "1";
		AM_SCARED = false;
	}

	// npc_spawn
	void NPCsDefaultHuman_OnNpcSpawn(string npc = "")
	{
		SetHealth(25);
		// ov		120
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetName("Commoner");
		SetRoam(true);
		SetBlood("red");
		SetModel("npc/human1.mdl");
		SetModelBody(0, RandomInt(0, 2));
		SetModelBody(1, RandomInt(0, 5));

		SetMoveAnim("walk");

		SetSkillLevel(-10);
	}

	// unnamed block (timer)
	void NPCsDefaultHuman_Timer()
	{
		CallEventDelayed(RandomInt(25, 35), "NPCsDefaultHuman_Timer");

		if (AM_SCARED)
			return;

		if (!Truthy(LegacyFunction("cansee", "ally", 180)))
			return;

		SetMoveDest(ENT_LASTSEEN, 128);
		SetVolume(2);
		if (!Truthy(GetVar("G_CHRISTMAS_MODE")))
			Say("chitchat[.5]", "[.2]", "[.55]", "[.55]", "[.23]", "[.22]");
		if (Truthy(GetVar("G_CHRISTMAS_MODE")))
			Say("xmass_male[.5]", "[.2]", "[.55]", "[.55]", "[.23]", "[.22]");
	}

	// game_struck
	void NPCsDefaultHuman_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		SetMoveDest(ENT_LASTSTRUCK, 1024, "flee");
		SetMoveAnim(ANIM_RUN);
		AM_SCARED = true;
		CallEventDelayed(20.0f, "calm_down1");
	}

	// calm_down1
	void NPCsDefaultHuman_OnCalmDown1()
	{
		SetMoveAnim("walk_scared");
		CallEventDelayed(10.0f, "calm_down2");
	}

	// calm_down2
	void NPCsDefaultHuman_OnCalmDown2()
	{
		SetMoveAnim(ANIM_WALK);
		AM_SCARED = false;
	}

	// game_heardsound
	void NPCsDefaultHuman_OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		CBaseEntity@ lastHeard = EntityOf(ENT_LASTHEARD);
		if (IsPlayer(lastHeard))
			return;
		if (RelationshipOf(ENT_ME, @lastHeard) != "enemy")
			return;
		SetMoveDest(@lastHeard, 1024, "flee");
		OnCallForHelp(lastHeard);
		AM_SCARED = true;
		CallEventDelayed(20.0f, "calm_down1");
	}

	// say_xmass
	void NPCsDefaultHuman_OnSayXmass()
	{
		if (!Truthy(GetVar("G_CHRISTMAS_MODE")))
			return;
		PlayAnim("critical", "wave");
		SayText("A happy Hogswatch to you too!");
		PlayMusic("all", "system", "xmass_annoy.mp3");
		Say("xmass_male[.20]", "[.20]", "[.30]", "[.10]", "[.20]", "[.10]", "[.10]", "[.10]", "[.10]");

		if (!Truthy(GetVar("IS_SNOWING")))
			CallExternal("players", "ext_weather_change", "snow");
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
		BaseCivilian_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_civilian
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseXmass_OnGameSpawn(playerRace, playerGender); // monsters/base_xmass
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseCivilian_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_civilian
		NPCsDefaultHuman_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// say_xmass
	void OnSayXmass()
	{
		BaseXmass_OnSayXmass(); // monsters/base_xmass
		NPCsDefaultHuman_OnSayXmass();
	}

	void OnNpcSpawn(string npc = "") { NPCsDefaultHuman_OnNpcSpawn(npc); } // npc_spawn
	void OnCalmDown1() { NPCsDefaultHuman_OnCalmDown1(); } // calm_down1
	void OnCalmDown2() { NPCsDefaultHuman_OnCalmDown2(); } // calm_down2
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f) { NPCsDefaultHuman_OnGameHeardsound(soundType, origin, dangerRadius); } // game_heardsound

	// This file's events and timers by their .script names
	bool NPCsDefaultHuman_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "calm_down1") { OnCalmDown1(); return true; }
		if (name == "calm_down2") { OnCalmDown2(); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "say_xmass") { OnSayXmass(); return true; }
		if (name == "NPCsDefaultHuman_Timer") { NPCsDefaultHuman_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "NPCs/default_human"]
shared class NPCsDefaultHumanScript : BaseNpcScript, NPCsDefaultHuman, BaseCivilian, BaseXmass
{
	// Variables every script that includes this file declares
	float CHATTER = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	NPCsDefaultHumanScript()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ATTACK_RANGE = 90.0f;
		CAN_FLEE = "1";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		Precache("npc/chitchat.wav");
		Precache("npc/xmass_male.wav");
		CallEventDelayed(Float(Eval("$rand(25,35)")), "NPCsDefaultHuman_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		NPCsDefaultHuman_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return NPCsDefaultHuman_DispatchEvent(name, params)
			|| BaseCivilian_DispatchEvent(name, params)
			|| BaseXmass_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
