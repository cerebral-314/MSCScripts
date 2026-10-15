#pragma context server

// Converted from monsters/beetle_fire_giant.script by msc_transpiler.
// Poisonus explosion on death

#include "runtime/ScriptEntity.as"
#include "converted/monsters/beetle_base.as"

[script "monsters/beetle_fire_giant"]
class BeetleFireGiant : BeetleBaseScript
{
	// Constants
	float DOT_POISON = 100.0f;
	float DMG_BURST = 2000.0f;
	float FREQ_SPIT = 0.0f;
	string SOUND_POISON_BURST = "weapons/explode3.wav";

	// Variables (an unset .script variable reads as its own name)
	int FLAME_JET_DMG = 0;
	int FLAME_JET_DOT = 0;
	Vector3 SLAM_POS = Vector3();
	string STUN_TARGS = "STUN_TARGS";
	string POISON_TARGS = "POISON_TARGS";
	float NEXT_SPIT = 0.0f;
	string SPIT_LIST = "SPIT_LIST";
	float SPIT_TARG_IDX = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	BeetleFireGiant()
	{
		BBET_SIZE = 2;
		BBET_CAN_FLY = false;
		BBET_CAN_LEAP = false;
		BBET_CAN_SLAM = true;
		BBET_GORE_PUSH_STR = 300;
		DMG_SLASH = 160.0f;
		DMG_GORE = 240;
		DMG_SLAM = 1000;
		BBET_HORN = true;
	}

	// unnamed block (first think)
	void BeetleFireGiant_FirstThink()
	{
		NPC_GIVE_EXP = 5000.0f;

		FLAME_JET_DMG = 200;
		FLAME_JET_DOT = 200;
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
		DoDamageEx(RelativePosition(Vector3(0, 0, 0)), 256, DMG_BURST, 0, ENT_ME, ENT_ME, "none", "generic");
		ClientEvent("new", "all", "effects/sfx_explode", OriginOf(ENT_ME), 512);
		Effect("tempent", "gibs", "cactusgibs.mdl", RelativePosition(Vector3(0, 0, 0)), 1.0f, 50, 50, 15, 2.0f);
		POISON_TARGS = FindInSphere("enemy", 512);
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
	// ================ Spit Fire (multi_target)
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BeetleBase_OnNpcatkHunt(); // monsters/beetle_base
		BeetleBase_OnNpcatkHunt_2(); // monsters/beetle_base
		if (NPCATK_TARGET == "unset")
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
		SetName("Giant Fire Beetle");
		SetHealth(10000);
		SetDamageTaken("all", 0.5f);
		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 1.25f);
		SetModelBody(0, 2); // 0=Horned 1=Venom 2=Fire
	}

	// beetle_slam
	// ================ Slam attack
	void OnBeetleSlam()
	{
		SLAM_POS = AttachmentPositionOf(ENT_ME, 1);
		SLAM_POS.z = GroundHeight(SLAM_POS);
		DoDamage(Text(SLAM_POS), BBET_SLAM_RADIUS, DMG_SLAM, "100%", 0, "reflective", "blunt");
		ClientEvent("new", "all", "effects/sfx_stun_burst", SLAM_POS, 256, 0);
		STUN_TARGS = LegacyFunction("get_tsphere", "enemy", 256, SLAM_POS);
		if (STUN_TARGS == "none")
			return;
		int count = GetTokenCount(STUN_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnAffectTargets();
		}
	}

	// affect_targets
	void OnAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(STUN_TARGS, loopIteration));
		if (!IsOnGround(curTarg))
			return;
		ApplyEffect(curTarg, "effects/debuff_stun", 8.0f, self);
		Vector3 targOrg = OriginOf(curTarg);
		float targAng = AnglesTo(SLAM_POS, targOrg);
		SetVelocity(curTarg, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 1000, 0)));
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
		SPIT_LIST = FindInSphere("enemy", 1024);

		if (SPIT_LIST == "none")
			return;
		SPIT_TARG_IDX = 0.0f;
		OnSpitTargets();
	}

	// spit_targets
	void OnSpitTargets()
	{
		CBaseEntity@ curSpitTarg = FindEntity(GetToken(SPIT_LIST, int(SPIT_TARG_IDX)));

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_flame_jet", RelativePosition(Vector3(0, 64, 28)), @curSpitTarg, 300, "DMG_SPIT", 2, "none");

		SPIT_TARG_IDX += 1.0f;
		float nSpitTargs = GetTokenCount(SPIT_LIST) - 1.0f;
		if (!(SPIT_TARG_IDX < nSpitTargs))
			return;
		SPIT_TARG_IDX += 1.0f;
		CallEventDelayed(0.1f, "spit_targets");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/beetles_giant.mdl");
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
		BeetleFireGiant_FirstThink();
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
		if (name == "affect_targets") { OnAffectTargets(); return true; }
		if (name == "beetle_slam") { OnBeetleSlam(); return true; }
		if (name == "beetle_spawn") { OnBeetleSpawn(); return true; }
		if (name == "frame_spell") { OnFrameSpell(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "poison_affect_targets") { OnPoisonAffectTargets(); return true; }
		if (name == "spit_targets") { OnSpitTargets(); return true; }
		return BeetleBaseScript::DispatchEvent(name, params);
	}
}
