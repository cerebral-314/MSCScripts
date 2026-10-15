#pragma context server

// Converted from monsters/wyrm_fire.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_struck.as"

[script "monsters/wyrm_fire"]
class WyrmFire : BaseMonsterNewScript, BaseStruck
{
	// Constants
	string WYRM_TYPE = "fire";
	bool WYRM_SKIN = false;
	int WYRM_SIZE = 1;
	string MONSTER_MODEL = "monsters/wyrms_medium.mdl";
	string ANIM_APPEAR = "anim_appear";
	string ANIM_RETRACT = "anim_retract";
	string ANIM_RAWR = "anim_blong";
	string ANIM_BITE1 = "anim_bite1";
	string ANIM_BITE2 = "anim_bite2";
	string ANIM_SPIT = "anim_spit";
	string ANIM_SWIPE = "anim_swipe";
	string ANIM_HEADBUTT = "anim_hbutt";
	string ANIM_FLINCH1 = "anim_flinch1";
	string ANIM_FLINCH2 = "anim_flinch2";
	string ANIM_HIDDEN = "anim_hidden";
	int ATTACK_RANGE_BITE = 245;
	int ATTACK_RANGE_SPIT = 4096;
	float FREQ_SWIPE = 0.0f;
	float FREQ_MODE_SWITCH = 0.0f;
	float FREQ_PIT_SEARCH = 0.0f;
	float PROJ_SPEED = 300.0f;
	string PROJ_DMG = "50";
	int PROJ_COF = 5;
	string PROJ_SCRIPT = "proj_fire_bomb_sm";
	float FREQ_SPIT = 0.0f;
	bool ATT_MOUTH = false;
	string SOUND_SPIT_PREP = "magic/fireball_large.wav";
	string SOUND_SPIT_STRIKE = "weapons/rocketfire1.wav";
	string SOUND_ALERT1 = "monsters/wyrm/c_x0stgwar_bat1.wav";
	string SOUND_ALERT2 = "monsters/wyrm/c_x0stgwar_bat2.wav";
	string SOUND_BITE = "monsters/wyrm/8bit/c_x0stgwar_atk1.wav";
	string SOUND_HBUTT = "monsters/wyrm/c_x0stgwar_atk2.wav";
	string SOUND_SWIPE = "monsters/wyrm/c_x0stgwar_atk3.wav";
	string SOUND_SWIPE_LARGE = "weapons/swinghuge.wav";
	string SOUND_SPLASH_DOWN = "monsters/wyrm/lava_splash_rev.wav";
	string SOUND_SPLASH_UP = "amb/lava_splash.wav";
	string SOUND_LAVA_LOOP = "amb/lava_loop.wav";
	string SOUND_PASSIVE1 = "monsters/wyrm/idle1.wav";
	string SOUND_PASSIVE2 = "monsters/wyrm/idle2.wav";
	string SOUND_PASSIVE3 = "monsters/wyrm/idle3.wav";
	string SOUND_PASSIVE4 = "monsters/wyrm/idle4.wav";
	float FREQ_PASSIVE = 0.0f;
	float DUR_QUAKE = 7.0f;
	int AOE_HBUTT = 80;
	int AOE_SWIPE = 128;
	int DMG_HBUTT = 75;
	float DMG_BITE = 65.0f;
	int DMG_FROCK = 100;
	string DMG_SWIPE = "50";
	string DOT_SCRIPT = "effects/dot_fire";
	string DOT_EFFECTNAME = "DOT_fire";
	float DOT_DMG = 25.0f;
	float DOT_DUR = 5.0f;
	string DOT_SCRIPT2 = "effects/dot_fire";
	string DOT_EFFECTNAME2 = "DOT_fire";
	int DOT_DMG2 = 25;
	float DOT_DUR2 = 5.0f;
	Vector3 WYRM_GLOW_COLOR = Vector3();
	bool NPC_NO_MOVE = true;
	bool CANT_FLEE = true;
	bool NPC_USE_FLINCH = true;
	bool NPC_USE_PAIN = true;
	bool NPC_USE_IDLE = false;
	float NPC_FLINCH_HEALTH_RATIO = 0.5f;
	string NPC_MATERIAL_TYPE = "carapace";
	string SOUND_PAIN1 = "monsters/wyrm/c_x0stgwar_hit1.wav";
	string SOUND_PAIN2 = "monsters/wyrm/c_x0stgwar_hit2.wav";
	string SOUND_PAIN3 = "monsters/wyrm/c_x0stgwar_hit2.wav";
	string SOUND_FLINCH1 = "monsters/wyrm/c_x0stgwar_hit1.wav";
	string SOUND_FLINCH2 = "monsters/wyrm/c_x0stgwar_hit2.wav";
	string SOUND_FLINCH3 = "monsters/wyrm/c_x0stgwar_hit2.wav";

	// Variables (an unset .script variable reads as its own name)
	string WYRM_EDGE_PREFIX = "WYRM_EDGE_PREFIX";
	string WYRM_PIT_PREFIX = "WYRM_PIT_PREFIX";
	int WYRM_SPEED = 0;
	string WYRM_MOVEDEST = "WYRM_MOVEDEST";
	string PROJ_LOOP_SOUND = "PROJ_LOOP_SOUND";
	float CUR_PASSIVE = 0.0f;
	float WYRM_CUR_PIT_IDX = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_FLINCH = "ANIM_FLINCH";
	float GAME_PUSH_RATIO = 0.0f;
	bool CAN_SPIT = false;
	int WYRM_UNHIDE_RANGE = 0;
	float NEXT_PITHUNT = 0.0f;
	bool WYRM_FINALIZED = false;
	bool WYRM_USE_EDGES = false;
	float N_EDGE_POINTS = 0.0f;
	bool WYRM_USE_PITS = false;
	float N_PIT_POINTS = 0.0f;
	string WYRM_CUR_PIT = "WYRM_CUR_PIT";
	string WYRM_MMODE = "WYRM_MMODE";
	bool WYRM_USE_BOTH = false;
	bool WYRM_GOT_ALL_EDGE_POINTS = false;
	bool WYRM_GOT_ALL_PIT_POINTS = false;
	string WYRM_OLD_TARGET = "WYRM_OLD_TARGET";
	bool WYRM_HIDE_MODE = false;
	float WYRM_UNHIDE_TIME = 0.0f;
	bool NPC_FLINCH_DISABLE = false;
	int LAVA_VOLUME = 0;
	float NEXT_GIVEUP = 0.0f;
	bool WYRM_TELEPORTING = false;
	bool WYRM_SUBMERGING = false;
	float NEXT_SWIPE_CHECK = 0.0f;
	float NEXT_MODE_SWITCH = 0.0f;
	float NEXT_PIT_SEARCH = 0.0f;
	int INTRO_STAGE = 0;
	bool WYRM_COMBAT_INITIATED = false;
	float NEXT_PASSIVE = 0.0f;
	float NEXT_WORM_HIDE = 0.0f;
	float NEXT_LOCAL_SCAN = 0.0f;
	string WYRM_PORTING_TO = "WYRM_PORTING_TO";
	float NEXT_WYRM_FLOAT = 0.0f;
	int DID_INTRO = 0;
	float NEXT_SPIT = 0.0f;
	float WYRM_SPIT_COUNT = 0.0f;
	bool DO_QUAKE = false;
	float WYRM_EDGE_INIT = 0.0f;
	int T_NEAREST = 0;
	float WYRM_NEXT_EDGE_IDX = 0.0f;
	string PIT_TARGET = "PIT_TARGET";
	float MOVE_TO_PIT_IDX = 0.0f;
	string MOVE_TO_PIT = "MOVE_TO_PIT";
	int T_LEAST_DIST = 0;
	bool WYRM_TELE_STAGE2 = false;
	Vector3 REPELL_POS = Vector3();
	string T_SPHERE = "T_SPHERE";
	string PROJ_TARGET = "PROJ_TARGET";
	float DID_BITE = 0.0f;
	bool WYRM_SUBMERGE_GOT_ENDFRAME = false;
	string WYRM_NO_TELEPORT_FLAG = "WYRM_NO_TELEPORT_FLAG";
	Vector3 FIRE_BOMB_POS = Vector3();
	float NEXT_PUSH_ALERT = 0.0f;
	bool DID_FLEE1 = false;
	bool DID_FLEE2 = false;
	bool DID_FLEE3 = false;
	float NEXT_LOOP_LAVA = 0.0f;
	string TARGET_LIST = "TARGET_LIST";
	string WYRM_LIGHT_CLIDX = "WYRM_LIGHT_CLIDX";
	float NEXT_LIGHT_REFRESH = 0.0f;
	bool WYRM_LIGHT_ACTIVE = false;
	bool NO_QUAKES = false;
	bool WYRM_PITHUNTER = false;

