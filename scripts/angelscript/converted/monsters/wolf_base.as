#pragma context server

// Converted from monsters/wolf_base.script by msc_transpiler.
// Wolf by Thothie from scratch
// - unique behavior: pack formation
// - wolves will stay near their alpha leader to form a pack
// - wolves will not flee if their alpha is alive, instead they will simply run to the alpha for protection
// - alpha wolves never flee (fight to the death)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class WolfBase
{
	// Constants
	string ANIM_LEAP = "attack2";
	string ANIM_CLAW = "attack2";
	string ANIM_HOWL = "howl";
	string ANIM_ALERT = "threat";
	string ANIM_IDLE_SIT = "sit_idle1";
	string ANIM_IDLE_SIT2 = "sit_idle2";
	string ANIM_IDLE_STAND = "standidle1";
	string ANIM_IDLE_STAND2 = "standidle2";
	string ANIM_IDLE_STAND3 = "guard";
	string ANIM_TOSTAND = "standup";
	string ANIM_BITE = "attack1";
	string ANIM_EAT = "eat";
	string ANIM_FLINCH1 = "hopback";
	string ANIM_FLINCH2 = "pain1";
	string ANIM_FLINCH3 = "pain2";
	string ATTACK_HITCHANCE = "70";
	int LEAP_RANGE = 256;
	float DMG_BITE = 0.0f;
	float DMG_CLAW = 0.0f;
	float FREQ_LOOK = 20.0f;
	float FREQ_IDLE = 0.0f;
	float FREQ_HOWL = 0.0f;
	int CHANCE_CLAW = 50;
	string SOUND_HOWL1 = "monsters/wolves/wolf_howl1.wav";
	string SOUND_HOWL2 = "monsters/wolves/wolf_howl2.wav";
	string SOUND_GROWL = "monsters/wolves/wolf_alert.wav";
	string SOUND_ATK1 = "monsters/wolves/wolf_atk1.wav";
	string SOUND_ATK2 = "monsters/wolves/wolf_atk2.wav";
	string SOUND_ATK3 = "monsters/wolves/wolf_atk3.wav";
	string SOUND_PAIN = "monsters/wolves/wolf_yelp1.wav";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_YELP = "monsters/wolves/wolf_yelp2.wav";
	string SOUND_DEATH = "monsters/wolves/wolf_death.wav";
	string MONSTER_MODEL = "monsters/normal_wolf.mdl";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK = "run";
	string ANIM_RUN = "run";
	string ANIM_IDLE = "standidle1";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	float NPC_ALLY_RESPONSE_RANGE = 0.0f;
	string ANIM_FLINCH = "ANIM_FLINCH";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	string CAN_FLEE = "CAN_FLEE";
	int FLEE_HEALTH = 0;
	string FLEE_CHANCE = "FLEE_CHANCE";
	float NEXT_HOWL = 0.0f;
	string MY_ALPHA = "MY_ALPHA";
	bool SIT_MODE = false;
	bool NPC_FORCED_MOVEDEST = false;
	string ATTACK_TYPE = "ATTACK_TYPE";
	bool DID_ALLY_ALERT = false;
	float SEARCH_DELAY = 0.0f;
	string FLINCH_ANIM = "FLINCH_ANIM";

	// unnamed block (first think)
	void WolfBase_FirstThink()
	{
		// _base anims
		ANIM_WALK = "run"; // model needs a walk anim
		ANIM_RUN = "run";
		ANIM_IDLE = "standidle1";
		ANIM_DEATH = "die1";
		ANIM_ATTACK = "attack1"; // using event bite1
		NPC_ALLY_RESPONSE_RANGE = 2048.0f;
		ANIM_FLINCH = "hopback";

		// _base stats
		ATTACK_RANGE = 92.0f;
		ATTACK_HITRANGE = 128.0f;
		ATTACK_MOVERANGE = 72.0f;
		CAN_FLEE = "1";
		FLEE_HEALTH = 25;
		FLEE_CHANCE = "25";
	}

	// npc_spawn
	void WolfBase_OnNpcSpawn(string npc = "")
	{
		SetName("Wolf");
		SetRace("rogue"); // attacks everything but its own
		SetModel(MONSTER_MODEL);
		SetHearingSensitivity(8);
		SetWidth(36);
		SetHeight(48);
		SetRoam(true);
		if (!Truthy(GetVar("AM_ALPHA")))
		{
			SetHealth(50);
			// setvard NPC_GIVE_EXP 30
			SetModelBody(0, 0); // some skin
			CallEventDelayed(3.0f, "find_alpha");
		}
		if (Truthy(GetVar("AM_ALPHA")))
		{
			SetHealth(75);
			// setvard NPC_GIVE_EXP 35
			SetModelBody(0, 1); // some skin
			FLEE_HEALTH = 0;
		}

		if (ToLowerCase(MapName()) == "sfor" && RandomInt(1, 100) == 50)
			GiveItem("swords_wolvesbane");

		NEXT_HOWL = 0.0f;
	}

	// npc_post_spawn
	void WolfBase_OnNpcPostSpawn()
	{
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
	}

	// find_alpha
	void WolfBase_OnFindAlpha()
	{
		CallExternal("all", "ext_wolf_setalpha");
		if (IsAlive(GetVar("G_ALPHA")))
			MY_ALPHA = GetVar("G_ALPHA");
		if (!IsAlive(GetVar("G_ALPHA")))
			MY_ALPHA = "unset";
	}

	// ext_wolf_setalpha
	void WolfBase_OnExtWolfSetalpha()
	{
		if (!Truthy(GetVar("AM_ALPHA")))
			return;
		SetGlobal("G_ALPHA", self);
	}

	// unnamed block (timer)
	void WolfBase_Timer()
	{
		bool exitSub = false;
		CallEventDelayed(FREQ_IDLE, "WolfBase_Timer");

		if (!Truthy(GetVar("AM_ALPHA")) && MY_ALPHA != "unset")
			OnNpcatkSetmovedest(GetVar("G_ALPHA"), Text(ATTACK_MOVERANGE));

		if (NPCATK_TARGET != "unset")
			return;

		if (GameTime() > NEXT_HOWL)
		{
			DebugPrint("idle howl");
			NEXT_HOWL = GameTime() + FREQ_HOWL;
			OnDoHowl();
			exitSub = true;
		}
		if (exitSub)
			return;

		if (SIT_MODE)
			PlayAnim("critical", ANIM_IDLE_SIT2);
		if (!SIT_MODE)
		{
			int rndIdle = RandomInt(1, 2);
			if (rndIdle == 1)
			{
				OnAtkSound();
				PlayAnim("critical", ANIM_IDLE_STAND2);
			}
			if (rndIdle == 2)
			{
				PlaySound(0, 10, SOUND_GROWL);
				PlayAnim("critical", ANIM_IDLE_STAND3);
			}
		}

		if (!Truthy(GetVar("AM_ALPHA")))
			return;
		if (RandomInt(1, 2) != 1)
			return;
		if (SIT_MODE)
			CallEventDelayed(0.5f, "sitmode_off");
		if (!SIT_MODE)
			CallEventDelayed(0.5f, "sitmode_on");
	}

	// sitmode_off
	void WolfBase_OnSitmodeOff()
	{
		if (SIT_MODE)
			PlayAnim("critical", ANIM_TOSTAND);
		SIT_MODE = false;
		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE);
	}

	// sitmode_on
	void WolfBase_OnSitmodeOn()
	{
		SIT_MODE = true;
		SetMoveAnim(ANIM_IDLE_SIT);
		SetIdleAnim(ANIM_IDLE_SIT);
	}

	// npcatk_checkflee
	void WolfBase_OnNpcatkCheckflee()
	{
		// (always true here) if !CANT_FLEE

		if (FLEE_HEALTH > 0 && MyHealth() < FLEE_HEALTH && RandomInt(1, 100) <= Float(FLEE_CHANCE) && !Truthy(GetVar("AM_ALPHA")))
		{
			if (IsAlive(MY_ALPHA))
			{
				NPC_FORCED_MOVEDEST = true;
				SetMoveDest(MY_ALPHA, ATTACK_MOVERANGE);
				OnNpcatkSuspendAi("2.0");
			}
			if (!IsAlive(MY_ALPHA))
				OnNpcatkFlee(EntityId(EntityOf(ENT_LASTSTRUCK)), FLEE_DISTANCE, "10.0");
		}
	}

	// bite1
	// anim events
	void WolfBase_OnBite1()
	{
		ATTACK_TYPE = "bite";
		DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, DMG_BITE, ATTACK_HITCHANCE, ENT_ME, ENT_ME, "none", "slash", "dmgevent:wolfatk");
		OnAtkSound();
		if (RandomInt(1, 100) < CHANCE_CLAW)
			ANIM_ATTACK = ANIM_CLAW;
	}

	// claw1
	void WolfBase_OnClaw1()
	{
		ATTACK_TYPE = "claw";
		DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, DMG_CLAW, ATTACK_HITCHANCE, ENT_ME, ENT_ME, "none", "slash", "dmgevent:wolfatk");
		OnAtkSound();

		ANIM_ATTACK = ANIM_BITE;
	}

	// npc_aiding_ally
	// ==== end anim events
	void WolfBase_OnNpcAidingAlly(CBaseEntity@ allyToAid = null, string caller = "")
	{
		CallExternal(NPC_ALLY_TO_AID, "being_aided");
	}

	// being_aided
	void WolfBase_OnBeingAided()
	{
		// wolves being aided howl (to simulate calling allies)
		if (DID_ALLY_ALERT)
			return;
		DID_ALLY_ALERT = true;
		OnDoHowl();
	}

	// do_howl
	void WolfBase_OnDoHowl()
	{
		if (IsAlive(ENT_ME))
			PlayAnim("critical", ANIM_HOWL);
		PlayRandomSound(0, 10, SOUND_HOWL1, SOUND_HOWL2);
	}

	// npcatk_lost_sight
	void WolfBase_OnNpcatkLostSight()
	{
		if (CanSee("enemy"))
			return;
		if (int(SEARCH_DELAY) != 0)
			return;
		SEARCH_DELAY = 1.0f;
		PlaySound(0, 10, SOUND_GROWL);
		CallEventDelayed(FREQ_LOOK, "reset_search_delay");
		OnDoHowl();
	}

	// reset_search_delay
	void WolfBase_OnResetSearchDelay()
	{
		SEARCH_DELAY = 0.0f;
	}

	// npc_flinch
	void WolfBase_OnNpcFlinch(float damage = 0.0f)
	{
		// monster favorw backpedal for flinch, but has two other less likely flinches, including a rollover
		int rndFlinch = RandomInt(1, 5);
		if (rndFlinch == 1)
			FLINCH_ANIM = ANIM_FLINCH2;
		if (rndFlinch == 2)
			FLINCH_ANIM = ANIM_FLINCH3;
		if (rndFlinch > 2)
			FLINCH_ANIM = ANIM_FLINCH1;
		PlaySound(0, 10, SOUND_YELP);
	}

	// cycle_up
	void WolfBase_OnCycleUp(string reason = "")
	{
		if (SIT_MODE)
			OnSitmodeOff();
	}

	// atk_sound
	void WolfBase_OnAtkSound()
	{
		PlayRandomSound(0, 10, SOUND_ATK1, SOUND_ATK2, SOUND_ATK3);
	}

	// game_struck
	void WolfBase_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_PAIN);
	}

	// game_dodamage
	string WolfBase_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (!hit)
			return result;
		if (ATTACK_TYPE == "bite")
			AddVelocity(target, RelativeVelocity(Vector3(-50, 110, 105)));
		if (ATTACK_TYPE == "claw")
			AddVelocity(target, RelativeVelocity(Vector3(-100, 130, 120)));
		ATTACK_TYPE = "none";
		return result;
	}

	// game_death
	void WolfBase_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		int rndDeath = RandomInt(1, 2);
		if (rndDeath == 1)
			ANIM_DEATH = "die1";
		if (rndDeath == 2)
			ANIM_DEATH = "die2";
	}

	// my_target_died
	void WolfBase_OnMyTargetDied(string offender = "")
	{
		if (CanSee("enemy"))
			return;
		PlayAnim("once", ANIM_EAT);
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
		WolfBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
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
		WolfBase_OnNpcPostSpawn();
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		WolfBase_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		WolfBase_OnNpcSpawn(npc);
	}

	// npcatk_lost_sight
	void OnNpcatkLostSight()
	{
		BaseNpcAttackNew_OnNpcatkLostSight(); // monsters/base_npc_attack_new
		WolfBase_OnNpcatkLostSight();
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		WolfBase_OnMyTargetDied(offender);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, WolfBase_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		WolfBase_OnCycleUp(reason);
	}

	void OnFindAlpha() { WolfBase_OnFindAlpha(); } // find_alpha
	void OnExtWolfSetalpha() { WolfBase_OnExtWolfSetalpha(); } // ext_wolf_setalpha
	void OnSitmodeOff() { WolfBase_OnSitmodeOff(); } // sitmode_off
	void OnSitmodeOn() { WolfBase_OnSitmodeOn(); } // sitmode_on
	void OnNpcatkCheckflee() { WolfBase_OnNpcatkCheckflee(); } // npcatk_checkflee
	void OnBite1() { WolfBase_OnBite1(); } // bite1
	void OnClaw1() { WolfBase_OnClaw1(); } // claw1
	void OnNpcAidingAlly(CBaseEntity@ allyToAid = null, string caller = "") { WolfBase_OnNpcAidingAlly(allyToAid, caller); } // npc_aiding_ally
	void OnBeingAided() { WolfBase_OnBeingAided(); } // being_aided
	void OnDoHowl() { WolfBase_OnDoHowl(); } // do_howl
	void OnResetSearchDelay() { WolfBase_OnResetSearchDelay(); } // reset_search_delay
	void OnNpcFlinch(float damage = 0.0f) { WolfBase_OnNpcFlinch(damage); } // npc_flinch
	void OnAtkSound() { WolfBase_OnAtkSound(); } // atk_sound
	void OnFreqLook() {} // FREQ_LOOK

	// This file's events and timers by their .script names
	bool WolfBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "atk_sound") { OnAtkSound(); return true; }
		if (name == "being_aided") { OnBeingAided(); return true; }
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "claw1") { OnClaw1(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_howl") { OnDoHowl(); return true; }
		if (name == "ext_wolf_setalpha") { OnExtWolfSetalpha(); return true; }
		if (name == "find_alpha") { OnFindAlpha(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_aiding_ally") { OnNpcAidingAlly(EntityParam(params, 0), Param(params, 1)); return true; }
		if (name == "npc_flinch") { OnNpcFlinch(Float(Param(params, 0))); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_checkflee") { OnNpcatkCheckflee(); return true; }
		if (name == "npcatk_lost_sight") { OnNpcatkLostSight(); return true; }
		if (name == "reset_search_delay") { OnResetSearchDelay(); return true; }
		if (name == "sitmode_off") { OnSitmodeOff(); return true; }
		if (name == "sitmode_on") { OnSitmodeOn(); return true; }
		if (name == "WolfBase_Timer") { WolfBase_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/wolf_base"]
shared class WolfBaseScript : BaseMonsterNewScript, WolfBase
{
	// Variables declared by included files, with the value they start with in this script
	WolfBaseScript()
	{
		ANIM_WALK = "run";
		ANIM_RUN = "run";
		ANIM_IDLE = "standidle1";
		SOUND_DEATH = "monsters/wolves/wolf_death.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/normal_wolf.mdl");
		CallEventDelayed(FREQ_IDLE, "WolfBase_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		WolfBase_FirstThink();
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
		return WolfBase_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
