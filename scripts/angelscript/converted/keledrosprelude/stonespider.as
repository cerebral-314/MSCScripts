#pragma context server

// Converted from keledrosprelude/stonespider.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.
// Thothie - This bugger wasn't working
// - For simplicity's sake, I'm using the spiders/thornlands, which does work, and matching up the stats
// - Differences: >range <accuracy >damage
// - Just to make it intersting, adding a 1 in 10 chance per hit for major knock back or stun
// - Maybe he'll knock you into that pit yer next to. ^_^
// Stone Spider (from Thornlands Spider)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/spider_base.as"

[script "keledrosprelude/stonespider"]
class Stonespider : SpiderBaseScript
{
	// Constants
	string SOUND_ATTACK1 = "zombie/claw_miss1.wav";
	string SOUND_ATTACK2 = "zombie/claw_miss2.wav";
	string ANIM_DODGE = "dodge";
	string NPC_BASE_EXP = "100";

	// Variables (an unset .script variable reads as its own name)
	string PUSH_VEL = "PUSH_VEL";

	// Variables declared by included files, with the value they start with in this script
	Stonespider()
	{
		SOUND_PAIN = "monsters/spider/spiderhiss.wav";
		SOUND_IDLE1 = "monsters/spider/spideridle.wav";
		SOUND_DEATH = "monsters/spider/spiderdie.wav";
		SND_STRUCK1 = "weapons/axemetal1.wav";
		SND_STRUCK2 = "weapons/axemetal2.wav";
		SND_STRUCK3 = "debris/concrete1.wav";
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ATTACK_DAMAGE_LOW = 14.0f;
		ATTACK_DAMAGE_HIGH = 20.0f;
		ATTACK_ACCURACY = "60%";
		SPIDER_IDLE_VOL = 4;
		SPIDER_IDLE_DELAY = 3.6f;
		SPIDER_VOLUME = 10;
	}

	// unnamed block (first think)
	void Stonespider_FirstThink()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "attack";
		ANIM_DEATH = "die";

		MOVE_RANGE = "100";
		ATTACK_RANGE = 250.0f;
		ATTACK_HITRANGE = 300.0f;
		NPC_GIVE_EXP = 100.0f;

		IMMUNE_VAMPIRE = true;
	}

	// game_damaged_other
	string Stonespider_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		if (PUSH_VEL == "PUSH_VEL")
			return result;

		AddVelocity(ENT_LASTSTRUCKBYME, Vec(PUSH_VEL)); // Push the player a bit
		return result;
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, Stonespider_OnGameDamagedOther(target, damage, damageType, damageEvent));
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
		SetDamageTaken("holy", 2);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SpiderBase_OnNpcSpawn(npc); // monsters/spider_base

		SetHealth(500);
		SetWidth(120);
		SetHeight(64);
		SetName("Spider made of stone");
		SetHearingSensitivity(6);
		SetModel("monsters/fer_spider_giant.mdl");
		SetModelBody(0, 3);

		SetDamageTaken("all", 0.85f);
		SetDamageTaken("poison", 0);
	}

	// bite1
	// Deal damage
	void OnBite1()
	{
		if (RandomInt(0, 1) == 0)
			PlayRandomSound(Int(GetVar("CHAN_VOICE")), SPIDER_VOLUME, SOUND_ATTACK1, SOUND_ATTACK2);
		PUSH_VEL = Text(RelativeVelocity(Vector3(0, 100, 0)));
		if (RandomInt(1, 10) == 1)
			ApplyEffect(ENT_LASTSTRUCKBYME, "effects/effect_push", 3, RelativeVelocity(Vector3(0, 200, 200)), 0);
		if (RandomInt(1, 10) == 1)
			ApplyEffect(ENT_LASTSTRUCKBYME, "effects/debuff_stun", 3, self);
		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, Random(ATTACK_DAMAGE_LOW, ATTACK_DAMAGE_HIGH), "85%");
	}

	// check_attack
	void OnCheckAttack()
	{
		bool attack = false;

		if (IS_FLEEING)
			return;

		if (!IsAlive(HUNT_LASTTARGET))
			return;

		if (RangeTo(HUNT_LASTTARGET) <= ATTACK_RANGE)
			attack = true;

		if (!attack)
			return;
		OnNpcatkAttackenemy();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/fer_spider_giant.mdl");
		CallEventDelayed(SPIDER_IDLE_DELAY, "SpiderBase_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Stonespider_FirstThink();
		SpiderBase_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "check_attack") { OnCheckAttack(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return SpiderBaseScript::DispatchEvent(name, params);
	}
}
