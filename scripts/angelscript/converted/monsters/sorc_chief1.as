#pragma context server

// Converted from monsters/sorc_chief1.script by msc_transpiler.
// Shadahar Orc Chief, from scratch by Thothie
// Powers
// - Summong Tornado: pick sup players, swings about, damages
// - Vampyric Sword*
// - Throw, said vampyric sword*
// - Lightning storm*
// - Lightning burst - thinking redundant?
// - Lightning blast (drop one bolt on each nearby enemy from sky)*
// - Teleport (teleports behind one player, strikes, then returns to spawn point)
// - Can also teleport to up to 4 pre-defined locations monster/sorc_telepointX
// - Counter gang bang with lightning repulsion
// - Kick to the nuts repulse + stun
// - Lots of jumping
// - Double jump height at 50% health
// - Cold immunity pot

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/sorc_chief1"]
class SorcChief1 : BaseMonsterNewScript
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
	string ANIM_FLINCH = "ANIM_FLINCH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	float FREQ_LEAP = 0.0f;
	bool SWORD_ATTACK = false;
	int JUMP_FWD_DIST = 0;
	float CUR_SPECIAL = 0.0f;
	bool CYCLES_STARTED = false;
	string FIRST_PLAYER = "FIRST_PLAYER";
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
	Vector3 TELE_ANG = Vector3();
	Vector3 TELE_ANGS = Vector3();
	string NEW_TARGET = "NEW_TARGET";
	float RENDER_COUNT = 0.0f;
	float HALF_HEALTH = 0.0f;
	bool ON_LODAGOND = false;
	string TORNADO_ID = "TORNADO_ID";
	bool PLAYERS_NEAR = false;
	bool PLAYERS_INRANGE = false;
	float PNEAR_LOOP_COUNT = 0.0f;
	bool AM_UNARMED = false;
	string BLOOD_DRINKER_ID = "BLOOD_DRINKER_ID";
	float MAX_AI_SUSPEND = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	SorcChief1()
	{
		NPC_BOSS_REGEN_RATE = 0.0f;
		NPC_BOSS_RESTORATION = 0.3f;
		ANIM_IDLE = "idle1";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		SOUND_DEATH = "voices/orc/die.wav";
	}

	// unnamed block (first think)
	void SorcChief1_FirstThink()
	{
		if (ToLowerCase(MapName()) == "lodagond-1")
		{
			NPC_GIVE_EXP = 10000.0f;
			NPC_IS_BOSS = true;
		}
		else
		{
			NPC_GIVE_EXP = 3000.0f;
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

	// game_damaged_other
	// PARAM1=target_hit PARAM2=dmg
	string SorcChief1_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
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
	string SorcChief1_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		// dbg game_damaged game.monster.hp $get(PARAM1,name) PARAM2 PARAM3
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

	// unnamed block (timer)
	void SorcChief1_Timer()
	{
		CallEventDelayed(Random(8, 15), "SorcChief1_Timer");
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
	void SorcChief1_Timer2()
	{
		CallEventDelayed(1.1f, "SorcChief1_Timer2");
		if (!(STUCK_COUNT > 4.0f))
			return;
		OnDoTeleport("stuck_count");
	}

	// game_takedamage
	string SorcChief1_OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		string result = "";
		return result;
	}

	// unnamed block (timer)
	void SorcChief1_Timer3()
	{
		CallEventDelayed(20.0f, "SorcChief1_Timer3");

		// if I've not thwacked anyone for a bit, teleport
		// - but not if I can see him almost in range
		// hacky brain death prevention FEB2010_26
		if (GameTime() > MAX_AI_SUSPEND)
		{
			MAX_AI_SUSPEND = GameTime() + 10.0f;
			OnNpcatkResumeAi();
		}

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

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		UseTrigger("sorc_defeat");
		if (Exists(BLOOD_DRINKER_ID))
			CallExternal(BLOOD_DRINKER_ID, "ext_remove");
		if (Exists(TORNADO_ID))
			DeleteEntity(TORNADO_ID);

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
		CreateNpc("lodagond/sorc_image_defeat", RelativePosition(Vector3(0, 0, 0)), AnglesOf(ENT_ME).y);
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, SorcChief1_OnGameDamagedOther(target, damage, damageType, damageEvent));
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
		HALF_HEALTH = Divide(MyMaxHealth(), 2.0f);

		string mapName = ToLowerCase(MapName());
		if (mapName != "lodagond-1")
			return;
		ON_LODAGOND = true;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SetName("Runegahr, Shadahar Orc Chieftain");
		SetRace("orc");

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

		SetSayTextRange(1024);

		SWORD_ATTACK = false;
		JUMP_FWD_DIST = 250;
		CUR_SPECIAL = 0.0f;
		CallEventDelayed(1.0f, "get_teleporters");
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
		MAX_AI_SUSPEND = GameTime() + 10.0f;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		bool plotMap = false;
		string raceRemark = "RACE_REMARK";
		string racePlural = "RACE_PLURAL";

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
		string mapName = ToLowerCase(MapName());
		if (mapName == "sorc_test")
			plotMap = true;
		if (Contains(mapName, "lodagond"))
			plotMap = true;
		if (!plotMap)
			return;
		PLAYER_LIST = GetPlayers();
		FIRST_PLAYER = GetToken(PLAYER_LIST, 0);
		if (RaceOf(FIRST_PLAYER) == "human")
		{
			raceRemark = "human";
			racePlural = "humans";
		}
		if (RaceOf(FIRST_PLAYER) == "elf")
		{
			raceRemark = "elf";
			racePlural = "elves";
		}
		if (RaceOf(FIRST_PLAYER) == "dwarf")
		{
			raceRemark = "dwarf";
			racePlural = "dwarves";
		}

		SetSayTextRange(2048);

		if (PlayerCount() == 1)
			SayText("No! I will NOT be rescued by a lowly " + raceRemark + " !");

		if (PlayerCount() > 1)
			SayText("No! I will NOT be rescued by a couple of puny " + racePlural + " !");

		PlaySound(0, 10, SOUND_ATTACK2);
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, SorcChief1_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
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

	// swing_axe
	// This was axed due to crash issues
	// { do_lblast
	// //centralized under do_special now
	// //	local NEXT_TRY FREQ_LBLAST
	// //	if ( SUSPEND_AI )
	// //	{
	// //		//I'm busy doing something else
	// //		//come back to this later
	// //		local NEXT_TRY 10.0
	// //		local ABORT_SPECIAL 1
	// //	}
	// //
	// //	callevent NEXT_TRY do_lblast
	// //	if !ABORT_SPECIAL
	// createnpc monsters/summon/lstrike $relpos(0,0,0) $get(ent_me,id) DMG_LBLAST 9
	// setvard CAN_FLINCH 0
	// callevent npcatk_suspend_ai 2.0
	// setvard AS_ATTACKING 20
	// playanim critical ANIM_WARCRY
	// playsound 0 10 SOUND_WARCRY
	// }
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

	// warcry_done
	void OnWarcryDone()
	{
		CAN_FLINCH = "1";
		if (SUSPEND_AI)
			OnNpcatkResumeAi();
	}

	// get_teleporters
	void OnGetTeleporters()
	{
		N_TELES = 0.0f;

		TELE_ID1 = EntityId(FindByName("sorc_telepoint1"));
		TELE_ID2 = EntityId(FindByName("sorc_telepoint2"));
		TELE_ID3 = EntityId(FindByName("sorc_telepoint3"));
		TELE_ID4 = EntityId(FindByName("sorc_telepoint4"));

		if (Exists(TELE_ID1))
			N_TELES += 1.0f;
		if (Exists(TELE_ID2))
			N_TELES += 1.0f;
		if (Exists(TELE_ID3))
			N_TELES += 1.0f;
		if (Exists(TELE_ID4))
			N_TELES += 1.0f;
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
		{
			TELE_DEST = OriginOf(TELE_ID1);
			TELE_ANG = AnglesOf(TELE_ID1);
			CallExternal(TELE_ID1, "tele_used");
		}
		if (pickTele == 2)
		{
			TELE_DEST = OriginOf(TELE_ID2);
			TELE_ANG = AnglesOf(TELE_ID2);
			CallExternal(TELE_ID2, "tele_used");
		}
		if (pickTele == 3)
		{
			TELE_DEST = OriginOf(TELE_ID3);
			TELE_ANG = AnglesOf(TELE_ID3);
			CallExternal(TELE_ID3, "tele_used");
		}
		if (pickTele == 4)
		{
			TELE_DEST = OriginOf(TELE_ID4);
			TELE_ANG = AnglesOf(TELE_ID4);
			CallExternal(TELE_ID4, "tele_used");
		}
		if (pickTele > N_TELES)
		{
			TELE_DEST = NPC_SPAWN_LOC;
			TELE_DEST.z += 128.0f;
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
		Vector3 testTele = OriginOf(TELE_ID1);
		testTele.z = GroundHeight(testTele);
		float teleDist = Distance(playerOrg, testTele);
		if (teleDist < SEARCH_RAD)
		{
			FOUND_NEAR_TARGET = 1;
			NEW_TARGET = curPlayer;
		}

		if (!(N_TELES >= 2.0f))
			return;
		testTele = OriginOf(TELE_ID2);
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
		testTele = OriginOf(TELE_ID3);
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
		testTele = OriginOf(TELE_ID4);
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
		SetAngle("face", TELE_ANGS);
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
		TORNADO_ID = ENT_LASTCREATED;
	}

	string OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "") { return SorcChief1_OnGameTakedamage(attacker, inflictor, damage, damageType); } // game_takedamage

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
		BLOOD_DRINKER_ID = ENT_LASTCREATED;
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

	// do_nadda
	void OnDoNadda()
	{
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
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
		CallEventDelayed(Float(Eval("$randf(8,15)")), "SorcChief1_Timer");
		CallEventDelayed(1.1f, "SorcChief1_Timer2");
		CallEventDelayed(20.0f, "SorcChief1_Timer3");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SorcChief1_FirstThink();
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
		if (name == "any_players_near") { OnAnyPlayersNear(); return true; }
		if (name == "check_kick") { OnCheckKick(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_leap") { OnDoLeap(); return true; }
		if (name == "do_lstorm") { OnDoLstorm(); return true; }
		if (name == "do_lstorm2") { OnDoLstorm2(); return true; }
		if (name == "do_lstorm3") { OnDoLstorm3(); return true; }
		if (name == "do_lstorm_loop") { OnDoLstormLoop(); return true; }
		if (name == "do_nadda") { OnDoNadda(); return true; }
		if (name == "do_special") { OnDoSpecial(); return true; }
		if (name == "do_teleport") { OnDoTeleport(Param(params, 0), Param(params, 1)); return true; }
		if (name == "do_throw") { OnDoThrow(); return true; }
		if (name == "do_throw2") { OnDoThrow2(); return true; }
		if (name == "do_tornado") { OnDoTornado(); return true; }
		if (name == "find_near_teleporter") { OnFindNearTeleporter(); return true; }
		if (name == "flicker_in") { OnFlickerIn(); return true; }
		if (name == "flicker_out") { OnFlickerOut(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_parry") { OnGameParry(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), Float(Param(params, 4)), Float(Param(params, 5))); return true; }
		if (name == "game_takedamage") { Return(OnGameTakedamage(EntityParam(params, 0), EntityParam(params, 1), Float(Param(params, 2)), Param(params, 3))); return true; }
		if (name == "get_teleporters") { OnGetTeleporters(); return true; }
		if (name == "kick_land") { OnKickLand(); return true; }
		if (name == "leap_at") { OnLeapAt(Param(params, 0)); return true; }
		if (name == "leap_away") { OnLeapAway(Param(params, 0)); return true; }
		if (name == "leap_delay_reset") { OnLeapDelayReset(); return true; }
		if (name == "leap_random") { OnLeapRandom(); return true; }
		if (name == "leap_tele") { OnLeapTele(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_suspend_ai") { OnNpcatkSuspendAi(Param(params, 0), Param(params, 1)); return true; }
		if (name == "orc_hop") { OnOrcHop(); return true; }
		if (name == "reset_kick_delay") { OnResetKickDelay(); return true; }
		if (name == "reset_leaping") { OnResetLeaping(); return true; }
		if (name == "sorc_yell") { OnSorcYell(); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		if (name == "sword_return") { OnSwordReturn(); return true; }
		if (name == "tele_in") { OnTeleIn(); return true; }
		if (name == "tele_out") { OnTeleOut(); return true; }
		if (name == "warcry_done") { OnWarcryDone(); return true; }
		if (name == "SorcChief1_Timer") { SorcChief1_Timer(); return true; }
		if (name == "SorcChief1_Timer2") { SorcChief1_Timer2(); return true; }
		if (name == "SorcChief1_Timer3") { SorcChief1_Timer3(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
