#pragma context server

// Converted from monsters/dwarf_zombie_sbow.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_struck.as"
#include "converted/NPCs/dwarf_lantern_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DwarfZombieSbow
{
	// Constants
	int XBOW_TYPE = 1;
	string ANIM_SXBOW_ATTACK = "anim_sxbow_shoot";
	string ANIM_HXBOW_ATTACK = "anim_hxbow_shoot_reload";
	string SOUND_DEATH = "agrunt/ag_die5.wav";
	string ACT_ANIM_RUN = "walk";
	string ANIM_RELOAD = "anim_sxbow_reload";
	string ANIM_RELOAD_DONE = "anim_sxbow_reload_done";
	string ANIM_DODGE = "anim_roll_back";
	string ANIM_ALERT = "nod";
	int AMMO_MAX = 5;
	string SOUND_TURNED1 = "ambience/the_horror1.wav";
	string SOUND_TURNED2 = "ambience/the_horror2.wav";
	string SOUND_TURNED3 = "ambience/the_horror3.wav";
	string SOUND_TURNED4 = "ambience/the_horror4.wav";
	string SOUND_HOLYPAIN1 = "agrunt/ag_pain4.wav";
	string SOUND_HOLYPAIN2 = "agrunt/ag_die3.wav";
	string SOUND_ALERT = "agrunt/ag_alert2.wav";
	string SOUND_XBOW_STRETCH = "weapons/bow/stretch.wav";
	string SOUND_XBOW_SHOOT = "weapons/bow/crossbow.wav";
	string SOUND_BOLT_HIT = "weapons/bow/bolthit1.wav";
	string SOUND_RELOAD = "weapons/357_reload1.wav";
	int XBOW_ACCURACY = 80;
	string XBOW_CL_SCRIPT = "monsters/elf_xbow_cl";
	int XBOW_BONE = 35;
	int DMG_XBOW = 30;
	float DOT_POISON = 5.0f;
	float PBOLT_DURATION = 8.0f;
	int PBOLT_AOE = 64;
	float FREQ_CLIENT_REFRESH = 40.0f;
	string SOUND_IDLE1 = "agrunt/ag_idle2.wav";
	string SOUND_IDLE2 = "agrunt/ag_alert3.wav";
	string SOUND_IDLE3 = "agrunt/ag_idle5.wav";
	string SOUND_PAIN1 = "agrunt/ag_pain3.wav";
	string SOUND_PAIN2 = "agrunt/ag_pain5.wav";
	string SOUND_PAIN3 = "agrunt/ag_pain2.wav";
	string SOUND_FLINCH1 = "agrunt/ag_pain3.wav";
	string SOUND_FLINCH2 = "agrunt/ag_pain5.wav";
	string SOUND_FLINCH3 = "agrunt/ag_pain2.wav";
	string ANIM_FLINCH = "anim_xbow_flinch";
	string NPC_MATERIAL_TYPE = "flesh";
	bool NPC_USE_PAIN = true;
	bool NPC_USE_IDLE = true;
	bool NPC_USE_FLINCH = true;
	int LANTERN_HAND_SUBMODEL = 2;
	bool LANTERN_HAND_INDEX = false;
	string LANTERN_COLOR = "LANTERN_COLOR";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK = "walk";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_IDLE = "idle";
	float NPC_GIVE_EXP = 0.0f;
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string AMMO_TYPE = "AMMO_TYPE";
	string NPC_RANGED = "NPC_RANGED";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	float AMMO_COUNT = 0.0f;
	bool I_AM_TURNABLE = false;
	bool IS_BLOODLESS = false;
	bool IMMUNE_VAMPIRE = false;
	bool IS_UNHOLY = false;
	float NEXT_SCRIPT_UPDATE = 0.0f;
	string XBOW_CL_SCRIPT_ID = "XBOW_CL_SCRIPT_ID";
	float NEXT_DZOMB_FLEE = 0.0f;
	float AS_ATTACKING = 0.0f;
	bool DID_ALERT = false;
	float NEXT_ALERT = 0.0f;
	bool EXPLOSIVE_BOLTS = false;
	bool ADJUSTED_XP = false;
	float MISS_COUNT = 0.0f;
	string XBOW_REPELL_POINT = "XBOW_REPELL_POINT";
	Vector3 XBOW_AIM_ANGLES = Vector3();
	string XBOW_BOLT_START = "XBOW_BOLT_START";
	string XBOW_BOLT_LAND = "XBOW_BOLT_LAND";
	bool IN_RELOAD = false;
	bool PBOLT_ACTIVE = false;
	float PBOLT_COUNTER = 0.0f;
	string PBOLT_ARRAY_NAME = "PBOLT_ARRAY_NAME";
	string CUR_PBOLT_ORG = "CUR_PBOLT_ORG";

	// unnamed block (first think)
	void DwarfZombieSbow_FirstThink()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = ACT_ANIM_RUN; // living dwarves in NPCs/dwarf_xbow use me as a base, they run - zombies don't
		ANIM_IDLE = "idle";

		if (XBOW_TYPE == 1)
		{
			NPC_GIVE_EXP = 200.0f;
			DROP_GOLD = 1;
			DROP_GOLD_AMT = 100.0f;
			ANIM_ATTACK = ANIM_SXBOW_ATTACK;
		}
		else
		{
			NPC_GIVE_EXP = 150.0f;
			DROP_GOLD = 1;
			DROP_GOLD_AMT = 75.0f;
			ANIM_ATTACK = ANIM_HXBOW_ATTACK;
		}
		AMMO_TYPE = "unset";

		NPC_RANGED = "1";

		ATTACK_RANGE = 2048.0f;
		ATTACK_HITRANGE = 2048.0f;
		ATTACK_MOVERANGE = 768.0f;
		AMMO_COUNT = 5.0f;

		I_AM_TURNABLE = true;
	}

	// game_precache
	void DwarfZombieSbow_OnGamePrecache()
	{
		PrecacheFile(XBOW_CL_SCRIPT);
		ServerPlaySound(0, 0, "agrunt/ag_pain3.wav"); // fake precache, sound should follow him when he rolls
	}

	// npc_spawn
	void DwarfZombieSbow_OnNpcSpawn(string npc = "")
	{
		OnDarcherSpawn();
		OnSelectAmmo();
	}

	// darcher_spawn
	void DwarfZombieSbow_OnDarcherSpawn()
	{
		SetName("Dwarven Zombie Bowman");
		SetModel("dwarf/male1.mdl");
		SetModelBody(0, 2);
		SetModelBody(1, 6);
		SetWidth(32);
		SetHeight(48);
		SetRoam(true);
		SetHealth(300);
		SetRace("undead");
		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 2);
		SetDamageTaken("lightning", 0.5f);
		SetDamageTaken("cold", 0.5f);
		SetDamageTaken("pierce", 0.5f);
		SetDamageTaken("fire", 1.25f);
		SetDamageTaken("slash", 1.25f);
		SetHearingSensitivity(8);

		IS_BLOODLESS = true;
		IMMUNE_VAMPIRE = true;
		IS_UNHOLY = true;
	}

	// npc_targetsighted
	void DwarfZombieSbow_OnNpcTargetsighted(string target = "")
	{
		if (XBOW_CL_SCRIPT_ID == "XBOW_CL_SCRIPT_ID")
		{
			ClientEvent("new", "all", XBOW_CL_SCRIPT, FREQ_CLIENT_REFRESH);
			NEXT_SCRIPT_UPDATE = GameTime() + FREQ_CLIENT_REFRESH;
			XBOW_CL_SCRIPT_ID = LastClientScriptId();
		}
		else if (GameTime() > NEXT_SCRIPT_UPDATE)
		{
			// dbg npc_targetsighted refresh cl
			XBOW_CL_SCRIPT_ID = "XBOW_CL_SCRIPT_ID"; // refresh on next sight
		}

		if (RangeTo(NPCATK_TARGET) < 64.0f)
		{
			// a 'roll away' anim would be sweet here, see if the player dwarf has one, and adjust
			// well it doesn't - but screw it, I made one
			if (!NPC_IS_TURRET && GameTime() > NEXT_DZOMB_FLEE)
			{
				NEXT_DZOMB_FLEE = GameTime() + Random(8, 12);
				AS_ATTACKING = GameTime() + 5.0f;
				ServerPlaySound(2, 10, SOUND_PAIN1);
				PlayAnim("critical", ANIM_DODGE);
				AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, -200, 100)));
			}
		}

		// if !$get(ent_me,race) equals undead //zombs are too slow to bother with running
		// if game.time > NEXT_DZOMB_FLEE
		// setvard NEXT_DZOMB_FLEE game.time
		// add NEXT_DZOMB_FLEE 10.0
		// callevent npcatk_flee NPCATK_TARGET 128 3.0
		if (DID_ALERT)
			return;
		DID_ALERT = true;
		NEXT_DZOMB_FLEE = GameTime() + Random(8, 12);
		if (!(GameTime() > NEXT_ALERT))
			return;
		AS_ATTACKING = GameTime() + 5.0f;
		PlayAnim("critical", ANIM_ALERT);
		if (!NPC_NO_PLAYER_DMG)
			PlaySound(0, 10, SOUND_ALERT);
		else
			PlayRandomSound(0, 10, SOUND_ALERT1, SOUND_ALERT2, SOUND_ALERT3);

		NEXT_ALERT = GameTime() + 20.0f;
	}

	// frame_roll_back_push
	void DwarfZombieSbow_OnFrameRollBackPush()
	{
		// cuz freaking LX anim dun work :...(
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, -100, 100)));
	}

	// npcatk_clear_targets
	void DwarfZombieSbow_OnNpcatkClearTargets(string reason = "")
	{
		DID_ALERT = false;
	}

	// select_ammo
	void DwarfZombieSbow_OnSelectAmmo()
	{
		if (AMMO_TYPE != "unset") // somehow we are getting here, even when set_ammo is run :\
			return;

		// ^ mental note: game_dynamically_created events apparently go off BEFORE spawn (fixed, maybe)
		AMMO_TYPE = "pierce";
	}

	// set_ammo
	// addparam
	void DwarfZombieSbow_OnSetAmmo(string ammoType = "")
	{
		AMMO_TYPE = ammoType;

		if (StartsWith(ammoType, "poison"))
			AMMO_TYPE = "poison";
		else if (StartsWith(ammoType, "fire"))
			AMMO_TYPE = "explode";
		else if (StartsWith(ammoType, "pierce"))
			AMMO_TYPE = "pierce";
		else
			AMMO_TYPE = "unset";

		OnAdjustXp();

		if (AMMO_TYPE == "unset")
		{
			string title = "MAP ERROR - " + ScriptNameOf(ENT_ME);
			InfoMessage("all", title, "Ammo type incorrectly set, options are: set_ammo;poison | fire | pierce");
		}
	}

	// adjust_xp
	void DwarfZombieSbow_OnAdjustXp()
	{
		if (ADJUSTED_XP)
			return;
		if (AMMO_TYPE == "explode")
		{
			EXPLOSIVE_BOLTS = true;
			NPC_GIVE_EXP += 100.0f;
		}

		if (AMMO_TYPE == "poison")
			NPC_GIVE_EXP += 100.0f;
		ADJUSTED_XP = true;
	}

	// frame_attack_sxbow
	void DwarfZombieSbow_OnFrameAttackSxbow()
	{
		// dbg frame_attack_sxbow
		if (AMMO_COUNT >= 1.0f)
		{
			AMMO_COUNT -= 1.0f;
			OnBowFire();
		}
		else
		{
			if (!NPC_NO_ATTACK)
				OnNpcatkSuspendAttack(1.0f);
			// if !IN_RELOAD
			OnBowReload();
		}
	}

	// bow_fire
	void DwarfZombieSbow_OnBowFire()
	{
		int nbolts = 0;
		bool exitSub = false;
		// dbg bow_fire
		if (AMMO_TYPE == "unset")
			OnSelectAmmo();

		PlaySound(1, 10, SOUND_XBOW_SHOOT);

		MISS_COUNT += 1.0f;

		Vector3 startLine = BonePositionOf(ENT_ME, XBOW_BONE);
		Vector3 targOrg = OriginOf(NPCATK_TARGET);

		if (RandomInt(1, 100) > XBOW_ACCURACY)
		{
			float rndX = Random(-64, 64);
			float rndY = Random(-64, 64);
			targOrg.x += rndX;
			targOrg.y += rndY;
		}

		if (AMMO_TYPE != "pierce")
		{
			// try to land the bolt between him and me
			if (AMMO_TYPE == "poison")
			{
				nbolts = GetArrayCount(PBOLT_ARRAY_NAME);
				if (nbolts >= 5)
				{
					exitSub = true; // unless we're on pbolt cooldown
				}
			}

			float myYaw = AnglesOf(ENT_ME).y;
			targOrg += RelativePosition(Vector3(0, myYaw, 0), Vector3(0, -32, 0));
			targOrg.z = GroundHeight(targOrg);

			XBOW_REPELL_POINT = Text(targOrg);
		}
		else
		{
			// if not player, aim up a bit for center, or I'll probably just hit the ground
			if (!IsPlayer(NPCATK_TARGET))
			{
				float thheight = HeightOf(NPCATK_TARGET) * 0.5f;
				targOrg.z += thheight;
			}
		}

		XBOW_AIM_ANGLES = Angles3DTo(startLine, targOrg);
		float angPitch = XBOW_AIM_ANGLES.x;
		angPitch = -angPitch;
		XBOW_AIM_ANGLES.x = angPitch;
		string endLine = Text(startLine);
		endLine = Text(Vec(endLine) + RelativePosition(XBOW_AIM_ANGLES, Vector3(0, 2048, 0)));
		endLine = LegacyFunction("get_traceline", startLine, endLine, "worldonly");

		XBOW_BOLT_START = Text(startLine);
		XBOW_BOLT_LAND = endLine;

		// if ( G_DEVELOPER_MODE )
		// {
		// effect beam point lgtning.spr 20 XBOW_BOLT_START XBOW_BOLT_LAND (255,0,255) 200 0 0.2
		// }
		// setvard XBOW_REPELL_POINT L_END_LINE
		// vectorset XBOW_REPELL_POINT z $get_ground_height(XBOW_REPELL_POINT)
		// dbg bow_fire XBOW_BOLT_START XBOW_BOLT_LAND
		DoDamageEx(XBOW_BOLT_START, XBOW_BOLT_LAND, DMG_XBOW, "100%", ENT_ME, ENT_ME, "none", "pierce", "dmgevent:bolt");
		if (EXPLOSIVE_BOLTS)
			CallEventDelayed(0.1f, "bolt_explode");
		if (AMMO_TYPE == "poison")
		{
			if (nbolts < 5) // max out at 4 clouds
				CallEventDelayed(0.1f, "pbolt_explode");
		}

		if (XBOW_CL_SCRIPT_ID != "XBOW_CL_SCRIPT_ID")
		{
			string landPoint = XBOW_BOLT_LAND;
			if (AMMO_TYPE != "pierce")
				landPoint = XBOW_REPELL_POINT;
			ClientEvent("update", "all", XBOW_CL_SCRIPT_ID, "fire_bolt", XBOW_BOLT_START, landPoint, XBOW_AIM_ANGLES, EXPLOSIVE_BOLTS);
		}

		// case we're on the edge of a brush, or somethin
		if (!(MISS_COUNT > 4.0f))
			return;
		MISS_COUNT = 0.0f;
		OnChickenRun(3.0f);
	}

	// game_damaged_other
	string DwarfZombieSbow_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		MISS_COUNT = 0.0f;
		return result;
	}

	// bolt_dodamage
	// only seems to go off if we hit an NPC, not walls
	void DwarfZombieSbow_OnBoltDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		// dbg bolt_dodamage
		if (!hit)
			return;
		MISS_COUNT = 0.0f;
		if (AMMO_TYPE == "poison" && RelationshipOf(target, ENT_ME) == "enemy")
			ApplyEffect(target, "effects/dot_poison", 5.0f, self, DOT_POISON);
	}

	// bolt_explode
	void DwarfZombieSbow_OnBoltExplode()
	{
		// dbg bolt_explode
		DoDamageEx(XBOW_REPELL_POINT, 128, DMG_XBOW, 0, ENT_ME, ENT_ME, "none", "fire_effect", "dmgevent:explode");
	}

	// explode_dodamage
	string DwarfZombieSbow_OnExplodeDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		// dbg explode_dodamage
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return result;
		Vector3 targOrg = OriginOf(target);
		float targAng = AnglesTo(Vec(XBOW_REPELL_POINT), targOrg);

		float targDist = Divide(Distance(targOrg, Vec(XBOW_REPELL_POINT)), 128.0f);
		float pushStr = Ratio(targDist, 500, 100);
		float halfPushStr = Divide(pushStr, 2.0f);
		// dbg game_dodamage str PUSH_STR ratio TARG_DIST
		SetVelocity(target, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, pushStr, halfPushStr)));
		return result;
	}

	// bow_reload
	void DwarfZombieSbow_OnBowReload()
	{
		IN_RELOAD = true;
		PlayAnim("critical", ANIM_RELOAD);
	}

	// frame_reload_sxbow
	void DwarfZombieSbow_OnFrameReloadSxbow()
	{
		PlaySound(2, 10, SOUND_RELOAD);
		AMMO_COUNT += 1.0f;
		if (AMMO_COUNT >= AMMO_MAX)
			PlayAnim("critical", ANIM_RELOAD_DONE);
	}

	// frame_reload_sxbow_done
	void DwarfZombieSbow_OnFrameReloadSxbowDone()
	{
		IN_RELOAD = false; // wish we could depend on this
	}

	// pbolt_explode
	void DwarfZombieSbow_OnPboltExplode()
	{
		OnAddPoisonBolt(XBOW_REPELL_POINT);
	}

	// add_poison_bolt
	// <origin>
	void DwarfZombieSbow_OnAddPoisonBolt(string origin = "")
	{
		// dbg ext_poison_bolt PARAM1

		ScriptFlags(ENT_ME, "add", "stack_pbolt", "pbolt", origin, PBOLT_DURATION);
		ClientEvent("new", "all", "effects/sfx_poison_cloud", origin, PBOLT_AOE, PBOLT_DURATION);
		if (PBOLT_ACTIVE)
			return;
		PBOLT_ACTIVE = true;
		PBOLT_COUNTER = 0.0f;
		OnExtPoisonBoltLoop();
	}

	// ext_poison_bolt_loop
	void DwarfZombieSbow_OnExtPoisonBoltLoop()
	{
		// nice thing about this setup is we shouldn't have to do anything in game_scriptflags
		if (!PBOLT_ACTIVE)
			return;

		PBOLT_ARRAY_NAME = ScriptFlag(ENT_ME, "pbolt", "type_array");

		if (PBOLT_ARRAY_NAME != "none")
		{
			float nbolts = GetArrayCount(PBOLT_ARRAY_NAME) - 1.0f;
			if (PBOLT_COUNTER > nbolts) // bolt expired during last loop, or there's only 1 active bolt
				PBOLT_COUNTER = 0.0f;
			CUR_PBOLT_ORG = GetArray(PBOLT_ARRAY_NAME, Text(PBOLT_COUNTER));
			OnExtPoisonBoltDmg();

			float boltScanSpeed = 1.0f;

			if (nbolts > 0.0f)
				boltScanSpeed = Divide(boltScanSpeed, nbolts);
			if (boltScanSpeed < 0.1f) // max scans = 1/0.2secs
				boltScanSpeed = 0.2f;

			PBOLT_COUNTER += 1.0f;

			CallEventDelayed(boltScanSpeed, "ext_poison_bolt_loop");
		}
		else
		{
			PBOLT_ACTIVE = false;
		}
	}

	// ext_poison_bolt_dmg
	void DwarfZombieSbow_OnExtPoisonBoltDmg()
	{
		Vector3 scanPoint = Vec(CUR_PBOLT_ORG);
		scanPoint.z += 32.0f; // in case the ground is uneven
		DoDamageEx(scanPoint, PBOLT_AOE, DMG_XBOW, 0.1f, ENT_ME, ENT_ME, "none", "poison_effect", "dmgevent:pbolt_cloud");
	}

	// pbolt_cloud_dodamage
	void DwarfZombieSbow_OnPboltCloudDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		ApplyEffect(target, "effects/dot_poison", 5.0f, self, DOT_POISON);
	}

	// game_death
	void DwarfZombieSbow_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		// (always true here) if !NPC_NO_DROP
		float chance = ActivePlayerCount() * 2.0f;
		if (!(RandomInt(1, 100) < chance))
			return;
		CreateNpc("chests/base_quiver_of", Vec("proj_bolt_poison"), 25);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_precache
	void OnGamePrecache()
	{
		DwarfZombieSbow_OnGamePrecache();
		DwarfLanternBase_OnGamePrecache(); // NPCs/dwarf_lantern_base
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		DwarfLanternBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // NPCs/dwarf_lantern_base
		DwarfZombieSbow_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, DwarfZombieSbow_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseStruck_OnGameSpawn(playerRace, playerGender); // monsters/base_struck
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		DwarfZombieSbow_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseStruck_OnNpcatkHunt(); // monsters/base_struck
		DwarfLanternBase_OnNpcatkHunt(); // NPCs/dwarf_lantern_base
	}

	// npcatk_clear_targets
	void OnNpcatkClearTargets(string reason = "")
	{
		BaseNpcAttackNew_OnNpcatkClearTargets(reason); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkClearTargets(reason); // monsters/base_monster_shared
		BaseMonsterShared_OnNpcatkClearTargets_2(reason); // monsters/base_monster_shared
		DwarfZombieSbow_OnNpcatkClearTargets(reason);
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseStruck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		DwarfZombieSbow_OnNpcTargetsighted(target);
	}

	void OnDarcherSpawn() { DwarfZombieSbow_OnDarcherSpawn(); } // darcher_spawn
	void OnFrameRollBackPush() { DwarfZombieSbow_OnFrameRollBackPush(); } // frame_roll_back_push
	void OnSelectAmmo() { DwarfZombieSbow_OnSelectAmmo(); } // select_ammo
	void OnSetAmmo(string ammoType = "") { DwarfZombieSbow_OnSetAmmo(ammoType); } // set_ammo
	void OnAdjustXp() { DwarfZombieSbow_OnAdjustXp(); } // adjust_xp
	void OnFrameAttackSxbow() { DwarfZombieSbow_OnFrameAttackSxbow(); } // frame_attack_sxbow
	void OnBowFire() { DwarfZombieSbow_OnBowFire(); } // bow_fire
	void OnBoltDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { DwarfZombieSbow_OnBoltDodamage(hit, target, start, end, damageType, damageText); } // bolt_dodamage
	void OnBoltExplode() { DwarfZombieSbow_OnBoltExplode(); } // bolt_explode
	string OnExplodeDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return DwarfZombieSbow_OnExplodeDodamage(hit, target, start, end, damageType, damageText); } // explode_dodamage
	void OnBowReload() { DwarfZombieSbow_OnBowReload(); } // bow_reload
	void OnFrameReloadSxbow() { DwarfZombieSbow_OnFrameReloadSxbow(); } // frame_reload_sxbow
	void OnFrameReloadSxbowDone() { DwarfZombieSbow_OnFrameReloadSxbowDone(); } // frame_reload_sxbow_done
	void OnPboltExplode() { DwarfZombieSbow_OnPboltExplode(); } // pbolt_explode
	void OnAddPoisonBolt(string origin = "") { DwarfZombieSbow_OnAddPoisonBolt(origin); } // add_poison_bolt
	void OnExtPoisonBoltLoop() { DwarfZombieSbow_OnExtPoisonBoltLoop(); } // ext_poison_bolt_loop
	void OnExtPoisonBoltDmg() { DwarfZombieSbow_OnExtPoisonBoltDmg(); } // ext_poison_bolt_dmg
	void OnPboltCloudDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { DwarfZombieSbow_OnPboltCloudDodamage(hit, target, start, end, damageType, damageText); } // pbolt_cloud_dodamage
	void OnLBoltScanSpeed() {} // L_BOLT_SCAN_SPEED

	// This file's events and timers by their .script names
	bool DwarfZombieSbow_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "add_poison_bolt") { OnAddPoisonBolt(Param(params, 0)); return true; }
		if (name == "adjust_xp") { OnAdjustXp(); return true; }
		if (name == "bolt_dodamage") { OnBoltDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "bolt_explode") { OnBoltExplode(); return true; }
		if (name == "bow_fire") { OnBowFire(); return true; }
		if (name == "bow_reload") { OnBowReload(); return true; }
		if (name == "darcher_spawn") { OnDarcherSpawn(); return true; }
		if (name == "explode_dodamage") { Return(OnExplodeDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "ext_poison_bolt_dmg") { OnExtPoisonBoltDmg(); return true; }
		if (name == "ext_poison_bolt_loop") { OnExtPoisonBoltLoop(); return true; }
		if (name == "frame_attack_sxbow") { OnFrameAttackSxbow(); return true; }
		if (name == "frame_reload_sxbow") { OnFrameReloadSxbow(); return true; }
		if (name == "frame_reload_sxbow_done") { OnFrameReloadSxbowDone(); return true; }
		if (name == "frame_roll_back_push") { OnFrameRollBackPush(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_clear_targets") { OnNpcatkClearTargets(Param(params, 0)); return true; }
		if (name == "pbolt_cloud_dodamage") { OnPboltCloudDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "pbolt_explode") { OnPboltExplode(); return true; }
		if (name == "select_ammo") { OnSelectAmmo(); return true; }
		if (name == "set_ammo") { OnSetAmmo(Param(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/dwarf_zombie_sbow"]
shared class DwarfZombieSbowScript : BaseMonsterNewScript, DwarfZombieSbow, BaseStruck, DwarfLanternBase
{
	// Variables every script that includes this file declares
	string AI_NO_TARGET_STRING = "AI_NO_TARGET_STRING";
	float ALLY_AS_UNSTUCK_ANG = 0.0f;
	int ALLY_FOLLOW_CLOSE_DIST = 0;
	int ALLY_FOLLOW_NORM_DIST = 0;
	bool ALLY_FOLLOW_ON = false;
	int ALLY_FOLLOW_PLR_DIST = 0;
	string ALLY_FOLLOW_PLR_ID = "ALLY_FOLLOW_PLR_ID";
	string ALLY_FPLAYER_LIST = "ALLY_FPLAYER_LIST";
	float ALLY_FWD_JUMP_STR = 0.0f;
	bool ALLY_IS_LEADER = false;
	float ALLY_JUMP_STR = 0.0f;
	int ALLY_JUMP_THRESHOLD = 0;
	string ALLY_LEADER_DEST = "ALLY_LEADER_DEST";
	int ALLY_MAX_JUMP_RANGE = 0;
	int ALLY_MIN_DISTANCE = 0;
	int ALLY_MOVE_AWAY_DIST = 0;
	float ALLY_NEXT_FAS_CHECK = 0.0f;
	float ALLY_NEXT_FOLLOW_CHECK = 0.0f;
	float ALLY_NEXT_LEADER_UPDATE = 0.0f;
	float ALLY_NEXT_REGEN = 0.0f;
	int ALLY_OLD_DIST = 0;
	float ALLY_REGEN_RATIO = 0.0f;
	float ALLY_STUCK_COUNT = 0.0f;
	string ANIM_ALLY_JUMP = "ANIM_ALLY_JUMP";
	float FREQ_ALLYJUMP = 0.0f;
	float NEXT_ALLYJUMP = 0.0f;
	string NPC_BASE_EXP = "NPC_BASE_EXP";
	bool NPC_BATTLE_ALLY = false;
	string SOUND_ALERT1 = "SOUND_ALERT1";
	string SOUND_ALERT2 = "SOUND_ALERT2";
	string SOUND_ALERT3 = "SOUND_ALERT3";
	string SOUND_ALLY_JUMP = "SOUND_ALLY_JUMP";

	// Variables declared by included files, with the value they start with in this script
	DwarfZombieSbowScript()
	{
		SOUND_DEATH = "agrunt/ag_die5.wav";
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle";
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/bows/boltexplosive.mdl");
		Precache("explode1.spr");
		Precache("agrunt/ag_pain3.wav");
		Precache("3dmflagry.spr");
		Precache("dwarf/male1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DwarfZombieSbow_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseStruck_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return DwarfZombieSbow_DispatchEvent(name, params)
			|| BaseStruck_DispatchEvent(name, params)
			|| DwarfLanternBase_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
