#pragma context server

// Converted from monsters/orc_base.script by msc_transpiler.
// Orc base

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class OrcBase
{
	// Constants
	string SOUND_STRUCK1 = "body/armour1.wav";
	string SOUND_STRUCK2 = "body/armour2.wav";
	string SOUND_STRUCK3 = "body/armour3.wav";
	string SOUND_HIT = "voices/orc/hit.wav";
	string SOUND_HIT2 = "voices/orc/hit2.wav";
	string SOUND_HIT3 = "voices/orc/hit3.wav";
	string SOUND_PAIN = "monsters/orc/pain.wav";
	string SOUND_WARCRY1 = "monsters/orc/battlecry.wav";
	string SOUND_ATTACK1 = "voices/orc/attack.wav";
	string SOUND_ATTACK2 = "voices/orc/attack2.wav";
	string SOUND_ATTACK3 = "voices/orc/attack3.wav";
	string SOUND_HELP = "voices/orc/help.wav";
	float ZORC_DMG_MULTI = 5.0f;
	float ZORC_HP_MULTI = 6.0f;
	string SOUND_ZOMB_STRUCK1 = "debris/flesh2.wav";
	string SOUND_ZOMB_STRUCK2 = "agrunt/ag_pain3.wav";
	string SOUND_ZOMB_STRUCK3 = "agrunt/ag_pain5.wav";
	string SOUND_ZOMB_ATK1 = "zombie/claw_miss1.wav";
	string SOUND_ZOMB_ATK2 = "zombie/claw_miss2.wav";
	string SOUND_ZOMB_ATK3 = "zombie/claw_strike1.wav";
	string SOUND_ZOMB_ALERT1 = "monsters/zombie1/orc_zo_alert10.wav";
	string SOUND_ZOMB_ALERT2 = "monsters/zombie1/orc_zo_alert20.wav";
	string SOUND_ZOMB_ALERT3 = "monsters/zombie1/orc_zo_alert30.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_RUN = "run";
	string ANIM_IDLE = "idle1";
	string ANIM_WALK = "walk";
	bool NPC_SILENT_DEATH = false;
	string ANIM_DEATH = "ANIM_DEATH";
	string HUNT_AGRO = "HUNT_AGRO";
	string CAN_HEAR = "CAN_HEAR";
	string CAN_FLEE = "CAN_FLEE";
	string CAN_FLINCH = "CAN_FLINCH";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	string ANIM_FLINCH = "ANIM_FLINCH";
	string FLINCH_DELAY = "FLINCH_DELAY";
	string LAST_ENEMY = "LAST_ENEMY";
	bool NO_STEP_ADJ = false;
	float NPC_GIVE_EXP = 0.0f;
	float NEXT_ORC_VALIDATE_SOUND = 0.0f;
	bool CALLED_HELP = false;
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_MOVERANGE = 0.0f;
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	bool IS_RANGED = false;
	bool ORC_JUMPER = false;
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool BO_ZOMBIE_MODE = false;

	// unnamed block (first think)
	void OrcBase_FirstThink()
	{
		NPC_SILENT_DEATH = true;
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_DEATH = "die_fallback";
		HUNT_AGRO = "1"; // base_npc_attack - Premptive attack
		CAN_HEAR = "1"; // Turn to face enemies I hear
		CAN_FLEE = "0"; // Don't flee
		CAN_FLINCH = "1"; // Flinch when hit
		FLINCH_CHANCE = "30%"; // Chance of flinch
		ANIM_FLINCH = "flinch";
		FLINCH_DELAY = "4"; // base_npc_attack - Time until next allowed flinch
		LAST_ENEMY = "`NONE`";
	}

	// npc_spawn
	void OrcBase_OnNpcSpawn(string npc = "")
	{
		SetRoam(true);
		SetRace("orc");
		SetModel("monsters/orc.mdl");
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		OnOrcSpawn();

		// they can't get up on the lips of the huts in daragoth DEC2007a (aka. daragoth2) for some bloody reason
		if (ToLowerCase(MapName()) != "daragoth")
			return;
		NO_STEP_ADJ = true;
	}

	// npc_post_spawn
	void OrcBase_OnNpcPostSpawn()
	{
		if (Truthy(GetVar("G_SHAD_PRESENT")))
			OnBoZombieMode();

		if (Truthy(GetVar("G_SHAD_PRESENT")))
			return;

		string mapName = ToLowerCase(MapName());
		if (mapName == "old_helena")
		{
			NPC_GIVE_EXP = Divide(NPC_GIVE_EXP, 2.0f);
			SetSkillLevel(NPC_GIVE_EXP);
		}
	}

	// npc_death
	// On death, don't display weapon
	void OrcBase_OnNpcDeath()
	{
		SetModelBody(2, 0); // Hide weapon
		SetModelBody(4, 0); // Hide Shield
		OnOrcDeath();
	}

	// npcatk_targetvalidate
	// Warcry
	void OrcBase_OnNpcatkTargetvalidate(string target = "")
	{
		string lastseenEnemy = NPCATK_TARGET;
		if (lastseenEnemy == LAST_ENEMY)
			return;

		if (!BO_ZOMBIE_MODE)
		{
			if (GameTime() > NEXT_ORC_VALIDATE_SOUND)
			{
				NEXT_ORC_VALIDATE_SOUND = GameTime() + Random(5, 10);

				PlaySound(Int(Eval("game.sound.voice")), 5, SOUND_ATTACK2);
			}
		}
		else if (GameTime() > NEXT_ORC_VALIDATE_SOUND)
		{
			NEXT_ORC_VALIDATE_SOUND = GameTime() + Random(5, 10);
			PlayRandomSound(0, 5, SOUND_ZOMB_ALERT1, SOUND_ZOMB_ALERT2, SOUND_ZOMB_ALERT3);
		}
		LAST_ENEMY = lastseenEnemy;
	}

	// npc_struck
	// Hit by someone
	void OrcBase_OnNpcStruck(float damage = 0.0f)
	{
		if (GetVar("ORC_SHIELD") == "1")
		{
			if (!BO_ZOMBIE_MODE)
			{
				int block = RandomInt(0, 99);
				if (block < 30)
				{
					if (block < 5)
					{
						PlayAnim("critical", "deflectcounter");
						OnSwingAxe();
					}
					else
					{
						int rand = RandomInt(0, 1);
						if (rand == 0)
							PlayAnim("critical", "shielddeflect1");
						if (rand == 1)
							PlayAnim("critical", "shielddeflect2");
					}
				}
				else
				{
					OnSoundStruck();
				}
			}
		}
		else
		{
			OnSoundStruck();
		}
		OnOrcStruck();
	}

	// sound_struck
	void OrcBase_OnSoundStruck()
	{
		if (BO_ZOMBIE_MODE)
			PlayRandomSound(1, 10, SOUND_ZOMB_STRUCK1, SOUND_ZOMB_STRUCK2, SOUND_ZOMB_STRUCK3, "none", "none");
		else
			PlayRandomSound(1, 10, SOUND_PAIN, SOUND_STRUCK2, SOUND_PAIN, "none", "none");
	}

	// baseorc_yell
	void OrcBase_OnBaseorcYell()
	{
		if (BO_ZOMBIE_MODE)
			PlayRandomSound(1, 10, SOUND_ZOMB_ATK1, SOUND_ZOMB_ATK2, SOUND_ZOMB_ATK3);
		else
			PlayRandomSound(1, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
	}

	// game_damaged_other
	string OrcBase_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		if (GetVar("ATTACK_PUSH") == "ATTACK_PUSH")
			return result;
		if (GetVar("ATTACK_PUSH") == "none")
			return result;

		AddVelocity(ENT_LASTSTRUCKBYME, Vec(GetVar("ATTACK_PUSH"))); // Push the player a bit
		return result;
	}

	// game_parry
	void OrcBase_OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
	}

	// npc_aiding_ally
	void OrcBase_OnNpcAidingAlly(CBaseEntity@ allyToAid = null, string caller = "")
	{
		if (CALLED_HELP)
			return;
		CALLED_HELP = true;
		CallExternal(EntityOf(caller), "ext_mon_playsound", 0, 10, "voices/orc/help.wav");
	}

	// bo_zombie_mode
	void OrcBase_OnBoZombieMode()
	{
		bool noNameChange = false;

		SetRace("undead");
		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 1.5f);
		SetProp(ENT_ME, "skin", 1);
		SetAnimFrameRate(0.5f);
		// movespeed 0.5
		SetModelBody(2, 0);

		MOVE_RANGE = "32";
		ATTACK_MOVERANGE = 32.0f;
		ATTACK_RANGE = 80.0f;
		ATTACK_HITRANGE = 140.0f;
		IS_RANGED = false;
		ORC_JUMPER = false;
		ANIM_ATTACK = "swordswing1_L";

		SetDamageMultiplier(ZORC_DMG_MULTI);

		float hpMulti = MyMaxHealth() * ZORC_HP_MULTI;
		SetHealth(hpMulti);

		BO_ZOMBIE_MODE = true;

		// const_ovrd ORC_SHIELD 0
		SetStat("parry", 0);

		NPC_GIVE_EXP *= 4.0f;
		SetSkillLevel(NPC_GIVE_EXP);

		// hacky name change prevention cuz I dun wanna redist mscave
		string myName = NameOf(ENT_ME);
		if (Contains(ToLowerCase(myName), "zombie"))
			noNameChange = true;
		if (noNameChange)
			return;
		SetName(NameOf(ENT_ME) + " Zombie");
	}

	// game_death
	void OrcBase_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (!BO_ZOMBIE_MODE)
			PlaySound(0, 5, "voices/orc/die.wav");
		else
			PlaySound(0, 5, "agrunt/ag_die5.wav");
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
		OrcBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, OrcBase_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
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
		OrcBase_OnNpcPostSpawn();
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		OrcBase_OnNpcSpawn(npc);
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		OrcBase_OnNpcatkTargetvalidate(target);
	}

	// game_parry
	void OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		BaseMonsterShared_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue); // monsters/base_monster_shared
		OrcBase_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue);
	}

	void OnNpcDeath() { OrcBase_OnNpcDeath(); } // npc_death
	void OnNpcStruck(float damage = 0.0f) { OrcBase_OnNpcStruck(damage); } // npc_struck
	void OnSoundStruck() { OrcBase_OnSoundStruck(); } // sound_struck
	void OnBaseorcYell() { OrcBase_OnBaseorcYell(); } // baseorc_yell
	void OnNpcAidingAlly(CBaseEntity@ allyToAid = null, string caller = "") { OrcBase_OnNpcAidingAlly(allyToAid, caller); } // npc_aiding_ally
	void OnBoZombieMode() { OrcBase_OnBoZombieMode(); } // bo_zombie_mode
	void OnOrcDeath() {} // orc_death
	void OnOrcSpawn() {} // orc_spawn
	void OnOrcStruck() {} // orc_struck
	void OnSwingAxe() {} // swing_axe

	// This file's events and timers by their .script names
	bool OrcBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "baseorc_yell") { OnBaseorcYell(); return true; }
		if (name == "bo_zombie_mode") { OnBoZombieMode(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_parry") { OnGameParry(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), Float(Param(params, 4)), Float(Param(params, 5))); return true; }
		if (name == "npc_aiding_ally") { OnNpcAidingAlly(EntityParam(params, 0), Param(params, 1)); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "sound_struck") { OnSoundStruck(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/orc_base"]
shared class OrcBaseScript : BaseMonsterNewScript, OrcBase
{
	// Variables declared by included files, with the value they start with in this script
	OrcBaseScript()
	{
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/orc.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
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
		return OrcBase_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
