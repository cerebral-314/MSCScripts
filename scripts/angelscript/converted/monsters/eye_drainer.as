#pragma context server

// Converted from monsters/eye_drainer.script by msc_transpiler.
// Orbits players (can't quite figure this bit), drains Mana, insta-kills players with no mana remaining
// Consider deleting (fade away) on sucsseful kill

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_flyer.as"
#include "converted/monsters/base_propelled.as"
#include "converted/monsters/base_monster.as"

[script "monsters/eye_drainer"]
class EyeDrainer : BaseMonsterScript, BaseFlyer, BasePropelled
{
	// Constants
	bool NPC_NO_END_FLY = true;
	string ANIM_SPIN = "spin_horizontal_slow";
	string SOUND_BEAM_LOOP = "x/x_teleattack1.wav";
	string SOUND_STRUCK = "weapons/cbar_hitbod1.wav";
	string SOUND_PAIN1 = "houndeye/he_pain2.wav";
	string SOUND_PAIN2 = "houndeye/he_pain5.wav";
	string SOUND_KILL = "houndeye/he_blast3.wav";
	string SOUND_HOVER_LOOP = "ambience/labdrone2.wav";

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	float NPC_HACKED_MOVE_SPEED = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool AM_SUMMONED = false;
	string MY_OWNER = "MY_OWNER";
	bool ANG_HOVER = false;
	bool IDLE_MODE = false;
	string BEAM_ID = "BEAM_ID";
	float NEXT_RENDER_CHECK = 0.0f;
	float LASTATK_MESSAGE = 0.0f;
	bool BEAM_ACTIVE = false;
	string EYE_STUCK_POS = "EYE_STUCK_POS";
	bool DOING_DODGE = false;
	bool DOING_FS_DODGE = false;

	// Variables declared by included files, with the value they start with in this script
	EyeDrainer()
	{
		ANIM_WALK = "idle_standard";
		ANIM_IDLE = "spin_horizontal_slow";
		SOUND_DEATH = "turret/tu_die2.wav";
	}

	// unnamed block (first think)
	void EyeDrainer_FirstThink()
	{
		NPC_GIVE_EXP = 200.0f;
		NPC_HACKED_MOVE_SPEED = 100.0f; // base_propelled

		// base params
		MOVE_RANGE = "128";
		ATTACK_RANGE = 128.0f;
		ATTACK_HITRANGE = 128.0f;
		ANIM_ATTACK = "idle_standard";

		// has no real animations
		ANIM_WALK = "idle_standard";
		ANIM_RUN = "idle_standard";
		ANIM_IDLE = "spin_horizontal_slow";
		ANIM_DEATH = "spin_horizontal_fast";

		IS_UNHOLY = true;
	}

	// unnamed block (timer)
	void EyeDrainer_Timer()
	{
		CallEventDelayed(10.0f, "EyeDrainer_Timer");
		if (!IsAlive(ENT_ME))
			return;
		ServerPlaySound(4, 0, SOUND_HOVER_LOOP);
		CallEventDelayed(0.1f, "hover_loop");

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);

