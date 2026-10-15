#pragma context server

// Converted from heras/GhorAsh.script by msc_transpiler.
// Thothie - removing the rand on this so I can test it (I think the syntax is wrong)
// -Style note: in the future, it seems to me, all script names should be entirely lowercase.
// -Hammer does not take well to case sensitivity, so mappers tend to ignore it
// Evil Skeleton

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_base.as"

[script "heras/GhorAsh"]
class GhorAsh : SkeletonBaseScript
{
	// Constants
	float ATTACK_DAMAGE_LOW = 5.5f;
	float ATTACK_DAMAGE_HIGH = 7.0f;
	string SKEL_RESPAWN_CHANCE = "0%";
	int SKEL_RESPAWN_LIVES = 0;

	// Variables (an unset .script variable reads as its own name)
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;

	// Variables declared by included files, with the value they start with in this script
	GhorAsh()
	{
		ANIM_RUN = "run";
		SKEL_HP = 250;
		ATTACK_HITCHANCE = "85%";
	}

	// unnamed block (first think)
	void GhorAsh_FirstThink()
	{
		ANIM_RUN = "run";
		NPC_GIVE_EXP = 26.0f;

		DROP_GOLD = 1;
		DROP_GOLD_MIN = 25;
		DROP_GOLD_MAX = 55;
	}

	// skeleton_spawn
	void OnSkeletonSpawn()
	{
		SetName("Ghor Ash");
		SetRoam(true);
		SetDamageTaken("all", 0.9f);
		SetModel("monsters/skeleton_boss1.mdl");
		SetModelBody(0, 1); // 0=standard 1=ash 2=green 3=bloody 4=decayed 5=ice 6=gold 7=stone 8=crystal 9=weirdgel
		SetModelBody(1, 0); // 0=Unarmed 1=darkmace 2=sword 3=hammahs 4=bigsword+shield 5=iceclubs 6=fireclubs 7=highsword 8=wand

		SetHearingSensitivity(3);
		if (MapName() == "heras") // he doesn't drop it with the hands flag
			GiveItem("item_runicsymbol");
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
		GhorAsh_FirstThink();
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
		if (name == "skeleton_spawn") { OnSkeletonSpawn(); return true; }
		return SkeletonBaseScript::DispatchEvent(name, params);
	}
}
