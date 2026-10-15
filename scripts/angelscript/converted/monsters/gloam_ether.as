#pragma context server

// Converted from monsters/gloam_ether.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/gloam_ether"]
class GloamEther : BaseMonsterNewScript
{
	// Constants
	string ANIM_GALLOP = "gallop";
	string ANIM_JUMP = "jump";
	string ANIM_PROJECTILE = "turnright";
	string ANIM_VICTORY = "eat";
	float FREQ_SPORES = 30.0f;
	float FREQ_SPITWAD = 0.0f;
	float FREQ_CLOAK = 0.0f;
	float DUR_CLOAK = 10.0f;
	string DMG_SWIPE = "$rand(80,150)";
	float DMG_SPORE = 200.0f;
	int DMG_SPITWAD = 80;
	string SOUND_STRUCK1 = "debris/flesh1.wav";
	string SOUND_STRUCK2 = "debris/flesh2.wav";
	string SOUND_ATTACK1 = "zombie/claw_miss1.wav";
	string SOUND_ATTACK2 = "zombie/claw_miss2.wav";
	string SOUND_ATTACKHIT1 = "zombie/claw_strike1.wav";
	string SOUND_ATTACKHIT2 = "zombie/claw_strike2.wav";
	string SOUND_CLOAK = "magic/spawn.wav";
	string SOUND_PAIN1 = "aslave/slv_pain1.wav";
	string SOUND_PAIN2 = "aslave/slv_pain2.wav";
	string SOUND_SPORES = "bullchicken/bc_attack3.wav";
	string SOUND_SPITWAD = "headcrab/hc_attack1.wav";
	string SOUND_JUMP = "aslave/slv_alert3.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_FLINCH = "ANIM_FLINCH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string SPORE_POISON_DMG = "SPORE_POISON_DMG";
	bool AM_CLOAKED = false;
	string PUSH_TARG = "PUSH_TARG";
	bool CYCLES_STARTED = false;
	bool CALLED_BY_DANGER = false;
	bool SWIPE_ATTACK = false;
	bool SPIT_WADS = false;
	float NEXT_VICTORY = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	GloamEther()
	{
		NPC_BOSS_REGEN_RATE = 0.05f;
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle_1";
		SOUND_DEATH = "aslave/slv_die2.wav";
	}

	// unnamed block (first think)
	void GloamEther_FirstThink()
	{
		SetCallback("touch", "enable");

		NPC_IS_BOSS = true;

		// base anims
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle_1";
		ANIM_FLINCH = "flinchb";
		ANIM_ATTACK = "bite"; // mdl_attack
		ANIM_DEATH = "die";

		// base stats
		ATTACK_RANGE = 96.0f;
		ATTACK_HITRANGE = 128.0f;
		ATTACK_MOVERANGE = 34.0f;
		NPC_GIVE_EXP = 600.0f;
		SPORE_POISON_DMG = "50";
	}

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type
	string GloamEther_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		if (!AM_CLOAKED)
		{
			string tBox = FindInBox("players", 256);
			if (tBox != "none" && GetTokenCount(tBox) > 2)
			{
				CALLED_BY_DANGER = true;
				OnDoCloak();
			}
		}

