#pragma context server

// Converted from monsters/k_larva_black.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/k_larva.as"

[script "monsters/k_larva_black"]
class KLarvaBlack : KLarvaScript
{
	// Variables declared by included files, with the value they start with in this script
	KLarvaBlack()
	{
		NPC_BASE_EXP = "400";
		BARF_BONE = 25;
		BARF_DUR = 10;
		DOT_BARF = 50;
		ANIM_BARF = "idle2";
		SOUND_BARF = "monsters/gonome/gonome_eat.wav";
		CL_SCRIPT = "monsters/k_larva_black_cl";
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile(CL_SCRIPT);
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
		KLarva_OnNpcPostSpawn(); // monsters/k_larva
		SetDamageTaken("holy", 1);
		SetDamageTaken("poison", 0.5f);
		SetDamageTaken("cold", 0.5f);
		SetDamageTaken("fire", 1);
		SetDamageTaken("lightning", 2);
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
	}

	// larva_spawn
	void OnLarvaSpawn()
	{
		SetName("Black Kharaztorant Larva");
		SetModel("monsters/k_larva_black.mdl");
		SetHealth(1600);
		SetRace("demon");
		SetWidth(32);
		SetHeight(48);
		SetRoam(true);
		SetHearingSensitivity(6);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE);
		AM_EATING = false;

		if (DID_WARCRY)
			return;
		DID_WARCRY = true;
		PlaySound(0, 10, SOUND_WARCRY);
		PlayAnim("critical", ANIM_IDLE2);
		AS_ATTACKING = GameTime();

		if (STARTED_CYCLES)
			return;
		STARTED_CYCLES = true;
		CallEventDelayed(FREQ_BARF, "do_barf");
	}

	// do_barf
	void OnDoBarf()
	{
		if (!IsAlive(ENT_ME))
			return;
		CallEventDelayed(FREQ_BARF, "do_barf");
		if (!IsAlive(NPCATK_TARGET))
			return;
		OnNpcatkSuspendAi();
		SetRoam(false);
		SetIdleAnim(ANIM_BARF);
		SetMoveAnim(ANIM_BARF);
		PlaySound(0, 10, SOUND_BARF);
		ClientEvent("new", "all", CL_SCRIPT, IndexOf(ENT_ME), BARF_BONE);
		AM_BARFING = true;
		OnBarfScan();
		CallEventDelayed(4.0f, "stop_barfing");
	}

	// stop_barfing
	void OnStopBarfing()
	{
		AM_BARFING = false;
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetRoam(true);
		OnNpcatkResumeAi();
	}

	// barf_scan
	void OnBarfScan()
	{
		if (!AM_BARFING)
			return;
		CallEventDelayed(0.5f, "barf_scan");
		Vector3 barfCenter = BonePositionOf(ENT_ME, BARF_BONE);
		barfCenter += RelativePosition(Vector3(0, Float(Eval("game.monster.angles.yaw")), 0), Vector3(0, 64, 0));
		BARF_TARGETS = LegacyFunction("get_tsphere", "enemy", 96, barfCenter);
		if (BARF_TARGETS == "none")
			return;
		int count = GetTokenCount(BARF_TARGETS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnZapTargs();
		}
	}

	// zap_targs
	void OnZapTargs()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(BARF_TARGETS, loopIteration));
		if (!(RangeTo(curTarg) < 96.0f))
			return;
		ApplyEffect(curTarg, "effects/dot_poison_blind", BARF_DUR, self, DOT_BARF);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreqBarf() {} // FREQ_BARF

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/k_larva_black.mdl");
		CallEventDelayed(FREQ_IDLE, "KLarva_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "barf_scan") { OnBarfScan(); return true; }
		if (name == "do_barf") { OnDoBarf(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "larva_spawn") { OnLarvaSpawn(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "stop_barfing") { OnStopBarfing(); return true; }
		if (name == "zap_targs") { OnZapTargs(); return true; }
		return KLarvaScript::DispatchEvent(name, params);
	}
}
