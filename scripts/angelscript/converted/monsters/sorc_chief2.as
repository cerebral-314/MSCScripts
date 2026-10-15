#pragma context server

// Converted from monsters/sorc_chief2.script by msc_transpiler.
// Shadahar Orc Chief, ally variant by Thothie
// - This version fights Maldora on the side of the players
// - Since Maldora is immune to magic, he only uses his sword, except when fighting minions
// - Can teleport out to heal

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/sorc_chief2"]
class SorcChief2 : BaseMonsterNewScript
{
	// Constants
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
	float FREQ_SPECIAL = 0.0f;
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
	string ANIM_FLINCH = "ANIM_FLINCH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	float FREQ_LEAP = 0.0f;
	bool SWORD_ATTACK = false;
	int JUMP_FWD_DIST = 0;
	float CUR_SPECIAL = 0.0f;
	bool CYCLES_STARTED = false;
	float LAST_SWORD_HIT = 0.0f;
	bool KICK_DELAY = false;
	bool LEAP_DELAY = false;
	bool DOUBLE_FOR = false;
	bool DOUBLE_UP = false;
	bool AM_LEAPING = false;
	string T_BOX = "T_BOX";
	bool ZAPPED_MINION = false;
	float RENDER_COUNT = 0.0f;
	Vector3 RETURN_POINT = Vector3();
	float LAST_TELE = 0.0f;
	bool STUCK_TELE = false;
	bool AM_UNARMED = false;
	CBaseEntity@ BD_ID = null;
	CBaseEntity@ MINION_TO_ZAP = null;
	string MALDORA_ID = "MALDORA_ID";
	bool MALDORA_DEAD = false;
	string TALK_TARGET = "TALK_TARGET";
	bool GAVE_SWORD = false;

	// Variables declared by included files, with the value they start with in this script
	SorcChief2()
	{
		ANIM_IDLE = "idle1";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		SOUND_DEATH = "voices/orc/die.wav";
	}

	// unnamed block (first think)
	void SorcChief2_FirstThink()
	{
		NPC_GIVE_EXP = 0.0f;
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

	// game_damaged_other
	// no regen, Maldora is immune to regen, and everything he summons is undead
	// PARAM1=target_hit PARAM2=dmg
	string SorcChief2_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		if (!Contains(NameOf(target), "Lightning"))
			return result;
		OnZapMinion(target);
		return result;
	}

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type
	string SorcChief2_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		// dbg game_damaged game.monster.hp $get(PARAM1,name) PARAM2 PARAM3
		if (MyHealth() < 0.0f)
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

	// unnamed block (timer)
	void SorcChief2_Timer()
	{
		CallEventDelayed(Random(8, 15), "SorcChief2_Timer");

		if (NPCATK_TARGET == "unset")
			OnNpcatkSettarget(MALDORA_ID);

		// keep an eye out for lightning minions
		T_BOX = FindInBox("enemy", 1024);
		if (T_BOX == "none")
			return;
		ZAPPED_MINION = false;
		int count = Int(T_BOX);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCheckForLminion();
		}
		if (IsAlive(MINION_TO_ZAP))
			OnZapMinion(MINION_TO_ZAP);

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
	void SorcChief2_Timer2()
	{
		CallEventDelayed(1.1f, "SorcChief2_Timer2");
		if (!(STUCK_COUNT > 4.0f))
			return;
		STUCK_TELE = true;
		OnDoTeleport("stuck_count");
	}

	// game_takedamage
	string SorcChief2_OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		string result = "";
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
		UseTrigger("sorc_defeat");
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, SorcChief2_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		MALDORA_ID = creatorValue1;
		SetMoveDest(MALDORA_ID, 9999);
		CallEventDelayed(0.1f, "cycle_up");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SetName("Runegahr, Shadahar Orc Chieftain");
		SetRace("human");

		SetHealth(8000);
		SetDamageTaken("all", 0.5f);
		SetDamageTaken("fire", 0.5f);
		SetDamageTaken("cold", 0.25f);
		SetDamageTaken("lightning", 0);
		SetDamageTaken("stun", 0.25f);

		SetHearingSensitivity(10);

		SetModel("monsters/sorc.mdl");
		SetModelBody(0, 2); // body: 0=bare 1=bloody_shirt 2=gold_armor 3=archer
		SetModelBody(1, 3); // head: 0=hat_horns 1=hat_spiked 2=lizardskin_horned 3=gold_chieften 4=lizard_cap
		SetModelBody(2, 8); // weapon: 0=unarmed 1=axe 2=bow 3=steel_bow 4=sword 5=great_axe 6=sword_sheild 8=yellow_axe 9=blooddrinker
		SetStat("parry", 150);
		SetWidth(32);
		SetHeight(96);

