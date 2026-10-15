#pragma context server

// Converted from hunderswamp/tubequeen.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_monster_shared.as"

[script "hunderswamp/tubequeen"]
class Tubequeen : BaseNpcScript, BaseMonsterShared, BaseAntiStuck
{
	// Constants
	string ANIM_SPELL_START = "spell_start";
	string ANIM_SPELL_LOOP = "spell_loop";
	float ESCORT_SPAWN_FREQ_LOW = 0.0f;
	float ESCORT_SPAWN_FREQ_MED = 0.0f;
	float ESCORT_SPAWN_FREQ_HIGH = 0.0f;
	float ESCORT_SPAWN_FREQ_PANIC = 0.0f;
	float NPC_BOSS_REGEN_RATE = 0.05f;
	float NPC_BOSS_REGEN_FREQ = 120.0f;
	bool CANT_FLEE = true;
	bool NPC_HEARDSOUND_OVERRIDE = true;
	string SOUND_RAWR = "monsters/tubequeen/tq_lavascream.wav";
	string SOUND_SMALLFLINCH1 = "monsters/tubequeen/tq_smallflinch.wav";
	string SOUND_SMALLFLINCH2 = "monsters/tubequeen/tq_smallflinch2.wav";
	string SOUND_BIGFLINCH1 = "monsters/tubequeen/tq_bigflinch.wav";
	string SOUND_BIGLLFLINCH2 = "monsters/tubequeen/tq_bigflinch2.wav";
	string SOUND_VIOLENTFLINCH = "monsters/tubequeen/tq_flinchviolent.wav";
	string SOUND_STRUCK1 = "monsters/tube/TubeCritter_Hit1.wav";
	string SOUND_STRUCK2 = "monsters/tube/TuberCritter_Hit2.wav";
	string SOUND_STRUCK3 = "monsters/tube/TubeCritter_Hit3.wav";
	string SOUND_IDLE1 = "monsters/tubequeen/tq_idle1.wav";
	string SOUND_IDLE2 = "monsters/tubequeen/tq_idle1a.wav";
	string SOUND_IDLE3 = "monsters/tubequeen/tq_idle2.wav";
	string SOUND_SWOOP = "weapons/swinghuge.wav";
	string SOUND_ATTACK_FORWARD = "monsters/tubequeen/tq_clawattack.wav";
	string SOUND_ATTACK_RIGHT = "monsters/tubequeen/tq_clawattack_right.wav";
	string SOUND_ATTACK_LEFT = "monsters/tubequeen/tq_clawattack_left.wav";
	string SOUND_SPELLPREP1 = "monsters/tubequeen/tq_mortarfire1.wav";
	string SOUND_SPELLPREP2 = "monsters/tubequeen/tq_mortarfire2.wav";
	string SOUND_SPELLPREP3 = "monsters/tubequeen/tq_mortarfire3.wav";
	string ATTACH_RHAND = "1";
	string ATTACH_LHAND = "2";
	int DMG_SLAM = 800;
	float FREQ_SPELL = 0.0f;
	float DMG_GLOB = 300.0f;
	int DOT_GLOB = 100;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle1";
	float FREQ_ESCORT_SPAWN = 0.0f;
	Vector3 NPC_HBAR_ADJ = Vector3();
	int CUR_HURT_STAGE = 0;
	bool FIRST_ESCORT = false;
	float ESCORT_CYCLE = 0.0f;
	float INIT_DELAY = 0.0f;
	float NEXT_ESCORT = 0.0f;
	float TIME_SPAWN_PLUS_20 = 0.0f;
	float NEXT_FLINCH = 0.0f;
	float NEXT_SPELL = 0.0f;
	float NEXT_IDLE_ANIM = 0.0f;
	int LEFT_YAW = 0;
	int RIGHT_YAW = 0;
	float HURT_STAGE1 = 0.0f;
	float HURT_STAGE2 = 0.0f;
	float HURT_STAGE3 = 0.0f;
	bool TUBEQUEEN_ACTIVE = false;
	int DID_INTRO = 0;
	float NEXT_IDLE = 0.0f;
	bool DOING_SPELL = false;
	float NEXT_TUBE = 0.0f;
	float NEXT_ATTACK = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string SLAM_ORG = "SLAM_ORG";
	float TUBE_COUNT = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	Tubequeen()
	{
		ANIM_WALK = "idle1";
	}

