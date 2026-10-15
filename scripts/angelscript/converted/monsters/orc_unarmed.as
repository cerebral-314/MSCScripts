#pragma context server

// Converted from monsters/orc_unarmed.script by msc_transpiler.
// Thothie - More appropriate naming for a MS 1.35 compatibility beast
// - note I *copied* instead of *renaming*
// - Please do this as a policy, so people don't have to update all their maps with every new SC.DLL
// - Hopefully include works - seems not to for some monsters
// Thothie - backwards compatibility for MS 1.35
// - apparently supposed to be unarmed orc citizen... Er, orc girl, maybe? ;)
// - armed fists only, runs, no gold
// - Buggar - thing wont run :/

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_melee.as"
#include "converted/monsters/orc_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class OrcUnarmed
{
	// Constants
	int FLEE_HEALTH = 19;
	string FLEE_CHANCE = "99%";
	string ATTACK_ACCURACY = "50%";
	float ATTACK_DMG_LOW = 1.0f;
	float ATTACK_DMG_HIGH = 2.0f;

	// Variables (an unset .script variable reads as its own name)
	int DROP_GOLD = 0;
	float NPC_GIVE_EXP = 0.0f;
	string CAN_FLEE = "CAN_FLEE";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string LIGHT_COLOR = "LIGHT_COLOR";

	// unnamed block (first think)
	void OrcUnarmed_FirstThink()
	{
		DROP_GOLD = 0; // Gold Drops
		NPC_GIVE_EXP = 1.0f;
		CAN_FLEE = "1"; // base_npc_attack - Whether I run away at low health (changes for boar)

		ANIM_ATTACK = "swordswing1_L"; // Attack animation (wanted to use "kick" but couldnt hit)
	}

	// orc_spawn
	void OrcUnarmed_OnOrcSpawn()
	{
		SetHealth(20);
		// ov 180
		SetName("Unarmed Orc");
		SetHearingSensitivity(0);
		SetStat("parry", 1);
		SetDamageTaken("all", 1);
		SetInvincible(false);

		SetModelBody(0, 0); // Body 0=naked 2=leather 3=plate 4=green-hide
		SetModelBody(1, 4); // Head 0=cap_shorthorn 1=cap_nohorn 2=buffo_skin 3=cheif_ramhorns 4=green_hood
		SetModelBody(2, 0); // Weapon 0=fist 1=axe 2=bow_weak 3=bow_strng 4=sword 5=bloodyaxe 6=sword&sheild
	}

	// superorc
	void OrcUnarmed_OnSuperorc()
	{
		// This is for testing invulnerability script
		SetInvincible(true);
		SetName("INVULNERABLE Unarmed Orc");
		LIGHT_COLOR = Text(Vector3(255, 255, 255));
		Effect("glow", ENT_ME, LIGHT_COLOR, 255, 255, 5);
		SetSayTextRange(1024);
		SayText("W00t! I r invlnerable!");
	}

	// godoff
	void OrcUnarmed_OnGodoff()
	{
		// This is for testing invulnerability script
		SetInvincible(false);
		SetName("Unarmed Orc");
		LIGHT_COLOR = Text(Vector3(1, 1, 1));
		Effect("glow", ENT_ME, LIGHT_COLOR, 255, 5, 5);
		SetSayTextRange(1024);
		SayText("OMG WTF h4x!");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseMelee_OnOrcSpawn(); // monsters/orc_base_melee
		OrcUnarmed_OnOrcSpawn();
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		OrcBaseMelee_OnNpcatkTargetvalidate(target); // monsters/orc_base_melee
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		OrcBase_OnNpcatkTargetvalidate(target); // monsters/orc_base
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		OrcBaseMelee_OnMyTargetDied(offender); // monsters/orc_base_melee
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
	}

	void OnBaseorcYell() { OrcBase_OnBaseorcYell(); } // baseorc_yell
	void OnSuperorc() { OrcUnarmed_OnSuperorc(); } // superorc
	void OnGodoff() { OrcUnarmed_OnGodoff(); } // godoff

	// This file's events and timers by their .script names
	bool OrcUnarmed_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "godoff") { OnGodoff(); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "superorc") { OnSuperorc(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/orc_unarmed"]
shared class OrcUnarmedScript : OrcBaseScript, OrcUnarmed, OrcBaseMelee
{
	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OrcUnarmed_FirstThink();
		OrcBaseMelee_FirstThink();
		OrcBase_FirstThink();
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
		return OrcUnarmed_DispatchEvent(name, params)
			|| OrcBaseMelee_DispatchEvent(name, params)
			|| OrcBaseScript::DispatchEvent(name, params);
	}
}
