#pragma context server

// Converted from monsters/fish_leech.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.
// Thothie - Again the include causing problems - fish_base includes animations not in model
// Leech

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"
#include "converted/monsters/base_propelled.as"

[script "monsters/fish_leech"]
class FishLeech : BaseMonsterScript, BasePropelled
{
	// Constants
	bool DELETE_ON_DEATH = true;
	string SOUND_IDLE1 = "none";
	string SOUND_IDLE2 = "none";
	string SOUND_ATTACK1 = "leech/leech_bite1.wav";
	string SOUND_ATTACK2 = "leech/leech_bite2.wav";
	string SOUND_STRUCK1 = "leech/leech_alert2.wav";
	string SOUND_STRUCK2 = "leech/leech_alert1.wav";
	string SOUND_STRUCK3 = "leech/leech_alert2.wav";
	string SOUND_STRUCK4 = "leech/leech_alert1.wav";
	string SOUND_STRUCK5 = "leech/leech_alert2.wav";
	string ATTACK_HITCHANCE = "80%";
	float ATK_DMG_LOW = 0.2f;
	float ATK_DMG_HIGH = 0.8f;
	string ANIM_TURN_RIGHT = "leftturn";
	string ANIM_TURN_LEFT = "rightturn";
	int TURN_ANIM_THRESHOLD = 90;
	string RETALIATE_CHANGETARGET_CHANCE = "75%";

	// Variables (an unset .script variable reads as its own name)
	float NPC_HACKED_MOVE_SPEED = 100.0f;
	bool NPC_EXTRA_VALIDATIONS = false;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string FISH_LASTYAW = "FISH_LASTYAW";
	bool TARGET_INVALID = false;

	// Variables declared by included files, with the value they start with in this script
	FishLeech()
	{
		ANIM_IDLE = "swim";
		ANIM_WALK = "swim";
		ANIM_RUN = "swim2";
	}

	// unnamed block (first think)
	void FishLeech_FirstThink()
	{
		NPC_EXTRA_VALIDATIONS = true;

		NO_STUCK_CHECKS = "1";
		ANIM_IDLE = "swim";
		ANIM_WALK = "swim";
		ANIM_RUN = "swim2";
		ANIM_DEATH = "death";
		ANIM_ATTACK = "attack";

		MOVE_RANGE = "40";
		ATTACK_RANGE = 65.0f;
		ATTACK_HITRANGE = 80.0f;

		CAN_HEAR = "1";
		HUNT_AGRO = "1";
		CAN_FLINCH = "0"; // Flinch when hit
		NPC_HACKED_MOVE_SPEED = 100.0f; // base_propelled

		NPC_GIVE_EXP = 1.0f;
	}

	// npc_spawn
	void FishLeech_OnNpcSpawn(string npc = "")
	{
		SetHealth(5);
		// ov 360
		SetName("Leech");
		SetHearingSensitivity(2);
		SetGravity(0.02f);

		SetModel("monsters/leech.mdl");
		SetBoundingBox(Vector3(-5, -5, -5), Vector3(5, 5, 5));
	}

	// npc_post_spawn
	void FishLeech_OnNpcPostSpawn()
	{
		if (!StartsWith(ToLowerCase(MapName()), "lostcastle"))
			return;
		NPC_EXTRA_VALIDATIONS = false;
	}

	// unnamed block (first think)
	// Importing fish base manually this time, edting
	void FishLeech_FirstThink2()
	{
		CAN_RETALIATE = "1";
	}

	// npc_spawn
	void FishLeech_OnNpcSpawn_2(string npc = "")
	{
		SetRace("wildanimal");
		SetRoam(true);
		SetHearingSensitivity(3);
		LegacyCommand("float", 1);

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
	}

