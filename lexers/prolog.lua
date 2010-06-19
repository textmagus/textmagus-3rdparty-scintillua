-- Copyright 2006-2010 Mitchell Foral mitchell<att>caladbolg.net. See LICENSE.
-- Prolog LPeg lexer

local l = lexer
local token, style, color, word_match = l.token, l.style, l.color, l.word_match
local P, R, S = l.lpeg.P, l.lpeg.R, l.lpeg.S

module(...)

local ws = token('whitespace', l.space^1)

-- comments
local line_comment = '%' * l.nonnewline^0
local block_comment = '/*' * (l.any - '*/')^0 * '*/'
local comment = token('comment', line_comment + block_comment)

-- strings
local sq_str = l.delimited_range("'", '\\', true, false, '\n')
local dq_str = l.delimited_range('"', '\\', true, false, '\n')
local string = token('string', sq_str + dq_str)

-- numbers
local number = token('number', l.digit^1 * ('.' * l.digit^1)^-1)

-- keywords
local keyword = token('keyword', word_match {
  'module', 'meta_predicate', 'multifile', 'dynamic', 'abolish',
  'current_output', 'peek_code', 'append', 'current_predicate', 'put_byte',
  'arg', 'current_prolog_flag', 'put_char', 'asserta', 'assert', 'fail',
  'put_code', 'assertz', 'findall', 'read', 'at_end_of_stream', 'float',
  'read_term', 'atom', 'flush_output', 'repeat', 'atom_chars', 'functor',
  'retract', 'atom_codes', 'get_byte', 'set_input', 'atom_concat', 'get_char',
  'set_output', 'atom_length', 'get_code', 'set_prolog_flag', 'atomic', 'halt',
  'set_stream_position', 'bagof', 'integer', 'setof', 'call', 'is',
  'stream_property', 'catch', 'nl', 'sub_atom', 'char_code', 'nonvar', 'throw',
  'char_conversion', 'number', 'clause', 'number_chars',
  'unify_with_occurs_check', 'close', 'number_codes', 'var', 'compound', 'once',
  'copy_term', 'op', 'write', 'writeln', 'write_canonical', 'write_term',
  'writeq', 'current_char_conversion', 'open', 'current_input', 'peek_byte',
  'current_op', 'peek_char', 'false', 'true', 'consult', 'member', 'memberchk',
  'reverse', 'permutation', 'delete',
  -- math
  'mod', 'div', 'abs', 'exp', 'ln', 'log', 'sqrt', 'round', 'trunc', 'val',
  'cos', 'sin', 'tan', 'arctan', 'random', 'randominit'
})

-- identifiers
local identifier = token('identifier', l.word)

-- operators
local operator = token('operator', S('-!+\\|=:;&<>()[]{}'))

_rules = {
  { 'whitespace', ws },
  { 'keyword', keyword },
  { 'identifier', identifier },
  { 'string', string },
  { 'comment', comment },
  { 'number', number },
  { 'operator', operator },
  { 'any_char', l.any_char },
}