#pragma context server

// Converted from monsters/beetle_horned_giant.script by msc_transpiler.
// weekest of the giant beetles

#include "runtime/ScriptEntity.as"
#include "converted/monsters/beetle_base.as"

[script "monsters/beetle_horned_giant"]
class BeetleHornedGiant : BeetleBaseScript
{
	// Variables (an unset .script variable reads as its own name)
	Vector3 SLAM_POS = Vector3();
	string STUN_TARGS = "STUN_TARGS";

	// Variables declared by included files, with the value they start with in this script
	BeetleHornedGiant()
	{
		BBET_SIZE = 2;
		BBET_CAN_FLY = false;
		BBET_CAN_LEAP = false;
		BBET_CAN_SLAM = true;
		BBET_GORE_PUSH_STR = 800;
		DMG_SLASH = 80.0f;
		DMG_GORE = 100;
		DMG_SLAM = 300;
		SOUND_ATTACK1 = "monsters/beetle/attack_double1.wav";
		SOUND_ATTACK2 = "monsters/beetle/attack_double2.wav";
		SOUND_ATTACK3 = "monsters/beetle/attack_double3.wav";
	}

	// unnamed block (first think)
	void BeetleHornedGiant_FirstThink()
	{
		NPC_GIVE_EXP = 600.0f;

		NPC_MUST_SEE_TARGET = "0"; // likely fighting through minions
	}

	// game_precache
	void OnGamePrecache()
	{
	}

	// beetle_spawn
	void OnBeetleSpawn()
	{
		SetName("Giant Horned Beetle");
		SetHealth(2000);
		SetDamageTaken("all", 0.75f);
		SetModelBody(0, 0); // 0=Horned 1=Venom 2=Fire
	}

	// beetle_slam
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

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/beetles_giant.mdl");
		Precache("monsters/beetle/charge_loop1.wav");
		Precache("monsters/beetle/fly1.wav");
		CallEventDelayed(Float(Eval("$randf(8.0,15.0)")), "BeetleBase_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BeetleHornedGiant_FirstThink();
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
		if (name == "game_precache") { OnGamePrecache(); return true; }
		return BeetleBaseScript::DispatchEvent(name, params);
	}
}
