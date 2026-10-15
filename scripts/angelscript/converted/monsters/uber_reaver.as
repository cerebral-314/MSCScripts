#pragma context server

// Converted from monsters/uber_reaver.script by msc_transpiler.
// Ice Reaver Patriarch by Thothie from monsters/ice_reaver for Crow

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/uber_reaver"]
class UberReaver : BaseMonsterNewScript
{
	// Constants
	float FREQ_ICE_BLAST = 30.0f;
	float FREQ_SHOCK_BURST = 45.0f;
	float FREQ_SMASH = 10.0f;
	float DMG_FROST = 60.0f;
	float DMG_SHOCK_BURST = 20.0f;
	string CHANCE_FREEZE = "2";
	float DMG_STORM = 20.0f;
	float STORM_DUR = 60.0f;
	int STORM_RAD = 800;
	Vector3 LODAGOND_LOC = Vector3();
	float FREEZE_DURATION = 15.0f;
	int SHOCK_CONE_RANGE = 1024;
	string SOUND_WALK1 = "common/npc_step1.wav";
	string SOUND_WALK2 = "common/npc_step2.wav";
	string SOUND_WALK3 = "common/npc_step3.wav";
	string SOUND_WALK4 = "common/npc_step4.wav";
	string SOUND_RUN1 = "gonarch/gon_step1.wav";
	string SOUND_RUN2 = "gonarch/gon_step2.wav";
	string SOUND_RUN3 = "gonarch/gon_step3.wav";
	string SOUND_WARCRY = "gonarch/gon_alert1.wav";
	string SOUND_STRUCK1 = "gonarch/gon_sack1.wav";
	string SOUND_STRUCK2 = "gonarch/gon_sack2.wav";
	string SOUND_PAIN_STRONG = "gonarch/gon_pain2.wav";
	string SOUND_PAIN_WEAK = "gonarch/gon_pain4.wav";
	string SOUND_PAIN_NEAR_DEATH = "gonarch/gon_pain5.wav";
	string SOUND_SLASHHIT = "zombie/claw_strike1.wav";
	string SOUND_SMASHHIT = "zombie/claw_strike2.wav";
	string SOUND_SLASHMISS = "zombie/claw_miss1.wav";
	string SOUND_SMASHMISS = "zombie/claw_miss2.wav";
	string SOUND_BEAMCHARGE = "debris/beamstart2.wav";
	string SOUND_BEAMFIRE = "debris/beamstart9.wav";
	string SOUND_SEARCH1 = "gonarch/gon_childdie3.wav";
	string SOUND_SEARCH2 = "gonarch/gon_childdie2.wav";
	string SOUND_SEARCH3 = "gonarch/gon_childdie1.wav";
	int STRONG_THRESHOLD = 5000;
	float WEAK_THRESHOLD = 2000.0f;
	int NEAR_DEATH_THRESHOLD = 1000;
	int PROJECTILE_RANGE = 256;
	bool MAX_PROJECTILE_AMMO = true;
	string SLASH_DAMAGE = "$rand(50,100)";
	string SMASH_DAMAGE = "$rand(100,250)";
	string SLASH_HITCHANCE = "90%";
	string SMASH_HITCHANCE = "100%";
	int SMASH_HITRANGE = 200;
	string SMASH_STUN_CHANCE = "50%";
	float BEAM_FREQ = 45.0f;
	string BEAM_DAMAGE = "200";
	int SHOCK_DAMAGE = 100;
	int SHOCK_DURATION = 0;
	string ANIM_SEARCH = "idle2";
	string ANIM_SMASH = "mattack3";
	string ANIM_SLASH = "mattack2";
	string ANIM_PROJECTILE = "distanceattack";
	string ANIM_ALERT = "distanceattack";
	string ANIM_VICTORY1 = "victoryeat";
	string ANIM_VICTORY2 = "victorysniff";
	int DOSMASH_CHANCE = 20;
	string LIGHTNING_SPRITE = "lgtning.spr";
	string MONSTER_MODEL = "monsters/abominable_huge.mdl";

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	string SOUND_ATTACKHIT = "SOUND_ATTACKHIT";
	string SOUND_ATTACKMISS = "SOUND_ATTACKMISS";
	string ANIM_FLINCH = "ANIM_FLINCH";
	string ANIM_DEATH1 = "ANIM_DEATH1";
	string ANIM_DEATH2 = "ANIM_DEATH2";
	string ANIM_DEATH3 = "ANIM_DEATH3";
	string ANIM_VICTORY = "ANIM_VICTORY";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	float HP_STORAGE = 0.0f;
	bool NPC_OVERSIZED = false;
	bool ON_LODAGOND = false;
	bool DID_WARCRY = false;
	bool FIRST_ATTACK = false;
	bool SWING_ATTACK = false;
	string PUSH_VEL = "PUSH_VEL";
	bool STUN_ATTACK = false;
	bool DO_SMASH_DELAY = false;
	string NPC_DELAYING_UNSTUCK = "NPC_DELAYING_UNSTUCK";
	bool SEARCH_ANIM_DELAY = false;
	bool STARTED_SPELLS = false;
	bool DO_ICEBLAST = false;
	bool SKELS_ON = false;

