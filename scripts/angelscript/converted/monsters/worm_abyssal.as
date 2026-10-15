#pragma context server

// Converted from monsters/worm_abyssal.script by msc_transpiler.
// descript/requirements
// � monsters/worm_abyssal - The Abyssal Worm (hard demon, 128x700, 18000hp, baseXP 3000)
// - This is a special giant worm monster, that requires various map ents to operate properly.
// - Intent is to move about a platform in the center of his chamber, and attack players standing thereon.
// - Requires the following entities:
// - info_target's with targetnames: worm_telepoint1 worm_telepoint2 worm_telepoint3 and worm_telepoint4
// -- The worm will periodically submerge and re-emerge at these points in sequence.
// -- He will do this every ~60 seconds, and when first damaged below 75%, 50%, and 25% of his maximum HP
// - info_target with targetname: worm_telepoint_final
// -- Upon falling below 25% health, the worm will submerge, and re-emerge at this point. He will not teleport nor submerge again.
// -- In this case, the point is at the center of the platform, allowing him to use his stronger, close range attacks, against all targets on the platform.
// -- He will fire brk_worm as he re-emerges, breaking the stone in the center of the platform, and produce a repulsive field, to prevent players from falling in the resulting hole.
// -- (In this case, the hole is invisibly sealed, so this can't actually happen, but it prevents the otherwise odd results of walking on air and floating through him - the actual worm is not solid.)
// - info_target with targetname: worm_repel_point
// -- This marks the loc from which to generate the aforementioned repulsive field.
// - trigger_multiple with scriptevent: gm_map_rmines_dinnerbell, with 10 second reset delay, flagged to only work on clients
// -- This trigger causes the Game Master to alert the worm that there is a player on his platform
// -- If no player is on the platform for at least 15 seconds, the worm will submerge (is invulnerable while submerged), until new meat is placed on his table.
// - light with targetname: light_worm (start dark) [optional]
// -- Triggered on when in final position - in this case, the monster model is popping up through a clip brush, so it needs this light to avoid being rendered as a black silhouette.
// -- In this instance, the light is turned off again on death, map side.
// - Known issues: The worm is kinda setup like Undamael, and can be difficult to strike, but improvements to the system mitigate this to a great degree.
// - Additionally, unlike Undamael, DOT effects used against his "hitbox npc" will pass to the actual mob.
// - The worm can only be struck about the head area, not the body or arms.
// - Worm has several different attacks for dealing with targets at various ranges, some of which are AOE.
// - He will usually favor the closest target. The closer attacks are stronger, but the longer ranged ones are AOE and apply Dark Damage DOT.
// - Additionally, he has a stunning eye beam with an AOE effect - though it also a fair amount of warning. He'll favor it, if players try to stay out of reach.
// - Dark energy will actually heal the Abyssal Worm. His Dark Energy DOT also adds Darkness contamination to players.
// - This mob uses name_unique for management, thus only one can exist at a time.
// internal notes:
// Weird stuff happens with models this big - they ignore their normal bbox, and somehow have one that represents their actual size, and even polies.
// ...Which would be great, except it moves with them, causing players to be stuck inside, and thus imobilized.
// This mysterious secondary hull also does not function as a hitbox, so you can't get close enough to actually hit the mob.
// Think maybe it's defaulting to animsize when mob is over a certain size, but changing it to a fixed sized bbox doesn't undo it.
// Anywho... This works around that by removing this mob's collision box, and attaching an NPC that acts as a hitbox (monsters/worm_abyssal_head), which passes damage to this mob.
// Downside is it blinds the mob, but as seen below, this can be worked around.
// Given that the mob's "eyes" are at its feat (~600 units below the players) the mob would be basically blind anyways.
// Some of the work arounds for this involve measuring attacks in Range2D (thus ignoring the height difference), and tracing attacks from its eye attachment, instead of its base.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_struck.as"

