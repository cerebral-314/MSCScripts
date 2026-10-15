#pragma context server

// Converted from monsters/beetle_venom_giant.script by msc_transpiler.
// giant venomsack beetle
// poison aura - blinding poison breath

#include "runtime/ScriptEntity.as"
#include "converted/monsters/beetle_base.as"

[script "monsters/beetle_venom_giant"]
class BeetleVenomGiant : BeetleBaseScript
{
	// Constants
	int DOT_APOISON = 50;
	float DOT_POISON = 100.0f;
	int DOT_SLIME = 50;
	float DMG_BURST = 800.0f;
	string SOUND_SLIME = "monsters/gonome/gonome_eat.wav";
	string SOUND_SLIME_LOOP = "ambience/steamjet1.wav";
	float FREQ_SLIME = 0.0f;
	float SLIME_ATTACK_DURATION = 4.0f;
	string SOUND_POISON_BURST = "weapons/explode3.wav";

	// Variables (an unset .script variable reads as its own name)
	Vector3 SLAM_POS = Vector3();
	string STUN_TARGS = "STUN_TARGS";
	string APOISON_TARGS = "APOISON_TARGS";
	string POISON_TARGS = "POISON_TARGS";
	float NEXT_SLIME = 0.0f;
	float SPIN_ANG = 0.0f;
	bool DOING_SLIME = false;
	string SLIME_TARGETS = "SLIME_TARGETS";

	// Variables declared by included files, with the value they start with in this script
	BeetleVenomGiant()
	{
		BBET_SIZE = 2;
		BBET_CAN_FLY = false;
		BBET_CAN_LEAP = false;
		BBET_CAN_SLAM = true;
		BBET_GORE_PUSH_STR = 800;
		DMG_SLASH = 160.0f;
		DMG_GORE = 150;
		DMG_SLAM = 600;
		SOUND_ATTACK1 = "monsters/beetle/attack_double1.wav";
		SOUND_ATTACK2 = "monsters/beetle/attack_double2.wav";
		SOUND_ATTACK3 = "monsters/beetle/attack_double3.wav";
	}

	// unnamed block (first think)
	void BeetleVenomGiant_FirstThink()
	{
		NPC_GIVE_EXP = 3000.0f;

		NPC_MUST_SEE_TARGET = "0"; // likely fighting through minions
	}

	// unnamed block (timer)
	// ================ Poison Aura
	void BeetleVenomGiant_Timer()
	{
		CallEventDelayed(1.0f, "BeetleVenomGiant_Timer");
		if (!IsAlive(ENT_ME))
			return;
		APOISON_TARGS = FindInSphere("enemy", 256);
		if (APOISON_TARGS == "none")
			return;
		int count = GetTokenCount(APOISON_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnApoisonAffectTargets();
		}
	}

	// unnamed block (timer)
	void BeetleVenomGiant_Timer2()
	{
		CallEventDelayed(10.0f, "BeetleVenomGiant_Timer2");
		if (!IsAlive(ENT_ME))
			return;
		ClientEvent("new", "all", "effects/sfx_poison_aura", IndexOf(ENT_ME), 256, 10.0f);
	}

	// game_precache
	void OnGamePrecache()
	{
	}

