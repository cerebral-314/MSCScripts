#pragma context server

// Converted from monsters/sorc_warrior.script by msc_transpiler.
// second weakest of the Shadahar Orc series

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_melee.as"
#include "converted/monsters/sorc_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SorcWarrior
{
	// Constants
	int DMG_THROW = 25;
	string ATTACK_ACCURACY = "80%";
	float DMG_SWORD = 0.0f;
	float DOT_THROW_SHOCK = 40.0f;
	float DOT_SHOCK = 15.0f;
	string DMG_KICK = "DMG_KICK";
	string ANIM_KICK = "kick";
	string SOUND_SHOCK1 = "debris/zap8.wav";
	string SOUND_SHOCK2 = "debris/zap3.wav";
	string SOUND_SHOCK3 = "debris/zap4.wav";
	string CHANCE_SHOCK = "10%";
	string CHANCE_KICK = "30%";
	float FREQ_KICK = 0.0f;
	float FREQ_THROW = 0.0f;
	float SORC_LRESIST = 0.65f;
	float SORC_PRESIST = 1.15f;

	// Variables (an unset .script variable reads as its own name)
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	string ANIM_SWORD = "ANIM_SWORD";
	string ANIM_AXE = "ANIM_AXE";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool ORC_JUMPER = false;
	bool KICK_DELAY = false;
	bool KICK_ATTACK = false;
	float THROW_DELAY = 0.0f;
	float AS_ATTACKING = 0.0f;
	bool THROWING_AXE = false;
	string MY_AXE = "MY_AXE";

	// unnamed block (first think)
	void SorcWarrior_FirstThink()
	{
		DROP_GOLD = 1; // Gold Drops
		DROP_GOLD_AMT = RandomInt(20, 80);
		NPC_GIVE_EXP = 300.0f;

		ANIM_SWORD = "swordswing1_L"; // Attack animation 1
		ANIM_AXE = "battleaxe_swing1_L"; // Attack animation 2
		FLINCH_CHANCE = "25%";

		ANIM_ATTACK = "battleaxe_swing1_L";

		ORC_JUMPER = true;
	}

	// orc_spawn
	void SorcWarrior_OnOrcSpawn()
	{
		SetName("Shadahar Warrior");
		SetModel("monsters/sorc.mdl");
		SetHealth(2000);
		SetDamageTaken("all", 0.7f);
		SetStat("parry", 110);

		SetWidth(32);
		SetHeight(96);

		SetModelBody(0, 2); // body: 0=bare 1=bloody_shirt 2=gold_armor 3=archer
		SetModelBody(1, 2); // head: 0=hat_horns 1=hat_spiked 2=lizardskin_horned 3=gold_Chieftain 4=lizard_cap
		SetModelBody(2, 7); // weapon: 0=unarmed 1=axe 2=bow 3=steel_bow 4=sword 5=great_axe 6=sword_sheild 8=yellow_axe 9=blooddrinker
	}

	// swing_axe
	// model event (base also calls this from model event swing_sword)
	void SorcWarrior_OnSwingAxe()
	{
		OnBaseorcYell();

		OnNpcatkDodamage(ENT_LASTSEEN, Text(ATTACK_HITRANGE), Text(DMG_SWORD), ATTACK_ACCURACY, "slash");

		if (RandomInt(1, 100) < Float(CHANCE_SHOCK) && !THROWING_AXE)
		{
			ApplyEffect(NPCATK_TARGET, "effects/dot_lightning", 3, self, DOT_SHOCK);
			PlayRandomSound(0, 10, SOUND_SHOCK1, SOUND_SHOCK2, SOUND_SHOCK3);
			DebugPrint("temp me glow");
			Effect("glow", ENT_ME, Vector3(255, 255, 0), 128, 1, 1);
		}

		if (RandomInt(1, 100) < Float(CHANCE_KICK) && !THROWING_AXE && !KICK_DELAY)
		{
			KICK_DELAY = true;
			CallEventDelayed(FREQ_KICK, "reset_kick_delay");
			ANIM_ATTACK = ANIM_KICK;
		}

		if (!THROWING_AXE)
			return;
		SetAnimFrameRate(0.00001f);
	}

	// reset_kick_delay
	void SorcWarrior_OnResetKickDelay()
	{
		KICK_DELAY = false;
	}

	// kick_land
	// model vent
	void SorcWarrior_OnKickLand()
	{
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), DMG_KICK, ATTACK_ACCURACY, "blunt");
		KICK_ATTACK = true;
		ANIM_ATTACK = ANIM_AXE;
	}

	// npc_targetsighted
	void SorcWarrior_OnNpcTargetsighted(string target = "")
	{
		if (I_R_FROZEN)
			return;
		if (int(THROW_DELAY) != 0)
			return;
		if (!(RangeTo(NPCATK_TARGET) > ATTACK_RANGE))
			return;

		THROW_DELAY = 1.0f;
		OnThrowAxe();
	}

	// reset_throw_delay
	void SorcWarrior_OnResetThrowDelay()
	{
		THROW_DELAY = 0.0f;
	}

	// throw_axe
	void SorcWarrior_OnThrowAxe()
	{
		AS_ATTACKING = GameTime();
		THROWING_AXE = true;
		OnNpcatkSuspendAi();
		SetIdleAnim(ANIM_SWORD);
		SetMoveAnim(ANIM_SWORD);
		SetRoam(false);
		PlayAnim("break");
		PlayAnim("hold", ANIM_SWORD);
		CallEventDelayed(0.5f, "throw_axe2");
	}

	// throw_axe2
	void SorcWarrior_OnThrowAxe2()
	{
		SetModelBody(2, 0);
		Vector3 targDest = OriginOf(NPCATK_TARGET);
		targDest += RelativePosition(Vector3(0, Float(Eval("game.monster.angles.yaw")), 0), Vector3(0, 128, 0));
		if (!IsPlayer(NPCATK_TARGET))
			targDest.z += HeightOf(NPCATK_TARGET);
		CreateNpc("monsters/summon/sorc_axe", RelativePosition(Vector3(0, 40, 5)), self, targDest, DMG_THROW);
		MY_AXE = EntityId(EntityOf(ENT_LASTCREATED));
		OnThrowAxeLoop();
	}

	// throw_axe_loop
	void SorcWarrior_OnThrowAxeLoop()
	{
		if (!THROWING_AXE)
			return;
		SetMoveDest(MY_AXE, 9999);
		CallEventDelayed(0.1f, "throw_axe_loop");
	}

	// catch_axe
	// called extermally from bludgeon_axe upon return
	void SorcWarrior_OnCatchAxe()
	{
		OnNpcatkResumeAi();
		PlayAnim("break");
		SetRoam(true);
		THROWING_AXE = false;
		SetModelBody(2, 7);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_RUN);
		CallEventDelayed(FREQ_THROW, "reset_throw_delay");
		SetAnimFrameRate(1);
	}

	// game_dodamage
	string SorcWarrior_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (KICK_ATTACK)
		{
			KICK_ATTACK = false;
			if (hit)
			{
				AddVelocity(target, RelativeVelocity(Vector3(0, 200, 30)));
				int noAtk = RandomInt(0, 1);
				ApplyEffect(target, "effects/debuff_stun", RandomInt(2, 5), self);
			}
		}

		if (!THROWING_AXE)
			return result;
		CallExternal(MY_AXE, "do_shock", @target, DOT_THROW_SHOCK);
		return result;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseMelee_OnOrcSpawn(); // monsters/orc_base_melee
		SorcWarrior_OnOrcSpawn();
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		OrcBaseMelee_OnNpcatkTargetvalidate(target); // monsters/orc_base_melee
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		SorcBase_OnNpcatkTargetvalidate(target); // monsters/sorc_base
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		OrcBaseMelee_OnMyTargetDied(offender); // monsters/orc_base_melee
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, SorcWarrior_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		SorcBase_OnNpcTargetsighted(target); // monsters/sorc_base
		SorcWarrior_OnNpcTargetsighted(target);
	}

	void OnBaseorcYell() { SorcBase_OnBaseorcYell(); } // baseorc_yell
	void OnSwingAxe() { SorcWarrior_OnSwingAxe(); } // swing_axe
	void OnResetKickDelay() { SorcWarrior_OnResetKickDelay(); } // reset_kick_delay
	void OnKickLand() { SorcWarrior_OnKickLand(); } // kick_land
	void OnResetThrowDelay() { SorcWarrior_OnResetThrowDelay(); } // reset_throw_delay
	void OnThrowAxe() { SorcWarrior_OnThrowAxe(); } // throw_axe
	void OnThrowAxe2() { SorcWarrior_OnThrowAxe2(); } // throw_axe2
	void OnThrowAxeLoop() { SorcWarrior_OnThrowAxeLoop(); } // throw_axe_loop
	void OnCatchAxe() { SorcWarrior_OnCatchAxe(); } // catch_axe
	void OnFreqKick() {} // FREQ_KICK
	void OnFreqThrow() {} // FREQ_THROW

	// This file's events and timers by their .script names
	bool SorcWarrior_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "catch_axe") { OnCatchAxe(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "kick_land") { OnKickLand(); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "reset_kick_delay") { OnResetKickDelay(); return true; }
		if (name == "reset_throw_delay") { OnResetThrowDelay(); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		if (name == "throw_axe") { OnThrowAxe(); return true; }
		if (name == "throw_axe2") { OnThrowAxe2(); return true; }
		if (name == "throw_axe_loop") { OnThrowAxeLoop(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/sorc_warrior"]
shared class SorcWarriorScript : SorcBaseScript, SorcWarrior, OrcBaseMelee
{
	// Variables every script that includes this file declares
	bool AM_HUMILIATED = false;
	bool BFSORC_DID_TELE = false;
	bool BFSORC_GOING_TELE = false;
	bool BFSORC_MOVE_TELE = false;
	bool CHAT_ABORT = false;
	string CHAT_ANIMS_ANAME = "CHAT_ANIMS_ANAME";
	bool CHAT_AUTO_FACE = false;
	bool CHAT_AUTO_HAIL = false;
	bool CHAT_AUTO_JOB = false;
	bool CHAT_AUTO_RUMOR = false;
	bool CHAT_BUSY = false;
	string CHAT_CONV_ANIMS = "CHAT_CONV_ANIMS";
	string CHAT_CURRENT_SPEAKER = "CHAT_CURRENT_SPEAKER";
	float CHAT_DELAY = 0.0f;
	string CHAT_DELAYS_ANAME = "CHAT_DELAYS_ANAME";
	float CHAT_END_MOVE_MOUTH = 0.0f;
	float CHAT_END_TIME = 0.0f;
	string CHAT_EVENTS_ANAME = "CHAT_EVENTS_ANAME";
	bool CHAT_FACE_ON_USE = false;
	bool CHAT_IGNORE_WHILE_BUSY = false;
	CBasePlayer@ CHAT_LAST_USED_MENU = null;
	string CHAT_LINES_ANAME = "CHAT_LINES_ANAME";
	int CHAT_MAX_LINE_LEN = 0;
	bool CHAT_MENU_ENABLE = false;
	bool CHAT_MENU_ON = false;
	bool CHAT_MOVE_MOUTH = false;
	bool CHAT_NEVER_INTERRUPT = false;
	bool CHAT_NO_CLOSE_MOUTH = false;
	string CHAT_PLAYANIM_STYLE = "CHAT_PLAYANIM_STYLE";
	bool CHAT_QUE_ACTIVE = false;
	bool CHAT_RESET_ON_NEW = false;
	string CHAT_SEQUENCE = "CHAT_SEQUENCE";
	string CHAT_SOUNDS_ANAME = "CHAT_SOUNDS_ANAME";
	float CHAT_SPOOL_OUT_ALL_COUNT = 0.0f;
	float CHAT_SPOOL_OUT_COUNT = 0.0f;
	bool CHAT_USE_BUSY_MESSAGE = false;
	bool CHAT_USE_CONV_ANIMS = false;
	bool DID_ASHINKAHR = false;
	string DUMP_CONVO = "DUMP_CONVO";
	int FOLLOW_PLR_DIST = 0;
	string FOLLOW_PLR_ID = "FOLLOW_PLR_ID";
	string FPLAYER_LIST = "FPLAYER_LIST";
	float FSORC_DMG_POINTS = 0.0f;
	bool FSORC_DMG_REQ = false;
	bool FSORC_HIT_BY_BOSS = false;
	bool FSORC_ON = false;
	float FSORC_TELE_HOME_DELAY = 0.0f;
	float F_AS_UNSTUCK_ANG = 0.0f;
	float F_STUCK_COUNT = 0.0f;
	bool GAVE_REWARD = false;
	bool HAS_BASE_CHAT_ARRAY_INCLUDE = false;
	float NEXT_FAS_CHECK = 0.0f;
	float NEXT_FOLLOW_CHECK = 0.0f;
	float NEXT_REGEN = 0.0f;
	float NEXT_TEAM_ALERT = 0.0f;
	bool NPC_BATTLE_ALLY = false;
	bool NPC_EXTRA_VALIDATIONS = false;
	int OLD_DIST = 0;
	bool REWARD_MODE = false;
	CBaseEntity@ SBOSS_ID = null;
	Vector3 SBOSS_ORG = Vector3();
	bool SETUP_QUALIFICATIONS = false;
	float TC_AVG_DMG_PTS = 0.0f;
	float TC_HALF_AVG_DMG_PTS = 0.0f;
	bool TC_QUAL_PLAYERS = false;
	Vector3 TO_SBOSS_TELE_POINT = Vector3();
	CBaseEntity@ T_LEADER_ID = null;
	CBaseEntity@ T_SECOND_ID = null;
	CBaseEntity@ T_SHAMAN_ID = null;
	bool USER_QUALIFIES = false;
	bool WAIT_MODE = false;
	Vector3 WAIT_POINT = Vector3();
	CBaseEntity@ ZOMBIE_ID = null;

	// Variables declared by included files, with the value they start with in this script
	SorcWarriorScript()
	{
		SORC_LRESIST = 0.65f;
		SORC_PRESIST = 1.15f;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/sorc.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SorcWarrior_FirstThink();
		OrcBaseMelee_FirstThink();
		SorcBase_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		SorcBase_FirstThink2();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return SorcWarrior_DispatchEvent(name, params)
			|| OrcBaseMelee_DispatchEvent(name, params)
			|| SorcBaseScript::DispatchEvent(name, params);
	}
}
