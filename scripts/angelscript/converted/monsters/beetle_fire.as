#pragma context server

// Converted from monsters/beetle_fire.script by msc_transpiler.
// Poisonus explosion on death

#include "runtime/ScriptEntity.as"
#include "converted/monsters/beetle_base.as"

[script "monsters/beetle_fire"]
class BeetleFire : BeetleBaseScript
{
	// Constants
	float DOT_POISON = 100.0f;
	float DMG_BURST = 400.0f;
	float FREQ_SPIT = 0.0f;
	string SOUND_POISON_BURST = "weapons/explode3.wav";

	// Variables (an unset .script variable reads as its own name)
	int FLAME_JET_DMG = 0;
	int FLAME_JET_DOT = 0;
	string POISON_TARGS = "POISON_TARGS";
	float NEXT_SPIT = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	BeetleFire()
	{
		BBET_GORE_PUSH_STR = 300;
		BBET_FAKE_DEATH = 1;
		DMG_SLASH = 80.0f;
		DMG_LEAP = 150;
	}

	// unnamed block (first think)
	void BeetleFire_FirstThink()
	{
		NPC_GIVE_EXP = 1200.0f;

		FLAME_JET_DMG = 100;
		FLAME_JET_DOT = 100;
	}

	// game_precache
	void OnGamePrecache()
	{
	}

	// game_death
	// ================ Splodie Death (from Venom Beetle)
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BeetleBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/beetle_base
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);

		PlaySound(0, 10, SOUND_POISON_BURST);
		DoDamageEx(RelativePosition(Vector3(0, 0, 0)), 256, DMG_BURST, 0, ENT_ME, ENT_ME, "none", "blunt");
		ClientEvent("new", "all", "effects/sfx_explode", OriginOf(ENT_ME), 256);
		Effect("tempent", "gibs", "cactusgibs.mdl", RelativePosition(Vector3(0, 0, 0)), 1.0f, 50, 50, 15, 2.0f);
		POISON_TARGS = FindInSphere("enemy", 256);
		PlaySound(0, 10, SOUND_POISON_BURST);
		if (POISON_TARGS == "none")
			return;
		int count = GetTokenCount(POISON_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnPoisonAffectTargets();
		}
	}

	// npcatk_hunt
	// ================ Spit Fire
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BeetleBase_OnNpcatkHunt(); // monsters/beetle_base
		BeetleBase_OnNpcatkHunt_2(); // monsters/beetle_base
		if (NPCATK_TARGET == "unset")
			return;
		if (!(RangeTo(NPCATK_TARGET) > 200.0f))
			return;
		if (!CanSee(NPCATK_TARGET))
			return;
		if (!(GameTime() > NEXT_SPIT))
			return;
		NEXT_SPIT = GameTime() + FREQ_SPIT;
		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_SPECIAL);
	}

	// beetle_spawn
	void OnBeetleSpawn()
	{
		SetName("Fire Beetle");
		SetHealth(3500);
		SetDamageTaken("fire", 0);
		SetModelBody(0, 2); // 0=Horned 1=Venom 2=Fire
	}

	// poison_affect_targets
	void OnPoisonAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(POISON_TARGS, loopIteration));
		ApplyEffect(curTarg, "effects/dot_fire", 5.0f, self, DOT_POISON);
		Vector3 targOrg = OriginOf(curTarg);
		float targAng = AnglesTo(MyOrigin(), targOrg);
		SetVelocity(curTarg, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 1000, 0)));
	}

	// frame_spell
	void OnFrameSpell()
	{
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_flame_jet", RelativePosition(Vector3(0, 64, 44)), NPCATK_TARGET, 300, "DMG_SPIT", 2, "none");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/beetles.mdl");
		Precache("cactusgibs.mdl");
		Precache("explode1.spr");
		Precache("xfireball3.spr");
		Precache("monsters/beetle/charge_loop1.wav");
		Precache("monsters/beetle/fly1.wav");
		CallEventDelayed(Float(Eval("$randf(8.0,15.0)")), "BeetleBase_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BeetleFire_FirstThink();
		BeetleBase_FirstThink();
		BeetleBase_FirstThink2();
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
		if (name == "beetle_spawn") { OnBeetleSpawn(); return true; }
		if (name == "frame_spell") { OnFrameSpell(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "poison_affect_targets") { OnPoisonAffectTargets(); return true; }
		return BeetleBaseScript::DispatchEvent(name, params);
	}
}
