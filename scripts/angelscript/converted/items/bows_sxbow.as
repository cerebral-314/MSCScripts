#pragma context server

// Converted from items/bows_sxbow.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_item_extras.as"

[script "items/bows_sxbow"]
class BowsSxbow : BaseItemExtrasScript
{
	// Constants
	bool ITEM_NEVER_DELETE = true;
	string BASE_LEVEL_REQ = "35";
	string RANGED_STAT = "archery";
	float RANGED_DMG_MULTI = 1.5f;
	string MODEL_VIEW = "viewmodels/v_steambow.mdl";
	string MODEL_HANDS = "weapons/p_weapons3.mdl";
	string MODEL_WORLD = "weapons/p_weapons3.mdl";
	string MODEL_BODY_OFS = "80";
	string VMODEL_FILE = "viewmodels/v_steambow.mdl";
	string PMODEL_FILE = "weapons/p_weapons3.mdl";
	int PMODEL_IDX_HANDS = 80;
	int PMODEL_IDX_FLOOR = 82;
	bool VANIM_IDLE0 = true;
	int VANIM_FIRE = 7;
	int VANIM_RELOAD1 = 14;
	int VANIM_RELOAD2 = 15;
	int VANIM_RL_LOWER = 16;
	int VANIM_RL_LOADBOLT = 17;
	int VANIM_RL_PRIME = 20;
	int VANIM_DRAW = 0;
	string WANIM_HAND = "standard_idle";
	string WANIM_FLOOR = "standard_floor_idle";
	float BOLT_LOAD_TIME = 0.56f;
	float RELOAD_LOWER_TIME = 0.8f;
	float RELOAD_RAISE_TIME = 1.83f;
	float RELOAD_CANCEL_RAISE_TIME = 1.83f;

	// Variables (an unset .script variable reads as its own name)
	string WEAPON_PRIMARY_SKILL = "WEAPON_PRIMARY_SKILL";
	float BOW_CHAMBER = 0.0f;
	bool BOW_RELOADING = false;
	float NEXT_BOLT = 0.0f;
	float BOLT_ANIM = 0.0f;
	float HITSCAN_DMG_MULTI = 0.0f;
	float NEXT_ATTACK = 0.0f;
	float RAISE_END = 0.0f;
	bool UNDER_SKILLED = false;

	// unnamed block (first think)
	void BowsSxbow_FirstThink()
	{
		WEAPON_PRIMARY_SKILL = RANGED_STAT;

		BOW_CHAMBER = 0.0f;
		BOW_RELOADING = false;
		NEXT_BOLT = 0.0f;
		BOLT_ANIM = 0.0f;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		SetName("Steam Crossbow");
		SetDescription("A strange dwarven contraption");
		SetWeight(50);
		SetValue(4000);

		// wearable 0
		SetAnimExtension("bow");
		SetWorldModel(MODEL_WORLD);
		SetViewModel(MODEL_VIEW);
		SetPlayerModel(MODEL_HANDS);
		SetHand("both");
		SetHudSprite("trade", "147");

		OnRegisterAttack();
	}

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras

		SetModelBody(0, PMODEL_IDX_FLOOR);
		PlayAnim(WANIM_FLOOR);

