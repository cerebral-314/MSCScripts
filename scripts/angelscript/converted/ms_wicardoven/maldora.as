#pragma context server

// Converted from ms_wicardoven/maldora.script by msc_transpiler.
// Attacks
// - Barrier
// - Lightning bolt with push + slide
// - Chain Lightning
// - Rock Storm
// - Mirror image summon
// - Summon minions
// - Horror Eggs //protozoa.mdl? //stickygib.mdl?
// - Mana ghost?
// - Hornet Swarm?
// - Spikes from floor via altered rip.mdl?
// - Hell bats

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "ms_wicardoven/maldora"]
class MsWicardovenMaldora : BaseMonsterNewScript
{
	// Constants
	int CHAIN_COUNT_LIMIT = 20;
	int NUM_SPELLS = 6;
	int MINION_LIMIT = 2;
	string FINGER_ADJ = "$relpos($vec(0,MY_YAW,0),$vec(0,30,54))";
	string SHADOW_SCRIPT = "ms_wicardoven/maldora_image";
	string MINION_SCRIPT = "monsters/maldora_minion_random";
	string NPC_BASE_EXP = "2000";
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
	bool NPC_PROX_ACTIVATE = true;
	string NPC_PROXACT_RANGE = "640";
	bool NPC_PROXACT_IFSEEN = true;
	string NPC_PROXACT_EVENT = "start_convo";
	Vector3 BARRIER_COLOR = Vector3();

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	string ANIM_RUN_NORM = "run2";
	string ANIM_WALK_NORM = "walk2handed";
	float DMG_BARRIER = 0.0f;
	string WAND_TARGET = "WAND_TARGET";
	float IMAGES_ALIVE = 0.0f;
	float MINIONS_ALIVE = 0.0f;
	string BARRIER_IDX = "BARRIER_IDX";
	bool BARRIER_ON = false;
	CBaseEntity@ ORC_A_ID = null;
	CBaseEntity@ ORC_B_ID = null;
	string SPELL_TARGET = "SPELL_TARGET";
	string PRO_NOUN = "PRO_NOUN";
	bool COMBAT_ON = false;
	bool BARRIER_DELAY = false;
	int SPELL_CHOICE = 0;
	int G_DEVELOPER = 0;
	bool BEAM_ON = false;
	float BEAM_COUNT = 0.0f;
	bool APPLIED_BEAM = false;
	string BEAM_TARGET = "BEAM_TARGET";
	bool CHAIN_ON = false;
	float CHAIN_COUNT = 0.0f;
	float NEXT_MINION = 0.0f;
	bool REPULSE_ON = false;
	bool NO_MOVE = false;
	string BARRIER_TARGS = "BARRIER_TARGS";
	bool PUSH_BEAM_VISIBLE = false;
	bool GAVE_WARNING = false;
	string CHAIN_LIST = "CHAIN_LIST";
	bool WAND_ATK = false;
	float NEXT_CHAIN_SOUND = 0.0f;
	float NEXT_CHAIN_SHOCK = 0.0f;
	CBaseEntity@ PUSH_BEAM_ID = null;

	// Variables declared by included files, with the value they start with in this script
	MsWicardovenMaldora()
	{
		NPC_BOSS_RESTORATION = 0.25f;
		ANIM_IDLE = "idle";
		ANIM_RUN = "run2";
		ANIM_WALK = "walk2handed";
	}

	// unnamed block (first think)
	void MsWicardovenMaldora_FirstThink()
	{
		if (ToLowerCase(MapName()) == "ms_wicardoven")
			NPC_IS_BOSS = true;

		IS_UNHOLY = true;

		ANIM_IDLE = "idle";
		ANIM_RUN_NORM = "run2";
		ANIM_WALK_NORM = "walk2handed";
		ANIM_DEATH = "look_idle";
		ANIM_RUN = "run2";
		ANIM_WALK = "walk2handed";

		NO_SPAWN_STUCK_CHECK = true;

		IMMUNE_VAMPIRE = true;
		DMG_BARRIER = 0.0f;
	}

	// game_dodamage
	string MsWicardovenMaldora_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			WAND_ATK = false;

