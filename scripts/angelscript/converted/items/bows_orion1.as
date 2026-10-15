#pragma context server

// Converted from items/bows_orion1.script by msc_transpiler.
// Orion Bow by Thothie (non-h4x0r weapon)
// Drains mana, damage increases longer held

#include "runtime/ScriptEntity.as"
#include "converted/items/bows_base.as"

[script "items/bows_orion1"]
class BowsOrion1 : BowsBaseScript
{
	// Constants
	int MODEL_VIEW_IDX = 3;
	string BASE_LEVEL_REQ = "15";
	string BOLT_SPRITE = "nhth1.spr";
	bool CUSTOM_ATTACK = true;
	int MP_DRAIN = 4;
	float CHARGE_RATE = 0.3f;
	string DMG_MULTI = "10";
	bool NOT_WEARABLE = true;

	// Variables (an unset .script variable reads as its own name)
	float BALL_SIZE = 0.0f;
	float NEXT_ATTACK = 0.0f;
	bool AM_CHARGING = false;
	float BALL_DMG = 0.0f;
	bool TALLY_ACTIVE = false;
	float NEXT_CHARGE = 0.0f;
	bool BALOON_ON = false;
	string BOW_CL_IDX = "BOW_CL_IDX";
	bool MAX_LEVEL = false;