[script "monsters/worm_abyssal"]
class WormAbyssal : BaseMonsterNewScript, BaseStruck
{
	// Constants
	bool NPC_NO_VADJ = true;
	string ANIM_FLINCH = "flinch1";
	string ANIM_RISE = "rise";
	string ANIM_LOWER = "lower";
	string ANIM_IDLE_UP = "idle2";
	string ANIM_FLINCH1 = "flinch1";
	string ANIM_FLINCH2 = "flinch2";
	string ANIM_RAWR = "scream";
	string ANIM_HIDE = "hide_idle";
	string ANIM_ATTACK_LONG = "attacklow";
	string ANIM_ATTACK_SHORT = "attack";
	string ANIM_ATTACK_STRONG = "attack_strong_close";
	string ANIM_ATTACK_BITE_MED = "attack_bite_med";
	string ANIM_ATTACK_MULTI = "attack_multi_close";
	string ANIM_ATTACK_BITE_CLOSE = "attack_bite_close";
	string ANIM_BEAM = "eyeblast";
	string ATTACH_EYE = "0";
	int ATTACH_CLAW = 2;
	float FREQ_TELEPORT = 60.0f;
	float FREQ_EYEBEAM = 0.0f;
	float DMG_CLAW = 100.0f;
	int DMG_STRONG = 200;
	float DMG_BITE = 300.0f;
	string DMG_MULTI = "250";
	float DOT_DMG = 30.0f;
	string DOT_EFFECT_SCRIPT = "effects/dot_dark";
	int AOE_CLAW = 200;
	int AOE_STRONG = 128;
	int AOE_BEAM = 256;
	string CL_SCRIPT = "monsters/worm_abyssal_cl";
	float FREQ_CL_REFRESH = 30.0f;
	string SOUND_RAWR1 = "gonarch/gon_alert1.wav";
	string SOUND_RAWR2 = "gonarch/gon_alert2.wav";
	string SOUND_RAWR3 = "gonarch/gon_alert3.wav";
	string SOUND_MULTI = "monsters/aby_worm/multi_attack.wav";
	string SOUND_BITE = "monsters/aby_worm/bite.wav";
	string SOUND_BEAM_CHARGE = "monsters/aby_worm/beam_charge.wav";
	string SOUND_BEAM_FIRE = "monsters/aby_worm/beam_fire.wav";
	string SOUND_GIBBER1 = "monsters/aby_worm/gibber1.wav";
	string SOUND_GIBBER2 = "monsters/aby_worm/gibber2.wav";
	string SOUND_IDLE1 = "bullchicken/bc_idle1.wav";
	string SOUND_IDLE2 = "bullchicken/bc_idle2.wav";
	string SOUND_IDLE3 = "bullchicken/bc_idle3.wav";
	string SOUND_IDLE4 = "bullchicken/bc_idle4.wav";
	string SOUND_IDLE5 = "bullchicken/bc_idle5.wav";
	float FREQ_IDLE_SOUND = 0.0f;
	string NPC_MATERIAL_TYPE = "carapace";
	bool NPC_USE_PAIN = true;
	bool NPC_USE_FLINCH = true;
	string SOUND_PAIN1 = "gonarch/gon_pain2.wav";
	string SOUND_PAIN2 = "gonarch/gon_pain4.wav";
	string SOUND_PAIN3 = "gonarch/gon_pain5.wav";
	string SOUND_FLINCH1 = "gonarch/gon_childdie1.wav";
	string SOUND_FLINCH2 = "gonarch/gon_childdie2.wav";
	string SOUND_FLINCH3 = "gonarch/gon_childdie3.wav";
	int NPC_PITCH_PAIN = 0;
	int NPC_PITCH_FLINCH = 0;
	int NPC_STRUCK_CHANNEL = 0;
	string NPC_STRUCK_SOUND_EVENT = "do_playsound";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	Vector3 NPC_HBAR_ADJ = Vector3();
	bool HIDE_MODE = false;
	float CUR_HIDE_THRESH = 0.0f;
	float WORM_TELE_IDX = 0.0f;
	string CL_IDX = "CL_IDX";
	float CUR_RAWR = 0.0f;
	string MY_HEAD = "MY_HEAD";
	bool MAP_RMINES_KEEP_CLEAR = false;
	float NEXT_WORM_CALM_HIDE = 0.0f;
	float NEXT_EYEBEAM = 0.0f;
	bool WORM_UNHIDING = false;
	float NEXT_TELEPORT = 0.0f;
	bool IDLE_SOUNDS_ACTIVE = false;
	float NEXT_IDLE_SOUND = 0.0f;
	float NEXT_GLOW = 0.0f;
	bool DID_HIDE_STAGE1 = false;
	bool DID_HIDE_STAGE2 = false;
	bool DID_HIDE_STAGE3 = false;
	bool FINAL_TELEPORT = false;
	bool DOING_IDLE_SOUND = false;
	string REPEL_TARGS = "REPEL_TARGS";
	float NEXT_GIBBER = 0.0f;
	bool GIBBER_ACTIVE = false;
	float GIBBER_COUNT = 0.0f;
	float GIBBER_DELAY = 0.0f;
	float NEXT_CL_REFRESH = 0.0f;
	bool NPC_FLINCH_DISABLE_ONCE = false;
	Vector3 BEAM_DEST = Vector3();
	float NEXT_MULTI_SOUND = 0.0f;
	int GIBBER_DIR = 0;
	bool HIDE_IN_PROGRESS = false;
	float NEXT_UNHIDE = 0.0f;
	Vector3 REPEL_POINT = Vector3();
	bool WORM_REPEL = false;
	bool NPC_FLINCH_DISABLE = false;

	// Variables declared by included files, with the value they start with in this script
	WormAbyssal()
	{
		NPC_IS_BOSS = true;
		ANIM_IDLE = "hide_idle";
		ANIM_WALK = "idle";
		ANIM_RUN = "idle2";
		NPC_RANGE_TYPE = "range2D";
		SOUND_DEATH = "monsters/aby_worm/death.wav";
	}

