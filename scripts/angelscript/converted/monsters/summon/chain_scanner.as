#pragma context server

// Converted from monsters/summon/chain_scanner.script by msc_transpiler.
// NPC to scan for chain bolts by Thothie from scratch

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/base_aoe.as"

[script "monsters/summon/chain_scanner"]
class ChainScanner : BaseAoeScript
{
	// Constants
	string SOUND_ZAP1 = "debris/beamstart14.wav";
	string SOUND_ZAP2 = "debris/beamstart15.wav";
	string SOUND_ZAP3 = "debris/zap1.wav";
	int SCAN_RANGE = 400;
	float DAMAGE_ADJ = 0.75f;
	string LIGHTNING_SPRITE = "lgtning.spr";

	// Variables (an unset .script variable reads as its own name)
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	float MY_BASE_DAMAGE = 0.0f;
	float DEATH_DELAY = 0.0f;
	string ACTIVE_SKILL = "ACTIVE_SKILL";
	bool DAMAGE_DELAY = false;
	bool ZAP_SOUND_DELAY = false;

	// Variables declared by included files, with the value they start with in this script
	ChainScanner()
	{
		AOE_RADIUS = "400";
	}

	// game_dynamically_created
	// PARAM1 = owner PARAM2 = Owner's lightning skill
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		// //dbg temp Got $get(PARAM1,name) PARAM2
		MY_OWNER = creatorValue1;
		OWNER_ISPLAYER = Text(IsPlayer(MY_OWNER));
		MY_BASE_DAMAGE = Float(creatorValue2);
		MY_BASE_DAMAGE *= DAMAGE_ADJ; // balancing
		DEATH_DELAY = 0.0f;

		// one would think this would always be spellcasting.lightning
		// but it's nice to have other options in case this is created by another item in the future
		ACTIVE_SKILL = "spellcasting.lightning";
		if (!damage.isEmpty())
			ACTIVE_SKILL = damage;

