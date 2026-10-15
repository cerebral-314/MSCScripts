#pragma context server

// Converted from monsters/fish_base.script by msc_transpiler.
// Base fish

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"
#include "converted/monsters/base_propelled.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class FishBase
{
	// Constants
	string ANIM_TURN_RIGHT = "rturn";
	string ANIM_TURN_LEFT = "lturn";
	int TURN_ANIM_THRESHOLD = 90;
	string RETALIATE_CHANGETARGET_CHANCE = "75%";

	// Variables (an unset .script variable reads as its own name)
	string NPC_MUST_SEE_TARGET = "NPC_MUST_SEE_TARGET";
	string CAN_RETALIATE = "CAN_RETALIATE";
	string FISH_LASTYAW = "FISH_LASTYAW";
	Vector3 FISH_WANDER_DEST = Vector3();

	// unnamed block (first think)
	void FishBase_FirstThink()
	{
		NPC_MUST_SEE_TARGET = "0";

		CAN_RETALIATE = "1";
	}

	// npc_spawn
	void FishBase_OnNpcSpawn(string npc = "")
	{
		SetRace("wildanimal");
		SetRoam(true);
		SetHearingSensitivity(3);
		LegacyCommand("float", 1);

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
	}

	// unnamed block (timer)
	void FishBase_Timer()
	{
		CallEventDelayed(RandomInt(10, 25), "FishBase_Timer");

		if (IS_HUNTING)
			return;
		if (IS_FLEEING)
			return;

		PlayRandomSound(Int(Eval("game.sound.body")), Eval("game.sound.maxvol"), SOUND_IDLE1, SOUND_IDLE2);
	}

	// npc_struck
	// Hit by someone
	void FishBase_OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(Int(Eval("game.sound.body")), Eval("game.sound.maxvol"), SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK4, SOUND_STRUCK5);
	}

	// npc_targetsighted
	void FishBase_OnNpcTargetsighted(string target = "")
	{
		LegacyCommand("roamdelay", 2);
		if (RangeTo(HUNT_LASTTARGET) < Float(MOVE_RANGE))
			SetMoveDest("none");
	}

	// game_stopmoving
	void FishBase_OnGameStopmoving()
	{
		FISH_LASTYAW = Eval("game.monster.angles.yaw");
	}

	// game_movingto_dest
	// PARAM1: Absolute angles towards destination
	// Use the dern turn animations
	void FishBase_OnGameMovingtoDest(Vector3 angles = Vector3())
	{
		if (IS_HUNTING)
			SetAngle("face.x", angles.x);

		if (IS_HUNTING)
			return;

		int currentYaw = Int(Eval("game.monster.angles.yaw"));
		float diff = AngleDifference(angles.y, currentYaw);
		bool negative = false;
		if (diff < 0.0f)
		{
			negative = true;
			diff *= -1.0f;
		}

		if (!(diff > TURN_ANIM_THRESHOLD))
			return;

		string anim = ANIM_TURN_LEFT;
		if (negative)
			anim = ANIM_TURN_RIGHT;

		PlayAnim("once", anim);
	}

	// npc_wander
	void FishBase_OnNpcWander()
	{
		LegacyCommand("setturnrate", 0.175f);
		SetAngle("face.x", 0);
		LegacyCommand("roamdelay", 0);
		FISH_WANDER_DEST = Vec(Eval("game.monster.movedest.origin"));
		FISH_WANDER_DEST += Vector3(0, 0, Random(32, 256));
		SetMoveDest(FISH_WANDER_DEST, Eval("game.monster.moveprox"));
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		BasePropelled_OnNpcPostSpawn(); // monsters/base_propelled
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		FishBase_OnNpcSpawn(npc);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		FishBase_OnNpcTargetsighted(target);
	}

	// game_movingto_dest
	void OnGameMovingtoDest(Vector3 angles = Vector3())
	{
		BasePropelled_OnGameMovingtoDest(angles); // monsters/base_propelled
		FishBase_OnGameMovingtoDest(angles);
	}

	// game_stopmoving
	void OnGameStopmoving()
	{
		BasePropelled_OnGameStopmoving(); // monsters/base_propelled
		FishBase_OnGameStopmoving();
	}

	void OnNpcStruck(float damage = 0.0f) { FishBase_OnNpcStruck(damage); } // npc_struck
	void OnNpcWander() { FishBase_OnNpcWander(); } // npc_wander

	// This file's events and timers by their .script names
	bool FishBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_movingto_dest") { OnGameMovingtoDest(Vec(Param(params, 0))); return true; }
		if (name == "game_stopmoving") { OnGameStopmoving(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npc_wander") { OnNpcWander(); return true; }
		if (name == "FishBase_Timer") { FishBase_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/fish_base"]
shared class FishBaseScript : BaseMonsterScript, FishBase, BasePropelled
{
	// Variables every script that includes this file declares
	string ANIM_ATK1 = "ANIM_ATK1";
	string ANIM_ATK2 = "ANIM_ATK2";
	string ANIM_ATK_BIG = "ANIM_ATK_BIG";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ATTACK_HITCHANCE = "ATTACK_HITCHANCE";
	string CHANCE_SWALLOW = "CHANCE_SWALLOW";
	bool CYCLES_ON = false;
	float DMG_BITE = 0.0f;
	int DMG_BITE2 = 0;
	int DMG_BITE3 = 0;
	float FLIGHT_STUCK = 0.0f;
	float FREQ_SWALLOW = 0.0f;
	Vector3 LAST_POS = Vector3();
	float LAST_PROG = 0.0f;
	int PUSH_RANGE = 0;
	string SOUND_ATTACK1 = "SOUND_ATTACK1";
	string SOUND_ATTACK2 = "SOUND_ATTACK2";
	string SOUND_IDLE1 = "SOUND_IDLE1";
	string SOUND_IDLE2 = "SOUND_IDLE2";
	string SOUND_STRUCK1 = "SOUND_STRUCK1";
	string SOUND_STRUCK2 = "SOUND_STRUCK2";
	string SOUND_STRUCK3 = "SOUND_STRUCK3";
	string SOUND_STRUCK4 = "SOUND_STRUCK4";
	string SOUND_STRUCK5 = "SOUND_STRUCK5";

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(Float(Eval("$rand(10,25)")), "FishBase_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		FishBase_FirstThink();
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
		return FishBase_DispatchEvent(name, params)
			|| BasePropelled_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