	// unnamed block (first think)
	void WormAbyssal_FirstThink()
	{
		// base ai
		NPC_IS_BOSS = true;
		NPC_GIVE_EXP = 6000.0f; // we have to double the XP value, as half the hit value goes to the head
		ANIM_IDLE = "hide_idle";
		ANIM_WALK = "idle";
		ANIM_RUN = "idle2";
		ANIM_DEATH = "death";
		ANIM_ATTACK = "attacklow";
		NO_STUCK_CHECKS = "1";
		NPC_HBAR_ADJ = Vector3(0, 128, 200);
		ATTACK_RANGE = 628.0f;
		ATTACK_HITRANGE = 628.0f; // attacks are AOE, so we're not gonna worry about hitrange
		ATTACK_MOVERANGE = 9999.0f; // dun move - will get flagged as ranged though
		NPC_MUST_SEE_TARGET = "0";
		NPC_RANGED = "1";
		NPC_IS_TURRET = true;

		HIDE_MODE = true;

		CUR_HIDE_THRESH = 0.75f;

		// setvard CUR_HIDE_DIDSTAGES ''
		ArrayCreate("ARRAY_WORM_TELES");
		ArrayAdd("ARRAY_WORM_TELES", "worm_telepoint1");
		ArrayAdd("ARRAY_WORM_TELES", "worm_telepoint2");
		ArrayAdd("ARRAY_WORM_TELES", "worm_telepoint3");
		ArrayAdd("ARRAY_WORM_TELES", "worm_telepoint4");
		WORM_TELE_IDX = 1.0f;

		CL_IDX = "-1";
		CUR_RAWR = 0.0f;
	}

	// game_applyeffect
	// <"applyeffect"|"applyeffectstack"> <target> <effectscript> [params...]
	string WormAbyssal_OnGameApplyeffect(string command = "", CBaseEntity@ caller = null, string effect = "", string value = "", string attacker = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "")
	{
		string result = "";
		DebugPrint("game_applyeffect " + effect);
		if (HIDE_MODE)
			result = AppendResult(result, "abort");
		if (Contains(effect, "freeze_solid"))
		{
			if (IsPlayer(attacker))
				PlayerMessageDark(attacker, FullNameOf(ENT_ME) + " is too large to be encased in ice.");
			result = AppendResult(result, "abort");
		}
		return result;
	}

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type
	string WormAbyssal_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		if (!IsAlive(ENT_ME))
			return result;

		if (HIDE_MODE)
		{
			result = AppendResult(result, "0");
			return result;
		}

		if (NPCATK_TARGET == "unset")
		{
			OnNpcatkSettarget(EntityId(attacker));
		}
		else
		{
			if (!IsPlayer(NPCATK_TARGET)) // prioritize players
				OnNpcatkSettarget(EntityId(attacker));
			if (RangeTo(NPCATK_TARGET) > RangeTo(attacker)) // prioritize closest
				OnNpcatkSettarget(EntityId(attacker));
		}

		if (Contains(damageType, "dark")) // healed by dark energy
		{
			result = AppendResult(result, "0");
			float healAmt = damage * 2.0f;
			GiveHealth(ENT_ME, healAmt);
			if (GameTime() > NEXT_GLOW)
			{
				NEXT_GLOW = GameTime() + 5.0f;
				Effect("glow", ENT_ME, Vector3(0, 255, 0), 30, 5.0f, 5.0f);
			}
			return result;
		}

		// check if hide from lack of hp (<75%,<50%,<25% [final])
		if (FINAL_TELEPORT)
			return result;

		float nextHideThresh = MaxHealthOf(ENT_ME) * CUR_HIDE_THRESH;
		float curHp = HealthOf(ENT_ME) - damage;

