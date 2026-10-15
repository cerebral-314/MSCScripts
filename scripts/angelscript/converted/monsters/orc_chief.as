#pragma context server

// Converted from monsters/orc_chief.script by msc_transpiler.
// Thothie - Provided for backwards compatability with MS 1.35
// - Guess who's back :D
// - He can be given Infernal Fire Damage or Invulnerability (toggle) via ms_npcscript send:
// - godon_warboss - invincible
// - offgod_warboss - vulnerable
// - infernal_warboss - fire damage +30-60
// - normal_warboss - removes fire damage

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base.as"
#include "converted/monsters/orc_base_melee.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class OrcChief
{
	// Constants
	bool OVERRIDE_NODROP = true;
	float NPC_BOSS_REGEN_RATE = 0.1f;
	float NPC_BOSS_RESTORATION = 0.5f;
	string ATTACK_ACCURACY = "80%";
	float ATTACK_DMG_LOW = 75.0f;
	float ATTACK_DMG_HIGH = 650.0f;
	int ATTAKC_MOVERANGE = 64;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	int INFERNAL = 0;
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	bool WARBOSS_VALID_MAP = false;
	string DROP_ITEM1 = "DROP_ITEM1";
	string DROP_ITEM1_CHANCE = "DROP_ITEM1_CHANCE";
	string DROP_ITEM2 = "DROP_ITEM2";
	string DROP_ITEM2_CHANCE = "DROP_ITEM2_CHANCE";
	bool IS_OLD_HELENA = false;
	bool NPC_IS_BOSS = false;

	// unnamed block (first think)
	void OrcChief_FirstThink()
	{
		ANIM_ATTACK = "battleaxe_swing1_L"; // Attack animation
		FLINCH_CHANCE = "35%";

		INFERNAL = 0;

		// Manually porting orc_melee include for safty
		MOVE_RANGE = "64";
		ATTACK_RANGE = 150.0f;
		ATTACK_HITRANGE = 225.0f;
	}

	// orc_spawn
	void OrcChief_OnOrcSpawn()
	{
		SetHealth(3000);
		SetWidth(38);
		SetHeight(72);

		NPC_GIVE_EXP = 1250.0f;
		SetName("Orc Warlord");

		string mapName = ToLowerCase(MapName());
		if (ToLowerCase(MapName()) == "ara")
		{
			SetName("Farghead the Warlord");
			NPC_GIVE_EXP = 1500.0f;
			WARBOSS_VALID_MAP = true;
			DROP_ITEM1 = "axes_greataxe";
			DROP_ITEM1_CHANCE = "50";
		}
		else if (mapName == "foutpost")
		{
			SetName("Graznux the Warboss");
			DROP_ITEM2 = "item_warbosshead";
			DROP_ITEM2_CHANCE = "100%";
			WARBOSS_VALID_MAP = true;
			DROP_ITEM1 = "axes_greataxe";
			DROP_ITEM1_CHANCE = "50";
		}
		else if (mapName == "lostcastle_msc")
		{
			SetName("Gul the Warchief");
			WARBOSS_VALID_MAP = true;
			DROP_ITEM1 = "axes_greataxe";
			DROP_ITEM1_CHANCE = "75";
		}
		else if (mapName == "old_helena")
		{
			SetName("Lumdum the Warboss");
			WARBOSS_VALID_MAP = true;
			IS_OLD_HELENA = true;
			NPC_GIVE_EXP = 10000.0f; // to compensate for the XP nerfage
		}

		if (WARBOSS_VALID_MAP)
			NPC_IS_BOSS = true;

		SetHearingSensitivity(8);
		SetStat("parry", 90);
		SetDamageTaken("all", 0.8f);
		SetInvincible(false);
		SetModel("monsters/orc_big.mdl");

		SetModelBody(0, 2); // Body 0=naked 1=leather 2=plate 3=green-hide
		SetModelBody(1, 3); // Head 0=cap_shorthorn 1=cap_nohorn 2=buffo_skin 3=cheif_ramhorns 4=green_hood
		SetModelBody(2, 5); // Weapon 0=fist 1=axe 2=bow_weak 3=bow_strng 4=sword 5=bloodyaxe 6=sword&sheild
	}

	// swing_axe
	void OrcChief_OnSwingAxe()
	{
		if (INFERNAL == 1)
			ApplyEffect(ENT_LASTSTRUCKBYME, "effects/dot_fire", 5, ENT_ME, RandomInt(30, 60));
	}

	// godon_warboss
	// effects
	void OrcChief_OnGodonWarboss()
	{
		PlayAnim("critical", "warcry");
		SetInvincible(true);
		SetSayTextRange(1024);
		SayText("You fools! Now nothing can stop me!");
	}

	// offgod_warboss
	void OrcChief_OnOffgodWarboss()
	{
		SetInvincible(false);
		SetSayTextRange(1024);
		SayText("Noooo! My power!");
	}

	// infernal_warboss
	void OrcChief_OnInfernalWarboss()
	{
		PlayAnim("critical", "warcry");
		SetRace("demon");
		INFERNAL = 1;
		SetSayTextRange(1024);
		SayText("Feel the fire of my rage! Muahahahaaa!");
		// hopefully this supplies burn effect with no damage
		ApplyEffect(ENT_ME, "effects/dot_fire", 60, ENT_ME, 0);
		SetDamageTaken("fire", 0);
		SetDamageTaken("holy", 4);
	}

	// normal_warboss
	void OrcChief_OnNormalWarboss()
	{
		SetRace("orc");
		INFERNAL = 0;
		SetSayTextRange(1024);
		SayText("What? No! The hellfire has abandoned me!");
		SetDamageTaken("fire", 1);
		SetDamageTaken("holy", 0);
	}

	// turn_undead
	void OrcChief_OnTurnUndead(float holyDamage = 0.0f, CBaseEntity@ exorcist = null)
	{
		if (INFERNAL == 0)
			return;

		// Can be damaged by Holy Light when infernal
		// PARAM1 - incoming Holy damage
		// PARAM2 - exorcist
		CBaseEntity@ meMe = self;

		OnNpcatkDodamage(EntityId(meMe), "direct", Text(holyDamage), "100", EntityId(exorcist));

		Effect("glow", ENT_ME, Vector3(255, 255, 0), 512, 1, 1);
	}

	// npc_death
	void OrcChief_OnNpcDeath()
	{
		SetGlobal("WARBOSS_DEAD", 1);
		if (WARBOSS_VALID_MAP && !IS_OLD_HELENA)
		{
			OnBmGoldSpew(25, "2", 64, 8, 24); // PARAM1=gold_per_bag PARAM2=bags_player PARAM3=dist_from_mon PARAM4=min#bags PARAM5 max#bags
		}
		if (!WARBOSS_VALID_MAP)
			OnBmGoldSpew(10, "3", 64, 4, 16);

		if (IS_OLD_HELENA)
		{
			SetGlobal("G_WARBOSS_ORIGIN", OriginOf(ENT_ME));
			CallExternal("all", "old_helena_warboss_died");
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// turn_undead
	void OnTurnUndead(float holyDamage = 0.0f, CBaseEntity@ exorcist = null)
	{
		MonstersExternals_OnTurnUndead(holyDamage, exorcist); // monsters/externals
		OrcChief_OnTurnUndead(holyDamage, exorcist);
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		OrcBase_OnNpcatkTargetvalidate(target); // monsters/orc_base
		OrcBaseMelee_OnNpcatkTargetvalidate(target); // monsters/orc_base_melee
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		OrcBaseMelee_OnMyTargetDied(offender); // monsters/orc_base_melee
	}

	// npc_death
	void OnNpcDeath()
	{
		OrcBase_OnNpcDeath(); // monsters/orc_base
		OrcChief_OnNpcDeath();
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseMelee_OnOrcSpawn(); // monsters/orc_base_melee
		OrcChief_OnOrcSpawn();
	}

	// swing_axe
	void OnSwingAxe()
	{
		OrcBaseMelee_OnSwingAxe(); // monsters/orc_base_melee
		OrcChief_OnSwingAxe();
	}

	void OnGodonWarboss() { OrcChief_OnGodonWarboss(); } // godon_warboss
	void OnOffgodWarboss() { OrcChief_OnOffgodWarboss(); } // offgod_warboss
	void OnInfernalWarboss() { OrcChief_OnInfernalWarboss(); } // infernal_warboss
	void OnNormalWarboss() { OrcChief_OnNormalWarboss(); } // normal_warboss

	// This file's events and timers by their .script names
	bool OrcChief_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "godon_warboss") { OnGodonWarboss(); return true; }
		if (name == "infernal_warboss") { OnInfernalWarboss(); return true; }
		if (name == "normal_warboss") { OnNormalWarboss(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "offgod_warboss") { OnOffgodWarboss(); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		if (name == "turn_undead") { OnTurnUndead(Float(Param(params, 0)), EntityParam(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/orc_chief"]
shared class OrcChiefScript : OrcBaseScript, OrcChief, OrcBaseMelee
{
	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnBaseorcYell() { OrcBase_OnBaseorcYell(); } // baseorc_yell

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/orc.mdl");
		Precache("monsters/orc_big.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OrcChief_FirstThink();
		OrcBase_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		OrcBaseMelee_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return OrcChief_DispatchEvent(name, params)
			|| OrcBaseMelee_DispatchEvent(name, params)
			|| OrcBaseScript::DispatchEvent(name, params);
	}
}