	// game_death
	// ================ Splodie Death
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
		DoDamageEx(RelativePosition(Vector3(0, 0, 0)), 512, DMG_BURST, 0, ENT_ME, ENT_ME, "none", "poison_effect");
		ClientEvent("new", "all", "effects/sfx_poison_explode", OriginOf(ENT_ME), 512);
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
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BeetleBase_OnNpcatkHunt(); // monsters/beetle_base
		BeetleBase_OnNpcatkHunt_2(); // monsters/beetle_base
		if (NPCATK_TARGET == "unset")
			return;
		if (DOING_SLIME)
			return;
		if (!(GameTime() > NEXT_SLIME))
			return;
		OnDoSlime();
	}

	// cycle_up
	// ================ Slime attack
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		BeetleBase_OnCycleUp(reason); // monsters/beetle_base
		NEXT_SLIME = GameTime() + FREQ_SLIME;
	}

	// beetle_spawn
	void OnBeetleSpawn()
	{
		SetName("Giant Venomsack");
		SetHealth(4000);
		SetDamageTaken("all", 0.5f);
		SetDamageTaken("poison", 0.1f);
		SetModelBody(0, 1); // 0=Horned 1=Venom 2=Fire

		ClientEvent("new", "all", "effects/sfx_poison_aura", IndexOf(ENT_ME), 256, 10.0f);
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

	// apoison_affect_targets
	void OnApoisonAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(APOISON_TARGS, loopIteration));
		ApplyEffect(curTarg, "effects/dot_poison", 5.0f, self, DOT_APOISON);
	}

	// poison_affect_targets
	void OnPoisonAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(POISON_TARGS, loopIteration));
		ApplyEffect(curTarg, "effects/dot_poison", 5.0f, self, DOT_POISON);
		Vector3 targOrg = OriginOf(curTarg);
		float targAng = AnglesTo(MyOrigin(), targOrg);
		SetVelocity(curTarg, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 1000, 200)));
	}

	// do_slime
	void OnDoSlime()
	{
		OnNpcatkSuspendAi();
		OnNpcatkSuspendMovement(ANIM_SPECIAL);
		PlayAnim("critical", ANIM_SPECIAL);
		ClientEvent("new", "all", "monsters/beetle_venom_giant_cl", IndexOf(ENT_ME), SLIME_ATTACK_DURATION);
		ServerPlaySound(2, 10, SOUND_SLIME_LOOP);
		PlaySound(0, 10, SOUND_SLIME);
		SPIN_ANG = AnglesOf(ENT_ME).y;
		DOING_SLIME = true;
		OnSlimeScan();
		CallEventDelayed(SLIME_ATTACK_DURATION, "end_slime");
	}

	// end_slime
	void OnEndSlime()
	{
		DOING_SLIME = false;
		OnNpcatkResumeAi();
		OnNpcatkResumeMovement();
		PlayAnim("break");
		NEXT_SLIME = GameTime() + FREQ_SLIME;
		ServerPlaySound(2, 0, SOUND_SLIME_LOOP);
	}

	// slime_scan
	void OnSlimeScan()
	{
		if (!DOING_SLIME)
			return;
		CallEventDelayed(0.5f, "slime_scan");

		Vector3 facePos = OriginOf(ENT_ME) + RelativePosition(Vector3(0, SPIN_ANG, 0), Vector3(0, 100, 0));
		SPIN_ANG += 10.0f;
		if (SPIN_ANG > 359.0f)
			SPIN_ANG -= 359.0f;

		Vector3 slimeCenter = AttachmentPositionOf(ENT_ME, 1);
		slimeCenter += RelativePosition(Vector3(0, Float(Eval("game.monster.angles.yaw")), 0), Vector3(0, 128, 0));
		slimeCenter.z = GroundHeight(slimeCenter);
		SLIME_TARGETS = LegacyFunction("get_tsphere", "enemy", 96, slimeCenter);
		if (SLIME_TARGETS == "none")
			return;
		int count = GetTokenCount(SLIME_TARGETS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnSlimeAffectTargets();
		}
	}

	// slime_affect_targets
	void OnSlimeAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(SLIME_TARGETS, loopIteration));
		if (!(RangeTo(curTarg) < 256.0f))
			return;
		Vector3 targOrg = OriginOf(curTarg);
		if (!WithinCone2D(targOrg, MyOrigin(), MyAngles(), 10))
			return;
		Vector3 traceStart = AttachmentPositionOf(ENT_ME, 1);
		string traceEnd = Text(targOrg);
		string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		if (traceLine != traceEnd)
			return;
		ApplyEffect(curTarg, "effects/dot_poison_blind", 5.0f, self, DOT_SLIME);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnSlimeAttackDuration() {} // SLIME_ATTACK_DURATION

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/beetles_giant.mdl");
		Precache("cactusgibs.mdl");
		Precache("poison_cloud.spr");
		Precache("monsters/beetle/charge_loop1.wav");
		Precache("monsters/beetle/fly1.wav");
		Precache("ambience/steamjet1.wav");
		CallEventDelayed(Float(Eval("$randf(8.0,15.0)")), "BeetleBase_Timer");
		CallEventDelayed(1.0f, "BeetleVenomGiant_Timer");
		CallEventDelayed(10.0f, "BeetleVenomGiant_Timer2");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BeetleVenomGiant_FirstThink();
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
		if (name == "apoison_affect_targets") { OnApoisonAffectTargets(); return true; }
		if (name == "beetle_slam") { OnBeetleSlam(); return true; }
		if (name == "beetle_spawn") { OnBeetleSpawn(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_slime") { OnDoSlime(); return true; }
		if (name == "end_slime") { OnEndSlime(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "poison_affect_targets") { OnPoisonAffectTargets(); return true; }
		if (name == "slime_affect_targets") { OnSlimeAffectTargets(); return true; }
		if (name == "slime_scan") { OnSlimeScan(); return true; }
		if (name == "BeetleVenomGiant_Timer") { BeetleVenomGiant_Timer(); return true; }
		if (name == "BeetleVenomGiant_Timer2") { BeetleVenomGiant_Timer2(); return true; }
		return BeetleBaseScript::DispatchEvent(name, params);
	}
}