		OnWeaponFall(); // compatibility
	}

	// game_deploy
	// ============== from polearms
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras

		OnItemDeploy(); // compatibility

		SetViewModel(VMODEL_FILE);
		SetModel(PMODEL_FILE);
		SetWorldModel(PMODEL_FILE);
		SetModelBody(0, PMODEL_IDX_HANDS);

		SetAnimExtension("xbow");
		PlayViewAnim(VANIM_DRAW);
		PlayAnim(WANIM_HAND);

		OnCheckSkill();

		BOW_RELOADING = false;
		NEXT_BOLT = 0.0f;
		SetViewModelProp(ENT_ME, "animspeed", 1);

		if (BOW_CHAMBER > 0.0f)
			CallEventDelayed(0.1f, "redeploy_idle");
		// so I don't prematurely fire
		NEXT_ATTACK = GameTime() + 0.6f;
	}

	// game_drop
	void OnGameDrop()
	{
		BaseItemExtras_OnGameDrop(); // items/base_item_extras

		OnItemDrop(); // compatibility
	}

	// register_attack
	void OnRegisterAttack()
	{
		SetLocal("reg.attack.type", "charge-throw-projectile");
		SetLocal("reg.attack.keys", "+attack1");
		SetLocal("reg.attack.hold_min&max", "0;0");
		SetLocal("reg.attack.noautoaim", 1);
		SetLocal("reg.attack.dmg.type", "pierce");
		SetLocal("reg.attack.range", 1000);
		SetLocal("reg.attack.energydrain", 0);
		SetLocal("reg.attack.stat", "archery");
		SetLocal("reg.attack.COF", 0);
		SetLocal("reg.attack.projectile", "bolt");
		SetLocal("reg.attack.priority", 10);
		SetLocal("reg.attack.delay.strike", 0.0f);
		SetLocal("reg.attack.delay.end", 0.2f); // reload time, I think
		SetLocal("reg.attack.ofs.startpos", Vector3(10, 10, -15));
		SetLocal("reg.attack.ofs.aimang", Vector3(8, -4, 0));
		SetLocal("reg.attack.callback", "ranged");
		SetLocal("reg.attack.dmg.multi", RANGED_DMG_MULTI); // this has no affect on hitscan arrows, thus we pass to setvard HITSCAN_DMG_MULTI which they read from
		SetLocal("reg.attack.noise", 10);

		HITSCAN_DMG_MULTI = RANGED_DMG_MULTI;

		RegisterAttack();
	}

	// ranged_start
	void OnRangedStart()
	{
		CancelAttack();
	}

	// game_attack1_down
	void OnGameAttack1Down()
	{
		int rndLock = 0;
		bool exitSub = false;

		if (ScriptVarOf(ENT_OWNER, "PLR_ACTIVE_WEAPON") != EntityId(self))
			return;

		// delay a sec if we just selected an arrow so ammo type can change
		float arrowMenuTime = Float(ScriptVarOf(ENT_OWNER, "PLR_ARROW_MENU"));
		if (arrowMenuTime > 0.0f)
			arrowMenuTime += 1.0f;
		if (GameTime() < arrowMenuTime)
			NEXT_ATTACK = arrowMenuTime;

		// got bolts in it, stop reloading and shoot
		if (BOW_RELOADING && BOW_CHAMBER < 6.0f)
			OnReloadCancel();

		if (!(GameTime() > NEXT_ATTACK))
			return;

		if (!CanAttack(ENT_OWNER))
			return;

		if (BOW_RELOADING)
			return;

		if (BOW_CHAMBER < 6.0f)
		{
			int cof = 0;
			int speed = 1000;

			if (UNDER_SKILLED)
			{
				cof = 20;
				speed = 300;

				rndLock = RandomInt(1, 3);
			}

			if (rndLock == 1 && BOW_CHAMBER < 6.0f)
			{
				PlaySound(0, 10, "weapons/357_reload1.wav");
				PlayerMessageDark(ENT_OWNER, "Your lack of proficiency causes you to jam the weapon.");
				NEXT_ATTACK = GameTime() + 4.0f;
				exitSub = true;
			}
			if (!exitSub)
			{
				BOW_CHAMBER += 1.0f;
				float fireAnim = BOW_CHAMBER + VANIM_FIRE;
				PlayItemViewAnim(ENT_ME, int(fireAnim));

				// local PLR_ARROW $get(ent_owner,chosenarrow)
				// if ( PLR_ARROW equals unset )
				// {
				// clientcmd ent_owner "quickslot arrow"
				// local PLR_ARROW $get(ent_owner,chosenarrow)
				// if PLR_ARROW equals unset
				// local GENERIC_ARRROW 1
				// local PLR_ARROW proj_bolt_generic
				// }
				string plrArrow = "proj_bolt_generic";
				string ammoId = ScriptVarOf(ENT_OWNER, "PLR_ARROW_ID");
				string ammoName = ItemNameOf(ammoId);
				float ammoLeft = QuantityOf(ammoId);
				if (OwnerOf(ammoId) !is EntityOf(ENT_OWNER))
					ammoName = "none";

				// selection is lost on map change, use the last bolt type picked and saved in player_main game_arrowmenu - Dravus
				if (!StartsWith(ammoName, "proj_bolt"))
				{
					string lastBolt = GetQuestData(ENT_OWNER, "sxbow_bolt");
					if (StartsWith(lastBolt, "proj_bolt"))
					{
						string foundId = LegacyFunction("item_exists", ENT_OWNER, lastBolt, "id");
						if (foundId != "0")
						{
							ammoId = foundId;
							ammoName = lastBolt;
							ammoLeft = QuantityOf(ammoId);
						}
					}
				}

				if (StartsWith(ammoName, "proj_bolt"))
				{
					if (ammoName == "proj_bolt_generic")
					{
						plrArrow = "proj_bolt_generic";
					}
					else if (ammoLeft > 0.0f)
					{
						plrArrow = ammoName;
						ammoLeft -= 1.0f;
						if (ammoLeft > 0.0f)
						{
							LegacyCommand("setquantity", ammoId, ammoLeft);
						}
						else
						{
							string gone = LegacyFunction("item_exists", ENT_OWNER, ammoName, "remove");
						}
					}
				}

				DebugPrint("arrowtype: " + plrArrow);

				// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
				CallExternal(ENT_OWNER, "ext_tossprojectile", plrArrow, "view", "none", speed, 0, cof, "archery");

				PlayOwnerAnim("hold", "xbow_idle", "global.anim.combatwalk");

				PlaySound(0, 10, "weapons/xbow_reload1.wav");
				PlaySound(0, 10, "weapons/bow/crossbow.wav");
			}
		}

		DebugPrint("chamber " + Text(BOW_CHAMBER));

		if (BOW_CHAMBER >= 6.0f)
		{
			OnDoReload();
		}
		else
		{
			CallEventDelayed(0.5f, "do_idle");
			NEXT_ATTACK = GameTime() + 0.6f;
		}
	}

	// game_+attack2
	void OnGamePressAttack2()
	{
		if (!CanAttack(ENT_OWNER))
			return;
		if (ScriptVarOf(ENT_OWNER, "PLR_ACTIVE_WEAPON") != EntityId(self))
			return;
		if (!(GameTime() > NEXT_ATTACK))
			return;
		if (BOW_CHAMBER == 0.0f)
			OnShowChamber();
		if (!(BOW_CHAMBER > 0.0f))
			return;
		OnDoReload();
	}

	// do_reload
	void OnDoReload()
	{
		if (ScriptVarOf(ENT_OWNER, "PLR_ACTIVE_WEAPON") != EntityId(self))
			return;
		if (BOW_RELOADING)
			return;
		if (!(BOW_CHAMBER > 0.0f))
			return;

		BOW_RELOADING = true;

		PlayOwnerAnim("once", "xbow_reload", "global.anim.combatwalk");
		PlaySound(0, 10, "weapons/357_reload1.wav");

		SetViewModelProp(ENT_ME, "animspeed", Divide(0.68f, RELOAD_LOWER_TIME));
		PlayItemViewAnim(ENT_ME, VANIM_RL_LOWER);

		NEXT_BOLT = GameTime() + RELOAD_LOWER_TIME - 0.05f;
		CallEventDelayed(RELOAD_LOWER_TIME, "reload_bolt");
	}

	// reload_bolt
	void OnReloadBolt()
	{
		if (!BOW_RELOADING)
			return;
		if (!(GameTime() >= NEXT_BOLT))
			return;
		if (ScriptVarOf(ENT_OWNER, "PLR_ACTIVE_WEAPON") != EntityId(self))
			return;

		if (BOW_CHAMBER <= 1.0f)
		{
			OnDoReload2();
			return;
		}

		float boltIdx = VANIM_RL_LOADBOLT + BOLT_ANIM;
		BOLT_ANIM += 1.0f;
		if (BOLT_ANIM > 1.0f)
			BOLT_ANIM = 0.0f;
		SetViewModelProp(ENT_ME, "animspeed", Divide(0.62f, BOLT_LOAD_TIME));
		PlayItemViewAnim(ENT_ME, int(boltIdx));

		NEXT_BOLT = GameTime() + BOLT_LOAD_TIME - 0.05f;
		CallEventDelayed(BOLT_LOAD_TIME, "reload_bolt2");
	}

	// reload_bolt2
	void OnReloadBolt2()
	{
		if (!BOW_RELOADING)
			return;
		if (!(GameTime() >= NEXT_BOLT))
			return;
		if (ScriptVarOf(ENT_OWNER, "PLR_ACTIVE_WEAPON") != EntityId(self))
			return;

		BOW_CHAMBER -= 1.0f;
		DebugPrint("bolt loaded " + Text(BOW_CHAMBER));

		if (BOW_CHAMBER > 0.0f)
			OnReloadBolt();
		else
			OnDoReload2();
	}

	// do_reload2
	void OnDoReload2()
	{
		BOW_CHAMBER = 0.0f;
		BOW_RELOADING = false;
		OnDoRaise(RELOAD_RAISE_TIME);
		CallEventDelayed(RELOAD_RAISE_TIME, "pilot_light");
	}

	// reload_cancel
	void OnReloadCancel()
	{
		if (BOW_CHAMBER > 0.0f)
			BOW_CHAMBER -= 1.0f;
		BOW_RELOADING = false;
		NEXT_BOLT = 0.0f;
		OnDoRaise(RELOAD_CANCEL_RAISE_TIME);
		CallEventDelayed(RELOAD_CANCEL_RAISE_TIME, "pilot_light");
	}

	// do_raise
	// PARAM1 = time
	void OnDoRaise(float raiseTime = 0.0f)
	{
		SetViewModelProp(ENT_ME, "animspeed", Divide(1.83f, raiseTime));
		// prime anim for however many bolts are in
		float primeIdx = VANIM_RL_PRIME + 5.0f - BOW_CHAMBER;
		PlayItemViewAnim(ENT_ME, int(primeIdx));

		NEXT_ATTACK = GameTime() + raiseTime;

		RAISE_END = NEXT_ATTACK - 0.05f;
		CallEventDelayed(raiseTime, "raise_done");
	}

	// raise_done
	void OnRaiseDone()
	{
		if (BOW_RELOADING)
			return;
		if (!(GameTime() >= RAISE_END))
			return;

		SetViewModelProp(ENT_ME, "animspeed", 1);
		OnShowChamber();
	}

	// show_chamber
	void OnShowChamber()
	{
		float idleAnim = BOW_CHAMBER + (VANIM_IDLE0 ? 1.0f : 0.0f);
		PlayItemViewAnim(ENT_ME, int(idleAnim));
	}

	// pilot_light
	void OnPilotLight()
	{
		if (ScriptVarOf(ENT_OWNER, "PLR_ACTIVE_WEAPON") != EntityId(self))
			return;

		ServerPlaySound(0, 10, "weapons/bow/steam.wav");
	}

	// do_idle
	void OnDoIdle()
	{
		if (ScriptVarOf(ENT_OWNER, "PLR_ACTIVE_WEAPON") != EntityId(self))
			return;
		if (BOW_RELOADING)
			return;
		OnShowChamber();
	}

	// redeploy_idle
	// case we slotted this during reload
	void OnRedeployIdle()
	{
		OnShowChamber();
	}

	// game_show
	// { arrow_check
	// local PLR_ARROW $get(ent_owner,chosenarrow)
	// if ( PLR_ARROW equals unset ) clientcmd ent_owner "quickslot arrow"
	// }
	void OnGameShow(string raceType = "", string genderType = "", string debugFlag = "")
	{
		SetModel(PMODEL_FILE);
		SetWorldModel(PMODEL_FILE);
		SetModelBody(0, PMODEL_IDX_HANDS);
	}

	// game_switchhands
	void OnGameSwitchhands()
	{
		PlayViewAnim(0);

		OnItemSwitchhands(); // compatibility
	}

	// check_skill
	void OnCheckSkill()
	{
		if (!Truthy(ScriptVarOf(ENT_OWNER, "GAVE_MAP_INTRO")))
			return;

		string findMeleeStat = "skill." + RANGED_STAT;
		// dbg game_deploy $get(ent_owner,FIND_MELEE_STAT) FIND_MELEE_STAT BASE_LEVEL_REQ
		if (Float(GetProp(ENT_OWNER, findMeleeStat)) < Float(BASE_LEVEL_REQ))
		{
			PlayerMessageDark(ENT_OWNER, "You lack the skill to properly wield this weapon!");
			string outStr = "You lack the proficiency to wield this weapon. ( requires: " + RANGED_STAT;
			outStr += " proficiency " + BASE_LEVEL_REQ + " )";
			InfoMessage(ENT_OWNER, "Insufficient Skill", outStr);
			UNDER_SKILLED = true;
		}
		else
		{
			if (UNDER_SKILLED)
				HITSCAN_DMG_MULTI = RANGED_DMG_MULTI;
			UNDER_SKILLED = false;
		}

		if (!UNDER_SKILLED)
			HITSCAN_DMG_MULTI = RANGED_DMG_MULTI;
		else
			HITSCAN_DMG_MULTI = 0.1f;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnBoltLoadTime() {} // BOLT_LOAD_TIME
	void OnReloadCancelRaiseTime() {} // RELOAD_CANCEL_RAISE_TIME
	void OnReloadLowerTime() {} // RELOAD_LOWER_TIME
	void OnReloadRaiseTime() {} // RELOAD_RAISE_TIME
	void OnItemDeploy() {} // item_deploy
	void OnItemDrop() {} // item_drop
	void OnItemSwitchhands() {} // item_switchhands
	void OnWeaponFall() {} // weapon_fall

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons3.mdl");
		Precache("viewmodels/v_steambow.mdl");
		Precache("weapons/bow/steam.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BowsSxbow_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "check_skill") { OnCheckSkill(); return true; }
		if (name == "do_idle") { OnDoIdle(); return true; }
		if (name == "do_raise") { OnDoRaise(Float(Param(params, 0))); return true; }
		if (name == "do_reload") { OnDoReload(); return true; }
		if (name == "do_reload2") { OnDoReload2(); return true; }
		if (name == "game_+attack2") { OnGamePressAttack2(); return true; }
		if (name == "game_attack1_down") { OnGameAttack1Down(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_drop") { OnGameDrop(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_show") { OnGameShow(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_switchhands") { OnGameSwitchhands(); return true; }
		if (name == "pilot_light") { OnPilotLight(); return true; }
		if (name == "raise_done") { OnRaiseDone(); return true; }
		if (name == "ranged_start") { OnRangedStart(); return true; }
		if (name == "redeploy_idle") { OnRedeployIdle(); return true; }
		if (name == "register_attack") { OnRegisterAttack(); return true; }
		if (name == "reload_bolt") { OnReloadBolt(); return true; }
		if (name == "reload_bolt2") { OnReloadBolt2(); return true; }
		if (name == "reload_cancel") { OnReloadCancel(); return true; }
		if (name == "show_chamber") { OnShowChamber(); return true; }
		return BaseItemExtrasScript::DispatchEvent(name, params);
	}
}
