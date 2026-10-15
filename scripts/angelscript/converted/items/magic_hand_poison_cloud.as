#pragma context server

// Converted from items/magic_hand_poison_cloud.script by msc_transpiler.
// Poison Cloud by Thothie (from magic_hand_fire_ball)

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_base.as"

[script "items/magic_hand_poison_cloud"]
class MagicHandPoisonCloud : MagicHandBaseScript
{
	// Constants
	int RANGED_FORCE = 1500;
	string RANGED_ATK_DURATION = "1";
	string RANGED_PROJECTILE = "proj_poison_cloud";
	string SPELL_DAMAGE_TYPE = "poison";
	int SPELL_MPDRAIN = 40;
	string SPELL_STAT = "spellcasting.affliction";

	// Variables (an unset .script variable reads as its own name)
	int SPELL_SKILL_REQUIRED = 15;
	float CLOUD_COUNT = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	MagicHandPoisonCloud()
	{
		SOUND_CHARGE = "magic/fireball_powerup.wav";
		SOUND_SHOOT = "magic/fireball_strike.wav";
		RANGED_COF = "1;1";
		RANGED_DMG_DELAY = 0.5f;
		SPELL_PREPARE_TIME = 2.0f;
		SPELL_ENERGYDRAIN = 5;
	}

	// unnamed block (first think)
	void MagicHandPoisonCloud_FirstThink()
	{
		SPELL_SKILL_REQUIRED = 15;
	}

	// spell_casted
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnSpellCasted(string hitType = "", Vector3 endPosition = Vector3(), CBaseEntity@ target = null)
	{
		MagicHandBase_OnSpellCasted(hitType, endPosition, target); // items/magic_hand_base

		CLOUD_COUNT += 1.0f;
		ServerPlaySound(Int(Eval("game.sound.item")), Eval("game.sound.maxvol"), SOUND_SHOOT);
	}

	// spell_spawn
	void OnSpellSpawn()
	{
		SetName("Poison Cloud");
		SetDescription("Creates a cloud of extremely deadly poison");
		CLOUD_COUNT = 0.0f;
	}

	// remove_hands
	void OnRemoveHands()
	{
		DeleteEntity(ENT_ME);
	}

	// fake_precache
	void OnFakePrecache()
	{
		ServerPlaySound(0, 0, SOUND_SHOOT);
		ServerPlaySound(0, 0, SOUND_CHARGE);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("viewmodels/v_martialarts.mdl");
		Precache("magic/fireball_powerup.wav");
		Precache("magic/fireball_strike.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MagicHandPoisonCloud_FirstThink();
		MagicHandBase_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "fake_precache") { OnFakePrecache(); return true; }
		if (name == "remove_hands") { OnRemoveHands(); return true; }
		if (name == "spell_casted") { OnSpellCasted(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2)); return true; }
		if (name == "spell_spawn") { OnSpellSpawn(); return true; }
		return MagicHandBaseScript::DispatchEvent(name, params);
	}
}
