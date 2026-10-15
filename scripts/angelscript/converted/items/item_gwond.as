#pragma context server

// Converted from items/item_gwond.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

[script "items/item_gwond"]
class ItemGwond : BaseMiscitemScript
{
	// Variables (an unset .script variable reads as its own name)
	float NEXT_USE = 0.0f;
	bool SCROLL_USED = false;

	// Variables declared by included files, with the value they start with in this script
	ItemGwond()
	{
		MODEL_WORLD = "garbagegibs.mdl";
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseMiscitem_OnGameDeploy(); // items/base_miscitem
		NEXT_USE = GameTime() + 1.0f;
	}

	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Galat's Wondrous Scroll");
		SetDescription("This one time use scroll summons Galat's Wondrous Chest");
		SetHudSprite("trade", "letter");
	}

	// game_attack1
	void OnGameAttack1()
	{
		if (!(GameTime() > NEXT_USE))
			return;

		if (SCROLL_USED)
			return;
		SCROLL_USED = true;
		OnSummonChest();
	}

	// summon_chest
	void OnSummonChest()
	{
		Vector3 ownerPos = OriginOf(ENT_OWNER);
		float ownerYaw = AnglesOf(ENT_OWNER).y;
		string spawnPos = Text(ownerPos);
		spawnPos = Text(Vec(spawnPos) + RelativePosition(Vector3(0, ownerYaw, 0), Vector3(0, 64, 0)));
		CreateNpc("chests/galats", Vec(spawnPos), @EntityOf(ENT_OWNER));
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("garbagegibs.mdl");
		Precache("misc/p_misc.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_attack1") { OnGameAttack1(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "miscitem_spawn") { OnMiscitemSpawn(); return true; }
		if (name == "summon_chest") { OnSummonChest(); return true; }
		return BaseMiscitemScript::DispatchEvent(name, params);
	}
}
