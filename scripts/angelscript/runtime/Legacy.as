#pragma context server

// Helpers used by converted MS-Script code. They read and write values the way the .script
// interpreter does, so converted scripts behave the same when they mix numbers and text.

// ---- Entity names the engine resolves relative to the calling entity ----------------------
const string ENT_ME = "ent_me";
const string ENT_OWNER = "ent_owner";
const string ENT_TARGET = "ent_target";
const string ENT_LASTSEEN = "ent_lastseen";
const string ENT_LASTHEARD = "ent_lastheard";
const string ENT_LASTSPOKE = "ent_lastspoke";
const string ENT_LASTOFFERED = "ent_lastoffered";
const string ENT_LASTGAVE = "ent_lastgave";
const string ENT_LASTSTOLE = "ent_laststole";
const string ENT_LASTUSED = "ent_lastused";
const string ENT_LASTSTRUCK = "ent_laststruck";
const string ENT_LASTSTRUCKBYME = "ent_laststruckbyme";
const string ENT_LASTPROJECTILE = "ent_lastprojectile";
const string ENT_LASTCREATED = "ent_lastcreated";
const string ENT_CREATIONOWNER = "ent_creationowner";
const string ENT_EXPOWNER = "ent_expowner";
const string ENT_LOCALPLAYER = "ent_localplayer";
const string ENT_CURRENTPLAYER = "ent_currentplayer";

// ---- Text <-> values ---------------------------------------------------------------------

string Text(const string &in value) { return value; }
string Text(int value) { return formatInt(value); }
string Text(bool value) { return value ? "1" : "0"; }

string Text(float value)
{
	if (value == float(int(value)))
		return formatInt(int(value));
	return formatFloat(value, "", 0, 2);
}

// "(x,y,z)", the format .script uses for vectors
string Text(const Vector3 &in value)
{
	return "(" + Text(value.x) + "," + Text(value.y) + "," + Text(value.z) + ")";
}

// atoi: the leading integer of the text, 0 if there is none
int Int(const string &in text)
{
	return int(parseFloat(text));
}

// atof: the leading number of the text, 0 if there is none
float Float(const string &in text)
{
	return float(parseFloat(text));
}

// `if X` in .script: true when the text starts with a non-zero integer
bool Truthy(const string &in text)
{
	return Int(text) != 0;
}

// "(x,y,z)" or "(x,y)" to a vector; anything else is (0,0,0)
Vector3 Vec(const string &in text)
{
	int open = text.findFirst("(");
	int close = text.findFirst(")", open + 1);
	if (open < 0 || close < 0)
		return Vector3();
	array<string>@ parts = text.substr(open + 1, close - open - 1).split(",");
	Vector3 result;
	if (parts.length() > 0) result.x = Float(parts[0]);
	if (parts.length() > 1) result.y = Float(parts[1]);
	if (parts.length() > 2) result.z = Float(parts[2]);
	return result;
}

// ---- Comparisons ---------------------------------------------------------------------------

bool StartsWith(const string &in text, const string &in prefix)
{
	return text.findFirst(prefix) == 0;
}

bool Contains(const string &in text, const string &in part)
{
	return text.findFirst(part) >= 0;
}

// ---- Arithmetic as the math commands do it -----------------------------------------------

float Clamp(float value, float low, float high)
{
	return value < low ? low : (value > high ? high : value);
}

int Clamp(int value, int low, int high)
{
	return value < low ? low : (value > high ? high : value);
}

// divide: dividing by zero leaves the value unchanged
float Divide(float value, float divisor)
{
	return divisor == 0 ? value : value / divisor;
}

// mod is an integer remainder; by zero leaves the value unchanged
float Modulo(float value, float divisor)
{
	int d = int(divisor);
	return d == 0 ? value : float(int(value) % d);
}

// ---- `;`-separated token lists ------------------------------------------------------------

// The engine stops at the first empty entry ("a;;b" is one entry)
array<string>@ Tokens(const string &in list)
{
	array<string> result;
	array<string>@ parts = list.split(";");
	for (uint i = 0; i < parts.length(); i++)
	{
		if (parts[i].isEmpty())
			break;
		result.insertLast(parts[i]);
	}
	return result;
}

string JoinTokens(const array<string> &in tokens)
{
	return join(tokens, ";");
}

string TokenAdd(const string &in list, const string &in value)
{
	return list.isEmpty() ? value : list + ";" + value;
}

// token.del: unchanged when the index is out of range
string TokenRemove(const string &in list, int index)
{
	array<string>@ tokens = Tokens(list);
	if (index < 0 || index >= int(tokens.length()))
		return list;
	tokens.removeAt(index);
	return JoinTokens(tokens);
}

// token.set: unchanged when the index is out of range
string TokenSet(const string &in list, int index, const string &in value)
{
	array<string>@ tokens = Tokens(list);
	if (index < 0 || index >= int(tokens.length()))
		return list;
	tokens[index] = value;
	return JoinTokens(tokens);
}

// token.scramble: shuffled, with a trailing ";" like the engine writes it
string TokenShuffle(const string &in list)
{
	array<string>@ tokens = Tokens(list);
	string result;
	while (tokens.length() > 0)
	{
		int pick = RandomInt(0, tokens.length() - 1);
		result += tokens[pick] + ";";
		tokens.removeAt(pick);
	}
	return result;
}

// ---- Event plumbing -------------------------------------------------------------------------

// Parameter <index> of an event, "" when the caller passed fewer
string Param(const array<string> &in params, uint index)
{
	return index < params.length() ? params[index] : "";
}

// `return` adds to the entity's result; several returns are separated by ";"
string AppendResult(const string &in result, const string &in value)
{
	return result.isEmpty() ? value : result + ";" + value;
}
