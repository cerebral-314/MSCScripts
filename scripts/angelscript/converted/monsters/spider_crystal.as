#pragma context server

// Converted from monsters/spider_crystal.script by msc_transpiler.
// Crystal Phase Spider, from scratch by Thothie
// - Crawls on ceiling
// - Eletrical Projectile Attacks
// - Poison
// - Teleportation
// - crab step sideways dodge/orientation (not work so good)
// - leap towards/away

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/spider_crystal"]
class SpiderCrystal : BaseMonsterNewScript
{
	// Constants
	string BANIM_IDLE = "idle";
	string BANIM_WALK = "walk";
	string BANIM_RUN = "run";
	string BANIM_DODGEL = "walkl";
	string BANIM_DODGER = "walkr";
	string BANIM_BITE = "bite";
	string BANIM_SPELL = "spell";
	string BANIM_DOUBLEATK = "dblslash";
	string BANIM_CLOSEATK = "close";
	string BANIM_FLING = "fling";
	string BANIM_PROJ = "project";
	string BANIM_REEL = "real";
	string BANIM_FLINCH = "flinch";
	string C_PREFIX = "c_";
	string G_PREFIX = "g_";
	string ANIM_JUMP = "g_jump";
	string ANIM_TOGROUND = "toground";
	int RANGE_CHASE = 300;
	float FREQ_BITE = 0.0f;
	float FREQ_TELEPORT = 0.0f;
	float FREQ_SIDESTEP = 0.0f;
	float DOT_POISON = 30.0f;
	string DMG_SWIPE = "75.0";
	float DMG_BITE = 100.0f;
	float DMG_PROJ = 60.0f;
	float DOT_SHOCK = 20.0f;
	bool ATTACH_MAW = false;
	bool ATTACH_CLAW1 = true;
	int ATTACH_CLAW2 = 2;
	string SOUND_ALERT1 = "monsters/spider/c_pspidhas_bat1.wav";
	string SOUND_ALERT2 = "monsters/spider/c_pspidire_bat1.wav";
	string SOUND_ALERT3 = "monsters/spider/c_pspidr_bat1.wav";
	string SOUND_ALERT4 = "monsters/spider/c_pspidr_bat2.wav";
	string SOUND_PAIN1 = "monsters/spider/c_pspidr_hit1.wav";
	string SOUND_PAIN2 = "monsters/spider/c_pspidr_hit2.wav";
	string SOUND_ATTACK1 = "monsters/spider/c_pspidr_atk1.wav";
	string SOUND_ATTACK2 = "monsters/spider/c_pspidr_atk2.wav";
	string SOUND_ATTACK3 = "monsters/spider/c_pspidr_atk3.wav";
	string SOUND_MANIFEST = "monsters/spider/c_pspidrth_bat1.wav";
	string SOUND_QUICK1 = "monsters/spider/c_pspidr_no.wav";
	string SOUND_QUICK2 = "monsters/spider/c_pspidr_yes.wav";
	string SOUND_SEARCH = "monsters/spider/c_pspidr_slct.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_PREFIX = "ANIM_PREFIX";
	int RANGE_NORM = 0;
	int MOVERANGE_NORM = 0;
	int HITRANGE_NORM = 0;
	int RANGE_CLOSE = 0;
	int HITRANGE_CLOSE = 0;
	int RANGE_PROJ = 0;
	int MOVERANGE_PROJ = 0;
	string PROJ_SPRITE = "PROJ_SPRITE";
	string TELE_TYPE = "TELE_TYPE";
	float NEXT_TELE_FIX = 0.0f;
	bool STAY_ON_GROUND = false;
	bool GROUND_MODE = false;
	int V_ADJ = 0;
	float DELAY_V_PUSH = 0.0f;
	int DID_INTRO = 0;
	float NEXT_SIDESTEP = 0.0f;
	float NEXT_TELEPORT = 0.0f;
	float NEXT_INTRO = 0.0f;
	bool BITE_ATTACK = false;
	float NEXT_BITE = 0.0f;
	string LAST_TELE_POINT = "LAST_TELE_POINT";
	bool DID_TELEPORT = false;

