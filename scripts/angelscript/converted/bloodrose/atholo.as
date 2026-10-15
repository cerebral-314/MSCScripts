#pragma context server

// Converted from bloodrose/atholo.script by msc_transpiler.
// Altholo rebuilt from scratch, by Thothie

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

[script "bloodrose/atholo"]
class BloodroseAtholo : BaseMonsterScript
{
	// Variables (an unset .script variable reads as its own name)
	int REGEN_AMT = 60;
	float REGEN_RATE = 5.0f;
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_PAIN = "controller/con_pain2.wav";
	string SOUND_ATTACK1 = "zombie/claw_miss1.wav";
	string SOUND_ATTACK2 = "zombie/claw_miss2.wav";
	string SOUND_PISSED = "garg/gar_die1.wav";
	string SOUND_TAUNT = "nihilanth/nil_die.wav";
	string SOUND_IDLE = "garg/gar_idle2.wav";
	string ATTACK_HITCHANCE = "90%";
	int DAMAGE_ATTACK1 = 0;
	int DAMAGE_ATTACK2 = 0;
	string FIRE_DAMAGE = "FIRE_DAMAGE";
	float FIRE_DURATION = 5.0f;
	int FREEZE_DAMAGE = 0;
	float FREEZE_DURATION = 5.0f;
	string ANIM_SLASH = "attack1";
	string ANIM_SMASH = "attack2";
	string ANIM_CAST = "castspell";
	float BURST_FREQ = 15.0f;
	string MONSTER_MODEL = "monsters/skeleton_boss2.mdl";
	bool I_AM_TURNABLE = false;
	float ATTACK_MOVERANGE = 0.0f;
	float MISS_ATTACK = 0.0f;
	string VENGENCE_TARGET = "VENGENCE_TARGET";
	string ANIM_ATTACK = "ANIM_ATTACK";
	float SWIPES_COUNT = 0.0f;
	int FIRE_ATTACK = 0;
	bool FIREBALL_DELAY = false;
	CBaseEntity@ FIREBALL_TARGET = null;
	bool ROAM_ON = false;
	string CHOSEN_ONE = "CHOSEN_ONE";
	bool I_R_GLOWING = false;
	string MY_LIGHT_SCRIPT = "MY_LIGHT_SCRIPT";

	// Variables declared by included files, with the value they start with in this script
	BloodroseAtholo()
	{
		NPC_BOSS_REGEN_RATE = 0.0f;
		NPC_BOSS_RESTORATION = 0.0f;
		SOUND_DEATH = "garg/gar_die2.wav";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		NO_STEP_ADJ = true;
	}

	// unnamed block (first think)
	void BloodroseAtholo_FirstThink()
	{
		if (ToLowerCase(MapName()) == "bloodrose")
		{
			NPC_GIVE_EXP = 5000.0f;
			NPC_IS_BOSS = true;
		}
		else
		{
			NPC_GIVE_EXP = 1500.0f;
		}

		REGEN_AMT = 60;
		REGEN_RATE = 5.0f;

		NPC_ALLY_RESPONSE_RANGE = 6000.0f;

		SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
		SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
		SOUND_PAIN = "controller/con_pain2.wav";
		SOUND_ATTACK1 = "zombie/claw_miss1.wav";
		SOUND_ATTACK2 = "zombie/claw_miss2.wav";
		SOUND_PISSED = "garg/gar_die1.wav"; // added for invul script
		SOUND_TAUNT = "nihilanth/nil_die.wav";
		SOUND_IDLE = "garg/gar_idle2.wav"; // was atholo/idle.wav

		ATTACK_HITRANGE = 240.0f;
		ATTACK_RANGE = 180.0f;
		MOVE_RANGE = "50";
		ATTACK_MOVERANGE = 64.0f;
		ATTACK_HITCHANCE = "90%";

		DAMAGE_ATTACK1 = RandomInt(50, 90);
		DAMAGE_ATTACK2 = RandomInt(100, 200);

		FIRE_DAMAGE = RandomInt(50, 100);
		FIRE_DURATION = 5.0f;
		FREEZE_DAMAGE = RandomInt(25, 50);
		FREEZE_DURATION = 5.0f;

		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";

		ANIM_SLASH = "attack1";
		ANIM_SMASH = "attack2";
		ANIM_CAST = "castspell";
		ANIM_DEATH = "dieforward";

		NO_STEP_ADJ = true;

		BURST_FREQ = 15.0f;

		MONSTER_MODEL = "monsters/skeleton_boss2.mdl";

		I_AM_TURNABLE = false;

		MISS_ATTACK = 0.0f;

		NPC_MUST_SEE_TARGET = "0";
	}

