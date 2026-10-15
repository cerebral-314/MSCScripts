#pragma context server

// Converted from orc_for/orc_fshaman_sa.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/orc_for/tiers1.as"
#include "converted/monsters/orc_shaman_fire.as"

[script "orc_for/orc_fshaman_sa"]
class OrcFshamanSa : OrcShamanFireScript, Tiers1
{
	// Variables declared by included files, with the value they start with in this script
	OrcFshamanSa()
	{
		NPC_SELF_ADJUST = true;
		NPC_ADJ_TIERS = "0;750;1500;2000;3000;5000";
		NPC_ADJ_DMG_MUTLI_TOKENS = "1.0;1.5;2.0;5.0;7.5;10.0;";
		NPC_ADJ_HP_MUTLI_TOKENS = "1.0;1.5;2.0;3.0;5.0;7.5;";
	}

	// unnamed block (first think)
	void OrcFshamanSa_FirstThink()
	{
		NPC_SELF_ADJUST = true;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		CallEventDelayed(2.0f, "final_adjstments");
	}

	// final_adjstments
	void OnFinalAdjstments()
	{
		if (!(NPC_ADJ_LEVEL < 2.0f))
			return;
		FIRE_BALL_DAMAGE = FIRE_BALL_DAMAGE_ALT;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OrcFshamanSa_FirstThink();
		Tiers1_FirstThink();
		OrcShamanFire_FirstThink();
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
		if (name == "final_adjstments") { OnFinalAdjstments(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return OrcShamanFireScript::DispatchEvent(name, params);
	}
}
