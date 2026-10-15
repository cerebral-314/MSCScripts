#pragma context server

// Converted from monsters/skeleton_ice_lord.script by msc_transpiler.
// Ice Bone Lord by Thothie from Blacksmith

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/skeleton_ice_lord"]
class SkeletonIceLord : BaseMonsterNewScript
{
	// Constants
	bool NPC_NO_RAMP = true;
	string SOUND_INTRO1 = "npc/ice_queen_live_beating2.wav";
	string SOUND_INTRO2 = "npc/ice_queen_put_that_on_ice2.wav";
	string SOUND_STAGETWO1 = "npc/ice_queen_cant_pronounce_loreldians2.wav";
	string SOUND_STAGETWO2 = "npc/ice_queen_game2.wav";
	string SOUND_FINAL1 = "npc/ice_queen_powah2.wav";
	string SOUND_FINAL2 = "npc/ice_queen_die2.wav";
	string SOUND_STRUCK1 = "controller/con_pain2.wav";
	string SOUND_STRUCK2 = "controller/con_pain3.wav";
	string SOUND_ATTACK1 = "zombie/claw_strike1.wav";
	string SOUND_ATTACK2 = "zombie/claw_strike2.wav";
	string SOUND_ATTACK3 = "zombie/claw_strike3.wav";
	string SOUND_FLINCH1 = "npc/ice_queen_pain2.wav";
	string SOUND_FLINCH2 = "garg/gar_pain2.wav";
	string SOUND_PUSH1 = "npc/ice_queen_throw2.wav";
	string SOUND_PUSH2 = "npc/ice_queen_throw3.wav";
	string SOUND_FALL = "weapons/mortarhit.wav";
	string ANIM_BASERUN = "walk";
	string ANIM_BASEIDLE = "idle1";
	string ANIM_BASEWALK = "walk";
	int ATTACK1_RANGE = 160;
	int ATTACK2_RANGE = 160;
	string MAX_HP = "3000";
	int ATTACK_CLUB_RANGE = 200;
	string ANIM_THROW = "throw_scientist";
	string SOUND_STEP1 = "debris/glass1.wav";
	string SOUND_STEP2 = "debris/glass2.wav";
	string SOUND_STEP3 = "debris/glass3.wav";
	string SOUND_LAUGH = "monsters/skeleton/cal_laugh.wav";
	string SOUND_FAKEDEATH1 = "garg/gar_die2.wav";
	string SOUND_FAKEDEATH2 = "garg/gar_die1.wav";
	string SOUND_FINAL = "gonarch/gon_die1.wav";
	string SOUND_WHACK = "zombie/claw_strike1.wav";
	string SOUND_REGEN = "x/x_laugh2.wav";
	string SOUND_POWERUP = "ambience/particle_suck2.wav";
	string ANIM_FAKEDEATH = "dieforward";
	string ANIM_DEAD = "dead_on_stomach";
	string ANIM_ALTTHROW = "bigflinch";
	float TAUNT_DELAY = 2.0f;
	float GETUP_DELAY = 8.0f;
	float SPECATK_FREQ_CIRCLE = 20.0f;
	float SPECATK_FREQ_FREEZE = 20.0f;
	int FEIGN_THRESHOLD = 500;
	float DAMAGE_NORM1 = 0.0f;
	float DAMAGE_NORM2 = 0.0f;
	float DAMAGE_BALL1 = 0.0f;
	float DAMAGE_BALL2 = 0.0f;
	float DAMAGE_CLUBS1 = 0.0f;
	int DAMAGE_CLUBS2 = 200;
	string CIRCLE_SCRIPT = "monsters/summon/circle_of_ice_greater";
	string XSEAL_MODEL = "weapons/magic/seals.mdl";
	string SOUND_MANIFEST = "magic/spawn_loud.wav";
	string XSOUND_PULSE = "magic/frost_forward.wav";
	string XSOUND_FADE = "magic/frost_reverse.wav";
	string XFX_SPRITE = "firemagic.spr";
	string ICE_BLAST_SCRIPT = "monsters/summon/ice_blast";
	string SOUND_FREEZE = "magic/freeze.wav";
	string XSOUND_HOVERLOOP = "ambience/alienwind1.wav";
	string XSOUND_HITWALL = "ambience/alienlaser1.wav";
	string XLIGHTNING_SPRITE = "lgtning.spr";
	string SOUND_ICEBLAST = "magic/temple.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_SLASH = "ANIM_SLASH";
	string ANIM_SMASH = "ANIM_SMASH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	int MOVE_RANGE1 = 0;
	int MOVE_RANGE2 = 0;
	bool SEE_ENEMY = false;
	bool IGNORE_ENEMY = false;
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	string CAN_HUNT = "CAN_HUNT";
	string CAN_ATTACK = "CAN_ATTACK";
	string NPC_MOVE_TARGET = "NPC_MOVE_TARGET";
	string ATTACK_MODE = "ATTACK_MODE";
	float STEP_COUNTER = 0.0f;
	string ANIM_FLINCH = "ANIM_FLINCH";
	float STUCK_CHECK_FREQUENCY = 0.0f;
	bool I_AM_TURNABLE = false;
	bool WAS_SNOWING = false;
	float SPEC_ATK_FREQUENCY = 0.0f;
	float ALT_ATTACK = 0.0f;
	CBaseEntity@ PASS_THIS_POS = null;
	bool PURE_FLEE = false;
	bool DID_WARCRY = false;
	string HIT_RECENT = "HIT_RECENT";

