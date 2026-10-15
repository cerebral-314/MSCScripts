#pragma context server

// Converted from monsters/elemental_air1.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/elemental_air0.as"

[script "monsters/elemental_air1"]
class ElementalAir1 : ElementalAir0Script
{
	// Variables declared by included files, with the value they start with in this script
	ElementalAir1()
	{
		FREQ_CIRCLE = 60.0f;
		DMG_CIRCLE = 100;
	}

	// unnamed block (first think)
	void ElementalAir1_FirstThink()
	{
		AS_SUMMON_TELE_CHECK = true;

		BALL_SIZE = 3.0f;
		DMG_BALL = 60;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		ElementalAir0_OnNpcSpawn(npc); // monsters/elemental_air0

		SetName("Air Elemental");
		SetHealth(500);
		SetWidth(64);
		SetHeight(64);
		SetRace("demon");
		SetDamageTaken("holy", 2);
		SetDamageTaken("poison", 1.5f);
		SetDamageTaken("lightning", 0);
		SetRoam(true);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetHearingSensitivity(5);
		SetModel("monsters/elementals_lesser_fly.mdl");
		SetModelBody(0, 1);
		NPC_GIVE_EXP = 150.0f;
		CallEventDelayed(1.0f, "idle_sounds");
		FIRE_BALL_AMMO = FULL_FIRE_BALL_AMMO;
		I_JUST_SPAWNED = 1;

		SetFly(true);

		SetBlood("none");

		MY_HURT_STAGE = MaxHealthOf(ENT_ME) * HURT_THRESHOLD;

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", RandomInt(200, 255));

		CallEventDelayed(0.1f, "init_beam");

		NEXT_LIGHTNING_BALL = 0.0f;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		ElementalAir0_OnNpcTargetsighted(target); // monsters/elemental_air0

		if (!(GameTime() > NEXT_LIGHTNING_BALL))
			return;
		NEXT_LIGHTNING_BALL = GameTime() + FREQ_LIGHTING_BALLS;
		OnNpcatkSuspendAi("1.5");
		PlaySound(0, 10, SOUND_ALERT);

		BALL_TARGETS = TokenShuffle(LegacyFunction("get_tsphere", "enemy", 1024, MyOrigin()));
		SetMoveDest(GetToken(BALL_TARGETS, 0), 9999);
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_lightning_ball_simple", "view", GetToken(BALL_TARGETS, 0), 200, DMG_BALL, 0.5f, "none");

		if (!(GetTokenCount(BALL_TARGETS) > 1))
			return;
		CallEventDelayed(0.5f, "toss_ball_2");
	}

	// toss_ball_2
	void OnTossBall2()
	{
		SetMoveDest(GetToken(BALL_TARGETS, 1), 9999);
		TossProjectile("proj_lightning_ball_simple", "view", GetToken(BALL_TARGETS, 1), 200, DMG_BALL, 0.5f, "none");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ElementalAir1_FirstThink();
		ElementalAir0_FirstThink();
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
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "toss_ball_2") { OnTossBall2(); return true; }
		return ElementalAir0Script::DispatchEvent(name, params);
	}
}
