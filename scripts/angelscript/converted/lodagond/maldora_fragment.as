#pragma context server

// Converted from lodagond/maldora_fragment.script by msc_transpiler.
// optimized version of maldora fragment for use in sets of 2-4
// only summons 2 images, 1 minion, most fx are client side
// uses flag to make sure no two fragments are spell spamming at the same time

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MaldoraFragment
{
	// Constants
	int CHAIN_COUNT_LIMIT = 20;
	int AXESKIN_WHITE = 6;
	int AXESKIN_NULL = 5;
	int AXESKIN_LIGHTNING = 4;
	int AXESKIN_POISON = 3;
	int AXESKIN_COLD = 2;
	bool AXESKIN_DARK = true;
	bool AXESKIN_FIRE = false;
	string WAND_LIGHTNING_EFFECT = "effects/dot_lightning";
	string WAND_COLD_EFFECT = "effects/dot_cold";
	string WAND_POISON_EFFECT = "effects/dot_poison";
	string WAND_FIRE_EFFECT = "effects/dot_fire";
	string WAND_DARK_EFFECT = "effects/debuff_stun";
	string NME_LIST = "human;hguard;wildanimal;";
	int FREQ_SPAM = 10;
	bool NO_INTRO = true;
	int NUM_SPELLS = 6;
	int MINION_LIMIT = 1;
	string FINGER_ADJ = "$relpos($vec(0,MY_YAW,0),$vec(0,30,54))";
	string SHADOW_SCRIPT = "ms_wicardoven/maldora_image";
	string MINION_SCRIPT = "monsters/maldora_minion_random";
	int FIN_EXP = 2000;
	string ANIM_LOOK = "look_idle";
	string ANIM_JUMP = "jump";
	string ANIM_LEAP = "long_jump";
	string ANIM_CAST = "ref_shoot_trip";
	string ANIM_ROCK = "ref_shoot_squeak";
	string ANIM_BOLT = "shoot_1";
	string ANIM_WAND = "ref_shoot_crowbar";
	float LAVA_FREQ = 0.0f;
	float SPELL_FREQ = 9.0f;
	float BARRIER_FREQ = 30.0f;
	float DMG_PUSH_BEAM = 0.0f;
	float DMG_CHAIN = 0.0f;
	float DMG_SHOCK = 10.0f;
	int DMG_ROCKS = 0;
	float DMG_WAND = 0.0f;
	string SOUND_SHOCK1 = "debris/zap8.wav";
	string SOUND_SHOCK2 = "debris/zap3.wav";
	string SOUND_SHOCK3 = "debris/zap4.wav";
	string SOUND_BEAM = "weather/Storm_exclamation.wav";
	string SOUND_STRUCK1 = "voices/human/male_hit2.wav";
	string SOUND_STRUCK2 = "voices/human/male_hit1.wav";
	string SOUND_STRUCK3 = "voices/human/male_hit3.wav";
	string SOUND_STRUCK4 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK5 = "weapons/cbar_hitbod1.wav";
	string MONSTER_MODEL = "monsters/maldora.mdl";
	string XSOUND_LEVITATE = "fans/fan4on.wav";
	string XSOUND_SPIN = "magic/fan4_noloop.wav";
	string XSOUND_SUMMON = "magic/volcano_start.wav";
	Vector3 BARRIER_COLOR = Vector3();

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	string ANIM_IDLE = "idle";
	string ANIM_RUN_NORM = "run2";
	string ANIM_WALK_NORM = "walk2handed";
	string ANIM_RUN = "run2";
	string ANIM_WALK = "walk2handed";
	string ANIM_DEATH = "ANIM_DEATH";
	bool NO_SPAWN_STUCK_CHECK = false;
	bool IMMUNE_VAMPIRE = false;
	float DMG_BARRIER = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	string WAND_TARGET = "WAND_TARGET";
	float IMAGES_ALIVE = 0.0f;
	float MINIONS_ALIVE = 0.0f;
	bool NPC_PROX_ACTIVATE = false;
	string NPC_PROXACT_RANGE = "NPC_PROXACT_RANGE";
	bool NPC_PROXACT_IFSEEN = false;
	string NPC_PROXACT_EVENT = "NPC_PROXACT_EVENT";
	bool DEBUG_DID_POSTSPAWN = false;
	bool NPC_PROX_LOOP = false;
	bool NPC_PROXACT_INRANGE = false;
	CBaseEntity@ NPC_PROXACT_PLAYERID = null;
	bool NPC_PROXACT_TRIPPED = false;
	float MALDORA_IDX = 0.0f;
	bool READY_TO_WAIT = false;
	bool DEBUG_START_CONVO = false;
	int DEBUG_CALLED_COMBAT = 0;
	string SPELL_TARGET = "SPELL_TARGET";
	string CL_BEAM_IDX = "CL_BEAM_IDX";
	bool COMBAT_ON = false;
	bool BARRIER_DELAY = false;
	int SPELL_CHOICE = 0;
	float BEAM_COUNT = 0.0f;
	bool BEAM_ON = false;
	float CHAIN_COUNT = 0.0f;
	bool CHAIN_ON = false;
	int G_DEVELOPER = 0;
	string MALDORA_LIST = "MALDORA_LIST";
	bool FELLOW_FRAG_NEARBY = false;
	float G_MALDORA_SPELLTIME = 0.0f;
	bool APPLIED_BEAM = false;
	string BEAM_TARGET = "BEAM_TARGET";
	bool CUR_CHAIN_TARGET = false;
	float NEXT_MINION = 0.0f;
	bool REPULSE_ON = false;
	bool NPC_FORCED_MOVEDEST = false;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	bool NO_MOVE = false;
	bool BARRIER_ON = false;
	string BARRIER_TARGS = "BARRIER_TARGS";
	bool PUSH_BEAM_VISIBLE = false;
	bool GAVE_WARNING = false;
	string CHAIN_LIST = "CHAIN_LIST";
	bool WAND_ATK = false;
	float NEXT_CHAIN_SOUND = 0.0f;
	float NEXT_CHAIN_SHOCK = 0.0f;
	float AS_ATTACKING = 0.0f;
	bool G_MALDORA_SPELLING = false;
	CBaseEntity@ PUSH_BEAM_ID = null;

	// unnamed block (first think)
	void MaldoraFragment_FirstThink()
	{
		IS_UNHOLY = true;

		ANIM_IDLE = "idle";
		ANIM_RUN_NORM = "run2";
		ANIM_WALK_NORM = "walk2handed";
		ANIM_DEATH = "look_idle";
		ANIM_RUN = "run2";
		ANIM_WALK = "walk2handed";

		NO_SPAWN_STUCK_CHECK = true;

		IMMUNE_VAMPIRE = true;
		DMG_BARRIER = 400.0f;
	}

	// game_precache
	void MaldoraFragment_OnGamePrecache()
	{
		// man I wish I knew this worked when I wrote the base script ^_^
		PrecacheFile("monsters/maldora_minion_random");
		PrecacheFile("ms_wicardoven/maldora_image");
		if (AM_UBER)
			PrecacheFile("monsters/maldora_gminion_random");
	}

	// npc_spawn
	void MaldoraFragment_OnNpcSpawn(string npc = "")
	{
		if (AM_UBER)
			return;

		SetName("Fragment of Maldora");
		SetHealth(5000);
		SetRace("demon");
		SetWidth(32);
		SetHeight(86);

		SetBlood("none");

		NPC_GIVE_EXP = FIN_EXP;

		SetRoam(false);

		WAND_TARGET = "unset";

		SetHearingSensitivity(11);

		SetInvincible(true);

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_IDLE); // remember to set back on resume
		PlayAnim("once", ANIM_IDLE);

		SetDamageTaken("all", 0.5f);

		SetDamageTaken("fire", 0);
		SetDamageTaken("poison", 0);
		SetDamageTaken("cold", 0);
		SetDamageTaken("magic", 0);
		SetDamageTaken("lightning", 0);
		SetDamageTaken("acid", 0);
		SetDamageTaken("stun", 0);

		SetDamageTaken("holy", 0.25f); // evil, but well shielded

		SetModel(MONSTER_MODEL);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);

		OnNpcatkSuspendAi();

		IMAGES_ALIVE = 0.0f;
		MINIONS_ALIVE = 0.0f;

		SetSayTextRange(2048);

		// need to re-write the NPC activation sequence, or something, this doesn't work, and fux the whole system somehow
		if (Contains(ToLowerCase(MapName()), "lodagond"))
		{
			if (!Truthy(GetVar("G_MALDORA_PRESENT"))) // remember to stick this on the final maldora
			{
				NPC_PROX_ACTIVATE = true;
				NPC_PROXACT_RANGE = "768";
				NPC_PROXACT_IFSEEN = true;
				NPC_PROXACT_EVENT = "start_convo";
			}
		}

		if (!NPC_PROX_ACTIVATE)
			OnCombatGo();

		if (!AM_UBER)
			SetProp(ENT_ME, "skin", AXESKIN_NULL);
	}

	// npc_post_spawn
	void MaldoraFragment_OnNpcPostSpawn()
	{
		// get beams ready
		CallEventDelayed(0.1f, "init_beam_push");
		CallEventDelayed(0.2f, "init_beam_chain");

		DEBUG_DID_POSTSPAWN = true;
		CallExternal(GetVar("GAME_MASTER"), "gm_add_maldora_fragment", self); // write this in after ye get back home
		CallEventDelayed(0.1f, "get_index");
	}

	// npcatk_proxact_scan
	void MaldoraFragment_OnNpcatkProxactScan()
	{
		if (!READY_TO_WAIT)
			return;

		if (NPC_PROXACT_TRIPPED)
			return;
		SetVar("LPLAYERS", GetActivePlayers());
		NPC_PROX_LOOP = false;
		NPC_PROXACT_INRANGE = false;
		int count = GetTokenCount("LPLAYERS");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnNpcatkProxactLplayers();
		}
		if (NPC_PROXACT_INRANGE)
			OnNpcatkProxActivated(NPC_PROXACT_SCANID, "player_scan");

		if (NPC_PROXACT_TRIPPED) // might get reset above
			return;
		CallEventDelayed(1.0f, "npcatk_proxact_scan");
	}

	// npcatk_prox_activated
	// PARAM1 = activating player PARAM2 debug
	void MaldoraFragment_OnNpcatkProxActivated(CBaseEntity@ player = null, string reason = "")
	{
		bool exitSub = false;

		if (!READY_TO_WAIT)
			return;

		if (exitSub)
			return;

		@NPC_PROXACT_PLAYERID = player;
		DebugPrint(NameOf(NPC_PROXACT_PLAYERID) + " activated me by " + EntityId(player) + " " + reason);
		if (NPC_PROXACT_TRIPPED)
			return;
		NPC_PROXACT_TRIPPED = true;
		CallEventOrDelay(NPC_PROXACT_EVENT);
	}

	// get_index
	void MaldoraFragment_OnGetIndex()
	{
		bool exitSub = false;
		if (NPC_PROX_ACTIVATE)
			CallEventDelayed(1.0f, "npcatk_proxact_scan");

		MALDORA_IDX = Float(ScriptVarOf(GetVar("GAME_MASTER"), "N_MALDORAS"));
		NPC_PROXACT_TRIPPED = false;
		if (MALDORA_IDX > 0.0f)
			READY_TO_WAIT = true;
		if (MALDORA_IDX <= 0.0f)
		{
			CallEventDelayed(0.1f, "get_index");
			exitSub = true;
		}
		if (exitSub)
			return;
	}

	// start_convo
	void MaldoraFragment_OnStartConvo()
	{
		DEBUG_START_CONVO = true;

		if (MALDORA_IDX == 1.0f)
		{
			SayText("Shall we?");
			PlaySound(0, 10, "voices/lodagond-4/fragment_shallwe.wav");
			DEBUG_CALLED_COMBAT = 1;
			CallEventDelayed(2.5f, "combat_go");
		}
		if (MALDORA_IDX == 2.0f)
		{
			DEBUG_CALLED_COMBAT = 2;
			CallEventDelayed(1.33f, "start_convo2");
			CallEventDelayed(2.5f, "combat_go");
		}
	}

	// start_convo2
	void MaldoraFragment_OnStartConvo2()
	{
		SayText("Lets!");
		PlaySound(0, 10, "voices/lodagond-4/fragment_lets.wav");
	}

	// game_heardsound
	// PARAM1=type:combat|move|danger PARAM2=(origin) PARAM3=danger_radius
	void MaldoraFragment_OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		if (COMBAT_ON && IsPlayer(ENT_LASTHEARD))
			SPELL_TARGET = EntityId(EntityOf(ENT_LASTHEARD));
	}

	// shock_ambience
	void MaldoraFragment_OnShockAmbience()
	{
		PlaySound(0, 10, "magic/shock_noloop.wav");
	}

	// combat_go
	void MaldoraFragment_OnCombatGo()
	{
		// clientevent new all effects/dynamic_beam_cl $get(ent_me,index) (255,0,0) 100 26
		CL_BEAM_IDX = LastClientScriptId();

		SetInvincible(false);
		SetMoveAnim(ANIM_RUN);
		COMBAT_ON = true;

		OnCycleUp();

		// setvard BARRIER_DELAY 1
		// callevent BARRIER_FREQ reset_barrier_delay
		OnPickSpell();
		CallEventDelayed(1.0f, "movement_cycle");
	}

	// reset_barrier_delay
	void MaldoraFragment_OnResetBarrierDelay()
	{
		BARRIER_DELAY = false;
	}

	// npcatk_hunt
	void MaldoraFragment_OnNpcatkHunt()
	{
		if (!COMBAT_ON)
			return;

		if (!CanSee("enemy"))
			return;
		SPELL_TARGET = EntityId(EntityOf(ENT_LASTSEEN));
	}

	// movement_cycle
	void MaldoraFragment_OnMovementCycle()
	{
		CallEventDelayed(0.5f, "movement_cycle");
		if (NO_MOVE)
			return;
		if (SUSPEND_AI)
			OnNpcatkGoMovedest();
		if (!CanSee("enemy"))
			SetMoveAnim(ANIM_WALK);
		if (CanSee("enemy"))
			SetMoveAnim(ANIM_RUN);

		if (IsAlive(WAND_TARGET) && RangeTo(WAND_TARGET) < 1024.0f)
		{
			OnNpcatkSetmovedest(WAND_TARGET, MOVE_RANGE);
			if (RangeTo(WAND_TARGET) < ATTACK_RANGE)
				OnSwingFist(WAND_TARGET);
		}

		if (IsAlive(WAND_TARGET) && RangeTo(WAND_TARGET) >= 1024.0f)
			WAND_TARGET = "unset";

		if (WAND_TARGET == "unset" && RandomInt(1, 20) == 1)
		{
			string newWand = SPELL_TARGET;
			if (RangeTo(SPELL_TARGET) > 640.0f && CanSee("enemy"))
				newWand = EntityId(EntityOf(ENT_LASTSEEN));
			if (!IsAlive(SPELL_TARGET) && CanSee("enemy"))
				newWand = EntityId(EntityOf(ENT_LASTSEEN));
			OnSwingFist(newWand);
		}

		if (WAND_TARGET != "unset")
		{
			int disengage = RandomInt(1, 10);
			if (disengage == 1)
			{
				OnLeapAway(WAND_TARGET);
				WAND_TARGET = "unset";
			}
			if (disengage > 1)
				OnNpcatkSetmovedest(WAND_TARGET, MOVE_RANGE);
		}

		if (!IsAlive(WAND_TARGET))
		{
			// no target, restricted wander
			if (RandomInt(1, 5) == 1)
			{
				int randAng = RandomInt(0, 359);
				Vector3 traceStart = MyOrigin();
				string traceEnd = Text(traceStart);
				traceEnd = Text(Vec(traceEnd) + RelativePosition(Vector3(0, randAng, 0), Vector3(0, 1000, 0)));
				string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
				OnNpcatkSetmovedest(traceLine, MOVE_RANGE);
			}
		}
	}

	// reset_props
	void MaldoraFragment_OnResetProps()
	{
		CallEventDelayed(10.0f, "reset_props");

		// ocasionally turns invisible when added with glow shells
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
	}

	// thrash_strike
	// called from model
	void MaldoraFragment_OnThrashStrike()
	{
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), "80%");
	}

	// pick_spell
	void MaldoraFragment_OnPickSpell()
	{
		bool exitSub = false;
		int count;

		SPELL_CHOICE = RandomInt(1, NUM_SPELLS);

		if (G_MALDORA_SPELLING)
		{
			// another fragment cast a spell within the last FREQ_SPAM seconds, try again later
			// dbg other maldora is spelling
			float rndDelay = Random(1, 5);
			CallEventDelayed(rndDelay, "pick_spell");
			exitSub = true;

			float timeDiff = G_MALDORA_SPELLTIME + 30.0f;
			if (GameTime() > timeDiff)
			{
				BEAM_COUNT = 0.0f;
				BEAM_ON = true;
				CHAIN_COUNT = 0.0f;
				CHAIN_ON = false;
				DebugPrint("wtf, no spells for 30 seconds? spell flag must be jammed (happens, dunno why)");
				SetGlobal("G_MALDORA_SPELLING", 0);
			}
		}
		if (exitSub)
			return;

		if (BEAM_ON)
			exitSub = true;
		if (CHAIN_ON)
			exitSub = true;
		if (exitSub)
			CallEventDelayed(0.5f, "pick_spell");
		if (exitSub)
			return;

		if (G_DEVELOPER > 0)
		{
			SPELL_CHOICE = G_DEVELOPER;
			G_DEVELOPER = 0;
		}

		if (RangeTo(SPELL_TARGET) > 2048.0f)
			SPELL_CHOICE = 0;
		if (!IsAlive(SPELL_TARGET))
			SPELL_CHOICE = 0;
		if (RelationshipOf(SPELL_TARGET, ENT_ME) == "ally")
			SPELL_CHOICE = 0;

		if (SPELL_CHOICE == 0 && !BARRIER_ON && NO_MOVE)
			OnResumeMoving();

		if (SPELL_CHOICE == 1)
		{
			if (BARRIER_DELAY)
			{
				SPELL_CHOICE = RandomInt(2, NUM_SPELLS);
				DebugPrint("barrier_no_go - barrier delay");
			}
			if (!BARRIER_DELAY)
			{
				// fragments must be sure not to start barriers within one another
				MALDORA_LIST = ScriptVarOf(GetVar("GAME_MASTER"), "GM_MALDORA_LIST");

				DebugPrint("maldist " + MALDORA_LIST);

				FELLOW_FRAG_NEARBY = false;
				count = GetTokenCount(MALDORA_LIST);
				for (int i = 0; i < count; i++)
				{
					loopIteration = i;
					OnCheckNearby();
				}
				if (FELLOW_FRAG_NEARBY)
				{
					DebugPrint("barrier_no_go - fellow maldora nearby");
					SPELL_CHOICE = RandomInt(2, NUM_SPELLS);
				}
				if (!FELLOW_FRAG_NEARBY)
				{
					BARRIER_DELAY = true;
					CallEventDelayed(BARRIER_FREQ, "reset_barrier_delay");

					CallEventDelayed(0.1f, "raise_barrier");
				}
			}
		}

		if (SPELL_CHOICE == 2)
		{
			SetGlobal("G_MALDORA_SPELLING", 1);
			G_MALDORA_SPELLTIME = GameTime();
			BEAM_ON = true;
			OnFaceTarget(SPELL_TARGET);
			PlayAnim("critical", ANIM_BOLT);
			BEAM_COUNT = 0.0f;
			APPLIED_BEAM = false;
			BEAM_TARGET = SPELL_TARGET;

			// clientevent update all CL_BEAM_IDX dbeam_color (1,1,0) 20
			CallEventDelayed(0.1f, "beam_push");
		}

		if (SPELL_CHOICE == 3)
		{
			SetGlobal("G_MALDORA_SPELLING", 1);
			G_MALDORA_SPELLTIME = GameTime();
			CHAIN_ON = true;
			CUR_CHAIN_TARGET = false;
			OnFaceTarget(SPELL_TARGET);
			PlayAnim("critical", ANIM_CAST);
			CHAIN_COUNT = 0.0f;
			// clientevent update all CL_BEAM_IDX dbeam_color (1,1,1) 10
			CallEventDelayed(0.1f, "chain_lightning");
		}

		if (SPELL_CHOICE == 4)
		{
			if (Truthy(GetVar("G_MAL_ROCK_STORMS")))
			{
				// dbg MALDORA: Can't summon rock storm, still exists
				CallEventDelayed(0.2f, "pick_spell");
				exitSub = true;
			}
			if (!exitSub)
			{
				SetGlobal("G_MAL_ROCK_STORMS", 1);

				PlayAnim("critical", ANIM_CAST);
				int numRocks = PlayerCount();
				if (numRocks > 4)
				{
					int numRucks = 4;
				}
				CreateNpc("monsters/summon/rock_storm", RelativePosition(Vector3(0, 0, 0)), self, numRocks, DMG_ROCKS, 64, 90); // <Owner> <#Rocks> <Dmg> <FX_Radius> <Letivtate_Height>
			}
		}
		// setvard ROCK_STORM_ID $get(ent_lastcreated,id)
		if (exitSub)
			return;

		if (SPELL_CHOICE == 5)
		{
			if (BARRIER_ON)
			{
				// no summoning inside barriers as it means you have to leap out of them
				CallEventDelayed(0.2f, "pick_spell");
				exitSub = true;
			}
			if (!BARRIER_ON)
			{
				if (IMAGES_ALIVE >= 1.0f)
					SPELL_CHOICE = RandomInt(6, NUM_SPELLS);
				if (IMAGES_ALIVE == 0.0f)
				{
					if (RandomInt(1, 3) == 1 && !AM_UBER)
						SayText("Shadows, of shadows, of shadows...");
					CallEventDelayed(0.1f, "laugh_it_up");
					OnStopMoving();
					PlayAnim("critical", ANIM_CAST);
					PlaySound(0, 10, "magic/spawn.wav");
					Effect("glow", ENT_ME, Vector3(255, 255, 255), 128, 2, 2);
					// setsolid none
					CreateNpc(SHADOW_SCRIPT, RelativePosition(Vector3(0, 64, -35)), self, SPELL_TARGET, 45, AM_UBER);
					CallEventDelayed(0.1f, "make_shadow2");
					if (AM_UBER)
					{
						CallEventDelayed(0.2f, "make_shadow3");
						CallEventDelayed(0.4f, "make_shadow4");
					}

					IMAGES_ALIVE = 2.0f;
					// callevent repulse_blast //stop players from getting stuck inside of me
					CallEventDelayed(1.0f, "resume_solid");
					CallEventDelayed(3.0f, "resume_moving");
				}
			}
		}

		if (SPELL_CHOICE == 6)
		{
			if (BARRIER_ON)
			{
				// no summoning inside barriers as it means you have to leap out of them
				CallEventDelayed(0.2f, "pick_spell");
				exitSub = true;
			}
			if (MINIONS_ALIVE >= MINION_LIMIT)
				SPELL_CHOICE = RandomInt(7, NUM_SPELLS);

			if (GameTime() <= NEXT_MINION)
				SPELL_CHOICE = RandomInt(7, NUM_SPELLS);

			if (GameTime() > NEXT_MINION)
			{
				NEXT_MINION = GameTime() + 5.0f;

				if (MINIONS_ALIVE < MINION_LIMIT)
				{
					MINIONS_ALIVE += 1.0f;

					PlayAnim("critical", ANIM_CAST);
					PlaySound(0, 10, "monsters/skeleton/calrain3.wav");
					Effect("glow", ENT_ME, Vector3(255, 255, 255), 128, 2, 2);
					CreateNpc(MINION_SCRIPT, RelativePosition(Vector3(0, 0, -64)), self, SPELL_TARGET);
					OnStopMoving(0.9f);
					CallEventDelayed(1.0f, "leap_away");
				}
			}
		}

		if (SPELL_CHOICE == 1)
		{
			CallEventDelayed(2.0f, "pick_spell");
			exitSub = true;
		}
		if (SPELL_CHOICE == 7) // REMOVE THIS WHEN YOU HAVE SPELL #7!!!
		{
			CallEventDelayed(0.2f, "pick_spell");
			exitSub = true;
		}
		if (exitSub)
			return;

		CallEventDelayed(SPELL_FREQ, "pick_spell");
	}

	// make_shadow2
	void MaldoraFragment_OnMakeShadow2()
	{
		CreateNpc(SHADOW_SCRIPT, RelativePosition(Vector3(0, -64, -35)), self, SPELL_TARGET, 135, AM_UBER);
	}

	// make_shadow3
	void MaldoraFragment_OnMakeShadow3()
	{
		CreateNpc(SHADOW_SCRIPT, RelativePosition(Vector3(64, -64, -35)), self, SPELL_TARGET, 225, AM_UBER);
	}

	// make_shadow4
	void MaldoraFragment_OnMakeShadow4()
	{
		CreateNpc(SHADOW_SCRIPT, RelativePosition(Vector3(-64, 64, -35)), self, SPELL_TARGET, 315, AM_UBER);
	}

	// reset_repulse
	// { repulse_blast
	// setvard REPULSE_ON 1
	// callevent 1.0 reset_repulse
	// dodamage $relpos(0,0,0) 96 0.0 100% 0.0 reflective target
	// }
	void MaldoraFragment_OnResetRepulse()
	{
		REPULSE_ON = false;
	}

	// laugh_it_up
	void MaldoraFragment_OnLaughItUp()
	{
		PlaySound(0, 10, "voices/ms_wicardoven/fmaldora_exit4.wav");
	}

	// image_died
	void MaldoraFragment_OnImageDied()
	{
		IMAGES_ALIVE -= 1.0f;
	}

	// game_struck
	void MaldoraFragment_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		// //dbg temp health game.monster.hp
		if (!NO_MOVE && RangeTo(ENT_LASTSTRUCK) < ATTACK_RANGE)
			OnSwingFist(EntityId(EntityOf(ENT_LASTSTRUCK)));

		if (IsPlayer(ENT_LASTSTRUCK) && RandomInt(1, 2) == 1)
			SPELL_TARGET = EntityId(EntityOf(ENT_LASTSTRUCK));

		if (!(damage > 20.0f))
			return;
		PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK4, SOUND_STRUCK5);

		if (!(damage > 50.0f))
			return;
		OnLeapAway(EntityId(EntityOf(ENT_LASTSTRUCK)));
	}

	// leap_away
	// PARAM1 = dude to flee
	void MaldoraFragment_OnLeapAway(string target = "")
	{
		if (CHAIN_ON)
			return;
		if (BEAM_ON)
			return;
		if (BARRIER_ON)
			return;
		if (NO_MOVE)
			return;

		NPC_FORCED_MOVEDEST = true;
		SetMoveDest(target, 800, "flee");
		CallEventDelayed(0.1f, "leap_away2");
	}

	// leap_away2
	void MaldoraFragment_OnLeapAway2()
	{
		PlayAnim("critical", ANIM_LEAP);
		CallEventDelayed(0.1f, "leap_boost");
	}

	// leap_boost
	void MaldoraFragment_OnLeapBoost()
	{
		if (BARRIER_ON)
			return;
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 400, 50)));
	}

	// swing_fist
	// PARAM1 = swing targ
	void MaldoraFragment_OnSwingFist(string target = "")
	{
		if (CHAIN_ON)
			return;
		if (BEAM_ON)
			return;
		if (BARRIER_ON)
			return;
		if (NO_MOVE)
			return;
		WAND_TARGET = target;
		OnNpcatkSetmovedest(WAND_TARGET, MOVE_RANGE);
		if (!(RangeTo(WAND_TARGET) < ATTACK_RANGE))
			return;
		PlayAnim("once", ANIM_WAND);
	}

	// stop_moving
	void MaldoraFragment_OnStopMoving(float delay = 0.0f)
	{
		SetRoam(false);
		NO_STUCK_CHECKS = "1";
		NO_MOVE = true;
		SetMoveAnim(ANIM_IDLE);
		ANIM_RUN = ANIM_IDLE;
		ANIM_WALK = ANIM_IDLE;
		OnFaceTarget(SPELL_TARGET);
		CallEventDelayed(delay, "resume_moving");
	}

	// resume_solid
	void MaldoraFragment_OnResumeSolid()
	{
		SetSolid("box");
	}

	// resume_moving
	void MaldoraFragment_OnResumeMoving()
	{
		SetRoam(true);
		NO_STUCK_CHECKS = "0";
		NO_MOVE = false;
		SetMoveAnim(ANIM_RUN);
		ANIM_RUN = ANIM_RUN_NORM;
		ANIM_WALK = ANIM_WALK_NORM;
	}

	// raise_barrier
	void MaldoraFragment_OnRaiseBarrier()
	{
		DebugPrint("raise_barrier " + Text(BARRIER_COLOR) + " " + Text(DMG_BARRIER));
		OnStopMoving();
		BARRIER_ON = true;
		PlayAnim("critical", ANIM_CAST);
		// createnpc monsters/summon/barrier $relpos(0,0,0) $get(ent_me,id) 128 0 0 1
		// setvard BARRIER_ID $get(ent_lastcreated,id)
		ClientEvent("new", "all", "effects/sfx_barrier", IndexOf(ENT_ME), 128, BARRIER_COLOR, 10.0f, 1, 1);
		PlaySound(0, 10, "magic/spawn_loud.wav");
		OnBarrierLoop();
		CallEventDelayed(10.0f, "lower_barrier");
	}

	// barrier_loop
	void MaldoraFragment_OnBarrierLoop()
	{
		if (!BARRIER_ON)
			return;
		CallEventDelayed(0.5f, "barrier_loop");
		Vector3 scanPoint = OriginOf(ENT_ME);
		scanPoint.z += 32.0f;
		BARRIER_TARGS = LegacyFunction("get_tsphere", "enemy", 128, scanPoint);
		if (BARRIER_TARGS == "none")
			return;
		PlaySound(0, 10, "doors/aliendoor1.wav");
		int count = GetTokenCount(BARRIER_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBarrierAffectTargets();
		}
	}

	// barrier_affect_targets
	void MaldoraFragment_OnBarrierAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(BARRIER_TARGS, loopIteration));

		// dbg barrier_affect_targets BARRIER_TARGS DMG_BARRIER
		if (DMG_BARRIER > 0.0f)
			DoDamageEx(@curTarg, "direct", DMG_BARRIER, "100%", ENT_ME, ENT_ME, "none", "magic");
		Vector3 targOrg = OriginOf(curTarg);
		Vector3 myOrg = OriginOf(ENT_ME);
		float targAng = AnglesTo(myOrg, targOrg);
		SetVelocity(curTarg, RelativeVelocity(Vector3(0, targAng, 0), Vector3(0, 1000, 110)));
	}

	// lower_barrier
	void MaldoraFragment_OnLowerBarrier()
	{
		BARRIER_ON = false;
		OnResumeMoving();
		CallExternal("BARRIER_ID", "remove_barrier");
	}

	// beam_push
	void MaldoraFragment_OnBeamPush()
	{
		BEAM_COUNT += 1.0f;
		if (BEAM_COUNT == 1.0f)
		{
			OnInitBeamPush();
			Effect("beam", "update", @PUSH_BEAM_ID, "brightness", 255);
		}
		if (BEAM_COUNT < 30.0f)
		{
			SetIdleAnim(ANIM_BOLT);
			SetMoveAnim(ANIM_WALK);
		}
		if (BEAM_COUNT == 30.0f)
		{
			SetIdleAnim(ANIM_IDLE);
			SetMoveAnim(ANIM_RUN);

			// clientevent update all CL_BEAM_IDX dbeam_off
			OnSwingFist(EntityId(EntityOf(ENT_LASTSTRUCK)));
			BEAM_ON = false;
			SetGlobal("G_MALDORA_SPELLING", 0);
			Effect("beam", "update", @PUSH_BEAM_ID, "brightness", 0);
		}
		if (!(BEAM_COUNT < 30.0f))
			return;
		CallEventDelayed(0.1f, "beam_push");
		if (!IsAlive(BEAM_TARGET))
			return;
		OnFaceTarget(BEAM_TARGET);
		Vector3 beamStart = MyOrigin();
		bool seeBtarget = CanSee(BEAM_TARGET);

		if (!seeBtarget)
		{
			PUSH_BEAM_VISIBLE = false;
			Effect("beam", "update", @PUSH_BEAM_ID, "brightness", 0);
		}
		// clientevent update all CL_BEAM_IDX dbeam_off
		if (!seeBtarget)
			return;

		if (!PUSH_BEAM_VISIBLE)
			Effect("beam", "update", @PUSH_BEAM_ID, "brightness", 255);
		PUSH_BEAM_VISIBLE = true;
		PlayAnim("once", ANIM_BOLT);
		PlaySound(0, 10, SOUND_BEAM);

		// effect beam point lgtning.spr 200 BEAM_START BEAM_END (255,255,0) 255 20 0.2
		// clientevent update all CL_BEAM_IDX dbeam_target $get(BEAM_TARGET,index)
		Effect("beam", "update", @PUSH_BEAM_ID, "end_target", BEAM_TARGET, 0);

		float myYaw = MyAngles().y;

		// these two lines maybe screwy
		myYaw += BEAM_COUNT;
		if (myYaw > 359.0f)
			myYaw -= 359.0f;

		Vector3 velSet = RelativePosition(Vector3(0, myYaw, 0), Vector3(500, 1000, 30));

		SetVelocity(BEAM_TARGET, velSet);

		DoDamage(BEAM_TARGET, "direct", DMG_PUSH_BEAM, "100%", self, "lightning");

		if (!APPLIED_BEAM && int(DamageTakenOf(BEAM_TARGET, "stun")) != 0)
		{
			ApplyEffect(BEAM_TARGET, "effects/dot_lightning", 5.0f, self, DMG_SHOCK);
			APPLIED_BEAM = true;
		}
	}

	// my_target_died
	void MaldoraFragment_OnMyTargetDied(string offender = "")
	{
		if (offender == WAND_TARGET)
			WAND_TARGET = "unset";

		SPELL_TARGET = "unset";

		if (GAVE_WARNING)
			return;
		GAVE_WARNING = true;
		InfoMessage(offender, "Beware!", "The Fragment of Malodra is immune to magic!");
	}

	// chain_lightning
	void MaldoraFragment_OnChainLightning()
	{
		CHAIN_COUNT += 1.0f;
		if (CHAIN_COUNT == 1.0f)
		{
			Vector3 scanPoint = OriginOf(ENT_ME);
			scanPoint.z += 32.0f;
			CHAIN_LIST = LegacyFunction("get_tsphere", "enemy", 1024, scanPoint);
		}
		if (CHAIN_COUNT < CHAIN_COUNT_LIMIT)
		{
			SetIdleAnim(ANIM_CAST);
			SetMoveAnim(ANIM_WALK);
			OnFaceTarget(SPELL_TARGET);
		}
		if (CHAIN_COUNT == CHAIN_COUNT_LIMIT)
		{
			// clientevent update all CL_BEAM_IDX dbeam_off
			SetIdleAnim(ANIM_IDLE);
			SetMoveAnim(ANIM_RUN);
			OnNpcatkFlee(EntityId(EntityOf(ENT_LASTSTRUCK)), "800", "3.0");
			CHAIN_ON = false;
			SetGlobal("G_MALDORA_SPELLING", 0);
		}
		// effect beam update CHAIN_BEAM_ID brightness 0
		if (!(CHAIN_COUNT < CHAIN_COUNT_LIMIT))
			return;
		CallEventDelayed(0.25f, "chain_lightning");
		if (CHAIN_LIST == "none")
			return;
		PlayAnim("once", ANIM_CAST);
		int count = GetTokenCount(CHAIN_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnChainAffectTargets();
		}
	}

	// chain_affect_targets
	void MaldoraFragment_OnChainAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(CHAIN_LIST, loopIteration));
		float targRange = RangeTo(curTarg) * 1.5f;
		DoDamage(curTarg, targRange, DMG_CHAIN, "100%", ENT_ME, "lightning");
	}

	// game_dodamage
	// old chain lightning
	// playanim once ANIM_CAST
	// setvard CHAIN_LIST ''
	// //dodamage $relpos(0,0,0) 1024 DMG_CHAIN 100% 0.0 reflective lightning
	// setvard ENEMY_LIST $get_tsphere(enemy,1024,game.monster.origin)
	// local N_CTARGS $get_token_amt(ENEMY_LIST)
	// //dbg detedted N_CTARGS enemies
	// if N_CTARGS > 0
	// add CUR_CHAIN_TARGET 1
	// //dbg zapping $get_token(ENEMY_LIST,CUR_CHAIN_TARGET) CUR_CHAIN_TARGET of N_CTARGS
	// if ( CUR_CHAIN_TARGET >= N_CTARGS ) setvard CUR_CHAIN_TARGET 0
	// local L_CHAIN_TARGET $get_token(ENEMY_LIST,CUR_CHAIN_TARGET)
	// local CT_ORG $get(L_CHAIN_TARGET,origin)
	// local CAN_HIT $get_traceline(game.monster.origin,CT_ORG,worldonly)
	// if ( CAN_HIT equals CT_ORG ) local CHAIN_HIT 1
	// if ( !CHAIN_HIT ) effect beam update CHAIN_BEAM_ID brightness 0
	// if ( CHAIN_HIT ) effect beam update CHAIN_BEAM_ID brightness 255
	// if CHAIN_HIT
	// //clientevent update all CL_BEAM_IDX dbeam_target $get(L_CHAIN_TARGET,index)
	// effect beam update CHAIN_BEAM_ID end_target L_CHAIN_TARGET 0
	// //add some damage if I have multiple targets, as I wont hit them as often as I'd hit one
	// local DMG_MULTI 0.25
	// multiply DMG_MULTI N_CTARGS
	// add DMG_MULTI 1
	// local F_DMG_CHAIN DMG_CHAIN
	// multiply F_DMG_CHAIN DMG_MULTI
	// dodamage L_CHAIN_TARGET direct F_DMG_CHAIN 100% $get(ent_me,id) lightning
	// applyeffect L_CHAIN_TARGET effects/dot_lightning 3.0 $get(ent_me,id) DMG_SHOCK
	// if ( !$get(L_CHAIN_TARGET,scriptvar,'IMMUNE_PUSH') )
	// {
	// local TARGET_ORG $get(L_CHAIN_TARGET,origin)
	// local TARG_ANG $angles(game.monster.origin,TARGET_ORG)
	// local NEW_YAW TARG_ANG
	// //add NEW_YAW 180
	// //if ( NEW_YAW > 359 ) subtract NEW_YAW 359
	// setvelocity L_CHAIN_TARGET $relvel($vec(0,NEW_YAW,0),$vec(0,110,0))
	// //addvelocity L_CHAIN_TARGET $relvel(0,110,0)
	// }
	// playrandomsound 0 10 SOUND_SHOCK1 SOUND_SHOCK2 SOUND_SHOCK3
	// //clientevent update all CL_BEAM_IDX dbeam_target_multi CHAIN_LIST
	// }
	string MaldoraFragment_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			WAND_ATK = false;

		if (REPULSE_ON)
		{
			// dun think this is actually used anymore
			if (RangeTo(target) < 128.0f)
			{
				float incVel = AnglesOf(target).y - 180.0f;
				if (incVel < 0.0f)
					incVel += 359.0f;
				Vector3 outVel = RelativeVelocity(Vector3(0, incVel, 0), Vector3(0, 2000, 0));
				AddVelocity(target, outVel);
			}
		}

		if (!hit)
			return result;
		if (CHAIN_ON)
		{
			if (GameTime() > NEXT_CHAIN_SOUND)
			{
				NEXT_CHAIN_SOUND = GameTime() + 0.5f;
				PlayRandomSound(0, 10, SOUND_SHOCK1, SOUND_SHOCK2, SOUND_SHOCK3);
			}
			Vector3 targOrg = OriginOf(target);
			Vector3 myOrg = OriginOf(ENT_ME);
			float targAng = AnglesTo(myOrg, targOrg);
			SetVelocity(target, RelativeVelocity(Vector3(0, targAng, 0), Vector3(0, 300, 0)));
			Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 2, @target, 1, Vector3(255, 255, 255), 255, 10, 1.0f);
			if (GameTime() > NEXT_CHAIN_SHOCK)
			{
				NEXT_CHAIN_SHOCK = GameTime() + 1.0f;
				ApplyEffect(target, "effects/dot_lightning", 3.0f, self, DMG_SHOCK);
			}
		}

		if (WAND_ATK)
			OnWandStrikeDmg(target);
		return result;
	}

	// wand_strike_dmg
	// param1 = target struck
	void MaldoraFragment_OnWandStrikeDmg(CBaseEntity@ target = null)
	{
		WAND_ATK = false;
		if (RandomInt(1, 5) != 1)
			return;
		ApplyEffect(target, "effects/debuff_stun", 3.0f, self);
	}

	// strike_wand
	void MaldoraFragment_OnStrikeWand()
	{
		AS_ATTACKING = GameTime();

		if (!(RangeTo(WAND_TARGET) < ATTACK_HITRANGE))
			return;
		WAND_ATK = true;
		DoDamage(WAND_TARGET, ATTACK_HITRANGE, DMG_WAND, "80%", "blunt");
	}

	// quick_spell
	void MaldoraFragment_OnQuickSpell()
	{
		AS_ATTACKING = GameTime();
	}

	// quick_bolt
	void MaldoraFragment_OnQuickBolt()
	{
		AS_ATTACKING = GameTime();
	}

	// face_target
	// wicard oven variant only
	// { raise_lava
	// playanim critical ANIM_CAST
	// usetrigger multilava
	// callevent LAVA_FREQ raise_lava
	// }
	// npcatk_faceattacker does not work with AI suspended
	void MaldoraFragment_OnFaceTarget(string target = "")
	{
		NPC_FORCED_MOVEDEST = true;
		SetMoveDest(target, 9999);
	}

	// skele_died
	void MaldoraFragment_OnSkeleDied()
	{
		MINIONS_ALIVE -= 1.0f;
	}

	// game_death
	void MaldoraFragment_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		G_MALDORA_SPELLING = false;

		// clientevent remove all CL_BEAM_IDX
		Effect("beam", "update", "CHAIN_BEAM_ID", "remove", 0);
		Effect("beam", "update", @PUSH_BEAM_ID, "remove", 0);

		if (!AM_UBER)
			CallExternal("all", "maldoraf_died", self);
		if (AM_UBER)
			CallExternal("all", "maldora_final_died", self);
		SetProp(ENT_ME, "renderamt", 0);
		CreateNpc("ms_wicardoven/maldora_dead", RelativePosition(Vector3(0, 0, 0)), "crow");
		SetSolid("none");
		SetOrigin(ENT_ME, Vector3(20000, 20000, 20000));
	}

	// check_nearby
	// this loops through to make sure the fragment does not raise a barrier while another is near
	void MaldoraFragment_OnCheckNearby()
	{
		string curMal = GetToken(MALDORA_LIST, loopIteration);
		if (curMal == EntityId(self))
			return;
		if (!IsAlive(curMal))
			return;
		if (RangeTo(curMal) < 256.0f)
			FELLOW_FRAG_NEARBY = true;
	}

	// ext_rock_storm_end
	void MaldoraFragment_OnExtRockStormEnd()
	{
		SetGlobal("G_MAL_ROCK_STORMS", 0);
	}

	// init_beam_push
	void MaldoraFragment_OnInitBeamPush()
	{
		Effect("beam", "ents", "lgtning.spr", 200, self, 2, self, 0, Vector3(255, 255, 0), 0, 20, 30.0f); // try -1
		@PUSH_BEAM_ID = EntityOf(ENT_LASTCREATED);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePrecache() { MaldoraFragment_OnGamePrecache(); } // game_precache

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		MaldoraFragment_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
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
		MaldoraFragment_OnNpcPostSpawn();
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		MaldoraFragment_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		MaldoraFragment_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		MaldoraFragment_OnNpcatkHunt();
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		BaseNpcAttackNew_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_monster_shared
		MaldoraFragment_OnGameHeardsound(soundType, origin, dangerRadius);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		MaldoraFragment_OnMyTargetDied(offender);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, MaldoraFragment_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	void OnNpcatkProxactScan() { MaldoraFragment_OnNpcatkProxactScan(); } // npcatk_proxact_scan
	void OnNpcatkProxActivated(CBaseEntity@ player = null, string reason = "") { MaldoraFragment_OnNpcatkProxActivated(player, reason); } // npcatk_prox_activated
	void OnGetIndex() { MaldoraFragment_OnGetIndex(); } // get_index
	void OnStartConvo() { MaldoraFragment_OnStartConvo(); } // start_convo
	void OnStartConvo2() { MaldoraFragment_OnStartConvo2(); } // start_convo2
	void OnShockAmbience() { MaldoraFragment_OnShockAmbience(); } // shock_ambience
	void OnCombatGo() { MaldoraFragment_OnCombatGo(); } // combat_go
	void OnResetBarrierDelay() { MaldoraFragment_OnResetBarrierDelay(); } // reset_barrier_delay
	void OnMovementCycle() { MaldoraFragment_OnMovementCycle(); } // movement_cycle
	void OnResetProps() { MaldoraFragment_OnResetProps(); } // reset_props
	void OnThrashStrike() { MaldoraFragment_OnThrashStrike(); } // thrash_strike
	void OnPickSpell() { MaldoraFragment_OnPickSpell(); } // pick_spell
	void OnMakeShadow2() { MaldoraFragment_OnMakeShadow2(); } // make_shadow2
	void OnMakeShadow3() { MaldoraFragment_OnMakeShadow3(); } // make_shadow3
	void OnMakeShadow4() { MaldoraFragment_OnMakeShadow4(); } // make_shadow4
	void OnResetRepulse() { MaldoraFragment_OnResetRepulse(); } // reset_repulse
	void OnLaughItUp() { MaldoraFragment_OnLaughItUp(); } // laugh_it_up
	void OnImageDied() { MaldoraFragment_OnImageDied(); } // image_died
	void OnLeapAway(string target = "") { MaldoraFragment_OnLeapAway(target); } // leap_away
	void OnLeapAway2() { MaldoraFragment_OnLeapAway2(); } // leap_away2
	void OnLeapBoost() { MaldoraFragment_OnLeapBoost(); } // leap_boost
	void OnSwingFist(string target = "") { MaldoraFragment_OnSwingFist(target); } // swing_fist
	void OnStopMoving(float delay = 0.0f) { MaldoraFragment_OnStopMoving(delay); } // stop_moving
	void OnResumeSolid() { MaldoraFragment_OnResumeSolid(); } // resume_solid
	void OnResumeMoving() { MaldoraFragment_OnResumeMoving(); } // resume_moving
	void OnRaiseBarrier() { MaldoraFragment_OnRaiseBarrier(); } // raise_barrier
	void OnBarrierLoop() { MaldoraFragment_OnBarrierLoop(); } // barrier_loop
	void OnBarrierAffectTargets() { MaldoraFragment_OnBarrierAffectTargets(); } // barrier_affect_targets
	void OnLowerBarrier() { MaldoraFragment_OnLowerBarrier(); } // lower_barrier
	void OnBeamPush() { MaldoraFragment_OnBeamPush(); } // beam_push
	void OnChainLightning() { MaldoraFragment_OnChainLightning(); } // chain_lightning
	void OnChainAffectTargets() { MaldoraFragment_OnChainAffectTargets(); } // chain_affect_targets
	void OnWandStrikeDmg(CBaseEntity@ target = null) { MaldoraFragment_OnWandStrikeDmg(target); } // wand_strike_dmg
	void OnStrikeWand() { MaldoraFragment_OnStrikeWand(); } // strike_wand
	void OnQuickSpell() { MaldoraFragment_OnQuickSpell(); } // quick_spell
	void OnQuickBolt() { MaldoraFragment_OnQuickBolt(); } // quick_bolt
	void OnFaceTarget(string target = "") { MaldoraFragment_OnFaceTarget(target); } // face_target
	void OnSkeleDied() { MaldoraFragment_OnSkeleDied(); } // skele_died
	void OnCheckNearby() { MaldoraFragment_OnCheckNearby(); } // check_nearby
	void OnExtRockStormEnd() { MaldoraFragment_OnExtRockStormEnd(); } // ext_rock_storm_end
	void OnInitBeamPush() { MaldoraFragment_OnInitBeamPush(); } // init_beam_push
	void OnBarrierFreq() {} // BARRIER_FREQ
	void OnRndDelay() {} // RND_DELAY
	void OnSpellFreq() {} // SPELL_FREQ
	void OnNpcatkGoMovedest() {} // npcatk_go_movedest

	// This file's events and timers by their .script names
	bool MaldoraFragment_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "barrier_affect_targets") { OnBarrierAffectTargets(); return true; }
		if (name == "barrier_loop") { OnBarrierLoop(); return true; }
		if (name == "beam_push") { OnBeamPush(); return true; }
		if (name == "chain_affect_targets") { OnChainAffectTargets(); return true; }
		if (name == "chain_lightning") { OnChainLightning(); return true; }
		if (name == "check_nearby") { OnCheckNearby(); return true; }
		if (name == "combat_go") { OnCombatGo(); return true; }
		if (name == "ext_rock_storm_end") { OnExtRockStormEnd(); return true; }
		if (name == "face_target") { OnFaceTarget(Param(params, 0)); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "get_index") { OnGetIndex(); return true; }
		if (name == "image_died") { OnImageDied(); return true; }
		if (name == "init_beam_push") { OnInitBeamPush(); return true; }
		if (name == "laugh_it_up") { OnLaughItUp(); return true; }
		if (name == "leap_away") { OnLeapAway(Param(params, 0)); return true; }
		if (name == "leap_away2") { OnLeapAway2(); return true; }
		if (name == "leap_boost") { OnLeapBoost(); return true; }
		if (name == "lower_barrier") { OnLowerBarrier(); return true; }
		if (name == "make_shadow2") { OnMakeShadow2(); return true; }
		if (name == "make_shadow3") { OnMakeShadow3(); return true; }
		if (name == "make_shadow4") { OnMakeShadow4(); return true; }
		if (name == "movement_cycle") { OnMovementCycle(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_prox_activated") { OnNpcatkProxActivated(EntityParam(params, 0), Param(params, 1)); return true; }
		if (name == "npcatk_proxact_scan") { OnNpcatkProxactScan(); return true; }
		if (name == "pick_spell") { OnPickSpell(); return true; }
		if (name == "quick_bolt") { OnQuickBolt(); return true; }
		if (name == "quick_spell") { OnQuickSpell(); return true; }
		if (name == "raise_barrier") { OnRaiseBarrier(); return true; }
		if (name == "reset_barrier_delay") { OnResetBarrierDelay(); return true; }
		if (name == "reset_props") { OnResetProps(); return true; }
		if (name == "reset_repulse") { OnResetRepulse(); return true; }
		if (name == "resume_moving") { OnResumeMoving(); return true; }
		if (name == "resume_solid") { OnResumeSolid(); return true; }
		if (name == "shock_ambience") { OnShockAmbience(); return true; }
		if (name == "skele_died") { OnSkeleDied(); return true; }
		if (name == "start_convo") { OnStartConvo(); return true; }
		if (name == "start_convo2") { OnStartConvo2(); return true; }
		if (name == "stop_moving") { OnStopMoving(Float(Param(params, 0))); return true; }
		if (name == "strike_wand") { OnStrikeWand(); return true; }
		if (name == "swing_fist") { OnSwingFist(Param(params, 0)); return true; }
		if (name == "thrash_strike") { OnThrashStrike(); return true; }
		if (name == "wand_strike_dmg") { OnWandStrikeDmg(EntityParam(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "lodagond/maldora_fragment"]
shared class MaldoraFragmentScript : BaseMonsterNewScript, MaldoraFragment
{
	// Variables every script that includes this file declares
	bool AM_UBER = false;
	int EFFECT_DELAY = 0;
	float FREQ_SOUND = 0.0f;
	float LAST_AXE_PICK = 0.0f;
	string LIGHT_COLOR = "LIGHT_COLOR";
	int LIGHT_RAD = 0;
	bool ME_DEAD = false;
	bool NOT_FRAGMENT = false;
	float RND_AXE = 0.0f;
	bool SORC_SPAWNED = false;
	bool SPELL_SUSPEND = false;
	int WAND_DOT = 0;
	string WAND_TYPE = "WAND_TYPE";

	// Variables declared by included files, with the value they start with in this script
	MaldoraFragmentScript()
	{
		ANIM_IDLE = "idle";
		ANIM_RUN = "run2";
		ANIM_WALK = "walk2handed";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/maldora.mdl");
		Precache("monsters/skeleton_boss1.mdl");
		Precache("rockgibs.mdl");
		CallEventDelayed(10.0f, "reset_props");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MaldoraFragment_FirstThink();
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
		return MaldoraFragment_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
