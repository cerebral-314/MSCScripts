#pragma context server

// Converted from monsters/companion/spell_maker_protection.script by msc_transpiler.
// Spell Maker by Thothie
// This bugger gives his owner the spell designated (attempting to bypass spell limit)
// - He also restores the scroll used to create him, as it will have to delete itself to make room for the spell
// - PARAM1 - Owner
// - PARAM2 - Spell to grant
// - PARAM3 - Scroll used to create

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc_attack.as"
#include "converted/monsters/companion/spell_maker_base.as"

[script "monsters/companion/spell_maker_protection"]
class SpellMakerProtection : BaseNpcAttackScript, SpellMakerBase
{
	// Constants
	string SPAWNER_MODEL = "weapons/p_weapons2.mdl";
	string MODEL_OFSET = "5";
	string SOUND_SPAWN = "magic/heal_powerup.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle1";

	// unnamed block (first think)
	void SpellMakerProtection_FirstThink()
	{
		ANIM_IDLE = "idle1";

		CAN_ATTACK = "0";
		CAN_HUNT = "0";

		PrecacheFile("monsters/companion/spell_maker_base");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetHealth(1);
		SetName("Spell Spawner");
		// ov		360
		SetWidth(32);
		SetHeight(32);
		SetRace("beloved");
		SetRoam(false);
		SetFly(true);
		LegacyCommand("float", 1);
		SetModel(SPAWNER_MODEL);
		SetModelBody(0, Int(MODEL_OFSET));
		SetInvincible(true);
		SetSolid("none");
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_IDLE);

		PlayAnim("loop", ANIM_IDLE);

		Effect("glow", ENT_ME, Vector3(255, 255, 255), 255, 2, 2);

		SetVolume(4);
		PlaySound(2, 4, SOUND_SPAWN);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		SpellMakerBase_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/companion/spell_maker_base
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseNpcAttack_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_attack
		SpellMakerBase_OnGameSpawn(playerRace, playerGender); // monsters/companion/spell_maker_base
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons2.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SpellMakerProtection_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return SpellMakerBase_DispatchEvent(name, params)
			|| BaseNpcAttackScript::DispatchEvent(name, params);
	}
}
