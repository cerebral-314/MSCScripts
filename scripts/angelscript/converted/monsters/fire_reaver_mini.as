#pragma context server

// Converted from monsters/fire_reaver_mini.script by msc_transpiler.
// Fire Reaver Hatchling, from Fire Reaver by Thothie (quick and sloppy)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/fire_reaver_mini"]
class FireReaverMini : BaseMonsterNewScript
{
	// Constants
	float DMG_BURST = 30.0f;
	float DOT_BURN = 10.0f;
	float FREQ_FIRE_BURST = 0.0f;
	int ROCK_START_HEIGHT = 96;
	int DMG_VOLCANO_DART = 25;
	float FREQ_VOLC_SOUND = 7.0f;
	float FREQ_VOLCANO = 0.25f;
	float FREQ_SMASH = 10.0f;
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
	string SOUND_SEARCH1 = "gonarch/gon_childdie3.wav";
	string SOUND_SEARCH2 = "gonarch/gon_childdie2.wav";
	string SOUND_SEARCH3 = "gonarch/gon_childdie1.wav";
	int STRONG_THRESHOLD = 2500;
	float WEAK_THRESHOLD = 2000.0f;
	int NEAR_DEATH_THRESHOLD = 750;
	string SLASH_DAMAGE = "$rand(100,200)";
	string SMASH_DAMAGE = "500";
	string SLASH_HITCHANCE = "90%";
	float FREQ_MISSILE = 20.0f;
	int DMG_MISSILE = 600;
	float FREQ_VOLC = 1.0f;
	string ANIM_SEARCH = "idle2";
	string ANIM_SMASH = "mattack3";
	string ANIM_SLASH = "mattack2";
	string ANIM_PROJECTILE = "distanceattack";
	string ANIM_ALERT = "distanceattack";
	string ANIM_VICTORY1 = "victoryeat";
	string ANIM_VICTORY2 = "victorysniff";
	int DOSMASH_CHANCE = 30;

	// Variables (an unset .script variable reads as its own name)
	int DMG_VOLCANO = 0;
	bool DMG_VOLCANO_DOT = false;
	string SOUND_ATTACKHIT = "SOUND_ATTACKHIT";
	string SOUND_ATTACKMISS = "SOUND_ATTACKMISS";
	string ANIM_FLINCH = "ANIM_FLINCH";
	string ANIM_DEATH1 = "ANIM_DEATH1";
	string ANIM_DEATH2 = "ANIM_DEATH2";
	string ANIM_DEATH3 = "ANIM_DEATH3";
	string ANIM_VICTORY = "ANIM_VICTORY";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	bool DID_WARCRY = false;
	bool FIRST_ATTACK = false;
	float NEXT_FIRE_BURST = 0.0f;
	bool SMASH_DELAY = false;
	string PUSH_VEL = "PUSH_VEL";
	bool PUSH_ATTACK = false;
	string NPC_DELAYING_UNSTUCK = "NPC_DELAYING_UNSTUCK";
	bool SEARCH_ANIM_DELAY = false;
	float HP_STORAGE = 0.0f;
	bool VOLCANO_ON = false;

	// Variables declared by included files, with the value they start with in this script
	FireReaverMini()
	{
		SOUND_DEATH = "gonarch/gon_die1.wav";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
	}

	// unnamed block (first think)
	void FireReaverMini_FirstThink()
	{
		NPC_GIVE_EXP = 250.0f;
		DMG_VOLCANO = 200;
		DMG_VOLCANO_DOT = true;
		SOUND_ATTACKHIT = "unset";
		SOUND_ATTACKMISS = "unset";

		// called indirectly, so need precache
		// defaults are a little too far, prob cuz of large model
		ATTACK_RANGE = 125.0f;
		ATTACK_HITRANGE = 150.0f;
		ATTACK_MOVERANGE = 50.0f;
		MOVE_RANGE = "50";

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
		FLINCH_HEALTH = 1000.0f;
		FLINCH_CHANCE = "30";
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string FireReaverMini_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit && SOUND_ATTACKMISS != "unset")
			PlaySound(0, 10, SOUND_ATTACKMISS);

