#pragma context server

// Converted from monsters/skeleton_stone3.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_base.as"

[script "monsters/skeleton_stone3"]
class SkeletonStone3 : SkeletonBaseScript
{
	// Constants
	float ATTACK_DAMAGE_LOW = 30.0f;
	float ATTACK_DAMAGE_HIGH = 60.0f;
	string SKEL_RESPAWN_CHANCE = "0%";
	int SKEL_RESPAWN_LIVES = 0;
	string SOUND_PUSH = "monsters/skeleton/calrain3.wav";
	int STUN_ATK_CHANCE = 10;
	bool STONE_SKELETON = true;

	// Variables (an unset .script variable reads as its own name)
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	bool WAS_SLEEPING = false;
	bool STUN_ATTACK = false;

	// Variables declared by included files, with the value they start with in this script
	SkeletonStone3()
	{
		ANIM_RUN = "run";
		SKEL_HP = 2000;
		ATTACK_HITCHANCE = "95%";
		SOUND_STRUCK1 = "weapons/axemetal1.wav";
		SOUND_STRUCK2 = "weapons/axemetal2.wav";
		SOUND_STRUCK3 = "debris/concrete1.wav";
	}

	// unnamed block (first think)
	void SkeletonStone3_FirstThink()
	{
		NPC_ALLY_RESPONSE_RANGE = 6000.0f;

		ANIM_RUN = "run";
		NPC_GIVE_EXP = 200.0f;

		DROP_GOLD = 1;
		DROP_GOLD_MIN = 35;
		DROP_GOLD_MAX = 65;
	}

	// game_dodamage
	// 1:AttackHit(1/0)  2:EntityHit  3:StartOrigin  4:EndOrigin
	string SkeletonStone3_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;
		if (!STUN_ATTACK)
			return result;
		PlaySound(0, 10, SOUND_PUSH);
		ApplyEffect(target, "effects/effect_push", 3, RelativeVelocity(Vector3(0, 400, 400)), 0);
		STUN_ATTACK = false;
		return result;
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, SkeletonStone3_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// attack_1
	void OnAttack12()
	{
		SkeletonBase_OnAttack12(); // monsters/skeleton_base

		STUN_ATTACK = true;
		DoDamage(ENTITY_ENEMY, ATTACK_HITRANGE, Random(ATTACK_DAMAGE_LOW, ATTACK_DAMAGE_HIGH), ATTACK_HITCHANCE);
		ANIM_ATTACK = "attack3";
	}

	// skeleton_spawn
	void OnSkeletonSpawn()
	{
		SetModel("monsters/skeleton_boss1.mdl");
		SetModelBody(0, 7); // 0=standard 1=ash 2=green 3=bloody 4=decayed 5=ice 6=gold 7=stone 8=crystal 9=weirdgel
		SetModelBody(1, 7); // 0=Unarmed 1=darkmace 2=sword 3=hammahs 4=bigsword+shield 5=iceclubs 6=fireclubs 7=highsword 8=wand
		SetWidth(32);
		SetHeight(80);
		if (!SLEEPER)
			OnAnimateStone();
		if (SLEEPER)
		{
			SetInvincible(true);
			WAS_SLEEPING = true;
			OnNpcatkSuspendAi();
			SetIdleAnim(ANIM_IDLE);
			SetMoveAnim(ANIM_IDLE);
			SetAnimFrameRate(0);
		}

		if (ToLowerCase(MapName()) == "thanatos")
			SET_GREEK = true;
		if (SET_GREEK)
			SetModelBody(0, 10);
	}

	// animate_stone
	void OnAnimateStone()
	{
		SetName("Petrified Blademaster");
		SetRoam(true);

		SetBlood("none");

		SetDamageTaken("all", 0.6f);

		ANIM_ATTACK = "attack3";

		SetHearingSensitivity(3);
	}

	// attack_3
	void OnAttack3()
	{
		STUN_ATTACK = false;
		OnAttackSnd();
		DoDamage(ENTITY_ENEMY, ATTACK_HITRANGE, Random(ATTACK_DAMAGE_LOW, ATTACK_DAMAGE_HIGH), ATTACK_HITCHANCE);
		if (!(RandomInt(1, 100) < STUN_ATK_CHANCE))
			return;
		ANIM_ATTACK = "attack1";
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnAttackSnd() {} // attack_snd

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skeleton_boss1.mdl");
		Precache("monsters/skeleton.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SkeletonStone3_FirstThink();
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
		if (name == "animate_stone") { OnAnimateStone(); return true; }
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_3") { OnAttack3(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "skeleton_spawn") { OnSkeletonSpawn(); return true; }
		return SkeletonBaseScript::DispatchEvent(name, params);
	}
}
