#pragma context server

// Converted from monsters/skeleton_ice2_hammer.script by msc_transpiler.
// First of the next tier of ice skeles

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_base.as"

[script "monsters/skeleton_ice2_hammer"]
class SkeletonIce2Hammer : SkeletonBaseScript
{
	// Constants
	float ATTACK_DAMAGE_LOW = 100.0f;
	float ATTACK_DAMAGE_HIGH = 200.0f;
	string SKEL_RESPAWN_CHANCE = "0%";
	int SKEL_RESPAWN_LIVES = 0;
	string SOUND_STEP1 = "debris/glass1.wav";
	string SOUND_STEP2 = "debris/glass2.wav";
	string SOUND_STEP3 = "debris/glass3.wav";
	float FREQ_CHARGE = 30.0f;
	float WALK_MOVESPEED = 1.0f;
	string SOUND_STUN = "zombie/claw_strike2.wav";
	string SOUND_SUMMON = "monsters/skeleton/calrain3.wav";
	bool CUSTOM_SIZE = true;
	float DOT_ICE = 50.0f;

	// Variables (an unset .script variable reads as its own name)
	float STUN_ATK_COUNT = 0.0f;
	float NEXT_CHARGE = 0.0f;
	bool AM_CHARGING = false;
	bool STUN_ATTACK = false;
	string PUSH_VEL = "PUSH_VEL";
	float N_SOUND_STEP = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	SkeletonIce2Hammer()
	{
		SKEL_MODEL = "monsters/skeleton_boss2.mdl";
		SKEL_WIDTH = 40;
		SKEL_HEIGHT = 130;
		SKEL_MOVE_RANGE = 64;
		SKEL_ATTACK_RANGE = 150;
		SKEL_ATTACK_HITRANGE = 220;
		ANIM_RUN = "run";
		SKEL_HP = 10000;
		ATTACK_HITCHANCE = "85%";
	}

	// unnamed block (first think)
	void SkeletonIce2Hammer_FirstThink()
	{
		ANIM_RUN = "run";
		NPC_GIVE_EXP = 2500.0f;

		DROP_GOLD = 1;
		DROP_GOLD_AMT = 750.0f;

		BASE_MOVESPEED = 2.0f;

		CAN_FLINCH = "0";
	}

	// game_dodamage
	string SkeletonIce2Hammer_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (STUN_ATTACK && hit)
		{
			PlaySound(0, 10, SOUND_STUN);
			ApplyEffect(target, "effects/debuff_stun", Random(5, 10), self);
		}
		STUN_ATTACK = false;
		return result;
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, SkeletonIce2Hammer_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (!(GameTime() > NEXT_CHARGE))
			return;
		NEXT_CHARGE = GameTime() + FREQ_CHARGE;