	// Variables declared by included files, with the value they start with in this script
	SkeletonIceLord()
	{
		NPC_BOSS_REGEN_RATE = 0.0f;
		NPC_BOSS_RESTORATION = 0.0f;
		ANIM_RUN = "walk";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		SOUND_DEATH = "npc/undamael2.wav";
	}

	// unnamed block (first think)
	void SkeletonIceLord_FirstThink()
	{
		if (ToLowerCase(MapName()) == "ms_snow")
		{
			NPC_GIVE_EXP = 4000.0f; // pain to reach
			NPC_IS_BOSS = true;
		}
		else
		{
			NPC_GIVE_EXP = 1000.0f;
		}
		ANIM_RUN = "walk";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_SLASH = "attack1";
		ANIM_SMASH = "attack2";
		ANIM_ATTACK = ANIM_SMASH;
		ATTACK_RANGE = ATTACK1_RANGE;
		MOVE_RANGE1 = 80;
		MOVE_RANGE2 = 80;
		MOVE_RANGE = MOVE_RANGE1;
		ATTACK_HITRANGE = 300.0f;
		SEE_ENEMY = false;
		IGNORE_ENEMY = false;
		CAN_FLINCH = "0";
		FLINCH_ANIM = "bigflinch";
		FLINCH_CHANCE = "10";
		FLINCH_DELAY = "1";
		CAN_HUNT = "1";
		CAN_ATTACK = "1";
		NPC_MOVE_TARGET = "enemy";

		// Precache
		// precache SOUND_DEATH //handled externally
		FLINCH_HEALTH = 1000.0f;
		ATTACK_MODE = "normal";
		// const SOUND_STEP4 debris/glass4.wav
		STEP_COUNTER = 0.0f;
		ANIM_DEATH = "dieforward";
		ANIM_FLINCH = "flinch";

		STUCK_CHECK_FREQUENCY = 3.5f; // plays lengthy still anims
		MONSTER_WIDTH = 40;
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string SkeletonIceLord_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool doingSecondary = false;
		string result = "";

		if (!hit)
			return result;

		if (ATTACK_MODE == "normal" && RandomInt(1, 20) == 1)
		{
			// playanim critical ANIM_THROW
			PlayRandomSound(0, 10, SOUND_PUSH1, SOUND_PUSH2);
			PlayAnim("once", ANIM_ALTTHROW);
			@PASS_THIS_POS = target;
			CallEventDelayed(0.2f, "throw_chummer");
			doingSecondary = true;
		}

		if (ATTACK_MODE == "freeze_ball" && RandomInt(1, 15) == 1)
		{
			// playanim critical ANIM_THROW
			PlayRandomSound(0, 10, SOUND_PUSH1, SOUND_PUSH2);
			PlayAnim("once", ANIM_ALTTHROW);
			@PASS_THIS_POS = target;
			CallEventDelayed(0.2f, "throw_chummer");
			doingSecondary = true;
		}

		if (ATTACK_MODE == "final" && RandomInt(1, 20) == 1)
		{
			// playanim critical ANIM_THROW
			PlayRandomSound(0, 10, SOUND_PUSH1, SOUND_PUSH2);
			PlayAnim("once", ANIM_ALTTHROW);
			@PASS_THIS_POS = target;
			CallEventDelayed(0.2f, "throw_chummer");
			doingSecondary = true;
		}

		if (doingSecondary)
			return result;
		if (ANIM_ATTACK == ANIM_SMASH)
			PlaySound(0, 10, SOUND_WHACK);
		return result;
	}

