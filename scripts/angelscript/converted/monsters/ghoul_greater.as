#pragma context server

// Converted from monsters/ghoul_greater.script by msc_transpiler.
// Ghoul by Thothie - From scratch
// - Fugly model - basically fast Zombie, stun/drunk attack secondary
// - Raised gold reward - came out a lil meaner than intended

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"
#include "converted/monsters/base_jumper.as"

[script "monsters/ghoul_greater"]
class GhoulGreater : BaseMonsterScript, BaseJumper
{
	// Constants
	string ANIM_NPC_JUMP = "slash";
	string ANIM_LOOK = "idle_look";
	string ANIM_SLASH = "slash";
	string ANIM_CLAW = "claw";
	string RETALIATE_CHANGETARGET_CHANCE = "80";
	int FLEE_HEALTH = 25;
	string FLEE_CHANCE = "25";
	int MOVE_RAGE = 55;
	string ATTACK_ACCURACY = "80%";
	string ATTACK2_ACCURACY = "90%";
	string ATTACK_DAMAGE = "80";
	string SOUND_IDLE1 = "zombie/zo_alert10.wav";
	string SOUND_IDLE2 = "zombie/zo_alert20.wav";
	string SOUND_IDLE3 = "zombie/zo_alert30.wav";
	string SOUND_ALERT = "zombie/zo_attack1.wav";
	string SOUND_ATTACK1 = "zombie/claw_miss1.wav";
	string SOUND_ATTACK2 = "zombie/claw_miss2.wav";
	string SOUND_ATTACKHIT1 = "zombie/claw_strike1.wav";
	string SOUND_ATTACKHIT2 = "zombie/claw_strike2.wav";
	string SOUND_ATTACKHIT3 = "zombie/claw_strike3.wav";
	string SOUND_STRUCK = "debris/flesh2.wav";
	string SOUND_PAIN1 = "zombie/zo_pain2.wav";
	string SOUND_PAIN2 = "zombie/zo_idle3.wav";
	string SOUND_TURNED1 = "ambience/the_horror1.wav";
	string SOUND_TURNED2 = "ambience/the_horror2.wav";
	string SOUND_TURNED3 = "ambience/the_horror3.wav";
	string SOUND_TURNED4 = "ambience/the_horror4.wav";
	string SOUND_HOLYPAIN1 = "agrunt/ag_pain2.wav";
	string SOUND_HOLYPAIN2 = "agrunt/ag_pain3.wav";
	string SOUND_HOLYPAIN3 = "agrunt/ag_pain4.wav";
	string SOUND_STEP1 = "player/pl_dirt1.wav";
	string SOUND_STEP2 = "player/pl_dirt2.wav";
	string SOUND_STEP3 = "player/pl_dirt3.wav";
	string SOUND_STEP4 = "player/pl_dirt4.wav";
	string SOUND_NPC_JUMP = "zombie/zo_attack1.wav";
	bool I_AM_TURNABLE = false;
	float STUCK_CHECK_FREQUENCY = 1.1f;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool NPC_JUMPER = false;
	bool CAN_WANDER = false;
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	int ATTACK_VOLUME = 0;
	bool ALERTED_OTHERS = false;
	bool DID_ALERT = false;

	// Variables declared by included files, with the value they start with in this script
	GhoulGreater()
	{
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		SOUND_DEATH = "bullchicken/bc_die1.wav";
	}

	// unnamed block (first think)
	void GhoulGreater_FirstThink()
	{
		// base anims
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_DEATH = "diesimple";
		ANIM_ATTACK = "claw"; // alternates between claw and slash
	}

	// unnamed block (first think)
	void GhoulGreater_FirstThink2()
	{
		if (ToLowerCase(MapName()) == "the_wall")
			NPC_JUMPER = true;
		if (ToLowerCase(MapName()) == "walltest")
			NPC_JUMPER = true;

		CAN_ATTACK = "1";
		CAN_HUNT = "1";
		HUNT_AGRO = "1";
		CAN_HEAR = "1";
		CAN_WANDER = true;

		CAN_RETALIATE = "1";

		CAN_FLINCH = "0";

		CAN_FLEE = "1";
		FLEE_DISTANCE = "2048";

		ATTACK_RANGE = 125.0f;
		ATTACK_HITRANGE = 200.0f;

		DROP_GOLD = 1;
		DROP_GOLD_MIN = 50;
		DROP_GOLD_MAX = 75;

		MONSTER_WIDTH = 32; // for anti-stuck
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string GhoulGreater_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			PlayRandomSound(Int(GetVar("CHAN_VOICE")), ATTACK_VOLUME, SOUND_ATTACK1, SOUND_ATTACK2);
		if (hit)
			PlayRandomSound(Int(GetVar("CHAN_VOICE")), ATTACK_VOLUME, SOUND_ATTACKHIT1, SOUND_ATTACKHIT2, SOUND_ATTACKHIT3);

		if (ALERTED_OTHERS)
			return result;
		// alert others to my target
		LegacyCommand("emitsound", ENT_LASTSTRUCK, OriginOf(ENT_LASTSTRUCK), 10, 10, "combat");
		ALERTED_OTHERS = true;
		return result;
	}

	// unnamed block (first think)
	// ov_up_ghoul
	void GhoulGreater_FirstThink3()
	{
		// ov 200
		CallEventOrDelay(1.0f); // ov_down_ghoul
	}

	// unnamed block (first think)
	// ov_down_ghoul
	void GhoulGreater_FirstThink4()
	{
		if (CanSee("player"))
			return;
	}

