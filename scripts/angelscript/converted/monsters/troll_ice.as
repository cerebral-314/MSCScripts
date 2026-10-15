#pragma context server

// Converted from monsters/troll_ice.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.
// Thothie - include override not working, so copying from original Troll (monsters/troll)
// - Changed model accordingly, increased fire sensitivity / HP
// - Adjusted Anims for Model
// - %chance of applying frostbite effect

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/troll_ice"]
class TrollIce : BaseMonsterNewScript
{
	// Constants
	float TOO_CLOSE = 100.0f;
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "monsters/troll/trollpain.wav";
	string SOUND_STRUCK3 = "monsters/troll/trollpain.wav";
	string SOUND_PAIN = "monsters/troll/trollpain.wav";
	string SOUND_ATTACK1 = "monsters/troll/trollattack.wav";
	string SOUND_ATTACK2 = "monsters/troll/trollattack.wav";
	string SOUND_WALK = "monsters/troll/trollidle.wav";
	string SOUND_WALK1 = "monsters/troll/step1.wav";
	string SOUND_WALK2 = "monsters/troll/step2.wav";
	string SOUND_IDLE = "monsters/troll/trollidle.wav";

	// Variables (an unset .script variable reads as its own name)
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string CAN_HUNT = "CAN_HUNT";
	string HUNT_AGRO = "HUNT_AGRO";
	string PUSH_VEL = "PUSH_VEL";
	bool I_R_SUMMONED = false;
	string MY_MASTER = "MY_MASTER";

	// Variables declared by included files, with the value they start with in this script
	TrollIce()
	{
		SOUND_DEATH = "monsters/troll/trolldeath.wav";
		ANIM_RUN = "walk";
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle1";
	}

	// unnamed block (first think)
	void TrollIce_FirstThink()
	{
		DROP_GOLD = 1;
		DROP_GOLD_MIN = 10;
		DROP_GOLD_MAX = 35;
		ANIM_RUN = "walk";
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle1";
		ANIM_ATTACK = "attack1";
		ANIM_DEATH = "dieheadshot2";
		ATTACK_RANGE = 150.0f;
		ATTACK_HITRANGE = 200.0f;
		CAN_FLINCH = "0";
		MOVE_RANGE = "100";
		CAN_HUNT = "1";
		HUNT_AGRO = "1";

		NPC_MUST_SEE_TARGET = "0";
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck

		// setsolid none
		CallEventDelayed(1.0f, "ice_solidify");

		I_R_SUMMONED = true;

		MY_MASTER = creatorValue1;
		bool myMasterLives = IsAlive(MY_MASTER);
		// dbg Mastah Alive MY_MASTER_LIVES
		if (!myMasterLives)
			return;
		NO_SPAWN_STUCK_CHECK = true;
		CallEventDelayed(0.1f, "check_dist");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		// ov 359
		SetWidth(50);
		SetHeight(100);
		SetRace("orc");
		SetIdleAnim("idle1");
		SetMoveAnim(ANIM_WALK);
		SetHealth(600);
		SetName("Ice Troll");
		SetRoam(true);
		NPC_GIVE_EXP = 200.0f;
		SetDamageTaken("all", 1);
		SetDamageTaken("cold", 0);
		SetDamageTaken("fire", 4);
		SetHearingSensitivity(8);
		SetModel("monsters/icetroll.mdl");

		Effect("glow", ENT_ME, Vector3(128, 128, 255), 512, 3, 3);

		OnTrollSpawn(); // holdover from troll - not what it's here for
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck

		if (!I_R_SUMMONED)
			return;
		string masterTarget = ScriptVarOf(MY_MASTER, NPCATK_TARGET);
		if (masterTarget == "unset")
			return;
		if (NPCATK_TARGET == masterTarget)
			return;
		OnNpcatkSettarget(masterTarget);
	}

	// attack_1
	void OnAttack12()
	{
		PUSH_VEL = Text(RelativeVelocity(Vector3(10, 200, 10)));
		if (RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE)
		{
			if (RandomInt(1, 8) == 1)
				ApplyEffect(ENT_LASTSTRUCK, "effects/dot_cold", 10, self, Random(5, 15), "none");
			OnNpcatkDodamage(NPCATK_TARGET, "direct", Text(Random(20, 30)), "75%", EntityId(self), "blunt");
		}

		if (RandomInt(0, 3) == 0)
			ANIM_ATTACK = "attack2";

		if (RandomInt(1, 20) == 1)
		{
			SetVolume(10);
			PlaySound(1, 10, SOUND_IDLE);
		}
		SetVolume(8);
		PlaySound(2, 8, SOUND_ATTACK1);
	}

	// attack_2
	void OnAttack22()
	{
		if (RandomInt(0, 3) == 0)
			ANIM_ATTACK = "attack1";

		if (RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE)
		{
			if (RandomInt(1, 4) == 1)
				ApplyEffect(NPCATK_TARGET, "effects/dot_cold", 5, self, Random(5, 15), "none");
			OnNpcatkDodamage(NPCATK_TARGET, "direct", Text(Random(35, 45)), "75%", EntityId(self), "blunt");
		}

		PlayRandomSound(2, SOUND_ATTACK1);
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		SetVolume(5);
		PlayRandomSound(Int(Eval("game.sound.voice")), 5, SOUND_PAIN, SOUND_PAIN, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_STRUCK3);
	}

	// check_dist
	void OnCheckDist()
	{
		if (Distance(Vec(MY_MASTER), MyOrigin()) < TOO_CLOSE)
		{
			SetSolid("none");
			CallEventDelayed(0.1f, "repeat_addvel");
			OnNpcatkFlee(MY_MASTER, "275", "3");
		}
	}

	// repeat_addvel
	void OnRepeatAddvel()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 800, 5)));
	}

	// ice_solidify
	void OnIceSolidify()
	{
		// check if pet is clear, if so, go back to solid, if not, try again 5 secs
		Vector3 myLoc = OriginOf(ENT_ME);
		Vector3 myMasterLoc = OriginOf(MY_MASTER);
		float masterDistance = Distance(myLoc, myMasterLoc);
		// dbg Master Distance MASTER_DISTANCE
		if (masterDistance > 80.0f)
		{
			// dbg Ice Troll Going Solid
			SetSolid("box");
		}
		if (masterDistance <= 80.0f)
		{
			if (!IS_FLEEING)
				OnNpcatkFlee(EntityId(EntityOf(MY_MASTER)), "512", "3");
			CallEventDelayed(0.25f, "ice_solidify");
		}
	}

	// npc_monster_stuck
	void OnNpcMonsterStuck()
	{
		// zomg master I r stuck! plz be re-summingz me!
		if (!(STUCK_COUNT > 3.0f))
			return;
		if (I_R_SUMMONED)
			CallExternal(EntityOf(MY_MASTER), "my_pet_stuck");
	}

	// ext_attack_master_target
	void OnExtAttackMasterTarget(string target = "")
	{
		if (NPCATK_TARGET != "unset")
			return;
		OnNpcatkSettarget(target);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnTrollSpawn() {} // troll_spawn

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/icetroll.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TrollIce_FirstThink();
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
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "check_dist") { OnCheckDist(); return true; }
		if (name == "ext_attack_master_target") { OnExtAttackMasterTarget(Param(params, 0)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "ice_solidify") { OnIceSolidify(); return true; }
		if (name == "npc_monster_stuck") { OnNpcMonsterStuck(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "repeat_addvel") { OnRepeatAddvel(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
