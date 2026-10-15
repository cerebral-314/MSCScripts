#pragma context server

// Converted from monsters/summon/fangtooth.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/giant_rat.as"

[script "monsters/summon/fangtooth"]
class MonstersSummonFangtooth : MonstersSummonGiantRatScript
{
	// Variables declared by included files, with the value they start with in this script
	MonstersSummonFangtooth()
	{
		SUM_SAY_COME = "*squirk!*";
		SUM_SAY_HUNT = "*squirk...*";
		SUM_SAY_GUARD = "*gasp!*";
		SUM_REPORT_SUFFIX = "..er, I mean, *squirk*!?";
	}

	// unnamed block (first think)
	void MonstersSummonFangtooth_FirstThink()
	{
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "attack";
		ANIM_DEATH = "die";
		MOVE_RANGE = "60";
		ATTACK_RANGE = 75.0f;
		ATTACK_HITRANGE = 100.0f;
		ATTACK_HITCHANCE = "90%";
		TRICK_ANIM = "attack";
	}

	// summon_spawn
	void OnSummonSpawn()
	{
		MonstersSummonRat_OnSummonSpawn(); // monsters/summon/rat
		MonstersSummonGiantRat_OnSummonSpawn(); // monsters/summon/giant_rat

		SetName("Fang Tooth");
		SetFieldOfView(359);
		SetWidth(32);
		SetHeight(20);
		SetRoam(true);
		SetHearingSensitivity(6);
		SetSkillLevel(0);
		SetRace("human");
		SetModel("monsters/giant_rat.mdl");
		SetIdleAnim("idle1");
		SetMoveAnim("run");

		PlayAnim("once", "idle1");

		SetAnimMoveSpeed(2);
		SetAnimFrameRate(2);

		BASE_FRAMERATE = "2.0";
		BASE_MOVESPEED = 2.0f;

		OnBasesummonAttackall(); // Premptive attack

		CatchSpeech("rat_standup", "stand", "shake", "trick");
		CatchSpeech("rat_rollover", "rollover", "roll over");
		CatchSpeech("rat_playdead", "play dead");
	}

	// bite_dodamage
	void OnBiteDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (RandomInt(1, 3) != 1)
			return;
		ApplyEffect(target, "effects/dot_poison", 10, self, Random(1, 10));
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MonstersSummonFangtooth_FirstThink();
		MonstersSummonGiantRat_FirstThink();
		BaseSummon_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		MonstersSummonRat_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bite_dodamage") { OnBiteDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "summon_spawn") { OnSummonSpawn(); return true; }
		return MonstersSummonGiantRatScript::DispatchEvent(name, params);
	}
}