	// game_reached_dest
	void OnGameReachedDest()
	{
		BaseNpcAttack_OnGameReachedDest(); // monsters/base_npc_attack
		BaseMonsterShared_OnGameReachedDest(); // monsters/base_monster_shared
		if (CanSee("player"))
			return;
		OnLookAroundGhoul();
	}

	// npcatk_stopflee
	void OnNpcatkStopflee()
	{
		BaseNpcAttack_OnNpcatkStopflee(); // monsters/base_npc_attack
		if (CanSee("player"))
			return;
		OnLookAroundGhoul();
	}

	// npcatk_targetvalidate
	// play alert sound on spotting player
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttack_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack
		OnAlertGhoul();
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttack_OnMyTargetDied(offender); // monsters/base_npc_attack
		DID_ALERT = false;
		OnLookAroundGhoul();
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Greater Ghoul");
		SetHealth(450); // hi HP, no armor
		// ov 110
		SetWidth(32);
		SetHeight(72);
		SetRoam(true);
		SetRace("undead");
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetDamageTaken("holy", 1);
		SetDamageTaken("cold", 0.25f);
		SetDamageTaken("poison", 0);
		SetHearingSensitivity(8);
		SetModel("monsters/ghoul_greater.mdl");
		NPC_GIVE_EXP = 120.0f;
		CallEventDelayed(1.0f, "look_around_ghoul");
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, GhoulGreater_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// attack1
	// called by modelanim claw @frames 11 & 22
	void OnAttack1()
	{
		STUCK_COUNT = 0.0f;
		ATTACK_VOLUME = 5;
		DoDamage(ENTITY_ENEMY, ATTACK_HITRANGE, ATTACK_DAMAGE, ATTACK_ACCURACY);
		if (RandomInt(1, 20) == 1)
			ANIM_ATTACK = ANIM_SLASH;
	}

	// attack2
	// called by modelanim slash @frame 11
	void OnAttack2()
	{
		STUCK_COUNT = 0.0f;
		ATTACK_VOLUME = 10;
		DoDamage(ENTITY_ENEMY, ATTACK_HITRANGE, ATTACK_DAMAGE, ATTACK2_ACCURACY);
		ANIM_ATTACK = ANIM_CLAW;

		if (!(RangeTo(ENT_LASTSTRUCKBYME) <= ATTACK_HITRANGE))
			return;
		ApplyEffect(EntityOf(ENT_LASTSTRUCKBYME), "effects/debuff_stun", RandomInt(2, 8), self);
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		bool exitSub = false;

		float myHealth = HealthOf(ENT_ME);
		float hurtThreshold = MaxHealthOf(ENT_ME) * 0.25f;

		if (int(STRUCK_BY_HOLY) != 0)
		{
			PlayRandomSound(Int(GetVar("CHAN_VOICE")), 10, SOUND_HOLYPAIN1, SOUND_HOLYPAIN2, SOUND_HOLYPAIN3);
			STRUCK_BY_HOLY = 0.0f;
			exitSub = true;
		}
		if (exitSub)
			return;

		if (myHealth > hurtThreshold)
			PlayRandomSound(Int(GetVar("CHAN_VOICE")), 8, SOUND_STRUCK, SOUND_STRUCK, SOUND_PAIN1);
		if (myHealth <= hurtThreshold)
			PlayRandomSound(Int(GetVar("CHAN_VOICE")), 8, SOUND_STRUCK, SOUND_STRUCK, SOUND_PAIN2);
	}

	// run_step
	// called by modelanim run @frames 5 and 17
	void OnRunStep()
	{
		PlayRandomSound(Int(GetVar("CHAN_VOICE")), 10, SOUND_STEP1, SOUND_STEP2, SOUND_STEP3, SOUND_STEP4);
	}

	// basenpcatk_target_lost
	// ghoul looks around on the following external calls
	void OnBasenpcatkTargetLost()
	{
		OnLookAroundGhoul();
	}

	// give_up_advanced
	void OnGiveUpAdvanced()
	{
		OnLookAroundGhoul();
	}

	// look_around_ghoul
	// look around temporarily increases FOV
	void OnLookAroundGhoul()
	{
		if (CanSee("player"))
			return;
		PlayAnim("once", ANIM_LOOK);
		PlayRandomSound(Int(GetVar("CHAN_VOICE")), 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3);
		CallEventOrDelay(1.0f); // ov_up_ghoul
	}

	// alert_ghoul
	void OnAlertGhoul()
	{
		if (DID_ALERT)
			return;
		if (!CanSee("player")) // play alert sound for players only
			return;
		PlaySound(Int(GetVar("CHAN_VOICE")), 10, SOUND_ALERT);
		DID_ALERT = true;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttack_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseJumper_OnNpcatkHunt(); // monsters/base_jumper
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/ghoul_greater.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		GhoulGreater_FirstThink();
		GhoulGreater_FirstThink2();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
		GhoulGreater_FirstThink3();
		GhoulGreater_FirstThink4();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "alert_ghoul") { OnAlertGhoul(); return true; }
		if (name == "attack1") { OnAttack1(); return true; }
		if (name == "attack2") { OnAttack2(); return true; }
		if (name == "basenpcatk_target_lost") { OnBasenpcatkTargetLost(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_reached_dest") { OnGameReachedDest(); return true; }
		if (name == "give_up_advanced") { OnGiveUpAdvanced(); return true; }
		if (name == "look_around_ghoul") { OnLookAroundGhoul(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npcatk_stopflee") { OnNpcatkStopflee(); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "run_step") { OnRunStep(); return true; }
		return BaseJumper_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
