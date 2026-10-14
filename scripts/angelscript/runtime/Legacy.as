#pragma context server

// Helpers used by converted MS-Script code. They read and write values the way the .script
// interpreter does, so converted scripts behave the same when they mix numbers and text.
//
// Everything here is `shared`: compiled once and used by every script module (shared code
// may only use other shared code, which is why ScriptEntity and the library base classes can
// call these).

// ---- Text <-> values ---------------------------------------------------------------------

shared string Text(const string &in value) { return value; }
shared string Text(int value) { return formatInt(value); }
shared string Text(bool value) { return value ? "1" : "0"; }

shared string Text(float value)
{
	if (value == float(int(value)))
		return formatInt(int(value));
	return formatFloat(value, "", 0, 2);
}

// "(x,y,z)", the format .script uses for vectors
shared string Text(const Vector3 &in value)
{
	return "(" + Text(value.x) + "," + Text(value.y) + "," + Text(value.z) + ")";
}

// atoi: the leading integer of the text, 0 if there is none
shared int Int(const string &in text)
{
	return int(parseFloat(text));
}

// atof: the leading number of the text, 0 if there is none
shared float Float(const string &in text)
{
	return float(parseFloat(text));
}

// `if X` in .script: true when the text starts with a non-zero integer
shared bool Truthy(const string &in text)
{
	return Int(text) != 0;
}

// "(x,y,z)" or "(x,y)" to a vector; anything else is (0,0,0)
shared Vector3 Vec(const string &in text)
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

shared bool StartsWith(const string &in text, const string &in prefix)
{
	return text.findFirst(prefix) == 0;
}

shared bool Contains(const string &in text, const string &in part)
{
	return text.findFirst(part) >= 0;
}

// ---- Arithmetic as the math commands do it -----------------------------------------------

// capvar: kept within [low, high] (floats, like every math command)
shared float Clamp(float value, float low, float high)
{
	return value < low ? low : (value > high ? high : value);
}

// divide: dividing by zero leaves the value unchanged
shared float Divide(float value, float divisor)
{
	return divisor == 0 ? value : value / divisor;
}

// mod is an integer remainder; by zero leaves the value unchanged
shared float Modulo(float value, float divisor)
{
	int d = int(divisor);
	return d == 0 ? value : float(int(value) % d);
}

// ---- `;`-separated token lists ------------------------------------------------------------

// The engine stops at the first empty entry ("a;;b" is one entry)
shared array<string>@ Tokens(const string &in list)
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

shared string JoinTokens(const array<string> &in tokens)
{
	return join(tokens, ";");
}

shared string TokenAdd(const string &in list, const string &in value)
{
	return list.isEmpty() ? value : list + ";" + value;
}

// token.del: unchanged when the index is out of range
shared string TokenRemove(const string &in list, int index)
{
	array<string>@ tokens = Tokens(list);
	if (index < 0 || index >= int(tokens.length()))
		return list;
	tokens.removeAt(index);
	return JoinTokens(tokens);
}

// token.set: unchanged when the index is out of range
shared string TokenSet(const string &in list, int index, const string &in value)
{
	array<string>@ tokens = Tokens(list);
	if (index < 0 || index >= int(tokens.length()))
		return list;
	tokens[index] = value;
	return JoinTokens(tokens);
}

// token.scramble: shuffled, with a trailing ";" like the engine writes it
shared string TokenShuffle(const string &in list)
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

// Parameter <index> of an event (counting from 0)
shared string Param(const array<string> &in params, uint index)
{
	// a parameter the caller did not pass is empty (scripts test that with isEmpty())
	return index < params.length() ? params[index] : "";
}

// `return` adds to the entity's result; several returns are separated by ";"
shared string AppendResult(const string &in result, const string &in value)
{
	return result.isEmpty() ? value : result + ";" + value;
}

// vectorset <var> x|y|z <value> on a variable that holds vector text
shared Vector3 WithX(const Vector3 &in value, float x) { return Vector3(x, value.y, value.z); }
shared Vector3 WithY(const Vector3 &in value, float y) { return Vector3(value.x, y, value.z); }
shared Vector3 WithZ(const Vector3 &in value, float z) { return Vector3(value.x, value.y, z); }

// vectormultiply <var> <vector>: multiplies component by component
shared Vector3 Scale(const Vector3 &in value, const Vector3 &in factors)
{
	return Vector3(value.x * factors.x, value.y * factors.y, value.z * factors.z);
}

// ---- Menus ----------------------------------------------------------------------------------

// The reg.mitem.* values that menuitem.register reads (see RegisterMenuItem)
shared class MenuItem
{
	string id;
	string title;
	string type;       // callback, disabled, ...
	string data;       // passed to the callback
	string callback;   // event run when the item is chosen
	string cb_failed;  // event run when it can't be chosen
	string priority;
}
