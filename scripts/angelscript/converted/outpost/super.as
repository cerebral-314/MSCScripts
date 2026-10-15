#pragma context server

// Converted from outpost/super.script by msc_transpiler.
// Supervisor, by Thothie for EvilSquirrles 'outpost' from edana/edrin

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_guard_friendly_new.as"
#include "converted/monsters/base_chat.as"

[script "outpost/super"]
class Super : BaseMonsterNewScript, BaseGuardFriendlyNew, BaseChat
{
	// Constants
	string SOUND_ATTACK = "weapons/cbar_miss1.wav";
	string ATTACK_HITCHANCE = "90%";
	string ATTACK_DAMAGE = "35";
	string SOUND_WARCRY = "scientist/cough.wav";
	string SOUND_PAINCRY1 = "scientist/sci_fear7.wav";
	string SOUND_PAINCRY2 = "scientist/sci_fear11.wav";
	string SOUND_PAINCRY3 = "scientist/sci_fear5.wav";
	string SOUND_PAINCRY4 = "scientist/scream01.wav";
	string SOUND_PAINCRY5 = "scientist/canttakemore.wav";
	int PATROL_RANGE = 384;
	int BG_ROAM = 0;
	bool NO_RUMOR = true;
	bool NO_JOB = true;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool CAN_TALK = false;
	float GIVE_INTRO_STEP = 0.0f;
	int REQ_QUEST_NOTDONE = 0;
	bool WAR_INPROGRESS = false;
	bool NO_HAIL = false;
	bool GAVE_INTRO = false;
	string QUEST_WINNER = "QUEST_WINNER";
	float REWARD_STEP = 0.0f;
	bool RECIEVED_HEAD = false;
	bool DID_WARCRY = false;
	bool GOING_HOME = false;
	bool MADE_IT_HOME = false;
	bool ATTACK_ALERT = false;
	bool DID_PAINCRY = false;
	bool OH_IT_IS_ON = false;

