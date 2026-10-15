#pragma context server

// Converted from monsters/ghoul_lesser.script by msc_transpiler.
// Lesser Ghoul by Thothie - From Greater Ghoul
// - Fugly model - basically fast Zombie, xtra danage attack secondary
// - Differences: -stunatk <hp <size <damage

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_jumper.as"

[script "monsters/ghoul_lesser"]
class GhoulLesser : BaseMonsterNewScript, BaseJumper
{
	// Constants
	string ANIM_NPC_JUMP = "slash";
	string ANIM_LOOK = "idle_look";
	string ANIM_SLASH = "slash";
	string ANIM_CLAW = "claw";
	string RETALIATE_CHANGETARGET_CHANCE = "80";
	int FLEE_HEALTH = 25;
	string FLEE_CHANCE = "25";
	int MOVE_RAGE = 65;
	string ATTACK_ACCURACY = "80%";
	string ATTACK2_ACCURACY = "75%";
	string ATTACK_DAMAGE = "30";
	string ATTACK2_DAMAGE = "80";
	string SOUND_IDLE1 = "zombie/zo_alert10.wav";
	string SOUND_IDLE2 = "zombie/zo_alert20.wav";
	string SOUND_IDLE3 = "zombie/zo_alert30.wav";
	string SOUND_ALERT = "houndeye/he_alert1.wav";
	string SOUND_ATTACK1 = "zombie/claw_miss1.wav";
	string SOUND_ATTACK2 = "zombie/claw_miss2.wav";
	string SOUND_ATTACKHIT1 = "zombie/claw_strike1.wav";
	string SOUND_ATTACKHIT2 = "zombie/claw_strike2.wav";
	string SOUND_ATTACKHIT3 = "zombie/claw_strike3.wav";
	string SOUND_STRUCK = "debris/flesh2.wav";
	string SOUND_PAIN1 = "zombie/zo_pain2.wav";
	string SOUND_PAIN2 = "houndeye/he_pain4.wav";
	float HURT_POINT = 0.5f;
	string SOUND_TURNED1 = "ambience/the_horror1.wav";
	string SOUND_TURNED2 = "ambience/the_horror2.wav";
	string SOUND_TURNED3 = "ambience/the_horror3.wav";
	string SOUND_TURNED4 = "ambience/the_horror4.wav";
	string SOUND_HOLYPAIN1 = "zombie/zo_attack1.wav";
	string SOUND_HOLYPAIN2 = "zombie/zo_attack2.wav";
	string SOUND_STEP1 = "player/pl_dirt1.wav";
	string SOUND_STEP2 = "player/pl_dirt2.wav";
	string SOUND_STEP3 = "player/pl_dirt3.wav";
	string SOUND_STEP4 = "player/pl_dirt4.wav";
	string SOUND_NPC_JUMP = "zombie/zo_attack1.wav";
	bool I_AM_TURNABLE = true;
	float STUCK_CHECK_FREQUENCY = 2.1f;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool NPC_JUMPER = false;
	string CAN_ATTACK = "CAN_ATTACK";
	string CAN_HUNT = "CAN_HUNT";
	string HUNT_AGRO = "HUNT_AGRO";
	bool CAN_WANDER = false;
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	int ATTACK_VOLUME = 0;
	bool ALERTED_OTHERS = false;
	bool DID_ALERT = false;

	// Variables declared by included files, with the value they start with in this script
	GhoulLesser()
	{
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		SOUND_DEATH = "zombie/zo_attack2.wav";
	}

	// unnamed block (first think)
	void GhoulLesser_FirstThink()
	{
		// base anims
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_DEATH = "diesimple";
		ANIM_ATTACK = "claw"; // alternates between claw and slash
	}

	// unnamed block (first think)
	void GhoulLesser_FirstThink2()
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

		ATTACK_RANGE = 65.0f;
		ATTACK_HITRANGE = 100.0f;

		DROP_GOLD = 1;
		DROP_GOLD_MIN = 5;
		DROP_GOLD_MAX = 10;

		MONSTER_WIDTH = 32; // for anti-stuck
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string GhoulLesser_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			PlayRandomSound(Int(GetVar("CHAN_VOICE")), ATTACK_VOLUME, SOUND_ATTACK1, SOUND_ATTACK2);
		if (hit)
			PlayRandomSound(Int(GetVar("CHAN_VOICE")), ATTACK_VOLUME, SOUND_ATTACKHIT1, SOUND_ATTACKHIT2, SOUND_ATTACKHIT3);

		if (ALERTED_OTHERS)
			return result;
		// alert others to my target
		// emitsound <source entity> <origin> <volume> <duration> <type> [danger radius (only for "danger")]
		LegacyCommand("emitsound", ENT_LASTSTRUCK, OriginOf(ENT_LASTSTRUCK), 10, 10, "combat");
		ALERTED_OTHERS = true;
		return result;
	}

	// unnamed block (first think)
	// ov_up_ghoul
	void GhoulLesser_FirstThink3()
	{
		if (DID_ALERT)
			return;
		// ov 200
		CallEventOrDelay(1.0f); // ov_down_ghoul
	}

	// unnamed block (first think)
	// ov_down_ghoul
	void GhoulLesser_FirstThink4()
	{
		if (DID_ALERT)
			return;
		if (CanSee("player"))
			return;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		string mapName = ToLowerCase(MapName());
		if (Contains(mapName, "helena"))
			NO_STEP_ADJ = true;

		SetName("Ghoul");
		SetHealth(200);
		// ov 110
		SetWidth(28);
		SetHeight(48);
		SetRoam(true);
		SetRace("undead");
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetDamageTaken("holy", 4);
		SetDamageTaken("poison", 0);
		SetDamageTaken("cold", 0.25f);
		SetHearingSensitivity(8);
		SetModel("monsters/ghoul_lesser.mdl");
		NPC_GIVE_EXP = 60.0f;
		CallEventDelayed(1.0f, "look_around_ghoul");
	}

	// npcatk_targetvalidate
	// play alert sound on spotting player
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		OnAlertGhoul();
	}

	// npcatk_stopflee
	void OnNpcatkStopflee()
	{
		BaseNpcAttackNew_OnNpcatkStopflee(); // monsters/base_npc_attack_new
		if (CanSee("player"))
			return;
		OnLookAroundGhoul();
	}

	// game_reached_dest
	void OnGameReachedDest()
	{
		BaseNpcAttackNew_OnGameReachedDest(); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameReachedDest(); // monsters/base_monster_shared
		if (CanSee("player"))
			return;
		OnLookAroundGhoul();
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		DID_ALERT = false;
		OnLookAroundGhoul();
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, GhoulLesser_OnGameDodamage(hit, target, start, end, damageType, damageText));
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
		DoDamage(ENTITY_ENEMY, ATTACK_HITRANGE, ATTACK2_DAMAGE, ATTACK2_ACCURACY);
		ANIM_ATTACK = ANIM_CLAW;
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		bool exitSub = false;

		float myHealth = HealthOf(ENT_ME);
		float hurtThreshold = MaxHealthOf(ENT_ME) * HURT_POINT;

		if (int(STRUCK_BY_HOLY) != 0)
		{
			PlayRandomSound(Int(GetVar("CHAN_VOICE")), 10, SOUND_HOLYPAIN1, SOUND_HOLYPAIN2);
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

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseJumper_OnNpcatkHunt(); // monsters/base_jumper
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/ghoul_lesser.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		GhoulLesser_FirstThink();
		GhoulLesser_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		GhoulLesser_FirstThink3();
		GhoulLesser_FirstThink4();
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
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
