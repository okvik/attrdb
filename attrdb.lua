local attrdb = {}

local lpeg = require "lpeg"

local P, B, R, S, V = lpeg.P, lpeg.B, lpeg.R, lpeg.S, lpeg.V
local C, Carg, Cb, Cc, Cf, Cg, Cp, Cs, Ct, Cmt = lpeg.C, lpeg.Carg, lpeg.Cb, lpeg.Cc, lpeg.Cf, lpeg.Cg, lpeg.Cp, lpeg.Cs, lpeg.Ct, lpeg.Cmt

local NL = P '\n'
local Space = S ' \t'
local Quote = S [['"]]
local Special = Space + Quote + NL + '='

local Openquote = Cg(Quote, "quote")
local Escquote = Cmt(
	C(Quote) * C(Quote) * Cb("quote"),
	function(s, pos, q1, q2, oq)
		if q1 == oq and q2 == oq then
			return true, oq
		end
	end
)
local Closequote = Cmt(
	C(Quote) * Cb("quote"),
	function(s, pos, q1, oq)
		return q1 == oq
	end
)
local Word = (1 - Special)^1
local Quoted = Cs(((P(1) - Closequote) + Escquote)^0)
local String = Cg(Word)
             + Openquote * Cg(Quoted) * Closequote
String = String / 1

local Pair = Ct(String * '=' * String^-1)

local Line = Ct(Pair * (Space^1 * Pair)^0)
local Entry = Ct(Line * (NL * Space^1 * Line)^0)
local Dbspace = NL + Space
local Db = Ct(Dbspace^0 * Entry * (Dbspace^1 * Entry)^0)

attrdb.String = String
attrdb.Pair = Pair
attrdb.Entry = Entry
attrdb.Db = Db

return attrdb
