#pragma context server

// Converted from monsters/swampeye.script by msc_transpiler.
// Eye stalk for use in shallow water. Lightning beams.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/swampeye"]
class Swampeye : BaseMonsterNewScript
{
	// Constants
	string ANIM_IDLE_NORM = "idle";
	string ANIM_HIDE = "hide_idle";
	string ANIM_LOOK = "idle2";
	string ANIM_FLINCH1 = "flinch1";
	string ANIM_FLINCH2 = "flinch2";
	string ANIM_ALERT = "scream";
	string ANIM_BEAM = "eyeblast";
	string ANIM_MELEE = "attack";
	string ANIM_RISE = "rise";
	string ANIM_LOWER = "lower";
	int BEAM_RANGE = 1024;
	float DMG_BEAM = 300.0f;
	int DOT_BEAM = 50;
	string MELEE_RANGE = "64";
	int MELEE_HITRANGE = 96;
	int DMG_MELEE = 100;
	float FREQ_MELEE = 4.0f;
	string SOUND_BEAM_FIRE1 = "debris/beamstart14.wav";
	string SOUND_BEAM_FIRE2 = "debris/beamstart15.wav";
	string SOUND_BEAM_FIRE3 = "debris/beamstart9.wav";
	string SOUND_BEAM_CHARGE = "debris/beamstart2.wav";
	string SOUND_ALERT_IDLE1 = "controller/con_alert1.wav";
	string SOUND_ALERT_IDLE2 = "controller/con_alert2.wav";
	string SOUND_ALERT_IDLE3 = "controller/con_alert3.wav";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_PAIN1 = "aslave/slv_pain1.wav";
	string SOUND_PAIN2 = "aslave/slv_pain2.wav";
	string SOUND_CLAW = "zombie/claw_miss2.wav";
	bool NPC_NO_MOVE = true;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_FLINCH = "ANIM_FLINCH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool HIDE_MODE = false;
	float MIN_FLINCH_DAMAGE = 0.0f;
	float GO_TO_REST = 0.0f;
	float NEXT_MELEE = 0.0f;
	string MELEE_TARGET = "MELEE_TARGET";
	float NEXT_SEARCH_SOUND = 0.0f;
	bool BEAM_ATTACK = false;
	float NEXT_FLINCH = 0.0f;
	float EYE_SKIN = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	Swampeye()
	{
		ANIM_IDLE = "hide_idle";
		ANIM_WALK = "idle";
		SOUND_DEATH = "aslave/slv_die2.wav";
	}

	// unnamed block (first think)
	void Swampeye_FirstThink()
	{
		ANIM_IDLE = "hide_idle";
		ANIM_WALK = "idle";
		ANIM_RUN = "idle";
		ANIM_FLINCH = "flinch1";
		ANIM_ATTACK = "eyeblast";
		ANIM_DEATH = "death2";
	}

	// unnamed block (first think)
	void Swampeye_FirstThink2()
	{
		NO_STUCK_CHECKS = "1"; // monster does not move

		NPC_GIVE_EXP = 400.0f;

		// setvard NPC_RANGED 1
		ATTACK_RANGE = 1024.0f;
		ATTACK_HITRANGE = 1024.0f;
	}

	// game_damaged
	string Swampeye_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		GO_TO_REST = GameTime() + 10.0f;

