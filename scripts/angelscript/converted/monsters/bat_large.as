#pragma context server

// Converted from monsters/bat_large.script by msc_transpiler.
// Thothie - attempting to see if can create better death sequence
// Bat

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bat_base.as"

[script "monsters/bat_large"]
class BatLarge : BatBaseScript
{
	// Constants
	string SOUND_PAIN = "monsters/rat/squeak1.wav";
	string SOUND_IDLE = "monsters/rat/squeak2.wav";
	int FLEE_HEALTH = 0;
	string FLEE_CHANCE = "100%";

	// Variables (an unset .script variable reads as its own name)
	float NEXT_DODGE = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	BatLarge()
	{
		ANIM_WALK = "IdleFlyNormal";
		ANIM_IDLE_HANG = "IdleHang";
		ANIM_IDLE_FLY = "IdleFlyNormal";
		SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
		SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
		SOUND_DEATH = "monsters/rat/squeak3.wav";
		ATTACK_DAMAGE = "20";
	}

	// unnamed block (first think)
	void BatLarge_FirstThink()
	{
		ANIM_WALK = "IdleFlyNormal";
		ANIM_RUN = ANIM_WALK;
		ANIM_ATTACK = "bite";
		ANIM_IDLE_HANG = "IdleHang";
		ANIM_IDLE_FLY = "IdleFlyNormal";
		ANIM_DEATH = "IdleFlyNormal"; // use normal flight for death anim (see end of script)

		MOVE_RANGE = "30";
		ATTACK_RANGE = 65.0f;
		ATTACK_HITRANGE = 100.0f;
		ATTACK_HITCHANCE = "80%";
		if (ToLowerCase(MapName()) == "catacombs")
			ATTACK_HITCHANCE = "80%";
		NPC_GIVE_EXP = 25.0f;

		CAN_FLEE = "1"; // base_npc_attack - Whether I run away
	}

	// game_damaged
	string BatLarge_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		if (!(GameTime() > NEXT_DODGE))
			return result;
		NEXT_DODGE = GameTime() + Random(1, 3);
		float rndLf = Random(-300, 300);
		float rndFb = Random(-1000, 0);
		float rndUp = Random(0, 300);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(rndLf, rndFb, rndUp)));
		return result;
	}

	// game_postspawn
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		BaseSelfAdjust_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_self_adjust
		BaseNpc_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_npc
		SetBoundingBox("animsize");
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BatLarge_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// bat_spawn
	void OnBatSpawn()
	{
		SetName("Large Bat");
		SetHealth(100);

		SetWidth(32);
		SetHeight(32);
		SetHearingSensitivity(3.5f);
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 0)));
		SetModel("monsters/bat_large.mdl");

		if (ToLowerCase(MapName()) == "nightmare_edana")
			SetMonsterClip(false);
	}

	// bat_drop_down
	// Drop down from the ceiling
	void OnBatDropDown()
	{
		CAN_HUNT = "1";
		BAT_STATUS = (BAT_FLYING ? 1 : 0);
		SetIdleAnim(ANIM_IDLE_FLY);
	}

	// bite1
	// Deal damage
	void OnBite1()
	{
		if (!(RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE))
			return;
		DoDamage(NPCATK_TARGET, "direct", ATTACK_DAMAGE, ATTACK_HITCHANCE, ENT_ME, "pierce");
	}

	// npc_struck
	// Hit by someone
	void OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(0, 10, SOUND_PAIN, SOUND_STRUCK2, SOUND_PAIN);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/bat_large.mdl");
		CallEventDelayed(0.5f, "BatBase_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BatLarge_FirstThink();
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
		if (name == "bat_drop_down") { OnBatDropDown(); return true; }
		if (name == "bat_spawn") { OnBatSpawn(); return true; }
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		return BatBaseScript::DispatchEvent(name, params);
	}
}
