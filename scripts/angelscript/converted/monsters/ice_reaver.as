#pragma context server

// Converted from monsters/ice_reaver.script by msc_transpiler.
// Ice Reaver by Thothie from scrath

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/ice_reaver"]
class IceReaver : BaseMonsterNewScript
{
	// Constants
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
	int STRONG_THRESHOLD = 1500;
	float WEAK_THRESHOLD = 1000.0f;
	int NEAR_DEATH_THRESHOLD = 500;
	int PROJECTILE_RANGE = 256;
	bool MAX_PROJECTILE_AMMO = true;
	string SLASH_DAMAGE = "$rand(50,100)";
	string SMASH_DAMAGE = "$rand(100,250)";
	string SLASH_HITCHANCE = "90%";
	string SMASH_HITCHANCE = "100%";
	int SMASH_HITRANGE = 200;
	string SMASH_STUN_CHANCE = "30%";
	string BEAM_DAMAGE = "150";
	int SHOCK_DAMAGE = 20;
	int SHOCK_DURATION = 5;
	string ANIM_SEARCH = "idle2";
	string ANIM_SMASH = "mattack3";
	string ANIM_SLASH = "mattack2";
	string ANIM_PROJECTILE = "distanceattack";
	string ANIM_ALERT = "distanceattack";
	string ANIM_VICTORY1 = "victoryeat";
	string ANIM_VICTORY2 = "victorysniff";
	int DOSMASH_CHANCE = 30;
	string LIGHTNING_SPRITE = "lgtning.spr";
	string MONSTER_MODEL = "monsters/abominable.mdl";

	// Variables (an unset .script variable reads as its own name)
	string SOUND_ATTACKHIT = "SOUND_ATTACKHIT";
	string SOUND_ATTACKMISS = "SOUND_ATTACKMISS";
	float BEAM_FREQ = 0.0f;
	string ANIM_FLINCH = "ANIM_FLINCH";
	string ANIM_DEATH1 = "ANIM_DEATH1";
	string ANIM_DEATH2 = "ANIM_DEATH2";
	string ANIM_DEATH3 = "ANIM_DEATH3";
	string ANIM_VICTORY = "ANIM_VICTORY";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	bool PROJECTILE_AMMO = false;
	float HP_STORAGE = 0.0f;
	float NEXT_PROJECTILE = 0.0f;
	bool DID_WARCRY = false;
	bool FIRST_ATTACK = false;
	string BEAM_TARGET = "BEAM_TARGET";
	bool STUN_ATTACK = false;
	string SOUND_ATTACK = "SOUND_ATTACK";
	string NPC_DAMAGE_TYPE = "NPC_DAMAGE_TYPE";
	string PUSH_VEL = "PUSH_VEL";
	string NPC_DELAYING_UNSTUCK = "NPC_DELAYING_UNSTUCK";
	bool SEARCH_ANIM_DELAY = false;

	// Variables declared by included files, with the value they start with in this script
	IceReaver()
	{
		SOUND_DEATH = "gonarch/gon_die1.wav";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
	}

	// unnamed block (first think)
	void IceReaver_FirstThink()
	{
		SOUND_ATTACKHIT = "unset";
		SOUND_ATTACKMISS = "unset";

		// called indirectly, so need precache
		// defaults are a little too far, prob cuz of large model
		ATTACK_RANGE = 60.0f;
		ATTACK_HITRANGE = 160.0f;
		ATTACK_MOVERANGE = 38.0f;

		BEAM_FREQ = 45.0f;

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

	// slash_dodamage
	void IceReaver_OnSlashDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		STUN_ATTACK = false;
		int randomPush = RandomInt(100, 175);
		PUSH_VEL = Text(RelativeVelocity(Vector3(-100, randomPush, 120)));
		SOUND_ATTACKHIT = SOUND_SLASHHIT;
		SOUND_ATTACKMISS = SOUND_SLASHMISS;
		OnMeleAttack(Text(hit));
	}

