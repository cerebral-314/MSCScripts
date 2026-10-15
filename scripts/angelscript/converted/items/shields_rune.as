#pragma context server

// Converted from items/shields_rune.script by msc_transpiler.
// Rune shield
// Immortal, chance of frostbiting opponents

#include "runtime/ScriptEntity.as"
#include "converted/items/shields_base.as"

[script "items/shields_rune"]
class ShieldsRune : ShieldsBaseScript
{
	// Constants
	bool SHIELD_REPORT_HITS = true;
	string SHIELD_MAXHEALTH = "infinite";
	int EFFECT_RANGE = 150;

	// Variables (an unset .script variable reads as its own name)
	string SHIELD_HEALTH = "SHIELD_HEALTH";

	// Variables declared by included files, with the value they start with in this script
	ShieldsRune()
	{
		NOPUSH_CHANCE = "75%";
		PARRY_MULTI = 2.0f;
		SHIELD_BASE_PARRY = 25;
		MODEL_VIEW = "viewmodels/v_shields.mdl";
		MODEL_VIEW_IDX = 2;
		MODEL_BODY_OFS = "69";
		MELEE_ENERGY = 15.0f;
		MELEE_ACCURACY = "90%";
		BLOCK_CHANCE_UP = 100;
		DMG_BLOCK_UP = 0.35f;
		BLOCK_CHANCE_DOWN = 30;
		SHIELD_IMMORTAL = true;
		SOUND_BLOCK = "doors/doorstop5.wav";
	}

	// unnamed block (first think)
	void ShieldsRune_FirstThink()
	{
		SHIELD_HEALTH = "infinite";
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras
		BaseMelee_OnGameWear(race, gender, source); // items/base_melee
		ShieldsBase_OnGameWear(race, gender, source); // items/shields_base

		OwnerMessage("You sling a Rune Shield over your shoulder.");
	}

	// shield_spawn
	void OnShieldSpawn()
	{
		SetName("Rune Shield");
		SetDescription("This rune shield is cold to the touch");
		SetWeight(40);
		SetValue(5000);
		LegacyCommand("quality", 2000);
		SetHudSprite("hand", "ironshield");
		SetHudSprite("trade", "runeshield");
	}

	// shield_hit
	// 1: Attacker  2: Inflictor  3: dmg  4: dmg type
	void OnShieldHit(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null)
	{
		int frostChance;

		if (!IsAlive(attacker))
			return;
		if (IsProjectile(inflictor))
			return;

		CBaseEntity@ myOwner = EntityOf(ENT_OWNER);
		CBaseEntity@ theAttacker = attacker;
		if (theAttacker is EntityOf(ENT_OWNER)) // don't freeze self shielding from effects
			return;

		Vector3 ownerOrg = OriginOf(myOwner);
		Vector3 attackerOrg = OriginOf(theAttacker);

		if (!(Distance(ownerOrg, attackerOrg) < EFFECT_RANGE))
			return;

		if (!Truthy(Eval("game.item.attacking")))
			frostChance = 25;
		else
			frostChance = 5;

		int frostRoll = RandomInt(1, frostChance);
		DebugPrint("frost_roll " + frostRoll + " / " + frostChance);

		if (frostRoll == 1)
		{
			OwnerMessage("The rune shield's magic has frozen your enemy!");
			PlaySound(2, Eval("const.snd.fullvol"), "debris/beamstart14.wav");
			ApplyEffect(theAttacker, "effects/dot_cold", 10, @EntityOf(ENT_OWNER), Random(5, 15), "none");
		}
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons2.mdl");
		Precache("viewmodels/v_shields.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ShieldsRune_FirstThink();
		ShieldsBase_FirstThink();
		BaseWeapon_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_wear") { OnGameWear(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "shield_hit") { OnShieldHit(EntityParam(params, 0), EntityParam(params, 1)); return true; }
		if (name == "shield_spawn") { OnShieldSpawn(); return true; }
		return ShieldsBaseScript::DispatchEvent(name, params);
	}
}
