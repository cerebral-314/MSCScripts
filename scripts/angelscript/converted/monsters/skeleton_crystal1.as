#pragma context server

// Converted from monsters/skeleton_crystal1.script by msc_transpiler.
// Crystal Skeleton escort for Crow
// Thothie - Same beast, but learns how to stay dead faster
// Skeleton Warrior

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_base.as"
#include "converted/monsters/base_propelled.as"

[script "monsters/skeleton_crystal1"]
class SkeletonCrystal1 : SkeletonBaseScript, BasePropelled
{
	// Constants
	float ATTACK_DAMAGE_LOW = 10.0f;
	float ATTACK_DAMAGE_HIGH = 20.0f;

	// Variables (an unset .script variable reads as its own name)
	float NPC_HACKED_MOVE_SPEED = 150.0f;
	bool AM_FADING = false;
	Vector3 SINK_ORIGIN = Vector3();
	float FADE_COUNT = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	SkeletonCrystal1()
	{
		ANIM_RUN = "idle1";
		ANIM_WALK = "idle1";
		SKEL_HP = 1;
		ATTACK_HITCHANCE = "80%";
	}

	// unnamed block (first think)
	void SkeletonCrystal1_FirstThink()
	{
		ANIM_RUN = "idle1";
		ANIM_WALK = "idle1";
		NPC_HACKED_MOVE_SPEED = 150.0f;
		NPC_GIVE_EXP = 0.0f;
	}

	// unnamed block (timer)
	void SkeletonCrystal1_Timer()
	{
		CallEventDelayed(1.7f, "SkeletonCrystal1_Timer");

		if (AM_FADING)
			return;
		PlaySound(0, 5, "magic/pulsemachine_noloop.wav");
	}

	// skeleton_spawn
	void OnSkeletonSpawn()
	{
		SetName("Crystalline Skeleton");
		SetRoam(true);
		SetHearingSensitivity(8);

		SetModel("monsters/skeleton_boss1.mdl");

		// setsolid none //causes them to get stuck inside reaver
		// fly 1 //causes them to "headbang" ;)
		SetInvincible(true);

		SetModelBody(0, 8);
	}

	// ext_crystal_remove
	void OnExtCrystalRemove()
	{
		AM_FADING = true;

		// setmovedest none
		NPC_HACKED_MOVE_SPEED = 0.0f;

		SINK_ORIGIN = MyOrigin();

		SetSolid("none");

		OnNpcatkSuspendAi();
		OnGameStopmoving();
		SetMoveAnim(ANIM_IDLE);
		PlayAnim("critical", ANIM_IDLE);
		FADE_COUNT = 255.0f;
		OnFadeOut();
	}

	// fade_out
	void OnFadeOut()
	{
		FADE_COUNT -= 5.0f;

		SINK_ORIGIN += RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, -1.5f));

		SetOrigin(ENT_ME, SINK_ORIGIN);

		if (FADE_COUNT <= 0.0f)
			OnTeleOut();

		if (!(FADE_COUNT > 0.0f))
			return;
		CallEventDelayed(0.1f, "fade_out");
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", FADE_COUNT);
	}

	// tele_out
	void OnTeleOut()
	{
		SetOrigin(ENT_ME, Vector3(20000, 10000, 20000));
		SetInvincible(false);
		CallEventDelayed(0.1f, "npc_suicide");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		SkeletonBase_OnNpcPostSpawn(); // monsters/skeleton_base
		BasePropelled_OnNpcPostSpawn(); // monsters/base_propelled
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skeleton.mdl");
		Precache("monsters/skeleton_boss1.mdl");
		CallEventDelayed(1.7f, "SkeletonCrystal1_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SkeletonCrystal1_FirstThink();
		SkeletonBase_FirstThink();
		SkeletonBase_FirstThink2();
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
		if (name == "ext_crystal_remove") { OnExtCrystalRemove(); return true; }
		if (name == "fade_out") { OnFadeOut(); return true; }
		if (name == "skeleton_spawn") { OnSkeletonSpawn(); return true; }
		if (name == "tele_out") { OnTeleOut(); return true; }
		if (name == "SkeletonCrystal1_Timer") { SkeletonCrystal1_Timer(); return true; }
		return BasePropelled_DispatchEvent(name, params)
			|| SkeletonBaseScript::DispatchEvent(name, params);
	}
}
