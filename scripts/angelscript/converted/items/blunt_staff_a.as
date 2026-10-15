#pragma context server

// Converted from items/blunt_staff_a.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_weapon_new.as"

[script "items/blunt_staff_a"]
class BluntStaffA : BaseWeaponNewScript
{
	// Constants
	float FREQ_CHARGE = 1.5f;
	float FINAL_CHARGE = 3.5f;
	int MP_BURST = 30;
	int MP_LCOD = 30;
	int MP_GCOD = 100;
	int MP_WRAITH = 50;
	int PMODEL_IDX_HAND_RIGHT = 32;
	int PMODEL_IDX_HAND_LEFT = 32;
	int VANIM_MELEE = 22;
	int VANIM_SPELL1 = 23;
	int VANIM_SPELL2 = 24;
	int VANIM_BURST = 25;
	int VANIM_BEAM_START = 26;
	int VANIM_BEAM_IDLE = 27;
	int VANIM_CHARGE_START = 28;
	int VANIM_CHARGE_END = 29;
	int VANIM_CHARGE_FAIL = 30;
	string SOUND_MELEE = "weapons/cbar_miss1.wav";
	bool BITEM_CUSTOM_ATK2_REGISTER = true;
	bool BWEAPON_CUSTOM_HITWALL = true;
	string SOUND_BEAM_LOOP = "ambience/dronemachine1.wav";
	string SOUND_CHARGE = "magic/spawn.wav";

	// Variables (an unset .script variable reads as its own name)
	string CL_FX_ID = "CL_FX_ID";
	bool BEAM_ON = false;
	float DMG_BEAM = 0.0f;
	float NEXT_AF_UNDERSKILL_WARN = 0.0f;
	bool BEAM_READY = false;
	float NEXT_CHARGE = 0.0f;
	bool AM_CHARGING = false;
	float CUR_CHARGE = 0.0f;
	float OWNER_SKILL = 0.0f;
	float MAX_CHARGE = 0.0f;
	string CL_STAFF_EYES = "CL_STAFF_EYES";
	string CL_DARK_FX = "CL_DARK_FX";

	// Variables declared by included files, with the value they start with in this script
	BluntStaffA()
	{
		BASE_LEVEL_REQ = "25";
		BWEAPON_NAME = "Dark Staff";
		BWEAPON_DESC = "Greater staff of Affliction";
		BWEAPON_WEIGHT = 60;
		BWEAPON_VALUE = 7000;
		BWEAPON_INV_SPRITE_IDX = 72;
		BWEAPON_HANDS = "both";
		VMODEL_FILE = "viewmodels/v_polearms.mdl";
		VMODEL_IDX = 15;
		PMODEL_FILE = "weapons/p_weapons4.mdl";
		PMODEL_IDX_FLOOR = 33;
		PMODEL_IDX_HANDS = 32;
		PANIM_IDLE = "aim_blunt";
		PANIM_EXT = "blunt";
		VANIM_IDLE = 21;
		VANIM_DRAW = 21;
		WANIM_FLOOR = "standard_floor_idle";
		WANIM_HAND = "standard_idle";
		ATK1_RANGE = 0;
		ATK1_DMG = 0;
		ATK1_DMG_RANGE = 0;
		ATK1_DMG_TYPE = "target";
		ATK1_STAMINA = 0.0f;
		ATK1_SKILL = "spellcasting.affliction";
		ATK1_ACCURACY = "80";
		ATK1_DURATION = 1.0f;
		ATK1_CALLBACK = "beam";
		ATK1_PANIM = "swing_blunt";
		ATK1_VANIM = 0;
		ATK2_VANIM = 0;
		ATK2_PANIM = "sword_double_swing";
		ATK2_CALLBACK = "spell2";
		SOUND_HITWALL1 = "none";
		SOUND_HITWALL2 = "none";
	}

	// unnamed block (first think)
	void BluntStaffA_FirstThink()
	{
		// recache ambience/dronemachine2.wav
		CL_FX_ID = "unset";
	}

