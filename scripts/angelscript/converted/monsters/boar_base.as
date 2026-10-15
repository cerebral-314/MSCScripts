#pragma context server

// Converted from monsters/boar_base.script by msc_transpiler.
// Weak Boar

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BoarBase
{
	// Constants
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_PAIN = "monsters/boar/boarpain.wav";
	string SOUND_IDLE1 = "monsters/boar/boaridle.wav";
	string SOUND_IDLE2 = "monsters/boar/boarsight2.wav";
	string SOUND_CHARGE = "monsters/boar/boarsight.wav";
	string SOUND_DEATH = "monsters/boar/boardeath.wav";
	string ANIM_BOAR_RUN = "run";
	string ANIM_FORWARD = "gore_forward";
	string ANIM_RIGHT = "gore_right";
	string ANIM_LEFT = "gore_left";
	string ANIM_STOMP = "stompsnort";
	string ANIM_CHARGE = "charge";
	string ATTACK_HITCHANCE = "50%";
	string RETALIATE_CHANGETARGET_CHANCE = "75%";
	string CL_SCRIPT = "monsters/boar_base_cl_charge";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle1";
	string ANIM_IDLE_EATGRASS = "idle2";
	string ANIM_RUN = "run";
	string ANIM_WALK = "walk";
	string HUNT_AGRO = "HUNT_AGRO";
	string ANIM_DEATH = "ANIM_DEATH";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string DROP_ITEM1 = "DROP_ITEM1";
	string DROP_ITEM1_CHANCE = "DROP_ITEM1_CHANCE";
	string CAN_RETALIATE = "CAN_RETALIATE";
	bool BOAR_IS_CHARGING = false;
	string BOAR_CHARGE_TARGET = "BOAR_CHARGE_TARGET";
	string ANIM_ATTACK = "ANIM_ATTACK";
	float AS_ATTACKING = 0.0f;
	string CAN_ATTACK = "CAN_ATTACK";
	string CAN_HEAR = "CAN_HEAR";
	string BOAR_CAN_FLEE = "BOAR_CAN_FLEE";
	string CAN_FLEE = "CAN_FLEE";
	string CL_SCRIPT_ID = "CL_SCRIPT_ID";

	// unnamed block (first think)
	void BoarBase_FirstThink()
	{
		HUNT_AGRO = "0"; // boards are non-agro unless specified otherwise

		ANIM_IDLE = "idle1";
		ANIM_IDLE_EATGRASS = "idle2";
		ANIM_RUN = "run"; // Not a constant because it changes
		ANIM_WALK = "walk";
		ANIM_DEATH = "die1";

		MOVE_RANGE = "64";
		ATTACK_RANGE = 96.0f;
		ATTACK_HITRANGE = 120.0f;
		DROP_ITEM1 = "skin_boar"; // base_monster - Item Drop #1
		DROP_ITEM1_CHANCE = "20%"; // base_monster - Chance of item drop #1

		CAN_RETALIATE = "1"; // Not const

		BOAR_IS_CHARGING = false;
		BOAR_CHARGE_TARGET = "\x81PNONE\x81P";
		ANIM_ATTACK = ANIM_FORWARD; // JUN2007b - start with some sort of attack to avoid anim error
		PrecacheFile(CL_SCRIPT);
	}

	// npc_spawn
	void BoarBase_OnNpcSpawn(string npc = "")
	{
		SetWidth(50);
		SetHeight(40);
		// ov 120
		SetRace("wildanimal");
		SetRoam(true);
		SetHearingSensitivity(0);

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		SetModel("monsters/boar.mdl");

		if (ToLowerCase(MapName()) == "nightmare_thornlands")
			SetMonsterClip(false);
	}

	// unnamed block (timer)
	void BoarBase_Timer()
	{
		CallEventDelayed(RandomInt(10, 25), "BoarBase_Timer");

		if (IS_HUNTING)
			return;
		if (IS_FLEEING)
			return;

		PlayRandomSound(Int(Eval("game.sound.voice")), Eval("game.sound.maxvol"), SOUND_IDLE1, SOUND_IDLE2);
	}

	// unnamed block (timer)
	void BoarBase_Timer2()
	{
		CallEventDelayed(RandomInt(8, 12), "BoarBase_Timer2");

		if (IS_HUNTING)
			return;
		if (IS_FLEEING)
			return;

		PlayAnim("once", ANIM_IDLE_EATGRASS);
	}

	// game_damaged_other
	string BoarBase_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		if (PUSH_VEL == "PUSH_VEL")
			return result;

		if (BOAR_IS_CHARGING)
		{
			OnBoarChargeHit();
		}
		else
		{
			AddVelocity(ENT_LASTSTRUCKBYME, Vec(PUSH_VEL)); // Push the player a bit
		}
		return result;
	}

	// npc_struck
	// Hit by someone
	void BoarBase_OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(Int(Eval("game.sound.body")), 5, SOUND_PAIN, SOUND_STRUCK2, SOUND_PAIN);
	}

	// npc_attack
	// Switch up my attack
	void BoarBase_OnNpcAttack()
	{
		int nextAttack = RandomInt(0, 2);
		if (nextAttack == 0)
			ANIM_ATTACK = ANIM_FORWARD;
		else if (nextAttack == 1)
			ANIM_ATTACK = ANIM_LEFT;
		else if (nextAttack == 2)
			ANIM_ATTACK = ANIM_RIGHT;
	}

	// npc_targetsighted
	// Charge !
	// --------
	void BoarBase_OnNpcTargetsighted(string target = "")
	{
		if (!BOAR_CAN_CHARGE)
			return;
		if (BOAR_IS_CHARGING)
			return;
		if (!(DistanceTo(HUNT_LASTTARGET) > 256.0f))
			return;

		// if HUNT_LASTTARGET isnot BOAR_CHARGE_TARGET
		BOAR_CHARGE_TARGET = HUNT_LASTTARGET;
		OnBoarCharge();
	}

	// boar_charge
	void BoarBase_OnBoarCharge()
	{
		PlaySound(Int(Eval("game.sound.voice")), Eval("game.sound.maxvol"), SOUND_CHARGE);
		AS_ATTACKING = GameTime();
		PlayAnim("once", ANIM_STOMP);
		SetMoveSpeed(3);
		ANIM_RUN = ANIM_CHARGE;
		BOAR_IS_CHARGING = true;
		CAN_ATTACK = "0";
		CAN_HEAR = "0";
		CAN_RETALIATE = "0";
		BOAR_CAN_FLEE = CAN_FLEE;
		CAN_FLEE = "0";
		CallEventDelayed(1.0f, "boar_charge2");
		CallEventDelayed(15.0f, "boar_charge_stop");

		ClientEvent("new", "all_in_sight", CL_SCRIPT, IndexOf(ENT_ME)); // Start Dust effect
		CL_SCRIPT_ID = LastClientScriptId();
	}

	// boar_charge2
	void BoarBase_OnBoarCharge2()
	{
		PlaySound(Int(Eval("game.sound.voice")), Eval("game.sound.maxvol"), SOUND_CHARGE);
	}

	// boar_charge_stop
	void BoarBase_OnBoarChargeStop()
	{
		if (!BOAR_IS_CHARGING)
			return;

		SetMoveSpeed(1);
		ANIM_RUN = ANIM_BOAR_RUN;
		BOAR_CHARGE_TARGET = "\x81PNONE\x81P";
		BOAR_IS_CHARGING = false;
		CAN_ATTACK = "1";
		CAN_HEAR = "1";
		CAN_RETALIATE = "1";
		CAN_FLEE = BOAR_CAN_FLEE;
		ClientEvent("remove", "all", CL_SCRIPT); // Remove Dust effect
	}

	// unnamed block (timer)
	void BoarBase_Timer3()
	{
		CallEventDelayed(0.1f, "BoarBase_Timer3");

		if (!BOAR_IS_CHARGING)
			return;
		if (IS_FLEEING)
			return;

		float chargeRange = Float(MOVE_RANGE);
		chargeRange *= 1.8f;
		if (!(DistanceTo(BOAR_CHARGE_TARGET) <= chargeRange))
			return;

		DoDamage(BOAR_CHARGE_TARGET, ATTACK_HITRANGE, GetVar("BOAR_CHARGE_DMG"), "100%");
		OnBoarChargeStop();
	}

	// boar_charge_hit
	void BoarBase_OnBoarChargeHit()
	{
		// this prevents making boar anti-stun possible
		// applyeffect ent_laststruckbyme effects/effect_push 3 $relvel(0,200,200) 0
		AddVelocity(ENT_LASTSTRUCKBYME, RelativeVelocity(Vector3(0, 200, 200)));
		ApplyEffect(ENT_LASTSTRUCKBYME, "effects/debuff_stun", 3, self);
	}

	// npc_wander
	void BoarBase_OnNpcWander()
	{
		if (!BOAR_IS_CHARGING)
			return;
		OnBoarChargeStop();
	}

	// gore_forward
	void BoarBase_OnGoreForward()
	{
		// messageall green gore - anim
		if (!Truthy(GetVar("IS_HARD")))
			return;
		float targRange = RangeTo(HUNT_LASTTARGET);
		int maxPushRange = 96; // constant
		if (!(targRange < maxPushRange))
			return;
		float rangePercent = Divide(targRange, maxPushRange);
		string rangePercentText = Text(rangePercent);
		float pushStr = Float(LegacyFunction("get_skill_ratio", rangePercentText, 400, 110));
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			PlayerMessageGreen(HUNT_LASTTARGET, "gore - PUSH str " + Text(pushStr) + " per " + rangePercentText + " rng " + Text(targRange));
		AddVelocity(HUNT_LASTTARGET, RelativeVelocity(Vector3(0, pushStr, 110)));
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BoarBase_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BoarBase_OnNpcSpawn(npc);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		BoarBase_OnNpcTargetsighted(target);
	}

	void OnNpcStruck(float damage = 0.0f) { BoarBase_OnNpcStruck(damage); } // npc_struck
	void OnNpcAttack() { BoarBase_OnNpcAttack(); } // npc_attack
	void OnBoarCharge() { BoarBase_OnBoarCharge(); } // boar_charge
	void OnBoarCharge2() { BoarBase_OnBoarCharge2(); } // boar_charge2
	void OnBoarChargeStop() { BoarBase_OnBoarChargeStop(); } // boar_charge_stop
	void OnBoarChargeHit() { BoarBase_OnBoarChargeHit(); } // boar_charge_hit
	void OnNpcWander() { BoarBase_OnNpcWander(); } // npc_wander
	void OnGoreForward() { BoarBase_OnGoreForward(); } // gore_forward

	// This file's events and timers by their .script names
	bool BoarBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "boar_charge") { OnBoarCharge(); return true; }
		if (name == "boar_charge2") { OnBoarCharge2(); return true; }
		if (name == "boar_charge_hit") { OnBoarChargeHit(); return true; }
		if (name == "boar_charge_stop") { OnBoarChargeStop(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "gore_forward") { OnGoreForward(); return true; }
		if (name == "npc_attack") { OnNpcAttack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npc_wander") { OnNpcWander(); return true; }
		if (name == "BoarBase_Timer") { BoarBase_Timer(); return true; }
		if (name == "BoarBase_Timer2") { BoarBase_Timer2(); return true; }
		if (name == "BoarBase_Timer3") { BoarBase_Timer3(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/boar_base"]
shared class BoarBaseScript : BaseMonsterScript, BoarBase
{
	// Variables every script that includes this file declares
	bool BOAR_CAN_CHARGE = false;
	string FLEE_CHANCE = "FLEE_CHANCE";
	int FLEE_HEALTH = 0;
	float GORE_FORWARD_DAMAGE = 0.0f;
	string GORE_SIDE_DAMAGE = "GORE_SIDE_DAMAGE";
	string PUSH_VEL = "PUSH_VEL";

	// Variables declared by included files, with the value they start with in this script
	BoarBaseScript()
	{
		SOUND_DEATH = "monsters/boar/boardeath.wav";
		ANIM_IDLE = "idle1";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/boar.mdl");
		CallEventDelayed(Float(Eval("$rand(10,25)")), "BoarBase_Timer");
		CallEventDelayed(Float(Eval("$rand(8,12)")), "BoarBase_Timer2");
		CallEventDelayed(0.1f, "BoarBase_Timer3");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BoarBase_FirstThink();
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
		return BoarBase_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