		if (REPULSE_ON && RangeTo(target) < 128.0f)
		{
			float incVel = AnglesOf(target).y - 180.0f;
			if (incVel < 0.0f)
				incVel += 359.0f;
			Vector3 outVel = RelativeVelocity(Vector3(0, incVel, 0), Vector3(0, 2000, 0));
			AddVelocity(target, outVel);
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
		{
			WAND_ATK = false;
			if (RandomInt(1, 5) == 1)
				ApplyEffect(target, "effects/debuff_stun", 3.0f, self);
		}
		return result;
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared

		CallExternal("all", "maldora_died");
		SetProp(ENT_ME, "renderamt", 0);
		CreateNpc("ms_wicardoven/maldora_dead", RelativePosition(Vector3(0, 0, 0)), "death");
		SetSolid("none");
		SetOrigin(ENT_ME, Vector3(20000, 20000, 20000));
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared

		// dbg temp health game.monster.hp
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

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Fragment of Maldora");
		SetHealth(4000);
		SetRace("demon");
		SetWidth(32);
		SetHeight(86);

		SetBlood("white");

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
		SetProp(ENT_ME, "skin", 5);

		OnNpcatkSuspendAi();

		IMAGES_ALIVE = 0.0f;
		MINIONS_ALIVE = 0.0f;

		SetSayTextRange(2048);

		CreateNpc("ms_wicardoven/orc_archer_image", RelativePosition(Vector3(20, 64, 0)));
		CreateNpc("ms_wicardoven/orc_champion_image", RelativePosition(Vector3(-20, 64, 0)));

		CallEventDelayed(0.1f, "make_barrier");
		CallEventDelayed(5.0f, "reset_props");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck

		if (!COMBAT_ON)
			return;

		if (!CanSee("enemy"))
			return;
		SPELL_TARGET = EntityId(EntityOf(ENT_LASTSEEN));
	}

	// game_heardsound
	// PARAM1=type:combat|move|danger PARAM2=(origin) PARAM3=danger_radius
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		BaseNpcAttackNew_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_monster_shared

		if (COMBAT_ON && IsPlayer(ENT_LASTHEARD))
			SPELL_TARGET = EntityId(EntityOf(ENT_LASTHEARD));
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new

		// add taunt + hints here if >1 player
		if (offender == WAND_TARGET)
			WAND_TARGET = "unset";

		SPELL_TARGET = "unset";

		if (GAVE_WARNING)
			return;
		GAVE_WARNING = true;
		InfoMessage(offender, "Beware!", "The Fragment of Malodra is immune to magic!");
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, MsWicardovenMaldora_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// make_barrier
	void OnMakeBarrier()
	{
		// createnpc monsters/summon/barrier $relpos(0,0,0) $get(ent_me,id) 128 1 0
		// setvard BARRIER_ID $get(ent_lastcreated,id)
		ClientEvent("new", "all", "effects/sfx_barrier", IndexOf(ENT_ME), 128, BARRIER_COLOR, 30.0f, 0, 1);
		BARRIER_IDX = LastClientScriptId();
		BARRIER_ON = true;
		OnBarrierLoop();
		CallEventDelayed(0.25f, "get_orc_ids");
	}

	// get_orc_ids
	void OnGetOrcIds()
	{
		CBaseEntity@ orcAName = FindByName("orc_a");
		CBaseEntity@ orcBName = FindByName("orc_b");
		@ORC_A_ID = orcAName;
		@ORC_B_ID = orcBName;
		CallEventDelayed(0.1f, "face_orcs");
	}

	// face_orcs
	void OnFaceOrcs()
	{
		CallExternal(ORC_A_ID, "face_me", self);
		CallEventDelayed(0.2f, "face_orcs2");
	}

	// face_orcs2
	void OnFaceOrcs2()
	{
		CallExternal(ORC_B_ID, "face_me", self);
	}

	// start_convo
	void OnStartConvo()
	{
		PlayAnim("critical", ANIM_WAND);
		if (PlayerCount() == 1)
			PRO_NOUN = "him";
		if (PlayerCount() > 1)
			PRO_NOUN = "them";

		SayText("You incompetent fools! How could you let " + PRO_NOUN + " get this far!?");
		PlaySound(0, 10, "voices/ms_wicardoven/fmaldora_orc_convo1.wav");
		CallEventDelayed(4.6f, "orc_talk1");
		CallEventDelayed(7.0f, "orc_talk2");
		CallEventDelayed(9.55f, "orc_talk3");
		CallEventDelayed(11.25f, "say_excuse_are_like_assholes");
	}