		if (hit)
		{
			if (SOUND_ATTACKHIT != "unset")
				PlaySound(0, 10, SOUND_ATTACKHIT);

			if (PUSH_ATTACK && RelationshipOf(target, ENT_ME) == "enemy")
			{
				AddVelocity(target, Vec(PUSH_VEL));
				ApplyEffect(target, "effects/dot_fire", 5.0f, self, DOT_BURN);
			}
		}
		PUSH_ATTACK = false;
		return result;
	}

	// game_death
	// { cycle_up
	// //if ( G_DEVELOPER_MODE ) messageall green firereaver: cycle_up ( VOLCANO_ID )
	// //callevent volcano_shoot
	// }
	// { start_volcano
	// if ( VOLCANO_ID equals 'VOLCANO_ID' )
	// {
	// clientevent new all monsters/fire_reaver_cl $get(ent_me,origin) $get(ent_me,index)
	// setvard VOLCANO_ID game.script.last_sent_id
	// }
	// if !VOLCANO_ON
	// setvard VOLCANO_ON 1
	// callevent 0.1 volcano_shoot
	// }
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
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

		SetName("Fire Reaver Hatchling");
		SetHealth(800);
		SetRoam(true);
		SetDamageTaken("cold", 1); // just that hot
		SetDamageTaken("fire", 0);
		SetDamageTaken("holy", 0.5f); // some magic involved in creation
		SetWidth(32);
		SetHeight(48);

		SetRace("demon");
		SetHearingSensitivity(3);
		SetModel("monsters/firereaver_mini.mdl");
		SetMoveAnim(ANIM_WALK);

		DebugPrint(Eval("game.monster.moveprox"));
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck

		if (NPCATK_TARGET == "unset")
			return;
		if (!IsPlayer(NPCATK_TARGET))
			return;
	}

	// npcatk_clear_targets
	void OnNpcatkClearTargets(string reason = "")
	{
		BaseNpcAttackNew_OnNpcatkClearTargets(reason); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkClearTargets(reason); // monsters/base_monster_shared
		BaseMonsterShared_OnNpcatkClearTargets_2(reason); // monsters/base_monster_shared
		VOLCANO_ON = false;
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new

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
		result = AppendResult(result, FireReaverMini_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (RangeTo(NPCATK_TARGET) < 256.0f && GameTime() > NEXT_FIRE_BURST)
		{
			NEXT_FIRE_BURST = GameTime() + FREQ_FIRE_BURST;
			OnDoFireBurst();
		}
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

	// reset_smash_delay
	void OnResetSmashDelay()
	{
		SMASH_DELAY = false;
	}

	// attack_mele1
	// slash (right hook)
	// called from model ANIM_SLASH (mattack2) @ frame 30
	void OnAttackMele1()
	{
		int randomPush = RandomInt(90, 150);
		PUSH_VEL = Text(RelativeVelocity(Vector3(-100, randomPush, 110)));
		SOUND_ATTACKHIT = SOUND_SLASHHIT;
		SOUND_ATTACKMISS = SOUND_SLASHMISS;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), SLASH_DAMAGE, SLASH_HITCHANCE);
		PUSH_ATTACK = true;

		if (RandomInt(1, 5) != 1)
			return;
		ANIM_ATTACK = ANIM_SMASH;
	}

	// attack_mele2
	// smash (overhead strike)
	// called from model ANIM_SMASH (mattack3) @ frame 30
	void OnAttackMele2()
	{
		SOUND_ATTACKHIT = SOUND_SMASHHIT;
		SOUND_ATTACKMISS = SOUND_SMASHMISS;
		ANIM_ATTACK = ANIM_SLASH;

		float slashDamage = Float(SLASH_DAMAGE);
		slashDamage *= 3.0f;

		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(slashDamage), SLASH_HITCHANCE);
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
		SEARCH_ANIM_DELAY = false;
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
		PlayRandomSound(0, 5, SOUND_WALK1, SOUND_WALK2, SOUND_WALK3, SOUND_WALK4);
	}

	// npc_death
	// called from base_npc
	void OnNpcDeath()
	{
		// death anims
		int randDeath = RandomInt(2, 3);
		// if ( RAND_DEATH == 1 ) setvard ANIM_DEATH ANIM_DEATH1 //use for volcano anim instead
		if (randDeath == 2)
			ANIM_DEATH = ANIM_DEATH2;
		if (randDeath == 3)
			ANIM_DEATH = ANIM_DEATH3;

		SUSPEND_AI = true;
		SetMoveDest("none");
		SetMoveAnim(ANIM_DEATH);
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

	// do_fire_burst
	void OnDoFireBurst(Vector3 projectilePosition = Vector3())
	{
		AS_ATTACKING = GameTime() + 2.0f;
		PlayAnim("critical", ANIM_PROJECTILE);
	}

	// attack_ranged
	// called from model ANIM_PROJECTILE ("distanceattack") @ frame 40
	void OnAttackRanged()
	{
		PlaySound(0, 10, "ambience/steamburst1.wav");
		ClientEvent("new", "all", "monsters/summon/flame_burst_cl", IndexOf(ENT_ME));
		DoDamage(Text(OriginOf(ENT_ME)), 384, DMG_BURST, "100%", 0, "reflective", "fire");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/firereaver_mini.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		FireReaverMini_FirstThink();
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
		if (name == "do_fire_burst") { OnDoFireBurst(Vec(Param(params, 0))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_reached_destination") { OnGameReachedDestination(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "monster_run_step") { OnMonsterRunStep(); return true; }
		if (name == "monster_walk_step") { OnMonsterWalkStep(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_clear_targets") { OnNpcatkClearTargets(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_search_init_advanced") { OnNpcatkSearchInitAdvanced(); return true; }
		if (name == "npcatk_validatetarget") { OnNpcatkValidatetarget(Param(params, 0)); return true; }
		if (name == "reset_search_anim") { OnResetSearchAnim(); return true; }
		if (name == "reset_smash_delay") { OnResetSmashDelay(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