	// Variables declared by included files, with the value they start with in this script
	SpiderCrystal()
	{
		ANIM_IDLE = "c_idle";
		ANIM_WALK = "c_walk";
		SOUND_DEATH = "monsters/spider/c_pspidr_dead.wav";
	}

	// unnamed block (first think)
	void SpiderCrystal_FirstThink()
	{
		ANIM_IDLE = "c_idle";
		ANIM_WALK = "c_walk";
		ANIM_RUN = "c_run";
		ANIM_ATTACK = "c_project";
		ANIM_PREFIX = "c_";
		ANIM_DEATH = "death";
	}

	// unnamed block (first think)
	void SpiderCrystal_FirstThink2()
	{
		NPC_GIVE_EXP = 600.0f;

		ATTACK_RANGE = 9999.0f;
		ATTACK_HITRANGE = 9999.0f;
		ATTACK_MOVERANGE = 100.0f;
		MOVE_RANGE = "100";

		RANGE_NORM = 150;
		MOVERANGE_NORM = 100;
		HITRANGE_NORM = 175;

		RANGE_CLOSE = 70;
		HITRANGE_CLOSE = 100;

		RANGE_PROJ = 9999;
		MOVERANGE_PROJ = 9999;
		NPC_RANGED = "1";

		PROJ_SPRITE = "nhth1.spr";
	}

	// unnamed block (timer)
	void SpiderCrystal_Timer()
	{
		CallEventDelayed(5.0f, "SpiderCrystal_Timer");
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", NPC_RENDER_AMT);
	}

