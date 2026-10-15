#pragma context server

// Converted from monsters/summon/base_aoe.script by msc_transpiler.
// About 80% of the summon spells just apply an affect to an area, half do it badly, thus this base
// - assumes MY_OWNER is person to credit damage with
// - hope to have everything on this system, eventually, for no concentrating on player events

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseAoe
{
	// Constants
	string AOE_RADIUS = "256";
	int AOE_DMG_FREQ = 0;
	float AOE_DMG = 10.0f;
	string AOE_DMG_TYPE = "fire";
	float AOE_FREQ = 0.0f;
	string AOE_FRIEND_FOE = "enemy";

	// Variables (an unset .script variable reads as its own name)
	int GAME_PVP = 0;
	bool IS_ACTIVE = false;
	bool AOE_ISPLAYER = false;
	string AOE_TOKENS = "AOE_TOKENS";

	// game_spawn
	void BaseAoe_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		// dbg aoe:game_spawn
		GAME_PVP = (IsPvp() ? 1 : 0);
		IS_ACTIVE = true; // some use this, make sure it does no conflict with function to set it here
		if (AOE_FREQ > 0.0f)
			CallEventDelayed(0.1f, "aoe_scan_loop");
		if (AOE_DMG_FREQ > 0)
			CallEventDelayed(0.1f, "aoe_dmg_loop");
		CallEventDelayed(0.1f, "get_skill");
	}

	// get_skill
	void BaseAoe_OnGetSkill()
	{
		AOE_ISPLAYER = IsPlayer(MY_OWNER);
		// dbg aoe:get_skill
		// if active skill still not defined this far in, assume the active item summoned me
		if (GetVar("ACTIVE_SKILL") == "ACTIVE_SKILL") {}
	}

	// aoe_scan_loop
	void BaseAoe_OnAoeScanLoop()
	{
		// dbg aoe:aoe_scan_loop IS_ACTIVE AOE_FREQ
		if (!IS_ACTIVE)
			return;
		CallEventDelayed(AOE_FREQ, "aoe_scan_loop");
		OnAoeApplyeffectRad();
	}

	// aoe_dmg_loop
	void BaseAoe_OnAoeDmgLoop()
	{
		if (!IS_ACTIVE)
			return;
		CallEventDelayed(AOE_DMG_FREQ, "aoe_dmg_loop");
		OnAoeDodamageRad();
	}

	// aoe_applyeffect_rad
	void BaseAoe_OnAoeApplyeffectRad()
	{
		AOE_TOKENS = "";
		Vector3 aoeScanPos = OriginOf(ENT_ME);
		aoeScanPos.z += 32.0f;
		AOE_TOKENS = LegacyFunction("get_tsphere", "any", AOE_RADIUS, aoeScanPos);
		if (AOE_TOKENS == "none")
			return;
		int nTokens = GetTokenCount(AOE_TOKENS);
		// dbg aoe:aoe_applyeffect_rad ( N_TOKENS ) AOE_TOKENS
		if (!(nTokens > 0))
			return;
		if (AOE_FRIEND_FOE == "enemy")
		{
			for (int i = 0; i < nTokens; i++)
			{
				loopIteration = i;
				OnAoeApplyLoop();
			}
		}
		if (AOE_FRIEND_FOE == "ally")
		{
			for (int i = 0; i < nTokens; i++)
			{
				loopIteration = i;
				OnAoeApplyeffectRadCheckFriendly();
			}
		}
	}

	// aoe_apply_loop
	void BaseAoe_OnAoeApplyLoop()
	{
		CBaseEntity@ curTarget = FindEntity(GetToken(AOE_TOKENS, loopIteration));
		// if $get(MY_OWNER,relationship,CUR_TARGET) equals enemy
		// if ( AOE_ISPLAYER )
		// {
		// if !GAME_PVP
		// if $get(CUR_TARGET,isplayer)
		// local EXIT_SUB 1
		// }
		// if !EXIT_SUB
		if (!IsAlive(curTarget))
			return;
		if (!Truthy(LegacyFunction("can_damage", @curTarget, MY_OWNER)))
			return;
		OnApplyAoeEffect(curTarget);
	}

	// aoe_applyeffect_rad_check_friendly
	void BaseAoe_OnAoeApplyeffectRadCheckFriendly()
	{
		bool doEffect = false;
		CBaseEntity@ curTarget = FindEntity(GetToken(AOE_TOKENS, loopIteration));
		if (RelationshipOf(MY_OWNER, @curTarget) == "ally")
			doEffect = true;
		if (AOE_ISPLAYER && IsPlayer(curTarget))
			doEffect = true;
		if (!doEffect)
			return;
		OnApplyAoeEffect(curTarget);
	}

	// aoe_dodamage_rad
	void BaseAoe_OnAoeDodamageRad()
	{
		DoDamageEx(RelativePosition(Vector3(0, 0, 0)), AOE_RADIUS, AOE_DMG, 0, MY_OWNER, MY_OWNER, GetVar("ACTIVE_SKILL"), AOE_DMG_TYPE);
	}

	// aoe_end
	void BaseAoe_OnAoeEnd()
	{
		IS_ACTIVE = false;
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BaseAoe_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnGetSkill() { BaseAoe_OnGetSkill(); } // get_skill
	void OnAoeScanLoop() { BaseAoe_OnAoeScanLoop(); } // aoe_scan_loop
	void OnAoeDmgLoop() { BaseAoe_OnAoeDmgLoop(); } // aoe_dmg_loop
	void OnAoeApplyeffectRad() { BaseAoe_OnAoeApplyeffectRad(); } // aoe_applyeffect_rad
	void OnAoeApplyLoop() { BaseAoe_OnAoeApplyLoop(); } // aoe_apply_loop
	void OnAoeApplyeffectRadCheckFriendly() { BaseAoe_OnAoeApplyeffectRadCheckFriendly(); } // aoe_applyeffect_rad_check_friendly
	void OnAoeDodamageRad() { BaseAoe_OnAoeDodamageRad(); } // aoe_dodamage_rad
	void OnAoeEnd() { BaseAoe_OnAoeEnd(); } // aoe_end
	void OnAoeDmgFreq() {} // AOE_DMG_FREQ
	void OnAoeFreq() {} // AOE_FREQ
	void OnApplyAoeEffect(CBaseEntity@ target = null) {} // apply_aoe_effect

	// This file's events and timers by their .script names
	bool BaseAoe_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "aoe_apply_loop") { OnAoeApplyLoop(); return true; }
		if (name == "aoe_applyeffect_rad") { OnAoeApplyeffectRad(); return true; }
		if (name == "aoe_applyeffect_rad_check_friendly") { OnAoeApplyeffectRadCheckFriendly(); return true; }
		if (name == "aoe_dmg_loop") { OnAoeDmgLoop(); return true; }
		if (name == "aoe_dodamage_rad") { OnAoeDodamageRad(); return true; }
		if (name == "aoe_end") { OnAoeEnd(); return true; }
		if (name == "aoe_scan_loop") { OnAoeScanLoop(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "get_skill") { OnGetSkill(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/summon/base_aoe"]
shared class BaseAoeScript : ScriptEntity, BaseAoe
{
	// Variables every script that includes this file declares
	string MY_OWNER = "MY_OWNER";

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseAoe_DispatchEvent(name, params);
	}
}