		SetRoam(true); // re-enable, debug

		SetSayTextRange(2048);

		SWORD_ATTACK = false;
		JUMP_FWD_DIST = 250;
		CUR_SPECIAL = 0.0f;
		CallEventDelayed(1.0f, "get_teleporters");
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new

		if (CYCLES_STARTED)
			return;
		CYCLES_STARTED = true;
		// callevent FREQ_TORNADO do_tornado
		// callevent FREQ_LSTORM do_lstorm
		// callevent FREQ_LBURST do_lburst
		// callevent FREQ_LBLAST do_lblast
		// callevent FREQ_THROW do_throw
		CallEventDelayed(FREQ_SPECIAL, "do_special");
		CallEventDelayed(60.0f, "do_teleport"); // do first teleport 1 min in, rest are random
		SetRoam(true);

		SayText("Now, Maldora! With these allies I shall defeat you!");

		PlaySound(0, 10, SOUND_ATTACK2);
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, SorcChief2_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
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

	// cycle_npc
	void OnCycleNpc(string mode = "")
	{
		OnCycleUp();
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
			OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), DMG_SMASH, ATTACK_HITCHANCE, "dark");
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
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_SLASH), ATTACK_HITCHANCE, "dark");
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
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), DMG_KICK, ATTACK_HITCHANCE, "blunt");
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
		if (MyHealth() > 0.0f)
			jumpHeight = RandomInt(350, 450);
		if (MyHealth() <= 0.0f)
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

	// warcry_done
	void OnWarcryDone()
	{
		CAN_FLINCH = "1";
		if (SUSPEND_AI)
			OnNpcatkResumeAi();
	}

	// do_teleport
	// PARAM1 = reason
	void OnDoTeleport(string reason = "", string option = "")
	{
		if (MALDORA_DEAD)
			return;
		// jump straight up, teleport out, return full health, repeat
		CreateNpc("monsters/summon/ibarrier", RelativePosition(Vector3(0, 0, 0)), self, 64, 2, 0, 0, 0, 1); // <owner> <rad> <duration> [invisible:0|1] [silent:0|1] [dmg] [push_allys:0|1]
		OnLeapTele();
	}

	// leap_tele
	// <target>
	void OnLeapTele()
	{
		AM_LEAPING = true;
		NPC_FORCED_MOVEDEST = true;
		OnNpcatkSuspendAi("1.0");
		SetMoveDest(RelativePosition(Vector3(0, 0, 1000)), ATTACK_MOVERANGE);
		CallEventDelayed(0.1f, "do_leap");
		RENDER_COUNT = 255.0f;
		CallEventDelayed(0.1f, "flicker_out");
		CallEventDelayed(0.25f, "tele_out");
		CallEventDelayed(4.5f, "tele_in_barrier");
		CallEventDelayed(5.0f, "tele_in");
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
		RETURN_POINT = MyOrigin();
		PlaySound(0, 10, SOUND_TELE);
		SetOrigin(ENT_ME, Vector3(-20000, 10000, -20000));
	}

	// tele_in_barrier
	void OnTeleInBarrier()
	{
		Vector3 returnBar = RETURN_POINT;
		returnBar.z = GroundHeight(RETURN_POINT);
		CreateNpc("monsters/summon/ibarrier", RETURN_POINT, self, 64, 2, 0, 0, 0, 1); // <owner> <rad> <duration> [invisible:0|1] [silent:0|1] [dmg] [push_allys:0|1]
	}

	// tele_in
	void OnTeleIn()
	{
		SetOrigin(ENT_ME, RETURN_POINT);
		PlaySound(0, 10, SOUND_TELE);
		RENDER_COUNT = 0.0f;
		OnFlickerIn();
		LAST_TELE = GameTime();
		GiveHealth(2000);
		if (!STUCK_TELE)
			CallEventDelayed(120.0f, "do_teleport");
		if (STUCK_TELE)
			STUCK_TELE = false;
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

	string OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "") { return SorcChief2_OnGameTakedamage(attacker, inflictor, damage, damageType); } // game_takedamage

	// do_throw
	void OnDoThrow()
	{
		if (AM_UNARMED)
			return;

		// setvard PLAYERS_NEAR 0
		// setvard PLAYERS_INRANGE 0
		// local SORC_LPLAYERS $get_tbox(1024,enemy)
		// setvard PNEAR_LOOP_COUNT 0
		// calleventloop $get_token_amt(SORC_LPLAYERS) any_players_near
		// dbg do_throw check nplayers $get_token_amt(SORC_LPLAYERS) near PLAYERS_NEAR inrang PLAYERS_INRANGE
		// if !PLAYERS_NEAR
		// if PLAYERS_INRANGE
		OnDoThrow2();
	}

	// do_throw2
	void OnDoThrow2()
	{
		// dbg do_throw2 throwing sword
		SetModelBody(2, 0);
		AM_UNARMED = true;
		PlayAnim("critical", ANIM_SWIPE);
		CreateNpc("monsters/summon/blood_drinker", RelativePosition(Vector3(0, 48, 48)), self, MALDORA_ID, 100, 30.0f);
		@BD_ID = EntityOf(ENT_LASTCREATED);
	}

	// do_special
	void OnDoSpecial()
	{
		bool abortSpecial = false;

		if (MALDORA_DEAD)
			return;

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

		OnDoThrow();
	}

	// sword_return
	void OnSwordReturn()
	{
		SetModelBody(2, 8);
		AM_UNARMED = false;
	}

	// do_nadda
	void OnDoNadda()
	{
	}

	// check_for_lminion
	void OnCheckForLminion()
	{
		CBaseEntity@ curNme = FindEntity(GetToken(T_BOX, loopIteration));
		string curName = NameOf(curNme);
		if (!Contains(curName, "Lightning"))
			return;
		@MINION_TO_ZAP = curNme;
	}

	// zap_minion
	// PARAM1 = minion
	void OnZapMinion(CBaseEntity@ minion = null)
	{
		SayText("Maldora! Your minions are pathetic!");
		PlaySound(0, 10, "weather/lightning.wav");
		Effect("beam", "ents", "lgtning.spr", 100, ENT_ME, 1, @minion, 0, Vector3(255, 255, 0), 255, 30, 3.0f);
		CallExternal(minion, "npc_suicide");
	}

	// maldora_final_died
	// ========= REWARD SEQUENCE
	void OnMaldoraFinalDied(CBaseEntity@ killer = null)
	{
		OnNpcatkSuspendAi();
		MALDORA_DEAD = true;
		SetMenuAutoOpen(true);
		if (IsAlive(BD_ID))
			DeleteEntity(BD_ID);
		OnSwordReturn();
		CatchSpeech("say_hi", "hail", "hi", "hello", "wassup", "j0", "yo");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;
		if (!MALDORA_DEAD)
			return;
		if (GAVE_SWORD)
			return;
		menuItem.title = "Demand Reward";
		menuItem.type = "callback";
		menuItem.callback = "say_sword";
		RegisterMenuItem(menuItem);
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SetMoveDest(@EntityOf(ENT_LASTSPOKE), 128);
		SayText("I got something you want, human?");
		OpenMenu(EntityOf(ENT_LASTSPOKE));
	}

	// say_sword
	void OnSaySword(CBasePlayer@ target = null)
	{
		if (GAVE_SWORD)
			return;
		TALK_TARGET = EntityId(target);
		SetMoveDest(TALK_TARGET, 128);
		SetRoam(false);
		if (!MALDORA_DEAD)
			return;
		SayText("Since you were the first to have the guts to ask, here you are, as promised.");
		SetModelBody(2, 0);
		CallEventDelayed(4.0f, "say_sword2");
		GAVE_SWORD = true;
		Offer(target, "swords_blood_drinker");
	}

	// say_sword2
	void OnSaySword2()
	{
		SetMoveDest(TALK_TARGET, 128);
		SayText("Worry not, I have a spare back at the palace... A couple spares, actually.");
		CallEventDelayed(4.0f, "say_sword3");
	}

	// say_sword3
	void OnSaySword3()
	{
		SetMoveDest(TALK_TARGET, 128);
		SayText("If you ever dare to step foot within the walls of the palace, be sure to find me.");
		CallEventDelayed(4.0f, "say_sword4");
	}

	// say_sword4
	void OnSaySword4()
	{
		SetMoveDest(TALK_TARGET, 128);
		SayText("You maybe lowly human's, but you've proven yourself true warriors all. Our doors are always open to true warriors.");
		CallEventDelayed(4.0f, "say_sword4b");
	}

	// say_sword4b
	void OnSaySword4b()
	{
		SetMoveDest(TALK_TARGET, 128);
		SayText("...but when you do visit us, be sure to show me that sword. All you human's look alike to me.");
		CallEventDelayed(4.0f, "say_sword5");
	}

	// say_sword5
	void OnSaySword5()
	{
		SetMoveDest(TALK_TARGET, 128);
		SayText("That having been said, I must leave before this citidel comes crashing down - I suggest you do the same.");
		PlayAnim("critical", "warcry");
		CallEventDelayed(3.0f, "final_tele_out");
	}

	// final_tele_out
	void OnFinalTeleOut()
	{
		SetMoveDest(TALK_TARGET, 128);
		SayText("Sorry I can't take you with me...");
		PlaySound(0, 10, SOUND_TELE);
		CreateNpc("monsters/summon/ibarrier", RelativePosition(Vector3(0, 0, 0)), self, 64, 2, 0, 0, 0, 1); // <owner> <rad> <duration> [invisible:0|1] [silent:0|1] [dmg] [push_allys:0|1]
		CallEventDelayed(0.1f, "fade_away");
	}

	// fade_away
	void OnFadeAway()
	{
		DeleteEntity(ENT_ME, "fade");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreqKick() {} // FREQ_KICK
	void OnFreqLeap() {} // FREQ_LEAP
	void OnFreqSpecial() {} // FREQ_SPECIAL
	void OnNextTry() {} // NEXT_TRY

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/sorc.mdl");
		CallEventDelayed(Float(Eval("$randf(8,15)")), "SorcChief2_Timer");
		CallEventDelayed(1.1f, "SorcChief2_Timer2");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SorcChief2_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "check_for_lminion") { OnCheckForLminion(); return true; }
		if (name == "check_kick") { OnCheckKick(); return true; }
		if (name == "cycle_npc") { OnCycleNpc(Param(params, 0)); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_leap") { OnDoLeap(); return true; }
		if (name == "do_nadda") { OnDoNadda(); return true; }
		if (name == "do_special") { OnDoSpecial(); return true; }
		if (name == "do_teleport") { OnDoTeleport(Param(params, 0), Param(params, 1)); return true; }
		if (name == "do_throw") { OnDoThrow(); return true; }
		if (name == "do_throw2") { OnDoThrow2(); return true; }
		if (name == "fade_away") { OnFadeAway(); return true; }
		if (name == "final_tele_out") { OnFinalTeleOut(); return true; }
		if (name == "flicker_in") { OnFlickerIn(); return true; }
		if (name == "flicker_out") { OnFlickerOut(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_parry") { OnGameParry(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), Float(Param(params, 4)), Float(Param(params, 5))); return true; }
		if (name == "game_takedamage") { Return(OnGameTakedamage(EntityParam(params, 0), EntityParam(params, 1), Float(Param(params, 2)), Param(params, 3))); return true; }
		if (name == "kick_land") { OnKickLand(); return true; }
		if (name == "leap_at") { OnLeapAt(Param(params, 0)); return true; }
		if (name == "leap_away") { OnLeapAway(Param(params, 0)); return true; }
		if (name == "leap_delay_reset") { OnLeapDelayReset(); return true; }
		if (name == "leap_random") { OnLeapRandom(); return true; }
		if (name == "leap_tele") { OnLeapTele(); return true; }
		if (name == "maldora_final_died") { OnMaldoraFinalDied(EntityParam(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "orc_hop") { OnOrcHop(); return true; }
		if (name == "reset_kick_delay") { OnResetKickDelay(); return true; }
		if (name == "reset_leaping") { OnResetLeaping(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_sword") { OnSaySword(PlayerParam(params, 0)); return true; }
		if (name == "say_sword2") { OnSaySword2(); return true; }
		if (name == "say_sword3") { OnSaySword3(); return true; }
		if (name == "say_sword4") { OnSaySword4(); return true; }
		if (name == "say_sword4b") { OnSaySword4b(); return true; }
		if (name == "say_sword5") { OnSaySword5(); return true; }
		if (name == "sorc_yell") { OnSorcYell(); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		if (name == "sword_return") { OnSwordReturn(); return true; }
		if (name == "tele_in") { OnTeleIn(); return true; }
		if (name == "tele_in_barrier") { OnTeleInBarrier(); return true; }
		if (name == "tele_out") { OnTeleOut(); return true; }
		if (name == "warcry_done") { OnWarcryDone(); return true; }
		if (name == "zap_minion") { OnZapMinion(EntityParam(params, 0)); return true; }
		if (name == "SorcChief2_Timer") { SorcChief2_Timer(); return true; }
		if (name == "SorcChief2_Timer2") { SorcChief2_Timer2(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