	// Variables declared by included files, with the value they start with in this script
	UberReaver()
	{
		SOUND_DEATH = "gonarch/gon_die1.wav";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
	}

	// unnamed block (first think)
	void UberReaver_FirstThink()
	{
		IS_UNHOLY = true;

		if (ToLowerCase(MapName()) == "lodagond-1")
			NPC_IS_BOSS = true;
		SOUND_ATTACKHIT = "unset";
		SOUND_ATTACKMISS = "unset";

		// called indirectly, so need precache
		// stun burst media
		// defaults are a little too far, prob cuz of large model
		ATTACK_RANGE = 200.0f;
		ATTACK_HITRANGE = 250.0f;
		ATTACK_MOVERANGE = 150.0f;
		MOVE_RANGE = "150"; // this should be redundant, but ain't, for some reason

		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		ANIM_FLINCH = "turnl";
		ANIM_DEATH1 = "dieforward";
		ANIM_DEATH2 = "diesimple";
		ANIM_DEATH3 = "diesideways";
		ANIM_VICTORY = "victoryeat";
		ANIM_DEATH = "dieforward";
		ANIM_ATTACK = "mattack3";

		CAN_FLINCH = "1";
		FLINCH_HEALTH = 500.0f;
		FLINCH_CHANCE = "30";
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string UberReaver_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit && SWING_ATTACK && SOUND_ATTACKMISS != "unset")
			PlaySound(0, 10, SOUND_ATTACKMISS);

		if (hit && SWING_ATTACK)
		{
			if (SOUND_ATTACKHIT != "unset")
				PlaySound(0, 10, SOUND_ATTACKHIT);
			AddVelocity(ENT_LASTSTRUCKBYME, Vec(PUSH_VEL));
			if (RandomInt(1, Int(CHANCE_FREEZE)) == 1)
				ApplyEffect(target, "effects/dot_cold", 5, self, DMG_FROST);
		}

