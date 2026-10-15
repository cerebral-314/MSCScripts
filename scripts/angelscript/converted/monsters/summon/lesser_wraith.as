#pragma context server

// Converted from monsters/summon/lesser_wraith.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_noclip.as"

[script "monsters/summon/lesser_wraith"]
class LesserWraith : BaseMonsterNewScript, BaseNoclip, BasePropelled
{
	// Constants
	bool NPC_EXTRA_VALIDATIONS = true;
	bool BASENOCLIP_NO_SETMOVEDEST = true;
	int FWD_SPEED_STANDARD = 20;
	string CL_SCRIPT = "monsters/summon/lesser_wraith_cl";
	float FREQ_ROAM = 0.0f;
	string SOUND_MOAN = "crow/ghostwail.wav";
	string SOUND_DRAIN_START = "crow/Triggered/tomb5.wav";
	string SOUND_DRAIN_LOOP = "x/x_teleattack1.wav";
	string SOUND_HOVER_LOOP = "ambience/labdrone2.wav";
	string SOUND_KILL = "houndeye/he_blast3.wav";
	string SOUND_TELE = "magic/teleport.wav";

	// Variables (an unset .script variable reads as its own name)
	int I_R_PET = 0;
	bool NPC_BATTLE_ALLY = false;
	string ANIM_ATTACK = "ANIM_ATTACK";
	float FWD_SPEED = 0.0f;
	float DMG_DRAIN = 0.0f;
	float MP_DRAIN_AMT = 0.0f;
	bool IS_UNHOLY = false;
	string OLD_WRAITH_TARG = "OLD_WRAITH_TARG";
	bool AM_DRAINING = false;
	string MY_CL_IDX = "MY_CL_IDX";
	float LASTATK_MESSAGE = 0.0f;
	string MY_OWNER = "MY_OWNER";
	float NEXT_READY = 0.0f;
	string NAMEPREFIX = "NAMEPREFIX";
	string INITIAL_ORIGIN = "INITIAL_ORIGIN";
	Vector3 NPC_NOCLIP_DEST = Vector3();
	string WRAITH_OLD_TARG = "WRAITH_OLD_TARG";
	bool NPC_PROPELL_SUSPEND = false;
	Vector3 HOLD_POS = Vector3();
	string LAST_OWNER_YAW = "LAST_OWNER_YAW";
	Vector3 OWNER_OLD_POS = Vector3();
	float NEXT_SCAN = 0.0f;
	bool FOLLOW_MODE = false;

	// Variables declared by included files, with the value they start with in this script
	LesserWraith()
	{
		ANIM_RUN = "wraith_idle";
		ANIM_IDLE = "wraith_idle";
		ANIM_WALK = "wraith_idle";
		SOUND_DEATH = "ichy/ichy_die2.wav";
	}

	// unnamed block (first think)
	void LesserWraith_FirstThink()
	{
		ANIM_RUN = "wraith_idle";
		ANIM_IDLE = "wraith_idle";
		ANIM_WALK = "wraith_idle";
	}

	// unnamed block (first think)
	void LesserWraith_FirstThink2()
	{
		I_R_PET = 1;

		NPC_NO_PLAYER_DMG = true;
		NPC_BATTLE_ALLY = true;

		ANIM_ATTACK = "wraith_attack";
		ANIM_DEATH = "wraith_idle";

		ATTACK_RANGE = 128.0f;
		ATTACK_MOVERANGE = 100.0f;
		ATTACK_HITRANGE = 150.0f;
		NPC_GIVE_EXP = 0.0f;
		FWD_SPEED = 20.0f;
		DMG_DRAIN = 10.0f; // for monsters
		MP_DRAIN_AMT = 1.0f; // for players
	}

	// turn_undead
	void OnTurnUndead(float holyDamage = 0.0f, CBaseEntity@ exorcist = null)
	{
		MonstersExternals_OnTurnUndead(holyDamage, exorcist); // monsters/externals
		// (always true here) if !NOT_SUMMONED
		float dmgHoly = MaxHealthOf(ENT_ME) * 2.0f;
		DoDamageEx(ENT_ME, "direct", 1000, "100%", @exorcist, @exorcist, "spellcasting.divination", "holy");
	}

