#pragma context server

// Converted from monsters/dwarf_bomber.script by msc_transpiler.
// Mad Bomber - runs around, throws bombs, ends in suicide attack
// - can hurt himself with his own bombs

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_struck.as"
#include "converted/NPCs/dwarf_lantern_base.as"

[script "monsters/dwarf_bomber"]
class DwarfBomber : BaseMonsterNewScript, BaseStruck, DwarfLanternBase
{
	// Constants
	string ANIM_RELOAD_R = "anim_draw_r";
	string ANIM_RELOAD_L = "anim_draw_l";
	string ANIM_THROW_R = "anim_throw_r";
	string ANIM_THROW_L = "anim_throw_l";
	string ANIM_EXPLODE = "anim_explode";
	string ANIM_JUMP = "anim_jump_back";
	string ANIM_DODGE = "anim_roll_back";
	float FREQ_LEAP_FORWARD = 0.0f;
	float FREQ_DODGE = 0.0f;
	string ANIM_ALERT = "nod";
	string MODEL_TNT = "monsters/dwarf_bomber_tnt.mdl";
	string PROJ_SCRIPT = "monsters/summon/tnt_bomb";
	string CL_SCRIPT = "monsters/dwarf_bomber_cl";
	float FREQ_CL_UPDATE = 15.0f;
	float FREQ_BOMB_DRAW = 5.0f;
	bool HR_CHAN = true;
	int HL_CHAN = 3;
	float FREQ_RBOMB_BEAM = 5.0f;
	float FREQ_LBOMB_BEAM = 5.0f;
	int DMG_SUICIDE = 300;
	string SOUND_FUSE_LOOP = "monsters/dwarf_bomber/fuse_loop.wav";
	string SOUND_FUSE_LIGHT = "monsters/dwarf_bomber/fuse_lit.wav";
	string SOUND_YELP = "monsters/dwarf_bomber/db_yelp.wav";
	string SOUND_GIGGLE1 = "monsters/dwarf_bomber/db_giggle1.wav";
	string SOUND_GIGGLE2 = "monsters/dwarf_bomber/db_giggle2.wav";
	string SOUND_GIGGLE3 = "monsters/dwarf_bomber/db_giggle3.wav";
	string SOUND_GIGGLE4 = "monsters/dwarf_bomber/db_giggle4.wav";
	string SOUND_GIGGLE5 = "monsters/dwarf_bomber/db_giggle5.wav";
	string SOUND_EXPLODE = "weapons/explode3.wav";
	string SOUND_GLOAT = "monsters/dwarf_bomber/db_gloat.wav";
	string SOUND_ALERT = "monsters/dwarf_bomber/db_alert1.wav";
	string SOUND_SUICIDE = "monsters/dwarf_bomber/db_suicide.wav";
	string SOUND_IDLE1 = "monsters/dwarf_bomber/db_idle1.wav";
	string SOUND_IDLE2 = "monsters/dwarf_bomber/db_idle2.wav";
	string SOUND_IDLE3 = "monsters/dwarf_bomber/db_idle3.wav";
	string SOUND_PAIN1 = "monsters/dwarf_bomber/db_pain1.wav";
	string SOUND_PAIN2 = "monsters/dwarf_bomber/db_pain2.wav";
	string SOUND_PAIN3 = "monsters/dwarf_bomber/db_pain3.wav";
	string SOUND_FLINCH1 = "monsters/dwarf_bomber/db_flinch1.wav";
	string SOUND_FLINCH2 = "monsters/dwarf_bomber/db_flinch2.wav";
	string SOUND_FLINCH3 = "monsters/dwarf_bomber/db_flinch3.wav";
	string ANIM_FLINCH = "anim_xbow_flinch";
	string NPC_MATERIAL_TYPE = "flesh";
	bool NPC_USE_PAIN = true;
	bool NPC_USE_IDLE = true;
	bool NPC_USE_FLINCH = true;