	// unnamed block (timer)
	void BloodroseAtholo_Timer()
	{
		CallEventDelayed(REGEN_RATE, "BloodroseAtholo_Timer");

		if (!(MyHealth() < MyMaxHealth()))
			return;
		int hpGive = REGEN_AMT;
		float giveTest = MyMaxHealth() - REGEN_AMT;
		if (!(MyHealth() < giveTest))
			return;
		GiveHealth(REGEN_AMT);
		PlaySound(0, 10, "player/heartbeat_noloop.wav");
		Effect("glow", ENT_ME, Vector3(0, 255, 0), 96, 1, 1);
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("kfortress/nh_appear_cl");
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared

		ClientEvent("remove", "all", MY_LIGHT_SCRIPT);

		string origin = "(63,1776,-3519)";

		int count = PlayerCount();
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnGetChosenOne();
			if (breakLoop)
			{
				breakLoop = false;
				break;
			}
		}

		if (CHOSEN_ONE != "CHOSEN_ONE")
		{
			ClientEvent("new", "all", "kfortress/nh_appear_cl", origin, 0);
			CreateItem("item_ring_ryza", Vec(origin));
			CallExternal(ENT_LASTCREATED, "bitem_reserve", CHOSEN_ONE);
		}
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		SetAngle("face", Vector3(0, Float(creatorValue1), 0));
		VENGENCE_TARGET = creatorValue2;
		CallEventDelayed(0.1f, "set_vengence");
	}

	// game_struck
	// Hit by someone
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttack_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared

		PlayRandomSound(0, 5, SOUND_STRUCK1, SOUND_STRUCK2);

		// last second fireball addition
		if (!(RangeTo(ENT_LASTSTRUCK) > 200.0f))
			return;
		if (FIREBALL_DELAY)
			return;
		FIREBALL_DELAY = true;
		SetAngle("face_origin", OriginOf(ENT_LASTSTRUCK));
		@FIREBALL_TARGET = EntityOf(ENT_LASTSTRUCK);
		CallEventDelayed(0.1f, "throw_fireball");
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttack_OnMyTargetDied(offender); // monsters/base_npc_attack

		PlaySound(0, 10, SOUND_TAUNT);
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttack_OnCycleUp(reason); // monsters/base_npc_attack

		OnLightOn();

		if (ROAM_ON)
			return;
		ROAM_ON = true;
		CallEventDelayed(BURST_FREQ, "flame_burst_check");
		SetRoam(true);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetUniqueName("boss_atholo");

		SetName("|Atholo");
		SetInvincible(true);
		SetHealth(7000);

		SetDamageTaken("all", 0.5f);
		SetDamageTaken("holy", 1.5f);
		SetDamageTaken("dark", 0.75f);
		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 0.2f);
		SetDamageTaken("lightning", 0.5f);

		SetWidth(40);
		SetHeight(128);
		SetRace("undead");
		SetRoam(false);
		SetHearingSensitivity(6);
		SetModel(MONSTER_MODEL);
		SetModelBody(0, 9);
		SetModelBody(1, 6);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		ANIM_ATTACK = "attack1";

		// setsolid box
		// setbbox npcsize
		SetMoveSpeed(1);

		SetStepSize(64);
		LegacyCommand("maxslope", 90);

		PlaySound(0, 10, SOUND_TAUNT);

		SWIPES_COUNT = 0.0f;

		CallEventDelayed(2.0f, "rt_adj_stepsize");

		CallEventDelayed(30.0f, "return_home");
	}

	// set_vengence
	void OnSetVengence()
	{
		if (RangeTo(VENGENCE_TARGET) < 2048.0f)
			OnNpcatkSettarget(VENGENCE_TARGET);
	}

	// rt_adj_stepsize
	void OnRtAdjStepsize()
	{
		CallEventDelayed(2.0f, "rt_adj_stepsize");
		if (!IsPlayer(HUNT_LASTTARGET))
			return;
		Vector3 myOrg = MyOrigin();
		float myZ = myOrg.z;
		Vector3 targOrg = OriginOf(HUNT_LASTTARGET);
		float targZ = targOrg.z + 0.0f;
		float diff = 0.0f;
		if (targZ > myZ)
			diff = targZ - myZ;
		if (targZ < myZ)
			diff = myZ - targZ;
		if (diff > 64.0f)
		{
			// dbg temp stepsize 200
			SetStepSize(300);
		}
		if (diff <= 64.0f)
		{
			// dbg temp stepsize 64
			SetStepSize(64);
		}
	}

	// attack_1
	void OnAttack12()
	{
		MISS_ATTACK += 1.0f;

		if (MISS_ATTACK > 5.0f)
		{
			MISS_ATTACK = 0.0f;
			OnChickenRun(3.0f);
		}

		// callevent npcatk_dodamage NPCATK_TARGET ATTACK_HITRANGE DAMAGE_ATTACK1 ATTACK_HITCHANCE
		if (RangeTo(HUNT_LASTTARGET) < ATTACK_HITRANGE)
			DoDamageEx(HUNT_LASTTARGET, "direct", DAMAGE_ATTACK1, ATTACK_HITCHANCE, self, self, "none", "slash", "dmgevent:swing");

		FIRE_ATTACK = 1;

		SWIPES_COUNT += 1.0f;
		if (!(SWIPES_COUNT > 20.0f))
			return;
		SWIPES_COUNT = 0.0f;
		ANIM_ATTACK = ANIM_SMASH;
	}

	// attack_2
	void OnAttack22()
	{
		MISS_ATTACK += 1.0f;

		if (MISS_ATTACK > 5.0f)
		{
			MISS_ATTACK = 0.0f;
			OnChickenRun(3.0f);
		}

		// callevent npcatk_dodamage NPCATK_TARGET ATTACK_HITRANGE DAMAGE_ATTACK2 ATTACK_HITCHANCE
		if (RangeTo(HUNT_LASTTARGET) < ATTACK_HITRANGE)
			DoDamageEx(HUNT_LASTTARGET, "direct", DAMAGE_ATTACK1, ATTACK_HITCHANCE, self, self, "none", "slash", "dmgevent:swing");

		FIRE_ATTACK = 2;
		ANIM_ATTACK = ANIM_SLASH;
	}

	// throw_fireball
	void OnThrowFireball()
	{
		// straighten out so you dont get goodie leaning look
		Vector3 myAng = MyAngles();
		float myYaw = myAng.y;
		SetAngle("face", Vector3(0, myYaw, 0));

		PlayAnim("critical", "attack3");

		PlaySound(0, 10, "magic/fireball_strike.wav");

		float dist = RangeTo(FIREBALL_TARGET);

		OnNpcatkSuspendAi("0.3");

		OnActToss();
		if (dist > 300.0f)
			CallEventDelayed(0.1f, "act_toss");
		if (dist > 400.0f)
			CallEventDelayed(0.2f, "act_toss");

		CallEventDelayed(5.0f, "reset_fireball_delay");
	}

	// act_toss
	void OnActToss()
	{
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none>
		TossProjectile("proj_fire_ball", RelativePosition(Vector3(0, 48, 32)), @FIREBALL_TARGET, 400, 400, 10, "none"); // Converted to use new tossprojectile //greatguys1@FEB2022 untested
		CallExternal(EntityOf(ENT_LASTPROJECTILE), "ext_lighten", 0);
		SetProp(ENT_LASTPROJECTILE, "rendermode", 5);
		SetProp(ENT_LASTPROJECTILE, "renderamt", 255);
	}

	// reset_fireball_delay
	void OnResetFireballDelay()
	{
		FIREBALL_DELAY = false;
	}

	// taunt
	void OnTaunt()
	{
		CallEventDelayed(RandomInt(15, 60), "taunt");

		if (!Truthy(Eval("game.monster.isalive")))
			return;

		PlaySound(2, 10, SOUND_TAUNT);
	}

	// vulnerable
	// attempt to make vulnerable via msnpc_script
	void OnVulnerable()
	{
		SetInvincible(false);
		PlaySound(0, 10, SOUND_PISSED);
		SetSayTextRange(1024);
		// setanim.movespeed 2.0
		// setanim.framerate 1.5
		CAN_FLINCH = "1";
		SayText("Fools! I shall destroy you all!");
	}

	// npc_death
	void OnNpcDeath()
	{
		UseTrigger("atholo_died");

		CBaseEntity@ ryzaName = FindByName("ryza");
		CBaseEntity@ ryzaId = ryzaName;
		CallExternal(ryzaId, "atholo_done");
	}

	// swing_dodamage
	// 1:AttackHit(1/0)  2:EntityHit  3:StartOrigin  4:EndOrigin
	void OnSwingDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		MISS_ATTACK = 0.0f;

		if (!hit)
			return;
		if (FIRE_ATTACK == 1)
			ApplyEffect(target, "effects/dot_fire", FIRE_DURATION, self, FIRE_DAMAGE);

		if (FIRE_ATTACK == 2)
			ApplyEffect(target, "effects/dot_cold_freeze", FREEZE_DURATION, self, FREEZE_DAMAGE);
		FIRE_ATTACK = 0;
	}

	// get_chosen_one
	void OnGetChosenOne()
	{
		if (loopIteration == 0)
			CallExternal(GetVar("GAME_MASTER"), "gm_find_strongest_reset");
		else
			CallExternal(GetVar("GAME_MASTER"), "gm_find_strongest_player");

		string strongest = ScriptVarOf(GetVar("GAME_MASTER"), "THE_CHOSEN_ONE");
		string quest = GetQuestData(strongest, "manaring");
		int item = Int(ItemExists(strongest, "item_ring_ryza"));

		if (quest != "0")
			return;
		if (item != 0)
			return;

		CHOSEN_ONE = strongest;
		breakLoop = true;
	}

	// light_on
	void OnLightOn()
	{
		if (I_R_GLOWING)
			return;
		I_R_GLOWING = true;
		ClientEvent("persist", "all", "bloodrose/atholo", IndexOf(ENT_ME));
		MY_LIGHT_SCRIPT = LastClientScriptId();
	}

	// flame_burst_check
	// =============================== End Glow System
	void OnFlameBurstCheck()
	{
		CallEventDelayed(BURST_FREQ, "flame_burst_check");

		if (!Truthy(LegacyFunction("cansee", "enemy", 128)))
			return;
		PlayAnim("break");
		OnNpcatkSuspendAi("1.0");
		CallEventDelayed(0.1f, "flame_burst");
	}

	// flame_burst
	void OnFlameBurst()
	{
		PlayAnim("critical", ANIM_CAST);
		CreateNpc("monsters/summon/flame_burst", RelativePosition(Vector3(0, 0, 0)), self, "FLAME_BURST_DAMAGE");
		DoDamage(Text(RelativePosition(Vector3(0, 0, 0))), 512, 0.0f, "100%", 0.0f, "reflective", "target");
		CallEventDelayed(0.2f, "stop_throwing");
	}

	// return_home
	void OnReturnHome()
	{
		CallEventDelayed(15.0f, "return_home");
		if (HUNT_LASTTARGET != "\xAFNONE\xAF")
			return;
		// dbg no target, going home NPC_SPAWN_LOC
		SetMoveDest(NPC_SPAWN_LOC, MOVE_RANGE);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnBurstFreq() {} // BURST_FREQ

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(REGEN_RATE, "BloodroseAtholo_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
		CallEventDelayed(Float(Eval("$rand(15,60)")), "taunt");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BloodroseAtholo_FirstThink();
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
		if (name == "act_toss") { OnActToss(); return true; }
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "flame_burst") { OnFlameBurst(); return true; }
		if (name == "flame_burst_check") { OnFlameBurstCheck(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "get_chosen_one") { OnGetChosenOne(); return true; }
		if (name == "light_on") { OnLightOn(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "reset_fireball_delay") { OnResetFireballDelay(); return true; }
		if (name == "return_home") { OnReturnHome(); return true; }
		if (name == "rt_adj_stepsize") { OnRtAdjStepsize(); return true; }
		if (name == "set_vengence") { OnSetVengence(); return true; }
		if (name == "swing_dodamage") { OnSwingDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "taunt") { OnTaunt(); return true; }
		if (name == "throw_fireball") { OnThrowFireball(); return true; }
		if (name == "vulnerable") { OnVulnerable(); return true; }
		if (name == "BloodroseAtholo_Timer") { BloodroseAtholo_Timer(); return true; }
		return BaseMonsterScript::DispatchEvent(name, params);
	}
}
