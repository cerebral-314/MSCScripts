#pragma context server

// Converted from monsters/orc_shaman_fire.script by msc_transpiler.
// Orc Fire Shamman, from Orc Sniper by Thothie

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_ranged.as"
#include "converted/monsters/orc_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class OrcShamanFire
{
	// Constants
	string PROJECTILE_SCRIPT = "proj_fire_ball";
	int AIM_RATIO = 50;
	int ATTACK_SPEED = 500;
	int ATTACK_CONE_OF_FIRE = 2;
	string FIRE_BALL_DAMAGE_NORM = "$rand(75,100)";
	string FIRE_BALL_DAMAGE_ALT = "$rand(5,10)";
	int MELE_RANGE = 96;
	int MELE_HITRANGE = 128;
	string ATTACK_ACCURACY = "80";
	string ANIM_SWIPE = "swordswing1_L";
	string ANIM_FIRE = "swordswing1_L";
	string ANIM_WARCRY = "warcry";
	string SWIPE_DAMAGE = "$rand(25,65)";
	string WEAK_SWIPE_DAMAGE = "$rand(5,20)";
	string SOUND_MELEMISS = "zombie/claw_miss1.wav";
	string SOUND_MELEHIT = "zombie/claw_strike3.wav";
	string SOUND_FIRECHARGE = "magic/fireball_powerup.wav";
	string SOUND_FIRESHOOT = "magic/fireball_strike.wav";
	string SOUND_WARCRY1 = "monsters/orc/attack1.wav";
	string SOUND_WARCRY2 = "monsters/orc/attack3.wav";
	int BASE_BURN_DAMAGE = 15;
	float FIRE_BALL_FREQ = 3.0f;
	string DEATH_SCRIPT = "traps/fire_wall2";
	string FIRE_FIST_SCRIPT = "monsters/fire_fist_cl";

	// Variables (an unset .script variable reads as its own name)
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	string BURN_DAMAGE = "BURN_DAMAGE";
	string FIRE_BALL_DAMAGE = "FIRE_BALL_DAMAGE";
	string MY_CL_SCRIPT_IDX = "MY_CL_SCRIPT_IDX";
	bool FIRE_BALL_DELAY = false;
	bool DID_WARCRY = false;
	string POISON_TARGS = "POISON_TARGS";
	bool SWIPE_SOUNDS = false;
	bool WEAK_ATTACK = false;
	bool NPC_IGNORE_PLAYERS = false;

	// unnamed block (first think)
	void OrcShamanFire_FirstThink()
	{
		DROP_GOLD = 1; // Gold Drop
		DROP_GOLD_AMT = RandomInt(15, 30);
		NPC_GIVE_EXP = 200.0f;

		// setvard DROP_ITEM1 scroll2_fire_dart //Used by base_monster
		// setvard DROP_ITEM1_CHANCE 5%	  //Used by base_monster
		ANIM_ATTACK = "swordswing1_L"; // Attack animation
		FLINCH_CHANCE = "45%";
		MOVE_RANGE = "256";
		ATTACK_RANGE = 5500.0f;
		BURN_DAMAGE = BASE_BURN_DAMAGE;

		PrecacheFile(DEATH_SCRIPT);
	}

	// orc_spawn
	void OrcShamanFire_OnOrcSpawn()
	{
		SetHealth(220);
		// ov 180
		SetName("Orc Fire Shaman");
		SetHearingSensitivity(8);
		SetDamageTaken("all", 0.8f);
		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 1.5f);
		SetStat("spellcasting", 30, 30, 30, 30, 30, 30, 30);

		FIRE_BALL_DAMAGE = FIRE_BALL_DAMAGE_NORM;
		if (ToLowerCase(MapName()) == "mscave")
			FIRE_BALL_DAMAGE = FIRE_BALL_DAMAGE_ALT;

		ClientEvent("persist", "all", FIRE_FIST_SCRIPT, IndexOf(ENT_ME), 19);
		MY_CL_SCRIPT_IDX = LastClientScriptId();

		// giveitem item_torch
		SetModelBody(0, 0); // Body 0=naked 1=leather 2=plate 3=green-hide
		SetModelBody(1, 4); // Head 0=cap_shorthorn 1=cap_nohorn 2=buffo_skin 3=cheif_ramhorns 4=green_hood
		SetModelBody(2, 0); // Weapon 0=fist 1=axe 2=bow_weak 3=bow_strng 4=sword 5=bloodyaxe 6=sword&sheild
	}

	// npc_selectattack
	void OrcShamanFire_OnNpcSelectattack()
	{
		if (BO_ZOMBIE_MODE)
			return;
		if (FIRE_BALL_DELAY)
			return;
		if (Truthy(LegacyFunction("cansee", "enemy", MELE_RANGE)))
			return;
		PlaySound(0, 10, SOUND_FIRECHARGE);
	}

	// swing_sword
	void OrcShamanFire_OnSwingSword()
	{
		bool exitSub = false;

		if (Truthy(LegacyFunction("cansee", "enemy", MELE_RANGE)))
		{
			// dbg Can See NME in range
			ANIM_ATTACK = ANIM_SWIPE;
			OnSwipeAttack(EntityOf(ENT_LASTSEEN));
			exitSub = true;
		}
		if (exitSub)
			return;

		if (BO_ZOMBIE_MODE)
			return;

		if (CanSee("enemy"))
		{
			// prevents shamman from moving closer to target than needed
			if (!Truthy(LegacyFunction("cansee", "enemy", MOVE_RANGE)))
				ANIM_ATTACK = ANIM_RUN;
			if (Truthy(LegacyFunction("cansee", "enemy", MOVE_RANGE)))
				ANIM_ATTACK = ANIM_WARCRY;
		}

		if (FIRE_BALL_DELAY)
			return;
		ANIM_ATTACK = ANIM_FIRE;
		OnThrowFireball();
	}

	// throw_fireball
	void OrcShamanFire_OnThrowFireball()
	{
		if (Truthy(GetVar("ORC_SHAMAN_CUSTOM_FIREBALL")))
			return;

		if (!CanSee("enemy"))
			return;

		// dbg Throwing Fireball
		CallEventDelayed(FIRE_BALL_FREQ, "reset_fireball");

		PlaySound(0, 10, SOUND_FIRESHOOT);

		CBaseEntity@ targetId = EntityOf(ENT_LASTSEEN);

		float aimAngle = Divide(DistanceTo(targetId), AIM_RATIO); // Aim up a bit
		SetAngle("add_view.x", aimAngle);

		float targetRange = RangeTo(targetId);

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		if (targetRange <= 800.0f)
			TossProjectile(PROJECTILE_SCRIPT, RelativePosition(Vector3(0, 48, 18)), "none", ATTACK_SPEED, FIRE_BALL_DAMAGE, ATTACK_CONE_OF_FIRE, "none");
		if (targetRange > 800.0f)
			TossProjectile(PROJECTILE_SCRIPT, RelativePosition(Vector3(0, 48, 18)), @targetId, ATTACK_SPEED, FIRE_BALL_DAMAGE, ATTACK_CONE_OF_FIRE, "none");
		float lightenAmt = 0.4f;
		if (targetRange > 800.0f)
			lightenAmt = 0.01f;
		CallExternal(EntityOf(ENT_LASTPROJECTILE), "lighten", BURN_DAMAGE, lightenAmt);
		FIRE_BALL_DELAY = true;
	}

	// reset_fireball
	void OrcShamanFire_OnResetFireball()
	{
		ANIM_ATTACK = ANIM_FIRE;
		DID_WARCRY = false;
		FIRE_BALL_DELAY = false;
	}

	// npc_death
	void OrcShamanFire_OnNpcDeath()
	{
		// removeitem ent_me item_torch
		OnOrcShamanDeath();
	}

	// orc_shaman_death
	void OrcShamanFire_OnOrcShamanDeath()
	{
		int count;
		if (Truthy(GetVar("ORC_SHAMAN_CUSTOM_DEATH")))
			return;
		ClientEvent("remove", "all", MY_CL_SCRIPT_IDX);
		if (!(GameTime() > Float(GetVar("G_FIRE_WALL_DELAY"))))
			return;
		SetGlobal("G_FIRE_WALL_DELAY", GameTime());
		LegacyCommand("add", "G_FIRE_WALL_DELAY", 2.0f); // anti-crash when killing multiple fire shamans
		if (!BO_ZOMBIE_MODE)
		{
			CallExternal(GetVar("GAME_MASTER"), "gm_createnpc", 0.1f, DEATH_SCRIPT, RelativePosition(Vector3(0, 0, 0)), self, AnglesOf(ENT_ME).y);
		}
		else
		{
			// fire burst borrowed from fire beetle
			SetProp(ENT_ME, "rendermode", 5);
			SetProp(ENT_ME, "renderamt", 0);

			PlaySound(0, 10, "weapons/explode3.wav");
			DoDamageEx(RelativePosition(Vector3(0, 0, 0)), 256, 300, 0, ENT_ME, ENT_ME, "none", "fire_effect");
			ClientEvent("new", "all", "effects/sfx_explode", OriginOf(ENT_ME), 256);
			POISON_TARGS = FindInSphere("enemy", 256);
			if (POISON_TARGS != "none")
			{
				count = GetTokenCount(POISON_TARGS);
				for (int i = 0; i < count; i++)
				{
					loopIteration = i;
					OnPoisonAffectTargets();
				}
			}
		}
	}

	// poison_affect_targets
	// fire burst borrowed from fire beetle
	void OrcShamanFire_OnPoisonAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(POISON_TARGS, loopIteration));
		ApplyEffect(curTarg, "effects/dot_fire", 5.0f, self, 100);
		Vector3 targOrg = OriginOf(curTarg);
		float targAng = AnglesTo(MyOrigin(), targOrg);
		SetVelocity(curTarg, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 1000, 0)));
	}

	// swipe_attack
	void OrcShamanFire_OnSwipeAttack(CBaseEntity@ enemy = null)
	{
		SWIPE_SOUNDS = true;

		if (!WEAK_ATTACK)
			OnNpcatkDodamage(EntityId(enemy), Text(MELE_HITRANGE), SWIPE_DAMAGE, ATTACK_ACCURACY);
		if (WEAK_ATTACK)
			OnNpcatkDodamage(EntityId(enemy), Text(MELE_HITRANGE), WEAK_SWIPE_DAMAGE, ATTACK_ACCURACY);

		int dotFire = RandomInt(20, 40);
		if (BO_ZOMBIE_MODE)
			dotFire = RandomInt(40, 100);

		ApplyEffect(enemy, "effects/dot_fire", RandomInt(5, 10), ENT_ME, dotFire);
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string OrcShamanFire_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!SWIPE_SOUNDS)
			return result;

		if (!hit)
			PlaySound(0, 10, SOUND_MELEMISS);

		if (hit)
			PlaySound(0, 10, SOUND_MELEHIT);

		SWIPE_SOUNDS = false;
		return result;
	}

	// npc_struck
	void OrcShamanFire_OnNpcStruck(float damage = 0.0f)
	{
		if (!(RangeTo(ENT_LASTSTRUCK) < MELE_RANGE))
			return;
		ANIM_ATTACK = ANIM_SWIPE;
		OnNpcatkSettarget(EntityId(EntityOf(ENT_LASTSTRUCK)));
	}

	// npc_attack
	void OrcShamanFire_OnNpcAttack()
	{
		if (ANIM_ATTACK != ANIM_WARCRY)
			return;
		if (DID_WARCRY)
			return;
		PlayRandomSound(0, 10, SOUND_WARCRY1, SOUND_WARCRY2);
		DID_WARCRY = true;
	}

	// npc_post_spawn
	void OrcShamanFire_OnNpcPostSpawn()
	{
		if (ToLowerCase(MapName()) == "mscave" && !BO_ZOMBIE_MODE)
		{
			SetName("Orc Fire Shaman Initiate");
			WEAK_ATTACK = true;
			DROP_GOLD = 1;
			DROP_GOLD_AMT = RandomInt(15, 30);
			NPC_GIVE_EXP = 100.0f;
			FIRE_BALL_DAMAGE = FIRE_BALL_DAMAGE_ALT;
			BURN_DAMAGE = "5";
		}
	}

	// npcatk_setup_siege
	void OrcShamanFire_OnNpcatkSetupSiege()
	{
		// fire shamans do not ignore players on old helena
		string mapName = ToLowerCase(MapName());
		if (mapName == "old_helena")
			return;
		// in siege maps, 1 in 3 monsters ignore players until struck, prefering to go for the critical NPCs
		if (RaceOf(ENT_ME) == "hguard")
			return;
		if (RaceOf(ENT_ME) == "human")
			return;
		if (RandomInt(1, 3) != 1)
			return;
		NPC_IGNORE_PLAYERS = true;
		OnNpcatkNpcHunterLoop();
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
		{
			SetProp(ENT_ME, "rendermode", 5); // for visual debug
			SetProp(ENT_ME, "renderamt", 255);
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseRanged_OnOrcSpawn(); // monsters/orc_base_ranged
		OrcShamanFire_OnOrcSpawn();
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		OrcBaseRanged_OnNpcTargetsighted(target); // monsters/orc_base_ranged
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
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
		OrcShamanFire_OnNpcPostSpawn();
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, OrcShamanFire_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		OrcShamanFire_OnNpcSelectattack();
	}

	// npc_death
	void OnNpcDeath()
	{
		OrcBase_OnNpcDeath(); // monsters/orc_base
		OrcShamanFire_OnNpcDeath();
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		OrcBase_OnNpcStruck(damage); // monsters/orc_base
		OrcShamanFire_OnNpcStruck(damage);
	}

	void OnSwingSword() { OrcShamanFire_OnSwingSword(); } // swing_sword
	void OnThrowFireball() { OrcShamanFire_OnThrowFireball(); } // throw_fireball
	void OnResetFireball() { OrcShamanFire_OnResetFireball(); } // reset_fireball
	void OnOrcShamanDeath() { OrcShamanFire_OnOrcShamanDeath(); } // orc_shaman_death
	void OnPoisonAffectTargets() { OrcShamanFire_OnPoisonAffectTargets(); } // poison_affect_targets
	void OnSwipeAttack(CBaseEntity@ enemy = null) { OrcShamanFire_OnSwipeAttack(enemy); } // swipe_attack
	void OnNpcAttack() { OrcShamanFire_OnNpcAttack(); } // npc_attack
	void OnNpcatkSetupSiege() { OrcShamanFire_OnNpcatkSetupSiege(); } // npcatk_setup_siege
	void OnFireBallFreq() {} // FIRE_BALL_FREQ

	// This file's events and timers by their .script names
	bool OrcShamanFire_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "npc_attack") { OnNpcAttack(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npcatk_setup_siege") { OnNpcatkSetupSiege(); return true; }
		if (name == "orc_shaman_death") { OnOrcShamanDeath(); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "poison_affect_targets") { OnPoisonAffectTargets(); return true; }
		if (name == "reset_fireball") { OnResetFireball(); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		if (name == "swipe_attack") { OnSwipeAttack(EntityParam(params, 0)); return true; }
		if (name == "throw_fireball") { OnThrowFireball(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/orc_shaman_fire"]
shared class OrcShamanFireScript : OrcBaseScript, OrcShamanFire, OrcBaseRanged
{
	// Variables declared by included files, with the value they start with in this script
	OrcShamanFireScript()
	{
		SOUND_WARCRY1 = "monsters/orc/attack1.wav";
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OrcShamanFire_FirstThink();
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
		return OrcShamanFire_DispatchEvent(name, params)
			|| OrcBaseRanged_DispatchEvent(name, params)
			|| OrcBaseScript::DispatchEvent(name, params);
	}
}
