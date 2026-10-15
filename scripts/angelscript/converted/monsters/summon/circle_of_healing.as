#pragma context server

// Converted from monsters/summon/circle_of_healing.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/base_aoe.as"

[script "monsters/summon/circle_of_healing"]
class CircleOfHealing : BaseAoeScript
{
	// Constants
	string SEAL_MODEL = "weapons/magic/seals.mdl";
	string SEAL_OFS = "26";
	string SOUND_PULSE = "ambience/alien_zonerator.wav";
	int CIRCLE_RADIUS = 172;
	float PULSE_PLAYTIME = 10.0f;

	// Variables (an unset .script variable reads as its own name)
	string MY_DURATION = "MY_DURATION";
	string HEAL_AMT = "HEAL_AMT";
	float DIV_SKILL = 0.0f;
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	string PLAYING_DEAD = "PLAYING_DEAD";
	string NEAR_SEAL = "NEAR_SEAL";
	bool SET_DELETE = false;

	// Variables declared by included files, with the value they start with in this script
	CircleOfHealing()
	{
		AOE_RADIUS = "172";
		AOE_FREQ = 1.0f;
		AOE_FRIEND_FOE = "ally";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseAoe_OnGameSpawn(playerRace, playerGender); // monsters/summon/base_aoe

		SetName("Circle of Healing");
		SetHealth(1);
		SetInvincible(true);
		SetRace("beloved");
		SetGravity(0);
		SetBlood("none");
		SetModel(SEAL_MODEL);
		SetModelBody(0, Int(SEAL_OFS));
		SetSolid("none");
		LegacyCommand("drop_to_floor");

		SetNoPush(true);

		PLAYING_DEAD = "1";

		CallEventDelayed(0.1f, "make_seal");
		ServerPlaySound(2, 10, SOUND_PULSE);

		ScriptFlags(self, "add", "hc", "hc"); // Flag this as an hc, so magic hands can check for hc later.
	}

	// aoe_end
	void OnAoeEnd()
	{
		BaseAoe_OnAoeEnd(); // monsters/summon/base_aoe
		ServerPlaySound(2, 0, SOUND_PULSE);
		IS_ACTIVE = false;
		DeleteEntity(ENT_ME);
	}

	// game_dynamically_created
	// PARAM1 = owner PARAM2 = CircleDuration PARAM3 = FreezeDuration
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		MY_DURATION = creatorValue2;
		HEAL_AMT = damage;

		DIV_SKILL = SkillOf(MY_OWNER, "spellcasting.divination");

		OWNER_ISPLAYER = Text(IsPlayer(creatorValue1));

		CallEventOrDelay(MY_DURATION, "aoe_end");
	}

	// make_seal
	void OnMakeSeal()
	{
		NEAR_SEAL = LegacyFunction("get_tsphere", "ally", AOE_RADIUS, MyOrigin());
		int count = GetTokenCount(NEAR_SEAL);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCheckIfNear();
		}
	}

	// check_if_near
	void OnCheckIfNear()
	{
		CBaseEntity@ curEnt = FindEntity(GetToken(NEAR_SEAL, loopIteration));
		if (!Contains(NameOf(NEAR_SEAL), "Healing"))
			return;
		if (SET_DELETE)
			return;
		SET_DELETE = true;
		PlayerMessageDark(MY_OWNER, "Healing Circle: Cannot create one healing circle within another.");
	}

	// apply_aoe_effect
	void OnApplyAoeEffect(CBaseEntity@ target = null)
	{
		bool exitSub = false;
		bool addPoints = false;
		if (Contains(NameOf(target), "Spell")) // thing keeps trying to heal the spell maker ;)
			exitSub = true;
		if (exitSub)
			return;
		if (Contains(ItemNameOf(target), "circle_of_heal"))
			OnAoeEnd();
		if (!(HealthOf(target) < MaxHealthOf(target)))
			return;

		if (Truthy(ScriptVarOf(target, "PLAYING_DEAD")))
			return;
		ApplyEffect(target, "effects/effect_rejuv2", 0, HEAL_AMT, MY_OWNER);

		if (IsPlayer(target))
			addPoints = true;
		if (Truthy(ScriptVarOf(target, "NPC_CRITICAL")))
			addPoints = true;
		if (addPoints && EntityId(target) != MY_OWNER)
			CallExternal(MY_OWNER, "add_damage_points", HEAL_AMT);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnMyDuration() {} // MY_DURATION

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/magic/seals.mdl");
		Precache("ambience/alien_zonerator.wav");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "aoe_end") { OnAoeEnd(); return true; }
		if (name == "apply_aoe_effect") { OnApplyAoeEffect(EntityParam(params, 0)); return true; }
		if (name == "check_if_near") { OnCheckIfNear(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "make_seal") { OnMakeSeal(); return true; }
		return BaseAoeScript::DispatchEvent(name, params);
	}
}
