#pragma context server

// Converted from items/armor_base_hybrid.script by msc_transpiler.
// Armor
// #scope server
// [shared] game_wear, register_loop, set_armor_body
// Requires:
// NEW_ARMOR_MODEL				usually armor/p_armorvest.mdl
// ARMOR_GROUP				Submodel group armor is in: JHLMV -1, as per usual
// ARMOR_BODY				Submodel of armor: should be JHLMV index -2
// BARMOR_TYPE				platemail|leather - affects display
// BARMOR_PROTECTION			Damage reduction%
// BARMOR_PROTECTION_AREA	eg."chest;arms;legs" - affects client display only
// ARMOR_TEXT				text to display when donning armor, eg. "You assemble the pheonix armor."
// ARMOR_STR_REQ				optional - strength requirement for armor

#include "runtime/ScriptEntity.as"

[script "items/armor_base_hybrid"]
class ArmorBaseHybrid : ScriptEntity
{
	// Constants
	string MODEL_HANDS = "misc/p_misc.mdl";
	string MODEL_WORLD = "misc/p_misc.mdl";
	string MODEL_VIEW = "none";
	int ARMOR_GROUP = 4;
	string NEW_ARMOR_MODEL = "armor/p_armorvest_new.mdl";
	bool EXPAR = true;

	// Variables (an unset .script variable reads as its own name)
	bool IN_WORLD = false;
	bool IS_REGISTERED = false;

	// game_takedamage
	// This doesn't work in player_main, so these affect all armors
	string ArmorBaseHybrid_OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		string result = "";
		// (always true here) if !IS_HELM

		if (!IsWorn(ENT_ME))
			return result;

		// dbg armor_base game_takedamage PARAM1 PARAM2 PARAM3
		if (Truthy(ScriptVarOf(ENT_OWNER, "PLR_SPIDER_PROT")) && RaceOf(attacker) == "spider")
		{
			float outDmg = damage * 0.0f;
			SetDamageInfo("hit", 1);
			SetDamageInfo("dmg", outDmg);
		}
		return result;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetWorldModel(MODEL_WORLD);
		SetHudSprite("hand", "armor");
		SetHudSprite("trade", "leather");
		if (!IsWorn(ENT_ME))
			SetModelBody(0, 10);
		if (IsWorn(ENT_ME))
		{
			float modelWear = 0.0f;
			modelWear += 1.0f;
			SetModelBody(ARMOR_GROUP, int(modelWear));
		}
		SetHand("any");

		// if ( !IS_HELM )
		// {
		// if ( $get_token(BARMOR_PROTECTION_AREA,0) equals legs ) setvard HIDE_LEGS 1
		// if ( $get_token(BARMOR_PROTECTION_AREA,0) equals head ) setvard HIDE_HEAD 1
		// if ( $get_token(BARMOR_PROTECTION_AREA,0) equals chest ) setvard HIDE_CHEST 1
		// if ( $get_token(BARMOR_PROTECTION_AREA,0) equals arms ) setvard HIDE_ARMS 1
		// if ( $get_token(BARMOR_PROTECTION_AREA,1) equals legs ) setvard HIDE_LEGS 1
		// if ( $get_token(BARMOR_PROTECTION_AREA,1) equals head ) setvard HIDE_HEAD 1
		// if ( $get_token(BARMOR_PROTECTION_AREA,1) equals chest ) setvard HIDE_CHEST 1
		// if ( $get_token(BARMOR_PROTECTION_AREA,1) equals arms ) setvard HIDE_ARMS 1
		// if ( $get_token(BARMOR_PROTECTION_AREA,2) equals legs ) setvard HIDE_LEGS 1
		// if ( $get_token(BARMOR_PROTECTION_AREA,2) equals head ) setvard HIDE_HEAD 1
		// if ( $get_token(BARMOR_PROTECTION_AREA,2) equals chest ) setvard HIDE_CHEST 1
		// if ( $get_token(BARMOR_PROTECTION_AREA,2) equals arms ) setvard HIDE_ARMS 1
		// if ( $get_token(BARMOR_PROTECTION_AREA,3) equals legs ) setvard HIDE_LEGS 1
		// if ( $get_token(BARMOR_PROTECTION_AREA,3) equals head ) setvard HIDE_HEAD 1
		// if ( $get_token(BARMOR_PROTECTION_AREA,3) equals chest ) setvard HIDE_CHEST 1
		// if ( $get_token(BARMOR_PROTECTION_AREA,3) equals arms ) setvard HIDE_ARMS 1
		// if ( $get_token(BARMOR_PROTECTION_AREA,4) equals legs ) setvard HIDE_LEGS 1
		// if ( $get_token(BARMOR_PROTECTION_AREA,4) equals head ) setvard HIDE_HEAD 1
		// if ( $get_token(BARMOR_PROTECTION_AREA,4) equals chest ) setvard HIDE_CHEST 1
		// if ( $get_token(BARMOR_PROTECTION_AREA,4) equals arms ) setvard HIDE_ARMS 1
		// }
		CallEventDelayed(1.0f, "armor_spec_effect"); // use this to apply any armor special effect (resistance,etc.)

