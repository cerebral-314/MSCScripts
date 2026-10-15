#pragma context server

// Converted from monsters/companion/spell_maker_base.script by msc_transpiler.
// Base for spell makers
// PARAMS
// PARAM1 = Who to center FX around / give spell
// PARAM2 = script name of spell to give owner
// PARAM3 = scroll to return to owner after giving spell
// PARAM4 = Height to spawn spellmaker at (this is no longer used, but kept for client<->server compatiblity)
// PARAM5 = Index of item to remove (remote removal)
// /onst to set
// /onst FX_SCRIPT monsters/companion/spell_maker_summoning //script to dosplay fx
// /onst SHOW_FX 1 //weather to display fx
// /etvar ANIM_IDLE 	'' //idle anim
// /onst SPAWNER_MODEL	none //spawner model
// /onst MODEL_OFSET	0 //model body offset of spawner model
// /onst SOUND_SPAWN 	magic/heal_powerup.wav //spawn sound
// /onst REMOVE_DELAY 10.0 //delay before script is removed
// /onst SPELL_MAKER_HEIGHT xx //required for scripts with models
// /onst NO_FADE 1 //do not fade on delete (unused, changed fade method)

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SpellMakerBase
{
	// Constants
	int SPELL_MAKER_HEIGHT = 64;
	int GLOW_AMT = 50;
	string SPAWNER_MODEL = "null.mdl";

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	string SPELL_TO_GRANT = "SPELL_TO_GRANT";
	string ITEM_CREATED_ME = "ITEM_CREATED_ME";
	string MY_SPAWN_HEIGHT = "MY_SPAWN_HEIGHT";
	string ITEM_TO_REMOVE = "ITEM_TO_REMOVE";
	float FADE_LEVEL = 0.0f;
	float FADE_RATE = 0.0f;

	// game_spawn
	void SpellMakerBase_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Spell Spawner");
		SetRace("beloved");
		SetInvincible(true);
		SetFly(true);
		SetGravity(0);
		SetModel(SPAWNER_MODEL);
		SetSolid("none");
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_IDLE);

		if (GetVar("MODEL_OFSET") != "MODEL_OFSET")
			SetModelBody(0, Int(GetVar("MODEL_OFSET")));

		if (ANIM_IDLE != "")
			PlayAnim("loop", ANIM_IDLE);

		if (GetVar("SOUND_SPAWN") != "SOUND_SPAWN")
			PlaySound(0, 10, GetVar("SOUND_SPAWN"));

		if (Truthy(GetVar("FX_GLOW")))
			Effect("glow", ENT_ME, GetVar("GLOW_COLOR"), GLOW_AMT, GetVar("REMOVE_DELAY"), GetVar("REMOVE_DELAY"));
	}

	// game_dynamically_created
	void SpellMakerBase_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = EntityId(EntityOf(creatorValue1)); // interesting this causes crash when used for client events, if not pulled with $get(,id)
		SPELL_TO_GRANT = creatorValue2;

		if (SPELL_TO_GRANT != "none")
		{
			ITEM_CREATED_ME = damage;
			MY_SPAWN_HEIGHT = skill;
			ITEM_TO_REMOVE = extraValue5;

			SetAngle("face.y", AnglesOf(MY_OWNER).y);
		}

		if (SPAWNER_MODEL != "none")
		{
			FADE_LEVEL = 255.0f;
			FADE_RATE = Float(GetVar("REMOVE_DELAY"));
			FADE_RATE *= 0.1f;

			OnStickToOwner();
		}

		if (Truthy(GetVar("SHOW_FX")))
			CallEventDelayed(0.1f, "show_fx");
		if (SPELL_TO_GRANT != "none") // issue comes up if spell is granted before book is deleted
			CallEventDelayed(0.1f, "remove_scroll");

		CallEventOrDelay(GetVar("REMOVE_DELAY"), "me_vanish");
	}

	// show_fx
	void SpellMakerBase_OnShowFx()
	{
		ClientEvent("new", "all", GetVar("FX_SCRIPT"), IndexOf(ENT_ME), IndexOf(MY_OWNER), "EXTRA_PARAM1", "EXTRA_PARAM2", "EXTRA_PARAM3");
	}

	// remove_scroll
	void SpellMakerBase_OnRemoveScroll()
	{
		if (ITEM_TO_REMOVE != "none") // deleteent ITEM_TO_REMOVE
			CallExternal(ITEM_TO_REMOVE, "clear_hands");
		CallEventDelayed(0.1f, "grant_spell");
	}

	// grant_spell
	void SpellMakerBase_OnGrantSpell()
	{
		if (SPELL_TO_GRANT != "none")
			Offer(MY_OWNER, SPELL_TO_GRANT);
		CallEventDelayed(0.1f, "restore_scroll");
	}

	// restore_scroll
	void SpellMakerBase_OnRestoreScroll()
	{
		if (ITEM_CREATED_ME != "none")
			Offer(MY_OWNER, ITEM_CREATED_ME);
	}

	// me_vanish
	void SpellMakerBase_OnMeVanish()
	{
		SetAlive(false);
		DeleteEntity(ENT_ME);
	}

	// stick_to_owner
	void SpellMakerBase_OnStickToOwner()
	{
		FADE_LEVEL -= FADE_RATE;

		if (!(FADE_LEVEL > 0.0f))
			return;
		CallEventDelayed(0.1f, "stick_to_owner");

		// //dbg fading $int(FADE_LEVEL)
		SetProp(ENT_ME, "rendermode", 1);
		SetProp(ENT_ME, "renderamt", int(FADE_LEVEL));

		SetAngle("face.yaw", AnglesOf(MY_OWNER).y);

		Vector3 ownerPos = OriginOf(MY_OWNER);
		float ownerX = ownerPos.x;
		float ownerY = ownerPos.y;
		float zPos = GroundHeight(ownerPos) + SPELL_MAKER_HEIGHT;

		SetOrigin(ENT_ME, Vector3(ownerX, ownerY, zPos));
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { SpellMakerBase_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "") { SpellMakerBase_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); } // game_dynamically_created
	void OnShowFx() { SpellMakerBase_OnShowFx(); } // show_fx
	void OnRemoveScroll() { SpellMakerBase_OnRemoveScroll(); } // remove_scroll
	void OnGrantSpell() { SpellMakerBase_OnGrantSpell(); } // grant_spell
	void OnRestoreScroll() { SpellMakerBase_OnRestoreScroll(); } // restore_scroll
	void OnMeVanish() { SpellMakerBase_OnMeVanish(); } // me_vanish
	void OnStickToOwner() { SpellMakerBase_OnStickToOwner(); } // stick_to_owner
	void OnRemoveDelay() {} // REMOVE_DELAY

	// This file's events and timers by their .script names
	bool SpellMakerBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "grant_spell") { OnGrantSpell(); return true; }
		if (name == "me_vanish") { OnMeVanish(); return true; }
		if (name == "remove_scroll") { OnRemoveScroll(); return true; }
		if (name == "restore_scroll") { OnRestoreScroll(); return true; }
		if (name == "show_fx") { OnShowFx(); return true; }
		if (name == "stick_to_owner") { OnStickToOwner(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/companion/spell_maker_base"]
shared class SpellMakerBaseScript : ScriptEntity, SpellMakerBase
{
	// Variables every script that includes this file declares
	string ANIM_IDLE = "ANIM_IDLE";

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("null.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return SpellMakerBase_DispatchEvent(name, params);
	}
}
