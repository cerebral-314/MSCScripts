#pragma context server

// Converted from orc_for/orc_demonic_sa.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/orc_for/tiers1.as"
#include "converted/monsters/orc_flayer.as"

[script "orc_for/orc_demonic_sa"]
class OrcDemonicSa : MonstersOrcFlayerScript, Tiers1
{
	// Constants
	string NPC_BASE_EXP = "200";
	float FREQ_FIREBALL = 0.0f;
	string FIRE_BALL_DAMAGE_NORM = "$rand(75,100)";
	string FIRE_BALL_DAMAGE_ALT = "$rand(25,50)";
	float DOT_FIRE = 10.0f;
	string SOUND_FIRECHARGE = "magic/fireball_powerup.wav";
	string SOUND_FIRESHOOT = "magic/fireball_strike.wav";

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	string FIRE_BALL_DAMAGE = "FIRE_BALL_DAMAGE";
	float NEXT_FIREBALL = 0.0f;
	bool SAY_SUMMONER = false;
	bool MELEE_ATTACK = false;

	// Variables declared by included files, with the value they start with in this script
	OrcDemonicSa()
	{
		NPC_SELF_ADJUST = true; // from orc_for/tiers1
		NPC_ADJ_DMG_MUTLI_TOKENS = "1.0;1.5;2.0;5.0;7.5;10.0;"; // from orc_for/tiers1
		NPC_ADJ_HP_MUTLI_TOKENS = "1.0;2.0;3.0;5.0;7.5;10.0;"; // from orc_for/tiers1
	}

	// unnamed block (first think)
	void OrcDemonicSa_FirstThink()
	{
		ORC_JUMPER = true;

		IS_UNHOLY = true;
	}

	// game_dodamage
	string OrcDemonicSa_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (MELEE_ATTACK && hit)
			ApplyEffect(target, "effects/dot_fire", 5.0f, self, DOT_FIRE);
		MELEE_ATTACK = false;
		return result;
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseMelee_OnOrcSpawn(); // monsters/orc_base_melee
		MonstersOrcFlayer_OnOrcSpawn(); // monsters/orc_flayer

		SetHealth(500);
		// ov 180
		SetName("Demonic Blackhand");
		SetProp(ENT_ME, "skin", 2);
		SetHearingSensitivity(2);
		SetStat("parry", 50);
		SetDamageTaken("all", 0.5f);
		SetDamageTaken("holy", 0.5f);
		SetDamageTaken("fire", 0);

		SetModelBody(0, 2); // Body 0=naked 1=leather 2=plate 3=green-hide
		SetModelBody(1, 2); // Head 0=cap_shorthorn 1=cap_nohorn 2=buffo_skin 3=cheif_ramhorns 4=green_hood
		SetModelBody(2, 5); // Weapon 0=fist 1=axe 2=bow_weak 3=bow_strng 4=sword 5=bloodyaxe 6=sword&sheild

		CallEventDelayed(2.0f, "final_adjstments");
	}

	// swing_sword
	void OnSwingSword()
	{
		OrcBaseMelee_OnSwingSword(); // monsters/orc_base_melee
		MELEE_ATTACK = true;
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, OrcDemonicSa_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		NEXT_FIREBALL = GameTime() + FREQ_FIREBALL;
		if (!SAY_SUMMONER)
			return;
		SetSayTextRange(4096);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared

		if (SAY_SUMMONER)
		{
			SetSayTextRange(4096);
			SayText("The enemy must not reach the summoner! STOP THEM!");
			SAY_SUMMONER = false;
		}

		if (!(GameTime() > NEXT_FIREBALL))
			return;
		if (!(RangeTo(NPCATK_TARGET) > ATTACK_HITRANGE))
			return;
		NEXT_FIREBALL = GameTime() + FREQ_FIREBALL;

		PlaySound(0, 10, SOUND_FIRESHOOT);
		PlayAnim("critical", ANIM_ATTACK);
		AS_ATTACKING = GameTime() + 2.0f;

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_fire_ball", RelativePosition(Vector3(0, 48, 12)), NPCATK_TARGET, 400, FIRE_BALL_DAMAGE, 2, "none");
		CallExternal(ENT_LASTPROJECTILE, "lighten", DOT_FIRE, 0.0f);
	}

	// final_adjstments
	void OnFinalAdjstments()
	{
		// get rid of shortsword drop
		DROP_ITEM1 = "none";
		DROP_ITEM1_CHANCE = "0%";

		if (!(NPC_ADJ_LEVEL < 2.0f))
			return;
		FIRE_BALL_DAMAGE = FIRE_BALL_DAMAGE_ALT;
	}

	// set_summoner_comment
	void OnSetSummonerComment()
	{
		SAY_SUMMONER = true;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OrcDemonicSa_FirstThink();
		Tiers1_FirstThink();
		MonstersOrcFlayer_FirstThink();
		OrcBaseMelee_FirstThink();
		OrcBase_FirstThink();
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
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "final_adjstments") { OnFinalAdjstments(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "set_summoner_comment") { OnSetSummonerComment(); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		return MonstersOrcFlayerScript::DispatchEvent(name, params);
	}
}