	// Variables declared by included files, with the value they start with in this script
	BowsOrion1()
	{
		MODEL_VIEW = "viewmodels/v_bows.mdl";
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		MODEL_WEAR = "weapons/p_weapons2.mdl";
		SOUND_SHOOT = "weapons/bow/bow.wav";
		ITEM_NAME = "longbow";
		ANIM_PREFIX = "longbow";
		MODEL_BODY_OFS = "48";
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("items/proj_mana2"); // <- not technically an item anymore
	}

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseWeapon_OnGameFall(); // items/base_weapon
		OnResetAtk();
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseItem_OnGameDeploy(); // items/base_item
		BaseWeapon_OnGameDeploy(); // items/base_weapon
		BaseWeapon_OnGameDeploy_2(); // items/base_weapon
		BaseRanged_OnGameDeploy(); // items/base_ranged
		NEXT_ATTACK = GameTime() + 1.0f;
	}

	// game_putinpack
	void OnGamePutinpack()
	{
		BaseItemExtras_OnGamePutinpack(); // items/base_item_extras
		OnCancelAttack();
	}

	// bow_spawn
	void OnBowSpawn()
	{
		SetName("Orion Bow");
		SetDescription("This enchanted bow fires spheres of pure mana");
		SetWeight(30);
		SetValue(1000);
		SetHudSprite("trade", "108");

		BALL_SIZE = 0.0f;

		OnCustomRegister();
	}

	// custom_register
	void OnCustomRegister()
	{
		SetLocal("reg.attack.type", "charge-throw-projectile");
		SetLocal("reg.attack.keys", "+attack1");
		SetLocal("reg.attack.hold_min&max", "0.1;0.1");
		SetLocal("reg.attack.dmg.type", "magic");
		SetLocal("reg.attack.range", 200);
		SetLocal("reg.attack.energydrain", 1);
		SetLocal("reg.attack.stat", "archery");
		SetLocal("reg.attack.COF", 0);
		SetLocal("reg.attack.projectile", "none");
		SetLocal("reg.attack.priority", 0);
		SetLocal("reg.attack.delay.strike", 0);
		SetLocal("reg.attack.delay.end", 0);
		SetLocal("reg.attack.ofs.startpos", "RANGED_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", RANGED_AIMANGLE);
		SetLocal("reg.attack.ammodrain", 0);
		SetLocal("reg.attack.callback", "ranged");
		SetLocal("reg.attack.noise", 1000);
		SetLocal("reg.attack.reqskill", BASE_LEVEL_REQ);
	}

	// game_attack1_down
	void OnGameAttack1Down()
	{
		if (!(GameTime() > NEXT_ATTACK))
			return;
		NEXT_ATTACK = GameTime() + 0.75f;
		if (!AM_CHARGING)
		{
			if (ManaOf(ENT_OWNER) > MP_DRAIN)
			{
				PlayViewAnim(Int(ANIM_FIRE));
				if (CanAttack(ENT_OWNER))
				{
					AM_CHARGING = true;
					// (always true here) if game.serverside
					BALL_SIZE = 0.0f;
					BALL_DMG = 0.0f;
					PlayOwnerAnim("critical", "bow_pull", "global.anim.combatwalk");
					if (!TALLY_ACTIVE)
					{
						TALLY_ACTIVE = true;
						OnTallyStretch();
					}
				}
			}
			else
			{
				PlayerMessageDark(ENT_OWNER, "You lack the mana to start charging a mana ball.");
				CancelAttack();
			}
		}
	}

	// tally_stretch
	void OnTallyStretch()
	{
		bool exitSub = false;

		if (!TALLY_ACTIVE)
			return;
		CallEventDelayed(0.1f, "tally_stretch");

		if (!AM_CHARGING)
			return;

		if (!(GameTime() > NEXT_CHARGE))
			return;
		NEXT_CHARGE = GameTime() + CHARGE_RATE;

		BALL_DMG = BALL_SIZE * Float(DMG_MULTI);

		if (MAX_LEVEL)
			return;
		BALL_SIZE += 1.0f;

		if (!BALOON_ON)
		{
			if (BALL_SIZE > 0.0f)
			{
				BALOON_ON = true;
				ClientEvent("new", "all", "items/bows_orion1_cl", IndexOf(ENT_OWNER));
				BOW_CL_IDX = LastClientScriptId();
			}
		}
		else
		{
			ClientEvent("update", "all", BOW_CL_IDX, "add_charge");
		}

		PlayItemViewAnim(ENT_ME, 2); // Stretch

		if (ManaOf(ENT_OWNER) <= MP_DRAIN)
		{
			MAX_LEVEL = true;
			PlayerMessageDark(ENT_OWNER, "Orion Bow: Insufficient Mana");
			// callexternal $get(ent_owner,id) set_mana_dart 0 0
			exitSub = true;
		}
		if (exitSub)
			return;

		if (BALL_SIZE >= 10.0f)
		{
			BALL_SIZE = 10.0f;
			MAX_LEVEL = true;
		}
		if (MAX_LEVEL)
			OwnerMessage("Manaball has reached maximum charge");

		GiveMana(-MP_DRAIN);
		CallExternal(ENT_OWNER, "mana_drain"); // update mana on player hud readout, if using hud feedback

		ServerPlaySound(1, 3, "ambience/alien_humongo.wav");

		BALL_DMG = BALL_SIZE * Float(DMG_MULTI);

		if (SkillOf(ENT_OWNER, "archery.proficiency") < Float(BASE_LEVEL_REQ))
		{
			MAX_LEVEL = true;
			BALL_DMG = 0.05f;
		}
	}

	// game_-attack1
	void OnGameReleaseAttack1()
	{
		PlayViewAnim(0);

		if (!AM_CHARGING)
			return;

		NEXT_ATTACK = GameTime() + 0.2f;

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none>
		// callexternal ent_owner ext_tossprojectile "proj_mana2" view none 200 0 0 archery //Converted to use new tossprojectile //greatguys1@FEB2022
		Vector3 vel = RelativeVelocity(ViewAnglesOf(ENT_OWNER), Vector3(0, 200, 0));
		CreateNpc("items/proj_mana2", EyePositionOf(ENT_OWNER), @EntityOf(ENT_OWNER), vel, BALL_SIZE, BALL_DMG, "archery"); // <owner> <vec> <ballSize> <damage> <skill to level>

		OnResetAtk();
	}

	// reset_atk
	void OnResetAtk()
	{
		// //dbg resetting atk
		ClientEvent("update", "all", BOW_CL_IDX, "charge_release");
		BALOON_ON = false;
		AM_CHARGING = false;
		BALL_SIZE = 0.0f;
		BALL_DMG = 0.0f;
		MAX_LEVEL = false;
		TALLY_ACTIVE = false;
	}

	// cancel_attack
	// thought there was a game func for this, but no can find
	void OnCancelAttack()
	{
		if (!AM_CHARGING)
			return;
		ClientEvent("update", "all", BOW_CL_IDX, "charge_release");
		OnResetAtk();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons2.mdl");
		Precache("viewmodels/v_bows.mdl");
		Precache("ambience/alien_humongo.wav");
		CallEventDelayed(3.35f, "BowsBase_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bow_spawn") { OnBowSpawn(); return true; }
		if (name == "cancel_attack") { OnCancelAttack(); return true; }
		if (name == "custom_register") { OnCustomRegister(); return true; }
		if (name == "game_-attack1") { OnGameReleaseAttack1(); return true; }
		if (name == "game_attack1_down") { OnGameAttack1Down(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_putinpack") { OnGamePutinpack(); return true; }
		if (name == "reset_atk") { OnResetAtk(); return true; }
		if (name == "tally_stretch") { OnTallyStretch(); return true; }
		return BowsBaseScript::DispatchEvent(name, params);
	}
}