	// slash_dodamage
	void IceReaver_OnSlashDodamage_2(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		STUN_ATTACK = true;
		SOUND_ATTACKHIT = SOUND_SMASHHIT;
		SOUND_ATTACKMISS = SOUND_SMASHMISS;
		int randomPush = RandomInt(200, 400);
		PUSH_VEL = Text(RelativeVelocity(Vector3(-100, randomPush, 120)));
		OnMeleAttack(Text(hit));
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

		SetName("Ice Reaver");
		SetHealth(2000);
		SetRoam(true);
		SetDamageTaken("cold", 0);

		if (ToLowerCase(MapName()) == "the_wall")
		{
			SetWidth(48);
			SetHeight(64);
		}
		else
		{
			SetWidth(72);
			SetHeight(64);
		}

		NPC_GIVE_EXP = 400.0f;
		SetRace("demon"); // actually a wildanimal - but I figure likely to be grouped with other baddies
		SetHearingSensitivity(3);
		SetModel(MONSTER_MODEL);
		SetMoveAnim(ANIM_WALK);

		if (StartsWith(ToLowerCase(MapName()), "the_wall"))
			BEAM_FREQ = 15.0f;

		PROJECTILE_AMMO = MAX_PROJECTILE_AMMO;

		HP_STORAGE = MyHealth();

		NEXT_PROJECTILE = GameTime() + BEAM_FREQ;

		CallEventDelayed(1.0f, "post_spawn");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck

		if (SUSPEND_AI)
			return;
		if (I_R_FROZEN)
			return;
		if (NPCATK_TARGET == "unset")
			return;

		// if $get(NPCATK_TARGET,isplayer)
		// lightning blast
		if (!(GameTime() > NEXT_PROJECTILE))
			return;
		NEXT_PROJECTILE = GameTime() + BEAM_FREQ;

		if (!CanSee(NPCATK_TARGET))
			return;

		if (RangeTo(NPCATK_TARGET) > ATTACK_RANGE)
		{
			BEAM_TARGET = NPCATK_TARGET;
			OnNpcatkFaceattacker();
			PlaySound(0, 10, SOUND_BEAMCHARGE);
			AS_ATTACKING = GameTime() + 5.0f;
			OnNpcatkSuspendMovement(ANIM_PROJECTILE, "2.0"); // just in case SOMETHING stops it from completing anim
			PlayAnim("critical", ANIM_PROJECTILE);
		}
		else
		{
			OnReaverBeamReposition();
			NEXT_PROJECTILE = GameTime() + 3.0f;
		}
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
		PlayAnim("once", ANIM_VICTORY);
		PlayRandomSound(0, 10, SOUND_SEARCH1, SOUND_SEARCH2, SOUND_SEARCH3);
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared

		// consider adding if !NPC_ATTACKING to npcatk_attack to cut down on calls, set to 1 on attack, and to 0 in anim
		int randAtk = RandomInt(1, 100);
		if (randAtk <= DOSMASH_CHANCE)
			ANIM_ATTACK = ANIM_SMASH;
		if (randAtk > DOSMASH_CHANCE)
			ANIM_ATTACK = ANIM_SLASH;
		if (FIRST_ATTACK)
			ANIM_ATTACK = ANIM_SMASH;
		FIRST_ATTACK = false;
	}

	// npc_targetsighted
	// first spot
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared

		if (DID_WARCRY)
			return;

