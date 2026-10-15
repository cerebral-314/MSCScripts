#pragma context server

// Converted from deralia/thief.script by msc_transpiler.
// Thothie - this effectively becomes a walking bag of cash anyone can nail for free
// - Attempting to allow him to fight back when attacked
// - Buggar had no animations
// - Success! Except - there's no attack event in the model animation
// - I'll fix in model, or see if I can get attack hack from Lord K
// Thief

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc_attack.as"
#include "converted/monsters/attack_hack.as"

[script "deralia/thief"]
class DeraliaThief : BaseNpcAttackScript, AttackHack
{
	// Constants
	int FLEE_HEALTH = 34;
	string FLEE_CHANCE = "100%";

	// Variables (an unset .script variable reads as its own name)
	float GOLD = 10.0f;
	string ATTACK_DAMAGE = "7";
	string ATTACK_HITCHANCE = "70%";
	int ATTACK_FREQUENCY = 10;
	bool CAN_STTACK = false;
	string FLINCH_ANIM = "FLINCH_ANIM";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	string ANIM_ATTACK = "ANIM_ATTACK";
	int FOLLOWING = 0;
	int THIEF = 0;
	bool STEAL = false;
	int STEALING = 0;
	int OFFER_GIVEN = 0;
	int REWARD_NAO_PLZ = 0;
	bool QUEST_DONE = false;

	// Variables declared by included files, with the value they start with in this script
	DeraliaThief()
	{
		SOUND_DEATH = "player/stomachhit1.wav";
	}

	// unnamed block (first think)
	void DeraliaThief_FirstThink()
	{
		CAN_STTACK = false; // vared so can change modes
		CAN_FLEE = "1";
		FLEE_DISTANCE = "1000";
		CAN_RETALIATE = "0"; // vared so can change modes
		CAN_FLINCH = "1";
		FLINCH_ANIM = "llflinch";
		FLINCH_CHANCE = "50%";
		FLINCH_DELAY = "1";
		ANIM_DEATH = "dieforward";
		ANIM_WALK = "walk";
		GOLD = 10.0f;

		// attack vars
		ATTACK_DAMAGE = "7";
		ATTACK_RANGE = 80.0f;
		ATTACK_HITRANGE = 150.0f;
		ATTACK_HITCHANCE = "70%";
		ATTACK_FREQUENCY = 10; // for attack_hack

		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "franticbutton";

		FOLLOWING = 0;
	}

	// unnamed block (timer)
	void DeraliaThief_Timer()
	{
		CallEventDelayed(1.0f, "DeraliaThief_Timer");
		if (STEAL)
			return;
		if (!Truthy(LegacyFunction("cansee", "player", 256)))
			return;
		SetMoveDest(ENT_LASTSEEN, 64);
		if ((STEAL ? 1 : 0) != 0)
			return;
		STEALING = RandomInt(-15, -5);
		Offer(EntityOf(ENT_LASTSEEN), "gold", STEALING);
		GOLD -= STEALING;
		PlayAnim("once", "return_needle");
		SetRoam(false);
		CallEventDelayed(0.0f, "1");
		CallEventDelayed(0.0f, "5");
		SetGold(int(GOLD));
	}

	// unnamed block (first think)
	void DeraliaThief_FirstThink2()
	{
		if ((STEAL ? 1 : 0) != 1)
			return;
		SetVolume(8);
		Say("hello1[.83]", "[.33]", "[.91]", "[.91]", "[.38]", "[.36]");
		SetRoam(false);
		CallEventDelayed(0.0f, "4");
	}

	// unnamed block (timer)
	void DeraliaThief_Timer2()
	{
		CallEventDelayed(1.0f, "DeraliaThief_Timer2");
		if (FOLLOWING == 1)
		{
			if (Float(LegacyFunction("cansee", @FindByName("knight_lord"), 256)) == 1.0f)
			{
				SetMoveDest(@FindByName("knight_lord"), ATTACK_RANGE);
				CallEventDelayed(3.0f, "turn_in_now");
				FOLLOWING = 0;
			}
			else
			{
				SetMoveDest(GetVar("APPREHENDER"), 100);
			}
		}
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttack_OnMyTargetDied(offender); // monsters/base_npc_attack
		SetRace("human");
		SetName("Commoner");
		SetRoam(true);
	}

