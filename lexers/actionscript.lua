-- Copyright 2006-2010 Mitchell mitchell<att>caladbolg.net. See LICENSE.
-- Actionscript LPeg lexer

local l = lexer
local token, style, color, word_match = l.token, l.style, l.color, l.word_match
local P, R, S = l.lpeg.P, l.lpeg.R, l.lpeg.S

module(...)

local ws = token('whitespace', l.space^1)

-- comments
local line_comment = '//' * l.nonnewline^0
local block_comment = '/*' * (l.any - '*/')^0 * '*/'
local comment = token('comment', line_comment + block_comment)

-- strings
local sq_str = l.delimited_range("'", '\\', true, false, '\n')
local dq_str = l.delimited_range('"', '\\', true, false, '\n')
local ml_str = '<![CDATA[' * (l.any - ']]>')^0 * ']]>'
local string = token('string', sq_str + dq_str + ml_str)

-- numbers
local number = token('number', (l.float + l.integer) * S('LlUuFf')^-2)

-- keywords
local keyword = token('keyword', word_match {
  'break', 'continue', 'delete', 'do', 'else', 'for', 'function', 'if', 'in',
  'new', 'on', 'return', 'this', 'typeof', 'var', 'void', 'while', 'with',
  'NaN', 'Infinity', 'false', 'null', 'true', 'undefined',
  -- reserved for future use
  'abstract', 'case', 'catch', 'class', 'const', 'debugger', 'default',
  'export', 'extends', 'final', 'finally', 'goto', 'implements', 'import',
  'instanceof', 'interface', 'native', 'package', 'private', 'Void',
  'protected', 'public', 'dynamic', 'static', 'super', 'switch', 'synchonized',
  'throw', 'throws', 'transient', 'try', 'volatile'
})

-- types
local type = token('type', word_match {
  'Array', 'Boolean', 'Color', 'Date', 'Function', 'Key', 'MovieClip', 'Math',
  'Mouse', 'Number', 'Object', 'Selection', 'Sound', 'String', 'XML', 'XMLNode',
  'XMLSocket',
  -- reserved for future use
  'boolean', 'byte', 'char', 'double', 'enum', 'float', 'int', 'long', 'short'
})

-- identifiers
local identifier = token('identifier', l.word)

-- operators
local operator = token('operator', S('=!<>+-/*%&|^~.,;?()[]{}'))

_rules = {
  { 'whitespace', ws },
  { 'keyword', keyword },
  { 'type', type },
  { 'identifier', identifier },
  { 'string', string },
  { 'comment', comment },
  { 'number', number },
  { 'operator', operator },
  { 'any_char', l.any_char },
}
