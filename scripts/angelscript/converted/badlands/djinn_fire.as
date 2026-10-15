#pragma context server

// Converted from badlands/djinn_fire.script by msc_transpiler.
// Badlands Fire Djinn Variant by Thothie - throws fireballs instead of summons, does not move

#include "runtime/ScriptEntity.as"
#include "converted/monsters/djinn_fire.as"

[script "badlands/djinn_fire"]
class BadlandsDjinnFire : MonstersDjinnFireScript
{
	// Variables declared by included files, with the value they start with in this script
	BadlandsDjinnFire()
	{
		SOUND_FIRESHOOT = "magic/fireball_strike.wav";
		FIRE_BALL_FREQ = 2.5f;
		AIM_RATIO = 50;
		ATTACK_SPEED = 500;
		ATTACK_CONE_OF_FIRE = 2;
		FIRE_BALL_DAMAGE = "400";
		FIRE_BALL_RANGE = 4000;
		SOUND_WARCRY = "monsters/troll/trollidle2.wav";
		WARCRY_FREQ = 60.0f;
		PUSH_CHANCE = 5;
		BURN_DAMAGE = "$rand(20,50)";
		CANT_FLEE = true;
		ANIM_WALK = "idle0";
		ANIM_RUN = "idle1";
	}

	// unnamed block (first think)
	void BadlandsDjinnFire_FirstThink()
	{
		CAN_FLEE = "0";

		ANIM_WALK = "idle0";
		ANIM_RUN = "idle1";

		NO_STUCK_CHECKS = "1";

		PrecacheFile("monsters/djinn_fire");
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttack_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack

		if (FIRE_BALL_DELAY)
			return;
		if (!CanSee("enemy"))
			return;
		// //dbg See enemy
		if (!(RangeTo(ENT_LASTSEEN) > ATTACK_RANGE))
			return;
		// //dbg in range
		PlayAnim("once", "idle2");
		OnThrowFireBallStart();
		CallEventDelayed(FIRE_BALL_FREQ, "reset_fire_ball_delay");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		MonstersDjinnFire_OnNpcSpawn(npc); // monsters/djinn_fire

		SetName("Fire Djinn Val-sul");
		SetMoveSpeed(0);
		SetProp(ENT_ME, Eval("const.movetype.none"));
		SetRoam(false);
		SetHealth(4500);
		SetDamageTaken("all", 0.6f);
		SetDamageTaken("cold", 1.25f);
		SetDamageTaken("stun", 0);
		SetGravity(100);

		CallEventDelayed(WARCRY_FREQ, "do_warcry");
	}

	// reset_fire_ball_delay
	void OnResetFireBallDelay()
	{
		FIRE_BALL_DELAY = false;
	}

	// throw_fire_ball_start
	void OnThrowFireBallStart()
	{
		if (IS_FLEEING)
			return;

		// //dbg throwing
		FIRE_BALL_DELAY = true;
		OnNpcatkFaceattacker(EntityId(EntityOf(ENT_LASTSEEN)));
		PlayAnim("critical", "throw_rock");
	}

	// rock_throw
	void OnRockThrow()
	{
		PlaySound(0, 10, SOUND_FIRESHOOT);

		// //dbg actual throw
		float aimAngle = Divide(DistanceTo(ENT_LASTSEEN), AIM_RATIO); // Aim up a bit
		SetAngle("add_view.x", aimAngle);

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none>
		TossProjectile("proj_fire_ball", RelativePosition(Vector3(0, 0, 46)), @EntityOf(ENT_LASTSEEN), ATTACK_SPEED, FIRE_BALL_DAMAGE, ATTACK_CONE_OF_FIRE, "none"); // Converted to use new tossprojectile //greatguys1@FEB2022
		CallExternal(EntityOf(ENT_LASTPROJECTILE), "lighten", BURN_DAMAGE);
	}

	// summon_firetroll
	void OnSummonFiretroll()
	{
		DO_NADDA = true;
	}

	// do_warcry
	void OnDoWarcry()
	{
		IS_FLEEING = true;
		PURE_FLEE = true;
		PlaySound(0, 10, SOUND_WARCRY);
		PlayAnim("critical", "idle2");
		CallEventDelayed(WARCRY_FREQ, "do_warcry");
		CallEventDelayed(2.0f, "restore_attacks");
	}

	// restore_attacks
	void OnRestoreAttacks()
	{
		IS_FLEEING = false;
		PURE_FLEE = false;
	}

	// warcry
	// called by model anim idle2 @ frame #28
	void OnWarcry()
	{
		UseTrigger("djinn_push");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFireBallFreq() {} // FIRE_BALL_FREQ
	void OnWarcryFreq() {} // WARCRY_FREQ

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BadlandsDjinnFire_FirstThink();
		MonstersDjinnFire_FirstThink();
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
		if (name == "do_warcry") { OnDoWarcry(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "reset_fire_ball_delay") { OnResetFireBallDelay(); return true; }
		if (name == "restore_attacks") { OnRestoreAttacks(); return true; }
		if (name == "rock_throw") { OnRockThrow(); return true; }
		if (name == "summon_firetroll") { OnSummonFiretroll(); return true; }
		if (name == "throw_fire_ball_start") { OnThrowFireBallStart(); return true; }
		if (name == "warcry") { OnWarcry(); return true; }
		return MonstersDjinnFireScript::DispatchEvent(name, params);
	}
}
