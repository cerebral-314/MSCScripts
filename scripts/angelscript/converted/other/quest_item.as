#pragma context server

// Converted from other/quest_item.script by msc_transpiler.
// This was an attempt to create a persistant "quest bank" for items to be read back by quest npcs
// got to be too complicated, just going to use a simpler system for m2_quest2

#include "runtime/ScriptEntity.as"

[script "other/quest_item"]
class QuestItem : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";
	float NEXT_TOUCH = 0.0f;
	string QUEST_PLAYER = "QUEST_PLAYER";
	bool QUEST_ITEM_FOUND = false;
	float NEXT_QUEST_ERROR = 0.0f;
	string CUR_QUEST_BANK = "CUR_QUEST_BANK";
	bool QUEST_ITEM_ADDED = false;
	string IN_NAME = "IN_NAME";
	string IN_PARAMS = "IN_PARAMS";
	string FINAL_NAME = "FINAL_NAME";
	string QUEST_TAG = "QUEST_TAG";
	string MODEL_NAME = "MODEL_NAME";
	int MODEL_BODY = 0;
	string MAP_TRIGGER = "MAP_TRIGGER";
	bool IS_UNIQUE = false;

	// unnamed block (first think)
	void QuestItem_FirstThink()
	{
		SetCallback("touch", "enable");
	}

	// game_touch
	string QuestItem_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";
		if (!(GameTime() > NEXT_TOUCH))
			return result;
		NEXT_TOUCH = GameTime() + 0.1f;

		if (!IsPlayer(other))
			return result;
		QUEST_PLAYER = EntityId(other);

		if (IS_UNIQUE)
		{
			QUEST_ITEM_FOUND = false;
			for (int i = 0; i < 9; i++)
			{
				loopIteration = i;
				OnCheckQuestData();
			}
			if (QUEST_ITEM_FOUND && GameTime() > NEXT_QUEST_ERROR)
			{
				NEXT_QUEST_ERROR = GameTime() + 5.0f;
				PlayerMessageDark(QUEST_PLAYER, "You already have this unique quest item.");
			}
		}
		if (QUEST_ITEM_FOUND)
			return result;

		PlaySound(0, 10, "items/ammopickup1.wav");
		string outMsg = "You find " + FullNameOf(ENT_ME);
		PlayerMessageGreen(QUEST_PLAYER, "You acquire  " + FullNameOf(ENT_ME));
		InfoMessage(QUEST_PLAYER, "QUEST ITEM FOUND", outMsg);
		HelpTip(QUEST_PLAYER, "questitem", "QUEST ITEM", "This is a special quest item that will not appear in your inventory.");
		for (int i = 0; i < 9; i++)
		{
			loopIteration = i;
			OnAddQuestItem();
		}
		CallEventDelayed(0.1f, "remove_me");
		return result;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetWidth(16);
		SetHeight(16);
		SetSolid("trigger");
		SetInvincible(true);
		SetNoPush(true);
		PLAYING_DEAD = "1"; // not a valid target
	}

	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "") { return QuestItem_OnGameTouch(other, hpRange, effectDamage); } // game_touch

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		// this valid death should be monster spawn friendly
		SetInvincible(false);
		SetRace("hated");
		DoDamage(ENT_ME, "direct", 99999, 100, GetVar("GAME_MASTER"), "target");
	}

	// check_quest_data
	// copy pasta these two events to NPC
	void OnCheckQuestData()
	{
		if (QUEST_ITEM_FOUND)
			return;
		string questBank = "q" + loopIteration;
		CUR_QUEST_BANK = GetQuestData(QUEST_PLAYER, questBank);
		if (CUR_QUEST_BANK == "0")
			return;
		int count = GetTokenCount(CUR_QUEST_BANK);
		int outerIteration = loopIteration;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCheckQuestBank();
		}
		loopIteration = outerIteration;
	}

	// check_quest_bank
	void OnCheckQuestBank()
	{
		string curItem = GetToken(CUR_QUEST_BANK, loopIteration);
		if (curItem == QUEST_TAG)
			QUEST_ITEM_FOUND = true;
	}

	// add_quest_item
	void OnAddQuestItem()
	{
		if (QUEST_ITEM_ADDED)
			return;
		string questBank = "q" + loopIteration;
		CUR_QUEST_BANK = GetQuestData(QUEST_PLAYER, questBank);
		if (int(CUR_QUEST_BANK.length()) < 200)
		{
			QUEST_ITEM_ADDED = true;
			if (CUR_QUEST_BANK == "0")
			{
				Quest("set", QUEST_PLAYER, questBank, QUEST_TAG);
			}
			else
			{
				CUR_QUEST_BANK = TokenAdd(CUR_QUEST_BANK, QUEST_TAG);
				Quest("set", QUEST_PLAYER, questBank, CUR_QUEST_BANK);
			}
		}
	}

	// game_postspawn
	// <name>
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		IN_NAME = title;
		IN_PARAMS = params; // <tag>;<model>;<model_idx>;<trigger>;[unique]
		FINAL_NAME = "QUEST ITEM: " + IN_NAME;
		QUEST_TAG = GetToken(IN_PARAMS, 0);

		// need to rethink the model def - maybe only p_misc models, and always use flor anim
		MODEL_NAME = "misc/p_misc.mdl"; // $get_token(IN_PARAMS,1)
		MODEL_BODY = 2; // $get_token(IN_PARAMS,2)

		SetIdleAnim("apple_floor_idle");
		MAP_TRIGGER = GetToken(IN_PARAMS, 3);
		if (GetToken(IN_PARAMS, 4) == "unique")
		{
			IS_UNIQUE = true;
			FINAL_NAME += "(unique)";
		}

		SetModel(MODEL_NAME);
		SetModelBody(0, MODEL_BODY);
		SetName(FINAL_NAME);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		QuestItem_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "add_quest_item") { OnAddQuestItem(); return true; }
		if (name == "check_quest_bank") { OnCheckQuestBank(); return true; }
		if (name == "check_quest_data") { OnCheckQuestData(); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		return false;
	}
}
