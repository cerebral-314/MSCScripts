#pragma context server

// Converted from minibosses/phlame.script by msc_transpiler.
// - Summons monsters via map triggers (counts via external calls) [lava scrops, lava boars, demon birds]
// - Transforms into Flame Wing (actually teleports out, and spawns flame wing via trigger)
// - Repulse flame burst /20sec (three in quick sucsession)
// - Flaming Shadow dodge (like Hollow One, but torrent of flames)
// - Blunt + Fire DOT mele
// - Eye Beam single target
// - Spawn multiple flaming boulders (bounce in arc)
// - Spawn fire variant of rock storm
// - Trigger meteor shower (via map trigger)
// - Flame staff (fire breath'ish)
// - Guided Burst (fire ball shoots out, explodes into multiple shots [1 for each valid target in radius])
// (also todo: make corrosive reaver)
// (only resummon if G_NPC_SUMMON_COUNT <= 2)

#include "runtime/ScriptEntity.as"
// #include monsters/base_npc_new - not found

[script "minibosses/phlame"]
class MinibossesPhlame : ScriptEntity
{
	// Constants
	string ANIM_RUN_DEF = "run2";
	string ANIM_WALK_DEF = "walk2handed";
	string ANIM_IDLE_DEF = "idle";
	string ANIM_LOOK = "idle_look";
	string ANIM_SUMMON = "summon";
	string ANIM_METEOR = "cieling_strike";
	string ANIM_BOULDERS = "cieling_strike";
	string ANIM_REPULSE = "fdeploy_strike";
	string ANIM_DODGE = "staff_aim";
	string ANIM_BEAM = "staff_aim";
	string ANIM_FIRE_BREATH = "aim_1";
	string ANIM_GUIDED_BURST = "shoot_1";
	float NPC_BOSS_REGEN_RATE = 0.05f;
	float FREQ_GLOAT = 0.0f;
	float FREQ_PAIN = 0.0f;
	string SOUND_GLOAT1 = "voices/phlame/vs_nx0headm_haha.wav";
	string SOUND_GLOAT2 = "voices/phlame/vs_nx0headm_attk.wav";
	string SOUND_GLOAT3 = "voices/phlame/vs_nx0headm_bat1.wav";
	string SOUND_GLOAT4 = "voices/phlame/vs_nx0headm_bat3.wav";
	string SOUND_SUMMON = "voices/phlame/vs_nx0headm_bat2.wav";
	string SOUND_PAIN1 = "voices/phlame/vs_nx0headm_atk1.wav";
	string SOUND_PAIN_HEALTHY = "voices/phlame/vs_nx0headm_yes.wav";
	string SOUND_PAIN_WEAK = "voices/phlame/vs_nx0headm_no.wav";
	string SOUND_STRUCK1 = "debris/flesh1.wav";
	string SOUND_STRUCK2 = "debris/flesh2.wav";
	string SOUND_SWING1 = "zombie/claw_miss1.wav";
	string SOUND_SWING2 = "zombie/claw_miss2.wav";
	string SOUND_STRONG_SWING1 = "zombie/claw_strike1.wav";
	string SOUND_STRONG_SWING2 = "zombie/claw_strike2.wav";
	string SOUND_DEATH = "none";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle";
	string ANIM_WALK = "walk2handed";
	string ANIM_RUN = "run2";
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool NPC_IS_BOSS = true;
	float NPC_GIVE_EXP = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	bool IS_UNHOLY = false;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	float NEXT_GLOBAL_GLOAT = 0.0f;
	bool IS_WEAK = false;
	float NEXT_PAIN = 0.0f;
	float NEXT_LEAP_AWAY = 0.0f;
	bool STAFF_STRIKE = false;

