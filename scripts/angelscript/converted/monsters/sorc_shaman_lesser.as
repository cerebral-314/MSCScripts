#pragma context server

// Converted from monsters/sorc_shaman_lesser.script by msc_transpiler.
// Sorc Shamman (In training) by Thothie (from morc shaman)
// - full fledger should do more damage and spawn lightning horror on death

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_ranged.as"
#include "converted/monsters/orc_base.as"

[script "monsters/sorc_shaman_lesser"]
class SorcShamanLesser : OrcBaseScript, OrcBaseRanged
{
	// Constants
	string FINGER_ADJ = "$relpos($vec(0,MY_YAW,0),$vec(0,30,54))";
	string SOUND_BEAM = "weather/Storm_exclamation.wav";
	string ANIM_BEAM = "battleaxe_swing1_L";
	float DMG_PUSH_BEAM = 0.0f;
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
	string SOUND_WARCRY2 = "monsters/orc/attack3.wav";
	string FROST_BOLT_DAMAGE = "$rand(25,60)";
	string FROST_STRIKE_DAMAGE = "$rand(10,20)";
	float FROST_BOLT_FREQ = 1.5f;
	string DEATH_SCRIPT = "monsters/summon/summon_lightning_storm";

	// Variables (an unset .script variable reads as its own name)
	float FREQ_REPULSE = 0.0f;
	float BALL_SIZE = 0.0f;
	float BALL_DMG = 0.0f;
	string BALL_TYPE = "BALL_TYPE";
	bool REPULSE_DELAY = false;
	string BEAM_TARGET = "BEAM_TARGET";
	float BEAM_COUNT = 0.0f;
	bool FROST_BOLT_DELAY = false;
	bool DID_WARCRY = false;
	bool SWIPE_SOUNDS = false;
	bool BEAM_ON = false;
	bool AM_TURRET = false;

	// Variables declared by included files, with the value they start with in this script
	SorcShamanLesser()
	{
		SOUND_WARCRY1 = "monsters/orc/attack1.wav";
		ANIM_RUN = "ANIM_RUN";
		ANIM_WALK = "ANIM_WALK";
	}

	// unnamed block (first think)
	void SorcShamanLesser_FirstThink()
	{
		FREQ_REPULSE = Random(15, 20);

		DROP_GOLD = 1; // Gold Drop
		DROP_GOLD_AMT = RandomInt(15, 30);
		NPC_GIVE_EXP = 220.0f;

		// setvard DROP_ITEM1 scroll2_frost_xolt //hanled through monsters/base_monster
		// setvard DROP_ITEM1_CHANCE 5%	  //hanled through by monsters/base_monster
		ANIM_ATTACK = "swordswing1_L"; // Attack animation
		FLINCH_CHANCE = "45%";

		MOVE_RANGE = "256";
		ATTACK_RANGE = 2000.0f;
		ANIM_IDLE = "idle1";

		BALL_SIZE = 3.0f;
		BALL_DMG = 10.0f;
		BALL_TYPE = "lightning";
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string SorcShamanLesser_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!SWIPE_SOUNDS)
			return result;

		if (!hit)
			PlaySound(0, 10, SOUND_MELEMISS);

		if (hit)
			PlaySound(0, 10, SOUND_MELEHIT);

		SWIPE_SOUNDS = false;
		return result;
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseRanged_OnOrcSpawn(); // monsters/orc_base_ranged

		SetHealth(750);
		SetName("Shadahar Shaman Initiate");
		SetHearingSensitivity(8);
		SetDamageTaken("lightning", 0);
		SetDamageTaken("poison", 2);
		SetDamageTaken("acid", 2);
		SetStat("spellcasting", 30, 30, 30, 30, 30, 30, 30); // ><

		SetModel("monsters/sorc.mdl");

		SetModelBody(0, 0); // body: 0=bare 1=bloody_shirt 2=gold_armor 3=archer
		SetModelBody(1, 4); // head: 0=hat_horns 1=hat_spiked 2=lizardskin_horned 3=gold_Chieftain 4=lizard_cap
		SetModelBody(2, 0); // weapon: 0=unarmed 1=axe 2=bow 3=steel_bow 4=sword 5=great_axe 6=sword_sheild 8=yellow_axe 9=blooddrinker
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
		// redundant
		if (!AM_TURRET)
			return;
		SetMoveAnim(ANIM_IDLE);
		ANIM_RUN = ANIM_IDLE;
		ANIM_WALK = ANIM_IDLE;
		NO_STUCK_CHECKS = "1";
		SetRoam(false);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		if (NPCATK_TARGET == "unset")
			return;
		if (!CanSee(NPCATK_TARGET))
			ATTACK_MOVERANGE = Float(Eval("game.monster.moveprox"));
		if (CanSee(NPCATK_TARGET))
			ATTACK_MOVERANGE = ATTACK_RANGE;
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, SorcShamanLesser_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared

