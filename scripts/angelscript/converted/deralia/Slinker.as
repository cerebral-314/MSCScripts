#pragma context server

// Converted from deralia/Slinker.script by msc_transpiler.
// Thothie - trying to get slinker to fight back when attacked
// - Quest seems to be bugged too - maybe OVER is reserved word? (could be true of QUEST too) :\
// - Quest fixed, Attack fixed (simplification + potential reserved word replacement)
// Slinker in Deralia
// Magnus Damli : Fixed responses dependant on the phase of the quest; Initiation, on-going and result.
// Magnus Damli : Fixed repeating the quest over and over without having to reload the map.
// Fixed slinker for the new deralia, uses $cansee instead of range; can now use menu option to say "no"; uses $cansee to determine if he was hailed;
// ...sounds now automatically determine the channel so speech doesn't get cut off. greatguys1@November2018

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"
#include "converted/monsters/base_chat.as"

[script "deralia/Slinker"]
class Slinker : BaseMonsterScript, BaseChat
{
	// Constants
	bool NO_RUMOR = true;
	bool NO_JOB = true;
	bool NO_HAIL = true;
	int SEE_RANGE = 350;

	// Variables (an unset .script variable reads as its own name)
	int FLEE_HEALTH = 0;
	string FLEE_CHANCE = "FLEE_CHANCE";
	string ATTACK_DAMAGE = "ATTACK_DAMAGE";
	string ATTACK_PERCENTAGE = "ATTACK_PERCENTAGE";
	string ANIM_ATTACK = "ANIM_ATTACK";
	int REQ_QUEST_NOTDONE = 0;
	bool MISSION_OVER = false;
	int ASKED = 0;
	int GAVE_QUEST = 0;
	string PLAYER_SPLOTTED = "PLAYER_SPLOTTED";
	string LAST_SPOKE_TO = "LAST_SPOKE_TO";
	string QUEST_WINNER = "QUEST_WINNER";
	bool T_QUEST_COMPLETE = false;

