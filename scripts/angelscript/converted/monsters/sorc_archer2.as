#pragma context server

// Converted from monsters/sorc_archer2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_sniper.as"

[script "monsters/sorc_archer2"]
class SorcArcher2 : OrcSniperScript
{
	// Constants
	bool AM_SORC = true;
	int ARROW_DAMAGE_LOW = 75;
	int ARROW_DAMAGE_HIGH = 150;

	// Variables (an unset .script variable reads as its own name)
	bool DOING_KICK = false;
	bool KICK_TYPE = false;

	// Variables declared by included files, with the value they start with in this script
	SorcArcher2()
	{
		ARROW_TYPE = "proj_arrow_lightning";
		FIN_EXP = 200;
		DROP_ITEM_BASE1 = "bows_swiftbow";
		CONTAINER_BASE = "chests/quiver_of_lightning";
	}

	// unnamed block (first think)
	void SorcArcher2_FirstThink()
	{
		DROP_GOLD_AMT = RandomInt(20, 60);
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseRanged_OnOrcSpawn(); // monsters/orc_base_ranged
		OrcSniper_OnOrcSpawn(); // monsters/orc_sniper

		SetHealth(500);
		// ov 180
		SetName("Shadahar Archer");
		SetHearingSensitivity(10);
		SetStat("parry", 60);
		SetDamageTaken("all", 0.7f);
		SetRace("orc");

		SetModel("monsters/sorc.mdl");

		DOING_KICK = false;
		KICK_TYPE = true;

		SetModelBody(0, 3); // body: 0=bare 1=bloody_shirt 2=gold_armor 3=archer
		SetModelBody(1, 2); // head: 0=hat_horns 1=hat_spiked 2=lizardskin_horned 3=gold_Chieftain 4=lizard_cap
		SetModelBody(2, 2); // weapon: 0=unarmed 1=axe 2=bow_noarrow 3=bow_witharrow 4=sword 5=great_axe 6=sword_sheild 8=yellow_axe 9=blooddrinker
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/orc.mdl");
		Precache("monsters/sorc.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SorcArcher2_FirstThink();
		OrcSniper_FirstThink();
		OrcBaseRanged_FirstThink();
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
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		return OrcSniperScript::DispatchEvent(name, params);
	}
}
