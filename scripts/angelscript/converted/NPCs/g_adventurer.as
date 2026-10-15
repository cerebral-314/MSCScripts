#pragma context server

// Converted from NPCs/g_adventurer.script by msc_transpiler.
// generic adventurer

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_chat.as"

[script "NPCs/g_adventurer"]
class GAdventurer : BaseMonsterNewScript, BaseChat
{
	// Constants
	float FREQ_FF_WARN = 10.0f;
	string SOUND_STRUCK = "body/flesh1.wav";
	string ATTACK_HITCHANCE = "85%";
	string ATTACK_DAMAGE = "$randf(5.0,8.0)";
	bool NO_JOB = true;
	bool NO_RUMOR = true;

	// Variables (an unset .script variable reads as its own name)
	string REWARD_LIST = "REWARD_LIST";
	string REWARD_NAMES = "REWARD_NAMES";
	float N_REWARDS_GIVEN = 0.0f;
	int MAX_REWARDS_TOGIVE = 0;
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool NO_HAIL = false;
	float NEXT_FF_WARNING = 0.0f;
	CBaseEntity@ CURRENT_SPEAKER = null;
	int DID_INTRO = 0;
	string CONVO_TYPE = "CONVO_TYPE";
	int CHAT_STEPS = 0;
	float CHAT_STEP = 0.0f;
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_DELAY_STEP1 = "CHAT_DELAY_STEP1";
	string CHAT_SOUND1 = "CHAT_SOUND1";
	string CHAT_STEP2 = "CHAT_STEP2";
	string CHAT_DELAY_STEP2 = "CHAT_DELAY_STEP2";
	string CHAT_SOUND2 = "CHAT_SOUND2";
	string CHAT_STEP3 = "CHAT_STEP3";
	string CHAT_DELAY_STEP3 = "CHAT_DELAY_STEP3";
	string CHAT_SOUND3 = "CHAT_SOUND3";
	string QUEST_WINNER = "QUEST_WINNER";
	bool IN_BATTLE = false;
	bool BATTLE_OVER = false;
	bool BATTLLE_OVER = false;
	bool FORCED_MOVE_DEST = false;
	bool SAID_REWARD = false;
	string MENU_TARGET = "MENU_TARGET";

	// Variables declared by included files, with the value they start with in this script
	GAdventurer()
	{
		SOUND_DEATH = "voices/human/male_die.wav";
		ANIM_IDLE = "idle1";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// unnamed block (first think)
	void GAdventurer_FirstThink()
	{
		REWARD_LIST = "axes_poison1;swords_poison1;swords_liceblade;gauntlets_normal;mana_leadfoot;scroll2_summon_rat;bows_swiftbow;item_charm_w1";
		REWARD_NAMES = "an Envenomed Axe;a Envenomed Shortsword;a Lesser Ice Blade;a set of Gauntlets;a Potion of Stability;a Summon Rat Scroll;an Elven Bow;a Wolf Charm";
		N_REWARDS_GIVEN = 0.0f; // maxes at whatever game.players was at battle_over
		MAX_REWARDS_TOGIVE = 0;

		ANIM_IDLE = "idle1";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_DEATH = "diebackward";
		ANIM_ATTACK = "swordswing1_l";

		MOVE_RANGE = "32";
		ATTACK_RANGE = 64.0f;
		ATTACK_HITRANGE = 120.0f;

		NPC_GIVE_EXP = 0.0f;
		NPC_NO_PLAYER_DMG = true;
		NO_HAIL = false;
	}

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type
	string GAdventurer_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		bool exitSub = false;
		bool isSpell = false;
		string result = "";

		// cant get him to stay invulnerable pre and post battle for some reason
		// not sure if this fixes it, but something did
		if (BATTLE_OVER)
		{
			result = AppendResult(result, "0");
			exitSub = true;
		}

		if (!IN_BATTLE)
		{
			result = AppendResult(result, "0");
			exitSub = true;
		}

		if (exitSub)
			return result;

		PlaySound(0, 5, SOUND_STRUCK);

		if (!IsPlayer(attacker))
			return result;

		if (!(GameTime() > NEXT_FF_WARNING))
			return result;

		NEXT_FF_WARNING = GameTime() + FREQ_FF_WARN;

		string itemName = ScriptVarOf(attacker, "PLR_ACTIVE_WEAPON");
		itemName = ItemNameOf(itemName);
		if (StartsWith(itemName, "magic_hand"))
			isSpell = true;
		if (StartsWith(itemName, "blunt_staff"))
			isSpell = true;

		if (isSpell)
		{
			SayText("Watch where you cast your spells!");
			int rndSpell = RandomInt(1, 2);
			if (rndSpell == 1)
				PlaySound(0, 10, "voices/jerdid/Jerdid_8.wav");
			else
				PlaySound(0, 10, "voices/jerdid/Jerdid_8_2.wav");
		}

		if (!isSpell)
		{
			SayText("Hey there! Careful where you swing that!");
			PlaySound(0, 10, "voices/jerdid/Jerdid_9.wav");
		}
		return result;
	}

