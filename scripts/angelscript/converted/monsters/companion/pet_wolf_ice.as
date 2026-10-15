#pragma context server

// Converted from monsters/companion/pet_wolf_ice.script by msc_transpiler.
// Pet ice wolf by Thothie

#include "runtime/ScriptEntity.as"
#include "converted/monsters/companion/pet_wolf.as"

[script "monsters/companion/pet_wolf_ice"]
class PetWolfIce : PetWolfScript
{
	// Variables declared by included files, with the value they start with in this script
	PetWolfIce()
	{
		SUMMON_CIRCLE_INDEX = 7;
		BASE_HP = 1000;
		COMPANION_MAXHP = 8000;
		MAX_DMG = "125";
		XPDMG_MULTI = 0.02f;
		BASE_DMG = 20;
		ATTACK_HITCHANCE = "90";
		DOT_ICE = 5.0f;
		FREQ_COMBAT_HOWL = 30.0f;
	}

	// unnamed block (first think)
	void PetWolfIce_FirstThink()
	{
		COMPANION_TYPE = "wolf";
		ACT_NAME = "pet winter wolf";
		NPC_REVIVAL_SCRIPT = "monsters/companion/pet_wolf_ice"; // this is for pet ressurection crystals (future item)
	}

	// game_dodamage
	string PetWolfIce_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (MELEE_ATTACK && hit && RandomInt(1, 4) == 1 && RelationshipOf(target, ENT_ME) == "enemy" && !IsPlayer(target))
		{
			ApplyEffect(target, "effects/dot_cold", 5.0f, self, DOT_ICE);
			PlaySound(0, 10, "magic/frost_reverse.wav");
			Effect("glow", ENT_ME, Vector3(0, 75, 255), 128, 1, 1);
		}
		MELEE_ATTACK = false;
		return result;
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseCompanion_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, PetWolf_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, PetWolfIce_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseCompanion_OnNpcatkHunt(); // monsters/companion/base_companion
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseSummon_OnNpcatkHunt(); // monsters/summon/base_summon
		PetWolf_OnNpcatkHunt(); // monsters/companion/pet_wolf
		if (NPCATK_TARGET == "unset")
			return;
		if (!(RangeTo(NPCATK_TARGET) < 75.0f))
			return;
		if (!(GameTime() > NEXT_COMBAT_HOWL))
			return;
		NEXT_COMBAT_HOWL = GameTime() + FREQ_COMBAT_HOWL;
		OnDoCombatHowl();
	}

	// pet_spawn
	void OnPetSpawn()
	{
		PetWolf_OnPetSpawn(); // monsters/companion/pet_wolf

		SetName("pet winter wolf");
		SetRace("human");
		SetModel("monsters/giant_rat.mdl");
		SetModelBody(0, 3);
		SetHearingSensitivity(8);
		SetWidth(36);
		SetHeight(48);
		SetRoam(false);

		SetDamageTaken("all", 0.5f);
		SetDamageTaken("cold", 0);
		SetDamageTaken("fire", 1.5f);

		NEXT_HOWL = 0.0f;

		CatchSpeech("say_sit", "sit");
		CatchSpeech("say_speak", "speak");
	}

	// do_combat_howl
	void OnDoCombatHowl()
	{
		OnNpcatkSuspendAi("1.0");
		if (IsAlive(ENT_ME))
			PlayAnim("critical", ANIM_HOWL);
		PlayRandomSound(0, 10, SOUND_HOWL1, SOUND_HOWL2);

		ClientEvent("new", "all", "effects/sfx_ice_burst", OriginOf(ENT_ME), 128, 1, Vector3(128, 128, 255));

		FREEZE_TARGS = FindInSphere("enemy", 128);
		if (FREEZE_TARGS == "none")
			return;
		int count = GetTokenCount(FREEZE_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnFreezeTargets();
		}
	}

	// freeze_targets
	void OnFreezeTargets()
	{
		string curTarg = GetToken(FREEZE_TARGS, loopIteration);
		if (IsPlayer(curTarg)) // pets cannot be harmed by players, even in PVP, so the reverse must also hold true
			return;

		int freezeChance = 1;
		if (MaxHealthOf(ENT_ME) > 3000.0f)
			freezeChance = RandomInt(1, 2);

		if (freezeChance == 1)
			ApplyEffect(curTarg, "effects/dot_cold", 5.0f, self, DOT_ICE);
		else
			ApplyEffect(curTarg, "effects/dot_cold_freeze", 5.0f, self);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		PetWolfIce_FirstThink();
		PetWolf_FirstThink();
		BaseCompanion_FirstThink();
		BaseSummon_FirstThink();
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
		if (name == "do_combat_howl") { OnDoCombatHowl(); return true; }
		if (name == "freeze_targets") { OnFreezeTargets(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "pet_spawn") { OnPetSpawn(); return true; }
		return PetWolfScript::DispatchEvent(name, params);
	}
}
