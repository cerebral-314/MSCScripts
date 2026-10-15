#pragma context server

// Converted from items/swords_volcano.script by msc_transpiler.
// Dark sword by Thothie (from Shortsword - model by pBarnum)

#include "runtime/ScriptEntity.as"
#include "converted/items/swords_base_onehanded.as"

[script "items/swords_volcano"]
class SwordsVolcano : SwordsBaseOnehandedScript
{
	// Constants
	int MP_REQ1 = 5;
	int MP_REQ2 = 10;
	int MP_REQ3 = 15;
	int MP_REQ4 = 20;
	int MP_REQ5 = 30;
	float LEVEL_INC = 1.5f;
	string BASE_LEVEL_REQ = "10";
	int MODEL_VIEW_IDX = 5;
	string SOUND_SHOUT = "SOUND_SHOUT";
	int SECONDARY_DMG = 500;

	// Variables (an unset .script variable reads as its own name)
	float LOOP_SOUND = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	SwordsVolcano()
	{
		MODEL_VIEW = "viewmodels/v_1hswords.mdl";
		MODEL_HANDS = "weapons/p_weapons1.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		MODEL_BODY_OFS = "110";
		ANIM_PREFIX = "darksword";
		MELEE_RANGE = "64";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.1f;
		MELEE_ENERGY = 0.3f;
		MELEE_DMG = 240;
		MELEE_DMG_RANGE = 10;
		MELEE_DMG_TYPE = "slash";
		MELEE_ACCURACY = "77%";
		MELEE_STAT = "swordsmanship";
		MELEE_ALIGN_BASE = "4,-6";
		MELEE_ALIGN_TIP = "0,6";
		MELEE_PARRY_CHANCE = "30%";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee

		SetName("Dark Sword");
		SetDescription("This swords magic can help the skillful land deadly blows");
		SetWeight(30);
		SetValue(3000);
		SetHudSprite("trade", "104");
	}

	// melee_start
	void OnMeleeStart()
	{
		BaseMelee_OnMeleeStart(); // items/base_melee
		SwordsBaseOnehanded_OnMeleeStart(); // items/swords_base_onehanded

		PlayViewAnim(3);
		if (PLAYERANIM_SWING != "PLAYERANIM_SWING")
			PlayOwnerAnim("once", PLAYERANIM_SWING, "global.anim.combatwalk", 3);
		CallEventDelayed(MELEE_SOUND_DELAY, "melee_playsound");
	}

