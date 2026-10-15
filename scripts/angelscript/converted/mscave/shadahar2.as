#pragma context server

// Converted from mscave/shadahar2.script by msc_transpiler.
// moving this to a new script as the original Shadahar is too contaminated with the lightning skeleton adjustments
// spells
// -COD (minor) on all players within 800 units
// -Laser Eyes
// -Summons floating eyes that drain mana until death
// -Teleport sequence throughout map (resets hp until the final point)
// -Launch impact-fireballs when on bridge to (more or less) force ranged combat

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

[script "mscave/shadahar2"]
class Shadahar2 : BaseMonsterScript
{
	// Constants
	string ANIM_SWIPE = "attack1";
	string ANIM_SMASH = "attack3";
	string ANIM_CAST = "castspell";
	string DMG_SWIPE = "DMG_SWIPE";
	string DMG_SMASH = "DMG_SMASH";
	int DMG_FIRE_BOLT = 0;
	bool ATTACH_IDX_WAND = false;
	bool ATTACH_IDX_EYE1 = true;
	int ATTACH_IDX_EYE2 = 2;
	float DMG_BEAM = 300.0f;
	int WAND_UNLIT = 8;
	int WAND_LIT = 9;
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_STRUCK4 = "zombie/zo_pain2.wav";
	string SOUND_STRUCK5 = "zombie/zo_pain2.wav";
	string SOUND_ATTACK1 = "zombie/claw_miss1.wav";
	string SOUND_ATTACK2 = "zombie/claw_miss2.wav";
	string SOUND_STUN = "debris/glass2.wav";
	string SOUND_BEAM_FIRE = "debris/beamstart1.wav";
	string SOUND_TURNED1 = "ambience/the_horror1.wav";
	string SOUND_TURNED2 = "ambience/the_horror2.wav";
	string SOUND_TURNED3 = "ambience/the_horror3.wav";
	string SOUND_TURNED4 = "ambience/the_horror4.wav";
	string SOUND_HOLY_STRIKE = "doors/aliendoor1.wav";
	string SOUND_LAUGH = "monsters/skeleton/cal_laugh.wav";
	string SOUND_WARCRY = "monsters/skeleton/calrain3.wav";
	float FREQ_SPECIAL = 0.0f;

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_MOVE = "ANIM_MOVE";
	string ATTACK_HITCHANCE = "ATTACK_HITCHANCE";
	int MAX_EYES = 0;
	CBaseEntity@ BEAM_EYE1 = null;
	CBaseEntity@ BEAM_EYE2 = null;
	string ATTACK_PUSH = "ATTACK_PUSH";
	bool SWIPE_ATTACK = false;
	bool STUN_ATTACK = false;
	string MY_CL_IDX = "MY_CL_IDX";
	string MY_TELE_POINTS = "MY_TELE_POINTS";
	string MY_TRIGGERS = "MY_TRIGGERS";
	float N_TELE_POINTS = 0.0f;
	float CUR_TELE_POINT = 0.0f;
	bool SET_TELE_POINTS = false;
	bool DID_WARCRY = false;
	bool STARTED_CYCLES = false;
	bool TELEPORT_SEQUENCE = false;
	string CUR_TRIG = "CUR_TRIG";
	bool STAY_NEAR_HOME = false;
	bool DOING_SPECIAL = false;
	float N_CIRC_PLAYERS = 0.0f;
	string PLAYER_ORGS = "PLAYER_ORGS";
	bool CIRCLES_ON = false;
	float CIRC_PLAYER_IDX = 0.0f;
	bool EYE_BEAM_WARMUP = false;
	float MY_YAW = 0.0f;
	float BEAM_COUNT = 0.0f;
	Vector3 SUMMON_POS = Vector3();
	bool SUMMON_WARMUP = false;
	float N_EYES = 0.0f;
	float LAST_RETURN_TIME = 0.0f;
	bool DID_ORC_COMMENT = false;
	bool AM_MOBILE = false;