		// //dbg temp Spotted Target $get(NPCATK_TARGET,name)
		PlaySound(0, 10, SOUND_WARCRY);
		DID_WARCRY = true;
		FIRST_ATTACK = true;
		NEXT_PROJECTILE = GameTime() + 1.0f;
		AS_ATTACKING = GameTime() + 5.0f;
	}

	// post_spawn
	void OnPostSpawn()
	{
		SetDamageTaken("holy", 0); // set by race in base_npc - this overrides
	}

	// attack_ranged
	// called from model ANIM_PROJECTILE ("distanceattack") @ frame 40
	void OnAttackRanged()
	{
		STUN_ATTACK = false;

		CallEventDelayed(0.5f, "npcatk_resume_ai");

		PlaySound(0, 10, SOUND_BEAMFIRE);

		SetMoveDest(BEAM_TARGET, 9999);

		// //dbg temp Doing Lightnign Blast
		// three beams
		Vector3 beamStart = MyOrigin();
		Vector3 beamEnd = OriginOf(BEAM_TARGET);
		// effects beam point LIGHTNING_SPRITE 50 BEAM_START BEAM_END (255,255,255) 200 2.7 1.5
		Effect("beam", "point", LIGHTNING_SPRITE, 80, RelativePosition(Vector3(0, 0, -22)), beamEnd, Vector3(255, 255, 255), 150, 50, 0.2f);
		Effect("beam", "point", LIGHTNING_SPRITE, 80, RelativePosition(Vector3(-22, 0, 22)), beamEnd, Vector3(255, 255, 255), 150, 50, 0.2f);
		Effect("beam", "point", LIGHTNING_SPRITE, 80, RelativePosition(Vector3(22, 0, 22)), beamEnd, Vector3(255, 255, 255), 150, 50, 0.2f);

		// beam point <spritename> <width> <startpos> <endpos> <(r,g,b)> <brightness> <noise> <duration>
		// switched from frost damage to lightning damage at last second, hence odd var names
		SOUND_ATTACK = "unset";
		NPC_DAMAGE_TYPE = "lightning"; // sent to npcatk_dodamage
		// callevent npcatk_dodamage BEAM_TARGET direct BEAM_DAMAGE 100% $get(ent_me,id) lightning
		DoDamageEx(BEAM_TARGET, "direct", BEAM_DAMAGE, "100%", ENT_ME, ENT_ME, "none", "lightning", "dmgevent:beam");
	}

	// beam_dodamage
	void OnBeamDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		ApplyEffect(target, "effects/dot_lightning", SHOCK_DURATION, self, SHOCK_DAMAGE);
	}

	// reaver_beam_reposition
	void OnReaverBeamReposition()
	{
		OnNpcatkFlee(NPCATK_TARGET, "640", "2.0"); // run away to beam again
	}

	// attack_mele1
	// slash (right hook)
	// called from model ANIM_SLASH (mattack2) @ frame 30
	void OnAttackMele1()
	{
		// callevent npcatk_dodamage NPCATK_TARGET ATTACK_HITRANGE SLASH_DAMAGE SLASH_HITCHANCE
		DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, SLASH_DAMAGE, SLASH_HITCHANCE, ENT_ME, ENT_ME, "none", "slash", "dmgevent:slash");
	}

	// slash_dodamage
	void OnSlashDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		IceReaver_OnSlashDodamage(hit, target, start, end, damageType, damageText);
		IceReaver_OnSlashDodamage_2(hit, target, start, end, damageType, damageText);
	}

	// attack_mele2
	// smash (overhead strike)
	// called from model ANIM_SMASH (mattack3) @ frame 30
	void OnAttackMele2()
	{
		// callevent npcatk_dodamage NPCATK_TARGET SMASH_HITRANGE SMASH_DAMAGE SMASH_HITCHANCE
		DoDamageEx(NPCATK_TARGET, SMASH_HITRANGE, SMASH_DAMAGE, SMASH_HITCHANCE, ENT_ME, ENT_ME, "none", "slash", "dmgevent:smash");
	}

	// npcatk_search_init_advanced
	void OnNpcatkSearchInitAdvanced()
	{
		if (SEARCH_ANIM_DELAY)
			return;
		NPC_DELAYING_UNSTUCK = "10.0";
		PlayAnim("once", ANIM_SEARCH);
		PlayRandomSound(0, 10, SOUND_SEARCH1, SOUND_SEARCH2, SOUND_SEARCH3);
		SEARCH_ANIM_DELAY = true;
		CallEventDelayed(5.0f, "reset_search_anim");
	}

	// reset_search_anim
	void OnResetSearchAnim()
	{
	}

	// mele_attack
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	void OnMeleAttack(string didHit = "")
	{
		if (!Truthy(didHit) && SOUND_ATTACKMISS != "unset")
			PlaySound(0, 10, SOUND_ATTACKMISS);

		if (Truthy(didHit))
		{
			if (SOUND_ATTACKHIT != "unset")
				PlaySound(0, 10, SOUND_ATTACKHIT);
			AddVelocity(ENT_LASTSTRUCKBYME, Vec(PUSH_VEL));
		}

		if (STUN_ATTACK)
		{
			STUN_ATTACK = false;
			if (RandomInt(1, 100) > Float(SMASH_STUN_CHANCE))
				ApplyEffect(NPCATK_TARGET, "effects/debuff_stun", 7, self);
		}
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
		PlayAnim("once", ANIM_VICTORY);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnIceReaverBeamReload() {} // ice_reaver_beam_reload

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("lgtning.spr");
		Precache("monsters/abominable.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		IceReaver_FirstThink();
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
		if (name == "beam_dodamage") { OnBeamDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "game_reached_destination") { OnGameReachedDestination(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "mele_attack") { OnMeleAttack(Param(params, 0)); return true; }
		if (name == "monster_run_step") { OnMonsterRunStep(); return true; }
		if (name == "monster_walk_step") { OnMonsterWalkStep(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_search_init_advanced") { OnNpcatkSearchInitAdvanced(); return true; }
		if (name == "post_spawn") { OnPostSpawn(); return true; }
		if (name == "reaver_beam_reposition") { OnReaverBeamReposition(); return true; }
		if (name == "reset_search_anim") { OnResetSearchAnim(); return true; }
		if (name == "slash_dodamage") { OnSlashDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
