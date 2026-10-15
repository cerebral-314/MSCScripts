#pragma context server

// Converted from monsters/djinn_ice.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.
// Djinn Ji-ax by Father Brandon
// - Mass mods by Thothie

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DjinnIce
{
	// Constants
	float TOO_CLOSE = 100.0f;
	float NPC_BOSS_REGEN_RATE = 0.1f;
	float NPC_BOSS_RESTORATION = 1.0f;
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "monsters/troll/trollpain.wav";
	string SOUND_ATTACK1 = "monsters/troll/trollattack.wav";
	string SOUND_ATTACK2 = "monsters/troll/trollattack.wav";
	string SOUND_DEATH = "monsters/troll/trolldeath.wav";
	string SOUND_WALK = "monsters/troll/walk.wav";
	string SOUND_SUMMON = "ambience/particle_suck2.wav";
	string SOUND_ROAR = "monsters/troll/trollidle2.wav";
	string ANIM_SUMMON = "throw_rock";
	int FLEE_HEALTH = 1;
	string TORCH_LIGHT_SCRIPT = "items/item_djinn_light";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle0";
	string ANIM_RUN = "run";
	string ANIM_WALK = "walk";
	bool NO_STEP_ADJ = true;
	bool NPC_IS_BOSS = false;
	float NPC_GIVE_EXP = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string CAN_FLINCH = "CAN_FLINCH";
	string MOVE_RANGE = "MOVE_RANGE";
	string CAN_FLEE = "CAN_FLEE";
	bool WIN_PRIZE = false;
	string PUSH_VEL = "PUSH_VEL";
	bool I_ATTACKED = false;
	bool MELEE_ATTACK = false;
	bool SUMMON_NEXT_CHECK = false;
	bool DID_ROAR_INTRO = false;
	Vector3 MY_PET_CLOC_NEW = Vector3();
	float CUR_SUMMON_POS = 0.0f;
	float N_SUMMON_POS = 0.0f;
	Vector3 SUMMON_POS1 = Vector3();
	Vector3 SUMMON_POS2 = Vector3();
	Vector3 SUMMON_POS3 = Vector3();
	Vector3 SUMMON_POS4 = Vector3();
	Vector3 SUMMON_POS5 = Vector3();
	float LOOP_COUNT = 0.0f;
	Vector3 SUMMON_POS = Vector3();
	string MY_ICE_TROLL = "MY_ICE_TROLL";

	// unnamed block (first think)
	void DjinnIce_FirstThink()
	{
		if (StartsWith(ToLowerCase(MapName()), "keledrosprelude"))
		{
			NPC_IS_BOSS = true;
			NPC_GIVE_EXP = 1000.0f;
			if (Truthy(GetVar("G_DEVELOPER_MODE")))
				ChatLog("Djinn Ji-ax set BOSS MODE");
		}
		else
		{
			NPC_GIVE_EXP = 500.0f;
		}
		ANIM_IDLE = "idle0";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "double_punch";
		ANIM_DEATH = "die_fall";
		ATTACK_RANGE = 90.0f;
		ATTACK_HITRANGE = 200.0f;
		CAN_FLINCH = "0";
		MOVE_RANGE = "70";
		// setvard CAN_HUNT 1
		// setvard CAN_ATTACK 1
		// setvard HUNT_AGRO	1
		CAN_FLEE = "1"; // hoping this gets him to avoid firewalls/volcanos

		NO_STEP_ADJ = true;
	}

	// game_precache
	void DjinnIce_OnGamePrecache()
	{
		PrecacheFile("items/item_djinn_light");
	}

	// npc_spawn
	void DjinnIce_OnNpcSpawn(string npc = "")
	{
		SetHealth(3000);
		// ov 359
		SetWidth(60);
		SetHeight(100);
		SetRace("orc");
		SetName("Ice Djinn");
		SetRoam(true);
		SetDamageTaken("all", 0.7f);
		SetDamageTaken("fire", 1.5f);
		SetDamageTaken("lightning", 1.5f);
		SetDamageTaken("cold", 0);
		SetDamageTaken("holy", 0.2f); // just possessed
		SetModel("monsters/troll.mdl");
		SetIdleAnim("idle1");
		SetMoveAnim(ANIM_WALK);

		CallEventDelayed(20.0f, "summon_icetroll");

		SetHearingSensitivity(10);

		SetGlobal("ICE_TROLL_DEAD", 1);

		PrecacheFile("monsters/troll_ice");

		if (RandomInt(1, 8) == 1)
			WIN_PRIZE = true;

		// giveitem scroll2_blizzard
		OnTrollSpawn();
		ClientEvent("persist", "all", TORCH_LIGHT_SCRIPT, IndexOf(ENT_ME), 1);
		Effect("glow", ENT_ME, Vector3(4, 50, 128), 64, -1, 0);
	}

	// attack_1
	void DjinnIce_OnAttack12()
	{
		I_ATTACKED = true;

		PUSH_VEL = Text(RelativeVelocity(Vector3(10, 30, 10)));
		DoDamage(ENT_LASTSEEN, ATTACK_RANGE, Random(4.5f, 6), "ATTACK_HITCHANCE");
		MELEE_ATTACK = true;

		if (RandomInt(1, 4) == 1)
			ANIM_ATTACK = "hit_down";

		// if( $rand(1,10) == 1 ) applyeffect $get(ent_laststruckbyme,id) effects/effect_push 3 $relvel(0,200,200) 0
		OnAttackSound();
	}

	// attack_2
	void DjinnIce_OnAttack22()
	{
		I_ATTACKED = true;

		DoDamage(ENTITY_ENEMY, ATTACK_HITRANGE, Random(40, 70), "75%");
		MELEE_ATTACK = true;
		ANIM_ATTACK = "double_punch";

		if (RandomInt(1, 10) == 1)
		{
			CallEventDelayed(0.1f, "rawr");
			if (EntityOf(ENT_LASTSTRUCKBYME) !is self && RangeTo(ENTITY_ENEMY) < ATTACK_HITRANGE) // reports of this guy throwing himself somehow?
				ApplyEffect(ENTITY_ENEMY, "effects/effect_push", 3, RelativeVelocity(Vector3(0, 400, 400)), 0);
		}

		OnAttackSound();
	}

	// bite1
	void DjinnIce_OnBite1()
	{
		I_ATTACKED = true;

		DoDamage(ENT_LASTSEEN, ATTACK_RANGE, Random(4.5f, 6), "ATTACK_HITCHANCE");
		MELEE_ATTACK = true;
	}

	// struck
	void DjinnIce_OnStruck()
	{
		SetVolume(10);
		PlayRandomSound(Int(Eval("game.sound.voice")), 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK2);
	}

	// attack_sound
	void DjinnIce_OnAttackSound(float pitch = 0.0f)
	{
		SetVolume(10);
		PlaySound(Int(Eval("game.sound.voice")), 10, SOUND_ATTACK1);
	}

	// npc_death
	void DjinnIce_OnNpcDeath()
	{
		// if ( WIN_PRIZE == 1 ) infomsg all Key_Item_Dropped "Jin-ax has left a Blizzard Scroll Page!"
		if (MY_ICE_TROLL != "MY_ICE_TROLL")
			DeleteEntity(MY_ICE_TROLL, "fade");

		ClientEvent("remove", "all", "SCRIPT_ID");

		OnBmGoldSpew(10, "4", 100, 1, 20);
	}

	// summon_icetroll
	void DjinnIce_OnSummonIcetroll()
	{
		CallEventDelayed(15.0f, "summon_icetroll");

		if (IsAlive(MY_ICE_TROLL))
			return;

		bool exitSub = false;

		if (!SUMMON_NEXT_CHECK)
		{
			SUMMON_NEXT_CHECK = true;
			exitSub = true;
		}

		if (exitSub)
			return;

		if (!CanSee("player"))
			return;

		if (MY_ICE_TROLL != "MY_ICE_TROLL")
			DeleteEntity(MY_ICE_TROLL, "fade");

		SetVolume(10);
		PlaySound(2, 10, SOUND_SUMMON);

		OnNpcatkSuspendAi("1.0");
		PlayAnim("break");
		PlayAnim("critical", ANIM_SUMMON);

		SetSolid("none");

		OnFindSummonPos();
		CreateNpc("monsters/summon/ibarrier", SUMMON_POS, self, 96, 1);
		CreateNpc("monsters/summon/ibarrier", MyOrigin(), self, 60, 1);
		CallEventDelayed(0.25f, "act_make_summon");

		CallEventDelayed(1.0f, "solidify_djinn"); // stops me from getting stuck inside my pet

		SUMMON_NEXT_CHECK = false;

		// run away for a second to get outside of my summoned
		if (!IS_FLEEING && Text(SUMMON_POS) == Text(MyOrigin()))
			OnNpcatkFlee(MY_ICE_TROLL, "275", "3");
	}

	// solidify_djinn
	void DjinnIce_OnSolidifyDjinn()
	{
		// check if pet is clear, if so, go back to solid, if not, try again 5 secs
		Vector3 myLoc = OriginOf(ENT_ME);
		Vector3 myPetLoc = OriginOf(MY_ICE_TROLL);
		float petDistance = Distance(myLoc, myPetLoc);
		if (petDistance > 80.0f)
		{
			// dbg Going Solid
			SetSolid("box");
		}
		if (petDistance <= 80.0f)
		{
			// if ( !IS_FLEEING ) callevent npcatk_flee MY_ICE_TROLL 512 2
			CallEventDelayed(0.25f, "solidify_djinn");
		}
	}

	// npc_targetsighted
	void DjinnIce_OnNpcTargetsighted(string target = "")
	{
		if (DID_ROAR_INTRO)
			return;

		SetVolume(10);
		PlaySound(Int(Eval("game.sound.voice")), 10, SOUND_ROAR);

		DID_ROAR_INTRO = true;

		CallEventDelayed(0.5f, "walker_go");
	}

	// walker_go
	void DjinnIce_OnWalkerGo()
	{
		CallEventDelayed(2.0f, "walker_go");

		bool didAttack = false;

		if (I_ATTACKED)
			didAttack = true;

		if (didAttack)
			I_ATTACKED = false;

		MY_PET_CLOC_NEW = OriginOf(MY_ICE_TROLL);

		if (didAttack)
			return;

		if (HUNT_LASTTARGET == "\xEF\xBF\xBDNONE\xEF\xBF\xBD")
			return;
		if (DistanceTo(HUNT_LASTTARGET) > Float(MOVE_RANGE))
		{
			SetVolume(10);
			PlaySound(Int(Eval("game.sound.voice")), 10, SOUND_WALK);
		}
	}

	// rawr
	void DjinnIce_OnRawr()
	{
		SetVolume(10);
		PlaySound(Int(Eval("game.sound.voice")), 10, SOUND_ROAR);
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string DjinnIce_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;
		if (!MELEE_ATTACK)
			return result;
		if (RandomInt(1, 4) == 1)
			ApplyEffect(EntityOf(ENT_LASTSTRUCKBYME), "effects/dot_cold", 5, ENT_ME, RandomInt(13, 25), "none");
		MELEE_ATTACK = false;
		return result;
	}

	// my_pet_stuck
	void DjinnIce_OnMyPetStuck()
	{
		// called by Troll Ice when Stuck Count == 2
		// dbg my pet says he's stuck, resummoning
		DeleteEntity(MY_ICE_TROLL, "fade");

		SetVolume(10);
		PlaySound(2, 10, SOUND_SUMMON);

		OnNpcatkSuspendAi("1.0");
		PlayAnim("break");
		PlayAnim("critical", ANIM_SUMMON);

		SetSolid("none");

		SetOrigin(MY_ICE_TROLL, MyOrigin());

		AddVelocity(MY_ICE_TROLL, RelativePosition(Vector3(0, 800, 10)));

		CreateNpc("monsters/summon/ibarrier", MyOrigin(), self, 60, 1);
		CallExternal(MY_ICE_TROLL, "npcatk_flee", self, 100, 10.0f, "master_told_me_to");

		CallEventDelayed(1.0f, "solidify_djinn"); // stops me from getting stuck inside my pet

		SUMMON_NEXT_CHECK = false;
	}

	// unnamed block (first think)
	// summon position finder
	void DjinnIce_FirstThink2()
	{
		CUR_SUMMON_POS = 0.0f;
		N_SUMMON_POS = 0.0f;
	}

	// unnamed block (timer)
	void DjinnIce_Timer()
	{
		CallEventDelayed(10.0f, "DjinnIce_Timer");
		if (!CYCLED_UP)
			return;

		// mark potential summon positions periodically
		if (STUCK_COUNT != 0.0f) // position not valid if I am stuck
			return;
		CUR_SUMMON_POS += 1.0f;
		if (CUR_SUMMON_POS > 5.0f)
			CUR_SUMMON_POS = 0.0f;
		if (CUR_SUMMON_POS == 1.0f)
			SUMMON_POS1 = MyOrigin();
		if (CUR_SUMMON_POS == 2.0f)
			SUMMON_POS2 = MyOrigin();
		if (CUR_SUMMON_POS == 3.0f)
			SUMMON_POS3 = MyOrigin();
		if (CUR_SUMMON_POS == 4.0f)
			SUMMON_POS4 = MyOrigin();
		if (CUR_SUMMON_POS == 5.0f)
			SUMMON_POS5 = MyOrigin();

		if (CUR_SUMMON_POS > N_SUMMON_POS)
			N_SUMMON_POS += 1.0f;
	}

	// unnamed block (timer)
	void DjinnIce_Timer2()
	{
		CallEventDelayed(1.0f, "DjinnIce_Timer2");
		if (!IsAlive(MY_ICE_TROLL))
			return;
		if (Distance(Vec(MY_ICE_TROLL), MyOrigin()) < TOO_CLOSE)
		{
			// game.monster.moveprox
			// dbg troll closer than TOO_CLOSE ( movprox game.monster.moveprox ) moving
			AddVelocity(MY_ICE_TROLL, RelativeVelocity(Vector3(0, 800, 10)));
		}

		if (Distance(Vec(MY_ICE_TROLL), MyOrigin()) > TOO_CLOSE && IsAlive(HUNT_LASTTARGET))
			CallExternal(MY_ICE_TROLL, "ext_attack_master_target", HUNT_LASTTARGET);
	}

	// find_summon_pos
	// returns SUMMON_POS
	void DjinnIce_OnFindSummonPos()
	{
		LOOP_COUNT = 0.0f;
		SUMMON_POS = MyOrigin(); // if cant find pos
		int count = int(N_SUMMON_POS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnFindSummonPosLoop();
		}
	}

	// find_summon_pos_loop
	void DjinnIce_OnFindSummonPosLoop()
	{
		Vector3 checkPos = Vec("CHECK_POS");
		LOOP_COUNT += 1.0f;
		if (LOOP_COUNT == 1.0f)
			checkPos = SUMMON_POS1;
		if (LOOP_COUNT == 2.0f)
			checkPos = SUMMON_POS2;
		if (LOOP_COUNT == 3.0f)
			checkPos = SUMMON_POS3;
		if (LOOP_COUNT == 4.0f)
			checkPos = SUMMON_POS4;
		if (LOOP_COUNT == 5.0f)
			checkPos = SUMMON_POS5;

		if (Distance(MyOrigin(), checkPos) > TOO_CLOSE)
			SUMMON_POS = checkPos;
		if (Distance(MyOrigin(), checkPos) > Distance(MyOrigin(), SUMMON_POS))
			SUMMON_POS = checkPos;
	}

	// act_make_summon
	void DjinnIce_OnActMakeSummon()
	{
		CreateNpc("monsters/troll_ice", SUMMON_POS, self);
		MY_ICE_TROLL = EntityId(EntityOf(ENT_LASTCREATED));
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePrecache() { DjinnIce_OnGamePrecache(); } // game_precache

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		DjinnIce_OnNpcSpawn(npc);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, DjinnIce_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		DjinnIce_OnNpcTargetsighted(target);
	}

	void OnAttack12() { DjinnIce_OnAttack12(); } // attack_1
	void OnAttack22() { DjinnIce_OnAttack22(); } // attack_2
	void OnBite1() { DjinnIce_OnBite1(); } // bite1
	void OnStruck() { DjinnIce_OnStruck(); } // struck
	void OnAttackSound(float pitch = 0.0f) { DjinnIce_OnAttackSound(pitch); } // attack_sound
	void OnNpcDeath() { DjinnIce_OnNpcDeath(); } // npc_death
	void OnSummonIcetroll() { DjinnIce_OnSummonIcetroll(); } // summon_icetroll
	void OnSolidifyDjinn() { DjinnIce_OnSolidifyDjinn(); } // solidify_djinn
	void OnWalkerGo() { DjinnIce_OnWalkerGo(); } // walker_go
	void OnRawr() { DjinnIce_OnRawr(); } // rawr
	void OnMyPetStuck() { DjinnIce_OnMyPetStuck(); } // my_pet_stuck
	void OnFindSummonPos() { DjinnIce_OnFindSummonPos(); } // find_summon_pos
	void OnFindSummonPosLoop() { DjinnIce_OnFindSummonPosLoop(); } // find_summon_pos_loop
	void OnActMakeSummon() { DjinnIce_OnActMakeSummon(); } // act_make_summon
	void OnTrollSpawn() {} // troll_spawn

	// This file's events and timers by their .script names
	bool DjinnIce_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "act_make_summon") { OnActMakeSummon(); return true; }
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "attack_sound") { OnAttackSound(Float(Param(params, 0))); return true; }
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "find_summon_pos") { OnFindSummonPos(); return true; }
		if (name == "find_summon_pos_loop") { OnFindSummonPosLoop(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "my_pet_stuck") { OnMyPetStuck(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "rawr") { OnRawr(); return true; }
		if (name == "solidify_djinn") { OnSolidifyDjinn(); return true; }
		if (name == "struck") { OnStruck(); return true; }
		if (name == "summon_icetroll") { OnSummonIcetroll(); return true; }
		if (name == "walker_go") { OnWalkerGo(); return true; }
		if (name == "DjinnIce_Timer") { DjinnIce_Timer(); return true; }
		if (name == "DjinnIce_Timer2") { DjinnIce_Timer2(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/djinn_ice"]
shared class DjinnIceScript : BaseMonsterScript, DjinnIce
{
	// Variables declared by included files, with the value they start with in this script
	DjinnIceScript()
	{
		NPC_BOSS_RESTORATION = 1.0f;
		SOUND_DEATH = "monsters/troll/trolldeath.wav";
		ANIM_IDLE = "idle0";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		NO_STEP_ADJ = true;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/icetroll.mdl");
		Precache("monsters/troll.mdl");
		CallEventDelayed(10.0f, "DjinnIce_Timer");
		CallEventDelayed(1.0f, "DjinnIce_Timer2");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
		CallEventDelayed(2.0f, "walker_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DjinnIce_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
		DjinnIce_FirstThink2();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return DjinnIce_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
