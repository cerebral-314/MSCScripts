#pragma context server

// Converted from items/axes_thunder11.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/axes_battleaxe.as"

[script "items/axes_thunder11"]
class AxesThunder11 : AxesBattleaxeScript
{
	// Variables (an unset .script variable reads as its own name)
	bool AXE_RESTORED = false;
	bool THROWING_AXE = false;

	// Variables declared by included files, with the value they start with in this script
	AxesThunder11()
	{
		BASE_LEVEL_REQ = "15";
		MELEE_DMG = 260;
		MODEL_VIEW_IDX = 3;
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		MODEL_BODY_OFS = "121";
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string AxesThunder11_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;
		if (RandomInt(1, 5) != 1)
			return result;
		float burnDamage = Divide(SkillOf(ENT_OWNER, "spellcasting.lightning"), 2.0f) + Random(1, 3);
		if (burnDamage < 5.0f)
			burnDamage = 5.0f;
		ApplyEffect(target, "effects/dot_lightning", 5, @EntityOf(ENT_OWNER), burnDamage, "axehandling");
		return result;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseItem_OnGameSpawn(playerRace, playerGender); // items/base_item
		AxesBaseTwohanded_OnGameSpawn(playerRace, playerGender); // items/axes_base_twohanded
		AxesBaseTwohanded_OnGameSpawn_2(playerRace, playerGender); // items/axes_base_twohanded

		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.noautoaim", 1);
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", 4096);
		SetLocal("reg.attack.dmg", 0);
		SetLocal("reg.attack.dmg.range", 0);
		SetLocal("reg.attack.dmg.type", "slash");
		SetLocal("reg.attack.energydrain", 2);
		SetLocal("reg.attack.stat", "axehandling");
		SetLocal("reg.attack.hitchance", "100%");
		SetLocal("reg.attack.priority", 3);
		SetLocal("reg.attack.delay.strike", 0.2f);
		SetLocal("reg.attack.delay.end", 0.9f);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "axethrow");
		SetLocal("reg.attack.noise", MELEE_NOISE);
		SetLocal("reg.attack.chargeamt", "300%");
		SetLocal("reg.attack.reqskill", 19);
		RegisterAttack();
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		AxesBattleaxe_OnWeaponSpawn(); // items/axes_battleaxe

		SetName("Thunderaxe");
		SetDescription("An axe enchanted with lightning magics");
		SetWeight(80);
		SetValue(800);
		SetHudSprite("hand", "121");
		SetHudSprite("trade", "121");
	}

	// melee_start
	void OnMeleeStart()
	{
		BaseMelee_OnMeleeStart(); // items/base_melee
		SetViewModel(MODEL_VIEW);
		SetModel(MODEL_WORLD);
		SetWorldModel(MODEL_WORLD);
		AXE_RESTORED = true;
	}

	// special_02
	void OnSpecial02()
	{
		DebugPrint("**************** special_02");
	}

	// axethrow_start
	// { game_deploy
	// local reg.effect.name	axe_stuff
	// local reg.effect.flags	nostack
	// local reg.effect.script	$currentscript
	// registereffect
	// }
	void OnAxethrowStart()
	{
		AXE_RESTORED = false;
		SetHand("undroppable");
		SetModel("none");
		SetWorldModel("none");
		SetViewModel("viewmodels/v_martialarts.mdl");
		PlayViewAnim(4);
		// dbg axethrow_start restoring axe in 3.0
		// callevent 3.0 restore_axe_cl //nvm, server can force this now
		SetViewModelProp(ENT_ME, "submodel", ScriptVarOf(ENT_OWNER, "PLR_HAND_SET"), 0);
		ServerPlaySound(0, 8, ScriptVarOf(ENT_OWNER, "PLR_SOUND_JAB2"));
	}

	// axethrow_strike
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnAxethrowStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		bool noEffect = false;

		PlayOwnerAnim("critical", "bow_release");
		// (always true here) if game.serverside

		Vector3 endTarget = endPos;
		Vector3 myView = ViewAnglesOf(ENT_OWNER);
		endTarget += RelativePosition(myView, Vector3(0, 128, 0));

		if (IsAlive(hitEntity))
		{
			if (IsPlayer(hitEntity) && (IsPvp() ? 1 : 0) < 1)
				noEffect = true;
			if (!noEffect)
			{
				DebugPrint("applying shock");
				float burnDamage = Divide(SkillOf(ENT_OWNER, "spellcasting.lightning"), 2.0f) + Random(1, 3);
				if (burnDamage < 5.0f)
					burnDamage = 5.0f;
				ApplyEffect(hitEntity, "effects/dot_lightning", 5, @EntityOf(ENT_OWNER), burnDamage, "axehandling");
			}
		}

		// if ( !$get(END_TARGET,isalive) )
		// {
		// local END_TARGET $get(ent_owner,origin)
		// local MY_VIEW $get(ent_owner,viewangles)
		// vectoradd END_TARGET $relpos(MY_VIEW,$vec(0,1024,0))
		// }
		// if ( $get(END_TARGET,isalive) ) local END_TARGET $get(END_TARGET,origin)
		float dmgAxe = SkillOf(ENT_OWNER, "axehandling");
		CreateNpc("monsters/summon/sorc_axe", OriginOf(ENT_OWNER), @EntityOf(ENT_OWNER), endTarget, dmgAxe, self, "axehandling");

		ApplyEffect(ENT_OWNER, "effects/effect_templock");
	}

	// restore_axe_cl
	void OnRestoreAxeCl()
	{
		SetViewModel(MODEL_VIEW);
		SetModel(MODEL_WORLD);
		SetWorldModel(MODEL_WORLD);
		if (AXE_RESTORED)
			return;
		PlayViewAnim(ANIM_LIFT1);
	}

	// catch_axe
	// called external from sorc_axe
	void OnCatchAxe()
	{
		DebugPrint("Caught Axe");
		// if ( game.clientside ) callevent restore_axe_cl //this is probably never client side as it is an external call
		// callexternal ent_owner ext_force_itemevent $get(ent_me,id) restore_axe_cl
		CallClientItemEvent(ENT_ME, "restore_axe_cl");
		SetViewModelProp(ENT_ME, "submodel", ScriptVarOf(ENT_OWNER, "PLR_HAND_SET"), MODEL_VIEW_IDX);

		SetViewModelProp(ENT_ME, "submodel", ScriptVarOf(ENT_OWNER, "PLR_HAND_SET"), MODEL_VIEW_IDX);

		CallExternal(ENT_OWNER, "ext_end_templock");
		THROWING_AXE = false;
		SetHand("both");
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return AxesThunder11_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons2.mdl");
		Precache("viewmodels/v_2haxes.mdl");
		Precache("viewmodels/v_martialarts.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "axethrow_start") { OnAxethrowStart(); return true; }
		if (name == "axethrow_strike") { OnAxethrowStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "catch_axe") { OnCatchAxe(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "restore_axe_cl") { OnRestoreAxeCl(); return true; }
		if (name == "special_02") { OnSpecial02(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return AxesBattleaxeScript::DispatchEvent(name, params);
	}
}