		// summons suicide if stuck in same place > 10 secs
		if (!AM_SUMMONED)
			return;
		if (BEAM_ACTIVE) // no suicide if can hit a target
			return;
		if (EYE_STUCK_POS == Text(MyOrigin()))
			OnNpcSuicide();
		EYE_STUCK_POS = Eval("game.monstemr.origin");
	}

	// unnamed block (timer)
	void EyeDrainer_Timer2()
	{
		CallEventDelayed(1.0f, "EyeDrainer_Timer2");

		// avoid floor/ceiling
		if (!IsAlive(ENT_ME))
			return;

		// floor
		Vector3 myPos = MyOrigin();
		float groundZ = GroundHeight(myPos);
		string groundLoc = Text(myPos);
		groundLoc = Text(WithZ(Vec(groundLoc), groundZ));
		if (Distance(myPos, Vec(groundLoc)) < 16.0f && !DOING_FS_DODGE)
		{
			DOING_FS_DODGE = true;
			AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, -110)));
			CallEventDelayed(1.0f, "reset_fs_dodge");
		}

		// ceiling
		string upPos = Text(myPos);
		upPos = Text(Vec(upPos) + Vector3(0.0f, 0.0f, 64.0f));
		upPos = LegacyFunction("get_traceline", myPos, upPos, "worldonly");
		if (Distance(myPos, Vec(upPos)) < 16.0f && !DOING_FS_DODGE)
		{
			DOING_FS_DODGE = true;
			AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 110)));
			CallEventDelayed(1.0f, "reset_fs_dodge");
		}
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		BasePropelled_OnNpcPostSpawn(); // monsters/base_propelled
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
		SetProp(ENT_ME, "renderfx", 16);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		OnBeamOff();
		Effect("beam", "update", BEAM_ID, "remove", 0.1f);
		ServerPlaySound(4, 0, SOUND_HOVER_LOOP);
		ServerPlaySound(1, 0, SOUND_BEAM_LOOP);
		CallExternal(GetVar("GAME_MASTER"), "gm_fade", self, 5);
		if (!AM_SUMMONED)
			return;
		if (!IsAlive(MY_OWNER))
			return;
		CallExternal(MY_OWNER, "eye_died");
	}

	// game_dynamically_created
	// <owner>
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck

		AM_SUMMONED = true;
		MY_OWNER = creatorValue1;
		CallEventDelayed(60.0f, "npc_suicide"); // remove self in 60 seconds, case stuck
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttack_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		if (!DOING_DODGE)
			OnDoDodge();
		PlaySound(1, 5, SOUND_STRUCK, SOUND_PAIN1, SOUND_PAIN2);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttack_OnMyTargetDied(offender); // monsters/base_npc_attack
		OnBeamOff();
	}

	// npcatk_clear_targets
	void OnNpcatkClearTargets(string reason = "")
	{
		BaseNpcAttack_OnNpcatkClearTargets(reason); // monsters/base_npc_attack
		BaseMonsterShared_OnNpcatkClearTargets(reason); // monsters/base_monster_shared
		BaseMonsterShared_OnNpcatkClearTargets_2(reason); // monsters/base_monster_shared
		IDLE_MODE = true;
		SetMoveAnim(ANIM_SPIN);
		SetIdleAnim(ANIM_SPIN);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetHealth(450);
		SetWidth(16);
		SetHeight(16);
		SetName("Eye of Death");
		SetHearingSensitivity(10);
		SetRoam(true);
		SetRace("demon");
		SetModel("monsters/eye_medium_float.mdl");
		SetIdleAnim(ANIM_SPIN);
		SetMoveAnim(ANIM_WALK);
		SetMonsterClip(false);
		SetGravity(0);
		SetFly(true);
		ServerPlaySound(4, 10, SOUND_HOVER_LOOP);

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
		SetProp(ENT_ME, "renderfx", 16);

		SetDamageTaken("holy", 2);
		SetDamageTaken("pierce", 4);

		ANG_HOVER = false;

		IDLE_MODE = true;

		CallEventDelayed(3.0f, "solidify_me");
		CallEventDelayed(0.1f, "init_beam");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck

		if (GameTime() > NEXT_RENDER_CHECK)
		{
			NEXT_RENDER_CHECK = GameTime() + 5.0f;
			SetProp(ENT_ME, "rendermode", 5);
			SetProp(ENT_ME, "renderamt", 255);
		}

		if (NPCATK_TARGET == "unset" && BEAM_ACTIVE)
			OnBeamOff();

		if (!IsAlive(NPCATK_TARGET))
			return;

		float targetRange = RangeTo(NPCATK_TARGET);
		if (BEAM_ACTIVE)
		{
			if (targetRange > ATTACK_RANGE)
			{
				OnBeamOff();
			}
			else
			{
				bool seeTarget = CanSee(NPCATK_TARGET);
				if (seeTarget)
				{
					GiveMana(NPCATK_TARGET, -0.5f);
					if (GameTime() > LASTATK_MESSAGE)
					{
						LASTATK_MESSAGE = GameTime() + 2.0f;
						PlayerMessage(NPCATK_TARGET, "Your soul is being drained!");
						Effect("screenfade", NPCATK_TARGET, 2, 1, Vector3(0, 0, 255), 180, "fadein");
					}
					if (ManaOf(NPCATK_TARGET) <= 0.0f)
						OnSlayTarget();
				}
				if (!seeTarget)
					OnBeamOff();
			}
		}

		if (BEAM_ACTIVE)
			return;

		if (!(targetRange < ATTACK_RANGE))
			return;

		OnBeamOn();
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (IDLE_MODE)
		{
			SetMoveAnim(ANIM_WALK);
			SetIdleAnim(ANIM_WALK);
			IDLE_MODE = false;
		}
	}

	// solidify_me
	void OnSolidifyMe()
	{
		SetProp(ENT_ME, "renderfx", 0);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
	}

	// init_beam
	void OnInitBeam()
	{
		Effect("beam", "ents", "laserbeam.spr", 30, ENT_ME, 0, ENT_ME, 0, Vector3(64, 64, 255), 0, 30, -1);
		BEAM_ID = EntityId(EntityOf(ENT_LASTCREATED));
	}

	// beam_on
	void OnBeamOn()
	{
		BEAM_ACTIVE = true;
		Effect("beam", "update", BEAM_ID, "end_target", NPCATK_TARGET, 0);
		Effect("beam", "update", BEAM_ID, "brightness", 200);
		ServerPlaySound(1, 10, SOUND_BEAM_LOOP);
	}

	// beam_off
	void OnBeamOff()
	{
		ServerPlaySound(1, 0, SOUND_BEAM_LOOP);
		Effect("beam", "update", BEAM_ID, "end_target", self, 0);
		Effect("beam", "update", BEAM_ID, "brightness", 0);
		BEAM_ACTIVE = false;
	}

	// slay_target
	void OnSlayTarget()
	{
		PlayerMessage(NPCATK_TARGET, "Your soul has been drained.");
		// figure slay target function here (maybe new code-side function)
		DoDamage(NPCATK_TARGET, "direct", 99999, "100%", ENT_ME, "target");
		PlaySound(2, 10, SOUND_KILL);
	}

	// hover_loop
	void OnHoverLoop()
	{
		ServerPlaySound(4, 10, SOUND_HOVER_LOOP);
	}

	// do_dodge
	void OnDoDodge()
	{
		if (DOING_FS_DODGE)
			return;
		if (!IsAlive(ENT_ME))
			return;
		DOING_DODGE = true;
		float rndFb = Random(0, -120);
		float rndRl = Random(-120, 120);
		float rndUd = Random(-120, 120);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(rndRl, rndFb, rndUd)));
		CallEventDelayed(1.0f, "reset_dodge");
	}

	// reset_dodge
	void OnResetDodge()
	{
		DOING_DODGE = false;
		SetVelocity(ENT_ME, Vector3(0, 0, 0));
	}

	// reset_fs_dodge
	void OnResetFsDodge()
	{
		DOING_FS_DODGE = false;
		SetVelocity(ENT_ME, Vector3(0, 0, 0));
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

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

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttack_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/eye_medium_float.mdl");
		Precache("ambience/labdrone2.wav");
		Precache("x/x_teleattack1.wav");
		CallEventDelayed(10.0f, "EyeDrainer_Timer");
		CallEventDelayed(1.0f, "EyeDrainer_Timer2");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		EyeDrainer_FirstThink();
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
		if (name == "beam_off") { OnBeamOff(); return true; }
		if (name == "beam_on") { OnBeamOn(); return true; }
		if (name == "do_dodge") { OnDoDodge(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "hover_loop") { OnHoverLoop(); return true; }
		if (name == "init_beam") { OnInitBeam(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_clear_targets") { OnNpcatkClearTargets(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "reset_dodge") { OnResetDodge(); return true; }
		if (name == "reset_fs_dodge") { OnResetFsDodge(); return true; }
		if (name == "slay_target") { OnSlayTarget(); return true; }
		if (name == "solidify_me") { OnSolidifyMe(); return true; }
		if (name == "EyeDrainer_Timer") { EyeDrainer_Timer(); return true; }
		if (name == "EyeDrainer_Timer2") { EyeDrainer_Timer2(); return true; }
		return BaseFlyer_DispatchEvent(name, params)
			|| BasePropelled_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
