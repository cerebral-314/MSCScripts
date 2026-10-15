#pragma context server

// Converted from monsters/bat_base.script by msc_transpiler.
// Base Bat

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_flyer.as"
#include "converted/monsters/base_monster.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BatBase
{
	// Constants
	bool BAT_FLYING = false;
	bool BAT_HANGING = true;
	int BAT_DROPPING = 2;
	string ANIM_DEAD = "deadground";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "IdleFlyNormal";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_DEATH_NEW = "ANIM_DEATH_NEW";
	string HUNT_AGRO = "HUNT_AGRO";
	string RETALIATE_CHANCE = "RETALIATE_CHANCE";
	string CAN_HEAR = "CAN_HEAR";
	int BAT_STATUS = 0;
	string CAN_HUNT = "CAN_HUNT";
	float FLIGHT_STUCK = 0.0f;
	float AS_ATTACKING = 0.0f;
	float LAST_PROG = 0.0f;
	Vector3 LAST_POS = Vector3();

	// unnamed block (first think)
	void BatBase_FirstThink()
	{
		ANIM_DEATH = "die";
		ANIM_DEATH_NEW = "die";
		ANIM_IDLE = "IdleFlyNormal";

		HUNT_AGRO = "1"; // base_npc_attack - Premptive attack
		RETALIATE_CHANCE = "75%"; // base_npc_attack - Automatically switch targets to the last damaging player
		CAN_HEAR = "1"; // base_npc_attack - Whether I hear sounds (Non-const because it changes on giantbat)
	}

	// npc_spawn
	void BatBase_OnNpcSpawn(string npc = "")
	{
		SetFly(true);
		SetRace("wildanimal");

		CallEventDelayed(0.1f, "bat_spawn"); // Delay is required for overwriting some setvards. -greatguys1 SEP2021
		OnBatHang();
	}

	// npc_post_spawn
	void BatBase_OnNpcPostSpawn()
	{
		string mapName = ToLowerCase(MapName());
		if (mapName != "sfor")
			return;
		SetMonsterClip(false); // there are some stupid monsterclips on sfor, ignore them
	}

	// bat_hang
	void BatBase_OnBatHang()
	{
		SetIdleAnim(ANIM_IDLE_HANG);
		SetMoveAnim(ANIM_WALK);
		SetRoam(false);
		BAT_STATUS = (BAT_HANGING ? 1 : 0); // Start hanging
		CAN_HUNT = "0";
	}

	// npc_targetsighted
	// See or hear enemy for the first time
	void BatBase_OnNpcTargetsighted(string target = "")
	{
		OnBasebatDropDown();
	}

	// npc_heardenemy
	void BatBase_OnNpcHeardenemy()
	{
		OnBasebatDropDown();
	}

	// basebat_drop_down
	// Drop down from the ceiling
	void BatBase_OnBasebatDropDown()
	{
		CAN_HUNT = "1";

		if (BAT_STATUS != (BAT_HANGING ? 1 : 0))
			return;

		OnBatDropDown();
	}

	// game_death
	void BatBase_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (Truthy(GetVar("BAT_NO_FAKE_DEATH")))
			return;

		SetMoveDest(RelativePosition(Vector3(0, 0, 2048)), 1);
		// laysound 0 5 SOUND_DEATH //causing crash, let base_npc handle this
		// desperately trying to get to fall to ground
		SetSolid("none");
		SetFly(false);
		SetIdleAnim(ANIM_DEAD);
		SetMoveAnim(ANIM_DEAD);
		SetProp(ENT_ME, "movetype", Eval("const.movetype.noclip"));
		PlayAnim("critical", ANIM_DEATH_NEW);
		LegacyCommand("drop_to_floor", self);
		LegacyCommand("drop_to_floor");
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, -10)));

		Vector3 slayerLoc = OriginOf(ENT_LASTSTRUCK);
		float slayerX = slayerLoc.x;

		Vector3 myLoc = OriginOf(ENT_ME);
		float myX = myLoc.x;

		float distanceX = slayerX - myX;

		// local IN_CONE $within_cone2D(MY_SLAYER_LOC,MY_LOC,180,64)
		if (distanceX < 0.0f)
		{
			// find ABS
			float holder = distanceX;
			holder *= 2.0f;
			distanceX -= holder;
		}

		// //dbg DistanceXFinal DISTANCE_X
		if (distanceX < 12.0f)
		{
			// Im likely right above, or otherwise 2D inside the players hitbox
			// if I fall, I will be stuck inside the player's collision box and float
			// despite the fact my setsolid is set none :\
			// so vanish instead
			// (not 100% effective, but helps)
			// //dbg VANISHing
			SetModel("none");
		}
	}

	// unnamed block (timer)
	// custom flyer mods
	void BatBase_Timer()
	{
		CallEventDelayed(0.5f, "BatBase_Timer");
		if (!IS_HUNTING)
			return;
		OnNpcatkFaceattacker();
		if (RangeTo(NPCATK_TARGET) > ATTACK_RANGE)
			SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 100, 0)));
		if (RangeTo(NPCATK_TARGET) < ATTACK_RANGE)
			SetVelocity(ENT_ME, Vector3(0, 0, 0));

		if (FLIGHT_STUCK > 4.0f)
		{
			// callevent chicken_run 1.0
			OnDoRandTweedee(); // do_rand_tweedee
			OnNpcatkSuspendAi(Text(Random(0.3f, 0.9f)));
			SetMoveDest(NEW_DEST, Eval("game.monster.moveprox"));
			CallEventDelayed(0.1f, "horror_boost");
			FLIGHT_STUCK = 0.0f;
		}

		AS_ATTACKING -= 2.0f;

		Vector3 targPos = OriginOf(NPCATK_TARGET);
		if (!SUSPEND_AI)
			SetAngle("face_origin", targPos);

		if (!(AS_ATTACKING <= 0.0f))
			return;
		AS_ATTACKING = 0.0f;
		if (IS_FLEEING)
			return;
		if (!(RangeTo(NPCATK_TARGET) > ATTACK_RANGE))
			return;
		float curProg = Distance(MyOrigin(), targPos);
		if (LAST_PROG >= curProg)
			FLIGHT_STUCK += 1.0f;
		LAST_PROG = Distance(MyOrigin(), targPos);
		LAST_POS = MyOrigin();
	}

	// chicken_run
	void BatBase_OnChickenRun(float duration = 0.0f)
	{
		CallEventDelayed(0.1f, "horror_boost");
	}

	// horror_boost
	void BatBase_OnHorrorBoost()
	{
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 200, 0)));
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseFlyer_OnGameSpawn(playerRace, playerGender); // monsters/base_flyer
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseNpcAttack_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_attack
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseFlyer_OnNpcatkTargetvalidate(target); // monsters/base_flyer
		BaseNpcAttack_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseFlyer_OnNpcSelectattack(); // monsters/base_flyer
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BatBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
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
		BatBase_OnNpcPostSpawn();
	}

	// chicken_run
	void OnChickenRun(float duration = 0.0f)
	{
		BaseNpcAttack_OnChickenRun(duration); // monsters/base_npc_attack
		BatBase_OnChickenRun(duration);
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttack_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BatBase_OnNpcSpawn(npc);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		BatBase_OnNpcTargetsighted(target);
	}

	void OnBatHang() { BatBase_OnBatHang(); } // bat_hang
	void OnNpcHeardenemy() { BatBase_OnNpcHeardenemy(); } // npc_heardenemy
	void OnBasebatDropDown() { BatBase_OnBasebatDropDown(); } // basebat_drop_down
	void OnHorrorBoost() { BatBase_OnHorrorBoost(); } // horror_boost
	void OnBatDropDown() {} // bat_drop_down

	// This file's events and timers by their .script names
	bool BatBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "basebat_drop_down") { OnBasebatDropDown(); return true; }
		if (name == "bat_hang") { OnBatHang(); return true; }
		if (name == "chicken_run") { OnChickenRun(Float(Param(params, 0))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "horror_boost") { OnHorrorBoost(); return true; }
		if (name == "npc_heardenemy") { OnNpcHeardenemy(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "BatBase_Timer") { BatBase_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/bat_base"]
shared class BatBaseScript : BaseMonsterScript, BatBase, BaseFlyer
{
	// Variables every script that includes this file declares
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_IDLE_FLY = "ANIM_IDLE_FLY";
	string ANIM_IDLE_HANG = "ANIM_IDLE_HANG";
	string ATTACK_DAMAGE = "ATTACK_DAMAGE";
	string ATTACK_HITCHANCE = "ATTACK_HITCHANCE";
	string SOUND_STRUCK1 = "SOUND_STRUCK1";
	string SOUND_STRUCK2 = "SOUND_STRUCK2";
	string SOUND_STRUCK3 = "SOUND_STRUCK3";

	// Variables declared by included files, with the value they start with in this script
	BatBaseScript()
	{
		ANIM_IDLE = "IdleFlyNormal";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(0.5f, "BatBase_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BatBase_FirstThink();
		BaseFlyer_FirstThink();
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
		return BatBase_DispatchEvent(name, params)
			|| BaseFlyer_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
