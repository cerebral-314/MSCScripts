#pragma context server

// Converted from monsters/ogre_cave_thug.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/ogre_cave_thug"]
class OgreCaveThug : BaseMonsterNewScript
{
	// Constants
	string ANIM_SEARCH = "idle_look";
	string ANIM_SWIPE = "attack1";
	string ANIM_HEADBUTT = "attack2";
	string ANIM_JUMP = "jump";
	string ANIM_LEAP = "jump";
	string ANIM_WARCRY = "warcry";
	string ANIM_BEAM = "beam";
	string ANIM_BEATDOWN = "anim_beatdown";
	string ANIM_SLAM = "anim_slam";
	string SOUND_IDLE1 = "bullchicken/bc_idle1.wav";
	string SOUND_IDLE2 = "bullchicken/bc_idle2.wav";
	string SOUND_IDLE3 = "bullchicken/bc_idle3.wav";
	string SOUND_IDLE4 = "bullchicken/bc_idle4.wav";
	string SOUND_IDLE5 = "bullchicken/bc_idle5.wav";
	string SOUND_HEADBUTT = "bullchicken/bc_spithit1.wav";
	string SOUND_SWIPEHIT1 = "zombie/claw_strike1.wav";
	string SOUND_SWIPEHIT2 = "zombie/claw_strike2.wav";
	string SOUND_SWIPEMISS1 = "zombie/claw_miss1.wav";
	string SOUND_SWIPEMISS2 = "zombie/claw_miss2.wav";
	string SOUND_STRUCK1 = "debris/flesh1.wav";
	string SOUND_STRUCK2 = "debris/flesh2.wav";
	string SOUND_STEP1 = "player/pl_slosh1.wav";
	string SOUND_STEP2 = "player/pl_slosh2.wav";
	string SOUND_PAIN_WEAK = "bullchicken/bc_pain2.wav";
	string SOUND_PAIN_STRONG = "bullchicken/bc_pain1.wav";
	string SOUND_WARCRY = "bullchicken/bc_attackgrowl3.wav";
	string SOUND_LEAP = "bullchicken/bc_attackgrowl2.wav";
	string SOUND_LEAP_LAND = "weapons/g_bounce2.wav";
	string SOUND_FLINCH = "bullchicken/bc_pain3.wav";
	string SOUND_BEATDOWN_START = "bullchicken/bc_attackgrowl2.wav";
	string SOUND_SLAM_START = "bullchicken/bc_attackgrowl3.wav";
	string ATTACK_HITCHANCE = "95%";
	string SWIPE_DAMAGE = "SWIPE_DAMAGE";
	int SLAM_DAMAGE = 200;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK_DEFAULT = "walk";
	string ANIM_RUN_DEFAULT = "run1";
	string ANIM_FLINCH = "ANIM_FLINCH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	float RUN_STEP = 0.0f;
	float WEAK_THRESHOLD = 0.0f;
	float TEN_PERCENT_HP = 0.0f;
	float REGEN_RATE = 0.0f;
	bool DID_WARCRY = false;
	float NEXT_IDLE_SOUND = 0.0f;
	bool SWIPE_ATTACK = false;
	float SLAM_COUNT = 0.0f;
	string SLAM_LOC = "SLAM_LOC";
	float STEP_COUNT = 0.0f;
	float NEXT_CUSTOM_FLINCH = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	OgreCaveThug()
	{
		ANIM_IDLE = "idle1";
		SOUND_DEATH = "bullchicken/bc_die1.wav";
	}

	// unnamed block (first think)
	void OgreCaveThug_FirstThink()
	{
		ANIM_IDLE = "idle1";
		ANIM_WALK_DEFAULT = "walk";
		ANIM_RUN_DEFAULT = "run1";
		ANIM_DEATH = "dieforward";
		ANIM_FLINCH = "bigflinch";

		ANIM_WALK = ANIM_WALK_DEFAULT;
		ANIM_RUN = ANIM_RUN_DEFAULT;
		ANIM_ATTACK = ANIM_BEATDOWN;

		NPC_GIVE_EXP = 2000.0f;

		ATTACK_RANGE = 64.0f;
		ATTACK_HITRANGE = 80.0f;
	}

