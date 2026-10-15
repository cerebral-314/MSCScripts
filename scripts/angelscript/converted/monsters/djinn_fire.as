#pragma context server

// Converted from monsters/djinn_fire.script by msc_transpiler.
// Fire Djinn Var-sul by Thothie (from Ice Djinn Ji-Ax by Father Brandon)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MonstersDjinnFire
{
	// Constants
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
	string SOUND_WALK1 = "monsters/troll/step1.wav";
	string SOUND_WALK2 = "monsters/troll/step2.wav";
	int PUSH_CHANCE = 10;
	bool GOLD_BAGS = true;
	int GOLD_BAGS_PPLAYER = 3;
	int GOLD_PER_BAG = 50;
	int GOLD_RADIUS = 64;
	int GOLD_MAX_BAGS = 32;
	int FLEE_HEALTH = 1;
	string SUMMON_SCRIPT = "monsters/troll_fire";
	string TORCH_LIGHT_SCRIPT = "items/item_djinn_fire";
	string FIRE_DAMAGE = "$rand(50,150)";

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	string ANIM_IDLE = "idle0";
	string ANIM_RUN = "run";
	string ANIM_WALK = "walk";
	bool NPC_IS_BOSS = false;
	float NPC_GIVE_EXP = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string CAN_FLINCH = "CAN_FLINCH";
	string MOVE_RANGE = "MOVE_RANGE";
	string CAN_HUNT = "CAN_HUNT";
	string HUNT_AGRO = "HUNT_AGRO";
	string CAN_FLEE = "CAN_FLEE";
	string FIRE_SCRIPT = "FIRE_SCRIPT";
	string DROP_ITEM1 = "DROP_ITEM1";
	string DROP_ITEM1_CHANCE = "DROP_ITEM1_CHANCE";
	string PUSH_VEL = "PUSH_VEL";
	bool I_ATTACKED = false;
	bool SUMMON_NEXT_CHECK = false;
	string MY_ICE_TROLL = "MY_ICE_TROLL";
	bool DID_ROAR_INTRO = false;
	float AS_ATTACKING = 0.0f;
	bool NO_SUMMON = false;

	// unnamed block (first think)
	void MonstersDjinnFire_FirstThink()
	{
		if (ToLowerCase(MapName()) == "demontemple") // dumb
		{
			NPC_IS_BOSS = true;
			NPC_GIVE_EXP = 3000.0f;
			if (Truthy(GetVar("G_DEVELOPER_MODE")))
				MessageAll("green", "Djinn Var-sul set BOSS MODE");
		}
		else
		{
			NPC_GIVE_EXP = 800.0f;
		}

		IS_UNHOLY = true;

		ANIM_IDLE = "idle0";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "double_punch";
		ANIM_DEATH = "die_fall";
		ATTACK_RANGE = 125.0f;
		ATTACK_HITRANGE = 200.0f;
		CAN_FLINCH = "0";
		MOVE_RANGE = "100";
		CAN_HUNT = "1";
		HUNT_AGRO = "1";
		CAN_FLEE = "1"; // hoping this gets him to avoid firewalls/volcanos

		PrecacheFile(TORCH_LIGHT_SCRIPT);
	}

	// npc_spawn
	void MonstersDjinnFire_OnNpcSpawn(string npc = "")
	{
		SetHealth(4000);
		// ov 359
		SetWidth(100);
		SetHeight(100);
		SetRace("demon");
		SetName("Fire Djinn Val-sul");
		SetRoam(false);
		SetDamageTaken("all", 0.7f);
		SetDamageTaken("fire", 0);
		SetDamageTaken("lightning", 0.5f);
		SetHearingSensitivity(10);
		SetDamageTaken("cold", 1.25f);
		SetDamageTaken("holy", 0.25f); // almost, but not quite, part of this world
		SetModel("monsters/troll.mdl");
		SetIdleAnim("idle1");
		SetMoveAnim(ANIM_WALK);

		// precachefile SUMMON_SCRIPT
		CallEventDelayed(10.0f, "summon_firetroll");

		SetGlobal("ICE_TROLL_DEAD", 1);

		OnTrollSpawn();
		ClientEvent("persist", "all", TORCH_LIGHT_SCRIPT, IndexOf(ENT_ME), 1);
		FIRE_SCRIPT = LastClientScriptId();
		Effect("glow", ENT_ME, Vector3(128, 50, 4), 64, -1, 0);

		if (RandomInt(1, 16) < ActivePlayerCount())
		{
			DROP_ITEM1 = "item_eh";
			DROP_ITEM1_CHANCE = "100";
		}
	}

	// attack_1
	void MonstersDjinnFire_OnAttack12()
	{
		I_ATTACKED = true;

		PUSH_VEL = Text(RelativeVelocity(Vector3(10, 30, 10)));
		// dodamage ENTITY_ENEMY ATTACK_HITRANGE $randf(25,35) 75%
		if (RangeTo(HUNT_LASTTARGET) <= ATTACK_HITRANGE)
			DoDamageEx(HUNT_LASTTARGET, "direct", Random(45, 80), "75%", ENT_ME, ENT_ME, "none", "blunt", "dmgevent:swing");

		if (RandomInt(1, 4) == 1)
			ANIM_ATTACK = "hit_down";

		// if( $rand(1,10) == 1 ) applyeffect $get(ent_laststruckbyme,id) effects/effect_push 3 $relvel(0,200,200) 0
		OnAttackSound();
	}

	// attack_2
	void MonstersDjinnFire_OnAttack22()
	{
		I_ATTACKED = true;

		if (RangeTo(HUNT_LASTTARGET) <= ATTACK_HITRANGE)
			DoDamageEx(HUNT_LASTTARGET, "direct", Random(80, 200), "75%", ENT_ME, ENT_ME, "none", "blunt", "dmgevent:swing");
		ANIM_ATTACK = "double_punch";

		if (RandomInt(1, PUSH_CHANCE) == 1)
		{
			CallEventDelayed(0.1f, "rawr");
			ApplyEffect(EntityOf(ENT_LASTSTRUCKBYME), "effects/effect_push", 3, RelativeVelocity(Vector3(0, 400, 400)), 0);
		}

		OnAttackSound();
	}

	// swing_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	void MonstersDjinnFire_OnSwingDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		ApplyEffect(EntityOf(ENT_LASTSTRUCKBYME), "effects/dot_fire", 3, self, FIRE_DAMAGE);
	}

	// npc_struck
	void MonstersDjinnFire_OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(Int(GetVar("CHAN_BODY")), 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK2);
	}

	// attack_sound
	void MonstersDjinnFire_OnAttackSound(float pitch = 0.0f)
	{
		PlaySound(0, 10, SOUND_ATTACK1);
	}

	// npc_death
	void MonstersDjinnFire_OnNpcDeath()
	{
		ClientEvent("remove", "all", FIRE_SCRIPT);

		if (MY_ICE_TROLL != "MY_ICE_TROLL")
			DeleteEntity(MY_ICE_TROLL, "fade");

		ClientEvent("remove", "all", "SCRIPT_ID");
		ClientEvent("remove", TORCH_LIGHT_SCRIPT);
		ClientEvent("remove", "all", TORCH_LIGHT_SCRIPT);
	}

	// summon_firetroll
	void MonstersDjinnFire_OnSummonFiretroll()
	{
		if (NO_SUMMON)
			return;

		CallEventDelayed(10.0f, "summon_firetroll");

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

		Vector3 summonPos = RelativePosition(Vector3(0, 0, 0)); // only safe summon position, due to monsterclip around walkway

		PlayAnim("critical", "throw_rock");

		CBaseEntity@ summonPoint1 = FindByName("summon_point1");
		if (Exists(summonPoint1))
			summonPos = OriginOf(summonPoint1);

		if (!Exists(summonPoint1))
			SetSolid("none");

		CreateNpc(SUMMON_SCRIPT, summonPos);

		CallEventDelayed(1.0f, "solidify_djinn"); // stops me from getting stuck inside my pet

		MY_ICE_TROLL = EntityId(EntityOf(ENT_LASTCREATED));

		SUMMON_NEXT_CHECK = false;

		// run away for a second to get outside of my summoned
		if (!IS_FLEEING)
			OnNpcatkFlee(MY_ICE_TROLL, "275", "3");
	}

	// solidify_djinn
	void MonstersDjinnFire_OnSolidifyDjinn()
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
	void MonstersDjinnFire_OnNpcTargetsighted(string target = "")
	{
		if (DID_ROAR_INTRO)
			return;

		SetVolume(10);
		PlaySound(Int(Eval("game.sound.voice")), 10, SOUND_ROAR);

		DID_ROAR_INTRO = true;
	}

	// rawr
	void MonstersDjinnFire_OnRawr()
	{
		SetVolume(10);
		PlaySound(Int(Eval("game.sound.voice")), 10, SOUND_ROAR);
	}

	// my_pet_stuck
	void MonstersDjinnFire_OnMyPetStuck()
	{
		// called by Troll Ice when Stuck Count == 2
		// dbg my pet says he's stuck, resummoning
		DeleteEntity(MY_ICE_TROLL, "fade");

		SetVolume(10);
		PlaySound(2, 10, SOUND_SUMMON);

		Vector3 summonPos = RelativePosition(Vector3(0, 0, 0)); // only safe summon position, due to monsterclip around walkway

		AS_ATTACKING = 20.0f;
		PlayAnim("critical", "throw_rock");

		SetSolid("none");

		CreateNpc(SUMMON_SCRIPT, summonPos);

		CallEventDelayed(1.0f, "solidify_djinn"); // stops me from getting stuck inside my pet

		MY_ICE_TROLL = EntityId(EntityOf(ENT_LASTCREATED));

		SUMMON_NEXT_CHECK = false;

		// run away for a second to get outside of my summoned
		if (!IS_FLEEING)
			OnNpcatkFlee(MY_ICE_TROLL, "275", "3");
	}

	// stomp_1
	// called by model run @ frame 10 (newer June 27,2006+ model only)
	void MonstersDjinnFire_OnStomp1()
	{
		PlaySound(2, 8, SOUND_WALK1);
	}

	// stomp_2
	// called by model run @ frame 30 (newer June 27,2006+ model only)
	void MonstersDjinnFire_OnStomp2()
	{
		PlaySound(2, 8, SOUND_WALK2);
	}

	// cycle_up
	void MonstersDjinnFire_OnCycleUp(string reason = "")
	{
		if (CYCLED_UP)
			return;
		SetRoam(true);
	}

	// set_no_summons
	void MonstersDjinnFire_OnSetNoSummons()
	{
		NO_SUMMON = true;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttack_OnCycleUp(reason); // monsters/base_npc_attack
		MonstersDjinnFire_OnCycleUp(reason);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		MonstersDjinnFire_OnNpcSpawn(npc);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		MonstersDjinnFire_OnNpcTargetsighted(target);
	}

	void OnAttack12() { MonstersDjinnFire_OnAttack12(); } // attack_1
	void OnAttack22() { MonstersDjinnFire_OnAttack22(); } // attack_2
	void OnSwingDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { MonstersDjinnFire_OnSwingDodamage(hit, target, start, end, damageType, damageText); } // swing_dodamage
	void OnNpcStruck(float damage = 0.0f) { MonstersDjinnFire_OnNpcStruck(damage); } // npc_struck
	void OnAttackSound(float pitch = 0.0f) { MonstersDjinnFire_OnAttackSound(pitch); } // attack_sound
	void OnNpcDeath() { MonstersDjinnFire_OnNpcDeath(); } // npc_death
	void OnSummonFiretroll() { MonstersDjinnFire_OnSummonFiretroll(); } // summon_firetroll
	void OnSolidifyDjinn() { MonstersDjinnFire_OnSolidifyDjinn(); } // solidify_djinn
	void OnRawr() { MonstersDjinnFire_OnRawr(); } // rawr
	void OnMyPetStuck() { MonstersDjinnFire_OnMyPetStuck(); } // my_pet_stuck
	void OnStomp1() { MonstersDjinnFire_OnStomp1(); } // stomp_1
	void OnStomp2() { MonstersDjinnFire_OnStomp2(); } // stomp_2
	void OnSetNoSummons() { MonstersDjinnFire_OnSetNoSummons(); } // set_no_summons
	void OnTrollSpawn() {} // troll_spawn

	// This file's events and timers by their .script names
	bool MonstersDjinnFire_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "attack_sound") { OnAttackSound(Float(Param(params, 0))); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "my_pet_stuck") { OnMyPetStuck(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "rawr") { OnRawr(); return true; }
		if (name == "set_no_summons") { OnSetNoSummons(); return true; }
		if (name == "solidify_djinn") { OnSolidifyDjinn(); return true; }
		if (name == "stomp_1") { OnStomp1(); return true; }
		if (name == "stomp_2") { OnStomp2(); return true; }
		if (name == "summon_firetroll") { OnSummonFiretroll(); return true; }
		if (name == "swing_dodamage") { OnSwingDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/djinn_fire"]
shared class MonstersDjinnFireScript : BaseMonsterScript, MonstersDjinnFire
{
	// Variables every script that includes this file declares
	int AIM_RATIO = 0;
	int ATTACK_CONE_OF_FIRE = 0;
	int ATTACK_SPEED = 0;
	string BURN_DAMAGE = "BURN_DAMAGE";
	bool CANT_FLEE = false;
	bool DO_NADDA = false;
	string FIRE_BALL_DAMAGE = "FIRE_BALL_DAMAGE";
	bool FIRE_BALL_DELAY = false;
	float FIRE_BALL_FREQ = 0.0f;
	int FIRE_BALL_RANGE = 0;
	string SOUND_FIRESHOOT = "SOUND_FIRESHOOT";
	string SOUND_WARCRY = "SOUND_WARCRY";
	float WARCRY_FREQ = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	MonstersDjinnFireScript()
	{
		NPC_BOSS_RESTORATION = 1.0f;
		SOUND_DEATH = "monsters/troll/trolldeath.wav";
		ANIM_IDLE = "idle0";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/troll.mdl");
		Precache("monsters/firetroll.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MonstersDjinnFire_FirstThink();
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
		return MonstersDjinnFire_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