	// spawn
	void OnSpawn()
	{
		SetUniqueName("thief");

		SetHealth(45);
		SetGold(int(GOLD));
		// fov   180
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetName("Commoner");
		SetRoam(true);
		SetModel("npc/human1.mdl");
		SetModelBody(0, 1);
		SetModelBody(1, 5);
		SetMoveAnim("walk");

		THIEF = 0;
		STEAL = false;
	}

	// resumeroam
	void OnResumeroam()
	{
		SetRoam(true);
	}

	// resumesteal
	void OnResumesteal()
	{
		STEAL = true;
	}

	// say_accept
	void OnSayAccept(CBasePlayer@ player = null)
	{
		OFFER_GIVEN = 1;
		if (REWARD_NAO_PLZ != 1)
		{
			SayText("Thank you good Sir! I shall follow you to the Lord of the Land.");
			SetGlobal("APPREHENDER", @player);
			SetRace("beloved");
			SetMoveAnim(ANIM_RUN);
			FOLLOWING = 1;
		}
	}

	// quest_done
	void OnQuestDone()
	{
		DeleteEntity(self, "fade");
	}

	// turn_in_now
	void OnTurnInNow()
	{
		SetMoveDest(@FindByName("knight_lord"), ATTACK_RANGE);
		SayText("Sir, I am turning myself in for I have commited crime.");
		SayText("I have stolen from people.");
		LegacyCommand("callexternal", @FindByName("knight_lord"), 2, "say_jail");
		PlayAnim("once", "kneel");
	}

	// turned_in
	void OnTurnedIn()
	{
		REWARD_NAO_PLZ = 1;
		OpenMenu(GetVar("APPREHENDER"));
		QUEST_DONE = true;
	}

	// game_menu_cancel
	void OnGameMenuCancel(CBasePlayer@ player = null)
	{
		if (REWARD_NAO_PLZ != 1)
		{
			SayText("Then I shall fight you!");

			SetRace("orc");
			SetName("A Thief!");
			ANIM_RUN = "run";
			CAN_RETALIATE = "1";
			CAN_ATTACK = "1";
			CAN_HUNT = "1";
			SetRace("orc");
			SetRoam(true);
			OnNpcatkTarget2(EntityId(EntityOf(ENT_LASTSTRUCK)));
		}
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		menuItem.title = "Accept";
		menuItem.type = "callback";
		menuItem.callback = "say_accept";
		RegisterMenuItem(menuItem);
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		if (OFFER_GIVEN == 0)
		{
			SetName("Thief");
			SayText("Please spare me, good Sir, for I am but a petty thief.");
			SayText("I shall turn myself in if you would be so kind as to let me live.");
			PlayAnim("critical", "crouch");
			OpenMenu(EntityOf(ENT_LASTSTRUCK));
			STEAL = true;
			SetRoam(false);
		}
	}

	// attack
	void OnAttack()
	{
		DoDamage(ENT_LASTSEEN, ATTACK_RANGE, "ATTACK1_DAMAGE", "ATTACK_PERCENTAGE");
	}

	// dbg_find_thief
	void OnDbgFindThief()
	{
		SetSayTextRange(4096);
		SayText("OVER HERE!");
		DebugPrint("thief present");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		Precache("npc/hello1.wav");
		CallEventDelayed(1.0f, "DeraliaThief_Timer");
		CallEventDelayed(1.0f, "DeraliaThief_Timer2");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DeraliaThief_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		DeraliaThief_FirstThink2();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack") { OnAttack(); return true; }
		if (name == "dbg_find_thief") { OnDbgFindThief(); return true; }
		if (name == "game_menu_cancel") { OnGameMenuCancel(PlayerParam(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "quest_done") { OnQuestDone(); return true; }
		if (name == "resumeroam") { OnResumeroam(); return true; }
		if (name == "resumesteal") { OnResumesteal(); return true; }
		if (name == "say_accept") { OnSayAccept(PlayerParam(params, 0)); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		if (name == "turn_in_now") { OnTurnInNow(); return true; }
		if (name == "turned_in") { OnTurnedIn(); return true; }
		if (name == "DeraliaThief_Timer") { DeraliaThief_Timer(); return true; }
		if (name == "DeraliaThief_Timer2") { DeraliaThief_Timer2(); return true; }
		return AttackHack_DispatchEvent(name, params)
			|| BaseNpcAttackScript::DispatchEvent(name, params);
	}
}