		OnRegisterArmor();
	}

	// register_armor
	// Armor properties
	void OnRegisterArmor()
	{
		// Thothie - either something here isn't gettin accross, or tis broken on the code side
		// setvard ARMOR_TYPE			BARMOR_TYPE
		// setvard ARMOR_PROTECTION		BARMOR_PROTECTION
		// setvard ARMOR_PROTECTION_AREA		BARMOR_PROTECTION_AREA
		// setvard ARMOR_REPLACE_BODYPARTS	BARMOR_REPLACE_BODYPARTS
		// registerarmor
		// if ( STUN_PROTECTION isnot 'STUN_PROTECTION' )
		// {
		// if !EXPAR
		// callexternal $get(ent_owner,id) set_stun_prot STUN_PROTECTION
		// }
		CallEventDelayed(0.1f, "register_loop");
	}

	// game_deploy
	void OnGameDeploy()
	{
		IN_WORLD = false;

		SetViewModel(MODEL_VIEW);
		SetModel(MODEL_HANDS);

		float submodel = 16.0f + ItemHandIndex();
		SetModelBody(0, int(submodel));

		CallExternal(EntityOf(ENT_OWNER), "wearing_armor", 0);
		SetModel("null.mdl");
		OnClearArmorBody();
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		IN_WORLD = false;
		// if ( !IS_HELM ) setmodel null.mdl
		// if ( IS_HELM )
		// {
		// //dbg temp NEW_ARMOR_MODEL ( ARMOR_BODY )
		SetModel(NEW_ARMOR_MODEL);
		OnSetArmorBody();
		// }
		OwnerMessageClient("ARMOR_TEXT");
		OnRegisterArmor();
		OnSetArmorBody();

		if (!(StatOf(ENT_OWNER, "strength") < 0.0f))
			return;
		CallEventDelayed(0.1f, "failed_str_req_loop");
	}

	// game_fall
	void OnGameFall()
	{
		IN_WORLD = true;
		SetModelBody(0, 17);
		PlayAnim("package_floor_idle");
	}

	// game_remove
	void OnGameRemove()
	{
	}

	// register_loop
	void OnRegisterLoop()
	{
		// no work: inhand $get(ent_me,inhand)
		// yes work: game.item.inhand
		// neither of these works with this item: dbg handidx ( game.item.hand_index $get(ent_me,hand_index) )
		IS_REGISTERED = false;

		// if ( STUN_PROTECTION isnot 'STUN_PROTECTION' )
		// {
		// if game.serverside
		// if $get(ent_owner,isalive)
		// if STUN_PROTECTION != $get(ent_owner,scriptvar,IMMUNE_STUN)
		// callexternal $get(ent_owner,id) set_stun_prot STUN_PROTECTION
		// }
		// if ( REG_SPECIAL_EFFECT )
		// {
		// if game.serverside
		// callevent 0.5 armor_spec_effect	//register other special effects here
		// //for element resistances see uses of base_element_resist
		// }
		if (IsAlive(ENT_OWNER) && !IN_WORLD)
		{
			SetModel(NEW_ARMOR_MODEL);
			// if game.serverside
			OnSetArmorBody();
		}

		CallEventDelayed(10.7f, "register_loop");
	}

	// game_drop
	void OnGameDrop()
	{
		SetModel("misc/p_misc.mdl");
		SetModelBody(0, 16);
	}

	// set_armor_body
	void OnSetArmorBody()
	{
		DebugPrint("set_armor_body NEW_ARMOR_OFS");
		SetModelBody(0, 0);
		CallExternal(ENT_OWNER, "ext_setbodytype", "BARMOR_TYPE");
	}

	// armor_spec_effect
	void OnArmorSpecEffect()
	{
	}

	string OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "") { return ArmorBaseHybrid_OnGameTakedamage(attacker, inflictor, damage, damageType); } // game_takedamage

	// failed_str_req_loop
	void OnFailedStrReqLoop()
	{
		if (!IsWorn(ENT_ME))
			return;
		if (!(StatOf(ENT_OWNER, "strength") < 0.0f))
			return;
		CallEventDelayed(10.0f, "failed_str_req_loop");
		string alrtStr = "You are too weak to move freely in this armor. (Min Strength ARMOR_STR_REQ)";
		InfoMessage(ENT_OWNER, "Insufficient Strength for Armor", alrtStr);
		ApplyEffect(ENT_OWNER, "effects/effect_slow", 10.0f, "50%", self); // effects/speed 10.0 75% 0.5
	}

	// ext_activate_items
	void OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		if (playerId !is EntityOf(ENT_OWNER))
			return;
		if (!(StatOf(ENT_OWNER, "strength") < 0.0f))
			return;
		CallEventDelayed(0.1f, "failed_str_req_loop");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnClearArmorBody() {} // clear_armor_body

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/p_misc.mdl");
		Precache("null.mdl");
		Precache("armor/p_armorvest_new.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "armor_spec_effect") { OnArmorSpecEffect(); return true; }
		if (name == "ext_activate_items") { OnExtActivateItems(EntityParam(params, 0)); return true; }
		if (name == "failed_str_req_loop") { OnFailedStrReqLoop(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_drop") { OnGameDrop(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_remove") { OnGameRemove(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_takedamage") { Return(OnGameTakedamage(EntityParam(params, 0), EntityParam(params, 1), Float(Param(params, 2)), Param(params, 3))); return true; }
		if (name == "game_wear") { OnGameWear(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "register_armor") { OnRegisterArmor(); return true; }
		if (name == "register_loop") { OnRegisterLoop(); return true; }
		if (name == "set_armor_body") { OnSetArmorBody(); return true; }
		return false;
	}
}
