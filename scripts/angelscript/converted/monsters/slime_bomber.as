#pragma context server

// Converted from monsters/slime_bomber.script by msc_transpiler.
// Slime Suicide Bomber by MiB
// Slime that gets in the player's face, then explodes into a nasty poison cloud.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/slime_bomber"]
class SlimeBomber : BaseMonsterNewScript
{
	// Constants
	string POISON_CLOUD = "monsters/summon/npc_poison_cloud2";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool EXPLODED = false;
	string SLIME_TARGETS = "SLIME_TARGETS";

	// Variables declared by included files, with the value they start with in this script
	SlimeBomber()
	{
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_DEATH = "die";
		SOUND_DEATH = "monsters/sludge/bio.wav";
	}

	// unnamed block (first think)
	void SlimeBomber_FirstThink()
	{
		ANIM_ATTACK = "attack";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_DEATH = "die";

		MOVE_RANGE = "64";
		ATTACK_RANGE = 64.0f;
		ATTACK_HITRANGE = 64.0f;

		NPC_GIVE_EXP = 200.0f;
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
		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SetName("Plague Spreader");
		SetRace("demon");
		SetHealth(100);
		SetWidth(40);
		SetHeight(44);
		SetModel("monsters/slime_large.mdl");
		SetModelBody(0, 0);

		SetDamageTaken("pierce", 1.5f);
		SetDamageTaken("blunt", 0.75f);
		SetDamageTaken("poison", 0.25f);
		SetDamageTaken("acid", 0.25f);
		SetDamageTaken("fire", 1.5f);
	}

	// bite1
	void OnBite1()
	{
		OnExplode();
	}

	// npc_death
	void OnNpcDeath()
	{
		OnExplode();
	}

	// explode
	void OnExplode()
	{
		int count;
		if (EXPLODED)
			return;
		EXPLODED = true;

		SLIME_TARGETS = FindInSphere(ENT_ME, 96);
		if (SLIME_TARGETS != "none")
		{
			count = GetTokenCount(SLIME_TARGETS);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnSlimeAffectTargs();
			}
		}

		Vector3 cloudPos = OriginOf(ENT_ME);
		float grndCloud = GroundHeight(cloudPos) + 24.0f;
		cloudPos.z = grndCloud;
		CreateNpc("monsters/summon/npc_poison_cloud2", cloudPos, self, RandomInt(100, 200), 60.0f, 1);
		SetOrigin(ENT_ME, Vector3(20000, 20000, 20000));
		CallEventDelayed(60.0f, "npc_suicide");
	}

	// slime_affect_targs
	void OnSlimeAffectTargs()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(SLIME_TARGETS, loopIteration));
		ApplyEffect(curTarg, "effects/dot_poison_blind", 10.0f, self, 25);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/slime_large.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SlimeBomber_FirstThink();
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
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "explode") { OnExplode(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "slime_affect_targs") { OnSlimeAffectTargs(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
