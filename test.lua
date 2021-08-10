#!/bin/lu9

insp = require "inspect"
local attrdb = require "attrdb"

local teststring = {
	[[unquoted]],
	
	[[""]],
	[["string"]],
	[["string with spaces"]],
	
	[['single quote ('')']],
	[["double quote ("")"]],
	
	[['outer single quote ('') (")']],
	[["outer double quote (') ("")"]],
	
	[["multiline
strings
work"]],
	
	[['("'') mix']],
}

local testpair = {
	[[novalue=]],
	[["long key no value"=]],
	[[key=value]],
	[["long key"="long value"]],
	[["multiline
	key"="multiline
	value"]],
	
	[[=nokey]],
	[[=]],
}

local testentry = {
	[[key=value k=v]],
[[
key=value
	newline=nl
]],
[[
k1=v1		"k2"="v2"
	newline=nl
	another="newline is here"
nextentry=
]],
[[
k1=v1 
	continuation=
	
	even=this
]],
[[
k=v		k2=v2	 
 cont=space
	cont=tab
			many=tabs
next=entry
]],
[[
k=v
next=entry
]]
}

local testdb = {
[[

nick=a
	mail=a@example.com
	mail=bla@example.com preffered=
	www=http://a.example.com
	git=https://git.example.com/a
  
nick=b
	mail=b@example.com
	www=http://b.example.com
nick=c nick=C
	mail=c@example.com
	www=http://c.example.com www=http://cccc.example.com
	git=https://git.example.com/c
	

]]
}

for _, buf in ipairs(testdb) do
	local m = attrdb.Db:match(buf)
	io.write(string.format("%s\n%s\n", ln, insp(m)))
end
