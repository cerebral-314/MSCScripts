#pragma context server

// Converted from items/item_ring_ryza.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

[script "items/item_ring_ryza"]
class ItemRingRyza : BaseMiscitemScript
{
	// Constants
	int EFFECT_DELAY = 25;

	// Variables (an unset .script variable reads as its own name)
	float NEXT_EFFECT = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	ItemRingRyza()
	{
		MODEL_BODY_OFS = "28";
		ANIM_PREFIX = "ring";
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("effects/manaring_portals");
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseMiscitem_OnGameDeploy(); // items/base_miscitem

		if (GameTime() >= NEXT_EFFECT)
			NEXT_EFFECT = GameTime() + 1.0f;
	}

	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Binding Trinket");
		SetDescription("You feel a faint thrum of power from the artifact that once bound Ryza.");

		SetViewModel("none");
		SetWorldModel(MODEL_WORLD);
		SetValue(420);
		SetHudSprite("trade", "226");
	}

	// game_attack1
	void OnGameAttack1()
	{
		if (GameTime() >= NEXT_EFFECT)
		{
			NEXT_EFFECT = GameTime() + EFFECT_DELAY;
			OnPortalEffects();
		}
	}

	// portal_effects
	void OnPortalEffects()
	{
		Vector3 spawnPoint = OriginOf(ENT_OWNER);
		Vector3 myAngles = ViewAnglesOf(ENT_OWNER);
		float myYaw = myAngles.y;
		spawnPoint += RelativePosition(Vector3(0, myYaw, 0), Vector3(0, 128, 0));
		spawnPoint.z += 15.0f;

		ClientEvent("new", "all", "effects/manaring_portals", spawnPoint);
	}

	// game_removefromowner
	void OnGameRemovefromowner()
	{
		SetModel(MODEL_HANDS);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_attack1") { OnGameAttack1(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_removefromowner") { OnGameRemovefromowner(); return true; }
		if (name == "miscitem_spawn") { OnMiscitemSpawn(); return true; }
		if (name == "portal_effects") { OnPortalEffects(); return true; }
		return BaseMiscitemScript::DispatchEvent(name, params);
	}
}
