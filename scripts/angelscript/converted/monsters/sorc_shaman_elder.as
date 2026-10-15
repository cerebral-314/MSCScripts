#pragma context server

// Converted from monsters/sorc_shaman_elder.script by msc_transpiler.
// Sorc Shamman (In training) by Thothie (from morc shaman)
// Elder Sorc Shaman worked by The Magical Bong/CrazyMonkeyDude

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_ranged.as"
#include "converted/monsters/orc_base.as"
#include "converted/monsters/base_lightning_shield.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SorcShamanElder
{
	// Constants
	string FINGER_ADJ = "$relpos($vec(0,MY_YAW,0),$vec(0,30,54))";
	string SOUND_BEAM = "weather/Storm_exclamation.wav";
	string ANIM_BEAM = "battleaxe_swing1_L";
	float DMG_PUSH_BEAM = 0.0f;
	string PROJ_SCRIPT = "proj_lightning_ball";
	int ATTACK_SPEED = 300;
	int ATTACK_CONE_OF_FIRE = 2;
	int MELE_RANGE = 96;
	int MELE_HITRANGE = 128;
	string ATTACK_ACCURACY = "80";
	string ANIM_SWIPE = "swordswing1_L";
	string ANIM_FIRE = "swordswing1_L";
	string ANIM_WARCRY = "warcry";
	string ANIM_KICK = "kick";
	string SWIPE_DAMAGE = "$rand(25,65)";
	string SOUND_MELEMISS = "zombie/claw_miss1.wav";
	string SOUND_MELEHIT = "zombie/claw_strike3.wav";
	string SOUND_SHOCK1 = "debris/zap8.wav";
	string SOUND_SHOCK2 = "debris/zap3.wav";
	string SOUND_SHOCK3 = "debris/zap4.wav";
	string SOUND_DEATH_SHOOT = "magic/spawn.wav";
	string SOUND_WARCRY1 = "monsters/orc/attack1.wav";
	string SOUND_WARCRY2 = "monsters/orc/attack3.wav";
	string FROST_BOLT_DAMAGE = "$rand(40,75)";
	string FROST_STRIKE_DAMAGE = "$rand(30,60)";
	float FROST_BOLT_FREQ = 1.5f;
	string DEATH_SCRIPT = "monsters/summon/summon_lightning_storm";
	int SORC_MAX_SUMMONS = 2;
	string LELM_SUMMON_SCRIPT = "monsters/elemental_air2";
	string SOUND_THUNDER = "magic/bolt_end.wav";
	string TORNADO_MODEL = "weapons/magic/tornado.mdl";
	string SOUND_LHOR = "monsters/magic/elecidlepop.wav";
	int LHOR_SUMMON_FREQ = 15;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle1";
	float FREQ_REPULSE = 0.0f;
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float BALL_SIZE = 0.0f;
	float BALL_DMG = 0.0f;
	string BALL_TYPE = "BALL_TYPE";
	string LHOR_SUMMON_SCRIPT = "LHOR_SUMMON_SCRIPT";
	bool REPULSE_DELAY = false;
	string BEAM_TARGET = "BEAM_TARGET";
	float AS_ATTACKING = 0.0f;
	float BEAM_COUNT = 0.0f;
	bool FROST_BOLT_DELAY = false;
	float MISS_COUNT = 0.0f;
	bool DID_WARCRY = false;
	bool SWIPE_SOUNDS = false;
	bool BEAM_ON = false;
	float ATTACK_MOVERANGE = 0.0f;
	float NEXT_SUMMON = 0.0f;
	float LHOR_NSUMMONS = 0.0f;
	bool AM_TURRET = false;
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_WALK = "ANIM_WALK";
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";

	// unnamed block (first think)
	void SorcShamanElder_FirstThink()
	{
		FREQ_REPULSE = Random(15, 20);

		DROP_GOLD = 1; // Gold Drop
		DROP_GOLD_AMT = RandomInt(15, 30);
		NPC_GIVE_EXP = 800.0f;

		// setvard DROP_ITEM1 scroll2_frost_xolt //hanled through monsters/base_monster
		// setvard DROP_ITEM1_CHANCE 5%	  //hanled through by monsters/base_monster
		ANIM_ATTACK = "swordswing1_L"; // Attack animation
		FLINCH_CHANCE = "45%";

		MOVE_RANGE = "256";
		ATTACK_RANGE = 2000.0f;
		ANIM_IDLE = "idle1";

		BALL_SIZE = 5.0f;
		BALL_DMG = 100.0f;
		BALL_TYPE = "lightning";
		LHOR_SUMMON_SCRIPT = "monsters/horror_lightning";
		if (ToLowerCase(MapName()) == "sorc_villa")
			LHOR_SUMMON_SCRIPT = "monsters/horror_lightning2";
	}

	// game_precache
	void SorcShamanElder_OnGamePrecache()
	{
		PrecacheFile("monsters/horror_lightning");
		PrecacheFile("monsters/elemental_air2");
		// To prevent "Not precached" errors"
		PrecacheFile("monsters/summon/tornado");
		PrecacheFile("monsters/summon/lightning_ball_guided");
	}

	// orc_spawn
	void SorcShamanElder_OnOrcSpawn()
	{
		SetHealth(1750);
		SetName("Elder Shadahar Shaman");
		SetHearingSensitivity(8);
		SetDamageTaken("lightning", 0);
		SetDamageTaken("poison", 2);
		SetDamageTaken("acid", 2);
		SetStat("spellcasting", 30, 30, 30, 30, 30, 30, 30); // ><

		SetModel("monsters/sorc.mdl");

		SetModelBody(1, 0); // body: 0=bare 1=bloody_shirt 2=gold_armor 3=archer
		SetModelBody(1, 4); // head: 0=hat_horns 1=hat_spiked 2=lizardskin_horned 3=gold_Chieftain 4=lizard_cap
		SetModelBody(2, 0); // weapon: 0=unarmed 1=axe 2=bow 3=steel_bow 4=sword 5=great_axe 6=sword_sheild 8=yellow_axe 9=blooddrinker
	}

	// npc_selectattack
	void SorcShamanElder_OnNpcSelectattack()
	{
		float noBeam = 0.0f;

		float nmeRange = RangeTo(ENT_LASTSEEN);
		if (FROST_BOLT_DELAY && nmeRange > MELE_HITRANGE)
			ANIM_ATTACK = ANIM_FIRE;
		if (!FROST_BOLT_DELAY)
			ANIM_ATTACK = ANIM_FIRE;
		if (!(nmeRange < MELE_HITRANGE))
			return;
		if (REPULSE_DELAY)
			return;

		if (IsNoPush(NPCATK_TARGET))
			noBeam = 1.0f;
		if (DamageTakenOf(NPCATK_TARGET, "lightning") == 0.0f)
			noBeam += 1.0f;
		REPULSE_DELAY = true;
		CallEventDelayed(FREQ_REPULSE, "reset_repulse_delay");

		if (!(noBeam < 2.0f)) // if can neither push nor damage target, skip
			return;

		SetMoveAnim(ANIM_BEAM);
		SetIdleAnim(ANIM_BEAM);
		PlayAnim("critical", ANIM_BEAM);
		BEAM_TARGET = NPCATK_TARGET;
		AS_ATTACKING = GameTime();
		BEAM_COUNT = 0.0f;
		OnNpcatkSuspendAi();
		OnBeamPush();
	}

	// reset_repulse_delay
	void SorcShamanElder_OnResetRepulseDelay()
	{
		REPULSE_DELAY = false;
	}

	// swing_sword
	// called by modeanim swordswing1_L at frame 14
	void SorcShamanElder_OnSwingSword()
	{
		bool exitSub = false;

		if (Truthy(LegacyFunction("cansee", NPCATK_TARGET, MELE_RANGE)))
		{
			// dbg Can See NME in range
			ANIM_ATTACK = ANIM_SWIPE;
			OnSwipeAttack(EntityOf(NPCATK_TARGET));
			exitSub = true;
		}
		if (exitSub)
			return;

		// if ( $cansee(NPCATK_TARGET) )
		// {
		// //prevents shamman from moving closer to target than needed
		// //if ( !$cansee(enemy,MOVE_RANGE) ) setvard ANIM_ATTACK ANIM_RUN
		// //if ( $cansee(enemy,MOVE_RANGE) ) setvard ANIM_ATTACK ANIM_WARCRY
		// }
		// if !FROST_BOLT_DELAY
		ANIM_ATTACK = ANIM_FIRE;
		OnThrowFrostbolt();
	}

	// throw_frostbolt
	void SorcShamanElder_OnThrowFrostbolt()
	{
		if (!CanSee(NPCATK_TARGET))
			return;
		OnNpcatkFaceattacker(NPCATK_TARGET);

		CallEventDelayed(FROST_BOLT_FREQ, "reset_frostbolt");
		PlayRandomSound(0, 10, SOUND_SHOCK1, SOUND_SHOCK2, SOUND_SHOCK3);

		float finalDamage = Float(FROST_BOLT_DAMAGE);
		if (EXT_DAMAGE_ADJUSTMENT != "EXT_DAMAGE_ADJUSTMENT") // for future use
			finalDamage += Float(EXT_DAMAGE_ADJUSTMENT);
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile(PROJ_SCRIPT, RelativePosition(Vector3(0, 48, 18)), NPCATK_TARGET, ATTACK_SPEED, finalDamage, ATTACK_CONE_OF_FIRE, "none");
		FROST_BOLT_DELAY = true;

		MISS_COUNT += 1.0f;
		if (MISS_COUNT >= 5.0f)
		{
			OnChickenRun(1.0f);
			MISS_COUNT = 0.0f;
		}
	}

	// reset_frostbolt
	void SorcShamanElder_OnResetFrostbolt()
	{
		ANIM_ATTACK = ANIM_FIRE;
		DID_WARCRY = false;
		FROST_BOLT_DELAY = false;
	}

	// npc_death
	void SorcShamanElder_OnNpcDeath()
	{
		SetSolid("none");
		SetBoundingBox("none");
		PlaySound(0, 10, SOUND_DEATH_SHOOT);
		Vector3 stormPos = MyOrigin();
		stormPos.z = GroundHeight(MyOrigin());
		CreateNpc(DEATH_SCRIPT, stormPos, self, AnglesOf(ENT_ME).y, 40.0f, 15.0f);
		Vector3 spawnPos = OriginOf(ENT_ME);
		spawnPos.z += 60.0f;
		if (NO_SUMMON)
			return;
		CreateNpc(LELM_SUMMON_SCRIPT, spawnPos);
	}

	// swipe_attack
	// PARAM1 = enemy struck
	void SorcShamanElder_OnSwipeAttack(CBaseEntity@ enemy = null)
	{
		SWIPE_SOUNDS = true;
		float finalDamage = Float(SWIPE_DAMAGE);
		if (EXT_DAMAGE_ADJUSTMENT != "EXT_DAMAGE_ADJUSTMENT") // for future use
			finalDamage += Float(EXT_DAMAGE_ADJUSTMENT);
		if (!(RangeTo(ENT_LASTSTRUCKBYME) <= MELE_HITRANGE))
			return;
		OnNpcatkDodamage(EntityId(enemy), Text(MELE_HITRANGE), Text(finalDamage), ATTACK_ACCURACY);
		if (RandomInt(1, 5) != 1)
			return;
		ApplyEffect(enemy, "effects/dot_lightning", RandomInt(5, 10), ENT_ME, FROST_STRIKE_DAMAGE);
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string SorcShamanElder_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (hit)
			MISS_COUNT = 0.0f;

		if (!SWIPE_SOUNDS)
			return result;

		if (!hit)
			PlaySound(0, 10, SOUND_MELEMISS);

		if (hit)
			PlaySound(0, 10, SOUND_MELEHIT);

		SWIPE_SOUNDS = false;
		return result;
	}

	// npc_struck
	void SorcShamanElder_OnNpcStruck(float damage = 0.0f)
	{
		if (!(RangeTo(ENT_LASTSTRUCK) < MELE_RANGE))
			return;
		// setvard ANIM_ATTACK ANIM_KICK
		OnNpcatkSettarget(EntityId(EntityOf(ENT_LASTSTRUCK)));
	}

	// beam_push
	void SorcShamanElder_OnBeamPush()
	{
		BEAM_COUNT += 1.0f;
		if (BEAM_COUNT == 30.0f)
		{
			OnNpcatkResumeAi();
			SetIdleAnim(ANIM_IDLE);
			SetMoveAnim(ANIM_RUN);
			BEAM_ON = false;
		}
		if (!(BEAM_COUNT < 30.0f))
			return;
		CallEventDelayed(0.1f, "beam_push");
		if (!IsAlive(BEAM_TARGET))
			BEAM_COUNT = 29.0f;
		if (!IsAlive(BEAM_TARGET))
			return;
		OnNpcatkFaceattacker(BEAM_TARGET);
		Vector3 beamStart = MyOrigin();
		float myYaw = MyAngles().y;
		beamStart += Vec(FINGER_ADJ); // start fingers
		Vector3 beamEnd = OriginOf(BEAM_TARGET);

		string beamTrace = LegacyFunction("get_traceline", beamStart, beamEnd, "worldonly");
		if (beamTrace != Text(beamEnd))
			return;

		PlaySound(0, 10, SOUND_BEAM);
		Effect("beam", "end", "lgtning.spr", 30, beamStart, BEAM_TARGET, 0, Vector3(200, 255, 50), 200, 30, 1.0f);

		myYaw = MyAngles().y + BEAM_COUNT;
		if (myYaw > 359.0f)
			myYaw -= 359.0f;

		Vector3 velSet = RelativePosition(Vector3(0, myYaw, 0), Vector3(500, 1000, 30));

		SetVelocity(BEAM_TARGET, velSet);

		DoDamage(BEAM_TARGET, "direct", DMG_PUSH_BEAM, "100%", self, "lightning");
	}

	// npcatk_hunt
	void SorcShamanElder_OnNpcatkHunt()
	{
		if (!CanSee(NPCATK_TARGET))
			ATTACK_MOVERANGE = Float(Eval("game.monster.moveprox"));
		if (CanSee(NPCATK_TARGET))
			ATTACK_MOVERANGE = ATTACK_RANGE;

		if (!IsAlive(ENT_ME))
			return;
		if (NPCATK_TARGET == "unset")
			return;
		if (!(GameTime() > NEXT_SUMMON))
			return;
		if (!(LHOR_NSUMMONS < SORC_MAX_SUMMONS))
			return;
		NEXT_SUMMON = GameTime() + LHOR_SUMMON_FREQ;
		OnSummonLhor();
	}

	// summon_lhor
	void SorcShamanElder_OnSummonLhor()
	{
		if (NO_SUMMON)
			return;
		Vector3 summonPos = OriginOf(ENT_ME);
		summonPos.z += 76.0f;
		CreateNpc(LHOR_SUMMON_SCRIPT, summonPos, self, NPCATK_TARGET);
		LHOR_NSUMMONS += 1.0f;
	}

	// horror_died
	void SorcShamanElder_OnHorrorDied()
	{
		LHOR_NSUMMONS -= 1.0f;
		// dont constantly refresh summons
		NEXT_SUMMON = GameTime() + LHOR_SUMMON_FREQ;
	}

	// set_turret
	void SorcShamanElder_OnSetTurret()
	{
		AM_TURRET = true;
		SetMoveAnim(ANIM_IDLE);
		ANIM_RUN = ANIM_IDLE;
		ANIM_WALK = ANIM_IDLE;
		NO_STUCK_CHECKS = "1";
		SetRoam(false);
	}

	// npc_post_spawn
	void SorcShamanElder_OnNpcPostSpawn()
	{
		// redundant
		if (!AM_TURRET)
			return;
		SetMoveAnim(ANIM_IDLE);
		ANIM_RUN = ANIM_IDLE;
		ANIM_WALK = ANIM_IDLE;
		NO_STUCK_CHECKS = "1";
		SetRoam(false);
	}

	// set_sorcpal_shaman1
	void SorcShamanElder_OnSetSorcpalShaman1()
	{
		SetSayTextRange(2048);
		SayText("Fear the thunder! Feel the lightning!");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseRanged_OnOrcSpawn(); // monsters/orc_base_ranged
		SorcShamanElder_OnOrcSpawn();
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		OrcBaseRanged_OnNpcTargetsighted(target); // monsters/orc_base_ranged
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
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
		BaseLightningShield_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_lightning_shield
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
		SorcShamanElder_OnNpcPostSpawn();
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseLightningShield_OnNpcatkHunt(); // monsters/base_lightning_shield
		SorcShamanElder_OnNpcatkHunt();
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, SorcShamanElder_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		SorcShamanElder_OnNpcSelectattack();
	}

	// npc_death
	void OnNpcDeath()
	{
		OrcBase_OnNpcDeath(); // monsters/orc_base
		SorcShamanElder_OnNpcDeath();
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		OrcBase_OnNpcStruck(damage); // monsters/orc_base
		SorcShamanElder_OnNpcStruck(damage);
	}

	void OnGamePrecache() { SorcShamanElder_OnGamePrecache(); } // game_precache
	void OnResetRepulseDelay() { SorcShamanElder_OnResetRepulseDelay(); } // reset_repulse_delay
	void OnSwingSword() { SorcShamanElder_OnSwingSword(); } // swing_sword
	void OnThrowFrostbolt() { SorcShamanElder_OnThrowFrostbolt(); } // throw_frostbolt
	void OnResetFrostbolt() { SorcShamanElder_OnResetFrostbolt(); } // reset_frostbolt
	void OnSwipeAttack(CBaseEntity@ enemy = null) { SorcShamanElder_OnSwipeAttack(enemy); } // swipe_attack
	void OnBeamPush() { SorcShamanElder_OnBeamPush(); } // beam_push
	void OnSummonLhor() { SorcShamanElder_OnSummonLhor(); } // summon_lhor
	void OnHorrorDied() { SorcShamanElder_OnHorrorDied(); } // horror_died
	void OnSetTurret() { SorcShamanElder_OnSetTurret(); } // set_turret
	void OnSetSorcpalShaman1() { SorcShamanElder_OnSetSorcpalShaman1(); } // set_sorcpal_shaman1
	void OnFreqRepulse() {} // FREQ_REPULSE
	void OnFrostBoltFreq() {} // FROST_BOLT_FREQ

	// This file's events and timers by their .script names
	bool SorcShamanElder_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "beam_push") { OnBeamPush(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "horror_died") { OnHorrorDied(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "reset_frostbolt") { OnResetFrostbolt(); return true; }
		if (name == "reset_repulse_delay") { OnResetRepulseDelay(); return true; }
		if (name == "set_sorcpal_shaman1") { OnSetSorcpalShaman1(); return true; }
		if (name == "set_turret") { OnSetTurret(); return true; }
		if (name == "summon_lhor") { OnSummonLhor(); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		if (name == "swipe_attack") { OnSwipeAttack(EntityParam(params, 0)); return true; }
		if (name == "throw_frostbolt") { OnThrowFrostbolt(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/sorc_shaman_elder"]
shared class SorcShamanElderScript : OrcBaseScript, SorcShamanElder, OrcBaseRanged, BaseLightningShield
{
	// Variables every script that includes this file declares
	bool AM_ESCORT = false;
	bool AM_HUMILIATED = false;
	string ANIM_KNEEL = "ANIM_KNEEL";
	string ANIM_SORCJUMP = "ANIM_SORCJUMP";
	bool BFSORC_DID_TELE = false;
	bool BFSORC_GOING_TELE = false;
	bool BFSORC_MOVE_TELE = false;
	bool CHAT_ABORT = false;
	string CHAT_ANIMS_ANAME = "CHAT_ANIMS_ANAME";
	bool CHAT_AUTO_FACE = false;
	bool CHAT_AUTO_HAIL = false;
	bool CHAT_AUTO_JOB = false;
	bool CHAT_AUTO_RUMOR = false;
	bool CHAT_BUSY = false;
	string CHAT_CONV_ANIMS = "CHAT_CONV_ANIMS";
	string CHAT_CURRENT_SPEAKER = "CHAT_CURRENT_SPEAKER";
	float CHAT_DELAY = 0.0f;
	string CHAT_DELAYS_ANAME = "CHAT_DELAYS_ANAME";
	float CHAT_END_MOVE_MOUTH = 0.0f;
	float CHAT_END_TIME = 0.0f;
	string CHAT_EVENTS_ANAME = "CHAT_EVENTS_ANAME";
	bool CHAT_FACE_ON_USE = false;
	bool CHAT_IGNORE_WHILE_BUSY = false;
	CBasePlayer@ CHAT_LAST_USED_MENU = null;
	string CHAT_LINES_ANAME = "CHAT_LINES_ANAME";
	int CHAT_MAX_LINE_LEN = 0;
	bool CHAT_MENU_ENABLE = false;
	bool CHAT_MENU_ON = false;
	bool CHAT_MOVE_MOUTH = false;
	bool CHAT_NEVER_INTERRUPT = false;
	bool CHAT_NO_CLOSE_MOUTH = false;
	string CHAT_PLAYANIM_STYLE = "CHAT_PLAYANIM_STYLE";
	bool CHAT_QUE_ACTIVE = false;
	bool CHAT_RESET_ON_NEW = false;
	string CHAT_SEQUENCE = "CHAT_SEQUENCE";
	string CHAT_SOUNDS_ANAME = "CHAT_SOUNDS_ANAME";
	float CHAT_SPOOL_OUT_ALL_COUNT = 0.0f;
	float CHAT_SPOOL_OUT_COUNT = 0.0f;
	bool CHAT_USE_BUSY_MESSAGE = false;
	bool CHAT_USE_CONV_ANIMS = false;
	CBaseEntity@ CHIEF_ID = null;
	bool DID_SHADOWFORM = false;
	bool DID_SPOT_SPEECH = false;
	bool DOING_SWITCH_PAGE = false;
	string DUMP_CONVO = "DUMP_CONVO";
	int FOLLOW_PLR_DIST = 0;
	string FOLLOW_PLR_ID = "FOLLOW_PLR_ID";
	string FPLAYER_LIST = "FPLAYER_LIST";
	float FREQ_SORCJUMP = 0.0f;
	float FREQ_TELE = 0.0f;
	float FSORC_DMG_POINTS = 0.0f;
	bool FSORC_DMG_REQ = false;
	bool FSORC_HIT_BY_BOSS = false;
	bool FSORC_ON = false;
	float FSORC_TELE_HOME_DELAY = 0.0f;
	float FWD_JUMP_STR = 0.0f;
	float F_AS_UNSTUCK_ANG = 0.0f;
	float F_STUCK_COUNT = 0.0f;
	bool HAS_BASE_CHAT_ARRAY_INCLUDE = false;
	bool KNEEL_MODE = false;
	CBaseEntity@ LEADER_ID = null;
	float NEXT_FAS_CHECK = 0.0f;
	float NEXT_FOLLOW_CHECK = 0.0f;
	float NEXT_REGEN = 0.0f;
	float NEXT_SORCJUMP = 0.0f;
	float NEXT_TEAM_ALERT = 0.0f;
	bool NO_CLOSE_MOUTH = false;
	bool NO_SUMMON = false;
	bool NPC_BATTLE_ALLY = false;
	int OLD_DIST = 0;
	int ORC_JUMP_CUTOFF = 0;
	int ORC_JUMP_POWER = 0;
	int ORC_JUMP_RANGE = 0;
	string PLAYERS_TO_REWARD = "PLAYERS_TO_REWARD";
	string PLAYER_LIST = "PLAYER_LIST";
	float REWARDS_LEFT = 0.0f;
	bool REWARD_MODE = false;
	CBaseEntity@ SBOSS_ID = null;
	Vector3 SBOSS_ORG = Vector3();
	CBaseEntity@ SECOND_ID = null;
	bool SETUP_QUALIFICATIONS = false;
	CBasePlayer@ SFORC_MENU_TARGET = null;
	Vector3 SFS_ENTRANCE_POINT = Vector3();
	int SKILL_PAGE = 0;
	int SORC_CUR_TELE_IDX = 0;
	string SORC_FINAL_TELEDEST = "SORC_FINAL_TELEDEST";
	float SORC_LRESIST = 0.0f;
	int SORC_MAX_JUMP_RANGE = 0;
	bool SORC_NO_TELE = false;
	float SORC_PRESIST = 0.0f;
	string SORC_REPULSE_TARGETS = "SORC_REPULSE_TARGETS";
	string SORC_SCAN_BEST_DIST = "SORC_SCAN_BEST_DIST";
	int SORC_SCAN_BEST_IDX = 0;
	string SORC_SCAN_BEST_SET = "SORC_SCAN_BEST_SET";
	int SORC_SCAN_IDX = 0;
	string SORC_SCAN_SET = "SORC_SCAN_SET";
	bool SORC_SUPERJUMP = false;
	bool SORC_TELEPORTS = false;
	bool SORC_TELE_CYCLE_ON = false;
	string SORC_TELE_ORG = "SORC_TELE_ORG";
	string SORC_TELE_SET1 = "SORC_TELE_SET1";
	string SORC_TELE_SET2 = "SORC_TELE_SET2";
	string SORC_TELE_SET3 = "SORC_TELE_SET3";
	int SORC_TELE_SETS = 0;
	string SPAWN_SPEECH = "SPAWN_SPEECH";
	float SPAWN_SPEECH_DELAY = 0.0f;
	string SPOT_SPEECH = "SPOT_SPEECH";
	float TC_AVG_DMG_PTS = 0.0f;
	float TC_HALF_AVG_DMG_PTS = 0.0f;
	bool TC_QUAL_PLAYERS = false;
	Vector3 TO_SBOSS_TELE_POINT = Vector3();
	CBaseEntity@ T_LEADER_ID = null;
	CBaseEntity@ T_SECOND_ID = null;
	CBaseEntity@ T_SHAMAN_ID = null;
	float UP_SORCJUMP_STR = 0.0f;
	bool USER_QUALIFIES = false;
	bool WAIT_MODE = false;
	Vector3 WAIT_POINT = Vector3();
	CBaseEntity@ ZOMBIE_ID = null;

	// Variables declared by included files, with the value they start with in this script
	SorcShamanElderScript()
	{
		SOUND_WARCRY1 = "monsters/orc/attack1.wav";
		ANIM_RUN = "ANIM_RUN";
		ANIM_WALK = "ANIM_WALK";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/orc.mdl");
		Precache("weapons/magic/tornado.mdl");
		Precache("c-tele1.spr");
		Precache("monsters/sorc.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SorcShamanElder_FirstThink();
		OrcBaseRanged_FirstThink();
		OrcBase_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseLightningShield_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return SorcShamanElder_DispatchEvent(name, params)
			|| OrcBaseRanged_DispatchEvent(name, params)
			|| BaseLightningShield_DispatchEvent(name, params)
			|| OrcBaseScript::DispatchEvent(name, params);
	}
}
