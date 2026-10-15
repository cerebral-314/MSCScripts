#pragma context server

// Converted from monsters/gbat_hunter.script by msc_transpiler.
// Thothie - trying desperately to fix the giant bat
// Giant Bat

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bat_base.as"

[script "monsters/gbat_hunter"]
class GbatHunter : BatBaseScript
{
	// Constants
	string ANIM_DROP = "hangtofly";
	string SOUND_PAIN1 = "monsters/bat/pain1.wav";
	string SOUND_PAIN2 = "monsters/bat/pain2.wav";
	string SOUND_ATTACK1 = "monsters/skeleton/claw_miss1.wav";
	string SOUND_ATTACK2 = "monsters/skeleton/claw_miss2.wav";
	string SOUND_ATTACK3 = "monsters/orc/attack3.wav";
	string SOUND_ALERT = "monsters/bat/alert.wav";
	string SOUND_FLAP1 = "monsters/bat/flap_big1.wav";
	string SOUND_FLAP2 = "monsters/bat/flap_big2.wav";
	string BAT_SUMMON_SCRIPT = "monsters/bat_summon";
	int BAT_SUMMON_AMT = 5;
	int BAT_SUMMON_LIFETIME = 15;
	int BAT_SUMMON_DMG = 4;
	int BAT_SUMMON_HEIGHT = 300;
	string BAT_SUMMON_CHANCE = "60%";
	string BAT_SUMMON_SND_RETREAT = "monsters/bat/pain1.wav";
	string BAT_SUMMON_SND_SUMMON = "monsters/bat/death.wav";

	// Variables (an unset .script variable reads as its own name)
	bool CAN_STTACK = false;
	bool BAT_SUMMONING = false;
	bool BAT_SUMMON_BLOCKED = false;
	bool BAT_SUMMON_RISING = false;
	float BAT_SUMMON_NUM = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	GbatHunter()
	{
		ANIM_RUN = "fly";
		ANIM_WALK = "fly";
		ANIM_IDLE_HANG = "idlehang";
		ANIM_IDLE_FLY = "idle";
		ATTACK_DAMAGE = "15";
		ATTACK_HITCHANCE = "85%";
		SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
		SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
		SOUND_DEATH = "monsters/bat/death.wav";
	}

	// unnamed block (first think)
	void GbatHunter_FirstThink()
	{
		ANIM_RUN = "fly";
		ANIM_WALK = "fly";
		ANIM_ATTACK = "attack2";
		ANIM_IDLE_HANG = "idlehang";
		ANIM_IDLE_FLY = "idle";
		ANIM_DEATH = "die";

		MOVE_RANGE = "70";
		ATTACK_RANGE = 120.0f;
		ATTACK_HITRANGE = 180.0f;
		NPC_GIVE_EXP = 150.0f;
	}

	// unnamed block (first think)
	// Spawn some friends
	// ==================
	void GbatHunter_FirstThink2()
	{
		PrecacheFile("monsters/bat_summon");
	}

	// unnamed block (timer)
	void GbatHunter_Timer()
	{
		CallEventDelayed(3.0f, "GbatHunter_Timer");

		if (!IS_HUNTING)
			return;
		if (!(Float(Eval("game.monster.last_seen.distance")) < 128.0f))
			return;
		if (BAT_SUMMONING)
			return;
		if (BAT_SUMMON_BLOCKED)
			return;
		if (!(RandomInt(0, 99) < Float(BAT_SUMMON_CHANCE)))
			return;
		if (!IsAlive(ENT_ME))
			return;

		Vector3 targetpos = OriginOf(ENT_ME) + RelativeVelocity(Vector3(0, -128, 0));

		SetRoam(false);
		SetMoveDest(targetpos, 64);
		BAT_SUMMONING = true;
		BAT_SUMMON_BLOCKED = true;
		CAN_ATTACK = "0";
		NPC_MOVE_TARGET = "\xEF\xBF\xBDNONE\xEF\xBF\xBD";
		CAN_RETALIATE = "0";
		CAN_HEAR = "0";
		PlaySound(Int(Eval("game.sound.voice")), Eval("game.sound.maxvol"), BAT_SUMMON_SND_RETREAT);
		CallEventDelayed(0.75f, "bat_summon_flyup");
	}

	// bat_spawn
	void OnBatSpawn()
	{
		SetName("Giant Bat");
		SetHealth(500);
		// ov 359
		SetWidth(50);
		SetHeight(60);
		SetHearingSensitivity(10);
		SetModel("monsters/giant_bat.mdl");
		SetVolume(10);
		SetSolid("none"); // one of many whacky tries

		CAN_STTACK = false;
	}

	// bat_drop_down
	// Drop down from the ceiling
	void OnBatDropDown()
	{
		PlayAnim("once", ANIM_DROP);
		BAT_STATUS = BAT_DROPPING;
		CAN_ATTACK = "0";
		CAN_HUNT = "0";
		PlaySound(Int(GetVar("CHAN_VOICE")), SOUND_ALERT);
	}