	// unnamed block (first think)
	void MinibossesPhlame_FirstThink()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk2handed";
		ANIM_RUN = "run2";
		ANIM_ATTACK = "staff_strike"; // frame_staff_strike
	}

	// unnamed block (first think)
	void MinibossesPhlame_FirstThink2()
	{
		NPC_IS_BOSS = true;
		NPC_GIVE_EXP = 15000.0f;

		ATTACK_MOVERANGE = 768.0f;
		ATTACK_RANGE = 200.0f;
		ATTACK_HITRANGE = 250.0f;
	}

	// game_dodamage
	string MinibossesPhlame_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (STAFF_STRIKE)
		{
			ApplyEffect("NPCATK_TARGET", "effects/dot_fire", 5.0f, self, "DOT_FIRE");
			STAFF_STRIKE = false;
		}
		return result;
	}

	// game_precache
	void OnGamePrecache()
	{
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetName("Phlame the Ever Burning");
		SetRace("demon");
		SetHealth(15000);

		SetUniqueName("phlame_wiz");

		SetDamageTaken("all", 0.5f);
		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 1.25f);
		SetDamageTaken("lightning", 0.5f);
		SetDamageTaken("poison", 0.25f);
		SetDamageTaken("acid", 0.5f);
		SetDamageTaken("holy", 1.25f);

		IS_UNHOLY = true;
		SetMoveAnim(ANIM_LOOK);
		SetIdleAnim(ANIM_LOOK);

		SetInvincible(true);

		SetSayTextRange(1024);

		OnNpcatkSuspendAi();
		NO_STUCK_CHECKS = "1";

		CallEventDelayed(2.0f, "speak_begin");
		CallEventDelayed(5.0f, "let_us_begin");
	}

	// speak_begin
	void OnSpeakBegin()
	{
		SayText("Then... Let us... Begin...");
	}

	// let_us_begin
	void OnLetUsBegin()
	{
		SetInvincible(false);

		ANIM_RUN = ANIM_WALK_DEF;
		ANIM_IDLE = ANIM_IDLE_DEF;

		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);

		OnNpcatkResumeAi();
		NO_STUCK_CHECKS = "0";
		OnStartCycles();
	}

	// bs_global_command
	void OnBsGlobalCommand(CBasePlayer@ deadPlayer = null, string command = "", string reason = "")
	{
		if (reason != "death")
			return;
		if (!IsAlive(ENT_ME))
			return;
		if (!(GameTime() > NEXT_GLOBAL_GLOAT))
			return;
		NEXT_GLOBAL_GLOAT = GameTime() + 15.0f;

		// random global gloat whenever a player dies (anywhere) - maps side
		int rndGloat = RandomInt(1, 4);
		if (rndGloat == 1)
			UseTrigger("snd_gloat1");
		if (rndGloat == 2)
			UseTrigger("snd_gloat2");
		if (rndGloat == 3)
			UseTrigger("snd_gloat3");
		if (rndGloat == 4)
			UseTrigger("snd_gloat4");
	}

	// do_gloat
	void OnDoGloat()
	{
		PlayRandomSound(0, 10, SOUND_GLOAT1, SOUND_GLOAT2, SOUND_GLOAT3, SOUND_GLOAT4);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (HealthOf(ENT_ME) < 0.0f)
			IS_WEAK = true;
		else
			IS_WEAK = false;

		if (GameTime() > NEXT_PAIN)
		{
			NEXT_PAIN = GameTime();
			if (!IS_WEAK)
				PlayRandomSound(0, 10, SOUND_PAIN1, SOUND_PAIN_HEALTHY);
			else
				PlayRandomSound(0, 10, SOUND_PAIN1, SOUND_PAIN_WEAK);
		}
		else
		{
			PlayRandomSound(0, 8, SOUND_STRUCK1, SOUND_STRUCK2);
		}

		if (IS_WEAK)
		{
			ANIM_RUN = ANIM_RUN_DEF;
			SetMoveAnim(ANIM_RUN);
		}
		else
		{
			ANIM_RUN = ANIM_WALK_DEF;
			SetMoveAnim(ANIM_RUN);
		}

		if (!IS_WEAK)
			return;

		if (RangeTo(ENT_LASTSTRUCK) < 200.0f && GameTime() > NEXT_LEAP_AWAY)
		{
			NEXT_LEAP_AWAY = GameTime() + 0.0f;
			OnDoLeapAway();
		}
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return MinibossesPhlame_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// frame_staff_strike
	// ============================================================ Animation Events
	void OnFrameStaffStrike()
	{
		int rndStrength = RandomInt(1, 2);
		if (rndStrength == 1)
			PlayRandomSound(0, 10, SOUND_SWING1, SOUND_SWING2);
		else
			PlayRandomSound(0, 10, SOUND_STRONG_SWING1, SOUND_STRONG_SWING2);

		string dmgText = "DMG_STAFF";
		float dmg = 0.0f;
		if (rndStrength == 2)
		{
			dmg *= 4.0f;
			dmgText = Text(dmg);
		}

		STAFF_STRIKE = true;
		DoDamage("NPCATK_TARGET", ATTACK_HITRANGE, dmgText, "90%", "blunt");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnDoLeapAway() {} // do_leap_away
	void OnNpcatkResumeAi(string target = "") {} // npcatk_resume_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "") {} // npcatk_suspend_ai
	void OnStartCycles() {} // start_cycles

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("c-tele1.spr");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MinibossesPhlame_FirstThink();
		MinibossesPhlame_FirstThink2();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bs_global_command") { OnBsGlobalCommand(PlayerParam(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "do_gloat") { OnDoGloat(); return true; }
		if (name == "frame_staff_strike") { OnFrameStaffStrike(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "let_us_begin") { OnLetUsBegin(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "speak_begin") { OnSpeakBegin(); return true; }
		return false;
	}
}
