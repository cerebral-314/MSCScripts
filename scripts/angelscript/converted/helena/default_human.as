#pragma context server

// Converted from helena/default_human.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_civilian.as"
#include "converted/helena/helena_npc.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_xmass.as"

[script "helena/default_human"]
class HelenaDefaultHuman : BaseNpcScript, BaseCivilian, HelenaNpc, BaseXmass
{
	// Constants
	string MALE_MODEL = "npc/human1.mdl";
	string FEMALE_MODEL = "npc/human2.mdl";
	string MY_RAID_POS = "$relpos(0,0,0)";
	bool DEFAULT_HUMAN = true;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle1";
	string MY_SEX = "MY_SEX";
	bool DID_FEM_VOICE = false;

	// Variables declared by included files, with the value they start with in this script
	HelenaDefaultHuman()
	{
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// unnamed block (first think)
	void HelenaDefaultHuman_FirstThink()
	{
		ANIM_IDLE = "idle1";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_DEATH = "diesimple";
	}

	// unnamed block (timer)
	void HelenaDefaultHuman_Timer()
	{
		CallEventDelayed(RandomInt(25, 35), "HelenaDefaultHuman_Timer");

		if (RAID_ON)
			return;

		if (!Truthy(LegacyFunction("cansee", "ally", 180)))
			return;

		SetMoveDest(ENT_LASTSEEN, 128);
		SetVolume(2);
		if (MY_SEX == "male")
			Say("chitchat[.5]", "[.2]", "[.55]", "[.55]", "[.23]", "[.22]");
		if (MY_SEX == "female")
		{
			// this is kidna annoying - so only once
			if (!DID_FEM_VOICE && IsPlayer(ENT_LASTSEEN))
			{
				PlaySound(0, 8, "voices/human/female_vendor2.wav");
				DID_FEM_VOICE = true;
				Say("[.5]", "[.2]", "[.55]", "[.55]", "[.23]", "[.22]", "[.5]", "[.2]", "[.55]", "[.55]", "[.23]", "[.22]");
			}
		}

		if (HELENA_SAVED && RandomInt(1, 2) == 1)
		{
			int rndSay = RandomInt(1, 2);
			if (rndSay == 1)
				SayText("Thank you for saving our little village.");
			if (rndSay == 2)
				SayText("Thanks to heros like you, we may yet turn this into a safe place to live.");
		}
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetHealth(25);
		// ov		120
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetName("Commoner");
		SetRoam(true);
		SetBlood("red");
		SetSkillLevel(-10);

		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);

		// dbg spawning
		int genderBender = RandomInt(1, 2);
		if (genderBender == 1)
		{
			// dbg spawned a male
			MY_SEX = "male";
			SetModel(MALE_MODEL);
		}
		if (genderBender == 2)
		{
			// dbg ZOMG - THERE'S A CHICK IN TOWN!
			SetModel(FEMALE_MODEL);
			MY_SEX = "female";
		}

		SetModelBody(0, RandomInt(0, 2));
		SetModelBody(1, RandomInt(0, 5));
		SetMoveAnim("walk");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseCivilian_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_civilian
		HelenaNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // helena/helena_npc
		HelenaNpc_OnGameStruck_2(damage, extraValue2, extraValue3, extraValue4); // helena/helena_npc
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseCivilian_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_civilian
		HelenaNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // helena/helena_npc
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
	}

	void OnCallForHelp(CBaseEntity@ attacker = null) { HelenaNpc_OnCallForHelp(attacker); } // call_for_help

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseXmass_OnGameSpawn(playerRace, playerGender); // monsters/base_xmass
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		Precache("npc/human2.mdl");
		Precache("npc/chitchat.wav");
		CallEventDelayed(Float(Eval("$rand(25,35)")), "HelenaDefaultHuman_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		HelenaDefaultHuman_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "HelenaDefaultHuman_Timer") { HelenaDefaultHuman_Timer(); return true; }
		return BaseCivilian_DispatchEvent(name, params)
			|| HelenaNpc_DispatchEvent(name, params)
			|| BaseXmass_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
