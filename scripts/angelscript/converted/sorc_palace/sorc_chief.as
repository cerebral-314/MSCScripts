#pragma context server

// Converted from sorc_palace/sorc_chief.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_chat.as"

[script "sorc_palace/sorc_chief"]
class SorcChief : BaseMonsterNewScript, BaseChat
{
	// Constants
	string ANIM_SIT = "on_chair";
	bool NO_CLOSE_MOUTH = true;
	float CHAT_DELAY = 6.0f;
	bool NO_CHAT = true;
	int BARRIER_RAD = 64;
	float DMG_BARRIER = 100.0f;
	string SOUND_DRAW_WEAPON = "weapons/swords/sworddraw.wav";
	float MIN_TELEPORT_DELAY = 15.0f;
	bool NPC_USES_LIGHTS = true;
	string ANIM_WARCRY = "warcry";
	string ANIM_SWIPE = "swordswing1_L";
	string ANIM_SMASH = "battleaxe_swing1_L";
	string ANIM_KICK = "kick";
	string ANIM_PARRY = "shielddeflect1";
	string ANIM_HOP = "battleaxe_swing1_L";
	string ATTACK_HITCHANCE = "90%";
	float DMG_SLASH = 0.0f;
	int DMG_SMACK = 0;
	string DMG_SMASH = "DMG_SMASH";
	string DMG_KICK = "DMG_KICK";
	int DMG_LBLAST = 100;
	int DMG_LSTORM = 100;
	int DUR_LSTORM = 30;
	float FREQ_TORNADO = 0.0f;
	int FREQ_LSTORM = 0;
	int FREQ_LBLAST = 0;
	float FREQ_THROW = 0.0f;
	float FREQ_SPECIAL = 0.0f;
	float FREQ_TELEPORT = 0.0f;
	int FREQ_TELEPORT_FAST = 0;
	float FREQ_KICK = 10.0f;
	string SOUND_WARCRY = "monsters/troll/trollidle.wav";
	string SOUND_STRUCK1 = "body/armour1.wav";
	string SOUND_STRUCK2 = "body/armour2.wav";
	string SOUND_STRUCK3 = "body/armour3.wav";
	string SOUND_HIT = "voices/orc/hit.wav";
	string SOUND_HIT2 = "voices/orc/hit2.wav";
	string SOUND_HIT3 = "voices/orc/hit3.wav";
	string SOUND_PAIN = "monsters/orc/pain.wav";
	string SOUND_WARCRY1 = "monsters/orc/battlecry.wav";
	string SOUND_ATTACK1 = "voices/orc/attack.wav";
	string SOUND_ATTACK2 = "voices/orc/attack2.wav";
	string SOUND_ATTACK3 = "voices/orc/attack3.wav";
	string SOUND_HELP = "voices/orc/help.wav";
	string SOUND_TELE = "magic/teleport.wav";
	float VAMPIRE_RATIO = 0.1f;

	// Variables (an unset .script variable reads as its own name)
	bool COMBAT_MODE = false;
	bool NPC_PROX_ACTIVATE = false;
	string ANIM_FLINCH = "ANIM_FLINCH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	float FREQ_LEAP = 0.0f;
	bool SWORD_ATTACK = false;
	int JUMP_FWD_DIST = 0;
	float CUR_SPECIAL = 0.0f;
	Vector3 CHIEF_SPAWN = Vector3();
	string MOVE_TARG = "MOVE_TARG";
	float N_BLOOD_DRINKERS = 0.0f;
	string NPC_PROXACT_RANGE = "NPC_PROXACT_RANGE";
	string NPC_PROXACT_EVENT = "NPC_PROXACT_EVENT";
	bool NPC_PROXACT_IFSEEN = false;
	bool NPC_PROXACT_FOV = false;
	CBasePlayer@ BLOOD_ID = null;
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_STEP2 = "CHAT_STEP2";
	string CHAT_STEP3 = "CHAT_STEP3";
	int CHAT_STEPS = 0;
	bool FRIEND_FOE_ANSWERED = false;
	string CHAT_MODE = "CHAT_MODE";
	string CHAT_STEP4 = "CHAT_STEP4";
	bool ESCORT_ACTIVE = false;
	bool BARRIER_ON = false;
	float BARRIER_NEXT_REFRESH = 0.0f;
	string BARRIER_IDX = "BARRIER_IDX";
	Vector3 BURST_ORIGIN = Vector3();
	bool BURST_OVERRIDE = false;
	string REPULSE_LIST = "REPULSE_LIST";
	string MREPELL_LIST = "MREPELL_LIST";
	bool AM_STANDING = false;
	bool FACE_PLAYERS = false;
	Vector3 DEFAULT_TELE_POINT = Vector3();
	bool CYCLES_STARTED = false;
	float LAST_SWORD_HIT = 0.0f;
	bool KICK_DELAY = false;
	bool LEAP_DELAY = false;
	bool DOUBLE_FOR = false;
	bool DOUBLE_UP = false;
	bool AM_LEAPING = false;
	string LSTORM_TARGS = "LSTORM_TARGS";
	float N_STORMS = 0.0f;
	bool LOC_LSTORM1 = false;
	bool LOC_LSTORM2 = false;
	float LSTORM_LOOPCOUNT = 0.0f;
	CBaseEntity@ ID_LSTORM1 = null;
	CBaseEntity@ ID_LSTORM2 = null;
	float N_TELES = 0.0f;
	string TELE_ID1 = "TELE_ID1";
	string TELE_ID2 = "TELE_ID2";
	string TELE_ID3 = "TELE_ID3";
	string TELE_ID4 = "TELE_ID4";
	float LAST_TELE = 0.0f;
	string PLAYER_LIST = "PLAYER_LIST";
	int FOUND_NEAR_TARGET = 0;
	int SEARCH_RAD = 0;
	Vector3 TELE_DEST = Vector3();
	Vector3 TELE_ANGS = Vector3();
	string NEW_TARGET = "NEW_TARGET";
	float RENDER_COUNT = 0.0f;
	float HALF_HEALTH = 0.0f;
	bool ON_LODAGOND = false;
	bool PLAYERS_NEAR = false;
	bool PLAYERS_INRANGE = false;
	float PNEAR_LOOP_COUNT = 0.0f;
	bool AM_UNARMED = false;
	string BLOOD_DRINKER_ID = "BLOOD_DRINKER_ID";

	// Variables declared by included files, with the value they start with in this script
	SorcChief()
	{
		NPC_BOSS_REGEN_RATE = 0.0f;
		NPC_BOSS_RESTORATION = 0.3f;
		ANIM_IDLE = "idle1";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		SOUND_DEATH = "voices/orc/die.wav";
	}