	// Variables declared by included files, with the value they start with in this script
	Super()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		ATTACK_RANGE = 85.0f;
		MOVE_RANGE = "75";
		ATTACK_HITRANGE = 150.0f;
		SOUND_DEATH = "scientist/scream21.wav";
	}

	// unnamed block (first think)
	void Super_FirstThink()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		ANIM_ATTACK = "swordswing1_L";
		ANIM_DEATH = "dieforward";
		CAN_TALK = true;
		GIVE_INTRO_STEP = 0.0f;
		NO_STUCK_CHECKS = "1";
	}

	// game_damaged
	string Super_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		if (!IsPlayer(attacker))
			return result;
		result = AppendResult(result, "0");
		return result;
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared

		InfoMessage("all", "FAILURE!", "THE OUTPOST SUPERVISOR HAS DIED! You will not be allowed to proceed to the next area.");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BaseGuardFriendlyNew_OnNpcSpawn(npc); // monsters/base_guard_friendly_new

		SetUniqueName("outpost_super");
		SetNoPush(true);
		SetHealth(600);
		SetGold(10);
		SetName("Vadrel, the outpost supervisor");
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false);
		SetModel("npc/guard2.mdl");
		SetModelBody(1, 2);
		SetMoveAnim("walk");
		SetSkillLevel(0);
		SetStepSize(0);
		LegacyCommand("maxslope", 10);

		SetDamageTaken("all", 0.5f);

		// invincible	1
		REQ_QUEST_NOTDONE = 1;
		SetGlobal("WARBOSS_DEAD", 0);
		WAR_INPROGRESS = false;

		CallEventDelayed(1.0f, "stay_home");

		SetInvincible(true);
		SetDamageTaken("stun", 0);

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "howdy", "hay", "yo", "waddup", "wassup", "j0");
		CatchSpeech("say_yes", "yes", "yah", "yeah", "sure", "ok", "yup", "on it", "roger", "rodger", "ja", "hai", "right away");
		CatchSpeech("say_no", "no", "nah", "uh", "nein");
	}

	// npcatk_settarget
	void OnNpcatkSettarget(string target = "", string debug = "")
	{
		BaseNpcAttackNew_OnNpcatkSettarget(target, debug); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSettarget(target, debug); // monsters/base_monster_shared

		CAN_TALK = false;

		if (!DID_WARCRY)
		{
			PlaySound(0, 10, SOUND_WARCRY);
			DID_WARCRY = true;
		}
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		BaseGuardFriendlyNew_OnNpcatkTargetvalidate(target); // monsters/base_guard_friendly_new
		Vector3 targetOrg = OriginOf(target);

		if (!(Distance(targetOrg, NPC_SPAWN_LOC) >= PATROL_RANGE))
			return;

		// dbg temp target too far ignoring
		NPCATK_TARGET = "unset";
	}

	// npcatk_clear_targets
	void OnNpcatkClearTargets(string reason = "")
	{
		BaseNpcAttackNew_OnNpcatkClearTargets(reason); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkClearTargets(reason); // monsters/base_monster_shared
		BaseMonsterShared_OnNpcatkClearTargets_2(reason); // monsters/base_monster_shared
		BaseGuardFriendlyNew_OnNpcatkClearTargets(reason); // monsters/base_guard_friendly_new

		CAN_TALK = true;
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new

		CAN_TALK = true;
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, Super_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		if (GAVE_INTRO && !WAR_INPROGRESS)
		{
			menuItem.title = "Accept";
			menuItem.type = "callback";
			menuItem.callback = "say_yes";
			RegisterMenuItem(menuItem);
		}

		if (!Truthy(GetVar("WARBOSS_DEAD")))
			return;
		if (RECIEVED_HEAD)
			return;

		if (Truthy(ItemExists(player, "item_warbosshead")))
		{
			menuItem.title = "Offer Graznux's Head";
			menuItem.type = "payment"; // _silent means don't say what's missing (also crashes)
			menuItem.data = "item_warbosshead";
			menuItem.callback = "gave_head";
			RegisterMenuItem(menuItem);
		}
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		OnSayHi();
	}

	// stay_home
	void OnStayHome()
	{
		// this will be possible with NPC_PATROL_RANGE later
		if (Distance(MyOrigin(), NPC_SPAWN_LOC) > 384.0f)
		{
			OnNpcatkClearTargets();
			if (!GOING_HOME)
				OnForceGoHome();
			SetMoveDest(NPC_SPAWN_LOC, 1);
			OnNpcatkSuspendAi("2.0");
		}
		CallEventDelayed(1.0f, "stay_home");
	}

	// attack_1
	// called from model ANIM_ATTACK (swordswing1_L) at frame 10
	void OnAttack12()
	{
		PlaySound(0, 10, SOUND_ATTACK);
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_HITCHANCE);
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (!CAN_TALK)
			return;

		OnNpcatkSetmovedest(ENT_LASTSPOKE, "9999");

		if (Truthy(GetVar("WARBOSS_DEAD")))
		{
			PlayAnim("once", "yes");
			SayText("Thank you again for your help... Travel safely.");
		}

		if (Truthy(GetVar("WARBOSS_DEAD")))
			return;

		if (WAR_INPROGRESS)
		{
			PlayAnim("once", "fear1");
			SayText("What are you doing here? Protect the outpost!");
		}

		if (WAR_INPROGRESS)
			return;

		if (GIVE_INTRO_STEP == 7.0f)
			GIVE_INTRO_STEP = 0.0f;
		if (GIVE_INTRO_STEP != 0.0f)
			return;
		OnGiveIntro();
		PlayAnim("once", "lean");
	}

	// give_intro
	void OnGiveIntro()
	{
		float stepDelay = 0.0f;

		if (!CAN_TALK)
			return;

		GIVE_INTRO_STEP += 1.0f;

		if (GIVE_INTRO_STEP == 1.0f)
		{
			NO_HAIL = true;
			GAVE_INTRO = true;
			// saytext Welcome to our forgotten outpost, traveller.
			stepDelay = 0.1f; // skipping this bit as we've no voice file
		}
		if (GIVE_INTRO_STEP == 2.0f)
		{
			SayText("Hail. For the longest time, we have struggled here against the Orcish invaders from the south.");
			PlaySound(0, 10, "voices/foutpost/Vadrel_1.wav");
			stepDelay = 4.51f;
		}
		if (GIVE_INTRO_STEP == 3.0f)
		{
			PlayAnim("once", "whiteboard");
			SayText("King Ardelleron just recently allowed us the materials for the wall.");
			PlaySound(0, 10, "voices/foutpost/Vadrel_2.wav");
			stepDelay = 4.07f;
		}
		if (GIVE_INTRO_STEP == 4.0f)
		{
			SayText("However, even with the wall, our numbers are diminishing and the King has yet to send more troops.");
			PlaySound(0, 10, "voices/foutpost/Vadrel_3.wav");
			stepDelay = 4.7f;
		}
		if (GIVE_INTRO_STEP == 5.0f)
		{
			SayText("We can't hold this position any longer... or at least... not without help...");
			PlaySound(0, 10, "voices/foutpost/Vadrel_4.wav");
			stepDelay = 4.04f;
		}
		if (GIVE_INTRO_STEP == 6.0f)
		{
			SayText("If you help us to stop this invasion, I will reward you most graciously.");
			PlaySound(0, 10, "voices/foutpost/Vadrel_5.wav");
			stepDelay = 3.60f;
		}
		if (GIVE_INTRO_STEP == 7.0f)
		{
			PlayAnim("critical", "converse2");
			SayText("Do you accept?");
			PlaySound(0, 10, "voices/foutpost/Vadrel_6.wav");
		}

		if (!(GIVE_INTRO_STEP < 7.0f))
			return;

		CallEventDelayed(stepDelay, "give_intro");
	}

	// say_no
	void OnSayNo(CBasePlayer@ player = null)
	{
		if (!CAN_TALK)
			return;
		if (WAR_INPROGRESS)
			return;

		PlayAnim("once", "pull_needle");
		SayText("Then begone from our lands, as another attack is imminent!");
		PlaySound(0, 10, "voices/foutpost/Vadrel_7.wav");

		UseTrigger("player_refused");
	}

	// say_yes
	void OnSayYes(CBasePlayer@ player = null)
	{
		if (!CAN_TALK)
			return;
		if (WAR_INPROGRESS)
			return;

		GIVE_INTRO_STEP = 8.0f;

		UseTrigger("player_accepted");

		SetInvincible(false);

		WAR_INPROGRESS = true;

		CallEventDelayed(10.0f, "i_r_super_lure");

		PlayAnim("once", "pondering2");

		SayText("Ah! Wonderful. If you would, there is a guard tower where you can watch for them coming.");
		PlaySound(0, 10, "voices/foutpost/Vadrel_8.wav");
	}

	// gave_head
	// ^_^
	void OnGaveHead(CBasePlayer@ winner = null)
	{
		REQ_QUEST_NOTDONE = 0;

		ReceiveOffer("accept");
		QUEST_WINNER = EntityId(winner);
		REWARD_STEP = 0.0f;
		if (!Truthy(GetVar("WARBOSS_DEAD")))
			return;
		if (RECIEVED_HEAD)
			return;

		UseTrigger("gave_head");

		SetInvincible(true);

		REWARD_STEP = 0.0f;
		CallEventDelayed(0.1f, "reward_intro");
	}

	// reward_intro
	void OnRewardIntro()
	{
		float stepDelay = 0.0f;

		RECIEVED_HEAD = true;

		REWARD_STEP += 1.0f;

		if (REWARD_STEP == 1.0f)
		{
			PlayAnim("once", "dryhands");
			SayText("Well done, travellers. Please, take a look around the armory and take what you wish.");
			PlaySound(0, 10, "voices/foutpost/Vadrel_9.wav");
			// offer QUEST_WINNER key_treasury
			stepDelay = 4.15f;
		}

		if (REWARD_STEP == 2.0f)
		{
			SayText("No shoving now! There's enough for everyone!");
			PlaySound(0, 10, "voices/foutpost/Vadrel_10.wav");
		}

		// if ( REWARD_STEP == 3 ) saytext The magic in the key will cause the key to crumble after the first use.
		if (!(REWARD_STEP < 2.0f))
			return;

		CallEventDelayed(stepDelay, "reward_intro");
	}

	// force_go_home
	void OnForceGoHome()
	{
		if (MADE_IT_HOME)
			return;

		GOING_HOME = true;

		CallEventDelayed(1.0f, "force_go_home");
		Vector3 myPos = OriginOf(ENT_ME);

		// //dbg GoingHome distance game.monster.origin vs MY_POS
		if (Eval("game.monster.movedest.origin") != Text(MY_GUARD_POST))
			OnNpcatkSetmovedest(Text(MY_GUARD_POST), "1");

		if (Distance(myPos, MY_GUARD_POST) < 10.0f && !OH_IT_IS_ON)
		{
			// dbg made it home
			myPos = OriginOf(ENT_ME);
			SetMoveDest("none");
			SetRoam(BG_ROAM != 0);
			SetMoveSpeed(BG_ROAM);
			SetMoveAnim(ANIM_IDLE);
			SetAngle("face", MY_ORG_ANGLES);
			MADE_IT_HOME = true;
			GOING_HOME = false;
		}
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		float hurtThreshold = MyMaxHealth() * 0.75f;

		if (!ATTACK_ALERT)
		{
			InfoMessage("all", "CRITICAL_NPC", "The outpost supervisor is under attack! Save him!");
			ATTACK_ALERT = true;
			CallEventDelayed(5.0f, "reset_attack_alert");
		}

		if (!(MyHealth() < hurtThreshold))
			return;

		if (!DID_PAINCRY)
		{
			PlayRandomSound(0, 10, SOUND_PAINCRY1, SOUND_PAINCRY2, SOUND_PAINCRY3, SOUND_PAINCRY4, SOUND_PAINCRY5);
			DID_PAINCRY = true;
			CallEventDelayed(5.0f, "reset_paincry");
		}
	}

	// reset_attack_alert
	void OnResetAttackAlert()
	{
		ATTACK_ALERT = false;
	}

	// reset_paincry
	void OnResetPaincry()
	{
		DID_PAINCRY = false;
	}

	// baseguard_clear_targs
	void OnBaseguardClearTargs()
	{
		OH_IT_IS_ON = false;

		if (!BG_NO_GO_HOME)
		{
			SetAngle("face_origin", MY_GUARD_POST);
			OnNpcatkSetmovedest(Text(MY_GUARD_POST), "1");
		}
		MADE_IT_HOME = false;
		OnGoingHome();
	}

	// i_r_super_lure
	void OnIRSuperLure()
	{
		CallExternal("all", "super_lure", self, "orc");
		CallEventDelayed(5.0f, "i_r_super_lure");
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

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BaseGuardFriendlyNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_guard_friendly_new
	}

	// npcatk_setmovedest
	void OnNpcatkSetmovedest(string destination = "", string range = "")
	{
		BaseNpcAttackNew_OnNpcatkSetmovedest(destination, range); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkSetmovedest(destination, range); // monsters/base_anti_stuck
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	void OnLStepDelay() {} // L_STEP_DELAY

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/guard2.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Super_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseGuardFriendlyNew_FirstThink();
		BaseChat_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "baseguard_clear_targs") { OnBaseguardClearTargs(); return true; }
		if (name == "force_go_home") { OnForceGoHome(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "gave_head") { OnGaveHead(PlayerParam(params, 0)); return true; }
		if (name == "give_intro") { OnGiveIntro(); return true; }
		if (name == "i_r_super_lure") { OnIRSuperLure(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npcatk_clear_targets") { OnNpcatkClearTargets(Param(params, 0)); return true; }
		if (name == "npcatk_settarget") { OnNpcatkSettarget(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "reset_attack_alert") { OnResetAttackAlert(); return true; }
		if (name == "reset_paincry") { OnResetPaincry(); return true; }
		if (name == "reward_intro") { OnRewardIntro(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_no") { OnSayNo(PlayerParam(params, 0)); return true; }
		if (name == "say_yes") { OnSayYes(PlayerParam(params, 0)); return true; }
		if (name == "stay_home") { OnStayHome(); return true; }
		return BaseGuardFriendlyNew_DispatchEvent(name, params)
			|| BaseChat_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
