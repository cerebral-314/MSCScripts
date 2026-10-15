#pragma context server

// Converted from monsters/mummy_storm_pharaoh.script by msc_transpiler.
// Mummy with lightning shield, lightning breath, and zappy rod of dewm (pending)
// add glow

#include "runtime/ScriptEntity.as"
#include "converted/monsters/mummy_base.as"
#include "converted/monsters/base_lightning_shield.as"

[script "monsters/mummy_storm_pharaoh"]
class MummyStormPharaoh : MummyBaseScript, BaseLightningShield
{
	// Constants
	bool LIGHTNING_SHIELD = true;
	int LIGHTNING_SHIELD_RADIUS = 96;
	int DMG_LIGHTNING_SHIELD = 200;
	int LIGHTNING_SHIELD_REPELL_STRENGTH = 1000;
	int LIGHTNING_SHIELD_V_CENTER = 36;
	bool MUMMY_DOUBLE_CYCLE = true;
	float MUMMY_FREQ_DOUBLE_CYCLE = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	MummyStormPharaoh()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "walk1";
		ANIM_IDLE = "idle1";
		AS_STUCK_FREQ = 0.5f;
		ANIM_ATTACK_LONG = "stab";
		ATTACK_TYPE = "long";
		DMG_STEELPIPE = 300;
		DMG_STAB = 800;
		ATTACK_RANGE_LONG = 130;
		ATTACK_HITRANGE_LONG = 150;
		MUMMY_BREATH_ATTACK = true;
		MUMMY_BREATH_ATTACK_TYPE = "lightning";
		MUMMY_BREATH_DOT = 250;
		MUMMY_BREATH_ATTACK_RANGE = 400;
		MUMMY_BREATH_CONE = 15;
		MUMMY_BREATH_DURATION = 8.0f;
		MUMMY_BREATH_ATTACK_CLSCRIPT = "monsters/mummy_lightning_breath_cl";
		MUMMY_BEAM_ATTACK = true;
		DMG_PUSH_BEAM = 100.0f;
	}

	// unnamed block (first think)
	void MummyStormPharaoh_FirstThink()
	{
		// base anims
		ANIM_WALK = "walk";
		ANIM_RUN = "walk1";
		ANIM_IDLE = "idle1";

		// base stats
		NPC_GIVE_EXP = 4500.0f;
		ATTACK_RANGE = 130.0f;
		ATTACK_HITRANGE = 150.0f;
		ATTACK_MOVERANGE = 100.0f;
		ANIM_ATTACK = "stab";
		FLINCH_DAMAGE_THRESHOLD = 200.0f;

		if (ToLowerCase(MapName()) == "umulak")
			NPC_IS_BOSS = true;
	}

	// unnamed block (timer)
	void MummyStormPharaoh_Timer()
	{
		CallEventDelayed(10.1f, "MummyStormPharaoh_Timer");
		// renew light 10/secs (light is now self-removing)
		if (!IsAlive(ENT_ME))
			return;
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(128, 128, 0), 128, 10.0f);
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(128, 128, 0), 128, 10.0f);
		SetMoveSpeed(2);
		SetAnimMoveSpeed(2);
		BASE_MOVESPEED = 2.0f;
	}

	// mummy_spawn
	void OnMummySpawn()
	{
		SetName("Pharaoh of Storms");
		SetHealth(8000);

		SetDamageTaken("all", 0.5f);
		SetDamageTaken("lightning", 0);
		SetDamageTaken("holy", 0.5f); // anti-foreign magix crown ^_^

		SetModelBody(0, 1); // 0=Dark_Bandages 1=Tan_Bandages
		SetModelBody(1, 2); // 0=None 1=Priest 2=Royal 3=Warrior 4=High_Peasant
		SetModelBody(2, 6); // 0=None 1=Mace 2=Axe 3=Sword 4=Mace_Bigger 5=Magic_Sword 6=Pike 7=Pike_glowfx
		SetModelBody(3, 0); // 0=None 1=Red_Repulse 2=Weird_Confusion(hi-poly)
	}

	// ext_lshield_on
	// debuggary
	// [duration]
	void OnExtLshieldOn(float duration = 0.0f)
	{
		float shieldDuration = duration;
		if (shieldDuration == 0.0f)
			shieldDuration = 10.0f;
		OnNpcatkSuspendAi(Text(shieldDuration));
		SetRoam(false);
		OnLshieldActivate(shieldDuration);
		SetIdleAnim("crazyshit");
		SetMoveAnim("crazyshit");
		CallEventDelayed(shieldDuration, "ext_end_shield");
	}

	// ext_end_shield
	void OnExtEndShield()
	{
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_RUN);
		OnNpcatkResumeAi();
		SetRoam(true);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		MummyBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/mummy_base
		BaseLightningShield_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_lightning_shield
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		MummyBase_OnNpcatkHunt(); // monsters/mummy_base
		BaseLightningShield_OnNpcatkHunt(); // monsters/base_lightning_shield
	}

	void OnShieldDuration() {} // SHIELD_DURATION

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/mummy.mdl");
		Precache("magic/chant_loop.wav");
		Precache("magic/haunted_loop.wav");
		Precache("magic/bolt_loop.wav");
		CallEventDelayed(10.1f, "MummyStormPharaoh_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MummyStormPharaoh_FirstThink();
		MummyBase_FirstThink();
		MummyBase_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseLightningShield_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ext_end_shield") { OnExtEndShield(); return true; }
		if (name == "ext_lshield_on") { OnExtLshieldOn(Float(Param(params, 0))); return true; }
		if (name == "mummy_spawn") { OnMummySpawn(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "MummyStormPharaoh_Timer") { MummyStormPharaoh_Timer(); return true; }
		return BaseLightningShield_DispatchEvent(name, params)
			|| MummyBaseScript::DispatchEvent(name, params);
	}
}
