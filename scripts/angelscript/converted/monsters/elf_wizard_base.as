#pragma context server

// Converted from monsters/elf_wizard_base.script by msc_transpiler.
// Wizards, Crossbowmen, and Necromancers of the pointy eared persuasion

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ElfWizardBase
{
	// Constants
	string ELF_MODEL = "npc/elf_m_wizard.mdl";
	string ANIM_LOOK = "look_idle";
	string ANIM_HOP = "jump";
	string ANIM_JUMP = "long_jump";
	string ANIM_MELEE = "ref_shoot_crowbar";
	string ANIM_PALM_ATTACK = "ref_shoot_trip";
	string ANIM_XBOW_AIM = "ref_aim_bow";
	string ANIM_XBOW_FIRE = "ref_shoot_bow";
	string ANIM_XBOW_RELOAD = "ref_shoot_squeak";
	string ANIM_DUCK_MOVE = "crawl";
	string ANIM_MELEE_DUCK = "crouch_shoot_crowbar";
	string ANIM_XBOW_AIM_DUCK = "crouch_aim_bow";
	string ANIM_XBOW_FIRE_DUCK = "crouch_shoot_bow";
	string ANIM_XBOW_RELOAD_DUCK = "crouch_aim_squeak";
	string ANIM_SPELL_HOLD = "ref_aim_onehanded";
	string ANIM_SPELL_LEFT_HOLD = "ref_aim_egon";
	string ANIM_SPELL_PREP = "ref_aim_trip";
	string ANIM_SPELL_RELEASE = "ref_shoot_trip";
	string ANIM_REPELL = "ref_shoot_trip";
	string ANIM_PREP_EGG = "ref_aim_squeak";
	string ANIM_RELEASE_EGG = "ref_shoot_squeak";
	string ANIM_SHIELD_HOLD = "aim_2";
	string ANIM_STAFF_HOLD = "ref_aim_crowbar";
	string ANIM_DEATH1 = "die_simple";
	string ANIM_DEATH2 = "die_backwards1";
	string ANIM_DEATH3 = "die_backwards";
	string ANIM_DEATH4 = "die_forwards";
	string ANIM_DEATH5 = "headshot";
	string ANIM_DEATH6 = "die_spin";
	string ANIM_DEATH7 = "gutshot";
	string SOUND_DEATH = "voices/human/male_die.wav";
	bool ELF_IS_ARCHER = false;
	bool ELF_EXPLOSIVE_BOLTS = true;
	string ELF_XBOW_CL_SCRIPT = "monsters/elf_xbow_cl";
	Vector3 ELF_XBOW_STAND_OFS = Vector3();
	Vector3 ELF_XBOW_DUCK_OFS = Vector3();
	int ELF_XBOW_BONE = 27;
	int DMG_XBOW = 200;
	float FREQ_XBOW_BASH = 5.0f;
	int ELF_XBOW_ACCURACY = 75;
	int ATTACK_HITRANGE_MELEE = 64;
	int ATTACH_STAFF_TIP = 2;
	bool ATTACH_STAFF_HILT = true;
	string ATTACH_LHAND = "3";
	string ATTACH_RHAND = "0";
	bool ELF_IS_NOVICE = false;
	float FREQ_GUIDED = 25.0f;
	bool ELF_CAN_GUIDED = false;
	string ELF_GUIDED_TYPES = "fire;cold;lightning;poison";
	string ELF_GUIDED_DOTS = "100;75;75;75";
	int ELF_GUIDED_DMG = 200;
	float ELF_GUIDED_DURATION = 20.0f;
	string ELF_GUIDED_SCRIPT = "monsters/summon/guided_sphere_cl";
	int CFB_SPEED = 60;
	bool ELF_PALM_ATTACK = false;
	int ELF_PALM_DMG = 300;
	int ELF_PALM_RANGE = 96;
	float FREQ_PALM = 3.0f;
	int ELF_BEAM_RANGE = 512;
	string ELF_PALM_CL_SCRIPT = "effects/sfx_hit_shield";
	int DMG_MELEE = 200;
	Vector3 ELF_MELEE_PUSH_VEL = Vector3();
	string SOUND_ELF_BEAM_START = "magic/bolt_start.wav";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_XBOW_STRETCH = "weapons/bow/stretch.wav";
	string SOUND_XBOW_SHOOT = "weapons/bow/crossbow.wav";
	string SOUND_BOLT_HIT = "weapons/bow/bolthit1.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle";
	string ANIM_WALK = "walk2handed";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_DEATH = "ANIM_DEATH";
	int ELF_BEAM_DMG = 0;
	int ELF_BEAM_DOT = 0;
	string ELF_BEAM_DMG_TYPE = "ELF_BEAM_DMG_TYPE";
	Vector3 ELF_BEAM_PUSH_VEL = Vector3();
	float ELF_BEAM_DUR = 0.0f;
	string ELF_BEAM_SPECIAL = "ELF_BEAM_SPECIAL";
	float ELF_HALF_HEALTH = 0.0f;
	string DEF_ANIM_WALK = "DEF_ANIM_WALK";
	string DEF_ANIM_RUN = "DEF_ANIM_RUN";
	string DEF_ANIM_IDLE = "DEF_ANIM_IDLE";
	float FIRST_CYCLE = 0.0f;
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string NPC_RANGED = "NPC_RANGED";
	bool ELF_MISS_COUNT = false;
	bool ELF_BEAM_ATTACK = false;
	Vector3 ELF_BEAM_COLOR = Vector3();
	string ELF_BEAM_EFFECT = "ELF_BEAM_EFFECT";
	float AS_ATTACKING = 0.0f;
	Vector3 ELF_AIM_ANGLES = Vector3();
	bool ELF_XBOW_SHOT = false;
	string ELF_BOLT_LAND = "ELF_BOLT_LAND";
	Vector3 ELF_XBOW_REPELL_POINT = Vector3();
	string ELF_XBOW_TARGETS = "ELF_XBOW_TARGETS";
	float NEXT_GUIDED = 0.0f;
	float NEXT_XBOW_BASH = 0.0f;
	string ELF_GUIDED_TYPE = "ELF_GUIDED_TYPE";
	string ELF_GUIDED_DOT = "ELF_GUIDED_DOT";
	bool ELF_GUIDED_ACTIVE = false;
	bool CFB_FIRST_TARGET_FOUND = false;
	Vector3 CFB_EST_ORG = Vector3();
	string CFB_EST_ANG = "CFB_EST_ANG";
	string CFB_FIREBALL_IDX = "CFB_FIREBALL_IDX";
	float CFB_FORCE_END = 0.0f;
	float CFB_NEXT_SCAN = 0.0f;
	CBaseEntity@ CFB_TARGET = null;
	CBaseEntity@ ELF_PALM_TARGET = null;
	string BEAM_TARGET = "BEAM_TARGET";
	bool ELF_BEAM_ON = false;
	float NEXT_SCRIPT_UPDATE = 0.0f;
	string ELF_XBOW_CL_SCRIPT_ID = "ELF_XBOW_CL_SCRIPT_ID";

	// unnamed block (first think)
	void ElfWizardBase_FirstThink()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk2handed";
		ANIM_RUN = "run2";
		ANIM_DEATH = "die_simple";
	}

	// unnamed block (first think)
	void ElfWizardBase_FirstThink2()
	{
		// setvard for easy adjustment
		ELF_BEAM_DMG = 100;
		ELF_BEAM_DOT = 100;
		ELF_BEAM_DMG_TYPE = "lightning";
		ELF_BEAM_PUSH_VEL = RelativeVelocity(Vector3(0, 300, 110));
		ELF_BEAM_DUR = 5.0f;
		ELF_BEAM_SPECIAL = "none";
	}

	// game_precache
	void ElfWizardBase_OnGamePrecache()
	{
		if (ELF_IS_ARCHER)
			PrecacheFile(ELF_XBOW_CL_SCRIPT);
		if (ELF_PALM_ATTACK) {}
		if (ELF_CAN_GUIDED) {}
	}

	// npc_spawn
	// ==================================== Init
	void ElfWizardBase_OnNpcSpawn(string npc = "")
	{
		SetModel(ELF_MODEL);
		SetWidth(24);
		SetHeight(80);
		SetRoam(true);

		SetHearingSensitivity(10);

		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);

		// general elemental resistance
		SetDamageTaken("cold", 0.5f);
		SetDamageTaken("fire", 0.5f);
		SetDamageTaken("poison", 0.5f);
		SetDamageTaken("lightning", 0.5f);

		SetDamageTaken("holy", 0); // native to plane

		OnElfSpawn();

		ELF_HALF_HEALTH = MaxHealthOf(ENT_ME) * 0.5f;

		DEF_ANIM_WALK = ANIM_WALK;
		DEF_ANIM_RUN = ANIM_RUN;
		DEF_ANIM_IDLE = ANIM_IDLE;

		FIRST_CYCLE = GameTime() + 5.0f;

		if (ELF_IS_ARCHER)
		{
			ATTACK_RANGE = 1024.0f;
			ATTACK_HITRANGE = 1024.0f;
			ANIM_ATTACK = ANIM_XBOW_FIRE;
			NPC_RANGED = "1";
			ELF_MISS_COUNT = false;
		}

		if (ELF_IS_NOVICE)
		{
			ATTACK_RANGE = 64.0f;
			ATTACK_HITRANGE = 120.0f;
			ANIM_ATTACK = ANIM_PALM_ATTACK;
		}

		if (Truthy(GetVar("ELF_LIGHTNING_WIZARD")))
		{
			ELF_BEAM_ATTACK = true;
			ELF_BEAM_COLOR = Vector3(255, 128, 64);
			ELF_BEAM_EFFECT = "effects/dot_lightning";
		}
	}

	// frame_xbow_shoot_stand
	// ==================================== Anim Events
	void ElfWizardBase_OnFrameXbowShootStand()
	{
		// setvard NPC_NO_ATTACK 1 //risky, and may not be needed
		// dbg frame_xbow_shoot_stand
		if (ELF_IS_ARCHER)
			OnElfShootXbow();
	}

	// frame_xbow_shoot_crouch
	void ElfWizardBase_OnFrameXbowShootCrouch()
	{
		if (ELF_IS_ARCHER)
			OnElfShootXbow();
	}

	// frame_xbow_reload_now
	void ElfWizardBase_OnFrameXbowReloadNow()
	{
		// dbg frame_xbow_reload_now
		if (!ELF_IS_ARCHER)
			return;
		PlaySound(0, 10, SOUND_XBOW_STRETCH);
		AS_ATTACKING = GameTime() + 10.0f;

		PlayAnim("critical", ANIM_XBOW_RELOAD);
	}

	// frame_xbow_reloaded
	void ElfWizardBase_OnFrameXbowReloaded()
	{
		// dbg frame_xbow_reloaded
		if (!ELF_IS_ARCHER)
			return;
		// playsound 0 10 SOUND_XBOW_COCK
		// setvard NPC_NO_ATTACK 0
		AS_ATTACKING = GameTime() + 10.0f;

		PlayAnim("critical", ANIM_XBOW_AIM);
	}

	// frame_repell
	void ElfWizardBase_OnFrameRepell()
	{
		string finalTarg;
		if (!ELF_PALM_ATTACK)
			return;

		Vector3 repellSpriteOrg = RelativePosition(Vector3(0, 32, 32));
		ClientEvent("new", "all", ELF_PALM_CL_SCRIPT, repellSpriteOrg, AnglesOf(ENT_ME).y, Vector3(255, 255, 255), 2.0f, 2.0f);

		PlaySound(0, 10, "magic/frost_pulse.wav");

		if (IsAlive(NPCATK_TARGET))
		{
			finalTarg = NPCATK_TARGET;
		}
		else
		{
			// in case AI suspended during attack call
			finalTarg = EntityId(ELF_PALM_TARGET);
		}
		// if ( $get(FINAL_TARG,range) < ELF_PALM_RANGE ) local FINAL_TARG ELF_PALM_TARGET
		DoDamage(finalTarg, ELF_PALM_RANGE, ELF_PALM_DMG, "100%", "magic");
		if (RangeTo(finalTarg) < ELF_PALM_RANGE)
			AddVelocity(finalTarg, RelativeVelocity(Vector3(10, 1000, 110)));
	}

	// frame_melee
	void ElfWizardBase_OnFrameMelee()
	{
		DoDamage(NPCATK_TARGET, DMG_MELEE, ATTACK_HITRANGE_MELEE, "90%", "blunt");
		if (ELF_IS_ARCHER)
			PlayAnim("critical", "frame_xbow_reloaded");
		AddVelocity(NPCATK_TARGET, ELF_MELEE_PUSH_VEL);
	}

	// elf_shoot_xbow
	// ==================================== XBow Attack
	void ElfWizardBase_OnElfShootXbow()
	{
		PlaySound(1, 10, SOUND_XBOW_SHOOT);

		Vector3 startLine = BonePositionOf(ENT_ME, ELF_XBOW_BONE);
		Vector3 targOrg = OriginOf(NPCATK_TARGET);

		if (RandomInt(1, 100) > ELF_XBOW_ACCURACY)
		{
			DebugPrint("elf_shoot_xbow miss"); // miss slightly
			float rndX = Random(-64, 64);
			float rndY = Random(-64, 64);
			targOrg.x += rndX;
			targOrg.y += rndY;
		}

		if (ELF_EXPLOSIVE_BOLTS)
			targOrg.z = GroundHeight(targOrg);

		ELF_AIM_ANGLES = Angles3DTo(startLine, targOrg);
		DebugPrint("before " + Text(ELF_AIM_ANGLES));
		float ang = ELF_AIM_ANGLES.x;
		ang = -ang;
		ELF_AIM_ANGLES.x = ang;
		DebugPrint("after " + Text(ELF_AIM_ANGLES));
		string endLine = Text(startLine);
		endLine = Text(Vec(endLine) + RelativePosition(ELF_AIM_ANGLES, Vector3(0, 2048, 0)));
		ELF_XBOW_SHOT = true;
		endLine = LegacyFunction("get_traceline", startLine, endLine, "worldonly");
		ELF_BOLT_LAND = endLine;

		// if ( G_DEVELOPER_MODE ) effect beam point lgtning.spr 30 START_LINE END_LINE (255,0,0) 255 0 1.0
		DoDamageEx(startLine, endLine, DMG_XBOW, "100%", ENT_ME, ENT_ME, "none", "pierce");
		ELF_XBOW_REPELL_POINT = Vec(endLine);
		if (ELF_XBOW_CL_SCRIPT_ID != "ELF_XBOW_CL_SCRIPT_ID")
			ClientEvent("update", "all", ELF_XBOW_CL_SCRIPT_ID, "fire_bolt", startLine, endLine, ELF_AIM_ANGLES, ELF_EXPLOSIVE_BOLTS);
		if (ELF_EXPLOSIVE_BOLTS)
			CallEventDelayed(0.1f, "elf_do_explode");
	}

	// elf_do_explode
	void ElfWizardBase_OnElfDoExplode()
	{
		DoDamageEx(ELF_BOLT_LAND, 128, DMG_XBOW, 0, ENT_ME, ENT_ME, "none", "fire_effect", "dmgevent:dbolt");
	}

	// game_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end)
	string ElfWizardBase_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		int count;
		string result = "";
		if (ELF_XBOW_SHOT)
		{
			// if ( G_DEVELOPER_MODE ) effect beam point lgtning.spr 30 PARAM3 PARAM4 (0,0,255) 255 0 1.0
			if (ELF_EXPLOSIVE_BOLTS)
			{
				ELF_XBOW_TARGETS = LegacyFunction("get_tsphere", "enemy", 128, end);
				if (ELF_XBOW_TARGETS != "none")
				{
					ELF_XBOW_REPELL_POINT = end;
					count = GetTokenCount(ELF_XBOW_TARGETS);
					for (int i = 0; i < count; i++)
					{
						loopIteration = i;
						OnElfXbowRepellTargs();
					}
				}
			}
		}
		ELF_XBOW_SHOT = false;

		if (ELF_GUIDED_ACTIVE)
		{
			// (never true here, the rest is skipped) if ELF_GUIDED_EFFECT isnot 'ELF_GUIDED_EFFECT'
		}
		return result;
	}

	// dbolt_dodamage
	void ElfWizardBase_OnDboltDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		Vector3 targOrg = OriginOf(target);
		float targAng = AnglesTo(ELF_XBOW_REPELL_POINT, targOrg);

		float targDist = Divide(Distance(targOrg, ELF_XBOW_REPELL_POINT), 128.0f);
		float pushStr = Float(LegacyFunction("get_skill_ratio", targDist, 500, 100));
		float halfPushStr = Divide(pushStr, 2.0f);
		DebugPrint("game_dodamage str " + Text(pushStr) + " ratio " + Text(targDist));
		SetVelocity(target, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, pushStr, halfPushStr)));
	}

	// npcatk_hunt
	// ==================================== Main Cycle
	void ElfWizardBase_OnNpcatkHunt()
	{
		bool exitSub = false;

		if (NPCATK_TARGET == "unset")
			return;

		if (!CanSee(NPCATK_TARGET))
			return;

		if (ELF_CAN_GUIDED && !ELF_GUIDED_ACTIVE && GameTime() > NEXT_GUIDED)
		{
			NEXT_GUIDED = GameTime() + FREQ_GUIDED;
			OnSetupGuided();
			exitSub = true;
		}

		if (ELF_BEAM_ATTACK && !ELF_BEAM_ON && RangeTo(NPCATK_TARGET) < ELF_BEAM_RANGE)
		{
			Vector3 traceStart = AttachmentPositionOf(ENT_ME, ATTACH_STAFF_TIP);
			Vector3 traceEnd = OriginOf(NPCATK_TARGET);
			string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
			if (traceLine == Text(traceEnd))
			{
				OnElfDoBeam();
				exitSub = true;
			}
		}
		if (exitSub)
			return;

		if (ELF_IS_ARCHER && RangeTo(NPCATK_TARGET) < 32.0f && GameTime() > NEXT_XBOW_BASH)
		{
			NEXT_XBOW_BASH = GameTime() + FREQ_XBOW_BASH;
			AS_ATTACKING = GameTime() + 5.0f;
			PlayAnim("critical", ANIM_MELEE);
			exitSub = true;
		}
		if (exitSub)
			return;
	}

	// setup_guided
	// ==================================== Guided Spell
	// guided magic cloud that pushes and does damage
	// similar system to guided fire ball, but does not explode
	void ElfWizardBase_OnSetupGuided()
	{
		SetProp(ENT_ME, "controller2", 100);
		OnNpcatkSuspendMovement(ANIM_SPELL_LEFT_HOLD);
		PlayAnim("critical", ANIM_RELEASE_EGG);
		CallEventDelayed(0.3f, "setup_guided2");
	}

	// setup_guided2
	void ElfWizardBase_OnSetupGuided2()
	{
		float nTypes = GetTokenCount(ELF_GUIDED_TYPES) - 1.0f;
		int rndType = RandomInt(0, int(nTypes));
		ELF_GUIDED_TYPE = GetToken(ELF_GUIDED_TYPES, rndType);
		ELF_GUIDED_DOT = GetToken(ELF_GUIDED_DOTS, rndType);
		ELF_GUIDED_ACTIVE = true;
		CFB_FIRST_TARGET_FOUND = false;
		CFB_EST_ORG = RelativePosition(Vector3(0, 32, 40));
		Vector3 startAngs = AnglesOf(ENT_ME);
		CFB_EST_ANG = Text(startAngs);
		ClientEvent("new", "all", ELF_GUIDED_SCRIPT, CFB_EST_ORG, startAngs, ELF_GUIDED_TYPE, IndexOf(ENT_ME), ATTACH_LHAND, IndexOf(NPCATK_TARGET));
		CFB_FIREBALL_IDX = LastClientScriptId();
		CallEventDelayed(0.1f, "cfb_fireball_loop");
		CFB_FORCE_END = GameTime() + ELF_GUIDED_DURATION;
	}

	// cfb_fireball_loop
	void ElfWizardBase_OnCfbFireballLoop()
	{
		Vector3 targOrg = Vec("TARG_ORG");
		Vector3 angToTarg = Vec("ANG_TO_TARG");
		if (!ELF_GUIDED_ACTIVE)
			return;

		if (IsAlive(CFB_TARGET))
			SetMoveDest(@CFB_TARGET, 9999);
		else
			SetMoveDest(CFB_EST_ORG, 9999);

		CallEventDelayed(0.5f, "cfb_fireball_loop");
		if (GameTime() > CFB_NEXT_SCAN)
		{
			CFB_NEXT_SCAN = GameTime() + 2.0f;
			if (!IsAlive(CFB_TARGET))
			{
				Vector3 ownerOrg = OriginOf(ENT_ME);
				string targetTokens = LegacyFunction("get_tsphere", "enemy", 512, CFB_EST_ORG);
				if (targetTokens != "none")
				{
					if (GetTokenCount(targetTokens) > 1) // not important when player is owner, but may prevent targeting same player every time
						targetTokens = TokenShuffle(targetTokens);
					CBaseEntity@ testTarg = FindEntity(GetToken(targetTokens, 0));
					if (IsAlive(testTarg) && !Truthy(ScriptVarOf(testTarg, "PLAYING_DEAD")))
					{
						@CFB_TARGET = testTarg;
						// dbg *** cfb_fireball_loop: targeting $get(CFB_TARGET,id)
						if (!CFB_FIRST_TARGET_FOUND)
						{
							CFB_FIRST_TARGET_FOUND = true;
							angToTarg = Angles3DTo(CFB_EST_ORG, targOrg);
						}
					}
				}
			}
		}

		DoDamageEx(CFB_EST_ORG, 128, ELF_GUIDED_DMG, 0, ENT_ME, ENT_ME, "none", GetVar("ELF_GUIDED_DMG_TYPE"));

		if (IsAlive(CFB_TARGET))
		{
			targOrg = OriginOf(CFB_TARGET);
			if (!IsPlayer(CFB_TARGET)) // aim for the heads of monsters
				targOrg.z += HeightOf(CFB_TARGET);
			angToTarg = Angles3DTo(CFB_EST_ORG, targOrg);
			angToTarg.x = -angToTarg.x;
			CFB_EST_ANG = Text(angToTarg);
			CFB_EST_ORG += RelativeVelocity(angToTarg, Vector3(0, CFB_SPEED, 0));
		}
		else
		{
			CFB_EST_ORG += RelativeVelocity(Vec(CFB_EST_ANG), Vector3(0, CFB_SPEED, 0));
			angToTarg = Vec(CFB_EST_ANG);
		}

		ClientEvent("update", "all", CFB_FIREBALL_IDX, "svr_update_fireball_vec", angToTarg, CFB_EST_ORG, IndexOf(CFB_TARGET));

		// hopefully we can just pass through walls without losing our sprite
		// local TRACE_DEST CFB_EST_ORG
		// vectoradd TRACE_DEST $relvel(CFB_EST_ANG,$vec(0,60,0))
		// local TRACE_RESULT $get_traceline(CFB_EST_ORG,TRACE_DEST,worldonly)
		// if ( TRACE_RESULT isnot TRACE_DEST ) callevent cfb_explode "hitwall"
		if (GameTime() > CFB_FORCE_END)
		{
			ELF_GUIDED_ACTIVE = false;
			CallEventDelayed(1.0f, "npcatk_resume_movement");
			ClientEvent("update", "all", CFB_FIREBALL_IDX, "fireball_end");
			SetProp(ENT_ME, "controller2", 120);
		}
	}

	// cfb_fireball_end
	// { cfb_explode
	// //do next special sooner
	// setvard NEXT_SPECIAL game.time
	// add NEXT_SPECIAL 1.0
	// setvard ELF_GUIDED_ACTIVE 0
	// //if ( G_DEVELOPER_MODE ) gplayermessage ent_me Fireball Explode: PARAM1
	// clientevent update all CFB_FIREBALL_IDX fireball_explode
	// callevent 0.1 cfb_fireball_release
	// //scan/dodamage aoe here
	// setvard CFB_LIST $get_tsphere(enemy,128,CFB_EST_ORG)
	// if CFB_LIST isnot none
	// if $get_token_amt(CFB_LIST) > 0
	// }
	void ElfWizardBase_OnCfbFireballEnd()
	{
		DebugPrint("cfb_fireball_end");
		ClientEvent("update", "all", CFB_FIREBALL_IDX, "fireball_end");
		CallEventDelayed(0.1f, "cfb_fireball_release");
	}

	// cfb_fireball_release
	void ElfWizardBase_OnCfbFireballRelease()
	{
		DebugPrint("cfb_fireball_release");
		ELF_GUIDED_ACTIVE = false;
	}

	// game_damaged
	// ==================================== Struck / Damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type
	string ElfWizardBase_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		PlaySound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);

		if (!ELF_PALM_ATTACK)
			return result;
		if (!Exists(attacker)) // shouldn't need to do this, but checking isalive vs. map entities causes error
			return result;
		if (!IsAlive(attacker))
			return result;

		if (RangeTo(attacker) < ELF_PALM_RANGE)
		{
			@ELF_PALM_TARGET = attacker;
			SetMoveDest(@attacker, 9999);
			PlayAnim("once", ANIM_REPELL);
		}
		return result;
	}

	// elf_do_beam
	// ==================================== Beam Attack
	void ElfWizardBase_OnElfDoBeam()
	{
		BEAM_TARGET = NPCATK_TARGET;
		OnNpcatkSuspendMovement(ANIM_SPELL_HOLD);
		OnNpcatkSuspendAi();
		ELF_BEAM_ON = true;
		float attachStaffTip = ATTACH_STAFF_TIP + 1.0f; // effect beam attach indexes are base index 1 :/
		Effect("beam", "ents", "lgtning.spr", 50, ENT_ME, attachStaffTip, BEAM_TARGET, 1, ELF_BEAM_COLOR, 200, 30, ELF_BEAM_DUR);
		ClientEvent("new", "all", "effects/sfx_beam_sparks", IndexOf(ENT_ME), IndexOf(BEAM_TARGET), ATTACH_STAFF_TIP, ELF_BEAM_COLOR, ELF_BEAM_DUR);
		CallEventDelayed(ELF_BEAM_DUR, "elf_beam_end");
		OnElfBeamLoop();
		PlaySound(2, 10, SOUND_ELF_BEAM_START);
		ServerPlaySound(1, 10, GetVar("SOUND_ELF_BEAM_LOOP")); // precache this in top script
	}

	// elf_beam_end
	void ElfWizardBase_OnElfBeamEnd()
	{
		ELF_BEAM_ON = false;
		OnNpcatkResumeAi();
		OnNpcatkResumeMovement();
		ServerPlaySound(1, 0, GetVar("SOUND_ELF_BEAM_LOOP"));
	}

	// elf_beam_loop
	void ElfWizardBase_OnElfBeamLoop()
	{
		if (!ELF_BEAM_ON)
			return;
		CallEventDelayed(0.25f, "elf_beam_loop");
		Vector3 traceStart = AttachmentPositionOf(ENT_ME, ATTACH_STAFF_TIP);
		Vector3 traceEnd = OriginOf(BEAM_TARGET);
		string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		SetMoveDest(BEAM_TARGET, 9999);
		if (traceLine != Text(traceEnd))
			return;
		if (ELF_BEAM_SPECIAL == "none")
		{
			ApplyEffect(BEAM_TARGET, ELF_BEAM_EFFECT, 5.0f, self, ELF_BEAM_DOT);
		}
		else
		{
			OnElfBeamSpecial(BEAM_TARGET); // used by top script
		}
		DoDamage(BEAM_TARGET, "direct", ELF_BEAM_DMG, "100%", ELF_BEAM_DMG_TYPE);
		AddVelocity(BEAM_TARGET, ELF_BEAM_PUSH_VEL);
	}

	// ext_con
	// ==================================== Debugarry
	void ElfWizardBase_OnExtCon(float controllerIndex = 0.0f, string controllerValue = "")
	{
		DebugPrint("got ext_con " + Text(controllerIndex) + " " + controllerValue);
		if (controllerIndex == 0.0f)
			SetProp(ENT_ME, "controller0", controllerValue);
		if (controllerIndex == 1.0f)
			SetProp(ENT_ME, "controller1", controllerValue);
		if (controllerIndex == 2.0f)
			SetProp(ENT_ME, "controller2", controllerValue);
		if (controllerIndex == 3.0f)
			SetProp(ENT_ME, "controller3", controllerValue);
	}

	// close_mouth
	void ElfWizardBase_OnCloseMouth()
	{
		SetProp(ENT_ME, "controller1", 0);
	}

	// game_death
	void ElfWizardBase_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		int rndDeath = RandomInt(1, 7);
		if (rndDeath == 1)
			ANIM_DEATH = ANIM_DEATH1;
		if (rndDeath == 2)
			ANIM_DEATH = ANIM_DEATH2;
		if (rndDeath == 3)
			ANIM_DEATH = ANIM_DEATH3;
		if (rndDeath == 4)
			ANIM_DEATH = ANIM_DEATH4;
		if (rndDeath == 5)
			ANIM_DEATH = ANIM_DEATH5;
		if (rndDeath == 6)
			ANIM_DEATH = ANIM_DEATH6;
		if (rndDeath == 7)
			ANIM_DEATH = ANIM_DEATH7;

		if (!ELF_GUIDED_ACTIVE)
			return;
		ELF_GUIDED_ACTIVE = false;
		ClientEvent("update", "all", CFB_FIREBALL_IDX, "fireball_end");
	}

	// npc_targetsighted
	void ElfWizardBase_OnNpcTargetsighted(string target = "")
	{
		if (ELF_XBOW_CL_SCRIPT_ID == "ELF_XBOW_CL_SCRIPT_ID")
		{
			ClientEvent("new", "all", ELF_XBOW_CL_SCRIPT, 40.0f);
			NEXT_SCRIPT_UPDATE = GameTime() + 40.0f;
			ELF_XBOW_CL_SCRIPT_ID = LastClientScriptId();
		}
		else if (GameTime() > NEXT_SCRIPT_UPDATE)
		{
			ELF_XBOW_CL_SCRIPT_ID = "ELF_XBOW_CL_SCRIPT_ID"; // refresh on next sight
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePrecache() { ElfWizardBase_OnGamePrecache(); } // game_precache

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		ElfWizardBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		ElfWizardBase_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		ElfWizardBase_OnNpcatkHunt();
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, ElfWizardBase_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, ElfWizardBase_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		ElfWizardBase_OnNpcTargetsighted(target);
	}

	void OnFrameXbowShootStand() { ElfWizardBase_OnFrameXbowShootStand(); } // frame_xbow_shoot_stand
	void OnFrameXbowShootCrouch() { ElfWizardBase_OnFrameXbowShootCrouch(); } // frame_xbow_shoot_crouch
	void OnFrameXbowReloadNow() { ElfWizardBase_OnFrameXbowReloadNow(); } // frame_xbow_reload_now
	void OnFrameXbowReloaded() { ElfWizardBase_OnFrameXbowReloaded(); } // frame_xbow_reloaded
	void OnFrameRepell() { ElfWizardBase_OnFrameRepell(); } // frame_repell
	void OnFrameMelee() { ElfWizardBase_OnFrameMelee(); } // frame_melee
	void OnElfShootXbow() { ElfWizardBase_OnElfShootXbow(); } // elf_shoot_xbow
	void OnElfDoExplode() { ElfWizardBase_OnElfDoExplode(); } // elf_do_explode
	void OnDboltDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { ElfWizardBase_OnDboltDodamage(hit, target, start, end, damageType, damageText); } // dbolt_dodamage
	void OnSetupGuided() { ElfWizardBase_OnSetupGuided(); } // setup_guided
	void OnSetupGuided2() { ElfWizardBase_OnSetupGuided2(); } // setup_guided2
	void OnCfbFireballLoop() { ElfWizardBase_OnCfbFireballLoop(); } // cfb_fireball_loop
	void OnCfbFireballEnd() { ElfWizardBase_OnCfbFireballEnd(); } // cfb_fireball_end
	void OnCfbFireballRelease() { ElfWizardBase_OnCfbFireballRelease(); } // cfb_fireball_release
	void OnElfDoBeam() { ElfWizardBase_OnElfDoBeam(); } // elf_do_beam
	void OnElfBeamEnd() { ElfWizardBase_OnElfBeamEnd(); } // elf_beam_end
	void OnElfBeamLoop() { ElfWizardBase_OnElfBeamLoop(); } // elf_beam_loop
	void OnExtCon(float controllerIndex = 0.0f, string controllerValue = "") { ElfWizardBase_OnExtCon(controllerIndex, controllerValue); } // ext_con
	void OnCloseMouth() { ElfWizardBase_OnCloseMouth(); } // close_mouth
	void OnElfBeamDur() {} // ELF_BEAM_DUR
	void OnElfBeamSpecial(string target = "") {} // elf_beam_special
	void OnElfSpawn() {} // elf_spawn
	void OnElfXbowRepellTargs() {} // elf_xbow_repell_targs

	// This file's events and timers by their .script names
	bool ElfWizardBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "cfb_fireball_end") { OnCfbFireballEnd(); return true; }
		if (name == "cfb_fireball_loop") { OnCfbFireballLoop(); return true; }
		if (name == "cfb_fireball_release") { OnCfbFireballRelease(); return true; }
		if (name == "close_mouth") { OnCloseMouth(); return true; }
		if (name == "dbolt_dodamage") { OnDboltDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "elf_beam_end") { OnElfBeamEnd(); return true; }
		if (name == "elf_beam_loop") { OnElfBeamLoop(); return true; }
		if (name == "elf_do_beam") { OnElfDoBeam(); return true; }
		if (name == "elf_do_explode") { OnElfDoExplode(); return true; }
		if (name == "elf_shoot_xbow") { OnElfShootXbow(); return true; }
		if (name == "ext_con") { OnExtCon(Float(Param(params, 0)), Param(params, 1)); return true; }
		if (name == "frame_melee") { OnFrameMelee(); return true; }
		if (name == "frame_repell") { OnFrameRepell(); return true; }
		if (name == "frame_xbow_reload_now") { OnFrameXbowReloadNow(); return true; }
		if (name == "frame_xbow_reloaded") { OnFrameXbowReloaded(); return true; }
		if (name == "frame_xbow_shoot_crouch") { OnFrameXbowShootCrouch(); return true; }
		if (name == "frame_xbow_shoot_stand") { OnFrameXbowShootStand(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "setup_guided") { OnSetupGuided(); return true; }
		if (name == "setup_guided2") { OnSetupGuided2(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/elf_wizard_base"]
shared class ElfWizardBaseScript : BaseMonsterNewScript, ElfWizardBase
{
	// Variables declared by included files, with the value they start with in this script
	ElfWizardBaseScript()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk2handed";
		SOUND_DEATH = "voices/human/male_die.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/bows/boltexplosive.mdl");
		Precache("explode1.spr");
		Precache("rain_ripple.spr");
		Precache("3dmflaora.spr");
		Precache("npc/elf_m_wizard.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ElfWizardBase_FirstThink();
		ElfWizardBase_FirstThink2();
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
		return ElfWizardBase_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