		if (curHp <= nextHideThresh)
		{
			// not working, using hacky way
			// if $get_find_token(CUR_HIDE_DIDSTAGES,CUR_HIDE_THRESH) < 0
			// token.add CUR_HIDE_DIDSTAGES CUR_HIDE_THRESH
			// only do each health based hide stage once, in case we're set boss and regenerating
			// abort over damage to make sure I get these stages off
			float newHp = nextHideThresh;
			string newHpText;
			newHp -= 1.0f;
			newHpText = Text(newHp);
			SetHealth(newHp, MaxHealthOf(ENT_ME));
			result = AppendResult(result, "0");

			DebugPrint("game_damaged (body) cur " + Text(curHp) + " hide@ " + Text(nextHideThresh) + " thrsh " + Text(CUR_HIDE_THRESH) + " newhp " + newHpText);

			if (CUR_HIDE_THRESH == 0.75f && DID_HIDE_STAGE1)
				return result;

			if (CUR_HIDE_THRESH == 0.5f && DID_HIDE_STAGE2)
				return result;

			if (CUR_HIDE_THRESH == 0.25f && DID_HIDE_STAGE3)
				return result;

			if (CUR_HIDE_THRESH == 0.75f)
				DID_HIDE_STAGE1 = true;
			else if (CUR_HIDE_THRESH == 0.50f)
				DID_HIDE_STAGE2 = true;
			else if (CUR_HIDE_THRESH == 0.25f) // shouldnt ever get here agian
				DID_HIDE_STAGE3 = true;
			CUR_HIDE_THRESH -= 0.25f;
			if (CUR_HIDE_THRESH <= 0.0f)
				FINAL_TELEPORT = true;
			OnDoTeleport();
		}
		return result;
	}

	// game_damaged_other
	string WormAbyssal_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		// (never true here, the rest is skipped) if G_LESSER_DEV_MODE
		return result;
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile(CL_SCRIPT);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		CallExternal(GetVar("GAME_MASTER"), "gm_suspend_mob_spawns", 0);
		ClientEvent("update", "all", CL_IDX, "end_fx");
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, WormAbyssal_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
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
		OnAsTeleStuckCheck();
		CreateNpc("monsters/worm_abyssal_head", AttachmentPositionOf(ENT_ME, 1), self);
		MY_HEAD = ENT_LASTCREATED;

		if (ToLowerCase(MapName()) != "undermines")
			return;
		MAP_RMINES_KEEP_CLEAR = true;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseStruck_OnGameSpawn(playerRace, playerGender); // monsters/base_struck
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		OnWormSpawn();
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseStruck_OnNpcatkHunt(); // monsters/base_struck
		int count;

		if (GameTime() > NEXT_CL_REFRESH)
			OnRefreshCl();

		if (IDLE_SOUNDS_ACTIVE && GameTime() > NEXT_IDLE_SOUND)
		{
			NEXT_IDLE_SOUND = GameTime();
			DOING_IDLE_SOUND = true;
			NEXT_IDLE_SOUND += FREQ_IDLE_SOUND;
			int rndIdle = RandomInt(1, 5);
			if (rndIdle == 1)
				OnDoPlaysound(0, 10, SOUND_IDLE1, 0.8f, Random(50, 70));
			else if (rndIdle == 2)
				OnDoPlaysound(0, 10, SOUND_IDLE2, 0.8f, Random(50, 70));
			else if (rndIdle == 3)
				OnDoPlaysound(0, 10, SOUND_IDLE3, 0.8f, Random(50, 70));
			else if (rndIdle == 4)
				OnDoPlaysound(0, 10, SOUND_IDLE4, 0.8f, Random(50, 70));
			else if (rndIdle == 5)
				OnDoPlaysound(0, 10, SOUND_IDLE5, 0.8f, Random(50, 70));
		}

		if (!FINAL_TELEPORT && !HIDE_MODE)
		{
			// no one's been on the platform for at least 15 seconds, calm and hide
			if (GameTime() > NEXT_WORM_CALM_HIDE)
			{
				NEXT_TELEPORT = GameTime() + FREQ_TELEPORT;
				OnDoTeleport();
			}
		}

		if (WORM_REPEL)
		{
			// push folks away from me so they can't fall into the sealed hole
			REPEL_TARGS = LegacyFunction("get_tsphere", "any", 128, REPEL_POINT);
			if (REPEL_TARGS != "none")
			{
				count = GetTokenCount(REPEL_TARGS);
				for (int i = 0; i < count; i++)
				{
					loopIteration = i;
					OnRepelTargets();
				}
			}
		}

		if (GameTime() > NEXT_GIBBER)
		{
			NEXT_GIBBER = GameTime() + Random(10, 20);
			GIBBER_ACTIVE = true;
			GIBBER_COUNT = 0.0f;
			GIBBER_DELAY = 0.01f;
			if (RandomInt(1, 2) == 1)
				OnDoPlaysound(2, 10, SOUND_GIBBER1, 0.8f, RandomInt(75, 125));
			else
				OnDoPlaysound(2, 10, SOUND_GIBBER2, 0.8f, RandomInt(75, 125));
			OnDoGibber();
			CallEventDelayed(5.0f, "end_gibber");
		}

		if (SUSPEND_AI)
			return;

		if (!FINAL_TELEPORT && GameTime() > NEXT_TELEPORT)
		{
			NEXT_TELEPORT = GameTime() + FREQ_TELEPORT;
			OnDoTeleport();
		}

		if (NPCATK_TARGET == "unset")
			return;

		SetMoveDest(NPCATK_TARGET, ATTACK_MOVERANGE);

		if (Range2DTo(NPCATK_TARGET) > ATTACK_RANGE) // gonna beam more often if cant reach target
			NEXT_EYEBEAM -= 1.0f;

		if (GameTime() > NEXT_EYEBEAM && Range2DTo(NPCATK_TARGET) < 1024.0f)
		{
			NEXT_TELEPORT = GameTime() + FREQ_TELEPORT;
			OnDoEyebeam();
		}
	}

	// npcatk_suspend_ai
	// suspend flinch while hiding
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
		NPC_FLINCH_DISABLE = true;
	}

	// npcatk_resume_ai
	void OnNpcatkResumeAi(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkResumeAi(target); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkResumeAi(target); // monsters/base_monster_shared
		BaseMonsterShared_OnNpcatkResumeAi_2(target); // monsters/base_monster_shared
		NPC_FLINCH_DISABLE = false;
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		// horribly complex range of possible attacks, other than eye beam
		float range = Range2DTo(NPCATK_TARGET);
		string possibleAttacks = "";

		if (range > 500.0f)
			possibleAttacks = TokenAdd(possibleAttacks, ANIM_ATTACK_LONG);
		if (range < 500.0f && range > 350.0f)
			possibleAttacks = TokenAdd(possibleAttacks, ANIM_ATTACK_SHORT);
		if (range < 425.0f)
		{
			if (range > 230.0f)
				possibleAttacks = TokenAdd(possibleAttacks, ANIM_ATTACK_STRONG);
			if (range > 250.0f && range < 325.0f)
				possibleAttacks = TokenAdd(possibleAttacks, ANIM_ATTACK_BITE_MED);

			if (range < 280.0f)
				possibleAttacks = TokenAdd(possibleAttacks, ANIM_ATTACK_MULTI);

			if (range < 250.0f)
				possibleAttacks = TokenAdd(possibleAttacks, ANIM_ATTACK_BITE_CLOSE);
		}

		// dbg npc_selectattack $int(L_RANGE) L_POSSIBLE_ATTACKS
		float npatks = GetTokenCount(possibleAttacks) - 1.0f;
		int rndAttack = RandomInt(0, int(npatks));
		ANIM_ATTACK = GetToken(possibleAttacks, rndAttack);
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseStruck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, WormAbyssal_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// worm_spawn
	void OnWormSpawn()
	{
		SetName("Abyssal Worm");
		SetUniqueName("aby_worm");
		SetModel("monsters/abyssal_worm.mdl");
		SetWidth(128);
		SetHeight(700);
		SetSolid("trigger");
		SetRace("demon");
		SetHealth(18000);
		SetDamageTaken("holy", 1.5f);
		SetHearingSensitivity(11);
		OnNpcatkSuspendAi();
		SetInvincible(true);
	}

	// dinner_bell
	// { game_heardsound
	// if HIDE_MODE
	// if game.time > NEXT_UNHIDE
	// if $get(ent_me,relationship,ent_lastheard) equals enemy
	// callevent dinner_bell
	// }
	// called every 10 seconds a player is on the platform
	void OnDinnerBell(string soundSource = "")
	{
		NEXT_WORM_CALM_HIDE = GameTime() + 15.0f;
		if (HIDE_IN_PROGRESS)
			return;
		if (HIDE_MODE)
		{
			DebugPrint("dinner_bell " + NameOf(soundSource) + " " + Text(GameTime()) + " vs. " + Text(NEXT_UNHIDE));
			if (GameTime() > NEXT_UNHIDE)
			{
				NEXT_EYEBEAM = GameTime() + FREQ_EYEBEAM;
				HIDE_MODE = false;
				WORM_UNHIDING = true;
				PlayAnim("critical", ANIM_RISE);
				if (FINAL_TELEPORT)
					CallEventDelayed(0.5f, "brk_wall");
			}
		}
		else
		{
			// if ( SUSPEND_AI ) callevent npcatk_resume_ai //bad, what if beaming?
			OnWormFindTarget();
		}
	}

	// brk_wall
	void OnBrkWall()
	{
		UseTrigger("brk_worm");
	}

	// frame_rise_done
	void OnFrameRiseDone()
	{
		SetInvincible(false);
		NPC_NO_ATTACK = false;
		OnRefreshCl();
		ANIM_IDLE = ANIM_IDLE_UP;
		SetIdleAnim(ANIM_IDLE_UP);
		SetMoveAnim(ANIM_IDLE_UP);
		ANIM_RUN = ANIM_IDLE_UP;
		ANIM_WALK = ANIM_IDLE_UP;
		ANIM_IDLE = ANIM_IDLE_UP;
		OnNpcatkResumeAi();
		PlayAnim("critical", ANIM_RAWR);
		OnWormFindTarget();
		NEXT_TELEPORT = GameTime() + FREQ_TELEPORT;
		IDLE_SOUNDS_ACTIVE = true;
		NEXT_IDLE_SOUND = GameTime() + FREQ_IDLE_SOUND;
		WORM_UNHIDING = false;

		Effect("screenshake", OriginOf(MY_HEAD), 400, 10, 3, 1024);

		CUR_RAWR += 1.0f;
		if (CUR_RAWR == 1.0f)
			OnDoPlaysound(0, 10, SOUND_RAWR1, 0.8f, RandomInt(30, 60));
		if (CUR_RAWR == 2.0f)
			OnDoPlaysound(0, 10, SOUND_RAWR2, 0.8f, RandomInt(30, 60));
		if (CUR_RAWR == 3.0f)
		{
			OnDoPlaysound(0, 10, SOUND_RAWR3, 0.8f, RandomInt(30, 60));
			CUR_RAWR = 0.0f;
		}
	}

	// worm_find_target
	void OnWormFindTarget()
	{
		string targs = FindInSphere("enemy", 1024);
		if (targs == "none")
			return;
		targs = SortEntities(targs, "range");
		OnNpcatkSettarget(GetToken(targs, 0));
	}

	string OnGameApplyeffect(string command = "", CBaseEntity@ caller = null, string effect = "", string value = "", string attacker = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "") { return WormAbyssal_OnGameApplyeffect(command, caller, effect, value, attacker, value2, value3, value4, value5); } // game_applyeffect

	// refresh_cl
	void OnRefreshCl()
	{
		if (Float(CL_IDX) > -1.0f)
			ClientEvent("update", "all", CL_IDX, "end_fx");
		ClientEvent("new", "all", CL_SCRIPT, IndexOf(ENT_ME), FREQ_CL_REFRESH);
		CL_IDX = LastClientScriptId();
		NEXT_CL_REFRESH = GameTime() + FREQ_CL_REFRESH;

		if (!MAP_RMINES_KEEP_CLEAR)
			return;
		CallExternal("all", "ext_rmines_clear");
	}

	// npc_flinch
	void OnNpcFlinch(float damage = 0.0f)
	{
		if (HIDE_MODE)
		{
			NPC_FLINCH_DISABLE_ONCE = true;
			return;
		}
		if (SUSPEND_AI)
			OnNpcatkResumeAi();
		if (RandomInt(1, 2) == 1)
			ANIM_FLINCH = ANIM_FLINCH1;
		else
			ANIM_FLINCH = ANIM_FLINCH2;
	}

	// do_eyebeam
	void OnDoEyebeam()
	{
		NEXT_EYEBEAM = GameTime() + FREQ_EYEBEAM;
		BEAM_DEST = OriginOf(NPCATK_TARGET);
		if (!SUSPEND_AI) // albiet, shouldn't have gotten here if AI suspended, but paranoid
			OnNpcatkSuspendAi();
		PlayAnim("critical", ANIM_BEAM); // frame_beam_charge + frame_beam_fire
		OnRefreshCl();
	}

	// frame_beam_charge
	void OnFrameBeamCharge()
	{
		OnDoPlaysound(0, 10, SOUND_BEAM_CHARGE);
		ClientEvent("update", "all", CL_IDX, "beam_charge", BEAM_DEST);
	}

	// frame_beam_fire
	void OnFrameBeamFire()
	{
		OnNpcatkResumeAi();
		OnDoPlaysound(0, 10, SOUND_BEAM_FIRE);
		ClientEvent("update", "all", CL_IDX, "beam_fire", BEAM_DEST);
		// stun everyone around + dark DOT
		DoDamageEx(BEAM_DEST, AOE_BEAM, "DMG_BEAM", 0.01f, ENT_ME, ENT_ME, "none", "dark_effect", "dmgevent:beam");
	}

	// beam_dodamage
	void OnBeamDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		ApplyEffect(target, DOT_EFFECT_SCRIPT, 5.0f, self, DOT_DMG);
		ApplyEffect(target, "effects/effect_stun", 8.0f, 0, 1, self);
	}

	// repel_targets
	void OnRepelTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(REPEL_TARGS, loopIteration));
		Vector3 targOrg = OriginOf(curTarg);
		// Use the repel field's center, not the worm entity's origin. The worm's
		// origin can be well below the platform, which skews the push direction.
		float targAng = AnglesTo(REPEL_POINT, targOrg);
		int newYaw = int(targAng);
		AddVelocity(curTarg, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 500, 0)), "override");
	}

	// frame_claw
	void OnFrameClaw()
	{
		// big AOE
		OnNpcatkSuspendAttack(2.0f); // delay before next attack
		Vector3 attackPos = AttachmentPositionOf(ENT_ME, ATTACH_EYE);
		float myYaw = AnglesOf(ENT_ME).y;
		attackPos += RelativePosition(Vector3(0, myYaw, 0), Vector3(0, 64, 0));
		attackPos.z = GroundHeight(attackPos);
		attackPos.z += 16.0f;
		DebugPrint("frame_claw " + Text(attackPos));
		ClientEvent("update", "all", CL_IDX, "dark_burst", attackPos, AOE_CLAW);
		DoDamageEx(attackPos, AOE_CLAW, DMG_CLAW, 0.01f, ENT_ME, ENT_ME, "none", "dark", "dmgevent:burst");
	}

	// frame_strong
	void OnFrameStrong()
	{
		OnNpcatkSuspendAttack(2.0f); // delay before next attack
		Vector3 attackPos = AttachmentPositionOf(ENT_ME, ATTACH_EYE); // claw turned out to be off center
		float myYaw = AnglesOf(ENT_ME).y;
		attackPos += RelativePosition(Vector3(0, myYaw, 0), Vector3(0, 64, 0));
		attackPos.z = GroundHeight(attackPos);
		attackPos.z += 16.0f;
		DebugPrint("frame_strong " + Text(attackPos));
		ClientEvent("update", "all", CL_IDX, "dark_burst", attackPos, AOE_STRONG);
		DoDamageEx(attackPos, AOE_STRONG, DMG_STRONG, 0.01f, ENT_ME, ENT_ME, "none", "dark", "dmgevent:burst");
	}

	// burst_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end) PARAM5=DmgType PARAM6=DmgAmt
	void OnBurstDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		ApplyEffect(target, DOT_EFFECT_SCRIPT, 5.0f, self, DOT_DMG);
	}

	// frame_maw0
	void OnFrameMaw0()
	{
		OnSetMaw(0);
	}

	// frame_maw1
	void OnFrameMaw1()
	{
		OnSetMaw(1);
	}

	// frame_maw2
	void OnFrameMaw2()
	{
		OnSetMaw(2);
	}

	// frame_bite
	void OnFrameBite()
	{
		OnSetMaw(3);
		OnDoPlaysound(0, 10, SOUND_BITE);
		DoDamageEx(AttachmentPositionOf(ENT_ME, ATTACH_EYE), OriginOf(NPCATK_TARGET), DMG_BITE, 90, ENT_ME, ENT_ME, "none", "slash");
	}

	// frame_multi
	void OnFrameMulti()
	{
		// fairly nasty direct
		DoDamageEx(AttachmentPositionOf(ENT_ME, ATTACH_EYE), OriginOf(NPCATK_TARGET), DMG_MULTI, 80, ENT_ME, ENT_ME, "none", "pierce");
		if (!(GameTime() > NEXT_MULTI_SOUND))
			return;
		NEXT_MULTI_SOUND = GameTime() + 10.0f;
		OnDoPlaysound(1, 10, SOUND_MULTI, 0.8f, RandomInt(90, 110));
	}

	// frame_gibber_start
	void OnFrameGibberStart()
	{
		GIBBER_ACTIVE = true;
		GIBBER_COUNT = 0.0f;
		GIBBER_DELAY = 0.01f;
		NEXT_GIBBER = GameTime() + Random(10, 15);
		OnDoGibber();
	}

	// frame_gibber_end
	void OnFrameGibberEnd()
	{
		SetProp(ENT_ME, "skin", 0);
		GIBBER_ACTIVE = false;
	}

	// set_maw
	void OnSetMaw(int skin = 0)
	{
		GIBBER_ACTIVE = false;
		NEXT_GIBBER = GameTime() + Random(5, 10);
		SetProp(ENT_ME, "skin", skin);
	}

	// do_gibber
	void OnDoGibber()
	{
		if (!GIBBER_ACTIVE)
			return;
		if (GIBBER_COUNT == 0.0f)
			GIBBER_DIR = 1;
		if (GIBBER_COUNT == 3.0f)
			GIBBER_DIR = -1;
		GIBBER_COUNT += GIBBER_DIR;
		SetProp(ENT_ME, "skin", GIBBER_COUNT);
		CallEventDelayed(GIBBER_DELAY, "do_gibber");
		GIBBER_DELAY += 0.01f;
	}

	// end_gibber
	void OnEndGibber()
	{
		SetProp(ENT_ME, "skin", 0);
		GIBBER_ACTIVE = false;
	}

	// check_porters
	void OnCheckPorters()
	{
		// debuggary
		CBaseEntity@ porter = FindByName("telepoint_abyssal4");
		DebugPrint("check_porters " + EntityId(porter) + " " + Text(OriginOf(porter)) + " " + Text(AnglesOf(porter)));
		Vector3 start = OriginOf(ENT_ME);
		string end = Text(start);
		end = Text(Vec(end) + Vector3(0.0f, 0.0f, HeightOf(ENT_ME)));
		Effect("beam", "point", "lgtning.spr", 30, start, end, Vector3(255, 0, 255), 200, 0, 120.0f);

		float ofs = Divide(WidthOf(ENT_ME), 2.0f);
		float negOfs = -Divide(WidthOf(ENT_ME), 2.0f);

		DebugPrint("check_porters ofs " + Text(Vector3(negOfs, negOfs, 0)) + " - " + Text(Vector3(ofs, ofs, 0)));

		start = OriginOf(ENT_ME) + Vector3(ofs, ofs, 0);
		end = Text(start);
		end = Text(Vec(end) + Vector3(0.0f, 0.0f, HeightOf(ENT_ME)));
		Effect("beam", "point", "lgtning.spr", 5, start, end, Vector3(255, 255, 0), 200, 0, 120.0f);

		start = OriginOf(ENT_ME) + Vector3(negOfs, negOfs, 0);
		end = Text(start);
		end = Text(Vec(end) + Vector3(0.0f, 0.0f, HeightOf(ENT_ME)));
		Effect("beam", "point", "lgtning.spr", 5, start, end, Vector3(255, 255, 0), 200, 0, 120.0f);

		start = OriginOf(ENT_ME) + Vector3(negOfs, ofs, 0);
		end = Text(start);
		end = Text(Vec(end) + Vector3(0.0f, 0.0f, HeightOf(ENT_ME)));
		Effect("beam", "point", "lgtning.spr", 5, start, end, Vector3(255, 255, 0), 200, 0, 120.0f);

		start = OriginOf(ENT_ME) + Vector3(ofs, negOfs, 0);
		end = Text(start);
		end = Text(Vec(end) + Vector3(0.0f, 0.0f, HeightOf(ENT_ME)));
		Effect("beam", "point", "lgtning.spr", 5, start, end, Vector3(255, 255, 0), 200, 0, 120.0f);
	}

	// do_teleport
	void OnDoTeleport(string reason = "", string option = "")
	{
		ClearEffects();
		OnNpcatkSuspendAi();
		HIDE_MODE = true;
		HIDE_IN_PROGRESS = true;
		SetMoveAnim(ANIM_LOWER);
		SetIdleAnim(ANIM_LOWER);
		ANIM_RUN = ANIM_LOWER;
		ANIM_WALK = ANIM_LOWER;
		ANIM_IDLE = ANIM_LOWER;
		SetInvincible(true);
		NEXT_UNHIDE = GameTime() + 5.0f;
		PlayAnim("critical", ANIM_LOWER);
		NEXT_TELEPORT = GameTime() + FREQ_TELEPORT;

		int rndSound = RandomInt(1, 3);
		if (rndSound == 1)
			OnDoPlaysound(0, 10, SOUND_FLINCH1, 0.8f, Random(40, 60));
		else if (rndSound == 2)
			OnDoPlaysound(0, 10, SOUND_FLINCH2, 0.8f, Random(40, 60));
		else if (rndSound == 3)
			OnDoPlaysound(0, 10, SOUND_FLINCH3, 0.8f, Random(40, 60));
	}

	// frame_lower_done
	void OnFrameLowerDone()
	{
		string teleName;
		HIDE_IN_PROGRESS = false;
		SetMoveAnim(ANIM_HIDE);
		SetIdleAnim(ANIM_HIDE);
		ANIM_RUN = ANIM_HIDE;
		ANIM_WALK = ANIM_HIDE;
		ANIM_IDLE = ANIM_HIDE;
		NPC_NO_ATTACK = true;

		if (!FINAL_TELEPORT)
		{
			teleName = GetArray("ARRAY_WORM_TELES", Text(WORM_TELE_IDX));
		}
		else
		{
			teleName = "worm_telepoint_final";
			UseTrigger("light_worm");
			CBaseEntity@ repelPoint = FindByName("worm_repel_point");
			REPEL_POINT = OriginOf(repelPoint);
			WORM_REPEL = true;
		}

		CBaseEntity@ teleId = FindByName(teleName);

		SetOrigin(ENT_ME, OriginOf(teleId));
		float teleYaw = AnglesOf(teleId).y;
		SetAngle("face", Vector3(0, teleYaw, 0));
		WORM_TELE_IDX += 1.0f;
		float nteles = GetArrayCount("ARRAY_WORM_TELES") - 1.0f;
		if (WORM_TELE_IDX > nteles)
			WORM_TELE_IDX = 0.0f;
	}

	// do_playsound
	// from base struck ala NPC_STRUCK_SOUND_EVENT
	void OnDoPlaysound(int channel = 0, int volume = 0, string soundName = "", float attenuation = 0.0f, float pitch = 0.0f)
	{
		float pass4 = 0.0f;
		float pass5 = 0.0f;
		if (!DOING_IDLE_SOUND)
		{
			float nextIdle = NEXT_IDLE_SOUND - GameTime();
			if (nextIdle < 3.0f) // don't want idle sounds overriding primary sounds
				NEXT_IDLE_SOUND += Random(2, 4);
		}
		DOING_IDLE_SOUND = false;

		// chan
		// vol
		// sound
		if (Float(Eval("game.event.params")) > 3.0f) // attn
			pass4 = attenuation;
		if (Float(Eval("game.event.params")) > 4.0f) // pitch
			pass5 = pitch;

		if (Float(Eval("game.event.params")) > 3.0f)
			CallExternal(MY_HEAD, "ext_playsound", channel, volume, soundName, pass4, pass5);
		else
			CallExternal(MY_HEAD, "ext_playsound", channel, volume, soundName);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnGibberDelay() {} // GIBBER_DELAY

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/abyssal_worm_hitbox.mdl");
		Precache("monsters/zubat_sphere.mdl");
		Precache("3dmflagry.spr");
		Precache("monsters/abyssal_worm.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		WormAbyssal_FirstThink();
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
		if (name == "beam_dodamage") { OnBeamDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "brk_wall") { OnBrkWall(); return true; }
		if (name == "burst_dodamage") { OnBurstDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "check_porters") { OnCheckPorters(); return true; }
		if (name == "dinner_bell") { OnDinnerBell(Param(params, 0)); return true; }
		if (name == "do_eyebeam") { OnDoEyebeam(); return true; }
		if (name == "do_gibber") { OnDoGibber(); return true; }
		if (name == "do_playsound") { OnDoPlaysound(Int(Param(params, 0)), Int(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), Float(Param(params, 4))); return true; }
		if (name == "do_teleport") { OnDoTeleport(Param(params, 0), Param(params, 1)); return true; }
		if (name == "end_gibber") { OnEndGibber(); return true; }
		if (name == "frame_beam_charge") { OnFrameBeamCharge(); return true; }
		if (name == "frame_beam_fire") { OnFrameBeamFire(); return true; }
		if (name == "frame_bite") { OnFrameBite(); return true; }
		if (name == "frame_claw") { OnFrameClaw(); return true; }
		if (name == "frame_gibber_end") { OnFrameGibberEnd(); return true; }
		if (name == "frame_gibber_start") { OnFrameGibberStart(); return true; }
		if (name == "frame_lower_done") { OnFrameLowerDone(); return true; }
		if (name == "frame_maw0") { OnFrameMaw0(); return true; }
		if (name == "frame_maw1") { OnFrameMaw1(); return true; }
		if (name == "frame_maw2") { OnFrameMaw2(); return true; }
		if (name == "frame_multi") { OnFrameMulti(); return true; }
		if (name == "frame_rise_done") { OnFrameRiseDone(); return true; }
		if (name == "frame_strong") { OnFrameStrong(); return true; }
		if (name == "game_applyeffect") { Return(OnGameApplyeffect(Param(params, 0), EntityParam(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7), Param(params, 8))); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npc_flinch") { OnNpcFlinch(Float(Param(params, 0))); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_resume_ai") { OnNpcatkResumeAi(Param(params, 0)); return true; }
		if (name == "npcatk_suspend_ai") { OnNpcatkSuspendAi(Param(params, 0), Param(params, 1)); return true; }
		if (name == "refresh_cl") { OnRefreshCl(); return true; }
		if (name == "repel_targets") { OnRepelTargets(); return true; }
		if (name == "set_maw") { OnSetMaw(Int(Param(params, 0))); return true; }
		if (name == "worm_find_target") { OnWormFindTarget(); return true; }
		if (name == "worm_spawn") { OnWormSpawn(); return true; }
		return BaseStruck_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
