#pragma context server

// Converted from monsters/k_childre_boss_jelly.script by msc_transpiler.
// Kruxus the Corrupting Shadow, by Jelly
// Note: haven't finished his nova yet, going to do it the same way I did repulse undead. Also think there's something else missing, just can't remember it.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/k_childre_boss_jelly"]
class KChildreBossJelly : BaseMonsterNewScript
{
	// Constants
	string ANIM_IDLE_NORM = "idle1";
	string ANIM_IDLE_CROUCH = "crouch_idle";
	string ANIM_WALK_NORM = "walk";
	string ANIM_RUN_NORM = "run";
	string ANIM_CRAWL = "crawl";
	string ANIM_JUMP = "jump";
	string ANIM_DEATH_BACK1 = "death1_die";
	string ANIM_DEATH_BACK2 = "back_die";
	string ANIM_DEATH_FORWARD1 = "forward_die";
	string ANIM_DEATH_CROUCH = "crouch_die";
	string DMG_SWIPE = "DMG_SWIPE";
	float DOT1_DMG = 10.0f;
	float DOT1_DURATION = 15.0f;
	float CLOUD_DMG = 20.0f;
	float CLOUD_DURATION = 10.0f;
	float NOVA_DMG = 100.0f;
	float NOVA_DOT_DMG = 10.0f;
	float NOVA_DOT_DURATION = 5.0f;
	Vector3 NOVA_COLOUR = Vector3();
	int SUMMON_FREQ = 180;
	int SUMMON_RATE_1 = 60;
	int SUMMON_RATE_2 = 90;
	int SUMMON_RATE_3 = 100;
	string SUMMON_SCRIPT_1 = "monsters/k_larva_black";
	string SUMMON_SCRIPT_2 = "monsters/horror";
	string SUMMON_SCRIPT_3 = "monsters/k_childre_black";
	string SOUND_SPAWN = "magic/spawn.wav";
	string SOUND_FLINCH = "monsters/gonome/gonome_pain3.wav";
	string SOUND_WARCRY = "monsters/gonome/gonome_melee1.wav";
	string SOUND_FADE = "monsters/gonome/gonome_melee2.wav";
	string SOUND_UNFADE = "monsters/gonome/gonome_death3.wav";
	string SOUND_STRUCK1 = "debris/flesh1.wav";
	string SOUND_STRUCK2 = "debris/flesh2.wav";
	string SOUND_PAIN1 = "monsters/gonome/gonome_jumpattack.wav";
	string SOUND_PAIN2 = "monsters/gonome/gonome_melee1.wav";
	string SOUND_SWING_MISS1 = "zombie/claw_miss1.wav";
	string SOUND_SWING_MISS2 = "zombie/claw_miss2.wav";
	string SOUND_SWING_HIT1 = "zombie/claw_strike1.wav";
	string SOUND_SWING_HIT2 = "zombie/claw_strike2.wav";
	string SOUND_STEP1 = "common/npc_step1.wav";
	string SOUND_STEP2 = "common/npc_step2.wav";
	string SOUND_IDLE1 = "monsters/gonome/gonome_idle1.wav";
	string SOUND_IDLE2 = "monsters/gonome/gonome_idle2.wav";
	string SOUND_IDLE3 = "monsters/gonome/gonome_idle3.wav";
	string SOUND_PARRY = "weapons/axemetal1.wav";
	string MONSTER_MODEL = "monsters/k_childre_black.mdl";

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_FLINCH = "ANIM_FLINCH";
	string ATTACK_HITCHANCE = "ATTACK_HITCHANCE";
	int NOT_FIRST_TIME = 0;
	bool DID_WARCRY = false;
	bool STARTED_CYCLES = false;
	Vector3 SUMMON_ORIGIN = Vector3();
	int I_HAS_ORIGIN = 0;
	string MY_SUMMON = "MY_SUMMON";
	string NOVA_LIST = "NOVA_LIST";
	bool FADE_DELAY = false;
	string FADE_TARGET = "FADE_TARGET";
	bool DOING_FADE = false;
	bool WAS_STRUCK = false;
	float FADE_STEP = 0.0f;
	bool AM_CRAWLING = false;
	bool SWIPE_ATTACK = false;
	Vector3 KK_START_POS = Vector3();