	// orc_talk1
	void OnOrcTalk1()
	{
		CallExternal(ORC_A_ID, "say_excuse1");
	}

	// orc_talk2
	void OnOrcTalk2()
	{
		CallExternal(ORC_B_ID, "say_minions");
	}

	// orc_talk3
	void OnOrcTalk3()
	{
		CallExternal(ORC_A_ID, "say_whadup");
	}

	// say_excuse_are_like_assholes
	void OnSayExcuseAreLikeAssholes()
	{
		PlayAnim("critical", ANIM_WAND);
		SayText("Enough!");
		PlaySound(0, 10, "voices/ms_wicardoven/fmaldora_orc_convo2.wav");
		CallEventDelayed(1.64f, "say_amulet");
	}

	// say_amulet
	void OnSayAmulet()
	{
		SayText("I told you! You cannot control the minions until I have Lor Malgoriand's amulet of...");
		PlaySound(0, 10, "voices/ms_wicardoven/fmaldora_orc_convo3.wav");
		CallEventDelayed(5.5f, "look_around");
	}

	// look_around
	void OnLookAround()
	{
		PlayAnim("critical", ANIM_LOOK);
		CallEventDelayed(1.0f, "say_deal_with");
	}

	// say_deal_with
	void OnSayDealWith()
	{
		SayText("Nevermind! I'll deal with " + PRO_NOUN + " myself!");
		PlaySound(0, 10, "voices/ms_wicardoven/fmaldora_orc_convo4.wav");

		PlayAnim("critical", ANIM_BOLT);
		PlaySound(0, 10, "debris/beamstart14.wav");
		CallEventDelayed(0.1f, "shock_ambience");

		Vector3 orcALoc = OriginOf(ORC_A_ID) + RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, 32)); // aim center
		Vector3 orcBLoc = OriginOf(ORC_B_ID) + RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, 32)); // aim center
		Vector3 myLoc = MyOrigin() + RelativePosition(Vector3(0, 0, 0), Vector3(0, 10, 72)); // start fingers

		Effect("beam", "point", "lgtning.spr", 30, myLoc, orcALoc, Vector3(255, 255, 255), 255, 10, 0.5f);
		Effect("beam", "point", "lgtning.spr", 30, myLoc, orcBLoc, Vector3(255, 255, 255), 255, 10, 0.5f);

		CallExternal(ORC_A_ID, "die");
		CallExternal(ORC_B_ID, "die");

		CallEventDelayed(3.1f, "lets_play");
	}

	// shock_ambience
	void OnShockAmbience()
	{
		PlaySound(0, 10, "magic/shock_noloop.wav");
	}

	// lets_play
	// Less chat, more action
	// { say_useless
	// saytext Be they under Valdor or Graznux, still... Useless!
	// callevent 2.0 lets_play
	// }
	void OnLetsPlay()
	{
		OnFaceTarget(EntityId(NPC_PROXACT_PLAYERID));
		WAND_TARGET = EntityId(NPC_PROXACT_PLAYERID);
		PlayAnim("critical", ANIM_ROCK);
		SayText("Now... Let us end this...");
		PlaySound(0, 10, "voices/ms_wicardoven/fmaldora_orc_convo5.wav");
		CallEventDelayed(0.5f, "combat_go");
	}

	// combat_go
	void OnCombatGo()
	{
		// callexternal BARRIER_ID remove_barrier
		BARRIER_ON = false;
		ClientEvent("update", "all", BARRIER_IDX, "clear_sprites");
		UseTrigger("maldora_seal");

		SetInvincible(false);
		SetMoveAnim(ANIM_RUN);
		COMBAT_ON = true;

		OnCycleUp();

		BARRIER_DELAY = true;
		CallEventDelayed(BARRIER_FREQ, "reset_barrier_delay");

		OnPickSpell();
		CallEventDelayed(1.0f, "movement_cycle");
		CallEventDelayed(LAVA_FREQ, "raise_lava");
	}

	// reset_barrier_delay
	void OnResetBarrierDelay()
	{
		BARRIER_DELAY = false;
	}

	// movement_cycle
	void OnMovementCycle()
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
	void OnResetProps()
	{
		CallEventDelayed(10.0f, "reset_props");

		// ocasionally turns invisible when added with glow shells
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
	}

	// thrash_strike
	// called from model
	void OnThrashStrike()
	{
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), "80%");
	}

	// pick_spell
	void OnPickSpell()
	{
		bool exitSub = false;

		SPELL_CHOICE = RandomInt(1, NUM_SPELLS);

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
				SPELL_CHOICE = RandomInt(2, NUM_SPELLS);
			if (!BARRIER_DELAY)
			{
				BARRIER_DELAY = true;
				CallEventDelayed(BARRIER_FREQ, "reset_barrier_delay");

				CallEventDelayed(0.1f, "raise_barrier");
			}
		}

		if (SPELL_CHOICE == 2)
		{
			BEAM_ON = true;
			OnFaceTarget(SPELL_TARGET);
			PlayAnim("critical", ANIM_BOLT);
			BEAM_COUNT = 0.0f;
			APPLIED_BEAM = false;
			BEAM_TARGET = SPELL_TARGET;
			CallEventDelayed(0.1f, "beam_push");
		}

		if (SPELL_CHOICE == 3)
		{
			CHAIN_ON = true;
			OnFaceTarget(SPELL_TARGET);
			PlayAnim("critical", ANIM_CAST);
			CHAIN_COUNT = 0.0f;
			CallEventDelayed(0.1f, "chain_lightning");
		}

		if (SPELL_CHOICE == 4)
		{
			PlayAnim("critical", ANIM_CAST);
			int numRocks = PlayerCount();
			if (numRocks > 4)
			{
				int numRucks = 4;
			}
			CreateNpc("monsters/summon/rock_storm", RelativePosition(Vector3(0, 0, 0)), self, numRocks, DMG_ROCKS, 64, 90); // <Owner> <#Rocks> <Dmg> <FX_Radius> <Letivtate_Height>
		}

		if (SPELL_CHOICE == 5)
		{
			if (IMAGES_ALIVE >= 1.0f)
				SPELL_CHOICE = RandomInt(6, NUM_SPELLS);
			if (IMAGES_ALIVE == 0.0f)
			{
				if (RandomInt(1, 3) == 1)
				{
					PlaySound(0, 10, "voices/ms_wicardoven/fmaldora_summon.wav");
					SayText("Shadows, of shadows, of shadows...");
				}
				CallEventDelayed(0.1f, "laugh_it_up");
				OnStopMoving();
				PlayAnim("critical", ANIM_CAST);
				PlaySound(0, 10, "magic/spawn.wav");
				Effect("glow", ENT_ME, Vector3(255, 255, 255), 128, 2, 2);
				SetSolid("none");
				CreateNpc(SHADOW_SCRIPT, RelativePosition(Vector3(0, 0, -35)), self, SPELL_TARGET, 45);
				CallEventDelayed(0.1f, "make_shadow2");
				CallEventDelayed(0.2f, "make_shadow3");
				CallEventDelayed(0.4f, "make_shadow4");

				IMAGES_ALIVE = 4.0f;
				OnRepulseBlast(); // stop players from getting stuck inside of me
				CallEventDelayed(1.0f, "resume_solid");
				CallEventDelayed(3.0f, "resume_moving");
			}
		}

		if (SPELL_CHOICE == 6)
		{
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
	void OnMakeShadow2()
	{
		CreateNpc(SHADOW_SCRIPT, RelativePosition(Vector3(0, 0, -35)), self, SPELL_TARGET, 135);
	}

	// make_shadow3
	void OnMakeShadow3()
	{
		CreateNpc(SHADOW_SCRIPT, RelativePosition(Vector3(0, 0, -35)), self, SPELL_TARGET, 225);
	}

	// make_shadow4
	void OnMakeShadow4()
	{
		CreateNpc(SHADOW_SCRIPT, RelativePosition(Vector3(0, 0, -35)), self, SPELL_TARGET, 315);
	}

	// repulse_blast
	void OnRepulseBlast()
	{
		REPULSE_ON = true;
		CallEventDelayed(1.0f, "reset_repulse");
		DoDamage(Text(RelativePosition(Vector3(0, 0, 0))), 96, 0.0f, "100%", 0.0f, "reflective", "target");
	}

	// reset_repulse
	void OnResetRepulse()
	{
		REPULSE_ON = false;
	}

	// laugh_it_up
	void OnLaughItUp()
	{
		PlaySound(0, 10, "monsters/skeleton/cal_laugh.wav");
	}

	// image_died
	void OnImageDied()
	{
		IMAGES_ALIVE -= 1.0f;
	}

	// leap_away
	// PARAM1 = dude to flee
	void OnLeapAway(string target = "")
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
	void OnLeapAway2()
	{
		PlayAnim("critical", ANIM_LEAP);
		CallEventDelayed(0.1f, "leap_boost");
	}

	// leap_boost
	void OnLeapBoost()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 400, 50)));
	}

	// swing_fist
	// PARAM1 = swing targ
	void OnSwingFist(string target = "")
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
	void OnStopMoving(float delay = 0.0f)
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
	void OnResumeSolid()
	{
		SetSolid("box");
	}

	// resume_moving
	void OnResumeMoving()
	{
		SetRoam(true);
		NO_STUCK_CHECKS = "0";
		NO_MOVE = false;
		SetMoveAnim(ANIM_RUN);
		ANIM_RUN = ANIM_RUN_NORM;
		ANIM_WALK = ANIM_WALK_NORM;
	}

	// raise_barrier
	void OnRaiseBarrier()
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
	void OnBarrierLoop()
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
	void OnBarrierAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(BARRIER_TARGS, loopIteration));

		// dbg barrier_affect_targets BARRIER_TARGS DMG_BARRIER
		// if ( DMG_BARRIER > 0 ) xdodamage CUR_TARG direct DMG_BARRIER 100% ent_me ent_me none magic
		Vector3 targOrg = OriginOf(curTarg);
		Vector3 myOrg = OriginOf(ENT_ME);
		float targAng = AnglesTo(myOrg, targOrg);
		SetVelocity(curTarg, RelativeVelocity(Vector3(0, targAng, 0), Vector3(0, 1000, 110)));
	}

	// lower_barrier
	void OnLowerBarrier()
	{
		BARRIER_ON = false;
		OnResumeMoving();
		CallExternal("BARRIER_ID", "remove_barrier");
	}

	// beam_push
	void OnBeamPush()
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

	// chain_lightning
	void OnChainLightning()
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
	void OnChainAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(CHAIN_LIST, loopIteration));
		float targRange = RangeTo(curTarg) * 1.5f;
		DoDamage(curTarg, targRange, DMG_CHAIN, "100%", ENT_ME, "lightning");
	}

	// strike_wand
	void OnStrikeWand()
	{
		AS_ATTACKING = GameTime();

		if (!(RangeTo(WAND_TARGET) < ATTACK_HITRANGE))
			return;
		WAND_ATK = true;
		DoDamage(WAND_TARGET, ATTACK_HITRANGE, DMG_WAND, "80%", "blunt");
	}

	// quick_spell
	void OnQuickSpell()
	{
		AS_ATTACKING = GameTime();
	}

	// quick_bolt
	void OnQuickBolt()
	{
		AS_ATTACKING = GameTime();
	}

	// raise_lava
	void OnRaiseLava()
	{
		PlayAnim("critical", ANIM_CAST);
		UseTrigger("multilava");
		CallEventDelayed(LAVA_FREQ, "raise_lava");
	}

	// face_target
	// npcatk_faceattacker does not work with AI suspended
	void OnFaceTarget(string target = "")
	{
		NPC_FORCED_MOVEDEST = true;
		SetMoveDest(target, 9999);
	}

	// skele_died
	void OnSkeleDied()
	{
		MINIONS_ALIVE -= 1.0f;
	}

	// init_beam_push
	void OnInitBeamPush()
	{
		Effect("beam", "ents", "lgtning.spr", 200, self, 2, self, 0, Vector3(255, 255, 0), 0, 20, 30.0f); // try -1
		@PUSH_BEAM_ID = EntityOf(ENT_LASTCREATED);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnBarrierFreq() {} // BARRIER_FREQ
	void OnLavaFreq() {} // LAVA_FREQ
	void OnSpellFreq() {} // SPELL_FREQ
	void OnNpcatkGoMovedest() {} // npcatk_go_movedest

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/maldora.mdl");
		Precache("monsters/skeleton_boss1.mdl");
		Precache("rockgibs.mdl");
		Precache("monsters/orc.mdl");
		CallEventDelayed(10.0f, "reset_props");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MsWicardovenMaldora_FirstThink();
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
		if (name == "barrier_affect_targets") { OnBarrierAffectTargets(); return true; }
		if (name == "barrier_loop") { OnBarrierLoop(); return true; }
		if (name == "beam_push") { OnBeamPush(); return true; }
		if (name == "chain_affect_targets") { OnChainAffectTargets(); return true; }
		if (name == "chain_lightning") { OnChainLightning(); return true; }
		if (name == "combat_go") { OnCombatGo(); return true; }
		if (name == "face_orcs") { OnFaceOrcs(); return true; }
		if (name == "face_orcs2") { OnFaceOrcs2(); return true; }
		if (name == "face_target") { OnFaceTarget(Param(params, 0)); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "get_orc_ids") { OnGetOrcIds(); return true; }
		if (name == "image_died") { OnImageDied(); return true; }
		if (name == "init_beam_push") { OnInitBeamPush(); return true; }
		if (name == "laugh_it_up") { OnLaughItUp(); return true; }
		if (name == "leap_away") { OnLeapAway(Param(params, 0)); return true; }
		if (name == "leap_away2") { OnLeapAway2(); return true; }
		if (name == "leap_boost") { OnLeapBoost(); return true; }
		if (name == "lets_play") { OnLetsPlay(); return true; }
		if (name == "look_around") { OnLookAround(); return true; }
		if (name == "lower_barrier") { OnLowerBarrier(); return true; }
		if (name == "make_barrier") { OnMakeBarrier(); return true; }
		if (name == "make_shadow2") { OnMakeShadow2(); return true; }
		if (name == "make_shadow3") { OnMakeShadow3(); return true; }
		if (name == "make_shadow4") { OnMakeShadow4(); return true; }
		if (name == "movement_cycle") { OnMovementCycle(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "orc_talk1") { OnOrcTalk1(); return true; }
		if (name == "orc_talk2") { OnOrcTalk2(); return true; }
		if (name == "orc_talk3") { OnOrcTalk3(); return true; }
		if (name == "pick_spell") { OnPickSpell(); return true; }
		if (name == "quick_bolt") { OnQuickBolt(); return true; }
		if (name == "quick_spell") { OnQuickSpell(); return true; }
		if (name == "raise_barrier") { OnRaiseBarrier(); return true; }
		if (name == "raise_lava") { OnRaiseLava(); return true; }
		if (name == "repulse_blast") { OnRepulseBlast(); return true; }
		if (name == "reset_barrier_delay") { OnResetBarrierDelay(); return true; }
		if (name == "reset_props") { OnResetProps(); return true; }
		if (name == "reset_repulse") { OnResetRepulse(); return true; }
		if (name == "resume_moving") { OnResumeMoving(); return true; }
		if (name == "resume_solid") { OnResumeSolid(); return true; }
		if (name == "say_amulet") { OnSayAmulet(); return true; }
		if (name == "say_deal_with") { OnSayDealWith(); return true; }
		if (name == "say_excuse_are_like_assholes") { OnSayExcuseAreLikeAssholes(); return true; }
		if (name == "shock_ambience") { OnShockAmbience(); return true; }
		if (name == "skele_died") { OnSkeleDied(); return true; }
		if (name == "start_convo") { OnStartConvo(); return true; }
		if (name == "stop_moving") { OnStopMoving(Float(Param(params, 0))); return true; }
		if (name == "strike_wand") { OnStrikeWand(); return true; }
		if (name == "swing_fist") { OnSwingFist(Param(params, 0)); return true; }
		if (name == "thrash_strike") { OnThrashStrike(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