	// Variables declared by included files, with the value they start with in this script
	WyrmFire()
	{
		ANIM_IDLE = "anim_idle";
		ANIM_WALK = "anim_idle";
		ANIM_RUN = "anim_idle";
		CANT_TURN = "1";
		NPC_GIVE_EXP = 1000.0f;
		SOUND_DEATH = "monsters/wyrm/c_x0stgwar_dead.wav";
	}

	// unnamed block (first think)
	// current issues:
	// need to test with just edges and with no setting
	// plug in final damage numbers
	// Lava Wyrm (hard demon, 80x256, 5000hp, Base 750xp)
	// - Wyrms are large, dragon-like worms that create tunnels throughout the underworld of Leane. Some were harnessesd by Lor Malgoriand to create underground paths through which his armies could move unseen and bypass portions of The Wall. Dwarves, while they have yet to harness them directly, will sometimes herd groups of smaller wyrms to create tunnels faster, though such efforts are desperate and dangerous.
	// - Wyrms come in a staggering variey of types and sizes. This paticular wyrm is a moderately sized Lava Wyrm, capable of swimming through solid rock as if it were water.
	// -
	// - Placement: Intended to be semi mobile around edges of a large platform, with holes he can pop up through or placed in a pit of appropriately themed deadly element.
	// -
	// - optional entities:
	// -- info_target: wyrm_edge1 (up to ...20)
	// --- Teleport points around the edge of the platfrom the mob can emerge at and float between.
	// --- There should be a clear line of movement between these points in logical order, similar to looping func_train tracks.
	// -- info_target: wyrm_pit1 (up to ...20)
	// -- Pits in the platform or scattered across the level that the mob can tunnel up and emerge at.
	// -
	// - If none of these entities exist, mob will float around randomly near its spawn point, hopefully obeying monster clips.
	// When mobile, mob's movement is independent of his aim target, either floating from wyrm_edgeX points or randomly until blocked.
	// While at wyrm_pitX points, wyrm remains stationary, wyrm periodically submerges and re-emerges at wyrm_pitX point closest to target.
	// -
	// - Attack pattern consists of four AOE melee attacks, one of which is stun, and another a heavy repulse via uncoiling.
	// If no targets are in melee range, the Lava Wyrm will continue to fire projectiles, half of which are guided, all of which explode on impact, applying force and DOT.
	// After every fourth or fifth projectile, the Lava Wyrm will pause to roar and create an earthquake. This will cause flaming rocks to dislodge from the ceiling.
	// These do signifigant damage, but can be fairly easily avoided by continuous movement.
	// -
	// - other addparams:
	// -- set_noquakes
	// --- If you are using more than one lava wyrm, or lava wyrms combined with Earth Elementals, this is recomended, as the tempent spam from multiple quakes is rough.
	// --- Wyrms set set_noquake will spit projectiles more often.
	// -- set_pithunt
	// --- Changes behavior so that the wyrm will constantly look among its pits for a random player target and emerge there
	// --- Whenever losing more than 25% health, wyrm will flee to a random pit.
	// --- Beware this may make him nigh indestructible if he's boss flagged, and thus regenerates while in retreat.
	// --- (Unless you have very few pits and a player waiting at each.)
	// --- Use set_endpithunt via msnpc_script to end this behavior.
	// --- This type of behavior requires pit points, and it is suggested that only pit points are used
	// -- set_edge_prefix;<name>
	// -- set_pit_prefix;<name>
	// --- Allows you to change the info_target set used for pits and edges. (Useful when using multiple wyrms.)
	// --- For instance, if you used set_pit_prefix;my_pit - you would place info_targets named my_pit1, my_pit2, etc.
	// --- Without this, there's a good chance multiple wyrms will appear at the same pit or edge point
	// - Creature is initially hidden, and wont react until it hears a target within 384 units.
	// - Not the toughest thing ever, but a fairly self-sufficient boss, whose mobility gives him some staying power.
	// - XP maybe adjusted based on mobility
	// - Other flavors and sizes easily available upon request.
	// <nixed>
	// Lava Wyrms, or other wyrms set in deadly pits, will need a targetname to be healed by their pits
	// the pit should have a trigger_multiple with the scriptedevent: gm_map_feedpit;<wyrm_targetname>;<dmg_type>
	// (Handled dmg_types are: fire, cold, poison, and dark - other types will still do damage of type but not apply DOT)
	// creatures in this pit will take heavy dmg_type damage and DOT (based on victim's maxhp), feeding the wyrm for the HP lost during each tick
	// reset delay should be 1 second, and individual cooldowns set to "Scriptevent Only" [1]
	// the pit will not affect creatures allied with the wyrm (unless the wyrm is dead, though immunities still apply)
	// - Multiple wyrms in the same pit will probably not heal reliably (even if they all share the same targetname and link).
	void WyrmFire_FirstThink()
	{
		// custom
		WYRM_EDGE_PREFIX = "wyrm_edge";
		WYRM_PIT_PREFIX = "wyrm_pit";
		WYRM_SPEED = 100;
		WYRM_MOVEDEST = "unset";

		NPC_NO_ATTACK = true; // attacks are handled via target sighted
		PROJ_LOOP_SOUND = "ambient/animals/rattle_long.wav"; // ** for proj_fire_bomb_sm
		CUR_PASSIVE = 0.0f;

		// ** Liable to change by type
		WYRM_CUR_PIT_IDX = 0.0f;

		// base AI
		ANIM_IDLE = "anim_idle";
		ANIM_WALK = "anim_idle";
		ANIM_RUN = "anim_idle";
		ANIM_ATTACK = ANIM_BITE1;
		ANIM_DEATH = "anim_death";
		CANT_TURN = "1";
		NPC_GIVE_EXP = 1000.0f;
		NO_STUCK_CHECKS = "1";
		ATTACK_RANGE = 256.0f; // not used, but AI might need it
		ATTACK_HITRANGE = 256.0f; // not used, but AI might need it
		ANIM_FLINCH = "anim_flinch1";
	}

	// game_damaged_other
	// PARAM1=target_hit PARAM2=dmg PARAM3=dmg_type
	string WyrmFire_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		bool incDmg = false;
		string result = "";

		NEXT_GIVEUP = GameTime() + 20.0f;

		// this is cheap, but he needs help
		if (IsNoPush(target))
			incDmg = true;

