-- Copyright 2006-2010 Mitchell mitchell<att>caladbolg.net. See LICENSE.
-- TCL LPeg lexer

local l = lexer
local token, style, color, word_match = l.token, l.style, l.color, l.word_match
local P, R, S = l.lpeg.P, l.lpeg.R, l.lpeg.S

module(...)

local ws = token('whitespace', l.space^1)

-- comments
local comment = token('comment', '#' * l.nonnewline^0)

-- strings
local sq_str = l.delimited_range("'", '\\', true, false, '\n')
local dq_str = l.delimited_range('"', '\\', true, false, '\n')
local regex = l.delimited_range('/', '\\', false, false, '\n')
local string = token('string', sq_str + dq_str + regex)

-- numbers
local number = token('number', l.float + l.integer)

-- keywords
local keyword = token('keyword', word_match {
  'string', 'subst', 'regexp', 'regsub', 'scan', 'format', 'binary', 'list',
  'split', 'join', 'concat', 'llength', 'lrange', 'lsearch', 'lreplace',
  'lindex', 'lsort', 'linsert', 'lrepeat', 'dict', 'if', 'else', 'elseif',
  'then', 'for', 'foreach', 'switch', 'case', 'while', 'continue', 'return',
  'break', 'catch', 'error', 'eval', 'uplevel', 'after', 'update', 'vwait',
  'proc', 'rename', 'set', 'lset', 'lassign', 'unset', 'namespace', 'variable',
  'upvar', 'global', 'trace', 'array', 'incr', 'append', 'lappend', 'expr',
  'file', 'open', 'close', 'socket', 'fconfigure', 'puts', 'gets', 'read',
  'seek', 'tell', 'eof', 'flush', 'fblocked', 'fcopy', 'fileevent', 'source',
  'load', 'unload', 'package', 'info', 'interp', 'history', 'bgerror',
  'unknown', 'memory', 'cd', 'pwd', 'clock', 'time', 'exec', 'glob', 'pid',
  'exit'
})

-- identifiers
local identifier = token('identifier', l.word)

-- variables
local variable = token('variable', S('$@') * P('$')^-1 * l.word)

-- operators
local operator = token('operator', S('<>=+-*/!@|&.,:;?()[]{}'))

_rules = {
  { 'whitespace', ws },
  { 'keyword', keyword },
  { 'identifier', identifier },
  { 'string', string },
  { 'comment', comment },
  { 'number', number },
  { 'variable', variable },
  { 'operator', operator },
  { 'any_char', l.any_char },
}
