#pragma context server

// Converted from orc_for/orc_pshaman_sa.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/dq/voldarshaman.as"

[script "orc_for/orc_pshaman_sa"]
class OrcPshamanSa : VoldarshamanScript
{
	// Variables declared by included files, with the value they start with in this script
	OrcPshamanSa()
	{
		NPC_SELF_ADJUST = true;
		NPC_ADJ_TIERS = "0;750;1500;2000;3000;5000";
		NPC_ADJ_DMG_MUTLI_TOKENS = "1.0;1.5;2.0;5.0;7.5;10.0;";
		NPC_ADJ_HP_MUTLI_TOKENS = "1.0;1.5;2.0;3.0;5.0;7.5;";
	}

	// unnamed block (first think)
	void OrcPshamanSa_FirstThink()
	{
		NPC_SELF_ADJUST = true;
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseRanged_OnOrcSpawn(); // monsters/orc_base_ranged
		Voldarshaman_OnOrcSpawn(); // dq/voldarshaman

		SetProp(ENT_ME, "skin", 3);

		SetHealth(220);
		// ov 180
		SetName("Orc Venom Shaman");
		SetHearingSensitivity(8);
		SetStat("parry", 30);
		SetDamageTaken("all", 0.8f);
		SetDamageTaken("lightning", 3);
		SetDamageTaken("acid", 0);
		SetDamageTaken("poison", 0);
		SetStat("spellcasting", 30, 30, 30, 30, 30, 30, 30);

		SetModelBody(0, 0); // Body 0=naked 1=leather 2=plate 3=green-hide
		SetModelBody(1, 4); // Head 0=cap_shorthorn 1=cap_nohorn 2=buffo_skin 3=cheif_ramhorns 4=green_hood
		SetModelBody(2, 0); // Weapon 0=fist 1=axe 2=bow_weak 3=bow_strng 4=sword 5=bloodyaxe 6=sword&sheild
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OrcPshamanSa_FirstThink();
		Voldarshaman_FirstThink();
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
		return VoldarshamanScript::DispatchEvent(name, params);
	}
}
