#pragma context server

// Converted from items/blunt_gauntlets_bear.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_melee.as"
#include "converted/items/base_kick.as"

[script "items/blunt_gauntlets_bear"]
class BluntGauntletsBear : BaseMeleeScript, BaseKick
{
	// Constants
	string BASE_LEVEL_REQ = "30";
	int DRAIN_RATE = -8;
	bool NO_IDLE = true;
	bool MELEE_OVERRIDE = true;
	int ANIM_HANDS_DOWN = 0;
	string ANIM_LOWER = "4";
	int ANIM_IDLE_TOTAL = 1;
	string ANIM_ATTACK1 = "5";
	string ANIM_ATTACK2 = "6";
	int ANIM_SHEATH = 5;
	int MODEL_VIEW_IDX = 6;
	int MELEE_DMG = 190;
	int MELEE_DMG_RANGE = 0;
	string MELEE_DMG_TYPE = "slash";
	string MELEE_ACCURACY = "85%";
	string MELEE_RANGE = "100";
	float MELEE_DMG_DELAY = 0.3f;
	float MELEE_ATK_DURATION = 0.9f;
	int MELEE_RANGE_BEAR = 80;
	float MELEE_DELAY_BEAR = 0.3f;
	int MELEE_DMG_BEAR = 1000;
	string MELEE_STAT = "martialarts";
	string MELEE_SOUND = "weapons/swingsmall.wav";
	float MELEE_SOUND_DELAY = 0.0f;
	string MELEE_PARRY_CHANCE = "0%";
	string SOUND_SWIPE = "weapons/swingsmall.wav";
	string SOUND_HITWALL1 = "weapons/cbar_hitbod1.wav";
	string SOUND_HITWALL2 = "weapons/cbar_hitbod2.wav";
	string SOUND_SWING = "weapons/swingsmall.wav";
	string SOUND_BEAR_IDLE1 = "monsters/bear/c_bear_yes.wav";
	string SOUND_BEAR_IDLE2 = "monsters/bear/c_bear_bat1.wav";
	string SOUND_BEAR_IDLE3 = "monsters/bear/c_bear_bat2.wav";
	string SOUND_BEAR_TRANSFORM_ON = "monsters/bear/c_beardire_bat1.wav";
	string SOUND_BEAR_ATTACK1 = "monsters/bear/c_bear_atk1.wav";
	string SOUND_BEAR_ATTACK2 = "monsters/bear/c_bear_atk2.wav";
	string SOUND_BEAR_ATTACK3 = "monsters/bear/c_bear_atk3.wav";
	float FREQ_BEAR_IDLE = 0.0f;
	string SOUND_BEAR_HITWALL1 = "debris/bustconcrete1.wav";
	string SOUND_BEAR_HITWALL2 = "debris/bustconcrete2.wav";
	float FREQ_BEAR_RAWR = 0.0f;
	bool BEAR_CLAWS_VOFS = true;
	float FREQ_BEAR_ATTACK = 0.75f;
	int ANIM_BEAR_ATTACK1 = 5;
	int ANIM_BEAR_ATTACK2 = 6;
	bool ANIM_BEAR_LIFT1 = true;

	// Variables (an unset .script variable reads as its own name)
	int PUNCH_ATTACK = 0;
	float FISTS_LAST_ATTACK = 0.0f;
	float NEXT_RIGHT_CLICK = 0.0f;
	bool BEAR_MODE = false;
	CBaseEntity@ BEAR_IMAGE_ID = null;
	float NEXT_BEAR_IDLE = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	BluntGauntletsBear()
	{
		ANIM_LIFT1 = 3;
		ANIM_IDLE1 = "2";
		MODEL_VIEW = "viewmodels/v_martialarts.mdl";
		MODEL_BODY_OFS = "58";
		MODEL_HANDS = "weapons/p_weapons3.mdl";
		MODEL_WORLD = "weapons/p_weapons3.mdl";
		ANIM_PREFIX = "standard";
		PLAYERANIM_AIM = "fists";
	}