	// register_charge1
	void OnRegisterCharge1()
	{
		float triDmg = MELEE_DMG;
		float fDmgRange = MELEE_DMG_RANGE;

		triDmg *= LEVEL_INC;
		fDmgRange *= 2.0f;
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", MELEE_RANGE);
		SetLocal("reg.attack.dmg", triDmg);
		SetLocal("reg.attack.dmg.range", fDmgRange);
		SetLocal("reg.attack.dmg.type", "dark");
		SetLocal("reg.attack.energydrain", 2);
		SetLocal("reg.attack.stat", "swordsmanship");
		SetLocal("reg.attack.hitchance", "85%");
		SetLocal("reg.attack.priority", 1);
		SetLocal("reg.attack.delay.strike", MELEE_DMG_DELAY);
		SetLocal("reg.attack.delay.end", MELEE_ATK_DURATION);
		SetLocal("reg.attack.callback", "dmgup1");
		SetLocal("reg.attack.noise", MELEE_NOISE);
		SetLocal("reg.attack.chargeamt", "100%");
		SetLocal("reg.attack.reqskill", 10);
		SetLocal("reg.attack.mpdrain", MP_REQ1);
		RegisterAttack();

		triDmg *= LEVEL_INC;
		fDmgRange *= 2.0f;
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", MELEE_RANGE);
		SetLocal("reg.attack.dmg", triDmg);
		SetLocal("reg.attack.dmg.range", fDmgRange);
		SetLocal("reg.attack.dmg.type", "dark");
		SetLocal("reg.attack.energydrain", 4);
		SetLocal("reg.attack.stat", "swordsmanship");
		SetLocal("reg.attack.hitchance", "85%");
		SetLocal("reg.attack.priority", 2);
		SetLocal("reg.attack.delay.strike", MELEE_DMG_DELAY);
		SetLocal("reg.attack.delay.end", MELEE_ATK_DURATION);
		SetLocal("reg.attack.callback", "dmgup2");
		SetLocal("reg.attack.noise", MELEE_NOISE);
		SetLocal("reg.attack.chargeamt", "200%");
		SetLocal("reg.attack.reqskill", 15);
		SetLocal("reg.attack.mpdrain", MP_REQ2);
		RegisterAttack();

		triDmg *= LEVEL_INC;
		fDmgRange *= 2.0f;
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", MELEE_RANGE);
		SetLocal("reg.attack.dmg", triDmg);
		SetLocal("reg.attack.dmg.range", fDmgRange);
		SetLocal("reg.attack.dmg.type", "dark");
		SetLocal("reg.attack.energydrain", 6);
		SetLocal("reg.attack.stat", "swordsmanship");
		SetLocal("reg.attack.hitchance", "85%");
		SetLocal("reg.attack.priority", 3);
		SetLocal("reg.attack.delay.strike", MELEE_DMG_DELAY);
		SetLocal("reg.attack.delay.end", MELEE_ATK_DURATION);
		SetLocal("reg.attack.callback", "dmgup3");
		SetLocal("reg.attack.noise", MELEE_NOISE);
		SetLocal("reg.attack.chargeamt", "300%");
		SetLocal("reg.attack.reqskill", 20);
		SetLocal("reg.attack.mpdrain", MP_REQ3);
		RegisterAttack();

		triDmg *= LEVEL_INC;
		fDmgRange *= 2.0f;
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", MELEE_RANGE);
		SetLocal("reg.attack.dmg", triDmg);
		SetLocal("reg.attack.dmg.range", fDmgRange);
		SetLocal("reg.attack.dmg.type", "dark");
		SetLocal("reg.attack.energydrain", 8);
		SetLocal("reg.attack.stat", "swordsmanship");
		SetLocal("reg.attack.hitchance", "85%");
		SetLocal("reg.attack.priority", 4);
		SetLocal("reg.attack.delay.strike", MELEE_DMG_DELAY);
		SetLocal("reg.attack.delay.end", MELEE_ATK_DURATION);
		SetLocal("reg.attack.callback", "dmgup4");
		SetLocal("reg.attack.noise", MELEE_NOISE);
		SetLocal("reg.attack.chargeamt", "400%");
		SetLocal("reg.attack.reqskill", 25);
		SetLocal("reg.attack.mpdrain", MP_REQ4);
		RegisterAttack();

		triDmg *= LEVEL_INC;
		fDmgRange *= 2.0f;
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", MELEE_RANGE);
		SetLocal("reg.attack.dmg", triDmg);
		SetLocal("reg.attack.dmg.range", fDmgRange);
		SetLocal("reg.attack.dmg.type", "dark");
		SetLocal("reg.attack.energydrain", 10);
		SetLocal("reg.attack.stat", "swordsmanship");
		SetLocal("reg.attack.hitchance", "85%");
		SetLocal("reg.attack.priority", 5);
		SetLocal("reg.attack.delay.strike", MELEE_DMG_DELAY);
		SetLocal("reg.attack.delay.end", MELEE_ATK_DURATION);
		SetLocal("reg.attack.callback", "dmgup5");
		SetLocal("reg.attack.noise", MELEE_NOISE);
		SetLocal("reg.attack.chargeamt", "500%");
		SetLocal("reg.attack.reqskill", 30);
		SetLocal("reg.attack.mpdrain", MP_REQ5);
		RegisterAttack();
	}

	// dmgup1_start
	void OnDmgup1Start()
	{
		ConsoleMessage(ENT_OWNER, "darksword_Charge1");

		Effect("glow", ENT_OWNER, Vector3(255, 255, 255), 64, 1, 1);
		LOOP_SOUND = 1.0f;
		OnPlaySoundLoop();
		OnAtkAnim(MP_REQ1, "I");
	}

