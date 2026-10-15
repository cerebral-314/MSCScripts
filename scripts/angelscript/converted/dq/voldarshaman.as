#pragma context server

// Converted from dq/voldarshaman.script by msc_transpiler.
// Orc Fire Shamman, from Orc Sniper by Thothie

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_ranged.as"
#include "converted/monsters/orc_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Voldarshaman
{
	// Constants
	int AIM_RATIO = 50;
	int ATTACK_SPEED = 200;
	int ATTACK_CONE_OF_FIRE = 2;
	int MELE_RANGE = 96;
	int MELE_HITRANGE = 128;
	string ATTACK_ACCURACY = "80";
	string ANIM_SWIPE = "swordswing1_L";
	string ANIM_FIRE = "swordswing1_L";
	string ANIM_WARCRY = "warcry";
	string SWIPE_DAMAGE = "$rand(25,65)";
	string SOUND_MELEMISS = "zombie/claw_miss1.wav";
	string SOUND_MELEHIT = "zombie/claw_strike3.wav";
	string SOUND_FIRECHARGE = "bullchicken/bc_attack1.wav";
	string SOUND_FIRESHOOT = "bullchicken/bc_attack3.wav";
	string SOUND_WARCRY1 = "monsters/orc/attack1.wav";
	string SOUND_WARCRY2 = "monsters/orc/attack3.wav";
	string FIRE_BALL_DAMAGE = "$rand(75,100)";
	string BURN_DAMAGE = "$randf(10,20)";
	float FIRE_BALL_FREQ = 2.0f;
	string DEATH_SCRIPT = "monsters/horror";
	string NPC_DEATH_MSG = "You have slain one of Voldar's shamans";

	// Variables (an unset .script variable reads as its own name)
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	bool DELAY_SOUND = false;
	bool DID_WARCRY = false;
	bool FIRE_BALL_DELAY = false;
	bool SWIPE_SOUNDS = false;
	bool I_R_GLOWING = false;
	string MY_LIGHT_SCRIPT = "MY_LIGHT_SCRIPT";

	// unnamed block (first think)
	void Voldarshaman_FirstThink()
	{
		DROP_GOLD = 1; // Gold Drop
		DROP_GOLD_AMT = RandomInt(15, 30);
		NPC_GIVE_EXP = 100.0f;

		ANIM_ATTACK = "swordswing1_L"; // Attack animation
		FLINCH_CHANCE = "45%";
		MOVE_RANGE = "256";
		ATTACK_RANGE = 5500.0f;
	}

	// orc_spawn
	void Voldarshaman_OnOrcSpawn()
	{
		SetProp(ENT_ME, "skin", 3);

		SetHealth(220);
		// ov 180
		SetName("Voldar's Shamans");
		SetHearingSensitivity(8);
		SetStat("parry", 30);
		SetDamageTaken("all", 0.8f);
		SetDamageTaken("lightning", 3);
		SetDamageTaken("acid", 0);
		SetDamageTaken("poison", 0);
		SetStat("spellcasting", 30, 30, 30, 30, 30, 30, 30);

		SetModelBody(0, 0); // Body 0=naked 1=leather 2=plate 3=green-hide
		SetModelBody(1, 4); // Head 0=cap_shorthorn 1=cap_nohorn 2=buffo_skin 3=cheif_ramhorns 4=green_hood
		SetModelBody(2, 0); // Weapon 0=fist 1=axe 2=bow_weak 3=bow_strng 4=sword 5=bloodyaxe 6=sword&sheild
	}

	// npc_selectattack
	void Voldarshaman_OnNpcSelectattack()
	{
		if (DELAY_SOUND)
			return;
		if (Truthy(LegacyFunction("cansee", "enemy", MELE_RANGE)))
			return;
		DELAY_SOUND = true;
		PlaySound(0, 10, SOUND_FIRECHARGE);
	}

	// swing_sword
	void Voldarshaman_OnSwingSword()
	{
		bool exitSub = false;

		if (Truthy(LegacyFunction("cansee", "enemy", MELE_RANGE)))
		{
			// dbg Can See NME in range
			ANIM_ATTACK = ANIM_SWIPE;
			OnSwipeAttack(EntityOf(ENT_LASTSEEN));
			exitSub = true;
		}
		if (exitSub)
			return;

		if (CanSee("enemy"))
		{
			// prevents shamman from moving closer to target than needed
			if (!Truthy(LegacyFunction("cansee", "enemy", MOVE_RANGE)))
				ANIM_ATTACK = ANIM_RUN;
			if (Truthy(LegacyFunction("cansee", "enemy", MOVE_RANGE)))
				ANIM_ATTACK = ANIM_WARCRY;
		}

		if (FIRE_BALL_DELAY)
			return;
		ANIM_ATTACK = ANIM_FIRE;
		OnThrowFireball();
	}

	// throw_fireball
	void Voldarshaman_OnThrowFireball()
	{
		if (!CanSee("enemy"))
			return;
		PlaySound(0, 10, SOUND_FIRESHOOT);
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none>
		TossProjectile("proj_acid_bolt", RelativePosition(Vector3(0, 48, 18)), "none", ATTACK_SPEED, FIRE_BALL_DAMAGE, ATTACK_CONE_OF_FIRE, "none"); // Converted to use new tossprojectile //greatguys1@FEB2022
		DELAY_SOUND = false;
	}

	// reset_fireball
	void Voldarshaman_OnResetFireball()
	{
		ANIM_ATTACK = ANIM_FIRE;
		DID_WARCRY = false;
		FIRE_BALL_DELAY = false;
	}

	// npc_death
	void Voldarshaman_OnNpcDeath()
	{
		// removeitem ent_me item_torch
		CreateNpc(DEATH_SCRIPT, RelativePosition(Vector3(0, 0, 20)), self, @EntityOf(ENT_LASTSTRUCK));
		CreateNpc("monsters/summon/npc_poison_cloud2", RelativePosition(Vector3(0, 0, 0)), self, 100, 10.0f, 1);
	}

	// swipe_attack
	void Voldarshaman_OnSwipeAttack(CBaseEntity@ enemy = null)
	{
		// dbg swipe_attack got $get(PARAM1,name)
		if (RangeTo(NPCATK_TARGET) > MELE_RANGE)
			OnThrowFireball();
		SWIPE_SOUNDS = true;
		OnNpcatkDodamage(EntityId(enemy), Text(MELE_HITRANGE), SWIPE_DAMAGE, ATTACK_ACCURACY);
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string Voldarshaman_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!SWIPE_SOUNDS)
			return result;

		if (!hit)
			PlaySound(0, 10, SOUND_MELEMISS);

		if (hit)
		{
			PlaySound(0, 10, SOUND_MELEHIT);
			ApplyEffect(target, "effects/dot_poison", RandomInt(5, 10), self, Random(10, 40));
		}

		SWIPE_SOUNDS = false;
		return result;
	}

	// npc_struck
	void Voldarshaman_OnNpcStruck(float damage = 0.0f)
	{
		if (!(RangeTo(ENT_LASTSTRUCK) < MELE_RANGE))
			return;
		ANIM_ATTACK = ANIM_SWIPE;
		OnNpcatkSettarget(EntityId(EntityOf(ENT_LASTSTRUCK)));
	}

	// npc_attack
	void Voldarshaman_OnNpcAttack()
	{
		if (ANIM_ATTACK != ANIM_WARCRY)
			return;
		if (DID_WARCRY)
			return;
		PlayRandomSound(0, 10, SOUND_WARCRY1, SOUND_WARCRY2);
		DID_WARCRY = true;
	}

	// cycle_up
	void Voldarshaman_OnCycleUp(string reason = "")
	{
		if (!I_R_GLOWING)
			OnLightOn();
	}

	// game_death
	void Voldarshaman_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		ClientEvent("remove", "all", MY_LIGHT_SCRIPT);
	}

	// light_on
	void Voldarshaman_OnLightOn()
	{
		if (I_R_GLOWING)
			return;
		I_R_GLOWING = true;
		ClientEvent("persist", "all", "dq/voldarshaman", IndexOf(ENT_ME), Vector3(0, 255, 0));
		MY_LIGHT_SCRIPT = LastClientScriptId();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseRanged_OnOrcSpawn(); // monsters/orc_base_ranged
		Voldarshaman_OnOrcSpawn();
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		OrcBaseRanged_OnNpcTargetsighted(target); // monsters/orc_base_ranged
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		OrcBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/orc_base
		Voldarshaman_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, Voldarshaman_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		Voldarshaman_OnCycleUp(reason);
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		Voldarshaman_OnNpcSelectattack();
	}

	// npc_death
	void OnNpcDeath()
	{
		OrcBase_OnNpcDeath(); // monsters/orc_base
		Voldarshaman_OnNpcDeath();
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		OrcBase_OnNpcStruck(damage); // monsters/orc_base
		Voldarshaman_OnNpcStruck(damage);
	}

	void OnSwingSword() { Voldarshaman_OnSwingSword(); } // swing_sword
	void OnThrowFireball() { Voldarshaman_OnThrowFireball(); } // throw_fireball
	void OnResetFireball() { Voldarshaman_OnResetFireball(); } // reset_fireball
	void OnSwipeAttack(CBaseEntity@ enemy = null) { Voldarshaman_OnSwipeAttack(enemy); } // swipe_attack
	void OnNpcAttack() { Voldarshaman_OnNpcAttack(); } // npc_attack
	void OnLightOn() { Voldarshaman_OnLightOn(); } // light_on

	// This file's events and timers by their .script names
	bool Voldarshaman_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "light_on") { OnLightOn(); return true; }
		if (name == "npc_attack") { OnNpcAttack(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "reset_fireball") { OnResetFireball(); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		if (name == "swipe_attack") { OnSwipeAttack(EntityParam(params, 0)); return true; }
		if (name == "throw_fireball") { OnThrowFireball(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "dq/voldarshaman"]
shared class VoldarshamanScript : OrcBaseScript, Voldarshaman, OrcBaseRanged
{
	// Variables declared by included files, with the value they start with in this script
	VoldarshamanScript()
	{
		SOUND_WARCRY1 = "monsters/orc/attack1.wav";
		NPC_DEATH_MSG = "You have slain one of Voldar's shamans";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/edwardgorey.mdl");
		Precache("monsters/orc.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Voldarshaman_FirstThink();
		OrcBaseRanged_FirstThink();
		OrcBase_FirstThink();
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
		return Voldarshaman_DispatchEvent(name, params)
			|| OrcBaseRanged_DispatchEvent(name, params)
			|| OrcBaseScript::DispatchEvent(name, params);
	}
}
