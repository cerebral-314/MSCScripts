#pragma context server

// Converted from monsters/shambler2.script by msc_transpiler.
// Bog Creature by Shurik3n

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/shambler2"]
class Shambler2 : BaseMonsterNewScript
{
	// Constants
	string HUNT_AGRO = "1";
	string ANIM_ATTACK_SLASH = "attack1";
	string ANIM_ATTACK_CRUSH = "attack2";
	float DMG_SLASH = 0.0f;
	int DMG_CRUSH = 0;
	string ATTACK_HITCHANCE_SLASH = "70%";
	string ATTACK_HITCHANCE_CRUSH = "40%";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "agrunt/ag_attack1.wav";
	string SOUND_PAIN = "agrunt/ag_attack3.wav";
	string SOUND_ATTACK1 = "ichy/ichy_bite1.wav";
	string SOUND_ATTACK2 = "zombie/claw_miss2.wav";
	string SOUND_IDLE1 = "garg/gar_breathe3.wav";
	string CAN_HUNT = "1";
	string SOUND_STEP1 = "debris/flesh1.wav";
	string SOUND_STEP2 = "debris/flesh2.wav";
	string SOUND_STEP3 = "debris/flesh3.wav";
	string SOUND_STEP4 = "debris/flesh7.wav";
	string SOUND_STEP5 = "debris/flesh5.wav";
	string SOUND_STEP6 = "debris/flesh6.wav";
	string SOUND_STEP7 = "debris/flesh7.wav";
	bool GOLD_BAGS = true;
	int GOLD_BAGS_PPLAYER = 2;
	int GOLD_PER_BAG = 25;
	int GOLD_RADIUS = 64;
	int GOLD_MAX_BAGS = 32;
	string CHANCE_STUN = "50";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "attack1";
	string ATTACK_TYPE = "ATTACK_TYPE";

	// Variables declared by included files, with the value they start with in this script
	Shambler2()
	{
		ANIM_RUN = "walk";
		ANIM_WALK = "walk";
		ATTACK_RANGE = 80.0f;
		ATTACK_HITRANGE = 220.0f;
		SOUND_DEATH = "bullchicken/bc_die3.wav";
		RETALIATE_CHANCE = "75%";
		CAN_FLEE = "0";
	}

	// unnamed block (first think)
	void Shambler2_FirstThink()
	{
		ANIM_DEATH = "diebackward";
		ANIM_RUN = "walk";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "attack1";
		ATTACK_RANGE = 80.0f;
		ATTACK_HITRANGE = 220.0f;
		CAN_FLEE = "0";
	}

	// game_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end)
	string Shambler2_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (ATTACK_TYPE != "crush")
			return result;
		if (!hit)
			return result;
		if (!(RandomInt(1, 100) < Float(CHANCE_STUN)))
			return result;
		ApplyEffect(target, "effects/debuff_stun", 5, self);
		return result;
	}

	// unnamed block (timer)
	void Shambler2_Timer()
	{
		CallEventDelayed(Random(5, 8), "Shambler2_Timer");
		PlaySound(0, 10, SOUND_IDLE1);
		if (CYCLED_UP)
			return;
		PlayAnim("once", "llflinch");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetHealth(4000);
		SetWidth(50);
		SetHeight(150);
		SetName("Greater Shambler");
		SetRoam(true);
		SetBlood("green");
		SetHearingSensitivity(6);
		NPC_GIVE_EXP = 200.0f;
		SetRace("demon");
		SetModel("monsters/shambler.mdl");
		SetModelBody(0, 0);
		SetIdleAnim("idle1");
		SetMoveAnim(ANIM_WALK);
		SetAnimFrameRate(0.75f);
		SetAnimMoveSpeed(0.75f);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, Shambler2_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// attack_1
	void OnAttack12()
	{
		ATTACK_TYPE = "slash";
		if (RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE)
			OnNpcatkDodamage(NPCATK_TARGET, "direct", Text(DMG_SLASH), ATTACK_HITCHANCE_SLASH, EntityId(self), "slash");

		if (RandomInt(1, 4) == 3)
			ANIM_ATTACK = ANIM_ATTACK_CRUSH;
		AddVelocity(ENT_LASTSTRUCKBYME, RelativeVelocity(Vector3(0, 35, 70)));
		PlaySound(2, 10, SOUND_ATTACK1);
	}

	// attack_2
	void OnAttack22()
	{
		ATTACK_TYPE = "crush";
		if (RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE)
			OnNpcatkDodamage(NPCATK_TARGET, "direct", Text(DMG_CRUSH), ATTACK_HITCHANCE_CRUSH, EntityId(self), "blunt");

		ANIM_ATTACK = ANIM_ATTACK_SLASH;
		AddVelocity(ENT_LASTSTRUCKBYME, RelativeVelocity(Vector3(0, 300, 200)));
		PlaySound(2, 10, SOUND_ATTACK2);
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(2, 10, SOUND_PAIN, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_PAIN);
	}

	// walk_step
	void OnWalkStep()
	{
		PlayRandomSound(0, 8, SOUND_STEP1, SOUND_STEP2, SOUND_STEP3, SOUND_STEP4, SOUND_STEP5, SOUND_STEP6, SOUND_STEP7);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/shambler.mdl");
		CallEventDelayed(Float(Eval("$randf(5,8)")), "Shambler2_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Shambler2_FirstThink();
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
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "walk_step") { OnWalkStep(); return true; }
		if (name == "Shambler2_Timer") { Shambler2_Timer(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
