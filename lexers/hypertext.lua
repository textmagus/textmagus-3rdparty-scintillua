-- Copyright 2006-2013 Mitchell mitchell.att.foicica.com. See LICENSE.
-- HTML LPeg lexer.

local l, token, word_match = lexer, lexer.token, lexer.word_match
local P, R, S, V = lpeg.P, lpeg.R, lpeg.S, lpeg.V

local M = {_NAME = 'hypertext'}

case_insensitive_tags = true

-- Whitespace.
local ws = token(l.WHITESPACE, l.space^1)

-- Comments.
local comment = token(l.COMMENT, '<!--' * (l.any - '-->')^0 * P('-->')^-1)

-- Strings.
local sq_str = l.delimited_range("'", '\\', true)
local dq_str = l.delimited_range('"', '\\', true)
local string = token(l.STRING, sq_str + dq_str)

-- Tags.
local number = token(l.NUMBER, l.digit^1 * P('%')^-1)
local element = token('element', word_match({
  'a', 'abbr', 'acronym', 'address', 'applet', 'area', 'b', 'base', 'basefont',
  'bdo', 'big', 'blockquote', 'body', 'br', 'button', 'caption', 'center',
  'cite', 'code', 'col', 'colgroup', 'dd', 'del', 'dfn', 'dir', 'div', 'dl',
  'dt', 'em', 'fieldset', 'font', 'form', 'frame', 'frameset', 'h1', 'h2', 'h3',
  'h4', 'h5', 'h6', 'head', 'hr', 'html', 'i', 'iframe', 'img', 'input', 'ins',
  'isindex', 'kbd', 'label', 'legend', 'li', 'link', 'map', 'menu', 'meta',
  'noframes', 'noscript', 'object', 'ol', 'optgroup', 'option', 'p', 'param',
  'pre', 'q', 'samp', 'script', 'select', 'small', 'span', 'strike', 'strong',
  'style', 'sub', 'sup', 's', 'table', 'tbody', 'td', 'textarea', 'tfoot', 'th',
  'thead', 'title', 'tr', 'tt', 'u', 'ul', 'var', 'xml'
}, nil, case_insensitive_tags)) + token('unknown_element', l.word)
local attribute = (token('attribute', ('data-' * l.alnum^1) + word_match({
  'abbr', 'accept-charset', 'accept', 'accesskey', 'action', 'align', 'alink',
  'alt', 'archive', 'axis', 'background', 'bgcolor', 'border', 'cellpadding',
  'cellspacing', 'char', 'charoff', 'charset', 'checked', 'cite', 'class',
  'classid', 'clear', 'codebase', 'codetype', 'color', 'cols', 'colspan',
  'compact', 'content', 'coords', 'data', 'datafld', 'dataformatas',
  'datapagesize', 'datasrc', 'datetime', 'declare', 'defer', 'dir', 'disabled',
  'enctype', 'event', 'face', 'for', 'frame', 'frameborder', 'headers',
  'height', 'href', 'hreflang', 'hspace', 'http-equiv', 'id', 'ismap', 'label',
  'lang', 'language', 'leftmargin', 'link', 'longdesc', 'marginwidth',
  'marginheight', 'maxlength', 'media', 'method', 'multiple', 'name', 'nohref',
  'noresize', 'noshade', 'nowrap', 'object', 'onblur', 'onchange', 'onclick',
  'ondblclick', 'onfocus', 'onkeydown', 'onkeypress', 'onkeyup', 'onload',
  'onmousedown', 'onmousemove', 'onmouseover', 'onmouseout', 'onmouseup',
  'onreset', 'onselect', 'onsubmit', 'onunload', 'profile', 'prompt',
  'readonly', 'rel', 'rev', 'rows', 'rowspan', 'rules', 'scheme', 'scope',
  'selected', 'shape', 'size', 'span', 'src', 'standby', 'start', 'style',
  'summary', 'tabindex', 'target', 'text', 'title', 'topmargin', 'type',
  'usemap', 'valign', 'value', 'valuetype', 'version', 'vlink', 'vspace',
  'width', 'text', 'password', 'checkbox', 'radio', 'submit', 'reset', 'file',
  'hidden', 'image', 'xml', 'xmlns', 'xml:lang'
}, '-:', case_insensitive_tags)) + token('unknown_attribute', l.word)) *
         (ws^0 * token(l.OPERATOR, '=') * ws^0 * (string + number))^-1
local attributes = P{attribute * (ws * V(1))^0}
local tag_start = token('tag', '<' * P('/')^-1) * element
local tag_end = token('tag', P('/')^-1 * '>')
local tag = tag_start * (ws * attributes)^0 * ws^0 * tag_end^-1

-- Words.
local word = token(l.DEFAULT, (l.any - l.space - S('<&'))^1)

-- Entities.
local entity = token('entity', '&' * (l.any - l.space - ';')^1 * ';')

-- Doctype.
local doctype = token('doctype', '<!' *
                      word_match({'doctype'}, nil, case_insensitive_tags) *
                      (l.any - '>')^1 * '>')

M._rules = {
  {'whitespace', ws},
  {'default', word},
  {'comment', comment},
  {'doctype', doctype},
  {'tag', tag},
  {'entity', entity},
  {'any_char', l.any_char},
}

M._tokenstyles = {
  {'tag', l.STYLE_KEYWORD},
  {'element', l.STYLE_KEYWORD},
  {'unknown_element', l.STYLE_KEYWORD..',italics'},
  {'attribute', l.STYLE_VARIABLE},
  {'unknown_attribute', l.STYLE_TYPE..',italics'},
  {'entity', l.STYLE_OPERATOR},
  {'doctype', l.STYLE_COMMENT},
}

-- Embedded CSS.
local css = l.load('css')
local style_element = word_match({'style'}, nil, case_insensitive_tags)
local css_start_rule = #(P('<') * style_element *
                        ('>' + P(function(input, index)
  if input:find('^[^>]+type%s*=%s*(["\'])text/css%1', index) then
    return index
  end
end))) * tag -- <style type="text/css">
local css_end_rule = #('</' * style_element * ws^0 * '>') * tag -- </style>
l.embed_lexer(M, css, css_start_rule, css_end_rule)

-- Embedded Javascript.
local js = l.load('javascript')
local script_element = word_match({'script'}, nil, case_insensitive_tags)
local js_start_rule = #(P('<') * script_element *
                       ('>' + P(function(input, index)
  if input:find('^[^>]+type%s*=%s*(["\'])text/javascript%1', index) then
    return index
  end
end))) * tag -- <script type="text/javascript">
local js_end_rule = #('</' * script_element * ws^0 * '>') * tag -- </script>
l.embed_lexer(M, js, js_start_rule, js_end_rule)

-- Embedded CoffeeScript.
local cs = l.load('coffeescript')
local script_element = word_match({'script'}, nil, case_insensitive_tags)
local cs_start_rule = #(P('<') * script_element * P(function(input, index)
  if input:find('^[^>]+type%s*=%s*(["\'])text/coffeescript%1', index) then
    return index
  end
end)) * tag -- <script type="text/coffeescript">
local cs_end_rule = #('</' * script_element * ws^0 * '>') * tag -- </script>
l.embed_lexer(M, cs, cs_start_rule, cs_end_rule)

M._foldsymbols = {
  _patterns = {'</?', '/>', '<!%-%-', '%-%->'},
  tag = {['<'] = 1, ['/>'] = -1, ['</'] = -1},
  [l.COMMENT] = {['<!--'] = 1, ['-->'] = -1}
}

return M