		if (incDmg)
		{
			float finDmg = damage * 4.0f;
			result = AppendResult(result, "4.0");

			if (IsPlayer(target))
			{
				NEXT_PUSH_ALERT = 10.0f + GameTime();
				PlayerMessageRed(target, "Your push immunity causes you to absorb the " + NameOf(ENT_ME) + " 's sheer strength as extra damage!");
			}
		}
		return result;
	}

	// game_damaged
	string WyrmFire_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		if (WYRM_PITHUNTER)
		{
			// pit hunters refresh flee stats in case of regeneration from boss tag
			if (HealthOf(ENT_ME) >= MaxHealthOf(ENT_ME) * 0.75f)
				DID_FLEE1 = false;
			if (HealthOf(ENT_ME) >= MaxHealthOf(ENT_ME) * 0.50f)
				DID_FLEE2 = false;
			if (HealthOf(ENT_ME) >= MaxHealthOf(ENT_ME) * 0.25f)
				DID_FLEE3 = false;
		}

		if (HealthOf(ENT_ME) < MaxHealthOf(ENT_ME) * 0.75f && !DID_FLEE1)
		{
			DID_FLEE1 = true;
			NEXT_PITHUNT = GameTime() + 20.0f;
			OnDoFlee();
		}

		if (HealthOf(ENT_ME) < MaxHealthOf(ENT_ME) * 0.5f && !DID_FLEE2)
		{
			DID_FLEE2 = true;
			NEXT_PITHUNT = GameTime() + 20.0f;
			OnDoFlee();
		}

		if (HealthOf(ENT_ME) < MaxHealthOf(ENT_ME) * 0.25f && !DID_FLEE3)
		{
			DID_FLEE3 = true;
			NEXT_PITHUNT = GameTime() + 20.0f;
			OnDoFlee();
		}
		return result;
	}

	// fake_precache
	void OnFakePrecache()
	{
		ServerPlaySound(0, 0, "ambient/animals/rattle_long.wav");
		ServerPlaySound(0, 0, "monsters/wyrm/idle1.wav");
		ServerPlaySound(0, 0, "monsters/wyrm/idle2.wav");
		ServerPlaySound(0, 0, "monsters/wyrm/idle3.wav");
		ServerPlaySound(0, 0, "monsters/wyrm/idle4.wav");
		ServerPlaySound(0, 0, "amb/lava_loop.wav");
	}

	// game_precache
	void OnGamePrecache()
	{
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, WyrmFire_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// bs_global_command
	// player I was attacking died
	void OnBsGlobalCommand(CBasePlayer@ deadPlayer = null, string command = "", string reason = "")
	{
		MonstersExternals_OnBsGlobalCommand(deadPlayer, command, reason); // monsters/externals
		DebugPrint("bs_global_command " + NameOf(deadPlayer) + " " + command + " " + reason);
		if (EntityId(deadPlayer) != NPCATK_TARGET)
			return;
		NPCATK_TARGET = "unset";
		if (reason != "death")
			return;
		CallEventDelayed(3.0f, "anger_sated");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		OnWyrmSpawn();
		CallEventDelayed(2.0f, "wyrm_finalize");
	}

	// npcatk_hunt
	// ====================================================================== Main Hunt Cycle - Start
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseStruck_OnNpcatkHunt(); // monsters/base_struck

		float gameTime = GameTime();

		if (gameTime > NEXT_PASSIVE)
		{
			CUR_PASSIVE += 1.0f;
			if (CUR_PASSIVE == 1.0f)
				ServerPlaySound(2, 10, SOUND_PASSIVE1);
			if (CUR_PASSIVE == 2.0f)
				ServerPlaySound(2, 10, SOUND_PASSIVE2);
			if (CUR_PASSIVE == 3.0f)
				ServerPlaySound(2, 10, SOUND_PASSIVE3);
			if (CUR_PASSIVE == 4.0f)
			{
				ServerPlaySound(2, 10, SOUND_PASSIVE4);
				CUR_PASSIVE = 0.0f;
			}
			NEXT_PASSIVE = gameTime;
			NEXT_PASSIVE += FREQ_PASSIVE;
		}

		// dbg passive_sound CUR_PASSIVE
		if (gameTime > NEXT_LOOP_LAVA)
		{
			if (WYRM_HIDE_MODE)
			{
				LAVA_VOLUME = 3;
				OnLoopLava();
			}
			else
			{
				LAVA_VOLUME = 10;
				OnLoopLava();
			}
		}

		if (NPCATK_TARGET == "unset")
		{
			if (!WYRM_HIDE_MODE)
			{
				if (gameTime > NEXT_WORM_HIDE)
				{
					NEXT_WORM_HIDE = 99999.0f;
					OnDoSubmerge("1", "lack_of_target");
					DebugPrint("hiding from lack of target");
				}
			}
			else
			{
				if (gameTime > NEXT_LOCAL_SCAN && gameTime > WYRM_UNHIDE_TIME)
				{
					NEXT_LOCAL_SCAN = gameTime;
					NEXT_LOCAL_SCAN += 0.5f;
					string sphere = FindInSphere("enemy", 512);
					if (sphere != "none")
					{
						OnWyrmAppear(GetToken(sphere, 0), "local_scan");
						return;
					}
				}
				if (WYRM_PITHUNTER && gameTime > NEXT_PITHUNT)
				{
					NEXT_PITHUNT = gameTime;
					NEXT_PITHUNT += 10.0f;
					WYRM_PORTING_TO = "pit";
					OnFindNextPit("randomtarg");
					OnWyrmTeleport("pit_hunt");
				}
			}
		}

		if (WYRM_LIGHT_ACTIVE && gameTime > NEXT_LIGHT_REFRESH)
			OnGlowToggle(1);

		if (!WYRM_HIDE_MODE && WYRM_MOVEDEST != "unset")
		{
			Vector3 myOrg = OriginOf(ENT_ME);
			float yaw = AnglesTo(myOrg, Vec(WYRM_MOVEDEST));
			yaw = Vec(Text(yaw)).y;
			SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, yaw, 0), Vector3(0, WYRM_SPEED, 0)));
		}

		if (WYRM_HIDE_MODE)
			return;
		if (NPCATK_TARGET == "unset")
			return;

		if (gameTime > NEXT_GIVEUP)
		{
			// I've not seen nor hit anything for 20 seconds, give up, I'll move to next pit, if I have one
			DebugPrint("idle too long, giving up target...");
			NPCATK_TARGET = "unset";
		}

		SetMoveDest(NPCATK_TARGET, 9999);

		NEXT_WORM_HIDE = gameTime;
		NEXT_WORM_HIDE += 20.0f;

		// perodically switch between pits and floating between edge waypoints, if we have both
		if (WYRM_USE_BOTH && gameTime > NEXT_MODE_SWITCH)
		{
			NEXT_MODE_SWITCH = FREQ_MODE_SWITCH + gameTime;
			if (!WYRM_HIDE_MODE)
			{
				DebugPrint("picking new movement mode");
				OnWyrmPickMovementMode("npcatk_hunt");
			}
		}

		if (WYRM_MMODE == "edges")
		{
			string edgeOrg = GetArray("ARRAY_EDGE_POINTS", Text(WYRM_NEXT_EDGE_IDX));
			WYRM_MOVEDEST = Text(OriginOf(edgeOrg));
			Vector3 myPos = OriginOf(ENT_ME);
			if (Distance(myPos, Vec(WYRM_MOVEDEST)) < 16.0f)
			{
				OnFindNextEdge(); // next think cycle we'll have new edge waypoint
			}
		}

		if (WYRM_MMODE == "pits")
		{
			// keep slowly moving to pit center in case we get kocked about
			string pitOrg = GetArray("ARRAY_PIT_POINTS", WYRM_CUR_PIT);
			// dbg WYRM_MOVEDEST setto WYRM_MOVEDEST idx WYRM_CUR_PIT id $get_array(ARRAY_PIT_POINTS,WYRM_CUR_PIT)
			WYRM_MOVEDEST = Text(OriginOf(pitOrg));
		}

		if (WYRM_MMODE == "none")
		{
			// float around - hope monsterclip stops me from leaving lava pit
			if (gameTime > NEXT_WYRM_FLOAT)
			{
				NEXT_WYRM_FLOAT = gameTime;
				NEXT_WYRM_FLOAT += Random(3, 7);
				float moveYaw = Random(0, 359.99f);
				Vector3 moveTo = OriginOf(ENT_ME) + RelativePosition(Vector3(0, moveYaw, 0), Vector3(0, 256, 0));
				WYRM_SPEED = 20;
				WYRM_MOVEDEST = Text(moveTo);
			}
		}
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		BaseNpcAttackNew_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_monster_shared
		if (!WYRM_HIDE_MODE)
			return;
		if (!(GameTime() > WYRM_UNHIDE_TIME))
			return;
		if (WYRM_TELEPORTING)
			return;
		if (WYRM_SUBMERGING)
			return;
		CBaseEntity@ heardId = EntityOf(ENT_LASTHEARD);
		if (RelationshipOf(heardId, ENT_ME) != "enemy")
			return;
		if (!(RangeTo(heardId) < WYRM_UNHIDE_RANGE))
			return;
		OnWyrmAppear(EntityId(heardId), "heard_sound");
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseStruck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, WyrmFire_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_targetsighted
	// ====================================================================== Main Hunt Cycle - End
	// ====================================================================== Attack Cycle - Start
	// - this would normally be done under npc_select_attack, but we got funky
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (DID_INTRO == 0)
		{
			DID_INTRO = 1;
			NPC_FLINCH_DISABLE = true;
			INTRO_STAGE = 1;
			PlayAnim("critical", ANIM_RAWR);
			CallEventDelayed(3.0f, "intro_done"); // in case frame_blong_end doesn't complete
		}
		if (!(INTRO_STAGE > 1)) // attack cycle suspended until intro done
			return;

		// dbg range $get(NPCATK_TARGET,range)
		float gameTime = GameTime();

		if (RangeTo(NPCATK_TARGET) <= ATTACK_RANGE_BITE)
		{
			PlayAnim("once", ANIM_ATTACK);
		}
		else if (gameTime > NEXT_SPIT)
		{
			NEXT_SPIT = GameTime() + FREQ_SPIT;
			WYRM_SPIT_COUNT += 1.0f;
			if (WYRM_SPIT_COUNT >= 5.0f)
			{
				// give a bit of a breather
				NEXT_SPIT += 10.0f;
				WYRM_SPIT_COUNT = 0.0f;
				DO_QUAKE = true;
				PlayAnim("critical", ANIM_RAWR);
				return;
			}
			PlayAnim("once", ANIM_SPIT);
		}
	}

	// npc_targetvalidate
	// ====================================================================== To be sorted
	void OnNpcTargetvalidate(CBaseEntity@ target = null)
	{
		BaseMonsterShared_OnNpcTargetvalidate(target); // monsters/base_monster_shared
		if (WYRM_TELEPORTING)
			NPCATK_TARGET = "unset";
		if (WYRM_SUBMERGING)
			NPCATK_TARGET = "unset";
		if (NPCATK_TARGET == "unset")
			DebugPrint("targetinvalidcuz: tele " + Text(WYRM_TELEPORTING) + " sub " + Text(WYRM_SUBMERGING));
		if (!WYRM_HIDE_MODE)
			return;
		if (!(RangeTo(NPCATK_TARGET) > 256.0f))
			return;
		NPCATK_TARGET = "unset";
	}

	// wyrm_spawn
	// override this for other types
	void OnWyrmSpawn()
	{
		SetName("Lava Wyrm");

		SetModel(MONSTER_MODEL);

		GAME_PUSH_RATIO = 0.1f;

		if (WYRM_SIZE == 1)
		{
			SetWidth(80);
			SetHeight(256);
		}

		SetRace("demon");
		SetBlood("red");
		SetProp(ENT_ME, "skin", WYRM_SKIN);

		SetHealth(5000);
		SetDamageTaken("all", 0.5f);
		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 1.5f);

		SetHearingSensitivity(11);
		CAN_SPIT = true;

		SetIdleAnim(ANIM_HIDDEN);
		SetMoveAnim(ANIM_HIDDEN);

		WYRM_UNHIDE_RANGE = 384; // might set higher for larger wyrms
		CallEventDelayed(0.1f, "wyrm_hide");

		// make sure initiated before pit hunting
		NEXT_PITHUNT = GameTime() + 20.0f;
	}

	// wyrm_finalize
	void OnWyrmFinalize()
	{
		if (WYRM_FINALIZED)
			return;
		WYRM_FINALIZED = true; // case this gets called twice for some weird reason
		ArrayCreate("ARRAY_EDGE_POINTS");
		ArrayCreate("ARRAY_PIT_POINTS");
		string edge1Name = WYRM_EDGE_PREFIX + "1";
		CBaseEntity@ edge1 = FindByName(edge1Name);
		if (Exists(edge1))
		{
			DebugPrint("wyrm_finalize found edge1");
			WYRM_USE_EDGES = true;
			N_EDGE_POINTS = 0.0f;
			for (int i = 0; i < 20; i++)
			{
				loopIteration = i;
				OnWyrmGetEdgesLoop();
			}
		}
		string pit1Name = WYRM_PIT_PREFIX + "1";
		CBaseEntity@ pit1 = FindByName(pit1Name);
		if (Exists(pit1))
		{
			DebugPrint("wyrm_finalize found pit1");
			WYRM_USE_PITS = true;
			N_PIT_POINTS = 0.0f;
			for (int i = 0; i < 20; i++)
			{
				loopIteration = i;
				OnWyrmGetPitsLoop();
			}
		}

		if (WYRM_USE_EDGES)
		{
			WYRM_CUR_PIT_IDX = 0.0f;
			WYRM_CUR_PIT = GetArray("ARRAY_PIT_POINTS", Text(WYRM_CUR_PIT_IDX));

			if (WYRM_USE_PITS)
			{
				if (WYRM_MMODE == "WYRM_MMODE")
				{
					WYRM_MMODE = "pits"; // should toggle to edges by default if has both
				}
				WYRM_USE_BOTH = true;
			}
		}

		if (!WYRM_USE_EDGES && !WYRM_USE_PITS)
			WYRM_MMODE = "none";

		DebugPrint("wyrm_finalize");

		if (WYRM_MMODE != "none")
		{
			OnWyrmPickMovementMode("init");
		}
		else
		{
			float xp = ExperienceOf(ENT_ME) * 0.5f;
			SetSkillLevel(xp);
		}
	}

	// wyrm_get_edges_loop
	void OnWyrmGetEdgesLoop()
	{
		if (WYRM_GOT_ALL_EDGE_POINTS)
			return;
		N_EDGE_POINTS += 1.0f;
		string edgeName = WYRM_EDGE_PREFIX + int(N_EDGE_POINTS);
		CBaseEntity@ edgeId = FindByName(edgeName);
		if (Exists(edgeId))
		{
			ArrayAdd("ARRAY_EDGE_POINTS", @edgeId);
			DebugPrint("added edge @ " + Text(OriginOf(edgeId)));
		}
		else
		{
			WYRM_GOT_ALL_EDGE_POINTS = true;
		}
	}

	// wyrm_get_pits_loop
	void OnWyrmGetPitsLoop()
	{
		if (WYRM_GOT_ALL_PIT_POINTS)
			return;
		N_PIT_POINTS += 1.0f;
		string pitName = WYRM_PIT_PREFIX + int(N_PIT_POINTS);
		CBaseEntity@ pitId = FindByName(pitName);
		if (Exists(pitId))
		{
			ArrayAdd("ARRAY_PIT_POINTS", @pitId);
			DebugPrint("added pit @ " + Text(OriginOf(pitId)));
		}
		else
		{
			WYRM_GOT_ALL_PIT_POINTS = true;
		}
	}

	// wyrm_hide
	void OnWyrmHide()
	{
		// note: bugger here, is if someone with fire immunity is in my destin pit, I'm going to be stuck inside him
		// so make sure to use a push burst with override 1 sec before teleport
		OnGlowToggle(0);
		NPCATK_TARGET = "unset";
		WYRM_OLD_TARGET = NPCATK_TARGET;
		WYRM_HIDE_MODE = true;
		WYRM_UNHIDE_TIME = GameTime() + 5.0f;
		SetInvincible(true);
		NPC_FLINCH_DISABLE = true;
		OnNpcatkSuspendMovement(ANIM_HIDDEN);
		if (!SUSPEND_AI)
			OnNpcatkSuspendAi();
		WYRM_MOVEDEST = "unset";
		LAVA_VOLUME = 3;
		CallEventDelayed(0.1f, "loop_lava");
	}

	// wyrm_appear
	// [atk target] [dbg_reason]
	void OnWyrmAppear(string target = "", string reason = "")
	{
		DebugPrint("wyrm_appear " + reason);

		float gameTime = GameTime();

		NEXT_GIVEUP = gameTime + 20.0f;

		// h4x
		WYRM_TELEPORTING = false;
		WYRM_SUBMERGING = false;

		LAVA_VOLUME = 10;
		CallEventDelayed(0.1f, "loop_lava");

		OnGlowToggle(1);

		WYRM_HIDE_MODE = false;
		WYRM_UNHIDE_TIME = gameTime + 5.0f;
		SetInvincible(false);
		NPC_FLINCH_DISABLE = false;
		OnNpcatkResumeMovement();
		OnNpcatkResumeAi();

		OnWyrmAppearFx();

		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);

		PlayAnim("critical", ANIM_APPEAR);

		NEXT_SWIPE_CHECK = gameTime + FREQ_SWIPE;
		NEXT_MODE_SWITCH = gameTime + FREQ_MODE_SWITCH;
		NEXT_PIT_SEARCH = gameTime + FREQ_PIT_SEARCH;

		if (IsAlive(WYRM_OLD_TARGET))
		{
			if (RangeTo(WYRM_OLD_TARGET) < RangeTo(target))
			{
				// old target is closer, use it
				OnNpcatkSettarget(WYRM_OLD_TARGET);
			}
			else
			{
				// target I raised for is closer than my old target, switch
				OnNpcatkSettarget(EntityId(EntityOf(target)));
			}
		}
		else
		{
			// I ain't got no old target, eat this guy
			OnNpcatkSettarget(EntityId(EntityOf(target)));
		}
	}

	// intro_done
	void OnIntroDone()
	{
		INTRO_STAGE = 2;
		if (WYRM_HIDE_MODE) // not sure how we'd wind up hidden mid-intro, but just in case, don't re-enable flinch
			return;
		NPC_FLINCH_DISABLE = false;
	}

	// npc_found_new_target
	void OnNpcFoundNewTarget(string target = "")
	{
		WYRM_COMBAT_INITIATED = true; // this is so we don't pit-teleport to targets before they first find us
	}

	// anger_sated
	void OnAngerSated()
	{
		DebugPrint("anger_sated");
		if (NPCATK_TARGET != "unset")
			return;
		if (WYRM_HIDE_MODE)
			return;
		if (WYRM_TELEPORTING)
			return;
		if (WYRM_MMODE == "edges") // we should just keep going, but don't seem to
			return;
		OnDoSubmerge("1", "anger_sated");
	}

	// wyrm_pick_movement_mode
	// ====================================================================== Attack Cycle - End
	// ====================================================================== Movement selection - Start
	// [dbg_reason]
	void OnWyrmPickMovementMode(string reason = "")
	{
		// toggle movement mode and find nearest to target, if any
		DebugPrint("wyrm_pick_movement_mode was " + WYRM_MMODE + " " + reason);

		if (WYRM_MMODE == "pits")
		{
			if (WYRM_USE_EDGES)
			{
				WYRM_MMODE = "edges";
				OnFindNextEdge();
				WYRM_PORTING_TO = "edge";
				OnWyrmTeleport("switch_modes_to_edge");
			}
		}
		else if (WYRM_USE_PITS)
		{
			WYRM_MMODE = "pits";
			OnFindNextPit(); // teleport is handled here, as pithunter uses this direct
			WYRM_PORTING_TO = "pit";
			OnWyrmTeleport("switch_modes_to_pits");
		}

		DebugPrint("wyrm_pick_movement_mode is " + WYRM_MMODE + " " + reason);
	}

	// find_next_edge
	void OnFindNextEdge()
	{
		int count;

		if (int(WYRM_EDGE_INIT) == 0)
		{
			WYRM_EDGE_INIT += 1.0f;
			T_NEAREST = 9999;
			count = GetArrayCount("ARRAY_EDGE_POINTS"); // pick edge point closest to initial placement
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnFindNearestEdge();
			}
			DebugPrint("nearest edge " + Text(WYRM_NEXT_EDGE_IDX));

			string edgeOrg = GetArray("ARRAY_EDGE_POINTS", Text(WYRM_NEXT_EDGE_IDX));
			edgeOrg = Text(OriginOf(edgeOrg));
			DebugPrint("find_next_edge init");
			SetOrigin(ENT_ME, Vec(edgeOrg));
		}
		else
		{
			WYRM_NEXT_EDGE_IDX += 1.0f;
			if (WYRM_NEXT_EDGE_IDX >= GetArrayCount("ARRAY_EDGE_POINTS") - 1.0f)
			{
				DebugPrint("find_next_edge hit last edge");
				WYRM_NEXT_EDGE_IDX = 0.0f;
			}
		}
	}

	// find_nearest_edge
	void OnFindNearestEdge()
	{
		string curEdge = GetArray("ARRAY_EDGE_POINTS", Text(loopIteration));
		Vector3 curEdgeOrg = OriginOf(curEdge);
		Vector3 myPos = OriginOf(ENT_ME);
		float dist = Distance(myPos, curEdgeOrg);
		DebugPrint("find_nearest_edge # " + loopIteration + " @ " + Text(dist) + " vs " + T_NEAREST);
		if (!(dist < T_NEAREST))
			return;
		WYRM_NEXT_EDGE_IDX = loopIteration;
		T_NEAREST = int(dist);
	}

	// find_next_pit
	// [flee|randomtarg]
	void OnFindNextPit(string mode = "", string pickType = "")
	{
		bool pickRandom = false;
		int count;

		DebugPrint("find_next_pit " + mode);

		if (mode != "flee")
		{
			if (NPCATK_TARGET == "unset")
			{
				DebugPrint("find_next_pit no target, choosing...");
				if (PlayerCount() > 0)
				{
					DebugPrint("find_next_pit getplayers...");
					PIT_TARGET = GetPlayers();
					DebugPrint("find_next_pit sort by range...");
					PIT_TARGET = SortEntities(PIT_TARGET, "range");
					DebugPrint("find_next_pit survived sort by range...");

					if (pickType == "randomtarg")
					{
						DebugPrint("find_next_pit " + pickType + " picking random...");
						PIT_TARGET = GetToken(PIT_TARGET, RandomInt(0, int(GetTokenCount(PIT_TARGET) - 1.0f)));
					}
					else
					{
						DebugPrint("find_next_pit picking nearest...");
						PIT_TARGET = GetToken(PIT_TARGET, 0);
					}

					if (RandomInt(1, 5) == 1 && !WYRM_PITHUNTER)
					{
						pickRandom = true; // every now and again we'll change nonsensically to mysteriously vanish
					}
					DebugPrint("find_next_pit target " + NameOf(PIT_TARGET) + " rnd " + Text(pickRandom) + " typ " + pickType);
				}
				else
				{
					DebugPrint("find_next_pit Ain't no one here,");
					pickRandom = true; // no one's here, pick random
				}
			}
			else
			{
				// I have a target, but may or may not be at the nearest pit
				PIT_TARGET = NPCATK_TARGET;
				if (RandomInt(1, 5) == 1) // every now and again we'll change nonsensically to mysteriously vanish
					pickRandom = true;
				DebugPrint("find_next_pit curtarget " + NameOf(PIT_TARGET) + " rnd " + Text(pickRandom));
			}
		}
		else
		{
			pickRandom = true; // feeing - anywhere but here
		}

		if (pickRandom)
		{
			DebugPrint("find_next_pit picking random...");
			MOVE_TO_PIT_IDX = RandomInt(0, int(GetArrayCount("ARRAY_PIT_POINTS") - 1.0f));
			MOVE_TO_PIT = GetArray("ARRAY_PIT_POINTS", Text(MOVE_TO_PIT_IDX));

			if (MOVE_TO_PIT_IDX == WYRM_CUR_PIT_IDX)
			{
				MOVE_TO_PIT_IDX += 1.0f;
				if (MOVE_TO_PIT_IDX >= GetArrayCount("ARRAY_PIT_POINTS") - 1.0f)
					MOVE_TO_PIT_IDX = 0.0f;
				MOVE_TO_PIT = GetArray("ARRAY_PIT_POINTS", Text(MOVE_TO_PIT_IDX));
			}
			WYRM_CUR_PIT_IDX = MOVE_TO_PIT_IDX;

			DebugPrint("find_next_pit random " + Text(WYRM_CUR_PIT_IDX) + " [ " + MOVE_TO_PIT + " ]");
		}
		else
		{
			// find pit closest to selected pit target
			T_LEAST_DIST = 9999;
			count = GetArrayCount("ARRAY_PIT_POINTS");
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnFindPitNearestTarget();
			}
			DebugPrint("find_next_pit nearest2targ to " + NameOf(PIT_TARGET) + " " + Text(OriginOf(PIT_TARGET)) + " " + Text(MOVE_TO_PIT_IDX) + " [ " + MOVE_TO_PIT + " ]");
		}
	}

	// find_pit_nearest_target
	void OnFindPitNearestTarget()
	{
		string curPit = GetArray("ARRAY_PIT_POINTS", Text(loopIteration));
		Vector3 cutPitOrg = OriginOf(curPit);
		Vector3 pitTargOrg = OriginOf(PIT_TARGET);
		float pitDistFromTarg = Distance(cutPitOrg, pitTargOrg);
		DebugPrint("find_pit_nearest_target # " + loopIteration + " dist " + Text(pitDistFromTarg));
		if (!(pitDistFromTarg < T_LEAST_DIST))
			return;
		T_LEAST_DIST = int(pitDistFromTarg);
		MOVE_TO_PIT_IDX = loopIteration;
		MOVE_TO_PIT = GetArray("ARRAY_PIT_POINTS", Text(MOVE_TO_PIT_IDX));
	}

	// wyrm_teleport
	// [dbg_reason] three steps: retract, repel targets at dest, if edge dest appear
	void OnWyrmTeleport(string reason = "")
	{
		// this animation calls wyrm_teleport2 on completion
		DebugPrint("wyrm_teleport " + reason);
		WYRM_TELEPORTING = true;
		WYRM_TELE_STAGE2 = true;
		if (!WYRM_HIDE_MODE)
			OnDoSubmerge("0", "teleporting");
		else
			OnWyrmTeleport2();
	}

	// wyrm_teleport2
	// called by ANIM_RETRACT or failsafe
	void OnWyrmTeleport2()
	{
		int count;
		// create a burst at MOVE_TO_PIT org and move there
		if (!WYRM_TELE_STAGE2)
			return;
		WYRM_TELE_STAGE2 = false;
		DebugPrint("wyrm_teleport2 " + Text(WYRM_TELEPORTING) + " " + WYRM_PORTING_TO);
		float width = WidthOf(ENT_ME) * 1.5f;
		DebugPrint("wyrm_teleport2 width " + Text(width));
		if (WYRM_PORTING_TO == "pit")
			REPELL_POS = OriginOf(MOVE_TO_PIT);
		if (WYRM_PORTING_TO == "edge")
		{
			string edgeOrg = GetArray("ARRAY_EDGE_POINTS", Text(WYRM_NEXT_EDGE_IDX));
			REPELL_POS = OriginOf(edgeOrg);
		}
		DebugPrint("wyrm_teleport2 repellpos " + Text(REPELL_POS));
		REPELL_POS.z += 32.0f;
		T_SPHERE = LegacyFunction("get_tsphere", "any", width, REPELL_POS);
		if (T_SPHERE != "none")
		{
			count = GetTokenCount(T_SPHERE);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnPitrepellAffectTargets();
			}
		}
		DebugPrint("wyrm_teleport2 nextstage...");
		CallEventDelayed(0.5f, "wyrm_teleport3");
	}

	// pitrepell_affect_targets
	// repells targets from pit teleport loc
	void OnPitrepellAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(T_SPHERE, loopIteration));
		Vector3 targOrg = OriginOf(curTarg);
		Vector3 myOrg = OriginOf(Text(REPELL_POS));
		float repelYaw = AnglesTo(myOrg, targOrg);
		SetVelocity(curTarg, RelativeVelocity(Vector3(0, repelYaw, 0), Vector3(200, 1000, 200)), "override");
	}

	// wyrm_teleport3
	void OnWyrmTeleport3()
	{
		string target = "L_TARGET";

		DebugPrint("wyrm_teleport3 " + WYRM_PORTING_TO);

		WYRM_TELEPORTING = false;
		if (WYRM_PORTING_TO == "pit")
		{
			SetOrigin(ENT_ME, OriginOf(MOVE_TO_PIT));
			WYRM_CUR_PIT = MOVE_TO_PIT;
			WYRM_CUR_PIT_IDX = MOVE_TO_PIT_IDX;
			if (WYRM_PITHUNTER) // otherwise stays hidden until target spotted
			{
				TARGET_LIST = GetPlayers();
				target = SortEntities(TARGET_LIST, "range");
				target = GetToken(target, 0);
				OnWyrmAppear(target, "teleport2pit");
			}
		}
		if (WYRM_PORTING_TO == "edge")
		{
			string edgeOrg = GetArray("ARRAY_EDGE_POINTS", Text(WYRM_NEXT_EDGE_IDX));
			edgeOrg = Text(OriginOf(edgeOrg));
			DebugPrint("wyrm_teleport3 " + WYRM_PORTING_TO + " " + Text(WYRM_NEXT_EDGE_IDX) + " " + edgeOrg);
			SetOrigin(ENT_ME, Vec(edgeOrg));
			// set nearest player as target and appear
			TARGET_LIST = GetPlayers();
			target = SortEntities(TARGET_LIST, "range");
			target = GetToken(target, 0);
			OnWyrmAppear(target, "teleport2edge");
		}
	}

	// frame_spit_start
	// ====================================================================== Movement selection - End
	// ====================================================================== Frame events
	// ANIM_SPIT anim_spit
	void OnFrameSpitStart()
	{
		PlaySound(1, 10, SOUND_SPIT_PREP);
		PlaySound(2, 10, "monsters/wyrm/8bit/c_x0stgwar_hit2.wav", 0.8f, RandomInt(80, 110));
	}

	// frame_spit_strike
	// ANIM_SPIT anim_spit
	void OnFrameSpitStrike()
	{
		if (!IsAlive(NPCATK_TARGET)) // case he died/invalidated between frames
			return;
		PlaySound(0, 10, SOUND_SPIT_STRIKE);
		Vector3 targOrg = OriginOf(NPCATK_TARGET);
		targOrg.z = GroundHeight(targOrg);
		if (RandomInt(1, 2) == 1) // guided, sometimes
			PROJ_TARGET = NPCATK_TARGET;
		else
			PROJ_TARGET = "unset";

		TossProjectile(PROJ_SCRIPT, AttachmentPositionOf(ENT_ME, ATT_MOUTH), targOrg, PROJ_SPEED, PROJ_DMG, PROJ_COF, "none");
	}

	// frame_blong_start
	void OnFrameBlongStart()
	{
		if (!DO_QUAKE)
			PlayRandomSound(0, 10, SOUND_ALERT1, SOUND_ALERT2);
		else
			PlaySound(0, 10, "monsters/wyrm/quake_rawr.wav");

		if (!DO_QUAKE)
			return;
		// clientevent new all drip flames from mouth and add another glow
		OnStartQuake();
	}

	// frame_blong_end
	// ANIM_RAWR anim_blong
	void OnFrameBlongEnd()
	{
		if (INTRO_STAGE < 2)
		{
			// this prevents this anim from attacking until intro complete
			OnIntroDone();
			return;
		}
	}

	// frame_hbutt_start
	// ANIM_HEADBUTT anim_hbutt
	void OnFrameHbuttStart()
	{
		PlaySound(0, 10, SOUND_HBUTT);
	}

	// frame_hbutt_strike
	// ANIM_HEADBUTT anim_hbutt
	void OnFrameHbuttStrike()
	{
		ANIM_ATTACK = ANIM_BITE1;
		DID_BITE = 0.0f;

		PlaySound(0, 10, SOUND_SWIPE_LARGE);
		float yaw = AnglesOf(ENT_ME).y;
		Vector3 burstPos = OriginOf(ENT_ME);
		burstPos += RelativePosition(Vector3(0, yaw, 0), Vector3(0, AOE_HBUTT * 0.95f, 0));
		burstPos.z = OriginOf(NPCATK_TARGET).z;
		burstPos.z += 32.0f; // rough terrain adj
		DoDamageEx(burstPos, AOE_HBUTT, DMG_HBUTT, 0.1f, ENT_ME, ENT_ME, "none", "blunt_effect", "dmgevent:hbutt");
		DebugPrint("frame_hbutt_strike yaw " + Text(yaw) + " org " + Text(burstPos));
	}

	// frame_swipe_start
	// ANIM_SWIPE anim_swipe
	void OnFrameSwipeStart()
	{
		PlaySound(0, 10, SOUND_SWIPE);
	}

	// frame_swipe_strike
	// ANIM_SWIPE anim_swipe
	void OnFrameSwipeStrike()
	{
		ANIM_ATTACK = ANIM_BITE2;
		DID_BITE = 0.0f;

		PlaySound(0, 10, SOUND_SWIPE_LARGE);
		float yaw = AnglesOf(ENT_ME).y;
		Vector3 burstPos = OriginOf(ENT_ME);
		burstPos += RelativePosition(Vector3(0, yaw, 0), Vector3(0, AOE_SWIPE * 0.5f, 0));
		burstPos.z = OriginOf(NPCATK_TARGET).z;
		burstPos.z += 32.0f; // rough terrain adj
		DoDamageEx(burstPos, AOE_SWIPE, DMG_SWIPE, 0.1f, ENT_ME, ENT_ME, "none", "blunt_effect", "dmgevent:bigswipe");
		DebugPrint("frame_swipe_strike yaw " + Text(yaw) + " org " + Text(burstPos));
	}

	// frame_retract_start
	// ANIM_RETRACT anim_retract
	void OnFrameRetractStart()
	{
		PlaySound(0, 10, SOUND_SPLASH_DOWN);
	}

	// submerge_failsafe
	// in case we don't get the last frame
	void OnSubmergeFailsafe()
	{
		if (WYRM_SUBMERGE_GOT_ENDFRAME)
			return;
		DebugPrint("submerge_failsafe !");
		OnFrameRetractEnd();
	}

	// frame_retract_end
	// ANIM_RETRACT anim_retract
	void OnFrameRetractEnd()
	{
		DebugPrint("frame_retract_end notep " + WYRM_NO_TELEPORT_FLAG);

		WYRM_SUBMERGE_GOT_ENDFRAME = true;
		WYRM_SUBMERGING = false;
		OnWyrmHide();
		if (Truthy(WYRM_NO_TELEPORT_FLAG))
		{
			WYRM_NO_TELEPORT_FLAG = "0";
			return;
		}
		OnWyrmTeleport2();
	}

	// frame_bite1_start
	void OnFrameBite1Start()
	{
		PlaySound(0, 10, SOUND_BITE);
	}

	// frame_bite2_start
	void OnFrameBite2Start()
	{
		PlaySound(0, 10, SOUND_BITE);
	}

	// frame_bite1_strike
	// ANIM_BITE1 anim_bite1
	void OnFrameBite1Strike()
	{
		float yaw = AnglesOf(ENT_ME).y;
		Vector3 burstPos = OriginOf(ENT_ME);
		burstPos += RelativePosition(Vector3(0, yaw, 0), Vector3(0, AOE_HBUTT * 0.95f, 0)); // bite & hbutt have same AOE
		burstPos.z = OriginOf(NPCATK_TARGET).z;
		burstPos.z += 32.0f; // rough terrain adj
		DoDamageEx(burstPos, AOE_HBUTT, DMG_BITE, 0.1f, ENT_ME, ENT_ME, "none", "pierce", "dmgevent:bite1");
		OnSelectMelee();
	}

	// frame_bite2_strike
	// ANIM_BITE2 anim_bite2
	void OnFrameBite2Strike()
	{
		float yaw = AnglesOf(ENT_ME).y;
		Vector3 burstPos = OriginOf(ENT_ME);
		burstPos += RelativePosition(Vector3(0, yaw, 0), Vector3(0, AOE_HBUTT * 0.95f, 0)); // bite & hbutt have same AOE
		burstPos.z = OriginOf(NPCATK_TARGET).z;
		burstPos.z += 32.0f; // rough terrain adj
		DoDamageEx(burstPos, AOE_HBUTT, DMG_BITE, 0.1f, ENT_ME, ENT_ME, "none", "pierce", "dmgevent:bite2");
		OnSelectMelee();
	}

	// select_melee
	// after every 4-5th standard bite we will do a swipe or headbutt
	void OnSelectMelee()
	{
		DID_BITE += 1.0f;
		if (DID_BITE > RandomInt(3, 4))
		{
			if (RandomInt(1, 3) == 1)
				ANIM_ATTACK = ANIM_SWIPE;
			else
				ANIM_ATTACK = "ANIM_HBUTT";
		}
	}

	// frame_appear_start
	// ANIM_APPEAR anim_appear
	void OnFrameAppearStart()
	{
		PlaySound(0, 10, SOUND_SPLASH_UP);
	}

	// hbutt_dodamage
	// ====================================================================== Outgoing Damage events
	// from frame_hbutt_strike, toss and stun
	void OnHbuttDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		// the "headbutt" animation is actually a sideways sweeping motion
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;

		// we should probably do extra damage to push immune here
		// not sure if dmgevent also calls _damaged_other - testing below
		AddVelocity(target, RelativeVelocity(Vector3(400, 0, 300)));
		ApplyEffect(target, "effects/debuff_stun", 5.0f, self);
	}

	// bite1_dodamage
	// from frame_bite1_strike, nudge slightly
	void OnBite1Dodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		AddVelocity(target, RelativeVelocity(Vector3(100, 0, 200)));
	}

	// bite2_dodamage
	// from frame_bite2_strike, nudge slightly
	void OnBite2Dodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		AddVelocity(target, RelativeVelocity(Vector3(-100, 0, 200)));
	}

	// hbutt_damaged_other
	// test
	void OnHbuttDamagedOther(string target = "")
	{
		DebugPrint("hbutt_damaged_other " + NameOf(target));
	}

	// bigswipe_dodamage
	// from frame_swipe_strike, larger AOE, toss far
	void OnBigswipeDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		// this is a large sweeping curl repelling nearby targets
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;

		// we should probably do extra damage to push immune here
		// not sure if dmgevent also calls _damaged_other - testing below
		Vector3 targOrg = OriginOf(target);
		Vector3 myOrg = OriginOf(ENT_ME);
		float repelYaw = AnglesTo(myOrg, targOrg);
		SetVelocity(target, RelativeVelocity(Vector3(0, repelYaw, 0), Vector3(-800, 1000, 200)));
	}

	// swipe_damaged_other
	void OnSwipeDamagedOther(string target = "")
	{
		DebugPrint("swipe_damaged_other " + NameOf(target));
	}

	// ext_fire_bomb
	// <land point> - called by proj_fire_bomb
	void OnExtFireBomb(Vector3 landPosition = Vector3())
	{
		DebugPrint("ext_fire_bomb " + Text(landPosition));
		FIRE_BOMB_POS = landPosition;
		DoDamageEx(FIRE_BOMB_POS, 128, "DMG_PROJ_RAPID", 0.1f, ENT_ME, ENT_ME, "none", "blunt_effect", "dmgevent:spit");
	}

	// spit_dodamage
	void OnSpitDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		Vector3 targOrg = Vec("L_TARG_ORG");
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;

		if (IsPlayer(target) && !IsOnGround(target))
			return;

		OnApplyDot1(target);

		targOrg = OriginOf(Text(targOrg));
		Vector3 myOrg = FIRE_BOMB_POS;
		float repelYaw = AnglesTo(myOrg, targOrg);
		AddVelocity(target, RelativeVelocity(Vector3(0, repelYaw, 0), Vector3(0, 500, 100)));
	}

	// apply_dot1
	void OnApplyDot1(CBaseEntity@ target = null)
	{
		if (HasEffect(target, DOT_EFFECTNAME)) // idear: one could tweak this to upgrade frostbite to freeze
			return;
		ApplyEffect(target, DOT_SCRIPT, DOT_DUR, self, DOT_DMG);
	}

	// apply_dot2
	void OnApplyDot2(CBaseEntity@ target = null)
	{
		if (HasEffect(target, DOT_EFFECTNAME2))
			return;
		ApplyEffect(target, DOT_SCRIPT2, DOT_DUR2, self, DOT_DMG2);
	}

	// frock_dodamage
	void OnFrockDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		OnApplyDot1(target);
		DebugPrint("frock_dodamage " + NameOf(target));
	}

	// wyrm_appear_fx
	// ====================================================================== Type Specific
	void OnWyrmAppearFx()
	{
		if (WYRM_TYPE == "fire")
		{
			ClientEvent("new", "all", "effects/sfx_sprite", OriginOf(ENT_ME), "xfire.spr", "0;5.0;100;add;(255,255,255);20;20", "once");

			LegacyCommand("bleed", ENT_ME, "yellow", RandomInt(100, 10000));
			LegacyCommand("bleed", ENT_ME, "yellow", RandomInt(100, 10000));
			LegacyCommand("bleed", ENT_ME, "yellow", RandomInt(100, 10000));
			LegacyCommand("bleed", ENT_ME, "yellow", RandomInt(100, 10000));
			LegacyCommand("bleed", ENT_ME, "yellow", RandomInt(100, 10000));
			LegacyCommand("bleed", ENT_ME, "yellow", RandomInt(100, 10000));
		}

		PlayRandomSound(0, 10, SOUND_ALERT1, SOUND_ALERT2);
	}

	// loop_lava
	// <vol>
	void OnLoopLava()
	{
		ServerPlaySound(3, 0, SOUND_LAVA_LOOP);
		CallEventDelayed(0.1f, "loop_lava_act");

		NEXT_LOOP_LAVA = GameTime() + RandomInt(20, 75);
	}

	// loop_lava_act
	void OnLoopLavaAct()
	{
		ServerPlaySound(3, LAVA_VOLUME, SOUND_LAVA_LOOP);
	}

	// start_quake
	// activated by ANIM_RAWR during fireball pauses
	void OnStartQuake()
	{
		Effect("glow", ENT_ME, Vector3(255, 128, 64), 128, DUR_QUAKE, DUR_QUAKE);
		DO_QUAKE = false;
		TARGET_LIST = GetPlayers();
		int count = GetTokenCount(TARGET_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnQuakeFilterRange();
		}
		DebugPrint("start_quake targetlist " + TARGET_LIST);
		count = GetTokenCount(TARGET_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnQuakeApply();
		}
	}

	// quake_filter_range
	void OnQuakeFilterRange()
	{
		string curPlr = GetToken(TARGET_LIST, loopIteration);
		Vector3 plrOrg = OriginOf(curPlr);
		Vector3 myOrg = OriginOf(ENT_ME);
		if (!(Distance(myOrg, plrOrg) > 1024.0f))
			return;
		TARGET_LIST = TokenSet(TARGET_LIST, loopIteration, "0");
	}

	// quake_apply
	void OnQuakeApply()
	{
		string curPlr = GetToken(TARGET_LIST, loopIteration);
		if (curPlr == "0")
			return;
		DebugPrint("quake_apply " + NameOf(curPlr));
		CallExternal(curPlr, "ext_quake_fx_volc", DUR_QUAKE, IndexOf(ENT_ME));
	}

	// ext_frock_hit
	// flaming rock from volcanic quake
	// <plr_index>, from effects/sfx_quake->player/externals->ext_cl_callback
	void OnExtFrockHit(string playerIndex = "")
	{
		CBaseEntity@ plr = EntityOf(playerIndex);
		DebugPrint("ext_frock_hit " + playerIndex + " " + NameOf(plr));
		DoDamageEx(@plr, "direct", DMG_FROCK, "100%", ENT_ME, ENT_ME, "none", "blunt_effect", "dmgevent:frock");
	}

	// glow_toggle
	// ====================================================================== Other and Debug
	// 0|1
	void OnGlowToggle(int flag = 0)
	{
		if (flag != 0)
		{
			if (WYRM_LIGHT_CLIDX != "WYRM_LIGHT_CLIDX")
				ClientEvent("update", "all", WYRM_LIGHT_CLIDX, "remove_light");
			ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), WYRM_GLOW_COLOR, 32, 30.0f);
			WYRM_LIGHT_CLIDX = LastClientScriptId();
			NEXT_LIGHT_REFRESH = GameTime() + 30.0f;
			WYRM_LIGHT_ACTIVE = true;
		}
		else if (WYRM_LIGHT_CLIDX != "WYRM_LIGHT_CLIDX")
		{
			ClientEvent("update", "all", WYRM_LIGHT_CLIDX, "remove_light");
			WYRM_LIGHT_CLIDX = "WYRM_LIGHT_CLIDX";
			WYRM_LIGHT_ACTIVE = false;
		}
	}

	// mmode_switch
	// debuggary
	void OnMmodeSwitch()
	{
		NEXT_MODE_SWITCH = 0.0f;
	}

	// do_flee
	void OnDoFlee()
	{
		NPCATK_TARGET = "unset";
		if (!SUSPEND_AI)
			OnNpcatkSuspendAi();

		DebugPrint("do_flee " + WYRM_MMODE);

		// if I have both available, my flee method is to change movement modes
		if (WYRM_USE_BOTH)
		{
			NEXT_MODE_SWITCH = FREQ_MODE_SWITCH + GameTime();
			OnWyrmPickMovementMode("flee");
			return;
		}

		if (WYRM_MMODE == "pits")
		{
			PlayAnim("break");
			WYRM_PORTING_TO = "pit";
			OnFindNextPit("flee");
			OnWyrmTeleport("pitflee");
		}

		if (WYRM_MMODE == "edges")
		{
			WYRM_NEXT_EDGE_IDX = RandomInt(0, int(GetArrayCount("ARRAY_EDGE_POINTS") - 1.0f)); // prob should find furthest instead, but I'm getting sick of this thing's BS
			WYRM_PORTING_TO = "edge";
			OnDoSubmerge("0", "flee");
		}
	}

	// set_mmode
	// ====================================================================== Additional Parameters
	// external/addparam: <pits|edges|none>
	void OnSetMmode(string moveMode = "")
	{
		bool paramCorrect = false;
		if (moveMode.isEmpty())
			return;
		DebugPrint("set_mmode " + moveMode);
		WYRM_MMODE = moveMode;
		if (WYRM_MMODE == "pits")
		{
			paramCorrect = true;
			OnFindNextPit();
		}
		if (WYRM_MMODE == "edges")
		{
			paramCorrect = true;
			OnFindNextEdge();
		}
		if (WYRM_MMODE == "none")
		{
			paramCorrect = true;
			if (NPC_HOME_LOC != "NPC_HOME_LOC")
				SetOrigin(ENT_ME, Vec(NPC_HOME_LOC));
		}
		CallEventDelayed(0.1f, "wyrm_hide");

		DebugPrint("set_mmode " + WYRM_MMODE);

		if (paramCorrect)
			return;
		string outsg = ItemNameOf(ENT_ME) + ": addparam set_mmode - must be pits, edges, or none";
		InfoMessage("all", "MAP ERROR", outsg);
		ChatLog(Timestamp() + " MAP ERROR: " + outsg);
	}

	// set_noquakes
	// dont cause earthquakes
	void OnSetNoquakes()
	{
		NO_QUAKES = true;
	}

	// set_pithunt
	// set to hunt pits actively, flee whenever lose %25 health
	void OnSetPithunt()
	{
		WYRM_PITHUNTER = true;
	}

	// set_endpithunt
	void OnSetEndpithunt()
	{
		WYRM_PITHUNTER = false;
	}

	// set_edge_prefix
	void OnSetEdgePrefix(string prefix = "")
	{
		if (prefix.isEmpty())
			return;
		WYRM_EDGE_PREFIX = prefix;
	}

	// set_pit_prefix
	void OnSetPitPrefix(string prefix = "")
	{
		if (prefix.isEmpty())
			return;
		WYRM_PIT_PREFIX = prefix;
	}

	// do_submerge
	// <1=no teleport> [dbg_reason]
	void OnDoSubmerge(string noTeleport = "", string reason = "")
	{
		DebugPrint("do_submerge " + noTeleport + " " + reason);

		WYRM_SUBMERGING = true;
		WYRM_SUBMERGE_GOT_ENDFRAME = false;
		NPC_FLINCH_DISABLE = true;
		WYRM_NO_TELEPORT_FLAG = noTeleport;
		SetInvincible(true);
		if (WYRM_HIDE_MODE)
			return;
		NPCATK_TARGET = "unset";
		if (!SUSPEND_AI)
			OnNpcatkSuspendAi();
		PlayAnim("critical", ANIM_RETRACT);
		CallEventDelayed(3.0f, "submerge_failsafe");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseStruck_OnGameSpawn(playerRace, playerGender); // monsters/base_struck
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("ambient/animals/rattle_long.wav");
		Precache("monsters/wyrm/idle1.wav");
		Precache("monsters/wyrm/idle2.wav");
		Precache("monsters/wyrm/idle3.wav");
		Precache("monsters/wyrm/idle4.wav");
		Precache("amb/lava_loop.wav");
		Precache("xfire.spr");
		Precache("rockgibs.mdl");
		Precache("xfireball3.spr");
		Precache("monsters/wyrms_medium.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		WyrmFire_FirstThink();
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
		if (name == "anger_sated") { OnAngerSated(); return true; }
		if (name == "apply_dot1") { OnApplyDot1(EntityParam(params, 0)); return true; }
		if (name == "apply_dot2") { OnApplyDot2(EntityParam(params, 0)); return true; }
		if (name == "bigswipe_dodamage") { OnBigswipeDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "bite1_dodamage") { OnBite1Dodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "bite2_dodamage") { OnBite2Dodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "bs_global_command") { OnBsGlobalCommand(PlayerParam(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "do_flee") { OnDoFlee(); return true; }
		if (name == "do_submerge") { OnDoSubmerge(Param(params, 0), Param(params, 1)); return true; }
		if (name == "ext_fire_bomb") { OnExtFireBomb(Vec(Param(params, 0))); return true; }
		if (name == "ext_frock_hit") { OnExtFrockHit(Param(params, 0)); return true; }
		if (name == "fake_precache") { OnFakePrecache(); return true; }
		if (name == "find_nearest_edge") { OnFindNearestEdge(); return true; }
		if (name == "find_next_edge") { OnFindNextEdge(); return true; }
		if (name == "find_next_pit") { OnFindNextPit(Param(params, 0), Param(params, 1)); return true; }
		if (name == "find_pit_nearest_target") { OnFindPitNearestTarget(); return true; }
		if (name == "frame_appear_start") { OnFrameAppearStart(); return true; }
		if (name == "frame_bite1_start") { OnFrameBite1Start(); return true; }
		if (name == "frame_bite1_strike") { OnFrameBite1Strike(); return true; }
		if (name == "frame_bite2_start") { OnFrameBite2Start(); return true; }
		if (name == "frame_bite2_strike") { OnFrameBite2Strike(); return true; }
		if (name == "frame_blong_end") { OnFrameBlongEnd(); return true; }
		if (name == "frame_blong_start") { OnFrameBlongStart(); return true; }
		if (name == "frame_hbutt_start") { OnFrameHbuttStart(); return true; }
		if (name == "frame_hbutt_strike") { OnFrameHbuttStrike(); return true; }
		if (name == "frame_retract_end") { OnFrameRetractEnd(); return true; }
		if (name == "frame_retract_start") { OnFrameRetractStart(); return true; }
		if (name == "frame_spit_start") { OnFrameSpitStart(); return true; }
		if (name == "frame_spit_strike") { OnFrameSpitStrike(); return true; }
		if (name == "frame_swipe_start") { OnFrameSwipeStart(); return true; }
		if (name == "frame_swipe_strike") { OnFrameSwipeStrike(); return true; }
		if (name == "frock_dodamage") { OnFrockDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "glow_toggle") { OnGlowToggle(Int(Param(params, 0))); return true; }
		if (name == "hbutt_damaged_other") { OnHbuttDamagedOther(Param(params, 0)); return true; }
		if (name == "hbutt_dodamage") { OnHbuttDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "intro_done") { OnIntroDone(); return true; }
		if (name == "loop_lava") { OnLoopLava(); return true; }
		if (name == "loop_lava_act") { OnLoopLavaAct(); return true; }
		if (name == "mmode_switch") { OnMmodeSwitch(); return true; }
		if (name == "npc_found_new_target") { OnNpcFoundNewTarget(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npc_targetvalidate") { OnNpcTargetvalidate(EntityParam(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "pitrepell_affect_targets") { OnPitrepellAffectTargets(); return true; }
		if (name == "quake_apply") { OnQuakeApply(); return true; }
		if (name == "quake_filter_range") { OnQuakeFilterRange(); return true; }
		if (name == "select_melee") { OnSelectMelee(); return true; }
		if (name == "set_edge_prefix") { OnSetEdgePrefix(Param(params, 0)); return true; }
		if (name == "set_endpithunt") { OnSetEndpithunt(); return true; }
		if (name == "set_mmode") { OnSetMmode(Param(params, 0)); return true; }
		if (name == "set_noquakes") { OnSetNoquakes(); return true; }
		if (name == "set_pit_prefix") { OnSetPitPrefix(Param(params, 0)); return true; }
		if (name == "set_pithunt") { OnSetPithunt(); return true; }
		if (name == "spit_dodamage") { OnSpitDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "start_quake") { OnStartQuake(); return true; }
		if (name == "submerge_failsafe") { OnSubmergeFailsafe(); return true; }
		if (name == "swipe_damaged_other") { OnSwipeDamagedOther(Param(params, 0)); return true; }
		if (name == "wyrm_appear") { OnWyrmAppear(Param(params, 0), Param(params, 1)); return true; }
		if (name == "wyrm_appear_fx") { OnWyrmAppearFx(); return true; }
		if (name == "wyrm_finalize") { OnWyrmFinalize(); return true; }
		if (name == "wyrm_get_edges_loop") { OnWyrmGetEdgesLoop(); return true; }
		if (name == "wyrm_get_pits_loop") { OnWyrmGetPitsLoop(); return true; }
		if (name == "wyrm_hide") { OnWyrmHide(); return true; }
		if (name == "wyrm_pick_movement_mode") { OnWyrmPickMovementMode(Param(params, 0)); return true; }
		if (name == "wyrm_spawn") { OnWyrmSpawn(); return true; }
		if (name == "wyrm_teleport") { OnWyrmTeleport(Param(params, 0)); return true; }
		if (name == "wyrm_teleport2") { OnWyrmTeleport2(); return true; }
		if (name == "wyrm_teleport3") { OnWyrmTeleport3(); return true; }
		return BaseStruck_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