		float nmeRange = RangeTo(ENT_LASTSEEN);
		if (FROST_BOLT_DELAY && nmeRange > MELE_HITRANGE)
			ANIM_ATTACK = ANIM_FIRE;
		if (!FROST_BOLT_DELAY)
			ANIM_ATTACK = ANIM_FIRE;
		if (!(nmeRange < MELE_HITRANGE))
			return;
		if (REPULSE_DELAY)
			return;
		REPULSE_DELAY = true;
		CallEventDelayed(FREQ_REPULSE, "reset_repulse_delay");
		SetMoveAnim(ANIM_BEAM);
		SetIdleAnim(ANIM_BEAM);
		PlayAnim("critical", ANIM_BEAM);
		BEAM_TARGET = NPCATK_TARGET;
		AS_ATTACKING = GameTime();
		BEAM_COUNT = 0.0f;
		OnNpcatkSuspendAi();
		OnBeamPush();
	}

	// npc_death
	void OnNpcDeath()
	{
		OrcBase_OnNpcDeath(); // monsters/orc_base

		SetSolid("none");
		SetBoundingBox("none");
		Vector3 ballDest = RelativePosition(Vector3(0, 0, 2000));
		PlaySound(0, 10, SOUND_DEATH_SHOOT);
		Vector3 stormPos = MyOrigin();
		stormPos.z = GroundHeight(MyOrigin());
		CreateNpc(DEATH_SCRIPT, stormPos, self, AnglesOf(ENT_ME).y, 40.0f, 15.0f);
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		OrcBase_OnNpcStruck(damage); // monsters/orc_base

		if (!(RangeTo(ENT_LASTSTRUCK) < MELE_RANGE))
			return;
		// setvard ANIM_ATTACK ANIM_KICK
		OnNpcatkSettarget(EntityId(EntityOf(ENT_LASTSTRUCK)));
	}

	// reset_repulse_delay
	void OnResetRepulseDelay()
	{
		REPULSE_DELAY = false;
	}

	// swing_sword
	// called by modeanim swordswing1_L at frame 14
	void OnSwingSword()
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
	void OnThrowFrostbolt()
	{
		if (!CanSee(NPCATK_TARGET))
			return;
		OnNpcatkFaceattacker(NPCATK_TARGET);

		CallEventDelayed(FROST_BOLT_FREQ, "reset_frostbolt");
		PlayRandomSound(0, 10, SOUND_SHOCK1, SOUND_SHOCK2, SOUND_SHOCK3);

		float finalDamage = Float(FROST_BOLT_DAMAGE);
		if (EXT_DAMAGE_ADJUSTMENT != "EXT_DAMAGE_ADJUSTMENT") // for future use
			finalDamage += Float(EXT_DAMAGE_ADJUSTMENT);
		TossProjectile("proj_lightning_ball", RelativePosition(Vector3(0, 48, 18)), NPCATK_TARGET, ATTACK_SPEED, finalDamage, ATTACK_CONE_OF_FIRE, "none");
		FROST_BOLT_DELAY = true;
	}

	// reset_frostbolt
	void OnResetFrostbolt()
	{
		ANIM_ATTACK = ANIM_FIRE;
		DID_WARCRY = false;
		FROST_BOLT_DELAY = false;
	}

	// swipe_attack
	// PARAM1 = enemy struck
	void OnSwipeAttack(CBaseEntity@ enemy = null)
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

	// beam_push
	void OnBeamPush()
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

	// set_turret
	void OnSetTurret()
	{
		AM_TURRET = true;
		SetMoveAnim(ANIM_IDLE);
		ANIM_RUN = ANIM_IDLE;
		ANIM_WALK = ANIM_IDLE;
		NO_STUCK_CHECKS = "1";
		SetRoam(false);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		OrcBaseRanged_OnNpcTargetsighted(target); // monsters/orc_base_ranged
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
	}

	void OnFreqRepulse() {} // FREQ_REPULSE
	void OnFrostBoltFreq() {} // FROST_BOLT_FREQ

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/orc.mdl");
		Precache("monsters/sorc.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SorcShamanLesser_FirstThink();
		OrcBaseRanged_FirstThink();
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
		if (name == "beam_push") { OnBeamPush(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "reset_frostbolt") { OnResetFrostbolt(); return true; }
		if (name == "reset_repulse_delay") { OnResetRepulseDelay(); return true; }
		if (name == "set_turret") { OnSetTurret(); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		if (name == "swipe_attack") { OnSwipeAttack(EntityParam(params, 0)); return true; }
		if (name == "throw_frostbolt") { OnThrowFrostbolt(); return true; }
		return OrcBaseRanged_DispatchEvent(name, params)
			|| OrcBaseScript::DispatchEvent(name, params);
	}
}