	// bweapon_effect_remove
	void OnBweaponEffectRemove(string reason = "")
	{
		BaseItemExtras_OnBweaponEffectRemove(reason); // items/base_item_extras
		BEAM_READY = false;
		if (BEAM_ON)
			OnEndBeam();
		if (AM_CHARGING)
			OnEndCharge();
	}

	// game_hitworld
	void OnGameHitworld()
	{
		BaseWeaponNew_OnGameHitworld(); // items/base_weapon_new
		// dbg game_hitworld
		if (BEAM_ON)
			return;
	}

	// cbeam_start
	void OnCbeamStart()
	{
		PlayViewAnim(VANIM_BEAM_START);
		CallEventDelayed(0.6f, "setup_beam");
	}

	// setup_beam
	void OnSetupBeam()
	{
		if (BEAM_ON)
			return;
		BEAM_ON = true;
		PlayViewAnim(VANIM_BEAM_IDLE);
		ClientEvent("new", "all", "items/blunt_staff_a_cl", IndexOf(ENT_OWNER), ViewAnglesOf(ENT_OWNER));
		CL_FX_ID = LastClientScriptId();
		DMG_BEAM = SkillOf(ENT_OWNER, "spellcasting.affliction");
		if (SkillOf(ENT_OWNER, "spellcasting.affliction") < 20.0f)
		{
			DMG_BEAM *= 0.1f;
			if (GameTime() > NEXT_AF_UNDERSKILL_WARN)
			{
				NEXT_AF_UNDERSKILL_WARN = GameTime() + 5.0f;
				PlayerMessageDark(ENT_OWNER, NameOf(ENT_ME) + " underskilled (req:affliction[20])");
			}
		}
		ServerPlaySound(3, 10, SOUND_BEAM_LOOP);
		OnBeamLoop();
	}

	// beam_loop
	void OnBeamLoop()
	{
		bool endBeam = false;
		bool exitSub = false;
		if (!BEAM_ON)
			return;

		if (ActiveItemOf(ENT_OWNER) !is self)
			endBeam = true;
		if (!CanAttack(ENT_OWNER))
			endBeam = true;
		if (!IsAlive(ENT_OWNER))
			endBeam = true;
		if (endBeam)
		{
			OnEndBeam();
			CallClientItemEvent(ENT_ME, "end_beam");
			exitSub = true;
		}
		if (exitSub)
			return;

		CallEventDelayed(0.5f, "beam_loop");
		Vector3 beamEnd = EyePositionOf(ENT_OWNER);
		Vector3 ownerViewang = ViewAnglesOf(ENT_OWNER);
		ClientEvent("update", "all", CL_FX_ID, "ext_aim", ownerViewang);
		beamEnd += RelativePosition(ownerViewang, Vector3(0, 1280, 0));
		// <target|(src_origin)> <range|aoe|(dest_origin)|direct> <damage> <cth|fall_off> <attacker> <inflciter> <skill|none> <dmg_type> [flag_string]
		DoDamageEx(EyePositionOf(ENT_OWNER), beamEnd, DMG_BEAM, 100, ENT_OWNER, ENT_ME, "spellcasting.affliction", "dark", "nodecal;dmgevent:*beam");
		if (CanAttack(ENT_OWNER))
			return;
		OnEndBeam();
	}

