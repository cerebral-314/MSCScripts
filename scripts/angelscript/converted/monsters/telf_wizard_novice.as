#pragma context server

// Converted from monsters/telf_wizard_novice.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/elf_wizard_base.as"

[script "monsters/telf_wizard_novice"]
class TelfWizardNovice : ElfWizardBaseScript
{
	// Constants
	string ELF_GUIDED_DMG_TYPE = "magic";

	// Variables (an unset .script variable reads as its own name)
	int ELF_PALM_TYPE = 0;

	// Variables declared by included files, with the value they start with in this script
	TelfWizardNovice()
	{
		ELF_IS_NOVICE = true;
		ELF_PALM_ATTACK = true;
		ELF_CAN_GUIDED = true;
	}

	// unnamed block (first think)
	void TelfWizardNovice_FirstThink()
	{
		NPC_GIVE_EXP = 3000.0f;
		DROP_GOLD = 1;
		DROP_GOLD_AMT = 300.0f;

		ELF_PALM_TYPE = RandomInt(1, 3); // cold;fire;lightning
	}

	// elf_spawn
	void OnElfSpawn()
	{
		SetName("Torkalath Novice");
		SetHealth(5000);
		SetRace("torkie");

		SetModelBody(1, 0); // 0=Unarmed 1=Dark_Staff 2=Dragon_Staff 3=H4xbow
		SetProp(ENT_ME, "skin", 0); // 0=Young_Black_Robe 1=Elder_Black_Robe 2=Young_Green_Robe 3=Elder_Green_Robe 4=Young_Puce_Robe 5=Elder_Puce_Robe 6=Good_Pale 7=Good_Pink
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TelfWizardNovice_FirstThink();
		ElfWizardBase_FirstThink();
		ElfWizardBase_FirstThink2();
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
		if (name == "elf_spawn") { OnElfSpawn(); return true; }
		return ElfWizardBaseScript::DispatchEvent(name, params);
	}
}
