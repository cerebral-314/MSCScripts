#pragma context server

// Converted from monsters/boar_lava3.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/boar_base_remake.as"

[script "monsters/boar_lava3"]
class BoarLava3 : BoarBaseRemakeScript
{
	// Constants
	float DOT_FIRE = 75.0f;

	// Variables (an unset .script variable reads as its own name)
	string BURST_TARGS = "BURST_TARGS";

	// Variables declared by included files, with the value they start with in this script
	BoarLava3()
	{
		BOAR_SIZE = 3;
		BOAR_SKIN = 2;
		BOAR_MODEL = "monsters/boar3.mdl";
		ATTACK_HITCHANCE = "70%";
		SOUND_STRUCK1 = "weapons/axemetal1.wav";
		SOUND_STRUCK2 = "weapons/axemetal2.wav";
		SOUND_STRUCK3 = "debris/concrete1.wav";
		CL_CHARGE_SCRIPT = "monsters/boar_lava_cl";
	}

	// unnamed block (first think)
	void BoarLava3_FirstThink()
	{
		NPC_GIVE_EXP = 1000.0f;

		FLEE_CHANCE = "10%";
	}

	// game_precache
	void BoarLava3_OnGamePrecache()
	{
	}

	// game_dodamage
	string BoarLava3_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!(RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE))
			return result;
		ApplyEffect(NPCATK_TARGET, "effects/dot_fire", 5.0f, self, DOT_FIRE);
		return result;
	}

	// game_precache
	void OnGamePrecache()
	{
		BoarLava3_OnGamePrecache();
		BoarBaseRemake_OnGamePrecache(); // monsters/boar_base_remake
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
		// this is set in the base too (on spawn), so must reset here
		DROP_ITEM1_CHANCE = "0%";
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BoarLava3_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// boar_charge_sequence
	void OnBoarChargeSequence()
	{
		BoarBaseRemake_OnBoarChargeSequence(); // monsters/boar_base_remake
		Vector3 burstOrg = OriginOf(ENT_ME);
		burstOrg += RelativePosition(Vector3(0, Float(Eval("game.monster.angles.yaw")), 0), Vector3(0, -50, 0));
		ClientEvent("new", "all", "effects/sfx_fire_burst", burstOrg, 196, 1, Vector3(255, 128, 0));
		BURST_TARGS = LegacyFunction("get_tsphere", "enemy", 196, burstOrg);
		if (BURST_TARGS == "none")
			return;
		int count = GetTokenCount(BURST_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBurstAffectTargets();
			if (breakLoop)
			{
				breakLoop = false;
				break;
			}
		}
	}

	// boar_spawn
	void OnBoarSpawn()
	{
		SetName("Great Lava Boar");
		SetRace("demon");
		SetHealth(3000);
		SetHearingSensitivity(4);
		SetRoam(true);
		SetDamageTaken("all", 0.5f);
		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 1.5f);
		SetDamageTaken("pierce", 0.5f);
		SetDamageTaken("holy", 0.5f); // some magic used in creation
	}

	// burst_affect_targets
	void OnBurstAffectTargets()
	{
		string curTarg = GetToken(BURST_TARGS, loopIteration);
		ApplyEffect(curTarg, "effects/dot_fire", 5.0f, self, DOT_FIRE);
		Vector3 targOrg = OriginOf(curTarg);
		Vector3 myOrg = OriginOf(ENT_ME);
		float newYaw = AnglesTo(myOrg, targOrg);

		AddVelocity(curTarg, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 2000, 400)));
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("fire1_fixed2.spr");
		Precache("monsters/boar3.mdl");
		Precache("monsters/boar/hoofbeats_loop.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BoarLava3_FirstThink();
		BoarBaseRemake_FirstThink();
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
		if (name == "boar_charge_sequence") { OnBoarChargeSequence(); return true; }
		if (name == "boar_spawn") { OnBoarSpawn(); return true; }
		if (name == "burst_affect_targets") { OnBurstAffectTargets(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		return BoarBaseRemakeScript::DispatchEvent(name, params);
	}
}