	// game_damaged_other
	string SkeletonIceLord_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		if (ATTACK_MODE != "final")
			return result;
		if (Float(HIT_RECENT) != 0.0f)
			return result;
		HIT_RECENT = EntityId(target);
		CallEventDelayed(0.5f, "hit_recent_reset");
		return result;
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, SkeletonIceLord_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// game_struck
	// Hit by someone
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared

		float myHp = HealthOf(ENT_ME);
		float outHp = myHp - damage;

		// dbg MyHp MY_HP
		if (ATTACK_MODE != "final" && outHp <= FEIGN_THRESHOLD)
			OnFallDown();

		if (HealthOf(ENT_ME) < 1000.0f)
			CAN_FLINCH = "1";

		SetVolume(5);
		PlayRandomSound(5, GetVar("CHAN_BODY"), 10, SOUND_STRUCK1, SOUND_STRUCK2);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		I_AM_TURNABLE = false;

		SetHealth(Float(MAX_HP));
		SetGold(RandomInt(100, 300));
		// ov 359
		SetWidth(40);
		SetHeight(120);
		SetRace("undead");
		int pickName = RandomInt(1, 2);
		if (pickName == 1)
			SetName("Ice Bone Lord");
		if (pickName == 2)
			SetName("Ice Queen");
		SetRoam(false);
		SetHearingSensitivity(6);
		SetModel("monsters/skeleton_icel.mdl");
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		PlayAnim("once", ANIM_IDLE);
		SetDamageTaken("all", 0.6f);

		SetDamageTaken("fire", 1.25f);
		SetDamageTaken("poison", 0);
		SetDamageTaken("cold", 0);
		SetDamageTaken("slash", 0.5f);
		SetDamageTaken("pierce", 0.5f);
		SetDamageTaken("lightning", 0.4f);
		SetDamageTaken("holy", 1.25f);

		if (GetVar("G_CURRENT_WEATHER") == "snow")
			WAS_SNOWING = true;

		SPEC_ATK_FREQUENCY = SPECATK_FREQ_CIRCLE;
		CallEventDelayed(SPEC_ATK_FREQUENCY, "spec_attack");

		// needs a manifest effect here
		PlaySound(0, 10, SOUND_FREEZE);
		// effect glow <target> <(r,g,b)> <amount> <duration> <fadeduration>
		Effect("glow", ENT_ME, Vector3(255, 255, 255), 512, 5, 5);
		CallEventDelayed(0.1f, "finish_manifest");
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new

