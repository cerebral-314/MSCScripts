#pragma context server

// Converted from gatecity/guard.script by msc_transpiler.
// Gate City guard

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_chat.as"

[script "gatecity/guard"]
class GatecityGuard : BaseMonsterNewScript, BaseChat
{
	// Constants
	string ATTACK_HITCHANCE = "85%";
	string ATTACK_DAMAGE = "50";
	int BG_MAX_HEAR_CIV = 1024;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	float TRAVEL_HOME_TIME = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	GatecityGuard()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle";
	}

	// unnamed block (first think)
	void GatecityGuard_FirstThink()
	{
		ATTACK_MOVERANGE = 32.0f;
		ATTACK_RANGE = 64.0f;
		ATTACK_HITRANGE = 120.0f;
		ANIM_DEATH = "death";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "attack";
		ANIM_IDLE = "idle";
	}

	// npc_spawn
	// include monsters/base_guard_friendly_new - not working for some damned reason
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetHealth(700); // Guards are strong
		SetGold(10);
		SetName("Gate City Guard");
		SetFieldOfView(359);
		SetWidth(32);
		SetHeight(64);
		SetRace("hguard");
		SetRoam(false);
		if (ToLowerCase(MapName()) == "gatecity")
		{
			SetMonsterClip(false);
			SetStepSize(256);
		}
		SetModel("dwarf/male1.mdl");
		SetModelBody(0, 1); // 0-Elder 1-Youngin 2-Zombie
		SetModelBody(1, 3); // 0-Unarmed 1-smallaxe 2-battleaxe 3-bastardsword
		SetMoveAnim("walk");

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet");
		CatchSpeech("say_job", "job", "work", "money", "gold");
		CatchSpeech("say_rumour", "rumour", "news", "happenings", "rumor");
		CatchSpeech("say_mayor", "mayor");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		if (NPCATK_TARGET != "unset")
			return;

		if (!(GameTime() > TRAVEL_HOME_TIME))
			return;
		TRAVEL_HOME_TIME = GameTime() + 3.0f;
		if (Distance(Vec(NPC_HOME_LOC), MyOrigin()) > 32.0f)
		{
			NO_STUCK_CHECKS = "0";
			OnNpcatkWalk();
			OnNpcatkSetmovedest(NPC_HOME_LOC, "10");
		}
		else
		{
			SetRoam(false);
			NO_STUCK_CHECKS = "1";
			SetAngle("face", Vector3(0, NPC_HOME_ANG.y, 0));
		}
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		NO_STUCK_CHECKS = "0";
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat
		OnSayRumour();
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SayText("Welcome to Gate City, Adventurer!");
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		SayText("I have no work for you. However...");
		CallEventDelayed(0.0f, "3");
	}

	// say_rumour
	void OnSayRumour(string speaker = "")
	{
		SayText("The [mayor] is looking for some help. Why not pay him a visit?");
	}

	// say_mayor
	void OnSayMayor()
	{
		SayText("The mayor can be found inside his office in the town hall.");
	}

	// attack_1
	void OnAttack12()
	{
		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, ATTACK_DAMAGE, ATTACK_HITCHANCE, "slash");
	}

	// civilian_attacked
	// PARAM1 Attacker ID PARAM2 isplayer - called from NPC's with base_civlian when attacked / killed
	void OnCivilianAttacked(CBaseEntity@ attacker = null)
	{
		if (RaceOf(attacker) == "hguard") // don't attack friends who accidentally cause 'collateral damage'
			return;
		if (!(RangeTo(attacker) <= BG_MAX_HEAR_CIV)) // resond only to civilians within a certain range
			return;

		if (NPCATK_TARGET != "unset") // do not break off current attack to save civi
			return;

		NO_STUCK_CHECKS = "0";
		OnNpcatkSettarget(EntityId(attacker));

		if (!CanSee(NPCATK_TARGET))
			return;
		SetSayTextRange(1024);
		int randHalt = RandomInt(1, 4);
		if (randHalt == 1)
			SayText("Hey you! Leave him alone!");
		if (randHalt == 2)
			SayText("You there, leave him be I said!");
		if (randHalt == 3)
			SayText("Stop that!");
		if (randHalt == 4)
			SayText("Halt! We'll have no trouble making around here!");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("dwarf/male1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		GatecityGuard_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseChat_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "civilian_attacked") { OnCivilianAttacked(EntityParam(params, 0)); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_mayor") { OnSayMayor(); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "say_rumour") { OnSayRumour(Param(params, 0)); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