		if (STUN_ATTACK)
		{
			STUN_ATTACK = false;
			if (RandomInt(1, 100) > Float(SMASH_STUN_CHANCE))
				ApplyEffect(target, "effects/debuff_stun", 10, self);
		}
		SWING_ATTACK = false;
		return result;
	}

	// game_damaged
	string UberReaver_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
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
		string mapName = ToLowerCase(MapName());
		if (mapName != "lodagond-1")
			return;
		ON_LODAGOND = true;
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		string painSound = "PAIN_SOUND";

		HP_STORAGE = MyHealth(); // anti-heal

		if (MyHealth() >= 1500.0f)
			painSound = SOUND_PAIN_STRONG;
		if (MyHealth() < 1500.0f)
			painSound = SOUND_PAIN_WEAK;
		if (MyHealth() < 500.0f)
			painSound = SOUND_PAIN_NEAR_DEATH;
		PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_STRUCK2, painSound);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Maldora's Pet");
		SetHealth(9000);
		HP_STORAGE = 9000.0f;
		SetRoam(true);
		SetDamageTaken("all", 0.7f);
		SetDamageTaken("cold", 0);
		SetDamageTaken("fire", 0.2f);
		SetDamageTaken("holy", 1);
		SetDamageTaken("stun", 0.25f);
		SetWidth(200);
		SetHeight(96);
		NPC_GIVE_EXP = 2000.0f; // 4000 maybe more appropriate, but he's too close to the beginning of the level
		SetRace("demon");
		SetHearingSensitivity(3);
		SetModel(MONSTER_MODEL);
		SetMoveAnim(ANIM_WALK);

		NPC_OVERSIZED = true;
		SetNoPush(true);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new

		OnIceReaverBeamReload();

		SetHealth(HP_STORAGE); // anti-heal

		if (CanSee("enemy"))
			return;

		int randVict = RandomInt(1, 2);
		if (randVict == 1)
			ANIM_VICTORY = ANIM_VICTORY1;
		if (randVict == 2)
			ANIM_VICTORY = ANIM_VICTORY2;
		PlayAnim("critical", ANIM_VICTORY);
		PlayRandomSound(0, 10, SOUND_SEARCH1, SOUND_SEARCH2, SOUND_SEARCH3);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, UberReaver_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_up
	// called from npc_attack when player spotted
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new

		if (STARTED_SPELLS)
			return;
		STARTED_SPELLS = true;
		CallEventDelayed(0.5f, "ice_storm");
		CallEventDelayed(FREQ_ICE_BLAST, "ice_blast");
		CallEventDelayed(FREQ_SHOCK_BURST, "do_shock_burst");
		OnToggleSkeles();
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, UberReaver_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npcatk_validatetarget
	// first spot
	void OnNpcatkValidatetarget(string target = "")
	{
		if (!IsPlayer(target))
			return;
		if (DID_WARCRY)
			return;

		// //dbg temp Spotted Target $get(NPCATK_TARGET,name)
		PlaySound(0, 10, SOUND_WARCRY);
		DID_WARCRY = true;
		FIRST_ATTACK = true;
	}

	// attack_mele1
	// slash (right hook)
	// called from model ANIM_SLASH (mattack2) @ frame 30
	void OnAttackMele1()
	{
		SWING_ATTACK = true;

		int randomPush = RandomInt(100, 175);
		PUSH_VEL = Text(RelativeVelocity(Vector3(-100, randomPush, 120)));
		SOUND_ATTACKHIT = SOUND_SLASHHIT;
		SOUND_ATTACKMISS = SOUND_SLASHMISS;
		STUN_ATTACK = false;

		if (!(RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE))
			return;
		OnNpcatkDodamage(NPCATK_TARGET, "direct", SLASH_DAMAGE, SLASH_HITCHANCE, EntityId(self), "slash");

		if (DO_SMASH_DELAY)
			return;
		DO_SMASH_DELAY = true;
		CallEventDelayed(FREQ_SMASH, "reset_do_smash_delay");
		ANIM_ATTACK = ANIM_SMASH;
	}

	// reset_do_smash_delay
	void OnResetDoSmashDelay()
	{
		DO_SMASH_DELAY = false;
	}

	// attack_mele2
	// smash (overhead strike)
	// called from model ANIM_SMASH (mattack3) @ frame 30
	void OnAttackMele2()
	{
		SWING_ATTACK = true;

		SOUND_ATTACKHIT = SOUND_SMASHHIT;
		SOUND_ATTACKMISS = SOUND_SMASHMISS;

		int randomPush = RandomInt(200, 400);
		PUSH_VEL = Text(RelativeVelocity(Vector3(-100, randomPush, 120)));
		if (RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE)
			OnNpcatkDodamage(NPCATK_TARGET, "direct", SMASH_DAMAGE, SMASH_HITCHANCE, EntityId(self), "slash");
		STUN_ATTACK = true;

		CreateNpc("monsters/summon/stun_burst", RelativePosition(Vector3(0, 0, 0)), self, 512, 0, SMASH_DAMAGE);
		ANIM_ATTACK = ANIM_SLASH;
	}

	// npcatk_search_init_advanced
	void OnNpcatkSearchInitAdvanced()
	{
		if (SEARCH_ANIM_DELAY)
			return;
		NPC_DELAYING_UNSTUCK = "10.0";
		PlayAnim("critical", ANIM_SEARCH);
		PlayRandomSound(0, 10, SOUND_SEARCH1, SOUND_SEARCH2, SOUND_SEARCH3);
		SEARCH_ANIM_DELAY = true;
		CallEventDelayed(5.0f, "reset_search_anim");
	}

	// reset_search_anim
	void OnResetSearchAnim()
	{
	}

	// monster_walk_step
	// called from model anim walk at various frames
	void OnMonsterWalkStep()
	{
		PlayRandomSound(0, 5, SOUND_WALK1, SOUND_WALK2, SOUND_WALK3, SOUND_WALK4);
	}

	// monster_run_step
	// called from model anim run at various frames
	void OnMonsterRunStep()
	{
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 64, 10, 0.5f, 128);
		PlayRandomSound(0, 8, SOUND_RUN1, SOUND_RUN2, SOUND_RUN3);
	}

	// npc_death
	// called from base_npc
	void OnNpcDeath()
	{
		// death anims
		int randDeath = RandomInt(1, 3);
		if (randDeath == 1)
			ANIM_DEATH = ANIM_DEATH1;
		if (randDeath == 2)
			ANIM_DEATH = ANIM_DEATH2;
		if (randDeath == 3)
			ANIM_DEATH = ANIM_DEATH3;

		if (SKELS_ON)
			CallExternal("all", "ext_crystal_remove");

		// ;<gold_per_bag> <bags_player> <dist_from_monster> <min#bags> <max#bags>
		OnBmGoldSpew(50, "3", 100, 4, 30);
	}

	// game_reached_destination
	void OnGameReachedDestination()
	{
		// idle anims
		if (NPCATK_TARGET != "unset")
			return;
		if (NPC_LOST_TARGET != "unset")
			return;
		if (CanSee("enemy"))
			return;
		int randVict = RandomInt(1, 2);
		if (randVict == 1)
			ANIM_VICTORY = ANIM_VICTORY1;
		if (randVict == 2)
			ANIM_VICTORY = ANIM_VICTORY2;
		PlayAnim("critical", ANIM_VICTORY);
	}

	// ice_storm
	void OnIceStorm()
	{
		// dbg ice storm
		PlaySound(0, 10, SOUND_WARCRY);
		PlayAnim("critical", ANIM_PROJECTILE);
		Vector3 blizLoc = RelativePosition(Vector3(0, 0, 0));
		if (ON_LODAGOND)
			blizLoc = LODAGOND_LOC;
		CreateNpc("monsters/summon/uber_blizzard", blizLoc, self, DMG_STORM, STORM_DUR, STORM_RAD, "60%");
		float nextStorm = STORM_DUR + 5.0f;
		CallEventDelayed(nextStorm, "ice_storm");
	}

	// ice_blast
	void OnIceBlast()
	{
		PlaySound(0, 10, SOUND_WARCRY);
		PlayAnim("critical", ANIM_PROJECTILE);
		DO_ICEBLAST = true;
		OnToggleSkeles();
		CallEventDelayed(FREQ_ICE_BLAST, "ice_blast");
	}

	// do_shock_burst
	void OnDoShockBurst()
	{
		// dbg shock burst
		CallEventDelayed(FREQ_SHOCK_BURST, "do_shock_burst");

		PlaySound(0, 10, SOUND_WARCRY);
		PlayAnim("critical", ANIM_PROJECTILE);
		SetIdleAnim(ANIM_PROJECTILE);
		SetMoveAnim(ANIM_PROJECTILE);
		AS_ATTACKING = GameTime() + 10.0f;
		OnNpcatkFaceattacker(NPCATK_TARGET);
		OnNpcatkSuspendAi("1.0");

		CallEventDelayed(1.0f, "do_shock_burst2");
	}

	// do_shock_burst2
	void OnDoShockBurst2()
	{
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_RUN);

		// crashie, can't figure why, not enough time to fix - need new attack
		// createnpc monsters/summon/shock_burst $relpos(0,0,0) $get(ent_me,id) DMG_SHOCK_BURST 512 4 (200,200,255) 200
		PlaySound(0, 10, SOUND_BEAMFIRE);
		Vector3 beamStart = MyOrigin();
		string beamEnd = Text(beamStart);
		float myYaw = MyAngles().y;
		beamEnd = Text(Vec(beamEnd) + RelativePosition(Vector3(0, myYaw, 0), Vector3(0, 2000, 0)));
		// effects beam point LIGHTNING_SPRITE 50 BEAM_START BEAM_END (255,255,255) 200 2.7 1.5
		beamStart += RelativePosition(Vector3(0, myYaw, 0), Vector3(-64, 30, 64));
		Effect("beam", "point", LIGHTNING_SPRITE, 250, beamStart, beamEnd, Vector3(254, 254, 254), 150, 50, 0.2f);
		beamStart = MyOrigin() + RelativePosition(Vector3(0, myYaw, 0), Vector3(0, 30, 64));
		Effect("beam", "point", LIGHTNING_SPRITE, 250, beamStart, beamEnd, Vector3(254, 254, 254), 150, 50, 0.2f);
		beamStart = MyOrigin() + RelativePosition(Vector3(0, myYaw, 0), Vector3(64, 30, 64));
		Effect("beam", "point", LIGHTNING_SPRITE, 250, beamStart, beamEnd, Vector3(254, 254, 254), 150, 50, 0.2f);

		SetVar("PLAYER_LIST", GetActivePlayers());
		int count = GetTokenCount("PLAYER_LIST");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnShockCanSee();
		}
	}

	// shock_can_see
	void OnShockCanSee()
	{
		string curPlayer = GetToken("PLAYER_LIST", loopIteration);
		Vector3 curOrg = OriginOf(curPlayer);
		if (!(RangeTo(curPlayer) < SHOCK_CONE_RANGE))
			return;
		if (!Truthy(LegacyFunction("within_cone", curOrg, MyOrigin(), MyAngles(), 60)))
			return;
		Vector3 monCent = MyOrigin();
		monCent.z += 128.0f;
		Effect("beam", "point", LIGHTNING_SPRITE, 250, monCent, curOrg, Vector3(254, 254, 254), 150, 50, 0.2f);
		ApplyEffect(curPlayer, "effects/dot_lightning", SHOCK_DURATION, self, SHOCK_DAMAGE);
		Effect("screenfade", curPlayer, 3, 1, Vector3(255, 255, 255), 255, "fadein");
	}

	// toggle_skeles
	void OnToggleSkeles()
	{
		if (!SKELS_ON)
			OnSummonSkeles();
		if (SKELS_ON)
			OnUnsummonSkeles();
	}

	// unsummon_skeles
	void OnUnsummonSkeles()
	{
		// remove skeles, resummon
		SKELS_ON = false;
		CallExternal("all", "ext_crystal_remove");
		CallEventDelayed(10.0f, "summon_skeles");
	}

	// summon_skeles
	void OnSummonSkeles()
	{
		SKELS_ON = true;
		PlaySound(0, 10, SOUND_PAIN_STRONG);
		UseTrigger("summon_skels");
	}

	// attack_ranged
	// called from model ANIM_PROJECTILE ("distanceattack") @ frame 40
	void OnAttackRanged()
	{
		if (!DO_ICEBLAST)
			return;
		DO_ICEBLAST = false;
		// createnpc monsters/summon/uber_ice_blast $relpos(0,0,0) 1024 FREEZE_DURATION
		OnDoIceblast();
	}

	// do_iceblast
	void OnDoIceblast()
	{
		// dbg ice blast
		Vector3 ballDest = MyOrigin();
		Vector3 angAdj = Vector3(0, 0, 0);
		ballDest += RelativePosition(angAdj, Vector3(0, 2000, 64));
		Vector3 startOfs = MyOrigin() + RelativePosition(angAdj, Vector3(0, 64, 32));
		CreateNpc("monsters/summon/ice_blast", startOfs, self, 10.0f, ballDest);

		ballDest = MyOrigin();
		angAdj = Vector3(0, 90, 0);
		ballDest += RelativePosition(angAdj, Vector3(0, 2000, 64));
		startOfs = MyOrigin() + RelativePosition(angAdj, Vector3(0, 64, 32));
		CreateNpc("monsters/summon/ice_blast", startOfs, self, 10.0f, ballDest);

		ballDest = MyOrigin();
		angAdj = Vector3(0, 180, 0);
		ballDest += RelativePosition(angAdj, Vector3(0, 2000, 64));
		startOfs = MyOrigin() + RelativePosition(angAdj, Vector3(0, 64, 32));
		CreateNpc("monsters/summon/ice_blast", startOfs, self, 10.0f, ballDest);

		ballDest = MyOrigin();
		angAdj = Vector3(0, 270, 0);
		ballDest += RelativePosition(angAdj, Vector3(0, 2000, 64));
		startOfs = MyOrigin() + RelativePosition(angAdj, Vector3(0, 64, 32));
		CreateNpc("monsters/summon/ice_blast", startOfs, self, 10.0f, ballDest);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreqIceBlast() {} // FREQ_ICE_BLAST
	void OnFreqShockBurst() {} // FREQ_SHOCK_BURST
	void OnFreqSmash() {} // FREQ_SMASH
	void OnNextStorm() {} // NEXT_STORM
	void OnIceReaverBeamReload() {} // ice_reaver_beam_reload

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("lgtning.spr");
		Precache("monsters/abominable_huge.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		UberReaver_FirstThink();
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
		if (name == "attack_mele1") { OnAttackMele1(); return true; }
		if (name == "attack_mele2") { OnAttackMele2(); return true; }
		if (name == "attack_ranged") { OnAttackRanged(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_iceblast") { OnDoIceblast(); return true; }
		if (name == "do_shock_burst") { OnDoShockBurst(); return true; }
		if (name == "do_shock_burst2") { OnDoShockBurst2(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_reached_destination") { OnGameReachedDestination(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "ice_blast") { OnIceBlast(); return true; }
		if (name == "ice_storm") { OnIceStorm(); return true; }
		if (name == "monster_run_step") { OnMonsterRunStep(); return true; }
		if (name == "monster_walk_step") { OnMonsterWalkStep(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_search_init_advanced") { OnNpcatkSearchInitAdvanced(); return true; }
		if (name == "npcatk_validatetarget") { OnNpcatkValidatetarget(Param(params, 0)); return true; }
		if (name == "reset_do_smash_delay") { OnResetDoSmashDelay(); return true; }
		if (name == "reset_search_anim") { OnResetSearchAnim(); return true; }
		if (name == "shock_can_see") { OnShockCanSee(); return true; }
		if (name == "summon_skeles") { OnSummonSkeles(); return true; }
		if (name == "toggle_skeles") { OnToggleSkeles(); return true; }
		if (name == "unsummon_skeles") { OnUnsummonSkeles(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