	// bs_global_command
	void OnBsGlobalCommand(CBasePlayer@ deadPlayer = null, string command = "", string reason = "")
	{
		MonstersExternals_OnBsGlobalCommand(deadPlayer, command, reason); // monsters/externals
		bool endedWraith = false;
		if (EntityId(deadPlayer) != MY_OWNER)
			return;

		if (command == "vanish")
		{
			OnEndWraith();
			endedWraith = true;
		}
		if (endedWraith)
			return;

		PlaySound(0, 10, SOUND_KILL);

		if (command == "follow")
		{
			if (NPCATK_TARGET == "unset")
				PlayerMessageGreen(MY_OWNER, "Lesser Wraith set non agro.");
			else
				PlayerMessageGreen(MY_OWNER, "Lesser Wraith disengaging.");

			NPCATK_TARGET = "unset";
			FOLLOW_MODE = true;
			OnZapToOwner();
		}

		if (command == "hunt")
		{
			PlayerMessageGreen(MY_OWNER, "Lesser Wraith set agro.");
			FOLLOW_MODE = false;
		}

		if (command == "defend")
		{
			PlayerMessageGreen(MY_OWNER, "Lesser Wraith set defensive.");
			FOLLOW_MODE = false;
		}

		if (command == "report")
		{
			string healthString = Text(int(HealthOf(ENT_ME))) + "/" + int(MaxHealthOf(ENT_ME)) + "hp";
			PlayerMessageGreen(MY_OWNER, "Lesser Wraith Reports: " + healthString);
		}
	}

	// game_dynamically_created
	// <owner> <start_pos>
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		MY_OWNER = creatorValue1;

		CallEventDelayed(0.1f, "circle_in");

		NEXT_READY = GameTime() + 2.0f;

		NAMEPREFIX = NameOf(MY_OWNER) + "'s" + " " + NameOf(ENT_ME);

		SetName(NAMEPREFIX);

		INITIAL_ORIGIN = creatorValue2;
		CallEventDelayed(0.1f, "set_first_origin");
		CallEventDelayed(300.0f, "end_wraith");

		CallExternal(MY_OWNER, "ext_wraith_active", 1);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Lesser Wraith");
		SetModel("weapons/projectiles.mdl");
		SetModelBody(0, 72);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		PlayAnim("once", ANIM_IDLE);
		SetWidth(0);
		SetHeight(0);
		SetBoundingBox(Vector3(0, 0, 0), Vector3(0, 0, 0));
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
		IMMUNE_VAMPIRE = true;
		IS_UNHOLY = true;

		SetMenuAutoOpen(true);

		SetBlood("none");

		SetHealth(1000);
		SetRace("human");

		SetDamageTaken("slash", 0.25f);
		SetDamageTaken("pierce", 0.25f);
		SetDamageTaken("blunt", 0.25f);
		SetDamageTaken("fire", 0.25f);
		SetDamageTaken("cold", 0.25f);
		SetDamageTaken("generic", 0.25f);
		SetDamageTaken("poison", 0);
		SetDamageTaken("lightning", 3);
		SetDamageTaken("holy", 4);
		SetDamageTaken("stun", 0);

		SetSolid("none");

		SetNoPush(true);

		SetGravity(0);

		SetRoam(false);

		SetHearingSensitivity(11);

		OLD_WRAITH_TARG = "unset";

		CallEventDelayed(1.0f, "sustain_renderprops");

		CallEventDelayed(0.5f, "do_manual_roam");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		bool removeMe = false;
		bool exitSub = false;
		float myZ = 0.0f;
		float targetZ = 0.0f;
		Vector3 myOrg = Vec("MY_ORG");

		CYCLE_TIME = "0.1";

		if (!Exists(MY_OWNER))
			removeMe = true;
		if (!IsAlive(MY_OWNER))
			removeMe = true;
		if (removeMe)
			OnEndWraith();
		if (removeMe)
			return;

		FWD_SPEED = FWD_SPEED_STANDARD;