	// game_fall
	// { [server]
	// repeatdelay 1.0
	// dbg bear_check BOGUS_ITEM
	// }
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseWeapon_OnGameFall(); // items/base_weapon
		float worldOfs = Float(MODEL_BODY_OFS);
		worldOfs += 1.0f;
		SetModelBody(0, int(worldOfs));
	}

	// bweapon_effect_remove
	void OnBweaponEffectRemove(string reason = "")
	{
		BaseItemExtras_OnBweaponEffectRemove(reason); // items/base_item_extras
		DebugPrint("Item Removed");
		OnBearTransformationEnd("removed");
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee

		SetName("Bear Claws");
		SetDescription("Magical claws enchanted with the spirit of a great bear");
		SetWeight(3);
		SetValue(3000);
		SetHand("both");
		SetHudSprite("hand", "138");
		SetHudSprite("trade", "138");
	}

	// melee_start
	void OnMeleeStart()
	{
		BaseMelee_OnMeleeStart(); // items/base_melee
		string punchAnim = "l.punch_anim";

		if (BEAR_MODE)
		{
			CallExternal(BEAR_IMAGE_ID, "ext_attack");
			LegacyCommand("svplayrandomsound", 0, 10, SOUND_BEAR_ATTACK1, SOUND_BEAR_ATTACK2, SOUND_BEAR_ATTACK3);
		}

		if (BEAR_MODE)
			return;

		if (PUNCH_ATTACK == 0)
		{
			punchAnim = "stance_normal_lowjab_r1";
			PUNCH_ATTACK = 1;
			PlayViewAnim(Int(ANIM_ATTACK1));
		}
		else if (PUNCH_ATTACK == 1)
		{
			punchAnim = "stance_normal_lowjab_r2";
			PUNCH_ATTACK = 0;
			PlayViewAnim(Int(ANIM_ATTACK2));
		}

		PlayOwnerAnim("once", punchAnim, "global.anim.combatwalk", 3);

		PlaySound(3, 5, SOUND_SWING);
		FISTS_LAST_ATTACK = GameTime();
		OnPunch1Done(); // Lower fists in 5 seconds
	}

	// hitwall
	void OnHitwall()
	{
		BaseMelee_OnHitwall(); // items/base_melee

		if (!BEAR_MODE)
			PlayRandomSound(2, 10, SOUND_HITWALL1, SOUND_HITWALL2);
		else
			LegacyCommand("svplayrandomsound", 2, 10, SOUND_BEAR_HITWALL1, SOUND_BEAR_HITWALL2);
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("monsters/companion/bear_image");
	}

	// weapon_deploy
	void OnWeaponDeploy()
	{
		SetModelBody(0, Int(MODEL_BODY_OFS));
		PlayViewAnim(ANIM_HANDS_DOWN);

		if (!BEAR_MODE)
			return;
		OnBearTransformationEnd();
	}

	// punch1_done
	void OnPunch1Done()
	{
		if (int(FISTS_LAST_ATTACK) == 0)
			return;
		float elapsedtime = GameTime() - FISTS_LAST_ATTACK;

		if (!(elapsedtime > 5.0f))
			return;

		PlayViewAnim(Int(ANIM_LOWER));
		FISTS_LAST_ATTACK = 0.0f;
	}

	// game_+attack2
	void OnGamePressAttack2()
	{
		if (!CanAttack(ENT_OWNER))
			return;

		if (!(GameTime() > NEXT_RIGHT_CLICK))
			return;
		NEXT_RIGHT_CLICK = GameTime() + 1.0f; // 1 second before transform/attempts

		CallEventDelayed(0.1f, "bear_mode_toggle");
	}

	// bear_mode_toggle
	void OnBearModeToggle()
	{
		bool exitSub = false;

		if (!BEAR_MODE)
		{
			if (ManaOf(ENT_OWNER) < 30.0f)
			{
				PlayerMessageDark(ENT_OWNER, "Bear Claws: Not enough mana to transform.");
			}
			else
			{
				if (SkillOf(ENT_OWNER, "spellcasting") < 20.0f)
				{
					PlayerMessageDark(ENT_OWNER, "Bear Claws: You lack the magical talent to activate this item. (Spellcasting:20)");
					exitSub = true;
				}

				if (!exitSub)
				{
					CallEventDelayed(0.1f, "bear_transformation"); // give a cycle for button to clear
				}
			}
		}
		else
		{
			CallEventDelayed(0.1f, "bear_transformation_end");
		}
	}

	// bear_transformation
	void OnBearTransformation()
	{
		bool isWielded = false;

		// not sure how we're going to do this, exactly, until I setup the model and experiment
		// current thought is to change viewmodel and attack attribs
		// may also want to slow player here a bit and/or prevent run, however
		// you'll need a new slow effect that can be canceled
		// you'll also need to lock inventory here
		// hope game_mouse_down and +attack2 work with inventory lock
		// sethand	undroppable
		if (EntityId(self) == ScriptVarOf(ENT_OWNER, "PLR_LEFT_HAND"))
			isWielded = true;
		if (EntityId(self) == ScriptVarOf(ENT_OWNER, "PLR_RIGHT_HAND"))
			isWielded = true;
		if (!isWielded)
			return;

		SetViewModelProp(ENT_ME, "model", "none");

		SetAttackProp(ENT_ME, 0, "range", MELEE_RANGE_BEAR);
		// attackprop ent_me 0 callback bear //causes overflow
		SetAttackProp(ENT_ME, 0, "dmg", MELEE_DMG_BEAR);
		SetAttackProp(ENT_ME, 1, "reqskill", 99); // stop kick ability

		ServerPlaySound(0, 10, SOUND_BEAR_TRANSFORM_ON);

		BEAR_MODE = true;
		OnBearLoop();
		// (always true here) if game.serverside

		CreateNpc("monsters/companion/bear_image", OriginOf(ENT_OWNER), @EntityOf(ENT_OWNER));
		@BEAR_IMAGE_ID = EntityOf(ENT_LASTCREATED);
		CallExternal(ENT_OWNER, "ext_bear_mode", @BEAR_IMAGE_ID);
	}

	// bear_transformation_end
	void OnBearTransformationEnd(string reason = "")
	{
		bool isWielded = false;
		// (always true here) if game.serverside

		if (!BEAR_MODE)
			return;

		BEAR_MODE = false;

		// playsound 0 10 SOUND_BEAR_TRANSFORM_OFF
		if (EntityId(self) == ScriptVarOf(ENT_OWNER, "PLR_LEFT_HAND"))
			isWielded = true;
		if (EntityId(self) == ScriptVarOf(ENT_OWNER, "PLR_RIGHT_HAND"))
			isWielded = true;

		if (reason != "removed")
		{
			SetAttackProp(ENT_ME, 0, "range", MELEE_RANGE);
			SetAttackProp(ENT_ME, 0, "dmg", MELEE_DMG);
			SetAttackProp(ENT_ME, 1, "reqskill", 5); // restore kick ability
		}

		if (IsAlive(ENT_OWNER))
		{
			CallExternal(ENT_OWNER, "ext_bear_mode_end", 1);
			CallExternal(BEAR_IMAGE_ID, "remove_bear");
			if (isWielded)
			{
				SetViewModelProp(ENT_ME, "model", MODEL_VIEW);
				SetViewModelProp(ENT_ME, "submodel", MODEL_VIEW_IDX);
				if (reason != "removed")
					CallEventDelayed(0.1f, "sv_lift_arms");
			}
		}
		else if (Exists(BEAR_IMAGE_ID))
			CallExternal(BEAR_IMAGE_ID, "ext_bear_die", "from_gauntlets");
	}

	// sv_lift_arms
	void OnSvLiftArms()
	{
		PlayItemViewAnim(ENT_ME, ANIM_LIFT1);
	}

	// bear_loop
	// { game_attack1_down
	// if game.serverside
	// setvard BOGUS_ITEM not
	// if BEAR_MODE
	// if game.time > NEXT_BEAR_ATTACK
	// setvard NEXT_BEAR_ATTACK game.time
	// add NEXT_BEAR_ATTACK FREQ_BEAR_ATTACK
	// callexternal BEAR_IMAGE_ID ext_attack
	// //splayviewanim ent_me ANIM_BEAR_ATTACK1
	// playrandomsound 0 10 SOUND_BEAR_ATTACK1 SOUND_BEAR_ATTACK2 SOUND_BEAR_ATTACK3
	// local BEAR_CL_INDEX $get(ent_owner,scriptvar,'PLR_BEAR_CL_INDEX')
	// clientevent update all BEAR_CL_INDEX bear_attack
	// callevent MELEE_DELAY_BEAR bear_damage
	// }
	// { bear_damage
	// local DMG_SET $get(ent_owner,skill.martialarts.ratio)
	// multiply DMG_SET MELEE_DMG
	// multiply DMG_SET BEAR_DMG_MULTI
	// local OWNER_TARG $get(ent_owner,target)
	// local OWNER_POS $get(ent_owner,origin)
	// local TARG_POS $get(OWNER_TARG,origin)
	// xdodamage OWNER_TARG MELEE_RANGE_BEAR DMG_SET 90% $get(ent_owner,id) $get(ent_owner,id) MELEE_STAT slash
	// }
	void OnBearLoop()
	{
		if (!BEAR_MODE)
			return;

		if (!IsAlive(ENT_OWNER))
			OnBearTransformationEnd();

		if (!IsAlive(ENT_OWNER))
			return;
		if (ManaOf(ENT_OWNER) > 0.0f)
			GiveMana(ENT_OWNER, DRAIN_RATE);
		if (ManaOf(ENT_OWNER) <= 1.0f)
		{
			PlayerMessageDark(ENT_OWNER, "Bear Claws: You've run out of mana!");
			OnBearTransformationEnd();
			bool exITSub = true;
		}

		CallEventDelayed(0.5f, "bear_loop");

		if (GameTime() > NEXT_BEAR_IDLE)
		{
			NEXT_BEAR_IDLE = GameTime() + FREQ_BEAR_IDLE;
			LegacyCommand("svplayrandomsound", 1, 10, SOUND_BEAR_IDLE1, SOUND_BEAR_IDLE2, SOUND_BEAR_IDLE3);
		}
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons3.mdl");
		Precache("viewmodels/v_martialarts.mdl");
		Precache("weapons/martialarts/foot.mdl");
		Precache("monsters/bear/c_bear_atk1.wav");
		Precache("monsters/bear/c_bear_atk2.wav");
		Precache("monsters/bear/c_bear_atk3.wav");
		Precache("debris/bustconcrete1.wav");
		Precache("debris/bustconcrete2.wav");
		Precache("monsters/bear/c_beardire_bat1.wav");
		Precache("monsters/bear/c_bear_yes.wav");
		Precache("monsters/bear/c_bear_bat1.wav");
		Precache("monsters/bear/c_bear_bat2.wav");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bear_loop") { OnBearLoop(); return true; }
		if (name == "bear_mode_toggle") { OnBearModeToggle(); return true; }
		if (name == "bear_transformation") { OnBearTransformation(); return true; }
		if (name == "bear_transformation_end") { OnBearTransformationEnd(Param(params, 0)); return true; }
		if (name == "bweapon_effect_remove") { OnBweaponEffectRemove(Param(params, 0)); return true; }
		if (name == "game_+attack2") { OnGamePressAttack2(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "hitwall") { OnHitwall(); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "punch1_done") { OnPunch1Done(); return true; }
		if (name == "sv_lift_arms") { OnSvLiftArms(); return true; }
		if (name == "weapon_deploy") { OnWeaponDeploy(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BaseKick_DispatchEvent(name, params)
			|| BaseMeleeScript::DispatchEvent(name, params);
	}
}
