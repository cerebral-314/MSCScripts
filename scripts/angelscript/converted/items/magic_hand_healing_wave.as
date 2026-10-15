#pragma context server

// Converted from items/magic_hand_healing_wave.script by msc_transpiler.
// Healing Wave as a spell. greatguys1@OCT2022

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_base.as"

[script "items/magic_hand_healing_wave"]
class MagicHandHealingWave : MagicHandBaseScript
{
	// Constants
	string MELEE_RANGE = "1";
	float MELEE_ATK_DURATION = 3.0f;
	int SPELL_MPDRAIN = 20;

	// Variables (an unset .script variable reads as its own name)
	int SPELL_SKILL_REQUIRED = 10;

	// Variables declared by included files, with the value they start with in this script
	MagicHandHealingWave()
	{
		MELEE_DMG_DELAY = 0.1f;
		SPELL_PREPARE_TIME = 1.0f;
	}

	// unnamed block (first think)
	void MagicHandHealingWave_FirstThink()
	{
		SPELL_SKILL_REQUIRED = 10;
	}

	// game_precache
	void MagicHandHealingWave_OnGamePrecache()
	{
		PrecacheFile("effects/sfx_wave");
	}

	// game_precache
	void OnGamePrecache()
	{
		MagicHandHealingWave_OnGamePrecache();
		MagicHandBase_OnGamePrecache(); // items/magic_hand_base
	}

	// spell_casted
	void OnSpellCasted(string hitType = "", Vector3 endPosition = Vector3(), CBaseEntity@ target = null)
	{
		MagicHandBase_OnSpellCasted(hitType, endPosition, target); // items/magic_hand_base

		Vector3 ownerLoc = OriginOf(ENT_OWNER);
		ownerLoc.z = GroundHeight(ownerLoc);

		string ownerYaw = Text(ViewAnglesOf(ENT_OWNER));
		ownerYaw = Text(Vec(ownerYaw).y);

		CreateNpc("effects/sfx_wave", ownerLoc, @EntityOf(ENT_OWNER), ownerYaw, SkillOf(ENT_OWNER, "spellcasting.divination"), "spellcasting.divination"); // <owner> <yaw> <level cast as> <skill to level>
	}

	// spell_spawn
	void OnSpellSpawn()
	{
		SetName("Healing Wave");
		SetDescription("A holy wave of Felewyn to bless your allies.");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MagicHandHealingWave_FirstThink();
		MagicHandBase_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "spell_casted") { OnSpellCasted(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2)); return true; }
		if (name == "spell_spawn") { OnSpellSpawn(); return true; }
		return MagicHandBaseScript::DispatchEvent(name, params);
	}
}
