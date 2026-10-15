#pragma context server

// Converted from mscave/Shadahar.script by msc_transpiler.
// Thothie - Reducing gold slightly
// - Naming convention note: please use all lower case names in future (case screws with Hammer sometimes)
// Evil Skeleton

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Shadahar
{
	// Constants
	int SKEL_HP = 1000;
	string ATTACK_HITCHANCE = "85%";
	float ATTACK_DAMAGE_LOW = 15.5f;
	float ATTACK_DAMAGE_HIGH = 25.5f;
	string ANIM_CIRCLE = "throw_scientist";
	string SKEL_RESPAWN_CHANCE = "0%";
	int SKEL_RESPAWN_LIVES = 0;
	string ANIM_BLAST = "rlflinch";
	string SOUND_BOLT = "magic/ice_strike.wav";
	float CIRCLE_FREQ = 30.0f;
	string SOUND_LAUGH = "monsters/skeleton/cal_laugh.wav";
	string SOUND_WARCRY = "monsters/skeleton/calrain3.wav";

	// Variables (an unset .script variable reads as its own name)
	float NPC_GIVE_EXP = 0.0f;
	bool CIRCLE_ON = false;
	float AS_ATTACKING = 0.0f;
	bool PURE_FLEE = false;
	bool DID_WARCRY = false;

	// unnamed block (first think)
	void Shadahar_FirstThink()
	{
		NPC_GIVE_EXP = 150.0f;
	}

	// skeleton_spawn
	void Shadahar_OnSkeletonSpawn()
	{
		SetName("Shadahar");
		if (MapName() != "mscave")
		{
			SetGold(RandomInt(25, 75));
			SetName("Gold Forged Skeleton");
			NPC_GIVE_EXP = 150.0f;
		}
		if (MapName() == "mscave")
		{
			NPC_GIVE_EXP = 4000.0f; // v. hard to get him to spawn
			SetGold(RandomInt(80, 150));
			if (RandomInt(1, 100) == 1)
			{
				int picThree = RandomInt(1, 3);
				if (picThree == 1)
					GiveItem("scroll2_poison_cloud");
				if (picThree == 2)
					GiveItem("mana_forget");
				if (picThree == 3)
					GiveItem("armor_helm_gaz1");
			}
		}

		SetRace("undead");
		SetRoam(true);
		SetDamageTaken("all", 0.7f);
		SetModel("monsters/skeleton.mdl");
		SetHearingSensitivity(8);
		SetModelBody(0, 8); // wassup-G - this thing is loaded with cash
		SetModelBody(1, 0);

		// ov 359
		Vector3 mySky = MyOrigin() + Vector3(0, 0, 4096);
		Vector3 myCenter = OriginOf(ENT_ME) + Vector3(0, 0, -48);
		ClientEvent("new", "all_in_sight", "effects/sfx_lightning", myCenter, mySky, 1, 1);

		CallEventDelayed(10.0f, "circle_check");
	}

	// circle_check
	void Shadahar_OnCircleCheck()
	{
		if (!CanSee("enemy"))
			CallEventDelayed(5.0f, "circle_check");

		if (!CanSee("enemy"))
			return;

		CallEventDelayed(CIRCLE_FREQ, "circle_check");
		if (I_R_FROZEN)
			return;
		if (!CYCLED_UP)
			return;
		OnCirclePrep();
	}

	// circle_prep
	void Shadahar_OnCirclePrep()
	{
		if (CIRCLE_ON)
			return;
		CallEventDelayed(15.0f, "circle_reset");
		CIRCLE_ON = true;
		AS_ATTACKING = GameTime() + 10.0f;
		PlayAnim("critical", ANIM_CIRCLE);
		PlaySound(0, 10, SOUND_WARCRY);
		OnCanReachNme(); // delays anti-stuck checks
		CallEventDelayed(2.0f, "circle_spawn");
	}

	// circle_spawn
	void Shadahar_OnCircleSpawn()
	{
		CreateNpc("monsters/summon/circle_of_death", RelativePosition(Vector3(0, 0, 0)), self, 100, 200, 10.0f); // PARAM1=Owner PARAM2=radius PARAM3=Damage PARAM4=Duration [PARAM5=skill]
		CallEventDelayed(1.0f, "circle_bait");
	}

	// circle_bait
	void Shadahar_OnCircleBait()
	{
		PURE_FLEE = true;
		OnNpcatkFlee(EntityId(EntityOf(ENT_LASTSEEN)), "500", "5.0");
	}

	// circle_reset
	void Shadahar_OnCircleReset()
	{
		CIRCLE_ON = false;
	}

	// circle_kill
	// external call from circle
	void Shadahar_OnCircleKill()
	{
		PlaySound(0, 10, SOUND_LAUGH);
	}

	// skel_death
	void Shadahar_OnSkelDeath()
	{
		UseTrigger("beam11", "beam13", "beam21", "beam23");
	}

	// npcatk_targetvalidate
	void Shadahar_OnNpcatkTargetvalidate(string target = "")
	{
		if (!DID_WARCRY)
		{
			DID_WARCRY = true;
			PlaySound(0, 10, SOUND_LAUGH); // switched to laugh to avoid confuszhionzinos with spell
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttack_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack
		Shadahar_OnNpcatkTargetvalidate(target);
	}

	void OnSkeletonSpawn() { Shadahar_OnSkeletonSpawn(); } // skeleton_spawn
	void OnCircleCheck() { Shadahar_OnCircleCheck(); } // circle_check
	void OnCirclePrep() { Shadahar_OnCirclePrep(); } // circle_prep
	void OnCircleSpawn() { Shadahar_OnCircleSpawn(); } // circle_spawn
	void OnCircleBait() { Shadahar_OnCircleBait(); } // circle_bait
	void OnCircleReset() { Shadahar_OnCircleReset(); } // circle_reset
	void OnCircleKill() { Shadahar_OnCircleKill(); } // circle_kill
	void OnSkelDeath() { Shadahar_OnSkelDeath(); } // skel_death
	void OnCircleFreq() {} // CIRCLE_FREQ
	void OnCanReachNme() {} // can_reach_nme
	void OnDoLightning(string endOrigin = "") {} // do_lightning

	// This file's events and timers by their .script names
	bool Shadahar_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "circle_bait") { OnCircleBait(); return true; }
		if (name == "circle_check") { OnCircleCheck(); return true; }
		if (name == "circle_kill") { OnCircleKill(); return true; }
		if (name == "circle_prep") { OnCirclePrep(); return true; }
		if (name == "circle_reset") { OnCircleReset(); return true; }
		if (name == "circle_spawn") { OnCircleSpawn(); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "skel_death") { OnSkelDeath(); return true; }
		if (name == "skeleton_spawn") { OnSkeletonSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "mscave/Shadahar"]
shared class ShadaharScript : SkeletonBaseScript, Shadahar
{
	// Variables declared by included files, with the value they start with in this script
	ShadaharScript()
	{
		SKEL_HP = 1000;
		ATTACK_HITCHANCE = "85%";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/magic/seals.mdl");
		Precache("skull.spr");
		Precache("monsters/skeleton.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Shadahar_FirstThink();
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
		return Shadahar_DispatchEvent(name, params)
			|| SkeletonBaseScript::DispatchEvent(name, params);
	}
}