		OnDeathCount();
	}

	// fire_bolts
	void OnFireBolts()
	{
		// dbg temp firing bolts (DAMAGE_DELAY)
		if (DAMAGE_DELAY)
			return;
		DAMAGE_DELAY = true;
		CallEventDelayed(0.2f, "reset_damage_delay");

		// old method
		// dodamage $relpos(0,0,-32) SCAN_RANGE 0.0 100% 0 reflective target
		// getents any SCAN_RANGE //getents is being less dependable than dodamage here :\
		// if GET_COUNT > 0
		// setvard LOOP_COUNT 0
		// calleventloop GET_COUNT zap_buggers_loop
		OnAoeApplyeffectRad();
	}

	// reset_damage_delay
	// old old method
	// { zap_buggers_loop
	// add LOOP_COUNT 1
	// if ( LOOP_COUNT == 1 ) local CHECK_ENT GET_ENT1
	// if ( LOOP_COUNT == 2 ) local CHECK_ENT GET_ENT2
	// if ( LOOP_COUNT == 3 ) local CHECK_ENT GET_ENT3
	// if ( LOOP_COUNT == 4 ) local CHECK_ENT GET_ENT4
	// if ( LOOP_COUNT == 5 ) local CHECK_ENT GET_ENT5
	// if ( LOOP_COUNT == 6 ) local CHECK_ENT GET_ENT6
	// if ( LOOP_COUNT == 7 ) local CHECK_ENT GET_ENT7
	// if ( LOOP_COUNT == 8 ) local CHECK_ENT GET_ENT8
	// if ( LOOP_COUNT == 9 ) local CHECK_ENT GET_ENT9
	// if $get(CHECK_ENT,relationship,MY_OWNER) equals enemy
	// if ( OWNER_ISPLAYER )
	// {
	// if game.pvp == 0
	// if $get(CHECK_ENT,isplayer)
	// local EXIT_SUB 1
	// }
	// if !EXIT_SUB
	// clientevent new all_in_sight monsters/summon/chain_scanner_cl $get(MY_OWNER,index) $get(CHECK_ENT,index)
	// callexternal MY_OWNER send_damage $get(CHECK_ENT,id) "direct" MY_BASE_DAMAGE 100% MY_OWNER lightning
	// }
	void OnResetDamageDelay()
	{
		DAMAGE_DELAY = false;
	}

	// apply_aoe_effect
	// old method
	// { game_dodamage //1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Origin  4:  End Origin
	// if PARAM1
	// if $get(PARAM2,relationship,MY_OWNER) equals enemy
	// if ( OWNER_ISPLAYER )
	// {
	// if game.pvp < 1
	// if $get(PARAM2,isplayer)
	// local EXIT_SUB 1
	// }
	// if !EXIT_SUB
	// //effect beam point LIGHTNING_SPRITE 60 BEAM_START BEAM_END (96,96,255) 150 50 1.0
	// //clientevent new all_in_sight monsters/summon/chain_scanner_cl effects/sfx_lightning $get(PARAM2,origin) 0.5 1.0 $get(MY_OWNER,index) $get(PARAM2,index)
	// clientevent new all_in_sight monsters/summon/chain_scanner_cl $get(MY_OWNER,index) $get(PARAM2,index)
	// local MY_FINAL_DAMAGE MY_BASE_DAMAGE
	// multiply MY_FINAL_DAMAGE DAMAGE_ADJ //balancing
	// //callexternal MY_OWNER send_damage $get(PARAM2,id) "direct" MY_BASE_DAMAGE 100% MY_OWNER lightning
	// xdodamage $get(PARAM2,id) direct MY_BASE_DAMAGE 100 MY_OWNER MY_OWNER ACTIVE_SKILL lightning
	// //applyeffect PARAM2 effects/generic_damage MY_FINAL_DAMAGE MY_OWNER 0 lightning
	// }
	// new method via base_aoe
	// PARAM1 = target
	void OnApplyAoeEffect(CBaseEntity@ target = null)
	{
		Vector3 targOrg = OriginOf(target);
		Vector3 myOrg = OriginOf(MY_OWNER);
		string traceLine = LegacyFunction("get_traceline", myOrg, targOrg, "worldonly");
		if (traceLine != Text(targOrg))
			return;

		if (!ZAP_SOUND_DELAY)
		{
			ZAP_SOUND_DELAY = true;
			PlayRandomSound(0, 10, SOUND_ZAP1, SOUND_ZAP2, SOUND_ZAP3);
			CallEventDelayed(0.25f, "zap_sound_reset");
		}

		ClientEvent("new", "all_in_sight", "monsters/summon/chain_scanner_cl", IndexOf(MY_OWNER), IndexOf(target));
		float myFinalDamage = MY_BASE_DAMAGE * DAMAGE_ADJ; // balancing - that shoulda been done magic hand side
		DoDamageEx(@target, "direct", MY_BASE_DAMAGE, 100, MY_OWNER, MY_OWNER, ACTIVE_SKILL, "lightning");
	}

	// zap_sound_reset
	void OnZapSoundReset()
	{
		ZAP_SOUND_DELAY = false;
	}

	// heart_beat
	void OnHeartBeat()
	{
		SetOrigin(ENT_ME, OriginOf(MY_OWNER));

		// //dbg temp got heartbeat ( DEATH_DELAY )
		DEATH_DELAY = 0.0f;
	}

	// death_count
	void OnDeathCount()
	{
		CallEventDelayed(1.0f, "death_count");

		// dbg temp death beat ( DEATH_DELAY )
		DEATH_DELAY += 1.0f;
		if (!(DEATH_DELAY > 10.0f))
			return;
		// dbg temp Removing due to death delay
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "apply_aoe_effect") { OnApplyAoeEffect(EntityParam(params, 0)); return true; }
		if (name == "death_count") { OnDeathCount(); return true; }
		if (name == "fire_bolts") { OnFireBolts(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "heart_beat") { OnHeartBeat(); return true; }
		if (name == "reset_damage_delay") { OnResetDamageDelay(); return true; }
		if (name == "zap_sound_reset") { OnZapSoundReset(); return true; }
		return BaseAoeScript::DispatchEvent(name, params);
	}
}
