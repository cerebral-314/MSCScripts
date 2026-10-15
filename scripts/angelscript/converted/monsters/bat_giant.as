#pragma context server

// Converted from monsters/bat_giant.script by msc_transpiler.
// Thothie - the only way I can see of fixing this is to remove all CAN_ATTACK 0 and CAN_HUNT 0 events...
// - However, that would kill a lot of the niftier effects, so I've decided to see how it looks on a seperate beast, meantime.
// - See gbat_hunter
// Giant Bat

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bat_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BatGiant
{
	// Constants
	string ANIM_DROP = "idle";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_PAIN1 = "monsters/bat/pain1.wav";
	string SOUND_PAIN2 = "monsters/bat/pain2.wav";
	string SOUND_ATTACK1 = "zombie/claw_miss1.wav";
	string SOUND_ATTACK2 = "zombie/claw_miss2.wav";
	string SOUND_ATTACK3 = "monsters/orc/attack3.wav";
	string SOUND_ALERT = "monsters/bat/alert.wav";
	string SOUND_FLAP1 = "monsters/bat/flap_big1.wav";
	string SOUND_FLAP2 = "monsters/bat/flap_big2.wav";
	string SOUND_DEATH = "monsters/bat/death.wav";
	string BAT_SUMMON_SCRIPT = "monsters/bat_summon";
	int BAT_SUMMON_AMT = 5;
	int BAT_SUMMON_LIFETIME = 15;
	int BAT_SUMMON_DMG = 4;
	int BAT_SUMMON_HEIGHT = 300;
	string BAT_SUMMON_CHANCE = "60%";
	string BAT_SUMMON_SND_RETREAT = "monsters/bat/pain1.wav";
	string BAT_SUMMON_SND_SUMMON = "monsters/bat/death.wav";
	float FREQ_SUMMON = 17.0f;
	int BBOX_WIDE = 36;
	int BBOX_LOW = 26;
	int BBOX_HIGH = 26;
	bool BBOX_REAPPLY = true;
	bool BBOX_REPORT = false;
	int MAX_HOVER = 40;
	int SINK_STEP = 8;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_RUN = "fly";
	string ANIM_WALK = "fly";
	string ANIM_IDLE_HANG = "idle";
	string ANIM_IDLE_FLY = "idle";
	string HEAR_RANGE_PLAYER = "HEAR_RANGE_PLAYER";
	string HEAR_RANGE_MAX = "HEAR_RANGE_MAX";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string MOVE_RANGE = "MOVE_RANGE";
	string ATTACK_DAMAGE = "ATTACK_DAMAGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string ATTACK_HITCHANCE = "ATTACK_HITCHANCE";
	float NPC_GIVE_EXP = 0.0f;
	string CAN_HUNT = "CAN_HUNT";
	bool CHAPEL_BAT = false;
	string OLD_TARG = "OLD_TARG";
	float BAT_SUMMON_NUM = 0.0f;
	bool CL_FLAP_SND = false;

	// unnamed block (first think)
	void BatGiant_FirstThink()
	{
		HEAR_RANGE_PLAYER = "256";
		HEAR_RANGE_MAX = "300";

		ANIM_RUN = "fly";
		ANIM_WALK = "fly";
		ANIM_ATTACK = "attack2";
		ANIM_IDLE_HANG = "idle"; // idlehang
		ANIM_IDLE_FLY = "idle";
		ANIM_DEATH = "die";

		MOVE_RANGE = "10";
		ATTACK_DAMAGE = "15";
		ATTACK_RANGE = 200.0f;
		ATTACK_HITRANGE = 250.0f;
		ATTACK_HITCHANCE = "85%";
		NPC_GIVE_EXP = 150.0f;

		PrecacheFile("monsters/bat_summon");

		// Box is built at spawn from width/height. bat_base delays bat_spawn 0.1, so
		// setting them down there is too late, they were never being read.
		SetWidth(72);
		SetHeight(48);
	}

	// bat_spawn
	void BatGiant_OnBatSpawn()
	{
		SetName("Giant Bat");
		SetHealth(500);

		// fov 359
		// width/height live up top now, too late to matter here
		SetBoundingBox(Vector3(0, 0, 0), Vector3(BBOX_WIDE, BBOX_WIDE, BBOX_HIGH));
		SetHearingSensitivity(10);
		SetModel("monsters/giant_bat.mdl");
		SetVolume(10);

		SetRace("demon");
	}

	// unnamed block (timer)
	void BatGiant_Timer()
	{
		CallEventDelayed(0.2f, "BatGiant_Timer");

		// re-applied here - on a slower timer it kept reverting between checks
		if (BBOX_REAPPLY)
			SetBoundingBox(Vector3(0, 0, 0), Vector3(BBOX_WIDE, BBOX_WIDE, BBOX_HIGH));
		if (BBOX_REPORT)
			MessageAll("green", "giant bat box " + GetProp(ENT_ME, "mins") + " to " + GetProp(ENT_ME, "maxs"));

		// keep him low enough to swing at
		if (!IS_HUNTING)
			return;
		Vector3 targ = OriginOf(NPCATK_TARGET);
		float ceil = targ.z + MAX_HOVER;

		Vector3 org = OriginOf(ENT_ME);
		float myz = org.z;
		if (myz > ceil)
		{
			float newz = myz;
			string newzText;
			newz -= SINK_STEP;
			if (newz < ceil)
				newz = ceil;
			org.z = newz;
			SetOrigin(ENT_ME, org);
		}
	}

	// bat_hang
	void BatGiant_OnBatHang()
	{
		SetRoam(true);
		CAN_HUNT = "1";
	}

	// npc_post_spawn
	void BatGiant_OnNpcPostSpawn()
	{
		if (ToLowerCase(MapName()) == "chapel")
		{
			ATTACK_DAMAGE = Text(Divide(Float(ATTACK_DAMAGE), 2.0f));
			NPC_GIVE_EXP = Divide(NPC_GIVE_EXP, 2.0f);
			SetHealth(250);
			ATTACK_HITCHANCE = "75";
			CHAPEL_BAT = true;
		}
	}

	// cycle_up
	void BatGiant_OnCycleUp(string reason = "")
	{
		SetIdleAnim(ANIM_IDLE_FLY);
		SetMoveAnim(ANIM_RUN);
		PlayAnim("critical", ANIM_DROP);
		PlaySound(0, 10, SOUND_ALERT);
		SetRoam(true);
		CallEventDelayed(FREQ_SUMMON, "make_babies");
	}

	// make_babies
	void BatGiant_OnMakeBabies()
	{
		CallEventDelayed(FREQ_SUMMON, "make_babies");
		OLD_TARG = NPCATK_TARGET;
		OnNpcatkSuspendAi("2.0");
		Vector3 destPos = MyOrigin();
		destPos.z += 1024.0f;
		SetMoveDest(destPos, 10);
		AddVelocity(ENT_ME, Vector3(0, -50, 900));
		CallEventDelayed(0.5f, "make_babies2");
	}

	// make_babies2
	void BatGiant_OnMakeBabies2()
	{
		AddVelocity(ENT_ME, Vector3(0, -50, 900));
		SetMoveDest(OLD_TARG, 9999);
		// face targ, straighten
		SetVelocity(ENT_ME, Vector3(0, 0, 0));
		CallEventDelayed(0.1f, "make_babies3");
	}

	// make_babies3
	void BatGiant_OnMakeBabies3()
	{
		float myYaw = MyAngles().y;
		SetAngle("face", Vector3(0, myYaw, 0));
		PlayAnim("critical", ANIM_ATTACK);
		CallEventDelayed(0.1f, "bat_summon_all");
	}

	// bat_summon_all
	void BatGiant_OnBatSummonAll()
	{
		PlaySound(Int(Eval("game.sound.voice")), Eval("game.sound.maxvol"), BAT_SUMMON_SND_SUMMON);
		PlayAnim("once", "attack2");
		BAT_SUMMON_NUM = BAT_SUMMON_AMT;
		CallEventDelayed(0.1f, "bat_summon_loop");
	}

	// bat_summon_loop
	void BatGiant_OnBatSummonLoop()
	{
		if (int(BAT_SUMMON_NUM) == 0)
			return;
		BAT_SUMMON_NUM -= 1.0f;
		Vector3 targetpos = OriginOf(ENT_ME);
		int ofsX = RandomInt(-100, 100);
		int ofsY = RandomInt(-100, 100);
		targetpos += Vector3(ofsX, ofsY, -64);
		CreateNpc(BAT_SUMMON_SCRIPT, targetpos, BAT_SUMMON_LIFETIME, BAT_SUMMON_DMG, HUNT_LASTTARGET);
		CallEventDelayed(0.1f, "bat_summon_loop");
	}

	// frame_attack1
	// Deal damage
	void BatGiant_OnFrameAttack1()
	{
		OnAttackYell();
		DoDamage(HUNT_LASTTARGET, ATTACK_HITRANGE, ATTACK_DAMAGE, ATTACK_HITCHANCE);
	}

	// frame_attack2
	// Deal damage
	void BatGiant_OnFrameAttack2()
	{
		OnAttackYell();
		DoDamage(HUNT_LASTTARGET, ATTACK_HITRANGE, ATTACK_DAMAGE, ATTACK_HITCHANCE);
	}

	// attack_yell
	// Attack grunts
	void BatGiant_OnAttackYell()
	{
		if (RandomInt(0, 1) == 0)
			PlayRandomSound(Int(GetVar("CHAN_VOICE")), SOUND_ATTACK1, SOUND_ATTACK2);
	}

	// npc_struck
	// Hit by someone
	void BatGiant_OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(Int(GetVar("CHAN_BODY")), SOUND_PAIN1, SOUND_PAIN2, SOUND_STRUCK1, SOUND_STRUCK2, "none");
	}

	// npc_death
	void BatGiant_OnNpcDeath()
	{
		CallExternal(FindByName("spawner"), "makechest");
	}

	// cl_frame_flap
	// the fect that this was client side was part of the issue
	// casues all vars to duplicate
	void BatGiant_OnClFrameFlap()
	{
		if (!CL_FLAP_SND)
		{
			PlaySound(0, 10, SOUND_FLAP1);
			CL_FLAP_SND = true;
		}
		else
		{
			PlaySound(0, 10, SOUND_FLAP2);
			CL_FLAP_SND = false;
		}
	}

	// unnamed block (timer)
	void BatGiant_Timer2()
	{
		CallEventDelayed(1.0f, "BatGiant_Timer2");
		// dbg FLIGHT_STUCK $get(NPCATK_TARGET,range) vs. ATTACK_RANGE
		if (!IsAlive(NPCATK_TARGET))
			return;
		if (RangeTo(NPCATK_TARGET) < ATTACK_RANGE)
			PlayAnim("critical", ANIM_ATTACK);
	}

	// npcatk_setmovedest
	void BatGiant_OnNpcatkSetmovedest(string destination = "", string range = "")
	{
		if (EntityId(EntityOf(destination)) != NPCATK_TARGET)
			SetMoveDest(destination, range);

		if (EntityId(EntityOf(destination)) == NPCATK_TARGET)
		{
			// attack from above
			Vector3 targOrg = OriginOf(NPCATK_TARGET) + RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, 128));
			SetMoveDest(targOrg, 10);
		}
	}

	// game_death
	void BatGiant_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (!CHAPEL_BAT)
			return;
		CallExternal(GetVar("GAME_MASTER"), "gm_createnpc", 0.1f, "chests/chapel_bat", RelativePosition(Vector3(0, 0, 0)));
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BatBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/bat_base
		BatGiant_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
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
		BatBase_OnNpcPostSpawn(); // monsters/bat_base
		BatGiant_OnNpcPostSpawn();
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttack_OnCycleUp(reason); // monsters/base_npc_attack
		BatGiant_OnCycleUp(reason);
	}

	// bat_hang
	void OnBatHang()
	{
		BatBase_OnBatHang(); // monsters/bat_base
		BatGiant_OnBatHang();
	}

	void OnBatSpawn() { BatGiant_OnBatSpawn(); } // bat_spawn
	void OnMakeBabies() { BatGiant_OnMakeBabies(); } // make_babies
	void OnMakeBabies2() { BatGiant_OnMakeBabies2(); } // make_babies2
	void OnMakeBabies3() { BatGiant_OnMakeBabies3(); } // make_babies3
	void OnBatSummonAll() { BatGiant_OnBatSummonAll(); } // bat_summon_all
	void OnBatSummonLoop() { BatGiant_OnBatSummonLoop(); } // bat_summon_loop
	void OnFrameAttack1() { BatGiant_OnFrameAttack1(); } // frame_attack1
	void OnFrameAttack2() { BatGiant_OnFrameAttack2(); } // frame_attack2
	void OnAttackYell() { BatGiant_OnAttackYell(); } // attack_yell
	void OnNpcStruck(float damage = 0.0f) { BatGiant_OnNpcStruck(damage); } // npc_struck
	void OnNpcDeath() { BatGiant_OnNpcDeath(); } // npc_death
	void OnClFrameFlap() { BatGiant_OnClFrameFlap(); } // cl_frame_flap
	void OnNpcatkSetmovedest(string destination = "", string range = "") { BatGiant_OnNpcatkSetmovedest(destination, range); } // npcatk_setmovedest
	void OnFreqSummon() {} // FREQ_SUMMON

	// This file's events and timers by their .script names
	bool BatGiant_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_yell") { OnAttackYell(); return true; }
		if (name == "bat_hang") { OnBatHang(); return true; }
		if (name == "bat_spawn") { OnBatSpawn(); return true; }
		if (name == "bat_summon_all") { OnBatSummonAll(); return true; }
		if (name == "bat_summon_loop") { OnBatSummonLoop(); return true; }
		if (name == "cl_frame_flap") { OnClFrameFlap(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "frame_attack1") { OnFrameAttack1(); return true; }
		if (name == "frame_attack2") { OnFrameAttack2(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "make_babies") { OnMakeBabies(); return true; }
		if (name == "make_babies2") { OnMakeBabies2(); return true; }
		if (name == "make_babies3") { OnMakeBabies3(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npcatk_setmovedest") { OnNpcatkSetmovedest(Param(params, 0), Param(params, 1)); return true; }
		if (name == "BatGiant_Timer") { BatGiant_Timer(); return true; }
		if (name == "BatGiant_Timer2") { BatGiant_Timer2(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/bat_giant"]
shared class BatGiantScript : BatBaseScript, BatGiant
{
	// Variables declared by included files, with the value they start with in this script
	BatGiantScript()
	{
		ANIM_RUN = "fly";
		ANIM_WALK = "fly";
		ANIM_IDLE_HANG = "idle";
		ANIM_IDLE_FLY = "idle";
		SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
		SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
		SOUND_DEATH = "monsters/bat/death.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/bat.mdl");
		Precache("monsters/giant_bat.mdl");
		CallEventDelayed(0.5f, "BatBase_Timer");
		CallEventDelayed(0.2f, "BatGiant_Timer");
		CallEventDelayed(1.0f, "BatGiant_Timer2");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BatGiant_FirstThink();
		BatBase_FirstThink();
		BaseFlyer_FirstThink();
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
		return BatGiant_DispatchEvent(name, params)
			|| BatBaseScript::DispatchEvent(name, params);
	}
}