	// unnamed block (timer)
	void FishLeech_Timer()
	{
		CallEventDelayed(RandomInt(10, 25), "FishLeech_Timer");

		if (IS_HUNTING)
			return;
		if (IS_FLEEING)
			return;

		PlayRandomSound(Int(Eval("game.sound.body")), Eval("game.sound.maxvol"), SOUND_IDLE1, SOUND_IDLE2);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		FishLeech_OnNpcSpawn(npc);
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		FishLeech_OnNpcSpawn_2(npc);
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		FishLeech_OnNpcPostSpawn();
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		BasePropelled_OnNpcPostSpawn(); // monsters/base_propelled
	}

	// bite
	void OnBite()
	{
		PlayRandomSound(Int(Eval("game.sound.voice")), Eval("game.sound.maxvol"), SOUND_ATTACK1, SOUND_ATTACK2);
		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, Random(ATK_DMG_LOW, ATK_DMG_HIGH), ATTACK_HITCHANCE);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared

		LegacyCommand("roamdelay", 2);
		if (Truthy(LegacyFunction("cansee", NPC_MOVE_TARGET, ATTACK_RANGE)))
			SetMoveDest("none");
	}

	// npc_targetvalidate
	// no more flying leeches (outside of lostcastle)
	// { npcatk_hunt
	// if NPC_EXTRA_VALIDATIONS
	// if $get(ent_me,inwater) == 0
	// if ( HUNT_LASTTARGET equals �NONE� )
	// {
	// setmovedest NPC_HOME_LOC 5
	// }
	// else
	// {
	// add OUT_OF_WATER 1
	// if OUT_OF_WATER > 3
	// setvard OUT_OF_WATER 0
	// callevent npcatk_clear_targets "out_of_water"
	// callevent npcatk_suspend_ai 1.0
	// setmovedest NPC_HOME_LOC 5
	// }
	// }
	void OnNpcTargetvalidate(CBaseEntity@ target = null)
	{
		BaseMonsterShared_OnNpcTargetvalidate(target); // monsters/base_monster_shared
		if ((IsInWater(target) ? 1 : 0) != 0)
			return;
		TARGET_INVALID = true;
	}

	// game_movingto_dest
	// PARAM1: Absolute angles towards destination
	// Use the dern turn animations
	void OnGameMovingtoDest(Vector3 angles = Vector3())
	{
		BasePropelled_OnGameMovingtoDest(angles); // monsters/base_propelled

		if (IS_HUNTING)
			SetAngle("face.x", angles.x);

		if (IS_HUNTING)
			return;

		int currentYaw = Int(Eval("game.monster.angles.yaw"));
		float diff = AngleDifference(angles.y, currentYaw);
		bool negative = false;
		if (diff < 0.0f)
		{
			negative = true;
			diff *= -1.0f;
		}

		if (!(diff > TURN_ANIM_THRESHOLD))
			return;

		string anim = ANIM_TURN_LEFT;
		if (negative)
			anim = ANIM_TURN_RIGHT;

		PlayAnim("once", anim);
	}

	// game_stopmoving
	void OnGameStopmoving()
	{
		BasePropelled_OnGameStopmoving(); // monsters/base_propelled

		FISH_LASTYAW = Eval("game.monster.angles.yaw");
	}

	// npc_struck
	// Hit by someone
	void OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(Int(Eval("game.sound.body")), Eval("game.sound.maxvol"), SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK4, SOUND_STRUCK5);
	}

	// npc_wander
	void OnNpcWander()
	{
		LegacyCommand("setturnrate", 0.175f);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/leech.mdl");
		CallEventDelayed(Float(Eval("$rand(10,25)")), "FishLeech_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		FishLeech_FirstThink();
		FishLeech_FirstThink2();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bite") { OnBite(); return true; }
		if (name == "game_movingto_dest") { OnGameMovingtoDest(Vec(Param(params, 0))); return true; }
		if (name == "game_stopmoving") { OnGameStopmoving(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npc_targetvalidate") { OnNpcTargetvalidate(EntityParam(params, 0)); return true; }
		if (name == "npc_wander") { OnNpcWander(); return true; }
		if (name == "FishLeech_Timer") { FishLeech_Timer(); return true; }
		return BasePropelled_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