		AM_CHARGING = true;
		CAN_FLEE = "0";
		PlayAnim("break");
		ApplyEffect(ENT_ME, "effects/sfx_motionblur_temp", self, 8, 0, 5.0f);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
		SetAnimFrameRate(3);
		PlaySound(0, 10, "magic/teleport.wav");
		CallEventDelayed(5.0f, "end_charge");
	}

	// attack_1
	void OnAttack12()
	{
		SkeletonBase_OnAttack12(); // monsters/skeleton_base

		STUN_ATTACK = false;

		PUSH_VEL = Text(RelativeVelocity(Vector3(10, 100, 10)));

		STUN_ATK_COUNT += 1.0f;
		if (!(STUN_ATK_COUNT >= 10.0f))
			return;
		STUN_ATK_COUNT = 0.0f;
		ANIM_ATTACK = "attack2";
	}

	// skeleton_spawn
	void OnSkeletonSpawn()
	{
		SetModelBody(0, 8); // 0=standard 1=ash 2=green 3=bloody 4=decayed 5=ice 6=gold 7=stone 8=icelord 9=bloodlord
		SetModelBody(1, 3); // 0=Unarmed 1=darkmace 2=sword 3=hammahs 4=bigsword+shield 5=iceclubs 6=fireclubs 7=highsword 8=wand

		SetName("Frost Hammer");
		SetRoam(true);

		SetBlood("none");

		SetDamageTaken("all", 0.6f);
		SetDamageTaken("cold", 0);
		SetDamageTaken("fire", 1.5f);

		SetHearingSensitivity(3);

		STUN_ATK_COUNT = 0.0f;
	}

	// end_charge
	void OnEndCharge()
	{
		CAN_FLEE = "1";
		PlayAnim("break");
		AM_CHARGING = false;
		SetProp(ENT_ME, "rendermode", 0);
		SetProp(ENT_ME, "renderamt", 255);
		SetAnimFrameRate(1);
	}

	// attack_2
	void OnAttack22()
	{
		PUSH_VEL = Text(RelativeVelocity(Vector3(10, 200, 10)));

		STUN_ATTACK = true;
		OnAttackSnd();
		DoDamage(ENTITY_ENEMY, ATTACK_HITRANGE, Random(ATTACK_DAMAGE_LOW, ATTACK_DAMAGE_HIGH), ATTACK_HITCHANCE);
		ANIM_ATTACK = "attack1";
	}

	// skele_swing_dodamage
	// 1:AttackHit(1/0)  2:EntityHit  3:StartOrigin  4:EndOrigin
	void OnSkeleSwingDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		AddVelocity(target, Vec(PUSH_VEL)); // Push the player a bit
		if (RandomInt(1, 10) != 1)
			return;
		ApplyEffect(target, "effects/dot_cold", 5.0f, self, DOT_ICE);
	}

	// walk_step1
	// walk
	void OnWalkStep1()
	{
		// movespeed WALK_MOVESPEED
		OnSoundStep();
	}

	// walk_step2
	// walk
	void OnWalkStep2()
	{
		// movespeed WALK_MOVESPEED
		OnSoundStep();
	}

	// run_step1
	// run
	void OnRunStep1()
	{
		SetMoveSpeed(BASE_MOVESPEED);
		OnSoundStep();
	}

	// run_step2
	// run
	void OnRunStep2()
	{
		SetMoveSpeed(BASE_MOVESPEED);
		OnSoundStep();
	}

	// sound_step
	void OnSoundStep()
	{
		N_SOUND_STEP += 1.0f;
		if (N_SOUND_STEP > 2.0f)
			N_SOUND_STEP = 1.0f;
		if (N_SOUND_STEP == 1.0f)
			PlaySound(0, 5, "weapons/dagger/daggermetal1.wav");
		if (N_SOUND_STEP == 2.0f)
			PlaySound(0, 5, "weapons/dagger/daggermetal2.wav");
		if (N_SOUND_STEP == 3.0f)
			PlaySound(0, 5, SOUND_STEP3);
	}

	// skeleton_attribs
	void OnSkeletonAttribs()
	{
		SetDamageTaken("slash", 0.7f);
		SetDamageTaken("pierce", 0.5f);
		SetDamageTaken("blunt", 1.2f);
		SetDamageTaken("fire", 2);
		SetDamageTaken("holy", 3);
		SetDamageTaken("cold", 0);
		SetDamageTaken("poison", 0);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnAttackSnd() {} // attack_snd

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skeleton_boss2.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SkeletonIce2Hammer_FirstThink();
		SkeletonBase_FirstThink();
		SkeletonBase_FirstThink2();
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
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "end_charge") { OnEndCharge(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "run_step1") { OnRunStep1(); return true; }
		if (name == "run_step2") { OnRunStep2(); return true; }
		if (name == "skele_swing_dodamage") { OnSkeleSwingDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "skeleton_attribs") { OnSkeletonAttribs(); return true; }
		if (name == "skeleton_spawn") { OnSkeletonSpawn(); return true; }
		if (name == "sound_step") { OnSoundStep(); return true; }
		if (name == "walk_step1") { OnWalkStep1(); return true; }
		if (name == "walk_step2") { OnWalkStep2(); return true; }
		return SkeletonBaseScript::DispatchEvent(name, params);
	}
}
