#pragma context server

// Converted from monsters/morc_sniper.script by msc_transpiler.
// Morc sniper from monsters/orc_sniper by Thothie

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_ranged.as"
#include "converted/monsters/orc_base.as"

[script "monsters/morc_sniper"]
class MorcSniper : OrcBaseScript, OrcBaseRanged
{
	// Constants
	int DMG_DOT = 30;
	float DOT_DUR = 5.0f;
	string ARROW_TYPE = "proj_arrow_npc_dyn";
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
	string CONTAINER_BASE = "chests/quiver_of_frost_arrows";
	int FIN_EXP = 200;
	string SOUND_KICK = "zombie/claw_miss1.wav";

	// Variables (an unset .script variable reads as its own name)
	int ATTACK_CONE_OF_FIRE = 0;
	string DROP_ITEM1 = "DROP_ITEM1";
	int DROPS_CONTAINER = 0;
	string CONTAINER_SCRIPT = "CONTAINER_SCRIPT";
	bool IS_ARROW = false;
	bool MELEE_ATK = false;
	string ATTACK_PUSH = "ATTACK_PUSH";
	float NEXT_KICK = 0.0f;
	float ARROW_MISSED = 0.0f;
	bool AM_TURRET = false;

	// Variables declared by included files, with the value they start with in this script
	MorcSniper()
	{
		ANIM_RUN = "ANIM_RUN";
		ANIM_WALK = "ANIM_WALK";
	}

	// unnamed block (first think)
	void MorcSniper_FirstThink()
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
	void OnOrcSpawn()
	{
		OrcBaseRanged_OnOrcSpawn(); // monsters/orc_base_ranged

		SetName("Marogar Elite Archer");
		SetHealth(420);
		SetHearingSensitivity(2);
		SetStat("parry", 30);
		SetDamageTaken("all", 0.8f);

		SetModel("monsters/morc.mdl");
		SetModelBody(0, 3); // Body 0=topless+skirt 1=topless+pants 2=brestplate 3=whitefurhide
		SetModelBody(1, 3); // Head 0=cap_shorthorn 1=cap_spike 2=wbuffo_skin 3=cheif_ramhorns 4=wletherhood
		SetModelBody(2, 3); // Weapon 0=fist 1=axe 2=wood_bow 3=icebow 4=icesword 5=iceaxe

		CallEventDelayed(1.0f, "reset_range"); // debug
	}

	// grab_arrow
	void OnGrabArrow()
	{
		OrcBaseRanged_OnGrabArrow(); // monsters/orc_base_ranged
		SetModelBody(3, 1); // Show Arrow
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
		SetModelBody(3, 0); // Hide arrow
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
		// redundant
		if (!AM_TURRET)
			return;
		SetMoveAnim(ANIM_IDLE);
		ANIM_RUN = ANIM_IDLE;
		ANIM_WALK = ANIM_IDLE;
		NO_STUCK_CHECKS = "1";
		SetRoam(false);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
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
		SetModelBody(3, 0); // Hide arrow
		ANIM_ATTACK = ANIM_SWIPE;
	}

	// reset_range
	void OnResetRange()
	{
		ATTACK_HITRANGE = 2000.0f;
	}

	// shoot_arrow
	void OnShootArrow()
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

		SetModelBody(3, 0); // Hide arrow
		PlaySound(2, 10, SOUND_BOW);

		MELEE_ATK = false;
	}

	// swing_sword
	// swipe attack
	void OnSwingSword()
	{
		ANIM_ATTACK = ANIM_KICK;

		PlaySound(0, 10, SOUND_KICK);
		ATTACK_PUSH = Text(RelativeVelocity(Vector3(-100, 130, 120)));
		OnNpcatkDodamage(NPCATK_TARGET, Text(KICK_HITRANGE), DMG_SWIPE, Text(KICK_HITCHANCE));
	}

	// kick_land
	void OnKickLand()
	{
		ANIM_ATTACK = ANIM_SMASH;

		PlaySound(0, 10, SOUND_KICK);
		ATTACK_PUSH = Text(RelativeVelocity(Vector3(50, 130, 120)));
		OnNpcatkDodamage(NPCATK_TARGET, Text(KICK_HITRANGE), DMG_KICK, Text(KICK_HITCHANCE));
	}

	// swing_axe
	void OnSwingAxe()
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

	// ext_arrow_hit
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	void OnExtArrowHit(string hit = "", CBaseEntity@ hitEntity = null, Vector3 startPosition = Vector3())
	{
		if (!Truthy(hit))
			ARROW_MISSED += 1.0f;
		// if ( AM_TURRET ) add ATTACK_CONE_OF_FIRE 1 //not work so good
		if (Truthy(hit))
		{
			ARROW_MISSED = 0.0f;
			AddVelocity(hitEntity, RelativeVelocity(Vector3(0, 400, 110)));
			ApplyEffect(hitEntity, "effects/dot_cold", DOT_DUR, self, "DOT_DMG");
		}

		// if ( AM_TURRET ) setvard ATTACK_CONE_OF_FIRE 2
		if (!(ARROW_MISSED > 3.0f))
			return;
		OnChangePosition();
		ARROW_MISSED = 0.0f;
	}

	// change_position
	void OnChangePosition()
	{
		// can't hit from here, so running in a random direction for 3 seconds.
		if (AM_TURRET)
			return;
		PlayAnim("critical", ANIM_RUN);
		OnChickenRun(3.0f);
	}

	// set_turret
	void OnSetTurret()
	{
		AM_TURRET = true;
		SetMoveAnim(ANIM_IDLE);
		ANIM_RUN = ANIM_IDLE;
		ANIM_WALK = ANIM_IDLE;
		NO_STUCK_CHECKS = "1";
		SetRoam(false);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		OrcBaseRanged_OnNpcTargetsighted(target); // monsters/orc_base_ranged
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/orc.mdl");
		Precache("monsters/morc.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MorcSniper_FirstThink();
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
		if (name == "change_position") { OnChangePosition(); return true; }
		if (name == "ext_arrow_hit") { OnExtArrowHit(Param(params, 0), EntityParam(params, 1), Vec(Param(params, 2))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "grab_arrow") { OnGrabArrow(); return true; }
		if (name == "kick_land") { OnKickLand(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "reset_range") { OnResetRange(); return true; }
		if (name == "set_turret") { OnSetTurret(); return true; }
		if (name == "shoot_arrow") { OnShootArrow(); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		return OrcBaseRanged_DispatchEvent(name, params)
			|| OrcBaseScript::DispatchEvent(name, params);
	}
}