	// Variables (an unset .script variable reads as its own name)
	string CL_SCRIPT_IDX = "CL_SCRIPT_IDX";
	bool HR_ACTIVE = false;
	bool HL_ACTIVE = false;
	bool HR_ATTACH_IDX = false;
	int HL_ATTACH_IDX = 0;
	float NEXT_RBOMB_BEAM = 0.0f;
	float NEXT_LBOMB_BEAM = 0.0f;
	Vector3 VEC_ENGLISH = Vector3();
	int DMG_BOMB = 0;
	string ANIM_ATTACK = "ANIM_ATTACK";
	int DID_INTRO = 0;
	float NPC_NEXT_FLINCH = 0.0f;
	float NEXT_ALERT = 0.0f;
	float NEXT_BOMB_DRAW = 0.0f;
	float NEXT_LEAP_FORWARD = 0.0f;
	int ROLL_DIR = 0;
	float NEXT_DODGE = 0.0f;
	float NEXT_CL_UPDATE = 0.0f;
	bool DID_FAKE_DEATH = false;
	bool DROP_TNT = false;
	bool DID_FSUICIDE = false;

	// Variables declared by included files, with the value they start with in this script
	DwarfBomber()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle";
		ANIM_DEATH = "none";
	}

	// unnamed block (first think)
	void DwarfBomber_FirstThink()
	{
		CL_SCRIPT_IDX = "-1";

		HR_ACTIVE = false;
		HL_ACTIVE = false;
		HR_ATTACH_IDX = true; // for beams, think index from one
		HL_ATTACH_IDX = 2;
		NEXT_RBOMB_BEAM = 0.0f;
		NEXT_LBOMB_BEAM = 0.0f;

		VEC_ENGLISH = Vector3(0, 0, 0); // adds to this vector after each throw, resets on hit

		DMG_BOMB = 100; // captured by projectile

		// base ai
		NPC_GIVE_EXP = 300.0f;
		NPC_RANGED = "1";
		ATTACK_RANGE = 640.0f;
		ATTACK_HITRANGE = 640.0f;
		ATTACK_MOVERANGE = 512.0f;
		ANIM_ATTACK = "frame_release_r";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle";
		ANIM_DEATH = "none"; // custom
		BASE_MOVESPEED = 2.0f;
		SetMoveSpeed(BASE_MOVESPEED);
		SetAnimMoveSpeed(BASE_MOVESPEED);
	}

	// game_precache
	void DwarfBomber_OnGamePrecache()
	{
		PrecacheFile(CL_SCRIPT);
		PrecacheFile(PROJ_SCRIPT);
		ServerPlaySound(0, 0, "monsters/dwarf_bomber/fuse_loop.wav");
	}

	// game_precache
	void OnGamePrecache()
	{
		DwarfBomber_OnGamePrecache();
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

		if (DID_FAKE_DEATH)
			return;
		DID_FAKE_DEATH = true;
		PlaySound(2, 10, SOUND_SUICIDE);

		SetDamageTaken("cold", 0);

		// reinit clfx
		ClientEvent("update", "all", CL_SCRIPT_IDX, "end_fx");
		CL_SCRIPT_IDX = "-1";
		OnUpdateClScript();

		ClearEffects();
		SetAlive(true);
		SetInvincible(true);
		SetHealth(1);
		OnNpcatkSuspendMovement(ANIM_EXPLODE);
		OnNpcatkSuspendAi();
		PlayAnim("critical", ANIM_EXPLODE);

		CallEventDelayed(20.0f, "remove_me"); // in case something goes horribly wrong
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseStruck_OnGameSpawn(playerRace, playerGender); // monsters/base_struck
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		OnDbomberSpawn();
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseStruck_OnNpcatkHunt(); // monsters/base_struck
		DwarfLanternBase_OnNpcatkHunt(); // NPCs/dwarf_lantern_base
		bool exitSub = false;
		float gameTime = GameTime();

		if (NPCATK_TARGET != "unset")
		{
			if (!SUSPEND_AI) // case I'm in flinch
			{
				if (RangeTo(NPCATK_TARGET) > ATTACK_RANGE && !NPC_IS_TURRET && gameTime > NEXT_LEAP_FORWARD)
				{
					NEXT_LEAP_FORWARD = gameTime;
					DebugPrint("npcatk_hunt leap forward");
					NEXT_LEAP_FORWARD += FREQ_LEAP_FORWARD;
					ROLL_DIR = 200;
					PlayAnim("critical", ANIM_JUMP);
					PlayRandomSound(2, 10, SOUND_GIGGLE1, SOUND_GIGGLE2, SOUND_GIGGLE3, SOUND_GIGGLE4, SOUND_GIGGLE5);
					exitSub = true;
				}
				if (!exitSub)
				{
					if (RangeTo(NPCATK_TARGET) < 96.0f && !NPC_IS_TURRET && gameTime > NEXT_DODGE)
					{
						NEXT_DODGE = gameTime + FREQ_DODGE;
						DebugPrint("npcatk_hunt dodge");
						ROLL_DIR = -100;
						PlayRandomSound(2, 10, SOUND_GIGGLE1, SOUND_GIGGLE2, SOUND_GIGGLE3, SOUND_GIGGLE4, SOUND_GIGGLE5);
						if (RandomInt(1, 2) == 1)
							PlayAnim("critical", ANIM_DODGE);
						else
							PlayAnim("critical", ANIM_JUMP);
						exitSub = true;
					}
					if (!exitSub && gameTime > NEXT_BOMB_DRAW)
					{
						float nActive = (HR_ACTIVE ? 1.0f : 0.0f) + (HL_ACTIVE ? 1.0f : 0.0f);
						if (nActive < 2.0f)
						{
							NEXT_BOMB_DRAW = gameTime + FREQ_BOMB_DRAW;
							OnDrawRandomBomb();
						}
					}
				}
			}
		}

		if (HR_ACTIVE && gameTime > NEXT_RBOMB_BEAM)
		{
			NEXT_RBOMB_BEAM = gameTime + FREQ_RBOMB_BEAM;
			Effect("beam", "follow", "lgtning.spr", ENT_ME, HR_ATTACH_IDX, 1, 4.0f, 200, Vector3(255, 0, 0));
		}

		if (HL_ACTIVE && gameTime > NEXT_LBOMB_BEAM)
		{
			NEXT_LBOMB_BEAM = gameTime + FREQ_LBOMB_BEAM;
			Effect("beam", "follow", "lgtning.spr", ENT_ME, HL_ATTACH_IDX, 1, 4.0f, 200, Vector3(255, 0, 0));
		}

		if (Float(CL_SCRIPT_IDX) > -1.0f && gameTime > NEXT_CL_UPDATE)
		{
			ClientEvent("update", "all", CL_SCRIPT_IDX, "end_fx");
			CL_SCRIPT_IDX = "-1";
			OnUpdateClScript();
		}
	}

	// cycle_down
	void OnCycleDown()
	{
		BaseNpcAttackNew_OnCycleDown(); // monsters/base_npc_attack_new
		BaseMonsterShared_OnCycleDown(); // monsters/base_monster_shared
		BaseMonsterShared_OnCycleDown_2(); // monsters/base_monster_shared
		DID_INTRO = 0;
		PlayAnim("critical", ANIM_ALERT);
		PlaySound(0, 10, SOUND_GLOAT);
		NEXT_ALERT = GameTime() + 20.0f;
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		bool exitSub = false;
		if (HR_ACTIVE)
		{
			ANIM_ATTACK = ANIM_THROW_R;
			exitSub = true;
		}
		if (exitSub)
			return;
		if (HL_ACTIVE)
		{
			ANIM_ATTACK = ANIM_THROW_L;
			exitSub = true;
		}
		if (exitSub)
			return;

		// I'z got no bombs!
		if (RandomInt(1, 2) == 1)
			ANIM_ATTACK = "ANIM_DRAW_R";
		else
			ANIM_ATTACK = "ANIM_DRAW_L";
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (DID_INTRO != 0)
			return;
		DID_INTRO = 1;
		NPC_NEXT_FLINCH = GameTime() + NPC_FREQ_FLINCH; // so we don't flinch and drop our shit on first blow

		if (GameTime() > NEXT_ALERT)
		{
			PlayAnim("critical", ANIM_ALERT);
			PlaySound(0, 10, SOUND_ALERT);
			NEXT_ALERT = GameTime() + 20.0f;
		}

		NEXT_BOMB_DRAW = GameTime() + 1.0f;

		// don't init cl effects until the first time you see someone
		if (!(GameTime() > NEXT_CL_UPDATE))
			return;
		if (Float(CL_SCRIPT_IDX) > -1.0f)
			ClientEvent("update", "all", CL_SCRIPT_IDX, "end_fx");
		CL_SCRIPT_IDX = "-1";
		OnUpdateClScript();
	}

	// dbomber_spawn
	void OnDbomberSpawn()
	{
		SetName("Mad Dwarven Bomber");
		SetModel("monsters/dwarf_bomber.mdl");
		SetModelBody(0, 2);
		SetModelBody(1, 6);
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		SetWidth(32);
		SetHeight(48);
		SetRoam(true);
		SetHealth(300);
		SetRace("evil");
		SetHearingSensitivity(8);
	}

	// draw_random_bomb
	void OnDrawRandomBomb()
	{
		bool drawingBomb = false;
		if (SUSPEND_AI) // in flinch
			return;

		float nActive = (HR_ACTIVE ? 1.0f : 0.0f) + (HL_ACTIVE ? 1.0f : 0.0f);

		if (!(nActive < 2.0f))
			return;

		int rndHand = RandomInt(1, 2);

		if (rndHand == 1)
		{
			if (!HR_ACTIVE)
			{
				drawingBomb = true;
				PlayAnim("critical", "ANIM_DRAW_R");
			}
		}
		else if (!HL_ACTIVE)
		{
			drawingBomb = true;
			PlayAnim("critical", "ANIM_DRAW_L");
		}

		if (drawingBomb) // random bomb draw was active, do the other hand
			return;
		if (!HR_ACTIVE)
			PlayAnim("critical", "ANIM_DRAW_R");
		if (!HL_ACTIVE)
			PlayAnim("critical", "ANIM_DRAW_L");
	}

	// frame_draw_r
	void OnFrameDrawR()
	{
		PlaySound(0, 10, SOUND_FUSE_LIGHT);
		OnUpdateSubmodels("activate", "right");
	}

	// frame_draw_l
	void OnFrameDrawL()
	{
		PlaySound(0, 10, SOUND_FUSE_LIGHT);
		OnUpdateSubmodels("activate", "left");
	}

	// update_submodels
	// <activate|deactivate> <left|right|both>
	void OnUpdateSubmodels(string activate = "", string side = "")
	{
		// screwy, but required to properly set looping sounds and submodels
		if (activate == "activate")
		{
			if (side == "right")
			{
				if (!HR_ACTIVE)
				{
					HR_ACTIVE = true;
					ServerPlaySound((HR_CHAN ? 1 : 0), 5, SOUND_FUSE_LOOP);
				}
			}
			else if (side == "left")
			{
				if (!HL_ACTIVE)
				{
					HL_ACTIVE = true;
					ServerPlaySound(HL_CHAN, 5, SOUND_FUSE_LOOP);
				}
			}
			else if (side == "both")
			{
				if (!HR_ACTIVE)
				{
					HR_ACTIVE = true;
					ServerPlaySound((HR_CHAN ? 1 : 0), 5, SOUND_FUSE_LOOP);
				}
				if (!HL_ACTIVE)
				{
					HL_ACTIVE = true;
					ServerPlaySound(HL_CHAN, 5, SOUND_FUSE_LOOP);
				}
			}
		}
		else if (activate == "deactivate")
		{
			if (side == "right")
			{
				if (HR_ACTIVE)
					ServerPlaySound((HR_CHAN ? 1 : 0), 0, SOUND_FUSE_LOOP);
				HR_ACTIVE = false;
			}
			else if (side == "left")
			{
				if (HL_ACTIVE)
					ServerPlaySound(HL_CHAN, 0, SOUND_FUSE_LOOP);
				HL_ACTIVE = false;
			}
			else if (side == "both")
			{
				if (HR_ACTIVE)
					ServerPlaySound((HR_CHAN ? 1 : 0), 0, SOUND_FUSE_LOOP);
				if (HL_ACTIVE)
					ServerPlaySound(HL_CHAN, 0, SOUND_FUSE_LOOP);
				HR_ACTIVE = false;
				HL_ACTIVE = false;
			}
		}

		float nActive = (HR_ACTIVE ? 1.0f : 0.0f) + (HL_ACTIVE ? 1.0f : 0.0f);

		if (nActive == 2.0f)
		{
			SetModelBody(1, 3);
		}
		else
		{
			if (HR_ACTIVE)
				SetModelBody(1, 1);
			if (HL_ACTIVE)
				SetModelBody(1, 2);
			if (nActive == 0.0f)
				SetModelBody(1, 0);
		}

		if (Float(CL_SCRIPT_IDX) > -1.0f)
			ClientEvent("update", "all", CL_SCRIPT_IDX, "set_hands", HR_ACTIVE, HL_ACTIVE);
	}

	// npc_bs_struck
	void OnNpcBsStruck(CBaseEntity@ attacker = null)
	{
		if (!(RangeTo(attacker) < 128.0f))
			return;
		if (!(GameTime() > NEXT_DODGE))
			return;
		NEXT_DODGE = GameTime() + FREQ_DODGE;
		DebugPrint("npc_bs_struck dodge");
		ROLL_DIR = -100;
		if (RandomInt(1, 2) == 1)
			PlayAnim("critical", ANIM_DODGE);
		else
			PlayAnim("critical", ANIM_JUMP);
	}

	// update_cl_script
	void OnUpdateClScript()
	{
		if (Float(CL_SCRIPT_IDX) > 0.0f)
		{
			ClientEvent("update", "all", CL_SCRIPT_IDX, "set_hands", HR_ACTIVE, HL_ACTIVE);
		}
		else
		{
			ClientEvent("new", "all", CL_SCRIPT, IndexOf(ENT_ME), FREQ_CL_UPDATE, HR_ACTIVE, HL_ACTIVE);
			CL_SCRIPT_IDX = LastClientScriptId();
			NEXT_CL_UPDATE = GameTime() + FREQ_CL_UPDATE;
		}
	}

	// frame_release_r
	// overhand throw
	void OnFrameReleaseR()
	{
		OnUpdateSubmodels("deactivate", "right");

		// figure required velocity
		Vector3 myOrg = OriginOf(ENT_ME);
		Vector3 targOrg = OriginOf(NPCATK_TARGET);
		float targRange = RangeTo(NPCATK_TARGET);
		Vector3 targDir = Scale(DirectionTo(myOrg, targOrg), Vector3(targRange, targRange, targRange));
		targDir += RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, 110)); // overhand
		if (myOrg.z < targOrg.z)
		{
			float vadj = (targOrg.z - myOrg.z) * 4.0f + targRange;
			// dbg vadj frame_release_r L_VADJ [ $math(subtract,$vec.z(L_TARG_ORG),$vec.z(L_MY_ORG)) ]
			targDir += RelativeVelocity(Vector3(0, 0, 0), Vector3(0, 0, vadj));
		}
		targDir += VEC_ENGLISH;

		CreateNpc(PROJ_SCRIPT, AttachmentPositionOf(ENT_ME, 0), self, targDir);

		VEC_ENGLISH.z += 25.0f;
	}

	// frame_release_l
	// underhand throw
	void OnFrameReleaseL()
	{
		OnUpdateSubmodels("deactivate", "left");

		// figure required velocity
		Vector3 myOrg = OriginOf(ENT_ME);
		Vector3 targOrg = OriginOf(NPCATK_TARGET);
		float targRange = RangeTo(NPCATK_TARGET);
		Vector3 targDir = Scale(DirectionTo(myOrg, targOrg), Vector3(targRange, targRange, targRange));
		// vectoradd L_TARG_DIR $relpos($vec(0,0,0),$vec(0,0,0))
		if (myOrg.z < targOrg.z)
		{
			float vadj = (targOrg.z - myOrg.z) * 4.0f;
			// add L_VADJ L_TARG_RANGE
			DebugPrint("vadj frame_release_l " + Text(vadj) + " [ " + Text(targOrg.z - myOrg.z) + " ]");
			targDir += RelativeVelocity(Vector3(0, 0, 0), Vector3(0, 0, vadj));
		}
		targDir += VEC_ENGLISH;

		CreateNpc(PROJ_SCRIPT, AttachmentPositionOf(ENT_ME, 1), self, targDir);

		VEC_ENGLISH.z += 25.0f;
	}

	// ext_hittarget
	// from monsters/summon/tnt_bomb on struck enemy
	void OnExtHittarget()
	{
		VEC_ENGLISH = Vector3(0, 0, 0); // reset miss adj
	}

	// frame_dodge
	void OnFrameDodge()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, ROLL_DIR, 0)));
	}

	// frame_dodge_up
	void OnFrameDodgeUp()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, ROLL_DIR, 150)));
	}

	// friendly_fire
	void OnFriendlyFire()
	{
		float rndPitch = Random(85, 115);
		// today we learned something - you can only change the pitch of 8-bit unsigned files
		ServerPlaySound(2, 10, SOUND_YELP, 0.8f, rndPitch);
		ROLL_DIR = 0;
		if (RandomInt(1, 2) == 1)
			PlayAnim("critical", ANIM_DODGE);
		else
			PlayAnim("critical", ANIM_JUMP);
	}

	// frame_explode_draw
	void OnFrameExplodeDraw()
	{
		PlaySound(0, 10, SOUND_FUSE_LIGHT);
		OnUpdateSubmodels("activate", "both");
	}

	// frame_explode_land
	void OnFrameExplodeLand()
	{
	}

	// frame_explode_prep
	void OnFrameExplodePrep()
	{
	}

	// frame_explode_fin
	void OnFrameExplodeFin()
	{
		SetProp("rendermode", "5");
		SetProp("renderamt", "0");
		Effect("tempent", "gibs", "fleshgibs.mdl", RelativePosition(Vector3(0, 0, 0)), 1.0f, 50, 50, 15, 20.0f);
		ClientEvent("update", "all", CL_SCRIPT_IDX, "end_fx");
		ClientEvent("new", "all", "effects/sfx_explode", OriginOf(ENT_ME), 256);
		ServerPlaySound((HR_CHAN ? 1 : 0), 0, SOUND_FUSE_LOOP);
		ServerPlaySound(HL_CHAN, 0, SOUND_FUSE_LOOP);
		DoDamageEx(RelativePosition(Vector3(0, 0, 32)), 256, DMG_SUICIDE, 0.1f, ENT_ME, ENT_ME, "none", "generic", "dmgevent:suicide");
		CallEventDelayed(0.1f, "remove_me");

		if (StartsWith(ToLowerCase(MapName()), "rmine"))
			DROP_TNT = true;

		if (DROP_TNT)
		{
			// if $rand(1,100) <= 50
			CreateNpc("other/qitem", RelativePosition(Vector3(0, 0, 0)), "tnt");
			float rndYaw = Random(0, 359.99f);
			SetVelocity(ENT_LASTCREATED, RelativeVelocity(Vector3(0, rndYaw, 0), Vector3(0, 800, 120)), "override");
			Effect("beam", "follow", "lgtning.spr", ENT_LASTCREATED, 1, 1, 8.0f, 200, Vector3(0, 255, 0));
		}
	}

	// set_drop_tnt
	void OnSetDropTnt()
	{
		DROP_TNT = true;
	}

	// suicide_dodamage
	void OnSuicideDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		Vector3 targetOrg = OriginOf(target);
		float targAng = AnglesTo(MyOrigin(), targetOrg);
		SetVelocity(target, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 1000, 110)));
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		if (DID_FSUICIDE)
			return;
		DID_FSUICIDE = true;
		SetInvincible(false);
		SetOrigin(ENT_ME, Vector3(20000, -20000, 20000));
		OnNpcSuicide();
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
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

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/dwarf_bomber_tnt.mdl");
		Precache("bigsmoke.spr");
		Precache("fleshgibs.mdl");
		Precache("misc/sylphiels_stuff.mdl");
		Precache("monsters/dwarf_bomber/fuse_loop.wav");
		Precache("3dmflagry.spr");
		Precache("monsters/dwarf_bomber.mdl");
		Precache("monsters/dwarf_bomber/db_yelp.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DwarfBomber_FirstThink();
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
		if (name == "cycle_down") { OnCycleDown(); return true; }
		if (name == "dbomber_spawn") { OnDbomberSpawn(); return true; }
		if (name == "draw_random_bomb") { OnDrawRandomBomb(); return true; }
		if (name == "ext_hittarget") { OnExtHittarget(); return true; }
		if (name == "frame_dodge") { OnFrameDodge(); return true; }
		if (name == "frame_dodge_up") { OnFrameDodgeUp(); return true; }
		if (name == "frame_draw_l") { OnFrameDrawL(); return true; }
		if (name == "frame_draw_r") { OnFrameDrawR(); return true; }
		if (name == "frame_explode_draw") { OnFrameExplodeDraw(); return true; }
		if (name == "frame_explode_fin") { OnFrameExplodeFin(); return true; }
		if (name == "frame_explode_land") { OnFrameExplodeLand(); return true; }
		if (name == "frame_explode_prep") { OnFrameExplodePrep(); return true; }
		if (name == "frame_release_l") { OnFrameReleaseL(); return true; }
		if (name == "frame_release_r") { OnFrameReleaseR(); return true; }
		if (name == "friendly_fire") { OnFriendlyFire(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npc_bs_struck") { OnNpcBsStruck(EntityParam(params, 0)); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "set_drop_tnt") { OnSetDropTnt(); return true; }
		if (name == "suicide_dodamage") { OnSuicideDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "update_cl_script") { OnUpdateClScript(); return true; }
		if (name == "update_submodels") { OnUpdateSubmodels(Param(params, 0), Param(params, 1)); return true; }
		return BaseStruck_DispatchEvent(name, params)
			|| DwarfLanternBase_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
