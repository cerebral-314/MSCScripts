#pragma context server

// Converted from monsters/companion/pet_wolf_shadow.script by msc_transpiler.
// Pet shadow wolf, sloppily ported from pet_wolf_ice by Thothie

#include "runtime/ScriptEntity.as"
#include "converted/monsters/companion/pet_wolf.as"

[script "monsters/companion/pet_wolf_shadow"]
class PetWolfShadow : PetWolfScript
{
	// Variables declared by included files, with the value they start with in this script
	PetWolfShadow()
	{
		SUMMON_CIRCLE_INDEX = 1;
		BASE_HP = 500;
		COMPANION_MAXHP = 6000;
		MAX_DMG = "80";
		BASE_DMG = 10;
		ATTACK_HITCHANCE = "90";
		DOT_ICE = 5.0f;
		FREQ_COMBAT_HOWL = 30.0f;
	}

	// unnamed block (first think)
	void PetWolfShadow_FirstThink()
	{
		COMPANION_TYPE = "wolf";
		ACT_NAME = "pet shadow wolf";
		NPC_REVIVAL_SCRIPT = "monsters/companion/pet_wolf_shadow"; // this is for pet ressurection crystals (future item)
	}

	// game_dodamage
	string PetWolfShadow_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (MELEE_ATTACK && hit && RandomInt(1, 4) == 1 && RelationshipOf(target, ENT_ME) == "enemy" && !IsPlayer(target))
		{
			ApplyEffect(target, "effects/dot_fire", 5.0f, self, DOT_ICE);
			PlaySound(0, 10, "ambience/steamburst1.wav");
			Effect("glow", ENT_ME, Vector3(255, 128, 64), 128, 1, 1);
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
		result = AppendResult(result, PetWolfShadow_OnGameDodamage(hit, target, start, end, damageType, damageText));
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

		SetName("pet shadow wolf");
		SetRace("human");
		SetModel("monsters/giant_rat.mdl");
		SetModelBody(0, 4);
		SetHearingSensitivity(8);
		SetWidth(36);
		SetHeight(48);
		SetRoam(false);

		SetDamageTaken("all", 0.75f);
		SetDamageTaken("cold", 1.5f);
		SetDamageTaken("fire", 0);

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

		ClientEvent("new", "all", "effects/sfx_fire_burst", OriginOf(ENT_ME), 128, 1, Vector3(128, 128, 255));

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

		ApplyEffect(curTarg, "effects/dot_fire", 5.0f, self, DOT_ICE);
		ApplyEffect(curTarg, "effects/debuff_stun", 5, self);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		PetWolfShadow_FirstThink();
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