		if (!AM_CLOAKED)
			return result;
		bool canHit = false;
		// if ( $get(PARAM1,range) < 96 ) addvelocity PARAM1 $relvel(0,400,200)
		if (damageType == "magic")
			canHit = true;
		if (damageType == "holy")
			canHit = true;
		if (damageType == "dark")
			canHit = true;
		if (canHit)
			return result;
		result = AppendResult(result, "0.0");
		return result;
	}

	// game_dodamage
	string GloamEther_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (SWIPE_ATTACK)
		{
			AddVelocity(target, RelativeVelocity(Vector3(0, 300, 110)));
			if (hit)
				PlayRandomSound(0, 10, SOUND_ATTACKHIT1, SOUND_ATTACKHIT2);
			else
				PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2);
			SWIPE_ATTACK = false;
		}
		return result;
	}

	// game_touch
	string GloamEther_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";
		if (!AM_CLOAKED)
			return result;
		if (RelationshipOf(other, ENT_ME) != "enemy")
			return result;
		PUSH_TARG = EntityId(other);
		return result;
	}

	// unnamed block (timer)
	void GloamEther_Timer()
	{
		CallEventDelayed(0.1f, "GloamEther_Timer");
		if (SPIT_WADS)
		{
			if (!IsAlive(NPCATK_TARGET))
			{
				OnEndSpitwad();
			}
			else
			{
				PlayAnim("once", "flinchs");
				SetMoveDest(NPCATK_TARGET, 9999);
			}
		}

		if (!AM_CLOAKED)
		{
			SetProp(ENT_ME, "renderamt", 255);
			SetProp(ENT_ME, "renderfx", 16);
		}

		if (!AM_CLOAKED)
			return;
		SetProp(ENT_ME, "renderamt", 0);
		if (PUSH_TARG == "unset")
			return;
		float rndRl = RandomInt(-1, 1) * 400.0f;
		AddVelocity(PUSH_TARG, RelativeVelocity(Vector3(rndRl, 800, 400))); // can't be called from game_touch
		PUSH_TARG = "unset";
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		PlayRandomSound(0, 8, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_PAIN1, SOUND_PAIN2);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Ether Gloam");

		SetModel("monsters/hunter1.mdl");
		SetRace("demon");
		SetBlood("green");
		SetHearingSensitivity(11);
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		PlayAnim("once", ANIM_IDLE);
		SetWidth(32);
		SetHeight(32);

		SetHealth(5000);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
		SetProp(ENT_ME, "renderfx", 16);
		SetDamageTaken("all", 0.6f); // ethereal damage reduct
		SetDamageTaken("poison", 0.5f);
		SetDamageTaken("cold", 0.5f);
		SetDamageTaken("fire", 0.5f);
		SetDamageTaken("holy", 1);
		SetDamageTaken("dark", 0.5f);

		AM_CLOAKED = false;

		PUSH_TARG = "unset";
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		if (!(GameTime() > NEXT_VICTORY))
			return;
		NEXT_VICTORY = GameTime() + 10.0f;
		PlayAnim("critical", ANIM_VICTORY);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, GloamEther_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		OnStartCycles();
	}

	// cycle_npc
	void OnCycleNpc(string mode = "")
	{
		BaseNpcAttackNew_OnCycleNpc(mode); // monsters/base_npc_attack_new
		OnStartCycles();
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, GloamEther_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// start_cycles
	void OnStartCycles()
	{
		if (CYCLES_STARTED)
			return;
		CYCLES_STARTED = true;
		CallEventDelayed(FREQ_CLOAK, "do_cloak");
		CallEventDelayed(FREQ_SPORES, "do_spores");
		CallEventDelayed(FREQ_SPITWAD, "do_spitwad");
	}

	// do_cloak
	void OnDoCloak()
	{
		if (!CALLED_BY_DANGER)
			CallEventDelayed(FREQ_CLOAK, "do_cloak");
		CALLED_BY_DANGER = false;
		if (SPIT_WADS)
			return;
		if (!IsAlive(ENT_LASTSTRUCK))
			return;

		ClearEffects();

		PlaySound(0, 10, SOUND_CLOAK);
		Effect("glow", ENT_ME, Vector3(128, 255, 0), 256, 1, 1);
		SetProp(ENT_ME, "renderamt", 0);
		SetProp(ENT_ME, "renderfx", 0);

		SetMoveSpeed(5);
		OnNpcatkFlee(EntityId(EntityOf(ENT_LASTSTRUCK)), "2048", Text(DUR_CLOAK));
		AM_CLOAKED = true;
		CallEventDelayed(DUR_CLOAK, "end_cloak");
	}

	// end_cloak
	void OnEndCloak()
	{
		PlaySound(0, 10, SOUND_CLOAK);
		AM_CLOAKED = false;
		Effect("glow", ENT_ME, Vector3(128, 255, 0), 256, 2, 2);
		SetProp(ENT_ME, "renderamt", 255);
		SetProp(ENT_ME, "renderfx", 16);
		SetMoveSpeed(1);
	}

	// do_spores
	void OnDoSpores()
	{
		CallEventDelayed(FREQ_SPORES, "do_spores");
		if (AM_CLOAKED)
			return;
		if (!CanSee(NPCATK_TARGET))
			return;
		PlayAnim("critical", "turnright");
		PlaySound(0, 10, SOUND_SPORES);

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_spore", RelativePosition(Vector3(-10, 0, 32)), NPCATK_TARGET, 500, DMG_SPORE, 0.1f, "none");
	}

	// mdl_attack
	void OnMdlAttack()
	{
		if (AM_CLOAKED)
			return;
		SWIPE_ATTACK = true;
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_SWIPE, "90%", "slash");
	}

	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "") { return GloamEther_OnGameTouch(other, hpRange, effectDamage); } // game_touch

	// npcatk_run
	void OnNpcatkRun()
	{
		SetMoveAnim(ANIM_RUN);
		PlayAnim("once", ANIM_GALLOP);
	}

	// do_spitwad
	void OnDoSpitwad()
	{
		CallEventDelayed(FREQ_SPITWAD, "do_spitwad");

		if (!CanSee(NPCATK_TARGET))
			return;
		if (AM_CLOAKED)
			return;

		SetMoveAnim("flinchs");
		SetIdleAnim("flinchs");
		SetRoam(false);

		OnNpcatkSuspendAi();

		SPIT_WADS = true;
		CallEventDelayed(4.0f, "end_spitwad");
	}

	// end_spitwad
	void OnEndSpitwad()
	{
		SetRoam(true);
		SPIT_WADS = false;
		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE);
		OnNpcatkResumeAi();
	}

	// mdl_attack2
	void OnMdlAttack2()
	{
		PlaySound(0, 10, SOUND_SPITWAD);

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_thorn", RelativePosition(Vector3(20, 0, 16)), NPCATK_TARGET, 600, DMG_SPITWAD, 5, "none");
	}

	// mdl_jump_boost
	void OnMdlJumpBoost()
	{
		PlaySound(0, 10, SOUND_JUMP);
		float jumpHeight = RandomInt(150, 250) + 0.0f;
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 250, jumpHeight)));
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnDurCloak() {} // DUR_CLOAK
	void OnFreqCloak() {} // FREQ_CLOAK
	void OnFreqSpitwad() {} // FREQ_SPITWAD
	void OnFreqSpores() {} // FREQ_SPORES

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/hunter1.mdl");
		CallEventDelayed(0.1f, "GloamEther_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		GloamEther_FirstThink();
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
		if (name == "cycle_npc") { OnCycleNpc(Param(params, 0)); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_cloak") { OnDoCloak(); return true; }
		if (name == "do_spitwad") { OnDoSpitwad(); return true; }
		if (name == "do_spores") { OnDoSpores(); return true; }
		if (name == "end_cloak") { OnEndCloak(); return true; }
		if (name == "end_spitwad") { OnEndSpitwad(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		if (name == "mdl_attack") { OnMdlAttack(); return true; }
		if (name == "mdl_attack2") { OnMdlAttack2(); return true; }
		if (name == "mdl_jump_boost") { OnMdlJumpBoost(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_run") { OnNpcatkRun(); return true; }
		if (name == "start_cycles") { OnStartCycles(); return true; }
		if (name == "GloamEther_Timer") { GloamEther_Timer(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
