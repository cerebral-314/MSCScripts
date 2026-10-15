#pragma context server

// Converted from monsters/horror2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/horror.as"

[script "monsters/horror2"]
class Horror2 : HorrorScript
{
	// Constants
	string NPC_BASE_EXP = "400";

	// Variables (an unset .script variable reads as its own name)
	float SPORE_CLOUD_AMMO = 0.0f;
	float SPORE_DELAY = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	Horror2()
	{
		ATTACK_DAMAGE = "200";
		SPIT_DAMAGE = 100;
		BREATH_DAMAGE_MIN = 100;
		BREATH_DAMAGE_MAX = 200;
	}

	// unnamed block (first think)
	void Horror2_FirstThink()
	{
		IS_UNHOLY = true;

		DROP_GOLD = 1;
		DROP_GOLD_MIN = 30;
		DROP_GOLD_MAX = 60;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		Horror_OnNpcSpawn(npc); // monsters/horror

		SetName("Elder Horror");
		SetHealth(1500);
		SetDamageTaken("all", 0.75f);
		SetDamageTaken("holy", 0.5f);
		SetDamageTaken("poison", 0);

		SetWidth(22);
		SetHeight(22);
		SetBoundingBox("npcsize");
		SetRoam(true);
		SetFly(true);
		I_FLY = true;
		LegacyCommand("float", 0);
		SetRace("demon");
		SetIdleAnim(ANIM_WALK);
		SetMoveAnim(ANIM_WALK);
		SetHearingSensitivity(5);
		SetModel("monsters/edwardgorey.mdl");
		SetModelBody(0, 1);
		NPC_GIVE_EXP = 400.0f;
		CallEventDelayed(1.0f, "idle_sounds");
		FLIGHT_SCANNING = true;

		SPORE_CLOUD_AMMO = 1.0f;

		// JUN2010_20, attempting to add delay to see if it stops Lodagond-4 crashes
		SPORE_DELAY = GameTime() + Random(3, 20);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		Horror_OnMyTargetDied(offender); // monsters/horror
		// reload spore cloud
		SPORE_CLOUD_AMMO = 1.0f;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (!(SPORE_CLOUD_AMMO > 0.0f))
			return;
		if (!(RangeTo(NPCATK_TARGET) > 256.0f))
			return;
		if (!(GameTime() > SPORE_DELAY))
			return;
		PlayAnim("critical", ANIM_ATTACK);
		Vector3 cloudOrigin = OriginOf(NPCATK_TARGET);
		// if ( $get(NPCATK_TARGET,isplayer) ) vectoradd CLOUD_ORIGIN z -40
		CreateNpc("monsters/summon/npc_poison_cloud2", cloudOrigin, self, 75, 20.0f, 2);
		SPORE_CLOUD_AMMO -= 1.0f;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Horror2_FirstThink();
		Horror_FirstThink();
		BaseFlyer_FirstThink();
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
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		return HorrorScript::DispatchEvent(name, params);
	}
}