	// dmgup2_start
	void OnDmgup2Start()
	{
		ConsoleMessage(ENT_OWNER, "darksword_Charge2");

		Effect("glow", ENT_OWNER, Vector3(255, 255, 255), 96, 1, 1);
		LOOP_SOUND = 2.0f;
		OnPlaySoundLoop();
		OnAtkAnim(MP_REQ2, "II");
	}

	// dmgup3_start
	void OnDmgup3Start()
	{
		ConsoleMessage(ENT_OWNER, "darksword_Charge3");

		Effect("glow", ENT_OWNER, Vector3(255, 255, 255), 128, 1, 1);
		LOOP_SOUND = 3.0f;
		OnPlaySoundLoop();
		OnAtkAnim(MP_REQ3, "III");
	}

	// dmgup4_start
	void OnDmgup4Start()
	{
		ConsoleMessage(ENT_OWNER, "darksword_Charge4");

		Effect("glow", ENT_OWNER, Vector3(255, 255, 255), 256, 1, 1);
		LOOP_SOUND = 4.0f;
		OnPlaySoundLoop();
		PlaySound(Int(Eval("const.snd.weapon")), Eval("const.snd.maxvol"), SPECIAL01_SND);
		OnAtkAnim(MP_REQ4, "IV");
	}

	// dmgup5_start
	void OnDmgup5Start()
	{
		ConsoleMessage(ENT_OWNER, "darksword_Charge5");

		Effect("glow", ENT_OWNER, Vector3(255, 0, 0), 512, 1, 1);
		LOOP_SOUND = 5.0f;
		OnPlaySoundFull();
		PlaySound(Int(Eval("const.snd.weapon")), Eval("const.snd.maxvol"), SPECIAL01_SND);
		OnAtkAnim(MP_REQ5, "V");
	}

	// atk_anim
	void OnAtkAnim(int mpRequired = 0, string rankLabel = "")
	{
		if (ManaOf(ENT_OWNER) < mpRequired)
			PlayerMessageDark(ENT_OWNER, "Dark Sword: Not enough MP for Soul Pierce " + rankLabel);
		if (!(ManaOf(ENT_OWNER) >= mpRequired))
			return;
		PlayItemViewAnim(ENT_ME, 2);
		if (PLAYERANIM_SWING != "PLAYERANIM_SWING")
			PlayOwnerAnim("once", PLAYERANIM_SWING, "global.anim.combatwalk", 3);
		CallEventDelayed(MELEE_SOUND_DELAY, "melee_playsound");
	}

	// play_sound_loop
	void OnPlaySoundLoop()
	{
		LOOP_SOUND -= 1.0f;
		PlaySound(0, 5, "magic/spawn.wav");
		if (!(LOOP_SOUND > 0.0f))
			return;
		CallEventDelayed(0.25f, "play_sound_loop");
	}

	// play_sound_full
	void OnPlaySoundFull()
	{
		PlaySound(0, 10, "magic/spawn_loud.wav");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons1.mdl");
		Precache("viewmodels/v_1hswords.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "atk_anim") { OnAtkAnim(Int(Param(params, 0)), Param(params, 1)); return true; }
		if (name == "dmgup1_start") { OnDmgup1Start(); return true; }
		if (name == "dmgup2_start") { OnDmgup2Start(); return true; }
		if (name == "dmgup3_start") { OnDmgup3Start(); return true; }
		if (name == "dmgup4_start") { OnDmgup4Start(); return true; }
		if (name == "dmgup5_start") { OnDmgup5Start(); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "play_sound_full") { OnPlaySoundFull(); return true; }
		if (name == "play_sound_loop") { OnPlaySoundLoop(); return true; }
		if (name == "register_charge1") { OnRegisterCharge1(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return SwordsBaseOnehandedScript::DispatchEvent(name, params);
	}
}
