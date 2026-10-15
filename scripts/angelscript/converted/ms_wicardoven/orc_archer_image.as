#pragma context server

// Converted from ms_wicardoven/orc_archer_image.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "ms_wicardoven/orc_archer_image"]
class OrcArcherImage : ScriptEntity
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Orc Lieutenant Shagul");
		SetRace("orc");
		SetInvincible(true);

		SetUniqueName("orc_a");

		SetModel("monsters/orc.mdl");
		SetSolid("none");

		SetSayTextRange(2048);

		SetModelBody(0, 3); // Body 0=naked 1=leather 2=plate 3=green-hide
		SetModelBody(1, 3); // Head 0=cap_shorthorn 1=cap_nohorn 2=buffo_skin 3=cheif_ramhorns 4=green_hood
		SetModelBody(2, 3); // Weapon 0=fist 1=axe 2=bow_weak 3=bow_strng 4=sword 5=bloodyaxe 6=sword&sheild
	}

	// say_excuse1
	void OnSayExcuse1()
	{
		string proNoun = "PRO_NOUN";
		PlayAnim("critical", "warcry");
		if (PlayerCount() == 1)
			proNoun = "He was";
		if (PlayerCount() > 1)
			proNoun = "They were";
		SayText(proNoun + " too powerful for us!");
		PlaySound(0, 10, "voices/ms_wicardoven/orca_2fmaldora1.wav");
	}

	// say_whadup
	void OnSayWhadup()
	{
		PlayAnim("hold", "deflectcounter");
		SayText("Yeah, what's up with that!?");
		PlaySound(0, 10, "voices/ms_wicardoven/orca_2fmaldora2.wav");
	}

	// die
	void OnDie()
	{
		SetIdleAnim("die_fallback");
		SetMoveAnim("die_fallback");
		PlaySound(0, 10, "voices/orc/die.wav");
		PlayAnim("hold", "die_fallback");
		Effect("glow", ENT_ME, Vector3(255, 255, 255), 200, 3, 3);
		CallEventDelayed(2.0f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME, "fade");
	}

	// face_me
	void OnFaceMe(CBaseEntity@ target = null)
	{
		SetAngle("face_origin", OriginOf(target));
		CallEventDelayed(0.1f, "straighten_up");
	}

	// straighten_up
	void OnStraightenUp()
	{
		SetAngle("face", Vector3(0, MyAngles().y, 0));
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/orc.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "die") { OnDie(); return true; }
		if (name == "face_me") { OnFaceMe(EntityParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "say_excuse1") { OnSayExcuse1(); return true; }
		if (name == "say_whadup") { OnSayWhadup(); return true; }
		if (name == "straighten_up") { OnStraightenUp(); return true; }
		return false;
	}
}
