#pragma context server

// Converted from monsters/maldora_minion_random.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.
// Greater minions vulnerable ONLY to their element

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MaldoraMinionRandom
{
	// Constants
	float NPC_FADE_IN_SPEED = 0.02f;
	int SKEL_HP = 400;
	string ATTACK_HITCHANCE = "85%";
	float ATTACK_DAMAGE_LOW = 20.0f;
	float ATTACK_DAMAGE_HIGH = 30.0f;
	string SKEL_RESPAWN_CHANCE = "0%";
	int SKEL_RESPAWN_LIVES = 0;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_RUN = "run";
	float NPC_GIVE_EXP = 0.0f;
	string MINION_TYPE = "MINION_TYPE";
	string MINION_DESC = "MINION_DESC";
	string MINION_EFFECT = "MINION_EFFECT";
	string LIGHT_COLOR = "LIGHT_COLOR";
	bool SET_GREEK = false;
	bool ATTRIBS_SET = false;
	bool MINION_SUMMONED = false;
	bool AM_RISING = false;
	string MY_MASTER = "MY_MASTER";
	string FIRST_TARGET = "FIRST_TARGET";
	string PLAYING_DEAD = "PLAYING_DEAD";
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	Vector3 MASTER_ORG = Vector3();
	float GROUND_LEVEL = 0.0f;
	bool NO_SPAWN_STUCK_CHECK = false;
	bool FOUND_GROUND = false;
	bool I_R_GLOWING = false;
	string MY_LIGHT_SCRIPT = "MY_LIGHT_SCRIPT";

	// unnamed block (first think)
	void MaldoraMinionRandom_FirstThink()
	{
		ANIM_RUN = "run";
		NPC_GIVE_EXP = 125.0f;
	}

	// skeleton_spawn
	void MaldoraMinionRandom_OnSkeletonSpawn()
	{
		string nameSuffix = "NAME_SUFFIX";

		SetModel("monsters/skeleton_boss1.mdl");

		if (MINION_TYPE == "MINION_TYPE")
			MINION_TYPE = RandomInt(1, 4);

		if (Float(MINION_TYPE) == 1.0f)
		{
			MINION_DESC = "fire";
			nameSuffix = "of Fire";
			MINION_EFFECT = "effects/dot_fire";
			SetModelBody(0, 1); // 0=standard 1=ash 2=green 3=bloody 4=decayed 5=ice 6=gold 7=stone 8=crystal 9=weirdgel
			SetModelBody(1, 6); // 0=Unarmed 1=darkmace 2=sword 3=hammahs 4=bigsword+shield 5=iceclubs 6=fireclubs 7=highsword 8=wand
			LIGHT_COLOR = Text(Vector3(255, 0, 0));
		}

		if (Float(MINION_TYPE) == 2.0f)
		{
			MINION_DESC = "cold";
			nameSuffix = "of Ice";
			MINION_EFFECT = "effects/dot_cold";
			SetModelBody(0, 1); // 0=standard 1=ash 2=green 3=bloody 4=decayed 5=ice 6=gold 7=stone 8=crystal 9=weirdgel
			SetModelBody(1, 5); // 0=Unarmed 1=darkmace 2=sword 3=hammahs 4=bigsword+shield 5=iceclubs 6=fireclubs 7=highsword 8=wand
			LIGHT_COLOR = Text(Vector3(0, 0, 255));
		}

		if (Float(MINION_TYPE) == 3.0f)
		{
			MINION_DESC = "lightning";
			nameSuffix = "of Lightning";
			MINION_EFFECT = "effects/dot_lightning";
			SetModelBody(0, 1); // 0=standard 1=ash 2=green 3=bloody 4=decayed 5=ice 6=gold 7=stone 8=crystal 9=weirdgel
			SetModelBody(1, 3); // 0=Unarmed 1=darkmace 2=sword 3=hammahs 4=bigsword+shield 5=iceclubs 6=fireclubs 7=highsword 8=wand
			LIGHT_COLOR = Text(Vector3(255, 255, 0));
		}

		if (Float(MINION_TYPE) == 4.0f)
		{
			MINION_DESC = "poison";
			nameSuffix = "of Venom";
			LIGHT_COLOR = Text(Vector3(0, 255, 0));
			MINION_EFFECT = "effects/dot_poison";
			SetModelBody(0, 1); // 0=standard 1=ash 2=green 3=bloody 4=decayed 5=ice 6=gold 7=stone 8=crystal 9=weirdgel
			SetModelBody(1, 2); // 0=Unarmed 1=darkmace 2=sword 3=hammahs 4=bigsword+shield 5=iceclubs 6=fireclubs 7=highsword 8=wand
		}

		// dbg temp MinionType MINION_TYPE
		if (ToLowerCase(MapName()) == "thanatos")
			SET_GREEK = true;
		if (SET_GREEK)
			SetModelBody(0, 10);

		SetName("Maldora's Minion " + nameSuffix);
		SetWidth(32);
		SetHeight(80);
		SetRace("undead");
		SetBlood("none");

		CallEventDelayed(1.0f, "light_on");
	}

	// skele_swing_dodamage
	void MaldoraMinionRandom_OnSkeleSwingDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (AM_RISING)
			return;

		if (!hit)
			return;
		Effect("glow", ENT_ME, LIGHT_COLOR, 64, 1, 1);

		ApplyEffect(target, MINION_EFFECT, 5.0f, self, RandomInt(10, 20));
	}

	// skeleton_attribs
	void MaldoraMinionRandom_OnSkeletonAttribs()
	{
		if (ATTRIBS_SET)
			return;
		ATTRIBS_SET = true;

		SetDamageTaken("all", 0.6f);
		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 1.5f);

		if (MINION_DESC == "fire")
		{
			SetDamageTaken("cold", 4);
			SetDamageTaken("fire", 0);
			SetDamageTaken("lightning", 0.5f);
			SetDamageTaken("acid", 0.5f);
		}

		if (MINION_DESC == "cold")
		{
			SetDamageTaken("cold", 0);
			SetDamageTaken("fire", 4);
			SetDamageTaken("lightning", 0.5f);
			SetDamageTaken("acid", 0.5f);
		}

		if (MINION_DESC == "lightning")
		{
			SetDamageTaken("cold", 0.5f);
			SetDamageTaken("fire", 0.5f);
			SetDamageTaken("lightning", 0);
			SetDamageTaken("acid", 4);
		}

		if (MINION_DESC == "poison")
		{
			SetDamageTaken("cold", 0.5f);
			SetDamageTaken("fire", 0.5f);
			SetDamageTaken("lightning", 4);
			SetDamageTaken("acid", 0);
		}
	}

	// pop_off_masters_head
	void MaldoraMinionRandom_OnPopOffMastersHead()
	{
		float rndAng = Random(0, 359.99f);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, rndAng, 0), Vector3(0, 500, 0)));
	}

	// npc_fadein_done
	void MaldoraMinionRandom_OnNpcFadeinDone()
	{
		OnMinionWakeup();
	}

	// game_dynamically_created
	void MaldoraMinionRandom_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MINION_SUMMONED = true;
		AM_RISING = true;

		MY_MASTER = creatorValue1;
		FIRST_TARGET = creatorValue2;

		Vector3 myOrg = OriginOf(ENT_ME);
		myOrg.z += 128.0f;
		SetOrigin(ENT_ME, myOrg);
		SetProp(ENT_ME, "rendermode", 2);
		SetProp(ENT_ME, "renderamt", 0);
		CallEventDelayed(0.1f, "pop_off_masters_head");
		OnScanForGround();

		SetAnimFrameRate(0);
		SetRoam(false);
		PLAYING_DEAD = "1";
		SetMoveAnim(ANIM_RESPAWN_DEADIDLE);
		SetIdleAnim(ANIM_RESPAWN_DEADIDLE);
		SetInvincible(true);
		SetHearingSensitivity(0);
		OnNpcatkSuspendAi();
		NO_STUCK_CHECKS = "1";

		// find ground level - should be created below ground
		MASTER_ORG = OriginOf(MY_MASTER);
		GROUND_LEVEL = MASTER_ORG.z; // assumes master is at ground level

		NO_SPAWN_STUCK_CHECK = true;

		// setvard MY_X $vec.x(game.monster.origin)
		// setvard MY_Y $vec.y(game.monster.origin)
		// setvard MY_Z $vec.z(game.monster.origin)
		// setvard AM_RISING 1
		// setsolid none
		LegacyCommand("emitsound", ENT_ME, OriginOf(ENT_ME), 64, 5.0f, "danger", 128);
	}

	// scan_for_ground
	void MaldoraMinionRandom_OnScanForGround()
	{
		if (FOUND_GROUND)
			return;
		CallEventDelayed(0.1f, "scan_for_ground");
		if (OriginOf(ENT_ME).z != GroundHeight(MyOrigin()))
			return;
		FOUND_GROUND = true;
		OnSetFadeIn();
	}

	// minion_wakeup
	// { rise_from_grave
	// if ( MY_Z > GROUND_LEVEL ) callevent minion_wakeup
	// if MY_Z <= GROUND_LEVEL
	// callevent 0.1 rise_from_grave
	// add MY_Z 0.5
	// local MASTER_ORG $get(MY_MASTER,origin)
	// if ( $dist(game.monster.origin,MASTER_ORG) < 64 )
	// {
	// callexternal MY_MASTER leap_away $get(ent_me,id)
	// subtract MY_Z 0.5
	// }
	// //local CUR_LOC $vec(MY_X,MY_Y,MY_Z)
	// //local DEST_LOC $vec(MY_X,MY_Y,GROUND_LEVEL)
	// //dbg Rising $dist(CUR_LOC,DEST_LOC) ( CUR_LOC )
	// //setorigin ent_me $vec(MY_X,MY_Y,MY_Z)
	// }
	// { repulse_loop
	// if AM_RISING
	// local ROCK_SOURCE $vec(MY_X,MY_Y,GROUND_LEVEL)
	// //gibs <modelname/spritename> <position> <size> <velocity> <randomness> <amount> <duration>
	// local ROCK_VEL $randf(-10,10)
	// effect tempent gibs rockgibs.mdl ROCK_SOURCE 0.5 (ROCK_VEL,ROCK_VEL,100) 20 3 1.0
	// playsound 0 5 debris/bustconcrete1.wav debris/bustconcrete2.wav debris/concrete3.wav
	// //dodamage ROCK_SOURCE 48 0.0 100% 0 reflective target
	// callevent 1.0 repulse_loop
	// }
	void MaldoraMinionRandom_OnMinionWakeup()
	{
		// setprop ent_me rendermode 0
		// setprop ent_me renderamt 255
		OnSkeletonAttribs();

		// setsolid box
		AM_RISING = false;

		float awakeDelay = 1.5f; // give time to play getup anim

		if (BASE_FRAMERATE == "BASE_FRAMERATE")
			SetAnimFrameRate(1);
		if (BASE_FRAMERATE != "BASE_FRAMERATE")
			SetAnimFrameRate(Float(BASE_FRAMERATE));

		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		PlayAnim("once", "getup");

		CallEventDelayed(1.7f, "aid_master");
		CallEventDelayed(awakeDelay, "skeleton_awake");
	}

	// aid_master
	void MaldoraMinionRandom_OnAidMaster()
	{
		if (IsAlive(HUNT_LASTTARGET))
			return;
		if (!(RangeTo(FIRST_TARGET) < 1024.0f))
			return;
		if (!IsAlive(FIRST_TARGET))
			return;
		OnNpcatkTarget2(FIRST_TARGET);
	}

	// game_death
	void MaldoraMinionRandom_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		CallExternal(MY_MASTER, "skele_died");
	}

	// game_death
	void MaldoraMinionRandom_OnGameDeath_2(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		ClientEvent("remove", "all", MY_LIGHT_SCRIPT);

		if (NPC_NO_DROPS)
			return;
		if (MINION_SUMMONED)
			return;
		OnBmGoldSpew(25, "1", 32, 2, 4);
	}

	// light_on
	void MaldoraMinionRandom_OnLightOn()
	{
		if (I_R_GLOWING)
			return;
		I_R_GLOWING = true;
		ClientEvent("persist", "all", "monsters/maldora_minion_random", IndexOf(ENT_ME), LIGHT_COLOR);
		MY_LIGHT_SCRIPT = LastClientScriptId();
	}

	// maldora_died
	// =============================== End Glow System
	void MaldoraMinionRandom_OnMaldoraDied()
	{
		DeleteEntity(ENT_ME, "fade");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		MaldoraMinionRandom_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
		MaldoraMinionRandom_OnGameDeath_2(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		MaldoraMinionRandom_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9);
	}

	void OnSkeletonSpawn() { MaldoraMinionRandom_OnSkeletonSpawn(); } // skeleton_spawn
	void OnSkeleSwingDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { MaldoraMinionRandom_OnSkeleSwingDodamage(hit, target, start, end, damageType, damageText); } // skele_swing_dodamage
	void OnSkeletonAttribs() { MaldoraMinionRandom_OnSkeletonAttribs(); } // skeleton_attribs
	void OnPopOffMastersHead() { MaldoraMinionRandom_OnPopOffMastersHead(); } // pop_off_masters_head
	void OnNpcFadeinDone() { MaldoraMinionRandom_OnNpcFadeinDone(); } // npc_fadein_done
	void OnScanForGround() { MaldoraMinionRandom_OnScanForGround(); } // scan_for_ground
	void OnMinionWakeup() { MaldoraMinionRandom_OnMinionWakeup(); } // minion_wakeup
	void OnAidMaster() { MaldoraMinionRandom_OnAidMaster(); } // aid_master
	void OnLightOn() { MaldoraMinionRandom_OnLightOn(); } // light_on
	void OnMaldoraDied() { MaldoraMinionRandom_OnMaldoraDied(); } // maldora_died

	// This file's events and timers by their .script names
	bool MaldoraMinionRandom_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "aid_master") { OnAidMaster(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "light_on") { OnLightOn(); return true; }
		if (name == "maldora_died") { OnMaldoraDied(); return true; }
		if (name == "minion_wakeup") { OnMinionWakeup(); return true; }
		if (name == "npc_fadein_done") { OnNpcFadeinDone(); return true; }
		if (name == "pop_off_masters_head") { OnPopOffMastersHead(); return true; }
		if (name == "scan_for_ground") { OnScanForGround(); return true; }
		if (name == "skele_swing_dodamage") { OnSkeleSwingDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "skeleton_attribs") { OnSkeletonAttribs(); return true; }
		if (name == "skeleton_spawn") { OnSkeletonSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/maldora_minion_random"]
shared class MaldoraMinionRandomScript : SkeletonBaseScript, MaldoraMinionRandom
{
	// Variables declared by included files, with the value they start with in this script
	MaldoraMinionRandomScript()
	{
		NPC_FADE_IN_SPEED = 0.02f;
		ANIM_RUN = "run";
		SKEL_HP = 400;
		ATTACK_HITCHANCE = "85%";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skeleton_boss1.mdl");
		Precache("monsters/skeleton.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MaldoraMinionRandom_FirstThink();
		SkeletonBase_FirstThink();
		SkeletonBase_FirstThink2();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return MaldoraMinionRandom_DispatchEvent(name, params)
			|| SkeletonBaseScript::DispatchEvent(name, params);
	}
}
