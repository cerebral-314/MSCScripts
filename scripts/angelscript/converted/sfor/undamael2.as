#pragma context server

// Converted from sfor/undamael2.script by msc_transpiler.
// Thothie - Undamael is not working, remaking based on Blacksmith-Atholo Conversion
// -Again, IMO - invulnerable, but drops too much stuff (is there some way to kill invulnerables?)
// -One unique item per boss - plzkthnx! :)
// -Reducing GOld
// -Does insane damage -but not the 400/hit of the original script ><
// -Other Noteable Differences from Atholo: no glow, >hp >damage, sounds
// -attempting to make vulnerable via NPC script
// Undamael (from Atholo)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

[script "sfor/undamael2"]
class Undamael2 : BaseMonsterScript
{
	// Constants
	string SOUND_PISSED = "nihilanth/nil_done.wav";
	string SOUND_REGEN = "x/x_laugh1.wav";

	// Variables (an unset .script variable reads as its own name)
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_PAIN = "controller/con_pain2.wav";
	string SOUND_ATTACK1 = "zombie/claw_miss1.wav";
	string SOUND_ATTACK2 = "zombie/claw_miss2.wav";
	string SOUND_SPAWN = "npc/undamael1.wav";
	int ATTACK1_RANGE = 600;
	int ATTACK2_RANGE = 200;
	bool SEE_ENEMY = false;
	bool IGNORE_ENEMY = false;
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool I_AM_TURNABLE = false;

	// Variables declared by included files, with the value they start with in this script
	Undamael2()
	{
		SOUND_DEATH = "npc/undamael2.wav";
		ANIM_RUN = "walk";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
	}

	// unnamed block (first think)
	void Undamael2_FirstThink()
	{
		SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
		SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
		SOUND_PAIN = "controller/con_pain2.wav";
		SOUND_ATTACK1 = "zombie/claw_miss1.wav";
		SOUND_ATTACK2 = "zombie/claw_miss2.wav";
		SOUND_SPAWN = "npc/undamael1.wav";
		ANIM_RUN = "walk";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "attack1";
		ATTACK1_RANGE = 600;
		ATTACK2_RANGE = 200;
		MOVE_RANGE = "500";
		SEE_ENEMY = false;
		IGNORE_ENEMY = false;
		CAN_FLINCH = "0";
		FLINCH_DELAY = "12";
		NPC_MOVE_TARGET = "enemy";
		PlaySound(2, 10, SOUND_SPAWN); // plays fresh blood sound

		I_AM_TURNABLE = false;
	}

	// game_damaged
	// PARAM1=attacker PARAM2=Damage PARAM3=DamageType
	string Undamael2_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		if (damage > 100.0f)
			DoDamage(attacker, "direct", "100%", damage, ENT_ME, "magic");
		return result;
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttack_OnMyTargetDied(offender); // monsters/base_npc_attack
		PlaySound(0, 10, SOUND_REGEN);
		Effect("glow", ENT_ME, Vector3(0, 255, 0), 128, 2, 2);
		SetHealth(MyMaxHealth());
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Lord Undamael");
		SetInvincible(true);
		SetHealth(9000);
		SetGold(RandomInt(100, 400));
		// ov 359
		SetWidth(50);
		SetHeight(128);
		SetRace("undead");
		SetRoam(false);
		SetHearingSensitivity(10);
		NPC_GIVE_EXP = 400.0f;
		SetModel("monsters/skeleton_hood.mdl");
		SetModelBody(0, 0);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		SetDamageTaken("all", 0.25f);
		SetDamageTaken("holy", 2);
		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 0.1f);
		SetDamageTaken("lightning", 0.1f);

		PlaySound(2, 10, SOUND_SPAWN);
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, Undamael2_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// attack_1
	void OnAttack12()
	{
		DoDamage(ENT_LASTSEEN, 600, Random(20, 150), "75%");
	}

	// attack_2
	void OnAttack22()
	{
		DoDamage(ENT_LASTSEEN, ATTACK2_RANGE, Random(10, 100), "100%");
		DoDamage(ENT_LASTSEEN, ATTACK2_RANGE, Random(10, 100), "100%");
	}

	// npc_struck
	// Hit by someone
	void OnNpcStruck(float damage = 0.0f)
	{
		SetVolume(5);
		PlayRandomSound(2, SOUND_STRUCK1, SOUND_STRUCK2);
	}

	// npc_attack
	void OnNpcAttack()
	{
		if (RandomInt(0, 10) > 9)
		{
			ANIM_ATTACK = "attack1";
			ATTACK_RANGE = 600.0f;
			MOVE_RANGE = "500";
		}
		else
		{
			ANIM_ATTACK = "attack2";
			ATTACK_RANGE = 160.0f;
			MOVE_RANGE = "130";
		}
	}

	// death
	// ported from original, edited
	void OnDeath()
	{
		PlaySound(2, 10, SOUND_DEATH);
		GiveItem("bows_swiftbow");
		GiveItem("smallarms_huggerdagger3");
	}

	// vulnerable
	// attempt to make vulnerable via msnpc_script
	void OnVulnerable()
	{
		SetInvincible(false);
		PlaySound(0, 10, SOUND_PISSED);
		SetSayTextRange(1024);
		SayText("No! What have you done!?");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("lgtning.spr");
		Precache("monsters/skeleton_hood.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Undamael2_FirstThink();
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
		if (name == "death") { OnDeath(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_attack") { OnNpcAttack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "vulnerable") { OnVulnerable(); return true; }
		return BaseMonsterScript::DispatchEvent(name, params);
	}
}
