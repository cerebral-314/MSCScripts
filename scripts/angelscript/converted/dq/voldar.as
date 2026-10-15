#pragma context server

// Converted from dq/voldar.script by msc_transpiler.
// Volar (From Flayer)
// Beefed up MAY2007a by Thothie for ms_wicardoven by Replica
// - Attacks:
// - G. Poison Blade*
// - Acid Bolt*
// - Acid Cloud*
// - Leap*
// - Horror Egg*
// - Hornet Swarm? ( too much )

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_melee.as"
#include "converted/monsters/orc_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Voldar
{
	// Constants
	float NPC_BOSS_REGEN_RATE = 0.05f;
	float NPC_BOSS_RESTORATION = 0.25f;
	string ANIM_HOP = "battleaxe_swing1_L";
	string ANIM_WARCRY = "warcry";
	float SPIT_FREQ = 3.0f;
	int CLOUD_FREQ = 0;
	int HORNET_FREQ = 0;
	int EGG_FREQ = 0;
	int ATTACK_SPEED = 300;
	string ANIM_KICK = "kick";
	int DMG_SPIT = 0;
	string DMG_KICK = "DMG_KICK";
	float DMG_SLASH = 0.0f;
	string SOUND_WARCRY = "monsters/orc/zo_alert10.wav";
	string SOUND_DEATH = "voices/orc/die2.wav";
	string ATTACK_ACCURACY = "90%";
	string NPC_PROXACT_RANGE = "640";
	bool NPC_PROXACT_IFSEEN = true;
	string NPC_PROXACT_EVENT = "start_intro";

	// Variables (an unset .script variable reads as its own name)
	bool NO_SPAWN_STUCK_CHECK = false;
	float NPC_GIVE_EXP = 0.0f;
	bool NPC_IS_BOSS = false;
	string ANIM_ATTACK2 = "ANIM_ATTACK2";
	string ANIM_FLINCH = "ANIM_FLINCH";
	string MOVE_RANGE = "MOVE_RANGE";
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	float FLINCH_HEALTH = 0.0f;
	float ACTIVE_HORRORS = 0.0f;
	bool NPC_PROX_ACTIVATE = false;
	string MALDORA_ID = "MALDORA_ID";
	float AS_ATTACKING = 0.0f;
	int DID_INTRO = 0;
	bool ORC_JUMPER = false;
	bool AM_LEAPING = false;
	bool NPC_FORCED_MOVEDEST = false;
	float OLD_Z = 0.0f;
	bool DO_STUN = false;
	bool SPIT_DELAY = false;
	bool MAKE_ACLOUD = false;
	bool SUMMON_HORROR = false;

	// unnamed block (first think)
	void Voldar_FirstThink()
	{
		NO_SPAWN_STUCK_CHECK = true;

		NPC_GIVE_EXP = 2000.0f;

		if (ToLowerCase(MapName()) == "ms_wicardoven")
			NPC_IS_BOSS = true;
		else if (ToLowerCase(MapName()) != "orc_for")
			NPC_GIVE_EXP = 1000.0f;
		ANIM_ATTACK2 = "battleaxe_swing1_L";

		ANIM_FLINCH = "flinch";

		MOVE_RANGE = "300";

		DROP_GOLD = 1; // Gold Drops
		DROP_GOLD_AMT = RandomInt(100, 300);

		ANIM_ATTACK = "swordswing1_L";
		FLINCH_CHANCE = "35%";
		FLINCH_HEALTH = 1000.0f;
	}

	// orc_spawn
	void Voldar_OnOrcSpawn()
	{
		SetHealth(2500);
		SetWidth(32);
		SetHeight(60);
		SetName("Voldar, former head of the Black Hand");
		SetHearingSensitivity(11);
		SetStat("parry", 50);
		SetDamageTaken("all", 0.4f);
		SetRoam(false);

		SetProp(ENT_ME, "skin", 3);

		ACTIVE_HORRORS = 0.0f;

		SetModelBody(0, 2); // Body
		SetModelBody(1, 3); // Head
		SetModelBody(2, 6); // Weapon

		SetSayTextRange(2048);

		CatchSpeech("debug_params", "debug");

		// only do maldora bit on certain maps
		string mapName = ToLowerCase(MapName());
		// dbg Map result L_MAP_NAME
		bool exitSub = true;
		if (mapName == "ms_wicardoven")
			exitSub = false;
		if (mapName == "voldar_test")
			exitSub = false;
		if (exitSub)
		{
			SetName("Orc Poisoner");
			NPC_PROX_ACTIVATE = false;
			CallEventDelayed(0.1f, "combat_go");
		}
		if (exitSub)
			return;
		NPC_PROX_ACTIVATE = true;

		// dbg Plot map, suspending AI
		OnNpcatkSuspendAi();

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_IDLE);

		// setmovespeed 0.0 //I think this mean "movespeed 0.0", but the script still appears to work as normal. -greatguys1 SEP2021
		SetInvincible(true);

		CreateNpc("ms_wicardoven/maldora_dead", RelativePosition(Vector3(0, 64, 0)), "valdor");

		CallEventDelayed(0.25f, "get_maldora_id");
	}

	// get_maldora_id
	void Voldar_OnGetMaldoraId()
	{
		CBaseEntity@ maldoraName = FindByName("dead_maldora");
		MALDORA_ID = EntityId(maldoraName);
		CallEventDelayed(0.1f, "face_maldora");
	}

	// face_maldora
	void Voldar_OnFaceMaldora()
	{
		// callexteternal MALDORA_ID $get(ent_me,id) //No idea what this was supposed to accomplish, sans the typo.
		CallEventDelayed(0.1f, "scan_for_players");
	}

	// start_intro
	void Voldar_OnStartIntro()
	{
		PlayAnim("critical", "flinch");
		SayText("You were supposed to help me take back my tribe! But now look what's happened!");
		PlaySound(0, 10, "voices/ms_wicardoven/voldor_2fmaldora1.wav");
		CallEventDelayed(3.6f, "do_intro1");
	}

	// do_intro1
	void Voldar_OnDoIntro1()
	{
		CallExternal(MALDORA_ID, "say_gaveyou1");
		CallEventDelayed(6.22f, "do_intro2");
	}

	// do_intro2
	void Voldar_OnDoIntro2()
	{
		CallExternal(MALDORA_ID, "say_gaveyou2");
		CallEventDelayed(4.2f, "do_intro3");
	}

	// do_intro3
	void Voldar_OnDoIntro3()
	{
		CallExternal(MALDORA_ID, "say_gaveyou3");
		CallEventDelayed(5.8f, "do_intro4");
	}

	// do_intro4
	void Voldar_OnDoIntro4()
	{
		CallExternal(MALDORA_ID, "say_gaveyou4");
		CallEventDelayed(3.3f, "do_intro5");
	}

	// do_intro5
	void Voldar_OnDoIntro5()
	{
		CallExternal(MALDORA_ID, "fly_out");
		SayText("WAAAIIIT!!!!!");
		PlaySound(0, 10, "voices/ms_wicardoven/voldor_2fmaldora2.wav");
		PlayAnim("critical", ANIM_WARCRY);
		CallEventDelayed(1.8f, "do_intro6");
	}

	// do_intro6
	void Voldar_OnDoIntro6()
	{
		PlayAnim("critical", ANIM_ATTACK);
		SayText("Fine! Have to prove my worth, do I?");
		PlaySound(0, 10, "voices/ms_wicardoven/voldor_2fmaldora3.wav");
		SetMoveDest("FIRST_TARGET", 9999);
		// recache voices/orc/help.wav
		// callexternal all ext_playsound voices/orc/help.wav $get(ent_me,origin) 2048
		AS_ATTACKING = GameTime();
		CallEventDelayed(2.0f, "combat_go");
	}

	// debug_params
	void Voldar_OnDebugParams()
	{
		SayText("horrors " + Text(ACTIVE_HORRORS) + " leaping " + Text(AM_LEAPING));
	}

	// combat_go
	void Voldar_OnCombatGo()
	{
		DID_INTRO = 1;
		SetInvincible(false);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		OnNpcatkResumeAi();
		OnCycleUp("voldar_forced");
		CallEventDelayed(CLOUD_FREQ, "make_cloud");
		CallEventDelayed(EGG_FREQ, "lay_egg");
		UseTrigger("voldar_go");
		CallEventDelayed(0.1f, "set_first_targ");
	}

	// set_first_targ
	void Voldar_OnSetFirstTarg()
	{
		OnNpcatkSettarget("FIRST_TARGET", "voldar_forced");
	}

	// npc_post_spawn
	void Voldar_OnNpcPostSpawn()
	{
		ORC_JUMPER = true;
	}

	// run_away
	// <target>
	void Voldar_OnRunAway(string threatEntity = "", string fleeDistance = "")
	{
		OnNpcatkFlee(EntityId(EntityOf(threatEntity)), "400", "2.0");
	}

	// leap_away
	// <target>
	void Voldar_OnLeapAway(string target = "")
	{
		// dbg leap_away PARAM2
		AM_LEAPING = true;
		NPC_FORCED_MOVEDEST = true;
		OnNpcatkSuspendAi("1.0");
		SetMoveDest(target, 800, "flee");
		CallEventDelayed(0.1f, "leap_away2");
	}

	// leap_away2
	void Voldar_OnLeapAway2()
	{
		PlayRandomSound(0, 10, "voices/orc/hit.wav", "voices/orc/hit2.wav", "voices/orc/hit3.wav");
		PlayAnim("critical", ANIM_HOP);
		CallEventDelayed(0.1f, "orc_hop");
		CallEventDelayed(1.0f, "reset_leaping");
	}

	// leap_at
	// <target>
	void Voldar_OnLeapAt(string target = "")
	{
		if (AM_LEAPING)
			return;
		AM_LEAPING = true;
		NPC_FORCED_MOVEDEST = true;
		OnNpcatkSuspendAi("1.0");
		SetMoveDest(target, MOVE_RANGE);
		CallEventDelayed(0.1f, "leap_at2");
	}

	// leap_at2
	void Voldar_OnLeapAt2()
	{
		PlayRandomSound(0, 10, "voices/orc/hit.wav", "voices/orc/hit2.wav", "voices/orc/hit3.wav");
		PlayAnim("critical", ANIM_HOP);
		CallEventDelayed(0.1f, "orc_hop");
		CallEventDelayed(1.0f, "reset_leaping");
		OLD_Z = MyOrigin().z;
		DO_STUN = true;
		CallEventDelayed(0.5f, "ground_scan");
	}

	// ground_scan
	void Voldar_OnGroundScan()
	{
		if (!DO_STUN)
			return;
		CallEventDelayed(0.2f, "ground_scan");

		// find if on ground method not working
		// local TRACE_ORG game.monster.origin
		// local TRACE_END TRACE_ORG
		// vectoradd TRACE_END $relpos($vec(0,0,0),$vec(0,0,-16))
		// local TRACE_LINE $get_traceline(TRACE_ORG,TRACE_END,worldonly)
		// if ( $dist(TRACE_LINE,TRACE_END) < 4 ) setvard DO_STUN 0
		float myGround = GroundHeight(MyOrigin());
		float myZ = MyOrigin().z;
		float diff = myZ - myGround;
		if (diff < 5.0f)
			DO_STUN = false;

		if (DO_STUN)
			return;
		// //dbg TRACE_LINE vs $get_ground_height(TRACE_ORG)
		CreateNpc("monsters/summon/stun_burst", RelativePosition(Vector3(0, 30, 0)), self, 128);
	}

	// game_hitground
	void Voldar_OnGameHitground(float fallVelocity = 0.0f)
	{
	}

	// reset_leaping
	void Voldar_OnResetLeaping()
	{
		AM_LEAPING = false;
	}

	// npc_targetsighted
	void Voldar_OnNpcTargetsighted(string target = "")
	{
		if (SPIT_DELAY)
			return;
		if (!(RangeTo(target) > ATTACK_RANGE))
			return;
		if (AM_LEAPING)
			return;
		if (IS_FLEEING)
			return;

		SPIT_DELAY = true;

		CallEventDelayed(SPIT_FREQ, "reset_spit_delay");

		AS_ATTACKING = GameTime();
		PlayAnim("once", ANIM_ATTACK2);
	}

	// reset_spit_delay
	void Voldar_OnResetSpitDelay()
	{
		SPIT_DELAY = false;
	}

	// game_struck
	void Voldar_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		int thresh = 0;

		// dbg game.monster.hp
		if (MyHealth() >= 1000.0f)
			thresh = 50;
		if (MyHealth() < 1000.0f)
			thresh = 25;

		int escapeChance = RandomInt(thresh, 100); // if struck for damage > than this, leap away or kick
		if (damage > escapeChance)
		{
			// dbg temp game_struck/escape chan ESCAPE_CHANCE vs dmg PARAM1
			int escapeChoice = RandomInt(1, 2);
			if (escapeChoice == 1)
				OnLeapAway(EntityId(EntityOf(ENT_LASTSTRUCK)));
			if (escapeChoice == 2)
				OnDoKick();
		}
	}

	// do_kick
	void Voldar_OnDoKick()
	{
		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_KICK);
		CallEventDelayed(1.0f, "kick_damage");
	}

	// kick_damage
	void Voldar_OnKickDamage()
	{
		// callevent npcatk_dodamage NPCATK_TARGET ATTACK_HITRANGE KICK_DAMAGE 100% blunt
		DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, "KICK_DAMAGE", "100%", ENT_ME, ENT_ME, "none", "blunt", "dmgevent:kick");
	}

	// kick_dodamage
	void Voldar_OnKickDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		ApplyEffect(target, "effects/debuff_stun", 5.0f, self);
		AddVelocity(target, RelativeVelocity(Vector3(0, 150, 20)));
		OnRunAway(EntityId(target));
	}

	// make_cloud
	void Voldar_OnMakeCloud(string origin = "", string angles = "")
	{
		CallEventDelayed(CLOUD_FREQ, "make_cloud");

		if (!CanSee(NPCATK_TARGET))
			return;

		MAKE_ACLOUD = true;

		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_WARCRY);
		PlaySound(0, 10, SOUND_WARCRY);

		CallEventDelayed(2.0f, "make_cloud2");
	}

	// make_cloud2
	void Voldar_OnMakeCloud2()
	{
		if (MAKE_ACLOUD)
		{
			MAKE_ACLOUD = false;
			CallEventDelayed(0.1f, "magic_fx");
			Vector3 cloudOrg = OriginOf(NPCATK_TARGET);
			if (!IsAlive(NPCATK_TARGET))
				cloudOrg = RelativePosition(Vector3(0, 0, 0));
			if (RangeTo(NPCATK_TARGET) > 3000.0f)
				cloudOrg = RelativePosition(Vector3(0, 0, 0));
			CreateNpc("monsters/summon/npc_poison_cloud2", cloudOrg, self, 100, 20.0f, 3);
			bool exitSub = true;
		}
	}

	// npc_flinch
	void Voldar_OnNpcFlinch(float damage = 0.0f)
	{
		MAKE_ACLOUD = false;
	}

	// lay_egg
	void Voldar_OnLayEgg()
	{
		CallEventDelayed(EGG_FREQ, "lay_egg");

		if (!(ACTIVE_HORRORS < 2.0f))
			return;

		SUMMON_HORROR = true;

		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_ATTACK2);
		PlaySound(0, 10, "voices/orc/attack2.wav");
	}

	// horror_died
	void Voldar_OnHorrorDied()
	{
		// dbg horror died
		ACTIVE_HORRORS -= 1.0f;
	}

	// swing_axe
	void Voldar_OnSwingAxe()
	{
		bool exitSub = false;

		if (SUMMON_HORROR)
		{
			SUMMON_HORROR = false;
			ACTIVE_HORRORS += 1.0f;
			CallEventDelayed(0.1f, "magic_fx");
			PlaySound(0, 10, "magic/frost_reverse.wav");
			CreateNpc("monsters/summon/horror_egg", RelativePosition(Vector3(0, 30, 50)), self);
			AddVelocity(ENT_LASTCREATED, RelativeVelocity(Vector3(0, 100, 20)));
			exitSub = true;
		}

		if (exitSub)
			return;

		if (IS_FLEEING)
			return;

		PlaySound(0, 10, "bullchicken/bc_attack3.wav");
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none>
		TossProjectile("proj_poison", RelativePosition(Vector3(0, 48, 18)), NPCATK_TARGET, ATTACK_SPEED, DMG_SPIT, 0, "none"); // Converted to use new tossprojectile //greatguys1@FEB2022
		Effect("glow", ENT_LASTPROJECTILE, Vector3(0, 255, 0), 64, -1, 0);

		if (RangeTo(NPCATK_TARGET) > 200.0f && RandomInt(1, 100) > 50)
			OnLeapAt("NPCATK_TARGET,id");
	}

	// swing_sword
	void Voldar_OnSwingSword()
	{
		if (DID_INTRO == 0)
			return;
		OnBaseorcYell();
		// setvard SLASH_ATTACK 1
		// callevent npcatk_dodamage NPCATK_TARGET ATTACK_HITRANGE DMG_SLASH ATTACK_ACCURACY
		DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, DMG_SLASH, ATTACK_ACCURACY, ENT_ME, ENT_ME, "none", "slash", "dmgevent:swing");
	}

	// swing_dodamage
	void Voldar_OnSwingDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		ApplyEffect(target, "effects/dot_poison", RandomInt(3, 5), self, 40);
		if (RandomInt(1, 20) == 1)
			OnLeapAway(EntityId(target));
	}

	// magic_fx
	void Voldar_OnMagicFx()
	{
		Effect("glow", ENT_ME, Vector3(255, 0, 0), 64, 2, 2);
	}

	// game_death
	void Voldar_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		bool treasureMap = false;

		string mapName = ToLowerCase(MapName());
		if (mapName == "voldar_test")
			treasureMap = true;
		if (mapName == "ms_wicardoven")
			treasureMap = true;
		// //PARAM1=gold_per_bag PARAM2=bags_player PARAM3=dist_from_mon PARAM4=min#bags PARAM5 max#bags
		if (treasureMap)
			OnBmGoldSpew(25, "2", 75, 4, 30);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseMelee_OnOrcSpawn(); // monsters/orc_base_melee
		Voldar_OnOrcSpawn();
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		OrcBaseMelee_OnNpcatkTargetvalidate(target); // monsters/orc_base_melee
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		OrcBase_OnNpcatkTargetvalidate(target); // monsters/orc_base
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		OrcBaseMelee_OnMyTargetDied(offender); // monsters/orc_base_melee
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		OrcBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/orc_base
		Voldar_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
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
		OrcBase_OnNpcPostSpawn(); // monsters/orc_base
		Voldar_OnNpcPostSpawn();
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		Voldar_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		Voldar_OnNpcTargetsighted(target);
	}

	void OnBaseorcYell() { OrcBase_OnBaseorcYell(); } // baseorc_yell
	void OnGetMaldoraId() { Voldar_OnGetMaldoraId(); } // get_maldora_id
	void OnFaceMaldora() { Voldar_OnFaceMaldora(); } // face_maldora
	void OnStartIntro() { Voldar_OnStartIntro(); } // start_intro
	void OnDoIntro1() { Voldar_OnDoIntro1(); } // do_intro1
	void OnDoIntro2() { Voldar_OnDoIntro2(); } // do_intro2
	void OnDoIntro3() { Voldar_OnDoIntro3(); } // do_intro3
	void OnDoIntro4() { Voldar_OnDoIntro4(); } // do_intro4
	void OnDoIntro5() { Voldar_OnDoIntro5(); } // do_intro5
	void OnDoIntro6() { Voldar_OnDoIntro6(); } // do_intro6
	void OnDebugParams() { Voldar_OnDebugParams(); } // debug_params
	void OnCombatGo() { Voldar_OnCombatGo(); } // combat_go
	void OnSetFirstTarg() { Voldar_OnSetFirstTarg(); } // set_first_targ
	void OnRunAway(string threatEntity = "", string fleeDistance = "") { Voldar_OnRunAway(threatEntity, fleeDistance); } // run_away
	void OnLeapAway(string target = "") { Voldar_OnLeapAway(target); } // leap_away
	void OnLeapAway2() { Voldar_OnLeapAway2(); } // leap_away2
	void OnLeapAt(string target = "") { Voldar_OnLeapAt(target); } // leap_at
	void OnLeapAt2() { Voldar_OnLeapAt2(); } // leap_at2
	void OnGroundScan() { Voldar_OnGroundScan(); } // ground_scan
	void OnGameHitground(float fallVelocity = 0.0f) { Voldar_OnGameHitground(fallVelocity); } // game_hitground
	void OnResetLeaping() { Voldar_OnResetLeaping(); } // reset_leaping
	void OnResetSpitDelay() { Voldar_OnResetSpitDelay(); } // reset_spit_delay
	void OnDoKick() { Voldar_OnDoKick(); } // do_kick
	void OnKickDamage() { Voldar_OnKickDamage(); } // kick_damage
	void OnKickDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { Voldar_OnKickDodamage(hit, target, start, end, damageType, damageText); } // kick_dodamage
	void OnMakeCloud(string origin = "", string angles = "") { Voldar_OnMakeCloud(origin, angles); } // make_cloud
	void OnMakeCloud2() { Voldar_OnMakeCloud2(); } // make_cloud2
	void OnNpcFlinch(float damage = 0.0f) { Voldar_OnNpcFlinch(damage); } // npc_flinch
	void OnLayEgg() { Voldar_OnLayEgg(); } // lay_egg
	void OnHorrorDied() { Voldar_OnHorrorDied(); } // horror_died
	void OnSwingAxe() { Voldar_OnSwingAxe(); } // swing_axe
	void OnSwingSword() { Voldar_OnSwingSword(); } // swing_sword
	void OnSwingDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { Voldar_OnSwingDodamage(hit, target, start, end, damageType, damageText); } // swing_dodamage
	void OnMagicFx() { Voldar_OnMagicFx(); } // magic_fx
	void OnCloudFreq() {} // CLOUD_FREQ
	void OnEggFreq() {} // EGG_FREQ
	void OnSpitFreq() {} // SPIT_FREQ

	// This file's events and timers by their .script names
	bool Voldar_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "combat_go") { OnCombatGo(); return true; }
		if (name == "debug_params") { OnDebugParams(); return true; }
		if (name == "do_intro1") { OnDoIntro1(); return true; }
		if (name == "do_intro2") { OnDoIntro2(); return true; }
		if (name == "do_intro3") { OnDoIntro3(); return true; }
		if (name == "do_intro4") { OnDoIntro4(); return true; }
		if (name == "do_intro5") { OnDoIntro5(); return true; }
		if (name == "do_intro6") { OnDoIntro6(); return true; }
		if (name == "do_kick") { OnDoKick(); return true; }
		if (name == "face_maldora") { OnFaceMaldora(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_hitground") { OnGameHitground(Float(Param(params, 0))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "get_maldora_id") { OnGetMaldoraId(); return true; }
		if (name == "ground_scan") { OnGroundScan(); return true; }
		if (name == "horror_died") { OnHorrorDied(); return true; }
		if (name == "kick_damage") { OnKickDamage(); return true; }
		if (name == "kick_dodamage") { OnKickDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "lay_egg") { OnLayEgg(); return true; }
		if (name == "leap_at") { OnLeapAt(Param(params, 0)); return true; }
		if (name == "leap_at2") { OnLeapAt2(); return true; }
		if (name == "leap_away") { OnLeapAway(Param(params, 0)); return true; }
		if (name == "leap_away2") { OnLeapAway2(); return true; }
		if (name == "magic_fx") { OnMagicFx(); return true; }
		if (name == "make_cloud") { OnMakeCloud(Param(params, 0), Param(params, 1)); return true; }
		if (name == "make_cloud2") { OnMakeCloud2(); return true; }
		if (name == "npc_flinch") { OnNpcFlinch(Float(Param(params, 0))); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "reset_leaping") { OnResetLeaping(); return true; }
		if (name == "reset_spit_delay") { OnResetSpitDelay(); return true; }
		if (name == "run_away") { OnRunAway(Param(params, 0), Param(params, 1)); return true; }
		if (name == "set_first_targ") { OnSetFirstTarg(); return true; }
		if (name == "start_intro") { OnStartIntro(); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		if (name == "swing_dodamage") { OnSwingDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "dq/voldar"]
shared class VoldarScript : OrcBaseScript, Voldar, OrcBaseMelee
{
	// Variables declared by included files, with the value they start with in this script
	VoldarScript()
	{
		NPC_BOSS_REGEN_RATE = 0.05f;
		NPC_BOSS_RESTORATION = 0.25f;
		SOUND_DEATH = "voices/orc/die2.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/edwardgorey.mdl");
		Precache("monsters/egg.mdl");
		Precache("monsters/maldora.mdl");
		Precache("monsters/orc.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Voldar_FirstThink();
		OrcBaseMelee_FirstThink();
		OrcBase_FirstThink();
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
		return Voldar_DispatchEvent(name, params)
			|| OrcBaseMelee_DispatchEvent(name, params)
			|| OrcBaseScript::DispatchEvent(name, params);
	}
}