		if (!DID_WARCRY)
		{
			CallEventDelayed(1.0f, "pre_taunt");
			CallEventDelayed(5.0f, "taunt0");
			PlayAnim("once", ANIM_THROW);
			DID_WARCRY = true;
		}
	}

	// my_target_died
	// PARAM1 equals target slain
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new

		// regenerate on kill in mode 3
		if (ATTACK_MODE != "final")
			return;
		if (HIT_RECENT != offender)
			return;
		SetHealth(Float(MAX_HP));
		Effect("glow", ENT_ME, Vector3(0, 255, 0), 255, 5, 5);
		PlaySound(0, 10, SOUND_REGEN);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, SkeletonIceLord_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// finish_manifest
	void OnFinishManifest()
	{
		PlaySound(0, 10, SOUND_ICEBLAST);
	}

	// attack_1
	// called by model anim attack2
	void OnAttack12()
	{
		if (ATTACK_MODE == "normal")
		{
			if (RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE)
				OnNpcatkDodamage(NPCATK_TARGET, "direct", Text(DAMAGE_NORM1), "75%", EntityId(self), "slash");

			if (RandomInt(1, 3) == 1)
				ANIM_ATTACK = ANIM_SMASH;
		}

		if (ATTACK_MODE == "freeze_ball")
		{
			if (RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE)
				OnNpcatkDodamage(NPCATK_TARGET, "direct", Text(DAMAGE_BALL1), "80%", EntityId(self), "slash");

			if (RandomInt(1, 10) == 1)
				ANIM_ATTACK = ANIM_SMASH;
		}

		if (ATTACK_MODE == "final")
		{
			if (RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE)
			{
				OnNpcatkDodamage(NPCATK_TARGET, "direct", Text(DAMAGE_CLUBS1), "85%", EntityId(self), "blunt");
				if (RandomInt(1, 10) == 1)
					ApplyEffect(NPCATK_TARGET, "effects/debuff_stun", 2, self);
			}

			ALT_ATTACK += 1.0f;
			if (ALT_ATTACK >= 16.0f)
			{
				ANIM_ATTACK = ANIM_SMASH;
				ALT_ATTACK = 0.0f;
			}
		}
	}

	// attack_2
	// called by model anim attack1
	void OnAttack22()
	{
		if (ATTACK_MODE == "normal")
		{
			ANIM_ATTACK = ANIM_SLASH;
			if (RangeTo(NPCATK_TARGET) < ATTACK2_RANGE)
			{
				OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK2_RANGE), Text(DAMAGE_NORM2), "100%");
				ApplyEffect(NPCATK_TARGET, "effects/effect_push", 1, RelativeVelocity(Vector3(0, 200, 30)), 0);
				PlaySound(Int(GetVar("CHAN_VOICE")), 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
			}
		}

		if (ATTACK_MODE == "freeze_ball")
		{
			ANIM_ATTACK = ANIM_SLASH;
			if (RangeTo(NPCATK_TARGET) < ATTACK2_RANGE)
			{
				OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK2_RANGE), Text(DAMAGE_BALL2), "100%");
				ApplyEffect(NPCATK_TARGET, "effects/dot_cold", 5, self, RandomInt(3, 5), "none");
				PlaySound(Int(GetVar("CHAN_VOICE")), 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
			}
		}

		if (ATTACK_MODE == "final")
		{
			ANIM_ATTACK = ANIM_SLASH;
			if (RangeTo(NPCATK_TARGET) < ATTACK2_RANGE)
			{
				OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK2_RANGE), Text(DAMAGE_CLUBS2), "100%");
				AddVelocity(NPCATK_TARGET, RelativeVelocity(Vector3(0, 300, 60)));
				ApplyEffect(NPCATK_TARGET, "effects/debuff_stun", 5, self);
				PlaySound(Int(GetVar("CHAN_VOICE")), 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
			}
		}
	}

	// npc_flinch
	// { npc_attack
	// if( $rand(0,10) > 9 )
	// {
	// setvard ANIM_ATTACK ANIM_SMASH
	// setvard ATTACK_RANGE ATTACK1_RANGE
	// setvard MOVE_RANGE MOVE_RANGE1
	// }
	// else
	// {
	// setvard ANIM_ATTACK ANIM_SLASH
	// setvard ATTACK_RANGE ATTACK2_RANGE
	// setvard MOVE_RANGE MOVE_RANGE2
	// }
	// }
	void OnNpcFlinch(float damage = 0.0f)
	{
		PlayRandomSound(Int(GetVar("CHAN_BODY")), 10, SOUND_FLINCH1, SOUND_FLINCH2);
	}

	// throw_chummer
	void OnThrowChummer()
	{
		// PARAM1 ent to be thrown
		Vector3 myNmePos = OriginOf(ENT_LASTSTRUCKBYME);
		Vector3 myMePos = OriginOf(ENT_ME);
		float nmeDist = Distance(myNmePos, myMePos);

		// //dbg ThrowChummerGot p1 PARAM1 range NME_DIST vs ATTACK2_RANGE
		if (!(nmeDist < ATTACK2_RANGE))
			return;
		ApplyEffect(PASS_THIS_POS, "effects/effect_push", 3, RelativeVelocity(Vector3(0, 800, 800)), 0);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (!WAS_SNOWING)
			CallExternal("players", "ext_weather_change", "clear");

		if (!Truthy(GetVar("G_CHRISTMAS_MODE")))
			PlaySound(0, 10, "debris/bustglass3.wav");
		if (Truthy(GetVar("G_CHRISTMAS_MODE")))
			PlaySound(0, 10, "npc/happy_hogswatch.wav");
		Effect("tempent", "gibs", "glassgibs.mdl", RelativePosition(Vector3(0, 0, 256)), 1, 40, 10, 100, 30);
		CreateNpc("monsters/summon/sfx_glassmaker", RelativePosition(Vector3(0, 0, 0)));

		SetModel("none");
		SetBoundingBox("none");
		SetSolid("none");

		UseTrigger("ice_lord_died", "icedungeon_exit");

		// tempent gibs <modelname/spritename> <position> <size> <velocity> <randomness> <amount> <duration>
		CallEventDelayed(0.1f, "final_death");
	}

	// walk_step
	// called by anim walk @ frames 2,12,22,31,41,51
	void OnWalkStep()
	{
		STEP_COUNTER += 1.0f;
		if (STEP_COUNTER == 1.0f)
			PlaySound(0, 5, SOUND_STEP1);
		if (STEP_COUNTER == 2.0f)
			PlaySound(0, 5, SOUND_STEP2);
		if (STEP_COUNTER == 3.0f)
		{
			PlaySound(0, 5, SOUND_STEP3);
			STEP_COUNTER = 0.0f;
		}
	}

	// fall_down
	void OnFallDown()
	{
		if (ATTACK_MODE == "final")
			return;

		OnNpcatkSuspendAi();

		CANT_TURN = "1";

		SetBoundingBox("npcsize");

		// setvard STORED_TARGET HUNT_LASTTARGET
		SetMoveDest("none");

		CAN_FLINCH = "0";
		SetHealth(Float(MAX_HP));
		// dbg Hitpoints Reset
		SetInvincible(true);
		SetMoveDest("none");

		// race beloved //failed attempt to make playing dead skele a invalid target (destroys AI)
		PlayAnim("critical", ANIM_FAKEDEATH);

		SetIdleAnim(ANIM_DEAD);
		SetMoveAnim(ANIM_DEAD);

		ANIM_ATTACK = ANIM_DEAD;
		ANIM_RUN = ANIM_DEAD;
		ANIM_IDLE = ANIM_DEAD;
		ANIM_WALK = ANIM_DEAD;

		IS_FLEEING = true;
		PURE_FLEE = true;
		PLAYING_DEAD = "1";

		CallEventDelayed(1.0f, "stay_down_damnit");

		// setvard CAN_ATTACK 0
		// setvard CAN_HUNT 	0
		// setvard CAN_HEAR	0
		SetMoveSpeed(0);

		// dbg temp atk mode before ATTACK_MODE
		if (ATTACK_MODE == "freeze_ball")
		{
			ATTACK_MODE = "final";
			PlaySound(0, 10, SOUND_FAKEDEATH2);
			CallEventDelayed(TAUNT_DELAY, "taunt2");
			CallEventDelayed(GETUP_DELAY, "get_up");
		}

		if (ATTACK_MODE == "normal")
		{
			ATTACK_MODE = "freeze_ball";
			PlaySound(0, 10, SOUND_FAKEDEATH1);
			CallEventDelayed(TAUNT_DELAY, "taunt1");
			CallEventDelayed(GETUP_DELAY, "get_up");
		}

		// dbg temp atk mode after ATTACK_MODE
		SetBoundingBox("npcsize");
	}

	// npcatk_faceattacker
	// PARAM1: Entity to face
	void OnNpcatkFaceattacker(string target = "")
	{
		// some wierd stuff going on here, he's doing stuff in flee mode he shouldn't be able to
		if (IS_FLEEING)
			return;
		if (Truthy(PLAYING_DEAD))
			return;

		SetMoveDest(@EntityOf(target), 9999);
		Look(1024); // Thothie - I can't find documentation on this command
	}

	// stay_down_damnit
	// can't get him to stay down for the life of me second time around
	void OnStayDownDamnit()
	{
		if (!Truthy(PLAYING_DEAD))
			return;
		SetIdleAnim(ANIM_DEAD);
		SetMoveAnim(ANIM_DEAD);
		SetBoundingBox("npcsize");
		CallEventDelayed(1.0f, "stay_down_damnit");
	}

	// taunt1
	void OnTaunt1()
	{
		PlaySound(0, 10, SOUND_STAGETWO1);
		SetSayTextRange(2048);
		SayText("Hahaaa! I've not had this much fun since the Loreldians were here!");
	}

	// taunt2
	void OnTaunt2()
	{
		PlaySound(0, 10, SOUND_FINAL1);
		SetSayTextRange(2048);
		SayText("Good, good, maybe you are worthy of my full power...");
	}

	// get_up
	void OnGetUp()
	{
		CANT_TURN = "0";
		SetBoundingBox("npcsize");
		if (ATTACK_MODE == "freeze_ball")
		{
			SetSayTextRange(2048);
			PlaySound(0, 10, SOUND_STAGETWO2);
			SayText("Shall we continue this little game?");
		}
		SetIdleAnim(ANIM_IDLE);
		Effect("glow", ENT_ME, Vector3(128, 128, 255), 512, 3, 3);
		PlayAnim("critical", "getup");
	}

	// getup_done
	// called by anim getup @ frame 29
	void OnGetupDone()
	{
		SetBoundingBox("npcsize");
		SetSolid("box");

		// race undead
		OnNpcatkResumeAi();

		// dbg Getup_done anim played
		// setmovedest	HUNT_LASTTARGET 9999
		ANIM_RUN = ANIM_BASERUN;
		ANIM_IDLE = ANIM_BASEIDLE;
		ANIM_WALK = ANIM_BASEWALK;
		ANIM_ATTACK = ANIM_SMASH;

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_RUN);
		SetRoam(true);
		SetInvincible(false);
		IS_FLEEING = false;
		PURE_FLEE = false;
		PLAYING_DEAD = "0";

		// setvard CAN_ATTACK 1
		// setvard CAN_HUNT 	1
		// setvard CAN_RETALIATE	1
		// setvard CAN_HEAR	1
		if (ATTACK_MODE != "final")
			SetMoveSpeed(1);

		if (ATTACK_MODE != "final")
			return;

		// playanim critical ANIM_THROW
		// screenfade <target/"all"> <duration> <holdtime> <(r,g,b)> <alpha> <fadin|fadeout|noblend|perm>
		Effect("screenfade", "all", 3, 1, Vector3(255, 255, 255), 255, "fadein");

		// screenshake <position> <amplitude> <frequency> <duration> <radius>
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 190, 30, 3.0f, 2048);

		Effect("glow", ENT_ME, Vector3(255, 255, 255), 512, 5, 5);

		SetSayTextRange(2048);
		PlaySound(0, 10, SOUND_FINAL2);
		SayText("NOW YOU WILL ALL DIE!!!");

		CallEventDelayed(1.0f, "give_clubs");
	}

	// give_clubs
	void OnGiveClubs()
	{
		STUCK_CHECK_FREQUENCY = 2.5f; // movin faster now, and no more long anims
		PlaySound(0, 10, SOUND_POWERUP);
		SetModelBody(0, 1);
		SetMoveSpeed(3);
		SetProp(ENT_ME, "animtime", 3.0f);
		Effect("screenfade", "all", 3, 1, Vector3(255, 255, 255), 128, "fadeout");
		// effect screenfade all 1 0 0 0 fadein
		ALT_ATTACK = 1.0f;
	}

	// pre_taunt
	void OnPreTaunt()
	{
		SetSayTextRange(2048);
		PlaySound(0, 10, SOUND_INTRO1);
		SayText("Ah, the warm fire of live beating heart...");
	}

	// taunt0
	void OnTaunt0()
	{
		SetSayTextRange(2048);
		PlaySound(0, 10, SOUND_INTRO2);
		SayText("We'll just have to put that on ice.");
	}

	// spec_attack
	void OnSpecAttack()
	{
		if (ATTACK_MODE == "normal")
		{
			// circle of ice
			if (!Truthy(PLAYING_DEAD))
			{
				if (CanSee("enemy"))
				{
					PlayAnim("critical", ANIM_THROW);
					STUCK_COUNT = 0.0f;
					PlaySound(0, 10, SOUND_MANIFEST);
					Effect("glow", ENT_ME, Vector3(128, 128, 255), 80, 3, 0);
					CallEventDelayed(1.5f, "circle_of_ice");
				}
				SPEC_ATK_FREQUENCY = SPECATK_FREQ_CIRCLE;
			}
		}

		if (ATTACK_MODE == "freeze_ball")
		{
			// freeze ball
			if (!Truthy(PLAYING_DEAD) && CanSee("enemy"))
			{
				Effect("glow", ENT_ME, Vector3(128, 128, 255), 80, 3, 2);
				PlaySound(0, 10, SOUND_MANIFEST);
				CallEventDelayed(2.0f, "toss_iceball");
				SPEC_ATK_FREQUENCY = SPECATK_FREQ_FREEZE;
			}
		}

		CallEventDelayed(SPEC_ATK_FREQUENCY, "spec_attack");
	}

	// circle_of_ice
	void OnCircleOfIce()
	{
		if (Truthy(PLAYING_DEAD))
			return;

		STUCK_COUNT = 0.0f;

		CreateNpc(CIRCLE_SCRIPT, RelativePosition(Vector3(0, 0, 0)), self, 10.0f, 10.0f);
	}

	// toss_iceball
	void OnTossIceball()
	{
		if (Truthy(PLAYING_DEAD))
			return;

		Vector3 ballDest = RelativePosition(Vector3(0, 2000, 0));
		// dbg Foward BALL_DEST
		PlaySound(0, 10, SOUND_ICEBLAST);
		CreateNpc(ICE_BLAST_SCRIPT, RelativePosition(Vector3(0, 64, 32)), self, 10.0f, ballDest); // $get(ent_lastseen,origin) - works but goes into ground
	}

	// hit_recent_reset
	void OnHitRecentReset()
	{
		HIT_RECENT = "0";
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnGetupDelay() {} // GETUP_DELAY
	void OnSpecAtkFrequency() {} // SPEC_ATK_FREQUENCY
	void OnTauntDelay() {} // TAUNT_DELAY

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/magic/seals.mdl");
		Precache("firemagic.spr");
		Precache("lgtning.spr");
		Precache("monsters/skeleton_icel.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SkeletonIceLord_FirstThink();
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
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "circle_of_ice") { OnCircleOfIce(); return true; }
		if (name == "fall_down") { OnFallDown(); return true; }
		if (name == "finish_manifest") { OnFinishManifest(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "get_up") { OnGetUp(); return true; }
		if (name == "getup_done") { OnGetupDone(); return true; }
		if (name == "give_clubs") { OnGiveClubs(); return true; }
		if (name == "hit_recent_reset") { OnHitRecentReset(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_flinch") { OnNpcFlinch(Float(Param(params, 0))); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_faceattacker") { OnNpcatkFaceattacker(Param(params, 0)); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "pre_taunt") { OnPreTaunt(); return true; }
		if (name == "spec_attack") { OnSpecAttack(); return true; }
		if (name == "stay_down_damnit") { OnStayDownDamnit(); return true; }
		if (name == "taunt0") { OnTaunt0(); return true; }
		if (name == "taunt1") { OnTaunt1(); return true; }
		if (name == "taunt2") { OnTaunt2(); return true; }
		if (name == "throw_chummer") { OnThrowChummer(); return true; }
		if (name == "toss_iceball") { OnTossIceball(); return true; }
		if (name == "walk_step") { OnWalkStep(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
