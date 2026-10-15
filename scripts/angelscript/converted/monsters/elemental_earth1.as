#pragma context server

// Converted from monsters/elemental_earth1.script by msc_transpiler.
// Earth Elemental (basic)
// - ideas:
// - locks a target and blocks all attacks from that direction for several seconds
// - summons rocks from sky, drop on player
// - creates a fissure in the ground, stunning targets (use firebreaker fx, sans fire)
// - (greater) Summons rock swarm ala maldora/stone skeles
// - (greater) Causes earthquake, raining down rock gibs and stunning all in area
// - (greater) Encase in stone effect
// - No resistances, save poison and lightning, but heavy armor
// - Reflects lightning damage

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_propelled.as"
#include "converted/monsters/base_struck.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ElementalEarth1
{
	// Constants
	string ANIM_SEARCH = "dunno";
	int ELEMENTAL_EXP = 300;
	int MOVE_FAST = 100;
	int MOVE_NORMAL = 50;
	int ELEMENTAL_MOVERANGE = 2048;
	string SOUND_DEATH = "garg/gar_die1.wav";
	string NPC_MATERIAL_TYPE = "stone";
	bool NPC_USE_FLINCH = true;
	int NPC_PITCH_FLINCH = 60;
	string SOUND_FLINCH1 = "debris/bustflesh2.wav";
	string SOUND_FLINCH2 = "agrunt/ag_pain1.wav";
	string SOUND_FLINCH3 = "agrunt/ag_pain4.wav";
	bool NPC_USE_PAIN = true;
	int NPC_PITCH_PAIN = 60;
	string SOUND_PAIN1 = "debris/bustflesh2.wav";
	string SOUND_PAIN2 = "agrunt/ag_pain1.wav";
	string SOUND_PAIN3 = "agrunt/ag_pain4.wav";
	bool NPC_USE_IDLE = true;
	int NPC_PITCH_IDLE = 60;
	string SOUND_IDLE1 = "agrunt/ag_alert1.wav";
	string SOUND_IDLE2 = "agrunt/ag_die1.wav";
	string SOUND_IDLE3 = "agrunt/ag_idle1.wav";
	int ELEMENTAL_LEVEL = 1;
	int SWIPE_RANGE = 100;
	int SWIPE_HITRANGE = 150;
	string SOUND_ALERT = "agrunt/ag_alert5.wav";
	int PITCH_LEVEL = 60;
	string SOUND_SWIPE_MISS = "weapons/debris1.wav";
	string SOUND_SWIPE_HIT = "weapons/cbar_hitbod1.wav";
	string SOUND_SHOCK1 = "debris/zap8.wav";
	string SOUND_SHOCK2 = "debris/zap3.wav";
	string SOUND_SHOCK3 = "debris/zap4.wav";
	string SOUND_EARTHQUAKE_START = "magic/volcano_start.wav";
	string SOUND_EARTHQUAKE_LOOP = "magic/volcano_loop.wav";
	float FREQ_ROCK = 3.0f;
	float FREQ_FISSURE = 0.0f;
	float FREQ_LONG = 0.0f;
	int NUM_LONGS = 1;
	float SHIELD_DURATION = 10.0f;
	float EARTHQUAKE_DURATION = 10.0f;
	int EARTHQUAKE_AOE = 512;
	int HITCHANCE_SWIPE = 80;
	string DMG_SWIPE = "DMG_SWIPE";
	int DMG_ROCK = 0;
	int DMG_FISSURE = 0;
	float DMG_STORM = 0.0f;
	int DOT_EARTHQUAKE = 100;
	float FISSURE_LENGTH = 768.0f;
	string ANIM_TOCHARGE = "tocharge";
	string ANIM_CHARGEIDLE = "charging";
	string ANIM_FROMCHARGE = "fromcharge";
	string ANIM_ALERT = "yes";
	string ANIM_ROCK = "no";
	string ANIM_FIRE_BALL = "fireball";
	string ANIM_QUICKBLOCK = "block";

	// Variables (an unset .script variable reads as its own name)
	bool AS_SUMMON_TELE_CHECK = true;
	string ANIM_IDLE = "idle1";
	string ANIM_WALK = "idle1";
	string ANIM_RUN = "idle1";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	bool NPC_NO_ATTACK = false;
	float NPC_GIVE_EXP = 0.0f;
	float NPC_HACKED_MOVE_SPEED = 0.0f;
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	string ANIM_FLINCH = "ANIM_FLINCH";
	bool IS_BLOODLESS = false;
	bool IMMUNE_VAMPIRE = false;
	bool IS_UNHOLY = false;
	bool DID_ALERT = false;
	float NEXT_ACTION = 0.0f;
	bool ATTACK_CYCLE = false;
	float NEXT_ROCK = 0.0f;
	float NEXT_FISSURE = 0.0f;
	float NEXT_LONG = 0.0f;
	bool DID_SPECIAL = false;
	float LONG_SELECT = 0.0f;
	Vector3 ROCK_STRIKE_POS = Vector3();
	Vector3 BURST_POS = Vector3();
	float NEXT_SHOCK_MSG = 0.0f;
	float NEXT_BEAM = 0.0f;
	float NEXT_SHIELD_HITFX = 0.0f;
	float AS_ATTACKING = 0.0f;
	Vector3 FISSURE_ORG = Vector3();
	Vector3 FISSURE_ANG = Vector3();
	Vector3 FISSURE_DIR = Vector3();
	float FISSURE_MOVESTEP = 0.0f;
	float FISSURE_COUNT = 0.0f;
	string FISSURE_CHECK_POS = "FISSURE_CHECK_POS";
	string SHIELD_TARGET = "SHIELD_TARGET";
	bool SHIELD_ACTIVE = false;
	bool SUSPEND_CYCLE = false;
	string CL_SHIELD_IDX = "CL_SHIELD_IDX";
	string NPCATK_TARGET = "NPCATK_TARGET";
	bool EARTHQUAKE_ACTIVE = false;
	string EARTHQUAKE_TARGS = "EARTHQUAKE_TARGS";

	// unnamed block (first think)
	void ElementalEarth1_FirstThink()
	{
		// base attack/npc/antistuck
		AS_SUMMON_TELE_CHECK = true;
		ANIM_IDLE = "idle1";
		ANIM_WALK = "idle1";
		ANIM_RUN = "idle1";
		ANIM_ATTACK = "attack1"; // attack1_strike
		ANIM_DEATH = "die1";
		NPC_NO_ATTACK = true; // custom attack sequence
		NPC_GIVE_EXP = ELEMENTAL_EXP;
		NPC_HACKED_MOVE_SPEED = MOVE_NORMAL;
		ATTACK_RANGE = ELEMENTAL_MOVERANGE;
		ATTACK_HITRANGE = ELEMENTAL_MOVERANGE;
		ATTACK_MOVERANGE = ELEMENTAL_MOVERANGE;
		ANIM_FLINCH = "flinch";
	}

	// game_precache
	void ElementalEarth1_OnGamePrecache()
	{
		PrecacheFile("monsters/elemental_earth_cl");
	}

	// fake_precache
	void ElementalEarth1_OnFakePrecache()
	{
		ServerPlaySound(0, 0, SOUND_SHOCK1);
		ServerPlaySound(0, 0, SOUND_SHOCK2);
		ServerPlaySound(0, 0, SOUND_SHOCK3);
		ServerPlaySound(0, 0, "weapons/debris1.wav");
		ServerPlaySound(0, 0, SOUND_EARTHQUAKE_START);
		ServerPlaySound(0, 0, SOUND_EARTHQUAKE_LOOP);
	}

	// npc_spawn
	void ElementalEarth1_OnNpcSpawn(string npc = "")
	{
		OnElementalSpawn();
	}

	// elemental_spawn
	void ElementalEarth1_OnElementalSpawn()
	{
		SetName("Earth Elemental");
		SetModel("monsters/elementals_lesser.mdl");
		SetHealth(500);
		SetWidth(32);
		SetHeight(96);
		SetRace("demon");
		SetBlood("none");
		IS_BLOODLESS = true;
		IMMUNE_VAMPIRE = true;
		IS_UNHOLY = true;
		SetDamageTaken("all", 0.30f);
		SetDamageTaken("holy", 3);
		// takedmg lightning 0.0
		SetDamageTaken("poison", 0);
		SetRoam(true);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetHearingSensitivity(5);
		SetModelBody(0, 3); // maybe different on greater (elder model)
	}

	// npc_targetsighted
	void ElementalEarth1_OnNpcTargetsighted(string target = "")
	{
		bool exitSub = false;
		float gameTime = GameTime();
		if (!(gameTime > NEXT_ACTION))
			return;

		if (SUSPEND_AI)
			return;

		if (!DID_ALERT)
		{
			PlaySound(0, 10, SOUND_ALERT, 0.8f, PITCH_LEVEL);
			PlayAnim("critical", ANIM_ALERT);
			DID_ALERT = true;
			NEXT_ACTION = gameTime + 0.5f;
			exitSub = true; // would use exitevent here, but worried what it might do to base
			ATTACK_CYCLE = false;
			NEXT_ROCK = gameTime + FREQ_ROCK;
			NEXT_FISSURE = gameTime + FREQ_FISSURE;
			NEXT_LONG = gameTime + FREQ_LONG; // earthquake, block, storm
		}
		if (exitSub)
			return;

		if (I_R_FROZEN)
			return;

		if (SUSPEND_CYCLE)
			return;

		if (gameTime > NEXT_LONG && RangeTo(NPCATK_TARGET) < 640.0f)
		{
			DID_SPECIAL = true;
			if (LONG_SELECT >= NUM_LONGS)
				LONG_SELECT = 0.0f;
			LONG_SELECT += 1.0f;
			NEXT_LONG = gameTime + FREQ_LONG;

			if (LONG_SELECT == 1.0f)
			{
				NEXT_ACTION = gameTime + 1.0f;
				OnDoShield();
				exitSub = true;
			}
			else if (LONG_SELECT == 2.0f)
			{
				OnDoEarthquake();
				exitSub = true;
			}
			else if (LONG_SELECT == 3.0f)
			{
				NEXT_ACTION = gameTime + 1.0f;
				OnDoStorm();
				exitSub = true;
			}
		}
		if (exitSub)
			return;

		if (gameTime > NEXT_FISSURE && RangeTo(NPCATK_TARGET) < 640.0f)
		{
			NEXT_FISSURE = gameTime + FREQ_FISSURE;
			NEXT_ACTION = gameTime + 4.0f; // despite this, bastard is still tossing rocks right after fissures
			NEXT_ROCK = gameTime + 5.0f;
			PlayAnim("critical", ANIM_FIRE_BALL);
			DID_SPECIAL = true;
			OnDoFissure();
		}
		if (exitSub)
			return;

		// default attack, summon rock from sky, with bit of a delay
		if (gameTime > NEXT_ROCK)
		{
			PlayAnim("critical", ANIM_ROCK);
			OnSummonRock(OriginOf(NPCATK_TARGET));
			NEXT_ROCK = gameTime + FREQ_ROCK;
			DID_SPECIAL = true;
			exitSub = true;
		}
		if (exitSub)
			return;

		// if I'm not doing anything else, just punch him
		if (RangeTo(NPCATK_TARGET) < SWIPE_RANGE && DID_SPECIAL)
		{
			NEXT_ROCK = gameTime + FREQ_ROCK;
			PlayAnim("once", ANIM_ATTACK);
		}
	}

	// attack1_strike
	void ElementalEarth1_OnAttack1Strike()
	{
		if (RandomInt(1, 3) == 1) // lets the mob alternate between rocks/specials and swipes
			DID_SPECIAL = false;
		DoDamageEx(NPCATK_TARGET, SWIPE_HITRANGE, DMG_SWIPE, HITCHANCE_SWIPE, ENT_ME, ENT_ME, "none", "blunt", "dmgevent:swipe");
	}

	// swipe_dodamage
	void ElementalEarth1_OnSwipeDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			PlaySound(0, 10, SOUND_SWIPE_MISS, 0.8f, PITCH_LEVEL);

		if (!hit)
			return;
		PlaySound(0, 10, SOUND_SWIPE_HIT, 0.8f, PITCH_LEVEL);
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		if (RandomInt(1, 3) != 1)
			return;
		if (ELEMENTAL_LEVEL == 1)
			ApplyEffect(target, "effects/debuff_stun", 5.0f, self);
		else
			ApplyEffect(target, "effects/debuff_stun", 3.0f, self);
	}

	// summon_rock
	// loc
	void ElementalEarth1_OnSummonRock(Vector3 location = Vector3())
	{
		string pos = Text(location);
		string traceStart = pos;
		string traceEnd = Text(Vec(pos) + Vector3(0.0f, 0.0f, 768.0f));
		string trace = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		pos = trace;
		if (trace != traceEnd)
			pos = Text(Vec(pos) + Vector3(0.0f, 0.0f, -64.0f));
		ClientEvent("new", "all", "monsters/elemental_earth_cl", IndexOf(ENT_ME), "spawn_rock", pos);

		float ground = GroundHeight(Vec(pos));
		float dropDist = ground - Vec(pos).z;

		if (dropDist < 0.0f)
			dropDist = -dropDist;

		float dropTime = Divide(dropDist, 600.0f) + 2.0f;

		ROCK_STRIKE_POS = Vector3(Vec(pos).x, Vec(pos).y, ground); // used in ext_mob_clreturn
		CallEventDelayed(dropTime, "ext_mob_clreturn");
	}

	// ext_mob_clreturn
	// <position> //called from game_master via monsters/elemental_earth_cl
	void ElementalEarth1_OnExtMobClreturn()
	{
		// effect tempent gibs rockgibs.mdl PARAM1 1 5 15 20 5
		Vector3 gibPos = ROCK_STRIKE_POS;
		gibPos.z = GroundHeight(gibPos);
		gibPos.z += 16.0f; // little off the ground so the models dont get lost
		Effect("tempent", "gibs", "rockgibs.mdl", ROCK_STRIKE_POS, 10.0f, RelativeVelocity(Vector3(0, 0, 0), Vector3(0, 0, 300)), 50, 100, 5);
		// effect tempent gibs <modelname/spritename> <position> <size> <velocity> <randomness> <amount> <duration>
		Effect("screenshake", ROCK_STRIKE_POS, 100, 5, 3, 500);
		BURST_POS = ROCK_STRIKE_POS;
		DoDamageEx(ROCK_STRIKE_POS, 128, DMG_ROCK, 0.1f, ENT_ME, ENT_ME, "none", "blunt_effect", "dmgevent:rock");
	}

	// rock_dodamage
	void ElementalEarth1_OnRockDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!(ELEMENTAL_LEVEL > 1))
			return;
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		OnRepelTarget(EntityId(target), Text(Vector3(0, 500, 110)), BURST_POS);
	}

	// repel_target
	// <target> <strength> <from_origin>
	void ElementalEarth1_OnRepelTarget(string target = "", string strength = "", Vector3 fromOrigin = Vector3())
	{
		Vector3 targOrg = OriginOf(target);
		float targAng = AnglesTo(fromOrigin, targOrg);
		int newYaw = int(targAng);
		SetVelocity(target, RelativeVelocity(Vector3(0, newYaw, 0), Vec(strength)));
	}

	// game_damaged
	string ElementalEarth1_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		bool exitSub = false;
		bool blocked = false;
		string result = "";

		// reflect lightning attacks
		if (Contains(damageType, "lightning") && RelationshipOf(attacker, ENT_ME) == "enemy")
		{
			int rndSnd = RandomInt(1, 3);
			if (rndSnd == 1)
				LegacyCommand("svsound.play3d", SOUND_SHOCK1, 10, OriginOf(attacker));
			else if (rndSnd == 2)
				LegacyCommand("svsound.play3d", SOUND_SHOCK2, 10, OriginOf(attacker));
			else if (rndSnd == 3)
				LegacyCommand("svsound.play3d", SOUND_SHOCK3, 10, OriginOf(attacker));

			PlayRandomSound(2, 10, SOUND_SHOCK1, SOUND_SHOCK2, SOUND_SHOCK3);

			if (GameTime() > NEXT_SHOCK_MSG)
			{
				PlayerMessage(attacker, NameOf(ENT_ME) + " redirects your electrical attacks!");
				NEXT_SHOCK_MSG = GameTime() + 5.0f;
			}

			DoDamageEx(@attacker, 1024, damage, "100%", ENT_ME, ENT_ME, "lightning_effect", "dmgevent:zap");
			if (GameTime() > NEXT_BEAM)
			{
				NEXT_BEAM = GameTime() + 0.5f;
				// effect beam ents lgtning.spr 30 ent_me 0 PARAM1 $rand(1,3) (128,128,255) 200 10 0.5 //players have no attachments lest in 3rd person or viewing others
				// effect beam end lgtning.spr 30 $get(PARAM1,origin) ent_me 0 (128,128,255) 200 10 0.5
				if (ELEMENTAL_LEVEL > 1)
				{
					// also heals
					GiveHealth(ENT_ME, damage);
					Effect("glow", ENT_ME, Vector3(0, 255, 0), 22, 0.5f, 0.25f);
				}
				exitSub = true;
			}
		}
		if (exitSub)
			return result;

		if (!SHIELD_ACTIVE)
			return result;

		if (Contains(damageType, "effect")) // /don't shield vs. DOT
			return result;

		Vector3 atkOrg = OriginOf(attacker);
		Vector3 myOrg = OriginOf(ENT_ME);
		Vector3 myAng = AnglesOf(ENT_ME);

		if (WithinCone2D(atkOrg, myOrg, myAng, 90))
			blocked = true;

		if (!blocked)
			return result;

		if (GameTime() > NEXT_SHIELD_HITFX)
		{
			NEXT_SHIELD_HITFX = GameTime() + 0.1f;
			ClientEvent("update", "all", CL_SHIELD_IDX, "shield_hit");

			PlaySound(2, 10, "player/pl_metal2.wav", 0.8f, PITCH_LEVEL);
			PlayerMessageDark(attacker, NameOf(ENT_ME) + " blocks your attack.");
		}
		return result;
	}

	// zap_dodamage
	void ElementalEarth1_OnZapDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		Effect("beam", "end", "lgtning.spr", 30, OriginOf(target), ENT_ME, 0, Vector3(128, 128, 255), 200, 10, 0.5f);
	}

	// do_fissure
	void ElementalEarth1_OnDoFissure()
	{
		AS_ATTACKING = GameTime() + 4.0f;
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, -1000, 0)));
		SetMoveDest(NPCATK_TARGET, 9999);
		CallEventDelayed(0.5f, "do_fissure2");
	}

	// do_fissure2
	void ElementalEarth1_OnDoFissure2()
	{
		// fissure attack land
		DebugPrint("attack1_strike");
		float myYaw = AnglesOf(ENT_ME).y;
		Vector3 fissureEnd = OriginOf(ENT_ME);
		fissureEnd += RelativePosition(Vector3(0, myYaw, 0), Vector3(0, FISSURE_LENGTH, 0));
		ClientEvent("new", "all", "effects/sfx_fissure", OriginOf(ENT_ME), myYaw, fissureEnd, FISSURE_LENGTH, 0, 1);
		// setvard FISSURE_TARGS $get_tsphere(any,1024)
		// if ( FISSURE_TARGS isnot none ) calleventloop $get_token_amt(FISSURE_TARGS) fissure_affect_targets
		// xdodamage $relpos(0,0,0) 1536 0 0 ent_me ent_me none target dmgevent:fissure
		// switch to xdodamage - and note that fissure is going back and forth rather than RL
		FISSURE_ORG = OriginOf(ENT_ME);
		FISSURE_ANG = AnglesOf(ENT_ME);
		FISSURE_DIR = DirectionTo(FISSURE_ORG, fissureEnd);
		FISSURE_MOVESTEP = FISSURE_LENGTH * 0.1f;
		// if $get_array_amt(ARRAY_FISSURE_TARGS) > 0
		FISSURE_COUNT = 0.0f;
		OnFissureTravelLoop();
	}

	// fissure_travel_loop
	void ElementalEarth1_OnFissureTravelLoop()
	{
		FISSURE_COUNT += 1.0f;
		Vector3 fissureCheckPos = FISSURE_ORG;
		Vector3 fissureMoveamt = FISSURE_DIR * (FISSURE_MOVESTEP * FISSURE_COUNT);
		fissureCheckPos += fissureMoveamt;
		fissureCheckPos.z += 128.0f;
		fissureCheckPos.z = GroundHeight(fissureCheckPos);
		FISSURE_CHECK_POS = Text(fissureCheckPos);
		DoDamageEx(fissureCheckPos, FISSURE_MOVESTEP, 0, 0, ENT_ME, ENT_ME, "none", "target", "dmgevent:fissure");
		if (FISSURE_COUNT < 7.0f)
			CallEventDelayed(0.20f, "fissure_travel_loop");
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
		{
			string vecUp = Text(fissureCheckPos);
			vecUp = Text(Vec(vecUp) + Vector3(0.0f, 0.0f, 64.0f));
			Effect("beam", "point", "lgtning.spr", 10, fissureCheckPos, vecUp, Vector3(255, 0, 255), 255, 0, 0.25f);
		}
		LegacyCommand("svsound.play3d", "weapons/debris1.wav", 10, fissureCheckPos, 0.8f, 0, 30);
	}

	// fissure_dodamage
	void ElementalEarth1_OnFissureDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;

		Vector3 curTargPos = OriginOf(target);
		float myYaw = FISSURE_ANG.y;
		int rndLr = RandomInt(0, 1);
		int lr = -400;
		if (rndLr == 1)
			lr = 400;
		Vector3 vel = Vector3(lr, 0, 400);

		Vector3 curTargAngs = AnglesOf(target);
		SetVelocity(target, RelativeVelocity(FISSURE_ANG, vel));
		if (RelationshipOf(ENT_ME, @target) != "enemy")
			return;
		ApplyEffect(target, "effects/debuff_stun", 3.0f, self);

		float dmg = DMG_ROCK;
		if (IsNoPush(target))
			dmg *= 5.0f;

		DoDamageEx(@target, "direct", dmg, "100%", ENT_ME, ENT_ME, "none", "blunt_effect");
	}

	// func_inrange
	// <number_to_check> <base> <+/-range>
	string ElementalEarth1_OnFuncInrange(string numberToCheck = "", string base = "", string range = "")
	{
		float inRange = 0.0f;
		string result = "";
		if (Float(numberToCheck) >= Float(base) - Float(range))
			inRange = 1.0f;
		if (Float(numberToCheck) <= Float(base) + Float(range))
			inRange += 1.0f;
		if (inRange > 1.0f)
			result = AppendResult(result, "1");
		else
			result = AppendResult(result, "0");
		return result;
	}

	// do_shield
	void ElementalEarth1_OnDoShield()
	{
		SHIELD_TARGET = NPCATK_TARGET;
		SHIELD_ACTIVE = true;
		CallEventDelayed(SHIELD_DURATION, "end_shield");

		if (ELEMENTAL_LEVEL == 1)
		{
			OnNpcatkSuspendMovement(ANIM_CHARGEIDLE);
			SUSPEND_CYCLE = true;
			OnShieldLoop(); // keep facing target
		}
		else
		{
			// greater variant continues to attack while shield is up, but still locks target
			PlayAnim("critical", ANIM_TOCHARGE);
		}

		Effect("glow", ENT_ME, Vector3(255, 255, 255), 16, 2, 1);

		PlaySound(0, 10, "magic/spawn.wav", 0.8f, PITCH_LEVEL);

		ClientEvent("new", "all", "monsters/elemental_earth_cl", IndexOf(ENT_ME), "do_shield", SHIELD_DURATION);
		CL_SHIELD_IDX = LastClientScriptId();
	}

	// shield_loop
	void ElementalEarth1_OnShieldLoop()
	{
		if (!SHIELD_ACTIVE)
			return;
		CallEventDelayed(0.1f, "shield_loop");
		SetMoveDest(SHIELD_TARGET, 9999);
	}

	// npc_targetvalidate
	void ElementalEarth1_OnNpcTargetvalidate(CBaseEntity@ target = null)
	{
		if (!SHIELD_ACTIVE)
			return;
		if (NPCATK_TARGET == SHIELD_TARGET)
			return;
		NPCATK_TARGET = SHIELD_TARGET;
	}

	// end_shield
	void ElementalEarth1_OnEndShield()
	{
		if (ELEMENTAL_LEVEL == 1)
		{
			OnNpcatkResumeMovement();
			SUSPEND_CYCLE = false;
		}
		SHIELD_ACTIVE = false;
	}

	// do_storm
	void ElementalEarth1_OnDoStorm()
	{
		PlayAnim("once", ANIM_ALERT);
		PlaySound(0, 10, SOUND_ALERT, 0.8f, 30);
		CreateNpc("monsters/summon/rock_storm", RelativePosition(Vector3(0, 0, 0)), self, 4, DMG_STORM, 64, 100);
	}

	// do_earthquake
	void ElementalEarth1_OnDoEarthquake()
	{
		ATTACK_MOVERANGE = 9999.0f;
		EARTHQUAKE_ACTIVE = true;
		OnNpcatkSuspendMovement(ANIM_CHARGEIDLE);
		SUSPEND_CYCLE = true;
		ServerPlaySound(1, 10, SOUND_EARTHQUAKE_START, 0.8f, PITCH_LEVEL);
		ServerPlaySound(3, 10, SOUND_EARTHQUAKE_LOOP, 0.8f, PITCH_LEVEL);
		CallEventDelayed(EARTHQUAKE_DURATION, "earthquake_end");

		CallEventDelayed(0.1f, "earthquake_loop");

		Effect("screenshake", OriginOf(ENT_ME), 50, 10, EARTHQUAKE_DURATION, EARTHQUAKE_AOE * 1.5f);
		ClientEvent("new", "all", "effects/sfx_quake", IndexOf(ENT_ME), 1, EARTHQUAKE_AOE, EARTHQUAKE_DURATION);
	}

	// earthquake_loop
	void ElementalEarth1_OnEarthquakeLoop()
	{
		if (!EARTHQUAKE_ACTIVE)
			return;
		CallEventDelayed(1.0f, "earthquake_loop");

		EARTHQUAKE_TARGS = FindInSphere("enemy", EARTHQUAKE_AOE);
		if (EARTHQUAKE_TARGS == "none")
			return;
		int count = GetTokenCount(EARTHQUAKE_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnEarthquakeApplyeffect();
		}
	}

	// earthquake_applyeffect
	void ElementalEarth1_OnEarthquakeApplyeffect()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(EARTHQUAKE_TARGS, loopIteration));

		if (!IsOnGround(curTarg))
			return;
		ApplyEffect(curTarg, "effects/effect_quake", EARTHQUAKE_DURATION, self, EARTHQUAKE_AOE, DOT_EARTHQUAKE, self, 1);
	}

	// earthquake_end
	void ElementalEarth1_OnEarthquakeEnd()
	{
		ATTACK_MOVERANGE = ELEMENTAL_MOVERANGE;
		ServerPlaySound(3, 0, SOUND_EARTHQUAKE_LOOP);
		EARTHQUAKE_ACTIVE = false;
		OnNpcatkResumeMovement();
		SUSPEND_CYCLE = false;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePrecache() { ElementalEarth1_OnGamePrecache(); } // game_precache
	void OnFakePrecache() { ElementalEarth1_OnFakePrecache(); } // fake_precache

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		BasePropelled_OnNpcPostSpawn(); // monsters/base_propelled
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseStruck_OnGameSpawn(playerRace, playerGender); // monsters/base_struck
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		ElementalEarth1_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseStruck_OnNpcatkHunt(); // monsters/base_struck
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseStruck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, ElementalEarth1_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		ElementalEarth1_OnNpcTargetsighted(target);
	}

	// npc_targetvalidate
	void OnNpcTargetvalidate(CBaseEntity@ target = null)
	{
		BaseMonsterShared_OnNpcTargetvalidate(target); // monsters/base_monster_shared
		ElementalEarth1_OnNpcTargetvalidate(target);
	}

	void OnElementalSpawn() { ElementalEarth1_OnElementalSpawn(); } // elemental_spawn
	void OnAttack1Strike() { ElementalEarth1_OnAttack1Strike(); } // attack1_strike
	void OnSwipeDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { ElementalEarth1_OnSwipeDodamage(hit, target, start, end, damageType, damageText); } // swipe_dodamage
	void OnSummonRock(Vector3 location = Vector3()) { ElementalEarth1_OnSummonRock(location); } // summon_rock
	void OnExtMobClreturn() { ElementalEarth1_OnExtMobClreturn(); } // ext_mob_clreturn
	void OnRockDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { ElementalEarth1_OnRockDodamage(hit, target, start, end, damageType, damageText); } // rock_dodamage
	void OnRepelTarget(string target = "", string strength = "", Vector3 fromOrigin = Vector3()) { ElementalEarth1_OnRepelTarget(target, strength, fromOrigin); } // repel_target
	void OnZapDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { ElementalEarth1_OnZapDodamage(hit, target, start, end, damageType, damageText); } // zap_dodamage
	void OnDoFissure() { ElementalEarth1_OnDoFissure(); } // do_fissure
	void OnDoFissure2() { ElementalEarth1_OnDoFissure2(); } // do_fissure2
	void OnFissureTravelLoop() { ElementalEarth1_OnFissureTravelLoop(); } // fissure_travel_loop
	void OnFissureDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { ElementalEarth1_OnFissureDodamage(hit, target, start, end, damageType, damageText); } // fissure_dodamage
	string OnFuncInrange(string numberToCheck = "", string base = "", string range = "") { return ElementalEarth1_OnFuncInrange(numberToCheck, base, range); } // func_inrange
	void OnDoShield() { ElementalEarth1_OnDoShield(); } // do_shield
	void OnShieldLoop() { ElementalEarth1_OnShieldLoop(); } // shield_loop
	void OnEndShield() { ElementalEarth1_OnEndShield(); } // end_shield
	void OnDoStorm() { ElementalEarth1_OnDoStorm(); } // do_storm
	void OnDoEarthquake() { ElementalEarth1_OnDoEarthquake(); } // do_earthquake
	void OnEarthquakeLoop() { ElementalEarth1_OnEarthquakeLoop(); } // earthquake_loop
	void OnEarthquakeApplyeffect() { ElementalEarth1_OnEarthquakeApplyeffect(); } // earthquake_applyeffect
	void OnEarthquakeEnd() { ElementalEarth1_OnEarthquakeEnd(); } // earthquake_end
	void OnEarthquakeDuration() {} // EARTHQUAKE_DURATION
	void OnLDropTime() {} // L_DROP_TIME
	void OnShieldDuration() {} // SHIELD_DURATION

	// This file's events and timers by their .script names
	bool ElementalEarth1_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack1_strike") { OnAttack1Strike(); return true; }
		if (name == "do_earthquake") { OnDoEarthquake(); return true; }
		if (name == "do_fissure") { OnDoFissure(); return true; }
		if (name == "do_fissure2") { OnDoFissure2(); return true; }
		if (name == "do_shield") { OnDoShield(); return true; }
		if (name == "do_storm") { OnDoStorm(); return true; }
		if (name == "earthquake_applyeffect") { OnEarthquakeApplyeffect(); return true; }
		if (name == "earthquake_end") { OnEarthquakeEnd(); return true; }
		if (name == "earthquake_loop") { OnEarthquakeLoop(); return true; }
		if (name == "elemental_spawn") { OnElementalSpawn(); return true; }
		if (name == "end_shield") { OnEndShield(); return true; }
		if (name == "ext_mob_clreturn") { OnExtMobClreturn(); return true; }
		if (name == "fake_precache") { OnFakePrecache(); return true; }
		if (name == "fissure_dodamage") { OnFissureDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "fissure_travel_loop") { OnFissureTravelLoop(); return true; }
		if (name == "func_inrange") { Return(OnFuncInrange(Param(params, 0), Param(params, 1), Param(params, 2))); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npc_targetvalidate") { OnNpcTargetvalidate(EntityParam(params, 0)); return true; }
		if (name == "repel_target") { OnRepelTarget(Param(params, 0), Param(params, 1), Vec(Param(params, 2))); return true; }
		if (name == "rock_dodamage") { OnRockDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "shield_loop") { OnShieldLoop(); return true; }
		if (name == "summon_rock") { OnSummonRock(Vec(Param(params, 0))); return true; }
		if (name == "swipe_dodamage") { OnSwipeDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "zap_dodamage") { OnZapDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/elemental_earth1"]
shared class ElementalEarth1Script : BaseMonsterNewScript, ElementalEarth1, BasePropelled, BaseStruck
{
	// Variables declared by included files, with the value they start with in this script
	ElementalEarth1Script()
	{
		ANIM_IDLE = "idle1";
		ANIM_WALK = "idle1";
		ANIM_RUN = "idle1";
		SOUND_DEATH = "garg/gar_die1.wav";
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("rockgibs.mdl");
		Precache("rain_ripple.spr");
		Precache("debris/zap8.wav");
		Precache("debris/zap3.wav");
		Precache("debris/zap4.wav");
		Precache("weapons/debris1.wav");
		Precache("magic/volcano_start.wav");
		Precache("magic/volcano_loop.wav");
		Precache("monsters/elementals_lesser.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ElementalEarth1_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseStruck_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return ElementalEarth1_DispatchEvent(name, params)
			|| BasePropelled_DispatchEvent(name, params)
			|| BaseStruck_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
