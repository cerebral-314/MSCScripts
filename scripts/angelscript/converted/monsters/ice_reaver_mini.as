#pragma context server

// Converted from monsters/ice_reaver_mini.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/ice_reaver_mini"]
class IceReaverMini : BaseMonsterNewScript
{
	// Constants
	string ANIM_SEARCH = "idle2";
	string ANIM_SMASH = "mattack3";
	string ANIM_SLASH = "mattack2";
	string ANIM_ALERT = "distanceattack";
	string ANIM_VICTORY1 = "victoryeat";
	string ANIM_VICTORY2 = "victorysniff";
	float DMG_SLASH = 0.0f;
	string DMG_SMASH = "DMG_SMASH";
	int DOT_FROST = 25;
	string SLASH_HITCHANCE = "80%";
	string SMASH_HITCHANCE = "90%";
	int SMASH_HITRANGE = 75;
	int SLASH_HITRANGE = 75;
	string SOUND_STRUCK1 = "body/flesh1.wav";
	string SOUND_STRUCK2 = "body/flesh2.wav";
	string SOUND_STRUCK3 = "body/flesh3.wav";
	string SOUND_PAIN1 = "monsters/ice_reaver_mini/gon_pain2.wav";
	string SOUND_PAIN2 = "monsters/ice_reaver_mini/gon_pain4.wav";
	string SOUND_PAIN3 = "monsters/ice_reaver_mini/gon_pain5.wav";
	string SOUND_ALERT = "monsters/ice_reaver_mini/gon_alert1.wav";
	string SOUND_SEARCH1 = "monsters/ice_reaver_mini/gon_childdie3.wav";
	string SOUND_SEARCH2 = "monsters/ice_reaver_mini/gon_childdie2.wav";
	string SOUND_SEARCH3 = "monsters/ice_reaver_mini/gon_childdie1.wav";
	string SOUND_RUN1 = "common/npc_step1.wav";
	string SOUND_RUN2 = "common/npc_step2.wav";
	string SOUND_RUN3 = "common/npc_step3.wav";
	string SOUND_RUN4 = "common/npc_step4.wav";
	string SOUND_SLASHHIT = "zombie/claw_strike1.wav";
	string SOUND_SMASHHIT = "zombie/claw_strike2.wav";
	string SOUND_SLASHMISS = "zombie/claw_miss1.wav";
	string SOUND_SMASHMISS = "zombie/claw_miss2.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_FLINCH = "ANIM_FLINCH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH1 = "ANIM_DEATH1";
	string ANIM_DEATH2 = "ANIM_DEATH2";
	string PUSH_VEL = "PUSH_VEL";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	float HALF_HEALTH = 0.0f;
	float QUARTER_HEALTH = 0.0f;
	bool DID_ALERT = false;
	float NEXT_EAT = 0.0f;
	float NEXT_SEARCH = 0.0f;
	bool MELEE_ATTACK = false;

