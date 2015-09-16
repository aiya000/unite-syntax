scriptencoding utf-8

function! unite#sources#syntax#define()
	return [s:source, s:source_new]
endfunction


function! s:syntaxes()
	let s:syntaxes_cache = get(s:, 'syntaxes_cache', unite#util#uniq(map(
	\	split(globpath(&runtimepath, 'syntax/**/*.vim'), "\n"),
	\	'fnamemodify(v:val, ":t:r")')))
	return copy(s:syntaxes_cache)
endfunction

let s:source = {
\	'name'           : 'syntax',
\	'description'    : 'diplay all syntaxes and set the syntax',
\	'default_action' : 'set_syntax',
\	'action_table'   : {
\		'set_syntax' : {
\			'description'   : 'set syntax=',
\			'is_selectable' : 0
\		}
\	}
\}


function! s:source.action_table.set_syntax.func(candidate)
	let bufnr = get(unite#get_current_unite(), 'prev_bufnr', bufnr('%'))
	call setbufvar(bufnr, '&syntax', a:candidate.action_syntax)
endfunction

function! s:source.change_candidates(args, context)
	return map(s:syntaxes(), '{"word" : v:val, "action_syntax" : v:val}')
endfunction

let s:source_new = deepcopy(s:source)
let s:source_new.name = 'syntax/new'

function! s:source_new.change_candidates(args, context)
	return ((a:context.input != '' && index(s:syntaxes(), a:context.input) < 0)
	\	? [{
	\		'word'          : '[new syntax] ' . a:context.input,
	\		'action_syntax' : a:context.input
	\	}]
	\	: []
	\)
endfunction