	// game_dodamage
	string OgreCaveThug_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		int rlVel = 0;
		string result = "";
		if (SWIPE_ATTACK)
		{
			if (hit)
			{
				PlayRandomSound(0, 10, SOUND_SWIPEHIT1, SOUND_SWIPEHIT2);
				if (RandomInt(1, 2) == 1)
					rlVel = -100;
				else
					rlVel = 100;
				AddVelocity(target, RelativeVelocity(Vector3(rlVel, 300, 110)));
			}
			if (!hit)
				PlayRandomSound(0, 10, SOUND_SWIPEMISS1, SOUND_SWIPEMISS2);
		}
		SWIPE_ATTACK = false;
		return result;
	}

	// game_struck
	// PARAM1 = damage
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		bool doFlinch = false;

		if (MyHealth() > WEAK_THRESHOLD)
			PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_PAIN_STRONG);
		if (MyHealth() <= WEAK_THRESHOLD)
		{
			doFlinch = true;
			PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_PAIN_WEAK);
		}
		if (damage > TEN_PERCENT_HP)
			doFlinch = true;

		// custom flinch
		if (!doFlinch)
			return;
		if (!(GameTime() > NEXT_CUSTOM_FLINCH))
			return;
		NEXT_CUSTOM_FLINCH = GameTime() + 30.0f;
		AS_ATTACKING = GameTime() + 5.0f;
		int rndFlinch = RandomInt(1, 6);
		// wtf does this model have so many flinch anims? :O
		if (rndFlinch == 1)
			PlayAnim("critical", "flinch");
		if (rndFlinch == 2)
			PlayAnim("critical", "bigflinch");
		if (rndFlinch == 3)
			PlayAnim("critical", "raflinch");
		if (rndFlinch == 4)
			PlayAnim("critical", "raflinch");
		if (rndFlinch == 5)
			PlayAnim("critical", "llflinch");
		if (rndFlinch == 6)
			PlayAnim("critical", "rlflinch");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SetName("Cave Ogre Thug");
		SetModel("monsters/ogre_cave_thug.mdl");
		SetHealth(5000);
		SetRace("orc");
		SetRoam(true);
		SetMoveAnim(ANIM_WALK);
		SetHeight(96);
		SetWidth(32);
		SetHearingSensitivity(2);
		SetBlood("green");
		SetIdleAnim(ANIM_IDLE);

		SetDamageTaken("poison", 1.5f);
		SetDamageTaken("acid", 1.5f);

		RUN_STEP = 0.0f;

		CallEventDelayed(1.0f, "idle_sounds");
		CallEventDelayed(2.0f, "final_postspawn");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck

		// regenerate
		if (MyHealth() < MyMaxHealth())
			GiveHealth(ENT_ME, REGEN_RATE);

		if (!(GameTime() > NEXT_IDLE_SOUND))
			return;
		NEXT_IDLE_SOUND = GameTime() + Random(3, 10);
		if (NPCATK_TARGET != "unset")
			return;
		PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3, SOUND_IDLE4, SOUND_IDLE5);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new

		if (!CanSee("enemy"))
		{
			PlayAnim("critical", ANIM_WARCRY);
			PlaySound(0, 10, SOUND_WARCRY, 0.8f, 60);
			DID_WARCRY = false;
		}
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, OgreCaveThug_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// final_postspawn
	void OnFinalPostspawn()
	{
		WEAK_THRESHOLD = MaxHealthOf(ENT_ME) * 0.5f;

		TEN_PERCENT_HP = MaxHealthOf(ENT_ME) * 0.1f;

		REGEN_RATE = 2.0f;

		if (NPC_HP_MULTI > 1.0f)
			REGEN_RATE *= NPC_HP_MULTI;
	}

	// npcatk_validatetarget
	// first spot
	void OnNpcatkValidatetarget(string target = "")
	{
		if (!IsPlayer(target))
			return;
		if (DID_WARCRY)
			return;
		PlayAnim("critical", ANIM_WARCRY);
		PlaySound(0, 10, SOUND_WARCRY, 0.8f, 60);
		DID_WARCRY = true;
	}

	// attack1
	// frame event (unused)
	void OnAttack1()
	{
		SWIPE_ATTACK = true;
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, SWIPE_DAMAGE, ATTACK_HITCHANCE);
	}

	// frame_beatdown_start
	// frame event
	void OnFrameBeatdownStart()
	{
		PlaySound(0, 10, SOUND_BEATDOWN_START, 0.8f, RandomInt(50, 200));
	}

	// frame_beatdown
	// frame event
	void OnFrameBeatdown()
	{
		DebugPrint("frame_beatdown");
		SWIPE_ATTACK = true;
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, SWIPE_DAMAGE, ATTACK_HITCHANCE);
		OnDoStep();
	}

	// frame_beatdown_final
	// frame event
	void OnFrameBeatdownFinal()
	{
		SWIPE_ATTACK = true;
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, SWIPE_DAMAGE, ATTACK_HITCHANCE);
		SLAM_COUNT += 1.0f;
		if (SLAM_COUNT == 5.0f)
		{
			ANIM_ATTACK = ANIM_SLAM;
			SLAM_COUNT = 0.0f;
			PlayAnim("hold", ANIM_SLAM);
		}
		OnDoStep();
	}

	// frame_slam_start
	void OnFrameSlamStart()
	{
		PlaySound(0, 10, SOUND_SLAM_START, 0.8f, 60);
	}

	// frame_slam
	// frame event
	void OnFrameSlam()
	{
		ANIM_ATTACK = ANIM_BEATDOWN;
		Vector3 landPos = RelativePosition(Vector3(0, 64, 0));
		ClientEvent("new", "all", "effects/sfx_stun_burst", landPos, 256, 0, 0);
		SLAM_LOC = Text(landPos);
		DoDamageEx(landPos, 128, SLAM_DAMAGE, 0, ENT_ME, ENT_ME, "none", "blunt_effect", "dmgevent:slam");
		OnDoStep();
		CallEventDelayed(1.0f, "break_slam");
	}

	// break_slam
	void OnBreakSlam()
	{
		PlayAnim("break");
	}

	// slam_dodamage
	void OnSlamDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool isNme = false;
		if (!hit)
			return;
		// pushes allies too, although less - just for effect
		if (RelationshipOf(target, ENT_ME) == "enemy")
			isNme = true;
		int pushVel = 2000;
		if (!isNme)
		{
			int pushVelValue = 500;
		}
		Vector3 targOrg = OriginOf(target);
		string myOrg = "SLAM_POS";
		float targAng = AnglesTo(Vec(myOrg), targOrg);
		int newYaw = int(targAng);
		AddVelocity(target, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, pushVel, 110)));
		if (!isNme)
			return;
		ApplyEffect(target, "effects/debuff_stun", 5.0f, self);
	}

	// run_step1
	// called from model during ANIM_RUN
	void OnRunStep1()
	{
		OnDoStep();
	}

	// run_step2
	// called from model during ANIM_RUN
	void OnRunStep2()
	{
		OnDoStep();
	}

	// do_step
	void OnDoStep()
	{
		STEP_COUNT += 1.0f;
		if (STEP_COUNT == 1.0f)
			PlaySound(0, 5, SOUND_STEP1);
		if (STEP_COUNT == 2.0f)
		{
			STEP_COUNT = 0.0f;
			PlaySound(0, 5, SOUND_STEP2);
		}
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/ogre_cave_thug.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OgreCaveThug_FirstThink();
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
		if (name == "attack1") { OnAttack1(); return true; }
		if (name == "break_slam") { OnBreakSlam(); return true; }
		if (name == "do_step") { OnDoStep(); return true; }
		if (name == "final_postspawn") { OnFinalPostspawn(); return true; }
		if (name == "frame_beatdown") { OnFrameBeatdown(); return true; }
		if (name == "frame_beatdown_final") { OnFrameBeatdownFinal(); return true; }
		if (name == "frame_beatdown_start") { OnFrameBeatdownStart(); return true; }
		if (name == "frame_slam") { OnFrameSlam(); return true; }
		if (name == "frame_slam_start") { OnFrameSlamStart(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_validatetarget") { OnNpcatkValidatetarget(Param(params, 0)); return true; }
		if (name == "run_step1") { OnRunStep1(); return true; }
		if (name == "run_step2") { OnRunStep2(); return true; }
		if (name == "slam_dodamage") { OnSlamDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
