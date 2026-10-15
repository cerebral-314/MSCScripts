#pragma context server

// Converted from keledrosprelude/stoneboar.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.
// Boss in the dark caves

#include "runtime/ScriptEntity.as"
#include "converted/monsters/boar_hard.as"

[script "keledrosprelude/stoneboar"]
class Stoneboar : MonstersBoarHardScript
{
	// Constants
	string ATTACK_HITPERCENT = "85%";

	// Variables declared by included files, with the value they start with in this script
	Stoneboar()
	{
		GORE_FORWARD_DAMAGE = 12.0f;
		GORE_SIDE_DAMAGE = "8.5";
		BOAR_CHARGE_DMG = "25";
		NPC_BASE_EXP = "45";
		SOUND_STRUCK1 = "weapons/axemetal1.wav";
		SOUND_STRUCK2 = "weapons/axemetal2.wav";
		SOUND_STRUCK3 = "debris/concrete1.wav";
	}

	// unnamed block (first think)
	void Stoneboar_FirstThink()
	{
		NPC_GIVE_EXP = 45.0f;

		DROP_ITEM1_CHANCE = "0%";

		IMMUNE_VAMPIRE = true;
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		SetDamageTaken("holy", 2);
		DROP_ITEM1_CHANCE = "0%"; // no skin
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BoarBase_OnNpcSpawn(npc); // monsters/boar_base
		Boar_OnNpcSpawn(npc); // monsters/boar
		MonstersBoarHard_OnNpcSpawn(npc); // monsters/boar_hard

		SetHealth(250);
		SetDamageTaken("all", 0.45f);
		SetDamageTaken("pierce", 0.15f);
		SetDamageTaken("fire", 0.05f);
		SetDamageTaken("poison", 0);
		SetName("Boar made of stone");
		SetHearingSensitivity(9);

		SetBlood("none");

		SetProp(ENT_ME, "skin", 1);

		// Set this here, to override base scripts
		CAN_FLEE = "0"; // base_npc_attack - Whether I run away at low health (changes for boar)
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Stoneboar_FirstThink();
		MonstersBoarHard_FirstThink();
		Boar_FirstThink();
		BoarBase_FirstThink();
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
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return MonstersBoarHardScript::DispatchEvent(name, params);
	}
}
