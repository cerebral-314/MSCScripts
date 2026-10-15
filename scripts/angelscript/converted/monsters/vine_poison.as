#pragma context server

// Converted from monsters/vine_poison.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_stripped_ai.as"

[script "monsters/vine_poison"]
class VinePoison : BaseStrippedAiScript
{
	// Constants
	string ANIM_ATTACK = "attack1";
	string ANIM_GROW = "raise";
	int DMG_ATK = 100;
	int DOT_ATK = 50;
	string SOUND_ATTACK1 = "tentacle/te_roar1.wav";
	string SOUND_ATTACK2 = "tentacle/te_roar1.wav";

	// Variables (an unset .script variable reads as its own name)
	bool IMMUNE_VAMPIRE = false;
	bool VINE_SUSPEND = false;
	bool SWING_ATTACK = false;

	// Variables declared by included files, with the value they start with in this script
	VinePoison()
	{
		NPC_GIVE_EXP = 200.0f;
		ANIM_IDLE = "idle";
		ATTACK_HITRANGE = 200.0f;
		SOUND_STRUCK1 = "debris/flesh1.wav";
		SOUND_STRUCK2 = "debris/flesh2.wav";
		SOUND_STRUCK3 = "debris/flesh3.wav";
		SOUND_PAIN1 = "tentacle/te_alert1.wav";
		SOUND_PAIN2 = "tentacle/te_alert2.wav";
		SOUND_DEATH = "tentacle/te_move2.wav";
	}

	// unnamed block (first think)
	void VinePoison_FirstThink()
	{
		NPC_GIVE_EXP = 200.0f;
		ANIM_DEATH = "lower";
	}

	// game_dodamage
	string VinePoison_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (!hit)
			return result;
		if (SWING_ATTACK)
		{
			ApplyEffect(target, "effects/dot_poison", 5.0f, self, DOT_ATK); // *** switched this to dot_poison from effect_burn
			AddVelocity(target, RelativeVelocity(Vector3(-200, -300, 110)));
		}
		SWING_ATTACK = false;
		return result;
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseStrippedAi_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_stripped_ai
		PlayAnim("critical", ANIM_DEATH);
		// playsound 2 0 SOUND_BURN
		PlaySound(1, 10, SOUND_DEATH);
		ClearEffects();
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseStrippedAi_OnGameSpawn(playerRace, playerGender); // monsters/base_stripped_ai
		SetName("Poison Vine");
		SetModel("monsters/deadlyvine.mdl");
		SetWidth(32);
		SetHeight(64);
		SetHealth(1000);
		SetRace("demon");
		SetBlood("none");
		SetNoPush(true);
		IMMUNE_VAMPIRE = true; // plant blood
		SetHearingSensitivity(11);
		SetIdleAnim(ANIM_GROW);
		SetMoveAnim(ANIM_GROW);
		PlayAnim("once", ANIM_IDLE);
		VINE_SUSPEND = true;
		SetProp(ENT_ME, "rendermode", 2);
		SetProp(ENT_ME, "renderamt", 0);
		// skilllevel NPC_GIVE_EXP
		SetDamageTaken("lightning", 2);
		SetDamageTaken("poison", 0);
		CallEventDelayed(2.0f, "grow_in");
		SetModelBody(0, 1); // *** setmodelbody, not "setsubmodel" - editplus + ms.stx helps prevent typos like these
	}

	// set_wallmount
	// *** I 'spariment here, to see if we can mount these on walls (apparently fail)
	void OnSetWallmount()
	{
		SetGravity(0);
		SetFly(true);
	}

	// grow_in
	void OnGrowIn()
	{
		SetProp(ENT_ME, "rendermode", 0);
		SetProp(ENT_ME, "renderamt", 255);

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_IDLE);
		VINE_SUSPEND = false;
		PlayAnim("critical", ANIM_GROW);
		PlaySound(1, 10, "tentacle/te_move1.wav");
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		if (!IsAlive(ENT_ME))
			return;
		if (VINE_SUSPEND)
			return;
		CBaseEntity@ heardId = EntityOf(ENT_LASTHEARD);
		// dbg game_heardsound $get(ent_lastheard,name) $get(HEARD_ID,range) $get(ent_me,relationship,HEARD_ID)
		if (RelationshipOf(ENT_ME, @heardId) != "enemy")
			return;
		NPCATK_TARGET = EntityId(heardId);
		SetMoveDest(NPCATK_TARGET, 9999);
		if (!(RangeTo(heardId) < ATTACK_HITRANGE))
			return;
		PlayAnim("once", ANIM_ATTACK);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (!IsAlive(ENT_ME))
			return;
		PlaySound(0, 5, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_PAIN1, SOUND_PAIN2);

		if (VINE_SUSPEND)
			return;
		if (!(RangeTo(ENT_LASTSTRUCK) < ATTACK_HITRANGE))
			return;
		NPCATK_TARGET = EntityId(EntityOf(ENT_LASTSTRUCK));
		SetMoveDest(NPCATK_TARGET, 9999);
		PlayAnim("once", ANIM_ATTACK);
	}

	// frame_attack
	void OnFrameAttack()
	{
		SWING_ATTACK = true;
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2);
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_ATK, "100%", "pierce");
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return VinePoison_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/deadlyvine.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		VinePoison_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "frame_attack") { OnFrameAttack(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "grow_in") { OnGrowIn(); return true; }
		if (name == "set_wallmount") { OnSetWallmount(); return true; }
		return BaseStrippedAiScript::DispatchEvent(name, params);
	}
}