	// unnamed block (first think)
	void SorcChief_FirstThink()
	{
		COMBAT_MODE = false;

		NPC_PROX_ACTIVATE = true; // suspend AI on spawn, wait for player to come..

		if (ToLowerCase(MapName()) == "shad_palace")
		{
			NPC_GIVE_EXP = 10000.0f;
			NPC_IS_BOSS = true;
		}
		ANIM_IDLE = "idle1";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_FLINCH = "flinch";
		ANIM_ATTACK = "swordswing1_L";
		ANIM_DEATH = "die_fallback";

		CAN_FLINCH = "1";
		ATTACK_MOVERANGE = 32.0f;
		MOVE_RANGE = "32";
		ATTACK_RANGE = 60.0f;
		ATTACK_HITRANGE = 120.0f;
		FREQ_LEAP = 5.0f;
	}

	// npc_post_spawn
	void SorcChief_OnNpcPostSpawn()
	{
		SetMenuAutoOpen(false);

		Vector3 newOrg = OriginOf(ENT_ME);
		newOrg += RelativePosition(Vector3(0, Float(Eval("game.monster.angles.yaw")), 0), Vector3(0, 4, 0));
		SetMoveDest(newOrg, 0);
		SetOrigin(ENT_ME, newOrg);
	}

	// game_damaged
	string SorcChief_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		if (COMBAT_MODE)
			return result;
		result = AppendResult(result, "0");
		return result;
	}

	// warcry_done
	void SorcChief_OnWarcryDone()
	{
		SetModelBody(2, 8);
		PlaySound(0, 10, SOUND_DRAW_WEAPON);
	}

	// game_damaged_other
	// ===========================================================================================
	// ===========================================================================================
	// ===========================================================================================
	// ================== From monsters/sorc_chief1
	// PARAM1=target_hit PARAM2=dmg
	string SorcChief_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		// //dbg game_damaged_other $get(PARAM1,name) PARAM2
		if (SWORD_ATTACK)
		{
			SWORD_ATTACK = false;
			AddVelocity(target, RelativeVelocity(Vector3(-100, 130, 120)));
			if (MyHealth() < MyMaxHealth())
			{
				float hpToGive = damage * VAMPIRE_RATIO;
				GiveHealth(VAMPIRE_RATIO);
				Effect("glow", ENT_ME, Vector3(0, 255, 0), 96, 0.5f, 0.5f);
				// //dbg vampire_result game.monster.hp
				PlaySound(0, 10, "player/heartbeat_noloop.wav");
			}
		}
		return result;
	}

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type
	string SorcChief_OnGameDamaged_2(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		// dbg game_damaged game.monster.hp $get(PARAM1,name) PARAM2 PARAM3
		if (!COMBAT_MODE)
			return result;

		if (MyHealth() < HALF_HEALTH)
		{
			JUMP_FWD_DIST = 500;
			FREQ_LEAP = 0.1f;
		}

		CBaseEntity@ hitBy = attacker;
		if (damage > 30.0f && RangeTo(hitBy) < ATTACK_HITRANGE && RandomInt(1, 3) == 1 && !LEAP_DELAY)
		{
			LEAP_DELAY = true;
			CallEventDelayed(FREQ_LEAP, "leap_delay_reset");
			OnLeapAway(EntityId(hitBy));
		}
		return result;
	}

	// warcry_done
	void SorcChief_OnWarcryDone_2()
	{
		CAN_FLINCH = "1";
		if (SUSPEND_AI)
			OnNpcatkResumeAi();
	}

	// unnamed block (timer)
	void SorcChief_Timer()
	{
		CallEventDelayed(Random(8, 15), "SorcChief_Timer");
		if (SUSPEND_AI)
			return;
		if (NPCATK_TARGET == "unset")
			return;
		int leapType = RandomInt(1, 4);
		if (leapType < 4)
			OnLeapAt(NPCATK_TARGET);
		if (leapType == 4)
			OnLeapRandom();
	}

	// unnamed block (timer)
	void SorcChief_Timer2()
	{
		CallEventDelayed(1.1f, "SorcChief_Timer2");
		if (!(STUCK_COUNT > 4.0f))
			return;
		OnDoTeleport("stuck_count");
	}

	// npc_post_spawn
	void SorcChief_OnNpcPostSpawn_2()
	{
		HALF_HEALTH = Divide(MyMaxHealth(), 2.0f);

		string mapName = ToLowerCase(MapName());
		if (mapName != "lodagond-1")
			return;
		ON_LODAGOND = true;
	}

	// game_takedamage
	string SorcChief_OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		string result = "";
		return result;
	}

	// unnamed block (timer)
	void SorcChief_Timer3()
	{
		CallEventDelayed(20.0f, "SorcChief_Timer3");
		// if I've not thwacked anyone for a bit, teleport
		// - but not if I can see him almost in range
		if (!COMBAT_MODE)
			return;

		if (!(RangeTo(NPCATK_TARGET) > 256.0f))
			return;

		// - or if I teleported very recently
		float lastTeleDiff = GameTime() - LAST_TELE;
		if (!(lastTeleDiff > 5.0f))
			return;

		float lastHitDiff = GameTime() - LAST_SWORD_HIT;
		if (!(lastHitDiff > 20.0f))
			return;
		OnDoTeleport("stuck_count", "no_hits");
	}

	// unnamed block (timer)
	void SorcChief_Timer4()
	{
		CallEventDelayed(1.0f, "SorcChief_Timer4");
		if (AM_STANDING)
			return;
		if (Text(OriginOf(ENT_ME)) == Text(CHIEF_SPAWN))
			return;
		SetOrigin(ENT_ME, CHIEF_SPAWN);
		SetGravity(0);
	}

	// game_death
	// ====================== New Death Sequence for Sorc_Palace
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared

		UseTrigger("towndoors01", "thronesecr_exit");

		if (Exists(BLOOD_DRINKER_ID))
			CallExternal(BLOOD_DRINKER_ID, "ext_remove");
		SetModelBody(2, 0);
		CallExternal(GetVar("GAME_MASTER"), "gm_fade", self);
		OnRepellBurst(OriginOf(ENT_ME), BARRIER_RAD, 0);
		ClientEvent("new", "all", "sorc_palace/sorc_chief_cl", IndexOf(ENT_ME), 128, Vector3(255, 0, 0), 3.0f, 1);
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, SorcChief_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		SorcChief_OnNpcPostSpawn();
		SorcChief_OnNpcPostSpawn_2();
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetUniqueName("the_warchief");

		SetName("Runegahr the Warchief");
		SetRace("orc");

		SetHealth(18000); // use a map side 2.0 dmg/hp multiplier
		SetDamageTaken("all", 0.5f);
		SetDamageTaken("fire", 0.5f);
		SetDamageTaken("cold", 0.25f);
		SetDamageTaken("lightning", 0);
		SetDamageTaken("stun", 0.25f);

		SetHearingSensitivity(10);

		SetInvincible(true);

		SetModel("monsters/sorc.mdl");
		SetModelBody(0, 2); // body: 0=bare 1=bloody_shirt 2=gold_armor 3=archer
		SetModelBody(1, 3); // head: 0=hat_horns 1=hat_spiked 2=lizardskin_horned 3=gold_chieften 4=lizard_cap
		SetModelBody(2, 0); // weapon: 0=unarmed 1=axe 2=bow 3=steel_bow 4=sword 5=great_axe 6=sword_sheild 8=yellow_axe 9=blooddrinker
		SetStat("parry", 150);
		SetWidth(32);
		SetHeight(96);

		SetIdleAnim(ANIM_SIT);
		SetMoveAnim(ANIM_SIT);

		SetMenuAutoOpen(false);

		SetRoam(false);

		SetGravity(0);

		SetFly(true);

		SetSayTextRange(4096);

		SWORD_ATTACK = false;
		JUMP_FWD_DIST = 250;
		CUR_SPECIAL = 0.0f;
		CallEventDelayed(1.0f, "get_teleporters");

		CallEventDelayed(0.1f, "check_for_blood");

		OnNpcatkSuspendAi();

		CHIEF_SPAWN = OriginOf(ENT_ME);
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		BaseNpcAttackNew_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_monster_shared
		if (!FACE_PLAYERS)
			return;
		CBaseEntity@ heardId = EntityOf(ENT_LASTHEARD);
		if (!IsPlayer(heardId))
			return;
		if (!(RangeTo(heardId) < 128.0f))
			return;
		SetMoveDest(@heardId, 9999);
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new

		if (CYCLES_STARTED)
			return;
		CYCLES_STARTED = true;
		CallEventDelayed(FREQ_SPECIAL, "do_special");
		CallEventDelayed(60.0f, "do_teleport"); // do first teleport 1 min in, rest are random
		SetRoam(true);
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, SorcChief_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, SorcChief_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// game_parry
	void OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		BaseMonsterShared_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue); // monsters/base_monster_shared
		PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
		if (SUSPEND_AI)
			return;
		if (RandomInt(1, 3) == 1)
			PlayAnim("critical", "shielddeflect1");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;
		if (CHAT_MODE == "friend_foe")
		{
			menuItem.title = "Friend";
			menuItem.type = "callback";
			menuItem.callback = "say_friend";
			RegisterMenuItem(menuItem);

			menuItem.title = "Foe";
			menuItem.type = "callback";
			menuItem.callback = "say_foe";
			RegisterMenuItem(menuItem);
		}
	}

	// ext_nudge
	void OnExtNudge(string target = "")
	{
		MOVE_TARG = target;
		SetMoveDest(target, 0);
		Vector3 newOrg = OriginOf(ENT_ME);
		newOrg += RelativePosition(Vector3(0, Float(Eval("game.monster.angles.yaw")), 0), Vector3(0, 4, 0));
		SetOrigin(ENT_ME, newOrg);
		DebugPrint("ext_nudge " + NameOf(target) + " " + Text(OriginOf(ENT_ME)));
	}

	// check_for_blood
	void OnCheckForBlood()
	{
		SetVar("BD_PLAYER_LIST", GetActivePlayers());
		N_BLOOD_DRINKERS = 0.0f;

		int count = GetTokenCount("BD_PLAYER_LIST");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCheckInventories();
		}
		if (N_BLOOD_DRINKERS != 0.0f)
		{
			SetGlobal("G_SORC_CHIEF_PRESENT", 1);

			// setvard NPC_PROX_ACTIVATE 1 //suspend AI on spawn, wait for player to come..
			NPC_PROXACT_RANGE = "256"; // within this range then activate...
			NPC_PROXACT_EVENT = "player_nears"; // this event.
			NPC_PROXACT_IFSEEN = false; // activate if a player can see me, or targets me, regardless of range
			NPC_PROXACT_FOV = false; // Require player must be in field of vision to activate
		}
	}

	// check_inventories
	void OnCheckInventories()
	{
		CBasePlayer@ curTarg = FindPlayer(GetToken("BD_PLAYER_LIST", loopIteration));
		if (Truthy(ItemExists(curTarg, "swords_blood_drinker")))
		{
			N_BLOOD_DRINKERS += 1.0f;
			if (N_BLOOD_DRINKERS == 1.0f)
				@BLOOD_ID = curTarg;
		}
		if (Truthy(ItemExists(curTarg, "item_tk_swords_blood_drinker")))
		{
			N_BLOOD_DRINKERS += 1.0f;
			if (N_BLOOD_DRINKERS == 1.0f)
				@BLOOD_ID = curTarg;
		}
	}

	// player_nears
	void OnPlayerNears()
	{
		string refRescue = "REF_RESCUE";
		CHAT_STEP1 = "I remember ";
		if (N_BLOOD_DRINKERS > 1.0f)
			refRescue = "some of you";
		else if (PlayerCount() == 1)
			refRescue = "you";
		else if (N_BLOOD_DRINKERS == 1.0f)
			refRescue = NameOf(BLOOD_ID);
		refRescue += "... Aiding... In my escape from Lodagond.";
		CHAT_STEP1 += refRescue;
		CHAT_STEP2 = "So, before I decide whether or not to slay you here and now.";
		CHAT_STEP3 = "I ask you, have you come as [friend] or [foe]?";
		CHAT_STEPS = 3;
		OnChatLoop();
		FRIEND_FOE_ANSWERED = false;

		float chatDelayTotal = (CHAT_STEPS - 1.0f) * CHAT_DELAY + 1.0f;
		DebugPrint("player_nears cdt " + Text(chatDelayTotal));
		CallEventDelayed(chatDelayTotal, "send_ff_menu");

		CatchSpeech("say_friend", "friend");
		CatchSpeech("say_foe", "foe");
	}

	// send_ff_menu
	void OnSendFfMenu()
	{
		SetMenuAutoOpen(true);
		CHAT_MODE = "friend_foe";
		OpenMenu(NPC_PROXACT_PLAYERID);
	}

	// game_menu_cancel
	void OnGameMenuCancel(CBasePlayer@ player = null)
	{
		if (CHAT_MODE != "friend_foe")
			return;
		CallEventDelayed(1.0f, "resend_menu");
	}

	// resend_menu
	void OnResendMenu()
	{
		if (FRIEND_FOE_ANSWERED)
			return;
		OpenMenu(NPC_PROXACT_PLAYERID);
	}

	// say_friend
	void OnSayFriend()
	{
		if (CHAT_MODE == "in_combat")
			SayText("Too late now, coward.");

		DebugPrint("was busy chatting " + Text(BUSY_CHATTING));

		if (BUSY_CHATTING)
			CallEventDelayed(0.1f, "say_friend");
		if (BUSY_CHATTING)
			return;

		if (FRIEND_FOE_ANSWERED)
			return;
		if (CHAT_MODE != "friend_foe")
			return;
		CHAT_MODE = "friend";
		UseTrigger("towndoors01", "thronesecr_exit");
		SetGlobal("G_SORCV_FRIENDLY", 1);
		FRIEND_FOE_ANSWERED = true;

		CHAT_STEP1 = "Very well then...";
		CHAT_STEP2 = "I suppose I should be upset that you slaughtered the palace guard...";
		CHAT_STEP3 = "But, if they couldn't stop you, I suppose they weren't up to the job.";
		CHAT_STEP4 = "I've some more promising recruits lined up in the villa anyways.";
		CHAT_STEPS = 4;
		OnChatLoop();

		float chatDelayTotal = (CHAT_STEPS - 1.0f) * CHAT_DELAY + 4.0f;

		CallEventDelayed(chatDelayTotal, "announce_visitors");
	}

	// announce_visitors
	void OnAnnounceVisitors()
	{
		if (BUSY_CHATTING)
			CallEventDelayed(0.1f, "announce_visitors");
		if (BUSY_CHATTING)
			return;

		PlayMusic("all", "combat", "haunted_desert.mp3");

		OnStandUp();
		CHAT_STEP1 = "Let it be known that ";
		if (PlayerCount() > 1)
		{
			CHAT_STEP1 += "these humans are my guests.";
			CHAT_STEP2 = "They are under MY protection. And you are to treat them as if they were our own.";
			CHAT_STEP3 = "The gates to the villa are to be opened to them...";
			CHAT_STEP4 = "...and I expect them to be allowed to partake in what 'hospitality' we provide therein.";
		}
		if (PlayerCount() == 1)
		{
			CHAT_STEP1 += NameOf(NPC_PROXACT_PLAYERID) + " is my guest.";
			CHAT_STEP2 = "He is under my protection. And you are to treat him as if he was one of us.";
			CHAT_STEP3 = "The gates to the villa are to be opened to him...";
			CHAT_STEP4 = "...and I expect him to be allowed to partake in whatever 'hospitality' we provide therein.";
		}

		CHAT_STEPS = 4;
		OnChatLoop();

		float chatDelayTotal = (CHAT_STEPS - 1.0f) * CHAT_DELAY + 3.0f;
		CallEventDelayed(chatDelayTotal, "get_reply");
	}

	// get_reply
	void OnGetReply()
	{
		CallExternal("all", "sorcs_confirm_order");
	}

	// ext_tell_approach
	// called via map trigger
	void OnExtTellApproach()
	{
		if (!(N_BLOOD_DRINKERS > 0.0f))
			return;
		if (PlayerCount() > 1)
			SayText("Humans! Approach the throne of Runegahr. I wish to speak with thee.");
		else
			SayText("Human! You may approach the throne of Runegahr. I wish to speak with thee.");
	}

	// say_foe
	void OnSayFoe()
	{
		if (BUSY_CHATTING)
			CallEventDelayed(0.1f, "say_foe");
		if (BUSY_CHATTING)
			return;

		CHAT_STEP1 = "So be it.";
		CHAT_STEP2 = "Thuldahr, it is as you hoped. They are yours.";
		CHAT_STEPS = 2;
		OnChatLoop();

		ESCORT_ACTIVE = true;

		CHAT_MODE = "in_combat";

		float chatDelayTotal = CHAT_STEPS;
		// subtract CHAT_DELAY_TOTAL 1
		chatDelayTotal *= CHAT_DELAY;
		chatDelayTotal += 1.0f;
		CallEventDelayed(chatDelayTotal, "begin_the_attack");
	}

	// begin_the_attack
	void OnBeginTheAttack()
	{
		CallExternal("all", "ext_chief_orders_attack");
		OnShieldUp();
	}

	// shield_up
	void OnShieldUp()
	{
		BARRIER_ON = true;
		BARRIER_NEXT_REFRESH = GameTime() + 20.0f;
		// createnpc monsters/summon/barrier $relpos(0,0,0) $get(ent_me,id) 128 1 0
		ClientEvent("new", "all", "sorc_palace/sorc_chief_cl", IndexOf(ENT_ME), BARRIER_RAD, Vector3(255, 0, 0), 20.0f);
		BARRIER_IDX = LastClientScriptId();
		OnBarrierLoop();
	}

	// barrier_loop
	void OnBarrierLoop()
	{
		if (!BARRIER_ON)
			return;
		CallEventDelayed(0.5f, "barrier_loop");
		if (GameTime() > BARRIER_NEXT_REFRESH)
		{
			ClientEvent("update", "all", BARRIER_IDX, "remove_me");
			ClientEvent("new", "all", "sorc_palace/sorc_chief_cl", IndexOf(ENT_ME), BARRIER_RAD, Vector3(255, 0, 0), 20.0f);
			BARRIER_IDX = LastClientScriptId();
			BARRIER_NEXT_REFRESH = GameTime() + 20.0f;
		}

		OnRepellBurst(OriginOf(ENT_ME), BARRIER_RAD, 0);
	}

	// barrier_off
	void OnBarrierOff()
	{
		BARRIER_ON = false;
		ClientEvent("update", "all", BARRIER_IDX, "clear_sprites");
	}

	// repell_burst
	void OnRepellBurst(Vector3 burstOrigin = Vector3(), int radius = 0, int forceBurst = 0)
	{
		BURST_ORIGIN = burstOrigin;
		BURST_OVERRIDE = forceBurst != 0;
		REPULSE_LIST = LegacyFunction("get_tsphere", "enemy", radius, BURST_ORIGIN);
		if (REPULSE_LIST == "none")
			return;
		PlaySound(0, 10, "doors/aliendoor3.wav");
		int count = GetTokenCount(REPULSE_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnRepulseTargets();
		}
		DoDamage(Text(BURST_ORIGIN), radius, DMG_BARRIER, "100%", 0, "reflective", "magic");
	}

	// repulse_targets
	void OnRepulseTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(REPULSE_LIST, loopIteration));
		Vector3 targOrg = OriginOf(curTarg);
		float targAng = AnglesTo(BURST_ORIGIN, targOrg);
		if (!BURST_OVERRIDE)
			SetVelocity(curTarg, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 2000, 110)));
		else
			SetVelocity(curTarg, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 2000, 110)), "override");
	}

	// mild_repell_loop
	void OnMildRepellLoop()
	{
		// to avoid stuckage, model becomes no clip on friendly removal from throne
		// this gentle push keeps players out of the model
		MREPELL_LIST = FindInSphere("any", 64);
		CallEventDelayed(0.5f, "mild_repell_loop");
		if (MREPELL_LIST == "none")
			return;
		int count = GetTokenCount(MREPELL_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnMrepellTargets();
		}
	}

	// mrepell_targets
	void OnMrepellTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(MREPELL_LIST, loopIteration));
		Vector3 targOrg = OriginOf(curTarg);
		float targAng = AnglesTo(MyOrigin(), targOrg);
		SetVelocity(curTarg, RelativeVelocity(Vector3(0, targAng, 0), Vector3(0, 400, 110)), "override");
	}

	// thuld_died
	void OnThuldDied()
	{
		OnCombatModeGo();
	}

	// combat_mode_go
	void OnCombatModeGo()
	{
		OnBarrierOff();
		COMBAT_MODE = true;
		SetMenuAutoOpen(false);
		OnRepellBurst(RelativePosition(Vector3(0, 64, 0)), 128, 1);
		CallEventDelayed(0.5f, "stand_up");
	}

	// stand_up
	void OnStandUp()
	{
		SetGravity(1);
		SetFly(false);
		AM_STANDING = true;

		UseTrigger("chief_stand");

		if (!COMBAT_MODE)
			OnMildRepellLoop();

		SetOrigin(ENT_ME, RelativePosition(Vector3(0, 64, 0)));

		SetIdleAnim(ANIM_IDLE);
		if (COMBAT_MODE)
		{
			SetMoveAnim(ANIM_WALK);
			CallEventDelayed(0.1f, "combat_mode_go2");
		}
		else
		{
			SetMoveAnim(ANIM_IDLE);
			SetSolid("none");
			FACE_PLAYERS = true;
		}
	}

	// combat_mode_go2
	void OnCombatModeGo2()
	{
		DEFAULT_TELE_POINT = OriginOf(ENT_ME);

		PlayAnim("critical", ANIM_WARCRY);
		OnNpcatkResumeAi();
		SetInvincible(false);
		PlaySound(0, 10, "SOUND_WARCY");
		SayText("NOW IT'S MY TURN!");
		SetMoveSpeed(1.5f);
		SetAnimMoveSpeed(1.5f);
		SetAnimFrameRate(1.5f);
		BASE_MOVESPEED = 1.5f;
		BASE_FRAMERATE = "1.5";
		UseTrigger("spawn_throne_escort");
		SetGlobal("G_SORCV_FRIENDLY", 0);
	}

	// warcry_done
	void OnWarcryDone()
	{
		SorcChief_OnWarcryDone();
		SorcChief_OnWarcryDone_2();
	}

	// swing_axe
	// ANIM_SMASH
	void OnSwingAxe()
	{
		if (RangeTo(NPCATK_TARGET) < ATTACK_RANGE)
			LAST_SWORD_HIT = GameTime();

		OnSorcYell();
		// <target>		<range>			<dmg>		<cth>				[type]
		SWORD_ATTACK = true;
		if (!AM_UNARMED)
			OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), DMG_SMASH, ATTACK_HITCHANCE, "slash");
		if (AM_UNARMED)
		{
			SWORD_ATTACK = false;
			OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_SMACK), ATTACK_HITCHANCE, "blunt");
		}
		ANIM_ATTACK = ANIM_SWIPE;
		OnCheckKick();
	}

	// swing_sword
	// ANIM_SWIPE
	void OnSwingSword()
	{
		if (RangeTo(NPCATK_TARGET) < ATTACK_RANGE)
			LAST_SWORD_HIT = GameTime();

		OnSorcYell();
		// <target>		<range>			<dmg>		<cth>				[type]
		if (!AM_UNARMED)
			SWORD_ATTACK = true;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_SLASH), ATTACK_HITCHANCE, "slash");
		if (AM_UNARMED)
		{
			SWORD_ATTACK = false;
			OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_SMACK), ATTACK_HITCHANCE, "blunt");
		}

		if (RandomInt(1, 5) == 1)
			ANIM_ATTACK = ANIM_SMASH;
		OnCheckKick();
	}

	// check_kick
	void OnCheckKick()
	{
		bool exitSub = false;
		if (KICK_DELAY)
			return;
		if (!AM_UNARMED && RandomInt(1, 5) != 1)
			exitSub = true;
		if (exitSub)
			return;
		ANIM_ATTACK = ANIM_KICK;
		KICK_DELAY = true;
		// dbg swing_axe - set kick mode
		if (!AM_UNARMED)
			CallEventDelayed(FREQ_KICK, "reset_kick_delay");
		if (AM_UNARMED) // favor kick when unarmed
			CallEventDelayed(1.0f, "reset_kick_delay");
	}

	// kick_land
	void OnKickLand()
	{
		// dbg kick_land PARAM1
		if (RangeTo(NPCATK_TARGET) < ATTACK_RANGE)
			LAST_SWORD_HIT = GameTime();
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), DMG_KICK, ATTACK_HITCHANCE, "slash");
		ANIM_ATTACK = ANIM_SWIPE;
		if (!(RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE))
			return;
		// callexternal NPCATK_TARGET ext_playsound "player/stomachhit1.wav"
		ApplyEffect(NPCATK_TARGET, "effects/debuff_stun", Random(5, 10), self);
		AddVelocity(NPCATK_TARGET, RelativeVelocity(Vector3(-100, 200, 150)));
	}

	// reset_kick_delay
	void OnResetKickDelay()
	{
		KICK_DELAY = false;
	}

	// sorc_yell
	void OnSorcYell()
	{
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
	}

	// leap_delay_reset
	void OnLeapDelayReset()
	{
		LEAP_DELAY = false;
	}

	// orc_hop
	void OnOrcHop()
	{
		int jumpHeight = 0;

		PlaySound(0, 10, "monsters/orc/attack1.wav");
		if (MyHealth() > HALF_HEALTH)
			jumpHeight = RandomInt(350, 450);
		if (MyHealth() <= HALF_HEALTH)
			jumpHeight = RandomInt(350, 950);

		float jumpFwdDist = JUMP_FWD_DIST;
		float jumpHeightValue = jumpHeight;

		if (DOUBLE_FOR)
		{
			DOUBLE_FOR = false;
			jumpFwdDist *= 2.0f;
		}

		if (DOUBLE_UP)
		{
			DOUBLE_UP = false;
			jumpHeightValue *= 2.0f;
		}

		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, jumpFwdDist, jumpHeightValue)));
	}

	// leap_away
	// <target>
	void OnLeapAway(string target = "")
	{
		AM_LEAPING = true;
		NPC_FORCED_MOVEDEST = true;
		OnNpcatkSuspendAi("1.0");
		SetMoveDest(target, 800, "flee");
		CallEventDelayed(0.1f, "do_leap");
	}

	// leap_random
	void OnLeapRandom()
	{
		AM_LEAPING = true;
		NPC_FORCED_MOVEDEST = true;
		OnNpcatkSuspendAi("1.0");
		int rndRot = RandomInt(0, 359);
		Vector3 leapDest = MyOrigin() + RelativePosition(Vector3(0, rndRot, 0), Vector3(0, 400, 0));
		SetMoveDest(leapDest, ATTACK_MOVERANGE);
		CallEventDelayed(0.1f, "do_leap");
	}

	// leap_at
	// <target>
	void OnLeapAt(string target = "")
	{
		if (AM_LEAPING)
			return;
		AM_LEAPING = true;
		NPC_FORCED_MOVEDEST = true;

		if (IsAlive(NPCATK_TARGET))
		{
			Vector3 targetOrg = OriginOf(NPCATK_TARGET);
			float targetZ = targetOrg.z;
			int myZ = Int(Eval("game.monster.origin.z"));
			if (targetZ > myZ)
			{
				Vector3 vDest = MyOrigin();
				vDest.z = targetOrg.z;
				if (Distance(MyOrigin(), vDest) > 96.0f)
					DOUBLE_UP = true;
			}
			if (Range2DTo(NPCATK_TARGET) > 1600.0f)
				DOUBLE_FOR = true;
		}

		OnNpcatkSuspendAi("1.0");
		SetMoveDest(target, ATTACK_MOVERANGE);
		CallEventDelayed(0.1f, "do_leap");
	}

	// do_leap
	void OnDoLeap()
	{
		PlayRandomSound(0, 10, SOUND_HIT, SOUND_HIT2, SOUND_HIT3);
		PlayAnim("critical", ANIM_HOP);
		CallEventDelayed(0.1f, "orc_hop");
		CallEventDelayed(1.0f, "reset_leaping");
	}

	// reset_leaping
	void OnResetLeaping()
	{
		AM_LEAPING = false;
	}

	// do_lstorm
	void OnDoLstorm()
	{
		// Centralized under do_special
		// local NEXT_TRY FREQ_LSTORM
		// if ( SUSPEND_AI )
		// {
		// //I'm busy doing something else
		// //come back to this later
		// local NEXT_TRY 10.0
		// local ABORT_SPECIAL 1
		// }
		// callevent NEXT_TRY do_lstorm
		// if !ABORT_SPECIAL
		// make up to 2 lighting storms
		CAN_FLINCH = "0";
		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_WARCRY);
		PlaySound(0, 10, SOUND_WARCRY);
		OnNpcatkSuspendAi("2.0");

		LSTORM_TARGS = "placeholder";
		LSTORM_TARGS = GetPlayers();
		int nLstormTargs = GetTokenCount(LSTORM_TARGS);
		N_STORMS = 0.0f;
		LOC_LSTORM1 = false;
		LOC_LSTORM2 = false;
		LSTORM_LOOPCOUNT = 0.0f;
		if (nLstormTargs > 0)
		{
			for (int i = 0; i < nLstormTargs; i++)
			{
				loopIteration = i;
				OnDoLstormLoop();
			}
		}
		if (!(N_STORMS > 0.0f))
			return;
		CallEventDelayed(0.1f, "do_lstorm2");
		if (N_STORMS > 1.0f)
			CallEventDelayed(0.5f, "do_lstorm3");
	}

	// do_lstorm2
	void OnDoLstorm2()
	{
		CreateNpc("monsters/summon/summon_lightning_storm", Vec(Text(LOC_LSTORM1)), self, AnglesOf(ENT_ME).y, DMG_LSTORM, DUR_LSTORM);
		@ID_LSTORM1 = EntityOf(ENT_LASTCREATED);
	}

	// do_lstorm3
	void OnDoLstorm3()
	{
		CreateNpc("monsters/summon/summon_lightning_storm", Vec(Text(LOC_LSTORM2)), self, AnglesOf(ENT_ME).y, DMG_LSTORM, DUR_LSTORM);
		@ID_LSTORM2 = EntityOf(ENT_LASTCREATED);
	}

	// do_lstorm_loop
	void OnDoLstormLoop()
	{
		bool exitSub = false;

		// dbg do_lstorm_loop
		// make up to two storms, centering on players
		// storms must be within 1024 units of me
		// for there to be more than one, they must be more than 256 units apart
		string curPlayer = GetToken(LSTORM_TARGS, int(LSTORM_LOOPCOUNT));
		LSTORM_LOOPCOUNT += 1.0f;

		if (RangeTo(curPlayer) < 1024.0f && N_STORMS < 2.0f)
		{
			N_STORMS += 1.0f;
			Vector3 targOrg = OriginOf(curPlayer);
			if (N_STORMS == 2.0f && Distance(targOrg, Vec(Text(LOC_LSTORM1))) < 256.0f)
				exitSub = true;
			if (!exitSub)
			{
				float stormGrndpos = GroundHeight(targOrg);
				targOrg.z = stormGrndpos;
				// dbg do_lstorm_loop cnt LSTORM_LOOPCOUNT name $get(CUR_PLAYER,name) org TARG_ORG grnd STORM_GRNDPOS
				if (N_STORMS == 1.0f)
					LOC_LSTORM1 = false;
				if (N_STORMS == 2.0f)
					LOC_LSTORM2 = false;
			}
		}
	}

	// get_teleporters
	void OnGetTeleporters()
	{
		N_TELES = 0.0f;

		TELE_ID1 = GetToken(GetVar("G_RUNE_POINTS"), 0);
		TELE_ID2 = GetToken(GetVar("G_RUNE_POINTS"), 1);
		TELE_ID3 = GetToken(GetVar("G_RUNE_POINTS"), 2);
		TELE_ID4 = GetToken(GetVar("G_RUNE_POINTS"), 3);

		N_TELES = 3.0f;
	}

	// do_teleport
	// PARAM1 = reason
	void OnDoTeleport(string reason = "", string option = "")
	{
		bool teleportFast = false;
		int count;

		if (!(N_TELES > 0.0f))
			return;

		// dbg do_teleport PARAM1
		if (reason != "\"stuck_count\"")
		{
			if (MyHealth() > HALF_HEALTH)
				teleportFast = false;
			if (MyHealth() <= HALF_HEALTH)
				teleportFast = true;

			if (!teleportFast)
				CallEventDelayed(FREQ_TELEPORT, "do_teleport");
			if (teleportFast)
				CallEventDelayed(FREQ_TELEPORT_FAST, "do_teleport");
		}

		// abort if too often
		float lastTeleDiff = GameTime() - LAST_TELE;
		if (!(lastTeleDiff > MIN_TELEPORT_DELAY))
			return;

		DebugPrint(Text(GameTime()) + " secs: do_teleport " + reason + " " + option);

		LAST_TELE = GameTime(); // this is also set at tele_in for better accuracy

		float totalTeles = N_TELES + 1.0f;
		int pickTele = RandomInt(1, int(totalTeles));

		if (option == "\"no_hits\"")
		{
			// find if any players are near my teleport points
			// if the are, teleport there and target them
			if (Truthy(GetVar("G_DEVELOPER_MODE")))
				MessageAll("green", "no_hits teleport");
			PLAYER_LIST = GetActivePlayers();
			PLAYER_LIST = TokenShuffle(PLAYER_LIST); // so we dont always go for the same player

			FOUND_NEAR_TARGET = 0;
			SEARCH_RAD = 512;
			count = GetTokenCount(PLAYER_LIST);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnFindNearTeleporter();
			}
			if (FOUND_NEAR_TARGET > 0)
			{
				OnNpcatkSettarget(NEW_TARGET);
				if (Truthy(GetVar("G_DEVELOPER_MODE")))
					MessageAll("green", "SORC_CHIEF: found " + NameOf(NEW_TARGET) + " near " + FOUND_NEAR_TARGET);
				pickTele = FOUND_NEAR_TARGET;
			}
		}

		if (pickTele == 1)
			TELE_DEST = Vec(TELE_ID1);
		if (pickTele == 2)
			TELE_DEST = Vec(TELE_ID2);
		if (pickTele == 3)
			TELE_DEST = Vec(TELE_ID3);
		if (pickTele == 4)
			TELE_DEST = Vec(TELE_ID4);
		if (pickTele > N_TELES)
		{
			TELE_DEST = DEFAULT_TELE_POINT;
			TELE_ANGS = NPC_SPAWN_ANGLES;
		}

		CreateNpc("monsters/summon/ibarrier", TELE_DEST, self, 64, 2, 0, 0, 0, 1); // <owner> <rad> <duration> [invisible:0|1] [silent:0|1] [dmg] [push_allys:0|1]
		OnLeapTele();
	}

	// find_near_teleporter
	void OnFindNearTeleporter()
	{
		// find which teleporter player is nearest to
		// player to check
		string curPlayer = GetToken(PLAYER_LIST, loopIteration);
		Vector3 playerOrg = OriginOf(curPlayer);
		if (FOUND_NEAR_TARGET != 0)
			return;

		if (!(N_TELES >= 1.0f))
			return;
		Vector3 testTele = Vec(TELE_ID1);
		testTele.z = GroundHeight(testTele);
		float teleDist = Distance(playerOrg, testTele);
		if (teleDist < SEARCH_RAD)
		{
			FOUND_NEAR_TARGET = 1;
			NEW_TARGET = curPlayer;
		}

		if (!(N_TELES >= 2.0f))
			return;
		testTele = Vec(TELE_ID2);
		testTele.z = GroundHeight(testTele); // measure from ground
		int oldTeleDist = int(teleDist); // store last teleport distance
		teleDist = Distance(playerOrg, testTele);
		if (teleDist < SEARCH_RAD)
		{
			if (oldTeleDist > teleDist) // use only if player is closer to this than the last one
			{
				FOUND_NEAR_TARGET = 2;
				NEW_TARGET = curPlayer;
			}
		}

		if (!(N_TELES >= 3.0f))
			return;
		testTele = Vec(TELE_ID3);
		testTele.z = GroundHeight(testTele);
		oldTeleDist = int(teleDist);
		teleDist = Distance(playerOrg, testTele);
		if (teleDist < SEARCH_RAD && oldTeleDist > teleDist)
		{
			FOUND_NEAR_TARGET = 3;
			NEW_TARGET = curPlayer;
		}

		if (!(N_TELES >= 4.0f))
			return;
		testTele = Vec(TELE_ID4);
		testTele.z = GroundHeight(testTele);
		oldTeleDist = int(teleDist);
		teleDist = Distance(playerOrg, testTele);
		if (teleDist < SEARCH_RAD && oldTeleDist > teleDist)
		{
			FOUND_NEAR_TARGET = 4;
			NEW_TARGET = curPlayer;
		}

		testTele = NPC_SPAWN_LOC;
		testTele.z = GroundHeight(testTele);
		oldTeleDist = int(teleDist);
		teleDist = Distance(playerOrg, testTele);
		if (teleDist < SEARCH_RAD && oldTeleDist > teleDist)
		{
			FOUND_NEAR_TARGET = 5;
			NEW_TARGET = curPlayer;
		}
	}

	// leap_tele
	// <target>
	void OnLeapTele()
	{
		AM_LEAPING = true;
		NPC_FORCED_MOVEDEST = true;
		OnNpcatkSuspendAi("1.0");
		SetMoveDest(RelativePosition(Vector3(0, 1000, 0)), ATTACK_MOVERANGE);
		CallEventDelayed(0.1f, "do_leap");
		RENDER_COUNT = 255.0f;
		CallEventDelayed(0.25f, "flicker_out");
		CallEventDelayed(0.75f, "tele_out");
		CallEventDelayed(1.0f, "tele_in");
	}

	// flicker_out
	void OnFlickerOut()
	{
		RENDER_COUNT -= 50.0f;
		if (!(RENDER_COUNT > 0.0f))
			return;
		CallEventDelayed(0.1f, "flicker_out");
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", RENDER_COUNT);
	}

	// tele_out
	void OnTeleOut()
	{
		PlaySound(0, 10, SOUND_TELE);
		SetOrigin(ENT_ME, Vector3(-20000, 10000, -20000));
	}

	// tele_in
	void OnTeleIn()
	{
		SetOrigin(ENT_ME, TELE_DEST);
		// setangle face TELE_ANGS
		PlaySound(0, 10, SOUND_TELE);
		RENDER_COUNT = 0.0f;
		OnFlickerIn();
		LAST_TELE = GameTime();
	}

	// flicker_in
	void OnFlickerIn()
	{
		RENDER_COUNT += 50.0f;
		if (RENDER_COUNT >= 255.0f)
		{
			SetProp(ENT_ME, "rendermode", 0);
			SetProp(ENT_ME, "renderamt", 255);
		}
		if (!(RENDER_COUNT < 255.0f))
			return;
		CallEventDelayed(0.1f, "flicker_in");
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", RENDER_COUNT);
	}

	// do_tornado
	void OnDoTornado()
	{
		PlayAnim("critical", ANIM_SWIPE);
		CreateNpc("monsters/summon/tornado", RelativePosition(Vector3(0, 72, 0)), self, 200, 20.0f);
	}

	string OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "") { return SorcChief_OnGameTakedamage(attacker, inflictor, damage, damageType); } // game_takedamage

	// do_throw
	void OnDoThrow()
	{
		if (AM_UNARMED)
			return;

		PLAYERS_NEAR = false;
		PLAYERS_INRANGE = false;
		SetVar("SORC_LPLAYERS", GetActivePlayers());
		PNEAR_LOOP_COUNT = 0.0f;
		int count = GetTokenCount("SORC_LPLAYERS");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnAnyPlayersNear();
		}
		// dbg do_throw check nplayers $get_token_amt(SORC_LPLAYERS) near PLAYERS_NEAR inrang PLAYERS_INRANGE
		if (PLAYERS_NEAR)
			return;
		if (!PLAYERS_INRANGE)
			return;
		OnDoThrow2();
	}

	// do_throw2
	void OnDoThrow2()
	{
		// dbg do_throw2 throwing sword
		SetModelBody(2, 0);
		AM_UNARMED = true;
		PlayAnim("critical", ANIM_SWIPE);
		CreateNpc("monsters/summon/blood_drinker", RelativePosition(Vector3(0, 48, 48)), self, @EntityOf(ENT_LASTSTRUCK), 100, 30.0f);
		BLOOD_DRINKER_ID = EntityId(EntityOf(ENT_LASTCREATED));
	}

	// any_players_near
	void OnAnyPlayersNear()
	{
		CBasePlayer@ curPlayer = FindPlayer(GetToken("SORC_LPLAYERS", int(PNEAR_LOOP_COUNT)));
		if (RangeTo(curPlayer) < ATTACK_RANGE)
			PLAYERS_NEAR = true;
		if (RangeTo(curPlayer) < 2048.0f)
			PLAYERS_INRANGE = true;
		PNEAR_LOOP_COUNT += 1.0f;
	}

	// do_special
	void OnDoSpecial()
	{
		bool abortSpecial = false;

		float nextTry = FREQ_SPECIAL;

		if (SUSPEND_AI)
		{
			// I'm busy doing something else
			// come back to this later
			nextTry = 5.0f;
			abortSpecial = true;
		}

		CallEventDelayed(nextTry, "do_special");
		if (abortSpecial)
			return;

		CUR_SPECIAL += 1.0f;

		// setvard CUR_SPECIAL 3 //TEMP
		if (CUR_SPECIAL > 3.0f)
			CUR_SPECIAL = 1.0f;

		if (CUR_SPECIAL == 1.0f)
			OnDoTornado();
		if (CUR_SPECIAL == 2.0f)
			OnDoLstorm();
		if (CUR_SPECIAL == 3.0f)
			OnDoThrow();
	}

	// sword_return
	void OnSwordReturn()
	{
		SetModelBody(2, 8);
		AM_UNARMED = false;
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

	void OnChatDelayTotal() {} // CHAT_DELAY_TOTAL
	void OnFreqKick() {} // FREQ_KICK
	void OnFreqLeap() {} // FREQ_LEAP
	void OnFreqSpecial() {} // FREQ_SPECIAL
	void OnFreqTeleport() {} // FREQ_TELEPORT
	void OnFreqTeleportFast() {} // FREQ_TELEPORT_FAST
	void OnNextTry() {} // NEXT_TRY

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/magic/tornado.mdl");
		Precache("monsters/sorc.mdl");
		CallEventDelayed(Float(Eval("$randf(8,15)")), "SorcChief_Timer");
		CallEventDelayed(1.1f, "SorcChief_Timer2");
		CallEventDelayed(20.0f, "SorcChief_Timer3");
		CallEventDelayed(1.0f, "SorcChief_Timer4");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SorcChief_FirstThink();
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
		if (name == "announce_visitors") { OnAnnounceVisitors(); return true; }
		if (name == "any_players_near") { OnAnyPlayersNear(); return true; }
		if (name == "barrier_loop") { OnBarrierLoop(); return true; }
		if (name == "barrier_off") { OnBarrierOff(); return true; }
		if (name == "begin_the_attack") { OnBeginTheAttack(); return true; }
		if (name == "check_for_blood") { OnCheckForBlood(); return true; }
		if (name == "check_inventories") { OnCheckInventories(); return true; }
		if (name == "check_kick") { OnCheckKick(); return true; }
		if (name == "combat_mode_go") { OnCombatModeGo(); return true; }
		if (name == "combat_mode_go2") { OnCombatModeGo2(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_leap") { OnDoLeap(); return true; }
		if (name == "do_lstorm") { OnDoLstorm(); return true; }
		if (name == "do_lstorm2") { OnDoLstorm2(); return true; }
		if (name == "do_lstorm3") { OnDoLstorm3(); return true; }
		if (name == "do_lstorm_loop") { OnDoLstormLoop(); return true; }
		if (name == "do_special") { OnDoSpecial(); return true; }
		if (name == "do_teleport") { OnDoTeleport(Param(params, 0), Param(params, 1)); return true; }
		if (name == "do_throw") { OnDoThrow(); return true; }
		if (name == "do_throw2") { OnDoThrow2(); return true; }
		if (name == "do_tornado") { OnDoTornado(); return true; }
		if (name == "ext_nudge") { OnExtNudge(Param(params, 0)); return true; }
		if (name == "ext_tell_approach") { OnExtTellApproach(); return true; }
		if (name == "find_near_teleporter") { OnFindNearTeleporter(); return true; }
		if (name == "flicker_in") { OnFlickerIn(); return true; }
		if (name == "flicker_out") { OnFlickerOut(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_menu_cancel") { OnGameMenuCancel(PlayerParam(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_parry") { OnGameParry(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), Float(Param(params, 4)), Float(Param(params, 5))); return true; }
		if (name == "game_takedamage") { Return(OnGameTakedamage(EntityParam(params, 0), EntityParam(params, 1), Float(Param(params, 2)), Param(params, 3))); return true; }
		if (name == "get_reply") { OnGetReply(); return true; }
		if (name == "get_teleporters") { OnGetTeleporters(); return true; }
		if (name == "kick_land") { OnKickLand(); return true; }
		if (name == "leap_at") { OnLeapAt(Param(params, 0)); return true; }
		if (name == "leap_away") { OnLeapAway(Param(params, 0)); return true; }
		if (name == "leap_delay_reset") { OnLeapDelayReset(); return true; }
		if (name == "leap_random") { OnLeapRandom(); return true; }
		if (name == "leap_tele") { OnLeapTele(); return true; }
		if (name == "mild_repell_loop") { OnMildRepellLoop(); return true; }
		if (name == "mrepell_targets") { OnMrepellTargets(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "orc_hop") { OnOrcHop(); return true; }
		if (name == "player_nears") { OnPlayerNears(); return true; }
		if (name == "repell_burst") { OnRepellBurst(Vec(Param(params, 0)), Int(Param(params, 1)), Int(Param(params, 2))); return true; }
		if (name == "repulse_targets") { OnRepulseTargets(); return true; }
		if (name == "resend_menu") { OnResendMenu(); return true; }
		if (name == "reset_kick_delay") { OnResetKickDelay(); return true; }
		if (name == "reset_leaping") { OnResetLeaping(); return true; }
		if (name == "say_foe") { OnSayFoe(); return true; }
		if (name == "say_friend") { OnSayFriend(); return true; }
		if (name == "send_ff_menu") { OnSendFfMenu(); return true; }
		if (name == "shield_up") { OnShieldUp(); return true; }
		if (name == "sorc_yell") { OnSorcYell(); return true; }
		if (name == "stand_up") { OnStandUp(); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		if (name == "sword_return") { OnSwordReturn(); return true; }
		if (name == "tele_in") { OnTeleIn(); return true; }
		if (name == "tele_out") { OnTeleOut(); return true; }
		if (name == "thuld_died") { OnThuldDied(); return true; }
		if (name == "warcry_done") { OnWarcryDone(); return true; }
		if (name == "SorcChief_Timer") { SorcChief_Timer(); return true; }
		if (name == "SorcChief_Timer2") { SorcChief_Timer2(); return true; }
		if (name == "SorcChief_Timer3") { SorcChief_Timer3(); return true; }
		if (name == "SorcChief_Timer4") { SorcChief_Timer4(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
