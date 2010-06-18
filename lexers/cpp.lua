-- Copyright 2006-2010 Mitchell Foral mitchell<att>caladbolg.net. See LICENSE.
-- C/C++ LPeg Lexer

local l = lexer
local token, style, color, word_match = l.token, l.style, l.color, l.word_match
local P, R, S = l.lpeg.P, l.lpeg.R, l.lpeg.S

module(...)

local ws = token('whitespace', l.space^1)

-- comments
local line_comment = '//' * l.nonnewline_esc^0
local block_comment = '/*' * (l.any - '*/')^0 * P('*/')^-1
local comment = token('comment', line_comment + block_comment)

-- strings
local sq_str = P('L')^-1 * l.delimited_range("'", '\\', true, false, '\n')
local dq_str = P('L')^-1 * l.delimited_range('"', '\\', true, false, '\n')
local string = token('string', sq_str + dq_str)

-- numbers
local number = token('number', l.float + l.integer)

-- preprocessor
local preproc_word = word_match {
  'define', 'elif', 'else', 'endif', 'error', 'if', 'ifdef', 'ifndef', 'import',
  'include', 'line', 'pragma', 'undef', 'using', 'warning'
}
local preproc =
  token('preprocessor', #P('#') * l.starts_line('#' * S('\t ')^0 *
        preproc_word * (l.nonnewline_esc^0 + S('\t ') * l.nonnewline_esc^0)))

-- keywords
local keyword = token('keyword', word_match {
  -- C
  'asm', 'auto', 'break', 'case', 'const', 'continue', 'default', 'do', 'else',
  'extern', 'false', 'for', 'goto', 'if', 'inline', 'register', 'return',
  'sizeof', 'static', 'switch', 'true', 'typedef', 'volatile', 'while',
  'restrict', '_Bool', '_Complex', '_Pragma', '_Imaginary',
  -- C++
  'catch', 'class', 'const_cast', 'delete', 'dynamic_cast', 'explicit',
  'export', 'friend', 'mutable', 'namespace', 'new', 'operator', 'private',
  'protected', 'public', 'signals', 'slots', 'reinterpret_cast',
  'static_assert', 'static_cast', 'template', 'this', 'throw', 'try', 'typeid',
  'typename', 'using', 'virtual'
})

-- types
local type = token('type', word_match {
  'bool', 'char', 'double', 'enum', 'float', 'int', 'long', 'short', 'signed',
  'struct', 'union', 'unsigned', 'void'
})

-- identifiers
local identifier = token('identifier', l.word)

-- operators
local operator = token('operator', S('+-/*%<>!=^&|?~:;.()[]{}'))

_rules = {
  { 'whitespace', ws },
  { 'keyword', keyword },
  { 'type', type },
  { 'identifier', identifier },
  { 'string', string },
  { 'comment', comment },
  { 'number', number },
  { 'preproc', preproc },
  { 'operator', operator },
  { 'any_char', l.any_char },
}
