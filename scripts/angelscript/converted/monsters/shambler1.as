#pragma context server

// Converted from monsters/shambler1.script by msc_transpiler.
// Bog Creature by Shurik3n

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/shambler1"]
class Shambler1 : BaseMonsterNewScript
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
	string SOUND_STRUCK2 = "bullchicken/bc_pain1.wav";
	string SOUND_PAIN = "bullchicken/bc_pain1.wav";
	string SOUND_ATTACK1 = "ichy/ichy_bite1.wav";
	string SOUND_ATTACK2 = "zombie/claw_miss2.wav";
	string SOUND_IDLE1 = "garg/gar_breathe3.wav";
	string CAN_HUNT = "1";
	int DROP_GOLD_MIN = 20;
	int DROP_GOLD_MAX = 70;
	string CHANCE_STUN = "20";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ATTACK_TYPE = "ATTACK_TYPE";

	// Variables declared by included files, with the value they start with in this script
	Shambler1()
	{
		ANIM_RUN = "walk";
		ANIM_WALK = "walk";
		SOUND_DEATH = "bullchicken/bc_die3.wav";
		RETALIATE_CHANCE = "75%";
		CAN_FLEE = "0";
	}

	// unnamed block (first think)
	void Shambler1_FirstThink()
	{
		// these first four aims are used by the base
		// they should be setvard so the base can alter them if need be
		// the movement anims are pre-load as they are used in the game_spawn function (npc_spawn)
		ANIM_DEATH = "dieforward";
		ANIM_RUN = "walk";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "attack1";
		ATTACK_RANGE = 68.0f; // same with these two (used by base, adjustable)
		ATTACK_HITRANGE = 140.0f;
		CAN_FLEE = "0"; // default
	}

	// game_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end)
	string Shambler1_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		// this way the creature can only stun you if he hits you
		// (raised the stun% chance to compensate)
		// I've been bitched at before for making monsters stun when missing
		if (ATTACK_TYPE != "crush")
			return result;
		if (!hit)
			return result;
		if (!(RandomInt(1, 100) < Float(CHANCE_STUN)))
			return result;
		ApplyEffect(target, "effects/debuff_stun", 5, self);
		return result;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetHealth(2000);
		SetWidth(32); // this thing is actually about player sized, making it wider than 32 cause nav issues
		SetHeight(100);
		SetName("Shambler");
		SetRoam(true);
		SetBlood("green"); // looks like it needs green blood
		SetHearingSensitivity(6);
		NPC_GIVE_EXP = 300.0f; // no armor, no resistances, no special attacks (save pathetic chance to stun)
		SetRace("demon");
		SetModel("monsters/bogcreature.mdl");
		SetModelBody(0, 0);
		SetIdleAnim("idle1");
		SetMoveAnim(ANIM_WALK);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, Shambler1_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// attack_1
	void OnAttack12()
	{
		// ent_laststruckbyme here is not wise
		// reason being is the damage isn't actually done until the next cycle
		// thus the velocity effect may apply to a creature other than the one he hits
		// (this method very often what causes effects to  apply to the wrong players)
		// NPCATK_TARGET at least garuntees the effect is applied to the guy he's aiming at
		ATTACK_TYPE = "slash";
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_SLASH), ATTACK_HITCHANCE_SLASH, "slash");

		if (RandomInt(1, 4) == 3)
			ANIM_ATTACK = ANIM_ATTACK_CRUSH;
		AddVelocity(ENT_LASTSTRUCKBYME, RelativeVelocity(Vector3(0, 110, 105)));
		PlaySound(2, 10, SOUND_ATTACK1);
	}

	// attack_2
	void OnAttack22()
	{
		ATTACK_TYPE = "crush";
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_CRUSH), ATTACK_HITCHANCE_CRUSH, "blunt");

		// IMMUNE_PUSH - is a var used to mark lures and such unpushable
		// - (probably also give players some ring of stability or some such later)
		// - Unlike most resistances, it is all or nothing (1|0)
		// - Thus check for push immunity before pushing
		ANIM_ATTACK = ANIM_ATTACK_SLASH;
		PlaySound(2, 10, SOUND_ATTACK2);
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(2, 7, SOUND_PAIN, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_PAIN);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/bogcreature.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Shambler1_FirstThink();
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
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