	// beam_dodamage
	void OnBeamDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		// dbg beam_dodamage PARAM1 $get(PARAM2,name) PARAM3 PARAM4 PARAM5 PARAM6
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_OWNER) != "enemy")
			return;
		if (GAME_PVP == 0 && IsPlayer(target))
			exitSub = true;
		if (exitSub)
			return;
		if (!(ManaOf(ENT_OWNER) < MaxManaOf(ENT_OWNER)))
			return;
		GiveMana(ENT_OWNER, DMG_BEAM);
	}

	// game_attack1_down
	void OnGameAttack1Down()
	{
		bool exitSub = false;

		if (!CanAttack(ENT_OWNER))
			exitSub = true;
		if (ActiveItemOf(ENT_OWNER) !is self)
			exitSub = true;
		if (exitSub)
			return;

		if (exitSub)
			return;

		if (AM_CHARGING)
			return;
		if (BEAM_ON)
			return;
		if (BEAM_READY)
			return;
		BEAM_READY = true;
		OnCbeamStart();
	}

	// game_-attack1
	void OnGameReleaseAttack1()
	{
		if (!BEAM_ON)
			return;
		OnEndBeam();
	}

	// end_beam
	void OnEndBeam()
	{
		PlayViewAnim(VANIM_IDLE);
		BEAM_ON = false;
		BEAM_READY = false;
		ServerPlaySound(3, 0, SOUND_BEAM_LOOP);
		ClientEvent("update", "all", CL_FX_ID, "end_fx");
		CL_FX_ID = "unset";
	}

	// game_+attack2
	void OnGamePressAttack2()
	{
		bool exitSub = false;

		if (!CanAttack(ENT_OWNER))
			exitSub = true;
		if (exitSub)
			return;

		if (exitSub)
			return;

		if (Truthy(Eval("game.item.attacking")))
			return;

		if (BEAM_READY)
			return;
		if (BEAM_ON)
			return;
		if (!(GameTime() > NEXT_CHARGE))
			return;
		NEXT_CHARGE = GameTime() + 20.0f; // reset on release
		if (!AM_CHARGING)
			PlayItemViewAnim(ENT_ME, VANIM_CHARGE_START);

		AM_CHARGING = true;

		CUR_CHARGE = 1.0f;

		// setvard OLD_CAN_MOVE $get(ent_owner,scriptvar,'game.effect.canmove')
		// callexternal ent_owner set_status_canmove 0
		// setvard OLD_PUSH_STATUS $get(ent_owner,nopush)
		ScriptFlags(ENT_OWNER, "add", "af_staff", "nopush", 1, -1, "none");
		ApplyEffect(ENT_OWNER, "effects/effect_tempnomove");

		OWNER_SKILL = SkillOf(ENT_OWNER, "spellcasting.affliction");
		MAX_CHARGE = 0.0f;
		if (OWNER_SKILL >= 25.0f)
			MAX_CHARGE = 1.5f;
		if (OWNER_SKILL >= 30.0f)
			MAX_CHARGE = 2.5f;
		if (OWNER_SKILL >= 35.0f)
			MAX_CHARGE = 3.5f;
		CallClientItemEvent(ENT_ME, "cl_set_maxcharge", MAX_CHARGE); // pass max charge level to client

		CallEventDelayed(FREQ_CHARGE, "add_charge");

		if (OWNER_SKILL >= 25.0f)
			CallEventDelayed(0.75f, "repulse_burst");

		PlayOwnerAnim("critical", "aim_sword_double_idle", "global.anim.combatwalk", 3);
		ClientEvent("new", ENT_OWNER, "items/blunt_staff_a_charge_cl", IndexOf(ENT_ME));
		CL_STAFF_EYES = LastClientScriptId();
	}

	// repulse_burst
	void OnRepulseBurst()
	{
		bool exitSub = false;
		if (!AM_CHARGING)
			return;
		if (ManaOf(ENT_OWNER) < MP_BURST)
		{
			PlayerMessageDark(ENT_OWNER, "Dark Staff: Not enough mana for Dark Burst");
			exitSub = true;
		}
		if (exitSub)
			return;
		GiveMana(ENT_OWNER, -MP_BURST);

		float burstDmg = OWNER_SKILL;
		CallExternal(ENT_OWNER, "ext_repel_burst", burstDmg, 128, 0, "dark_effect", "spellcasting.affliction", 800, 0);
		Vector3 spellPos = OriginOf(ENT_OWNER);
		spellPos.z = GroundHeight(spellPos);
		ClientEvent("new", "all", "effects/sfx_dark_burst", spellPos, 8.0f);
		CL_DARK_FX = LastClientScriptId();
	}

	// cl_set_maxcharge
	void OnClSetMaxcharge(float maxCharge = 0.0f)
	{
		MAX_CHARGE = maxCharge;
	}

	// add_charge
	void OnAddCharge()
	{
		bool endCharge = false;
		bool exitSub = false;

		if (!AM_CHARGING)
			return;
		if (!(CUR_CHARGE < MAX_CHARGE))
			return;
		CUR_CHARGE += 0.5f;

		if (ActiveItemOf(ENT_OWNER) !is self)
			endCharge = true;
		if (!CanAttack(ENT_OWNER))
			endCharge = true;
		if (!IsAlive(ENT_OWNER))
			endCharge = true;
		if (endCharge)
		{
			OnEndCharge();
			exitSub = true;
		}
		if (exitSub)
			return;

		CallEventDelayed(FREQ_CHARGE, "add_charge");
		if (!IsAlive(ENT_OWNER))
			return;
		CallExternal(ENT_OWNER, "ext_repel_burst", 0, 128, 0, "none", "none", 300, MaxHealthOf(ENT_OWNER) * 3.0f, OriginOf(ENT_OWNER));
		ClientEvent("update", ENT_OWNER, CL_STAFF_EYES, "add_charge_level", CUR_CHARGE);
		// effect screenshake $get(ent_owner,origin) 190 20 0.5 32 //fubar's eyes
		PlayRandomSound(2, 5, "buttons/spark1.wav", "buttons/spark2.wav", "buttons/spark4.wav");
		if (CUR_CHARGE != int(CUR_CHARGE))
		{
			if (CUR_CHARGE < FINAL_CHARGE)
				PlaySound(1, 5, SOUND_CHARGE);
			if (CUR_CHARGE == FINAL_CHARGE)
				PlaySound(1, 10, SOUND_CHARGE);
		}
	}

	// game_-attack2
	void OnGameReleaseAttack2()
	{
		bool exitSub = false;
		float dmgCod = 0.0f;
		if (!AM_CHARGING)
			return;
		AM_CHARGING = false;
		NEXT_CHARGE = GameTime() + 3.0f;
		PlayViewAnim(VANIM_IDLE); // anim retract or fail
		DebugPrint("staff_charge_finish " + Text(CUR_CHARGE));

		if (!IsAlive(ENT_OWNER))
			return;

		// setvard OLD_CAN_MOVE $get(ent_owner,scriptvar,'game.effect.canmove')
		OnEndCharge();
		if (!CanAttack(ENT_OWNER)) // in case stunned or otherwise can't attack before release
			return;
		if (exitSub)
			return;

		if (CUR_CHARGE >= 1.5f && CUR_CHARGE < 2.5f)
		{
			// lesser circle of death here
			DebugPrint("lesser circle of death");
			if (Truthy(ScriptVarOf(ENT_OWNER, "PLR_LCOD_ACTIVE")))
			{
				PlayerMessageDark(ENT_OWNER, "Dark Staff: Can only maintain one Lesser Circle of Death.");
				exitSub = true;
			}
			if (!exitSub)
			{
				if (ManaOf(ENT_OWNER) < MP_LCOD)
				{
					PlayerMessageDark(ENT_OWNER, "Dark Staff: Insufficient mana for Lesser Circle of Death");
					exitSub = true;
				}
				if (!exitSub)
				{
					GiveMana(ENT_OWNER, -MP_LCOD);

					dmgCod = SkillOf(ENT_OWNER, "spellcasting.affliction");
					CallExternal(ENT_OWNER, "ext_lcod", OriginOf(ENT_OWNER), dmgCod, 30.0f);
				}
			}
		}

		if (CUR_CHARGE >= 2.5f && CUR_CHARGE < 3.5f)
		{
			// greater circle of death here
			DebugPrint("greater circle of death");
			if (Truthy(ScriptVarOf(ENT_OWNER, "PLR_GCOD_ACTIVE")))
			{
				PlayerMessageDark(ENT_OWNER, "Dark Staff: Can only maintain one Greater Circle of Death.");
				exitSub = true;
			}
			if (!exitSub)
			{
				if (ManaOf(ENT_OWNER) < MP_GCOD)
				{
					PlayerMessageDark(ENT_OWNER, "Dark Staff: Insufficient mana for Greater Circle of Death");
					exitSub = true;
				}
				if (!exitSub)
				{
					GiveMana(ENT_OWNER, -MP_GCOD);

					dmgCod = SkillOf(ENT_OWNER, "spellcasting.affliction");
					CallExternal(ENT_OWNER, "ext_gcod", OriginOf(ENT_OWNER), dmgCod, 30.0f);
				}
			}
		}

		if (CUR_CHARGE == 3.5f)
		{
			if (Truthy(ScriptVarOf(ENT_OWNER, "PLR_WRAITH_ACTIVE")))
			{
				PlayerMessageDark(ENT_OWNER, "Dark Staff: Can only maintain one Lesser Wraith");
				exitSub = true;
			}
			if (!exitSub)
			{
				if (ManaOf(ENT_OWNER) < MP_WRAITH)
				{
					PlayerMessageDark(ENT_OWNER, "Dark Staff: Insufficient mana for Lesser Wraith");
					exitSub = true;
				}
				if (!exitSub)
				{
					GiveMana(ENT_OWNER, -MP_WRAITH);

					Vector3 summonPos = OriginOf(ENT_OWNER);
					summonPos.z = GroundHeight(summonPos);
					string ownerYawText = Text(ViewAnglesOf(ENT_OWNER));
					float ownerYaw;
					ownerYaw = Vec(ownerYawText).y;
					summonPos += RelativePosition(Vector3(0, ownerYaw, 0), Vector3(0, 64, 0));

					CreateNpc("monsters/summon/lesser_wraith", summonPos, @EntityOf(ENT_OWNER), summonPos);
				}
			}
		}
	}

	// end_charge
	void OnEndCharge()
	{
		if (AM_CHARGING)
		{
			// maybe player put me away mid-charge or died
			AM_CHARGING = false;
			NEXT_CHARGE = GameTime() + 3.0f;
			CallClientItemEvent(ENT_ME, "cl_end_charge");
		}
		if (IsAlive(ENT_OWNER))
			ScriptFlags(ENT_OWNER, "remove", "af_staff");
		CallExternal(ENT_OWNER, "ext_end_tempnomove");
		ClientEvent("update", ENT_OWNER, CL_STAFF_EYES, "end_fx");
		ClientEvent("update", "all", CL_DARK_FX, "end_fx");
	}

	// cl_end_charge
	void OnClEndCharge()
	{
		AM_CHARGING = false;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreqCharge() {} // FREQ_CHARGE

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("calflame_small.spr");
		Precache("weapons/p_weapons4.mdl");
		Precache("viewmodels/v_polearms.mdl");
		Precache("ambience/dronemachine1.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BluntStaffA_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "add_charge") { OnAddCharge(); return true; }
		if (name == "beam_dodamage") { OnBeamDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "beam_loop") { OnBeamLoop(); return true; }
		if (name == "bweapon_effect_remove") { OnBweaponEffectRemove(Param(params, 0)); return true; }
		if (name == "cbeam_start") { OnCbeamStart(); return true; }
		if (name == "cl_end_charge") { OnClEndCharge(); return true; }
		if (name == "cl_set_maxcharge") { OnClSetMaxcharge(Float(Param(params, 0))); return true; }
		if (name == "end_beam") { OnEndBeam(); return true; }
		if (name == "end_charge") { OnEndCharge(); return true; }
		if (name == "game_+attack2") { OnGamePressAttack2(); return true; }
		if (name == "game_-attack1") { OnGameReleaseAttack1(); return true; }
		if (name == "game_-attack2") { OnGameReleaseAttack2(); return true; }
		if (name == "game_attack1_down") { OnGameAttack1Down(); return true; }
		if (name == "game_hitworld") { OnGameHitworld(); return true; }
		if (name == "repulse_burst") { OnRepulseBurst(); return true; }
		if (name == "setup_beam") { OnSetupBeam(); return true; }
		return BaseWeaponNewScript::DispatchEvent(name, params);
	}
}
