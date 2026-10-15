#pragma context server

// Converted from monsters/mummy_ice.script by msc_transpiler.
// Mummy with aura, poison breath, and long slash

#include "runtime/ScriptEntity.as"
#include "converted/monsters/mummy_base.as"

[script "monsters/mummy_ice"]
class MummyIce : MummyBaseScript
{
	// Constants
	int AURA_DOT = 25;

	// Variables declared by included files, with the value they start with in this script
	MummyIce()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "walk1";
		ANIM_IDLE = "idle1";
		AS_STUCK_FREQ = 0.5f;
		ANIM_ATTACK_SHORT = "slash";
		AURA_TYPE = 2;
		ATTACK_TYPE = "long";
		DMG_SLASH = 300.0f;
		DMG_LONGSLASH = 600;
		FREQ_MUMMY_BITE = 1.0f;
		MUMMY_BREATH_ATTACK = true;
		MUMMY_BREATH_ATTACK_TYPE = "ice";
		MUMMY_BREATH_DOT = 100;
		FREQ_MUMMY_BREATH_ATTACK = 0.0f;
		MUMMY_BREATH_CONE = 15;
		MUMMY_BREATH_DURATION = 8.0f;
		MUMMY_BREATH_ATTACK_CLSCRIPT = "monsters/mummy_ice_breath_cl";
		SOUND_BREATH_LOOP = "ambience/steamjet1.wav";
		MUMMY_MUNCHES = true;
	}

	// unnamed block (first think)
	void MummyIce_FirstThink()
	{
		// base anims
		ANIM_WALK = "walk";
		ANIM_RUN = "walk1";
		ANIM_IDLE = "idle1";

		// base stats
		NPC_GIVE_EXP = 2000.0f;
		ATTACK_RANGE = 140.0f;
		ATTACK_HITRANGE = 175.0f;
		ATTACK_MOVERANGE = 128.0f;
		ANIM_ATTACK = "longslash";
	}

	// unnamed block (timer)
	void MummyIce_Timer()
	{
		CallEventDelayed(15.1f, "MummyIce_Timer");
		// renew light 15/secs (light is now self-removing)
		if (!IsAlive(ENT_ME))
			return;
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(128, 128, 255), 128, 15.0f);
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
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(128, 128, 255), 128, 15.0f);
	}

	// mummy_spawn
	void OnMummySpawn()
	{
		SetName("Mummified Ice Lord");
		SetHealth(6000);

		SetDamageTaken("all", 0.75f);
		SetDamageTaken("cold", 0);
		SetDamageTaken("fire", 1.75f);

		SetModelBody(0, 1); // 0=Dark_Bandages 1=Tan_Bandages
		SetModelBody(1, 4); // 0=None 1=Priest 2=Royal 3=Warrior 4=High_Peasant
		SetModelBody(2, 0); // 0=None 1=Mace 2=Axe 3=Sword 4=Mace_Bigger 5=Magic_Sword 6=Pike 7=Pike_glowfx
		SetModelBody(3, 1); // 0=None 1=Red_Repulse 2=Weird_Confusion(hi-poly)

		SetProp(ENT_ME, "skin", 1); // ice aura (submodel scramble bug forced me to use a skin here)
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/mummy.mdl");
		Precache("magic/chant_loop.wav");
		Precache("magic/haunted_loop.wav");
		Precache("ambience/steamjet1.wav");
		Precache("magic/bolt_loop.wav");
		CallEventDelayed(15.1f, "MummyIce_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MummyIce_FirstThink();
		MummyBase_FirstThink();
		MummyBase_FirstThink2();
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
		if (name == "mummy_spawn") { OnMummySpawn(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "MummyIce_Timer") { MummyIce_Timer(); return true; }
		return MummyBaseScript::DispatchEvent(name, params);
	}
}
