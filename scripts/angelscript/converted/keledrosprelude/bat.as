#pragma context server

// Converted from keledrosprelude/bat.script by msc_transpiler.
// Fire Bat (from Bat)
// - Thothie sticky client side effect driving people nuts
// - switching to effect (although rougher on server)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bat_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class KeledrospreludeBat
{
	// Constants
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_PAIN = "monsters/rat/squeak1.wav";
	string SOUND_IDLE1 = "monsters/rat/squeak2.wav";
	string SOUND_DEATH = "monsters/rat/squeak3.wav";
	string ATTACK_DAMAGE = "5";
	int FLEE_HEALTH = 1;
	string FLEE_CHANCE = "100%";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK = "IdleFlyNormal";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_IDLE_HANG = "IdleHang";
	string ANIM_IDLE_FLY = "IdleFlyNormal";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	string CAN_FLEE = "CAN_FLEE";
	string ATTACK_HITCHANCE = "ATTACK_HITCHANCE";
	string CAN_HUNT = "CAN_HUNT";
	int BAT_STATUS = 0;

	// unnamed block (first think)
	void KeledrospreludeBat_FirstThink()
	{
		ANIM_WALK = "IdleFlyNormal";
		ANIM_RUN = ANIM_WALK;
		ANIM_ATTACK = "bite";
		ANIM_IDLE_HANG = "IdleHang";
		ANIM_IDLE_FLY = "IdleFlyNormal";
		ANIM_DEATH = "die";

		MOVE_RANGE = "54";
		ATTACK_RANGE = 64.0f;
		ATTACK_HITRANGE = 100.0f;
		NPC_GIVE_EXP = 20.0f;

		CAN_FLEE = "1"; // base_npc_attack - Whether I run away
	}

	// bat_spawn
	void KeledrospreludeBat_OnBatSpawn()
	{
		SetName("Fire Bat");
		SetHealth(50);
		// ov 359
		SetWidth(32);
		SetHeight(32);
		SetHearingSensitivity(5);
		SetVolume(5);

		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 2);
		SetModel("monsters/bat.mdl");

		CallEventDelayed(1.0f, "start_flaming");
	}

	// npc_post_spawn
	void KeledrospreludeBat_OnNpcPostSpawn()
	{
		ATTACK_HITCHANCE = "60%";
		if (ToLowerCase(MapName()) != "keledrosprelude2")
			ATTACK_HITCHANCE = "90%";
	}

	// game_postspawn
	void KeledrospreludeBat_OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		SetBoundingBox("animsize");
	}

	// bat_drop_down
	// Drop down from the ceiling
	void KeledrospreludeBat_OnBatDropDown()
	{
		CAN_HUNT = "1";
		BAT_STATUS = (BAT_FLYING ? 1 : 0);
		SetIdleAnim(ANIM_IDLE_FLY);
	}

	// bite1
	// Deal damage
	void KeledrospreludeBat_OnBite1()
	{
		if (!(RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE))
			return;
		DoDamageEx(NPCATK_TARGET, "direct", ATTACK_DAMAGE, ATTACK_HITCHANCE, ENT_ME, ENT_ME, "none", "pierce", "dmgevent:bite");
	}

	// npc_struck
	// Hit by someone
	void KeledrospreludeBat_OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(2, SOUND_PAIN, SOUND_STRUCK2, SOUND_PAIN);
	}

	// start_flaming
	void KeledrospreludeBat_OnStartFlaming()
	{
		CallEventDelayed(5.0f, "start_flaming");

		ApplyEffect(ENT_ME, "effects/torch_flame", 5);
	}

	// bite_dodamage
	void KeledrospreludeBat_OnBiteDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (!IsAlive(target))
			return;
		if (RandomInt(1, 5) != 1)
			return;
		ApplyEffect(target, "effects/dot_fire", 5.0f, self, ATTACK_DAMAGE);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		BatBase_OnNpcPostSpawn(); // monsters/bat_base
		KeledrospreludeBat_OnNpcPostSpawn();
	}

	// game_postspawn
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		BaseSelfAdjust_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_self_adjust
		BaseNpc_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_npc
		KeledrospreludeBat_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params);
	}

	void OnBatSpawn() { KeledrospreludeBat_OnBatSpawn(); } // bat_spawn
	void OnBatDropDown() { KeledrospreludeBat_OnBatDropDown(); } // bat_drop_down
	void OnBite1() { KeledrospreludeBat_OnBite1(); } // bite1
	void OnNpcStruck(float damage = 0.0f) { KeledrospreludeBat_OnNpcStruck(damage); } // npc_struck
	void OnStartFlaming() { KeledrospreludeBat_OnStartFlaming(); } // start_flaming
	void OnBiteDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { KeledrospreludeBat_OnBiteDodamage(hit, target, start, end, damageType, damageText); } // bite_dodamage

	// This file's events and timers by their .script names
	bool KeledrospreludeBat_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bat_drop_down") { OnBatDropDown(); return true; }
		if (name == "bat_spawn") { OnBatSpawn(); return true; }
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "bite_dodamage") { OnBiteDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "start_flaming") { OnStartFlaming(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "keledrosprelude/bat"]
shared class KeledrospreludeBatScript : BatBaseScript, KeledrospreludeBat
{
	// Variables declared by included files, with the value they start with in this script
	KeledrospreludeBatScript()
	{
		ANIM_WALK = "IdleFlyNormal";
		ANIM_IDLE_HANG = "IdleHang";
		ANIM_IDLE_FLY = "IdleFlyNormal";
		SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
		SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
		SOUND_DEATH = "monsters/rat/squeak3.wav";
		ATTACK_DAMAGE = "5";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/bat.mdl");
		CallEventDelayed(0.5f, "BatBase_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
		CallEventDelayed(5.0f, "start_flaming");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KeledrospreludeBat_FirstThink();
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
		return KeledrospreludeBat_DispatchEvent(name, params)
			|| BatBaseScript::DispatchEvent(name, params);
	}
}