	// unnamed block (first think)
	void Tubequeen_FirstThink()
	{
		ANIM_IDLE = "idle1";
		ANIM_WALK = "idle1";
		ANIM_RUN = "idle1";
	}

	// unnamed block (first think)
	void Tubequeen_FirstThink2()
	{
		FREQ_ESCORT_SPAWN = 30.0f;

		NPC_HBAR_ADJ = Vector3(0, 128, 0);

		NPC_IS_BOSS = true;
		NPC_GIVE_EXP = 20000.0f;
	}

	// game_damaged
	string Tubequeen_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		bool exitSub = false;
		string result = "";

		TUBEQUEEN_ACTIVE = true;
		DID_INTRO = 1;

		OnDelayIdleAnim();

		if (NPCATK_TARGET == "unset" && RelationshipOf(attacker, ENT_ME) == "enemy")
			OnNpcatkSettarget(EntityId(attacker));

		float curHp = HealthOf(ENT_ME);
		if (curHp < HURT_STAGE1 && CUR_HURT_STAGE == 0)
		{
			SetModelBody(1, 0);
			CUR_HURT_STAGE = 1;
			SetProp(ENT_ME, "skin", 1);
			PlaySound(0, 10, "monsters/tubequeen/tq_inspectbelly.wav");
			PlayAnim("critical", "bellyinspect");
			OnDelayFlinch();
			NEXT_ESCORT = GameTime() + 2.0f;
			exitSub = true;
		}
		if (curHp < HURT_STAGE2 && CUR_HURT_STAGE == 1)
		{
			SetModelBody(1, 0);
			CUR_HURT_STAGE = 2;
			SetProp(ENT_ME, "skin", 2);
			PlaySound(0, 10, "monsters/tubequeen/tq_inspectbelly.wav");
			PlayAnim("critical", "bellyinspect");
			OnDelayFlinch();
			NEXT_ESCORT = GameTime() + 2.0f;
			exitSub = true;
		}
		if (curHp < HURT_STAGE3 && CUR_HURT_STAGE == 2)
		{
			SetModelBody(1, 0);
			CUR_HURT_STAGE = 3;
			SetProp(ENT_ME, "skin", 2);
			PlaySound(0, 10, "monsters/tubequeen/tq_inspectbelly.wav");
			PlayAnim("critical", "bellyinspect");
			OnDelayFlinch();
			NEXT_ESCORT = GameTime() + 2.0f;
			exitSub = true;
		}
		if (exitSub)
			return result;

		if (GameTime() > NEXT_FLINCH)
		{
			exitSub = true;
			OnDelayFlinch();

			int rndFlinch = RandomInt(1, 8);
			if (rndFlinch >= 4)
			{
				PlayAnim("critical", "smallflinch");
				PlayRandomSound(0, 10, SOUND_SMALLFLINCH1, SOUND_SMALLFLINCH2);
			}
			if (rndFlinch >= 2 && rndFlinch > 1)
			{
				PlayAnim("critical", "bigflinch");
				PlayRandomSound(0, 10, SOUND_BIGFLINCH1, "SOUND_BIGFLINCH2");
			}
			if (rndFlinch == 1)
			{
				PlayAnim("critical", "flinchviolent");
				PlayRandomSound(0, 10, SOUND_VIOLENTFLINCH);
			}
			SetModelBody(1, 0);
		}
		if (exitSub)
			return result;

		PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
		return result;
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("monsters/swamp_tube");
		PrecacheFile("monsters/swamp_tube_cl");
		PrecacheFile("monsters/summon/slime_globe");
		PrecacheFile("monsters/summon/slime_globe_cl");
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		// tell all my children to follow me into the abyss
		PlaySound(0, 10, "monsters/tubequeen/tq_lavascream.wav");
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 380, 20, 10, 1024);
		Vector3 deathPos = OriginOf(ENT_ME) + RelativePosition(Vector3(0, 0, 0), Vector3(-256, 256, 0));
		CallExternal("all", "ext_mommy_died", deathPos);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Oodle-beak Hivemother");
		SetModel("monsters/tubequeen.mdl");
		SetWidth(600);
		SetHeight(600);
		SetRace("wildanimal");
		SetIdleAnim("idle1");
		SetMoveAnim("idle1");

		SetHealth(30000);
		SetRoam(false);
		SetNoPush(true);
		SetHearingSensitivity(11);
		SetDamageTaken("all", 0.5f);
		SetDamageTaken("fire", 1.25f);
		SetDamageTaken("slash", 0.25f);
		CallEventDelayed(0.1f, "pre_setup");
		CallEventDelayed(2.1f, "npcatk_hunt");
		CallEventDelayed(2.0f, "finalize_monster");
		CUR_HURT_STAGE = 0;
		NPCATK_TARGET = "unset"; // manual AI
		FIRST_ESCORT = false;
		ESCORT_CYCLE = 0.0f;
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		bool exitSub = false;
		if (!IsAlive(ENT_ME))
			return;
		CallEventDelayed(1.0f, "npcatk_hunt");

		float gameTime = GameTime();

		if (gameTime > INIT_DELAY)
		{
			if (NPCATK_TARGET == "unset")
				OnNpcatkGettarget();
			if (!IsAlive(NPCATK_TARGET))
				OnNpcatkGettarget();
		}

		if (DID_INTRO == 0)
		{
			// after 20 secs, force intro/init
			if (gameTime > TIME_SPAWN_PLUS_20)
				OnForceActive();
		}

		if (DID_INTRO == 0)
			return;

		if (gameTime > NEXT_ESCORT && NPCATK_TARGET != "unset")
			OnCheckEscort();

		if (I_R_FROZEN)
			return;
		if (DOING_SPELL)
			return;

		if (gameTime > NEXT_IDLE)
		{
			NEXT_IDLE = gameTime + Random(10, 20);
			PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3);
			if (gameTime > NEXT_IDLE_ANIM)
			{
				NEXT_IDLE_ANIM = gameTime + 10.0f;
				PlayAnim("once", "idle2"); // plays when not attacked or attacking for some time
			}
		}

		if (NPCATK_TARGET == "unset")
			return;

		if (gameTime > NEXT_SPELL)
		{
			NEXT_SPELL = gameTime + FREQ_SPELL;
			PlayAnim("critical", ANIM_SPELL_START);
			OnDelayIdleAnim();
			OnDelayFlinch();
			DOING_SPELL = true;
			CallEventDelayed(15.0f, "spell_break");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (gameTime > NEXT_TUBE && TUBE_COUNT < 3.0f)
		{
			NEXT_TUBE = gameTime + 20.0f; // resets on complete
			NEXT_FLINCH = gameTime + 60.0f; // resets on complete
			NEXT_IDLE_ANIM = gameTime + 60.0f; // resets on complete
			PlayAnim("once", "grabtube");
			OnDelaySpell(10.0f);
			OnDelayAttack(5.0f);
			exitSub = true;
		}
		if (exitSub)
			return;

		if (gameTime > NEXT_ATTACK)
		{
			NEXT_ATTACK = gameTime + Random(3, 5);
			// get angles to target to determine attack anim
			Vector3 targPos = OriginOf(NPCATK_TARGET);
			Vector3 myPos = OriginOf(ENT_ME);
			float targAngs = AnglesTo(myPos, targPos);
			ANIM_ATTACK = "clawattack";
			if (targAngs > LEFT_YAW)
				ANIM_ATTACK = "clawattackleft";
			if (targAngs < RIGHT_YAW)
				ANIM_ATTACK = "clawattackright";
			PlayAnim("once", ANIM_ATTACK);
			OnDelayIdleAnim();
		}
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, Tubequeen_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		BaseMonsterShared_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_monster_shared
		if (!(GameTime() > INIT_DELAY))
			return;
		if (NPCATK_TARGET != "unset")
			return;
		CBaseEntity@ checkTarg = EntityOf(ENT_LASTHEARD);
		if (RelationshipOf(checkTarg, ENT_ME) != "enemy")
			return;
		OnNpcatkSettarget(EntityId(checkTarg));
	}

	// npcatk_settarget
	// <possible_new_target>
	void OnNpcatkSettarget(string target = "", string debug = "")
	{
		BaseMonsterShared_OnNpcatkSettarget(target, debug); // monsters/base_monster_shared
		bool exitSub = false;
		if (NPCATK_TARGET != "unset" && RangeTo(NPCATK_TARGET) < RangeTo(target))
		{
			// ignore, current target is closer
			exitSub = true;
		}
		if (exitSub)
			return;

		string oldTarget = NPCATK_TARGET;
		NPCATK_TARGET = target;
		OnNpcatkTargetvalidate(EntityId(EntityOf(target)));
		if (NPCATK_TARGET == "unset")
		{
			// target was invalidated, switch to old, if any
			if (oldTarget != "unset")
				NPCATK_TARGET = oldTarget;
		}
	}

	// pre_setup
	void OnPreSetup()
	{
		INIT_DELAY = GameTime() + 5.0f;
		PlayAnim("once", "idle1");

		NEXT_ESCORT = GameTime() + FREQ_ESCORT_SPAWN;

		TIME_SPAWN_PLUS_20 = GameTime() + 20.0f;

		OnSetupDelays(); // happens again on intro
	}

	// setup_delays
	void OnSetupDelays()
	{
		NEXT_FLINCH = GameTime() + 60.0f;

		NEXT_SPELL = GameTime() + FREQ_SPELL;

		NEXT_IDLE_ANIM = GameTime() + 10.0f;
	}

	// finalize_monster
	void OnFinalizeMonster()
	{
		// setvard LEFT_YAW $get(ent_me,angles.yaw)
		// subtract LEFT_YAW 45
		LEFT_YAW = -60;

		// setvard RIGHT_YAW $get(ent_me,angles.yaw)
		// add RIGHT_YAW 45
		RIGHT_YAW = -110;

		float myHp = MaxHealthOf(ENT_ME);
		HURT_STAGE1 = myHp * 0.75f;
		HURT_STAGE2 = myHp * 0.5f;
		HURT_STAGE3 = myHp * 0.25f;
	}

	// delay_flinch
	void OnDelayFlinch()
	{
		NEXT_FLINCH = GameTime();
		if (CUR_HURT_STAGE == 0)
			NEXT_FLINCH += Random(20, 30);
		if (CUR_HURT_STAGE == 1)
			NEXT_FLINCH += Random(15, 25);
		if (CUR_HURT_STAGE == 2)
			NEXT_FLINCH += Random(10, 20);
		if (CUR_HURT_STAGE == 3)
			NEXT_FLINCH += Random(5, 15);
		NEXT_IDLE = GameTime() + Random(10, 20);
	}

	// delay_idle_anim
	// delays when struck or attacking
	void OnDelayIdleAnim()
	{
		NEXT_IDLE_ANIM = GameTime() + 10.0f;
	}

	// delay_attack
	// <delay>
	void OnDelayAttack(float delay = 0.0f)
	{
		NEXT_ATTACK = GameTime() + delay;
	}

	// npcatk_gettarget
	void OnNpcatkGettarget()
	{
		if (CanSee("enemy"))
			NPCATK_TARGET = EntityId(EntityOf(ENT_LASTSEEN));

		// can't see one - just pick up any in range
		if (NPCATK_TARGET == "unset")
		{
			string inSphere = FindInSphere("enemy", 768);
			if (inSphere != "none")
			{
				inSphere = SortEntities(inSphere, "range");
				NPCATK_TARGET = GetToken(inSphere, 0);
			}
		}
		OnNpcatkTargetvalidate(NPCATK_TARGET);
	}

	// npcatk_targetvalidate
	// returns NPCATK_TARGET to unset if target invalid
	void OnNpcatkTargetvalidate(string target = "")
	{
		if (Float(ScriptVarOf(NPCATK_TARGET, "PLAYING_DEAD")) == 1.0f)
			NPCATK_TARGET = "unset";
		if (!IsAlive(NPCATK_TARGET))
			NPCATK_TARGET = "unset";
		if (!CanDamage(NPCATK_TARGET))
			NPCATK_TARGET = "unset";

		if (NPCATK_TARGET == "unset")
			return;
		if (DID_INTRO != 0)
			return;
		DID_INTRO = 1;
		PlayAnim("critical", "flinchviolent");
		PlaySound(0, 10, SOUND_RAWR);
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 380, 20, 5, 1024);
		OnSetupDelays();
	}

	// frame_attack_forward_start
	void OnFrameAttackForwardStart()
	{
		PlaySound(1, 10, SOUND_SWOOP);
		PlaySound(2, 10, SOUND_ATTACK_FORWARD);
	}

	// frame_attack_left_start
	void OnFrameAttackLeftStart()
	{
		PlaySound(1, 10, SOUND_SWOOP);
		PlaySound(2, 10, SOUND_ATTACK_LEFT);
	}

	// frame_attack_right_start
	void OnFrameAttackRightStart()
	{
		PlaySound(1, 10, SOUND_SWOOP);
		PlaySound(2, 10, SOUND_ATTACK_RIGHT);
	}

	// frame_attack_forward_land
	void OnFrameAttackForwardLand()
	{
		Vector3 landPos = AttachmentPositionOf(ENT_ME, ATTACH_RHAND);
		landPos += RelativePosition(MyAngles(), Vector3(-128, 0, 0));
		landPos.z = GroundHeight(landPos);
		Effect("screenshake", landPos, 380, 20, 1, 512);
		ClientEvent("new", "all", "effects/sfx_stun_burst", landPos, 512, 0, 0);
		SLAM_ORG = Text(landPos);
		landPos.z += 32.0f;
		DoDamageEx(landPos, 512, DMG_SLAM, 0.3f, ENT_ME, ENT_ME, "none", "blunt_effect", "dmgevent:slam");
	}

	// frame_attack_right_land
	void OnFrameAttackRightLand()
	{
		Vector3 landPos = AttachmentPositionOf(ENT_ME, ATTACH_RHAND);
		landPos.z = GroundHeight(landPos);
		Effect("screenshake", landPos, 380, 20, 1, 384);
		ClientEvent("new", "all", "effects/sfx_stun_burst", landPos, 384, 0, 0);
		SLAM_ORG = Text(landPos);
		landPos.z += 32.0f;
		DoDamageEx(landPos, 384, DMG_SLAM, 0.3f, ENT_ME, ENT_ME, "none", "blunt_effect", "dmgevent:slam");
	}

	// frame_attack_left_land
	void OnFrameAttackLeftLand()
	{
		Vector3 landPos = AttachmentPositionOf(ENT_ME, ATTACH_LHAND);
		landPos.z = GroundHeight(landPos);
		Effect("screenshake", landPos, 380, 20, 1, 256);
		ClientEvent("new", "all", "effects/sfx_stun_burst", landPos, 384, 0, 0);
		SLAM_ORG = Text(landPos);
		landPos.z += 32.0f;
		DoDamageEx(landPos, 384, DMG_SLAM, 0.3f, ENT_ME, ENT_ME, "none", "blunt_effect", "dmgevent:slam");
	}

	// slam_dodamage
	void OnSlamDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		if (!IsOnGround(target))
			return;
		ApplyEffect(target, "effects/debuff_stun", 5.0f, self);
		Vector3 targOrg = OriginOf(target);
		string myOrg = SLAM_ORG;
		float targAng = AnglesTo(Vec(myOrg), targOrg);
		int newYaw = int(targAng);
		AddVelocity(target, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 1000, 0)));

		// delay slime ball spell, if I can hit someone, and spell to go off within 20 sec
		OnDelaySpell(20.0f);
	}

	// delay_spell
	// <delay> - delay spell X seconds, if to go off within X seconds
	void OnDelaySpell(float delay = 0.0f)
	{
		float checkTime = GameTime() + delay;
		if (checkTime > NEXT_SPELL)
		{
			DebugPrint("delay_spell " + Text(delay));
			NEXT_SPELL = GameTime() + delay;
		}
	}

	// frame_sack_start
	void OnFrameSackStart()
	{
		OnDelaySpell(5.0f);
		OnDelayAttack(10.0f);
		PlaySound(0, 10, "monsters/tubequeen/tq_grabtube1.wav");
	}

	// frame_sack_grab
	void OnFrameSackGrab()
	{
		OnDelayAttack(10.0f);
		SetModelBody(1, 1);
		PlaySound(0, 10, "monsters/tubequeen/tq_grabtube2.wav");
	}

	// frame_sack_throw
	void OnFrameSackThrow()
	{
		OnDelayAttack(1.0f);
		OnDelaySpell(5.0f);
		SetModelBody(1, 0);
		PlaySound(0, 10, "monsters/tubequeen/tq_grabtube3.wav");

		OnDelayFlinch();
		OnDelayIdleAnim();
		TUBE_COUNT += 1.0f;
		if (TUBE_COUNT < 3.0f)
			NEXT_TUBE = GameTime();
		else
			NEXT_TUBE = GameTime() + 60.0f;

		Vector3 spawnPos = AttachmentPositionOf(ENT_ME, ATTACH_RHAND);

		CreateNpc("monsters/swamp_tube", spawnPos, self);
		float rndRl = AnglesOf(ENT_ME).y + Random(-65, 65);
		float rndFd = Random(200, 800);
		float rndUp = Random(200, 900);
		float rndRl2 = Random(-1000, 1000);

		DebugPrint("frame_sack_throw " + Text(RelativePosition(Vector3(0, rndRl, 0), Vector3(0, rndFd, rndUp))));

		AddVelocity(ENT_LASTCREATED, RelativePosition(Vector3(0, rndRl, 0), Vector3(rndRl2, rndFd, rndUp)));
	}

	// ext_tube_died
	void OnExtTubeDied()
	{
		TUBE_COUNT -= 1.0f;
	}

	// frame_spell_start
	void OnFrameSpellStart()
	{
		PlayRandomSound(0, 10, SOUND_SPELLPREP1, SOUND_SPELLPREP2, SOUND_SPELLPREP3);
		DOING_SPELL = true;
		DebugPrint("frame_spell_start");
		CreateNpc("monsters/summon/slime_globe", RelativePosition(Vector3(0, 512, -64)), self, DMG_GLOB);
		// setvard SLIME_GLOBE_ID $get(ent_lastcreated,id) //just using the external instead
		NEXT_SPELL = GameTime() + FREQ_SPELL; // redundant, but short delay during testing helps here
	}

	// frame_spell_ready
	void OnFrameSpellReady()
	{
		PlayRandomSound(0, 10, SOUND_SPELLPREP1, SOUND_SPELLPREP2, SOUND_SPELLPREP3);
		OnNpcatkSuspendAi("12.0");
		OnNpcatkSuspendMovement(ANIM_SPELL_LOOP, "12.0");
		PlayAnim("critical", ANIM_SPELL_LOOP);
	}

	// spell_break
	void OnSpellBreak()
	{
		DOING_SPELL = false;
		PlayAnim("break");
		ANIM_IDLE = "idle1";
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_IDLE);
		NEXT_SPELL = GameTime() + FREQ_SPELL;
		OnDelayAttack(1.0f);
	}

	// glob_dodamage
	// from monsters/summon/slime_globe
	void OnGlobDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		// local TARG_ORG $get(PARAM2,origin)
		// local BLOG_ORG PARAM3
		// local BLOB_DIST $dist(BLOB_ORG,TARG_ORG)
		// divide BLOB_DIST 64
		// local BLOB_DIST_RATIO 1
		// subtract BLOB_DIST_RATIO BLOB_DIST
		// local BLIND_DURATION $ratio(BLOB_DIST_RATIO,4.0,8.0) //blind 4-8 seconds based on how direct the hit was
		// dbg glob_dodamage BLIND_DURATION BLOB_DIST_RATIO
		ApplyEffect(target, "effects/dot_poison_blind", 5.0f, self, DOT_GLOB);
	}

	// check_escort
	void OnCheckEscort()
	{
		bool exitSub = false;
		DebugPrint("check_escort " + Text(GameTime()));
		if (!FIRST_ESCORT)
		{
			DebugPrint("first_escort");
			FIRST_ESCORT = true;
			ESCORT_CYCLE = 2.0f;
			UseTrigger("spawn_boss_escort1");
			UseTrigger("spawn_boss_escort2");
			exitSub = true;
		}
		NEXT_ESCORT = GameTime();
		if (CUR_HURT_STAGE == 0)
			FREQ_ESCORT_SPAWN = ESCORT_SPAWN_FREQ_LOW;
		if (CUR_HURT_STAGE == 1)
			FREQ_ESCORT_SPAWN = ESCORT_SPAWN_FREQ_MED;
		if (CUR_HURT_STAGE == 2)
			FREQ_ESCORT_SPAWN = ESCORT_SPAWN_FREQ_HIGH;
		if (CUR_HURT_STAGE == 3)
			FREQ_ESCORT_SPAWN = ESCORT_SPAWN_FREQ_PANIC;
		NEXT_ESCORT += FREQ_ESCORT_SPAWN;
		if (exitSub)
			return;

		ESCORT_CYCLE += 1.0f;

		if (CUR_HURT_STAGE < 2)
		{
			if (ESCORT_CYCLE == 1.0f)
				UseTrigger("spawn_boss_escort1");
			if (ESCORT_CYCLE == 2.0f)
				UseTrigger("spawn_boss_escort2");
			if (ESCORT_CYCLE == 3.0f)
			{
				ESCORT_CYCLE = 0.0f;
				UseTrigger("spawn_boss_escort3");
			}
		}

		if (CUR_HURT_STAGE == 2)
		{
			if (ESCORT_CYCLE == 1.0f)
			{
				UseTrigger("spawn_boss_escort1");
				UseTrigger("spawn_boss_escort2");
			}
			if (ESCORT_CYCLE == 2.0f)
			{
				UseTrigger("spawn_boss_escort2");
				UseTrigger("spawn_boss_escort3");
			}
			if (ESCORT_CYCLE == 3.0f)
			{
				ESCORT_CYCLE = 0.0f;
				UseTrigger("spawn_boss_escort3");
				UseTrigger("spawn_boss_escort1");
			}
		}

		if (CUR_HURT_STAGE == 3)
		{
			ESCORT_CYCLE = 0.0f;
			UseTrigger("spawn_boss_escort1");
			UseTrigger("spawn_boss_escort2");
			UseTrigger("spawn_boss_escort3");
		}
	}

	// force_active
	void OnForceActive()
	{
		TUBEQUEEN_ACTIVE = true;
		DID_INTRO = 1;
		PlayAnim("critical", "flinchviolent");
		PlaySound(0, 10, SOUND_RAWR);
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 380, 20, 5, 1024);
		OnSetupDelays();
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnNpcSuicide(string suicideMode = "") { MonstersExternals_OnNpcSuicide(suicideMode); } // npc_suicide

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
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
	}

	void OnExtWinkOut(Vector3 spawnPosition = Vector3(), float delay = 0.0f) { MonstersExternals_OnExtWinkOut(spawnPosition, delay); } // ext_wink_out

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
	}

	// npcatk_get_postspawn_properties
	void OnNpcatkGetPostspawnProperties()
	{
		BaseNpc_OnNpcatkGetPostspawnProperties(); // monsters/base_npc
		BaseMonsterShared_OnNpcatkGetPostspawnProperties(); // monsters/base_monster_shared
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/tubequeen.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Tubequeen_FirstThink();
		Tubequeen_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "check_escort") { OnCheckEscort(); return true; }
		if (name == "delay_attack") { OnDelayAttack(Float(Param(params, 0))); return true; }
		if (name == "delay_flinch") { OnDelayFlinch(); return true; }
		if (name == "delay_idle_anim") { OnDelayIdleAnim(); return true; }
		if (name == "delay_spell") { OnDelaySpell(Float(Param(params, 0))); return true; }
		if (name == "ext_tube_died") { OnExtTubeDied(); return true; }
		if (name == "finalize_monster") { OnFinalizeMonster(); return true; }
		if (name == "force_active") { OnForceActive(); return true; }
		if (name == "frame_attack_forward_land") { OnFrameAttackForwardLand(); return true; }
		if (name == "frame_attack_forward_start") { OnFrameAttackForwardStart(); return true; }
		if (name == "frame_attack_left_land") { OnFrameAttackLeftLand(); return true; }
		if (name == "frame_attack_left_start") { OnFrameAttackLeftStart(); return true; }
		if (name == "frame_attack_right_land") { OnFrameAttackRightLand(); return true; }
		if (name == "frame_attack_right_start") { OnFrameAttackRightStart(); return true; }
		if (name == "frame_sack_grab") { OnFrameSackGrab(); return true; }
		if (name == "frame_sack_start") { OnFrameSackStart(); return true; }
		if (name == "frame_sack_throw") { OnFrameSackThrow(); return true; }
		if (name == "frame_spell_ready") { OnFrameSpellReady(); return true; }
		if (name == "frame_spell_start") { OnFrameSpellStart(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "glob_dodamage") { OnGlobDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_gettarget") { OnNpcatkGettarget(); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_settarget") { OnNpcatkSettarget(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "pre_setup") { OnPreSetup(); return true; }
		if (name == "setup_delays") { OnSetupDelays(); return true; }
		if (name == "slam_dodamage") { OnSlamDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "spell_break") { OnSpellBreak(); return true; }
		return BaseMonsterShared_DispatchEvent(name, params)
			|| BaseAntiStuck_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
