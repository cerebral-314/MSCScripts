#pragma context server

// Converted from monsters/skeleton_stone1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_base.as"

[script "monsters/skeleton_stone1"]
class SkeletonStone1 : SkeletonBaseScript
{
	// Constants
	float ATTACK_DAMAGE_LOW = 8.0f;
	float ATTACK_DAMAGE_HIGH = 13.0f;
	string SKEL_RESPAWN_CHANCE = "0%";
	int SKEL_RESPAWN_LIVES = 0;
	bool STONE_SKELETON = true;

	// Variables (an unset .script variable reads as its own name)
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	bool WAS_SLEEPING = false;

	// Variables declared by included files, with the value they start with in this script
	SkeletonStone1()
	{
		ANIM_RUN = "run";
		SKEL_HP = 500;
		ATTACK_HITCHANCE = "85%";
		SOUND_STRUCK1 = "weapons/axemetal1.wav";
		SOUND_STRUCK2 = "weapons/axemetal2.wav";
		SOUND_STRUCK3 = "debris/concrete1.wav";
	}

	// unnamed block (first think)
	void SkeletonStone1_FirstThink()
	{
		ANIM_RUN = "run";
		NPC_GIVE_EXP = 100.0f;

		DROP_GOLD = 1;
		DROP_GOLD_MIN = 25;
		DROP_GOLD_MAX = 35;
	}

	// skeleton_spawn
	void OnSkeletonSpawn()
	{
		SetModel("monsters/skeleton_boss1.mdl");
		SetModelBody(0, 7); // 0=standard 1=ash 2=green 3=bloody 4=decayed 5=ice 6=gold 7=stone 8=crystal 9=weirdgel
		SetModelBody(1, 4); // 0=Unarmed 1=darkmace 2=sword 3=hammahs 4=bigsword+shield 5=iceclubs 6=fireclubs 7=highsword 8=wand
		SetWidth(32);
		SetHeight(80);
		SetStat("parry", 110);

		if (!SLEEPER)
			OnAnimateStone();
		if (SLEEPER)
		{
			SetInvincible(true);
			WAS_SLEEPING = true;
			OnNpcatkSuspendAi();
			SetIdleAnim(ANIM_IDLE);
			SetMoveAnim(ANIM_IDLE);
			SetAnimFrameRate(0);
		}

		if (ToLowerCase(MapName()) == "thanatos")
			SET_GREEK = true;
		if (SET_GREEK)
			SetModelBody(0, 10);
	}

	// animate_stone
	void OnAnimateStone()
	{
		SetName("Petrified Paladin");
		SetRoam(true);

		SetBlood("none");

		SetDamageTaken("all", 0.6f);

		SetHearingSensitivity(3);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skeleton_boss1.mdl");
		Precache("monsters/skeleton.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SkeletonStone1_FirstThink();
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
		if (name == "animate_stone") { OnAnimateStone(); return true; }
		if (name == "skeleton_spawn") { OnSkeletonSpawn(); return true; }
		return SkeletonBaseScript::DispatchEvent(name, params);
	}
}