		if (IS_FLEEING)
			NPC_NOCLIP_DEST = Vec(Eval("game.monster.movedest.origin"));

		if (NPCATK_TARGET != "unset")
		{
			if (NPCATK_TARGET != WRAITH_OLD_TARG)
				PlayerMessage(MY_OWNER, "Your Lesser Wraith has targeted " + FullNameOf(NPCATK_TARGET));
			WRAITH_OLD_TARG = NPCATK_TARGET;

			NPC_PROPELL_SUSPEND = false;
			if (RangeTo(NPCATK_TARGET) < ATTACK_MOVERANGE)
				FWD_SPEED = 0.0f;
			else
				FWD_SPEED = FWD_SPEED_STANDARD;

			if (RangeTo(NPCATK_TARGET) > 1024.0f)
			{
				NPCATK_TARGET = "unset";
				OnZapToOwner();
				exitSub = true;
			}
			if (!exitSub)
			{
				// adjust vertical
				myZ = OriginOf(ENT_ME).z;
				targetZ = OriginOf(NPCATK_TARGET).z;
				if (IsPlayer(NPCATK_TARGET))
					targetZ -= 46.0f;
				myOrg = OriginOf(ENT_ME);
				myOrg.z = targetZ;
				SetOrigin(ENT_ME, myOrg);

				if (RangeTo(NPCATK_TARGET) < 55.0f)
				{
					// setvard IS_FLEEING 1
					// callevent npcatk_suspend_ai 1.0
					// setvard FWD_SPEED 50
					// setvard NPC_NOCLIP_DEST $get(NPCATK_TARGET,origin)
					// local RND_ANG $randf(0,359.99)
					// teleport away from targets stuck inside you
					float rndAng = Random(0, 359.99f);
					NPC_NOCLIP_DEST += RelativePosition(Vector3(0, rndAng, 0), Vector3(0, 80, 0));
					NPC_NOCLIP_DEST.z = targetZ;
					SetOrigin(ENT_ME, NPC_NOCLIP_DEST);
					PlaySound(0, 10, SOUND_TELE);
				}
				else
				{
					IS_FLEEING = false;
					NPC_NOCLIP_DEST = OriginOf(NPCATK_TARGET);
					NPC_NOCLIP_DEST.z = targetZ;
				}
			}
		}

		if (NPCATK_TARGET != "unset")
			return;

		myOrg = OriginOf(ENT_ME);
		HOLD_POS = OriginOf(MY_OWNER);
		if (RangeTo(MY_OWNER) > 64.0f)
		{
			LAST_OWNER_YAW = Text(ViewAnglesOf(MY_OWNER));
			LAST_OWNER_YAW = Text(Vec(LAST_OWNER_YAW).y);
		}

		if (Float(Text(OWNER_OLD_POS)) != Float(Text(OriginOf(MY_OWNER))))
		{
			// owner is moving, stay behind him
			LAST_OWNER_YAW = Text(ViewAnglesOf(MY_OWNER));
			LAST_OWNER_YAW = Text(Vec(LAST_OWNER_YAW).y);
		}

		HOLD_POS += RelativePosition(Vector3(0, Float(LAST_OWNER_YAW), 0), Vector3(0, -48, -20));

		float ownerGround = Float(Text(OriginOf(MY_OWNER)));
		ownerGround = GroundHeight(Vec(Text(ownerGround))) + 10.0f;
		HOLD_POS.z = ownerGround;

		if (Distance(myOrg, HOLD_POS) < 64.0f)
		{
			// dbg holding
			SetMoveDest("none");
			FWD_SPEED = 0.0f;
			string curYawText = Text(ViewAnglesOf(MY_OWNER));
			float curYaw;
			curYaw = Vec(curYawText).y;
			SetAngle("face", Vector3(0, curYaw, 0));
			NPC_PROPELL_SUSPEND = true;
			SetOrigin(ENT_ME, HOLD_POS);
		}
		else
		{
			// dbg moving to snuggy $dist(MY_ORG,HOLD_POS)
			// snap z
			myZ = OriginOf(ENT_ME).z;
			targetZ = HOLD_POS.z;
			myOrg.z = targetZ;
			SetOrigin(ENT_ME, myOrg);

			NPC_PROPELL_SUSPEND = false;
			FWD_SPEED = FWD_SPEED_STANDARD;
			NPC_NOCLIP_DEST = HOLD_POS;
			SetMoveDest(HOLD_POS);
		}
		OWNER_OLD_POS = OriginOf(MY_OWNER);

