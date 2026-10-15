#pragma context server

// Converted from other/qitem_barrel.script by msc_transpiler.
// . createnpc other/qitem_barrel 'tnt;5;brk_boss_entry'
// This script can be filled with quest items until full, then fires a trigger, or explodes

#include "runtime/ScriptEntity.as"
#include "converted/monsters/debug.as"

[script "other/qitem_barrel"]
class QitemBarrel : DebugScript
{
	// Constants
	string SPRITE_EXPLODE = "bigsmoke.spr";
	string SOUND_EXPLODE = "weapons/explode3.wav";
	int BARREL_CLOSED_IDX = 6;

	// Variables (an unset .script variable reads as its own name)
	float ITEMS_TO_TURN_IN = 0.0f;
	string PLAYING_DEAD = "PLAYING_DEAD";
	string MAIN_NAME = "MAIN_NAME";
	float ITEM_COUNT = 0.0f;
	bool AM_SUMMONED = false;
	string ITEM_TYPE = "ITEM_TYPE";
	float ITEM_REQ = 0.0f;
	string BARREL_EVENT = "BARREL_EVENT";
	bool BARREL_REPEATS = false;
	string MENU_ADD = "MENU_ADD";
	string ITEM_NAME = "ITEM_NAME";
	bool BARREL_EXPLODES = false;
	bool BARREL_USE_SUBMODELS = false;
	bool BARREL_SUBMODEL_GROUP = false;
	bool BARREL_SUBMODEL_IDX_MIN = false;
	int BARREL_SUBMODEL_IDX_MAX = 0;
	CBasePlayer@ BARREL_PLR = null;
	bool BARREL_DONE = false;

	// unnamed block (first think)
	void QitemBarrel_FirstThink()
	{
		ITEMS_TO_TURN_IN = 0.0f;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetModel("props/tnt_barrel.mdl");
		SetWidth(32);
		SetHeight(72);
		SetModelBody(0, 0);
		SetProp(ENT_ME, "skin", 0); // use skin #1 for non-explosives
		SetNoPush(true);
		SetInvincible(true);
		PLAYING_DEAD = "1";
		SetName("Barrel");
		MAIN_NAME = "'BarrelofStuff'";
		SetMenuAutoOpen(true);
		ITEM_COUNT = 0.0f;
	}

