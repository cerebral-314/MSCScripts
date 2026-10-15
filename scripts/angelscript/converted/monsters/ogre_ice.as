#pragma context server

// Converted from monsters/ogre_ice.script by msc_transpiler.
// Even meaner ogre/troll

#include "runtime/ScriptEntity.as"
#include "converted/monsters/swamp_ogre.as"
#include "converted/monsters/base_ice_race.as"

[script "monsters/ogre_ice"]
class OgreIce : SwampOgreScript, BaseIceRace
{
	// Constants
	string NPC_BASE_EXP = "450";
	string CHANCE_FREEZE = "25%";
	float DOT_FREEZE = 30.0f;
	string SOUND_FREEZE = "magic/frost_reverse.wav";

	// Variables declared by included files, with the value they start with in this script
	OgreIce()
	{
		WEAK_THRESHOLD = 1500.0f;
		SWIPE_DAMAGE = "$rand(50,90)";
		HEADBUTT_DAMAGE = "$rand(50,90)";
		LEAP_DAMAGE = "$rand(20,40)";
		FLINCH_HEALTH = 2000.0f;
	}

	// unnamed block (first think)
	void OgreIce_FirstThink()
	{
		DROP_GOLD = 1;
		DROP_GOLD_MIN = 40;
		DROP_GOLD_MAX = 60;

		FLINCH_HEALTH = 2000.0f;
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string OgreIce_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";

		if (HEADBUTT_ON)
		{
			if (hit)
			{
				PlaySound(0, 10, SOUND_HEADBUTT);
				ApplyEffect(NPCATK_TARGET, "effects/debuff_stun", 5, self);
			}
			if (!hit)
				PlayRandomSound(0, 10, SOUND_SWIPEMISS1, SOUND_SWIPEMISS2);
			ANIM_ATTACK = ANIM_SWIPE;
			HEADBUTT_ON = false;
			exitSub = true;
		}
		if (exitSub)
			return result;

		// assumes swipe
		if (!SWIPE_ATTACK)
			return result;
		SWIPE_ATTACK = false;
		if (hit)
		{
			PlayRandomSound(0, 10, SOUND_SWIPEHIT1, SOUND_SWIPEHIT2);
			AddVelocity(ENT_LASTSTRUCKBYME, RelativeVelocity(Vector3(-100, 130, 120)));
			if (RandomInt(1, 100) < Float(CHANCE_FREEZE))
			{
				ApplyEffect(target, "effects/dot_cold", 5.0f, self, DOT_FREEZE);
				PlaySound(0, 10, SOUND_FREEZE);
			}
		}
		if (!hit)
			PlayRandomSound(0, 10, SOUND_SWIPEMISS1, SOUND_SWIPEMISS2);
		return result;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SwampOgre_OnNpcSpawn(npc); // monsters/swamp_ogre
		BaseIceRace_OnNpcSpawn(npc); // monsters/base_ice_race

		SetName("Marogar Ogre");
		SetHealth(2500);
		SetDamageTaken("all", 0.5f);
		SetRace("demon"); // easier placement
		SetRoam(true);
		SetModel(MONSTER_MODEL);
		SetMoveAnim(ANIM_WALK);
		SetHeight(64);
		SetWidth(32);
		SetHearingSensitivity(2);
		SetBlood("green"); // check in code
		SetIdleAnim(ANIM_IDLE);

		RUN_STEP = 0.0f;

		SetProp(ENT_ME, "skin", 1);

		CallEventDelayed(1.0f, "idle_sounds");
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return OgreIce_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OgreIce_FirstThink();
		SwampOgre_FirstThink();
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
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return BaseIceRace_DispatchEvent(name, params)
			|| SwampOgreScript::DispatchEvent(name, params);
	}
}