	// game_precache
	void OnGamePrecache()
	{
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
		NPC_RENDER_AMT = 0.0f;
		NPC_RENDER_MODE = 5;
		OnSpiderFadeIn();
		if (GROUND_MODE)
			return;
		CallEventDelayed(0.1f, "ceiling_mode");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SetName("Crystal Phase Spider");
		SetModel("monsters/spider_crystal.mdl");
		SetWidth(48);
		SetHeight(48);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		SetHearingSensitivity(11);

		SetRace("spider");

		SetRoam(true);

		IMMUNE_VAMPIRE = true;
		NPC_RENDER_AMT = 0.0f;

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
		SetHealth(1000);
		SetDamageTaken("pierce", 0.5f);
		SetDamageTaken("slash", 0.75f);
		SetDamageTaken("blunt", 1.25f);
		SetDamageTaken("holy", 1);
		SetDamageTaken("poison", 0);

		TELE_TYPE = "melee";
		NEXT_TELE_FIX = 99999.0f;
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck

		float gameTime = GameTime();

		if (!GROUND_MODE)
		{
			SetGravity(-1);
			if (gameTime > DELAY_V_PUSH)
				SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 1)));
		}
		else
		{
			SetGravity(1);
		}

		if (NPCATK_TARGET == "unset" && DID_TELEPORT && gameTime > NEXT_TELE_FIX)
		{
			// I teleported, and have not had a target for 30 seconds
			// just on the off chance I teleported off map, teleport home
			DebugPrint("teleport_fix " + Text(NEXT_TELE_FIX));
			ClientEvent("new", "all", "effects/sfx_sprite_in_fancy", OriginOf(ENT_ME), "c-tele1.spr", 25, 2.0f, Vector3(255, 255, 255), 512, "magic/teleport.wav");
			SetOrigin(ENT_ME, Vec(NPC_HOME_LOC));
			TELE_TYPE = "melee";
			NEXT_TELE_FIX = 99999.0f;
			ClientEvent("new", "all", "effects/sfx_sprite_in_fancy", NPC_HOME_LOC, "c-tele1.spr", 25, 2.0f, Vector3(255, 255, 255), 512, "magic/teleport.wav");
		}

		if (NPCATK_TARGET == "unset")
			return;

		NEXT_TELE_FIX = gameTime + 20.0f;

		if (gameTime > NEXT_TELEPORT && IsPlayer(NPCATK_TARGET))
			OnCheckTeleport();

		float targRange = RangeTo(NPCATK_TARGET);

		if (targRange < RANGE_CHASE && targRange > RANGE_CLOSE)
		{
			ANIM_ATTACK = ANIM_PREFIX + BANIM_DOUBLEATK;
			ATTACK_RANGE = RANGE_NORM;
			ATTACK_HITRANGE = HITRANGE_NORM;
			ATTACK_MOVERANGE = MOVERANGE_NORM;
			SetMoveAnim(ANIM_RUN);
		}

		if (targRange < RANGE_CLOSE)
		{
			ANIM_ATTACK = ANIM_PREFIX + BANIM_CLOSEATK;
			ATTACK_RANGE = RANGE_CLOSE;
			ATTACK_HITRANGE = HITRANGE_CLOSE;
			ATTACK_MOVERANGE = MOVERANGE_NORM;

			if (gameTime > NEXT_BITE)
				ANIM_ATTACK = ANIM_PREFIX + BANIM_BITE;
		}

		if (targRange > RANGE_CHASE)
		{
			ANIM_ATTACK = ANIM_PREFIX + BANIM_PROJ;
			ATTACK_RANGE = RANGE_PROJ;
			ATTACK_HITRANGE = RANGE_PROJ;
			ATTACK_MOVERANGE = MOVERANGE_PROJ;
		}

		if (gameTime > NEXT_SIDESTEP)
		{
			NEXT_SIDESTEP = gameTime;
			float freqSidestep = FREQ_SIDESTEP;
			if (targRange > RANGE_CHASE)
				freqSidestep *= 0.5f;
			NEXT_SIDESTEP += freqSidestep;

			int sidestepDir = RandomInt(1, 2);
			if (sidestepDir == 1)
			{
				PlayAnim("critical", ANIM_PREFIX + BANIM_DODGEL);
				AddVelocity(ENT_ME, RelativeVelocity(Vector3(-1000, 0, 0)));
			}
			if (sidestepDir == 2)
			{
				PlayAnim("critical", ANIM_PREFIX + BANIM_DODGER);
				AddVelocity(ENT_ME, RelativeVelocity(Vector3(1000, 0, 0)));
			}
		}
	}

	// npcatk_clear_targets
	void OnNpcatkClearTargets(string reason = "")
	{
		BaseNpcAttackNew_OnNpcatkClearTargets(reason); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkClearTargets(reason); // monsters/base_monster_shared
		BaseMonsterShared_OnNpcatkClearTargets_2(reason); // monsters/base_monster_shared
		DID_INTRO = 0;
		NEXT_INTRO = GameTime() + Random(6, 12);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (DID_INTRO == 0 && GameTime() > NEXT_INTRO)
		{
			DID_INTRO = 1;
			PlayRandomSound(0, 10, SOUND_ALERT1, SOUND_ALERT2, SOUND_ALERT3, SOUND_ALERT4);

			NEXT_SIDESTEP = GameTime() + Random(30, 40);

			NEXT_TELEPORT = GameTime() + FREQ_TELEPORT;
		}
	}

	// set_start_ground
	void OnSetStartGround()
	{
		OnGroundMode();
	}

	// set_stay_ground
	void OnSetStayGround()
	{
		OnSetStartGround();
		STAY_ON_GROUND = true;
	}

	// spider_fade_in
	void OnSpiderFadeIn()
	{
		NPC_RENDER_AMT += 10.0f;

		if (NPC_RENDER_AMT < 255.0f)
		{
			SetProp(ENT_ME, "renderamt", NPC_RENDER_AMT);
			CallEventDelayed(0.1f, "spider_fade_in");
		}
		else
		{
			SetProp(ENT_ME, "renderamt", 255);
			SetProp(ENT_ME, "rendermode", 5);
			NPC_RENDER_AMT = 255.0f;
		}
	}

	// ground_mode
	void OnGroundMode()
	{
		if (!GROUND_MODE)
			PlayAnim("critical", ANIM_TOGROUND);

		ANIM_IDLE = "g_idle";
		ANIM_WALK = "g_walk";
		ANIM_RUN = "g_run";
		ANIM_ATTACK = "g_projectile";
		GROUND_MODE = true;
		ANIM_PREFIX = G_PREFIX;
		V_ADJ = 64;

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
	}

	// ceiling_mode
	void OnCeilingMode()
	{
		if (GROUND_MODE)
			PlayAnim("critical", ANIM_JUMP);

		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 1000)));
		DELAY_V_PUSH = GameTime() + 1.0f;

		ANIM_IDLE = "c_idle";
		ANIM_WALK = "c_walk";
		ANIM_RUN = "c_run";
		ANIM_ATTACK = "c_project";
		GROUND_MODE = false;
		ANIM_PREFIX = C_PREFIX;
		V_ADJ = -64;

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
	}

	// frame_projectile
	void OnFrameProjectile()
	{
		PlayRandomSound(0, 10, SOUND_QUICK1, SOUND_QUICK2);
		// clientevent new all effects/sfx_ball_lightning $relpos(0,32,V_ADJ) $get(NPCATK_TARGET,origin) 1
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_sprite", RelativePosition(Vector3(0, 32, V_ADJ)), NPCATK_TARGET, 300, 0, 0.1f, "none");
		// effect beam
		Effect("beam", "ents", "lgtning.spr", 10, ENT_ME, 2, ENT_ME, 3, Vector3(255, 0, 255), 200, 90, 1.0f);
	}

	// ext_proj_land
	void OnExtProjLand(string value = "", CBaseEntity@ target = null, Vector3 landPosition = Vector3())
	{
		bool hitEnemy = false;

		bool targAlive = IsAlive(target);
		if (RelationshipOf(target, ENT_ME) == "enemy" && targAlive)
			hitEnemy = true;

		Vector3 arrowPos = landPosition;
		if (hitEnemy)
			arrowPos = OriginOf(target);
		arrowPos.z = GroundHeight(arrowPos);
		arrowPos.z += 32.0f;
		ClientEvent("new", "all", "effects/sfx_light_fade", arrowPos, Vector3(255, 0, 255), 190, 1, "debris/beamstart4.wav", 5);
		DoDamageEx(arrowPos, 128, DMG_PROJ, 0.1f, ENT_ME, ENT_ME, "none", "lightning_effect", "dmgevent:proj");
	}

	// proj_dodamage
	void OnProjDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		DebugPrint("proj_dodamage " + Text(hit) + " " + NameOf(target) + " " + Text(start) + " " + Text(end));
		if (!hit)
			return;
		ApplyEffect(target, "effects/dot_lightning", 5.0f, self, DOT_SHOCK); // * replace
	}

	// frame_melee_strike
	void OnFrameMeleeStrike()
	{
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_SWIPE, "90%", "slash");
	}

	// frame_bite
	void OnFrameBite()
	{
		PlayRandomSound(0, 10, SOUND_QUICK1, SOUND_QUICK2);
		BITE_ATTACK = true;
		DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, DMG_BITE, "100%", ENT_ME, ENT_ME, "none", "pierce", "dmgevent:bite");
		ANIM_ATTACK = ANIM_PREFIX + BANIM_CLOSEATK;
		NEXT_BITE = GameTime() + FREQ_BITE;
	}

	// bite_dodamage
	void OnBiteDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		AddVelocity(target, RelativeVelocity(Vector3(0, 400, 110)));
		ApplyEffect(target, "effects/dot_poison", 5.0f, self, DOT_POISON);
	}

	// check_teleport
	void OnCheckTeleport()
	{
		Vector3 telePoint = Vec("TELE_POINT");
		bool teleFail = false;
		// if we're close, try to teleport to last position, if far, try to teleport closer
		// local AM_CLOSE 0
		// if ( $get(NPCATK_TARGET,range) < RANGE_CHASE ) local AM_CLOSE 1
		Vector3 curPos = OriginOf(ENT_ME);

		if (TELE_TYPE == "melee")
		{
			if (CanSee(NPCATK_TARGET))
			{
				// pick area randomly around target
				telePoint = OriginOf(NPCATK_TARGET);
				float rndAng = Random(0, 359.99f);
				telePoint += RelativePosition(Vector3(0, rndAng, 0), Vector3(0, MOVERANGE_NORM, 0));
				telePoint.z = GroundHeight(telePoint);
				if (!GROUND_MODE) // correct for ground slopes, if tele to ground
					telePoint.z += 16.0f;
				LAST_TELE_POINT = Text(OriginOf(ENT_ME));
			}
			else
			{
				// can't see him, try again later
				NEXT_TELEPORT = GameTime() + 3.0f;
				return;
			}
		}

		if (TELE_TYPE == "ranged")
		{
			if (LAST_TELE_POINT != "LAST_TELE_POINT")
				telePoint = Vec(LAST_TELE_POINT);
			else
				telePoint = Vec(NPC_HOME_LOC);
		}

		// test new position
		SetOrigin(ENT_ME, telePoint);
		string pos = Text(telePoint);
		SetLocal("reg.npcmove.endpos", pos);
		float wiggleRl = Random(-8, 8);
		float wiggleFb = Random(-8, 8);
		LegacyCommand("vectoradd", "reg.npcmove.endpos", RelativePosition(Vector3(0, Float(Eval("game.monster.angles.yaw")), 0), Vector3(wiggleRl, wiggleFb, 0)));
		SetLocal("reg.npcmove.testonly", 1);
		LegacyCommand("npcmove", ENT_ME, NPCATK_TARGET);
		if (Float(Eval("game.ret.npcmove.dist")) <= 0.0f)
			teleFail = true;

		if (teleFail)
		{
			// position failed, go back to where I was, try again next think
			DebugPrint("teleport failed " + TELE_TYPE + " " + Eval("game.ret.npcmove.dist") + " " + Text(telePoint));
			SetOrigin(ENT_ME, curPos);
		}
		else
		{
			// playsound 0 10 SOUND_TELE
			string sprPoint = Text(telePoint);
			if (TELE_TYPE == "melee") // presume teleporting to ground, adjust
				sprPoint = Text(Vec(sprPoint) + Vector3(0.0f, 0.0f, 32.0f));
			ClientEvent("new", "all", "effects/sfx_sprite_in_fancy", sprPoint, "c-tele1.spr", 25, 2.0f, Vector3(255, 255, 255), 512, "magic/teleport.wav");
			ClientEvent("new", "all", "effects/sfx_sprite_in_fancy", curPos, "c-tele1.spr", 25, 2.0f, Vector3(255, 255, 255), 512, "magic/teleport.wav");
			NEXT_TELEPORT = GameTime();
			float freqTeleport = FREQ_TELEPORT;
			if (TELE_TYPE == "melee")
			{
				freqTeleport *= 0.5f; // favors teleporting away
			}
			NEXT_TELEPORT += freqTeleport;

			if (!STAY_ON_GROUND)
			{
				if (TELE_TYPE == "melee")
				{
					// we weren't close before, but should be now, set ground mode
					// but premtively set ground mode var to prevent climb down animation
					if (!GROUND_MODE)
						PlayAnim("break");
					GROUND_MODE = true;
					OnGroundMode();
				}
				else
				{
					// otherwise, visa versa
					if (GROUND_MODE)
						PlayAnim("break");
					GROUND_MODE = false;
					OnCeilingMode();
				}
			}

			if (!teleFail)
			{
				DID_TELEPORT = true;
				if (TELE_TYPE == "melee")
					TELE_TYPE = "ranged";
				else
					TELE_TYPE = "melee";
			}
		}
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("nhth1.spr");
		Precache("c-tele1.spr");
		Precache("monsters/spider_crystal.mdl");
		CallEventDelayed(5.0f, "SpiderCrystal_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SpiderCrystal_FirstThink();
		SpiderCrystal_FirstThink2();
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
		if (name == "bite_dodamage") { OnBiteDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "ceiling_mode") { OnCeilingMode(); return true; }
		if (name == "check_teleport") { OnCheckTeleport(); return true; }
		if (name == "ext_proj_land") { OnExtProjLand(Param(params, 0), EntityParam(params, 1), Vec(Param(params, 2))); return true; }
		if (name == "frame_bite") { OnFrameBite(); return true; }
		if (name == "frame_melee_strike") { OnFrameMeleeStrike(); return true; }
		if (name == "frame_projectile") { OnFrameProjectile(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "ground_mode") { OnGroundMode(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_clear_targets") { OnNpcatkClearTargets(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "proj_dodamage") { OnProjDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "set_start_ground") { OnSetStartGround(); return true; }
		if (name == "set_stay_ground") { OnSetStayGround(); return true; }
		if (name == "spider_fade_in") { OnSpiderFadeIn(); return true; }
		if (name == "SpiderCrystal_Timer") { SpiderCrystal_Timer(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
