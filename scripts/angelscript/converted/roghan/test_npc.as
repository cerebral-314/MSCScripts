#pragma context server

// Converted from roghan/test_npc.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "roghan/test_npc"]
class TestNpc : BaseMonsterNewScript
{
	// Constants
	string NPC_MODEL = "npc/balancepriest1.mdl";

	// Variables (an unset .script variable reads as its own name)
	float FIGHT_STARTED = 0.0f;
	bool KEEP_PLAYERS_WARM_ACTIVE = false;
	Vector3 MY_LOC = Vector3();
	string PLAYER_LIST = "PLAYER_LIST";

	// Variables declared by included files, with the value they start with in this script
	TestNpc()
	{
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle1";
	}

	// unnamed block (first think)
	void TestNpc_FirstThink()
	{
		ANIM_RUN = "run"; // walk anim
		ANIM_WALK = "walk"; // run anim
		ANIM_IDLE = "idle1"; // idle anim
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Ancient Jailer");

		SetRace("beloved");

		SetHealth(1000);

		SetModel(NPC_MODEL);
		SetWidth(32);
		SetHeight(72);

		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE);

		SetInvincible(true);

		OnNpcatkSuspendAi();

		FIGHT_STARTED = 0.0f;
		KEEP_PLAYERS_WARM_ACTIVE = true;

		CatchSpeech("begin_fight", "start");
	}

	// begin_fight
	void OnBeginFight()
	{
		if (FIGHT_STARTED == 0.0f)
		{
			MY_LOC = OriginOf(ENT_ME);
			CallExternal(ENT_CREATIONOWNER, "begin_float");
			FIGHT_STARTED += 1.0f;
			OnKeepPlayersWarmLoop();
			SayText("Heroes! Stay near me and I will protect you from his ice!");
		}
	}

	// res_circle
	void OnResCircle()
	{
		ClientEvent("new", "all", "effects/sfx_seal", MY_LOC, 172, 26, 3);
		Vector3 fxOrigin = MY_LOC;
		fxOrigin.z = GroundHeight(MY_LOC);
	}

	// keep_players_warm_loop
	// Below is the frost resistance loop, as of now it does not work at all
	void OnKeepPlayersWarmLoop()
	{
		if (!KEEP_PLAYERS_WARM_ACTIVE)
			return;
		CallEventDelayed(3.0f, "keep_players_warm_loop");
		PLAYER_LIST = "";
		PLAYER_LIST = GetActivePlayers();
		int count = GetTokenCount(PLAYER_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCheckCanWarmPlayers();
		}
		OnResCircle();
	}

	// check_can_warm_players
	void OnCheckCanWarmPlayers()
	{
		string curTarg = GetToken(PLAYER_LIST, loopIteration);
		if (RangeTo(curTarg) < 256.0f)
		{
			CallExternal(curTarg, "ext_register_element", "warm", "cold", 99);
			PlayerMessageGreen(curTarg, "You are now protected from ICE!");
		}
		else
		{
			CallExternal(curTarg, "ext_register_element", "warm", "remove");
			PlayerMessageGreen(curTarg, "You are no longer protected from ICE!");
		}
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/balancepriest1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TestNpc_FirstThink();
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
		if (name == "begin_fight") { OnBeginFight(); return true; }
		if (name == "check_can_warm_players") { OnCheckCanWarmPlayers(); return true; }
		if (name == "keep_players_warm_loop") { OnKeepPlayersWarmLoop(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "res_circle") { OnResCircle(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