	// game_postspawn
	// <unused> <unused> <unused> <params>
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		if (AM_SUMMONED)
			return;
		OnSetupBarrel(params);
	}

	// game_dynamically_created
	// <item_type;num_required;trigger_event;[repeat]>
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		AM_SUMMONED = true;
		OnSetupBarrel(creatorValue1);
	}

	// setup_barrel
	// <item_type;num_required;trigger_event;[repeat]>
	void OnSetupBarrel(string barrelConfig = "")
	{
		bool typeHandled = false;

		if (ITEM_TYPE != "ITEM_TYPE")
			return;

		DebugPrint("setup_barrel " + barrelConfig);

		ITEM_TYPE = GetToken(barrelConfig, 0);
		ITEM_REQ = Float(GetToken(barrelConfig, 1));
		BARREL_EVENT = GetToken(barrelConfig, 2);
		if (GetTokenCount(barrelConfig) >= 4 && GetToken(barrelConfig, 3) == "repeat")
			BARREL_REPEATS = true;

		if (Contains(ITEM_TYPE, "tnt"))
		{
			MAIN_NAME = "Barrel of Explosives ";
			SetNamePrefix("a");
			SetProp(ENT_ME, "skin", 0);
			MENU_ADD = "Add Explosives ";
			ITEM_NAME = "explosives";
			BARREL_EXPLODES = true;
			BARREL_USE_SUBMODELS = true;
			BARREL_SUBMODEL_GROUP = false;
			BARREL_SUBMODEL_IDX_MIN = true;
			BARREL_SUBMODEL_IDX_MAX = 5;
			OnUpdateName();
			typeHandled = true;
		}

		if (!typeHandled)
			DebugPrint("other/qitem_barrel - Warning! Type " + ITEM_TYPE + " not handled!");
	}

	// update_name
	void OnUpdateName()
	{
		string name = MAIN_NAME + "(" + int(ITEM_COUNT) + "/" + int(ITEM_REQ) + ")";
		SetName(name);
	}

	// ext_receive_quest_item
	// PARAM1 = qitem code //Called from game master
	void OnExtReceiveQuestItem(string itemCode = "")
	{
		ITEMS_TO_TURN_IN += 1.0f;
		ITEMS_TO_TURN_IN = 1.0f;
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		if (BARREL_DONE)
			return;

		CallExternal(GetVar("GAME_MASTER"), "ext_check_quest_item", ITEM_TYPE, self); // Collects all items for "turning in"

		if (ITEMS_TO_TURN_IN > 0.0f)
		{
			menuItem.title = MENU_ADD;
			LegacyCommand("stradd", "reg.mitem.title", "(");
			LegacyCommand("stradd", "reg.mitem.title", ITEMS_TO_TURN_IN);
			LegacyCommand("stradd", "reg.mitem.title", ")");
			menuItem.type = "callback";
			menuItem.data = Text(ITEMS_TO_TURN_IN);
			menuItem.callback = "add_items";
			RegisterMenuItem(menuItem);
		}
		else
		{
			string outMsg = "You have no " + ITEM_NAME + " to add to the " + MAIN_NAME;
			InfoMessage(player, "Quest item required", outMsg);
			menuItem.title = MENU_ADD;
			menuItem.type = "disabled";
			RegisterMenuItem(menuItem);
		}
	}

	// add_items
	void OnAddItems(CBasePlayer@ player = null, float playSound = 0.0f)
	{
		ITEM_COUNT += 1.0f;
		ITEMS_TO_TURN_IN -= 1.0f;
		if (ITEMS_TO_TURN_IN < 0.0f)
			ITEMS_TO_TURN_IN = 0.0f;

		if (playSound != 0.0f)
			PlaySound(0, 10, "items/ammopickup1.wav");
		OnUpdateName();

		if (BARREL_USE_SUBMODELS)
		{
			float fullRatio = Divide(ITEM_COUNT, ITEM_REQ);
			float body = Ratio(fullRatio, (BARREL_SUBMODEL_IDX_MIN ? 1.0f : 0.0f), BARREL_SUBMODEL_IDX_MAX);
			body = int(body);

			SetModelBody((BARREL_SUBMODEL_GROUP ? 1 : 0), int(body));
		}

		if (IsPlayer(player))
			@BARREL_PLR = player;

		if (!(ITEM_COUNT >= ITEM_REQ))
			return;
		if (BARREL_USE_SUBMODELS)
			SetModelBody((BARREL_SUBMODEL_GROUP ? 1 : 0), BARREL_SUBMODEL_IDX_MAX);
		string outMsg = MAIN_NAME + "is full!";
		HelpTip(BARREL_PLR, "generic", outMsg, " ");
		OnDoEvent();
	}

	// ext_setbody
	void OnExtSetbody(int bodyGroup = 0, int submodel = 0)
	{
		DebugPrint("ext_setbody " + bodyGroup + " " + submodel);
		SetModelBody(bodyGroup, submodel);
	}

	// do_event
	void OnDoEvent()
	{
		if (!BARREL_EXPLODES)
		{
			UseTrigger(BARREL_EVENT);
		}
		else
		{
			SetMenuAutoOpen(false);
			BARREL_DONE = true;
			OnDoExplode();
		}

		if (BARREL_REPEATS)
		{
			ITEM_COUNT -= ITEM_REQ;
			if (ITEM_COUNT >= 0.0f)
			{
				// had more than enough to fill again - do eet again
				OnAddItems(null, 0.0f);
			}
		}
		else
		{
			SetMenuAutoOpen(false);
			BARREL_DONE = true;
			if (!BARREL_EXPLODES)
				SetModelBody(0, BARREL_CLOSED_IDX);
		}
	}

	// do_explode
	void OnDoExplode(string value = "")
	{
		PlaySound(0, 10, "monsters/dwarf_bomber/fuse_lit.wav");
		ClientEvent("new", "all", "monsters/summon/tnt_bomb_cl", IndexOf(ENT_ME), 5.0f);
		CallEventDelayed(5.0f, "do_explode2");
	}

	// do_explode2
	void OnDoExplode2()
	{
		UseTrigger(BARREL_EVENT);
		PlaySound(0, 10, SOUND_EXPLODE);
		Effect("tempent", "spray", SPRITE_EXPLODE, MyOrigin(), 0, 1, 0, 0);
		SetModel("none");
		DoDamageEx(OriginOf(ENT_ME), 256, 2000, 0.9f, ENT_ME, ENT_ME, "none", "fire_effect", "dmgevent:push_loop");
		CallEventDelayed(0.1f, "remove_me");
	}

	// push_loop_dodamage
	void OnPushLoopDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		// dbg push_loop $get(CUR_TARGET,name) of PUSH_LIST
		Vector3 targetOrg = OriginOf(target);
		float targAng = AnglesTo(MyOrigin(), targetOrg);
		SetVelocity(target, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 1000, 110))); // a little to the left too, in case he's stuck up against a wall
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		// msmonster_spawn friendly removal
		SetOrigin(ENT_ME, Vector3(20000, 0, 0));
		SetInvincible(false);
		SetRace("hated");
		DoDamage(ENT_ME, "direct", 99999, 100, GetVar("GAME_MASTER"), "target");
	}

	// set_scale
	void OnSetScale(float scale = 0.0f)
	{
		if (!(scale > 0.0f))
			return;
		SetProp(ENT_ME, "scale", scale);
		float myWidth = WidthOf(ENT_ME);
		float myHeight = HeightOf(ENT_ME);
		myWidth *= scale;
		myHeight *= scale;
		SetWidth(myWidth);
		SetHeight(myWidth);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("props/tnt_barrel.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		QitemBarrel_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "add_items") { OnAddItems(PlayerParam(params, 0), Float(Param(params, 1))); return true; }
		if (name == "do_event") { OnDoEvent(); return true; }
		if (name == "do_explode") { OnDoExplode(Param(params, 0)); return true; }
		if (name == "do_explode2") { OnDoExplode2(); return true; }
		if (name == "ext_receive_quest_item") { OnExtReceiveQuestItem(Param(params, 0)); return true; }
		if (name == "ext_setbody") { OnExtSetbody(Int(Param(params, 0)), Int(Param(params, 1))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "push_loop_dodamage") { OnPushLoopDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "set_scale") { OnSetScale(Float(Param(params, 0))); return true; }
		if (name == "setup_barrel") { OnSetupBarrel(Param(params, 0)); return true; }
		if (name == "update_name") { OnUpdateName(); return true; }
		return DebugScript::DispatchEvent(name, params);
	}
}
