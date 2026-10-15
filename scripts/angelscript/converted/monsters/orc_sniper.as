#pragma context server

// Converted from monsters/orc_sniper.script by msc_transpiler.
// Thothie: Orc Sniper re-write JAN2009
// - meh, this broke for reasons I couldnt figure so I needlessly re-wrote it
// - turns out it is due to the range adjustments in base orc... however
// - ...I can't for the life of me figure WHY wasnt an issue before. :\

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_ranged.as"
#include "converted/monsters/orc_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class OrcSniper
{
	// Constants
	string ARROW_TYPE = "proj_arrow_npc";
	int ATTACK_SPEED = 900;
	int DMG_BOW = 0;
	int KICK_RANGE = 96;
	int KICK_HITRANGE = 128;
	int KICK_HITCHANCE = 90;
	string ANIM_SMASH = "battleaxe_swing1_L";
	string ANIM_SWIPE = "swordswing1_L";
	string ANIM_BOW = "shootorcbow";
	string ANIM_KICK = "kick";
	string DMG_SMASH = "$rand(30,75)";
	string DMG_SWIPE = "$rand(10,30)";
	string DMG_KICK = "$rand(10,30)";
	bool ALT_ATTACKS = true;
	float FREQ_KICK = 10.0f;
	string DROP_ITEM_BASE1 = "bows_longbow";
	string CONTAINER_BASE = "chests/quiver_of_jagged";
	int FIN_EXP = 100;
	string SOUND_KICK = "zombie/claw_miss1.wav";

	// Variables (an unset .script variable reads as its own name)
	int ATTACK_CONE_OF_FIRE = 0;
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	string DROP_ITEM1 = "DROP_ITEM1";
	string DROP_ITEM1_CHANCE = "DROP_ITEM1_CHANCE";
	int DROPS_CONTAINER = 0;
	string CONTAINER_DROP_CHANCE = "CONTAINER_DROP_CHANCE";
	string CONTAINER_SCRIPT = "CONTAINER_SCRIPT";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	float NPC_GIVE_EXP = 0.0f;
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	bool IS_ARROW = false;
	bool MELEE_ATK = false;
	string ATTACK_PUSH = "ATTACK_PUSH";
	float NEXT_KICK = 0.0f;
	float ARROW_MISSED = 0.0f;
	bool AM_TURRET = false;
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_WALK = "ANIM_WALK";
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	bool DID_SPOT_SPEECH = false;
	string SPOT_SPEECH = "SPOT_SPEECH";
	string SPAWN_SPEECH = "SPAWN_SPEECH";
	float SPAWN_SPEECH_DELAY = 0.0f;

	// unnamed block (first think)
	void OrcSniper_FirstThink()
	{
		ATTACK_CONE_OF_FIRE = 2; // Cone of fire

		// base
		DROP_GOLD = 1;
		DROP_GOLD_AMT = RandomInt(10, 20);
		DROP_ITEM1 = DROP_ITEM_BASE1;
		DROP_ITEM1_CHANCE = "5%";
		DROPS_CONTAINER = 1;
		CONTAINER_DROP_CHANCE = "30%";
		CONTAINER_SCRIPT = CONTAINER_BASE;
		ANIM_ATTACK = "shootorcbow";
		FLINCH_CHANCE = "45%";
		NPC_GIVE_EXP = FIN_EXP;
		MOVE_RANGE = "2000";
		ATTACK_RANGE = 2000.0f;
		ATTACK_HITRANGE = 2000.0f;
		ATTACK_MOVERANGE = 2000.0f;
	}

	// orc_spawn
	void OrcSniper_OnOrcSpawn()
	{
		SetName("Elite Blackhand Archer");
		if (MapName() == "ms_wicardoven")
		{
			SetName("Voldar Scout");
			SetProp(ENT_ME, "skin", 3);
		}
		SetHealth(220);
		SetHearingSensitivity(2);
		SetStat("parry", 30);
		SetDamageTaken("all", 0.8f);

		SetModelBody(0, 3); // Body 0=naked 1=leather 2=plate 3=green-hide
		SetModelBody(1, 3); // Head 0=cap_shorthorn 1=cap_nohorn 2=buffo_skin 3=cheif_ramhorns 4=green_hood
		SetModelBody(2, 3); // Weapon 0=fist 1=axe 2=bow_weak 3=bow_strng 4=sword 5=bloodyaxe 6=sword&sheild

		CallEventDelayed(1.0f, "reset_range"); // debug
	}

	// reset_range
	void OrcSniper_OnResetRange()
	{
		ATTACK_HITRANGE = 2000.0f;
	}

	// shoot_arrow
	void OrcSniper_OnShootArrow()
	{
		float targetDist = RangeTo(ENT_LASTSEEN);
		Vector3 finalTarget = OriginOf(ENT_LASTSEEN);
		finalTarget += RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, targetDist));
		targetDist = Divide(targetDist, 100.0f);
		SetAngle("add_view.pitch", targetDist);

		IS_ARROW = true;
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile(ARROW_TYPE, RelativePosition(Vector3(0, 0, 18)), "none", 900, DMG_BOW, ATTACK_CONE_OF_FIRE, "none");
		CallExternal(EntityOf(ENT_LASTPROJECTILE), "ext_lighten", 0.4f);

		if (!Truthy(GetVar("AM_SORC")))
		{
			SetModelBody(3, 0); // Hide arrow
		}
		else
		{
			SetModelBody(2, 2);
			DebugPrint("hide arrow");
		}
		PlaySound(2, 10, SOUND_BOW);

		MELEE_ATK = false;
	}

	// grab_arrow
	void OrcSniper_OnGrabArrow()
	{
		if (!Truthy(GetVar("AM_SORC")))
		{
			SetModelBody(3, 1); // Show Arrow
		}
		else
		{
			SetModelBody(2, 3);
			DebugPrint("show arrow");
		}
	}

	// game_death
	void OrcSniper_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (!Truthy(GetVar("AM_SORC")))
		{
			SetModelBody(3, 0); // Hide arrow
		}
		else
		{
			SetModelBody(2, 2);
		}
	}

	// npcatk_hunt
	void OrcSniper_OnNpcatkHunt()
	{
		if (!IsAlive(NPCATK_TARGET))
			return;
		if (RangeTo(NPCATK_TARGET) >= KICK_RANGE)
			ANIM_ATTACK = ANIM_BOW;
		if (!(RangeTo(NPCATK_TARGET) < KICK_RANGE))
			return;
		if (!(GameTime() > NEXT_KICK))
			return;
		if (ANIM_ATTACK != ANIM_BOW)
			return;
		PlayAnim("break");
		if (!Truthy(GetVar("AM_SORC")))
		{
			SetModelBody(3, 0); // Hide arrow
		}
		else
		{
			SetModelBody(2, 2);
		}
		ANIM_ATTACK = ANIM_SWIPE;
	}

	// swing_sword
	// swipe attack
	void OrcSniper_OnSwingSword()
	{
		ANIM_ATTACK = ANIM_KICK;

		PlaySound(0, 10, SOUND_KICK);
		ATTACK_PUSH = Text(RelativeVelocity(Vector3(-100, 130, 120)));
		OnNpcatkDodamage(NPCATK_TARGET, Text(KICK_HITRANGE), DMG_SWIPE, Text(KICK_HITCHANCE));
	}

	// kick_land
	void OrcSniper_OnKickLand()
	{
		ANIM_ATTACK = ANIM_SMASH;

		PlaySound(0, 10, SOUND_KICK);
		ATTACK_PUSH = Text(RelativeVelocity(Vector3(50, 130, 120)));
		OnNpcatkDodamage(NPCATK_TARGET, Text(KICK_HITRANGE), DMG_KICK, Text(KICK_HITCHANCE));
	}

	// swing_axe
	void OrcSniper_OnSwingAxe()
	{
		PlaySound(0, 10, SOUND_KICK);
		ATTACK_PUSH = Text(RelativeVelocity(Vector3(50, 130, 120)));
		OnNpcatkDodamage(NPCATK_TARGET, Text(KICK_HITRANGE), DMG_SMASH, Text(KICK_HITCHANCE));
		if (!(RangeTo(NPCATK_TARGET) < KICK_HITRANGE))
			return;
		if (RandomInt(1, 2) != 1)
			return;
		ApplyEffect(EntityOf(NPCATK_TARGET), "effects/debuff_stun", 7, self);
		if (!AM_TURRET)
			OnNpcatkFlee(NPCATK_TARGET, "600", "2");
		NEXT_KICK = GameTime() + FREQ_KICK;
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string OrcSniper_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (IS_ARROW)
		{
			if (!hit)
				ARROW_MISSED += 1.0f;
			// if ( AM_TURRET ) add ATTACK_CONE_OF_FIRE 1 //not work so good
			if (hit)
			{
				ARROW_MISSED = 0.0f;
				if (GetVar("ARROW_PUSH_VEL") != "ARROW_PUSH_VEL")
					AddVelocity(target, Vec(GetVar("ARROW_PUSH_VEL")));
			}
		}
		// if ( AM_TURRET ) setvard ATTACK_CONE_OF_FIRE 2
		IS_ARROW = false;

		if (!(ARROW_MISSED > 3.0f))
			return result;
		OnChangePosition();
		ARROW_MISSED = 0.0f;
		return result;
	}

	// change_position
	void OrcSniper_OnChangePosition()
	{
		// can't hit from here, so running in a random direction for 3 seconds.
		if (AM_TURRET)
			return;
		PlayAnim("critical", ANIM_RUN);
		OnChickenRun(3.0f);
	}

	// set_turret
	void OrcSniper_OnSetTurret()
	{
		AM_TURRET = true;
		SetMoveAnim(ANIM_IDLE);
		ANIM_RUN = ANIM_IDLE;
		ANIM_WALK = ANIM_IDLE;
		NO_STUCK_CHECKS = "1";
		SetRoam(false);
	}

	// npc_post_spawn
	void OrcSniper_OnNpcPostSpawn()
	{
		// redundant
		if (!AM_TURRET)
			return;
		SetMoveAnim(ANIM_IDLE);
		ANIM_RUN = ANIM_IDLE;
		ANIM_WALK = ANIM_IDLE;
		NO_STUCK_CHECKS = "1";
		SetRoam(false);
	}

	// npc_targetsighted
	// ========== Sorc comments here as Sorc Archers don't actually use Sorc Base
	void OrcSniper_OnNpcTargetsighted(string target = "")
	{
		if (DID_SPOT_SPEECH)
			return;
		DID_SPOT_SPEECH = true;
		if (SPOT_SPEECH == "SPOT_SPEECH")
			return;
		SayText(SPOT_SPEECH);
	}

	// npc_post_spawn
	void OrcSniper_OnNpcPostSpawn_2()
	{
		if (SPAWN_SPEECH == "SPAWN_SPEECH")
			return;
		CallEventDelayed(SPAWN_SPEECH_DELAY, "say_spawn_speech");
	}

	// say_spawn_speech
	void OrcSniper_OnSaySpawnSpeech()
	{
		SayText(SPAWN_SPEECH);
	}

	// set_sorcpal_getem1
	void OrcSniper_OnSetSorcpalGetem1()
	{
		SetSayTextRange(2048);
		SPOT_SPEECH = "Get em!";
	}

	// set_sorcpal_getem2
	void OrcSniper_OnSetSorcpalGetem2()
	{
		SetSayTextRange(2048);
		if (PlayerCount() > 1)
			SPAWN_SPEECH = "Let's see them get out of this one!";
		else
			SPAWN_SPEECH = "Let's see him get out of this one!";
		SPAWN_SPEECH_DELAY = 3.0f;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseRanged_OnOrcSpawn(); // monsters/orc_base_ranged
		OrcSniper_OnOrcSpawn();
	}

	// grab_arrow
	void OnGrabArrow()
	{
		OrcBaseRanged_OnGrabArrow(); // monsters/orc_base_ranged
		OrcSniper_OnGrabArrow();
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		OrcBaseRanged_OnNpcTargetsighted(target); // monsters/orc_base_ranged
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		OrcSniper_OnNpcTargetsighted(target);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		OrcBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/orc_base
		OrcSniper_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
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
		OrcBase_OnNpcPostSpawn(); // monsters/orc_base
		OrcSniper_OnNpcPostSpawn();
		OrcSniper_OnNpcPostSpawn_2();
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		OrcSniper_OnNpcatkHunt();
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, OrcSniper_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	void OnResetRange() { OrcSniper_OnResetRange(); } // reset_range
	void OnShootArrow() { OrcSniper_OnShootArrow(); } // shoot_arrow
	void OnSwingSword() { OrcSniper_OnSwingSword(); } // swing_sword
	void OnKickLand() { OrcSniper_OnKickLand(); } // kick_land
	void OnSwingAxe() { OrcSniper_OnSwingAxe(); } // swing_axe
	void OnChangePosition() { OrcSniper_OnChangePosition(); } // change_position
	void OnSetTurret() { OrcSniper_OnSetTurret(); } // set_turret
	void OnSaySpawnSpeech() { OrcSniper_OnSaySpawnSpeech(); } // say_spawn_speech
	void OnSetSorcpalGetem1() { OrcSniper_OnSetSorcpalGetem1(); } // set_sorcpal_getem1
	void OnSetSorcpalGetem2() { OrcSniper_OnSetSorcpalGetem2(); } // set_sorcpal_getem2
	void OnSpawnSpeechDelay() {} // SPAWN_SPEECH_DELAY

	// This file's events and timers by their .script names
	bool OrcSniper_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "change_position") { OnChangePosition(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "grab_arrow") { OnGrabArrow(); return true; }
		if (name == "kick_land") { OnKickLand(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "reset_range") { OnResetRange(); return true; }
		if (name == "say_spawn_speech") { OnSaySpawnSpeech(); return true; }
		if (name == "set_sorcpal_getem1") { OnSetSorcpalGetem1(); return true; }
		if (name == "set_sorcpal_getem2") { OnSetSorcpalGetem2(); return true; }
		if (name == "set_turret") { OnSetTurret(); return true; }
		if (name == "shoot_arrow") { OnShootArrow(); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/orc_sniper"]
shared class OrcSniperScript : OrcBaseScript, OrcSniper, OrcBaseRanged
{
	// Variables declared by included files, with the value they start with in this script
	OrcSniperScript()
	{
		ANIM_RUN = "ANIM_RUN";
		ANIM_WALK = "ANIM_WALK";
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OrcSniper_FirstThink();
		OrcBaseRanged_FirstThink();
		OrcBase_FirstThink();
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
		return OrcSniper_DispatchEvent(name, params)
			|| OrcBaseRanged_DispatchEvent(name, params)
			|| OrcBaseScript::DispatchEvent(name, params);
	}
}