	// unnamed block (timer)
	void GAdventurer_Timer()
	{
		CallEventDelayed(10.0f, "GAdventurer_Timer");

		if (BATTLE_OVER)
			SetMoveDest(QUEST_WINNER, 32);

		// try to stay within 800 units of spawn
		if (!(Distance(MyOrigin(), Vec(NPC_HOME_LOC)) > 800.0f))
			return;
		OnNpcatkSuspendAi("2.0");
		NPC_FORCED_MOVEDEST = true;
		OnNpcatkSetmovedest(NPC_HOME_LOC, "32"); // make home official destination
		SetMoveDest(NPC_HOME_LOC, 32); // ai is suspended, so get there manually
		if (NPCATK_TARGET != "unset")
			OnNpcatkRun();
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Jerdid the Adventurer");
		SetInvincible(true); // toggle off when battle begins
		CallEventDelayed(0.1f, "stay_invuln_damnit");
		SetRace("human");
		SetWidth(32);
		SetHeight(96);
		SetHealth(300);
		SetSayTextRange(800);
		SetHearingSensitivity(8);
		SetModel("npc/royal_guard1.mdl");
		SetModelBody(1, 3);
		CallEventDelayed(1.0f, "critical_npc");
		SetIdleAnim("idle1");
		SetMoveAnim("walk");

		CatchSpeech("say_hi", "hi", "hail", "j0", "jo", "yo", "waddup", "wassup", "hello", "greet");
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, GAdventurer_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;
		int count;

		DebugPrint("game_menu_getoptions conv: " + CONVO_TYPE);

		if (CONVO_TYPE == "intro")
		{
			menuItem.title = "Yes, I'll help.";
			menuItem.type = "callback";
			menuItem.callback = "player_accept";
			RegisterMenuItem(menuItem);

			menuItem.title = "Sorry, busy.";
			menuItem.type = "callback";
			menuItem.callback = "player_deny";
			RegisterMenuItem(menuItem);
		}

		if (BATTLE_OVER)
		{
			DebugPrint("game_menu_getoptions bat " + Text(BATTLE_OVER));
			if (CONVO_TYPE != "give_list" && !Truthy(ScriptVarOf(player, "PLR_GOT_REWARD")))
			{
				menuItem.title = "Collect reward";
				menuItem.type = "callback";
				menuItem.callback = "give_reward";
				RegisterMenuItem(menuItem);
			}
		}

		if (CONVO_TYPE == "give_list" && !Truthy(ScriptVarOf(player, "PLR_GOT_REWARD")))
		{
			count = GetTokenCount(REWARD_LIST);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnAddRewards();
			}
			CONVO_TYPE = "none";
			NO_HAIL = false;
		}
	}

	// chat_loop
	void OnChatLoop()
	{
		BaseChat_OnChatLoop(); // monsters/base_chat
		if (CHAT_STEP == 2.0f)
		{
			// face some unseen howl in the distance and shiver a bit
			if (CONVO_TYPE == "intro")
			{
				SetMoveDest(RelativePosition(Vector3(0, -8000, 0)), 9999);
				UseTrigger("distant_howl");
				PlayAnim("critical", "panic");
				CallEventDelayed(2.0f, "fix_anims");
			}
		}
		if (CHAT_STEP == 3.0f && CONVO_TYPE == "intro")
		{
			SetMoveDest(@CURRENT_SPEAKER, 9999);
			PlayAnim("critical", "converse2");
			NO_HAIL = true;
			CallEventDelayed(2.0f, "open_menu");
		}
	}

	// stay_invuln_damnit
	// wtfness
	void OnStayInvulnDamnit()
	{
		SetInvincible(true);
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (IN_BATTLE)
			return;
		if (BUSY_CHATTING)
			return;

		if (IsPlayer(talkingPlayer))
		{
			@CURRENT_SPEAKER = talkingPlayer;
			OnFaceSpeaker(EntityId(CURRENT_SPEAKER));
		}
		if (IsPlayer(ENT_LASTSPOKE))
		{
			@CURRENT_SPEAKER = EntityOf(ENT_LASTSPOKE);
			OnFaceSpeaker(EntityId(CURRENT_SPEAKER));
		}

		if (!BATTLE_OVER)
		{
			DID_INTRO = 1;
			PlayAnim("critical", "lean");
			CallEventDelayed(2.0f, "fix_anims");
			CONVO_TYPE = "intro";
			CHAT_STEPS = 3;
			CHAT_STEP = 0.0f;
			CHAT_STEP1 = "Ah, hello there. I've been honing my skills here for awhile now.";
			CHAT_DELAY_STEP1 = "5.01";
			CHAT_SOUND1 = "voices/jerdid/Jerdid_1.wav";
			CHAT_STEP2 = "However, I'm hearing far more howls than I'd feel comfortable dealing with... Should there be wolves attached to them all.";
			CHAT_DELAY_STEP2 = "8.19";
			CHAT_SOUND2 = "voices/jerdid/Jerdid_2.wav";
			CHAT_STEP3 = "If you'd be so kind as to stay a moment and assist me, I'd would be forever grateful.";
			CHAT_DELAY_STEP3 = "6.33";
			CHAT_SOUND3 = "voices/jerdid/Jerdid_3.wav";
			OnChatLoop();
		}

		if (BATTLE_OVER)
		{
			PlayAnim("critical", "yes");
			CallEventDelayed(2.0f, "fix_anims");
			SayText("Thanks again for your assistance.");
			PlaySound(0, 10, "voices/jerdid/Jerdid_10.wav");
		}
	}

	// open_menu
	void OnOpenMenu()
	{
		OpenMenu(CURRENT_SPEAKER);
	}

	// add_rewards
	void OnAddRewards()
	{
		MenuItem menuItem;

		if (RandomInt(1, 2) != 1)
			return;

		int curIdx = loopIteration;
		string curReward = GetToken(REWARD_LIST, curIdx);
		string curName = GetToken(REWARD_NAMES, curIdx);

		menuItem.title = curName;
		menuItem.type = "callback";
		menuItem.data = curIdx;
		menuItem.cb_failed = "no_want";
		menuItem.callback = "give_selected_reward";

		DebugPrint("add_rewards reg.mitem.title reg.mitem.callback");

		RegisterMenuItem(menuItem);
	}

	// give_selected_reward
	void OnGiveSelectedReward(CBasePlayer@ player = null, int rewardIndex = 0)
	{
		DebugPrint("give_selected_reward " + NameOf(player) + " " + rewardIndex);
		N_REWARDS_GIVEN += 1.0f;
		Offer(player, GetToken(REWARD_LIST, rewardIndex));
		CallExternal(player, "ext_set_reward", 1);
	}

	// player_accept
	void OnPlayerAccept(CBasePlayer@ player = null)
	{
		OnCycleUp("manual_override");
		CONVO_TYPE = "none";
		QUEST_WINNER = EntityId(player);
		PlayAnim("critical", "yes");
		SayText("Your assistance is greatly appreciated! Now stand-fast and be ready... I'm sure they've caught our scent by now.");
		PlaySound(0, 10, "voices/jerdid/Jerdid_5.wav");
		IN_BATTLE = true;
		UseTrigger("wolves_go");
		SetInvincible(false);
		SetRoam(true);
	}

	// player_deny
	void OnPlayerDeny()
	{
		NO_HAIL = false;
		CONVO_TYPE = "none";
		PlayAnim("critical", "eye_wipe");
		SayText("I... Undestand... A powerful warrior like yourself must be busy... Quite often, I suppose...");
		PlaySound(0, 10, "voices/jerdid/Jerdid_4.wav");
		SetRoam(true);
	}

	// wolf_raid_over
	void OnWolfRaidOver()
	{
		MAX_REWARDS_TOGIVE = ActivePlayerCount();
		BATTLE_OVER = true;
		NO_HAIL = false;
		OnNpcatkClearTargets();
		BATTLLE_OVER = true;
		IN_BATTLE = false;
		FORCED_MOVE_DEST = true;
		SetMoveDest(QUEST_WINNER, 32);
		SetInvincible(true);
		CallEventDelayed(1.0f, "hunt_quest_winner_loop");
	}

	// hunt_quest_winner_loop
	void OnHuntQuestWinnerLoop()
	{
		if (Truthy(ScriptVarOf(QUEST_WINNER, "PLR_GOT_REWARD")))
			return;
		CallEventDelayed(1.0f, "hunt_quest_winner_loop");
		NPC_FORCED_MOVEDEST = true;
		if (Truthy(LegacyFunction("cansee", QUEST_WINNER, 128)))
		{
			if (!SAID_REWARD)
			{
				SAID_REWARD = true;
				CallEventDelayed(0.1f, "give_reward");
			}
		}
		else
		{
			SetMoveDest(QUEST_WINNER, 32);
		}
	}

	// give_reward
	void OnGiveReward(CBasePlayer@ player = null)
	{
		bool exitSub = false;
		if (N_REWARDS_GIVEN >= MAX_REWARDS_TOGIVE)
		{
			SayText("Sorry, I've nothing left to offer.");
			PlaySound(0, 10, "voices/jerdid/Jerdid_7.wav");
			exitSub = true;
		}
		if (exitSub)
			return;

		NPC_FORCED_MOVEDEST = true;
		PlayAnim("critical", "yes");
		if (IsAlive(player))
			SetMoveDest(@player, 9999);
		CallEventDelayed(2.0f, "fix_anims");

		if (Truthy(ScriptVarOf(player, "PLR_GOT_REWARD")))
			return;
		SayText("Thank you ever-so-much for your assistance! Please select a reward for your aid.");
		PlaySound(0, 10, "voices/jerdid/Jerdid_6.wav");
		CONVO_TYPE = "give_list";
		NO_HAIL = true;
		if (IsAlive(player))
			MENU_TARGET = EntityId(player);
		if (!IsAlive(player))
			MENU_TARGET = QUEST_WINNER;
		CallEventDelayed(0.1f, "send_menu");
	}

	// send_menu
	void OnSendMenu()
	{
		OpenMenu(MENU_TARGET);
	}

	// fix_anims
	void OnFixAnims()
	{
		// ms_npcscript seems to be fubar'ing my anims, reset after call
		SetMoveAnim("walk");
		SetIdleAnim("idle1");
		PlayAnim("once", "idle1");
	}

	// game_menu_cancel
	void OnGameMenuCancel(CBasePlayer@ player = null)
	{
		NO_HAIL = false;
		CONVO_TYPE = "none";
	}

	// attack_1
	void OnAttack12()
	{
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_HITCHANCE);
	}

	// npc_suicide
	void OnNpcSuicide(string suicideMode = "")
	{
		DebugPrint("No suicide for me");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/royal_guard1.mdl");
		CallEventDelayed(10.0f, "GAdventurer_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		GAdventurer_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseChat_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "add_rewards") { OnAddRewards(); return true; }
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "chat_loop") { OnChatLoop(); return true; }
		if (name == "fix_anims") { OnFixAnims(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_menu_cancel") { OnGameMenuCancel(PlayerParam(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "give_reward") { OnGiveReward(PlayerParam(params, 0)); return true; }
		if (name == "give_selected_reward") { OnGiveSelectedReward(PlayerParam(params, 0), Int(Param(params, 1))); return true; }
		if (name == "hunt_quest_winner_loop") { OnHuntQuestWinnerLoop(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_suicide") { OnNpcSuicide(Param(params, 0)); return true; }
		if (name == "open_menu") { OnOpenMenu(); return true; }
		if (name == "player_accept") { OnPlayerAccept(PlayerParam(params, 0)); return true; }
		if (name == "player_deny") { OnPlayerDeny(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "send_menu") { OnSendMenu(); return true; }
		if (name == "stay_invuln_damnit") { OnStayInvulnDamnit(); return true; }
		if (name == "wolf_raid_over") { OnWolfRaidOver(); return true; }
		if (name == "GAdventurer_Timer") { GAdventurer_Timer(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