	// Variables declared by included files, with the value they start with in this script
	Slinker()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
	}

	// unnamed block (first think)
	void Slinker_FirstThink()
	{
		CAN_ATTACK = "0";
		CAN_HUNT = "0";
		CAN_FLEE = "1";
		CAN_RETALIATE = "1";
		FLEE_HEALTH = 25; // Used by base_monster
		FLEE_CHANCE = "50%"; // Used by base_monster	const	RETALIATE_CHANGETARGET_CHANCE 75%
		ATTACK_RANGE = 150.0f;
		ATTACK_HITRANGE = 200.0f;
		ATTACK_DAMAGE = "8";
		MOVE_RANGE = "90";
		ATTACK_PERCENTAGE = "95%";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "beatdoor";
	}

	// unnamed block (timer)
	// { say_job
	// say_hi //Uhh... Just gonna comment that out, I forsee that causing problems.
	// }
	void Slinker_Timer()
	{
		CallEventDelayed(3.0f, "Slinker_Timer");

		// Thothie - he never does this... pisses me off no end
		if (MISSION_OVER)
			return;
		if (Truthy(CAN_HUNT))
			return;
		if (!Truthy(LegacyFunction("cansee", "player", SEE_RANGE)))
			return;

		// thothie  6/29/2007 - new method
		// getplayersnb SLINK_PLAYERS
		// setvard PLAYER_NEAR 0
		// setvard SLINKER_LOOP 0
		// calleventloop $get_token_amt(SLINK_PLAYERS) check_near //no need for this anymore, $cansee() works for players now
		// dbg pulse PLAYER_NEAR SLINK_PLAYERS
		// if PLAYER_NEAR
		PLAYER_SPLOTTED = EntityId(EntityOf(ENT_LASTSEEN)); // why tf is this "splotted?"

		if (LAST_SPOKE_TO == PLAYER_SPLOTTED)
			return;

		SetMoveDest(PLAYER_SPLOTTED, 50);
		SetSayTextRange(512);
		SayText("Hey, want to make some fast cash?");
		PlaySound(0, 10, "voices/deralia/slinker1.wav");
		LAST_SPOKE_TO = PLAYER_SPLOTTED;
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttack_OnMyTargetDied(offender); // monsters/base_npc_attack
		CAN_ATTACK = "0";
		CAN_HUNT = "0";
		SetRace("human");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetUniqueName("Slinker");
		SetHealth(150);
		REQ_QUEST_NOTDONE = 1;
		// fov		359
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetName("Slinker");
		SetRoam(false);
		SetModel("npc/human1.mdl");
		SetModelBody(0, 3); // no more random models on named NPC's please
		SetModelBody(1, 1);
		SetMoveAnim("walk");

		MISSION_OVER = false;

		CatchSpeech("say_hi", "hi", "hail", "greet", "hello");
		CatchSpeech("say_no", "no", "nope", "naw", "never", "nah");
		CatchSpeech("say_yes", "yes", "sure", "yea", "ok");

		ASKED = -1; // Switches to 0 when someone hails him
		GAVE_QUEST = 2;
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		menuItem.title = "Hail";
		menuItem.type = "say";

		int say = RandomInt(1, 4); // This didn't use all 4 options before. Changed it to use 'em.
		if (say == 1)
			menuItem.data = "Hello";
		else if (say == 2)
			menuItem.data = "Hi";
		else if (say == 3)
			menuItem.data = "Hail";
		else if (say == 4)
			menuItem.data = "Greetings!";
		RegisterMenuItem(menuItem);

		if (ASKED == 0 && EntityId(player) == LAST_SPOKE_TO)
		{
			menuItem.title = "No";
			menuItem.type = "callback";
			menuItem.callback = "say_no";
			RegisterMenuItem(menuItem);
		}

		if (Truthy(ItemExists(player, "item_deed")))
		{
			menuItem.title = "Give deed";
			menuItem.type = "payment";
			menuItem.data = "item_deed";
			menuItem.callback = "give_deed";
			RegisterMenuItem(menuItem);
		}
	}

	// say_hi
	// { check_near //This is no longer needed
	// dbg game.script.iteration //cant remember if this works - I think not
	// local CUR_PLAYER $get_token(SLINK_PLAYERS,SLINKER_LOOP)
	// if ( $get(CUR_PLAYER,range) < 256 )
	// {
	// if ( $get_traceline($get(ent_me,origin),$get(CUR_PLAYER,origin),worldonly) equals $get(CUR_PLAYER,origin) ) //If slinker has line of sight. greatguys1@October2018
	// {
	// setvard PLAYER_NEAR 1
	// setvard PLAYER_SPLOTTED CUR_PLAYER
	// }
	// }
	// add SLINKER_LOOP 1
	// }
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		CBaseEntity@ player = null;

		if (talkingPlayer !is null)
			@player = talkingPlayer;
		else
			@player = EntityOf(ENT_LASTSPOKE);

		if (!Truthy(LegacyFunction("cansee", @player, SEE_RANGE)))
			return;
		if (Truthy(CAN_HUNT))
			return;

		if (ASKED < 1)
		{
			SayText("You aren't a goody-two-shoes good guy, are ya?");
			PlaySound(0, 10, "voices/deralia/slinker2.wav");
			OnBchatMouthMove();
			ASKED = 0;
			LAST_SPOKE_TO = EntityId(player);
		}

		if (ASKED == 1)
		{
			SayText("Well, get goin' already!");
			OnBchatMouthMove();
		}

		if ((T_QUEST_COMPLETE ? 1 : 0) == 1)
		{
			SayText("I've got no further business with you.");
			OnBchatMouthMove();
		}
	}

	// say_no
	void OnSayNo(CBasePlayer@ player = null)
	{
		if (Truthy(CAN_HUNT))
			return;
		if (ASKED != 0)
			return;
		SayText("Alright, here's the scoop. Master Proffund, that snobby nobleman who always hangs out at the bank, owes me a little money.");
		PlaySound(0, 10, "voices/deralia/slinker3.wav");
		OnBchatAutoMouthMove("9.2");
		ASKED = 1;
		CallEventDelayed(0.0f, "9.2");
	}

	// say_instruct
	void OnSayInstruct()
	{
		SayText("A gambling man, he is, but not a very good one. Anyway, he owes me so much money, I've decided to settle for the deed to one of his nice farm properties.");
		PlaySound(0, 10, "voices/deralia/slinker4.wav");
		OnBchatAutoMouthMove("11.5");
		CallEventDelayed(0.0f, "11.5");
	}

	// say_instruct2
	void OnSayInstruct2()
	{
		SayText("Go and get that deed from him for me, and I'll pay you handsomely.");
		PlaySound(0, 10, "voices/deralia/slinker5.wav");
		CallExternal(FindByName("Proffund"), "quest_start");
	}

	// mortal
	void OnMortal()
	{
		SetRace("orc");
	}

	// give_deed
	void OnGiveDeed(CBasePlayer@ winner = null)
	{
		ReceiveOffer("accept");
		QUEST_WINNER = EntityId(winner);
		CallEventDelayed(0.0f, "1");
	}

	// say_letter
	void OnSayLetter(CBasePlayer@ speaker = null)
	{
		if (T_QUEST_COMPLETE)
			return;

		PlayAnim("once", "yes");
		SayText("Nice work, here's your reward.");
		OnBchatMouthMove();
		PlaySound(0, 10, "voices/deralia/slinker_reward.wav");
		Offer(QUEST_WINNER, "gold", 15);
		Offer(QUEST_WINNER, "health_spotion");
		T_QUEST_COMPLETE = true;
		MISSION_OVER = true;
		REQ_QUEST_NOTDONE = 0;
		ASKED = 2;
	}

	// npc_death
	void OnNpcDeath()
	{
		CallExternal(FindByName("Proffund"), "slinker_dead");
	}

	// attack_1
	void OnAttack12()
	{
		DoDamage(ENT_LASTSEEN, ATTACK_RANGE, Random(6, 9), ATTACK_PERCENTAGE);
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		CAN_ATTACK = "1";
		CAN_HUNT = "1";
		SetRace("orc");
		SetRoam(true);
		OnNpcatkTarget2(EntityId(EntityOf(ENT_LASTSTRUCK)));
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseNpcAttack_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_attack
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttack_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		CallEventDelayed(3.0f, "Slinker_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Slinker_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseChat_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "give_deed") { OnGiveDeed(PlayerParam(params, 0)); return true; }
		if (name == "mortal") { OnMortal(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_instruct") { OnSayInstruct(); return true; }
		if (name == "say_instruct2") { OnSayInstruct2(); return true; }
		if (name == "say_letter") { OnSayLetter(PlayerParam(params, 0)); return true; }
		if (name == "say_no") { OnSayNo(PlayerParam(params, 0)); return true; }
		if (name == "Slinker_Timer") { Slinker_Timer(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