	// Variables declared by included files, with the value they start with in this script
	Shadahar2()
	{
		NPC_IS_BOSS = true;
		ANIM_IDLE = "idle1";
		NO_STUCK_CHECKS = "1";
		SOUND_DEATH = "zombie/zo_pain1.wav";
	}

	// unnamed block (first think)
	void Shadahar2_FirstThink()
	{
		NPC_IS_BOSS = true;

		// base anims
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_RUN = "walk"; // doesn't run much, switch to run at last point
		ANIM_ATTACK = "attack1";
		ANIM_DEATH = "dieheadshot"; // needs new death sequence

		// base stats
		MOVE_RANGE = "32";
		ATTACK_RANGE = 64.0f;
		ATTACK_HITRANGE = 127.0f;
		IS_UNHOLY = true;
		NO_STUCK_CHECKS = "1"; // can't risk him getting stuck on some odd surface in mscave and teleporting home
		ANIM_MOVE = "walk";
		ATTACK_HITCHANCE = "70";
	}

	// game_dodamage
	// 1:AttackHit(1/0)  2:EntityHit  3:StartOrigin  4:EndOrigin
	string Shadahar2_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (hit)
		{
			if (SWIPE_ATTACK)
				AddVelocity(ENT_LASTSTRUCKBYME, Vec(ATTACK_PUSH));
			SWIPE_ATTACK = false;

			if (STUN_ATTACK)
			{
				PlaySound(0, 10, SOUND_LAUGH);
				ApplyEffect(target, "effects/debuff_stun", Random(5, 10), self);
			}
		}
		STUN_ATTACK = false;
		return result;
	}

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type
	string Shadahar2_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		if (TELEPORT_SEQUENCE)
			return result;

		if (CUR_TELE_POINT < N_TELE_POINTS && HealthOf(ENT_ME) <= 3000.0f)
			OnTeleportNextPoint();

		if (TELEPORT_SEQUENCE)
			result = AppendResult(result, "0 .0");

		if (TELEPORT_SEQUENCE)
			return result;

		if (damageType != "holy")
			PlayRandomSound(2, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK4, SOUND_STRUCK5);
		else
			PlayRandomSound(2, 10, SOUND_HOLY_STRIKE);
		return result;
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("monsters/summon/circle_of_death");
		PrecacheFile("monsters/eye_drainer");
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		Effect("beam", "update", @BEAM_EYE1, "brightness", 0);
		Effect("beam", "update", @BEAM_EYE2, "brightness", 0);
		Effect("beam", "update", @BEAM_EYE1, "remove", 0.1f);
		Effect("beam", "update", @BEAM_EYE2, "remove", 0.1f);
		UseTrigger("door_palace");
		ClientEvent("remove", "all", MY_CL_IDX);
		OnBmGoldSpew(500, "1", 32, 2, 4);
		SetGlobal("G_WEATHER_LOCK", 0);
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

		SetGlobal("global.map.weather", "fog_black;fog_black;flog_black");
		SetGlobal("G_WEATHER_LOCK", "fog_black");
		CallExternal("players", "ext_weather_change", GetVar("G_WEATHER_LOCK"));

		// give time for telepoints to spawn
		// should really be on a seperate spawner :/
		// (moved to global, but must recompile)
		CallEventDelayed(8.0f, "get_tele_points");

		CallExternal("all", "bo_zombie_mode");
		ClientEvent("new", "all", "mscave/shadahar_cl");
		MY_CL_IDX = LastClientScriptId();
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttack_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack

		if (!DID_WARCRY)
		{
			DID_WARCRY = true;
			PlaySound(0, 10, SOUND_LAUGH);
		}

		if (!STARTED_CYCLES)
		{
			STARTED_CYCLES = true;
			CallEventDelayed(FREQ_SPECIAL, "do_special");
		}
	}

	// npcatk_clear_targets
	void OnNpcatkClearTargets(string reason = "")
	{
		BaseNpcAttack_OnNpcatkClearTargets(reason); // monsters/base_npc_attack
		BaseMonsterShared_OnNpcatkClearTargets(reason); // monsters/base_monster_shared
		BaseMonsterShared_OnNpcatkClearTargets_2(reason); // monsters/base_monster_shared
		OnStayStill();
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		if (ToLowerCase(MapName()) == "mscave")
			NPC_GIVE_EXP = 10000.0f;
		else
			DeleteEntity(ENT_ME);

		if (Truthy(GetVar("G_SHAD_PRESENT"))) // someone's cheating - I'm already here
			DeleteEntity(ENT_ME);

		SetName("Remains of Shadahar");

		SetModel("monsters/skeleton_enraged.mdl");
		SetModelBody(0, 6);
		SetModelBody(1, WAND_UNLIT);
		SetWidth(32);
		SetHeight(80);

		SetRace("undead");
		SetHealth(6000);
		SetRoam(true);
		SetHearingSensitivity(4);
		SetNoPush(true);

		// skeleton attribs +armor
		SetDamageTaken("all", 0.7f);
		SetDamageTaken("slash", 0.7f);
		SetDamageTaken("pierce", 0.5f);
		SetDamageTaken("blunt", 1.2f);
		SetDamageTaken("holy", 2);
		SetDamageTaken("cold", 0.1f);
		SetDamageTaken("poison", 0);

		SetSayTextRange(1024);

		// moar intro fx
		Vector3 mySky = MyOrigin() + Vector3(0, 0, 4096);
		Vector3 myCenter = OriginOf(ENT_ME) + Vector3(0, 0, -48);
		ClientEvent("new", "all_in_sight", "effects/sfx_lightning", myCenter, mySky, 1, 1);

		SetGlobal("G_SHAD_PRESENT", 1);

		MAX_EYES = 2;
		if (PlayerCount() >= 4)
			MAX_EYES = 4;

		CallEventDelayed(0.1f, "init_beam1");
	}

	// npcatk_hunt
	// stay still after teleports until you have a target
	void OnNpcatkHunt()
	{
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck

		if (STAY_NEAR_HOME)
		{
			// stay near spawn point towards final death so folks see the door open
			if (!IsAlive(NPCATK_TARGET) && GameTime() > LAST_RETURN_TIME)
			{
				SetMoveDest(NPC_HOME_LOC, 10);
				LAST_RETURN_TIME = GameTime() + 2.0f;
			}
		}
		if (STAY_NEAR_HOME)
			return;
		if (IsAlive(NPCATK_TARGET))
			return;
		if (!AM_MOBILE)
			return;
		OnStayStill();
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, Shadahar2_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, Shadahar2_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		string proNoun = "PRO_NOUN";

		if (!DID_ORC_COMMENT && SET_TELE_POINTS && CUR_TELE_POINT == 0.0f && RangeTo(NPCATK_TARGET) < 768.0f)
		{
			DID_ORC_COMMENT = true;
			if (PlayerCount() > 1)
				proNoun = "yourselves.";
			if (PlayerCount() == 1)
				proNoun = "yourself.";
			SayText("Filthy Orcs! More useful dead than alive. Much like " + proNoun);
		}

		if (AM_MOBILE)
			return;
		OnResumeMovement();
	}

	// init_beam1
	void OnInitBeam1()
	{
		Effect("beam", "vector", "laserbeam.spr", 30, AttachmentPositionOf(ENT_ME, 1), OriginOf(ENT_ME), Vector3(255, 0, 255), 0, 10, -1);
		@BEAM_EYE1 = EntityOf(ENT_LASTCREATED);
		CallEventDelayed(1.0f, "init_beam2");
	}

	// init_beam2
	void OnInitBeam2()
	{
		Effect("beam", "vector", "laserbeam.spr", 30, AttachmentPositionOf(ENT_ME, 2), OriginOf(ENT_ME), Vector3(255, 0, 255), 0, 10, -1);
		@BEAM_EYE2 = EntityOf(ENT_LASTCREATED);
	}

	// attack_1
	// Deal damage
	void OnAttack12()
	{
		ATTACK_PUSH = Text(RelativeVelocity(Vector3(-100, 130, 120)));
		SWIPE_ATTACK = true;
		PlayRandomSound(1, 5, SOUND_ATTACK1, SOUND_ATTACK2, "none", "none");
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_SWIPE, ATTACK_HITCHANCE);
		if (RandomInt(1, 30) != 1)
			return;
		ANIM_ATTACK = ANIM_SMASH;
	}

	// attack_3
	// Deal damage
	void OnAttack3()
	{
		STUN_ATTACK = true;
		PlayRandomSound(1, 5, SOUND_ATTACK1, SOUND_ATTACK2, "none", "none");
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_SWIPE, ATTACK_HITCHANCE);
		ANIM_ATTACK = ANIM_SWIPE;
	}

	// get_tele_points
	void OnGetTelePoints()
	{
		// get teleport points from gamemaster
		MY_TELE_POINTS = ScriptVarOf(GetVar("GAME_MASTER"), "SHAD_TELEPOINTS");
		MY_TRIGGERS = ScriptVarOf(GetVar("GAME_MASTER"), "SHAD_TRIGGERS");
		MY_TELE_POINTS = TokenAdd(MY_TELE_POINTS, NPC_HOME_LOC);
		MY_TRIGGERS = TokenAdd(MY_TRIGGERS, "none");
		N_TELE_POINTS = GetTokenCount(MY_TELE_POINTS) - 1.0f;
		CUR_TELE_POINT = -1.0f;
		SET_TELE_POINTS = true;
	}

	// teleport_next_point
	void OnTeleportNextPoint()
	{
		TELEPORT_SEQUENCE = true;

		if (CUR_TELE_POINT == -1.0f)
			SayText("Let's see just how well you know these caves...");
		if (CUR_TELE_POINT == 0.0f)
			SayText("Time for more hide and seek...");
		if (CUR_TELE_POINT == 1.0f)
			SayText("You seem to know these caves pretty well.");
		if (CUR_TELE_POINT == 2.0f)
			SayText("I'm sure you can find me again...");
		if (CUR_TELE_POINT == 3.0f)
			SayText("My my, such a persistant seeker.");
		if (CUR_TELE_POINT == 4.0f)
			SayText("Such fun! But can you find me again?");
		if (CUR_TELE_POINT == 5.0f)
			SayText("Come find me on the bridge of fire...");
		if (CUR_TELE_POINT == 6.0f)
			SayText("My defeat shall not come about so easily as this...");

		PlaySound(0, 10, "ambience/particle_suck2.wav");
		OnNpcatkClearTargets();
		OnNpcatkSuspendAi();
		PlayAnim("critical", ANIM_CAST);
		SetIdleAnim(ANIM_CAST);
		SetMoveAnim(ANIM_CAST);
		Effect("screenfade", "all", 2, 1, Vector3(255, 255, 255), 255, "fadeout");
		CallEventDelayed(2.0f, "teleport_fx_fadein");
		CUR_TELE_POINT += 1.0f;
		SetAnimFrameRate(0.5f);
		SetGravity(0);

		// make a temp light here, or somethin
		CallEventDelayed(0.01f, "float_up");
		CallEventDelayed(2.01f, "teleport_next_point2");
	}

	// teleport_fx_fadein
	void OnTeleportFxFadein()
	{
		Effect("screenfade", "all", 2, 1, Vector3(255, 255, 255), 255, "fadein");
	}

	// float_up
	void OnFloatUp()
	{
		if (!TELEPORT_SEQUENCE)
			return;
		CallEventDelayed(0.1f, "float_up");
		Vector3 curPos = OriginOf(ENT_ME);
		curPos.z += 1.0f;
		SetOrigin(ENT_ME, curPos);
	}

	// teleport_next_point2
	void OnTeleportNextPoint2()
	{
		PlaySound(0, 10, SOUND_LAUGH);
		SetAnimFrameRate(1);
		TELEPORT_SEQUENCE = false;
		SetOrigin(ENT_ME, Vec(GetToken(MY_TELE_POINTS, int(CUR_TELE_POINT))));
		SetHealth(6000);
		LegacyCommand("blind", 0);
		OnNpcatkResumeAi();
		OnNpcatkClearTargets();
		SetGravity(1);
		OnStayStill();

		// meh, gettin lazy, hopefully Shad'd taunts are enough to get the idea accross
		// if ( TAUNTER_ID equals 'TAUNTER_ID' )
		// {
		// //this invisible ent floats arounds heads and whispers "hide and seek"
		// createnpc mscave/shad_taunter $get(ent_me,id)
		// setvard TAUNTER_ID $get(ent_lastcreated,id)
		// }
		CUR_TRIG = GetToken(MY_TRIGGERS, int(CUR_TELE_POINT));
		UseTrigger(CUR_TRIG);

		if (CUR_TRIG == "spawn_firereaver")
		{
			// stationary on bridge
			OnDoFireballs();
			ANIM_WALK = "idle1";
			ANIM_RUN = "idle1";
			OnStayStill();
			SetGlobal("global.map.weather", "fog_red;fog_red;fog_red");
			SetGlobal("G_WEATHER_LOCK", "fog_red");
			CallExternal("players", "ext_weather_change", GetVar("G_WEATHER_LOCK"));
		}
		if (CUR_TELE_POINT == N_TELE_POINTS)
		{
			// panic time
			STAY_NEAR_HOME = true;
			ANIM_MOVE = "run";
			ANIM_RUN = ANIM_MOVE;
			ANIM_WALK = "walk";
			SetGlobal("global.map.weather", "clear;clear;clear");
			SetGlobal("G_WEATHER_LOCK", 0);
			CallExternal("players", "ext_weather_change", "clear");
		}
	}

	// do_special
	void OnDoSpecial()
	{
		if (!IsAlive(ENT_ME))
			return;
		CallEventDelayed(FREQ_SPECIAL, "do_special");

		if (DOING_SPECIAL)
			return;
		if (TELEPORT_SEQUENCE)
			return;

		if (!IsAlive(NPCATK_TARGET))
			return;

		int pickSpecial = RandomInt(1, 2);
		if (N_EYES < MAX_EYES)
			pickSpecial = RandomInt(1, 3);

		// local PICK_SPECIAL 3 //devxxx
		if (pickSpecial == 1)
			OnDoCircles();
		if (pickSpecial == 2)
			OnDoEyebeams();
		if (pickSpecial == 3)
			OnDoSummonEye();
	}

	// do_circles
	void OnDoCircles()
	{
		DOING_SPECIAL = true;
		PlaySound(0, 10, SOUND_LAUGH);

		PlayAnim("critical", ANIM_CAST);

		SetVar("PLAYER_LIST", GetActivePlayers());
		N_CIRC_PLAYERS = GetTokenCount("PLAYER_LIST");
		PLAYER_ORGS = "";
		int count = int(N_CIRC_PLAYERS);
		int outerIteration = loopIteration;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnIdsToPos();
		}
		loopIteration = outerIteration;
		N_CIRC_PLAYERS -= 1.0f;

		CIRCLES_ON = false;
		OnWandSparkles();
		CallEventDelayed(1.0f, "do_circles2");
	}

	// wand_sparkles
	void OnWandSparkles()
	{
		if (CIRCLES_ON)
			return;
		CallEventDelayed(0.1f, "wand_sparkles");
		ClientEvent("update", "all", MY_CL_IDX, "wand_prep_cl", AttachmentPositionOf(ENT_ME, ATTACH_IDX_WAND), Vector3(255, 0, 0));
	}

	// do_circles2
	void OnDoCircles2()
	{
		CIRCLES_ON = true;

		CIRC_PLAYER_IDX = 0.0f;

		DOING_SPECIAL = false;
		OnSealPlayers();
	}

	// ids_to_pos
	void OnIdsToPos()
	{
		string curPlayer = GetToken("PLAYER_LIST", loopIteration);
		Vector3 curPlayerOrg = OriginOf(curPlayer);
		PLAYER_ORGS = TokenAdd(PLAYER_ORGS, Text(curPlayerOrg));
	}

	// seal_players
	void OnSealPlayers()
	{
		string curPlayerOrg = GetToken(PLAYER_ORGS, int(CIRC_PLAYER_IDX));

		if (Distance(MyOrigin(), Vec(PLAYER_ORGS)) < 800.0f)
		{
			CreateNpc("monsters/summon/circle_of_death", RelativePosition(Vector3(0, 0, 0)), self, 100, 100, 10.0f); // PARAM1=Owner PARAM2=radius PARAM3=Damage PARAM4=Duration [PARAM5=skill]
		}

		if (!(CIRC_PLAYER_IDX < N_CIRC_PLAYERS))
			return;
		CIRC_PLAYER_IDX += 1.0f;
		CallEventDelayed(0.1f, "seal_players");
	}

	// do_eyebeams
	void OnDoEyebeams()
	{
		DOING_SPECIAL = true;
		PlayAnim("critical", ANIM_CAST);
		SetMoveDest("none");
		OnNpcatkSuspendAi();
		SetIdleAnim(ANIM_CAST);
		SetMoveAnim(ANIM_CAST);
		NO_STUCK_CHECKS = "1";
		LegacyCommand("blind", 1);
		SetRoam(false);
		EYE_BEAM_WARMUP = true;
		MY_YAW = AnglesOf(ENT_ME).y;
		OnEyeWarmupLoop();
		CallEventDelayed(2.0f, "do_eyebeams2");
	}

	// eye_warmup_loop
	void OnEyeWarmupLoop()
	{
		float myYaw = MY_YAW;
		if (!EYE_BEAM_WARMUP)
			return;
		CallEventDelayed(0.1f, "eye_warmup_loop");
		myYaw -= 1.0f;
		if (myYaw < 0.0f)
			myYaw = 359.99f;
		SetAngle("face", Vector3(0, myYaw, 0));
		ClientEvent("update", "all", MY_CL_IDX, "eye_beam_prep_cl", AttachmentPositionOf(ENT_ME, ATTACH_IDX_EYE1), AttachmentPositionOf(ENT_ME, ATTACH_IDX_EYE2));
	}

	// do_eyebeams2
	void OnDoEyebeams2()
	{
		EYE_BEAM_WARMUP = false; // end client effect

		PlaySound(0, 10, SOUND_BEAM_FIRE);
		ServerPlaySound(1, 10, "ambience/zapmachine.wav");

		Effect("beam", "update", @BEAM_EYE1, "brightness", 128);
		Effect("beam", "update", @BEAM_EYE2, "brightness", 128);

		// snap back a bit
		// local MY_YAW $get(ent_me,angles.yaw)
		// subtract MY_YAW 35
		// if ( MY_YAW < 0 ) add MY_YAW 359.99
		// setangle face $vec(0,MY_YAW,0)
		// freeze
		SetAnimFrameRate(0);

		BEAM_COUNT = 0.0f;
		MY_YAW = AnglesOf(ENT_ME).y;
		CallEventDelayed(0.1f, "do_eyebeam_cycle");
	}

	// do_eyebeam_cycle
	void OnDoEyebeamCycle()
	{
		if (!IsAlive(ENT_ME))
			return;

		MY_YAW += 1.0f;
		if (MY_YAW > 359.99f)
			MY_YAW -= 359.99f;
		SetAngle("face", Vector3(0, MY_YAW, 0));
		// setmovedest $relpos($vec(0,MY_YAW,0,),$vec(0,128,0)) 64
		DebugPrint("do_eyebeam_cycle " + Text(MY_YAW));

		Vector3 beam1Start = AttachmentPositionOf(ENT_ME, ATTACH_IDX_EYE1);
		Vector3 beam2Start = AttachmentPositionOf(ENT_ME, ATTACH_IDX_EYE2);
		string beam1End = Text(beam1Start);
		string beam2End = Text(beam2Start);
		beam1End = Text(Vec(beam1End) + RelativePosition(Vector3(0, MY_YAW, 0), Vector3(0, 1000, -200)));
		beam2End = Text(Vec(beam2End) + RelativePosition(Vector3(0, MY_YAW, 0), Vector3(0, 1000, -200)));
		beam1End = LegacyFunction("get_traceline", beam1Start, beam1End, "worldonly");
		beam2End = LegacyFunction("get_traceline", beam2Start, beam2End, "worldonly");
		Effect("beam", "update", @BEAM_EYE1, "points", beam1Start, beam1End);
		Effect("beam", "update", @BEAM_EYE2, "points", beam2Start, beam2End);
		DoDamageEx(beam1Start, beam1End, DMG_BEAM, "100%", ENT_ME, ENT_ME, "none", "dark");
		DoDamageEx(beam2Start, beam2End, DMG_BEAM, "100%", ENT_ME, ENT_ME, "none", "dark");

		BEAM_COUNT += 1.0f;
		if (TELEPORT_SEQUENCE) // abort
			BEAM_COUNT = 120.0f;
		if (BEAM_COUNT == 120.0f)
			OnDoEyebeamEnd();
		else
			CallEventDelayed(0.1f, "do_eyebeam_cycle");
	}

	// do_eyebeam_end
	void OnDoEyebeamEnd()
	{
		if (!TELEPORT_SEQUENCE)
		{
			SetIdleAnim(ANIM_IDLE);
			SetMoveAnim(ANIM_MOVE);
		}

		if (AM_MOBILE)
			SetRoam(true);

		SetAnimFrameRate(1);
		ServerPlaySound(1, 0, "ambience/zapmachine.wav");
		OnNpcatkResumeAi();
		Effect("beam", "update", @BEAM_EYE1, "brightness", 0);
		Effect("beam", "update", @BEAM_EYE2, "brightness", 0);
		DOING_SPECIAL = false;
		if (TELEPORT_SEQUENCE)
		{
			// aborted
			PlayAnim("critical", ANIM_CAST);
			SetIdleAnim(ANIM_CAST);
			SetMoveAnim(ANIM_CAST);
		}
	}

	// do_summon_eye
	void OnDoSummonEye()
	{
		OnNpcatkSuspendAi();
		PlayAnim("critical", ANIM_CAST);
		PlaySound(0, 10, SOUND_LAUGH);
		SetModelBody(1, WAND_LIT);

		float rndAng = Random(0, 359);
		Vector3 summonAdj = RelativePosition(Vector3(0, rndAng, 0), Vector3(0, 64, 32));
		SUMMON_POS = MyOrigin() + summonAdj;

		Vector3 beamTop = SUMMON_POS;
		Vector3 beamBottom = SUMMON_POS;
		beamBottom.z = GroundHeight(SUMMON_POS);
		beamTop.z += 1024.0f;
		Effect("beam", "vector", "lgtning.spr", 200, beamBottom, beamTop, Vector3(64, 64, 255), 200, 50, 3.0f);

		CallEventDelayed(1.5f, "do_summon_eye2");
		SUMMON_WARMUP = true;
		CallEventDelayed(0.01f, "summon_warmup_loop");
	}

	// summon_warmup_loop
	void OnSummonWarmupLoop()
	{
		if (!SUMMON_WARMUP)
			return;
		CallEventDelayed(0.1f, "summon_warmup_loop");
		ClientEvent("update", "all", MY_CL_IDX, "wand_prep_cl", AttachmentPositionOf(ENT_ME, ATTACH_IDX_WAND), Vector3(0, 0, 255));
	}

	// do_summon_eye2
	void OnDoSummonEye2()
	{
		SUMMON_WARMUP = false;
		SetModelBody(1, WAND_UNLIT);
		OnNpcatkResumeAi();
		DebugPrint("do_summon_eye2 " + Text(SUMMON_POS));
		CreateNpc("monsters/eye_drainer", SUMMON_POS, self);
		N_EYES += 1.0f;
	}

	// eye_died
	void OnEyeDied()
	{
		N_EYES -= 1.0f;
	}

	// do_fireballs
	void OnDoFireballs()
	{
		if (CUR_TRIG != "spawn_firereaver")
			return;
		CallEventDelayed(1.0f, "do_fireballs");
		// no moving on bridge
		SetMoveSpeed(0);
		SetMoveAnim("idle1");
		SetIdleAnim("idle1");
		if (!IsAlive(NPCATK_TARGET))
			return;
		if (!(RangeTo(NPCATK_TARGET) < 800.0f))
			return;

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_fire_xolt", RelativePosition(Vector3(0, 8, 32)), NPCATK_TARGET, 400, DMG_FIRE_BOLT, 2, "none");
	}

	// stay_still
	void OnStayStill()
	{
		SetRoam(false);
		AM_MOBILE = false;
		SetMoveAnim("idle1");
		SetIdleAnim("idle1");
		SetMoveSpeed(0);
	}

	// resume_movement
	void OnResumeMovement()
	{
		SetRoam(true);
		AM_MOBILE = true;
		SetMoveAnim(ANIM_MOVE);
		SetIdleAnim("idle1");
		SetMoveSpeed(1);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreqSpecial() {} // FREQ_SPECIAL

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("bonegibs.mdl");
		Precache("monsters/skeleton_enraged.mdl");
		Precache("ambience/zapmachine.wav");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Shadahar2_FirstThink();
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
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_3") { OnAttack3(); return true; }
		if (name == "do_circles") { OnDoCircles(); return true; }
		if (name == "do_circles2") { OnDoCircles2(); return true; }
		if (name == "do_eyebeam_cycle") { OnDoEyebeamCycle(); return true; }
		if (name == "do_eyebeam_end") { OnDoEyebeamEnd(); return true; }
		if (name == "do_eyebeams") { OnDoEyebeams(); return true; }
		if (name == "do_eyebeams2") { OnDoEyebeams2(); return true; }
		if (name == "do_fireballs") { OnDoFireballs(); return true; }
		if (name == "do_special") { OnDoSpecial(); return true; }
		if (name == "do_summon_eye") { OnDoSummonEye(); return true; }
		if (name == "do_summon_eye2") { OnDoSummonEye2(); return true; }
		if (name == "eye_died") { OnEyeDied(); return true; }
		if (name == "eye_warmup_loop") { OnEyeWarmupLoop(); return true; }
		if (name == "float_up") { OnFloatUp(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "get_tele_points") { OnGetTelePoints(); return true; }
		if (name == "ids_to_pos") { OnIdsToPos(); return true; }
		if (name == "init_beam1") { OnInitBeam1(); return true; }
		if (name == "init_beam2") { OnInitBeam2(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_clear_targets") { OnNpcatkClearTargets(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "resume_movement") { OnResumeMovement(); return true; }
		if (name == "seal_players") { OnSealPlayers(); return true; }
		if (name == "stay_still") { OnStayStill(); return true; }
		if (name == "summon_warmup_loop") { OnSummonWarmupLoop(); return true; }
		if (name == "teleport_fx_fadein") { OnTeleportFxFadein(); return true; }
		if (name == "teleport_next_point") { OnTeleportNextPoint(); return true; }
		if (name == "teleport_next_point2") { OnTeleportNextPoint2(); return true; }
		if (name == "wand_sparkles") { OnWandSparkles(); return true; }
		return BaseMonsterScript::DispatchEvent(name, params);
	}
}