		if (!HIDE_MODE)
			return result;
		OnRiseAndShine();
		return result;
	}

	// game_dodamage
	string Swampeye_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (BEAM_ATTACK)
			ApplyEffect(target, "effects/dot_lightning", 5.0f, self, DOT_BEAM);
		BEAM_ATTACK = false;
		return result;
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		SetProp(ENT_ME, "skin", 3);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		PlayRandomSound(0, 5, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_PAIN1, SOUND_PAIN2);
		// manual flinch
		if (!(GameTime() > NEXT_FLINCH))
			return;
		if (!(damage > MIN_FLINCH_DAMAGE))
			return;
		if (!(RandomInt(1, int(MyMaxHealth())) > HealthOf(ENT_ME)))
			return;
		NEXT_FLINCH = GameTime() + 20.0f;
		OnNpcatkSuspendAi("1.0");
		if (RandomInt(1, 2) == 1)
		{
			PlayAnim("critical", ANIM_FLINCH1);
			OnDoBlink();
		}
		else
		{
			PlayAnim("critical", ANIM_FLINCH2);
			OnDoBlink();
		}
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SetName("Swamp Eye");
		SetModel("monsters/swamp_eye.mdl");
		SetWidth(48);
		SetHeight(92);
		SetRace("demon");
		SetBlood("green");
		SetHealth(1000);
		SetDamageTaken("lightning", 0.25f);
		SetHearingSensitivity(11);
		SetMoveAnim(ANIM_HIDE);
		SetIdleAnim(ANIM_HIDE);
		PlayAnim("hold", ANIM_HIDE);
		HIDE_MODE = true;
		SetNoPush(true);

		SetGravity(0);

		CallEventDelayed(2.0f, "final_props");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		bool exitSub = false;
		if (HIDE_MODE)
			return;

		if (GameTime() > GO_TO_REST)
		{
			OnGoToSleep();
			exitSub = true;
		}
		if (exitSub)
			return;

		if (NPCATK_TARGET == "unset")
			return;

		SetMoveDest(NPCATK_TARGET, 9999);

		if (RangeTo(NPCATK_TARGET) < Float(MELEE_RANGE) && GameTime() > NEXT_MELEE)
		{
			NEXT_MELEE = GameTime() + 4.0f;
			MELEE_TARGET = NPCATK_TARGET;
			OnNpcatkSuspendAi("1.0");
			PlayAnim("critical", ANIM_MELEE);
		}

		if (!CanSee(NPCATK_TARGET))
		{
			// check for "I can't see him cuz he's in da water" bullshit
			// nvm we fixed this code side - water also stops beam damage though :/
			// - gonna check if target is in water instead, do direct damage if so
			// local BEAM_START $get(ent_me,attachpos,0)
			// local BEAM_END $get(NPCATK_TARGET,origin)
			// if ( !$get(NPCATK_TARGET,isplayer) )
			// {
			// local HALF_TARG_HEIGHT $get(NPCATK_TARGET,height)
			// multiply HALF_TARG_HEIGHT 0.5
			// vectoradd BEAM_END z HALF_TARG_HEIGHT
			// }
			// local TRACE_LINE $get_traceline(BEAM_START,BEAM_END,worldonly)
			// if ( TRACE_LINE equals BEAM_END )
			// {
			// //aha! I can see him!
			// setvard WATER_BULLSHIT 1
			// playanim once ANIM_ATTACK
			// setvard GO_TO_REST game.time
			// add GO_TO_REST 10.0
			// local EXIT_SUB 1
			// }
			// if !EXIT_SUB
			if (GameTime() > NEXT_SEARCH_SOUND)
			{
				NEXT_SEARCH_SOUND = GameTime() + Random(3, 10);
				PlayRandomSound(0, 10, SOUND_ALERT_IDLE1, SOUND_ALERT_IDLE2, SOUND_ALERT_IDLE3);
				PlayAnim("once", ANIM_LOOK);
				if (RandomInt(1, 2) == 1)
					OnDoBlink();
			}
		}
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		if (!HIDE_MODE)
			return;
		OnRiseAndShine();
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, Swampeye_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, Swampeye_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		GO_TO_REST = GameTime() + 10.0f;
	}

	// final_props
	void OnFinalProps()
	{
		MIN_FLINCH_DAMAGE = MaxHealthOf(ENT_ME) * 0.05f;
	}

	// rise_and_shine
	void OnRiseAndShine()
	{
		HIDE_MODE = false;
		ANIM_IDLE = ANIM_IDLE_NORM;
		SetMoveAnim(ANIM_IDLE);
		SetIdleAnim(ANIM_IDLE);
		PlayAnim("critical", ANIM_RISE);
		GO_TO_REST = GameTime() + 20.0f;
		OnDoBlink();
	}

	// go_to_sleep
	void OnGoToSleep()
	{
		NPCATK_TARGET = "unset";
		ANIM_IDLE = ANIM_HIDE;
		SetMoveAnim(ANIM_IDLE);
		SetIdleAnim(ANIM_IDLE);
		PlayAnim("once", ANIM_LOWER);
		HIDE_MODE = true;
	}

	// frame_beam_charge
	void OnFrameBeamCharge()
	{
		PlaySound(0, 10, SOUND_BEAM_CHARGE);
	}

	// frame_beam_fire
	void OnFrameBeamFire()
	{
		PlayRandomSound(0, 10, SOUND_BEAM_FIRE1, SOUND_BEAM_FIRE2, SOUND_BEAM_FIRE3);

		Vector3 beamStart = AttachmentPositionOf(ENT_ME, 0);
		Vector3 beamEnd = OriginOf(NPCATK_TARGET);
		if (!IsPlayer(NPCATK_TARGET))
		{
			float halfTargHeight = HeightOf(NPCATK_TARGET) * 0.5f;
			beamEnd.z += halfTargHeight;
		}
		string traceLine = LegacyFunction("get_traceline", beamStart, beamEnd, "worldonly");

		Effect("beam", "end", "lgtning.spr", 30, traceLine, ENT_ME, 1, Vector3(255, 255, 0), 150, 30.0f, 1.0f);
		BEAM_ATTACK = true;

		if ((IsInWater(NPCATK_TARGET) ? 1 : 0) == 0)
			DoDamageEx(beamStart, beamEnd, DMG_BEAM, "100%", ENT_ME, ENT_ME, "none", "lightning");
		else
			DoDamage(NPCATK_TARGET, "direct", DMG_BEAM, "100%", ENT_ME, "lightning");
	}

	// frame_claw
	void OnFrameClaw()
	{
		PlaySound(0, 10, SOUND_CLAW);
		DoDamage(MELEE_TARGET, MELEE_HITRANGE, DMG_MELEE, "90%", "slash");
	}

	// do_blink
	void OnDoBlink()
	{
		EYE_SKIN = 0.0f;
		OnDoBlink2();
	}

	// do_blink2
	void OnDoBlink2()
	{
		EYE_SKIN += 1.0f;
		if (EYE_SKIN < 5.0f)
		{
			SetProp(ENT_ME, "skin", EYE_SKIN);
			CallEventDelayed(0.1f, "do_blink2");
		}
		else
		{
			SetProp(ENT_ME, "skin", 0);
		}
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/swamp_eye.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Swampeye_FirstThink();
		Swampeye_FirstThink2();
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
		if (name == "do_blink") { OnDoBlink(); return true; }
		if (name == "do_blink2") { OnDoBlink2(); return true; }
		if (name == "final_props") { OnFinalProps(); return true; }
		if (name == "frame_beam_charge") { OnFrameBeamCharge(); return true; }
		if (name == "frame_beam_fire") { OnFrameBeamFire(); return true; }
		if (name == "frame_claw") { OnFrameClaw(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "go_to_sleep") { OnGoToSleep(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "rise_and_shine") { OnRiseAndShine(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
