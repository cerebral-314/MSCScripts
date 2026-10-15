#pragma context server

// Converted from monsters/mummy_cursed.script by msc_transpiler.
// Mummy with aura, poison breath, and long slash

#include "runtime/ScriptEntity.as"
#include "converted/monsters/mummy_base.as"

[script "monsters/mummy_cursed"]
class MummyCursed : MummyBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	MummyCursed()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "walk1";
		ANIM_IDLE = "idle1";
		AS_STUCK_FREQ = 0.5f;
		ANIM_ATTACK_SHORT = "slash";
		AURA_TYPE = 1;
		ATTACK_TYPE = "long";
		MUMMY_BREATH_ATTACK = true;
		MUMMY_BREATH_ATTACK_RANGE = 250;
		MUMMY_BREATH_ATTACK_OFS = 125;
		FREQ_MUMMY_BREATH_ATTACK = 0.0f;
	}

	// unnamed block (first think)
	void MummyCursed_FirstThink()
	{
		// base anims
		ANIM_WALK = "walk";
		ANIM_RUN = "walk1";
		ANIM_IDLE = "idle1";

		// base stats
		NPC_GIVE_EXP = 500.0f;
		ATTACK_RANGE = 140.0f;
		ATTACK_HITRANGE = 175.0f;
		ATTACK_MOVERANGE = 128.0f;
		ANIM_ATTACK = "longslash";
	}

	// unnamed block (timer)
	void MummyCursed_Timer()
	{
		CallEventDelayed(15.1f, "MummyCursed_Timer");
		// renew light 10/secs (light is now self-removing)
		if (!IsAlive(ENT_ME))
			return;
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(255, 0, 0), 128, 15.0f);
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
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(255, 0, 0), 128, 15.0f);
	}

	// mummy_spawn
	void OnMummySpawn()
	{
		SetName("Cursed Crypt Fiend");
		SetHealth(2000);

		SetModelBody(0, 0); // 0=Dark_Bandages 1=Tan_Bandages
		SetModelBody(1, 4); // 0=None 1=Priest 2=Royal 3=Warrior 4=High_Peasant
		SetModelBody(2, 0); // 0=None 1=Mace 2=Axe 3=Sword 4=Mace_Bigger 5=Magic_Sword 6=Pike 7=Pike_glowfx
		SetModelBody(3, 1); // 0=None 1=Red_Repulse 4=Weird_Confusion(hi-poly)
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/mummy.mdl");
		Precache("magic/chant_loop.wav");
		Precache("magic/haunted_loop.wav");
		Precache("magic/bolt_loop.wav");
		CallEventDelayed(15.1f, "MummyCursed_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MummyCursed_FirstThink();
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
		if (name == "MummyCursed_Timer") { MummyCursed_Timer(); return true; }
		return MummyBaseScript::DispatchEvent(name, params);
	}
}