	// Variables declared by included files, with the value they start with in this script
	KChildreBossJelly()
	{
		NPC_IS_BOSS = true;
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		SOUND_DEATH = "bullchicken/bc_die2.wav";
	}

	// unnamed block (first think)
	void KChildreBossJelly_FirstThink()
	{
		IS_UNHOLY = true;

		NPC_IS_BOSS = true;

		// anims used by base
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		ANIM_ATTACK = "ability1_alien"; // { event 500 7 "attack_strike" }
		ANIM_DEATH = "death1_die";
		ANIM_FLINCH = "new_flinch";

		// Stats
		ATTACK_RANGE = 150.0f;
		ATTACK_HITRANGE = 250.0f;
		ATTACK_MOVERANGE = 130.0f;
		ATTACK_HITCHANCE = "75%";
		DROP_GOLD = 0;
		NPC_GIVE_EXP = 4000.0f;
		// THOTHIE: My experience with these is they only work in game_precache, but if they are working for ye here *shrug* go for it. ;)
		PrecacheFile(SUMMON_SCRIPT_1);
		PrecacheFile(SUMMON_SCRIPT_2);
		PrecacheFile(SUMMON_SCRIPT_3);

		NOT_FIRST_TIME = 0;
	}

	// game_dodamage
	string KChildreBossJelly_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (!SWIPE_ATTACK)
			return result;
		if (hit)
		{
			PlayRandomSound(0, 10, SOUND_SWING_HIT1, SOUND_SWING_HIT2);
			if (RandomInt(1, 100) <= 60)
				ApplyEffect(target, "effects/dot_poison", DOT1_DURATION, self, DOT1_DMG);
		}
		if (!hit)
			PlayRandomSound(0, 10, SOUND_SWING_MISS1, SOUND_SWING_MISS2);
		SWIPE_ATTACK = false;
		return result;
	}

	// unnamed block (timer)
	void KChildreBossJelly_Timer()
	{
		CallEventDelayed(0.0f, "KChildreBossJelly_Timer"); // THOTHIE: FREQ_IDLE is not defined
		// THOTHIE: in the original k_childre script, FREQ_IDLE is $randf(5,10)
		// - this would be a good place, also, to take advantage of the headroom and jump randomly
		// - perhaps, do a 1 second chicken run and use the high jump:
		// -- callevent chicken_run 0.5
		// -- callevent do_jump
		if (NPCATK_TARGET != "unset")
			return;
		PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		SetProp(ENT_ME, "skin", 2);
		if (DOING_FADE)
		{
			DOING_FADE = false;
			CallExternal(GetVar("GAME_MASTER"), "gm_fade_in", self);
		}

		if (RangeTo(ENT_LASTSTRUCK) > 256.0f)
			ANIM_DEATH = ANIM_DEATH_FORWARD1;
		if (RangeTo(ENT_LASTSTRUCK) <= 256.0f)
		{
			int rndDeath = RandomInt(1, 2);
			if (rndDeath == 1)
				ANIM_DEATH = ANIM_DEATH_BACK1;
			if (rndDeath == 2)
				ANIM_DEATH = ANIM_DEATH_BACK2;
		}
		if (AM_CRAWLING)
			ANIM_DEATH = ANIM_DEATH_CROUCH;

		if (!(RandomInt(1, 8) < ActivePlayerCount()))
			return;

		if (ToLowerCase(MapName()) != "kfortress")
			return;

		// start 128 units from ground pos (in case monster dies in air)
		Vector3 nkStartPos = MyOrigin();
		float nkStartGroundZ = GroundHeight(nkStartPos);
		nkStartPos.z = nkStartGroundZ;
		KK_START_POS.z += 128.0f;

		// spawn ostentatious client effect
		ClientEvent("new", "all", "kfortress/nh_appear_cl", nkStartPos);

		// time item spawn, more or less, with client script effect end
		CallExternal(GetVar("GAME_MASTER"), "gm_createitem", 15.0f, "smallarms_nh", "START_POS", 1);
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
		// THOTHIE: SP: "taledmg"
		SetDamageTaken("fire", 0);
		SetDamageTaken("poison", 0);
		SetDamageTaken("acid", 0);
		SetDamageTaken("holy", 0.5f);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		PlaySound(0, 8, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_PAIN1, SOUND_PAIN2);
		if (RandomInt(1, 20) > 14)
			OnDoNovaPart1();
		if (!AM_CRAWLING)
			return;
		if (!DOING_FADE)
			return;
		SetMoveAnim(ANIM_RUN);
		AM_CRAWLING = false;
		WAS_STRUCK = true;
		OnChickenRun(1.5f);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Kruxus the Corrupting Shadow");
		SetHealth(5000);
		SetModel(MONSTER_MODEL);
		SetRace("demon");
		SetWidth(32);
		SetHeight(72);
		SetRoam(true);
		SetHearingSensitivity(4);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new

		DID_WARCRY = false;
		PlaySound(0, 10, SOUND_IDLE1);
		PlayAnim("critical", ANIM_FLINCH);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, KChildreBossJelly_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// game_parry
	void OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		BaseMonsterShared_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue); // monsters/base_monster_shared
		PlaySound(0, 10, SOUND_PARRY);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared

		if (!CanSee("enemy"))
			return;
		if (!DID_WARCRY)
		{
			DID_WARCRY = true;
			OnDoWarcry();
		}

		if (STARTED_CYCLES)
			return;
		STARTED_CYCLES = true;
		OnFreqFade();
		CallEventDelayed(1.0f, "jump_check");
		CallEventDelayed(SUMMON_FREQ, "do_summon");
	}

	// do_summon
	void OnDoSummon()
	{
		if (I_HAS_ORIGIN != 1)
		{
			CBaseEntity@ entId = FindByName("kruxus_summon_origin"); // THOTHIE: Is this another script?
			SUMMON_ORIGIN = OriginOf(entId);
			I_HAS_ORIGIN = 1;
		}

		if (NOT_FIRST_TIME == 1 && IsAlive(MY_SUMMON))
			CallExternal(MY_SUMMON, "npc_fade_away");

		// THOTHIE: If THE_NUM rolls over 90, he'll summon two monsters, inside one another, with this arrangement:
		// - also I think he already has Black Childre escort (not sure off hand)
		int theNum = RandomInt(1, 100);
		if (theNum >= SUMMON_RATE_1)
			CreateNpc(SUMMON_SCRIPT_1, RelativePosition(Vector3(0, 48, 5)), self);
		if (theNum < SUMMON_RATE_1 && theNum >= SUMMON_RATE_2)
			CreateNpc(SUMMON_SCRIPT_3, RelativePosition(Vector3(0, 48, 5)), self);
		if (theNum > SUMMON_RATE_2)
			CreateNpc(SUMMON_SCRIPT_3, RelativePosition(Vector3(0, 48, 5)), self);

		MY_SUMMON = ENT_LASTCREATED;

		NOT_FIRST_TIME = 1;
	}

	// do_nova_part_1
	void OnDoNovaPart1()
	{
		Vector3 myOrg = OriginOf(ENT_ME);
		NOVA_LIST = LegacyFunction("get_tsphere", "enemy", 256, myOrg);
		OnDoNovaFx();
		if (NOVA_LIST == "none")
			return;
		int count = GetTokenCount(NOVA_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnDoNovaPart2();
		}
	}

	// do_nova_part_2
	void OnDoNovaPart2(string target = "")
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(NOVA_LIST, loopIteration));
		DoDamageEx(@curTarg, "direct", NOVA_DMG, "100%", ENT_ME, ENT_ME, "none", "poison");
		ApplyEffect(curTarg, "effects/dot_poison", 5, ENT_ME, 10, 0, "none");

		// The pushing effect of the nova
		Vector3 targetOrg = OriginOf(curTarg);
		Vector3 myOrg = OriginOf(ENT_ME);
		float targAng = AnglesTo(myOrg, targetOrg);
		PlaySound(0, 10, "magic/spookie1.wav");
		SetVelocity(target, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 1000, 0)));
	}

	// do_nova_FX
	void OnDoNovaFx()
	{
		ClientEvent("new", "all", "monsters/k_childre_boss_cl", IndexOf(ENT_ME));
	}

	// fade_check
	void OnFadeCheck()
	{
		CallEventDelayed(1.0f, "fade_check");
		if (DOING_FADE)
			return;
		if (FADE_DELAY)
			return;
		if (NPCATK_TARGET == "unset")
			return;
		if (!(RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE))
			return;

		FADE_DELAY = true;
		OnFreqFade();
		OnDoFade();
		CreateNpc("monsters/summon/npc_poison_cloud2", RelativePosition(Vector3(0, 0, 5)), self, CLOUD_DMG, CLOUD_DURATION, 2);
	}

	// reset_fade_delay
	void OnResetFadeDelay()
	{
		FADE_DELAY = false;
	}

	// do_fade
	void OnDoFade()
	{
		OnNpcatkFlee(NPCATK_TARGET, "2048", "3.0");
		FADE_TARGET = NPCATK_TARGET;
		DOING_FADE = true;
		OnNpcatkSuspendAi("2.0");
		SetMoveAnim(ANIM_RUN);
		WAS_STRUCK = false;
		CallEventDelayed(0.1f, "do_fade2");
		CallEventDelayed(1.0f, "resume_attack");
	}

	// do_fade2
	void OnDoFade2()
	{
		PlaySound(0, 10, SOUND_FADE);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 800, 200)));
		FADE_STEP = 255.0f;
		OnFadeLoop();
		SetDamageTaken("cold", 0);
	}

	// fade_loop
	void OnFadeLoop()
	{
		FADE_STEP -= 20.0f;
		if (FADE_STEP < 0.0f)
			SetProp(ENT_ME, "renderamt", 1);
		if (!(FADE_STEP >= 0.0f))
			return;
		if (!DOING_FADE)
			return;
		CallEventDelayed(0.1f, "fade_loop");
		SetProp(ENT_ME, "rendermode", 2);
		SetProp(ENT_ME, "renderamt", FADE_STEP);
	}

	// resume_attack
	void OnResumeAttack()
	{
		OnNpcatkResumeAi();
		SetMoveAnim(ANIM_CRAWL);
		AM_CRAWLING = true;
		if (WAS_STRUCK)
			return;
		OnChickenRun(2.0f);
		CallEventDelayed(2.1f, "invis_run2"); // run around a bit while invisible to lose target
	}

	// invis_run2
	void OnInvisRun2()
	{
		if (WAS_STRUCK)
			return;
		if (!DOING_FADE)
			return;
		OnChickenRun(2.0f);
		CallEventDelayed(2.1f, "flank_targ");
	}

	// flank_targ
	void OnFlankTarg()
	{
		OnNpcatkFlank(FADE_TARGET);
	}

	// do_warcry
	void OnDoWarcry()
	{
		PlayAnim("critical", ANIM_IDLE_CROUCH);
		OnNpcatkFaceattacker(NPCATK_TARGET);
		PlaySound(0, 10, SOUND_WARCRY);
	}

	// become_visible
	void OnBecomeVisible()
	{
		SetDamageTaken("cold", 1.25f);
		PlaySound(0, 10, SOUND_UNFADE);
		// dbg become_visible PARAM1
		DOING_FADE = false;
		SetProp(ENT_ME, "rendermode", 0);
		SetProp(ENT_ME, "renderamt", 255);
	}

	// npc_flinch
	void OnNpcFlinch(float damage = 0.0f)
	{
		int rndFlinch = RandomInt(1, 2);
		if (rndFlinch == 1)
			FLINCH_ANIM = "ANIM_FLINCH1";
		if (rndFlinch == 2)
			FLINCH_ANIM = "ANIM_FLINCH2";
		PlaySound(0, 10, SOUND_FLINCH);
	}

	// jump_check
	void OnJumpCheck()
	{
		OnFreqJump();

		if (NPCATK_TARGET == "unset")
			return;

		float targZ = OriginOf(NPCATK_TARGET).z;
		float myZ = MyOrigin().z;
		float zDiff = targZ - myZ;
		string zDiffText = Text(zDiff);
		DebugPrint("temp z_targ " + Text(targZ) + " z_me " + Text(myZ) + " z_diff " + zDiffText);
		if (!(zDiff > ATTACK_RANGE))
			return;
		OnNpcatkFaceattacker(NPCATK_TARGET);
		CallEventDelayed(0.1f, "do_jump");
		PlaySound(0, 10, SOUND_FADE);
	}

	// do_jump
	void OnDoJump()
	{
		SetMoveAnim(ANIM_JUMP);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, -200, 800)));
		CallEventDelayed(0.5f, "push_forward");
		CallEventDelayed(1.0f, "jump_done");
	}

	// push_forward
	void OnPushForward()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 400, 100)));
	}

	// jump_done
	void OnJumpDone(string npc = "")
	{
		SetMoveAnim(ANIM_RUN);
	}

	// walk_step
	// model events
	void OnWalkStep()
	{
		PlaySound(0, 4, SOUND_STEP1, SOUND_STEP2);
	}

	// run_step
	void OnRunStep()
	{
		PlaySound(0, 10, SOUND_STEP1, SOUND_STEP2);
	}

	// attack_strike
	void OnAttackStrike()
	{
		if (DOING_FADE)
		{
			// (always true here) if !POISON_NOVA
			OnBecomeVisible();
		}
		SetMoveAnim(ANIM_RUN);
		AM_CRAWLING = false;
		SWIPE_ATTACK = true;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), DMG_SWIPE, ATTACK_HITCHANCE, "slash");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreqFade() {} // FREQ_FADE
	void OnFreqJump() {} // FREQ_JUMP
	void OnSummonFreq() {} // SUMMON_FREQ

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/k_childre_black.mdl");
		CallEventDelayed(Float(Eval("FREQ_IDLE")), "KChildreBossJelly_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KChildreBossJelly_FirstThink();
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
		if (name == "attack_strike") { OnAttackStrike(); return true; }
		if (name == "become_visible") { OnBecomeVisible(); return true; }
		if (name == "do_fade") { OnDoFade(); return true; }
		if (name == "do_fade2") { OnDoFade2(); return true; }
		if (name == "do_jump") { OnDoJump(); return true; }
		if (name == "do_nova_FX") { OnDoNovaFx(); return true; }
		if (name == "do_nova_part_1") { OnDoNovaPart1(); return true; }
		if (name == "do_nova_part_2") { OnDoNovaPart2(Param(params, 0)); return true; }
		if (name == "do_summon") { OnDoSummon(); return true; }
		if (name == "do_warcry") { OnDoWarcry(); return true; }
		if (name == "fade_check") { OnFadeCheck(); return true; }
		if (name == "fade_loop") { OnFadeLoop(); return true; }
		if (name == "flank_targ") { OnFlankTarg(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_parry") { OnGameParry(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), Float(Param(params, 4)), Float(Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "invis_run2") { OnInvisRun2(); return true; }
		if (name == "jump_check") { OnJumpCheck(); return true; }
		if (name == "jump_done") { OnJumpDone(Param(params, 0)); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_flinch") { OnNpcFlinch(Float(Param(params, 0))); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "push_forward") { OnPushForward(); return true; }
		if (name == "reset_fade_delay") { OnResetFadeDelay(); return true; }
		if (name == "resume_attack") { OnResumeAttack(); return true; }
		if (name == "run_step") { OnRunStep(); return true; }
		if (name == "walk_step") { OnWalkStep(); return true; }
		if (name == "KChildreBossJelly_Timer") { KChildreBossJelly_Timer(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
