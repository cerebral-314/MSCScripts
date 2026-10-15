#pragma context server

// Converted from items/mana_soup.script by msc_transpiler.
// New Sylphiel's Soup
// Still full HP & Mana heal upon slurp
// Regen is still 3 minutes, but it's for both mana and health
// Regen starts at 10 per tick for the first 30 seconds, then 5 per tick for the next 30 seconds and then 2 per tick for the last 2 minutes
// (Numbers still subject to change in case it either gives too much HP or MP)

#include "runtime/ScriptEntity.as"
#include "converted/items/base_item.as"

[script "items/mana_soup"]
class ManaSoup : BaseItemScript
{
	// Constants
	string MODEL_VIEW = "viewmodels/v_martialarts.mdl";
	int ITEM_MODEL_VIEW_IDX = 8;
	string MODEL_HANDS = "misc/p_misc.mdl";
	string MODEL_WORLD = "misc/p_misc.mdl";
	string MODEL_BODY_OFS = "69";
	int MODEL_BODY_FLOOR = 71;
	string ANIM_WORLD_IDLE = "apple_floor_idle";
	string ANIM_HAND_IDLE = "idle";
	string OWNER_ANIM_IDLE = "aim_soup";
	string OWNER_ANIM_USE = "aim_soup";
	string ANIM_USE = "20";
	float USE_DELAY = 2.0f;
	string SOUND_USE = "magic/slurp.wav";
	bool NO_IDLE = true;

	// Variables (an unset .script variable reads as its own name)
	int DRINK_AMOUNT = 1;
	float NEXT_USE = 0.0f;
	bool DO_OWNER_IDLES = false;
	bool ITEM_USED = false;
	bool APPLY_LATER = false;

	// Variables declared by included files, with the value they start with in this script
	ManaSoup()
	{
		ANIM_LIFT1 = 21;
		ANIM_IDLE1 = "21";
	}

	// unnamed block (first think)
	void ManaSoup_FirstThink()
	{
		DRINK_AMOUNT = 1;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseItem_OnGameSpawn(playerRace, playerGender); // items/base_item

		SetName("Sylphiel's Soup");
		SetDescription("Sylphiel's Applemead Soup provides temporary health and mana regen.");
		SetWeight(1);
		SetValue(200);
		SetHand("both");
		SetHudSprite("hand", "88");
		SetHudSprite("trade", "88");
	}

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		SetModelBody(0, MODEL_BODY_FLOOR);
		PlayAnim("WANIM_FLOOR");
		PlayAnim(ANIM_WORLD_IDLE);
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseItem_OnGameDeploy(); // items/base_item
		SetAnimExtension("soup");

		SetViewModel(MODEL_VIEW);
		SetModel(MODEL_HANDS);
		PlayAnim(ANIM_HAND_IDLE);
		SetModelBody(0, Int(MODEL_BODY_OFS));

		PlayOwnerAnim("once", OWNER_ANIM_IDLE, "global.anim.combatwalk", 3);
		NEXT_USE = GameTime() + 1.0f;

		DO_OWNER_IDLES = true;
		CallEventDelayed(2.0f, "item_idle");
	}

	// bweapon_effect_remove
	void OnBweaponEffectRemove(string reason = "")
	{
		BaseItemExtras_OnBweaponEffectRemove(reason); // items/base_item_extras
		DO_OWNER_IDLES = false;
	}

	// item_idle
	void OnItemIdle()
	{
		BaseItem_OnItemIdle(); // items/base_item
		if (!DO_OWNER_IDLES)
			return;
		if (!IsInHand(ENT_ME))
		{
			DO_OWNER_IDLES = false;
		}
		else
		{
			PlayOwnerAnim("once", OWNER_ANIM_IDLE, "global.anim.combatwalk", 3);
			CallEventDelayed(1.0f, "item_idle");
		}
	}

	// game_attack1
	void OnGameAttack1()
	{
		if (ITEM_USED)
			return;
		if (!(GameTime() > NEXT_USE))
			return;
		ITEM_USED = true;
		PlayItemViewAnim(ENT_ME, Int(ANIM_USE));
		CallEventDelayed(USE_DELAY, "use_item");
	}

	// use_item
	void OnUseItem()
	{
		CallExternal(ENT_OWNER, "ext_svplaysound_kiss", 1, 10, SOUND_USE, 0.8f, 100);
		PlayOwnerAnim("once", OWNER_ANIM_USE, "global.anim.combatwalk", 3);
		OnUseEffect();
	}

	// use_effect
	void OnUseEffect()
	{
		CallEventDelayed(2.0f, "use_complete");

		bool poopy = false;
		if (RandomInt(0, 99) == 0)
			poopy = true;

		if (!HasEffect(ENT_OWNER, "soup"))
		{
			ApplyEffect(ENT_OWNER, "effects/soup", 180, poopy); // If it doesn't have the effect, apply it
		}
		else
		{
			LegacyCommand("removeeffect", ENT_OWNER, "soup"); // <target> <effect_id> //Otherwise flag for deletion and apply it again on the end step.
			APPLY_LATER = true;
		}

		GiveHealth(ENT_OWNER, MaxHealthOf(ENT_OWNER) - HealthOf(ENT_OWNER));
		GiveMana(ENT_OWNER, MaxManaOf(ENT_OWNER) - ManaOf(ENT_OWNER));
	}

	// use_complete
	void OnUseComplete()
	{
		bool poopy = false;
		if (RandomInt(0, 99) == 0)
			poopy = true;

		PlayerMessageGreen(ENT_OWNER, "All your health and mana has been restored.");
		PlayerMessageGreen(ENT_OWNER, "Three minutes of health and mana regen.");

		if (APPLY_LATER) // If it doesn't have the effect, apply it
			ApplyEffect(ENT_OWNER, "effects/soup", 180, poopy);

		RemoveScript();
		DeleteEntity(ENT_ME);
	}

	// fake_precache
	void OnFakePrecache()
	{
		ServerPlaySound(0, 0, SOUND_USE);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnUseDelay() {} // USE_DELAY

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/p_misc.mdl");
		Precache("viewmodels/v_martialarts.mdl");
		Precache("magic/slurp.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ManaSoup_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bweapon_effect_remove") { OnBweaponEffectRemove(Param(params, 0)); return true; }
		if (name == "fake_precache") { OnFakePrecache(); return true; }
		if (name == "game_attack1") { OnGameAttack1(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "item_idle") { OnItemIdle(); return true; }
		if (name == "use_complete") { OnUseComplete(); return true; }
		if (name == "use_effect") { OnUseEffect(); return true; }
		if (name == "use_item") { OnUseItem(); return true; }
		return BaseItemScript::DispatchEvent(name, params);
	}
}
