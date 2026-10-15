#pragma context server

// Converted from monsters/gloam1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/gloam1"]
class Gloam1 : BaseMonsterNewScript
{
	// Constants
	string ANIM_GALLOP = "gallop";
	string ANIM_JUMP = "jump";
	string ANIM_PROJECTILE = "turnright";
	string ANIM_VICTORY = "eat";
	int FLEE_HEALTH = 500;
	string FLEE_CHANCE = "25";
	float FREQ_SPITWAD = 0.0f;
	float DUR_CLOAK = 10.0f;
	string DMG_SWIPE = "$rand(20,40)";
	int DMG_SPoRE = 50;
	int DMG_SPITWAD = 20;
	int JUMP_THRESHOLD = 80;
	int JUMP_RANGE = 512;
	string SOUND_STRUCK1 = "debris/flesh1.wav";
	string SOUND_STRUCK2 = "debris/flesh2.wav";
	string SOUND_ATTACK1 = "zombie/claw_miss1.wav";
	string SOUND_ATTACK2 = "zombie/claw_miss2.wav";
	string SOUND_ATTACKHIT1 = "zombie/claw_strike1.wav";
	string SOUND_ATTACKHIT2 = "zombie/claw_strike2.wav";
	string SOUND_PAIN1 = "aslave/slv_pain1.wav";
	string SOUND_PAIN2 = "aslave/slv_pain2.wav";
	string SOUND_SPITWAD = "headcrab/hc_attack1.wav";
	string SOUND_JUMP = "aslave/slv_alert3.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_FLINCH = "ANIM_FLINCH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string SPORE_POISON_DMG = "SPORE_POISON_DMG";
	bool AM_CLOAKED = false;
	string PUSH_TARG = "PUSH_TARG";
	bool CYCLES_STARTED = false;
	bool SWIPE_ATTACK = false;
	bool SPIT_WADS = false;
	float JUMP_HEIGHT_FACTOR = 0.0f;
	float NEXT_JUMP = 0.0f;
	float NEXT_VICTORY = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	Gloam1()
	{
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle_1";
		SOUND_DEATH = "aslave/slv_die2.wav";
	}

	// unnamed block (first think)
	void Gloam1_FirstThink()
	{
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
		NPC_GIVE_EXP = 250.0f;
		FLEE_TIME = 5.0f;
		SPORE_POISON_DMG = "5";
	}

	// game_dodamage
	string Gloam1_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
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

		SetName("Gloam");

		SetModel("monsters/hunter1.mdl");
		SetRace("demon");
		SetBlood("green");
		SetHearingSensitivity(11);
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		PlayAnim("once", ANIM_IDLE);
		SetWidth(32);
		SetHeight(32);

		SetHealth(1000);
		SetDamageTaken("poison", 0.5f);
		SetDamageTaken("cold", 0.5f);
		SetDamageTaken("fire", 0.5f);
		SetDamageTaken("holy", 0);

		AM_CLOAKED = false;

		PUSH_TARG = "unset";
	}

	// npcatk_flee
	void OnNpcatkFlee(string threatEntity = "", string fleeDistance = "", string fleeDuration = "")
	{
		BaseNpcAttackNew_OnNpcatkFlee(threatEntity, fleeDistance, fleeDuration); // monsters/base_npc_attack_new
		CallEventDelayed(0.1f, "flee_boost");
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
		result = AppendResult(result, Gloam1_OnGameDodamage(hit, target, start, end, damageType, damageText));
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

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared

		if (!(GameTime() > NEXT_JUMP))
			return;

		if (!(RangeTo(NPCATK_TARGET) < JUMP_RANGE))
			return;

		int myZ = Int(Eval("game.monster.origin.z"));
		float targZ = OriginOf(NPCATK_TARGET).z;
		float zDiff = targZ - myZ;
		if (RandomInt(1, 50) == 1) // force a jump once in awhile
			zDiff = 81.0f;
		if (zDiff > JUMP_THRESHOLD)
		{
			JUMP_HEIGHT_FACTOR = zDiff;
			JUMP_HEIGHT_FACTOR *= 2.0f;
			AS_ATTACKING = GameTime() + 5.0f;
			PlayAnim("critical", ANIM_JUMP);
			NEXT_JUMP = GameTime() + 2.0f;
		}
	}

	// start_cycles
	void OnStartCycles()
	{
		if (CYCLES_STARTED)
			return;
		CYCLES_STARTED = true;
		CallEventDelayed(FREQ_SPITWAD, "do_spitwad");
	}

	// mdl_attack
	void OnMdlAttack()
	{
		SWIPE_ATTACK = true;
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_SWIPE, "90%", "slash");
	}

	// spitwad_loop
	void OnSpitwadLoop()
	{
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
				CallEventDelayed(0.1f, "spitwad_loop");
			}
		}
	}

	// do_spitwad
	void OnDoSpitwad()
	{
		CallEventDelayed(FREQ_SPITWAD, "do_spitwad");

		if (!CanSee(NPCATK_TARGET))
			return;
		if (IS_FLEEING)
			return;

		SetMoveAnim("flinchs");
		SetIdleAnim("flinchs");
		SetRoam(false);

		OnNpcatkSuspendAi();

		SPIT_WADS = true;
		CallEventDelayed(4.0f, "end_spitwad");
		CallEventDelayed(0.1f, "spitwad_loop");
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
		float jumpHeight = RandomInt(250, 350) + JUMP_HEIGHT_FACTOR;
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 250, jumpHeight)));
	}

	// flee_boost
	void OnFleeBoost()
	{
		JUMP_HEIGHT_FACTOR = JUMP_THRESHOLD;
		PlayAnim("critical", ANIM_JUMP);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreqSpitwad() {} // FREQ_SPITWAD

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/hunter1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Gloam1_FirstThink();
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
		if (name == "do_spitwad") { OnDoSpitwad(); return true; }
		if (name == "end_spitwad") { OnEndSpitwad(); return true; }
		if (name == "flee_boost") { OnFleeBoost(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "mdl_attack") { OnMdlAttack(); return true; }
		if (name == "mdl_attack2") { OnMdlAttack2(); return true; }
		if (name == "mdl_jump_boost") { OnMdlJumpBoost(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_flee") { OnNpcatkFlee(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "spitwad_loop") { OnSpitwadLoop(); return true; }
		if (name == "start_cycles") { OnStartCycles(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
