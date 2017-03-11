if exists('b:did_indent')
	finish
endif

setlocal indentexpr=CabalIndent()
"TODO evoke indent after ': '
setlocal indentkeys=o,O,!^F,*<Return>
setlocal autoindent

let b:undo_indent = 'setlocal
	\ indentexpr<
	\ indentkeys<
	\ autoindent<
	\'

let s:keep_indent = -1
let s:clear_indent = 0

function! CabalIndent() abort
	let l:cur_lnum = v:lnum
	let l:cur_line = getline(l:cur_lnum)
	let l:pre_lnum = prevnonblank(v:lnum - 1)
	let l:pre_line = getline(l:pre_lnum)

	if s:is_empty(l:cur_line)
		if s:is_start_section(l:pre_line)
			return shiftwidth()
		elseif s:is_field(l:pre_line)
			return s:align_to_element(l:pre_line)
		else
			return s:keep_indent
		endif
	else
		if s:is_start_section(l:cur_line)
			return s:clear_indent
		elseif s:is_field(l:cur_line)
			if s:is_in_section(l:pre_lnum)
				return shiftwidth()
			else
				return s:clear_indent
			endif
		else
			return s:keep_indent
		endif
	endif
endfunction

function! s:is_field(line)
	return a:line =~# '\v:\s'
endfunction

function! s:is_empty(line)
	return a:line =~# '\v^\s*$'
endfunction

function! s:is_start_section(line)
	return a:line =~# '\v^\s*<%(library|executable|flag|source-repository|test-suite|benchmark)>'
endfunction

function! s:is_in_section(lnum)
	let l:i = a:lnum
	while l:i > 0
		if s:is_start_section(getline(l:i))
			return v:true
		endif

		let l:i = prevnonblank(l:i - 1)
	endwhile

	return v:false
endfunction

function! s:align_to_element(line)
	return matchend(a:line, '\v:\s+')
endfunction

let b:did_indent = v:true