	// frame_hangdone
	// Finished dropping
	void OnFrameHangdone()
	{
		BAT_STATUS = (BAT_FLYING ? 1 : 0);
		CAN_ATTACK = "1";
		CAN_HUNT = "1";
		SetIdleAnim(ANIM_IDLE_FLY);
		SetRoam(true);
	}

	// frame_attack1
	// Deal damage
	void OnFrameAttack1()
	{
		OnAttackYell();
		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, ATTACK_DAMAGE, ATTACK_HITCHANCE);
	}

	// frame_attack2
	// Deal damage
	void OnFrameAttack2()
	{
		OnAttackYell();
		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, ATTACK_DAMAGE, ATTACK_HITCHANCE);
	}

	// attack_yell
	// Attack grunts
	void OnAttackYell()
	{
		if (RandomInt(0, 1) == 0)
			PlayRandomSound(Int(GetVar("CHAN_VOICE")), SOUND_ATTACK1, SOUND_ATTACK2);
	}

	// npc_struck
	// Hit by someone
	void OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(Int(GetVar("CHAN_BODY")), SOUND_PAIN1, SOUND_PAIN2, SOUND_STRUCK1, SOUND_STRUCK2, "none");
	}

	// bat_summon_flyup
	void OnBatSummonFlyup()
	{
		Vector3 targetpos = OriginOf(ENT_ME);
		string rayUp = "(0,0," + BAT_SUMMON_HEIGHT + ")";
		targetpos += Vec(rayUp);
		BAT_SUMMON_RISING = true;
		SetMoveDest(targetpos, 64);
	}

	// game_stopmoving
	void OnGameStopmoving()
	{
		if (!BAT_SUMMON_RISING)
			return;
		BAT_SUMMON_RISING = false;

		// setangle face HUNT_LASTTARGET
		CallEventDelayed(0.75f, "bat_summon_all");
	}

	// bat_summon_all
	void OnBatSummonAll()
	{
		PlaySound(Int(Eval("game.sound.voice")), Eval("game.sound.maxvol"), BAT_SUMMON_SND_SUMMON);
		PlayAnim("once", "attack2");
		BAT_SUMMON_NUM = BAT_SUMMON_AMT;
		CallEventDelayed(0.5f, "bat_summon_loop");
		CallEventDelayed(1.0f, "bat_summon_done");
	}

	// bat_summon_loop
	void OnBatSummonLoop()
	{
		if (int(BAT_SUMMON_NUM) == 0)
			return;
		BAT_SUMMON_NUM -= 1.0f;
		Vector3 targetpos = OriginOf(ENT_ME);
		int ofsX = RandomInt(-100, 100);
		int ofsY = RandomInt(-100, 100);
		targetpos += Vector3(ofsX, ofsY, -64);
		CreateNpc(BAT_SUMMON_SCRIPT, targetpos, BAT_SUMMON_LIFETIME, BAT_SUMMON_DMG, HUNT_LASTTARGET);
		CallEventDelayed(0.001f, "bat_summon_loop");
	}

	// bat_summon_done
	void OnBatSummonDone()
	{
		// setangle face HUNT_LASTTARGET
		// setangle face.x 0
		BAT_SUMMONING = false;
		BAT_SUMMON_RISING = false;
		CAN_ATTACK = "1";
		NPC_MOVE_TARGET = "enemy";
		CAN_RETALIATE = "1";
		CAN_HEAR = "1";
		CallEventDelayed(BAT_SUMMON_LIFETIME, "bat_summon_reset");
	}

	// bat_summon_reset
	void OnBatSummonReset()
	{
		BAT_SUMMON_BLOCKED = false;
	}

	// npc_death
	void OnNpcDeath()
	{
		CallExternal(FindByName("spawner"), "makechest");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnBatSummonLifetime() {} // BAT_SUMMON_LIFETIME

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/bat.mdl");
		Precache("monsters/giant_bat.mdl");
		CallEventDelayed(0.5f, "BatBase_Timer");
		CallEventDelayed(3.0f, "GbatHunter_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		GbatHunter_FirstThink();
		BatBase_FirstThink();
		BaseFlyer_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
		GbatHunter_FirstThink2();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack_yell") { OnAttackYell(); return true; }
		if (name == "bat_drop_down") { OnBatDropDown(); return true; }
		if (name == "bat_spawn") { OnBatSpawn(); return true; }
		if (name == "bat_summon_all") { OnBatSummonAll(); return true; }
		if (name == "bat_summon_done") { OnBatSummonDone(); return true; }
		if (name == "bat_summon_flyup") { OnBatSummonFlyup(); return true; }
		if (name == "bat_summon_loop") { OnBatSummonLoop(); return true; }
		if (name == "bat_summon_reset") { OnBatSummonReset(); return true; }
		if (name == "frame_attack1") { OnFrameAttack1(); return true; }
		if (name == "frame_attack2") { OnFrameAttack2(); return true; }
		if (name == "frame_hangdone") { OnFrameHangdone(); return true; }
		if (name == "game_stopmoving") { OnGameStopmoving(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "GbatHunter_Timer") { GbatHunter_Timer(); return true; }
		return BatBaseScript::DispatchEvent(name, params);
	}
}