	// Variables declared by included files, with the value they start with in this script
	IceReaverMini()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		SOUND_DEATH = "monsters/ice_reaver_mini/gon_die1.wav";
	}

	// unnamed block (first think)
	void IceReaverMini_FirstThink()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		ANIM_FLINCH = "turnl";
		ANIM_DEATH = "dieforward";
		ANIM_ATTACK = "mattack3";
		ANIM_DEATH1 = "diesimple";
		ANIM_DEATH2 = "diesideways";
	}

	// unnamed block (first think)
	void IceReaverMini_FirstThink2()
	{
		CAN_FLINCH = "1";
		ATTACK_RANGE = 64.0f;
		ATTACK_HITRANGE = 75.0f;
		ATTACK_MOVERANGE = 40.0f;

		NPC_GIVE_EXP = 200.0f;
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string IceReaverMini_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (MELEE_ATTACK)
		{
			if (!hit)
				PlaySound(0, 10, "SOUND_ATTACKMISS");

			if (hit)
			{
				PlaySound(0, 10, "SOUND_ATTACKHIT");
				if (PUSH_VEL != "none")
				{
					AddVelocity(target, Vec(PUSH_VEL));
					PUSH_VEL = "none";
					ApplyEffect(target, "effects/dot_cold", 5.0f, self, DOT_FROST);
				}
			}
		}
		MELEE_ATTACK = false;
		return result;
	}

	// game_precache
	void OnGamePrecache()
	{
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		string painSound = "PAIN_SOUND";
		float myHp = HealthOf(ENT_ME);
		if (myHp > HALF_HEALTH)
			painSound = SOUND_PAIN1;
		if (myHp < HALF_HEALTH)
			painSound = SOUND_PAIN2;
		if (myHp < QUARTER_HEALTH)
			painSound = SOUND_PAIN3;
		PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_STRUCK2, painSound);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SetName("Ice Reaver Hatchling");
		SetHealth(500);
		SetRoam(true);
		SetDamageTaken("cold", 0);
		SetDamageTaken("fire", 1.2f);

		SetWidth(32);
		SetHeight(32);

		NPC_GIVE_EXP = 200.0f;
		SetRace("demon"); // actually a wildanimal - but I figure likely to be grouped with other baddies
		SetHearingSensitivity(3);
		SetModel("monsters/abominable_mini.mdl");
		SetMoveAnim(ANIM_WALK);

		PUSH_VEL = "none";

		CallEventDelayed(1.5f, "post_setup");
	}

	// npcatk_lost_sight
	void OnNpcatkLostSight()
	{
		BaseNpcAttackNew_OnNpcatkLostSight(); // monsters/base_npc_attack_new
		if (!(GameTime() > NEXT_SEARCH))
			return;
		NEXT_SEARCH = GameTime() + 10.0f;
		PlayAnim("once", ANIM_SEARCH);
		PlayRandomSound(0, 10, SOUND_SEARCH1, SOUND_SEARCH2, SOUND_SEARCH3);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		DID_ALERT = false;
		if (!(GameTime() > NEXT_EAT))
			return;
		NEXT_EAT = GameTime() + 20.0f;
		int rndVict = RandomInt(1, 2);
		if (rndVict == 1)
			PlayAnim("critical", ANIM_VICTORY1);
		if (rndVict == 2)
			PlayAnim("critical", ANIM_VICTORY2);
		PlayRandomSound(0, 10, SOUND_SEARCH1, SOUND_SEARCH2, SOUND_SEARCH3);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, IceReaverMini_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (DID_ALERT)
			return;
		DID_ALERT = true;
		PlayAnim("critical", ANIM_ALERT);
		PlaySound(0, 10, SOUND_ALERT);
	}

	// post_setup
	void OnPostSetup()
	{
		FLINCH_HEALTH = MaxHealthOf(ENT_ME) * 0.25f;
		FLINCH_CHANCE = "30";

		HALF_HEALTH = MaxHealthOf(ENT_ME) * 0.5f;

		QUARTER_HEALTH = FLINCH_HEALTH;
	}

	// monster_run_step
	// ============ ANIM EVENTS
	// called from model anim run at various frames
	void OnMonsterRunStep()
	{
		PlayRandomSound(0, 5, SOUND_RUN1, SOUND_RUN2, SOUND_RUN3, SOUND_RUN4);
	}

	// attack_mele1
	void OnAttackMele1()
	{
		PUSH_VEL = "none";
		MELEE_ATTACK = true;
		DoDamage(NPCATK_TARGET, SLASH_HITRANGE, DMG_SLASH, SLASH_HITCHANCE);
		if (RandomInt(1, 5) != 1)
			return;
		ANIM_ATTACK = ANIM_SMASH;
	}

	// attack_mele2
	void OnAttackMele2()
	{
		MELEE_ATTACK = true;
		PUSH_VEL = Text(RelativeVelocity(Vector3(-100, 300, 110)));
		DoDamage(NPCATK_TARGET, SMASH_HITRANGE, DMG_SMASH, SMASH_HITCHANCE);
		ANIM_ATTACK = ANIM_SLASH;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/abominable_mini.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		IceReaverMini_FirstThink();
		IceReaverMini_FirstThink2();
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
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "monster_run_step") { OnMonsterRunStep(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_lost_sight") { OnNpcatkLostSight(); return true; }
		if (name == "post_setup") { OnPostSetup(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