		// local MY_ORG $get(ent_me,origin)
		// dbg $dist(MY_ORG,NPC_NOCLIP_DEST) WANDER_ROT
		// if ( $dist(MY_ORG,NPC_NOCLIP_DEST) < 40 )
		// {
		// //if game.time > NEXT_WANDER_ROT_ADJ
		// //setvard NEXT_WANDER_ROT_ADJ game.time
		// //add NEXT_WANDER_ROT_ADJ 0.25 //give him time to get away from the point
		// add WANDER_ROT 20
		// if ( WANDER_ROT >= 360 ) setvard WANDER_ROT 0
		// }
		// if ( $get(MY_OWNER,range) > 1024 )
		// {
		// setorigin ent_me NPC_NOCLIP_DEST
		// callevent 0.5 delay_tele_sound
		// }
		if (GameTime() > NEXT_SCAN)
		{
			NEXT_SCAN = GameTime() + 5.0f;

			CBaseEntity@ ownerTarg = TargetOf(MY_OWNER);
			if (RelationshipOf(ownerTarg, MY_OWNER) == "enemy")
			{
				NPCATK_TARGET = EntityId(ownerTarg);
				OnNpcatkTargetvalidate(NPCATK_TARGET);
			}

			if (NPCATK_TARGET == "unset") // failed validation
			{
				string targList = LegacyFunction("get_tsphere", "enemy", 768, MyOrigin());
				targList = SortEntities(targList, "range");
				NPCATK_TARGET = GetToken(targList, 0);
				OnNpcatkTargetvalidate(NPCATK_TARGET);
			}
		}
	}

	// npc_targetvalidate
	void OnNpcTargetvalidate(CBaseEntity@ target = null)
	{
		BaseMonsterShared_OnNpcTargetvalidate(target); // monsters/base_monster_shared
		bool exitSub = false;
		bool goHostile = false;
		if (FOLLOW_MODE)
		{
			NPCATK_TARGET = "unset";
			exitSub = true;
		}

		if (RaceOf(NPCATK_TARGET) == "hguard")
		{
			// don't attack guards unless they are picking on you, your master, or his friends
			string hguardTarget = ScriptVarOf(NPCATK_TARGET, "NPCATK_TARGET");
			if (hguardTarget == MY_OWNER)
				goHostile = true;
			if (hguardTarget == EntityId(self))
				goHostile = true;
			if (RelationshipOf(hguardTarget, MY_OWNER) == "ally")
				goHostile = true;
			if (!goHostile)
			{
				NPCATK_TARGET = "unset";
				exitSub = true;
			}
		}

		if (exitSub)
			return;

		if (OLD_WRAITH_TARG == NPCATK_TARGET)
			return;

		// anything beyond my master's LOS is invalid
		if (!IsAlive(NPCATK_TARGET))
			return;

		Vector3 traceStart = OriginOf(MY_OWNER);
		Vector3 traceEnd = OriginOf(NPCATK_TARGET);
		float halfHeight = HeightOf(NPCATK_TARGET) * 0.5f;
		traceEnd.z += halfHeight;
		string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		if (traceLine != Text(traceEnd))
			NPCATK_TARGET = OLD_WRAITH_TARG;
		else
			OLD_WRAITH_TARG = NPCATK_TARGET;
	}

	// sustain_renderprops
	void OnSustainRenderprops()
	{
		// in case a glow shell renders invisible, also handle sound loop here
		if (!IsAlive(ENT_ME))
			return;
		CallEventDelayed(5.0f, "sustain_renderprops");
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
		ServerPlaySound(3, 10, SOUND_HOVER_LOOP);
		if (RandomInt(1, 10) == 1)
			PlaySound(0, 10, SOUND_MOAN);
	}

	// npc_death
	void OnNpcDeath()
	{
		AM_DRAINING = false;
		SetAnimFrameRate(0);
		FWD_SPEED = 0.0f;
		CallExternal(GetVar("GAME_MASTER"), "gm_fade", self, 5, 128);
		PlaySound(1, 10, SOUND_DEATH);
		ServerPlaySound(2, 0, SOUND_DRAIN_LOOP);
		ServerPlaySound(3, 0, SOUND_HOVER_LOOP);
		if (Float(MY_CL_IDX) != 0.0f)
			ClientEvent("update", "all", MY_CL_IDX, "end_fx");
		if (!IsAlive(MY_OWNER))
			return;
		CallExternal(MY_OWNER, "ext_wraith_active", 0);
	}

	// frame_attack_start
	void OnFrameAttackStart()
	{
		ServerPlaySound(2, 10, SOUND_DRAIN_LOOP);
		OnStartDrainAttack();
	}

	// frame_attack_end
	void OnFrameAttackEnd()
	{
		OnEndDrainAttack();
	}

	// end_drain_attack
	void OnEndDrainAttack()
	{
		ServerPlaySound(2, 0, SOUND_DRAIN_LOOP);
		ClientEvent("update", "all", MY_CL_IDX, "end_fx");
		AM_DRAINING = false;
		MY_CL_IDX = "0";
	}

	// start_drain_attack
	void OnStartDrainAttack()
	{
		ClientEvent("new", "all", CL_SCRIPT, IndexOf(ENT_ME), IndexOf(NPCATK_TARGET), ATTACK_HITRANGE);
		MY_CL_IDX = LastClientScriptId();
		AM_DRAINING = true;
		OnDrainAttackLoop();
	}

	// drain_attack_loop
	void OnDrainAttackLoop()
	{
		if (!AM_DRAINING)
			return;
		CallEventDelayed(0.5f, "drain_attack_loop");
		if (IsPlayer(NPCATK_TARGET))
		{
			bool seeTarget = CanSee(NPCATK_TARGET);

			if (seeTarget && RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE)
			{
				GiveMana(NPCATK_TARGET, -MP_DRAIN_AMT);
				if (GameTime() > LASTATK_MESSAGE)
				{
					LASTATK_MESSAGE = GameTime() + 2.0f;
					PlayerMessage(NPCATK_TARGET, "Your soul is being drained!");
					Effect("screenfade", NPCATK_TARGET, 2, 1, Vector3(0, 0, 255), 180, "fadein");
				}
				if (ManaOf(NPCATK_TARGET) <= 0.0f)
					OnSlayTarget();
			}
		}
		else if (CanSee(NPCATK_TARGET))
			DoDamage(NPCATK_TARGET, "direct", DMG_DRAIN, "100%", ENT_ME, "dark");

		if (IsAlive(MY_OWNER) && ManaOf(MY_OWNER) < MaxManaOf(MY_OWNER))
			GiveMana(MY_OWNER, 5);

		if (!IsAlive(NPCATK_TARGET))
			OnEndDrainAttack();
	}

	// slay_target
	void OnSlayTarget()
	{
		if (!IsPlayer(NPCATK_TARGET))
			return;
		OnEndDrainAttack();
		PlayerMessage(NPCATK_TARGET, "Your soul has been drained.");
		// figure slay target function here (maybe new code-side function)
		DoDamage(NPCATK_TARGET, "direct", 99999, "100%", ENT_ME, "target");
		CallExternal(NPCATK_TARGET, "ext_playsound_kiss", 1, 10, SOUND_KILL);
		PlaySound(0, 10, SOUND_MOAN);
	}

	// set_first_origin
	void OnSetFirstOrigin()
	{
		SetOrigin(ENT_ME, Vec(INITIAL_ORIGIN));
	}

	// ext_master_died
	// called by master on death
	void OnExtMasterDied(CBaseEntity@ master = null)
	{
		if (EntityId(master) != MY_OWNER)
			return;
		OnNpcSuicide();
	}

	// delay_tele_sound
	void OnDelayTeleSound()
	{
		PlaySound(0, 10, SOUND_TELE);
	}

	// end_wraith
	void OnEndWraith()
	{
		if (IsAlive(MY_OWNER))
			PlayerMessage(MY_OWNER, "Your wraith has vanished!");
		CallExternal(MY_OWNER, "ext_wraith_active", 0);
		OnNpcSuicide();
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		if (EntityId(player) != MY_OWNER)
			return;

		menuItem.title = "Report Health";
		menuItem.type = "callback";
		menuItem.data = "report";
		menuItem.callback = "bs_global_command";
		RegisterMenuItem(menuItem);

		if (!FOLLOW_MODE)
		{
			if (NPCATK_TARGET == "unset")
			{
				menuItem.title = "Don't Attack";
				menuItem.type = "callback";
				menuItem.data = "follow";
				menuItem.callback = "bs_global_command";
				RegisterMenuItem(menuItem);
			}
			else
			{
				menuItem.title = "Disengage Enemy";
				menuItem.type = "callback";
				menuItem.data = "follow";
				menuItem.callback = "bs_global_command";
				RegisterMenuItem(menuItem);
			}
		}
		else
		{
			menuItem.title = "Attack on Sight";
			menuItem.type = "callback";
			menuItem.data = "hunt";
			menuItem.callback = "bs_global_command";
			RegisterMenuItem(menuItem);
		}

		menuItem.title = "Unsummon";
		menuItem.type = "callback";
		menuItem.data = "vanish";
		menuItem.callback = "bs_global_command";
		RegisterMenuItem(menuItem);
	}

	// zap_to_owner
	void OnZapToOwner()
	{
		NPC_NOCLIP_DEST = OriginOf(MY_OWNER);
		float ownerYaw = Float(Text(ViewAnglesOf(MY_OWNER)));
		ownerYaw = Vec(MY_OWNER).z + Random(-45, 45);
		NPC_NOCLIP_DEST += RelativePosition(Vector3(0, ownerYaw, 0), Vector3(0, -256, 0));
		SetOrigin(ENT_ME, NPC_NOCLIP_DEST);
		CallEventDelayed(0.1f, "delay_tele_sound");
	}

	// circle_in
	void OnCircleIn()
	{
		Vector3 circleOrg = OriginOf(ENT_ME);
		circleOrg.z = GroundHeight(circleOrg);
		ClientEvent("new", "all", "effects/sfx_summon_circle", circleOrg, 3);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		BasePropelled_OnNpcPostSpawn(); // monsters/base_propelled
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseNoclip_OnGameSpawn(playerRace, playerGender); // monsters/base_noclip
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
		Precache("ambience/labdrone2.wav");
		Precache("x/x_teleattack1.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		LesserWraith_FirstThink();
		LesserWraith_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseNoclip_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bs_global_command") { OnBsGlobalCommand(PlayerParam(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "circle_in") { OnCircleIn(); return true; }
		if (name == "delay_tele_sound") { OnDelayTeleSound(); return true; }
		if (name == "drain_attack_loop") { OnDrainAttackLoop(); return true; }
		if (name == "end_drain_attack") { OnEndDrainAttack(); return true; }
		if (name == "end_wraith") { OnEndWraith(); return true; }
		if (name == "ext_master_died") { OnExtMasterDied(EntityParam(params, 0)); return true; }
		if (name == "frame_attack_end") { OnFrameAttackEnd(); return true; }
		if (name == "frame_attack_start") { OnFrameAttackStart(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetvalidate") { OnNpcTargetvalidate(EntityParam(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "set_first_origin") { OnSetFirstOrigin(); return true; }
		if (name == "slay_target") { OnSlayTarget(); return true; }
		if (name == "start_drain_attack") { OnStartDrainAttack(); return true; }
		if (name == "sustain_renderprops") { OnSustainRenderprops(); return true; }
		if (name == "turn_undead") { OnTurnUndead(Float(Param(params, 0)), EntityParam(params, 1)); return true; }
		if (name == "zap_to_owner") { OnZapToOwner(); return true; }
		return BaseNoclip_DispatchEvent(name, params)
			|| BasePropelled_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
