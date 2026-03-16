# Snapshot file
# Unset all aliases to avoid conflicts with functions
unalias -a 2>/dev/null || true
# Functions
→chroma/-alias.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-autoload.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-autorandr.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-awk.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-docker.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-example.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-fast-theme.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-fpath_peq.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-git.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-grep.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-hub.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-ionice.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-lab.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-make.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-nice.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-nmcli.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-node.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-ogit.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-perl.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-precommand.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-printf.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-ruby.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-scp.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-sh.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-source.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-ssh.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-subcommand.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-subversion.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-vim.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-whatis.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-which.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/-zinit.ch () {
	# undefined
	builtin autoload -XUz
}
→chroma/main-chroma.ch () {
	# undefined
	builtin autoload -XUz
}
-fast-highlight-check-path () {
	(( _start_pos-__PBUFLEN >= 0 )) || {
		[[ $1 != "noasync" ]] && print -r -- "- $_start_pos $_end_pos"
		return 1
	}
	[[ $1 != "noasync" ]] && {
		print -r -- ${sysparams[pid]}
		print -r -- $__arg
	}
	: ${expanded_path:=${(Q)~__arg}}
	[[ -n ${FAST_BLIST_PATTERNS[(k)${${(M)expanded_path:#/*}:-$PWD/$expanded_path}]} ]] && {
		[[ $1 != "noasync" ]] && print -r -- "- $_start_pos $_end_pos"
		return 1
	}
	[[ -z $expanded_path ]] && {
		[[ $1 != "noasync" ]] && print -r -- "- $_start_pos $_end_pos"
		return 1
	}
	[[ -d $expanded_path ]] && {
		[[ $1 != "noasync" ]] && print -r -- "$_start_pos ${_end_pos}D" || __style=${FAST_THEME_NAME}path-to-dir 
		return 0
	}
	[[ -e $expanded_path ]] && {
		[[ $1 != "noasync" ]] && print -r -- "$_start_pos $_end_pos" || __style=${FAST_THEME_NAME}path 
		return 0
	}
	[[ $active_command = "cd" ]] && for cdpath_dir in $cdpath
	do
		[[ -d $cdpath_dir/$expanded_path ]] && {
			[[ $1 != "noasync" ]] && print -r -- "$_start_pos ${_end_pos}D" || __style=${FAST_THEME_NAME}path-to-dir 
			return 0
		}
		[[ -e $cdpath_dir/$expanded_path ]] && {
			[[ $1 != "noasync" ]] && print -r -- "$_start_pos $_end_pos" || __style=${FAST_THEME_NAME}path 
			return 0
		}
	done
	[[ $1 != "noasync" ]] && print -r -- "- $_start_pos $_end_pos"
	return 1
}
-fast-highlight-check-path-handler () {
	local IFS=$'\n' pid PCFD=$1 line stripped val 
	integer idx
	if read -r -u $PCFD pid
	then
		if read -r -u $PCFD val
		then
			if read -r -u $PCFD line
			then
				stripped=${${line#- }%D} 
				FAST_HIGHLIGHT[cache-path-${(q)val}-${stripped%% *}-born-at]=$EPOCHSECONDS 
				idx=${${FAST_HIGHLIGHT[path-queue]}[(I)$stripped]} 
				(( idx > 0 )) && {
					if [[ $line != -* ]]
					then
						FAST_HIGHLIGHT[cache-path-${(q)val}-${stripped%% *}]="1${(M)line%D}" 
						region_highlight+=("${line%% *} ${${line##* }%D} ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}path${${(M)line%D}:+-to-dir}]}") 
					else
						FAST_HIGHLIGHT[cache-path-${(q)val}-${stripped%% *}]=0 
					fi
					val=${FAST_HIGHLIGHT[path-queue]} 
					val[idx-1,idx+${#stripped}]="" 
					FAST_HIGHLIGHT[path-queue]=$val 
					[[ ${FAST_HIGHLIGHT[cache-path-${(q)val}-${stripped%% *}]%D} = 1 && ${#val} -le 27 ]] && zle -R
				}
			fi
		fi
		kill -9 $pid 2> /dev/null
	fi
	zle -F -w ${PCFD}
	exec {PCFD}<&-
}
-fast-highlight-dollar-string () {
	(( _start_pos-__PBUFLEN >= 0 )) || return 0
	local i j k __style
	local AA
	integer c
	for ((i = 3 ; i < _end_pos - _start_pos ; i += 1 )) do
		(( j = i + _start_pos - 1 ))
		(( k = j + 1 ))
		case ${__arg[$i]} in
			("\\") __style=${FAST_THEME_NAME}back-dollar-quoted-argument 
				for ((c = i + 1 ; c <= _end_pos - _start_pos ; c += 1 )) do
					[[ ${__arg[$c]} != ([0-9xXuUa-fA-F]) ]] && break
				done
				AA=$__arg[$i+1,$c-1] 
				if [[ "$AA" == (#m)(#s)(x|X)[0-9a-fA-F](#c1,2) || "$AA" == (#m)(#s)[0-7](#c1,3) || "$AA" == (#m)(#s)u[0-9a-fA-F](#c1,4) || "$AA" == (#m)(#s)U[0-9a-fA-F](#c1,8) ]]
				then
					(( k += MEND ))
					(( i += MEND ))
				else
					if (( __asize > i+1 )) && [[ $__arg[i+1] == [xXuU] ]]
					then
						__style=${FAST_THEME_NAME}unknown-token 
					fi
					(( k += 1 ))
					(( i += 1 ))
				fi ;;
			(*) continue ;;
		esac
		(( __start=j-__PBUFLEN, __end=k-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[$__style]}") 
	done
}
-fast-highlight-fill-option-variables () {
	if [[ -o ignore_braces ]] || eval '[[ -o ignore_close_braces ]] 2>/dev/null'
	then
		FAST_HIGHLIGHT[right_brace_is_recognised_everywhere]=0 
	else
		FAST_HIGHLIGHT[right_brace_is_recognised_everywhere]=1 
	fi
	if [[ -o path_dirs ]]
	then
		FAST_HIGHLIGHT[path_dirs_was_set]=1 
	else
		FAST_HIGHLIGHT[path_dirs_was_set]=0 
	fi
	if [[ -o multi_func_def ]]
	then
		FAST_HIGHLIGHT[multi_func_def]=1 
	else
		FAST_HIGHLIGHT[multi_func_def]=0 
	fi
	if [[ -o interactive_comments ]]
	then
		FAST_HIGHLIGHT[ointeractive_comments]=1 
	else
		FAST_HIGHLIGHT[ointeractive_comments]=0 
	fi
}
-fast-highlight-init () {
	_FAST_COMPLEX_BRACKETS=() 
	__fast_highlight_main__command_type_cache=() 
}
-fast-highlight-main-type () {
	REPLY=$__fast_highlight_main__command_type_cache[(e)$1] 
	[[ -z $REPLY ]] && {
		if zmodload -e zsh/parameter
		then
			if (( $+aliases[(e)$1] ))
			then
				REPLY=alias 
			elif (( ${+galiases[(e)${(Q)1}]} ))
			then
				REPLY="global alias" 
			elif (( $+functions[(e)$1] ))
			then
				REPLY=function 
			elif (( $+builtins[(e)$1] ))
			then
				REPLY=builtin 
			elif (( $+commands[(e)$1] ))
			then
				REPLY=command 
			elif (( $+saliases[(e)${1##*.}] ))
			then
				REPLY='suffix alias' 
			elif (( $reswords[(Ie)$1] ))
			then
				REPLY=reserved 
			elif [[ $1 != */* || ${+ZSH_ARGZERO} = "1" ]] && ! builtin type -w -- $1 > /dev/null 2>&1
			then
				REPLY=none 
			fi
		fi
		[[ -z $REPLY ]] && REPLY="${$(LC_ALL=C builtin type -w -- $1 2>/dev/null)##*: }" 
		[[ $REPLY = "none" ]] && {
			[[ -n ${FAST_BLIST_PATTERNS[(k)${${(M)1:#/*}:-$PWD/$1}]} ]] || {
				[[ -d $1 ]] && REPLY="dirpath"  || {
					for cdpath_dir in $cdpath
					do
						[[ -d $cdpath_dir/$1 ]] && {
							REPLY="dirpath" 
							break
						}
					done
				}
			}
		}
		__fast_highlight_main__command_type_cache[(e)$1]=$REPLY 
	}
}
-fast-highlight-math-string () {
	(( _start_pos-__PBUFLEN >= 0 )) || return 0
	_mybuf=$__arg 
	__idx=_start_pos 
	while [[ $_mybuf = (#b)[^\$_a-zA-Z0-9]#((\$(#B)(+|)(#B)([a-zA-Z_:][a-zA-Z0-9_:]#|[0-9]##)(#b)(\[[^\]]##\])(#c0,1))|(\$[{](#B)(+|)(#b)(\([a-zA-Z0-9_:@%#]##\))(#c0,1)[a-zA-Z0-9_:#]##(\[[^\]]##\])(#c0,1)[}])|\$|[a-zA-Z_][a-zA-Z0-9_]#|[0-9]##)(*) ]]
	do
		__idx+=${mbegin[1]}-1 
		_end_idx=__idx+${mend[1]}-${mbegin[1]}+1 
		_mybuf=${match[7]} 
		[[ ${match[1]} = [0-9]* ]] && __style=${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}mathnum]}  || {
			[[ ${match[1]} = [a-zA-Z_]* ]] && {
				[[ ${+parameters[${match[1]}]} = 1 || ${FAST_ASSIGNS_SEEN[${match[1]}]} = 1 ]] && __style=${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}mathvar]}  || __style=${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}matherr]} 
			} || {
				[[ ${match[1]} = "$"* ]] && {
					match[1]=${match[1]//[\{\}+]/} 
					if [[ ${match[1]} = "$" || ${FAST_ASSIGNS_SEEN[${match[1]:1}]} = 1 ]] || {
							eval "[[ -n \${(P)\${match[1]:1}} ]]"
						} 2>> /dev/null
					then
						__style=${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}back-or-dollar-double-quoted-argument]} 
					else
						__style=${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}matherr]} 
					fi
				}
			}
		}
		[[ $__style != "none" && -n $__style ]] && (( __start=__idx-__PBUFLEN, __end=_end_idx-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end $__style") 
		__idx=_end_idx 
	done
}
-fast-highlight-process () {
	emulate -L zsh
	setopt extendedglob bareglobqual nonomatch typesetsilent
	[[ $CONTEXT == "select" ]] && return 0
	(( FAST_HIGHLIGHT[path_dirs_was_set] )) && setopt PATH_DIRS
	(( FAST_HIGHLIGHT[ointeractive_comments] )) && local interactive_comments= 
	local _start_pos=$3 _end_pos __start __end highlight_glob=1 __arg __style in_array_assignment=0 MATCH expanded_path braces_stack __buf=$1$2 _mybuf __workbuf cdpath_dir active_command alias_target _was_double_hyphen=0 __nul=$'\0' __tmp 
	integer __arg_type=0 MBEGIN MEND in_redirection __len=${#__buf} __PBUFLEN=${#1} already_added offset __idx _end_idx this_word=1 next_word=0 __pos __asize __delimited=0 itmp iitmp 
	local -a match mbegin mend __inputs __list
	integer BIT_case_preamble=512 BIT_case_item=1024 BIT_case_nempty_item=2048 BIT_case_code=4096 
	ZLAST_COMMANDS=() 
	FAST_ASSIGNS_SEEN=() 
	FAST_HIGHLIGHT[chroma-autoload-elements]="" 
	FAST_HIGHLIGHT[chroma-fpath_peq-elements]="" 
	FAST_HIGHLIGHT[chroma-zinit-ice-elements-svn]=0 
	FAST_HIGHLIGHT[chroma-zinit-ice-elements-id-as]="" 
	[[ -n $ZCALC_ACTIVE ]] && {
		_start_pos=0 
		_end_pos=__len 
		__arg=$__buf 
		-fast-highlight-math-string
		return 0
	}
	local proc_buf=$__buf needle 
	for __arg in ${interactive_comments-${(z)__buf}} ${interactive_comments+${(zZ+c+)__buf}}
	do
		(( in_redirection = in_redirection > 0 ? in_redirection - 1 : in_redirection ))
		(( next_word = (in_redirection == 0) ? 2 : next_word ))
		(( next_word = next_word | (this_word & (BIT_case_code|8192)) ))
		[[ $__arg = '{' && $__delimited = 2 ]] && {
			(( this_word = (this_word & ~2) | 1 ))
			__delimited=0 
		}
		__asize=${#__arg} 
		already_added=0 
		__style=${FAST_THEME_NAME}unknown-token 
		(( this_word & 1 )) && {
			in_array_assignment=0 
			[[ $__arg == 'noglob' ]] && highlight_glob=0 
		}
		if [[ $__arg == ';' ]]
		then
			braces_stack=${braces_stack#T} 
			__delimited=0 
			needle=$';\n' 
			[[ $proc_buf = (#b)[^$needle]#([$needle]##)* ]] && offset=${mbegin[1]}-1 
			(( _start_pos += offset ))
			(( _end_pos = _start_pos + __asize ))
			(( this_word & BIT_case_item )) || {
				(( in_array_assignment )) && (( this_word = 2 | (this_word & BIT_case_code) )) || {
					(( this_word = 1 | (this_word & BIT_case_code) ))
					highlight_glob=1 
				}
			}
			in_redirection=0 
			[[ ${proc_buf[offset+1]} != $'\n' ]] && {
				[[ ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}commandseparator]} != "none" ]] && (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}commandseparator]}") 
			}
			proc_buf=${proc_buf[offset + __asize + 1,__len]} 
			_start_pos=$_end_pos 
			continue
		else
			offset=0 
			if [[ $proc_buf = (#b)(#s)(([[:space:]]|\\[[:space:]])##)* ]]
			then
				offset=${mend[1]} 
			fi
			(( _start_pos += offset ))
			(( _end_pos = _start_pos + __asize ))
			__arg_type=${__FAST_HIGHLIGHT_TOKEN_TYPES[$__arg]} 
		fi
		(( this_word & 1 )) && ZLAST_COMMANDS+=($__arg) 
		proc_buf=${proc_buf[offset + __asize + 1,__len]} 
		if [[ -n ${interactive_comments+'set'} && $__arg == ${histchars[3]}* ]]
		then
			if (( this_word & 3 ))
			then
				__style=${FAST_THEME_NAME}comment 
			else
				__style=${FAST_THEME_NAME}unknown-token 
			fi
			(( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[$__style]}") 
			_start_pos=$_end_pos 
			continue
		fi
		[[ $__arg == (<0-9>|)(\<|\>)* && $__arg != (\<|\>)$'\x28'* && $__arg != "<<<" ]] && in_redirection=2 
		if (( ! in_redirection ))
		then
			(( this_word & 4 )) && [[ $__arg != -* ]] && (( this_word = this_word ^ 4 ))
			if (( this_word & 4 ))
			then
				case $__arg in
					('-'[Cgprtu]) (( this_word = this_word & ~1 ))
						(( next_word = 8 | (this_word & BIT_case_code) )) ;;
					('-'*) (( this_word = this_word & ~1 ))
						(( next_word = next_word | 1 | 4 )) ;;
				esac
			elif (( this_word & 8 ))
			then
				(( next_word = next_word | 4 | 1 ))
			elif (( this_word & 64 ))
			then
				[[ $__arg = -[pvV-]## && $active_command = "command" ]] && (( this_word = (this_word & ~1) | 2, next_word = (next_word | 65) & ~2 ))
				[[ $__arg = -[cla-]## && $active_command = "exec" ]] && (( this_word = (this_word & ~1) | 2, next_word = (next_word | 65) & ~2 ))
				[[ $__arg = \{[a-zA-Z_][a-zA-Z0-9_]#\} && $active_command = "exec" ]] && {
					(( this_word = (this_word & ~1) | 2, next_word = (next_word | 65) & ~2 ))
					(( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}exec-descriptor]}") 
					already_added=1 
				}
			fi
		fi
		(( this_word & 8192 )) && {
			__list=(${(z@)${aliases[$active_command]:-${active_command##*/}}##[[:space:]]#(command|builtin|exec|noglob|nocorrect|pkexec)[[:space:]]#}) 
			${${FAST_HIGHLIGHT[chroma-${__list[1]}]}%\%*} ${(M)FAST_HIGHLIGHT[chroma-${__list[1]}]%\%*} 0 "$__arg" $_start_pos $_end_pos 2> /dev/null && continue
		}
		(( this_word & 1 )) && {
			(( !in_redirection )) && active_command=$__arg 
			_mybuf=${${aliases[$active_command]:-${active_command##*/}}##[[:space:]]#(command|builtin|exec|noglob|nocorrect|pkexec)[[:space:]]#} 
			[[ "$_mybuf" = (#b)(FPATH+(#c0,1)=)* ]] && _mybuf="${match[1]} ${(j: :)${(s,:,)${_mybuf#FPATH+(#c0,1)=}}}" 
			[[ -n ${FAST_HIGHLIGHT[chroma-${_mybuf%% *}]} ]] && {
				__list=(${(z@)_mybuf}) 
				if (( ${#__list} > 1 )) || [[ $active_command != $_mybuf ]]
				then
					__style=${FAST_THEME_NAME}alias 
					(( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[$__style]}") 
					${${FAST_HIGHLIGHT[chroma-${__list[1]}]}%\%*} ${(M)FAST_HIGHLIGHT[chroma-${__list[1]}]%\%*} 1 "${__list[1]}" "-100000" $_end_pos 2> /dev/null || (( this_word = next_word, next_word = 2 ))
					for _mybuf in "${(@)__list[2,-1]}"
					do
						(( next_word = next_word | (this_word & (BIT_case_code|8192)) ))
						${${FAST_HIGHLIGHT[chroma-${__list[1]}]}%\%*} ${(M)FAST_HIGHLIGHT[chroma-${__list[1]}]%\%*} 0 "$_mybuf" "-100000" $_end_pos 2> /dev/null || (( this_word = next_word, next_word = 2 ))
					done
					_start_pos=$_end_pos 
					continue
				else
					${${FAST_HIGHLIGHT[chroma-${__list[1]}]}%\%*} ${(M)FAST_HIGHLIGHT[chroma-${__list[1]}]%\%*} 1 "$__arg" $_start_pos $_end_pos 2> /dev/null && continue
				fi
			} || (( 1 ))
		}
		expanded_path="" 
		if (( this_word & 16 )) && [[ $__arg == 'always' ]]
		then
			__style=${FAST_THEME_NAME}reserved-word 
			(( next_word = 1 | (this_word & BIT_case_code) ))
		elif (( (this_word & 1) && (in_redirection == 0) )) || [[ $braces_stack = T* ]]
		then
			if (( __arg_type == 1 ))
			then
				__style=${FAST_THEME_NAME}precommand 
				[[ $__arg = "command" || $__arg = "exec" ]] && (( next_word = next_word | 64 ))
			elif [[ $__arg = (sudo|doas) ]]
			then
				__style=${FAST_THEME_NAME}precommand 
				(( next_word = (next_word & ~2) | 4 | 1 ))
			else
				_mybuf=${${(Q)__arg}#\"} 
				if (( ${+parameters} )) && [[ $_mybuf = (#b)(*)(*)\$([a-zA-Z_][a-zA-Z0-9_]#|[0-9]##)(*) || $_mybuf = (#b)(*)(*)\$\{([a-zA-Z_][a-zA-Z0-9_:-]#|[0-9]##)(*) ]] && (( ${+parameters[${match[3]%%:-*}]} ))
				then
					-fast-highlight-main-type ${match[1]}${match[2]}${(P)match[3]%%:-*}${match[4]#\}}
				elif [[ $braces_stack = T* ]]
				then
					REPLY=none 
				else
					: ${expanded_path::=${~_mybuf}}
					-fast-highlight-main-type $expanded_path
				fi
				case $REPLY in
					(reserved) [[ $__arg = "[[" ]] && __style=${FAST_THEME_NAME}double-sq-bracket  || __style=${FAST_THEME_NAME}reserved-word 
						if [[ $__arg == $'\x7b' ]]
						then
							braces_stack='Y'$braces_stack 
						elif [[ $__arg == $'\x7d' && $braces_stack = Y* ]]
						then
							braces_stack=${braces_stack#Y} 
							__style=${FAST_THEME_NAME}reserved-word 
							(( next_word = next_word | 16 ))
						elif [[ $__arg == "[[" ]]
						then
							braces_stack='A'$braces_stack 
							_FAST_COMPLEX_BRACKETS+=($(( _start_pos-__PBUFLEN )) $(( _start_pos-__PBUFLEN + 1 ))) 
						elif [[ $__arg == "for" ]]
						then
							(( next_word = next_word | 32 ))
						elif [[ $__arg == "case" ]]
						then
							(( next_word = BIT_case_preamble ))
						elif [[ $__arg = (typeset|declare|local|float|integer|export|readonly) ]]
						then
							braces_stack='T'$braces_stack 
						fi ;;
					('suffix alias') __style=${FAST_THEME_NAME}suffix-alias  ;;
					('global alias') __style=${FAST_THEME_NAME}global-alias  ;;
					(alias) if [[ $__arg = ?*'='* ]]
						then
							__style=${FAST_THEME_NAME}unknown-token 
						else
							__style=${FAST_THEME_NAME}alias 
							(( ${+aliases} )) && alias_target=${aliases[$__arg]}  || alias_target="${"$(alias -- $__arg)"#*=}" 
							[[ ${__FAST_HIGHLIGHT_TOKEN_TYPES[$alias_target]} = "1" && $__arg_type != "1" ]] && __FAST_HIGHLIGHT_TOKEN_TYPES[$__arg]="1" 
						fi ;;
					(builtin) [[ $__arg = "[" ]] && {
							__style=${FAST_THEME_NAME}single-sq-bracket 
							_FAST_COMPLEX_BRACKETS+=($(( _start_pos-__PBUFLEN ))) 
						} || __style=${FAST_THEME_NAME}builtin 
						[[ $__arg = (typeset|declare|local|float|integer|export|readonly) ]] && braces_stack='T'$braces_stack 
						[[ $__arg = eval ]] && (( next_word = next_word | 256 )) ;;
					(function) __style=${FAST_THEME_NAME}function  ;;
					(command) __style=${FAST_THEME_NAME}command  ;;
					(hashed) __style=${FAST_THEME_NAME}hashed-command  ;;
					(dirpath) __style=${FAST_THEME_NAME}path-to-dir  ;;
					(none) if [[ $__arg == [a-zA-Z_][a-zA-Z0-9_]#(|\[[^\]]#\])(|[^\]]#\])(|[+])=* || $__arg == [0-9]##(|[+])=* || ( $braces_stack = T* && ${__arg_type} != 3 ) ]]
						then
							__style=${FAST_THEME_NAME}assign 
							FAST_ASSIGNS_SEEN[${__arg%%=*}]=1 
							[[ $__arg = (#b)*=(\()*(\))* || $__arg = (#b)*=(\()* ]] && {
								(( __start=_start_pos-__PBUFLEN+${mbegin[1]}-1, __end=__start+1, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}assign-array-bracket]}") 
								_FAST_COMPLEX_BRACKETS+=($__start) 
								(( mbegin[2] >= 1 )) && {
									(( __start=_start_pos-__PBUFLEN+${mbegin[2]}-1, __end=__start+1, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}assign-array-bracket]}") 
									_FAST_COMPLEX_BRACKETS+=($__start) 
								} || in_array_assignment=1 
							} || {
								[[ ${braces_stack[1]} != 'T' ]] && (( next_word = (next_word | 1) & ~2 ))
							}
							local ctmp="\"" dtmp="'" 
							itmp=${__arg[(i)$ctmp]}-1 iitmp=${__arg[(i)$dtmp]}-1 
							integer jtmp=${__arg[(b:itmp+2:i)$ctmp]} jjtmp=${__arg[(b:iitmp+2:i)$dtmp]} 
							(( itmp < iitmp && itmp <= __asize - 1 )) && (( jtmp > __asize && (jtmp = __asize), 1 > 0 )) && (( __start=_start_pos-__PBUFLEN+itmp, __end=_start_pos-__PBUFLEN+jtmp, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}double-quoted-argument]}")  && {
								itmp=${__arg[(i)=]} 
								__arg=${__arg[itmp,__asize]} 
								(( _start_pos += itmp - 1 ))
								-fast-highlight-string
								(( _start_pos = _start_pos - itmp + 1, 1 > 0 ))
							} || {
								(( iitmp <= __asize - 1 )) && (( jjtmp > __asize && (jjtmp = __asize), 1 > 0 )) && (( __start=_start_pos-__PBUFLEN+iitmp, __end=_start_pos-__PBUFLEN+jjtmp, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}single-quoted-argument]}") 
							} || {
								itmp=${__arg[(i)=]} 
								__arg=${__arg[itmp,__asize]} 
								(( _start_pos += itmp - 1 ))
								[[ ${__arg[2,4]} = '$((' ]] && {
									-fast-highlight-math-string
									(( __start=_start_pos-__PBUFLEN+2, __end=__start+2, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}double-paren]}") 
									_FAST_COMPLEX_BRACKETS+=($__start $(( __start + 1 ))) 
									(( jtmp = ${__arg[(I)\)\)]}-1, jtmp > 0 )) && {
										(( __start=_start_pos-__PBUFLEN+jtmp, __end=__start+2, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}double-paren]}") 
										_FAST_COMPLEX_BRACKETS+=($__start $(( __start + 1 ))) 
									}
								} || -fast-highlight-string
								(( _start_pos = _start_pos - itmp + 1, 1 > 0 ))
							}
						elif [[ $__arg = ${histchars[1]}* && -n ${__arg[2]} ]]
						then
							__style=${FAST_THEME_NAME}history-expansion 
						elif [[ $__arg == ${histchars[2]}* ]]
						then
							__style=${FAST_THEME_NAME}history-expansion 
						elif (( __arg_type == 3 ))
						then
							(( this_word & 3 )) && __style=${FAST_THEME_NAME}commandseparator 
						elif [[ $__arg[1,2] == '((' ]]
						then
							(( __start=_start_pos-__PBUFLEN, __end=__start+2, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}double-paren]}") 
							already_added=1 
							_FAST_COMPLEX_BRACKETS+=($__start $(( __start + 1 ))) 
							-fast-highlight-math-string
							[[ $__arg[-2,-1] == '))' ]] && {
								(( __start=_end_pos-__PBUFLEN-2, __end=__start+2, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}double-paren]}") 
								(( __delimited = __delimited ? 2 : __delimited ))
								_FAST_COMPLEX_BRACKETS+=($__start $(( __start + 1 ))) 
							}
						elif [[ $__arg == '()' ]]
						then
							_FAST_COMPLEX_BRACKETS+=($(( _start_pos-__PBUFLEN )) $(( _start_pos-__PBUFLEN + 1 ))) 
							__style=${FAST_THEME_NAME}reserved-word 
						elif [[ $__arg == $'\x28' ]]
						then
							__style=${FAST_THEME_NAME}reserved-word 
							braces_stack='R'$braces_stack 
						elif [[ $__arg == $'\x29' ]]
						then
							[[ $braces_stack = R* ]] && {
								braces_stack=${braces_stack#R} 
								__style=${FAST_THEME_NAME}reserved-word 
							}
						elif (( this_word & 14 ))
						then
							__style=${FAST_THEME_NAME}default 
						elif [[ $__arg = (';;'|';&'|';|') ]] && (( this_word & BIT_case_code ))
						then
							(( next_word = (next_word | BIT_case_item) & ~(BIT_case_code+3) ))
							__style=${FAST_THEME_NAME}default 
						elif [[ $__arg = \$\([^\(]* ]]
						then
							already_added=1 
						fi ;;
					(*) already_added=1  ;;
				esac
			fi
		elif (( in_redirection + this_word & 14 ))
		then
			case $__arg in
				(']]') [[ $braces_stack = A* ]] && {
						__style=${FAST_THEME_NAME}double-sq-bracket 
						(( __delimited = __delimited ? 2 : __delimited ))
						_FAST_COMPLEX_BRACKETS+=($(( _start_pos-__PBUFLEN )) $(( _start_pos-__PBUFLEN+1 ))) 
					} || {
						[[ $braces_stack = *A* ]] && {
							__style=${FAST_THEME_NAME}unknown-token 
							_FAST_COMPLEX_BRACKETS+=($(( _start_pos-__PBUFLEN )) $(( _start_pos-__PBUFLEN+1 ))) 
						} || __style=${FAST_THEME_NAME}default 
					}
					braces_stack=${braces_stack#A}  ;;
				(']') __style=${FAST_THEME_NAME}single-sq-bracket 
					_FAST_COMPLEX_BRACKETS+=($(( _start_pos-__PBUFLEN )))  ;;
				($'\x28') __style=${FAST_THEME_NAME}reserved-word 
					braces_stack='R'$braces_stack  ;;
				($'\x29') if (( in_array_assignment ))
					then
						in_array_assignment=0 
						(( next_word = next_word | 1 ))
						(( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}assign-array-bracket]}") 
						already_added=1 
						_FAST_COMPLEX_BRACKETS+=($__start) 
					elif [[ $braces_stack = R* ]]
					then
						braces_stack=${braces_stack#R} 
						__style=${FAST_THEME_NAME}reserved-word 
					elif [[ $braces_stack = F* ]]
					then
						__style=${FAST_THEME_NAME}builtin 
					fi ;;
				($'\x28\x29') (( FAST_HIGHLIGHT[multi_func_def] )) && (( next_word = next_word | 1 ))
					__style=${FAST_THEME_NAME}reserved-word 
					_FAST_COMPLEX_BRACKETS+=($(( _start_pos-__PBUFLEN )) $(( _start_pos-__PBUFLEN + 1 ))) 
					reply[-1]=() 
					__fast_highlight_main__command_type_cache[$active_command]="function"  ;;
				('--'*) [[ $__arg == "--" ]] && {
						_was_double_hyphen=1 
						__style=${FAST_THEME_NAME}double-hyphen-option 
					} || {
						(( !_was_double_hyphen )) && {
							[[ "$__arg" = (#b)(--[a-zA-Z0-9_]##)=(*) ]] && {
								(( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}double-hyphen-option]}") 
								(( __start=_start_pos-__PBUFLEN+1+mend[1], __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}optarg-${${${(M)match[2]:#<->}:+number}:-string}]}") 
								already_added=1 
							} || __style=${FAST_THEME_NAME}double-hyphen-option 
						} || __style=${FAST_THEME_NAME}default 
					} ;;
				('-'*) (( !_was_double_hyphen )) && __style=${FAST_THEME_NAME}single-hyphen-option  || __style=${FAST_THEME_NAME}default  ;;
				(\$\'*) (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}dollar-quoted-argument]}") 
					-fast-highlight-dollar-string
					already_added=1  ;;
				([\"\']* | [^\"\\]##([\\][\\])#\"* | [^\'\\]##([\\][\\])#\'*) if (( this_word & 256 )) && [[ $__arg = [\'\"]* ]]
					then
						(( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}recursive-base]}") 
						if [[ -n ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}secondary]} ]]
						then
							__idx=1 
							_mybuf=$FAST_THEME_NAME 
							FAST_THEME_NAME=${${${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}secondary]}:t:r}#(XDG|LOCAL|HOME|OPT):} 
							(( ${+FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}default]} )) || source $FAST_WORK_DIR/secondary_theme.zsh
						else
							__idx=0 
						fi
						(( _start_pos-__PBUFLEN >= 0 )) && -fast-highlight-process "$PREBUFFER" "${${__arg%[\'\"]}#[\'\"]}" $(( _start_pos + 1 ))
						(( __idx )) && FAST_THEME_NAME=$_mybuf 
						already_added=1 
					else
						[[ $__arg = *([^\\][\#][\#]|"(#b)"|"(#B)"|"(#m)"|"(#c")* && $highlight_glob -ne 0 ]] && (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}globbing-ext]}") 
						itmp=0 __workbuf=$__arg __tmp="" cdpath_dir=$__arg 
						while [[ $__workbuf = (#b)[^\"\'\\]#(([\"\'])|[\\](*))(*) ]]
						do
							[[ -n ${match[3]} ]] && {
								itmp+=${mbegin[1]} 
								[[ $__tmp = \' ]] && __workbuf=${match[3]}  || {
									itmp+=1 
									__workbuf=${match[3]:1} 
								}
							} || {
								itmp+=${mbegin[1]} 
								__workbuf=${match[4]} 
								[[ ( ${match[1]} = \" && $__tmp != \' ) || ( ${match[1]} = \' && $__tmp != \" ) ]] && {
									[[ $__tmp = [\"\'] ]] && {
										(( __start=_start_pos-__PBUFLEN+iitmp-1, __end=_start_pos-__PBUFLEN+itmp, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}${${${__tmp#\'}:+double-quoted-argument}:-single-quoted-argument}]}") 
										already_added=1 
										[[ $__tmp = \" ]] && {
											__arg=${cdpath_dir[iitmp+1,itmp-1]} 
											(( _start_pos += iitmp - 1 + 1 ))
											-fast-highlight-string
											(( _start_pos = _start_pos - iitmp + 1 - 1 ))
										}
										__tmp= 
									} || {
										iitmp=itmp 
										__tmp=${match[1]} 
									}
								}
							}
						done
						[[ $__tmp = [\"\'] ]] && {
							(( __start=_start_pos-__PBUFLEN+iitmp-1, __end=_start_pos-__PBUFLEN+__asize, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}${${${__tmp#\'}:+double-quoted-argument}:-single-quoted-argument}]}") 
							already_added=1 
							[[ $__tmp = \" ]] && {
								__arg=${cdpath_dir[iitmp+1,__asize]} 
								(( _start_pos += iitmp - 1 + 1 ))
								-fast-highlight-string
								(( _start_pos = _start_pos - iitmp + 1 - 1 ))
							}
						}
					fi ;;
				(\$\(\(*) already_added=1 
					-fast-highlight-math-string
					(( __start=_start_pos-__PBUFLEN+1, __end=__start+2, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}double-paren]}") 
					_FAST_COMPLEX_BRACKETS+=($__start $(( __start + 1 ))) 
					[[ $__arg[-2,-1] == '))' ]] && (( __start=_end_pos-__PBUFLEN-2, __end=__start+2, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}double-paren]}") 
					_FAST_COMPLEX_BRACKETS+=($__start $(( __start + 1 )))  ;;
				('`'*) (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}back-quoted-argument]}") 
					if [[ -n ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}secondary]} ]]
					then
						__idx=1 
						_mybuf=$FAST_THEME_NAME 
						FAST_THEME_NAME=${${${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}secondary]}:t:r}#(XDG|LOCAL|HOME|OPT):} 
						(( ${+FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}default]} )) || source $FAST_WORK_DIR/secondary_theme.zsh
					else
						__idx=0 
					fi
					(( _start_pos-__PBUFLEN >= 0 )) && -fast-highlight-process "$PREBUFFER" "${${__arg%[\`]}#[\`]}" $(( _start_pos + 1 ))
					(( __idx )) && FAST_THEME_NAME=$_mybuf 
					already_added=1  ;;
				('((') (( this_word & 32 )) && {
						braces_stack='F'$braces_stack 
						__style=${FAST_THEME_NAME}double-paren 
						_FAST_COMPLEX_BRACKETS+=($(( _start_pos-__PBUFLEN )) $(( _start_pos-__PBUFLEN+1 ))) 
						__delimited=1 
					} ;;
				('))') [[ $braces_stack = F* ]] && {
						braces_stack=${braces_stack#F} 
						__style=${FAST_THEME_NAME}double-paren 
						_FAST_COMPLEX_BRACKETS+=($(( _start_pos-__PBUFLEN )) $(( _start_pos-__PBUFLEN+1 ))) 
						(( __delimited = __delimited ? 2 : __delimited ))
					} ;;
				('<<<') (( next_word = (next_word | 128) & ~3 ))
					[[ ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}here-string-tri]} != "none" ]] && (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}here-string-tri]}") 
					already_added=1  ;;
				(*) if [[ $braces_stack = F* ]]
					then
						-fast-highlight-string
						_mybuf=$__arg 
						__idx=_start_pos 
						while [[ $_mybuf = (#b)[^a-zA-Z\{\$]#([a-zA-Z][a-zA-Z0-9]#)(*) ]]
						do
							(( __start=__idx-__PBUFLEN+${mbegin[1]}-1, __end=__idx-__PBUFLEN+${mend[1]}+1-1, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}for-loop-variable]}") 
							__idx+=${mend[1]} 
							_mybuf=${match[2]} 
						done
						_mybuf=$__arg 
						__idx=_start_pos 
						while [[ $_mybuf = (#b)[^+\<\>=:\*\|\&\^\~-]#([+\<\>=:\*\|\&\^\~-]##)(*) ]]
						do
							(( __start=__idx-__PBUFLEN+${mbegin[1]}-1, __end=__idx-__PBUFLEN+${mend[1]}+1-1, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}for-loop-operator]}") 
							__idx+=${mend[1]} 
							_mybuf=${match[2]} 
						done
						_mybuf=$__arg 
						__idx=_start_pos 
						while [[ $_mybuf = (#b)[^0-9]#([0-9]##)(*) ]]
						do
							(( __start=__idx-__PBUFLEN+${mbegin[1]}-1, __end=__idx-__PBUFLEN+${mend[1]}+1-1, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}for-loop-number]}") 
							__idx+=${mend[1]} 
							_mybuf=${match[2]} 
						done
						if [[ $__arg = (#b)[^\;]#(\;)[\ ]# ]]
						then
							(( __start=_start_pos-__PBUFLEN+${mbegin[1]}-1, __end=_start_pos-__PBUFLEN+${mend[1]}+1-1, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}for-loop-separator]}") 
						fi
						already_added=1 
					elif [[ $__arg = *([^\\][\#][\#]|"(#b)"|"(#B)"|"(#m)"|"(#c")* ]]
					then
						(( highlight_glob )) && __style=${FAST_THEME_NAME}globbing-ext  || __style=${FAST_THEME_NAME}default 
					elif [[ $__arg = ([*?]*|*[^\\][*?]*) ]]
					then
						(( highlight_glob )) && __style=${FAST_THEME_NAME}globbing  || __style=${FAST_THEME_NAME}default 
					elif [[ $__arg = \$* ]]
					then
						__style=${FAST_THEME_NAME}variable 
					elif [[ $__arg = $'\x7d' && $braces_stack = Y* && ${FAST_HIGHLIGHT[right_brace_is_recognised_everywhere]} = "1" ]]
					then
						braces_stack=${braces_stack#Y} 
						__style=${FAST_THEME_NAME}reserved-word 
						(( next_word = next_word | 16 ))
					elif [[ $__arg = (';;'|';&'|';|') ]] && (( this_word & BIT_case_code ))
					then
						(( next_word = (next_word | BIT_case_item) & ~(BIT_case_code+3) ))
						__style=${FAST_THEME_NAME}default 
					elif [[ $__arg = ${histchars[1]}* && -n ${__arg[2]} ]]
					then
						__style=${FAST_THEME_NAME}history-expansion 
					elif (( __arg_type == 3 ))
					then
						__style=${FAST_THEME_NAME}commandseparator 
					elif (( in_redirection == 2 ))
					then
						__style=${FAST_THEME_NAME}redirection 
					elif (( ${+galiases[(e)${(Q)__arg}]} ))
					then
						__style=${FAST_THEME_NAME}global-alias 
					else
						if [[ ${FAST_HIGHLIGHT[no_check_paths]} != 1 ]]
						then
							if [[ ${FAST_HIGHLIGHT[use_async]} != 1 ]]
							then
								if -fast-highlight-check-path noasync
								then
									(( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[$__style]}") 
									already_added=1 
									[[ -n ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}path_pathseparator]} && ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}path]} != ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}path_pathseparator]} ]] && {
										for ((__pos = _start_pos; __pos <= _end_pos; __pos++ )) do
											[[ ${__buf[__pos]} == "/" ]] && (( __start=__pos-__PBUFLEN, __start >= 0 )) && reply+=("$(( __start - 1 )) $__start ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}path_pathseparator]}") 
										done
									}
								else
									__style=${FAST_THEME_NAME}default 
								fi
							else
								if [[ -z ${FAST_HIGHLIGHT[cache-path-${(q)__arg}-${_start_pos}]} || $(( EPOCHSECONDS - FAST_HIGHLIGHT[cache-path-${(q)__arg}-${_start_pos}-born-at] )) -gt 8 ]]
								then
									if [[ $LASTWIDGET != *-or-beginning-search ]]
									then
										exec {PCFD}< <(-fast-highlight-check-path; sleep 5)
										command sleep 0
										FAST_HIGHLIGHT[path-queue]+=";$_start_pos $_end_pos;" 
										is-at-least 5.0.6 && __pos=1  || __pos=0 
										zle -F ${${__pos:#0}:+-w} $PCFD fast-highlight-check-path-handler
										already_added=1 
									else
										__style=${FAST_THEME_NAME}default 
									fi
								elif [[ ${FAST_HIGHLIGHT[cache-path-${(q)__arg}-${_start_pos}]%D} -eq 1 ]]
								then
									(( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}path${${(M)FAST_HIGHLIGHT[cache-path-${(q)__arg}-${_start_pos}]%D}:+-to-dir}]}") 
									already_added=1 
								else
									__style=${FAST_THEME_NAME}default 
								fi
							fi
						else
							__style=${FAST_THEME_NAME}default 
						fi
					fi ;;
			esac
		elif (( this_word & 128 ))
		then
			(( next_word = (next_word | 2) & ~129 ))
			[[ ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}here-string-text]} != "none" ]] && (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}here-string-text]}") 
			-fast-highlight-string ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}here-string-var]:#none}
			already_added=1 
		elif (( this_word & (BIT_case_preamble + BIT_case_item) ))
		then
			if (( this_word & BIT_case_preamble ))
			then
				[[ $__arg = "in" ]] && {
					__style=${FAST_THEME_NAME}reserved-word 
					(( next_word = BIT_case_item ))
				} || {
					__style=${FAST_THEME_NAME}case-input 
					(( next_word = BIT_case_preamble ))
				}
			else
				if (( this_word & BIT_case_nempty_item == 0 )) && [[ $__arg = "esac" ]]
				then
					(( next_word = 1 ))
					__style=${FAST_THEME_NAME}reserved-word 
				elif [[ $__arg = (\(*\)|\)|\() ]]
				then
					[[ $__arg = *\) ]] && (( next_word = BIT_case_code | 1 )) || (( next_word = BIT_case_item | BIT_case_nempty_item ))
					_FAST_COMPLEX_BRACKETS+=($(( _start_pos-__PBUFLEN ))) 
					(( ${#__arg} > 1 )) && {
						_FAST_COMPLEX_BRACKETS+=($(( _start_pos+${#__arg}-1-__PBUFLEN ))) 
						(( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}case-parentheses]}") 
						(( __start=_start_pos+1-__PBUFLEN, __end=_end_pos-1-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}case-condition]}") 
						already_added=1 
					} || {
						__style=${FAST_THEME_NAME}case-parentheses 
					}
				else
					(( next_word = BIT_case_item | BIT_case_nempty_item ))
					__style=${FAST_THEME_NAME}case-condition 
				fi
			fi
		fi
		if [[ $__arg = (#b)*'#'(([0-9a-fA-F][0-9a-fA-F])([0-9a-fA-F][0-9a-fA-F])([0-9a-fA-F][0-9a-fA-F])|([0-9a-fA-F])([0-9a-fA-F])([0-9a-fA-F]))(|[^[:alnum:]]*) || $__arg = (#b)*'rgb('(([0-9a-fA-F][0-9a-fA-F](#c0,1)),([0-9a-fA-F][0-9a-fA-F](#c0,1)),([0-9a-fA-F][0-9a-fA-F](#c0,1)))* ]]
		then
			if [[ -n $match[2] ]]
			then
				if [[ $match[2] = ?? || $match[3] = ?? || $match[4] = ?? ]]
				then
					(( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end bg=#${(l:2::0:)match[2]}${(l:2::0:)match[3]}${(l:2::0:)match[4]}") 
				else
					(( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end bg=#$match[2]$match[3]$match[4]") 
				fi
			else
				(( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end bg=#$match[5]$match[6]$match[7]") 
			fi
			already_added=1 
		fi
		(( already_added == 0 )) && [[ ${FAST_HIGHLIGHT_STYLES[$__style]} != "none" ]] && (( __start=_start_pos-__PBUFLEN, __end=_end_pos-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[$__style]}") 
		if (( (__arg_type == 3) && ((this_word & (BIT_case_preamble|BIT_case_item)) == 0) ))
		then
			if [[ $__arg == ';' ]] && (( in_array_assignment ))
			then
				(( next_word = 2 | (next_word & BIT_case_code) ))
			elif [[ -n ${braces_stack[(r)A]} ]]
			then
				(( next_word = 2 | (next_word & BIT_case_code) ))
			else
				braces_stack=${braces_stack#T} 
				(( next_word = 1 | (next_word & BIT_case_code) ))
				highlight_glob=1 
				[[ $__arg != ("||"|"&&") ]] && __delimited=0  || (( __delimited = __delimited == 2 ? 1 : __delimited ))
			fi
		elif (( ( (__arg_type == 1) || (__arg_type == 2) ) && (this_word & 1) ))
		then
			__delimited=1 
			(( next_word = 1 | (next_word & (64 | BIT_case_code)) ))
		elif [[ $__arg == "repeat" ]] && (( this_word & 1 ))
		then
			__delimited=1 
			in_redirection=2 
			(( this_word = 3 ))
		fi
		_start_pos=$_end_pos 
		(( this_word = in_redirection == 0 ? next_word : this_word ))
	done
	[[ $3 != 0 ]] && return 0
	_mybuf=${__buf[1,250]} __workbuf=$_mybuf __idx=0 __pos=0 __list=() 
	while [[ $__workbuf = (#b)[^\(\)]#([\(\)])(*) ]]
	do
		if [[ ${match[1]} == \( ]]
		then
			__arg=${_mybuf[__idx+${mbegin[1]}-1,__idx+${mbegin[1]}-1+2]} 
			[[ $__arg = '$('[^\(] ]] && __list+=($__pos) 
			[[ $__arg = '$((' ]] && _mybuf[__idx+${mbegin[1]}-1]=x 
			__pos+=1 
		else
			__pos=__pos-1 
			[[ -z ${__list[(r)$__pos]} ]] && [[ $__pos -gt 0 ]] && _mybuf[__idx+${mbegin[1]}]=x 
		fi
		__idx+=${mbegin[2]}-1 
		__workbuf=${match[2]} 
	done
	if [[ "$_mybuf" = *$__nul* ]]
	then
		__nul=$'\7' 
	fi
	__inputs=(${(ps:$__nul:)${(S)_mybuf//(#b)*\$\(([^\)]#)(\)|(#e))/${mbegin[1]};${mend[1]}${__nul}}%$__nul*}) 
	if [[ "${__inputs[1]}" != "$_mybuf" && -n "${__inputs[1]}" ]]
	then
		if [[ -n ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}secondary]} ]]
		then
			__idx=1 
			__tmp=$FAST_THEME_NAME 
			FAST_THEME_NAME=${${${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}secondary]}:t:r}#(XDG|LOCAL|HOME|OPT):} 
			(( ${+FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}default]} )) || source $FAST_WORK_DIR/secondary_theme.zsh
		else
			__idx=0 
		fi
		for _mybuf in $__inputs
		do
			(( __start=${_mybuf%%;*}-__PBUFLEN-1, __end=${_mybuf##*;}-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${__tmp}recursive-base]}") 
			-fast-highlight-process "$PREBUFFER" "${__buf[${_mybuf%%;*},${_mybuf##*;}]}" $(( ${_mybuf%%;*} - 1 ))
		done
		(( __idx )) && FAST_THEME_NAME=$__tmp 
	fi
	return 0
}
-fast-highlight-string () {
	(( _start_pos-__PBUFLEN >= 0 )) || return 0
	_mybuf=$__arg 
	__idx=_start_pos 
	while [[ $_mybuf = (#b)[^\$\\]#((\$(#B)([#+^=~](#c1,2))(#c0,1)(#B)([a-zA-Z_:][a-zA-Z0-9_:]#|[0-9]##)(#b)(\[[^\]]#\])(#c0,1))|(\$[{](#B)([#+^=~](#c1,2))(#c0,1)(#b)(\([a-zA-Z0-9_:@%#]##\))(#c0,1)[a-zA-Z0-9_:#]##(\[[^\]]#\])(#c0,1)[}])|\$|[\\][\'\"\$]|[\\](*))(*) ]]
	do
		[[ -n ${match[7]} ]] && {
			__idx+=${mbegin[1]}+1 
			_mybuf=${match[7]:1} 
		} || {
			__idx+=${mbegin[1]}-1 
			_end_idx=__idx+${mend[1]}-${mbegin[1]}+1 
			_mybuf=${match[8]} 
			(( __start=__idx-__PBUFLEN, __end=_end_idx-__PBUFLEN, __start >= 0 )) && reply+=("$__start $__end ${${1:+$1}:-${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}back-or-dollar-double-quoted-argument]}}") 
			__idx=_end_idx 
		}
	done
	return 0
}
-fast-highlight-string-process () {
	emulate -LR zsh
	setopt extendedglob warncreateglobal typesetsilent
	local -A pos_to_level level_to_pos pair_map final_pairs
	local input=$1$2 _mybuf=$1$2 __style __quoting 
	integer __idx=0 __pair_idx __level=0 __start __end 
	local -a match mbegin mend
	pair_map=("(" ")" "{" "}" "[" "]") 
	while [[ $_mybuf = (#b)([^"{}()[]\\\"'"]#)((["({[]})\"'"])|[\\](*))(*) ]]
	do
		if [[ -n ${match[4]} ]]
		then
			__idx+=${mbegin[2]} 
			[[ $__quoting = \' ]] && _mybuf=${match[4]}  || {
				_mybuf=${match[4]:1} 
				(( ++ __idx ))
			}
		else
			__idx+=${mbegin[2]} 
			[[ -z $__quoting && -z ${_FAST_COMPLEX_BRACKETS[(r)$((__idx-${#PREBUFFER}-1))]} ]] && {
				if [[ ${match[2]} = ["({["] ]]
				then
					pos_to_level[$__idx]=$(( ++__level )) 
					level_to_pos[$__level]=$__idx 
				elif [[ ${match[2]} = ["]})"] ]]
				then
					if (( __level > 0 ))
					then
						__pair_idx=${level_to_pos[$__level]} 
						pos_to_level[$__idx]=$(( __level -- )) 
						[[ ${pair_map[${input[__pair_idx]}]} = ${input[__idx]} ]] && {
							final_pairs[$__idx]=$__pair_idx 
							final_pairs[$__pair_idx]=$__idx 
						}
					else
						pos_to_level[$__idx]=-1 
					fi
				fi
			}
			if [[ ${match[2]} = \" && $__quoting != \' ]]
			then
				[[ $__quoting = '"' ]] && __quoting=""  || __quoting='"' 
			fi
			if [[ ${match[2]} = \' && $__quoting != \" ]]
			then
				if [[ $__quoting = ("'"|"$'") ]]
				then
					__quoting="" 
				else
					if [[ $match[1] = *\$ ]]
					then
						__quoting="\$'" 
					else
						__quoting="'" 
					fi
				fi
			fi
			_mybuf=${match[5]} 
		fi
	done
	for __idx in ${(k)pos_to_level}
	do
		(( ${+final_pairs[$__idx]} )) && __style=${FAST_THEME_NAME}bracket-level-$(( ( (pos_to_level[$__idx]-1) % 3 ) + 1 ))  || __style=${FAST_THEME_NAME}unknown-token 
		(( __start=__idx-${#PREBUFFER}-1, __end=__idx-${#PREBUFFER}, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[$__style]}") 
	done
	if [[ $WIDGET != zle-line-finish ]]
	then
		__idx=$(( CURSOR + 1 )) 
		if (( ${+pos_to_level[$__idx]} )) && (( ${+final_pairs[$__idx]} ))
		then
			(( __start=final_pairs[$__idx]-${#PREBUFFER}-1, __end=final_pairs[$__idx]-${#PREBUFFER}, __start >= 0 )) && reply+=("$__start $__end ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}paired-bracket]}")  && reply+=("$CURSOR $__idx ${FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}paired-bracket]}") 
		fi
	fi
	return 0
}
-fsh_sy_h_shappend () {
	FSH_LIST+=("$(( $1 - 1 ));;$(( $2 ))") 
}
.fast-make-targets () {
	# undefined
	builtin autoload -XUz
}
.fast-read-ini-file () {
	# undefined
	builtin autoload -XUz
}
.fast-run-command () {
	# undefined
	builtin autoload -XUz
}
.fast-run-git-command () {
	# undefined
	builtin autoload -XUz
}
.fast-zts-read-all () {
	# undefined
	builtin autoload -XUz
}
/fshdbg () {
	print -r -- "$@" >>| /tmp/reply
}
VCS_INFO_formats () {
	setopt localoptions noksharrays NO_shwordsplit
	local msg tmp
	local -i i
	local -A hook_com
	hook_com=(action "$1" action_orig "$1" branch "$2" branch_orig "$2" base "$3" base_orig "$3" staged "$4" staged_orig "$4" unstaged "$5" unstaged_orig "$5" revision "$6" revision_orig "$6" misc "$7" misc_orig "$7" vcs "${vcs}" vcs_orig "${vcs}") 
	hook_com[base-name]="${${hook_com[base]}:t}" 
	hook_com[base-name_orig]="${hook_com[base-name]}" 
	hook_com[subdir]="$(VCS_INFO_reposub ${hook_com[base]})" 
	hook_com[subdir_orig]="${hook_com[subdir]}" 
	: vcs_info-patch-9b9840f2-91e5-4471-af84-9e9a0dc68c1b
	for tmp in base base-name branch misc revision subdir
	do
		hook_com[$tmp]="${hook_com[$tmp]//\%/%%}" 
	done
	VCS_INFO_hook 'post-backend'
	if [[ -n ${hook_com[action]} ]]
	then
		zstyle -a ":vcs_info:${vcs}:${usercontext}:${rrn}" actionformats msgs
		(( ${#msgs} < 1 )) && msgs[1]=' (%s)-[%b|%a]%u%c-' 
	else
		zstyle -a ":vcs_info:${vcs}:${usercontext}:${rrn}" formats msgs
		(( ${#msgs} < 1 )) && msgs[1]=' (%s)-[%b]%u%c-' 
	fi
	if [[ -n ${hook_com[staged]} ]]
	then
		zstyle -s ":vcs_info:${vcs}:${usercontext}:${rrn}" stagedstr tmp
		[[ -z ${tmp} ]] && hook_com[staged]='S'  || hook_com[staged]=${tmp} 
	fi
	if [[ -n ${hook_com[unstaged]} ]]
	then
		zstyle -s ":vcs_info:${vcs}:${usercontext}:${rrn}" unstagedstr tmp
		[[ -z ${tmp} ]] && hook_com[unstaged]='U'  || hook_com[unstaged]=${tmp} 
	fi
	if [[ ${quiltmode} != 'standalone' ]] && VCS_INFO_hook "pre-addon-quilt"
	then
		local REPLY
		VCS_INFO_quilt addon
		hook_com[quilt]="${REPLY}" 
		unset REPLY
	elif [[ ${quiltmode} == 'standalone' ]]
	then
		hook_com[quilt]=${hook_com[misc]} 
	fi
	(( ${#msgs} > maxexports )) && msgs[$(( maxexports + 1 )),-1]=() 
	for i in {1..${#msgs}}
	do
		if VCS_INFO_hook "set-message" $(( $i - 1 )) "${msgs[$i]}"
		then
			zformat -f msg ${msgs[$i]} a:${hook_com[action]} b:${hook_com[branch]} c:${hook_com[staged]} i:${hook_com[revision]} m:${hook_com[misc]} r:${hook_com[base-name]} s:${hook_com[vcs]} u:${hook_com[unstaged]} Q:${hook_com[quilt]} R:${hook_com[base]} S:${hook_com[subdir]}
			msgs[$i]=${msg} 
		else
			msgs[$i]=${hook_com[message]} 
		fi
	done
	hook_com=() 
	backend_misc=() 
	return 0
}
_SUSEconfig () {
	# undefined
	builtin autoload -XUz
}
__arguments () {
	# undefined
	builtin autoload -XUz
}
__bun_dynamic_comp () {
	local comp="" 
	for arg in scripts
	do
		local line
		while read -r line
		do
			local name="$line" 
			local desc="$line" 
			name="${name%$'\t'*}" 
			desc="${desc/*$'\t'/}" 
			echo
		done <<< "$arg"
	done
	return $comp
}
__git_prompt_git () {
	GIT_OPTIONAL_LOCKS=0 command git "$@"
}
__nvm () {
	declare previous_word
	previous_word="${COMP_WORDS[COMP_CWORD - 1]}" 
	case "${previous_word}" in
		(use | run | exec | ls | list | uninstall) __nvm_installed_nodes ;;
		(alias | unalias) __nvm_alias ;;
		(*) __nvm_commands ;;
	esac
	return 0
}
__nvm_alias () {
	__nvm_generate_completion "$(__nvm_aliases)"
}
__nvm_aliases () {
	declare aliases
	aliases="" 
	if [ -d "${NVM_DIR}/alias" ]
	then
		aliases="$(command cd "${NVM_DIR}/alias" && command find "${PWD}" -type f | command sed "s:${PWD}/::")" 
	fi
	echo "${aliases} node stable unstable iojs"
}
__nvm_commands () {
	declare current_word
	declare command
	current_word="${COMP_WORDS[COMP_CWORD]}" 
	COMMANDS='
    help install uninstall use run exec
    alias unalias reinstall-packages
    current list ls list-remote ls-remote
    install-latest-npm
    cache deactivate unload
    version version-remote which' 
	if [ ${#COMP_WORDS[@]} == 4 ]
	then
		command="${COMP_WORDS[COMP_CWORD - 2]}" 
		case "${command}" in
			(alias) __nvm_installed_nodes ;;
		esac
	else
		case "${current_word}" in
			(-*) __nvm_options ;;
			(*) __nvm_generate_completion "${COMMANDS}" ;;
		esac
	fi
}
__nvm_generate_completion () {
	declare current_word
	current_word="${COMP_WORDS[COMP_CWORD]}" 
	COMPREPLY=($(compgen -W "$1" -- "${current_word}")) 
	return 0
}
__nvm_installed_nodes () {
	__nvm_generate_completion "$(nvm_ls) $(__nvm_aliases)"
}
__nvm_options () {
	OPTIONS='' 
	__nvm_generate_completion "${OPTIONS}"
}
_a2ps () {
	# undefined
	builtin autoload -XUz
}
_a2utils () {
	# undefined
	builtin autoload -XUz
}
_aap () {
	# undefined
	builtin autoload -XUz
}
_abcde () {
	# undefined
	builtin autoload -XUz
}
_absolute_command_paths () {
	# undefined
	builtin autoload -XUz
}
_ack () {
	# undefined
	builtin autoload -XUz
}
_acpi () {
	# undefined
	builtin autoload -XUz
}
_acpitool () {
	# undefined
	builtin autoload -XUz
}
_acroread () {
	# undefined
	builtin autoload -XUz
}
_adb () {
	# undefined
	builtin autoload -XUz
}
_add-zle-hook-widget () {
	# undefined
	builtin autoload -XUz
}
_add-zsh-hook () {
	# undefined
	builtin autoload -XUz
}
_alias () {
	# undefined
	builtin autoload -XUz
}
_aliases () {
	# undefined
	builtin autoload -XUz
}
_all_labels () {
	# undefined
	builtin autoload -XUz
}
_all_matches () {
	# undefined
	builtin autoload -XUz
}
_alsa-utils () {
	# undefined
	builtin autoload -XUz
}
_alternative () {
	# undefined
	builtin autoload -XUz
}
_analyseplugin () {
	# undefined
	builtin autoload -XUz
}
_ansible () {
	# undefined
	builtin autoload -XUz
}
_ant () {
	# undefined
	builtin autoload -XUz
}
_antigravity () {
	# undefined
	builtin autoload -XUz
}
_antiword () {
	# undefined
	builtin autoload -XUz
}
_apachectl () {
	# undefined
	builtin autoload -XUz
}
_apm () {
	# undefined
	builtin autoload -XUz
}
_approximate () {
	# undefined
	builtin autoload -XUz
}
_apt () {
	# undefined
	builtin autoload -XUz
}
_apt-file () {
	# undefined
	builtin autoload -XUz
}
_apt-move () {
	# undefined
	builtin autoload -XUz
}
_apt-show-versions () {
	# undefined
	builtin autoload -XUz
}
_aptitude () {
	# undefined
	builtin autoload -XUz
}
_arch_archives () {
	# undefined
	builtin autoload -XUz
}
_arch_namespace () {
	# undefined
	builtin autoload -XUz
}
_arg_compile () {
	# undefined
	builtin autoload -XUz
}
_arguments () {
	# undefined
	builtin autoload -XUz
}
_arp () {
	# undefined
	builtin autoload -XUz
}
_arping () {
	# undefined
	builtin autoload -XUz
}
_arrays () {
	# undefined
	builtin autoload -XUz
}
_asciidoctor () {
	# undefined
	builtin autoload -XUz
}
_asciinema () {
	# undefined
	builtin autoload -XUz
}
_assign () {
	# undefined
	builtin autoload -XUz
}
_at () {
	# undefined
	builtin autoload -XUz
}
_attr () {
	# undefined
	builtin autoload -XUz
}
_augeas () {
	# undefined
	builtin autoload -XUz
}
_auto-apt () {
	# undefined
	builtin autoload -XUz
}
_autocd () {
	# undefined
	builtin autoload -XUz
}
_avahi () {
	# undefined
	builtin autoload -XUz
}
_awk () {
	# undefined
	builtin autoload -XUz
}
_axi-cache () {
	# undefined
	builtin autoload -XUz
}
_base64 () {
	# undefined
	builtin autoload -XUz
}
_basename () {
	# undefined
	builtin autoload -XUz
}
_basenc () {
	# undefined
	builtin autoload -XUz
}
_bash () {
	# undefined
	builtin autoload -XUz
}
_bash_complete () {
	local ret=1 
	local -a suf matches
	local -x COMP_POINT COMP_CWORD
	local -a COMP_WORDS COMPREPLY BASH_VERSINFO
	local -x COMP_LINE="$words" 
	local -A savejobstates savejobtexts
	(( COMP_POINT = 1 + ${#${(j. .)words[1,CURRENT-1]}} + $#QIPREFIX + $#IPREFIX + $#PREFIX ))
	(( COMP_CWORD = CURRENT - 1))
	COMP_WORDS=("${words[@]}") 
	BASH_VERSINFO=(2 05b 0 1 release) 
	savejobstates=(${(kv)jobstates}) 
	savejobtexts=(${(kv)jobtexts}) 
	[[ ${argv[${argv[(I)nospace]:-0}-1]} = -o ]] && suf=(-S '') 
	matches=(${(f)"$(compgen $@ -- ${words[CURRENT]})"}) 
	if [[ -n $matches ]]
	then
		if [[ ${argv[${argv[(I)filenames]:-0}-1]} = -o ]]
		then
			compset -P '*/' && matches=(${matches##*/}) 
			compset -S '/*' && matches=(${matches%%/*}) 
			compadd -f "${suf[@]}" -a matches && ret=0 
		else
			compadd "${suf[@]}" - "${(@)${(Q@)matches}:#*\ }" && ret=0 
			compadd -S ' ' - ${${(M)${(Q)matches}:#*\ }% } && ret=0 
		fi
	fi
	if (( ret ))
	then
		if [[ ${argv[${argv[(I)default]:-0}-1]} = -o ]]
		then
			_default "${suf[@]}" && ret=0 
		elif [[ ${argv[${argv[(I)dirnames]:-0}-1]} = -o ]]
		then
			_directories "${suf[@]}" && ret=0 
		fi
	fi
	return ret
}
_bash_completions () {
	# undefined
	builtin autoload -XUz
}
_baudrates () {
	# undefined
	builtin autoload -XUz
}
_baz () {
	# undefined
	builtin autoload -XUz
}
_be_name () {
	# undefined
	builtin autoload -XUz
}
_beadm () {
	# undefined
	builtin autoload -XUz
}
_beep () {
	# undefined
	builtin autoload -XUz
}
_bibtex () {
	# undefined
	builtin autoload -XUz
}
_bind_addresses () {
	# undefined
	builtin autoload -XUz
}
_bindkey () {
	# undefined
	builtin autoload -XUz
}
_bison () {
	# undefined
	builtin autoload -XUz
}
_bittorrent () {
	# undefined
	builtin autoload -XUz
}
_bogofilter () {
	# undefined
	builtin autoload -XUz
}
_bootctl () {
	# undefined
	builtin autoload -XUz
}
_bpf_filters () {
	# undefined
	builtin autoload -XUz
}
_bpython () {
	# undefined
	builtin autoload -XUz
}
_brace_parameter () {
	# undefined
	builtin autoload -XUz
}
_brctl () {
	# undefined
	builtin autoload -XUz
}
_bsd_disks () {
	# undefined
	builtin autoload -XUz
}
_bsd_pkg () {
	# undefined
	builtin autoload -XUz
}
_bsdconfig () {
	# undefined
	builtin autoload -XUz
}
_bsdinstall () {
	# undefined
	builtin autoload -XUz
}
_btrfs () {
	# undefined
	builtin autoload -XUz
}
_bts () {
	# undefined
	builtin autoload -XUz
}
_bug () {
	# undefined
	builtin autoload -XUz
}
_builtin () {
	# undefined
	builtin autoload -XUz
}
_bun () {
	zstyle ':completion:*:*:bun:*' group-name ''
	zstyle ':completion:*:*:bun-grouped:*' group-name ''
	zstyle ':completion:*:*:bun::descriptions' format '%F{green}-- %d --%f'
	zstyle ':completion:*:*:bun-grouped:*' format '%F{green}-- %d --%f'
	local program=bun 
	typeset -A opt_args
	local curcontext="$curcontext" state line context 
	_arguments -s '1: :->cmd' '*: :->args' && ret=0 
	case $state in
		(cmd) local -a scripts_list
			IFS=$'\n' scripts_list=($(SHELL=zsh bun getcompletes i)) 
			scripts="scripts:scripts:((${scripts_list//:/\\\\:}))" 
			IFS=$'\n' files_list=($(SHELL=zsh bun getcompletes j)) 
			main_commands=('run\:"Run JavaScript with Bun, a package.json script, or a bin" ' 'test\:"Run unit tests with Bun" ' 'x\:"Install and execute a package bin (bunx)" ' 'repl\:"Start a REPL session with Bun" ' 'init\:"Start an empty Bun project from a blank template" ' 'create\:"Create a new project from a template (bun c)" ' 'install\:"Install dependencies for a package.json (bun i)" ' 'add\:"Add a dependency to package.json (bun a)" ' 'remove\:"Remove a dependency from package.json (bun rm)" ' 'update\:"Update outdated dependencies & save to package.json" ' 'outdated\:"Display the latest versions of outdated dependencies" ' 'link\:"Link an npm package globally" ' 'unlink\:"Globally unlink an npm package" ' 'pm\:"More commands for managing packages" ' 'build\:"Bundle TypeScript & JavaScript into a single file" ' 'upgrade\:"Get the latest version of bun" ' 'help\:"Show all supported flags and commands" ') 
			main_commands=($main_commands) 
			_alternative "$scripts" "args:command:(($main_commands))" "files:files:(($files_list))" ;;
		(args) case $line[1] in
				(add | a) _bun_add_completion ;;
				(unlink) _bun_unlink_completion ;;
				(link) _bun_link_completion ;;
				(bun) _bun_bun_completion ;;
				(init) _bun_init_completion ;;
				(create | c) _bun_create_completion ;;
				(x) _arguments -s -C '1: :->cmd' '2: :->cmd2' '*: :->args' && ret=0  ;;
				(pm) _bun_pm_completion ;;
				(install | i) _bun_install_completion ;;
				(remove | rm) _bun_remove_completion ;;
				(run) _bun_run_completion ;;
				(upgrade) _bun_upgrade_completion ;;
				(build) _bun_build_completion ;;
				(update) _bun_update_completion ;;
				(outdated) _bun_outdated_completion ;;
				('test') _bun_test_completion ;;
				(help) _arguments -s -C '1: :->cmd' '2: :->cmd2' '*: :->args' && ret=0 
					case $state in
						(cmd2) curcontext="${curcontext%:*:*}:bun-grouped" 
							_alternative "args:command:(($main_commands))" ;;
						(args) case $line[2] in
								(add) _bun_add_completion ;;
								(unlink) _bun_unlink_completion ;;
								(link) _bun_link_completion ;;
								(bun) _bun_bun_completion ;;
								(init) _bun_init_completion ;;
								(create) _bun_create_completion ;;
								(x) _arguments -s -C '1: :->cmd' '2: :->cmd2' '*: :->args' && ret=0  ;;
								(pm) _bun_pm_completion ;;
								(install) _bun_install_completion ;;
								(remove) _bun_remove_completion ;;
								(run) _bun_run_completion ;;
								(upgrade) _bun_upgrade_completion ;;
								(build) _bun_build_completion ;;
								(update) _bun_update_completion ;;
								(outdated) _bun_outdated_completion ;;
								('test') _bun_test_completion ;;
							esac ;;
					esac ;;
			esac ;;
	esac
}
_bun_add_completion () {
	_arguments -s -C '1: :->cmd1' '*: :->package' '--config[Load config(bunfig.toml)]: :->config' '-c[Load config(bunfig.toml)]: :->config' '--yarn[Write a yarn.lock file (yarn v1)]' '-y[Write a yarn.lock file (yarn v1)]' '--production[Don'"'"'t install devDependencies]' '-p[Don'"'"'t install devDependencies]' '--no-save[Don'"'"'t save a lockfile]' '--save[Save to package.json]' '--dry-run[Don'"'"'t install anything]' '--frozen-lockfile[Disallow changes to lockfile]' '--force[Always request the latest versions from the registry & reinstall all dependencies]' '-f[Always request the latest versions from the registry & reinstall all dependencies]' '--cache-dir[Store & load cached data from a specific directory path]:cache-dir' '--no-cache[Ignore manifest cache entirely]' '--silent[Don'"'"'t log anything]' '--verbose[Excessively verbose logging]' '--no-progress[Disable the progress bar]' '--no-summary[Don'"'"'t print a summary]' '--no-verify[Skip verifying integrity of newly downloaded packages]' '--ignore-scripts[Skip lifecycle scripts in the package.json (dependency scripts are never run)]' '--global[Add a package globally]' '-g[Add a package globally]' '--cwd[Set a specific cwd]:cwd' '--backend[Platform-specific optimizations for installing dependencies]:backend:("copyfile" "hardlink" "symlink")' '--link-native-bins[Link "bin" from a matching platform-specific dependency instead. Default: esbuild, turbo]:link-native-bins' '--help[Print this help menu]' '--dev[Add dependence to "devDependencies]' '-d[Add dependence to "devDependencies]' '-D[]' '--development[]' '--optional[Add dependency to "optionalDependencies]' '--peer[Add dependency to "peerDependencies]' '--exact[Add the exact version instead of the ^range]' && ret=0 
	case $state in
		(config) _bun_list_bunfig_toml ;;
		(package) _bun_add_param_package_completion ;;
	esac
}
_bun_add_param_package_completion () {
	IFS=$'\n' inexact=($(history -n bun | grep -E "^bun add " | cut -c 9- | uniq)) 
	IFS=$'\n' exact=($($inexact | grep -E "^$words[$CURRENT]")) 
	IFS=$'\n' packages=($(SHELL=zsh bun getcompletes a $words[$CURRENT])) 
	to_print=$inexact 
	if [ ! -z "$exact" -a "$exact" != " " ]
	then
		to_print=$exact 
	fi
	if [ ! -z "$to_print" -a "$to_print" != " " ]
	then
		if [ ! -z "$packages" -a "$packages" != " " ]
		then
			_describe -1 -t to_print 'History' to_print
			_describe -1 -t packages "Popular" packages
			return
		fi
		_describe -1 -t to_print 'History' to_print
		return
	fi
	if [ ! -z "$packages" -a "$packages" != " " ]
	then
		_describe -1 -t packages "Popular" packages
		return
	fi
}
_bun_build_completion () {
	_arguments -s -C '1: :->cmd' '*: :->file' '--outfile[Write the output to a specific file (default: stdout)]:outfile' '--outdir[Write the output to a directory (required for splitting)]:outdir' '--minify[Enable all minification flags]' '--minify-whitespace[Remove unneeded whitespace]' '--minify-syntax[Transform code to use less syntax]' '--minify-identifiers[Shorten variable names]' '--sourcemap[Generate sourcemaps]: :->sourcemap' '--target[The intended execution environment for the bundle. "browser", "bun" or "node"]: :->target' '--splitting[Whether to enable code splitting (requires --outdir)]' '--compile[generating a standalone binary from a TypeScript or JavaScript file]' '--format[Specifies the module format to be used in the generated bundles]: :->format' && ret=0 
	case $state in
		(file) _files ;;
		(target) _alternative 'args:cmd3:((browser bun node))' ;;
		(sourcemap) _alternative 'args:cmd3:((none external inline))' ;;
		(format) _alternative 'args:cmd3:((esm cjs iife))' ;;
	esac
}
_bun_bun_completion () {
	_arguments -s -C '1: :->cmd' '*: :->file' '--version[Show version and exit]' '-V[Show version and exit]' '--cwd[Change directory]:cwd' '--help[Show command help]' '-h[Show command help]' '--use[Use a framework, e.g. "next"]:use' && ret=0 
	case $state in
		(file) _files ;;
	esac
}
_bun_create_completion () {
	_arguments -s -C '1: :->cmd' '2: :->cmd2' '*: :->args' && ret=0 
	case $state in
		(cmd2) _alternative 'args:create:((next-app\:"Next.js app" react-app\:"React app"))' ;;
		(args) case $line[2] in
				(next) pmargs=('1: :->cmd' '2: :->cmd2' '3: :->file' '--force[Overwrite existing files]' '--no-install[Don'"'"'t install node_modules]' '--no-git[Don'"'"'t create a git repository]' '--verbose[verbose]' '--no-package-json[Disable package.json transforms]' '--open[On finish, start bun & open in-browser]') 
					_arguments -s -C $pmargs && ret=0 
					case $state in
						(file) _files ;;
					esac ;;
				(react) _arguments -s -C $pmargs && ret=0 
					case $state in
						(file) _files ;;
					esac ;;
				(*) _arguments -s -C $pmargs && ret=0 
					case $state in
						(file) _files ;;
					esac ;;
			esac ;;
	esac
}
_bun_init_completion () {
	_arguments -s -C '1: :->cmd' '-y[Answer yes to all prompts]:' '--yes[Answer yes to all prompts]:' && ret=0 
}
_bun_install_completion () {
	_arguments -s -C '1: :->cmd1' '--config[Load config(bunfig.toml)]: :->config' '-c[Load config(bunfig.toml)]: :->config' '--yarn[Write a yarn.lock file (yarn v1)]' '-y[Write a yarn.lock file (yarn v1)]' '--production[Don'"'"'t install devDependencies]' '-p[Don'"'"'t install devDependencies]' '--no-save[Don'"'"'t save a lockfile]' '--save[Save to package.json]' '--dry-run[Don'"'"'t install anything]' '--frozen-lockfile[Disallow changes to lockfile]' '--force[Always request the latest versions from the registry & reinstall all dependencies]' '-f[Always request the latest versions from the registry & reinstall all dependencies]' '--cache-dir[Store & load cached data from a specific directory path]:cache-dir' '--no-cache[Ignore manifest cache entirely]' '--silent[Don'"'"'t log anything]' '--verbose[Excessively verbose logging]' '--no-progress[Disable the progress bar]' '--no-summary[Don'"'"'t print a summary]' '--no-verify[Skip verifying integrity of newly downloaded packages]' '--ignore-scripts[Skip lifecycle scripts in the package.json (dependency scripts are never run)]' '--global[Add a package globally]' '-g[Add a package globally]' '--cwd[Set a specific cwd]:cwd' '--backend[Platform-specific optimizations for installing dependencies]:backend:("copyfile" "hardlink" "symlink")' '--link-native-bins[Link "bin" from a matching platform-specific dependency instead. Default: esbuild, turbo]:link-native-bins' '--help[Print this help menu]' '--dev[Add dependence to "devDependencies]' '-d[Add dependence to "devDependencies]' '--development[]' '-D[]' '--optional[Add dependency to "optionalDependencies]' '--peer[Add dependency to "peerDependencies]' '--exact[Add the exact version instead of the ^range]' && ret=0 
	case $state in
		(config) _bun_list_bunfig_toml ;;
	esac
}
_bun_link_completion () {
	_arguments -s -C '1: :->cmd1' '*: :->package' '--config[Load config(bunfig.toml)]: :->config' '-c[Load config(bunfig.toml)]: :->config' '--yarn[Write a yarn.lock file (yarn v1)]' '-y[Write a yarn.lock file (yarn v1)]' '--production[Don'"'"'t install devDependencies]' '-p[Don'"'"'t install devDependencies]' '--no-save[Don'"'"'t save a lockfile]' '--save[Save to package.json]' '--dry-run[Don'"'"'t install anything]' '--frozen-lockfile[Disallow changes to lockfile]' '--force[Always request the latest versions from the registry & reinstall all dependencies]' '-f[Always request the latest versions from the registry & reinstall all dependencies]' '--cache-dir[Store & load cached data from a specific directory path]:cache-dir' '--no-cache[Ignore manifest cache entirely]' '--silent[Don'"'"'t log anything]' '--verbose[Excessively verbose logging]' '--no-progress[Disable the progress bar]' '--no-summary[Don'"'"'t print a summary]' '--no-verify[Skip verifying integrity of newly downloaded packages]' '--ignore-scripts[Skip lifecycle scripts in the package.json (dependency scripts are never run)]' '--global[Add a package globally]' '-g[Add a package globally]' '--cwd[Set a specific cwd]:cwd' '--backend[Platform-specific optimizations for installing dependencies]:backend:("copyfile" "hardlink" "symlink")' '--link-native-bins[Link "bin" from a matching platform-specific dependency instead. Default: esbuild, turbo]:link-native-bins' '--help[Print this help menu]' && ret=0 
	case $state in
		(config) _bun_list_bunfig_toml ;;
		(package) _bun_link_param_package_completion ;;
	esac
}
_bun_link_param_package_completion () {
	install_env=$BUN_INSTALL 
	install_dir=${(P)install_env:-$HOME/.bun} 
	global_node_modules=$install_dir/install/global/node_modules 
	local -a packages_full_path=(${global_node_modules}/*(N)) 
	packages=$(echo $packages_full_path | tr ' ' '\n' | xargs  basename) 
	_alternative "dirs:directory:(($packages))"
}
_bun_list_bunfig_toml () {
	_files
}
_bun_outdated_completion () {
	_arguments -s -C '--cwd[Set a specific cwd]:cwd' '--verbose[Excessively verbose logging]' '--no-progress[Disable the progress bar]' '--help[Print this help menu]' && ret=0 
	case $state in
		(config) _bun_list_bunfig_toml ;;
	esac
}
_bun_pm_completion () {
	_arguments -s -C '1: :->cmd' '2: :->cmd2' '*: :->args' && ret=0 
	case $state in
		(cmd2) sub_commands=('bin\:"print the path to bin folder" ' 'ls\:"list the dependency tree according to the current lockfile" ' 'hash\:"generate & print the hash of the current lockfile" ' 'hash-string\:"print the string used to hash the lockfile" ' 'hash-print\:"print the hash stored in the current lockfile" ' 'cache\:"print the path to the cache folder" ' 'version\:"bump the version in package.json and create a git tag" ') 
			_alternative "args:cmd3:(($sub_commands))" ;;
		(args) case $line[2] in
				(cache) _arguments -s -C '1: :->cmd' '2: :->cmd2' ':::(rm)' && ret=0  ;;
				(bin) pmargs=("-g[print the global path to bin folder]") 
					_arguments -s -C '1: :->cmd' '2: :->cmd2' $pmargs && ret=0  ;;
				(ls) pmargs=("--all[list the entire dependency tree according to the current lockfile]") 
					_arguments -s -C '1: :->cmd' '2: :->cmd2' $pmargs && ret=0  ;;
				(version) version_args=("patch[increment patch version]" "minor[increment minor version]" "major[increment major version]" "prepatch[increment patch version and add pre-release]" "preminor[increment minor version and add pre-release]" "premajor[increment major version and add pre-release]" "prerelease[increment pre-release version]" "from-git[use version from latest git tag]") 
					pmargs=("--no-git-tag-version[don't create a git commit and tag]" "--allow-same-version[allow bumping to the same version]" "-m[use the given message for the commit]:message" "--message[use the given message for the commit]:message" "--preid[identifier to prefix pre-release versions]:preid") 
					_arguments -s -C '1: :->cmd' '2: :->cmd2' '3: :->increment' $pmargs && ret=0 
					case $state in
						(increment) _alternative "args:increment:(($version_args))" ;;
					esac ;;
			esac ;;
	esac
}
_bun_remove_completion () {
	_arguments -s -C '1: :->cmd1' '*: :->package' '--config[Load config(bunfig.toml)]: :->config' '-c[Load config(bunfig.toml)]: :->config' '--yarn[Write a yarn.lock file (yarn v1)]' '-y[Write a yarn.lock file (yarn v1)]' '--production[Don'"'"'t install devDependencies]' '-p[Don'"'"'t install devDependencies]' '--no-save[Don'"'"'t save a lockfile]' '--save[Save to package.json]' '--dry-run[Don'"'"'t install anything]' '--frozen-lockfile[Disallow changes to lockfile]' '--force[Always request the latest versions from the registry & reinstall all dependencies]' '-f[Always request the latest versions from the registry & reinstall all dependencies]' '--cache-dir[Store & load cached data from a specific directory path]:cache-dir' '--no-cache[Ignore manifest cache entirely]' '--silent[Don'"'"'t log anything]' '--verbose[Excessively verbose logging]' '--no-progress[Disable the progress bar]' '--no-summary[Don'"'"'t print a summary]' '--no-verify[Skip verifying integrity of newly downloaded packages]' '--ignore-scripts[Skip lifecycle scripts in the package.json (dependency scripts are never run)]' '--global[Add a package globally]' '-g[Add a package globally]' '--cwd[Set a specific cwd]:cwd' '--backend[Platform-specific optimizations for installing dependencies]:backend:("copyfile" "hardlink" "symlink")' '--link-native-bins[Link "bin" from a matching platform-specific dependency instead. Default: esbuild, turbo]:link-native-bins' '--help[Print this help menu]' && ret=0 
	case $state in
		(config) _bun_list_bunfig_toml ;;
		(package) _bun_remove_param_package_completion ;;
	esac
}
_bun_remove_param_package_completion () {
	if ! command -v jq &> /dev/null
	then
		return
	fi
	if [ -f "package.json" ]
	then
		local dependencies=$(jq -r '.dependencies | keys[]' package.json) 
		local dev_dependencies=$(jq -r '.devDependencies | keys[]' package.json) 
		_alternative "deps:dependency:(($dependencies))"
		_alternative "deps:dependency:(($dev_dependencies))"
	fi
}
_bun_run_completion () {
	_arguments -s -C '1: :->cmd' '2: :->script' '*: :->other' '--help[Display this help and exit]' '-h[Display this help and exit]' '--bun[Force a script or package to use Bun'"'"'s runtime instead of Node.js (via symlinking node)]' '-b[Force a script or package to use Bun'"'"'s runtime instead of Node.js (via symlinking node)]' '--cwd[Absolute path to resolve files & entry points from. This just changes the process cwd]:cwd' '--config[Config file to load bun from (e.g. -c bunfig.toml]: :->config' '-c[Config file to load bun from (e.g. -c bunfig.toml]: :->config' '--env-file[Load environment variables from the specified file(s)]:env-file' '--extension-order[Defaults to: .tsx,.ts,.jsx,.js,.json]:extension-order' '--jsx-factory[Changes the function called when compiling JSX elements using the classic JSX runtime]:jsx-factory' '--jsx-fragment[Changes the function called when compiling JSX fragments]:jsx-fragment' '--jsx-import-source[Declares the module specifier to be used for importing the jsx and jsxs factory functions. Default: "react"]:jsx-import-source' '--jsx-runtime["automatic" (default) or "classic"]: :->jsx-runtime' '--preload[Import a module before other modules are loaded]:preload' '-r[Import a module before other modules are loaded]:preload' '--main-fields[Main fields to lookup in package.json. Defaults to --target dependent]:main-fields' '--no-summary[Don'"'"'t print a summary]' '--version[Print version and exit]' '-v[Print version and exit]' '--revision[Print version with revision and exit]' '--tsconfig-override[Load tsconfig from path instead of cwd/tsconfig.json]:tsconfig-override' '--define[Substitute K:V while parsing, e.g. --define process.env.NODE_ENV:"development". Values are parsed as JSON.]:define' '-d[Substitute K:V while parsing, e.g. --define process.env.NODE_ENV:"development". Values are parsed as JSON.]:define' '--external[Exclude module from transpilation (can use * wildcards). ex: -e react]:external' '-e[Exclude module from transpilation (can use * wildcards). ex: -e react]:external' '--loader[Parse files with .ext:loader, e.g. --loader .js:jsx. Valid loaders: js, jsx, ts, tsx, json, toml, text, file, wasm, napi]:loader' '--packages[Exclude dependencies from bundle, e.g. --packages external. Valid options: bundle, external]:packages' '-l[Parse files with .ext:loader, e.g. --loader .js:jsx. Valid loaders: js, jsx, ts, tsx, json, toml, text, file, wasm, napi]:loader' '--origin[Rewrite import URLs to start with --origin. Default: ""]:origin' '-u[Rewrite import URLs to start with --origin. Default: ""]:origin' '--port[Port to serve bun'"'"'s dev server on. Default: '"'"'3000'"'"']:port' '-p[Port to serve bun'"'"'s dev server on. Default: '"'"'3000'"'"']:port' '--smol[Use less memory, but run garbage collection more often]' '--minify[Minify (experimental)]' '--minify-syntax[Minify syntax and inline data (experimental)]' '--minify-whitespace[Minify Whitespace (experimental)]' '--minify-identifiers[Minify identifiers]' '--no-macros[Disable macros from being executed in the bundler, transpiler and runtime]' '--target[The intended execution environment for the bundle. "browser", "bun" or "node"]: :->target' '--inspect[Activate Bun'"'"'s Debugger]:inspect' '--inspect-wait[Activate Bun'"'"'s Debugger, wait for a connection before executing]:inspect-wait' '--inspect-brk[Activate Bun'"'"'s Debugger, set breakpoint on first line of code and wait]:inspect-brk' '--hot[Enable auto reload in bun'"'"'s JavaScript runtime]' '--watch[Automatically restart bun'"'"'s JavaScript runtime on file change]' '--no-install[Disable auto install in bun'"'"'s JavaScript runtime]' '--install[Install dependencies automatically when no node_modules are present, default: "auto". "force" to ignore node_modules, fallback to install any missing]: :->install_' '-i[Automatically install dependencies and use global cache in bun'"'"'s runtime, equivalent to --install=fallback'] '--prefer-offline[Skip staleness checks for packages in bun'"'"'s JavaScript runtime and resolve from disk]' '--prefer-latest[Use the latest matching versions of packages in bun'"'"'s JavaScript runtime, always checking npm]' '--silent[Don'"'"'t repeat the command for bun run]' '--dump-environment-variables[Dump environment variables from .env and process as JSON and quit. Useful for debugging]' '--dump-limits[Dump system limits. Userful for debugging]' && ret=0 
	case $state in
		(script) curcontext="${curcontext%:*:*}:bun-grouped" 
			_bun_run_param_script_completion ;;
		(jsx-runtime) _alternative 'args:cmd3:((classic automatic))' ;;
		(target) _alternative 'args:cmd3:((browser bun node))' ;;
		(install_) _alternative 'args:cmd3:((auto force fallback))' ;;
		(other) _files ;;
	esac
}
_bun_run_param_script_completion () {
	local -a scripts_list
	IFS=$'\n' scripts_list=($(SHELL=zsh bun getcompletes s)) 
	IFS=$'\n' bins=($(SHELL=zsh bun getcompletes b)) 
	_alternative "scripts:scripts:((${scripts_list//:/\\\\:}))"
	_alternative "bin:bin:((${bins//:/\\\\:}))"
	_alternative "files:file:_files -g '*.(js|ts|jsx|tsx|wasm)'"
}
_bun_test_completion () {
	_arguments -s -C '1: :->cmd1' '*: :->file' '-h[Display this help and exit]' '--help[Display this help and exit]' '-b[Force a script or package to use Bun.js instead of Node.js (via symlinking node)]' '--bun[Force a script or package to use Bun.js instead of Node.js (via symlinking node)]' '--cwd[Set a specific cwd]:cwd' '-c[Load config(bunfig.toml)]: :->config' '--config[Load config(bunfig.toml)]: :->config' '--env-file[Load environment variables from the specified file(s)]:env-file' '--extension-order[Defaults to: .tsx,.ts,.jsx,.js,.json]:extension-order' '--jsx-factory[Changes the function called when compiling JSX elements using the classic JSX runtime]:jsx-factory' '--jsx-fragment[Changes the function called when compiling JSX fragments]:jsx-fragment' '--jsx-import-source[Declares the module specifier to be used for importing the jsx and jsxs factory functions. Default: "react"]:jsx-import-source' '--jsx-runtime["automatic" (default) or "classic"]: :->jsx-runtime' '--preload[Import a module before other modules are loaded]:preload' '-r[Import a module before other modules are loaded]:preload' '--main-fields[Main fields to lookup in package.json. Defaults to --target dependent]:main-fields' '--no-summary[Don'"'"'t print a summary]' '--version[Print version and exit]' '-v[Print version and exit]' '--revision[Print version with revision and exit]' '--tsconfig-override[Load tsconfig from path instead of cwd/tsconfig.json]:tsconfig-override' '--define[Substitute K:V while parsing, e.g. --define process.env.NODE_ENV:"development". Values are parsed as JSON.]:define' '-d[Substitute K:V while parsing, e.g. --define process.env.NODE_ENV:"development". Values are parsed as JSON.]:define' '--external[Exclude module from transpilation (can use * wildcards). ex: -e react]:external' '-e[Exclude module from transpilation (can use * wildcards). ex: -e react]:external' '--loader[Parse files with .ext:loader, e.g. --loader .js:jsx. Valid loaders: js, jsx, ts, tsx, json, toml, text, file, wasm, napi]:loader' '-l[Parse files with .ext:loader, e.g. --loader .js:jsx. Valid loaders: js, jsx, ts, tsx, json, toml, text, file, wasm, napi]:loader' '--origin[Rewrite import URLs to start with --origin. Default: ""]:origin' '-u[Rewrite import URLs to start with --origin. Default: ""]:origin' '--port[Port to serve bun'"'"'s dev server on. Default: '"'"'3000'"'"']:port' '-p[Port to serve bun'"'"'s dev server on. Default: '"'"'3000'"'"']:port' '--smol[Use less memory, but run garbage collection more often]' '--minify[Minify (experimental)]' '--minify-syntax[Minify syntax and inline data (experimental)]' '--minify-identifiers[Minify identifiers]' '--no-macros[Disable macros from being executed in the bundler, transpiler and runtime]' '--target[The intended execution environment for the bundle. "browser", "bun" or "node"]: :->target' '--inspect[Activate Bun'"'"'s Debugger]:inspect' '--inspect-wait[Activate Bun'"'"'s Debugger, wait for a connection before executing]:inspect-wait' '--inspect-brk[Activate Bun'"'"'s Debugger, set breakpoint on first line of code and wait]:inspect-brk' '--watch[Automatically restart bun'"'"'s JavaScript runtime on file change]' '--timeout[Set the per-test timeout in milliseconds, default is 5000.]:timeout' '--update-snapshots[Update snapshot files]' '--rerun-each[Re-run each test file <NUMBER> times, helps catch certain bugs]:rerun' '--only[Only run tests that are marked with "test.only()"]' '--todo[Include tests that are marked with "test.todo()"]' '--coverage[Generate a coverage profile]' '--bail[Exit the test suite after <NUMBER> failures. If you do not specify a number, it defaults to 1.]:bail' '--test-name-pattern[Run only tests with a name that matches the given regex]:pattern' '-t[Run only tests with a name that matches the given regex]:pattern' && ret=0 
	case $state in
		(file) _bun_test_param_script_completion ;;
		(config) _files ;;
	esac
}
_bun_test_param_script_completion () {
	local -a scripts_list
	_alternative "files:file:_files -g '*(_|.)(test|spec).(js|ts|jsx|tsx)'"
}
_bun_unlink_completion () {
	_arguments -s -C '1: :->cmd1' '*: :->package' '--config[Load config(bunfig.toml)]: :->config' '-c[Load config(bunfig.toml)]: :->config' '--yarn[Write a yarn.lock file (yarn v1)]' '-y[Write a yarn.lock file (yarn v1)]' '--production[Don'"'"'t install devDependencies]' '-p[Don'"'"'t install devDependencies]' '--no-save[Don'"'"'t save a lockfile]' '--save[Save to package.json]' '--dry-run[Don'"'"'t install anything]' '--frozen-lockfile[Disallow changes to lockfile]' '--force[Always request the latest versions from the registry & reinstall all dependencies]' '-f[Always request the latest versions from the registry & reinstall all dependencies]' '--cache-dir[Store & load cached data from a specific directory path]:cache-dir' '--no-cache[Ignore manifest cache entirely]' '--silent[Don'"'"'t log anything]' '--verbose[Excessively verbose logging]' '--no-progress[Disable the progress bar]' '--no-summary[Don'"'"'t print a summary]' '--no-verify[Skip verifying integrity of newly downloaded packages]' '--ignore-scripts[Skip lifecycle scripts in the package.json (dependency scripts are never run)]' '--global[Add a package globally]' '-g[Add a package globally]' '--cwd[Set a specific cwd]:cwd' '--backend[Platform-specific optimizations for installing dependencies]:backend:("copyfile" "hardlink" "symlink")' '--link-native-bins[Link "bin" from a matching platform-specific dependency instead. Default: esbuild, turbo]:link-native-bins' '--help[Print this help menu]' && ret=0 
	case $state in
		(config) _bun_list_bunfig_toml ;;
		(package)  ;;
	esac
}
_bun_update_completion () {
	_arguments -s -C '1: :->cmd1' '-c[Load config(bunfig.toml)]: :->config' '--config[Load config(bunfig.toml)]: :->config' '-y[Write a yarn.lock file (yarn v1)]' '--yarn[Write a yarn.lock file (yarn v1)]' '-p[Don'"'"'t install devDependencies]' '--production[Don'"'"'t install devDependencies]' '--no-save[Don'"'"'t save a lockfile]' '--save[Save to package.json]' '--dry-run[Don'"'"'t install anything]' '--frozen-lockfile[Disallow changes to lockfile]' '--latest[Updates dependencies to latest version, regardless of compatibility]' '-f[Always request the latest versions from the registry & reinstall all dependencies]' '--force[Always request the latest versions from the registry & reinstall all dependencies]' '--cache-dir[Store & load cached data from a specific directory path]:cache-dir' '--no-cache[Ignore manifest cache entirely]' '--silent[Don'"'"'t log anything]' '--verbose[Excessively verbose logging]' '--no-progress[Disable the progress bar]' '--no-summary[Don'"'"'t print a summary]' '--no-verify[Skip verifying integrity of newly downloaded packages]' '--ignore-scripts[Skip lifecycle scripts in the package.json (dependency scripts are never run)]' '-g[Add a package globally]' '--global[Add a package globally]' '--cwd[Set a specific cwd]:cwd' '--backend[Platform-specific optimizations for installing dependencies]:backend:("copyfile" "hardlink" "symlink")' '--link-native-bins[Link "bin" from a matching platform-specific dependency instead. Default: esbuild, turbo]:link-native-bins' '--help[Print this help menu]' && ret=0 
	case $state in
		(config) _bun_list_bunfig_toml ;;
	esac
}
_bun_upgrade_completion () {
	_arguments -s -C '1: :->cmd' '--canary[Upgrade to canary build]' && ret=0 
}
_bundler () {
	# undefined
	builtin autoload -XUz
}
_busctl () {
	# undefined
	builtin autoload -XUz
}
_bwrap () {
	# undefined
	builtin autoload -XUz
}
_bzip2 () {
	# undefined
	builtin autoload -XUz
}
_bzr () {
	# undefined
	builtin autoload -XUz
}
_cabal () {
	# undefined
	builtin autoload -XUz
}
_cache_invalid () {
	# undefined
	builtin autoload -XUz
}
_caffeinate () {
	# undefined
	builtin autoload -XUz
}
_cal () {
	# undefined
	builtin autoload -XUz
}
_calendar () {
	# undefined
	builtin autoload -XUz
}
_call_function () {
	# undefined
	builtin autoload -XUz
}
_call_program () {
	local -xi COLUMNS=999 
	local curcontext="${curcontext}" tmp err_fd=-1 clocale='_comp_locale;' 
	local -a prefix
	if [[ "$1" = -p ]]
	then
		shift
		if (( $#_comp_priv_prefix ))
		then
			curcontext="${curcontext%:*}/${${(@M)_comp_priv_prefix:#^*[^\\]=*}[1]}:" 
			zstyle -t ":completion:${curcontext}:${1}" gain-privileges && prefix=($_comp_priv_prefix) 
		fi
	elif [[ "$1" = -l ]]
	then
		shift
		clocale='' 
	fi
	if (( ${debug_fd:--1} > 2 )) || [[ ! -t 2 ]]
	then
		exec {err_fd}>&2
	else
		exec {err_fd}> /dev/null
	fi
	{
		if zstyle -s ":completion:${curcontext}:${1}" command tmp
		then
			if [[ "$tmp" = -* ]]
			then
				eval $clocale "$tmp[2,-1]" "$argv[2,-1]"
			else
				eval $clocale $prefix "$tmp"
			fi
		else
			eval $clocale $prefix "$argv[2,-1]"
		fi 2>&$err_fd
	} always {
		exec {err_fd}>&-
	}
}
_canonical_paths () {
	# undefined
	builtin autoload -XUz
}
_capabilities () {
	# undefined
	builtin autoload -XUz
}
_cat () {
	# undefined
	builtin autoload -XUz
}
_ccal () {
	# undefined
	builtin autoload -XUz
}
_cd () {
	# undefined
	builtin autoload -XUz
}
_cdbs-edit-patch () {
	# undefined
	builtin autoload -XUz
}
_cdcd () {
	# undefined
	builtin autoload -XUz
}
_cdr () {
	# undefined
	builtin autoload -XUz
}
_cdrdao () {
	# undefined
	builtin autoload -XUz
}
_cdrecord () {
	# undefined
	builtin autoload -XUz
}
_chattr () {
	# undefined
	builtin autoload -XUz
}
_chcon () {
	# undefined
	builtin autoload -XUz
}
_chflags () {
	# undefined
	builtin autoload -XUz
}
_chkconfig () {
	# undefined
	builtin autoload -XUz
}
_chmod () {
	# undefined
	builtin autoload -XUz
}
_choom () {
	# undefined
	builtin autoload -XUz
}
_chown () {
	# undefined
	builtin autoload -XUz
}
_chroot () {
	# undefined
	builtin autoload -XUz
}
_chrt () {
	# undefined
	builtin autoload -XUz
}
_chsh () {
	# undefined
	builtin autoload -XUz
}
_cksum () {
	# undefined
	builtin autoload -XUz
}
_clay () {
	# undefined
	builtin autoload -XUz
}
_cmdambivalent () {
	# undefined
	builtin autoload -XUz
}
_cmdstring () {
	# undefined
	builtin autoload -XUz
}
_cmp () {
	# undefined
	builtin autoload -XUz
}
_code () {
	# undefined
	builtin autoload -XUz
}
_column () {
	# undefined
	builtin autoload -XUz
}
_combination () {
	# undefined
	builtin autoload -XUz
}
_comm () {
	# undefined
	builtin autoload -XUz
}
_command () {
	# undefined
	builtin autoload -XUz
}
_command_names () {
	# undefined
	builtin autoload -XUz
}
_comp_locale () {
	# undefined
	builtin autoload -XUz
}
_compadd () {
	# undefined
	builtin autoload -XUz
}
_compdef () {
	# undefined
	builtin autoload -XUz
}
_complete () {
	# undefined
	builtin autoload -XUz
}
_complete_debug () {
	# undefined
	builtin autoload -XUz
}
_complete_help () {
	# undefined
	builtin autoload -XUz
}
_complete_help_generic () {
	# undefined
	builtin autoload -XUz
}
_complete_tag () {
	# undefined
	builtin autoload -XUz
}
_completers () {
	# undefined
	builtin autoload -XUz
}
_composer () {
	# undefined
	builtin autoload -XUz
}
_compress () {
	# undefined
	builtin autoload -XUz
}
_condition () {
	# undefined
	builtin autoload -XUz
}
_configure () {
	# undefined
	builtin autoload -XUz
}
_coreadm () {
	# undefined
	builtin autoload -XUz
}
_correct () {
	# undefined
	builtin autoload -XUz
}
_correct_filename () {
	# undefined
	builtin autoload -XUz
}
_correct_word () {
	# undefined
	builtin autoload -XUz
}
_cowsay () {
	# undefined
	builtin autoload -XUz
}
_cp () {
	# undefined
	builtin autoload -XUz
}
_cpio () {
	# undefined
	builtin autoload -XUz
}
_cplay () {
	# undefined
	builtin autoload -XUz
}
_cpupower () {
	# undefined
	builtin autoload -XUz
}
_crontab () {
	# undefined
	builtin autoload -XUz
}
_cryptsetup () {
	# undefined
	builtin autoload -XUz
}
_cscope () {
	# undefined
	builtin autoload -XUz
}
_csplit () {
	# undefined
	builtin autoload -XUz
}
_cssh () {
	# undefined
	builtin autoload -XUz
}
_csup () {
	# undefined
	builtin autoload -XUz
}
_ctags () {
	# undefined
	builtin autoload -XUz
}
_ctags_tags () {
	# undefined
	builtin autoload -XUz
}
_cu () {
	# undefined
	builtin autoload -XUz
}
_curl () {
	# undefined
	builtin autoload -XUz
}
_cursor () {
	# undefined
	builtin autoload -XUz
}
_cut () {
	# undefined
	builtin autoload -XUz
}
_cvs () {
	# undefined
	builtin autoload -XUz
}
_cvsup () {
	# undefined
	builtin autoload -XUz
}
_cygcheck () {
	# undefined
	builtin autoload -XUz
}
_cygpath () {
	# undefined
	builtin autoload -XUz
}
_cygrunsrv () {
	# undefined
	builtin autoload -XUz
}
_cygserver () {
	# undefined
	builtin autoload -XUz
}
_cygstart () {
	# undefined
	builtin autoload -XUz
}
_dak () {
	# undefined
	builtin autoload -XUz
}
_darcs () {
	# undefined
	builtin autoload -XUz
}
_date () {
	# undefined
	builtin autoload -XUz
}
_date_formats () {
	# undefined
	builtin autoload -XUz
}
_dates () {
	# undefined
	builtin autoload -XUz
}
_dbus () {
	# undefined
	builtin autoload -XUz
}
_dchroot () {
	# undefined
	builtin autoload -XUz
}
_dchroot-dsa () {
	# undefined
	builtin autoload -XUz
}
_dconf () {
	# undefined
	builtin autoload -XUz
}
_dcop () {
	# undefined
	builtin autoload -XUz
}
_dcut () {
	# undefined
	builtin autoload -XUz
}
_dd () {
	# undefined
	builtin autoload -XUz
}
_deb_architectures () {
	# undefined
	builtin autoload -XUz
}
_deb_codenames () {
	# undefined
	builtin autoload -XUz
}
_deb_files () {
	# undefined
	builtin autoload -XUz
}
_deb_packages () {
	# undefined
	builtin autoload -XUz
}
_debbugs_bugnumber () {
	# undefined
	builtin autoload -XUz
}
_debchange () {
	# undefined
	builtin autoload -XUz
}
_debcheckout () {
	# undefined
	builtin autoload -XUz
}
_debdiff () {
	# undefined
	builtin autoload -XUz
}
_debfoster () {
	# undefined
	builtin autoload -XUz
}
_deborphan () {
	# undefined
	builtin autoload -XUz
}
_debsign () {
	# undefined
	builtin autoload -XUz
}
_debsnap () {
	# undefined
	builtin autoload -XUz
}
_debuild () {
	# undefined
	builtin autoload -XUz
}
_default () {
	# undefined
	builtin autoload -XUz
}
_defaults () {
	# undefined
	builtin autoload -XUz
}
_defer_async_git_register () {
	case "${PS1}:${PS2}:${PS3}:${PS4}:${RPROMPT}:${RPS1}:${RPS2}:${RPS3}:${RPS4}" in
		(*(\$\(git_prompt_info\)|\`git_prompt_info\`)*) _omz_register_handler _omz_git_prompt_info ;;
	esac
	case "${PS1}:${PS2}:${PS3}:${PS4}:${RPROMPT}:${RPS1}:${RPS2}:${RPS3}:${RPS4}" in
		(*(\$\(git_prompt_status\)|\`git_prompt_status\`)*) _omz_register_handler _omz_git_prompt_status ;;
	esac
	add-zsh-hook -d precmd _defer_async_git_register
	unset -f _defer_async_git_register
}
_delimiters () {
	# undefined
	builtin autoload -XUz
}
_describe () {
	# undefined
	builtin autoload -XUz
}
_description () {
	# undefined
	builtin autoload -XUz
}
_devtodo () {
	# undefined
	builtin autoload -XUz
}
_df () {
	# undefined
	builtin autoload -XUz
}
_dhclient () {
	# undefined
	builtin autoload -XUz
}
_dhcpinfo () {
	# undefined
	builtin autoload -XUz
}
_dict () {
	# undefined
	builtin autoload -XUz
}
_dict_words () {
	# undefined
	builtin autoload -XUz
}
_diff () {
	# undefined
	builtin autoload -XUz
}
_diff3 () {
	# undefined
	builtin autoload -XUz
}
_diff_options () {
	# undefined
	builtin autoload -XUz
}
_diffstat () {
	# undefined
	builtin autoload -XUz
}
_dig () {
	# undefined
	builtin autoload -XUz
}
_dir_list () {
	# undefined
	builtin autoload -XUz
}
_directories () {
	# undefined
	builtin autoload -XUz
}
_directory_stack () {
	# undefined
	builtin autoload -XUz
}
_dirs () {
	# undefined
	builtin autoload -XUz
}
_disable () {
	# undefined
	builtin autoload -XUz
}
_dispatch () {
	# undefined
	builtin autoload -XUz
}
_django () {
	# undefined
	builtin autoload -XUz
}
_dkms () {
	# undefined
	builtin autoload -XUz
}
_dladm () {
	# undefined
	builtin autoload -XUz
}
_dlocate () {
	# undefined
	builtin autoload -XUz
}
_dmesg () {
	# undefined
	builtin autoload -XUz
}
_dmidecode () {
	# undefined
	builtin autoload -XUz
}
_dnf () {
	# undefined
	builtin autoload -XUz
}
_dns_types () {
	# undefined
	builtin autoload -XUz
}
_doas () {
	# undefined
	builtin autoload -XUz
}
_docker () {
	# undefined
	builtin autoload -XUz
}
_domains () {
	# undefined
	builtin autoload -XUz
}
_dos2unix () {
	# undefined
	builtin autoload -XUz
}
_dpatch-edit-patch () {
	# undefined
	builtin autoload -XUz
}
_dpkg () {
	# undefined
	builtin autoload -XUz
}
_dpkg-buildpackage () {
	# undefined
	builtin autoload -XUz
}
_dpkg-cross () {
	# undefined
	builtin autoload -XUz
}
_dpkg-parsechangelog () {
	# undefined
	builtin autoload -XUz
}
_dpkg-repack () {
	# undefined
	builtin autoload -XUz
}
_dpkg_source () {
	# undefined
	builtin autoload -XUz
}
_dput () {
	# undefined
	builtin autoload -XUz
}
_drill () {
	# undefined
	builtin autoload -XUz
}
_dropbox () {
	# undefined
	builtin autoload -XUz
}
_dscverify () {
	# undefined
	builtin autoload -XUz
}
_dsh () {
	# undefined
	builtin autoload -XUz
}
_dtrace () {
	# undefined
	builtin autoload -XUz
}
_dtruss () {
	# undefined
	builtin autoload -XUz
}
_du () {
	# undefined
	builtin autoload -XUz
}
_dumpadm () {
	# undefined
	builtin autoload -XUz
}
_dumper () {
	# undefined
	builtin autoload -XUz
}
_dupload () {
	# undefined
	builtin autoload -XUz
}
_dvi () {
	# undefined
	builtin autoload -XUz
}
_dynamic_directory_name () {
	# undefined
	builtin autoload -XUz
}
_e2label () {
	# undefined
	builtin autoload -XUz
}
_ecasound () {
	# undefined
	builtin autoload -XUz
}
_echotc () {
	# undefined
	builtin autoload -XUz
}
_echoti () {
	# undefined
	builtin autoload -XUz
}
_ed () {
	# undefined
	builtin autoload -XUz
}
_elfdump () {
	# undefined
	builtin autoload -XUz
}
_elinks () {
	# undefined
	builtin autoload -XUz
}
_email_addresses () {
	# undefined
	builtin autoload -XUz
}
_emulate () {
	# undefined
	builtin autoload -XUz
}
_enable () {
	# undefined
	builtin autoload -XUz
}
_enscript () {
	# undefined
	builtin autoload -XUz
}
_entr () {
	# undefined
	builtin autoload -XUz
}
_env () {
	# undefined
	builtin autoload -XUz
}
_eog () {
	# undefined
	builtin autoload -XUz
}
_equal () {
	# undefined
	builtin autoload -XUz
}
_espeak () {
	# undefined
	builtin autoload -XUz
}
_etags () {
	# undefined
	builtin autoload -XUz
}
_ethtool () {
	# undefined
	builtin autoload -XUz
}
_evince () {
	# undefined
	builtin autoload -XUz
}
_exec () {
	# undefined
	builtin autoload -XUz
}
_expand () {
	# undefined
	builtin autoload -XUz
}
_expand_alias () {
	# undefined
	builtin autoload -XUz
}
_expand_word () {
	# undefined
	builtin autoload -XUz
}
_extensions () {
	# undefined
	builtin autoload -XUz
}
_external_pwds () {
	# undefined
	builtin autoload -XUz
}
_fakeroot () {
	# undefined
	builtin autoload -XUz
}
_fast-theme () {
	# undefined
	builtin autoload -XUz
}
_fbsd_architectures () {
	# undefined
	builtin autoload -XUz
}
_fbsd_device_types () {
	# undefined
	builtin autoload -XUz
}
_fc () {
	# undefined
	builtin autoload -XUz
}
_feh () {
	# undefined
	builtin autoload -XUz
}
_fetch () {
	# undefined
	builtin autoload -XUz
}
_fetchmail () {
	# undefined
	builtin autoload -XUz
}
_ffmpeg () {
	# undefined
	builtin autoload -XUz
}
_figlet () {
	# undefined
	builtin autoload -XUz
}
_file_descriptors () {
	# undefined
	builtin autoload -XUz
}
_file_flags () {
	# undefined
	builtin autoload -XUz
}
_file_modes () {
	# undefined
	builtin autoload -XUz
}
_file_systems () {
	# undefined
	builtin autoload -XUz
}
_files () {
	# undefined
	builtin autoload -XUz
}
_find () {
	# undefined
	builtin autoload -XUz
}
_find_net_interfaces () {
	# undefined
	builtin autoload -XUz
}
_findmnt () {
	# undefined
	builtin autoload -XUz
}
_finger () {
	# undefined
	builtin autoload -XUz
}
_fink () {
	# undefined
	builtin autoload -XUz
}
_first () {
	# undefined
	builtin autoload -XUz
}
_flac () {
	# undefined
	builtin autoload -XUz
}
_flex () {
	# undefined
	builtin autoload -XUz
}
_floppy () {
	# undefined
	builtin autoload -XUz
}
_flowadm () {
	# undefined
	builtin autoload -XUz
}
_fmadm () {
	# undefined
	builtin autoload -XUz
}
_fmt () {
	# undefined
	builtin autoload -XUz
}
_fold () {
	# undefined
	builtin autoload -XUz
}
_fortune () {
	# undefined
	builtin autoload -XUz
}
_free () {
	# undefined
	builtin autoload -XUz
}
_freebsd-update () {
	# undefined
	builtin autoload -XUz
}
_fs_usage () {
	# undefined
	builtin autoload -XUz
}
_fsh () {
	# undefined
	builtin autoload -XUz
}
_fstat () {
	# undefined
	builtin autoload -XUz
}
_functions () {
	# undefined
	builtin autoload -XUz
}
_fuse_arguments () {
	# undefined
	builtin autoload -XUz
}
_fuse_values () {
	# undefined
	builtin autoload -XUz
}
_fuser () {
	# undefined
	builtin autoload -XUz
}
_fusermount () {
	# undefined
	builtin autoload -XUz
}
_fw_update () {
	# undefined
	builtin autoload -XUz
}
_gcc () {
	# undefined
	builtin autoload -XUz
}
_gcore () {
	# undefined
	builtin autoload -XUz
}
_gdb () {
	# undefined
	builtin autoload -XUz
}
_geany () {
	# undefined
	builtin autoload -XUz
}
_gem () {
	# undefined
	builtin autoload -XUz
}
_generic () {
	# undefined
	builtin autoload -XUz
}
_genisoimage () {
	# undefined
	builtin autoload -XUz
}
_getclip () {
	# undefined
	builtin autoload -XUz
}
_getconf () {
	# undefined
	builtin autoload -XUz
}
_getent () {
	# undefined
	builtin autoload -XUz
}
_getfacl () {
	# undefined
	builtin autoload -XUz
}
_getmail () {
	# undefined
	builtin autoload -XUz
}
_getopt () {
	# undefined
	builtin autoload -XUz
}
_gh () {
	# undefined
	builtin autoload -XUz
}
_ghostscript () {
	# undefined
	builtin autoload -XUz
}
_git () {
	# undefined
	builtin autoload -XUz
}
_git-buildpackage () {
	# undefined
	builtin autoload -XUz
}
_git_log_prettily () {
	if ! [ -z $1 ]
	then
		git log --pretty=$1
	fi
}
_global () {
	# undefined
	builtin autoload -XUz
}
_global_tags () {
	# undefined
	builtin autoload -XUz
}
_globflags () {
	# undefined
	builtin autoload -XUz
}
_globqual_delims () {
	# undefined
	builtin autoload -XUz
}
_globquals () {
	# undefined
	builtin autoload -XUz
}
_gnome-gv () {
	# undefined
	builtin autoload -XUz
}
_gnu_generic () {
	# undefined
	builtin autoload -XUz
}
_gnupod () {
	# undefined
	builtin autoload -XUz
}
_gnutls () {
	# undefined
	builtin autoload -XUz
}
_go () {
	# undefined
	builtin autoload -XUz
}
_gpasswd () {
	# undefined
	builtin autoload -XUz
}
_gpg () {
	# undefined
	builtin autoload -XUz
}
_gphoto2 () {
	# undefined
	builtin autoload -XUz
}
_gprof () {
	# undefined
	builtin autoload -XUz
}
_gqview () {
	# undefined
	builtin autoload -XUz
}
_gradle () {
	# undefined
	builtin autoload -XUz
}
_graphicsmagick () {
	# undefined
	builtin autoload -XUz
}
_grep () {
	# undefined
	builtin autoload -XUz
}
_grep-excuses () {
	# undefined
	builtin autoload -XUz
}
_groff () {
	# undefined
	builtin autoload -XUz
}
_groups () {
	# undefined
	builtin autoload -XUz
}
_growisofs () {
	# undefined
	builtin autoload -XUz
}
_gsettings () {
	# undefined
	builtin autoload -XUz
}
_gstat () {
	# undefined
	builtin autoload -XUz
}
_guard () {
	# undefined
	builtin autoload -XUz
}
_guilt () {
	# undefined
	builtin autoload -XUz
}
_gv () {
	# undefined
	builtin autoload -XUz
}
_gzip () {
	# undefined
	builtin autoload -XUz
}
_hash () {
	# undefined
	builtin autoload -XUz
}
_have_glob_qual () {
	# undefined
	builtin autoload -XUz
}
_hdiutil () {
	# undefined
	builtin autoload -XUz
}
_head () {
	# undefined
	builtin autoload -XUz
}
_hexdump () {
	# undefined
	builtin autoload -XUz
}
_history () {
	# undefined
	builtin autoload -XUz
}
_history_complete_word () {
	# undefined
	builtin autoload -XUz
}
_history_modifiers () {
	# undefined
	builtin autoload -XUz
}
_host () {
	# undefined
	builtin autoload -XUz
}
_hostname () {
	# undefined
	builtin autoload -XUz
}
_hostnamectl () {
	# undefined
	builtin autoload -XUz
}
_hosts () {
	# undefined
	builtin autoload -XUz
}
_htop () {
	# undefined
	builtin autoload -XUz
}
_hwinfo () {
	# undefined
	builtin autoload -XUz
}
_iconv () {
	# undefined
	builtin autoload -XUz
}
_iconvconfig () {
	# undefined
	builtin autoload -XUz
}
_id () {
	# undefined
	builtin autoload -XUz
}
_ifconfig () {
	# undefined
	builtin autoload -XUz
}
_iftop () {
	# undefined
	builtin autoload -XUz
}
_ignored () {
	# undefined
	builtin autoload -XUz
}
_imagemagick () {
	# undefined
	builtin autoload -XUz
}
_in_vared () {
	# undefined
	builtin autoload -XUz
}
_inetadm () {
	# undefined
	builtin autoload -XUz
}
_init_d () {
	# undefined
	builtin autoload -XUz
}
_initctl () {
	# undefined
	builtin autoload -XUz
}
_install () {
	# undefined
	builtin autoload -XUz
}
_invoke-rc.d () {
	# undefined
	builtin autoload -XUz
}
_ionice () {
	# undefined
	builtin autoload -XUz
}
_iostat () {
	# undefined
	builtin autoload -XUz
}
_ip () {
	# undefined
	builtin autoload -XUz
}
_ipadm () {
	# undefined
	builtin autoload -XUz
}
_ipfw () {
	# undefined
	builtin autoload -XUz
}
_ipsec () {
	# undefined
	builtin autoload -XUz
}
_ipset () {
	# undefined
	builtin autoload -XUz
}
_iptables () {
	# undefined
	builtin autoload -XUz
}
_irssi () {
	# undefined
	builtin autoload -XUz
}
_ispell () {
	# undefined
	builtin autoload -XUz
}
_iwconfig () {
	# undefined
	builtin autoload -XUz
}
_jail () {
	# undefined
	builtin autoload -XUz
}
_jails () {
	# undefined
	builtin autoload -XUz
}
_java () {
	# undefined
	builtin autoload -XUz
}
_java_class () {
	# undefined
	builtin autoload -XUz
}
_jexec () {
	# undefined
	builtin autoload -XUz
}
_jls () {
	# undefined
	builtin autoload -XUz
}
_jobs () {
	# undefined
	builtin autoload -XUz
}
_jobs_bg () {
	# undefined
	builtin autoload -XUz
}
_jobs_builtin () {
	# undefined
	builtin autoload -XUz
}
_jobs_fg () {
	# undefined
	builtin autoload -XUz
}
_joe () {
	# undefined
	builtin autoload -XUz
}
_join () {
	# undefined
	builtin autoload -XUz
}
_jot () {
	# undefined
	builtin autoload -XUz
}
_journalctl () {
	# undefined
	builtin autoload -XUz
}
_jq () {
	# undefined
	builtin autoload -XUz
}
_kdeconnect () {
	# undefined
	builtin autoload -XUz
}
_kdump () {
	# undefined
	builtin autoload -XUz
}
_kernel-install () {
	# undefined
	builtin autoload -XUz
}
_kfmclient () {
	# undefined
	builtin autoload -XUz
}
_kill () {
	# undefined
	builtin autoload -XUz
}
_killall () {
	# undefined
	builtin autoload -XUz
}
_kiro () {
	# undefined
	builtin autoload -XUz
}
_kld () {
	# undefined
	builtin autoload -XUz
}
_knock () {
	# undefined
	builtin autoload -XUz
}
_kpartx () {
	# undefined
	builtin autoload -XUz
}
_ktrace () {
	# undefined
	builtin autoload -XUz
}
_ktrace_points () {
	# undefined
	builtin autoload -XUz
}
_kvno () {
	# undefined
	builtin autoload -XUz
}
_last () {
	# undefined
	builtin autoload -XUz
}
_ld_debug () {
	# undefined
	builtin autoload -XUz
}
_ldap () {
	# undefined
	builtin autoload -XUz
}
_ldconfig () {
	# undefined
	builtin autoload -XUz
}
_ldd () {
	# undefined
	builtin autoload -XUz
}
_less () {
	# undefined
	builtin autoload -XUz
}
_lha () {
	# undefined
	builtin autoload -XUz
}
_libvirt () {
	# undefined
	builtin autoload -XUz
}
_lighttpd () {
	# undefined
	builtin autoload -XUz
}
_limit () {
	# undefined
	builtin autoload -XUz
}
_limits () {
	# undefined
	builtin autoload -XUz
}
_links () {
	# undefined
	builtin autoload -XUz
}
_lintian () {
	# undefined
	builtin autoload -XUz
}
_list () {
	# undefined
	builtin autoload -XUz
}
_list_files () {
	# undefined
	builtin autoload -XUz
}
_lldb () {
	# undefined
	builtin autoload -XUz
}
_ln () {
	# undefined
	builtin autoload -XUz
}
_loadkeys () {
	# undefined
	builtin autoload -XUz
}
_locale () {
	# undefined
	builtin autoload -XUz
}
_localectl () {
	# undefined
	builtin autoload -XUz
}
_localedef () {
	# undefined
	builtin autoload -XUz
}
_locales () {
	# undefined
	builtin autoload -XUz
}
_locate () {
	# undefined
	builtin autoload -XUz
}
_logger () {
	# undefined
	builtin autoload -XUz
}
_logical_volumes () {
	# undefined
	builtin autoload -XUz
}
_login_classes () {
	# undefined
	builtin autoload -XUz
}
_loginctl () {
	# undefined
	builtin autoload -XUz
}
_look () {
	# undefined
	builtin autoload -XUz
}
_losetup () {
	# undefined
	builtin autoload -XUz
}
_lp () {
	# undefined
	builtin autoload -XUz
}
_ls () {
	# undefined
	builtin autoload -XUz
}
_lsattr () {
	# undefined
	builtin autoload -XUz
}
_lsblk () {
	# undefined
	builtin autoload -XUz
}
_lscfg () {
	# undefined
	builtin autoload -XUz
}
_lsdev () {
	# undefined
	builtin autoload -XUz
}
_lslv () {
	# undefined
	builtin autoload -XUz
}
_lsns () {
	# undefined
	builtin autoload -XUz
}
_lsof () {
	# undefined
	builtin autoload -XUz
}
_lspv () {
	# undefined
	builtin autoload -XUz
}
_lsusb () {
	# undefined
	builtin autoload -XUz
}
_lsvg () {
	# undefined
	builtin autoload -XUz
}
_ltrace () {
	# undefined
	builtin autoload -XUz
}
_lua () {
	# undefined
	builtin autoload -XUz
}
_luarocks () {
	# undefined
	builtin autoload -XUz
}
_lynx () {
	# undefined
	builtin autoload -XUz
}
_lz4 () {
	# undefined
	builtin autoload -XUz
}
_lzop () {
	# undefined
	builtin autoload -XUz
}
_mac_applications () {
	# undefined
	builtin autoload -XUz
}
_mac_files_for_application () {
	# undefined
	builtin autoload -XUz
}
_madison () {
	# undefined
	builtin autoload -XUz
}
_mail () {
	# undefined
	builtin autoload -XUz
}
_mailboxes () {
	# undefined
	builtin autoload -XUz
}
_main_complete () {
	# undefined
	builtin autoload -XUz
}
_make () {
	# undefined
	builtin autoload -XUz
}
_make-kpkg () {
	# undefined
	builtin autoload -XUz
}
_man () {
	# undefined
	builtin autoload -XUz
}
_mat () {
	# undefined
	builtin autoload -XUz
}
_mat2 () {
	# undefined
	builtin autoload -XUz
}
_match () {
	# undefined
	builtin autoload -XUz
}
_math () {
	# undefined
	builtin autoload -XUz
}
_math_params () {
	# undefined
	builtin autoload -XUz
}
_matlab () {
	# undefined
	builtin autoload -XUz
}
_md5sum () {
	# undefined
	builtin autoload -XUz
}
_mdadm () {
	# undefined
	builtin autoload -XUz
}
_mdfind () {
	# undefined
	builtin autoload -XUz
}
_mdls () {
	# undefined
	builtin autoload -XUz
}
_mdutil () {
	# undefined
	builtin autoload -XUz
}
_members () {
	# undefined
	builtin autoload -XUz
}
_mencal () {
	# undefined
	builtin autoload -XUz
}
_menu () {
	# undefined
	builtin autoload -XUz
}
_mere () {
	# undefined
	builtin autoload -XUz
}
_mergechanges () {
	# undefined
	builtin autoload -XUz
}
_meson () {
	# undefined
	builtin autoload -XUz
}
_message () {
	# undefined
	builtin autoload -XUz
}
_mh () {
	# undefined
	builtin autoload -XUz
}
_mii-tool () {
	# undefined
	builtin autoload -XUz
}
_mime_types () {
	# undefined
	builtin autoload -XUz
}
_mixerctl () {
	# undefined
	builtin autoload -XUz
}
_mkdir () {
	# undefined
	builtin autoload -XUz
}
_mkfifo () {
	# undefined
	builtin autoload -XUz
}
_mknod () {
	# undefined
	builtin autoload -XUz
}
_mkshortcut () {
	# undefined
	builtin autoload -XUz
}
_mktemp () {
	# undefined
	builtin autoload -XUz
}
_mkzsh () {
	# undefined
	builtin autoload -XUz
}
_module () {
	# undefined
	builtin autoload -XUz
}
_module-assistant () {
	# undefined
	builtin autoload -XUz
}
_module_math_func () {
	# undefined
	builtin autoload -XUz
}
_modutils () {
	# undefined
	builtin autoload -XUz
}
_mondo () {
	# undefined
	builtin autoload -XUz
}
_monotone () {
	# undefined
	builtin autoload -XUz
}
_moosic () {
	# undefined
	builtin autoload -XUz
}
_mosh () {
	# undefined
	builtin autoload -XUz
}
_most_recent_file () {
	# undefined
	builtin autoload -XUz
}
_mount () {
	# undefined
	builtin autoload -XUz
}
_mozilla () {
	# undefined
	builtin autoload -XUz
}
_mpc () {
	# undefined
	builtin autoload -XUz
}
_mplayer () {
	# undefined
	builtin autoload -XUz
}
_mt () {
	# undefined
	builtin autoload -XUz
}
_mtools () {
	# undefined
	builtin autoload -XUz
}
_mtr () {
	# undefined
	builtin autoload -XUz
}
_multi_parts () {
	# undefined
	builtin autoload -XUz
}
_mupdf () {
	# undefined
	builtin autoload -XUz
}
_mutt () {
	# undefined
	builtin autoload -XUz
}
_mv () {
	# undefined
	builtin autoload -XUz
}
_my_accounts () {
	# undefined
	builtin autoload -XUz
}
_myrepos () {
	# undefined
	builtin autoload -XUz
}
_mysql_utils () {
	# undefined
	builtin autoload -XUz
}
_mysqldiff () {
	# undefined
	builtin autoload -XUz
}
_nautilus () {
	# undefined
	builtin autoload -XUz
}
_nbsd_architectures () {
	# undefined
	builtin autoload -XUz
}
_ncftp () {
	# undefined
	builtin autoload -XUz
}
_nedit () {
	# undefined
	builtin autoload -XUz
}
_net_interfaces () {
	# undefined
	builtin autoload -XUz
}
_netcat () {
	# undefined
	builtin autoload -XUz
}
_netscape () {
	# undefined
	builtin autoload -XUz
}
_netstat () {
	# undefined
	builtin autoload -XUz
}
_networkctl () {
	# undefined
	builtin autoload -XUz
}
_networkmanager () {
	# undefined
	builtin autoload -XUz
}
_networksetup () {
	# undefined
	builtin autoload -XUz
}
_newsgroups () {
	# undefined
	builtin autoload -XUz
}
_next_label () {
	# undefined
	builtin autoload -XUz
}
_next_tags () {
	# undefined
	builtin autoload -XUz
}
_nginx () {
	# undefined
	builtin autoload -XUz
}
_ngrep () {
	# undefined
	builtin autoload -XUz
}
_nice () {
	# undefined
	builtin autoload -XUz
}
_ninja () {
	# undefined
	builtin autoload -XUz
}
_nkf () {
	# undefined
	builtin autoload -XUz
}
_nl () {
	# undefined
	builtin autoload -XUz
}
_nm () {
	# undefined
	builtin autoload -XUz
}
_nmap () {
	# undefined
	builtin autoload -XUz
}
_normal () {
	# undefined
	builtin autoload -XUz
}
_nothing () {
	# undefined
	builtin autoload -XUz
}
_npm () {
	# undefined
	builtin autoload -XUz
}
_nsenter () {
	# undefined
	builtin autoload -XUz
}
_nslookup () {
	# undefined
	builtin autoload -XUz
}
_numbers () {
	# undefined
	builtin autoload -XUz
}
_numfmt () {
	# undefined
	builtin autoload -XUz
}
_nvram () {
	# undefined
	builtin autoload -XUz
}
_objdump () {
	# undefined
	builtin autoload -XUz
}
_object_classes () {
	# undefined
	builtin autoload -XUz
}
_object_files () {
	# undefined
	builtin autoload -XUz
}
_obsd_architectures () {
	# undefined
	builtin autoload -XUz
}
_od () {
	# undefined
	builtin autoload -XUz
}
_okular () {
	# undefined
	builtin autoload -XUz
}
_oldlist () {
	# undefined
	builtin autoload -XUz
}
_omz () {
	local -a cmds subcmds
	cmds=('changelog:Print the changelog' 'help:Usage information' 'plugin:Manage plugins' 'pr:Manage Oh My Zsh Pull Requests' 'reload:Reload the current zsh session' 'shop:Open the Oh My Zsh shop' 'theme:Manage themes' 'update:Update Oh My Zsh' 'version:Show the version') 
	if (( CURRENT == 2 ))
	then
		_describe 'command' cmds
	elif (( CURRENT == 3 ))
	then
		case "$words[2]" in
			(changelog) local -a refs
				refs=("${(@f)$(builtin cd -q "$ZSH"; command git for-each-ref --format="%(refname:short):%(subject)" refs/heads refs/tags)}") 
				_describe 'command' refs ;;
			(plugin) subcmds=('disable:Disable plugin(s)' 'enable:Enable plugin(s)' 'info:Get plugin information' 'list:List plugins' 'load:Load plugin(s)') 
				_describe 'command' subcmds ;;
			(pr) subcmds=('clean:Delete all Pull Request branches' 'test:Test a Pull Request') 
				_describe 'command' subcmds ;;
			(theme) subcmds=('list:List themes' 'set:Set a theme in your .zshrc file' 'use:Load a theme') 
				_describe 'command' subcmds ;;
		esac
	elif (( CURRENT == 4 ))
	then
		case "${words[2]}::${words[3]}" in
			(plugin::(disable|enable|load)) local -aU valid_plugins
				if [[ "${words[3]}" = disable ]]
				then
					valid_plugins=($plugins) 
				else
					valid_plugins=("$ZSH"/plugins/*/{_*,*.plugin.zsh}(-.N:h:t) "$ZSH_CUSTOM"/plugins/*/{_*,*.plugin.zsh}(-.N:h:t)) 
					[[ "${words[3]}" = enable ]] && valid_plugins=(${valid_plugins:|plugins}) 
				fi
				_describe 'plugin' valid_plugins ;;
			(plugin::info) local -aU plugins
				plugins=("$ZSH"/plugins/*/{_*,*.plugin.zsh}(-.N:h:t) "$ZSH_CUSTOM"/plugins/*/{_*,*.plugin.zsh}(-.N:h:t)) 
				_describe 'plugin' plugins ;;
			(plugin::list) local -a opts
				opts=('--enabled:List enabled plugins only') 
				_describe -o 'options' opts ;;
			(theme::(set|use)) local -aU themes
				themes=("$ZSH"/themes/*.zsh-theme(-.N:t:r) "$ZSH_CUSTOM"/**/*.zsh-theme(-.N:r:gs:"$ZSH_CUSTOM"/themes/:::gs:"$ZSH_CUSTOM"/:::)) 
				_describe 'theme' themes ;;
		esac
	elif (( CURRENT > 4 ))
	then
		case "${words[2]}::${words[3]}" in
			(plugin::(enable|disable|load)) local -aU valid_plugins
				if [[ "${words[3]}" = disable ]]
				then
					valid_plugins=($plugins) 
				else
					valid_plugins=("$ZSH"/plugins/*/{_*,*.plugin.zsh}(-.N:h:t) "$ZSH_CUSTOM"/plugins/*/{_*,*.plugin.zsh}(-.N:h:t)) 
					[[ "${words[3]}" = enable ]] && valid_plugins=(${valid_plugins:|plugins}) 
				fi
				local -a args
				args=(${words[4,$(( CURRENT - 1))]}) 
				valid_plugins=(${valid_plugins:|args}) 
				_describe 'plugin' valid_plugins ;;
		esac
	fi
	return 0
}
_omz::changelog () {
	local version=${1:-HEAD} format=${3:-"--text"} 
	if (
			builtin cd -q "$ZSH"
			! command git show-ref --verify refs/heads/$version && ! command git show-ref --verify refs/tags/$version && ! command git rev-parse --verify "${version}^{commit}"
		) &> /dev/null
	then
		cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}} [version]

NOTE: <version> must be a valid branch, tag or commit.
EOF
		return 1
	fi
	ZSH="$ZSH" command zsh -f "$ZSH/tools/changelog.sh" "$version" "${2:-}" "$format"
}
_omz::confirm () {
	if [[ -n "$1" ]]
	then
		_omz::log prompt "$1" "${${functrace[1]#_}%:*}"
	fi
	read -r -k 1
	if [[ "$REPLY" != $'\n' ]]
	then
		echo
	fi
}
_omz::help () {
	cat >&2 <<EOF
Usage: omz <command> [options]

Available commands:

  help                Print this help message
  changelog           Print the changelog
  plugin <command>    Manage plugins
  pr     <command>    Manage Oh My Zsh Pull Requests
  reload              Reload the current zsh session
  shop                Open the Oh My Zsh shop
  theme  <command>    Manage themes
  update              Update Oh My Zsh
  version             Show the version

EOF
}
_omz::log () {
	setopt localoptions nopromptsubst
	local logtype=$1 
	local logname=${3:-${${functrace[1]#_}%:*}} 
	if [[ $logtype = debug && -z $_OMZ_DEBUG ]]
	then
		return
	fi
	case "$logtype" in
		(prompt) print -Pn "%S%F{blue}$logname%f%s: $2" ;;
		(debug) print -P "%F{white}$logname%f: $2" ;;
		(info) print -P "%F{green}$logname%f: $2" ;;
		(warn) print -P "%S%F{yellow}$logname%f%s: $2" ;;
		(error) print -P "%S%F{red}$logname%f%s: $2" ;;
	esac >&2
}
_omz::plugin () {
	(( $# > 0 && $+functions[$0::$1] )) || {
		cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}} <command> [options]

Available commands:

  disable <plugin> Disable plugin(s)
  enable <plugin>  Enable plugin(s)
  info <plugin>    Get information of a plugin
  list [--enabled] List Oh My Zsh plugins
  load <plugin>    Load plugin(s)

EOF
		return 1
	}
	local command="$1" 
	shift
	$0::$command "$@"
}
_omz::plugin::disable () {
	if [[ -z "$1" ]]
	then
		echo "Usage: ${(j: :)${(s.::.)0#_}} <plugin> [...]" >&2
		return 1
	fi
	local -a dis_plugins
	for plugin in "$@"
	do
		if [[ ${plugins[(Ie)$plugin]} -eq 0 ]]
		then
			_omz::log warn "plugin '$plugin' is not enabled."
			continue
		fi
		dis_plugins+=("$plugin") 
	done
	if [[ ${#dis_plugins} -eq 0 ]]
	then
		return 1
	fi
	local awk_subst_plugins="  gsub(/[ \t]+(${(j:|:)dis_plugins})[ \t]+/, \" \") # with spaces before or after
  gsub(/[ \t]+(${(j:|:)dis_plugins})$/, \"\")       # with spaces before and EOL
  gsub(/^(${(j:|:)dis_plugins})[ \t]+/, \"\")       # with BOL and spaces after

  gsub(/\((${(j:|:)dis_plugins})[ \t]+/, \"(\")     # with parenthesis before and spaces after
  gsub(/[ \t]+(${(j:|:)dis_plugins})\)/, \")\")     # with spaces before or parenthesis after
  gsub(/\((${(j:|:)dis_plugins})\)/, \"()\")        # with only parentheses

  gsub(/^(${(j:|:)dis_plugins})\)/, \")\")          # with BOL and closing parenthesis
  gsub(/\((${(j:|:)dis_plugins})$/, \"(\")          # with opening parenthesis and EOL
" 
	local awk_script="
# if plugins=() is in oneline form, substitute disabled plugins and go to next line
/^[ \t]*plugins=\([^#]+\).*\$/ {
  $awk_subst_plugins
  print \$0
  next
}

# if plugins=() is in multiline form, enable multi flag and disable plugins if they're there
/^[ \t]*plugins=\(/ {
  multi=1
  $awk_subst_plugins
  print \$0
  next
}

# if multi flag is enabled and we find a valid closing parenthesis, remove plugins and disable multi flag
multi == 1 && /^[^#]*\)/ {
  multi=0
  $awk_subst_plugins
  print \$0
  next
}

multi == 1 && length(\$0) > 0 {
  $awk_subst_plugins
  if (length(\$0) > 0) print \$0
  next
}

{ print \$0 }
" 
	local zdot="${ZDOTDIR:-$HOME}" 
	local zshrc="${${:-"${zdot}/.zshrc"}:A}" 
	awk "$awk_script" "$zshrc" > "$zdot/.zshrc.new" && command cp -f "$zshrc" "$zdot/.zshrc.bck" && command mv -f "$zdot/.zshrc.new" "$zshrc"
	[[ $? -eq 0 ]] || {
		local ret=$? 
		_omz::log error "error disabling plugins."
		return $ret
	}
	if ! command zsh -n "$zdot/.zshrc"
	then
		_omz::log error "broken syntax in '"${zdot/#$HOME/\~}/.zshrc"'. Rolling back changes..."
		command mv -f "$zdot/.zshrc.bck" "$zshrc"
		return 1
	fi
	_omz::log info "plugins disabled: ${(j:, :)dis_plugins}."
	[[ ! -o interactive ]] || _omz::reload
}
_omz::plugin::enable () {
	if [[ -z "$1" ]]
	then
		echo "Usage: ${(j: :)${(s.::.)0#_}} <plugin> [...]" >&2
		return 1
	fi
	local -a add_plugins
	for plugin in "$@"
	do
		if [[ ${plugins[(Ie)$plugin]} -ne 0 ]]
		then
			_omz::log warn "plugin '$plugin' is already enabled."
			continue
		fi
		add_plugins+=("$plugin") 
	done
	if [[ ${#add_plugins} -eq 0 ]]
	then
		return 1
	fi
	local awk_script="
# if plugins=() is in oneline form, substitute ) with new plugins and go to the next line
/^[ \t]*plugins=\([^#]+\).*\$/ {
  sub(/\)/, \" $add_plugins&\")
  print \$0
  next
}

# if plugins=() is in multiline form, enable multi flag and indent by default with 2 spaces
/^[ \t]*plugins=\(/ {
  multi=1
  indent=\"  \"
  print \$0
  next
}

# if multi flag is enabled and we find a valid closing parenthesis,
# add new plugins with proper indent and disable multi flag
multi == 1 && /^[^#]*\)/ {
  multi=0
  split(\"$add_plugins\",p,\" \")
  for (i in p) {
    print indent p[i]
  }
  print \$0
  next
}

# if multi flag is enabled and we didnt find a closing parenthesis,
# get the indentation level to match when adding plugins
multi == 1 && /^[^#]*/ {
  indent=\"\"
  for (i = 1; i <= length(\$0); i++) {
    char=substr(\$0, i, 1)
    if (char == \" \" || char == \"\t\") {
      indent = indent char
    } else {
      break
    }
  }
}

{ print \$0 }
" 
	local zdot="${ZDOTDIR:-$HOME}" 
	local zshrc="${${:-"${zdot}/.zshrc"}:A}" 
	awk "$awk_script" "$zshrc" > "$zdot/.zshrc.new" && command cp -f "$zshrc" "$zdot/.zshrc.bck" && command mv -f "$zdot/.zshrc.new" "$zshrc"
	[[ $? -eq 0 ]] || {
		local ret=$? 
		_omz::log error "error enabling plugins."
		return $ret
	}
	if ! command zsh -n "$zdot/.zshrc"
	then
		_omz::log error "broken syntax in '"${zdot/#$HOME/\~}/.zshrc"'. Rolling back changes..."
		command mv -f "$zdot/.zshrc.bck" "$zshrc"
		return 1
	fi
	_omz::log info "plugins enabled: ${(j:, :)add_plugins}."
	[[ ! -o interactive ]] || _omz::reload
}
_omz::plugin::info () {
	if [[ -z "$1" ]]
	then
		echo "Usage: ${(j: :)${(s.::.)0#_}} <plugin>" >&2
		return 1
	fi
	local readme
	for readme in "$ZSH_CUSTOM/plugins/$1/README.md" "$ZSH/plugins/$1/README.md"
	do
		if [[ -f "$readme" ]]
		then
			if [[ ! -t 1 ]]
			then
				cat "$readme"
				return $?
			fi
			case 1 in
				(${+commands[glow]}) glow -p "$readme" ;;
				(${+commands[bat]}) bat -l md --style plain "$readme" ;;
				(${+commands[less]}) less "$readme" ;;
				(*) cat "$readme" ;;
			esac
			return $?
		fi
	done
	if [[ -d "$ZSH_CUSTOM/plugins/$1" || -d "$ZSH/plugins/$1" ]]
	then
		_omz::log error "the '$1' plugin doesn't have a README file"
	else
		_omz::log error "'$1' plugin not found"
	fi
	return 1
}
_omz::plugin::list () {
	local -a custom_plugins builtin_plugins
	if [[ "$1" == "--enabled" ]]
	then
		local plugin
		for plugin in "${plugins[@]}"
		do
			if [[ -d "${ZSH_CUSTOM}/plugins/${plugin}" ]]
			then
				custom_plugins+=("${plugin}") 
			elif [[ -d "${ZSH}/plugins/${plugin}" ]]
			then
				builtin_plugins+=("${plugin}") 
			fi
		done
	else
		custom_plugins=("$ZSH_CUSTOM"/plugins/*(-/N:t)) 
		builtin_plugins=("$ZSH"/plugins/*(-/N:t)) 
	fi
	if [[ ! -t 1 ]]
	then
		print -l ${(q-)custom_plugins} ${(q-)builtin_plugins}
		return
	fi
	if (( ${#custom_plugins} ))
	then
		print -P "%U%BCustom plugins%b%u:"
		print -lac ${(q-)custom_plugins}
	fi
	if (( ${#builtin_plugins} ))
	then
		(( ${#custom_plugins} )) && echo
		print -P "%U%BBuilt-in plugins%b%u:"
		print -lac ${(q-)builtin_plugins}
	fi
}
_omz::plugin::load () {
	if [[ -z "$1" ]]
	then
		echo "Usage: ${(j: :)${(s.::.)0#_}} <plugin> [...]" >&2
		return 1
	fi
	local plugin base has_completion=0 
	for plugin in "$@"
	do
		if [[ -d "$ZSH_CUSTOM/plugins/$plugin" ]]
		then
			base="$ZSH_CUSTOM/plugins/$plugin" 
		elif [[ -d "$ZSH/plugins/$plugin" ]]
		then
			base="$ZSH/plugins/$plugin" 
		else
			_omz::log warn "plugin '$plugin' not found"
			continue
		fi
		if [[ ! -f "$base/_$plugin" && ! -f "$base/$plugin.plugin.zsh" ]]
		then
			_omz::log warn "'$plugin' is not a valid plugin"
			continue
		elif (( ! ${fpath[(Ie)$base]} ))
		then
			fpath=("$base" $fpath) 
		fi
		local -a comp_files
		comp_files=($base/_*(N)) 
		has_completion=$(( $#comp_files > 0 )) 
		if [[ -f "$base/$plugin.plugin.zsh" ]]
		then
			source "$base/$plugin.plugin.zsh"
		fi
	done
	if (( has_completion ))
	then
		compinit -D -d "$_comp_dumpfile"
	fi
}
_omz::pr () {
	(( $# > 0 && $+functions[$0::$1] )) || {
		cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}} <command> [options]

Available commands:

  clean                       Delete all PR branches (ohmyzsh/pull-*)
  test <PR_number_or_URL>     Fetch PR #NUMBER and rebase against master

EOF
		return 1
	}
	local command="$1" 
	shift
	$0::$command "$@"
}
_omz::pr::clean () {
	(
		set -e
		builtin cd -q "$ZSH"
		local fmt branches
		fmt="%(color:bold blue)%(align:18,right)%(refname:short)%(end)%(color:reset) %(color:dim bold red)%(objectname:short)%(color:reset) %(color:yellow)%(contents:subject)" 
		branches="$(command git for-each-ref --sort=-committerdate --color --format="$fmt" "refs/heads/ohmyzsh/pull-*")" 
		if [[ -z "$branches" ]]
		then
			_omz::log info "there are no Pull Request branches to remove."
			return
		fi
		echo "$branches\n"
		_omz::confirm "do you want remove these Pull Request branches? [Y/n] "
		[[ "$REPLY" != [yY$'\n'] ]] && return
		_omz::log info "removing all Oh My Zsh Pull Request branches..."
		command git branch --list 'ohmyzsh/pull-*' | while read branch
		do
			command git branch -D "$branch"
		done
	)
}
_omz::pr::test () {
	if [[ "$1" = https://* ]]
	then
		1="${1:t}" 
	fi
	if ! [[ -n "$1" && "$1" =~ ^[[:digit:]]+$ ]]
	then
		echo "Usage: ${(j: :)${(s.::.)0#_}} <PR_NUMBER_or_URL>" >&2
		return 1
	fi
	local branch
	branch=$(builtin cd -q "$ZSH"; git symbolic-ref --short HEAD)  || {
		_omz::log error "error when getting the current git branch. Aborting..."
		return 1
	}
	(
		set -e
		builtin cd -q "$ZSH"
		command git remote -v | while read remote url _
		do
			case "$url" in
				(https://github.com/ohmyzsh/ohmyzsh(|.git)) found=1 
					break ;;
				(git@github.com:ohmyzsh/ohmyzsh(|.git)) found=1 
					break ;;
			esac
		done
		(( $found )) || {
			_omz::log error "could not find the ohmyzsh git remote. Aborting..."
			return 1
		}
		_omz::log info "checking if PR #$1 has the 'testers needed' label..."
		local pr_json label label_id="MDU6TGFiZWw4NzY1NTkwNA==" 
		pr_json=$(
      curl -fsSL \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "https://api.github.com/repos/ohmyzsh/ohmyzsh/pulls/$1"
    ) 
		if [[ $? -gt 0 || -z "$pr_json" ]]
		then
			_omz::log error "error when trying to fetch PR #$1 from GitHub."
			return 1
		fi
		if (( $+commands[jq] ))
		then
			label="$(command jq ".labels.[] | select(.node_id == \"$label_id\")" <<< "$pr_json")" 
		else
			label="$(command grep "\"$label_id\"" <<< "$pr_json" 2>/dev/null)" 
		fi
		if [[ -z "$label" ]]
		then
			_omz::log warn "PR #$1 does not have the 'testers needed' label. This means that the PR"
			_omz::log warn "has not been reviewed by a maintainer and may contain malicious code."
			_omz::log prompt "Do you want to continue testing it? [yes/N] "
			builtin read -r
			if [[ "${REPLY:l}" != yes ]]
			then
				_omz::log error "PR test canceled. Please ask a maintainer to review and label the PR."
				return 1
			else
				_omz::log warn "Continuing to check out and test PR #$1. Be careful!"
			fi
		fi
		_omz::log info "fetching PR #$1 to ohmyzsh/pull-$1..."
		command git fetch -f "$remote" refs/pull/$1/head:ohmyzsh/pull-$1 || {
			_omz::log error "error when trying to fetch PR #$1."
			return 1
		}
		_omz::log info "rebasing PR #$1..."
		local ret gpgsign
		{
			gpgsign=$(command git config --local commit.gpgsign 2>/dev/null)  || ret=$? 
			[[ $ret -ne 129 ]] || gpgsign=$(command git config commit.gpgsign 2>/dev/null) 
			command git config commit.gpgsign false
			command git rebase master ohmyzsh/pull-$1 || {
				command git rebase --abort &> /dev/null
				_omz::log warn "could not rebase PR #$1 on top of master."
				_omz::log warn "you might not see the latest stable changes."
				_omz::log info "run \`zsh\` to test the changes."
				return 1
			}
		} always {
			case "$gpgsign" in
				("") command git config --unset commit.gpgsign ;;
				(*) command git config commit.gpgsign "$gpgsign" ;;
			esac
		}
		_omz::log info "fetch of PR #${1} successful."
	)
	[[ $? -eq 0 ]] || return 1
	_omz::log info "running \`zsh\` to test the changes. Run \`exit\` to go back."
	command zsh -l
	_omz::confirm "do you want to go back to the previous branch? [Y/n] "
	[[ "$REPLY" != [yY$'\n'] ]] && return
	(
		set -e
		builtin cd -q "$ZSH"
		command git checkout "$branch" -- || {
			_omz::log error "could not go back to the previous branch ('$branch')."
			return 1
		}
	)
}
_omz::reload () {
	command rm -f $_comp_dumpfile $ZSH_COMPDUMP
	local zsh="${ZSH_ARGZERO:-${functrace[-1]%:*}}" 
	[[ "$zsh" = -* || -o login ]] && exec -l "${zsh#-}" || exec "$zsh"
}
_omz::shop () {
	local shop_url="https://commitgoods.com/collections/oh-my-zsh" 
	_omz::log info "Opening Oh My Zsh shop in your browser..."
	_omz::log info "$shop_url"
	open_command "$shop_url"
}
_omz::theme () {
	(( $# > 0 && $+functions[$0::$1] )) || {
		cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}} <command> [options]

Available commands:

  list            List all available Oh My Zsh themes
  set <theme>     Set a theme in your .zshrc file
  use <theme>     Load a theme

EOF
		return 1
	}
	local command="$1" 
	shift
	$0::$command "$@"
}
_omz::theme::list () {
	local -a custom_themes builtin_themes
	custom_themes=("$ZSH_CUSTOM"/**/*.zsh-theme(-.N:r:gs:"$ZSH_CUSTOM"/themes/:::gs:"$ZSH_CUSTOM"/:::)) 
	builtin_themes=("$ZSH"/themes/*.zsh-theme(-.N:t:r)) 
	if [[ ! -t 1 ]]
	then
		print -l ${(q-)custom_themes} ${(q-)builtin_themes}
		return
	fi
	if [[ -n "$ZSH_THEME" ]]
	then
		print -Pn "%U%BCurrent theme%b%u: "
		[[ $ZSH_THEME = random ]] && echo "$RANDOM_THEME (via random)" || echo "$ZSH_THEME"
		echo
	fi
	if (( ${#custom_themes} ))
	then
		print -P "%U%BCustom themes%b%u:"
		print -lac ${(q-)custom_themes}
		echo
	fi
	print -P "%U%BBuilt-in themes%b%u:"
	print -lac ${(q-)builtin_themes}
}
_omz::theme::set () {
	if [[ -z "$1" ]]
	then
		echo "Usage: ${(j: :)${(s.::.)0#_}} <theme>" >&2
		return 1
	fi
	if [[ ! -f "$ZSH_CUSTOM/$1.zsh-theme" ]] && [[ ! -f "$ZSH_CUSTOM/themes/$1.zsh-theme" ]] && [[ ! -f "$ZSH/themes/$1.zsh-theme" ]]
	then
		_omz::log error "%B$1%b theme not found"
		return 1
	fi
	local awk_script='
!set && /^[ \t]*ZSH_THEME=[^#]+.*$/ {
  set=1
  sub(/^[ \t]*ZSH_THEME=[^#]+.*$/, "ZSH_THEME=\"'$1'\" # set by `omz`")
  print $0
  next
}

{ print $0 }

END {
  # If no ZSH_THEME= line was found, return an error
  if (!set) exit 1
}
' 
	local zdot="${ZDOTDIR:-$HOME}" 
	local zshrc="${${:-"${zdot}/.zshrc"}:A}" 
	awk "$awk_script" "$zshrc" > "$zdot/.zshrc.new" || {
		cat <<EOF
ZSH_THEME="$1" # set by \`omz\`

EOF
		cat "$zdot/.zshrc"
	} > "$zdot/.zshrc.new" && command cp -f "$zshrc" "$zdot/.zshrc.bck" && command mv -f "$zdot/.zshrc.new" "$zshrc"
	[[ $? -eq 0 ]] || {
		local ret=$? 
		_omz::log error "error setting theme."
		return $ret
	}
	if ! command zsh -n "$zdot/.zshrc"
	then
		_omz::log error "broken syntax in '"${zdot/#$HOME/\~}/.zshrc"'. Rolling back changes..."
		command mv -f "$zdot/.zshrc.bck" "$zshrc"
		return 1
	fi
	_omz::log info "'$1' theme set correctly."
	[[ ! -o interactive ]] || _omz::reload
}
_omz::theme::use () {
	if [[ -z "$1" ]]
	then
		echo "Usage: ${(j: :)${(s.::.)0#_}} <theme>" >&2
		return 1
	fi
	if [[ -f "$ZSH_CUSTOM/$1.zsh-theme" ]]
	then
		source "$ZSH_CUSTOM/$1.zsh-theme"
	elif [[ -f "$ZSH_CUSTOM/themes/$1.zsh-theme" ]]
	then
		source "$ZSH_CUSTOM/themes/$1.zsh-theme"
	elif [[ -f "$ZSH/themes/$1.zsh-theme" ]]
	then
		source "$ZSH/themes/$1.zsh-theme"
	else
		_omz::log error "%B$1%b theme not found"
		return 1
	fi
	ZSH_THEME="$1" 
	[[ $1 = random ]] || unset RANDOM_THEME
}
_omz::update () {
	(( $+commands[git] )) || {
		_omz::log error "git is not installed. Aborting..."
		return 1
	}
	[[ "$1" != --unattended ]] || {
		_omz::log error "the \`\e[2m--unattended\e[0m\` flag is no longer supported, use the \`\e[2mupgrade.sh\e[0m\` script instead."
		_omz::log error "for more information see https://github.com/ohmyzsh/ohmyzsh/wiki/FAQ#how-do-i-update-oh-my-zsh"
		return 1
	}
	local last_commit=$(builtin cd -q "$ZSH"; git rev-parse HEAD 2>/dev/null) 
	[[ $? -eq 0 ]] || {
		_omz::log error "\`$ZSH\` is not a git directory. Aborting..."
		return 1
	}
	zstyle -s ':omz:update' verbose verbose_mode || verbose_mode=default 
	ZSH="$ZSH" command zsh -f "$ZSH/tools/upgrade.sh" -i -v $verbose_mode || return $?
	zmodload zsh/datetime
	echo "LAST_EPOCH=$(( EPOCHSECONDS / 60 / 60 / 24 ))" >| "${ZSH_CACHE_DIR}/.zsh-update"
	command rm -rf "$ZSH/log/update.lock"
	if [[ "$(builtin cd -q "$ZSH"; git rev-parse HEAD)" != "$last_commit" ]]
	then
		local zsh="${ZSH_ARGZERO:-${functrace[-1]%:*}}" 
		[[ "$zsh" = -* || -o login ]] && exec -l "${zsh#-}" || exec "$zsh"
	fi
}
_omz::version () {
	(
		builtin cd -q "$ZSH"
		local version
		version=$(command git describe --tags HEAD 2>/dev/null)  || version=$(command git symbolic-ref --quiet --short HEAD 2>/dev/null)  || version=$(command git name-rev --no-undefined --name-only --exclude="remotes/*" HEAD 2>/dev/null)  || version="<detached>" 
		local commit=$(command git rev-parse --short HEAD 2>/dev/null) 
		printf "%s (%s)\n" "$version" "$commit"
	)
}
_omz_async_callback () {
	emulate -L zsh
	local fd=$1 
	local err=$2 
	if [[ -z "$err" || "$err" == "hup" ]]
	then
		local handler="${(k)_OMZ_ASYNC_FDS[(r)$fd]}" 
		local old_output="${_OMZ_ASYNC_OUTPUT[$handler]}" 
		IFS= read -r -u $fd -d '' "_OMZ_ASYNC_OUTPUT[$handler]"
		if [[ "$old_output" != "${_OMZ_ASYNC_OUTPUT[$handler]}" ]]
		then
			zle .reset-prompt
			zle -R
		fi
		exec {fd}<&-
	fi
	zle -F "$fd"
	_OMZ_ASYNC_FDS[$handler]=-1 
	_OMZ_ASYNC_PIDS[$handler]=-1 
}
_omz_async_request () {
	setopt localoptions noksharrays unset
	local -i ret=$? 
	typeset -gA _OMZ_ASYNC_FDS _OMZ_ASYNC_PIDS _OMZ_ASYNC_OUTPUT
	local handler
	for handler in ${_omz_async_functions}
	do
		(( ${+functions[$handler]} )) || continue
		local fd=${_OMZ_ASYNC_FDS[$handler]:--1} 
		local pid=${_OMZ_ASYNC_PIDS[$handler]:--1} 
		if (( fd != -1 && pid != -1 )) && {
				true <&$fd
			} 2> /dev/null
		then
			exec {fd}<&-
			zle -F $fd
			if [[ -o MONITOR ]]
			then
				kill -TERM -$pid 2> /dev/null
			else
				kill -TERM $pid 2> /dev/null
			fi
		fi
		_OMZ_ASYNC_FDS[$handler]=-1 
		_OMZ_ASYNC_PIDS[$handler]=-1 
		exec {fd}< <(
      # Tell parent process our PID
      builtin echo ${sysparams[pid]}
      # Set exit code for the handler if used
      () { return $ret }
      # Run the async function handler
      $handler
    )
		_OMZ_ASYNC_FDS[$handler]=$fd 
		is-at-least 5.8 || command true
		read -u $fd "_OMZ_ASYNC_PIDS[$handler]"
		zle -F "$fd" _omz_async_callback
	done
}
_omz_diag_dump_check_core_commands () {
	builtin echo "Core command check:"
	local redefined name builtins externals reserved_words
	redefined=() 
	reserved_words=(do done esac then elif else fi for case if while function repeat time until select coproc nocorrect foreach end '!' '[[' '{' '}') 
	builtins=(alias autoload bg bindkey break builtin bye cd chdir command comparguments compcall compctl compdescribe compfiles compgroups compquote comptags comptry compvalues continue dirs disable disown echo echotc echoti emulate enable eval exec exit false fc fg functions getln getopts hash jobs kill let limit log logout noglob popd print printf pushd pushln pwd r read rehash return sched set setopt shift source suspend test times trap true ttyctl type ulimit umask unalias unfunction unhash unlimit unset unsetopt vared wait whence where which zcompile zle zmodload zparseopts zregexparse zstyle) 
	if is-at-least 5.1
	then
		reserved_word+=(declare export integer float local readonly typeset) 
	else
		builtins+=(declare export integer float local readonly typeset) 
	fi
	builtins_fatal=(builtin command local) 
	externals=(zsh) 
	for name in $reserved_words
	do
		if [[ $(builtin whence -w $name) != "$name: reserved" ]]
		then
			builtin echo "reserved word '$name' has been redefined"
			builtin which $name
			redefined+=$name 
		fi
	done
	for name in $builtins
	do
		if [[ $(builtin whence -w $name) != "$name: builtin" ]]
		then
			builtin echo "builtin '$name' has been redefined"
			builtin which $name
			redefined+=$name 
		fi
	done
	for name in $externals
	do
		if [[ $(builtin whence -w $name) != "$name: command" ]]
		then
			builtin echo "command '$name' has been redefined"
			builtin which $name
			redefined+=$name 
		fi
	done
	if [[ -n "$redefined" ]]
	then
		builtin echo "SOME CORE COMMANDS HAVE BEEN REDEFINED: $redefined"
	else
		builtin echo "All core commands are defined normally"
	fi
}
_omz_diag_dump_echo_file_w_header () {
	local file=$1 
	if [[ -f $file || -h $file ]]
	then
		builtin echo "========== $file =========="
		if [[ -h $file ]]
		then
			builtin echo "==========    ( => ${file:A} )   =========="
		fi
		command cat $file
		builtin echo "========== end $file =========="
		builtin echo
	elif [[ -d $file ]]
	then
		builtin echo "File '$file' is a directory"
	elif [[ ! -e $file ]]
	then
		builtin echo "File '$file' does not exist"
	else
		command ls -lad "$file"
	fi
}
_omz_diag_dump_one_big_text () {
	local program programs progfile md5
	builtin echo oh-my-zsh diagnostic dump
	builtin echo
	builtin echo $outfile
	builtin echo
	command date
	command uname -a
	builtin echo OSTYPE=$OSTYPE
	builtin echo ZSH_VERSION=$ZSH_VERSION
	builtin echo User: $USERNAME
	builtin echo umask: $(umask)
	builtin echo
	_omz_diag_dump_os_specific_version
	builtin echo
	programs=(sh zsh ksh bash sed cat grep ls find git posh) 
	local progfile="" extra_str="" sha_str="" 
	for program in $programs
	do
		extra_str="" sha_str="" 
		progfile=$(builtin which $program) 
		if [[ $? == 0 ]]
		then
			if [[ -e $progfile ]]
			then
				if builtin whence shasum &> /dev/null
				then
					sha_str=($(command shasum $progfile)) 
					sha_str=$sha_str[1] 
					extra_str+=" SHA $sha_str" 
				fi
				if [[ -h "$progfile" ]]
				then
					extra_str+=" ( -> ${progfile:A} )" 
				fi
			fi
			builtin printf '%-9s %-20s %s\n' "$program is" "$progfile" "$extra_str"
		else
			builtin echo "$program: not found"
		fi
	done
	builtin echo
	builtin echo Command Versions:
	builtin echo "zsh: $(zsh --version)"
	builtin echo "this zsh session: $ZSH_VERSION"
	builtin echo "bash: $(bash --version | command grep bash)"
	builtin echo "git: $(git --version)"
	builtin echo "grep: $(grep --version)"
	builtin echo
	_omz_diag_dump_check_core_commands || return 1
	builtin echo
	builtin echo Process state:
	builtin echo pwd: $PWD
	if builtin whence pstree &> /dev/null
	then
		builtin echo Process tree for this shell:
		pstree -p $$
	else
		ps -fT
	fi
	builtin set | command grep -a '^\(ZSH\|plugins\|TERM\|LC_\|LANG\|precmd\|chpwd\|preexec\|FPATH\|TTY\|DISPLAY\|PATH\)\|OMZ'
	builtin echo
	builtin echo Exported:
	builtin echo $(builtin export | command sed 's/=.*//')
	builtin echo
	builtin echo Locale:
	command locale
	builtin echo
	builtin echo Zsh configuration:
	builtin echo setopt: $(builtin setopt)
	builtin echo
	builtin echo zstyle:
	builtin zstyle
	builtin echo
	builtin echo 'compaudit output:'
	compaudit
	builtin echo
	builtin echo '$fpath directories:'
	command ls -lad $fpath
	builtin echo
	builtin echo oh-my-zsh installation:
	command ls -ld ~/.z*
	command ls -ld ~/.oh*
	builtin echo
	builtin echo oh-my-zsh git state:
	(
		builtin cd $ZSH && builtin echo "HEAD: $(git rev-parse HEAD)" && git remote -v && git status | command grep "[^[:space:]]"
	)
	if [[ $verbose -ge 1 ]]
	then
		(
			builtin cd $ZSH && git reflog --date=default | command grep pull
		)
	fi
	builtin echo
	if [[ -e $ZSH_CUSTOM ]]
	then
		local custom_dir=$ZSH_CUSTOM 
		if [[ -h $custom_dir ]]
		then
			custom_dir=$(builtin cd $custom_dir && pwd -P) 
		fi
		builtin echo "oh-my-zsh custom dir:"
		builtin echo "   $ZSH_CUSTOM ($custom_dir)"
		(
			builtin cd ${custom_dir:h} && command find ${custom_dir:t} -name .git -prune -o -print
		)
		builtin echo
	fi
	if [[ $verbose -ge 1 ]]
	then
		builtin echo "bindkey:"
		builtin bindkey
		builtin echo
		builtin echo "infocmp:"
		command infocmp -L
		builtin echo
	fi
	local zdotdir=${ZDOTDIR:-$HOME} 
	builtin echo "Zsh configuration files:"
	local cfgfile cfgfiles
	cfgfiles=(/etc/zshenv /etc/zprofile /etc/zshrc /etc/zlogin /etc/zlogout $zdotdir/.zshenv $zdotdir/.zprofile $zdotdir/.zshrc $zdotdir/.zlogin $zdotdir/.zlogout ~/.zsh.pre-oh-my-zsh /etc/bashrc /etc/profile ~/.bashrc ~/.profile ~/.bash_profile ~/.bash_logout) 
	command ls -lad $cfgfiles 2>&1
	builtin echo
	if [[ $verbose -ge 1 ]]
	then
		for cfgfile in $cfgfiles
		do
			_omz_diag_dump_echo_file_w_header $cfgfile
		done
	fi
	builtin echo
	builtin echo "Zsh compdump files:"
	local dumpfile dumpfiles
	command ls -lad $zdotdir/.zcompdump*
	dumpfiles=($zdotdir/.zcompdump*(N)) 
	if [[ $verbose -ge 2 ]]
	then
		for dumpfile in $dumpfiles
		do
			_omz_diag_dump_echo_file_w_header $dumpfile
		done
	fi
}
_omz_diag_dump_os_specific_version () {
	local osname osver version_file version_files
	case "$OSTYPE" in
		(darwin*) osname=$(command sw_vers -productName) 
			osver=$(command sw_vers -productVersion) 
			builtin echo "OS Version: $osname $osver build $(sw_vers -buildVersion)" ;;
		(cygwin) command systeminfo | command head -n 4 | command tail -n 2 ;;
	esac
	if builtin which lsb_release > /dev/null
	then
		builtin echo "OS Release: $(command lsb_release -s -d)"
	fi
	version_files=(/etc/*-release(N) /etc/*-version(N) /etc/*_version(N)) 
	for version_file in $version_files
	do
		builtin echo "$version_file:"
		command cat "$version_file"
		builtin echo
	done
}
_omz_git_prompt_info () {
	if ! __git_prompt_git rev-parse --git-dir &> /dev/null || [[ "$(__git_prompt_git config --get oh-my-zsh.hide-info 2>/dev/null)" == 1 ]]
	then
		return 0
	fi
	local ref
	ref=$(__git_prompt_git symbolic-ref --short HEAD 2> /dev/null)  || ref=$(__git_prompt_git describe --tags --exact-match HEAD 2> /dev/null)  || ref=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null)  || return 0
	local upstream
	if (( ${+ZSH_THEME_GIT_SHOW_UPSTREAM} ))
	then
		upstream=$(__git_prompt_git rev-parse --abbrev-ref --symbolic-full-name "@{upstream}" 2>/dev/null)  && upstream=" -> ${upstream}" 
	fi
	echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${ref:gs/%/%%}${upstream:gs/%/%%}$(parse_git_dirty)${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}
_omz_git_prompt_status () {
	[[ "$(__git_prompt_git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]] && return
	local -A prefix_constant_map
	prefix_constant_map=('\?\? ' 'UNTRACKED' 'A  ' 'ADDED' 'M  ' 'MODIFIED' 'MM ' 'MODIFIED' ' M ' 'MODIFIED' 'AM ' 'MODIFIED' ' T ' 'MODIFIED' 'R  ' 'RENAMED' ' D ' 'DELETED' 'D  ' 'DELETED' 'UU ' 'UNMERGED' 'ahead' 'AHEAD' 'behind' 'BEHIND' 'diverged' 'DIVERGED' 'stashed' 'STASHED') 
	local -A constant_prompt_map
	constant_prompt_map=('UNTRACKED' "$ZSH_THEME_GIT_PROMPT_UNTRACKED" 'ADDED' "$ZSH_THEME_GIT_PROMPT_ADDED" 'MODIFIED' "$ZSH_THEME_GIT_PROMPT_MODIFIED" 'RENAMED' "$ZSH_THEME_GIT_PROMPT_RENAMED" 'DELETED' "$ZSH_THEME_GIT_PROMPT_DELETED" 'UNMERGED' "$ZSH_THEME_GIT_PROMPT_UNMERGED" 'AHEAD' "$ZSH_THEME_GIT_PROMPT_AHEAD" 'BEHIND' "$ZSH_THEME_GIT_PROMPT_BEHIND" 'DIVERGED' "$ZSH_THEME_GIT_PROMPT_DIVERGED" 'STASHED' "$ZSH_THEME_GIT_PROMPT_STASHED") 
	local status_constants
	status_constants=(UNTRACKED ADDED MODIFIED RENAMED DELETED STASHED UNMERGED AHEAD BEHIND DIVERGED) 
	local status_text
	status_text="$(__git_prompt_git status --porcelain -b 2> /dev/null)" 
	if [[ $? -eq 128 ]]
	then
		return 1
	fi
	local -A statuses_seen
	if __git_prompt_git rev-parse --verify refs/stash &> /dev/null
	then
		statuses_seen[STASHED]=1 
	fi
	local status_lines
	status_lines=("${(@f)${status_text}}") 
	if [[ "$status_lines[1]" =~ "^## [^ ]+ \[(.*)\]" ]]
	then
		local branch_statuses
		branch_statuses=("${(@s/,/)match}") 
		for branch_status in $branch_statuses
		do
			if [[ ! $branch_status =~ "(behind|diverged|ahead) ([0-9]+)?" ]]
			then
				continue
			fi
			local last_parsed_status=$prefix_constant_map[$match[1]] 
			statuses_seen[$last_parsed_status]=$match[2] 
		done
	fi
	for status_prefix in "${(@k)prefix_constant_map}"
	do
		local status_constant="${prefix_constant_map[$status_prefix]}" 
		local status_regex=$'(^|\n)'"$status_prefix" 
		if [[ "$status_text" =~ $status_regex ]]
		then
			statuses_seen[$status_constant]=1 
		fi
	done
	local status_prompt
	for status_constant in $status_constants
	do
		if (( ${+statuses_seen[$status_constant]} ))
		then
			local next_display=$constant_prompt_map[$status_constant] 
			status_prompt="$next_display$status_prompt" 
		fi
	done
	echo $status_prompt
}
_omz_register_handler () {
	setopt localoptions noksharrays unset
	typeset -ga _omz_async_functions
	if [[ -z "$1" ]] || (( ! ${+functions[$1]} )) || (( ${_omz_async_functions[(Ie)$1]} ))
	then
		return
	fi
	_omz_async_functions+=("$1") 
	if (( ! ${precmd_functions[(Ie)_omz_async_request]} )) && (( ${+functions[_omz_async_request]}))
	then
		autoload -Uz add-zsh-hook
		add-zsh-hook precmd _omz_async_request
	fi
}
_omz_source () {
	local context filepath="$1" 
	case "$filepath" in
		(lib/*) context="lib:${filepath:t:r}"  ;;
		(plugins/*) context="plugins:${filepath:h:t}"  ;;
	esac
	local disable_aliases=0 
	zstyle -T ":omz:${context}" aliases || disable_aliases=1 
	local -A aliases_pre galiases_pre
	if (( disable_aliases ))
	then
		aliases_pre=("${(@kv)aliases}") 
		galiases_pre=("${(@kv)galiases}") 
	fi
	if [[ -f "$ZSH_CUSTOM/$filepath" ]]
	then
		source "$ZSH_CUSTOM/$filepath"
	elif [[ -f "$ZSH/$filepath" ]]
	then
		source "$ZSH/$filepath"
	fi
	if (( disable_aliases ))
	then
		if (( #aliases_pre ))
		then
			aliases=("${(@kv)aliases_pre}") 
		else
			(( #aliases )) && unalias "${(@k)aliases}"
		fi
		if (( #galiases_pre ))
		then
			galiases=("${(@kv)galiases_pre}") 
		else
			(( #galiases )) && unalias "${(@k)galiases}"
		fi
	fi
}
_oomctl () {
	# undefined
	builtin autoload -XUz
}
_open () {
	# undefined
	builtin autoload -XUz
}
_openclaw_acp () {
	local -a commands
	local -a options
	_arguments -C "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--token-file[Read gateway token from file]" "--password[Gateway password (if required)]" "--password-file[Read gateway password from file]" "--session[Default session key (e.g. agent:main:main)]" "--session-label[Default session label to resolve]" "--require-existing[Fail if the session key/label does not exist]" "--reset-session[Reset the session key before first use]" "--no-prefix-cwd[Do not prefix prompts with the working directory]" "--provenance[ACP provenance mode: off, meta, or meta+receipt]" "(--verbose -v)"{--verbose,-v}"[Verbose logging to stderr]" "1: :_values 'command' 'client[Run an interactive ACP client against the local ACP bridge]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(client) _openclaw_acp_client ;;
			esac ;;
	esac
}
_openclaw_acp_client () {
	_arguments -C "--cwd[Working directory for the ACP session]" "--server[ACP server command (default: openclaw)]" "--server-args[Extra arguments for the ACP server]" "--server-verbose[Enable verbose logging on the ACP server]" "(--verbose -v)"{--verbose,-v}"[Verbose client logging]"
}
_openclaw_agent () {
	_arguments -C "(--message -m)"{--message,-m}"[Message body for the agent]" "(--to -t)"{--to,-t}"[Recipient number in E.164 used to derive the session key]" "--session-id[Use an explicit session id]" "--agent[Agent id (overrides routing bindings)]" "--thinking[Thinking level: off | minimal | low | medium | high]" "--verbose[Persist agent verbose level for the session]" "--channel[Delivery channel: last|telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon (omit to use the main session channel)]" "--reply-to[Delivery target override (separate from session routing)]" "--reply-channel[Delivery channel override (separate from routing)]" "--reply-account[Delivery account id override]" "--local[Run the embedded agent locally (requires model provider API keys in your shell)]" "--deliver[Send the agent'\''s reply back to the selected channel]" "--json[Output result as JSON]" "--timeout[Override agent command timeout (seconds, default 600 or config value)]"
}
_openclaw_agents () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'list[List configured agents]' 'bindings[List routing bindings]' 'bind[Add routing bindings for an agent]' 'unbind[Remove routing bindings for an agent]' 'add[Add a new isolated agent]' 'set-identity[Update an agent identity (name/theme/emoji/avatar)]' 'delete[Delete an agent and prune workspace/state]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(list) _openclaw_agents_list ;;
				(bindings) _openclaw_agents_bindings ;;
				(bind) _openclaw_agents_bind ;;
				(unbind) _openclaw_agents_unbind ;;
				(add) _openclaw_agents_add ;;
				(set-identity) _openclaw_agents_set_identity ;;
				(delete) _openclaw_agents_delete ;;
			esac ;;
	esac
}
_openclaw_agents_add () {
	_arguments -C "--workspace[Workspace directory for the new agent]" "--model[Model id for this agent]" "--agent-dir[Agent state directory for this agent]" "--bind[Route channel binding (repeatable)]" "--non-interactive[Disable prompts; requires --workspace]" "--json[Output JSON summary]"
}
_openclaw_agents_bind () {
	_arguments -C "--agent[Agent id (defaults to current default agent)]" "--bind[Binding to add (repeatable). If omitted, accountId is resolved by channel defaults/hooks.]" "--json[Output JSON summary]"
}
_openclaw_agents_bindings () {
	_arguments -C "--agent[Filter by agent id]" "--json[Output JSON instead of text]"
}
_openclaw_agents_delete () {
	_arguments -C "--force[Skip confirmation]" "--json[Output JSON summary]"
}
_openclaw_agents_list () {
	_arguments -C "--json[Output JSON instead of text]" "--bindings[Include routing bindings]"
}
_openclaw_agents_set_identity () {
	_arguments -C "--agent[Agent id to update]" "--workspace[Workspace directory used to locate the agent + IDENTITY.md]" "--identity-file[Explicit IDENTITY.md path to read]" "--from-identity[Read values from IDENTITY.md]" "--name[Identity name]" "--theme[Identity theme]" "--emoji[Identity emoji]" "--avatar[Identity avatar (workspace path, http(s) URL, or data URI)]" "--json[Output JSON summary]"
}
_openclaw_agents_unbind () {
	_arguments -C "--agent[Agent id (defaults to current default agent)]" "--bind[Binding to remove (repeatable)]" "--all[Remove all bindings for this agent]" "--json[Output JSON summary]"
}
_openclaw_approvals () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'get[Fetch exec approvals snapshot]' 'set[Replace exec approvals with a JSON file]' 'allowlist[Edit the per-agent allowlist]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(get) _openclaw_approvals_get ;;
				(set) _openclaw_approvals_set ;;
				(allowlist) _openclaw_approvals_allowlist ;;
			esac ;;
	esac
}
_openclaw_approvals_allowlist () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'add[Add a glob pattern to an allowlist]' 'remove[Remove a glob pattern from an allowlist]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(add) _openclaw_approvals_allowlist_add ;;
				(remove) _openclaw_approvals_allowlist_remove ;;
			esac ;;
	esac
}
_openclaw_approvals_allowlist_add () {
	_arguments -C "--node[Target node id/name/IP]" "--gateway[Force gateway approvals]" "--agent[Agent id (defaults to \"*\")]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_approvals_allowlist_remove () {
	_arguments -C "--node[Target node id/name/IP]" "--gateway[Force gateway approvals]" "--agent[Agent id (defaults to \"*\")]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_approvals_get () {
	_arguments -C "--node[Target node id/name/IP]" "--gateway[Force gateway approvals]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_approvals_set () {
	_arguments -C "--node[Target node id/name/IP]" "--gateway[Force gateway approvals]" "--file[Path to JSON file to upload]" "--stdin[Read JSON from stdin]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_backup () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'create[Write a backup archive for config, credentials, sessions, and workspaces]' 'verify[Validate a backup archive and its embedded manifest]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(create) _openclaw_backup_create ;;
				(verify) _openclaw_backup_verify ;;
			esac ;;
	esac
}
_openclaw_backup_create () {
	_arguments -C "--output[Archive path or destination directory]" "--json[Output JSON]" "--dry-run[Print the backup plan without writing the archive]" "--verify[Verify the archive after writing it]" "--only-config[Back up only the active JSON config file]" "--no-include-workspace[Exclude workspace directories from the backup]"
}
_openclaw_backup_verify () {
	_arguments -C "--json[Output JSON]"
}
_openclaw_browser () {
	local -a commands
	local -a options
	_arguments -C "--browser-profile[Browser profile name (default from config)]" "--json[Output machine-readable JSON]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--expect-final[Wait for final response (agent)]" "1: :_values 'command' 'status[Show browser status]' 'start[Start the browser (no-op if already running)]' 'stop[Stop the browser (best-effort)]' 'reset-profile[Reset browser profile (moves it to Trash)]' 'tabs[List open tabs]' 'tab[Tab shortcuts (index-based)]' 'open[Open a URL in a new tab]' 'focus[Focus a tab by target id (or unique prefix)]' 'close[Close a tab (target id optional)]' 'profiles[List all browser profiles]' 'create-profile[Create a new browser profile]' 'delete-profile[Delete a browser profile]' 'extension[Chrome extension helpers]' 'screenshot[Capture a screenshot (MEDIA:<path>)]' 'snapshot[Capture a snapshot (default: ai; aria is the accessibility tree)]' 'navigate[Navigate the current tab to a URL]' 'resize[Resize the viewport]' 'click[Click an element by ref from snapshot]' 'type[Type into an element by ref from snapshot]' 'press[Press a key]' 'hover[Hover an element by ai ref]' 'scrollintoview[Scroll an element into view by ref from snapshot]' 'drag[Drag from one ref to another]' 'select[Select option(s) in a select element]' 'upload[Arm file upload for the next file chooser]' 'waitfordownload[Wait for the next download (and save it)]' 'download[Click a ref and save the resulting download]' 'dialog[Arm the next modal dialog (alert/confirm/prompt)]' 'fill[Fill a form with JSON field descriptors]' 'wait[Wait for time, selector, URL, load state, or JS conditions]' 'evaluate[Evaluate a function against the page or a ref]' 'console[Get recent console messages]' 'pdf[Save page as PDF]' 'responsebody[Wait for a network response and return its body]' 'highlight[Highlight an element by ref]' 'errors[Get recent page errors]' 'requests[Get recent network requests (best-effort)]' 'trace[Record a Playwright trace]' 'cookies[Read/write cookies]' 'storage[Read/write localStorage/sessionStorage]' 'set[Browser environment settings]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(status) _openclaw_browser_status ;;
				(start) _openclaw_browser_start ;;
				(stop) _openclaw_browser_stop ;;
				(reset-profile) _openclaw_browser_reset_profile ;;
				(tabs) _openclaw_browser_tabs ;;
				(tab) _openclaw_browser_tab ;;
				(open) _openclaw_browser_open ;;
				(focus) _openclaw_browser_focus ;;
				(close) _openclaw_browser_close ;;
				(profiles) _openclaw_browser_profiles ;;
				(create-profile) _openclaw_browser_create_profile ;;
				(delete-profile) _openclaw_browser_delete_profile ;;
				(extension) _openclaw_browser_extension ;;
				(screenshot) _openclaw_browser_screenshot ;;
				(snapshot) _openclaw_browser_snapshot ;;
				(navigate) _openclaw_browser_navigate ;;
				(resize) _openclaw_browser_resize ;;
				(click) _openclaw_browser_click ;;
				(type) _openclaw_browser_type ;;
				(press) _openclaw_browser_press ;;
				(hover) _openclaw_browser_hover ;;
				(scrollintoview) _openclaw_browser_scrollintoview ;;
				(drag) _openclaw_browser_drag ;;
				(select) _openclaw_browser_select ;;
				(upload) _openclaw_browser_upload ;;
				(waitfordownload) _openclaw_browser_waitfordownload ;;
				(download) _openclaw_browser_download ;;
				(dialog) _openclaw_browser_dialog ;;
				(fill) _openclaw_browser_fill ;;
				(wait) _openclaw_browser_wait ;;
				(evaluate) _openclaw_browser_evaluate ;;
				(console) _openclaw_browser_console ;;
				(pdf) _openclaw_browser_pdf ;;
				(responsebody) _openclaw_browser_responsebody ;;
				(highlight) _openclaw_browser_highlight ;;
				(errors) _openclaw_browser_errors ;;
				(requests) _openclaw_browser_requests ;;
				(trace) _openclaw_browser_trace ;;
				(cookies) _openclaw_browser_cookies ;;
				(storage) _openclaw_browser_storage ;;
				(set) _openclaw_browser_set ;;
			esac ;;
	esac
}
_openclaw_browser_click () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]" "--double[Double click]" "--button[Mouse button to use]" "--modifiers[Comma-separated modifiers (Shift,Alt,Meta)]"
}
_openclaw_browser_close () {
	_arguments -C
}
_openclaw_browser_console () {
	_arguments -C "--level[Filter by level (error, warn, info)]" "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_cookies () {
	local -a commands
	local -a options
	_arguments -C "--target-id[CDP target id (or unique prefix)]" "1: :_values 'command' 'set[Set a cookie (requires --url or domain+path)]' 'clear[Clear all cookies]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(set) _openclaw_browser_cookies_set ;;
				(clear) _openclaw_browser_cookies_clear ;;
			esac ;;
	esac
}
_openclaw_browser_cookies_clear () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_cookies_set () {
	_arguments -C "--url[Cookie URL scope (recommended)]" "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_create_profile () {
	_arguments -C "--name[Profile name (lowercase, numbers, hyphens)]" "--color[Profile color (hex format, e.g. #0066CC)]" "--cdp-url[CDP URL for remote Chrome (http/https)]" "--driver[Profile driver (openclaw|extension). Default: openclaw]"
}
_openclaw_browser_delete_profile () {
	_arguments -C "--name[Profile name to delete]"
}
_openclaw_browser_dialog () {
	_arguments -C "--accept[Accept the dialog]" "--dismiss[Dismiss the dialog]" "--prompt[Prompt response text]" "--target-id[CDP target id (or unique prefix)]" "--timeout-ms[How long to wait for the next dialog (default: 120000)]"
}
_openclaw_browser_download () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]" "--timeout-ms[How long to wait for the download to start (default: 120000)]"
}
_openclaw_browser_drag () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_errors () {
	_arguments -C "--clear[Clear stored errors after reading]" "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_evaluate () {
	_arguments -C "--fn[Function source, e.g. (el) => el.textContent]" "--ref[Ref from snapshot]" "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_extension () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'install[Install the Chrome extension to a stable local path]' 'path[Print the path to the installed Chrome extension (load unpacked)]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(install) _openclaw_browser_extension_install ;;
				(path) _openclaw_browser_extension_path ;;
			esac ;;
	esac
}
_openclaw_browser_extension_install () {
	_arguments -C
}
_openclaw_browser_extension_path () {
	_arguments -C
}
_openclaw_browser_fill () {
	_arguments -C "--fields[JSON array of field objects]" "--fields-file[Read JSON array from a file]" "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_focus () {
	_arguments -C
}
_openclaw_browser_highlight () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_hover () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_navigate () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_open () {
	_arguments -C
}
_openclaw_browser_pdf () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_press () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_profiles () {
	_arguments -C
}
_openclaw_browser_requests () {
	_arguments -C "--filter[Only show URLs that contain this substring]" "--clear[Clear stored requests after reading]" "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_reset_profile () {
	_arguments -C
}
_openclaw_browser_resize () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_responsebody () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]" "--timeout-ms[How long to wait for the response (default: 20000)]" "--max-chars[Max body chars to return (default: 200000)]"
}
_openclaw_browser_screenshot () {
	_arguments -C "--full-page[Capture full scrollable page]" "--ref[ARIA ref from ai snapshot]" "--element[CSS selector for element screenshot]" "--type[Output type (default: png)]"
}
_openclaw_browser_scrollintoview () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]" "--timeout-ms[How long to wait for scroll (default: 20000)]"
}
_openclaw_browser_select () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_set () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'viewport[Set viewport size (alias for resize)]' 'offline[Toggle offline mode]' 'headers[Set extra HTTP headers (JSON object)]' 'credentials[Set HTTP basic auth credentials]' 'geo[Set geolocation (and grant permission)]' 'media[Emulate prefers-color-scheme]' 'timezone[Override timezone (CDP)]' 'locale[Override locale (CDP)]' 'device[Apply a Playwright device descriptor (e.g. "iPhone 14")]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(viewport) _openclaw_browser_set_viewport ;;
				(offline) _openclaw_browser_set_offline ;;
				(headers) _openclaw_browser_set_headers ;;
				(credentials) _openclaw_browser_set_credentials ;;
				(geo) _openclaw_browser_set_geo ;;
				(media) _openclaw_browser_set_media ;;
				(timezone) _openclaw_browser_set_timezone ;;
				(locale) _openclaw_browser_set_locale ;;
				(device) _openclaw_browser_set_device ;;
			esac ;;
	esac
}
_openclaw_browser_set_credentials () {
	_arguments -C "--clear[Clear credentials]" "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_set_device () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_set_geo () {
	_arguments -C "--clear[Clear geolocation + permissions]" "--accuracy[Accuracy in meters]" "--origin[Origin to grant permissions for]" "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_set_headers () {
	_arguments -C "--headers-json[JSON object of headers]" "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_set_locale () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_set_media () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_set_offline () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_set_timezone () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_set_viewport () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_snapshot () {
	_arguments -C "--format[Snapshot format (default: ai)]" "--target-id[CDP target id (or unique prefix)]" "--limit[Max nodes (default: 500/800)]" "--mode[Snapshot preset (efficient)]" "--efficient[Use the efficient snapshot preset]" "--interactive[Role snapshot: interactive elements only]" "--compact[Role snapshot: compact output]" "--depth[Role snapshot: max depth]" "--selector[Role snapshot: scope to CSS selector]" "--frame[Role snapshot: scope to an iframe selector]" "--labels[Include viewport label overlay screenshot]" "--out[Write snapshot to a file]"
}
_openclaw_browser_start () {
	_arguments -C
}
_openclaw_browser_status () {
	_arguments -C
}
_openclaw_browser_stop () {
	_arguments -C
}
_openclaw_browser_storage () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'local[localStorage commands]' 'session[sessionStorage commands]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(local) _openclaw_browser_storage_local ;;
				(session) _openclaw_browser_storage_session ;;
			esac ;;
	esac
}
_openclaw_browser_storage_local () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'get[Get localStorage (all keys or one key)]' 'set[Set a localStorage key]' 'clear[Clear all localStorage keys]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(get) _openclaw_browser_storage_local_get ;;
				(set) _openclaw_browser_storage_local_set ;;
				(clear) _openclaw_browser_storage_local_clear ;;
			esac ;;
	esac
}
_openclaw_browser_storage_local_clear () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_storage_local_get () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_storage_local_set () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_storage_session () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'get[Get sessionStorage (all keys or one key)]' 'set[Set a sessionStorage key]' 'clear[Clear all sessionStorage keys]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(get) _openclaw_browser_storage_session_get ;;
				(set) _openclaw_browser_storage_session_set ;;
				(clear) _openclaw_browser_storage_session_clear ;;
			esac ;;
	esac
}
_openclaw_browser_storage_session_clear () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_storage_session_get () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_storage_session_set () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_tab () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'new[Open a new tab (about:blank)]' 'select[Focus tab by index (1-based)]' 'close[Close tab by index (1-based); default: first tab]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(new) _openclaw_browser_tab_new ;;
				(select) _openclaw_browser_tab_select ;;
				(close) _openclaw_browser_tab_close ;;
			esac ;;
	esac
}
_openclaw_browser_tab_close () {
	_arguments -C
}
_openclaw_browser_tab_new () {
	_arguments -C
}
_openclaw_browser_tab_select () {
	_arguments -C
}
_openclaw_browser_tabs () {
	_arguments -C
}
_openclaw_browser_trace () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'start[Start trace recording]' 'stop[Stop trace recording and write a .zip]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(start) _openclaw_browser_trace_start ;;
				(stop) _openclaw_browser_trace_stop ;;
			esac ;;
	esac
}
_openclaw_browser_trace_start () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]" "--no-screenshots[Disable screenshots]" "--no-snapshots[Disable snapshots]" "--sources[Include sources (bigger traces)]"
}
_openclaw_browser_trace_stop () {
	_arguments -C "--out[Output path within openclaw temp dir (e.g. trace.zip or /tmp/openclaw/trace.zip)]" "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_type () {
	_arguments -C "--submit[Press Enter after typing]" "--slowly[Type slowly (human-like)]" "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_upload () {
	_arguments -C "--ref[Ref id from snapshot to click after arming]" "--input-ref[Ref id for <input type=file> to set directly]" "--element[CSS selector for <input type=file>]" "--target-id[CDP target id (or unique prefix)]" "--timeout-ms[How long to wait for the next file chooser (default: 120000)]"
}
_openclaw_browser_wait () {
	_arguments -C "--time[Wait for N milliseconds]" "--text[Wait for text to appear]" "--text-gone[Wait for text to disappear]" "--url[Wait for URL (supports globs like **/dash)]" "--load[Wait for load state]" "--fn[Wait for JS condition (passed to waitForFunction)]" "--timeout-ms[How long to wait for each condition (default: 20000)]" "--target-id[CDP target id (or unique prefix)]"
}
_openclaw_browser_waitfordownload () {
	_arguments -C "--target-id[CDP target id (or unique prefix)]" "--timeout-ms[How long to wait for the next download (default: 120000)]"
}
_openclaw_channels () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'list[List configured channels + auth profiles]' 'status[Show gateway channel status (use status --deep for local)]' 'capabilities[Show provider capabilities (intents/scopes + supported features)]' 'resolve[Resolve channel/user names to IDs]' 'logs[Show recent channel logs from the gateway log file]' 'add[Add or update a channel account]' 'remove[Disable or delete a channel account]' 'login[Link a channel account (if supported)]' 'logout[Log out of a channel session (if supported)]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(list) _openclaw_channels_list ;;
				(status) _openclaw_channels_status ;;
				(capabilities) _openclaw_channels_capabilities ;;
				(resolve) _openclaw_channels_resolve ;;
				(logs) _openclaw_channels_logs ;;
				(add) _openclaw_channels_add ;;
				(remove) _openclaw_channels_remove ;;
				(login) _openclaw_channels_login ;;
				(logout) _openclaw_channels_logout ;;
			esac ;;
	esac
}
_openclaw_channels_add () {
	_arguments -C "--channel[Channel (telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon)]" "--account[Account id (default when omitted)]" "--name[Display name for this account]" "--token[Bot token (Telegram/Discord)]" "--token-file[Bot token file (Telegram)]" "--bot-token[Slack bot token (xoxb-...)]" "--app-token[Slack app token (xapp-...)]" "--signal-number[Signal account number (E.164)]" "--cli-path[CLI path (signal-cli or imsg)]" "--db-path[iMessage database path]" "--service[iMessage service (imessage|sms|auto)]" "--region[iMessage region (for SMS)]" "--auth-dir[WhatsApp auth directory override]" "--http-url[Signal HTTP daemon base URL]" "--http-host[Signal HTTP host]" "--http-port[Signal HTTP port]" "--webhook-path[Webhook path (Google Chat/BlueBubbles)]" "--webhook-url[Google Chat webhook URL]" "--audience-type[Google Chat audience type (app-url|project-number)]" "--audience[Google Chat audience value (app URL or project number)]" "--homeserver[Matrix homeserver URL]" "--user-id[Matrix user ID]" "--access-token[Matrix access token]" "--password[Matrix password]" "--device-name[Matrix device name]" "--initial-sync-limit[Matrix initial sync limit]" "--ship[Tlon ship name (~sampel-palnet)]" "--url[Tlon ship URL]" "--code[Tlon login code]" "--group-channels[Tlon group channels (comma-separated)]" "--dm-allowlist[Tlon DM allowlist (comma-separated ships)]" "--auto-discover-channels[Tlon auto-discover group channels]" "--no-auto-discover-channels[Disable Tlon auto-discovery]" "--use-env[Use env token (default account only)]"
}
_openclaw_channels_capabilities () {
	_arguments -C "--channel[Channel (all|telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon)]" "--account[Account id (only with --channel)]" "--target[Channel target for permission audit (Discord channel:<id>)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_channels_list () {
	_arguments -C "--no-usage[Skip model provider usage/quota snapshots]" "--json[Output JSON]"
}
_openclaw_channels_login () {
	_arguments -C "--channel[Channel alias (auto when only one is configured)]" "--account[Account id (accountId)]" "--verbose[Verbose connection logs]"
}
_openclaw_channels_logout () {
	_arguments -C "--channel[Channel alias (auto when only one is configured)]" "--account[Account id (accountId)]"
}
_openclaw_channels_logs () {
	_arguments -C "--channel[Channel (all|telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon)]" "--lines[Number of lines (default: 200)]" "--json[Output JSON]"
}
_openclaw_channels_remove () {
	_arguments -C "--channel[Channel (telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon)]" "--account[Account id (default when omitted)]" "--delete[Delete config entries (no prompt)]"
}
_openclaw_channels_resolve () {
	_arguments -C "--channel[Channel (telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon)]" "--account[Account id (accountId)]" "--kind[Target kind (auto|user|group)]" "--json[Output JSON]"
}
_openclaw_channels_status () {
	_arguments -C "--probe[Probe channel credentials]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_clawbot () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'qr[Generate an iOS pairing QR code and setup code]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(qr) _openclaw_clawbot_qr ;;
			esac ;;
	esac
}
_openclaw_clawbot_qr () {
	_arguments -C "--remote[Use gateway.remote.url and gateway.remote token/password (ignores device-pair publicUrl)]" "--url[Override gateway URL used in the setup payload]" "--public-url[Override gateway public URL used in the setup payload]" "--token[Override gateway token for setup payload]" "--password[Override gateway password for setup payload]" "--setup-code-only[Print only the setup code]" "--no-ascii[Skip ASCII QR rendering]" "--json[Output JSON]"
}
_openclaw_completion () {
	_arguments -C "(--shell -s)"{--shell,-s}"[Shell to generate completion for (default: zsh)]" "(--install -i)"{--install,-i}"[Install completion script to shell profile]" "--write-state[Write completion scripts to $OPENCLAW_STATE_DIR/completions (no stdout)]" "(--yes -y)"{--yes,-y}"[Skip confirmation (non-interactive)]"
}
_openclaw_config () {
	local -a commands
	local -a options
	_arguments -C "--section[Configure wizard sections (repeatable). Use with no subcommand.]" "1: :_values 'command' 'get[Get a config value by dot path]' 'set[Set a config value by dot path]' 'unset[Remove a config value by dot path]' 'file[Print the active config file path]' 'validate[Validate the current config against the schema without starting the gateway]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(get) _openclaw_config_get ;;
				(set) _openclaw_config_set ;;
				(unset) _openclaw_config_unset ;;
				(file) _openclaw_config_file ;;
				(validate) _openclaw_config_validate ;;
			esac ;;
	esac
}
_openclaw_config_file () {
	_arguments -C
}
_openclaw_config_get () {
	_arguments -C "--json[Output JSON]"
}
_openclaw_config_set () {
	_arguments -C "--strict-json[Strict JSON5 parsing (error instead of raw string fallback)]" "--json[Legacy alias for --strict-json]"
}
_openclaw_config_unset () {
	_arguments -C
}
_openclaw_config_validate () {
	_arguments -C "--json[Output validation result as JSON]"
}
_openclaw_configure () {
	_arguments -C "--section[Configuration sections (repeatable). Options: workspace, model, web, gateway, daemon, channels, skills, health]"
}
_openclaw_cron () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'status[Show cron scheduler status]' 'list[List cron jobs]' 'add[Add a cron job]' 'rm[Remove a cron job]' 'enable[Enable a cron job]' 'disable[Disable a cron job]' 'runs[Show cron run history (JSONL-backed)]' 'run[Run a cron job now (debug)]' 'edit[Edit a cron job (patch fields)]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(status) _openclaw_cron_status ;;
				(list) _openclaw_cron_list ;;
				(add) _openclaw_cron_add ;;
				(rm) _openclaw_cron_rm ;;
				(enable) _openclaw_cron_enable ;;
				(disable) _openclaw_cron_disable ;;
				(runs) _openclaw_cron_runs ;;
				(run) _openclaw_cron_run ;;
				(edit) _openclaw_cron_edit ;;
			esac ;;
	esac
}
_openclaw_cron_add () {
	_arguments -C "--name[Job name]" "--description[Optional description]" "--disabled[Create job disabled]" "--delete-after-run[Delete one-shot job after it succeeds]" "--keep-after-run[Keep one-shot job after it succeeds]" "--agent[Agent id for this job]" "--session[Session target (main|isolated)]" "--session-key[Session key for job routing (e.g. agent:my-agent:my-session)]" "--wake[Wake mode (now|next-heartbeat)]" "--at[Run once at time (ISO) or +duration (e.g. 20m)]" "--every[Run every duration (e.g. 10m, 1h)]" "--cron[Cron expression (5-field or 6-field with seconds)]" "--tz[Timezone for cron expressions (IANA)]" "--stagger[Cron stagger window (e.g. 30s, 5m)]" "--exact[Disable cron staggering (set stagger to 0)]" "--system-event[System event payload (main session)]" "--message[Agent message payload]" "--thinking[Thinking level for agent jobs (off|minimal|low|medium|high)]" "--model[Model override for agent jobs (provider/model or alias)]" "--timeout-seconds[Timeout seconds for agent jobs]" "--light-context[Use lightweight bootstrap context for agent jobs]" "--announce[Announce summary to a chat (subagent-style)]" "--deliver[Deprecated (use --announce). Announces a summary to a chat.]" "--no-deliver[Disable announce delivery and skip main-session summary]" "--channel[Delivery channel (last)]" "--to[Delivery destination (E.164, Telegram chatId, or Discord channel/user)]" "--account[Channel account id for delivery (multi-account setups)]" "--best-effort-deliver[Do not fail the job if delivery fails]" "--json[Output JSON]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--expect-final[Wait for final response (agent)]"
}
_openclaw_cron_disable () {
	_arguments -C "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--expect-final[Wait for final response (agent)]"
}
_openclaw_cron_edit () {
	_arguments -C "--name[Set name]" "--description[Set description]" "--enable[Enable job]" "--disable[Disable job]" "--delete-after-run[Delete one-shot job after it succeeds]" "--keep-after-run[Keep one-shot job after it succeeds]" "--session[Session target (main|isolated)]" "--agent[Set agent id]" "--clear-agent[Unset agent and use default]" "--session-key[Set session key for job routing]" "--clear-session-key[Unset session key]" "--wake[Wake mode (now|next-heartbeat)]" "--at[Set one-shot time (ISO) or duration like 20m]" "--every[Set interval duration like 10m]" "--cron[Set cron expression]" "--tz[Timezone for cron expressions (IANA)]" "--stagger[Cron stagger window (e.g. 30s, 5m)]" "--exact[Disable cron staggering (set stagger to 0)]" "--system-event[Set systemEvent payload]" "--message[Set agentTurn payload message]" "--thinking[Thinking level for agent jobs]" "--model[Model override for agent jobs]" "--timeout-seconds[Timeout seconds for agent jobs]" "--light-context[Enable lightweight bootstrap context for agent jobs]" "--no-light-context[Disable lightweight bootstrap context for agent jobs]" "--announce[Announce summary to a chat (subagent-style)]" "--deliver[Deprecated (use --announce). Announces a summary to a chat.]" "--no-deliver[Disable announce delivery]" "--channel[Delivery channel (last)]" "--to[Delivery destination (E.164, Telegram chatId, or Discord channel/user)]" "--account[Channel account id for delivery (multi-account setups)]" "--best-effort-deliver[Do not fail job if delivery fails]" "--no-best-effort-deliver[Fail job when delivery fails]" "--failure-alert[Enable failure alerts for this job]" "--no-failure-alert[Disable failure alerts for this job]" "--failure-alert-after[Alert after N consecutive job errors]" "--failure-alert-channel[Failure alert channel (last)]" "--failure-alert-to[Failure alert destination]" "--failure-alert-cooldown[Minimum time between alerts (e.g. 1h, 30m)]" "--failure-alert-mode[Failure alert delivery mode (announce or webhook)]" "--failure-alert-account-id[Account ID for failure alert channel (multi-account setups)]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--expect-final[Wait for final response (agent)]"
}
_openclaw_cron_enable () {
	_arguments -C "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--expect-final[Wait for final response (agent)]"
}
_openclaw_cron_list () {
	_arguments -C "--all[Include disabled jobs]" "--json[Output JSON]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--expect-final[Wait for final response (agent)]"
}
_openclaw_cron_rm () {
	_arguments -C "--json[Output JSON]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--expect-final[Wait for final response (agent)]"
}
_openclaw_cron_run () {
	_arguments -C "--due[Run only when due (default behavior in older versions)]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--expect-final[Wait for final response (agent)]"
}
_openclaw_cron_runs () {
	_arguments -C "--id[Job id]" "--limit[Max entries (default 50)]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--expect-final[Wait for final response (agent)]"
}
_openclaw_cron_status () {
	_arguments -C "--json[Output JSON]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--expect-final[Wait for final response (agent)]"
}
_openclaw_daemon () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'status[Show service install status + probe the Gateway]' 'install[Install the Gateway service (launchd/systemd/schtasks)]' 'uninstall[Uninstall the Gateway service (launchd/systemd/schtasks)]' 'start[Start the Gateway service (launchd/systemd/schtasks)]' 'stop[Stop the Gateway service (launchd/systemd/schtasks)]' 'restart[Restart the Gateway service (launchd/systemd/schtasks)]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(status) _openclaw_daemon_status ;;
				(install) _openclaw_daemon_install ;;
				(uninstall) _openclaw_daemon_uninstall ;;
				(start) _openclaw_daemon_start ;;
				(stop) _openclaw_daemon_stop ;;
				(restart) _openclaw_daemon_restart ;;
			esac ;;
	esac
}
_openclaw_daemon_install () {
	_arguments -C "--port[Gateway port]" "--runtime[Daemon runtime (node|bun). Default: node]" "--token[Gateway token (token auth)]" "--force[Reinstall/overwrite if already installed]" "--json[Output JSON]"
}
_openclaw_daemon_restart () {
	_arguments -C "--json[Output JSON]"
}
_openclaw_daemon_start () {
	_arguments -C "--json[Output JSON]"
}
_openclaw_daemon_status () {
	_arguments -C "--url[Gateway WebSocket URL (defaults to config/remote/local)]" "--token[Gateway token (if required)]" "--password[Gateway password (password auth)]" "--timeout[Timeout in ms]" "--no-probe[Skip RPC probe]" "--deep[Scan system-level services]" "--json[Output JSON]"
}
_openclaw_daemon_stop () {
	_arguments -C "--json[Output JSON]"
}
_openclaw_daemon_uninstall () {
	_arguments -C "--json[Output JSON]"
}
_openclaw_dashboard () {
	_arguments -C "--no-open[Print URL but do not launch a browser]"
}
_openclaw_devices () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'list[List pending and paired devices]' 'remove[Remove a paired device entry]' 'clear[Clear paired devices from the gateway table]' 'approve[Approve a pending device pairing request]' 'reject[Reject a pending device pairing request]' 'rotate[Rotate a device token for a role]' 'revoke[Revoke a device token for a role]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(list) _openclaw_devices_list ;;
				(remove) _openclaw_devices_remove ;;
				(clear) _openclaw_devices_clear ;;
				(approve) _openclaw_devices_approve ;;
				(reject) _openclaw_devices_reject ;;
				(rotate) _openclaw_devices_rotate ;;
				(revoke) _openclaw_devices_revoke ;;
			esac ;;
	esac
}
_openclaw_devices_approve () {
	_arguments -C "--latest[Approve the most recent pending request]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--password[Gateway password (password auth)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_devices_clear () {
	_arguments -C "--pending[Also reject all pending pairing requests]" "--yes[Confirm destructive clear]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--password[Gateway password (password auth)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_devices_list () {
	_arguments -C "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--password[Gateway password (password auth)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_devices_reject () {
	_arguments -C "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--password[Gateway password (password auth)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_devices_remove () {
	_arguments -C "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--password[Gateway password (password auth)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_devices_revoke () {
	_arguments -C "--device[Device id]" "--role[Role name]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--password[Gateway password (password auth)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_devices_rotate () {
	_arguments -C "--device[Device id]" "--role[Role name]" "--scope[Scopes to attach to the token (repeatable)]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--password[Gateway password (password auth)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_directory () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'self[Show the current account user]' 'peers[Peer directory (contacts/users)]' 'groups[Group directory]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(self) _openclaw_directory_self ;;
				(peers) _openclaw_directory_peers ;;
				(groups) _openclaw_directory_groups ;;
			esac ;;
	esac
}
_openclaw_directory_groups () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'list[List groups]' 'members[List group members]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(list) _openclaw_directory_groups_list ;;
				(members) _openclaw_directory_groups_members ;;
			esac ;;
	esac
}
_openclaw_directory_groups_list () {
	_arguments -C "--channel[Channel (auto when only one is configured)]" "--account[Account id (accountId)]" "--json[Output JSON]" "--query[Optional search query]" "--limit[Limit results]"
}
_openclaw_directory_groups_members () {
	_arguments -C "--group-id[Group id]" "--channel[Channel (auto when only one is configured)]" "--account[Account id (accountId)]" "--json[Output JSON]" "--limit[Limit results]"
}
_openclaw_directory_peers () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'list[List peers]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(list) _openclaw_directory_peers_list ;;
			esac ;;
	esac
}
_openclaw_directory_peers_list () {
	_arguments -C "--channel[Channel (auto when only one is configured)]" "--account[Account id (accountId)]" "--json[Output JSON]" "--query[Optional search query]" "--limit[Limit results]"
}
_openclaw_directory_self () {
	_arguments -C "--channel[Channel (auto when only one is configured)]" "--account[Account id (accountId)]" "--json[Output JSON]"
}
_openclaw_dns () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'setup[Set up CoreDNS to serve your discovery domain for unicast DNS-SD (Wide-Area Bonjour)]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(setup) _openclaw_dns_setup ;;
			esac ;;
	esac
}
_openclaw_dns_setup () {
	_arguments -C "--domain[Wide-area discovery domain (e.g. openclaw.internal)]" "--apply[Install/update CoreDNS config and (re)start the service (requires sudo)]"
}
_openclaw_docs () {
	_arguments -C
}
_openclaw_doctor () {
	_arguments -C "--no-workspace-suggestions[Disable workspace memory system suggestions]" "--yes[Accept defaults without prompting]" "--repair[Apply recommended repairs without prompting]" "--fix[Apply recommended repairs (alias for --repair)]" "--force[Apply aggressive repairs (overwrites custom service config)]" "--non-interactive[Run without prompts (safe migrations only)]" "--generate-gateway-token[Generate and configure a gateway token]" "--deep[Scan system services for extra gateway installs]"
}
_openclaw_gateway () {
	local -a commands
	local -a options
	_arguments -C "--port[Port for the gateway WebSocket]" "--bind[Bind mode (\"loopback\"|\"lan\"|\"tailnet\"|\"auto\"|\"custom\"). Defaults to config gateway.bind (or loopback).]" "--token[Shared token required in connect.params.auth.token (default: OPENCLAW_GATEWAY_TOKEN env if set)]" "--auth[Gateway auth mode (\"none\"|\"token\"|\"password\"|\"trusted-proxy\")]" "--password[Password for auth mode=password]" "--password-file[Read gateway password from file]" "--tailscale[Tailscale exposure mode (\"off\"|\"serve\"|\"funnel\")]" "--tailscale-reset-on-exit[Reset Tailscale serve/funnel configuration on shutdown]" "--allow-unconfigured[Allow gateway start without gateway.mode=local in config]" "--dev[Create a dev config + workspace if missing (no BOOTSTRAP.md)]" "--reset[Reset dev config + credentials + sessions + workspace (requires --dev)]" "--force[Kill any existing listener on the target port before starting]" "--verbose[Verbose logging to stdout/stderr]" "--claude-cli-logs[Only show claude-cli logs in the console (includes stdout/stderr)]" "--ws-log[WebSocket log style (\"auto\"|\"full\"|\"compact\")]" "--compact[Alias for \"--ws-log compact\"]" "--raw-stream[Log raw model stream events to jsonl]" "--raw-stream-path[Raw stream jsonl path]" "1: :_values 'command' 'run[Run the WebSocket Gateway (foreground)]' 'status[Show gateway service status + probe the Gateway]' 'install[Install the Gateway service (launchd/systemd/schtasks)]' 'uninstall[Uninstall the Gateway service (launchd/systemd/schtasks)]' 'start[Start the Gateway service (launchd/systemd/schtasks)]' 'stop[Stop the Gateway service (launchd/systemd/schtasks)]' 'restart[Restart the Gateway service (launchd/systemd/schtasks)]' 'call[Call a Gateway method]' 'usage-cost[Fetch usage cost summary from session logs]' 'health[Fetch Gateway health]' 'probe[Show gateway reachability + discovery + health + status summary (local + remote)]' 'discover[Discover gateways via Bonjour (local + wide-area if configured)]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(run) _openclaw_gateway_run ;;
				(status) _openclaw_gateway_status ;;
				(install) _openclaw_gateway_install ;;
				(uninstall) _openclaw_gateway_uninstall ;;
				(start) _openclaw_gateway_start ;;
				(stop) _openclaw_gateway_stop ;;
				(restart) _openclaw_gateway_restart ;;
				(call) _openclaw_gateway_call ;;
				(usage-cost) _openclaw_gateway_usage_cost ;;
				(health) _openclaw_gateway_health ;;
				(probe) _openclaw_gateway_probe ;;
				(discover) _openclaw_gateway_discover ;;
			esac ;;
	esac
}
_openclaw_gateway_call () {
	_arguments -C "--params[JSON object string for params]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--password[Gateway password (password auth)]" "--timeout[Timeout in ms]" "--expect-final[Wait for final response (agent)]" "--json[Output JSON]"
}
_openclaw_gateway_discover () {
	_arguments -C "--timeout[Per-command timeout in ms]" "--json[Output JSON]"
}
_openclaw_gateway_health () {
	_arguments -C "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--password[Gateway password (password auth)]" "--timeout[Timeout in ms]" "--expect-final[Wait for final response (agent)]" "--json[Output JSON]"
}
_openclaw_gateway_install () {
	_arguments -C "--port[Gateway port]" "--runtime[Daemon runtime (node|bun). Default: node]" "--token[Gateway token (token auth)]" "--force[Reinstall/overwrite if already installed]" "--json[Output JSON]"
}
_openclaw_gateway_probe () {
	_arguments -C "--url[Explicit Gateway WebSocket URL (still probes localhost)]" "--ssh[SSH target for remote gateway tunnel (user@host or user@host:port)]" "--ssh-identity[SSH identity file path]" "--ssh-auto[Try to derive an SSH target from Bonjour discovery]" "--token[Gateway token (applies to all probes)]" "--password[Gateway password (applies to all probes)]" "--timeout[Overall probe budget in ms]" "--json[Output JSON]"
}
_openclaw_gateway_restart () {
	_arguments -C "--json[Output JSON]"
}
_openclaw_gateway_run () {
	_arguments -C "--port[Port for the gateway WebSocket]" "--bind[Bind mode (\"loopback\"|\"lan\"|\"tailnet\"|\"auto\"|\"custom\"). Defaults to config gateway.bind (or loopback).]" "--token[Shared token required in connect.params.auth.token (default: OPENCLAW_GATEWAY_TOKEN env if set)]" "--auth[Gateway auth mode (\"none\"|\"token\"|\"password\"|\"trusted-proxy\")]" "--password[Password for auth mode=password]" "--password-file[Read gateway password from file]" "--tailscale[Tailscale exposure mode (\"off\"|\"serve\"|\"funnel\")]" "--tailscale-reset-on-exit[Reset Tailscale serve/funnel configuration on shutdown]" "--allow-unconfigured[Allow gateway start without gateway.mode=local in config]" "--dev[Create a dev config + workspace if missing (no BOOTSTRAP.md)]" "--reset[Reset dev config + credentials + sessions + workspace (requires --dev)]" "--force[Kill any existing listener on the target port before starting]" "--verbose[Verbose logging to stdout/stderr]" "--claude-cli-logs[Only show claude-cli logs in the console (includes stdout/stderr)]" "--ws-log[WebSocket log style (\"auto\"|\"full\"|\"compact\")]" "--compact[Alias for \"--ws-log compact\"]" "--raw-stream[Log raw model stream events to jsonl]" "--raw-stream-path[Raw stream jsonl path]"
}
_openclaw_gateway_start () {
	_arguments -C "--json[Output JSON]"
}
_openclaw_gateway_status () {
	_arguments -C "--url[Gateway WebSocket URL (defaults to config/remote/local)]" "--token[Gateway token (if required)]" "--password[Gateway password (password auth)]" "--timeout[Timeout in ms]" "--no-probe[Skip RPC probe]" "--deep[Scan system-level services]" "--json[Output JSON]"
}
_openclaw_gateway_stop () {
	_arguments -C "--json[Output JSON]"
}
_openclaw_gateway_uninstall () {
	_arguments -C "--json[Output JSON]"
}
_openclaw_gateway_usage_cost () {
	_arguments -C "--days[Number of days to include]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--password[Gateway password (password auth)]" "--timeout[Timeout in ms]" "--expect-final[Wait for final response (agent)]" "--json[Output JSON]"
}
_openclaw_health () {
	_arguments -C "--json[Output JSON instead of text]" "--timeout[Connection timeout in milliseconds]" "--verbose[Verbose logging]" "--debug[Alias for --verbose]"
}
_openclaw_hooks () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'list[List all hooks]' 'info[Show detailed information about a hook]' 'check[Check hooks eligibility status]' 'enable[Enable a hook]' 'disable[Disable a hook]' 'install[Install a hook pack (path, archive, or npm spec)]' 'update[Update installed hooks (npm installs only)]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(list) _openclaw_hooks_list ;;
				(info) _openclaw_hooks_info ;;
				(check) _openclaw_hooks_check ;;
				(enable) _openclaw_hooks_enable ;;
				(disable) _openclaw_hooks_disable ;;
				(install) _openclaw_hooks_install ;;
				(update) _openclaw_hooks_update ;;
			esac ;;
	esac
}
_openclaw_hooks_check () {
	_arguments -C "--json[Output as JSON]"
}
_openclaw_hooks_disable () {
	_arguments -C
}
_openclaw_hooks_enable () {
	_arguments -C
}
_openclaw_hooks_info () {
	_arguments -C "--json[Output as JSON]"
}
_openclaw_hooks_install () {
	_arguments -C "(--link -l)"{--link,-l}"[Link a local path instead of copying]" "--pin[Record npm installs as exact resolved <name>@<version>]"
}
_openclaw_hooks_list () {
	_arguments -C "--eligible[Show only eligible hooks]" "--json[Output as JSON]" "(--verbose -v)"{--verbose,-v}"[Show more details including missing requirements]"
}
_openclaw_hooks_update () {
	_arguments -C "--all[Update all tracked hooks]" "--dry-run[Show what would change without writing]"
}
_openclaw_logs () {
	_arguments -C "--limit[Max lines to return]" "--max-bytes[Max bytes to read]" "--follow[Follow log output]" "--interval[Polling interval in ms]" "--json[Emit JSON log lines]" "--plain[Plain text output (no ANSI styling)]" "--no-color[Disable ANSI colors]" "--local-time[Display timestamps in local timezone]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--expect-final[Wait for final response (agent)]"
}
_openclaw_memory () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'status[Show memory search index status]' 'index[Reindex memory files]' 'search[Search memory files]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(status) _openclaw_memory_status ;;
				(index) _openclaw_memory_index ;;
				(search) _openclaw_memory_search ;;
			esac ;;
	esac
}
_openclaw_memory_index () {
	_arguments -C "--agent[Agent id (default: default agent)]" "--force[Force full reindex]" "--verbose[Verbose logging]"
}
_openclaw_memory_search () {
	_arguments -C "--query[Search query (alternative to positional argument)]" "--agent[Agent id (default: default agent)]" "--max-results[Max results]" "--min-score[Minimum score]" "--json[Print JSON]"
}
_openclaw_memory_status () {
	_arguments -C "--agent[Agent id (default: default agent)]" "--json[Print JSON]" "--deep[Probe embedding provider availability]" "--index[Reindex if dirty (implies --deep)]" "--verbose[Verbose logging]"
}
_openclaw_message () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'send[Send a message]' 'broadcast[Broadcast a message to multiple targets]' 'poll[Send a poll]' 'react[Add or remove a reaction]' 'reactions[List reactions on a message]' 'read[Read recent messages]' 'edit[Edit a message]' 'delete[Delete a message]' 'pin[Pin a message]' 'unpin[Unpin a message]' 'pins[List pinned messages]' 'permissions[Fetch channel permissions]' 'search[Search Discord messages]' 'thread[Thread actions]' 'emoji[Emoji actions]' 'sticker[Sticker actions]' 'role[Role actions]' 'channel[Channel actions]' 'member[Member actions]' 'voice[Voice actions]' 'event[Event actions]' 'timeout[Timeout a member]' 'kick[Kick a member]' 'ban[Ban a member]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(send) _openclaw_message_send ;;
				(broadcast) _openclaw_message_broadcast ;;
				(poll) _openclaw_message_poll ;;
				(react) _openclaw_message_react ;;
				(reactions) _openclaw_message_reactions ;;
				(read) _openclaw_message_read ;;
				(edit) _openclaw_message_edit ;;
				(delete) _openclaw_message_delete ;;
				(pin) _openclaw_message_pin ;;
				(unpin) _openclaw_message_unpin ;;
				(pins) _openclaw_message_pins ;;
				(permissions) _openclaw_message_permissions ;;
				(search) _openclaw_message_search ;;
				(thread) _openclaw_message_thread ;;
				(emoji) _openclaw_message_emoji ;;
				(sticker) _openclaw_message_sticker ;;
				(role) _openclaw_message_role ;;
				(channel) _openclaw_message_channel ;;
				(member) _openclaw_message_member ;;
				(voice) _openclaw_message_voice ;;
				(event) _openclaw_message_event ;;
				(timeout) _openclaw_message_timeout ;;
				(kick) _openclaw_message_kick ;;
				(ban) _openclaw_message_ban ;;
			esac ;;
	esac
}
_openclaw_message_ban () {
	_arguments -C "--guild-id[Guild id]" "--user-id[User id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]" "--reason[Moderation reason]" "--delete-days[Ban delete message days]"
}
_openclaw_message_broadcast () {
	_arguments -C "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]" "--targets[Recipient/channel targets (same format as --target); accepts ids or names when the directory is available.]" "--message[Message to send]" "--media[Media URL]"
}
_openclaw_message_channel () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'info[Fetch channel info]' 'list[List channels]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(info) _openclaw_message_channel_info ;;
				(list) _openclaw_message_channel_list ;;
			esac ;;
	esac
}
_openclaw_message_channel_info () {
	_arguments -C "(--target -t)"{--target,-t}"[Recipient/channel: E.164 for WhatsApp/Signal, Telegram chat id/@username, Discord/Slack channel/user, or iMessage handle/chat_id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]"
}
_openclaw_message_channel_list () {
	_arguments -C "--guild-id[Guild id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]"
}
_openclaw_message_delete () {
	_arguments -C "--message-id[Message id]" "(--target -t)"{--target,-t}"[Recipient/channel: E.164 for WhatsApp/Signal, Telegram chat id/@username, Discord/Slack channel/user, or iMessage handle/chat_id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]"
}
_openclaw_message_edit () {
	_arguments -C "--message-id[Message id]" "(--message -m)"{--message,-m}"[Message body]" "(--target -t)"{--target,-t}"[Recipient/channel: E.164 for WhatsApp/Signal, Telegram chat id/@username, Discord/Slack channel/user, or iMessage handle/chat_id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]" "--thread-id[Thread id (Telegram forum thread)]"
}
_openclaw_message_emoji () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'list[List emojis]' 'upload[Upload an emoji]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(list) _openclaw_message_emoji_list ;;
				(upload) _openclaw_message_emoji_upload ;;
			esac ;;
	esac
}
_openclaw_message_emoji_list () {
	_arguments -C "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]" "--guild-id[Guild id (Discord)]"
}
_openclaw_message_emoji_upload () {
	_arguments -C "--guild-id[Guild id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]" "--emoji-name[Emoji name]" "--media[Emoji media (path or URL)]" "--role-ids[Role id (repeat)]"
}
_openclaw_message_event () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'list[List scheduled events]' 'create[Create a scheduled event]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(list) _openclaw_message_event_list ;;
				(create) _openclaw_message_event_create ;;
			esac ;;
	esac
}
_openclaw_message_event_create () {
	_arguments -C "--guild-id[Guild id]" "--event-name[Event name]" "--start-time[Event start time]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]" "--end-time[Event end time]" "--desc[Event description]" "--channel-id[Channel id]" "--location[Event location]" "--event-type[Event type]"
}
_openclaw_message_event_list () {
	_arguments -C "--guild-id[Guild id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]"
}
_openclaw_message_kick () {
	_arguments -C "--guild-id[Guild id]" "--user-id[User id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]" "--reason[Moderation reason]"
}
_openclaw_message_member () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'info[Fetch member info]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(info) _openclaw_message_member_info ;;
			esac ;;
	esac
}
_openclaw_message_member_info () {
	_arguments -C "--user-id[User id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]" "--guild-id[Guild id (Discord)]"
}
_openclaw_message_permissions () {
	_arguments -C "(--target -t)"{--target,-t}"[Recipient/channel: E.164 for WhatsApp/Signal, Telegram chat id/@username, Discord/Slack channel/user, or iMessage handle/chat_id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]"
}
_openclaw_message_pin () {
	_arguments -C "(--target -t)"{--target,-t}"[Recipient/channel: E.164 for WhatsApp/Signal, Telegram chat id/@username, Discord/Slack channel/user, or iMessage handle/chat_id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]" "--message-id[Message id]"
}
_openclaw_message_pins () {
	_arguments -C "(--target -t)"{--target,-t}"[Recipient/channel: E.164 for WhatsApp/Signal, Telegram chat id/@username, Discord/Slack channel/user, or iMessage handle/chat_id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]" "--limit[Result limit]"
}
_openclaw_message_poll () {
	_arguments -C "(--target -t)"{--target,-t}"[Recipient/channel: E.164 for WhatsApp/Signal, Telegram chat id/@username, Discord/Slack channel/user, or iMessage handle/chat_id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]" "--poll-question[Poll question]" "--poll-option[Poll option (repeat 2-12 times)]" "--poll-multi[Allow multiple selections]" "--poll-duration-hours[Poll duration in hours (Discord)]" "--poll-duration-seconds[Poll duration in seconds (Telegram; 5-600)]" "--poll-anonymous[Send an anonymous poll (Telegram)]" "--poll-public[Send a non-anonymous poll (Telegram)]" "(--message -m)"{--message,-m}"[Optional message body]" "--silent[Send poll silently without notification (Telegram + Discord where supported)]" "--thread-id[Thread id (Telegram forum topic / Slack thread ts)]"
}
_openclaw_message_react () {
	_arguments -C "(--target -t)"{--target,-t}"[Recipient/channel: E.164 for WhatsApp/Signal, Telegram chat id/@username, Discord/Slack channel/user, or iMessage handle/chat_id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]" "--message-id[Message id]" "--emoji[Emoji for reactions]" "--remove[Remove reaction]" "--participant[WhatsApp reaction participant]" "--from-me[WhatsApp reaction fromMe]" "--target-author[Signal reaction target author (uuid or phone)]" "--target-author-uuid[Signal reaction target author uuid]"
}
_openclaw_message_reactions () {
	_arguments -C "(--target -t)"{--target,-t}"[Recipient/channel: E.164 for WhatsApp/Signal, Telegram chat id/@username, Discord/Slack channel/user, or iMessage handle/chat_id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]" "--message-id[Message id]" "--limit[Result limit]"
}
_openclaw_message_read () {
	_arguments -C "(--target -t)"{--target,-t}"[Recipient/channel: E.164 for WhatsApp/Signal, Telegram chat id/@username, Discord/Slack channel/user, or iMessage handle/chat_id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]" "--limit[Result limit]" "--before[Read/search before id]" "--after[Read/search after id]" "--around[Read around id]" "--include-thread[Include thread replies (Discord)]"
}
_openclaw_message_role () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'info[List roles]' 'add[Add role to a member]' 'remove[Remove role from a member]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(info) _openclaw_message_role_info ;;
				(add) _openclaw_message_role_add ;;
				(remove) _openclaw_message_role_remove ;;
			esac ;;
	esac
}
_openclaw_message_role_add () {
	_arguments -C "--guild-id[Guild id]" "--user-id[User id]" "--role-id[Role id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]"
}
_openclaw_message_role_info () {
	_arguments -C "--guild-id[Guild id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]"
}
_openclaw_message_role_remove () {
	_arguments -C "--guild-id[Guild id]" "--user-id[User id]" "--role-id[Role id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]"
}
_openclaw_message_search () {
	_arguments -C "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]" "--guild-id[Guild id]" "--query[Search query]" "--channel-id[Channel id]" "--channel-ids[Channel id (repeat)]" "--author-id[Author id]" "--author-ids[Author id (repeat)]" "--limit[Result limit]"
}
_openclaw_message_send () {
	_arguments -C "(--message -m)"{--message,-m}"[Message body (required unless --media is set)]" "(--target -t)"{--target,-t}"[Recipient/channel: E.164 for WhatsApp/Signal, Telegram chat id/@username, Discord/Slack channel/user, or iMessage handle/chat_id]" "--media[Attach media (image/audio/video/document). Accepts local paths or URLs.]" "--buttons[Telegram inline keyboard buttons as JSON (array of button rows)]" "--components[Discord components payload as JSON]" "--card[Adaptive Card JSON object (when supported by the channel)]" "--reply-to[Reply-to message id]" "--thread-id[Thread id (Telegram forum thread)]" "--gif-playback[Treat video media as GIF playback (WhatsApp only).]" "--silent[Send message silently without notification (Telegram + Discord)]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]"
}
_openclaw_message_sticker () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'send[Send stickers]' 'upload[Upload a sticker]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(send) _openclaw_message_sticker_send ;;
				(upload) _openclaw_message_sticker_upload ;;
			esac ;;
	esac
}
_openclaw_message_sticker_send () {
	_arguments -C "(--target -t)"{--target,-t}"[Recipient/channel: E.164 for WhatsApp/Signal, Telegram chat id/@username, Discord/Slack channel/user, or iMessage handle/chat_id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]" "--sticker-id[Sticker id (repeat)]" "(--message -m)"{--message,-m}"[Optional message body]"
}
_openclaw_message_sticker_upload () {
	_arguments -C "--guild-id[Guild id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]" "--sticker-name[Sticker name]" "--sticker-desc[Sticker description]" "--sticker-tags[Sticker tags]" "--media[Sticker media (path or URL)]"
}
_openclaw_message_thread () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'create[Create a thread]' 'list[List threads]' 'reply[Reply in a thread]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(create) _openclaw_message_thread_create ;;
				(list) _openclaw_message_thread_list ;;
				(reply) _openclaw_message_thread_reply ;;
			esac ;;
	esac
}
_openclaw_message_thread_create () {
	_arguments -C "--thread-name[Thread name]" "(--target -t)"{--target,-t}"[Recipient/channel: E.164 for WhatsApp/Signal, Telegram chat id/@username, Discord/Slack channel/user, or iMessage handle/chat_id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]" "--message-id[Message id (optional)]" "(--message -m)"{--message,-m}"[Initial thread message text]" "--auto-archive-min[Thread auto-archive minutes]"
}
_openclaw_message_thread_list () {
	_arguments -C "--guild-id[Guild id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]" "--channel-id[Channel id]" "--include-archived[Include archived threads]" "--before[Read/search before id]" "--limit[Result limit]"
}
_openclaw_message_thread_reply () {
	_arguments -C "(--message -m)"{--message,-m}"[Message body]" "(--target -t)"{--target,-t}"[Recipient/channel: E.164 for WhatsApp/Signal, Telegram chat id/@username, Discord/Slack channel/user, or iMessage handle/chat_id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]" "--media[Attach media (image/audio/video/document). Accepts local paths or URLs.]" "--reply-to[Reply-to message id]"
}
_openclaw_message_timeout () {
	_arguments -C "--guild-id[Guild id]" "--user-id[User id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]" "--duration-min[Timeout duration minutes]" "--until[Timeout until]" "--reason[Moderation reason]"
}
_openclaw_message_unpin () {
	_arguments -C "(--target -t)"{--target,-t}"[Recipient/channel: E.164 for WhatsApp/Signal, Telegram chat id/@username, Discord/Slack channel/user, or iMessage handle/chat_id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]" "--message-id[Message id]"
}
_openclaw_message_voice () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'status[Fetch voice status]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(status) _openclaw_message_voice_status ;;
			esac ;;
	esac
}
_openclaw_message_voice_status () {
	_arguments -C "--guild-id[Guild id]" "--user-id[User id]" "--channel[Channel: telegram|whatsapp|discord|irc|googlechat|slack|signal|imessage|line|feishu|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|zalo|zalouser|synology-chat|tlon]" "--account[Channel account id (accountId)]" "--json[Output result as JSON]" "--dry-run[Print payload and skip sending]" "--verbose[Verbose logging]"
}
_openclaw_models () {
	local -a commands
	local -a options
	_arguments -C "--status-json[Output JSON (alias for `models status --json`)]" "--status-plain[Plain output (alias for `models status --plain`)]" "--agent[Agent id to inspect (overrides OPENCLAW_AGENT_DIR/PI_CODING_AGENT_DIR)]" "1: :_values 'command' 'list[List models (configured by default)]' 'status[Show configured model state]' 'set[Set the default model]' 'set-image[Set the image model]' 'aliases[Manage model aliases]' 'fallbacks[Manage model fallback list]' 'image-fallbacks[Manage image model fallback list]' 'scan[Scan OpenRouter free models for tools + images]' 'auth[Manage model auth profiles]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(list) _openclaw_models_list ;;
				(status) _openclaw_models_status ;;
				(set) _openclaw_models_set ;;
				(set-image) _openclaw_models_set_image ;;
				(aliases) _openclaw_models_aliases ;;
				(fallbacks) _openclaw_models_fallbacks ;;
				(image-fallbacks) _openclaw_models_image_fallbacks ;;
				(scan) _openclaw_models_scan ;;
				(auth) _openclaw_models_auth ;;
			esac ;;
	esac
}
_openclaw_models_aliases () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'list[List model aliases]' 'add[Add or update a model alias]' 'remove[Remove a model alias]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(list) _openclaw_models_aliases_list ;;
				(add) _openclaw_models_aliases_add ;;
				(remove) _openclaw_models_aliases_remove ;;
			esac ;;
	esac
}
_openclaw_models_aliases_add () {
	_arguments -C
}
_openclaw_models_aliases_list () {
	_arguments -C "--json[Output JSON]" "--plain[Plain output]"
}
_openclaw_models_aliases_remove () {
	_arguments -C
}
_openclaw_models_auth () {
	local -a commands
	local -a options
	_arguments -C "--agent[Agent id for auth order get/set/clear]" "1: :_values 'command' 'add[Interactive auth helper (setup-token or paste token)]' 'login[Run a provider plugin auth flow (OAuth/API key)]' 'setup-token[Run a provider CLI to create/sync a token (TTY required)]' 'paste-token[Paste a token into auth-profiles.json and update config]' 'login-github-copilot[Login to GitHub Copilot via GitHub device flow (TTY required)]' 'order[Manage per-agent auth profile order overrides]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(add) _openclaw_models_auth_add ;;
				(login) _openclaw_models_auth_login ;;
				(setup-token) _openclaw_models_auth_setup_token ;;
				(paste-token) _openclaw_models_auth_paste_token ;;
				(login-github-copilot) _openclaw_models_auth_login_github_copilot ;;
				(order) _openclaw_models_auth_order ;;
			esac ;;
	esac
}
_openclaw_models_auth_add () {
	_arguments -C
}
_openclaw_models_auth_login () {
	_arguments -C "--provider[Provider id registered by a plugin]" "--method[Provider auth method id]" "--set-default[Apply the provider'\''s default model recommendation]"
}
_openclaw_models_auth_login_github_copilot () {
	_arguments -C "--profile-id[Auth profile id (default: github-copilot:github)]" "--yes[Overwrite existing profile without prompting]"
}
_openclaw_models_auth_order () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'get[Show per-agent auth order override (from auth-profiles.json)]' 'set[Set per-agent auth order override (locks rotation to this list)]' 'clear[Clear per-agent auth order override (fall back to config/round-robin)]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(get) _openclaw_models_auth_order_get ;;
				(set) _openclaw_models_auth_order_set ;;
				(clear) _openclaw_models_auth_order_clear ;;
			esac ;;
	esac
}
_openclaw_models_auth_order_clear () {
	_arguments -C "--provider[Provider id (e.g. anthropic)]" "--agent[Agent id (default: configured default agent)]"
}
_openclaw_models_auth_order_get () {
	_arguments -C "--provider[Provider id (e.g. anthropic)]" "--agent[Agent id (default: configured default agent)]" "--json[Output JSON]"
}
_openclaw_models_auth_order_set () {
	_arguments -C "--provider[Provider id (e.g. anthropic)]" "--agent[Agent id (default: configured default agent)]"
}
_openclaw_models_auth_paste_token () {
	_arguments -C "--provider[Provider id (e.g. anthropic)]" "--profile-id[Auth profile id (default: <provider>:manual)]" "--expires-in[Optional expiry duration (e.g. 365d, 12h). Stored as absolute expiresAt.]"
}
_openclaw_models_auth_setup_token () {
	_arguments -C "--provider[Provider id (default: anthropic)]" "--yes[Skip confirmation]"
}
_openclaw_models_fallbacks () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'list[List fallback models]' 'add[Add a fallback model]' 'remove[Remove a fallback model]' 'clear[Clear all fallback models]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(list) _openclaw_models_fallbacks_list ;;
				(add) _openclaw_models_fallbacks_add ;;
				(remove) _openclaw_models_fallbacks_remove ;;
				(clear) _openclaw_models_fallbacks_clear ;;
			esac ;;
	esac
}
_openclaw_models_fallbacks_add () {
	_arguments -C
}
_openclaw_models_fallbacks_clear () {
	_arguments -C
}
_openclaw_models_fallbacks_list () {
	_arguments -C "--json[Output JSON]" "--plain[Plain output]"
}
_openclaw_models_fallbacks_remove () {
	_arguments -C
}
_openclaw_models_image_fallbacks () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'list[List image fallback models]' 'add[Add an image fallback model]' 'remove[Remove an image fallback model]' 'clear[Clear all image fallback models]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(list) _openclaw_models_image_fallbacks_list ;;
				(add) _openclaw_models_image_fallbacks_add ;;
				(remove) _openclaw_models_image_fallbacks_remove ;;
				(clear) _openclaw_models_image_fallbacks_clear ;;
			esac ;;
	esac
}
_openclaw_models_image_fallbacks_add () {
	_arguments -C
}
_openclaw_models_image_fallbacks_clear () {
	_arguments -C
}
_openclaw_models_image_fallbacks_list () {
	_arguments -C "--json[Output JSON]" "--plain[Plain output]"
}
_openclaw_models_image_fallbacks_remove () {
	_arguments -C
}
_openclaw_models_list () {
	_arguments -C "--all[Show full model catalog]" "--local[Filter to local models]" "--provider[Filter by provider]" "--json[Output JSON]" "--plain[Plain line output]"
}
_openclaw_models_scan () {
	_arguments -C "--min-params[Minimum parameter size (billions)]" "--max-age-days[Skip models older than N days]" "--provider[Filter by provider prefix]" "--max-candidates[Max fallback candidates]" "--timeout[Per-probe timeout in ms]" "--concurrency[Probe concurrency]" "--no-probe[Skip live probes; list free candidates only]" "--yes[Accept defaults without prompting]" "--no-input[Disable prompts (use defaults)]" "--set-default[Set agents.defaults.model to the first selection]" "--set-image[Set agents.defaults.imageModel to the first image selection]" "--json[Output JSON]"
}
_openclaw_models_set () {
	_arguments -C
}
_openclaw_models_set_image () {
	_arguments -C
}
_openclaw_models_status () {
	_arguments -C "--json[Output JSON]" "--plain[Plain output]" "--check[Exit non-zero if auth is expiring/expired (1=expired/missing, 2=expiring)]" "--probe[Probe configured provider auth (live)]" "--probe-provider[Only probe a single provider]" "--probe-profile[Only probe specific auth profile ids (repeat or comma-separated)]" "--probe-timeout[Per-probe timeout in ms]" "--probe-concurrency[Concurrent probes]" "--probe-max-tokens[Probe max tokens (best-effort)]" "--agent[Agent id to inspect (overrides OPENCLAW_AGENT_DIR/PI_CODING_AGENT_DIR)]"
}
_openclaw_node () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'run[Run the headless node host (foreground)]' 'status[Show node host status]' 'install[Install the node host service (launchd/systemd/schtasks)]' 'uninstall[Uninstall the node host service (launchd/systemd/schtasks)]' 'stop[Stop the node host service (launchd/systemd/schtasks)]' 'restart[Restart the node host service (launchd/systemd/schtasks)]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(run) _openclaw_node_run ;;
				(status) _openclaw_node_status ;;
				(install) _openclaw_node_install ;;
				(uninstall) _openclaw_node_uninstall ;;
				(stop) _openclaw_node_stop ;;
				(restart) _openclaw_node_restart ;;
			esac ;;
	esac
}
_openclaw_node_install () {
	_arguments -C "--host[Gateway host]" "--port[Gateway port]" "--tls[Use TLS for the gateway connection]" "--tls-fingerprint[Expected TLS certificate fingerprint (sha256)]" "--node-id[Override node id (clears pairing token)]" "--display-name[Override node display name]" "--runtime[Service runtime (node|bun). Default: node]" "--force[Reinstall/overwrite if already installed]" "--json[Output JSON]"
}
_openclaw_node_restart () {
	_arguments -C "--json[Output JSON]"
}
_openclaw_node_run () {
	_arguments -C "--host[Gateway host]" "--port[Gateway port]" "--tls[Use TLS for the gateway connection]" "--tls-fingerprint[Expected TLS certificate fingerprint (sha256)]" "--node-id[Override node id (clears pairing token)]" "--display-name[Override node display name]"
}
_openclaw_node_status () {
	_arguments -C "--json[Output JSON]"
}
_openclaw_node_stop () {
	_arguments -C "--json[Output JSON]"
}
_openclaw_node_uninstall () {
	_arguments -C "--json[Output JSON]"
}
_openclaw_nodes () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'status[List known nodes with connection status and capabilities]' 'describe[Describe a node (capabilities + supported invoke commands)]' 'list[List pending and paired nodes]' 'pending[List pending pairing requests]' 'approve[Approve a pending pairing request]' 'reject[Reject a pending pairing request]' 'rename[Rename a paired node (display name override)]' 'invoke[Invoke a command on a paired node]' 'run[Run a shell command on a node (mac only)]' 'notify[Send a local notification on a node (mac only)]' 'push[Send an APNs test push to an iOS node]' 'canvas[Capture or render canvas content from a paired node]' 'camera[Capture camera media from a paired node]' 'screen[Capture screen recordings from a paired node]' 'location[Fetch location from a paired node]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(status) _openclaw_nodes_status ;;
				(describe) _openclaw_nodes_describe ;;
				(list) _openclaw_nodes_list ;;
				(pending) _openclaw_nodes_pending ;;
				(approve) _openclaw_nodes_approve ;;
				(reject) _openclaw_nodes_reject ;;
				(rename) _openclaw_nodes_rename ;;
				(invoke) _openclaw_nodes_invoke ;;
				(run) _openclaw_nodes_run ;;
				(notify) _openclaw_nodes_notify ;;
				(push) _openclaw_nodes_push ;;
				(canvas) _openclaw_nodes_canvas ;;
				(camera) _openclaw_nodes_camera ;;
				(screen) _openclaw_nodes_screen ;;
				(location) _openclaw_nodes_location ;;
			esac ;;
	esac
}
_openclaw_nodes_approve () {
	_arguments -C "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_nodes_camera () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'list[List available cameras on a node]' 'snap[Capture a photo from a node camera (prints MEDIA:<path>)]' 'clip[Capture a short video clip from a node camera (prints MEDIA:<path>)]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(list) _openclaw_nodes_camera_list ;;
				(snap) _openclaw_nodes_camera_snap ;;
				(clip) _openclaw_nodes_camera_clip ;;
			esac ;;
	esac
}
_openclaw_nodes_camera_clip () {
	_arguments -C "--node[Node id, name, or IP]" "--facing[Camera facing]" "--device-id[Camera device id (from nodes camera list)]" "--duration[Duration (default 3000ms; supports ms/s/m, e.g. 10s)]" "--no-audio[Disable audio capture]" "--invoke-timeout[Node invoke timeout in ms (default 90000)]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_nodes_camera_list () {
	_arguments -C "--node[Node id, name, or IP]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_nodes_camera_snap () {
	_arguments -C "--node[Node id, name, or IP]" "--facing[Camera facing]" "--device-id[Camera device id (from nodes camera list)]" "--max-width[Max width in px (optional)]" "--quality[JPEG quality (default 0.9)]" "--delay-ms[Delay before capture in ms (macOS default 2000)]" "--invoke-timeout[Node invoke timeout in ms (default 20000)]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_nodes_canvas () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'snapshot[Capture a canvas snapshot (prints MEDIA:<path>)]' 'present[Show the canvas (optionally with a target URL/path)]' 'hide[Hide the canvas]' 'navigate[Navigate the canvas to a URL]' 'eval[Evaluate JavaScript in the canvas]' 'a2ui[Render A2UI content on the canvas]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(snapshot) _openclaw_nodes_canvas_snapshot ;;
				(present) _openclaw_nodes_canvas_present ;;
				(hide) _openclaw_nodes_canvas_hide ;;
				(navigate) _openclaw_nodes_canvas_navigate ;;
				(eval) _openclaw_nodes_canvas_eval ;;
				(a2ui) _openclaw_nodes_canvas_a2ui ;;
			esac ;;
	esac
}
_openclaw_nodes_canvas_a2ui () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'push[Push A2UI JSONL to the canvas]' 'reset[Reset A2UI renderer state]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(push) _openclaw_nodes_canvas_a2ui_push ;;
				(reset) _openclaw_nodes_canvas_a2ui_reset ;;
			esac ;;
	esac
}
_openclaw_nodes_canvas_a2ui_push () {
	_arguments -C "--jsonl[Path to JSONL payload]" "--text[Render a quick A2UI text payload]" "--node[Node id, name, or IP]" "--invoke-timeout[Node invoke timeout in ms]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_nodes_canvas_a2ui_reset () {
	_arguments -C "--node[Node id, name, or IP]" "--invoke-timeout[Node invoke timeout in ms]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_nodes_canvas_eval () {
	_arguments -C "--js[JavaScript to evaluate]" "--node[Node id, name, or IP]" "--invoke-timeout[Node invoke timeout in ms]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_nodes_canvas_hide () {
	_arguments -C "--node[Node id, name, or IP]" "--invoke-timeout[Node invoke timeout in ms]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_nodes_canvas_navigate () {
	_arguments -C "--node[Node id, name, or IP]" "--invoke-timeout[Node invoke timeout in ms]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_nodes_canvas_present () {
	_arguments -C "--node[Node id, name, or IP]" "--target[Target URL/path (optional)]" "--x[Placement x coordinate]" "--y[Placement y coordinate]" "--width[Placement width]" "--height[Placement height]" "--invoke-timeout[Node invoke timeout in ms]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_nodes_canvas_snapshot () {
	_arguments -C "--node[Node id, name, or IP]" "--format[Image format]" "--max-width[Max width in px (optional)]" "--quality[JPEG quality (optional)]" "--invoke-timeout[Node invoke timeout in ms (default 20000)]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_nodes_describe () {
	_arguments -C "--node[Node id, name, or IP]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_nodes_invoke () {
	_arguments -C "--node[Node id, name, or IP]" "--command[Command (e.g. canvas.eval)]" "--params[JSON object string for params]" "--invoke-timeout[Node invoke timeout in ms (default 15000)]" "--idempotency-key[Idempotency key (optional)]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_nodes_list () {
	_arguments -C "--connected[Only show connected nodes]" "--last-connected[Only show nodes connected within duration (e.g. 24h)]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_nodes_location () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'get[Fetch the current location from a node]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(get) _openclaw_nodes_location_get ;;
			esac ;;
	esac
}
_openclaw_nodes_location_get () {
	_arguments -C "--node[Node id, name, or IP]" "--max-age[Use cached location newer than this (ms)]" "--accuracy[Desired accuracy (default: balanced/precise depending on node setting)]" "--location-timeout[Location fix timeout (ms)]" "--invoke-timeout[Node invoke timeout in ms (default 20000)]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_nodes_notify () {
	_arguments -C "--node[Node id, name, or IP]" "--title[Notification title]" "--body[Notification body]" "--sound[Notification sound]" "--priority[Notification priority]" "--delivery[Delivery mode]" "--invoke-timeout[Node invoke timeout in ms (default 15000)]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_nodes_pending () {
	_arguments -C "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_nodes_push () {
	_arguments -C "--node[Node id, name, or IP]" "--title[Push title]" "--body[Push body]" "--environment[Override APNs environment]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_nodes_reject () {
	_arguments -C "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_nodes_rename () {
	_arguments -C "--node[Node id, name, or IP]" "--name[New display name]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_nodes_run () {
	_arguments -C "--node[Node id, name, or IP]" "--cwd[Working directory]" "--env[Environment override (repeatable)]" "--raw[Run a raw shell command string (sh -lc / cmd.exe /c)]" "--agent[Agent id (default: configured default agent)]" "--ask[Exec ask mode (off|on-miss|always)]" "--security[Exec security mode (deny|allowlist|full)]" "--command-timeout[Command timeout (ms)]" "--needs-screen-recording[Require screen recording permission]" "--invoke-timeout[Node invoke timeout in ms (default 30000)]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_nodes_screen () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'record[Capture a short screen recording from a node (prints MEDIA:<path>)]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(record) _openclaw_nodes_screen_record ;;
			esac ;;
	esac
}
_openclaw_nodes_screen_record () {
	_arguments -C "--node[Node id, name, or IP]" "--screen[Screen index (0 = primary)]" "--duration[Clip duration (ms or 10s)]" "--fps[Frames per second]" "--no-audio[Disable microphone audio capture]" "--out[Output path]" "--invoke-timeout[Node invoke timeout in ms (default 120000)]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_nodes_status () {
	_arguments -C "--connected[Only show connected nodes]" "--last-connected[Only show nodes connected within duration (e.g. 24h)]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--json[Output JSON]"
}
_openclaw_onboard () {
	_arguments -C "--workspace[Agent workspace directory (default: ~/.openclaw/workspace)]" "--reset[Reset config + credentials + sessions before running wizard (workspace only with --reset-scope full)]" "--reset-scope[Reset scope: config|config+creds+sessions|full]" "--non-interactive[Run without prompts]" "--accept-risk[Acknowledge that agents are powerful and full system access is risky (required for --non-interactive)]" "--flow[Wizard flow: quickstart|advanced|manual]" "--mode[Wizard mode: local|remote]" "--auth-choice[Auth: token|openai-codex|chutes|apiKey|openai-api-key|mistral-api-key|openrouter-api-key|kilocode-api-key|ai-gateway-api-key|cloudflare-ai-gateway-api-key|moonshot-api-key|kimi-code-api-key|gemini-api-key|zai-api-key|xiaomi-api-key|minimax-global-api|synthetic-api-key|venice-api-key|together-api-key|huggingface-api-key|opencode-zen|opencode-go|xai-api-key|litellm-api-key|qianfan-api-key|modelstudio-api-key-cn|modelstudio-api-key|volcengine-api-key|byteplus-api-key|moonshot-api-key-cn|github-copilot|gemini-api-key|google-gemini-cli|zai-api-key|zai-coding-global|zai-coding-cn|zai-global|zai-cn|xiaomi-api-key|minimax-global-oauth|minimax-global-api|minimax-cn-oauth|minimax-cn-api|qwen-portal|copilot-proxy|apiKey|opencode-zen|qianfan-api-key|modelstudio-api-key-cn|modelstudio-api-key|custom-api-key|ollama|sglang|vllm|skip|setup-token|oauth|claude-cli|codex-cli]" "--token-provider[Token provider id (non-interactive; used with --auth-choice token)]" "--token[Token value (non-interactive; used with --auth-choice token)]" "--token-profile-id[Auth profile id (non-interactive; default: <provider>:manual)]" "--token-expires-in[Optional token expiry duration (e.g. 365d, 12h)]" "--secret-input-mode[API key persistence mode: plaintext|ref (default: plaintext)]" "--cloudflare-ai-gateway-account-id[Cloudflare Account ID]" "--cloudflare-ai-gateway-gateway-id[Cloudflare AI Gateway ID]" "--anthropic-api-key[Anthropic API key]" "--openai-api-key[OpenAI API key]" "--mistral-api-key[Mistral API key]" "--openrouter-api-key[OpenRouter API key]" "--kilocode-api-key[Kilo Gateway API key]" "--ai-gateway-api-key[Vercel AI Gateway API key]" "--cloudflare-ai-gateway-api-key[Cloudflare AI Gateway API key]" "--moonshot-api-key[Moonshot API key]" "--kimi-code-api-key[Kimi Coding API key]" "--gemini-api-key[Gemini API key]" "--zai-api-key[Z.AI API key]" "--xiaomi-api-key[Xiaomi API key]" "--minimax-api-key[MiniMax API key]" "--synthetic-api-key[Synthetic API key]" "--venice-api-key[Venice API key]" "--together-api-key[Together AI API key]" "--huggingface-api-key[Hugging Face API key (HF token)]" "--opencode-zen-api-key[OpenCode API key (Zen catalog)]" "--opencode-go-api-key[OpenCode API key (Go catalog)]" "--xai-api-key[xAI API key]" "--litellm-api-key[LiteLLM API key]" "--qianfan-api-key[QIANFAN API key]" "--modelstudio-api-key-cn[Alibaba Cloud Model Studio Coding Plan API key (China)]" "--modelstudio-api-key[Alibaba Cloud Model Studio Coding Plan API key (Global/Intl)]" "--volcengine-api-key[Volcano Engine API key]" "--byteplus-api-key[BytePlus API key]" "--custom-base-url[Custom provider base URL]" "--custom-api-key[Custom provider API key (optional)]" "--custom-model-id[Custom provider model ID]" "--custom-provider-id[Custom provider ID (optional; auto-derived by default)]" "--custom-compatibility[Custom provider API compatibility: openai|anthropic (default: openai)]" "--gateway-port[Gateway port]" "--gateway-bind[Gateway bind: loopback|tailnet|lan|auto|custom]" "--gateway-auth[Gateway auth: token|password]" "--gateway-token[Gateway token (token auth)]" "--gateway-token-ref-env[Gateway token SecretRef env var name (token auth; e.g. OPENCLAW_GATEWAY_TOKEN)]" "--gateway-password[Gateway password (password auth)]" "--remote-url[Remote Gateway WebSocket URL]" "--remote-token[Remote Gateway token (optional)]" "--tailscale[Tailscale: off|serve|funnel]" "--tailscale-reset-on-exit[Reset tailscale serve/funnel on exit]" "--install-daemon[Install gateway service]" "--no-install-daemon[Skip gateway service install]" "--skip-daemon[Skip gateway service install]" "--daemon-runtime[Daemon runtime: node|bun]" "--skip-channels[Skip channel setup]" "--skip-skills[Skip skills setup]" "--skip-search[Skip search provider setup]" "--skip-health[Skip health check]" "--skip-ui[Skip Control UI/TUI prompts]" "--node-manager[Node manager for skills: npm|pnpm|bun]" "--json[Output JSON summary]"
}
_openclaw_pairing () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'list[List pending pairing requests]' 'approve[Approve a pairing code and allow that sender]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(list) _openclaw_pairing_list ;;
				(approve) _openclaw_pairing_approve ;;
			esac ;;
	esac
}
_openclaw_pairing_approve () {
	_arguments -C "--channel[Channel (telegram)]" "--account[Account id (for multi-account channels)]" "--notify[Notify the requester on the same channel]"
}
_openclaw_pairing_list () {
	_arguments -C "--channel[Channel (telegram)]" "--account[Account id (for multi-account channels)]" "--json[Print JSON]"
}
_openclaw_plugins () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'list[List discovered plugins]' 'info[Show plugin details]' 'enable[Enable a plugin in config]' 'disable[Disable a plugin in config]' 'uninstall[Uninstall a plugin]' 'install[Install a plugin (path, archive, or npm spec)]' 'update[Update installed plugins (npm installs only)]' 'doctor[Report plugin load issues]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(list) _openclaw_plugins_list ;;
				(info) _openclaw_plugins_info ;;
				(enable) _openclaw_plugins_enable ;;
				(disable) _openclaw_plugins_disable ;;
				(uninstall) _openclaw_plugins_uninstall ;;
				(install) _openclaw_plugins_install ;;
				(update) _openclaw_plugins_update ;;
				(doctor) _openclaw_plugins_doctor ;;
			esac ;;
	esac
}
_openclaw_plugins_disable () {
	_arguments -C
}
_openclaw_plugins_doctor () {
	_arguments -C
}
_openclaw_plugins_enable () {
	_arguments -C
}
_openclaw_plugins_info () {
	_arguments -C "--json[Print JSON]"
}
_openclaw_plugins_install () {
	_arguments -C "(--link -l)"{--link,-l}"[Link a local path instead of copying]" "--pin[Record npm installs as exact resolved <name>@<version>]"
}
_openclaw_plugins_list () {
	_arguments -C "--json[Print JSON]" "--enabled[Only show enabled plugins]" "--verbose[Show detailed entries]"
}
_openclaw_plugins_uninstall () {
	_arguments -C "--keep-files[Keep installed files on disk]" "--keep-config[Deprecated alias for --keep-files]" "--force[Skip confirmation prompt]" "--dry-run[Show what would be removed without making changes]"
}
_openclaw_plugins_update () {
	_arguments -C "--all[Update all tracked plugins]" "--dry-run[Show what would change without writing]"
}
_openclaw_qr () {
	_arguments -C "--remote[Use gateway.remote.url and gateway.remote token/password (ignores device-pair publicUrl)]" "--url[Override gateway URL used in the setup payload]" "--public-url[Override gateway public URL used in the setup payload]" "--token[Override gateway token for setup payload]" "--password[Override gateway password for setup payload]" "--setup-code-only[Print only the setup code]" "--no-ascii[Skip ASCII QR rendering]" "--json[Output JSON]"
}
_openclaw_reset () {
	_arguments -C "--scope[config|config+creds+sessions|full (default: interactive prompt)]" "--yes[Skip confirmation prompts]" "--non-interactive[Disable prompts (requires --scope + --yes)]" "--dry-run[Print actions without removing files]"
}
_openclaw_root_completion () {
	local -a commands
	local -a options
	_arguments -C "(--version -V)"{--version,-V}"[output the version number]" "--dev[Dev profile: isolate state under ~/.openclaw-dev, default gateway port 19001, and shift derived ports (browser/canvas)]" "--profile[Use a named profile (isolates OPENCLAW_STATE_DIR/OPENCLAW_CONFIG_PATH under ~/.openclaw-<name>)]" "--log-level[Global log level override for file + console (silent|fatal|error|warn|info|debug|trace)]" "--no-color[Disable ANSI colors]" "1: :_values 'command' 'completion[Generate shell completion script]' 'setup[Initialize ~/.openclaw/openclaw.json and the agent workspace]' 'onboard[Interactive wizard to set up the gateway, workspace, and skills]' 'configure[Interactive setup wizard for credentials, channels, gateway, and agent defaults]' 'config[Non-interactive config helpers (get/set/unset/file/validate). Run without subcommand for the setup wizard.]' 'backup[Create and verify local backup archives for OpenClaw state]' 'doctor[Health checks + quick fixes for the gateway and channels]' 'dashboard[Open the Control UI with your current token]' 'reset[Reset local config/state (keeps the CLI installed)]' 'uninstall[Uninstall the gateway service + local data (CLI remains)]' 'message[Send, read, and manage messages and channel actions]' 'memory[Search, inspect, and reindex memory files]' 'agent[Run an agent turn via the Gateway (use --local for embedded)]' 'agents[Manage isolated agents (workspaces + auth + routing)]' 'status[Show channel health and recent session recipients]' 'health[Fetch health from the running gateway]' 'sessions[List stored conversation sessions]' 'browser[Manage OpenClaw'\''s dedicated browser (Chrome/Chromium)]' 'acp[Run an ACP bridge backed by the Gateway]' 'gateway[Run, inspect, and query the WebSocket Gateway]' 'daemon[Manage the Gateway service (launchd/systemd/schtasks)]' 'logs[Tail gateway file logs via RPC]' 'system[System tools (events, heartbeat, presence)]' 'models[Model discovery, scanning, and configuration]' 'approvals[Manage exec approvals (gateway or node host)]' 'nodes[Manage gateway-owned nodes (pairing, status, invoke, and media)]' 'devices[Device pairing and auth tokens]' 'node[Run and manage the headless node host service]' 'sandbox[Manage sandbox containers (Docker-based agent isolation)]' 'tui[Open a terminal UI connected to the Gateway]' 'cron[Manage cron jobs (via Gateway)]' 'dns[DNS helpers for wide-area discovery (Tailscale + CoreDNS)]' 'docs[Search the live OpenClaw docs]' 'hooks[Manage internal agent hooks]' 'webhooks[Webhook helpers and integrations]' 'qr[Generate an iOS pairing QR code and setup code]' 'clawbot[Legacy clawbot command aliases]' 'pairing[Secure DM pairing (approve inbound requests)]' 'plugins[Manage OpenClaw plugins and extensions]' 'channels[Manage connected chat channels and accounts]' 'directory[Lookup contact and group IDs (self, peers, groups) for supported chat channels]' 'security[Audit local config and state for common security foot-guns]' 'secrets[Secrets runtime controls]' 'skills[List and inspect available skills]' 'update[Update OpenClaw and inspect update channel status]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(completion) _openclaw_completion ;;
				(setup) _openclaw_setup ;;
				(onboard) _openclaw_onboard ;;
				(configure) _openclaw_configure ;;
				(config) _openclaw_config ;;
				(backup) _openclaw_backup ;;
				(doctor) _openclaw_doctor ;;
				(dashboard) _openclaw_dashboard ;;
				(reset) _openclaw_reset ;;
				(uninstall) _openclaw_uninstall ;;
				(message) _openclaw_message ;;
				(memory) _openclaw_memory ;;
				(agent) _openclaw_agent ;;
				(agents) _openclaw_agents ;;
				(status) _openclaw_status ;;
				(health) _openclaw_health ;;
				(sessions) _openclaw_sessions ;;
				(browser) _openclaw_browser ;;
				(acp) _openclaw_acp ;;
				(gateway) _openclaw_gateway ;;
				(daemon) _openclaw_daemon ;;
				(logs) _openclaw_logs ;;
				(system) _openclaw_system ;;
				(models) _openclaw_models ;;
				(approvals) _openclaw_approvals ;;
				(nodes) _openclaw_nodes ;;
				(devices) _openclaw_devices ;;
				(node) _openclaw_node ;;
				(sandbox) _openclaw_sandbox ;;
				(tui) _openclaw_tui ;;
				(cron) _openclaw_cron ;;
				(dns) _openclaw_dns ;;
				(docs) _openclaw_docs ;;
				(hooks) _openclaw_hooks ;;
				(webhooks) _openclaw_webhooks ;;
				(qr) _openclaw_qr ;;
				(clawbot) _openclaw_clawbot ;;
				(pairing) _openclaw_pairing ;;
				(plugins) _openclaw_plugins ;;
				(channels) _openclaw_channels ;;
				(directory) _openclaw_directory ;;
				(security) _openclaw_security ;;
				(secrets) _openclaw_secrets ;;
				(skills) _openclaw_skills ;;
				(update) _openclaw_update ;;
			esac ;;
	esac
}
_openclaw_sandbox () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'list[List sandbox containers and their status]' 'recreate[Remove containers to force recreation with updated config]' 'explain[Explain effective sandbox/tool policy for a session/agent]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(list) _openclaw_sandbox_list ;;
				(recreate) _openclaw_sandbox_recreate ;;
				(explain) _openclaw_sandbox_explain ;;
			esac ;;
	esac
}
_openclaw_sandbox_explain () {
	_arguments -C "--session[Session key to inspect (defaults to agent main)]" "--agent[Agent id to inspect (defaults to derived agent)]" "--json[Output result as JSON]"
}
_openclaw_sandbox_list () {
	_arguments -C "--json[Output result as JSON]" "--browser[List browser containers only]"
}
_openclaw_sandbox_recreate () {
	_arguments -C "--all[Recreate all sandbox containers]" "--session[Recreate container for specific session]" "--agent[Recreate containers for specific agent]" "--browser[Only recreate browser containers]" "--force[Skip confirmation prompt]"
}
_openclaw_secrets () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'reload[Re-resolve secret references and atomically swap runtime snapshot]' 'audit[Audit plaintext secrets, unresolved refs, and precedence drift]' 'configure[Interactive secrets helper (provider setup + SecretRef mapping + preflight)]' 'apply[Apply a previously generated secrets plan]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(reload) _openclaw_secrets_reload ;;
				(audit) _openclaw_secrets_audit ;;
				(configure) _openclaw_secrets_configure ;;
				(apply) _openclaw_secrets_apply ;;
			esac ;;
	esac
}
_openclaw_secrets_apply () {
	_arguments -C "--from[Path to plan JSON]" "--dry-run[Validate/preflight only]" "--json[Output JSON]"
}
_openclaw_secrets_audit () {
	_arguments -C "--check[Exit non-zero when findings are present]" "--json[Output JSON]"
}
_openclaw_secrets_configure () {
	_arguments -C "--apply[Apply changes immediately after preflight]" "--yes[Skip apply confirmation prompt]" "--providers-only[Configure secrets.providers only, skip credential mapping]" "--skip-provider-setup[Skip provider setup and only map credential fields to existing providers]" "--agent[Agent id for auth-profiles targets (default: configured default agent)]" "--plan-out[Write generated plan JSON to a file]" "--json[Output JSON]"
}
_openclaw_secrets_reload () {
	_arguments -C "--json[Output JSON]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--expect-final[Wait for final response (agent)]"
}
_openclaw_security () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'audit[Audit config + local state for common security foot-guns]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(audit) _openclaw_security_audit ;;
			esac ;;
	esac
}
_openclaw_security_audit () {
	_arguments -C "--deep[Attempt live Gateway probe (best-effort)]" "--fix[Apply safe fixes (tighten defaults + chmod state/config)]" "--json[Print JSON]"
}
_openclaw_sessions () {
	local -a commands
	local -a options
	_arguments -C "--json[Output as JSON]" "--verbose[Verbose logging]" "--store[Path to session store (default: resolved from config)]" "--agent[Agent id to inspect (default: configured default agent)]" "--all-agents[Aggregate sessions across all configured agents]" "--active[Only show sessions updated within the past N minutes]" "1: :_values 'command' 'cleanup[Run session-store maintenance now]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(cleanup) _openclaw_sessions_cleanup ;;
			esac ;;
	esac
}
_openclaw_sessions_cleanup () {
	_arguments -C "--store[Path to session store (default: resolved from config)]" "--agent[Agent id to maintain (default: configured default agent)]" "--all-agents[Run maintenance across all configured agents]" "--dry-run[Preview maintenance actions without writing]" "--enforce[Apply maintenance even when configured mode is warn]" "--fix-missing[Remove store entries whose transcript files are missing (bypasses age/count retention)]" "--active-key[Protect this session key from budget-eviction]" "--json[Output JSON]"
}
_openclaw_setup () {
	_arguments -C "--workspace[Agent workspace directory (default: ~/.openclaw/workspace; stored as agents.defaults.workspace)]" "--wizard[Run the interactive onboarding wizard]" "--non-interactive[Run the wizard without prompts]" "--mode[Wizard mode: local|remote]" "--remote-url[Remote Gateway WebSocket URL]" "--remote-token[Remote Gateway token (optional)]"
}
_openclaw_skills () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'list[List all available skills]' 'info[Show detailed information about a skill]' 'check[Check which skills are ready vs missing requirements]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(list) _openclaw_skills_list ;;
				(info) _openclaw_skills_info ;;
				(check) _openclaw_skills_check ;;
			esac ;;
	esac
}
_openclaw_skills_check () {
	_arguments -C "--json[Output as JSON]"
}
_openclaw_skills_info () {
	_arguments -C "--json[Output as JSON]"
}
_openclaw_skills_list () {
	_arguments -C "--json[Output as JSON]" "--eligible[Show only eligible (ready to use) skills]" "(--verbose -v)"{--verbose,-v}"[Show more details including missing requirements]"
}
_openclaw_status () {
	_arguments -C "--json[Output JSON instead of text]" "--all[Full diagnosis (read-only, pasteable)]" "--usage[Show model provider usage/quota snapshots]" "--deep[Probe channels (WhatsApp Web + Telegram + Discord + Slack + Signal)]" "--timeout[Probe timeout in milliseconds]" "--verbose[Verbose logging]" "--debug[Alias for --verbose]"
}
_openclaw_system () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'event[Enqueue a system event and optionally trigger a heartbeat]' 'heartbeat[Heartbeat controls]' 'presence[List system presence entries]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(event) _openclaw_system_event ;;
				(heartbeat) _openclaw_system_heartbeat ;;
				(presence) _openclaw_system_presence ;;
			esac ;;
	esac
}
_openclaw_system_event () {
	_arguments -C "--text[System event text]" "--mode[Wake mode (now|next-heartbeat)]" "--json[Output JSON]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--expect-final[Wait for final response (agent)]"
}
_openclaw_system_heartbeat () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'last[Show the last heartbeat event]' 'enable[Enable heartbeats]' 'disable[Disable heartbeats]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(last) _openclaw_system_heartbeat_last ;;
				(enable) _openclaw_system_heartbeat_enable ;;
				(disable) _openclaw_system_heartbeat_disable ;;
			esac ;;
	esac
}
_openclaw_system_heartbeat_disable () {
	_arguments -C "--json[Output JSON]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--expect-final[Wait for final response (agent)]"
}
_openclaw_system_heartbeat_enable () {
	_arguments -C "--json[Output JSON]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--expect-final[Wait for final response (agent)]"
}
_openclaw_system_heartbeat_last () {
	_arguments -C "--json[Output JSON]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--expect-final[Wait for final response (agent)]"
}
_openclaw_system_presence () {
	_arguments -C "--json[Output JSON]" "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--timeout[Timeout in ms]" "--expect-final[Wait for final response (agent)]"
}
_openclaw_tui () {
	_arguments -C "--url[Gateway WebSocket URL (defaults to gateway.remote.url when configured)]" "--token[Gateway token (if required)]" "--password[Gateway password (if required)]" "--session[Session key (default: \"main\", or \"global\" when scope is global)]" "--deliver[Deliver assistant replies]" "--thinking[Thinking level override]" "--message[Send an initial message after connecting]" "--timeout-ms[Agent timeout in ms (defaults to agents.defaults.timeoutSeconds)]" "--history-limit[History entries to load]"
}
_openclaw_uninstall () {
	_arguments -C "--service[Remove the gateway service]" "--state[Remove state + config]" "--workspace[Remove workspace dirs]" "--app[Remove the macOS app]" "--all[Remove service + state + workspace + app]" "--yes[Skip confirmation prompts]" "--non-interactive[Disable prompts (requires --yes)]" "--dry-run[Print actions without removing files]"
}
_openclaw_update () {
	local -a commands
	local -a options
	_arguments -C "--json[Output result as JSON]" "--no-restart[Skip restarting the gateway service after a successful update]" "--dry-run[Preview update actions without making changes]" "--channel[Persist update channel (git + npm)]" "--tag[Override npm dist-tag or version for this update]" "--timeout[Timeout for each update step in seconds (default: 1200)]" "--yes[Skip confirmation prompts (non-interactive)]" "1: :_values 'command' 'wizard[Interactive update wizard]' 'status[Show update channel and version status]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(wizard) _openclaw_update_wizard ;;
				(status) _openclaw_update_status ;;
			esac ;;
	esac
}
_openclaw_update_status () {
	_arguments -C "--json[Output result as JSON]" "--timeout[Timeout for update checks in seconds (default: 3)]"
}
_openclaw_update_wizard () {
	_arguments -C "--timeout[Timeout for each update step in seconds (default: 1200)]"
}
_openclaw_webhooks () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'gmail[Gmail Pub/Sub hooks (via gogcli)]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(gmail) _openclaw_webhooks_gmail ;;
			esac ;;
	esac
}
_openclaw_webhooks_gmail () {
	local -a commands
	local -a options
	_arguments -C "1: :_values 'command' 'setup[Configure Gmail watch + Pub/Sub + OpenClaw hooks]' 'run[Run gog watch serve + auto-renew loop]'" "*::arg:->args"
	case $state in
		(args) case $line[1] in
				(setup) _openclaw_webhooks_gmail_setup ;;
				(run) _openclaw_webhooks_gmail_run ;;
			esac ;;
	esac
}
_openclaw_webhooks_gmail_run () {
	_arguments -C "--account[Gmail account to watch]" "--topic[Pub/Sub topic path (projects/.../topics/..)]" "--subscription[Pub/Sub subscription name]" "--label[Gmail label to watch]" "--hook-url[OpenClaw hook URL]" "--hook-token[OpenClaw hook token]" "--push-token[Push token for gog watch serve]" "--bind[gog watch serve bind host]" "--port[gog watch serve port]" "--path[gog watch serve path]" "--include-body[Include email body snippets]" "--max-bytes[Max bytes for body snippets]" "--renew-minutes[Renew watch every N minutes]" "--tailscale[Expose push endpoint via tailscale (funnel|serve|off)]" "--tailscale-path[Path for tailscale serve/funnel]" "--tailscale-target[Tailscale serve/funnel target (port, host:port, or URL)]"
}
_openclaw_webhooks_gmail_setup () {
	_arguments -C "--account[Gmail account to watch]" "--project[GCP project id (OAuth client owner)]" "--topic[Pub/Sub topic name]" "--subscription[Pub/Sub subscription name]" "--label[Gmail label to watch]" "--hook-url[OpenClaw hook URL]" "--hook-token[OpenClaw hook token]" "--push-token[Push token for gog watch serve]" "--bind[gog watch serve bind host]" "--port[gog watch serve port]" "--path[gog watch serve path]" "--include-body[Include email body snippets]" "--max-bytes[Max bytes for body snippets]" "--renew-minutes[Renew watch every N minutes]" "--tailscale[Expose push endpoint via tailscale (funnel|serve|off)]" "--tailscale-path[Path for tailscale serve/funnel]" "--tailscale-target[Tailscale serve/funnel target (port, host:port, or URL)]" "--push-endpoint[Explicit Pub/Sub push endpoint]" "--json[Output JSON summary]"
}
_openstack () {
	# undefined
	builtin autoload -XUz
}
_opkg () {
	# undefined
	builtin autoload -XUz
}
_options () {
	# undefined
	builtin autoload -XUz
}
_options_set () {
	# undefined
	builtin autoload -XUz
}
_options_unset () {
	# undefined
	builtin autoload -XUz
}
_opustools () {
	# undefined
	builtin autoload -XUz
}
_osascript () {
	# undefined
	builtin autoload -XUz
}
_osc () {
	# undefined
	builtin autoload -XUz
}
_other_accounts () {
	# undefined
	builtin autoload -XUz
}
_otool () {
	# undefined
	builtin autoload -XUz
}
_pack () {
	# undefined
	builtin autoload -XUz
}
_pandoc () {
	# undefined
	builtin autoload -XUz
}
_parameter () {
	# undefined
	builtin autoload -XUz
}
_parameters () {
	# undefined
	builtin autoload -XUz
}
_paste () {
	# undefined
	builtin autoload -XUz
}
_patch () {
	# undefined
	builtin autoload -XUz
}
_patchutils () {
	# undefined
	builtin autoload -XUz
}
_path_commands () {
	# undefined
	builtin autoload -XUz
}
_path_files () {
	# undefined
	builtin autoload -XUz
}
_pax () {
	# undefined
	builtin autoload -XUz
}
_pbcopy () {
	# undefined
	builtin autoload -XUz
}
_pbm () {
	# undefined
	builtin autoload -XUz
}
_pbuilder () {
	# undefined
	builtin autoload -XUz
}
_pdf () {
	# undefined
	builtin autoload -XUz
}
_pdftk () {
	# undefined
	builtin autoload -XUz
}
_perf () {
	# undefined
	builtin autoload -XUz
}
_perforce () {
	# undefined
	builtin autoload -XUz
}
_perl () {
	# undefined
	builtin autoload -XUz
}
_perl_basepods () {
	# undefined
	builtin autoload -XUz
}
_perl_modules () {
	# undefined
	builtin autoload -XUz
}
_perldoc () {
	# undefined
	builtin autoload -XUz
}
_pfctl () {
	# undefined
	builtin autoload -XUz
}
_pfexec () {
	# undefined
	builtin autoload -XUz
}
_pgids () {
	# undefined
	builtin autoload -XUz
}
_pgrep () {
	# undefined
	builtin autoload -XUz
}
_php () {
	# undefined
	builtin autoload -XUz
}
_physical_volumes () {
	# undefined
	builtin autoload -XUz
}
_pick_variant () {
	# undefined
	builtin autoload -XUz
}
_picocom () {
	# undefined
	builtin autoload -XUz
}
_pidof () {
	# undefined
	builtin autoload -XUz
}
_pids () {
	# undefined
	builtin autoload -XUz
}
_pine () {
	# undefined
	builtin autoload -XUz
}
_ping () {
	# undefined
	builtin autoload -XUz
}
_pip () {
	# undefined
	builtin autoload -XUz
}
_piuparts () {
	# undefined
	builtin autoload -XUz
}
_pkg-config () {
	# undefined
	builtin autoload -XUz
}
_pkg5 () {
	# undefined
	builtin autoload -XUz
}
_pkg_instance () {
	# undefined
	builtin autoload -XUz
}
_pkgadd () {
	# undefined
	builtin autoload -XUz
}
_pkgin () {
	# undefined
	builtin autoload -XUz
}
_pkginfo () {
	# undefined
	builtin autoload -XUz
}
_pkgrm () {
	# undefined
	builtin autoload -XUz
}
_pkgtool () {
	# undefined
	builtin autoload -XUz
}
_plutil () {
	# undefined
	builtin autoload -XUz
}
_pmap () {
	# undefined
	builtin autoload -XUz
}
_poetry () {
	# undefined
	builtin autoload -XUz
}
_pon () {
	# undefined
	builtin autoload -XUz
}
_portaudit () {
	# undefined
	builtin autoload -XUz
}
_portlint () {
	# undefined
	builtin autoload -XUz
}
_portmaster () {
	# undefined
	builtin autoload -XUz
}
_ports () {
	# undefined
	builtin autoload -XUz
}
_portsnap () {
	# undefined
	builtin autoload -XUz
}
_postfix () {
	# undefined
	builtin autoload -XUz
}
_postgresql () {
	# undefined
	builtin autoload -XUz
}
_postscript () {
	# undefined
	builtin autoload -XUz
}
_powerd () {
	# undefined
	builtin autoload -XUz
}
_powerprofilesctl () {
	# undefined
	builtin autoload -XUz
}
_pr () {
	# undefined
	builtin autoload -XUz
}
_precommand () {
	# undefined
	builtin autoload -XUz
}
_prefix () {
	# undefined
	builtin autoload -XUz
}
_print () {
	# undefined
	builtin autoload -XUz
}
_printenv () {
	# undefined
	builtin autoload -XUz
}
_printers () {
	# undefined
	builtin autoload -XUz
}
_process_names () {
	# undefined
	builtin autoload -XUz
}
_procstat () {
	# undefined
	builtin autoload -XUz
}
_prompt () {
	# undefined
	builtin autoload -XUz
}
_prove () {
	# undefined
	builtin autoload -XUz
}
_prstat () {
	# undefined
	builtin autoload -XUz
}
_ps () {
	# undefined
	builtin autoload -XUz
}
_ps1234 () {
	# undefined
	builtin autoload -XUz
}
_pscp () {
	# undefined
	builtin autoload -XUz
}
_pspdf () {
	# undefined
	builtin autoload -XUz
}
_psutils () {
	# undefined
	builtin autoload -XUz
}
_ptree () {
	# undefined
	builtin autoload -XUz
}
_ptx () {
	# undefined
	builtin autoload -XUz
}
_pulseaudio () {
	# undefined
	builtin autoload -XUz
}
_pump () {
	# undefined
	builtin autoload -XUz
}
_putclip () {
	# undefined
	builtin autoload -XUz
}
_pv () {
	# undefined
	builtin autoload -XUz
}
_pwgen () {
	# undefined
	builtin autoload -XUz
}
_pydoc () {
	# undefined
	builtin autoload -XUz
}
_python () {
	# undefined
	builtin autoload -XUz
}
_python_modules () {
	# undefined
	builtin autoload -XUz
}
_qdbus () {
	# undefined
	builtin autoload -XUz
}
_qemu () {
	# undefined
	builtin autoload -XUz
}
_qiv () {
	# undefined
	builtin autoload -XUz
}
_qtplay () {
	# undefined
	builtin autoload -XUz
}
_quilt () {
	# undefined
	builtin autoload -XUz
}
_rake () {
	# undefined
	builtin autoload -XUz
}
_ranlib () {
	# undefined
	builtin autoload -XUz
}
_rar () {
	# undefined
	builtin autoload -XUz
}
_rcctl () {
	# undefined
	builtin autoload -XUz
}
_rclone () {
	# undefined
	builtin autoload -XUz
}
_rcs () {
	# undefined
	builtin autoload -XUz
}
_rdesktop () {
	# undefined
	builtin autoload -XUz
}
_read () {
	# undefined
	builtin autoload -XUz
}
_read_comp () {
	# undefined
	builtin autoload -XUz
}
_readelf () {
	# undefined
	builtin autoload -XUz
}
_readlink () {
	# undefined
	builtin autoload -XUz
}
_readshortcut () {
	# undefined
	builtin autoload -XUz
}
_rebootin () {
	# undefined
	builtin autoload -XUz
}
_redirect () {
	# undefined
	builtin autoload -XUz
}
_regex_arguments () {
	# undefined
	builtin autoload -XUz
}
_regex_words () {
	# undefined
	builtin autoload -XUz
}
_remote_files () {
	# undefined
	builtin autoload -XUz
}
_renice () {
	# undefined
	builtin autoload -XUz
}
_reprepro () {
	# undefined
	builtin autoload -XUz
}
_requested () {
	# undefined
	builtin autoload -XUz
}
_resolvectl () {
	# undefined
	builtin autoload -XUz
}
_retrieve_cache () {
	# undefined
	builtin autoload -XUz
}
_retrieve_mac_apps () {
	# undefined
	builtin autoload -XUz
}
_ri () {
	# undefined
	builtin autoload -XUz
}
_rlogin () {
	# undefined
	builtin autoload -XUz
}
_rm () {
	# undefined
	builtin autoload -XUz
}
_rmdir () {
	# undefined
	builtin autoload -XUz
}
_route () {
	# undefined
	builtin autoload -XUz
}
_routing_domains () {
	# undefined
	builtin autoload -XUz
}
_routing_tables () {
	# undefined
	builtin autoload -XUz
}
_rpm () {
	# undefined
	builtin autoload -XUz
}
_rrdtool () {
	# undefined
	builtin autoload -XUz
}
_rsync () {
	# undefined
	builtin autoload -XUz
}
_rubber () {
	# undefined
	builtin autoload -XUz
}
_ruby () {
	# undefined
	builtin autoload -XUz
}
_run-help () {
	# undefined
	builtin autoload -XUz
}
_run-with-bundler () {
	if (( ! $+commands[bundle] )) || ! _within-bundled-project
	then
		"$@"
		return $?
	fi
	if [[ -f "./bin/${1}" ]]
	then
		./bin/${^^@}
	else
		bundle exec "$@"
	fi
}
_runit () {
	# undefined
	builtin autoload -XUz
}
_samba () {
	# undefined
	builtin autoload -XUz
}
_savecore () {
	# undefined
	builtin autoload -XUz
}
_say () {
	# undefined
	builtin autoload -XUz
}
_sbuild () {
	# undefined
	builtin autoload -XUz
}
_sc_usage () {
	# undefined
	builtin autoload -XUz
}
_sccs () {
	# undefined
	builtin autoload -XUz
}
_sched () {
	# undefined
	builtin autoload -XUz
}
_schedtool () {
	# undefined
	builtin autoload -XUz
}
_schroot () {
	# undefined
	builtin autoload -XUz
}
_scl () {
	# undefined
	builtin autoload -XUz
}
_scons () {
	# undefined
	builtin autoload -XUz
}
_scrcpy () {
	# undefined
	builtin autoload -XUz
}
_screen () {
	# undefined
	builtin autoload -XUz
}
_script () {
	# undefined
	builtin autoload -XUz
}
_scselect () {
	# undefined
	builtin autoload -XUz
}
_scutil () {
	# undefined
	builtin autoload -XUz
}
_sd_hosts_or_user_at_host () {
	# undefined
	builtin autoload -XUz
}
_sd_outputmodes () {
	# undefined
	builtin autoload -XUz
}
_sd_unit_files () {
	# undefined
	builtin autoload -XUz
}
_seafile () {
	# undefined
	builtin autoload -XUz
}
_sed () {
	# undefined
	builtin autoload -XUz
}
_selinux_contexts () {
	# undefined
	builtin autoload -XUz
}
_selinux_roles () {
	# undefined
	builtin autoload -XUz
}
_selinux_types () {
	# undefined
	builtin autoload -XUz
}
_selinux_users () {
	# undefined
	builtin autoload -XUz
}
_sep_parts () {
	# undefined
	builtin autoload -XUz
}
_seq () {
	# undefined
	builtin autoload -XUz
}
_sequence () {
	# undefined
	builtin autoload -XUz
}
_service () {
	# undefined
	builtin autoload -XUz
}
_services () {
	# undefined
	builtin autoload -XUz
}
_set () {
	# undefined
	builtin autoload -XUz
}
_set_command () {
	# undefined
	builtin autoload -XUz
}
_set_remove () {
	comm -23 <(echo $1 | sort | tr " " "\n") <(echo $2 | sort | tr " " "\n") 2> /dev/null
}
_setfacl () {
	# undefined
	builtin autoload -XUz
}
_setopt () {
	# undefined
	builtin autoload -XUz
}
_setpriv () {
	# undefined
	builtin autoload -XUz
}
_setsid () {
	# undefined
	builtin autoload -XUz
}
_setup () {
	# undefined
	builtin autoload -XUz
}
_setxkbmap () {
	# undefined
	builtin autoload -XUz
}
_sh () {
	# undefined
	builtin autoload -XUz
}
_shasum () {
	# undefined
	builtin autoload -XUz
}
_showmount () {
	# undefined
	builtin autoload -XUz
}
_shred () {
	# undefined
	builtin autoload -XUz
}
_shuf () {
	# undefined
	builtin autoload -XUz
}
_shutdown () {
	# undefined
	builtin autoload -XUz
}
_signals () {
	# undefined
	builtin autoload -XUz
}
_signify () {
	# undefined
	builtin autoload -XUz
}
_sisu () {
	# undefined
	builtin autoload -XUz
}
_slabtop () {
	# undefined
	builtin autoload -XUz
}
_slrn () {
	# undefined
	builtin autoload -XUz
}
_smartmontools () {
	# undefined
	builtin autoload -XUz
}
_smit () {
	# undefined
	builtin autoload -XUz
}
_snap () {
	# undefined
	builtin autoload -XUz
}
_snoop () {
	# undefined
	builtin autoload -XUz
}
_socket () {
	# undefined
	builtin autoload -XUz
}
_sockstat () {
	# undefined
	builtin autoload -XUz
}
_softwareupdate () {
	# undefined
	builtin autoload -XUz
}
_sort () {
	# undefined
	builtin autoload -XUz
}
_source () {
	# undefined
	builtin autoload -XUz
}
_spamassassin () {
	# undefined
	builtin autoload -XUz
}
_split () {
	# undefined
	builtin autoload -XUz
}
_sqlite () {
	# undefined
	builtin autoload -XUz
}
_sqsh () {
	# undefined
	builtin autoload -XUz
}
_ss () {
	# undefined
	builtin autoload -XUz
}
_ssh () {
	# undefined
	builtin autoload -XUz
}
_ssh_hosts () {
	# undefined
	builtin autoload -XUz
}
_sshfs () {
	# undefined
	builtin autoload -XUz
}
_stat () {
	# undefined
	builtin autoload -XUz
}
_stdbuf () {
	# undefined
	builtin autoload -XUz
}
_stgit () {
	# undefined
	builtin autoload -XUz
}
_store_cache () {
	# undefined
	builtin autoload -XUz
}
_stow () {
	# undefined
	builtin autoload -XUz
}
_strace () {
	# undefined
	builtin autoload -XUz
}
_strftime () {
	# undefined
	builtin autoload -XUz
}
_strings () {
	# undefined
	builtin autoload -XUz
}
_strip () {
	# undefined
	builtin autoload -XUz
}
_stty () {
	# undefined
	builtin autoload -XUz
}
_su () {
	# undefined
	builtin autoload -XUz
}
_sub_commands () {
	# undefined
	builtin autoload -XUz
}
_sublimetext () {
	# undefined
	builtin autoload -XUz
}
_subscript () {
	# undefined
	builtin autoload -XUz
}
_subversion () {
	# undefined
	builtin autoload -XUz
}
_sudo () {
	# undefined
	builtin autoload -XUz
}
_suffix_alias_files () {
	# undefined
	builtin autoload -XUz
}
_surfraw () {
	# undefined
	builtin autoload -XUz
}
_svcadm () {
	# undefined
	builtin autoload -XUz
}
_svccfg () {
	# undefined
	builtin autoload -XUz
}
_svcprop () {
	# undefined
	builtin autoload -XUz
}
_svcs () {
	# undefined
	builtin autoload -XUz
}
_svcs_fmri () {
	# undefined
	builtin autoload -XUz
}
_svn-buildpackage () {
	# undefined
	builtin autoload -XUz
}
_sw_vers () {
	# undefined
	builtin autoload -XUz
}
_swaks () {
	# undefined
	builtin autoload -XUz
}
_swanctl () {
	# undefined
	builtin autoload -XUz
}
_swift () {
	# undefined
	builtin autoload -XUz
}
_sys_calls () {
	# undefined
	builtin autoload -XUz
}
_sysclean () {
	# undefined
	builtin autoload -XUz
}
_sysctl () {
	# undefined
	builtin autoload -XUz
}
_sysmerge () {
	# undefined
	builtin autoload -XUz
}
_syspatch () {
	# undefined
	builtin autoload -XUz
}
_sysrc () {
	# undefined
	builtin autoload -XUz
}
_sysstat () {
	# undefined
	builtin autoload -XUz
}
_systat () {
	# undefined
	builtin autoload -XUz
}
_system_profiler () {
	# undefined
	builtin autoload -XUz
}
_systemctl () {
	# undefined
	builtin autoload -XUz
}
_systemd () {
	# undefined
	builtin autoload -XUz
}
_systemd-analyze () {
	# undefined
	builtin autoload -XUz
}
_systemd-delta () {
	# undefined
	builtin autoload -XUz
}
_systemd-inhibit () {
	# undefined
	builtin autoload -XUz
}
_systemd-path () {
	# undefined
	builtin autoload -XUz
}
_systemd-run () {
	# undefined
	builtin autoload -XUz
}
_systemd-tmpfiles () {
	# undefined
	builtin autoload -XUz
}
_sysupgrade () {
	# undefined
	builtin autoload -XUz
}
_tac () {
	# undefined
	builtin autoload -XUz
}
_tags () {
	# undefined
	builtin autoload -XUz
}
_tail () {
	# undefined
	builtin autoload -XUz
}
_tar () {
	# undefined
	builtin autoload -XUz
}
_tar_archive () {
	# undefined
	builtin autoload -XUz
}
_tardy () {
	# undefined
	builtin autoload -XUz
}
_tcpdump () {
	# undefined
	builtin autoload -XUz
}
_tcpsys () {
	# undefined
	builtin autoload -XUz
}
_tcptraceroute () {
	# undefined
	builtin autoload -XUz
}
_tee () {
	# undefined
	builtin autoload -XUz
}
_telnet () {
	# undefined
	builtin autoload -XUz
}
_terminals () {
	# undefined
	builtin autoload -XUz
}
_tex () {
	# undefined
	builtin autoload -XUz
}
_texi () {
	# undefined
	builtin autoload -XUz
}
_texinfo () {
	# undefined
	builtin autoload -XUz
}
_tidy () {
	# undefined
	builtin autoload -XUz
}
_tiff () {
	# undefined
	builtin autoload -XUz
}
_tilde () {
	# undefined
	builtin autoload -XUz
}
_tilde_files () {
	# undefined
	builtin autoload -XUz
}
_time_zone () {
	# undefined
	builtin autoload -XUz
}
_timedatectl () {
	# undefined
	builtin autoload -XUz
}
_timeout () {
	# undefined
	builtin autoload -XUz
}
_tin () {
	# undefined
	builtin autoload -XUz
}
_tla () {
	# undefined
	builtin autoload -XUz
}
_tload () {
	# undefined
	builtin autoload -XUz
}
_tmux () {
	# undefined
	builtin autoload -XUz
}
_todo.sh () {
	# undefined
	builtin autoload -XUz
}
_toilet () {
	# undefined
	builtin autoload -XUz
}
_toolchain-source () {
	# undefined
	builtin autoload -XUz
}
_top () {
	# undefined
	builtin autoload -XUz
}
_topgit () {
	# undefined
	builtin autoload -XUz
}
_totd () {
	# undefined
	builtin autoload -XUz
}
_touch () {
	# undefined
	builtin autoload -XUz
}
_tpb () {
	# undefined
	builtin autoload -XUz
}
_tput () {
	# undefined
	builtin autoload -XUz
}
_tr () {
	# undefined
	builtin autoload -XUz
}
_tracepath () {
	# undefined
	builtin autoload -XUz
}
_transmission () {
	# undefined
	builtin autoload -XUz
}
_trap () {
	# undefined
	builtin autoload -XUz
}
_trash () {
	# undefined
	builtin autoload -XUz
}
_tree () {
	# undefined
	builtin autoload -XUz
}
_truncate () {
	# undefined
	builtin autoload -XUz
}
_truss () {
	# undefined
	builtin autoload -XUz
}
_tty () {
	# undefined
	builtin autoload -XUz
}
_ttyctl () {
	# undefined
	builtin autoload -XUz
}
_ttys () {
	# undefined
	builtin autoload -XUz
}
_tune2fs () {
	# undefined
	builtin autoload -XUz
}
_twidge () {
	# undefined
	builtin autoload -XUz
}
_twisted () {
	# undefined
	builtin autoload -XUz
}
_typeset () {
	# undefined
	builtin autoload -XUz
}
_ubuntu-report () {
	# undefined
	builtin autoload -XUz
}
_udevadm () {
	# undefined
	builtin autoload -XUz
}
_ulimit () {
	# undefined
	builtin autoload -XUz
}
_uml () {
	# undefined
	builtin autoload -XUz
}
_umountable () {
	# undefined
	builtin autoload -XUz
}
_unace () {
	# undefined
	builtin autoload -XUz
}
_uname () {
	# undefined
	builtin autoload -XUz
}
_unexpand () {
	# undefined
	builtin autoload -XUz
}
_unhash () {
	# undefined
	builtin autoload -XUz
}
_uniq () {
	# undefined
	builtin autoload -XUz
}
_unison () {
	# undefined
	builtin autoload -XUz
}
_units () {
	# undefined
	builtin autoload -XUz
}
_unshare () {
	# undefined
	builtin autoload -XUz
}
_update-alternatives () {
	# undefined
	builtin autoload -XUz
}
_update-rc.d () {
	# undefined
	builtin autoload -XUz
}
_uptime () {
	# undefined
	builtin autoload -XUz
}
_urls () {
	# undefined
	builtin autoload -XUz
}
_urpmi () {
	# undefined
	builtin autoload -XUz
}
_urxvt () {
	# undefined
	builtin autoload -XUz
}
_usbconfig () {
	# undefined
	builtin autoload -XUz
}
_uscan () {
	# undefined
	builtin autoload -XUz
}
_user_admin () {
	# undefined
	builtin autoload -XUz
}
_user_at_host () {
	# undefined
	builtin autoload -XUz
}
_user_expand () {
	# undefined
	builtin autoload -XUz
}
_user_math_func () {
	# undefined
	builtin autoload -XUz
}
_users () {
	# undefined
	builtin autoload -XUz
}
_users_on () {
	# undefined
	builtin autoload -XUz
}
_valgrind () {
	# undefined
	builtin autoload -XUz
}
_value () {
	# undefined
	builtin autoload -XUz
}
_values () {
	# undefined
	builtin autoload -XUz
}
_vared () {
	# undefined
	builtin autoload -XUz
}
_vars () {
	# undefined
	builtin autoload -XUz
}
_vcs_info () {
	# undefined
	builtin autoload -XUz
}
_vcs_info_hooks () {
	# undefined
	builtin autoload -XUz
}
_vi () {
	# undefined
	builtin autoload -XUz
}
_vim () {
	# undefined
	builtin autoload -XUz
}
_vim-addons () {
	# undefined
	builtin autoload -XUz
}
_visudo () {
	# undefined
	builtin autoload -XUz
}
_vlc () {
	# undefined
	builtin autoload -XUz
}
_vmctl () {
	# undefined
	builtin autoload -XUz
}
_vmstat () {
	# undefined
	builtin autoload -XUz
}
_vnc () {
	# undefined
	builtin autoload -XUz
}
_volume_groups () {
	# undefined
	builtin autoload -XUz
}
_vorbis () {
	# undefined
	builtin autoload -XUz
}
_vpnc () {
	# undefined
	builtin autoload -XUz
}
_vserver () {
	# undefined
	builtin autoload -XUz
}
_w () {
	# undefined
	builtin autoload -XUz
}
_w3m () {
	# undefined
	builtin autoload -XUz
}
_wait () {
	# undefined
	builtin autoload -XUz
}
_wajig () {
	# undefined
	builtin autoload -XUz
}
_wakeup_capable_devices () {
	# undefined
	builtin autoload -XUz
}
_wanna-build () {
	# undefined
	builtin autoload -XUz
}
_wanted () {
	# undefined
	builtin autoload -XUz
}
_watch () {
	# undefined
	builtin autoload -XUz
}
_watch-snoop () {
	# undefined
	builtin autoload -XUz
}
_wc () {
	# undefined
	builtin autoload -XUz
}
_webbrowser () {
	# undefined
	builtin autoload -XUz
}
_wget () {
	# undefined
	builtin autoload -XUz
}
_whereis () {
	# undefined
	builtin autoload -XUz
}
_which () {
	# undefined
	builtin autoload -XUz
}
_who () {
	# undefined
	builtin autoload -XUz
}
_whois () {
	# undefined
	builtin autoload -XUz
}
_widgets () {
	# undefined
	builtin autoload -XUz
}
_wiggle () {
	# undefined
	builtin autoload -XUz
}
_wipefs () {
	# undefined
	builtin autoload -XUz
}
_within-bundled-project () {
	local check_dir="$PWD" 
	while [[ "$check_dir" != "/" ]]
	do
		if [[ -f "$check_dir/Gemfile" || -f "$check_dir/gems.rb" ]]
		then
			return 0
		fi
		check_dir="${check_dir:h}" 
	done
	return 1
}
_wpa_cli () {
	# undefined
	builtin autoload -XUz
}
_x_arguments () {
	# undefined
	builtin autoload -XUz
}
_x_borderwidth () {
	# undefined
	builtin autoload -XUz
}
_x_color () {
	# undefined
	builtin autoload -XUz
}
_x_colormapid () {
	# undefined
	builtin autoload -XUz
}
_x_cursor () {
	# undefined
	builtin autoload -XUz
}
_x_display () {
	# undefined
	builtin autoload -XUz
}
_x_extension () {
	# undefined
	builtin autoload -XUz
}
_x_font () {
	# undefined
	builtin autoload -XUz
}
_x_geometry () {
	# undefined
	builtin autoload -XUz
}
_x_keysym () {
	# undefined
	builtin autoload -XUz
}
_x_locale () {
	# undefined
	builtin autoload -XUz
}
_x_modifier () {
	# undefined
	builtin autoload -XUz
}
_x_name () {
	# undefined
	builtin autoload -XUz
}
_x_resource () {
	# undefined
	builtin autoload -XUz
}
_x_selection_timeout () {
	# undefined
	builtin autoload -XUz
}
_x_title () {
	# undefined
	builtin autoload -XUz
}
_x_utils () {
	# undefined
	builtin autoload -XUz
}
_x_visual () {
	# undefined
	builtin autoload -XUz
}
_x_window () {
	# undefined
	builtin autoload -XUz
}
_xargs () {
	# undefined
	builtin autoload -XUz
}
_xauth () {
	# undefined
	builtin autoload -XUz
}
_xautolock () {
	# undefined
	builtin autoload -XUz
}
_xclip () {
	# undefined
	builtin autoload -XUz
}
_xcode-select () {
	# undefined
	builtin autoload -XUz
}
_xdvi () {
	# undefined
	builtin autoload -XUz
}
_xfig () {
	# undefined
	builtin autoload -XUz
}
_xft_fonts () {
	# undefined
	builtin autoload -XUz
}
_xinput () {
	# undefined
	builtin autoload -XUz
}
_xloadimage () {
	# undefined
	builtin autoload -XUz
}
_xmlsoft () {
	# undefined
	builtin autoload -XUz
}
_xmlstarlet () {
	# undefined
	builtin autoload -XUz
}
_xmms2 () {
	# undefined
	builtin autoload -XUz
}
_xmodmap () {
	# undefined
	builtin autoload -XUz
}
_xournal () {
	# undefined
	builtin autoload -XUz
}
_xpdf () {
	# undefined
	builtin autoload -XUz
}
_xrandr () {
	# undefined
	builtin autoload -XUz
}
_xscreensaver () {
	# undefined
	builtin autoload -XUz
}
_xset () {
	# undefined
	builtin autoload -XUz
}
_xt_arguments () {
	# undefined
	builtin autoload -XUz
}
_xt_session_id () {
	# undefined
	builtin autoload -XUz
}
_xterm () {
	# undefined
	builtin autoload -XUz
}
_xv () {
	# undefined
	builtin autoload -XUz
}
_xwit () {
	# undefined
	builtin autoload -XUz
}
_xxd () {
	# undefined
	builtin autoload -XUz
}
_xz () {
	# undefined
	builtin autoload -XUz
}
_yafc () {
	# undefined
	builtin autoload -XUz
}
_yast () {
	# undefined
	builtin autoload -XUz
}
_yodl () {
	# undefined
	builtin autoload -XUz
}
_yp () {
	# undefined
	builtin autoload -XUz
}
_yum () {
	# undefined
	builtin autoload -XUz
}
_zargs () {
	# undefined
	builtin autoload -XUz
}
_zattr () {
	# undefined
	builtin autoload -XUz
}
_zcalc () {
	# undefined
	builtin autoload -XUz
}
_zcalc_line () {
	# undefined
	builtin autoload -XUz
}
_zcat () {
	# undefined
	builtin autoload -XUz
}
_zcompile () {
	# undefined
	builtin autoload -XUz
}
_zdump () {
	# undefined
	builtin autoload -XUz
}
_zeal () {
	# undefined
	builtin autoload -XUz
}
_zed () {
	# undefined
	builtin autoload -XUz
}
_zfs () {
	# undefined
	builtin autoload -XUz
}
_zfs_dataset () {
	# undefined
	builtin autoload -XUz
}
_zfs_pool () {
	# undefined
	builtin autoload -XUz
}
_zftp () {
	# undefined
	builtin autoload -XUz
}
_zip () {
	# undefined
	builtin autoload -XUz
}
_zle () {
	# undefined
	builtin autoload -XUz
}
_zlogin () {
	# undefined
	builtin autoload -XUz
}
_zmodload () {
	# undefined
	builtin autoload -XUz
}
_zmv () {
	# undefined
	builtin autoload -XUz
}
_zoneadm () {
	# undefined
	builtin autoload -XUz
}
_zones () {
	# undefined
	builtin autoload -XUz
}
_zparseopts () {
	# undefined
	builtin autoload -XUz
}
_zpty () {
	# undefined
	builtin autoload -XUz
}
_zsh () {
	# undefined
	builtin autoload -XUz
}
_zsh-mime-handler () {
	# undefined
	builtin autoload -XUz
}
_zsh_autosuggest_accept () {
	local -i retval max_cursor_pos=$#BUFFER 
	if [[ "$KEYMAP" = "vicmd" ]]
	then
		max_cursor_pos=$((max_cursor_pos - 1)) 
	fi
	if (( $CURSOR != $max_cursor_pos || !$#POSTDISPLAY ))
	then
		_zsh_autosuggest_invoke_original_widget $@
		return
	fi
	BUFFER="$BUFFER$POSTDISPLAY" 
	POSTDISPLAY= 
	_zsh_autosuggest_invoke_original_widget $@
	retval=$? 
	if [[ "$KEYMAP" = "vicmd" ]]
	then
		CURSOR=$(($#BUFFER - 1)) 
	else
		CURSOR=$#BUFFER 
	fi
	return $retval
}
_zsh_autosuggest_async_request () {
	zmodload zsh/system 2> /dev/null
	typeset -g _ZSH_AUTOSUGGEST_ASYNC_FD _ZSH_AUTOSUGGEST_CHILD_PID
	if [[ -n "$_ZSH_AUTOSUGGEST_ASYNC_FD" ]] && {
			true <&$_ZSH_AUTOSUGGEST_ASYNC_FD
		} 2> /dev/null
	then
		builtin exec {_ZSH_AUTOSUGGEST_ASYNC_FD}<&-
		zle -F $_ZSH_AUTOSUGGEST_ASYNC_FD
		if [[ -n "$_ZSH_AUTOSUGGEST_CHILD_PID" ]]
		then
			if [[ -o MONITOR ]]
			then
				kill -TERM -$_ZSH_AUTOSUGGEST_CHILD_PID 2> /dev/null
			else
				kill -TERM $_ZSH_AUTOSUGGEST_CHILD_PID 2> /dev/null
			fi
		fi
	fi
	builtin exec {_ZSH_AUTOSUGGEST_ASYNC_FD}< <(
		# Tell parent process our pid
		echo $sysparams[pid]

		# Fetch and print the suggestion
		local suggestion
		_zsh_autosuggest_fetch_suggestion "$1"
		echo -nE "$suggestion"
	)
	autoload -Uz is-at-least
	is-at-least 5.8 || command true
	read _ZSH_AUTOSUGGEST_CHILD_PID <&$_ZSH_AUTOSUGGEST_ASYNC_FD
	zle -F "$_ZSH_AUTOSUGGEST_ASYNC_FD" _zsh_autosuggest_async_response
}
_zsh_autosuggest_async_response () {
	emulate -L zsh
	local suggestion
	if [[ -z "$2" || "$2" == "hup" ]]
	then
		IFS='' read -rd '' -u $1 suggestion
		zle autosuggest-suggest -- "$suggestion"
		builtin exec {1}<&-
	fi
	zle -F "$1"
	_ZSH_AUTOSUGGEST_ASYNC_FD= 
}
_zsh_autosuggest_bind_widget () {
	typeset -gA _ZSH_AUTOSUGGEST_BIND_COUNTS
	local widget=$1 
	local autosuggest_action=$2 
	local prefix=$ZSH_AUTOSUGGEST_ORIGINAL_WIDGET_PREFIX 
	local -i bind_count
	case $widgets[$widget] in
		(user:_zsh_autosuggest_(bound|orig)_*) bind_count=$((_ZSH_AUTOSUGGEST_BIND_COUNTS[$widget]))  ;;
		(user:*) _zsh_autosuggest_incr_bind_count $widget
			zle -N $prefix$bind_count-$widget ${widgets[$widget]#*:} ;;
		(builtin) _zsh_autosuggest_incr_bind_count $widget
			eval "_zsh_autosuggest_orig_${(q)widget}() { zle .${(q)widget} }"
			zle -N $prefix$bind_count-$widget _zsh_autosuggest_orig_$widget ;;
		(completion:*) _zsh_autosuggest_incr_bind_count $widget
			eval "zle -C $prefix$bind_count-${(q)widget} ${${(s.:.)widgets[$widget]}[2,3]}" ;;
	esac
	eval "_zsh_autosuggest_bound_${bind_count}_${(q)widget}() {
		_zsh_autosuggest_widget_$autosuggest_action $prefix$bind_count-${(q)widget} \$@
	}"
	zle -N -- $widget _zsh_autosuggest_bound_${bind_count}_$widget
}
_zsh_autosuggest_bind_widgets () {
	emulate -L zsh
	local widget
	local ignore_widgets
	ignore_widgets=(.\* _\* ${_ZSH_AUTOSUGGEST_BUILTIN_ACTIONS/#/autosuggest-} $ZSH_AUTOSUGGEST_ORIGINAL_WIDGET_PREFIX\* $ZSH_AUTOSUGGEST_IGNORE_WIDGETS) 
	for widget in ${${(f)"$(builtin zle -la)"}:#${(j:|:)~ignore_widgets}}
	do
		if [[ -n ${ZSH_AUTOSUGGEST_CLEAR_WIDGETS[(r)$widget]} ]]
		then
			_zsh_autosuggest_bind_widget $widget clear
		elif [[ -n ${ZSH_AUTOSUGGEST_ACCEPT_WIDGETS[(r)$widget]} ]]
		then
			_zsh_autosuggest_bind_widget $widget accept
		elif [[ -n ${ZSH_AUTOSUGGEST_EXECUTE_WIDGETS[(r)$widget]} ]]
		then
			_zsh_autosuggest_bind_widget $widget execute
		elif [[ -n ${ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS[(r)$widget]} ]]
		then
			_zsh_autosuggest_bind_widget $widget partial_accept
		else
			_zsh_autosuggest_bind_widget $widget modify
		fi
	done
}
_zsh_autosuggest_capture_completion_async () {
	_zsh_autosuggest_capture_setup
	zmodload zsh/parameter 2> /dev/null || return
	autoload +X _complete
	functions[_original_complete]=$functions[_complete] 
	_complete () {
		unset 'compstate[vared]'
		_original_complete "$@"
	}
	vared 1
}
_zsh_autosuggest_capture_completion_sync () {
	_zsh_autosuggest_capture_setup
	zle autosuggest-capture-completion
}
_zsh_autosuggest_capture_completion_widget () {
	local -a +h comppostfuncs
	comppostfuncs=(_zsh_autosuggest_capture_postcompletion) 
	CURSOR=$#BUFFER 
	zle -- ${(k)widgets[(r)completion:.complete-word:_main_complete]}
	if is-at-least 5.0.3
	then
		stty -onlcr -ocrnl -F /dev/tty
	fi
	echo -nE - $'\0'$BUFFER$'\0'
}
_zsh_autosuggest_capture_postcompletion () {
	compstate[insert]=1 
	unset 'compstate[list]'
}
_zsh_autosuggest_capture_setup () {
	if ! is-at-least 5.4
	then
		zshexit () {
			kill -KILL $$ 2>&- || command kill -KILL $$
			sleep 1
		}
	fi
	zstyle ':completion:*' matcher-list ''
	zstyle ':completion:*' path-completion false
	zstyle ':completion:*' max-errors 0 not-numeric
	bindkey '^I' autosuggest-capture-completion
}
_zsh_autosuggest_clear () {
	POSTDISPLAY= 
	_zsh_autosuggest_invoke_original_widget $@
}
_zsh_autosuggest_disable () {
	typeset -g _ZSH_AUTOSUGGEST_DISABLED
	_zsh_autosuggest_clear
}
_zsh_autosuggest_enable () {
	unset _ZSH_AUTOSUGGEST_DISABLED
	if (( $#BUFFER ))
	then
		_zsh_autosuggest_fetch
	fi
}
_zsh_autosuggest_escape_command () {
	setopt localoptions EXTENDED_GLOB
	echo -E "${1//(#m)[\"\'\\()\[\]|*?~]/\\$MATCH}"
}
_zsh_autosuggest_execute () {
	BUFFER="$BUFFER$POSTDISPLAY" 
	POSTDISPLAY= 
	_zsh_autosuggest_invoke_original_widget "accept-line"
}
_zsh_autosuggest_fetch () {
	if (( ${+ZSH_AUTOSUGGEST_USE_ASYNC} ))
	then
		_zsh_autosuggest_async_request "$BUFFER"
	else
		local suggestion
		_zsh_autosuggest_fetch_suggestion "$BUFFER"
		_zsh_autosuggest_suggest "$suggestion"
	fi
}
_zsh_autosuggest_fetch_suggestion () {
	typeset -g suggestion
	local -a strategies
	local strategy
	strategies=(${=ZSH_AUTOSUGGEST_STRATEGY}) 
	for strategy in $strategies
	do
		_zsh_autosuggest_strategy_$strategy "$1"
		[[ "$suggestion" != "$1"* ]] && unset suggestion
		[[ -n "$suggestion" ]] && break
	done
}
_zsh_autosuggest_highlight_apply () {
	typeset -g _ZSH_AUTOSUGGEST_LAST_HIGHLIGHT
	if (( $#POSTDISPLAY ))
	then
		typeset -g _ZSH_AUTOSUGGEST_LAST_HIGHLIGHT="$#BUFFER $(($#BUFFER + $#POSTDISPLAY)) $ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE" 
		region_highlight+=("$_ZSH_AUTOSUGGEST_LAST_HIGHLIGHT") 
	else
		unset _ZSH_AUTOSUGGEST_LAST_HIGHLIGHT
	fi
}
_zsh_autosuggest_highlight_reset () {
	typeset -g _ZSH_AUTOSUGGEST_LAST_HIGHLIGHT
	if [[ -n "$_ZSH_AUTOSUGGEST_LAST_HIGHLIGHT" ]]
	then
		region_highlight=("${(@)region_highlight:#$_ZSH_AUTOSUGGEST_LAST_HIGHLIGHT}") 
		unset _ZSH_AUTOSUGGEST_LAST_HIGHLIGHT
	fi
}
_zsh_autosuggest_incr_bind_count () {
	typeset -gi bind_count=$((_ZSH_AUTOSUGGEST_BIND_COUNTS[$1]+1)) 
	_ZSH_AUTOSUGGEST_BIND_COUNTS[$1]=$bind_count 
}
_zsh_autosuggest_invoke_original_widget () {
	(( $# )) || return 0
	local original_widget_name="$1" 
	shift
	if (( ${+widgets[$original_widget_name]} ))
	then
		zle $original_widget_name -- $@
	fi
}
_zsh_autosuggest_modify () {
	local -i retval
	local -i KEYS_QUEUED_COUNT
	local orig_buffer="$BUFFER" 
	local orig_postdisplay="$POSTDISPLAY" 
	POSTDISPLAY= 
	_zsh_autosuggest_invoke_original_widget $@
	retval=$? 
	emulate -L zsh
	if (( $PENDING > 0 || $KEYS_QUEUED_COUNT > 0 ))
	then
		POSTDISPLAY="$orig_postdisplay" 
		return $retval
	fi
	if [[ "$BUFFER" = "$orig_buffer"* && "$orig_postdisplay" = "${BUFFER:$#orig_buffer}"* ]]
	then
		POSTDISPLAY="${orig_postdisplay:$(($#BUFFER - $#orig_buffer))}" 
		return $retval
	fi
	if (( ${+_ZSH_AUTOSUGGEST_DISABLED} ))
	then
		return $?
	fi
	if (( $#BUFFER > 0 ))
	then
		if [[ -z "$ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE" ]] || (( $#BUFFER <= $ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE ))
		then
			_zsh_autosuggest_fetch
		fi
	fi
	return $retval
}
_zsh_autosuggest_partial_accept () {
	local -i retval cursor_loc
	local original_buffer="$BUFFER" 
	BUFFER="$BUFFER$POSTDISPLAY" 
	_zsh_autosuggest_invoke_original_widget $@
	retval=$? 
	cursor_loc=$CURSOR 
	if [[ "$KEYMAP" = "vicmd" ]]
	then
		cursor_loc=$((cursor_loc + 1)) 
	fi
	if (( $cursor_loc > $#original_buffer ))
	then
		POSTDISPLAY="${BUFFER[$(($cursor_loc + 1)),$#BUFFER]}" 
		BUFFER="${BUFFER[1,$cursor_loc]}" 
	else
		BUFFER="$original_buffer" 
	fi
	return $retval
}
_zsh_autosuggest_start () {
	if (( ${+ZSH_AUTOSUGGEST_MANUAL_REBIND} ))
	then
		add-zsh-hook -d precmd _zsh_autosuggest_start
	fi
	_zsh_autosuggest_bind_widgets
}
_zsh_autosuggest_strategy_completion () {
	emulate -L zsh
	setopt EXTENDED_GLOB
	typeset -g suggestion
	local line REPLY
	whence compdef > /dev/null || return
	zmodload zsh/zpty 2> /dev/null || return
	[[ -n "$ZSH_AUTOSUGGEST_COMPLETION_IGNORE" ]] && [[ "$1" == $~ZSH_AUTOSUGGEST_COMPLETION_IGNORE ]] && return
	if zle
	then
		zpty $ZSH_AUTOSUGGEST_COMPLETIONS_PTY_NAME _zsh_autosuggest_capture_completion_sync
	else
		zpty $ZSH_AUTOSUGGEST_COMPLETIONS_PTY_NAME _zsh_autosuggest_capture_completion_async "\$1"
		zpty -w $ZSH_AUTOSUGGEST_COMPLETIONS_PTY_NAME $'\t'
	fi
	{
		zpty -r $ZSH_AUTOSUGGEST_COMPLETIONS_PTY_NAME line '*'$'\0''*'$'\0'
		suggestion="${${(@0)line}[2]}" 
	} always {
		zpty -d $ZSH_AUTOSUGGEST_COMPLETIONS_PTY_NAME
	}
}
_zsh_autosuggest_strategy_history () {
	emulate -L zsh
	setopt EXTENDED_GLOB
	local prefix="${1//(#m)[\\*?[\]<>()|^~#]/\\$MATCH}" 
	local pattern="$prefix*" 
	if [[ -n $ZSH_AUTOSUGGEST_HISTORY_IGNORE ]]
	then
		pattern="($pattern)~($ZSH_AUTOSUGGEST_HISTORY_IGNORE)" 
	fi
	typeset -g suggestion="${history[(r)$pattern]}" 
}
_zsh_autosuggest_strategy_match_prev_cmd () {
	emulate -L zsh
	setopt EXTENDED_GLOB
	local prefix="${1//(#m)[\\*?[\]<>()|^~#]/\\$MATCH}" 
	local pattern="$prefix*" 
	if [[ -n $ZSH_AUTOSUGGEST_HISTORY_IGNORE ]]
	then
		pattern="($pattern)~($ZSH_AUTOSUGGEST_HISTORY_IGNORE)" 
	fi
	local history_match_keys
	history_match_keys=(${(k)history[(R)$~pattern]}) 
	local histkey="${history_match_keys[1]}" 
	local prev_cmd="$(_zsh_autosuggest_escape_command "${history[$((HISTCMD-1))]}")" 
	for key in "${(@)history_match_keys[1,200]}"
	do
		[[ $key -gt 1 ]] || break
		if [[ "${history[$((key - 1))]}" == "$prev_cmd" ]]
		then
			histkey="$key" 
			break
		fi
	done
	typeset -g suggestion="$history[$histkey]" 
}
_zsh_autosuggest_suggest () {
	emulate -L zsh
	local suggestion="$1" 
	if [[ -n "$suggestion" ]] && (( $#BUFFER ))
	then
		POSTDISPLAY="${suggestion#$BUFFER}" 
	else
		POSTDISPLAY= 
	fi
}
_zsh_autosuggest_toggle () {
	if (( ${+_ZSH_AUTOSUGGEST_DISABLED} ))
	then
		_zsh_autosuggest_enable
	else
		_zsh_autosuggest_disable
	fi
}
_zsh_autosuggest_widget_accept () {
	local -i retval
	_zsh_autosuggest_highlight_reset
	_zsh_autosuggest_accept $@
	retval=$? 
	_zsh_autosuggest_highlight_apply
	zle -R
	return $retval
}
_zsh_autosuggest_widget_clear () {
	local -i retval
	_zsh_autosuggest_highlight_reset
	_zsh_autosuggest_clear $@
	retval=$? 
	_zsh_autosuggest_highlight_apply
	zle -R
	return $retval
}
_zsh_autosuggest_widget_disable () {
	local -i retval
	_zsh_autosuggest_highlight_reset
	_zsh_autosuggest_disable $@
	retval=$? 
	_zsh_autosuggest_highlight_apply
	zle -R
	return $retval
}
_zsh_autosuggest_widget_enable () {
	local -i retval
	_zsh_autosuggest_highlight_reset
	_zsh_autosuggest_enable $@
	retval=$? 
	_zsh_autosuggest_highlight_apply
	zle -R
	return $retval
}
_zsh_autosuggest_widget_execute () {
	local -i retval
	_zsh_autosuggest_highlight_reset
	_zsh_autosuggest_execute $@
	retval=$? 
	_zsh_autosuggest_highlight_apply
	zle -R
	return $retval
}
_zsh_autosuggest_widget_fetch () {
	local -i retval
	_zsh_autosuggest_highlight_reset
	_zsh_autosuggest_fetch $@
	retval=$? 
	_zsh_autosuggest_highlight_apply
	zle -R
	return $retval
}
_zsh_autosuggest_widget_modify () {
	local -i retval
	_zsh_autosuggest_highlight_reset
	_zsh_autosuggest_modify $@
	retval=$? 
	_zsh_autosuggest_highlight_apply
	zle -R
	return $retval
}
_zsh_autosuggest_widget_partial_accept () {
	local -i retval
	_zsh_autosuggest_highlight_reset
	_zsh_autosuggest_partial_accept $@
	retval=$? 
	_zsh_autosuggest_highlight_apply
	zle -R
	return $retval
}
_zsh_autosuggest_widget_suggest () {
	local -i retval
	_zsh_autosuggest_highlight_reset
	_zsh_autosuggest_suggest $@
	retval=$? 
	_zsh_autosuggest_highlight_apply
	zle -R
	return $retval
}
_zsh_autosuggest_widget_toggle () {
	local -i retval
	_zsh_autosuggest_highlight_reset
	_zsh_autosuggest_toggle $@
	retval=$? 
	_zsh_autosuggest_highlight_apply
	zle -R
	return $retval
}
_zsh_highlight () {
	local ret=$? 
	if [[ $WIDGET == zle-isearch-update ]] && ! (( $+ISEARCHMATCH_ACTIVE ))
	then
		region_highlight=() 
		return $ret
	fi
	emulate -LR zsh
	setopt extendedglob warncreateglobal typesetsilent noshortloops
	local REPLY
	local -a reply
	[[ -n ${ZSH_HIGHLIGHT_MAXLENGTH:-} ]] && [[ $#BUFFER -gt $ZSH_HIGHLIGHT_MAXLENGTH ]] && return $ret
	[[ $PENDING -gt 0 ]] && return $ret
	if [[ $WIDGET == zle-line-finish ]] || _zsh_highlight_buffer_modified
	then
		-fast-highlight-init
		-fast-highlight-process "$PREBUFFER" "$BUFFER" 0
		(( FAST_HIGHLIGHT[use_brackets] )) && {
			_FAST_MAIN_CACHE=($reply) 
			-fast-highlight-string-process "$PREBUFFER" "$BUFFER"
		}
		region_highlight=($reply) 
	else
		local char="${BUFFER[CURSOR+1]}" 
		if [[ "$char" = ["{([])}"] || "${FAST_HIGHLIGHT[prev_char]}" = ["{([])}"] ]]
		then
			FAST_HIGHLIGHT[prev_char]="$char" 
			(( FAST_HIGHLIGHT[use_brackets] )) && {
				reply=($_FAST_MAIN_CACHE) 
				-fast-highlight-string-process "$PREBUFFER" "$BUFFER"
				region_highlight=($reply) 
			}
		fi
	fi
	{
		local cache_place
		local -a region_highlight_copy
		if (( REGION_ACTIVE == 1 ))
		then
			_zsh_highlight_apply_zle_highlight region standout "$MARK" "$CURSOR"
		elif (( REGION_ACTIVE == 2 ))
		then
			() {
				local needle=$'\n' 
				integer min max
				if (( MARK > CURSOR ))
				then
					min=$CURSOR max=$(( MARK + 1 )) 
				else
					min=$MARK max=$CURSOR 
				fi
				(( min = ${${BUFFER[1,$min]}[(I)$needle]} ))
				(( max += ${${BUFFER:($max-1)}[(i)$needle]} - 1 ))
				_zsh_highlight_apply_zle_highlight region standout "$min" "$max"
			}
		fi
		(( $+YANK_ACTIVE )) && (( YANK_ACTIVE )) && _zsh_highlight_apply_zle_highlight paste standout "$YANK_START" "$YANK_END"
		(( $+ISEARCHMATCH_ACTIVE )) && (( ISEARCHMATCH_ACTIVE )) && _zsh_highlight_apply_zle_highlight isearch underline "$ISEARCHMATCH_START" "$ISEARCHMATCH_END"
		(( $+SUFFIX_ACTIVE )) && (( SUFFIX_ACTIVE )) && _zsh_highlight_apply_zle_highlight suffix bold "$SUFFIX_START" "$SUFFIX_END"
		return $ret
	} always {
		typeset -g _ZSH_HIGHLIGHT_PRIOR_BUFFER="$BUFFER" 
		typeset -g _ZSH_HIGHLIGHT_PRIOR_RACTIVE="$REGION_ACTIVE" 
		typeset -gi _ZSH_HIGHLIGHT_PRIOR_CURSOR=$CURSOR 
	}
}
_zsh_highlight__function_callable_p () {
	if _zsh_highlight__is_function_p "$1" && ! _zsh_highlight__function_is_autoload_stub_p "$1"
	then
		return 0
	else
		(
			autoload -U +X -- "$1" 2> /dev/null
		)
		return $?
	fi
}
_zsh_highlight__function_is_autoload_stub_p () {
	if zmodload -e zsh/parameter
	then
		[[ "$functions[$1]" == *"builtin autoload -X"* ]]
	else
		[[ "${${(@f)"$(which -- "$1")"}[2]}" == $'\t'$histchars[3]' undefined' ]]
	fi
}
_zsh_highlight__is_function_p () {
	if zmodload -e zsh/parameter
	then
		(( ${+functions[$1]} ))
	else
		[[ $(type -wa -- "$1") == *'function'* ]]
	fi
}
_zsh_highlight__zle-line-finish () {
	() {
		local -h -r WIDGET=zle-line-finish 
		_zsh_highlight
	}
}
_zsh_highlight__zle-line-pre-redraw () {
	true && _zsh_highlight "$@"
}
_zsh_highlight_add_highlight () {
	local -i start end
	local highlight
	start=$1 
	end=$2 
	shift 2
	for highlight
	do
		if (( $+ZSH_HIGHLIGHT_STYLES[$highlight] ))
		then
			region_highlight+=("$start $end $ZSH_HIGHLIGHT_STYLES[$highlight], memo=zsh-syntax-highlighting") 
			break
		fi
	done
}
_zsh_highlight_apply_zle_highlight () {
	local entry="$1" default="$2" 
	integer first="$3" second="$4" 
	local region="${zle_highlight[(r)${entry}:*]}" 
	if [[ -z "$region" ]]
	then
		region=$default 
	else
		region="${region#${entry}:}" 
		if [[ -z "$region" ]] || [[ "$region" == none ]]
		then
			return
		fi
	fi
	integer start end
	if (( first < second ))
	then
		start=$first end=$second 
	else
		start=$second end=$first 
	fi
	region_highlight+=("$start $end $region") 
}
_zsh_highlight_bind_widgets () {
	setopt localoptions noksharrays
	local -F2 SECONDS
	local prefix=orig-s${SECONDS/./}-r$(( RANDOM % 1000 )) 
	zmodload zsh/zleparameter 2> /dev/null || {
		print -r -- 'zsh-syntax-highlighting: failed loading zsh/zleparameter.' >&2
		return 1
	}
	local -U widgets_to_bind
	widgets_to_bind=(${${(k)widgets}:#(.*|run-help|which-command|beep|set-local-history|yank|zle-line-pre-redraw|zle-keymap-select)}) 
	widgets_to_bind+=(zle-line-finish) 
	widgets_to_bind+=(zle-isearch-update) 
	local cur_widget
	for cur_widget in $widgets_to_bind
	do
		case ${widgets[$cur_widget]-} in
			(user:_zsh_highlight_widget_*)  ;;
			(user:*) zle -N -- $prefix-$cur_widget ${widgets[$cur_widget]#*:}
				eval "_zsh_highlight_widget_${(q)prefix}-${(q)cur_widget}() { _zsh_highlight_call_widget ${(q)prefix}-${(q)cur_widget} -- \"\$@\" }"
				zle -N -- $cur_widget _zsh_highlight_widget_$prefix-$cur_widget ;;
			(completion:*) zle -C $prefix-$cur_widget ${${(s.:.)widgets[$cur_widget]}[2,3]}
				eval "_zsh_highlight_widget_${(q)prefix}-${(q)cur_widget}() { _zsh_highlight_call_widget ${(q)prefix}-${(q)cur_widget} -- \"\$@\" }"
				zle -N -- $cur_widget _zsh_highlight_widget_$prefix-$cur_widget ;;
			(builtin) eval "_zsh_highlight_widget_${(q)prefix}-${(q)cur_widget}() { _zsh_highlight_call_widget .${(q)cur_widget} -- \"\$@\" }"
				zle -N -- $cur_widget _zsh_highlight_widget_$prefix-$cur_widget ;;
			(*) if [[ $cur_widget == zle-* ]] && [[ -z ${widgets[$cur_widget]-} ]]
				then
					_zsh_highlight_widget_${cur_widget} () {
						:
						_zsh_highlight
					}
					zle -N -- $cur_widget _zsh_highlight_widget_$cur_widget
				else
					print -r -- "zsh-syntax-highlighting: unhandled ZLE widget ${(qq)cur_widget}" >&2
				fi ;;
		esac
	done
}
_zsh_highlight_brackets_match () {
	case $BUFFER[$1] in
		(\() [[ $BUFFER[$2] == \) ]] ;;
		(\[) [[ $BUFFER[$2] == \] ]] ;;
		(\{) [[ $BUFFER[$2] == \} ]] ;;
		(*) false ;;
	esac
}
_zsh_highlight_buffer_modified () {
	[[ "${_ZSH_HIGHLIGHT_PRIOR_BUFFER:-}" != "$BUFFER" ]] || [[ "$REGION_ACTIVE" != "$_ZSH_HIGHLIGHT_PRIOR_RACTIVE" ]] || {
		_zsh_highlight_cursor_moved && [[ "$REGION_ACTIVE" = 1 || "$REGION_ACTIVE" = 2 ]]
	}
}
_zsh_highlight_call_widget () {
	integer ret
	builtin zle "$@"
	ret=$? 
	_zsh_highlight
	return $ret
}
_zsh_highlight_cursor_moved () {
	[[ -n $CURSOR ]] && [[ -n ${_ZSH_HIGHLIGHT_PRIOR_CURSOR-} ]] && (($_ZSH_HIGHLIGHT_PRIOR_CURSOR != $CURSOR))
}
_zsh_highlight_highlighter_brackets_paint () {
	local char style
	local -i bracket_color_size=${#ZSH_HIGHLIGHT_STYLES[(I)bracket-level-*]} buflen=${#BUFFER} level=0 matchingpos pos 
	local -A levelpos lastoflevel matching
	pos=0 
	for char in ${(s..)BUFFER}
	do
		(( ++pos ))
		case $char in
			(["([{"]) levelpos[$pos]=$((++level)) 
				lastoflevel[$level]=$pos  ;;
			([")]}"]) if (( level > 0 ))
				then
					matchingpos=$lastoflevel[$level] 
					levelpos[$pos]=$((level--)) 
					if _zsh_highlight_brackets_match $matchingpos $pos
					then
						matching[$matchingpos]=$pos 
						matching[$pos]=$matchingpos 
					fi
				else
					levelpos[$pos]=-1 
				fi ;;
		esac
	done
	for pos in ${(k)levelpos}
	do
		if (( $+matching[$pos] ))
		then
			if (( bracket_color_size ))
			then
				_zsh_highlight_add_highlight $((pos - 1)) $pos bracket-level-$(( (levelpos[$pos] - 1) % bracket_color_size + 1 ))
			fi
		else
			_zsh_highlight_add_highlight $((pos - 1)) $pos bracket-error
		fi
	done
	if [[ $WIDGET != zle-line-finish ]]
	then
		pos=$((CURSOR + 1)) 
		if (( $+levelpos[$pos] )) && (( $+matching[$pos] ))
		then
			local -i otherpos=$matching[$pos] 
			_zsh_highlight_add_highlight $((otherpos - 1)) $otherpos cursor-matchingbracket
		fi
	fi
}
_zsh_highlight_highlighter_brackets_predicate () {
	[[ $WIDGET == zle-line-finish ]] || _zsh_highlight_cursor_moved || _zsh_highlight_buffer_modified
}
_zsh_highlight_highlighter_cursor_paint () {
	[[ $WIDGET == zle-line-finish ]] && return
	_zsh_highlight_add_highlight $CURSOR $(( $CURSOR + 1 )) cursor
}
_zsh_highlight_highlighter_cursor_predicate () {
	[[ $WIDGET == zle-line-finish ]] || _zsh_highlight_cursor_moved
}
_zsh_highlight_highlighter_line_paint () {
	_zsh_highlight_add_highlight 0 $#BUFFER line
}
_zsh_highlight_highlighter_line_predicate () {
	_zsh_highlight_buffer_modified
}
_zsh_highlight_highlighter_main_paint () {
	setopt localoptions extendedglob
	if [[ $CONTEXT == (select|vared) ]]
	then
		return
	fi
	typeset -a ZSH_HIGHLIGHT_TOKENS_COMMANDSEPARATOR
	typeset -a ZSH_HIGHLIGHT_TOKENS_CONTROL_FLOW
	local -a options_to_set reply
	local REPLY
	local flags_with_argument
	local flags_sans_argument
	local flags_solo
	local -A precommand_options
	precommand_options=('-' '' 'builtin' '' 'command' :pvV 'exec' a:cl 'noglob' '' 'doas' aCu:Lns 'nice' n: 'pkexec' '' 'sudo' Cgprtu:AEHPSbilns:eKkVv 'stdbuf' ioe: 'eatmydata' '' 'catchsegv' '' 'nohup' '' 'setsid' :wc 'env' u:i 'ionice' cn:t:pPu 'strace' IbeaosXPpEuOS:ACdfhikqrtTvVxyDc 'proxychains' f:q 'torsocks' idq:upaP 'torify' idq:upaP 'ssh-agent' aEPt:csDd:k 'tabbed' gnprtTuU:cdfhs:v 'chronic' :ev 'ifne' :n 'grc' :se 'cpulimit' elp:ivz 'ktrace' fgpt:aBCcdiT) 
	if [[ $zsyh_user_options[ignorebraces] == on || ${zsyh_user_options[ignoreclosebraces]:-off} == on ]]
	then
		local right_brace_is_recognised_everywhere=false 
	else
		local right_brace_is_recognised_everywhere=true 
	fi
	if [[ $zsyh_user_options[pathdirs] == on ]]
	then
		options_to_set+=(PATH_DIRS) 
	fi
	ZSH_HIGHLIGHT_TOKENS_COMMANDSEPARATOR=('|' '||' ';' '&' '&&' $'\n' '|&' '&!' '&|') 
	ZSH_HIGHLIGHT_TOKENS_CONTROL_FLOW=($'\x7b' $'\x28' '()' 'while' 'until' 'if' 'then' 'elif' 'else' 'do' 'time' 'coproc' '!') 
	if (( $+X_ZSH_HIGHLIGHT_DIRS_BLACKLIST ))
	then
		print 'zsh-syntax-highlighting: X_ZSH_HIGHLIGHT_DIRS_BLACKLIST is deprecated. Please use ZSH_HIGHLIGHT_DIRS_BLACKLIST.' >&2
		ZSH_HIGHLIGHT_DIRS_BLACKLIST=($X_ZSH_HIGHLIGHT_DIRS_BLACKLIST) 
		unset X_ZSH_HIGHLIGHT_DIRS_BLACKLIST
	fi
	_zsh_highlight_main_highlighter_highlight_list -$#PREBUFFER '' 1 "$PREBUFFER$BUFFER"
	local start end_ style
	for start end_ style in $reply
	do
		(( start >= end_ )) && {
			print -r -- "zsh-syntax-highlighting: BUG: _zsh_highlight_highlighter_main_paint: start($start) >= end($end_)" >&2
			return
		}
		(( end_ <= 0 )) && continue
		(( start < 0 )) && start=0 
		_zsh_highlight_main_calculate_fallback $style
		_zsh_highlight_add_highlight $start $end_ $reply
	done
}
_zsh_highlight_highlighter_main_predicate () {
	[[ $WIDGET == zle-line-finish ]] || _zsh_highlight_buffer_modified
}
_zsh_highlight_highlighter_pattern_paint () {
	setopt localoptions extendedglob
	local pattern
	for pattern in ${(k)ZSH_HIGHLIGHT_PATTERNS}
	do
		_zsh_highlight_pattern_highlighter_loop "$BUFFER" "$pattern"
	done
}
_zsh_highlight_highlighter_pattern_predicate () {
	_zsh_highlight_buffer_modified
}
_zsh_highlight_highlighter_regexp_paint () {
	setopt localoptions extendedglob
	local pattern
	for pattern in ${(k)ZSH_HIGHLIGHT_REGEXP}
	do
		_zsh_highlight_regexp_highlighter_loop "$BUFFER" "$pattern"
	done
}
_zsh_highlight_highlighter_regexp_predicate () {
	_zsh_highlight_buffer_modified
}
_zsh_highlight_highlighter_root_paint () {
	if (( EUID == 0 ))
	then
		_zsh_highlight_add_highlight 0 $#BUFFER root
	fi
}
_zsh_highlight_highlighter_root_predicate () {
	_zsh_highlight_buffer_modified
}
_zsh_highlight_load_highlighters () {
	setopt localoptions noksharrays bareglobqual
	[[ -d "$1" ]] || {
		print -r -- "zsh-syntax-highlighting: highlighters directory ${(qq)1} not found." >&2
		return 1
	}
	local highlighter highlighter_dir
	for highlighter_dir in $1/*/(/)
	do
		highlighter="${highlighter_dir:t}" 
		[[ -f "$highlighter_dir${highlighter}-highlighter.zsh" ]] && . "$highlighter_dir${highlighter}-highlighter.zsh"
		if type "_zsh_highlight_highlighter_${highlighter}_paint" &> /dev/null && type "_zsh_highlight_highlighter_${highlighter}_predicate" &> /dev/null
		then
			
		elif type "_zsh_highlight_${highlighter}_highlighter" &> /dev/null && type "_zsh_highlight_${highlighter}_highlighter_predicate" &> /dev/null
		then
			if false
			then
				print -r -- "zsh-syntax-highlighting: warning: ${(qq)highlighter} highlighter uses deprecated entry point names; please ask its maintainer to update it: https://github.com/zsh-users/zsh-syntax-highlighting/issues/329" >&2
			fi
			eval "_zsh_highlight_highlighter_${(q)highlighter}_paint() { _zsh_highlight_${(q)highlighter}_highlighter \"\$@\" }"
			eval "_zsh_highlight_highlighter_${(q)highlighter}_predicate() { _zsh_highlight_${(q)highlighter}_highlighter_predicate \"\$@\" }"
		else
			print -r -- "zsh-syntax-highlighting: ${(qq)highlighter} highlighter should define both required functions '_zsh_highlight_highlighter_${highlighter}_paint' and '_zsh_highlight_highlighter_${highlighter}_predicate' in ${(qq):-"$highlighter_dir${highlighter}-highlighter.zsh"}." >&2
		fi
	done
}
_zsh_highlight_main__is_global_alias () {
	if zmodload -e zsh/parameter
	then
		(( ${+galiases[$arg]} ))
	elif [[ $arg == '='* ]]
	then
		return 1
	else
		alias -L -g -- "$1" > /dev/null
	fi
}
_zsh_highlight_main__is_redirection () {
	[[ ${1#[0-9]} == (\<|\<\>|(\>|\>\>)(|\|)|\<\<(|-)|\<\<\<|\<\&|\&\<|(\>|\>\>)\&(|\|)|\&(\>|\>\>)(|\||\!)) ]]
}
_zsh_highlight_main__is_runnable () {
	if _zsh_highlight_main__type "$1"
	then
		[[ $REPLY != none ]]
	else
		return 2
	fi
}
_zsh_highlight_main__precmd_hook () {
	setopt localoptions
	if eval '[[ -o warnnestedvar ]]' 2> /dev/null
	then
		unsetopt warnnestedvar
	fi
	_zsh_highlight_main__command_type_cache=() 
}
_zsh_highlight_main__resolve_alias () {
	if zmodload -e zsh/parameter
	then
		REPLY=${aliases[$arg]} 
	else
		REPLY="${"$(alias -- $arg)"#*=}" 
	fi
}
_zsh_highlight_main__stack_pop () {
	if [[ $braces_stack[1] == $1 ]]
	then
		braces_stack=${braces_stack:1} 
		if (( $+2 ))
		then
			style=$2 
		fi
		return 0
	else
		style=unknown-token 
		return 1
	fi
}
_zsh_highlight_main__type () {
	integer -r aliases_allowed=${2-1} 
	integer may_cache=1 
	if (( $+_zsh_highlight_main__command_type_cache ))
	then
		REPLY=$_zsh_highlight_main__command_type_cache[(e)$1] 
		if [[ -n "$REPLY" ]]
		then
			return
		fi
	fi
	if (( $#options_to_set ))
	then
		setopt localoptions $options_to_set
	fi
	unset REPLY
	if zmodload -e zsh/parameter
	then
		if (( $+aliases[(e)$1] ))
		then
			may_cache=0 
		fi
		if (( ${+galiases[(e)$1]} )) && (( aliases_allowed ))
		then
			REPLY='global alias' 
		elif (( $+aliases[(e)$1] )) && (( aliases_allowed ))
		then
			REPLY=alias 
		elif [[ $1 == *.* && -n ${1%.*} ]] && (( $+saliases[(e)${1##*.}] ))
		then
			REPLY='suffix alias' 
		elif (( $reswords[(Ie)$1] ))
		then
			REPLY=reserved 
		elif (( $+functions[(e)$1] ))
		then
			REPLY=function 
		elif (( $+builtins[(e)$1] ))
		then
			REPLY=builtin 
		elif (( $+commands[(e)$1] ))
		then
			REPLY=command 
		elif {
				[[ $1 != */* ]] || is-at-least 5.3
			} && ! (
				builtin type -w -- "$1"
			) > /dev/null 2>&1
		then
			REPLY=none 
		fi
	fi
	if ! (( $+REPLY ))
	then
		REPLY="${$(:; (( aliases_allowed )) || unalias -- "$1" 2>/dev/null; LC_ALL=C builtin type -w -- "$1" 2>/dev/null)##*: }" 
		if [[ $REPLY == 'alias' ]]
		then
			may_cache=0 
		fi
	fi
	if (( may_cache )) && (( $+_zsh_highlight_main__command_type_cache ))
	then
		_zsh_highlight_main__command_type_cache[(e)$1]=$REPLY 
	fi
	[[ -n $REPLY ]]
	return $?
}
_zsh_highlight_main_add_many_region_highlights () {
	for 1 2 3
	do
		_zsh_highlight_main_add_region_highlight $1 $2 $3
	done
}
_zsh_highlight_main_add_region_highlight () {
	integer start=$1 end=$2 
	shift 2
	if (( $#in_alias ))
	then
		[[ $1 == unknown-token ]] && alias_style=unknown-token 
		return
	fi
	if (( in_param ))
	then
		if [[ $1 == unknown-token ]]
		then
			param_style=unknown-token 
		fi
		if [[ -n $param_style ]]
		then
			return
		fi
		param_style=$1 
		return
	fi
	(( start += buf_offset ))
	(( end += buf_offset ))
	list_highlights+=($start $end $1) 
}
_zsh_highlight_main_calculate_fallback () {
	local -A fallback_of
	fallback_of=(alias arg0 suffix-alias arg0 global-alias dollar-double-quoted-argument builtin arg0 function arg0 command arg0 precommand arg0 hashed-command arg0 autodirectory arg0 arg0_\* arg0 path_prefix path path_pathseparator path path_prefix_pathseparator path_prefix single-quoted-argument{-unclosed,} double-quoted-argument{-unclosed,} dollar-quoted-argument{-unclosed,} back-quoted-argument{-unclosed,} command-substitution{-quoted,,-unquoted,} command-substitution-delimiter{-quoted,,-unquoted,} command-substitution{-delimiter,} process-substitution{-delimiter,} back-quoted-argument{-delimiter,}) 
	local needle=$1 value 
	reply=($1) 
	while [[ -n ${value::=$fallback_of[(k)$needle]} ]]
	do
		unset "fallback_of[$needle]"
		reply+=($value) 
		needle=$value 
	done
}
_zsh_highlight_main_highlighter__try_expand_parameter () {
	local arg="$1" 
	unset reply
	{
		{
			local -a match mbegin mend
			local MATCH
			integer MBEGIN MEND
			local parameter_name
			local -a words
			if [[ $arg[1] != '$' ]]
			then
				return 1
			fi
			if [[ ${arg[2]} == '{' ]] && [[ ${arg[-1]} == '}' ]]
			then
				parameter_name=${${arg:2}%?} 
			else
				parameter_name=${arg:1} 
			fi
			if [[ $res == none ]] && [[ ${parameter_name} =~ ^${~parameter_name_pattern}$ ]] && [[ ${(tP)MATCH} != *special* ]]
			then
				case ${(tP)MATCH} in
					(*array*|*assoc*) words=(${(P)MATCH})  ;;
					("") words=()  ;;
					(*) if [[ $zsyh_user_options[shwordsplit] == on ]]
						then
							words=(${(P)=MATCH}) 
						else
							words=(${(P)MATCH}) 
						fi ;;
				esac
				reply=("${words[@]}") 
			else
				return 1
			fi
		}
	}
}
_zsh_highlight_main_highlighter_check_assign () {
	setopt localoptions extended_glob
	[[ $arg == [[:alpha:]_][[:alnum:]_]#(|\[*\])(|[+])=* ]] || [[ $arg == [0-9]##(|[+])=* ]]
}
_zsh_highlight_main_highlighter_check_path () {
	_zsh_highlight_main_highlighter_expand_path "$1"
	local expanded_path="$REPLY" tmp_path 
	integer in_command_position=$2 
	if [[ $zsyh_user_options[autocd] == on ]]
	then
		integer autocd=1 
	else
		integer autocd=0 
	fi
	if (( in_command_position ))
	then
		REPLY=arg0 
	else
		REPLY=path 
	fi
	if [[ ${1[1]} == '=' && $1 == ??* && ${1[2]} != $'\x28' && $zsyh_user_options[equals] == 'on' && $expanded_path[1] != '/' ]]
	then
		REPLY=unknown-token 
		return 0
	fi
	[[ -z $expanded_path ]] && return 1
	if [[ $expanded_path[1] == / ]]
	then
		tmp_path=$expanded_path 
	else
		tmp_path=$PWD/$expanded_path 
	fi
	tmp_path=$tmp_path:a 
	while [[ $tmp_path != / ]]
	do
		[[ -n ${(M)ZSH_HIGHLIGHT_DIRS_BLACKLIST:#$tmp_path} ]] && return 1
		tmp_path=$tmp_path:h 
	done
	if (( in_command_position ))
	then
		if [[ -x $expanded_path ]]
		then
			if (( autocd ))
			then
				if [[ -d $expanded_path ]]
				then
					REPLY=autodirectory 
				fi
				return 0
			elif [[ ! -d $expanded_path ]]
			then
				return 0
			fi
		fi
	else
		if [[ -L $expanded_path || -e $expanded_path ]]
		then
			return 0
		fi
	fi
	if [[ $expanded_path != /* ]] && (( autocd || ! in_command_position ))
	then
		local cdpath_dir
		for cdpath_dir in $cdpath
		do
			if [[ -d "$cdpath_dir/$expanded_path" && -x "$cdpath_dir/$expanded_path" ]]
			then
				if (( in_command_position && autocd ))
				then
					REPLY=autodirectory 
				fi
				return 0
			fi
		done
	fi
	[[ ! -d ${expanded_path:h} ]] && return 1
	if (( has_end && (len == end_pos) )) && (( ! $#in_alias )) && [[ $WIDGET != zle-line-finish ]]
	then
		local -a tmp
		if (( in_command_position ))
		then
			tmp=(${expanded_path}*(N-*,N-/)) 
		else
			tmp=(${expanded_path}*(N)) 
		fi
		(( ${+tmp[1]} )) && REPLY=path_prefix  && return 0
	fi
	return 1
}
_zsh_highlight_main_highlighter_expand_path () {
	(( $# == 1 )) || print -r -- "zsh-syntax-highlighting: BUG: _zsh_highlight_main_highlighter_expand_path: called without argument" >&2
	setopt localoptions nonomatch
	unset REPLY
	: ${REPLY:=${(Q)${~1}}}
}
_zsh_highlight_main_highlighter_highlight_argument () {
	local base_style=default i=$1 option_eligible=${2:-1} path_eligible=1 ret start style 
	local -a highlights
	local -a match mbegin mend
	local MATCH
	integer MBEGIN MEND
	case "$arg[i]" in
		('%') if [[ $arg[i+1] == '?' ]]
			then
				(( i += 2 ))
			fi ;;
		('-') if (( option_eligible ))
			then
				if [[ $arg[i+1] == - ]]
				then
					base_style=double-hyphen-option 
				else
					base_style=single-hyphen-option 
				fi
				path_eligible=0 
			fi ;;
		('=') if [[ $arg[i+1] == $'\x28' ]]
			then
				(( i += 2 ))
				_zsh_highlight_main_highlighter_highlight_list $(( start_pos + i - 1 )) S $has_end $arg[i,-1]
				ret=$? 
				(( i += REPLY ))
				highlights+=($(( start_pos + $1 - 1 )) $(( start_pos + i )) process-substitution $(( start_pos + $1 - 1 )) $(( start_pos + $1 + 1 )) process-substitution-delimiter $reply) 
				if (( ret == 0 ))
				then
					highlights+=($(( start_pos + i - 1 )) $(( start_pos + i )) process-substitution-delimiter) 
				fi
			fi ;;
	esac
	(( --i ))
	while (( ++i <= $#arg ))
	do
		i=${arg[(ib.i.)[\\\'\"\`\$\<\>\*\?]]} 
		case "$arg[$i]" in
			("") break ;;
			("\\") (( i += 1 ))
				continue ;;
			("'") _zsh_highlight_main_highlighter_highlight_single_quote $i
				(( i = REPLY ))
				highlights+=($reply)  ;;
			('"') _zsh_highlight_main_highlighter_highlight_double_quote $i
				(( i = REPLY ))
				highlights+=($reply)  ;;
			('`') _zsh_highlight_main_highlighter_highlight_backtick $i
				(( i = REPLY ))
				highlights+=($reply)  ;;
			('$') if [[ $arg[i+1] != "'" ]]
				then
					path_eligible=0 
				fi
				if [[ $arg[i+1] == "'" ]]
				then
					_zsh_highlight_main_highlighter_highlight_dollar_quote $i
					(( i = REPLY ))
					highlights+=($reply) 
					continue
				elif [[ $arg[i+1] == $'\x28' ]]
				then
					if [[ $arg[i+2] == $'\x28' ]] && _zsh_highlight_main_highlighter_highlight_arithmetic $i
					then
						(( i = REPLY ))
						highlights+=($reply) 
						continue
					fi
					start=$i 
					(( i += 2 ))
					_zsh_highlight_main_highlighter_highlight_list $(( start_pos + i - 1 )) S $has_end $arg[i,-1]
					ret=$? 
					(( i += REPLY ))
					highlights+=($(( start_pos + start - 1)) $(( start_pos + i )) command-substitution-unquoted $(( start_pos + start - 1)) $(( start_pos + start + 1)) command-substitution-delimiter-unquoted $reply) 
					if (( ret == 0 ))
					then
						highlights+=($(( start_pos + i - 1)) $(( start_pos + i )) command-substitution-delimiter-unquoted) 
					fi
					continue
				fi
				while [[ $arg[i+1] == [=~#+'^'] ]]
				do
					(( i += 1 ))
				done
				if [[ $arg[i+1] == [*@#?$!-] ]]
				then
					(( i += 1 ))
				fi ;;
			([\<\>]) if [[ $arg[i+1] == $'\x28' ]]
				then
					start=$i 
					(( i += 2 ))
					_zsh_highlight_main_highlighter_highlight_list $(( start_pos + i - 1 )) S $has_end $arg[i,-1]
					ret=$? 
					(( i += REPLY ))
					highlights+=($(( start_pos + start - 1)) $(( start_pos + i )) process-substitution $(( start_pos + start - 1)) $(( start_pos + start + 1 )) process-substitution-delimiter $reply) 
					if (( ret == 0 ))
					then
						highlights+=($(( start_pos + i - 1)) $(( start_pos + i )) process-substitution-delimiter) 
					fi
					continue
				fi ;|
			(*) if $highlight_glob && [[ $zsyh_user_options[multios] == on || $in_redirection -eq 0 ]] && [[ ${arg[$i]} =~ ^[*?] || ${arg:$i-1} =~ ^\<[0-9]*-[0-9]*\> ]]
				then
					highlights+=($(( start_pos + i - 1 )) $(( start_pos + i + $#MATCH - 1)) globbing) 
					(( i += $#MATCH - 1 ))
					path_eligible=0 
				else
					continue
				fi ;;
		esac
	done
	if (( path_eligible ))
	then
		if (( in_redirection )) && [[ $last_arg == *['<>']['&'] && $arg[$1,-1] == (<0->|p|-) ]]
		then
			if [[ $arg[$1,-1] == (p|-) ]]
			then
				base_style=redirection 
			else
				base_style=numeric-fd 
			fi
		elif _zsh_highlight_main_highlighter_check_path $arg[$1,-1] 0
		then
			base_style=$REPLY 
			_zsh_highlight_main_highlighter_highlight_path_separators $base_style
			highlights+=($reply) 
		fi
	fi
	highlights=($(( start_pos + $1 - 1 )) $end_pos $base_style $highlights) 
	_zsh_highlight_main_add_many_region_highlights $highlights
}
_zsh_highlight_main_highlighter_highlight_arithmetic () {
	local -a saved_reply
	local style
	integer i j k paren_depth ret
	reply=() 
	for ((i = $1 + 3 ; i <= end_pos - start_pos ; i += 1 )) do
		(( j = i + start_pos - 1 ))
		(( k = j + 1 ))
		case "$arg[$i]" in
			([\'\"\\@{}]) style=unknown-token  ;;
			('(') (( paren_depth++ ))
				continue ;;
			(')') if (( paren_depth ))
				then
					(( paren_depth-- ))
					continue
				fi
				[[ $arg[i+1] == ')' ]] && {
					(( i++ ))
					break
				}
				(( has_end && (len == k) )) && break
				return 1 ;;
			('`') saved_reply=($reply) 
				_zsh_highlight_main_highlighter_highlight_backtick $i
				(( i = REPLY ))
				reply=($saved_reply $reply) 
				continue ;;
			('$') if [[ $arg[i+1] == $'\x28' ]]
				then
					saved_reply=($reply) 
					if [[ $arg[i+2] == $'\x28' ]] && _zsh_highlight_main_highlighter_highlight_arithmetic $i
					then
						(( i = REPLY ))
						reply=($saved_reply $reply) 
						continue
					fi
					(( i += 2 ))
					_zsh_highlight_main_highlighter_highlight_list $(( start_pos + i - 1 )) S $has_end $arg[i,end_pos]
					ret=$? 
					(( i += REPLY ))
					reply=($saved_reply $j $(( start_pos + i )) command-substitution-quoted $j $(( j + 2 )) command-substitution-delimiter-quoted $reply) 
					if (( ret == 0 ))
					then
						reply+=($(( start_pos + i - 1 )) $(( start_pos + i )) command-substitution-delimiter) 
					fi
					continue
				else
					continue
				fi ;;
			($histchars[1]) if [[ $arg[i+1] != ('='|$'\x28'|$'\x7b'|[[:blank:]]) ]]
				then
					style=history-expansion 
				else
					continue
				fi ;;
			(*) continue ;;
		esac
		reply+=($j $k $style) 
	done
	if [[ $arg[i] != ')' ]]
	then
		(( i-- ))
	fi
	style=arithmetic-expansion 
	reply=($(( start_pos + $1 - 1)) $(( start_pos + i )) arithmetic-expansion $reply) 
	REPLY=$i 
}
_zsh_highlight_main_highlighter_highlight_backtick () {
	local buf highlight style=back-quoted-argument-unclosed style_end 
	local -i arg1=$1 end_ i=$1 last offset=0 start subshell_has_end=0 
	local -a highlight_zone highlights offsets
	reply=() 
	last=$(( arg1 + 1 )) 
	while i=$arg[(ib:i+1:)[\\\\\`]] 
	do
		if (( i > $#arg ))
		then
			buf=$buf$arg[last,i] 
			offsets[i-arg1-offset]='' 
			(( i-- ))
			subshell_has_end=$(( has_end && (start_pos + i == len) )) 
			break
		fi
		if [[ $arg[i] == '\' ]]
		then
			(( i++ ))
			if [[ $arg[i] == ('$'|'`'|'\') ]]
			then
				buf=$buf$arg[last,i-2] 
				(( offset++ ))
				offsets[i-arg1-offset]=$offset 
			else
				buf=$buf$arg[last,i-1] 
			fi
		else
			style=back-quoted-argument 
			style_end=back-quoted-argument-delimiter 
			buf=$buf$arg[last,i-1] 
			offsets[i-arg1-offset]='' 
			break
		fi
		last=$i 
	done
	_zsh_highlight_main_highlighter_highlight_list 0 '' $subshell_has_end $buf
	for start end_ highlight in $reply
	do
		start=$(( start_pos + arg1 + start + offsets[(Rb:start:)?*] )) 
		end_=$(( start_pos + arg1 + end_ + offsets[(Rb:end_:)?*] )) 
		highlights+=($start $end_ $highlight) 
		if [[ $highlight == back-quoted-argument-unclosed && $style == back-quoted-argument ]]
		then
			style_end=unknown-token 
		fi
	done
	reply=($(( start_pos + arg1 - 1 )) $(( start_pos + i )) $style $(( start_pos + arg1 - 1 )) $(( start_pos + arg1 )) back-quoted-argument-delimiter $highlights) 
	if (( $#style_end ))
	then
		reply+=($(( start_pos + i - 1)) $(( start_pos + i )) $style_end) 
	fi
	REPLY=$i 
}
_zsh_highlight_main_highlighter_highlight_dollar_quote () {
	local -a match mbegin mend
	local MATCH
	integer MBEGIN MEND
	local i j k style
	local AA
	integer c
	reply=() 
	for ((i = $1 + 2 ; i <= $#arg ; i += 1 )) do
		(( j = i + start_pos - 1 ))
		(( k = j + 1 ))
		case "$arg[$i]" in
			("'") break ;;
			("\\") style=back-dollar-quoted-argument 
				for ((c = i + 1 ; c <= $#arg ; c += 1 )) do
					[[ "$arg[$c]" != ([0-9xXuUa-fA-F]) ]] && break
				done
				AA=$arg[$i+1,$c-1] 
				if [[ "$AA" =~ "^(x|X)[0-9a-fA-F]{1,2}" || "$AA" =~ "^[0-7]{1,3}" || "$AA" =~ "^u[0-9a-fA-F]{1,4}" || "$AA" =~ "^U[0-9a-fA-F]{1,8}" ]]
				then
					(( k += $#MATCH ))
					(( i += $#MATCH ))
				else
					if (( $#arg > $i+1 )) && [[ $arg[$i+1] == [xXuU] ]]
					then
						style=unknown-token 
					fi
					(( k += 1 ))
					(( i += 1 ))
				fi ;;
			(*) continue ;;
		esac
		reply+=($j $k $style) 
	done
	if [[ $arg[i] == "'" ]]
	then
		style=dollar-quoted-argument 
	else
		(( i-- ))
		style=dollar-quoted-argument-unclosed 
	fi
	reply=($(( start_pos + $1 - 1 )) $(( start_pos + i )) $style $reply) 
	REPLY=$i 
}
_zsh_highlight_main_highlighter_highlight_double_quote () {
	local -a breaks match mbegin mend saved_reply
	local MATCH
	integer last_break=$(( start_pos + $1 - 1 )) MBEGIN MEND 
	local i j k ret style
	reply=() 
	for ((i = $1 + 1 ; i <= $#arg ; i += 1 )) do
		(( j = i + start_pos - 1 ))
		(( k = j + 1 ))
		case "$arg[$i]" in
			('"') break ;;
			('`') saved_reply=($reply) 
				_zsh_highlight_main_highlighter_highlight_backtick $i
				(( i = REPLY ))
				reply=($saved_reply $reply) 
				continue ;;
			('$') style=dollar-double-quoted-argument 
				if [[ ${arg:$i} =~ ^([A-Za-z_][A-Za-z0-9_]*|[0-9]+) ]]
				then
					(( k += $#MATCH ))
					(( i += $#MATCH ))
				elif [[ ${arg:$i} =~ ^[{]([A-Za-z_][A-Za-z0-9_]*|[0-9]+)[}] ]]
				then
					(( k += $#MATCH ))
					(( i += $#MATCH ))
				elif [[ $arg[i+1] == '$' ]]
				then
					(( k += 1 ))
					(( i += 1 ))
				elif [[ $arg[i+1] == [-#*@?] ]]
				then
					(( k += 1 ))
					(( i += 1 ))
				elif [[ $arg[i+1] == $'\x28' ]]
				then
					saved_reply=($reply) 
					if [[ $arg[i+2] == $'\x28' ]] && _zsh_highlight_main_highlighter_highlight_arithmetic $i
					then
						(( i = REPLY ))
						reply=($saved_reply $reply) 
						continue
					fi
					breaks+=($last_break $(( start_pos + i - 1 ))) 
					(( i += 2 ))
					_zsh_highlight_main_highlighter_highlight_list $(( start_pos + i - 1 )) S $has_end $arg[i,-1]
					ret=$? 
					(( i += REPLY ))
					last_break=$(( start_pos + i )) 
					reply=($saved_reply $j $(( start_pos + i )) command-substitution-quoted $j $(( j + 2 )) command-substitution-delimiter-quoted $reply) 
					if (( ret == 0 ))
					then
						reply+=($(( start_pos + i - 1 )) $(( start_pos + i )) command-substitution-delimiter-quoted) 
					fi
					continue
				else
					continue
				fi ;;
			("\\") style=back-double-quoted-argument 
				if [[ \\\`\"\$${histchars[1]} == *$arg[$i+1]* ]]
				then
					(( k += 1 ))
					(( i += 1 ))
				else
					continue
				fi ;;
			($histchars[1]) if [[ $arg[i+1] != ('='|$'\x28'|$'\x7b'|[[:blank:]]) ]]
				then
					style=history-expansion 
				else
					continue
				fi ;;
			(*) continue ;;
		esac
		reply+=($j $k $style) 
	done
	if [[ $arg[i] == '"' ]]
	then
		style=double-quoted-argument 
	else
		(( i-- ))
		style=double-quoted-argument-unclosed 
	fi
	(( last_break != start_pos + i )) && breaks+=($last_break $(( start_pos + i ))) 
	saved_reply=($reply) 
	reply=() 
	for 1 2 in $breaks
	do
		(( $1 != $2 )) && reply+=($1 $2 $style) 
	done
	reply+=($saved_reply) 
	REPLY=$i 
}
_zsh_highlight_main_highlighter_highlight_list () {
	integer start_pos end_pos=0 buf_offset=$1 has_end=$3 
	local alias_style param_style last_arg arg buf=$4 highlight_glob=true saw_assignment=false style 
	local in_array_assignment=false 
	integer in_param=0 len=$#buf 
	local -a in_alias match mbegin mend list_highlights
	local -A seen_alias
	readonly parameter_name_pattern='([A-Za-z_][A-Za-z0-9_]*|[0-9]+)' 
	list_highlights=() 
	local braces_stack=$2 
	local this_word next_word=':start::start_of_pipeline:' 
	integer in_redirection
	local proc_buf="$buf" 
	local -a args
	if [[ $zsyh_user_options[interactivecomments] == on ]]
	then
		args=(${(zZ+c+)buf}) 
	else
		args=(${(z)buf}) 
	fi
	if [[ $braces_stack == 'S' ]] && (( $+args[3] && ! $+args[4] )) && [[ $args[3] == $'\x29' ]] && [[ $args[1] == *'<'* ]] && _zsh_highlight_main__is_redirection $args[1]
	then
		highlight_glob=false 
	fi
	while (( $#args ))
	do
		last_arg=$arg 
		arg=$args[1] 
		shift args
		if (( $#in_alias ))
		then
			(( in_alias[1]-- ))
			in_alias=($in_alias[$in_alias[(i)<1->],-1]) 
			if (( $#in_alias == 0 ))
			then
				seen_alias=() 
				_zsh_highlight_main_add_region_highlight $start_pos $end_pos $alias_style
			else
				() {
					local alias_name
					for alias_name in ${(k)seen_alias[(R)<$#in_alias->]}
					do
						seen_alias=("${(@kv)seen_alias[(I)^$alias_name]}") 
					done
				}
			fi
		fi
		if (( in_param ))
		then
			(( in_param-- ))
			if (( in_param == 0 ))
			then
				_zsh_highlight_main_add_region_highlight $start_pos $end_pos $param_style
				param_style="" 
			fi
		fi
		if (( in_redirection == 0 ))
		then
			this_word=$next_word 
			next_word=':regular:' 
		elif (( !in_param ))
		then
			(( --in_redirection ))
		fi
		style=unknown-token 
		if [[ $this_word == *':start:'* ]]
		then
			in_array_assignment=false 
			if [[ $arg == 'noglob' ]]
			then
				highlight_glob=false 
			fi
		fi
		if (( $#in_alias == 0 && in_param == 0 ))
		then
			[[ "$proc_buf" = (#b)(#s)(''([ $'\t']|[\\]$'\n')#)(?|)* ]]
			integer offset="${#match[1]}" 
			(( start_pos = end_pos + offset ))
			(( end_pos = start_pos + $#arg ))
			[[ $arg == ';' && ${match[3]} == $'\n' ]] && arg=$'\n' 
			proc_buf="${proc_buf[offset + $#arg + 1,len]}" 
		fi
		if [[ $zsyh_user_options[interactivecomments] == on && $arg[1] == $histchars[3] ]]
		then
			if [[ $this_word == *(':regular:'|':start:')* ]]
			then
				style=comment 
			else
				style=unknown-token 
			fi
			_zsh_highlight_main_add_region_highlight $start_pos $end_pos $style
			in_redirection=1 
			continue
		fi
		if [[ $this_word == *':start:'* ]] && ! (( in_redirection ))
		then
			_zsh_highlight_main__type "$arg" "$(( ! ${+seen_alias[$arg]} ))"
			local res="$REPLY" 
			if [[ $res == "alias" ]]
			then
				if [[ $arg == ?*=* ]]
				then
					_zsh_highlight_main_add_region_highlight $start_pos $end_pos unknown-token
					continue
				fi
				seen_alias[$arg]=$#in_alias 
				_zsh_highlight_main__resolve_alias $arg
				local -a alias_args
				if [[ $zsyh_user_options[interactivecomments] == on ]]
				then
					alias_args=(${(zZ+c+)REPLY}) 
				else
					alias_args=(${(z)REPLY}) 
				fi
				args=($alias_args $args) 
				if (( $#in_alias == 0 ))
				then
					alias_style=alias 
				else
					(( in_alias[1]-- ))
				fi
				in_alias=($(($#alias_args + 1)) $in_alias) 
				(( in_redirection++ ))
				continue
			else
				_zsh_highlight_main_highlighter_expand_path $arg
				_zsh_highlight_main__type "$REPLY" 0
				res="$REPLY" 
			fi
		fi
		if _zsh_highlight_main__is_redirection $arg
		then
			if (( in_redirection == 1 ))
			then
				_zsh_highlight_main_add_region_highlight $start_pos $end_pos unknown-token
			else
				in_redirection=2 
				_zsh_highlight_main_add_region_highlight $start_pos $end_pos redirection
			fi
			continue
		elif [[ $arg == '{'${~parameter_name_pattern}'}' ]] && _zsh_highlight_main__is_redirection $args[1]
		then
			in_redirection=3 
			_zsh_highlight_main_add_region_highlight $start_pos $end_pos named-fd
			continue
		fi
		if (( ! in_param )) && _zsh_highlight_main_highlighter__try_expand_parameter "$arg"
		then
			() {
				local -a words
				words=("${reply[@]}") 
				if (( $#words == 0 )) && (( ! in_redirection ))
				then
					(( ++in_redirection ))
					_zsh_highlight_main_add_region_highlight $start_pos $end_pos comment
					continue
				else
					(( in_param = 1 + $#words ))
					args=($words $args) 
					arg=$args[1] 
					_zsh_highlight_main__type "$arg" 0
					res=$REPLY 
				fi
			}
		fi
		if (( ! in_redirection ))
		then
			if [[ $this_word == *':sudo_opt:'* ]]
			then
				if [[ -n $flags_with_argument ]] && {
						if [[ -n $flags_sans_argument ]]
						then
							[[ $arg == '-'[$flags_sans_argument]#[$flags_with_argument] ]]
						else
							[[ $arg == '-'[$flags_with_argument] ]]
						fi
					}
				then
					this_word=${this_word//:start:/} 
					next_word=':sudo_arg:' 
				elif [[ -n $flags_with_argument ]] && {
						if [[ -n $flags_sans_argument ]]
						then
							[[ $arg == '-'[$flags_sans_argument]#[$flags_with_argument]* ]]
						else
							[[ $arg == '-'[$flags_with_argument]* ]]
						fi
					}
				then
					this_word=${this_word//:start:/} 
					next_word+=':start:' 
					next_word+=':sudo_opt:' 
				elif [[ -n $flags_sans_argument ]] && [[ $arg == '-'[$flags_sans_argument]# ]]
				then
					this_word=':sudo_opt:' 
					next_word+=':start:' 
					next_word+=':sudo_opt:' 
				elif [[ -n $flags_solo ]] && {
						if [[ -n $flags_sans_argument ]]
						then
							[[ $arg == '-'[$flags_sans_argument]#[$flags_solo]* ]]
						else
							[[ $arg == '-'[$flags_solo]* ]]
						fi
					}
				then
					this_word=':sudo_opt:' 
					next_word=':regular:' 
				elif [[ $arg == '-'* ]]
				then
					this_word=':sudo_opt:' 
					next_word+=':start:' 
					next_word+=':sudo_opt:' 
				else
					this_word=${this_word//:sudo_opt:/} 
				fi
			elif [[ $this_word == *':sudo_arg:'* ]]
			then
				next_word+=':sudo_opt:' 
				next_word+=':start:' 
			fi
		fi
		if [[ -n ${(M)ZSH_HIGHLIGHT_TOKENS_COMMANDSEPARATOR:#"$arg"} ]] && [[ $braces_stack != *T* || $arg != ('||'|'&&') ]]
		then
			if _zsh_highlight_main__stack_pop T || _zsh_highlight_main__stack_pop Q
			then
				style=unknown-token 
			elif $in_array_assignment
			then
				case $arg in
					($'\n') style=commandseparator  ;;
					(';') style=unknown-token  ;;
					(*) style=unknown-token  ;;
				esac
			elif [[ $this_word == *':regular:'* ]]
			then
				style=commandseparator 
			elif [[ $this_word == *':start:'* ]] && [[ $arg == $'\n' ]]
			then
				style=commandseparator 
			elif [[ $this_word == *':start:'* ]] && [[ $arg == ';' ]] && (( $#in_alias ))
			then
				style=commandseparator 
			else
				style=unknown-token 
			fi
			if [[ $arg == $'\n' ]] && $in_array_assignment
			then
				next_word=':regular:' 
			elif [[ $arg == ';' ]] && $in_array_assignment
			then
				next_word=':regular:' 
			else
				next_word=':start:' 
				highlight_glob=true 
				saw_assignment=false 
				() {
					local alias_name
					for alias_name in ${(k)seen_alias[(R)<$#in_alias->]}
					do
						seen_alias=("${(@kv)seen_alias[(I)^$alias_name]}") 
					done
				}
				if [[ $arg != '|' && $arg != '|&' ]]
				then
					next_word+=':start_of_pipeline:' 
				fi
			fi
		elif ! (( in_redirection)) && [[ $this_word == *':always:'* && $arg == 'always' ]]
		then
			style=reserved-word 
			highlight_glob=true 
			saw_assignment=false 
			next_word=':start::start_of_pipeline:' 
		elif ! (( in_redirection)) && [[ $this_word == *':start:'* ]]
		then
			if (( ${+precommand_options[$arg]} )) && _zsh_highlight_main__is_runnable $arg
			then
				style=precommand 
				() {
					set -- "${(@s.:.)precommand_options[$arg]}"
					flags_with_argument=$1 
					flags_sans_argument=$2 
					flags_solo=$3 
				}
				next_word=${next_word//:regular:/} 
				next_word+=':sudo_opt:' 
				next_word+=':start:' 
				if [[ $arg == 'exec' || $arg == 'env' ]]
				then
					next_word+=':regular:' 
				fi
			else
				case $res in
					(reserved) style=reserved-word 
						case $arg in
							(time|nocorrect) next_word=${next_word//:regular:/} 
								next_word+=':start:'  ;;
							($'\x7b') braces_stack='Y'"$braces_stack"  ;;
							($'\x7d') _zsh_highlight_main__stack_pop 'Y' reserved-word
								if [[ $style == reserved-word ]]
								then
									next_word+=':always:' 
								fi ;;
							($'\x5b\x5b') braces_stack='T'"$braces_stack"  ;;
							('do') braces_stack='D'"$braces_stack"  ;;
							('done') _zsh_highlight_main__stack_pop 'D' reserved-word ;;
							('if') braces_stack=':?'"$braces_stack"  ;;
							('then') _zsh_highlight_main__stack_pop ':' reserved-word ;;
							('elif') if [[ ${braces_stack[1]} == '?' ]]
								then
									braces_stack=':'"$braces_stack" 
								else
									style=unknown-token 
								fi ;;
							('else') if [[ ${braces_stack[1]} == '?' ]]
								then
									:
								else
									style=unknown-token 
								fi ;;
							('fi') _zsh_highlight_main__stack_pop '?' ;;
							('foreach') braces_stack='$'"$braces_stack"  ;;
							('end') _zsh_highlight_main__stack_pop '$' reserved-word ;;
							('repeat') in_redirection=2 
								this_word=':start::regular:'  ;;
							('!') if [[ $this_word != *':start_of_pipeline:'* ]]
								then
									style=unknown-token 
								else
									
								fi ;;
						esac
						if $saw_assignment && [[ $style != unknown-token ]]
						then
							style=unknown-token 
						fi ;;
					('suffix alias') style=suffix-alias  ;;
					('global alias') style=global-alias  ;;
					(alias) : ;;
					(builtin) style=builtin 
						[[ $arg == $'\x5b' ]] && braces_stack='Q'"$braces_stack"  ;;
					(function) style=function  ;;
					(command) style=command  ;;
					(hashed) style=hashed-command  ;;
					(none) if (( ! in_param )) && _zsh_highlight_main_highlighter_check_assign
						then
							_zsh_highlight_main_add_region_highlight $start_pos $end_pos assign
							local i=$(( arg[(i)=] + 1 )) 
							saw_assignment=true 
							if [[ $arg[i] == '(' ]]
							then
								in_array_assignment=true 
								_zsh_highlight_main_add_region_highlight start_pos+i-1 start_pos+i reserved-word
							else
								next_word+=':start:' 
								if (( i <= $#arg ))
								then
									() {
										local highlight_glob=false 
										[[ $zsyh_user_options[globassign] == on ]] && highlight_glob=true 
										_zsh_highlight_main_highlighter_highlight_argument $i
									}
								fi
							fi
							continue
						elif (( ! in_param )) && [[ $arg[0,1] = $histchars[0,1] ]] && (( $#arg[0,2] == 2 ))
						then
							style=history-expansion 
						elif (( ! in_param )) && [[ $arg[0,1] == $histchars[2,2] ]]
						then
							style=history-expansion 
						elif (( ! in_param )) && ! $saw_assignment && [[ $arg[1,2] == '((' ]]
						then
							_zsh_highlight_main_add_region_highlight $start_pos $((start_pos + 2)) reserved-word
							if [[ $arg[-2,-1] == '))' ]]
							then
								_zsh_highlight_main_add_region_highlight $((end_pos - 2)) $end_pos reserved-word
							fi
							continue
						elif (( ! in_param )) && [[ $arg == '()' ]]
						then
							style=reserved-word 
						elif (( ! in_param )) && ! $saw_assignment && [[ $arg == $'\x28' ]]
						then
							style=reserved-word 
							braces_stack='R'"$braces_stack" 
						elif (( ! in_param )) && [[ $arg == $'\x29' ]]
						then
							if _zsh_highlight_main__stack_pop 'S'
							then
								REPLY=$start_pos 
								reply=($list_highlights) 
								return 0
							fi
							_zsh_highlight_main__stack_pop 'R' reserved-word
						else
							if _zsh_highlight_main_highlighter_check_path $arg 1
							then
								style=$REPLY 
							else
								style=unknown-token 
							fi
						fi ;;
					(*) _zsh_highlight_main_add_region_highlight $start_pos $end_pos arg0_$res
						continue ;;
				esac
			fi
			if [[ -n ${(M)ZSH_HIGHLIGHT_TOKENS_CONTROL_FLOW:#"$arg"} ]]
			then
				next_word=':start::start_of_pipeline:' 
			fi
		elif _zsh_highlight_main__is_global_alias "$arg"
		then
			style=global-alias 
		else
			case $arg in
				($'\x29') if $in_array_assignment
					then
						_zsh_highlight_main_add_region_highlight $start_pos $end_pos assign
						_zsh_highlight_main_add_region_highlight $start_pos $end_pos reserved-word
						in_array_assignment=false 
						next_word+=':start:' 
						continue
					elif (( in_redirection ))
					then
						style=unknown-token 
					else
						if _zsh_highlight_main__stack_pop 'S'
						then
							REPLY=$start_pos 
							reply=($list_highlights) 
							return 0
						fi
						_zsh_highlight_main__stack_pop 'R' reserved-word
					fi ;;
				($'\x28\x29') if (( in_redirection )) || $in_array_assignment
					then
						style=unknown-token 
					else
						if [[ $zsyh_user_options[multifuncdef] == on ]] || false
						then
							next_word+=':start::start_of_pipeline:' 
						fi
						style=reserved-word 
					fi ;;
				(*) if false
					then
						
					elif [[ $arg = $'\x7d' ]] && $right_brace_is_recognised_everywhere
					then
						if (( in_redirection )) || $in_array_assignment
						then
							style=unknown-token 
						else
							_zsh_highlight_main__stack_pop 'Y' reserved-word
							if [[ $style == reserved-word ]]
							then
								next_word+=':always:' 
							fi
						fi
					elif [[ $arg[0,1] = $histchars[0,1] ]] && (( $#arg[0,2] == 2 ))
					then
						style=history-expansion 
					elif [[ $arg == $'\x5d\x5d' ]] && _zsh_highlight_main__stack_pop 'T' reserved-word
					then
						:
					elif [[ $arg == $'\x5d' ]] && _zsh_highlight_main__stack_pop 'Q' builtin
					then
						:
					else
						_zsh_highlight_main_highlighter_highlight_argument 1 $(( 1 != in_redirection ))
						continue
					fi ;;
			esac
		fi
		_zsh_highlight_main_add_region_highlight $start_pos $end_pos $style
	done
	(( $#in_alias )) && in_alias=() _zsh_highlight_main_add_region_highlight $start_pos $end_pos $alias_style
	(( in_param == 1 )) && in_param=0 _zsh_highlight_main_add_region_highlight $start_pos $end_pos $param_style
	[[ "$proc_buf" = (#b)(#s)(([[:space:]]|\\$'\n')#) ]]
	REPLY=$(( end_pos + ${#match[1]} - 1 )) 
	reply=($list_highlights) 
	return $(( $#braces_stack > 0 ))
}
_zsh_highlight_main_highlighter_highlight_path_separators () {
	local pos style_pathsep
	style_pathsep=$1_pathseparator 
	reply=() 
	[[ -z "$ZSH_HIGHLIGHT_STYLES[$style_pathsep]" || "$ZSH_HIGHLIGHT_STYLES[$1]" == "$ZSH_HIGHLIGHT_STYLES[$style_pathsep]" ]] && return 0
	for ((pos = start_pos; $pos <= end_pos; pos++ )) do
		if [[ $BUFFER[pos] == / ]]
		then
			reply+=($((pos - 1)) $pos $style_pathsep) 
		fi
	done
}
_zsh_highlight_main_highlighter_highlight_single_quote () {
	local arg1=$1 i q=\' style 
	i=$arg[(ib:arg1+1:)$q] 
	reply=() 
	if [[ $zsyh_user_options[rcquotes] == on ]]
	then
		while [[ $arg[i+1] == "'" ]]
		do
			reply+=($(( start_pos + i - 1 )) $(( start_pos + i + 1 )) rc-quote) 
			(( i++ ))
			i=$arg[(ib:i+1:)$q] 
		done
	fi
	if [[ $arg[i] == "'" ]]
	then
		style=single-quoted-argument 
	else
		(( i-- ))
		style=single-quoted-argument-unclosed 
	fi
	reply=($(( start_pos + arg1 - 1 )) $(( start_pos + i )) $style $reply) 
	REPLY=$i 
}
_zsh_highlight_pattern_highlighter_loop () {
	local buf="$1" pat="$2" 
	local -a match mbegin mend
	local MATCH
	integer MBEGIN MEND
	if [[ "$buf" == (#b)(*)(${~pat})* ]]
	then
		region_highlight+=("$((mbegin[2] - 1)) $mend[2] $ZSH_HIGHLIGHT_PATTERNS[$pat], memo=zsh-syntax-highlighting") 
		"$0" "$match[1]" "$pat"
		return $?
	fi
}
_zsh_highlight_preexec_hook () {
	typeset -g _ZSH_HIGHLIGHT_PRIOR_BUFFER= 
	typeset -gi _ZSH_HIGHLIGHT_PRIOR_CURSOR=0 
	typeset -ga _FAST_MAIN_CACHE
	_FAST_MAIN_CACHE=() 
}
_zsh_highlight_regexp_highlighter_loop () {
	local buf="$1" pat="$2" 
	integer OFFSET=0 
	local MATCH
	integer MBEGIN MEND
	local -a match mbegin mend
	while true
	do
		[[ "$buf" =~ "$pat" ]] || return
		region_highlight+=("$((MBEGIN - 1 + OFFSET)) $((MEND + OFFSET)) $ZSH_HIGHLIGHT_REGEXP[$pat], memo=zsh-syntax-highlighting") 
		buf="$buf[$(($MEND+1)),-1]" 
		OFFSET=$((MEND+OFFSET)) 
	done
}
_zsh_highlight_widget_orig-s000-r267-_bash_complete-word () {
	_zsh_highlight_call_widget orig-s000-r267-_bash_complete-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-_bash_list-choices () {
	_zsh_highlight_call_widget orig-s000-r267-_bash_list-choices -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-_complete_debug () {
	_zsh_highlight_call_widget orig-s000-r267-_complete_debug -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-_complete_help () {
	_zsh_highlight_call_widget orig-s000-r267-_complete_help -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-_complete_tag () {
	_zsh_highlight_call_widget orig-s000-r267-_complete_tag -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-_correct_filename () {
	_zsh_highlight_call_widget orig-s000-r267-_correct_filename -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-_correct_word () {
	_zsh_highlight_call_widget orig-s000-r267-_correct_word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-_expand_alias () {
	_zsh_highlight_call_widget orig-s000-r267-_expand_alias -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-_expand_word () {
	_zsh_highlight_call_widget orig-s000-r267-_expand_word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-_history-complete-newer () {
	_zsh_highlight_call_widget orig-s000-r267-_history-complete-newer -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-_history-complete-older () {
	_zsh_highlight_call_widget orig-s000-r267-_history-complete-older -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-_list_expansions () {
	_zsh_highlight_call_widget orig-s000-r267-_list_expansions -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-_most_recent_file () {
	_zsh_highlight_call_widget orig-s000-r267-_most_recent_file -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-_next_tags () {
	_zsh_highlight_call_widget orig-s000-r267-_next_tags -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-_read_comp () {
	_zsh_highlight_call_widget orig-s000-r267-_read_comp -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-accept-and-hold () {
	_zsh_highlight_call_widget .accept-and-hold -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-accept-and-infer-next-history () {
	_zsh_highlight_call_widget .accept-and-infer-next-history -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-accept-and-menu-complete () {
	_zsh_highlight_call_widget .accept-and-menu-complete -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-accept-line () {
	_zsh_highlight_call_widget .accept-line -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-accept-line-and-down-history () {
	_zsh_highlight_call_widget .accept-line-and-down-history -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-accept-search () {
	_zsh_highlight_call_widget .accept-search -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-argument-base () {
	_zsh_highlight_call_widget .argument-base -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-auto-suffix-remove () {
	_zsh_highlight_call_widget .auto-suffix-remove -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-auto-suffix-retain () {
	_zsh_highlight_call_widget .auto-suffix-retain -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-autosuggest-accept () {
	_zsh_highlight_call_widget orig-s000-r267-autosuggest-accept -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-autosuggest-capture-completion () {
	_zsh_highlight_call_widget orig-s000-r267-autosuggest-capture-completion -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-autosuggest-clear () {
	_zsh_highlight_call_widget orig-s000-r267-autosuggest-clear -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-autosuggest-disable () {
	_zsh_highlight_call_widget orig-s000-r267-autosuggest-disable -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-autosuggest-enable () {
	_zsh_highlight_call_widget orig-s000-r267-autosuggest-enable -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-autosuggest-execute () {
	_zsh_highlight_call_widget orig-s000-r267-autosuggest-execute -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-autosuggest-fetch () {
	_zsh_highlight_call_widget orig-s000-r267-autosuggest-fetch -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-autosuggest-suggest () {
	_zsh_highlight_call_widget orig-s000-r267-autosuggest-suggest -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-autosuggest-toggle () {
	_zsh_highlight_call_widget orig-s000-r267-autosuggest-toggle -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-backward-char () {
	_zsh_highlight_call_widget .backward-char -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-backward-delete-char () {
	_zsh_highlight_call_widget .backward-delete-char -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-backward-delete-word () {
	_zsh_highlight_call_widget .backward-delete-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-backward-kill-line () {
	_zsh_highlight_call_widget .backward-kill-line -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-backward-kill-word () {
	_zsh_highlight_call_widget .backward-kill-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-backward-word () {
	_zsh_highlight_call_widget .backward-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-beginning-of-buffer-or-history () {
	_zsh_highlight_call_widget .beginning-of-buffer-or-history -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-beginning-of-history () {
	_zsh_highlight_call_widget .beginning-of-history -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-beginning-of-line () {
	_zsh_highlight_call_widget .beginning-of-line -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-beginning-of-line-hist () {
	_zsh_highlight_call_widget .beginning-of-line-hist -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-bracketed-paste () {
	_zsh_highlight_call_widget orig-s000-r267-bracketed-paste -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-capitalize-word () {
	_zsh_highlight_call_widget .capitalize-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-clear-screen () {
	_zsh_highlight_call_widget .clear-screen -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-complete-word () {
	_zsh_highlight_call_widget orig-s000-r267-complete-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-copy-prev-shell-word () {
	_zsh_highlight_call_widget .copy-prev-shell-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-copy-prev-word () {
	_zsh_highlight_call_widget .copy-prev-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-copy-region-as-kill () {
	_zsh_highlight_call_widget .copy-region-as-kill -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-deactivate-region () {
	_zsh_highlight_call_widget .deactivate-region -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-delete-char () {
	_zsh_highlight_call_widget .delete-char -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-delete-char-or-list () {
	_zsh_highlight_call_widget orig-s000-r267-delete-char-or-list -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-delete-word () {
	_zsh_highlight_call_widget .delete-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-describe-key-briefly () {
	_zsh_highlight_call_widget .describe-key-briefly -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-digit-argument () {
	_zsh_highlight_call_widget .digit-argument -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-down-case-word () {
	_zsh_highlight_call_widget .down-case-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-down-history () {
	_zsh_highlight_call_widget .down-history -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-down-line () {
	_zsh_highlight_call_widget .down-line -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-down-line-or-beginning-search () {
	_zsh_highlight_call_widget orig-s000-r267-down-line-or-beginning-search -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-down-line-or-history () {
	_zsh_highlight_call_widget .down-line-or-history -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-down-line-or-search () {
	_zsh_highlight_call_widget .down-line-or-search -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-edit-command-line () {
	_zsh_highlight_call_widget orig-s000-r267-edit-command-line -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-emacs-backward-word () {
	_zsh_highlight_call_widget .emacs-backward-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-emacs-forward-word () {
	_zsh_highlight_call_widget .emacs-forward-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-end-of-buffer-or-history () {
	_zsh_highlight_call_widget .end-of-buffer-or-history -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-end-of-history () {
	_zsh_highlight_call_widget .end-of-history -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-end-of-line () {
	_zsh_highlight_call_widget .end-of-line -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-end-of-line-hist () {
	_zsh_highlight_call_widget .end-of-line-hist -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-end-of-list () {
	_zsh_highlight_call_widget .end-of-list -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-exchange-point-and-mark () {
	_zsh_highlight_call_widget .exchange-point-and-mark -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-execute-last-named-cmd () {
	_zsh_highlight_call_widget .execute-last-named-cmd -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-execute-named-cmd () {
	_zsh_highlight_call_widget .execute-named-cmd -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-expand-cmd-path () {
	_zsh_highlight_call_widget .expand-cmd-path -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-expand-history () {
	_zsh_highlight_call_widget .expand-history -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-expand-or-complete () {
	_zsh_highlight_call_widget orig-s000-r267-expand-or-complete -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-expand-or-complete-prefix () {
	_zsh_highlight_call_widget orig-s000-r267-expand-or-complete-prefix -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-expand-word () {
	_zsh_highlight_call_widget .expand-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-forward-char () {
	_zsh_highlight_call_widget .forward-char -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-forward-word () {
	_zsh_highlight_call_widget .forward-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-get-line () {
	_zsh_highlight_call_widget .get-line -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-gosmacs-transpose-chars () {
	_zsh_highlight_call_widget .gosmacs-transpose-chars -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-history-beginning-search-backward () {
	_zsh_highlight_call_widget .history-beginning-search-backward -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-history-beginning-search-forward () {
	_zsh_highlight_call_widget .history-beginning-search-forward -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-history-incremental-pattern-search-backward () {
	_zsh_highlight_call_widget .history-incremental-pattern-search-backward -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-history-incremental-pattern-search-forward () {
	_zsh_highlight_call_widget .history-incremental-pattern-search-forward -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-history-incremental-search-backward () {
	_zsh_highlight_call_widget .history-incremental-search-backward -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-history-incremental-search-forward () {
	_zsh_highlight_call_widget .history-incremental-search-forward -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-history-search-backward () {
	_zsh_highlight_call_widget .history-search-backward -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-history-search-forward () {
	_zsh_highlight_call_widget .history-search-forward -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-infer-next-history () {
	_zsh_highlight_call_widget .infer-next-history -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-insert-last-word () {
	_zsh_highlight_call_widget .insert-last-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-kill-buffer () {
	_zsh_highlight_call_widget .kill-buffer -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-kill-line () {
	_zsh_highlight_call_widget .kill-line -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-kill-region () {
	_zsh_highlight_call_widget .kill-region -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-kill-whole-line () {
	_zsh_highlight_call_widget .kill-whole-line -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-kill-word () {
	_zsh_highlight_call_widget .kill-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-list-choices () {
	_zsh_highlight_call_widget orig-s000-r267-list-choices -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-list-expand () {
	_zsh_highlight_call_widget .list-expand -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-magic-space () {
	_zsh_highlight_call_widget .magic-space -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-menu-complete () {
	_zsh_highlight_call_widget orig-s000-r267-menu-complete -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-menu-expand-or-complete () {
	_zsh_highlight_call_widget orig-s000-r267-menu-expand-or-complete -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-menu-select () {
	_zsh_highlight_call_widget .menu-select -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-neg-argument () {
	_zsh_highlight_call_widget .neg-argument -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-overwrite-mode () {
	_zsh_highlight_call_widget .overwrite-mode -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-pound-insert () {
	_zsh_highlight_call_widget .pound-insert -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-push-input () {
	_zsh_highlight_call_widget .push-input -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-push-line () {
	_zsh_highlight_call_widget .push-line -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-push-line-or-edit () {
	_zsh_highlight_call_widget .push-line-or-edit -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-put-replace-selection () {
	_zsh_highlight_call_widget .put-replace-selection -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-quote-line () {
	_zsh_highlight_call_widget .quote-line -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-quote-region () {
	_zsh_highlight_call_widget .quote-region -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-quoted-insert () {
	_zsh_highlight_call_widget .quoted-insert -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-read-command () {
	_zsh_highlight_call_widget .read-command -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-recursive-edit () {
	_zsh_highlight_call_widget .recursive-edit -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-redisplay () {
	_zsh_highlight_call_widget .redisplay -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-redo () {
	_zsh_highlight_call_widget .redo -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-reset-prompt () {
	_zsh_highlight_call_widget .reset-prompt -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-reverse-menu-complete () {
	_zsh_highlight_call_widget orig-s000-r267-reverse-menu-complete -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-select-a-blank-word () {
	_zsh_highlight_call_widget .select-a-blank-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-select-a-shell-word () {
	_zsh_highlight_call_widget .select-a-shell-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-select-a-word () {
	_zsh_highlight_call_widget .select-a-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-select-in-blank-word () {
	_zsh_highlight_call_widget .select-in-blank-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-select-in-shell-word () {
	_zsh_highlight_call_widget .select-in-shell-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-select-in-word () {
	_zsh_highlight_call_widget .select-in-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-self-insert () {
	_zsh_highlight_call_widget orig-s000-r267-self-insert -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-self-insert-unmeta () {
	_zsh_highlight_call_widget .self-insert-unmeta -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-send-break () {
	_zsh_highlight_call_widget .send-break -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-set-mark-command () {
	_zsh_highlight_call_widget .set-mark-command -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-spell-word () {
	_zsh_highlight_call_widget .spell-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-split-undo () {
	_zsh_highlight_call_widget .split-undo -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-transpose-chars () {
	_zsh_highlight_call_widget .transpose-chars -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-transpose-words () {
	_zsh_highlight_call_widget .transpose-words -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-undefined-key () {
	_zsh_highlight_call_widget .undefined-key -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-undo () {
	_zsh_highlight_call_widget .undo -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-universal-argument () {
	_zsh_highlight_call_widget .universal-argument -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-up-case-word () {
	_zsh_highlight_call_widget .up-case-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-up-history () {
	_zsh_highlight_call_widget .up-history -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-up-line () {
	_zsh_highlight_call_widget .up-line -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-up-line-or-beginning-search () {
	_zsh_highlight_call_widget orig-s000-r267-up-line-or-beginning-search -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-up-line-or-history () {
	_zsh_highlight_call_widget .up-line-or-history -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-up-line-or-search () {
	_zsh_highlight_call_widget .up-line-or-search -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-add-eol () {
	_zsh_highlight_call_widget .vi-add-eol -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-add-next () {
	_zsh_highlight_call_widget .vi-add-next -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-backward-blank-word () {
	_zsh_highlight_call_widget .vi-backward-blank-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-backward-blank-word-end () {
	_zsh_highlight_call_widget .vi-backward-blank-word-end -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-backward-char () {
	_zsh_highlight_call_widget .vi-backward-char -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-backward-delete-char () {
	_zsh_highlight_call_widget .vi-backward-delete-char -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-backward-kill-word () {
	_zsh_highlight_call_widget .vi-backward-kill-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-backward-word () {
	_zsh_highlight_call_widget .vi-backward-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-backward-word-end () {
	_zsh_highlight_call_widget .vi-backward-word-end -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-beginning-of-line () {
	_zsh_highlight_call_widget .vi-beginning-of-line -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-caps-lock-panic () {
	_zsh_highlight_call_widget .vi-caps-lock-panic -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-change () {
	_zsh_highlight_call_widget .vi-change -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-change-eol () {
	_zsh_highlight_call_widget .vi-change-eol -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-change-whole-line () {
	_zsh_highlight_call_widget .vi-change-whole-line -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-cmd-mode () {
	_zsh_highlight_call_widget .vi-cmd-mode -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-delete () {
	_zsh_highlight_call_widget .vi-delete -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-delete-char () {
	_zsh_highlight_call_widget .vi-delete-char -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-digit-or-beginning-of-line () {
	_zsh_highlight_call_widget .vi-digit-or-beginning-of-line -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-down-case () {
	_zsh_highlight_call_widget .vi-down-case -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-down-line-or-history () {
	_zsh_highlight_call_widget .vi-down-line-or-history -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-end-of-line () {
	_zsh_highlight_call_widget .vi-end-of-line -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-fetch-history () {
	_zsh_highlight_call_widget .vi-fetch-history -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-find-next-char () {
	_zsh_highlight_call_widget .vi-find-next-char -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-find-next-char-skip () {
	_zsh_highlight_call_widget .vi-find-next-char-skip -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-find-prev-char () {
	_zsh_highlight_call_widget .vi-find-prev-char -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-find-prev-char-skip () {
	_zsh_highlight_call_widget .vi-find-prev-char-skip -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-first-non-blank () {
	_zsh_highlight_call_widget .vi-first-non-blank -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-forward-blank-word () {
	_zsh_highlight_call_widget .vi-forward-blank-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-forward-blank-word-end () {
	_zsh_highlight_call_widget .vi-forward-blank-word-end -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-forward-char () {
	_zsh_highlight_call_widget .vi-forward-char -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-forward-word () {
	_zsh_highlight_call_widget .vi-forward-word -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-forward-word-end () {
	_zsh_highlight_call_widget .vi-forward-word-end -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-goto-column () {
	_zsh_highlight_call_widget .vi-goto-column -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-goto-mark () {
	_zsh_highlight_call_widget .vi-goto-mark -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-goto-mark-line () {
	_zsh_highlight_call_widget .vi-goto-mark-line -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-history-search-backward () {
	_zsh_highlight_call_widget .vi-history-search-backward -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-history-search-forward () {
	_zsh_highlight_call_widget .vi-history-search-forward -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-indent () {
	_zsh_highlight_call_widget .vi-indent -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-insert () {
	_zsh_highlight_call_widget .vi-insert -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-insert-bol () {
	_zsh_highlight_call_widget .vi-insert-bol -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-join () {
	_zsh_highlight_call_widget .vi-join -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-kill-eol () {
	_zsh_highlight_call_widget .vi-kill-eol -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-kill-line () {
	_zsh_highlight_call_widget .vi-kill-line -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-match-bracket () {
	_zsh_highlight_call_widget .vi-match-bracket -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-open-line-above () {
	_zsh_highlight_call_widget .vi-open-line-above -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-open-line-below () {
	_zsh_highlight_call_widget .vi-open-line-below -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-oper-swap-case () {
	_zsh_highlight_call_widget .vi-oper-swap-case -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-pound-insert () {
	_zsh_highlight_call_widget .vi-pound-insert -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-put-after () {
	_zsh_highlight_call_widget .vi-put-after -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-put-before () {
	_zsh_highlight_call_widget .vi-put-before -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-quoted-insert () {
	_zsh_highlight_call_widget .vi-quoted-insert -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-repeat-change () {
	_zsh_highlight_call_widget .vi-repeat-change -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-repeat-find () {
	_zsh_highlight_call_widget .vi-repeat-find -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-repeat-search () {
	_zsh_highlight_call_widget .vi-repeat-search -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-replace () {
	_zsh_highlight_call_widget .vi-replace -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-replace-chars () {
	_zsh_highlight_call_widget .vi-replace-chars -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-rev-repeat-find () {
	_zsh_highlight_call_widget .vi-rev-repeat-find -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-rev-repeat-search () {
	_zsh_highlight_call_widget .vi-rev-repeat-search -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-set-buffer () {
	_zsh_highlight_call_widget .vi-set-buffer -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-set-mark () {
	_zsh_highlight_call_widget .vi-set-mark -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-substitute () {
	_zsh_highlight_call_widget .vi-substitute -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-swap-case () {
	_zsh_highlight_call_widget .vi-swap-case -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-undo-change () {
	_zsh_highlight_call_widget .vi-undo-change -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-unindent () {
	_zsh_highlight_call_widget .vi-unindent -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-up-case () {
	_zsh_highlight_call_widget .vi-up-case -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-up-line-or-history () {
	_zsh_highlight_call_widget .vi-up-line-or-history -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-yank () {
	_zsh_highlight_call_widget .vi-yank -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-yank-eol () {
	_zsh_highlight_call_widget .vi-yank-eol -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-vi-yank-whole-line () {
	_zsh_highlight_call_widget .vi-yank-whole-line -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-visual-line-mode () {
	_zsh_highlight_call_widget .visual-line-mode -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-visual-mode () {
	_zsh_highlight_call_widget .visual-mode -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-what-cursor-position () {
	_zsh_highlight_call_widget .what-cursor-position -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-where-is () {
	_zsh_highlight_call_widget .where-is -- "$@"
}
_zsh_highlight_widget_orig-s000-r267-yank-pop () {
	_zsh_highlight_call_widget .yank-pop -- "$@"
}
_zsh_highlight_widget_zle-isearch-update () {
	:
	_zsh_highlight
}
_zsh_highlight_widget_zle-line-finish () {
	:
	_zsh_highlight
}
_zsocket () {
	# undefined
	builtin autoload -XUz
}
_zstyle () {
	# undefined
	builtin autoload -XUz
}
_ztodo () {
	# undefined
	builtin autoload -XUz
}
_zypper () {
	# undefined
	builtin autoload -XUz
}
add-zle-hook-widget () {
	# undefined
	builtin autoload -XU
}
add-zsh-hook () {
	emulate -L zsh
	local -a hooktypes
	hooktypes=(chpwd precmd preexec periodic zshaddhistory zshexit zsh_directory_name) 
	local usage="Usage: add-zsh-hook hook function\nValid hooks are:\n  $hooktypes" 
	local opt
	local -a autoopts
	integer del list help
	while getopts "dDhLUzk" opt
	do
		case $opt in
			(d) del=1  ;;
			(D) del=2  ;;
			(h) help=1  ;;
			(L) list=1  ;;
			([Uzk]) autoopts+=(-$opt)  ;;
			(*) return 1 ;;
		esac
	done
	shift $(( OPTIND - 1 ))
	if (( list ))
	then
		typeset -mp "(${1:-${(@j:|:)hooktypes}})_functions"
		return $?
	elif (( help || $# != 2 || ${hooktypes[(I)$1]} == 0 ))
	then
		print -u$(( 2 - help )) $usage
		return $(( 1 - help ))
	fi
	local hook="${1}_functions" 
	local fn="$2" 
	if (( del ))
	then
		if (( ${(P)+hook} ))
		then
			if (( del == 2 ))
			then
				set -A $hook ${(P)hook:#${~fn}}
			else
				set -A $hook ${(P)hook:#$fn}
			fi
			if (( ! ${(P)#hook} ))
			then
				unset $hook
			fi
		fi
	else
		if (( ${(P)+hook} ))
		then
			if (( ${${(P)hook}[(I)$fn]} == 0 ))
			then
				typeset -ga $hook
				set -A $hook ${(P)hook} $fn
			fi
		else
			typeset -ga $hook
			set -A $hook $fn
		fi
		autoload $autoopts -- $fn
	fi
}
alias_value () {
	(( $+aliases[$1] )) && echo $aliases[$1]
}
azure_prompt_info () {
	return 1
}
bashcompinit () {
	# undefined
	builtin autoload -XUz
}
bracketed-paste-magic () {
	# undefined
	builtin autoload -XUz
}
bundle_install () {
	if (( ! $+commands[bundle] ))
	then
		echo "Bundler is not installed"
		return 1
	fi
	if ! _within-bundled-project
	then
		echo "Can't 'bundle install' outside a bundled project"
		return 1
	fi
	autoload -Uz is-at-least
	local bundler_version=$(bundle version | cut -d' ' -f3) 
	if ! is-at-least 1.4.0 "$bundler_version"
	then
		bundle install "$@"
		return $?
	fi
	if [[ "$OSTYPE" = (darwin|freebsd)* ]]
	then
		local cores_num="$(sysctl -n hw.ncpu)" 
	else
		local cores_num="$(nproc)" 
	fi
	BUNDLE_JOBS="$cores_num" bundle install "$@"
}
bundled_annotate () {
	_run-with-bundler "annotate" "$@"
}
bundled_cap () {
	_run-with-bundler "cap" "$@"
}
bundled_capify () {
	_run-with-bundler "capify" "$@"
}
bundled_cucumber () {
	_run-with-bundler "cucumber" "$@"
}
bundled_foodcritic () {
	_run-with-bundler "foodcritic" "$@"
}
bundled_guard () {
	_run-with-bundler "guard" "$@"
}
bundled_hanami () {
	_run-with-bundler "hanami" "$@"
}
bundled_irb () {
	_run-with-bundler "irb" "$@"
}
bundled_jekyll () {
	_run-with-bundler "jekyll" "$@"
}
bundled_kitchen () {
	_run-with-bundler "kitchen" "$@"
}
bundled_knife () {
	_run-with-bundler "knife" "$@"
}
bundled_middleman () {
	_run-with-bundler "middleman" "$@"
}
bundled_nanoc () {
	_run-with-bundler "nanoc" "$@"
}
bundled_pry () {
	_run-with-bundler "pry" "$@"
}
bundled_puma () {
	_run-with-bundler "puma" "$@"
}
bundled_rackup () {
	_run-with-bundler "rackup" "$@"
}
bundled_rainbows () {
	_run-with-bundler "rainbows" "$@"
}
bundled_rake () {
	_run-with-bundler "rake" "$@"
}
bundled_rspec () {
	_run-with-bundler "rspec" "$@"
}
bundled_rubocop () {
	_run-with-bundler "rubocop" "$@"
}
bundled_shotgun () {
	_run-with-bundler "shotgun" "$@"
}
bundled_sidekiq () {
	_run-with-bundler "sidekiq" "$@"
}
bundled_spec () {
	_run-with-bundler "spec" "$@"
}
bundled_spork () {
	_run-with-bundler "spork" "$@"
}
bundled_spring () {
	_run-with-bundler "spring" "$@"
}
bundled_strainer () {
	_run-with-bundler "strainer" "$@"
}
bundled_tailor () {
	_run-with-bundler "tailor" "$@"
}
bundled_taps () {
	_run-with-bundler "taps" "$@"
}
bundled_thin () {
	_run-with-bundler "thin" "$@"
}
bundled_thor () {
	_run-with-bundler "thor" "$@"
}
bundled_unicorn () {
	_run-with-bundler "unicorn" "$@"
}
bundled_unicorn_rails () {
	_run-with-bundler "unicorn_rails" "$@"
}
bzr_prompt_info () {
	local bzr_branch
	bzr_branch=$(bzr nick 2>/dev/null)  || return
	if [[ -n "$bzr_branch" ]]
	then
		local bzr_dirty="" 
		if [[ -n $(bzr status 2>/dev/null) ]]
		then
			bzr_dirty=" %{$fg[red]%}*%{$reset_color%}" 
		fi
		printf "%s%s%s%s" "$ZSH_THEME_SCM_PROMPT_PREFIX" "bzr::${bzr_branch##*:}" "$bzr_dirty" "$ZSH_THEME_GIT_PROMPT_SUFFIX"
	fi
}
chruby_prompt_info () {
	return 1
}
clipcopy () {
	unfunction clipcopy clippaste
	detect-clipboard || true
	"$0" "$@"
}
clippaste () {
	unfunction clipcopy clippaste
	detect-clipboard || true
	"$0" "$@"
}
colors () {
	emulate -L zsh
	typeset -Ag color colour
	color=(00 none 01 bold 02 faint 22 normal 03 italic 23 no-italic 04 underline 24 no-underline 05 blink 25 no-blink 07 reverse 27 no-reverse 08 conceal 28 no-conceal 30 black 40 bg-black 31 red 41 bg-red 32 green 42 bg-green 33 yellow 43 bg-yellow 34 blue 44 bg-blue 35 magenta 45 bg-magenta 36 cyan 46 bg-cyan 37 white 47 bg-white 39 default 49 bg-default) 
	local k
	for k in ${(k)color}
	do
		color[${color[$k]}]=$k 
	done
	for k in ${color[(I)3?]}
	do
		color[fg-${color[$k]}]=$k 
	done
	for k in grey gray
	do
		color[$k]=${color[black]} 
		color[fg-$k]=${color[$k]} 
		color[bg-$k]=${color[bg-black]} 
	done
	colour=(${(kv)color}) 
	local lc=$'\e[' rc=m 
	typeset -Hg reset_color bold_color
	reset_color="$lc${color[none]}$rc" 
	bold_color="$lc${color[bold]}$rc" 
	typeset -AHg fg fg_bold fg_no_bold
	for k in ${(k)color[(I)fg-*]}
	do
		fg[${k#fg-}]="$lc${color[$k]}$rc" 
		fg_bold[${k#fg-}]="$lc${color[bold]};${color[$k]}$rc" 
		fg_no_bold[${k#fg-}]="$lc${color[normal]};${color[$k]}$rc" 
	done
	typeset -AHg bg bg_bold bg_no_bold
	for k in ${(k)color[(I)bg-*]}
	do
		bg[${k#bg-}]="$lc${color[$k]}$rc" 
		bg_bold[${k#bg-}]="$lc${color[bold]};${color[$k]}$rc" 
		bg_no_bold[${k#bg-}]="$lc${color[normal]};${color[$k]}$rc" 
	done
}
compaudit () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/functions/Completion
}
compdef () {
	local opt autol type func delete eval new i ret=0 cmd svc 
	local -a match mbegin mend
	emulate -L zsh
	setopt extendedglob
	if (( ! $# ))
	then
		print -u2 "$0: I need arguments"
		return 1
	fi
	while getopts "anpPkKde" opt
	do
		case "$opt" in
			(a) autol=yes  ;;
			(n) new=yes  ;;
			([pPkK]) if [[ -n "$type" ]]
				then
					print -u2 "$0: type already set to $type"
					return 1
				fi
				if [[ "$opt" = p ]]
				then
					type=pattern 
				elif [[ "$opt" = P ]]
				then
					type=postpattern 
				elif [[ "$opt" = K ]]
				then
					type=widgetkey 
				else
					type=key 
				fi ;;
			(d) delete=yes  ;;
			(e) eval=yes  ;;
		esac
	done
	shift OPTIND-1
	if (( ! $# ))
	then
		print -u2 "$0: I need arguments"
		return 1
	fi
	if [[ -z "$delete" ]]
	then
		if [[ -z "$eval" ]] && [[ "$1" = *\=* ]]
		then
			while (( $# ))
			do
				if [[ "$1" = *\=* ]]
				then
					cmd="${1%%\=*}" 
					svc="${1#*\=}" 
					func="$_comps[${_services[(r)$svc]:-$svc}]" 
					[[ -n ${_services[$svc]} ]] && svc=${_services[$svc]} 
					[[ -z "$func" ]] && func="${${_patcomps[(K)$svc][1]}:-${_postpatcomps[(K)$svc][1]}}" 
					if [[ -n "$func" ]]
					then
						_comps[$cmd]="$func" 
						_services[$cmd]="$svc" 
					else
						print -u2 "$0: unknown command or service: $svc"
						ret=1 
					fi
				else
					print -u2 "$0: invalid argument: $1"
					ret=1 
				fi
				shift
			done
			return ret
		fi
		func="$1" 
		[[ -n "$autol" ]] && autoload -rUz "$func"
		shift
		case "$type" in
			(widgetkey) while [[ -n $1 ]]
				do
					if [[ $# -lt 3 ]]
					then
						print -u2 "$0: compdef -K requires <widget> <comp-widget> <key>"
						return 1
					fi
					[[ $1 = _* ]] || 1="_$1" 
					[[ $2 = .* ]] || 2=".$2" 
					[[ $2 = .menu-select ]] && zmodload -i zsh/complist
					zle -C "$1" "$2" "$func"
					if [[ -n $new ]]
					then
						bindkey "$3" | IFS=$' \t' read -A opt
						[[ $opt[-1] = undefined-key ]] && bindkey "$3" "$1"
					else
						bindkey "$3" "$1"
					fi
					shift 3
				done ;;
			(key) if [[ $# -lt 2 ]]
				then
					print -u2 "$0: missing keys"
					return 1
				fi
				if [[ $1 = .* ]]
				then
					[[ $1 = .menu-select ]] && zmodload -i zsh/complist
					zle -C "$func" "$1" "$func"
				else
					[[ $1 = menu-select ]] && zmodload -i zsh/complist
					zle -C "$func" ".$1" "$func"
				fi
				shift
				for i
				do
					if [[ -n $new ]]
					then
						bindkey "$i" | IFS=$' \t' read -A opt
						[[ $opt[-1] = undefined-key ]] || continue
					fi
					bindkey "$i" "$func"
				done ;;
			(*) while (( $# ))
				do
					if [[ "$1" = -N ]]
					then
						type=normal 
					elif [[ "$1" = -p ]]
					then
						type=pattern 
					elif [[ "$1" = -P ]]
					then
						type=postpattern 
					else
						case "$type" in
							(pattern) if [[ $1 = (#b)(*)=(*) ]]
								then
									_patcomps[$match[1]]="=$match[2]=$func" 
								else
									_patcomps[$1]="$func" 
								fi ;;
							(postpattern) if [[ $1 = (#b)(*)=(*) ]]
								then
									_postpatcomps[$match[1]]="=$match[2]=$func" 
								else
									_postpatcomps[$1]="$func" 
								fi ;;
							(*) if [[ "$1" = *\=* ]]
								then
									cmd="${1%%\=*}" 
									svc=yes 
								else
									cmd="$1" 
									svc= 
								fi
								if [[ -z "$new" || -z "${_comps[$1]}" ]]
								then
									_comps[$cmd]="$func" 
									[[ -n "$svc" ]] && _services[$cmd]="${1#*\=}" 
								fi ;;
						esac
					fi
					shift
				done ;;
		esac
	else
		case "$type" in
			(pattern) unset "_patcomps[$^@]" ;;
			(postpattern) unset "_postpatcomps[$^@]" ;;
			(key) print -u2 "$0: cannot restore key bindings"
				return 1 ;;
			(*) unset "_comps[$^@]" ;;
		esac
	fi
}
compdump () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/functions/Completion
}
compgen () {
	local opts prefix suffix job OPTARG OPTIND ret=1 
	local -a name res results jids
	local -A shortopts
	emulate -L sh
	setopt kshglob noshglob braceexpand nokshautoload
	shortopts=(a alias b builtin c command d directory e export f file g group j job k keyword u user v variable) 
	while getopts "o:A:G:C:F:P:S:W:X:abcdefgjkuv" name
	do
		case $name in
			([abcdefgjkuv]) OPTARG="${shortopts[$name]}"  ;&
			(A) case $OPTARG in
					(alias) results+=("${(k)aliases[@]}")  ;;
					(arrayvar) results+=("${(k@)parameters[(R)array*]}")  ;;
					(binding) results+=("${(k)widgets[@]}")  ;;
					(builtin) results+=("${(k)builtins[@]}" "${(k)dis_builtins[@]}")  ;;
					(command) results+=("${(k)commands[@]}" "${(k)aliases[@]}" "${(k)builtins[@]}" "${(k)functions[@]}" "${(k)reswords[@]}")  ;;
					(directory) setopt bareglobqual
						results+=(${IPREFIX}${PREFIX}*${SUFFIX}${ISUFFIX}(N-/)) 
						setopt nobareglobqual ;;
					(disabled) results+=("${(k)dis_builtins[@]}")  ;;
					(enabled) results+=("${(k)builtins[@]}")  ;;
					(export) results+=("${(k)parameters[(R)*export*]}")  ;;
					(file) setopt bareglobqual
						results+=(${IPREFIX}${PREFIX}*${SUFFIX}${ISUFFIX}(N)) 
						setopt nobareglobqual ;;
					(function) results+=("${(k)functions[@]}")  ;;
					(group) emulate zsh
						_groups -U -O res
						emulate sh
						setopt kshglob noshglob braceexpand
						results+=("${res[@]}")  ;;
					(hostname) emulate zsh
						_hosts -U -O res
						emulate sh
						setopt kshglob noshglob braceexpand
						results+=("${res[@]}")  ;;
					(job) results+=("${savejobtexts[@]%% *}")  ;;
					(keyword) results+=("${(k)reswords[@]}")  ;;
					(running) jids=("${(@k)savejobstates[(R)running*]}") 
						for job in "${jids[@]}"
						do
							results+=(${savejobtexts[$job]%% *}) 
						done ;;
					(stopped) jids=("${(@k)savejobstates[(R)suspended*]}") 
						for job in "${jids[@]}"
						do
							results+=(${savejobtexts[$job]%% *}) 
						done ;;
					(setopt | shopt) results+=("${(k)options[@]}")  ;;
					(signal) results+=("SIG${^signals[@]}")  ;;
					(user) results+=("${(k)userdirs[@]}")  ;;
					(variable) results+=("${(k)parameters[@]}")  ;;
					(helptopic)  ;;
				esac ;;
			(F) COMPREPLY=() 
				local -a args
				args=("${words[0]}" "${@[-1]}" "${words[CURRENT-2]}") 
				() {
					typeset -h words
					$OPTARG "${args[@]}"
				}
				results+=("${COMPREPLY[@]}")  ;;
			(G) setopt nullglob
				results+=(${~OPTARG}) 
				unsetopt nullglob ;;
			(W) results+=(${(Q)~=OPTARG})  ;;
			(C) results+=($(eval $OPTARG))  ;;
			(P) prefix="$OPTARG"  ;;
			(S) suffix="$OPTARG"  ;;
			(X) if [[ ${OPTARG[0]} = '!' ]]
				then
					results=("${(M)results[@]:#${OPTARG#?}}") 
				else
					results=("${results[@]:#$OPTARG}") 
				fi ;;
		esac
	done
	print -l -r -- "$prefix${^results[@]}$suffix"
}
compinit () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/functions/Completion
}
compinstall () {
	# undefined
	builtin autoload -XUz /usr/share/zsh/functions/Completion
}
complete () {
	emulate -L zsh
	local args void cmd print remove
	args=("$@") 
	zparseopts -D -a void o: A: G: W: C: F: P: S: X: a b c d e f g j k u v p=print r=remove
	if [[ -n $print ]]
	then
		printf 'complete %2$s %1$s\n' "${(@kv)_comps[(R)_bash*]#* }"
	elif [[ -n $remove ]]
	then
		for cmd
		do
			unset "_comps[$cmd]"
		done
	else
		compdef _bash_complete\ ${(j. .)${(q)args[1,-1-$#]}} "$@"
	fi
}
conda_prompt_info () {
	return 1
}
current_gemset () {
	echo "not supported"
}
current_ruby () {
	echo "not supported"
}
d () {
	if [[ -n $1 ]]
	then
		dirs "$@"
	else
		dirs -v | head -n 10
	fi
}
default () {
	(( $+parameters[$1] )) && return 0
	typeset -g "$1"="$2" && return 3
}
detect-clipboard () {
	emulate -L zsh
	if [[ "${OSTYPE}" == darwin* ]] && (( ${+commands[pbcopy]} )) && (( ${+commands[pbpaste]} ))
	then
		clipcopy () {
			cat "${1:-/dev/stdin}" | pbcopy
		}
		clippaste () {
			pbpaste
		}
	elif [[ "${OSTYPE}" == (cygwin|msys)* ]]
	then
		clipcopy () {
			cat "${1:-/dev/stdin}" > /dev/clipboard
		}
		clippaste () {
			cat /dev/clipboard
		}
	elif (( $+commands[clip.exe] )) && (( $+commands[powershell.exe] ))
	then
		clipcopy () {
			cat "${1:-/dev/stdin}" | clip.exe
		}
		clippaste () {
			powershell.exe -noprofile -command Get-Clipboard
		}
	elif [ -n "${WAYLAND_DISPLAY:-}" ] && (( ${+commands[wl-copy]} )) && (( ${+commands[wl-paste]} ))
	then
		clipcopy () {
			cat "${1:-/dev/stdin}" | wl-copy &> /dev/null &|
		}
		clippaste () {
			wl-paste --no-newline
		}
	elif [ -n "${DISPLAY:-}" ] && (( ${+commands[xsel]} ))
	then
		clipcopy () {
			cat "${1:-/dev/stdin}" | xsel --clipboard --input
		}
		clippaste () {
			xsel --clipboard --output
		}
	elif [ -n "${DISPLAY:-}" ] && (( ${+commands[xclip]} ))
	then
		clipcopy () {
			cat "${1:-/dev/stdin}" | xclip -selection clipboard -in &> /dev/null &|
		}
		clippaste () {
			xclip -out -selection clipboard
		}
	elif (( ${+commands[lemonade]} ))
	then
		clipcopy () {
			cat "${1:-/dev/stdin}" | lemonade copy
		}
		clippaste () {
			lemonade paste
		}
	elif (( ${+commands[doitclient]} ))
	then
		clipcopy () {
			cat "${1:-/dev/stdin}" | doitclient wclip
		}
		clippaste () {
			doitclient wclip -r
		}
	elif (( ${+commands[win32yank]} ))
	then
		clipcopy () {
			cat "${1:-/dev/stdin}" | win32yank -i
		}
		clippaste () {
			win32yank -o
		}
	elif [[ $OSTYPE == linux-android* ]] && (( $+commands[termux-clipboard-set] ))
	then
		clipcopy () {
			cat "${1:-/dev/stdin}" | termux-clipboard-set
		}
		clippaste () {
			termux-clipboard-get
		}
	elif [ -n "${TMUX:-}" ] && (( ${+commands[tmux]} ))
	then
		clipcopy () {
			tmux load-buffer -w "${1:--}"
		}
		clippaste () {
			tmux save-buffer -
		}
	else
		_retry_clipboard_detection_or_fail () {
			local clipcmd="${1}" 
			shift
			if detect-clipboard
			then
				"${clipcmd}" "$@"
			else
				print "${clipcmd}: Platform $OSTYPE not supported or xclip/xsel not installed" >&2
				return 1
			fi
		}
		clipcopy () {
			_retry_clipboard_detection_or_fail clipcopy "$@"
		}
		clippaste () {
			_retry_clipboard_detection_or_fail clippaste "$@"
		}
		return 1
	fi
}
diff () {
	command diff --color "$@"
}
dlxmrom () {
	url=$1 
	new_host="bkt-sgp-miui-ota-update-alisgp.oss-ap-southeast-1.aliyuncs.com" 
	new_url=$(echo "$url" | sed -E "s/\/\/[^\/]+/\/\/$new_host/g") 
	echo "Original URL: $url"
	echo "Replaced URL: $new_url"
	axel -c -n 20 $new_url --header="Referer: https://$new_host/"
}
down-line-or-beginning-search () {
	# undefined
	builtin autoload -XU
}
edit-command-line () {
	# undefined
	builtin autoload -XU
}
env_default () {
	[[ ${parameters[$1]} = *-export* ]] && return 0
	export "$1=$2" && return 3
}
fast-theme () {
	# undefined
	builtin autoload -XUz
}
gbda () {
	git branch --no-color --merged | command grep -vE "^([+*]|\s*($(git_main_branch)|$(git_develop_branch))\s*$)" | command xargs git branch --delete 2> /dev/null
}
gbds () {
	local default_branch=$(git_main_branch) 
	(( ! $? )) || default_branch=$(git_develop_branch) 
	git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch
	do
		local merge_base=$(git merge-base $default_branch $branch) 
		if [[ $(git cherry $default_branch $(git commit-tree $(git rev-parse $branch\^{tree}) -p $merge_base -m _)) = -* ]]
		then
			git branch -D $branch
		fi
	done
}
gccd () {
	setopt localoptions extendedglob
	local repo="${${@[(r)(ssh://*|git://*|ftp(s)#://*|http(s)#://*|*@*)(.git/#)#]}:-$_}" 
	command git clone --recurse-submodules "$@" || return
	[[ -d "$_" ]] && cd "$_" || cd "${${repo:t}%.git/#}"
}
gdnolock () {
	git diff "$@" ":(exclude)package-lock.json" ":(exclude)*.lock"
}
gdv () {
	git diff -w "$@" | view -
}
gems () {
	echo "not supported"
}
gemsets () {
	echo "not supported"
}
getAppVerCode () {
	pkg=$1 
	echo $(adb shell dumpsys package $pkg | grep -i versionCode | cut -d'=' -f 2 | cut -d' ' -f 1)
}
getAppVerName () {
	pkg=$1 
	echo $(adb shell dumpsys package $pkg | grep -i versionName | cut -d'=' -f 2)
}
ggf () {
	local b
	[[ $# != 1 ]] && b="$(git_current_branch)" 
	git push --force origin "${b:-$1}"
}
ggfl () {
	local b
	[[ $# != 1 ]] && b="$(git_current_branch)" 
	git push --force-with-lease origin "${b:-$1}"
}
ggl () {
	if [[ $# != 0 ]] && [[ $# != 1 ]]
	then
		git pull origin "${*}"
	else
		local b
		[[ $# == 0 ]] && b="$(git_current_branch)" 
		git pull origin "${b:-$1}"
	fi
}
ggp () {
	if [[ $# != 0 ]] && [[ $# != 1 ]]
	then
		git push origin "${*}"
	else
		local b
		[[ $# == 0 ]] && b="$(git_current_branch)" 
		git push origin "${b:-$1}"
	fi
}
ggpnp () {
	if [[ $# == 0 ]]
	then
		ggl && ggp
	else
		ggl "${*}" && ggp "${*}"
	fi
}
ggu () {
	local b
	[[ $# != 1 ]] && b="$(git_current_branch)" 
	git pull --rebase origin "${b:-$1}"
}
gitCloneBase () {
	baseDir=$1 
	gitTip=$2 
	perfixUrl=$3 
	project=$4 
	if [ -z "$project" ]
	then
		echo "project 不能为空"
		return
	fi
	curDir="$(pwd)" 
	echo "check $baseDir/$project"
	if [[ -d "$baseDir/$project" ]]
	then
		echo "$gitTip project $project already exists. pull it..."
	else
		echo "clone $gitTip project $project"
		git -c 'http.proxy=http://192.168.222.241:10874' clone $perfixUrl$project.git "$baseDir/$project"
	fi
	cd "$baseDir/$project"
	git reset --hard HEAD
	git -c 'http.proxy=http://192.168.222.241:10874' fetch --all
	git -c 'http.proxy=http://192.168.222.241:10874' pull --recurse-submodule
	git -c 'http.proxy=http://192.168.222.241:10874' submodule update --init --recursive
	cd "$curDir"
}
git_commits_ahead () {
	if __git_prompt_git rev-parse --git-dir &> /dev/null
	then
		local commits="$(__git_prompt_git rev-list --count @{upstream}..HEAD 2>/dev/null)" 
		if [[ -n "$commits" && "$commits" != 0 ]]
		then
			echo "$ZSH_THEME_GIT_COMMITS_AHEAD_PREFIX$commits$ZSH_THEME_GIT_COMMITS_AHEAD_SUFFIX"
		fi
	fi
}
git_commits_behind () {
	if __git_prompt_git rev-parse --git-dir &> /dev/null
	then
		local commits="$(__git_prompt_git rev-list --count HEAD..@{upstream} 2>/dev/null)" 
		if [[ -n "$commits" && "$commits" != 0 ]]
		then
			echo "$ZSH_THEME_GIT_COMMITS_BEHIND_PREFIX$commits$ZSH_THEME_GIT_COMMITS_BEHIND_SUFFIX"
		fi
	fi
}
git_current_branch () {
	local ref
	ref=$(__git_prompt_git symbolic-ref --quiet HEAD 2> /dev/null) 
	local ret=$? 
	if [[ $ret != 0 ]]
	then
		[[ $ret == 128 ]] && return
		ref=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null)  || return
	fi
	echo ${ref#refs/heads/}
}
git_current_user_email () {
	__git_prompt_git config user.email 2> /dev/null
}
git_current_user_name () {
	__git_prompt_git config user.name 2> /dev/null
}
git_develop_branch () {
	command git rev-parse --git-dir &> /dev/null || return
	local branch
	for branch in dev devel develop development
	do
		if command git show-ref -q --verify refs/heads/$branch
		then
			echo $branch
			return 0
		fi
	done
	echo develop
	return 1
}
git_main_branch () {
	command git rev-parse --git-dir &> /dev/null || return
	local remote ref
	for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default,stable,master}
	do
		if command git show-ref -q --verify $ref
		then
			echo ${ref:t}
			return 0
		fi
	done
	for remote in origin upstream
	do
		ref=$(command git rev-parse --abbrev-ref $remote/HEAD 2>/dev/null) 
		if [[ $ref == $remote/* ]]
		then
			echo ${ref#"$remote/"}
			return 0
		fi
	done
	echo master
	return 1
}
git_previous_branch () {
	local ref
	ref=$(__git_prompt_git rev-parse --quiet --symbolic-full-name @{-1} 2> /dev/null) 
	local ret=$? 
	if [[ $ret != 0 ]] || [[ -z $ref ]]
	then
		return
	fi
	echo ${ref#refs/heads/}
}
git_prompt_ahead () {
	if [[ -n "$(__git_prompt_git rev-list origin/$(git_current_branch)..HEAD 2> /dev/null)" ]]
	then
		echo "$ZSH_THEME_GIT_PROMPT_AHEAD"
	fi
}
git_prompt_behind () {
	if [[ -n "$(__git_prompt_git rev-list HEAD..origin/$(git_current_branch) 2> /dev/null)" ]]
	then
		echo "$ZSH_THEME_GIT_PROMPT_BEHIND"
	fi
}
git_prompt_info () {
	if [[ -n "${_OMZ_ASYNC_OUTPUT[_omz_git_prompt_info]}" ]]
	then
		echo -n "${_OMZ_ASYNC_OUTPUT[_omz_git_prompt_info]}"
	fi
}
git_prompt_long_sha () {
	local SHA
	SHA=$(__git_prompt_git rev-parse HEAD 2> /dev/null)  && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}
git_prompt_remote () {
	if [[ -n "$(__git_prompt_git show-ref origin/$(git_current_branch) 2> /dev/null)" ]]
	then
		echo "$ZSH_THEME_GIT_PROMPT_REMOTE_EXISTS"
	else
		echo "$ZSH_THEME_GIT_PROMPT_REMOTE_MISSING"
	fi
}
git_prompt_short_sha () {
	local SHA
	SHA=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null)  && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}
git_prompt_status () {
	if [[ -n "${_OMZ_ASYNC_OUTPUT[_omz_git_prompt_status]}" ]]
	then
		echo -n "${_OMZ_ASYNC_OUTPUT[_omz_git_prompt_status]}"
	fi
}
git_remote_status () {
	local remote ahead behind git_remote_status git_remote_status_detailed
	remote=${$(__git_prompt_git rev-parse --verify ${hook_com[branch]}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/} 
	if [[ -n ${remote} ]]
	then
		ahead=$(__git_prompt_git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l) 
		behind=$(__git_prompt_git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l) 
		if [[ $ahead -eq 0 ]] && [[ $behind -eq 0 ]]
		then
			git_remote_status="$ZSH_THEME_GIT_PROMPT_EQUAL_REMOTE" 
		elif [[ $ahead -gt 0 ]] && [[ $behind -eq 0 ]]
		then
			git_remote_status="$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE" 
			git_remote_status_detailed="$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE$((ahead))%{$reset_color%}" 
		elif [[ $behind -gt 0 ]] && [[ $ahead -eq 0 ]]
		then
			git_remote_status="$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE" 
			git_remote_status_detailed="$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE$((behind))%{$reset_color%}" 
		elif [[ $ahead -gt 0 ]] && [[ $behind -gt 0 ]]
		then
			git_remote_status="$ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE" 
			git_remote_status_detailed="$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE$((ahead))%{$reset_color%}$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE$((behind))%{$reset_color%}" 
		fi
		if [[ -n $ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_DETAILED ]]
		then
			git_remote_status="$ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_PREFIX${remote:gs/%/%%}$git_remote_status_detailed$ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_SUFFIX" 
		fi
		echo $git_remote_status
	fi
}
git_repo_name () {
	local repo_path
	if repo_path="$(__git_prompt_git rev-parse --show-toplevel 2>/dev/null)"  && [[ -n "$repo_path" ]]
	then
		echo ${repo_path:t}
	fi
}
githubClone () {
	project=$1 
	gitCloneBase $GithubSources "GitHub" "git@github.com:" $project
}
gitlabClone () {
	project=$1 
	gitCloneBase $GitLabSources "GitLab" "git@gitlab.com:" $project
}
goenv () {
	local command
	command="$1" 
	if [ "$#" -gt 0 ]
	then
		shift
	fi
	case "$command" in
		(rehash | shell) eval "$(goenv "sh-$command" "$@")" ;;
		(*) command goenv "$command" "$@" ;;
	esac
}
grename () {
	if [[ -z "$1" || -z "$2" ]]
	then
		echo "Usage: $0 old_branch new_branch"
		return 1
	fi
	git branch -m "$1" "$2"
	if git push origin :"$1"
	then
		git push --set-upstream origin "$2"
	fi
}
gunwipall () {
	local _commit=$(git log --grep='--wip--' --invert-grep --max-count=1 --format=format:%H) 
	if [[ "$_commit" != "$(git rev-parse HEAD)" ]]
	then
		git reset $_commit || return 1
	fi
}
handle_completion_insecurities () {
	local -aU insecure_dirs
	insecure_dirs=(${(f@):-"$(compaudit 2>/dev/null)"}) 
	[[ -z "${insecure_dirs}" ]] && return
	print "[oh-my-zsh] Insecure completion-dependent directories detected:"
	ls -ld "${(@)insecure_dirs}"
	cat <<EOD

[oh-my-zsh] For safety, we will not load completions from these directories until
[oh-my-zsh] you fix their permissions and ownership and restart zsh.
[oh-my-zsh] See the above list for directories with group or other writability.

[oh-my-zsh] To fix your permissions you can do so by disabling
[oh-my-zsh] the write permission of "group" and "others" and making sure that the
[oh-my-zsh] owner of these directories is either root or your current user.
[oh-my-zsh] The following command may help:
[oh-my-zsh]     compaudit | xargs chmod g-w,o-w

[oh-my-zsh] If the above didn't help or you want to skip the verification of
[oh-my-zsh] insecure directories you can set the variable ZSH_DISABLE_COMPFIX to
[oh-my-zsh] "true" before oh-my-zsh is sourced in your zshrc file.

EOD
}
hg_prompt_info () {
	return 1
}
is-at-least () {
	emulate -L zsh
	local IFS=".-" min_cnt=0 ver_cnt=0 part min_ver version order 
	min_ver=(${=1}) 
	version=(${=2:-$ZSH_VERSION} 0) 
	while (( $min_cnt <= ${#min_ver} ))
	do
		while [[ "$part" != <-> ]]
		do
			(( ++ver_cnt > ${#version} )) && return 0
			if [[ ${version[ver_cnt]} = *[0-9][^0-9]* ]]
			then
				order=(${version[ver_cnt]} ${min_ver[ver_cnt]}) 
				if [[ ${version[ver_cnt]} = <->* ]]
				then
					[[ $order != ${${(On)order}} ]] && return 1
				else
					[[ $order != ${${(O)order}} ]] && return 1
				fi
				[[ $order[1] != $order[2] ]] && return 0
			fi
			part=${version[ver_cnt]##*[^0-9]} 
		done
		while true
		do
			(( ++min_cnt > ${#min_ver} )) && return 0
			[[ ${min_ver[min_cnt]} = <-> ]] && break
		done
		(( part > min_ver[min_cnt] )) && return 0
		(( part < min_ver[min_cnt] )) && return 1
		part='' 
	done
}
is_plugin () {
	local base_dir=$1 
	local name=$2 
	builtin test -f $base_dir/plugins/$name/$name.plugin.zsh || builtin test -f $base_dir/plugins/$name/_$name
}
is_theme () {
	local base_dir=$1 
	local name=$2 
	builtin test -f $base_dir/$name.zsh-theme
}
jdk11 () {
	export JAVA_HOME=$JAVA_HOME_11 
	updateJdkPath
}
jdk17 () {
	export JAVA_HOME=$JAVA_HOME_17 
	updateJdkPath
}
jdk21 () {
	export JAVA_HOME=$JAVA_HOME_21 
	updateJdkPath
}
jdk8 () {
	export JAVA_HOME=$JAVA_HOME_8 
	updateJdkPath
}
jenv_prompt_info () {
	return 1
}
mkcd () {
	mkdir -p $@ && cd ${@:$#}
}
modelscope () {
	project=$1 
	gitCloneBase $ModelscopeDir "Modelscope" "https://www.modelscope.cn/" $project
}
nvm () {
	if [ "$#" -lt 1 ]
	then
		nvm --help
		return
	fi
	local DEFAULT_IFS
	DEFAULT_IFS=" $(nvm_echo t | command tr t \\t)
" 
	if [ "${-#*e}" != "$-" ]
	then
		set +e
		local EXIT_CODE
		IFS="${DEFAULT_IFS}" nvm "$@"
		EXIT_CODE="$?" 
		set -e
		return "$EXIT_CODE"
	elif [ "${-#*a}" != "$-" ]
	then
		set +a
		local EXIT_CODE
		IFS="${DEFAULT_IFS}" nvm "$@"
		EXIT_CODE="$?" 
		set -a
		return "$EXIT_CODE"
	elif [ -n "${BASH-}" ] && [ "${-#*E}" != "$-" ]
	then
		set +E
		local EXIT_CODE
		IFS="${DEFAULT_IFS}" nvm "$@"
		EXIT_CODE="$?" 
		set -E
		return "$EXIT_CODE"
	elif [ "${IFS}" != "${DEFAULT_IFS}" ]
	then
		IFS="${DEFAULT_IFS}" nvm "$@"
		return "$?"
	fi
	local i
	for i in "$@"
	do
		case $i in
			(--) break ;;
			('-h' | 'help' | '--help') NVM_NO_COLORS="" 
				for j in "$@"
				do
					if [ "${j}" = '--no-colors' ]
					then
						NVM_NO_COLORS="${j}" 
						break
					fi
				done
				local NVM_IOJS_PREFIX
				NVM_IOJS_PREFIX="$(nvm_iojs_prefix)" 
				local NVM_NODE_PREFIX
				NVM_NODE_PREFIX="$(nvm_node_prefix)" 
				NVM_VERSION="$(nvm --version)" 
				nvm_echo
				nvm_echo "Node Version Manager (v${NVM_VERSION})"
				nvm_echo
				nvm_echo 'Note: <version> refers to any version-like string nvm understands. This includes:'
				nvm_echo '  - full or partial version numbers, starting with an optional "v" (0.10, v0.1.2, v1)'
				nvm_echo "  - default (built-in) aliases: ${NVM_NODE_PREFIX}, stable, unstable, ${NVM_IOJS_PREFIX}, system"
				nvm_echo '  - custom aliases you define with `nvm alias foo`'
				nvm_echo
				nvm_echo ' Any options that produce colorized output should respect the `--no-colors` option.'
				nvm_echo
				nvm_echo 'Usage:'
				nvm_echo '  nvm --help                                  Show this message'
				nvm_echo '    --no-colors                               Suppress colored output'
				nvm_echo '  nvm --version                               Print out the installed version of nvm'
				nvm_echo '  nvm install [<version>]                     Download and install a <version>. Uses .nvmrc if available and version is omitted.'
				nvm_echo '   The following optional arguments, if provided, must appear directly after `nvm install`:'
				nvm_echo '    -s                                        Skip binary download, install from source only.'
				nvm_echo '    -b                                        Skip source download, install from binary only.'
				nvm_echo '    --reinstall-packages-from=<version>       When installing, reinstall packages installed in <node|iojs|node version number>'
				nvm_echo '    --lts                                     When installing, only select from LTS (long-term support) versions'
				nvm_echo '    --lts=<LTS name>                          When installing, only select from versions for a specific LTS line'
				nvm_echo '    --skip-default-packages                   When installing, skip the default-packages file if it exists'
				nvm_echo '    --latest-npm                              After installing, attempt to upgrade to the latest working npm on the given node version'
				nvm_echo '    --no-progress                             Disable the progress bar on any downloads'
				nvm_echo '    --alias=<name>                            After installing, set the alias specified to the version specified. (same as: nvm alias <name> <version>)'
				nvm_echo '    --default                                 After installing, set default alias to the version specified. (same as: nvm alias default <version>)'
				nvm_echo '    --save                                    After installing, write the specified version to .nvmrc'
				nvm_echo '  nvm uninstall <version>                     Uninstall a version'
				nvm_echo '  nvm uninstall --lts                         Uninstall using automatic LTS (long-term support) alias `lts/*`, if available.'
				nvm_echo '  nvm uninstall --lts=<LTS name>              Uninstall using automatic alias for provided LTS line, if available.'
				nvm_echo '  nvm use [<version>]                         Modify PATH to use <version>. Uses .nvmrc if available and version is omitted.'
				nvm_echo '   The following optional arguments, if provided, must appear directly after `nvm use`:'
				nvm_echo '    --silent                                  Silences stdout/stderr output'
				nvm_echo '    --lts                                     Uses automatic LTS (long-term support) alias `lts/*`, if available.'
				nvm_echo '    --lts=<LTS name>                          Uses automatic alias for provided LTS line, if available.'
				nvm_echo '    --save                                    Writes the specified version to .nvmrc.'
				nvm_echo '  nvm exec [<version>] [<command>]            Run <command> on <version>. Uses .nvmrc if available and version is omitted.'
				nvm_echo '   The following optional arguments, if provided, must appear directly after `nvm exec`:'
				nvm_echo '    --silent                                  Silences stdout/stderr output'
				nvm_echo '    --lts                                     Uses automatic LTS (long-term support) alias `lts/*`, if available.'
				nvm_echo '    --lts=<LTS name>                          Uses automatic alias for provided LTS line, if available.'
				nvm_echo '  nvm run [<version>] [<args>]                Run `node` on <version> with <args> as arguments. Uses .nvmrc if available and version is omitted.'
				nvm_echo '   The following optional arguments, if provided, must appear directly after `nvm run`:'
				nvm_echo '    --silent                                  Silences stdout/stderr output'
				nvm_echo '    --lts                                     Uses automatic LTS (long-term support) alias `lts/*`, if available.'
				nvm_echo '    --lts=<LTS name>                          Uses automatic alias for provided LTS line, if available.'
				nvm_echo '  nvm current                                 Display currently activated version of Node'
				nvm_echo '  nvm ls [<version>]                          List installed versions, matching a given <version> if provided'
				nvm_echo '    --no-colors                               Suppress colored output'
				nvm_echo '    --no-alias                                Suppress `nvm alias` output'
				nvm_echo '  nvm ls-remote [<version>]                   List remote versions available for install, matching a given <version> if provided'
				nvm_echo '    --lts                                     When listing, only show LTS (long-term support) versions'
				nvm_echo '    --lts=<LTS name>                          When listing, only show versions for a specific LTS line'
				nvm_echo '    --no-colors                               Suppress colored output'
				nvm_echo '  nvm version <version>                       Resolve the given description to a single local version'
				nvm_echo '  nvm version-remote <version>                Resolve the given description to a single remote version'
				nvm_echo '    --lts                                     When listing, only select from LTS (long-term support) versions'
				nvm_echo '    --lts=<LTS name>                          When listing, only select from versions for a specific LTS line'
				nvm_echo '  nvm deactivate                              Undo effects of `nvm` on current shell'
				nvm_echo '    --silent                                  Silences stdout/stderr output'
				nvm_echo '  nvm alias [<pattern>]                       Show all aliases beginning with <pattern>'
				nvm_echo '    --no-colors                               Suppress colored output'
				nvm_echo '  nvm alias <name> <version>                  Set an alias named <name> pointing to <version>'
				nvm_echo '  nvm unalias <name>                          Deletes the alias named <name>'
				nvm_echo '  nvm install-latest-npm                      Attempt to upgrade to the latest working `npm` on the current node version'
				nvm_echo '  nvm reinstall-packages <version>            Reinstall global `npm` packages contained in <version> to current version'
				nvm_echo '  nvm unload                                  Unload `nvm` from shell'
				nvm_echo '  nvm which [current | <version>]             Display path to installed node version. Uses .nvmrc if available and version is omitted.'
				nvm_echo '    --silent                                  Silences stdout/stderr output when a version is omitted'
				nvm_echo '  nvm cache dir                               Display path to the cache directory for nvm'
				nvm_echo '  nvm cache clear                             Empty cache directory for nvm'
				nvm_echo '  nvm set-colors [<color codes>]              Set five text colors using format "yMeBg". Available when supported.'
				nvm_echo '                                               Initial colors are:'
				nvm_echo_with_colors "                                                  $(nvm_wrap_with_color_code 'b' 'b')$(nvm_wrap_with_color_code 'y' 'y')$(nvm_wrap_with_color_code 'g' 'g')$(nvm_wrap_with_color_code 'r' 'r')$(nvm_wrap_with_color_code 'e' 'e')"
				nvm_echo '                                               Color codes:'
				nvm_echo_with_colors "                                                $(nvm_wrap_with_color_code 'r' 'r')/$(nvm_wrap_with_color_code 'R' 'R') = $(nvm_wrap_with_color_code 'r' 'red') / $(nvm_wrap_with_color_code 'R' 'bold red')"
				nvm_echo_with_colors "                                                $(nvm_wrap_with_color_code 'g' 'g')/$(nvm_wrap_with_color_code 'G' 'G') = $(nvm_wrap_with_color_code 'g' 'green') / $(nvm_wrap_with_color_code 'G' 'bold green')"
				nvm_echo_with_colors "                                                $(nvm_wrap_with_color_code 'b' 'b')/$(nvm_wrap_with_color_code 'B' 'B') = $(nvm_wrap_with_color_code 'b' 'blue') / $(nvm_wrap_with_color_code 'B' 'bold blue')"
				nvm_echo_with_colors "                                                $(nvm_wrap_with_color_code 'c' 'c')/$(nvm_wrap_with_color_code 'C' 'C') = $(nvm_wrap_with_color_code 'c' 'cyan') / $(nvm_wrap_with_color_code 'C' 'bold cyan')"
				nvm_echo_with_colors "                                                $(nvm_wrap_with_color_code 'm' 'm')/$(nvm_wrap_with_color_code 'M' 'M') = $(nvm_wrap_with_color_code 'm' 'magenta') / $(nvm_wrap_with_color_code 'M' 'bold magenta')"
				nvm_echo_with_colors "                                                $(nvm_wrap_with_color_code 'y' 'y')/$(nvm_wrap_with_color_code 'Y' 'Y') = $(nvm_wrap_with_color_code 'y' 'yellow') / $(nvm_wrap_with_color_code 'Y' 'bold yellow')"
				nvm_echo_with_colors "                                                $(nvm_wrap_with_color_code 'k' 'k')/$(nvm_wrap_with_color_code 'K' 'K') = $(nvm_wrap_with_color_code 'k' 'black') / $(nvm_wrap_with_color_code 'K' 'bold black')"
				nvm_echo_with_colors "                                                $(nvm_wrap_with_color_code 'e' 'e')/$(nvm_wrap_with_color_code 'W' 'W') = $(nvm_wrap_with_color_code 'e' 'light grey') / $(nvm_wrap_with_color_code 'W' 'white')"
				nvm_echo 'Example:'
				nvm_echo '  nvm install 8.0.0                     Install a specific version number'
				nvm_echo '  nvm use 8.0                           Use the latest available 8.0.x release'
				nvm_echo '  nvm run 6.10.3 app.js                 Run app.js using node 6.10.3'
				nvm_echo '  nvm exec 4.8.3 node app.js            Run `node app.js` with the PATH pointing to node 4.8.3'
				nvm_echo '  nvm alias default 8.1.0               Set default node version on a shell'
				nvm_echo '  nvm alias default node                Always default to the latest available node version on a shell'
				nvm_echo
				nvm_echo '  nvm install node                      Install the latest available version'
				nvm_echo '  nvm use node                          Use the latest version'
				nvm_echo '  nvm install --lts                     Install the latest LTS version'
				nvm_echo '  nvm use --lts                         Use the latest LTS version'
				nvm_echo
				nvm_echo '  nvm set-colors cgYmW                  Set text colors to cyan, green, bold yellow, magenta, and white'
				nvm_echo
				nvm_echo 'Note:'
				nvm_echo '  to remove, delete, or uninstall nvm - just remove the `$NVM_DIR` folder (usually `~/.nvm`)'
				nvm_echo
				return 0 ;;
		esac
	done
	local COMMAND
	COMMAND="${1-}" 
	shift
	local VERSION
	local ADDITIONAL_PARAMETERS
	case $COMMAND in
		("cache") case "${1-}" in
				(dir) nvm_cache_dir ;;
				(clear) local DIR
					DIR="$(nvm_cache_dir)" 
					if command rm -rf "${DIR}" && command mkdir -p "${DIR}"
					then
						nvm_echo 'nvm cache cleared.'
					else
						nvm_err "Unable to clear nvm cache: ${DIR}"
						return 1
					fi ;;
				(*) nvm --help >&2
					return 127 ;;
			esac ;;
		("debug") local OS_VERSION
			nvm_is_zsh && setopt local_options shwordsplit
			nvm_err "nvm --version: v$(nvm --version)"
			if [ -n "${TERM_PROGRAM-}" ]
			then
				nvm_err "\$TERM_PROGRAM: ${TERM_PROGRAM}"
			fi
			nvm_err "\$SHELL: ${SHELL}"
			nvm_err "\$SHLVL: ${SHLVL-}"
			nvm_err "whoami: '$(whoami)'"
			nvm_err "\${HOME}: ${HOME}"
			nvm_err "\${NVM_DIR}: '$(nvm_sanitize_path "${NVM_DIR}")'"
			nvm_err "\${PATH}: $(nvm_sanitize_path "${PATH}")"
			nvm_err "\$PREFIX: '$(nvm_sanitize_path "${PREFIX}")'"
			nvm_err "\${NPM_CONFIG_PREFIX}: '$(nvm_sanitize_path "${NPM_CONFIG_PREFIX}")'"
			nvm_err "\$NVM_NODEJS_ORG_MIRROR: '${NVM_NODEJS_ORG_MIRROR}'"
			nvm_err "\$NVM_IOJS_ORG_MIRROR: '${NVM_IOJS_ORG_MIRROR}'"
			nvm_err "shell version: '$(${SHELL} --version | command head -n 1)'"
			nvm_err "uname -a: '$(command uname -a | command awk '{$2=""; print}' | command xargs)'"
			nvm_err "checksum binary: '$(nvm_get_checksum_binary 2>/dev/null)'"
			if [ "$(nvm_get_os)" = "darwin" ] && nvm_has sw_vers
			then
				OS_VERSION="$(sw_vers | command awk '{print $2}' | command xargs)" 
			elif [ -r "/etc/issue" ]
			then
				OS_VERSION="$(command head -n 1 /etc/issue | command sed 's/\\.//g')" 
				if [ -z "${OS_VERSION}" ] && [ -r "/etc/os-release" ]
				then
					OS_VERSION="$(. /etc/os-release && echo "${NAME}" "${VERSION}")" 
				fi
			fi
			if [ -n "${OS_VERSION}" ]
			then
				nvm_err "OS version: ${OS_VERSION}"
			fi
			if nvm_has "awk"
			then
				nvm_err "awk: $(nvm_command_info awk), $({ command awk --version 2>/dev/null || command awk -W version; } \
          | command head -n 1)"
			else
				nvm_err "awk: not found"
			fi
			if nvm_has "curl"
			then
				nvm_err "curl: $(nvm_command_info curl), $(command curl -V | command head -n 1)"
			else
				nvm_err "curl: not found"
			fi
			if nvm_has "wget"
			then
				nvm_err "wget: $(nvm_command_info wget), $(command wget -V | command head -n 1)"
			else
				nvm_err "wget: not found"
			fi
			local TEST_TOOLS ADD_TEST_TOOLS
			TEST_TOOLS="git grep" 
			ADD_TEST_TOOLS="sed cut basename rm mkdir xargs" 
			if [ "darwin" != "$(nvm_get_os)" ] && [ "freebsd" != "$(nvm_get_os)" ]
			then
				TEST_TOOLS="${TEST_TOOLS} ${ADD_TEST_TOOLS}" 
			else
				for tool in ${ADD_TEST_TOOLS}
				do
					if nvm_has "${tool}"
					then
						nvm_err "${tool}: $(nvm_command_info "${tool}")"
					else
						nvm_err "${tool}: not found"
					fi
				done
			fi
			for tool in ${TEST_TOOLS}
			do
				local NVM_TOOL_VERSION
				if nvm_has "${tool}"
				then
					if command ls -l "$(nvm_command_info "${tool}" | command awk '{print $1}')" | command grep -q busybox
					then
						NVM_TOOL_VERSION="$(command "${tool}" --help 2>&1 | command head -n 1)" 
					else
						NVM_TOOL_VERSION="$(command "${tool}" --version 2>&1 | command head -n 1)" 
					fi
					nvm_err "${tool}: $(nvm_command_info "${tool}"), ${NVM_TOOL_VERSION}"
				else
					nvm_err "${tool}: not found"
				fi
				unset NVM_TOOL_VERSION
			done
			unset TEST_TOOLS ADD_TEST_TOOLS
			local NVM_DEBUG_OUTPUT
			for NVM_DEBUG_COMMAND in 'nvm current' 'which node' 'which iojs' 'which npm' 'npm config get prefix' 'npm root -g'
			do
				NVM_DEBUG_OUTPUT="$(${NVM_DEBUG_COMMAND} 2>&1)" 
				nvm_err "${NVM_DEBUG_COMMAND}: $(nvm_sanitize_path "${NVM_DEBUG_OUTPUT}")"
			done
			return 42 ;;
		("install" | "i") local version_not_provided
			version_not_provided=0 
			local NVM_OS
			NVM_OS="$(nvm_get_os)" 
			if ! nvm_has "curl" && ! nvm_has "wget"
			then
				nvm_err 'nvm needs curl or wget to proceed.'
				return 1
			fi
			if [ $# -lt 1 ]
			then
				version_not_provided=1 
			fi
			local nobinary
			local nosource
			local noprogress
			nobinary=0 
			noprogress=0 
			nosource=0 
			local LTS
			local ALIAS
			local NVM_UPGRADE_NPM
			NVM_UPGRADE_NPM=0 
			local NVM_WRITE_TO_NVMRC
			NVM_WRITE_TO_NVMRC=0 
			local PROVIDED_REINSTALL_PACKAGES_FROM
			local REINSTALL_PACKAGES_FROM
			local SKIP_DEFAULT_PACKAGES
			while [ $# -ne 0 ]
			do
				case "$1" in
					(---*) nvm_err 'arguments with `---` are not supported - this is likely a typo'
						return 55 ;;
					(-s) shift
						nobinary=1 
						if [ $nosource -eq 1 ]
						then
							nvm err '-s and -b cannot be set together since they would skip install from both binary and source'
							return 6
						fi ;;
					(-b) shift
						nosource=1 
						if [ $nobinary -eq 1 ]
						then
							nvm err '-s and -b cannot be set together since they would skip install from both binary and source'
							return 6
						fi ;;
					(-j) shift
						nvm_get_make_jobs "$1"
						shift ;;
					(--no-progress) noprogress=1 
						shift ;;
					(--lts) LTS='*' 
						shift ;;
					(--lts=*) LTS="${1##--lts=}" 
						shift ;;
					(--latest-npm) NVM_UPGRADE_NPM=1 
						shift ;;
					(--default) if [ -n "${ALIAS-}" ]
						then
							nvm_err '--default and --alias are mutually exclusive, and may not be provided more than once'
							return 6
						fi
						ALIAS='default' 
						shift ;;
					(--alias=*) if [ -n "${ALIAS-}" ]
						then
							nvm_err '--default and --alias are mutually exclusive, and may not be provided more than once'
							return 6
						fi
						ALIAS="${1##--alias=}" 
						shift ;;
					(--reinstall-packages-from=*) if [ -n "${PROVIDED_REINSTALL_PACKAGES_FROM-}" ]
						then
							nvm_err '--reinstall-packages-from may not be provided more than once'
							return 6
						fi
						PROVIDED_REINSTALL_PACKAGES_FROM="$(nvm_echo "$1" | command cut -c 27-)" 
						if [ -z "${PROVIDED_REINSTALL_PACKAGES_FROM}" ]
						then
							nvm_err 'If --reinstall-packages-from is provided, it must point to an installed version of node.'
							return 6
						fi
						REINSTALL_PACKAGES_FROM="$(nvm_version "${PROVIDED_REINSTALL_PACKAGES_FROM}")"  || :
						shift ;;
					(--copy-packages-from=*) if [ -n "${PROVIDED_REINSTALL_PACKAGES_FROM-}" ]
						then
							nvm_err '--reinstall-packages-from may not be provided more than once, or combined with `--copy-packages-from`'
							return 6
						fi
						PROVIDED_REINSTALL_PACKAGES_FROM="$(nvm_echo "$1" | command cut -c 22-)" 
						if [ -z "${PROVIDED_REINSTALL_PACKAGES_FROM}" ]
						then
							nvm_err 'If --copy-packages-from is provided, it must point to an installed version of node.'
							return 6
						fi
						REINSTALL_PACKAGES_FROM="$(nvm_version "${PROVIDED_REINSTALL_PACKAGES_FROM}")"  || :
						shift ;;
					(--reinstall-packages-from | --copy-packages-from) nvm_err "If ${1} is provided, it must point to an installed version of node using \`=\`."
						return 6 ;;
					(--skip-default-packages) SKIP_DEFAULT_PACKAGES=true 
						shift ;;
					(--save | -w) NVM_WRITE_TO_NVMRC=1 
						shift ;;
					(*) break ;;
				esac
			done
			local provided_version
			provided_version="${1-}" 
			if [ -z "${provided_version}" ]
			then
				if [ "_${LTS-}" = '_*' ]
				then
					nvm_echo 'Installing latest LTS version.'
					if [ $# -gt 0 ]
					then
						shift
					fi
				elif [ "_${LTS-}" != '_' ]
				then
					nvm_echo "Installing with latest version of LTS line: ${LTS}"
					if [ $# -gt 0 ]
					then
						shift
					fi
				else
					nvm_rc_version
					if [ $version_not_provided -eq 1 ] && [ -z "${NVM_RC_VERSION}" ]
					then
						unset NVM_RC_VERSION
						nvm --help >&2
						return 127
					fi
					provided_version="${NVM_RC_VERSION}" 
					unset NVM_RC_VERSION
				fi
			elif [ $# -gt 0 ]
			then
				shift
			fi
			case "${provided_version}" in
				('lts/*') LTS='*' 
					provided_version=''  ;;
				(lts/*) LTS="${provided_version##lts/}" 
					provided_version=''  ;;
			esac
			VERSION="$(NVM_VERSION_ONLY=true NVM_LTS="${LTS-}" nvm_remote_version "${provided_version}")" 
			if [ "${VERSION}" = 'N/A' ]
			then
				local LTS_MSG
				local REMOTE_CMD
				if [ "${LTS-}" = '*' ]
				then
					LTS_MSG='(with LTS filter) ' 
					REMOTE_CMD='nvm ls-remote --lts' 
				elif [ -n "${LTS-}" ]
				then
					LTS_MSG="(with LTS filter '${LTS}') " 
					REMOTE_CMD="nvm ls-remote --lts=${LTS}" 
				else
					REMOTE_CMD='nvm ls-remote' 
				fi
				nvm_err "Version '${provided_version}' ${LTS_MSG-}not found - try \`${REMOTE_CMD}\` to browse available versions."
				return 3
			fi
			ADDITIONAL_PARAMETERS='' 
			while [ $# -ne 0 ]
			do
				case "$1" in
					(--reinstall-packages-from=*) if [ -n "${PROVIDED_REINSTALL_PACKAGES_FROM-}" ]
						then
							nvm_err '--reinstall-packages-from may not be provided more than once'
							return 6
						fi
						PROVIDED_REINSTALL_PACKAGES_FROM="$(nvm_echo "$1" | command cut -c 27-)" 
						if [ -z "${PROVIDED_REINSTALL_PACKAGES_FROM}" ]
						then
							nvm_err 'If --reinstall-packages-from is provided, it must point to an installed version of node.'
							return 6
						fi
						REINSTALL_PACKAGES_FROM="$(nvm_version "${PROVIDED_REINSTALL_PACKAGES_FROM}")"  || : ;;
					(--copy-packages-from=*) if [ -n "${PROVIDED_REINSTALL_PACKAGES_FROM-}" ]
						then
							nvm_err '--reinstall-packages-from may not be provided more than once, or combined with `--copy-packages-from`'
							return 6
						fi
						PROVIDED_REINSTALL_PACKAGES_FROM="$(nvm_echo "$1" | command cut -c 22-)" 
						if [ -z "${PROVIDED_REINSTALL_PACKAGES_FROM}" ]
						then
							nvm_err 'If --copy-packages-from is provided, it must point to an installed version of node.'
							return 6
						fi
						REINSTALL_PACKAGES_FROM="$(nvm_version "${PROVIDED_REINSTALL_PACKAGES_FROM}")"  || : ;;
					(--reinstall-packages-from | --copy-packages-from) nvm_err "If ${1} is provided, it must point to an installed version of node using \`=\`."
						return 6 ;;
					(--skip-default-packages) SKIP_DEFAULT_PACKAGES=true  ;;
					(*) ADDITIONAL_PARAMETERS="${ADDITIONAL_PARAMETERS} $1"  ;;
				esac
				shift
			done
			if [ -n "${PROVIDED_REINSTALL_PACKAGES_FROM-}" ] && [ "$(nvm_ensure_version_prefix "${PROVIDED_REINSTALL_PACKAGES_FROM}")" = "${VERSION}" ]
			then
				nvm_err "You can't reinstall global packages from the same version of node you're installing."
				return 4
			elif [ "${REINSTALL_PACKAGES_FROM-}" = 'N/A' ]
			then
				nvm_err "If --reinstall-packages-from is provided, it must point to an installed version of node."
				return 5
			fi
			local FLAVOR
			if nvm_is_iojs_version "${VERSION}"
			then
				FLAVOR="$(nvm_iojs_prefix)" 
			else
				FLAVOR="$(nvm_node_prefix)" 
			fi
			local EXIT_CODE
			EXIT_CODE=0 
			if nvm_is_version_installed "${VERSION}"
			then
				nvm_err "${VERSION} is already installed."
				nvm use "${VERSION}"
				EXIT_CODE=$? 
				if [ $EXIT_CODE -eq 0 ]
				then
					if [ "${NVM_UPGRADE_NPM}" = 1 ]
					then
						nvm install-latest-npm
						EXIT_CODE=$? 
					fi
					if [ $EXIT_CODE -ne 0 ] && [ -z "${SKIP_DEFAULT_PACKAGES-}" ]
					then
						nvm_install_default_packages
					fi
					if [ $EXIT_CODE -ne 0 ] && [ -n "${REINSTALL_PACKAGES_FROM-}" ] && [ "_${REINSTALL_PACKAGES_FROM}" != "_N/A" ]
					then
						nvm reinstall-packages "${REINSTALL_PACKAGES_FROM}"
						EXIT_CODE=$? 
					fi
				fi
				if [ -n "${LTS-}" ]
				then
					LTS="$(echo "${LTS}" | tr '[:upper:]' '[:lower:]')" 
					nvm_ensure_default_set "lts/${LTS}"
				else
					nvm_ensure_default_set "${provided_version}"
				fi
				if [ $EXIT_CODE -ne 0 ] && [ -n "${ALIAS-}" ]
				then
					nvm alias "${ALIAS}" "${provided_version}"
					EXIT_CODE=$? 
				fi
				return $EXIT_CODE
			fi
			if [ -n "${NVM_INSTALL_THIRD_PARTY_HOOK-}" ]
			then
				nvm_err '** $NVM_INSTALL_THIRD_PARTY_HOOK env var set; dispatching to third-party installation method **'
				local NVM_METHOD_PREFERENCE
				NVM_METHOD_PREFERENCE='binary' 
				if [ $nobinary -eq 1 ]
				then
					NVM_METHOD_PREFERENCE='source' 
				fi
				local VERSION_PATH
				VERSION_PATH="$(nvm_version_path "${VERSION}")" 
				"${NVM_INSTALL_THIRD_PARTY_HOOK}" "${VERSION}" "${FLAVOR}" std "${NVM_METHOD_PREFERENCE}" "${VERSION_PATH}" || {
					EXIT_CODE=$? 
					nvm_err '*** Third-party $NVM_INSTALL_THIRD_PARTY_HOOK env var failed to install! ***'
					return $EXIT_CODE
				}
				if ! nvm_is_version_installed "${VERSION}"
				then
					nvm_err '*** Third-party $NVM_INSTALL_THIRD_PARTY_HOOK env var claimed to succeed, but failed to install! ***'
					return 33
				fi
				EXIT_CODE=0 
			else
				if [ "_${NVM_OS}" = "_freebsd" ]
				then
					nobinary=1 
					nvm_err "Currently, there is no binary for FreeBSD"
				elif [ "_$NVM_OS" = "_openbsd" ]
				then
					nobinary=1 
					nvm_err "Currently, there is no binary for OpenBSD"
				elif [ "_${NVM_OS}" = "_sunos" ]
				then
					if ! nvm_has_solaris_binary "${VERSION}"
					then
						nobinary=1 
						nvm_err "Currently, there is no binary of version ${VERSION} for SunOS"
					fi
				fi
				if [ $nobinary -ne 1 ] && nvm_binary_available "${VERSION}"
				then
					NVM_NO_PROGRESS="${NVM_NO_PROGRESS:-${noprogress}}" nvm_install_binary "${FLAVOR}" std "${VERSION}" "${nosource}"
					EXIT_CODE=$? 
				else
					EXIT_CODE=-1 
				fi
				if [ $EXIT_CODE -ne 0 ]
				then
					if [ -z "${NVM_MAKE_JOBS-}" ]
					then
						nvm_get_make_jobs
					fi
					if [ "_${NVM_OS}" = "_win" ]
					then
						nvm_err 'Installing from source on non-WSL Windows is not supported'
						EXIT_CODE=87 
					else
						NVM_NO_PROGRESS="${NVM_NO_PROGRESS:-${noprogress}}" nvm_install_source "${FLAVOR}" std "${VERSION}" "${NVM_MAKE_JOBS}" "${ADDITIONAL_PARAMETERS}"
						EXIT_CODE=$? 
					fi
				fi
			fi
			if [ $EXIT_CODE -eq 0 ] && nvm_use_if_needed "${VERSION}" && nvm_install_npm_if_needed "${VERSION}"
			then
				if [ -n "${LTS-}" ]
				then
					nvm_ensure_default_set "lts/${LTS}"
				else
					nvm_ensure_default_set "${provided_version}"
				fi
				if [ "${NVM_UPGRADE_NPM}" = 1 ]
				then
					nvm install-latest-npm
					EXIT_CODE=$? 
				fi
				if [ $EXIT_CODE -eq 0 ] && [ -z "${SKIP_DEFAULT_PACKAGES-}" ]
				then
					nvm_install_default_packages
				fi
				if [ $EXIT_CODE -eq 0 ] && [ -n "${REINSTALL_PACKAGES_FROM-}" ] && [ "_${REINSTALL_PACKAGES_FROM}" != "_N/A" ]
				then
					nvm reinstall-packages "${REINSTALL_PACKAGES_FROM}"
					EXIT_CODE=$? 
				fi
			else
				EXIT_CODE=$? 
			fi
			return $EXIT_CODE ;;
		("uninstall") if [ $# -ne 1 ]
			then
				nvm --help >&2
				return 127
			fi
			local PATTERN
			PATTERN="${1-}" 
			case "${PATTERN-}" in
				(--)  ;;
				(--lts | 'lts/*') VERSION="$(nvm_match_version "lts/*")"  ;;
				(lts/*) VERSION="$(nvm_match_version "lts/${PATTERN##lts/}")"  ;;
				(--lts=*) VERSION="$(nvm_match_version "lts/${PATTERN##--lts=}")"  ;;
				(*) VERSION="$(nvm_version "${PATTERN}")"  ;;
			esac
			if [ "_${VERSION}" = "_$(nvm_ls_current)" ]
			then
				if nvm_is_iojs_version "${VERSION}"
				then
					nvm_err "nvm: Cannot uninstall currently-active io.js version, ${VERSION} (inferred from ${PATTERN})."
				else
					nvm_err "nvm: Cannot uninstall currently-active node version, ${VERSION} (inferred from ${PATTERN})."
				fi
				return 1
			fi
			if ! nvm_is_version_installed "${VERSION}"
			then
				nvm_err "${VERSION} version is not installed..."
				return
			fi
			local SLUG_BINARY
			local SLUG_SOURCE
			if nvm_is_iojs_version "${VERSION}"
			then
				SLUG_BINARY="$(nvm_get_download_slug iojs binary std "${VERSION}")" 
				SLUG_SOURCE="$(nvm_get_download_slug iojs source std "${VERSION}")" 
			else
				SLUG_BINARY="$(nvm_get_download_slug node binary std "${VERSION}")" 
				SLUG_SOURCE="$(nvm_get_download_slug node source std "${VERSION}")" 
			fi
			local NVM_SUCCESS_MSG
			if nvm_is_iojs_version "${VERSION}"
			then
				NVM_SUCCESS_MSG="Uninstalled io.js $(nvm_strip_iojs_prefix "${VERSION}")" 
			else
				NVM_SUCCESS_MSG="Uninstalled node ${VERSION}" 
			fi
			local VERSION_PATH
			VERSION_PATH="$(nvm_version_path "${VERSION}")" 
			if ! nvm_check_file_permissions "${VERSION_PATH}"
			then
				nvm_err 'Cannot uninstall, incorrect permissions on installation folder.'
				nvm_err 'This is usually caused by running `npm install -g` as root. Run the following commands as root to fix the permissions and then try again.'
				nvm_err
				nvm_err "  chown -R $(whoami) \"$(nvm_sanitize_path "${VERSION_PATH}")\""
				nvm_err "  chmod -R u+w \"$(nvm_sanitize_path "${VERSION_PATH}")\""
				return 1
			fi
			local CACHE_DIR
			CACHE_DIR="$(nvm_cache_dir)" 
			command rm -rf "${CACHE_DIR}/bin/${SLUG_BINARY}/files" "${CACHE_DIR}/src/${SLUG_SOURCE}/files" "${VERSION_PATH}" 2> /dev/null
			nvm_echo "${NVM_SUCCESS_MSG}"
			for ALIAS in $(nvm_grep -l "${VERSION}" "$(nvm_alias_path)/*" 2>/dev/null)
			do
				nvm unalias "$(command basename "${ALIAS}")"
			done ;;
		("deactivate") local NVM_SILENT
			while [ $# -ne 0 ]
			do
				case "${1}" in
					(--silent) NVM_SILENT=1  ;;
					(--)  ;;
				esac
				shift
			done
			local NEWPATH
			NEWPATH="$(nvm_strip_path "${PATH}" "/bin")" 
			if [ "_${PATH}" = "_${NEWPATH}" ]
			then
				if [ "${NVM_SILENT:-0}" -ne 1 ]
				then
					nvm_err "Could not find ${NVM_DIR}/*/bin in \${PATH}"
				fi
			else
				export PATH="${NEWPATH}" 
				\hash -r
				if [ "${NVM_SILENT:-0}" -ne 1 ]
				then
					nvm_echo "${NVM_DIR}/*/bin removed from \${PATH}"
				fi
			fi
			if [ -n "${MANPATH-}" ]
			then
				NEWPATH="$(nvm_strip_path "${MANPATH}" "/share/man")" 
				if [ "_${MANPATH}" = "_${NEWPATH}" ]
				then
					if [ "${NVM_SILENT:-0}" -ne 1 ]
					then
						nvm_err "Could not find ${NVM_DIR}/*/share/man in \${MANPATH}"
					fi
				else
					export MANPATH="${NEWPATH}" 
					if [ "${NVM_SILENT:-0}" -ne 1 ]
					then
						nvm_echo "${NVM_DIR}/*/share/man removed from \${MANPATH}"
					fi
				fi
			fi
			if [ -n "${NODE_PATH-}" ]
			then
				NEWPATH="$(nvm_strip_path "${NODE_PATH}" "/lib/node_modules")" 
				if [ "_${NODE_PATH}" != "_${NEWPATH}" ]
				then
					export NODE_PATH="${NEWPATH}" 
					if [ "${NVM_SILENT:-0}" -ne 1 ]
					then
						nvm_echo "${NVM_DIR}/*/lib/node_modules removed from \${NODE_PATH}"
					fi
				fi
			fi
			unset NVM_BIN
			unset NVM_INC ;;
		("use") local PROVIDED_VERSION
			local NVM_SILENT
			local NVM_SILENT_ARG
			local NVM_DELETE_PREFIX
			NVM_DELETE_PREFIX=0 
			local NVM_LTS
			local IS_VERSION_FROM_NVMRC
			IS_VERSION_FROM_NVMRC=0 
			while [ $# -ne 0 ]
			do
				case "$1" in
					(--silent) NVM_SILENT=1 
						NVM_SILENT_ARG='--silent'  ;;
					(--delete-prefix) NVM_DELETE_PREFIX=1  ;;
					(--)  ;;
					(--lts) NVM_LTS='*'  ;;
					(--lts=*) NVM_LTS="${1##--lts=}"  ;;
					(--save | -w) NVM_WRITE_TO_NVMRC=1  ;;
					(--*)  ;;
					(*) if [ -n "${1-}" ]
						then
							PROVIDED_VERSION="$1" 
						fi ;;
				esac
				shift
			done
			if [ -n "${NVM_LTS-}" ]
			then
				VERSION="$(nvm_match_version "lts/${NVM_LTS:-*}")" 
			elif [ -z "${PROVIDED_VERSION-}" ]
			then
				NVM_SILENT="${NVM_SILENT:-0}" nvm_rc_version
				if [ -n "${NVM_RC_VERSION-}" ]
				then
					PROVIDED_VERSION="${NVM_RC_VERSION}" 
					IS_VERSION_FROM_NVMRC=1 
					VERSION="$(nvm_version "${PROVIDED_VERSION}")" 
				fi
				unset NVM_RC_VERSION
				if [ -z "${VERSION}" ]
				then
					nvm_err 'Please see `nvm --help` or https://github.com/nvm-sh/nvm#nvmrc for more information.'
					return 127
				fi
			else
				VERSION="$(nvm_match_version "${PROVIDED_VERSION}")" 
			fi
			if [ -z "${VERSION}" ]
			then
				nvm --help >&2
				return 127
			fi
			if [ "${NVM_WRITE_TO_NVMRC:-0}" -eq 1 ]
			then
				nvm_write_nvmrc "$VERSION"
			fi
			if [ "_${VERSION}" = '_system' ]
			then
				if nvm_has_system_node && nvm deactivate "${NVM_SILENT_ARG-}" > /dev/null 2>&1
				then
					if [ "${NVM_SILENT:-0}" -ne 1 ]
					then
						nvm_echo "Now using system version of node: $(node -v 2>/dev/null)$(nvm_print_npm_version)"
					fi
					return
				elif nvm_has_system_iojs && nvm deactivate "${NVM_SILENT_ARG-}" > /dev/null 2>&1
				then
					if [ "${NVM_SILENT:-0}" -ne 1 ]
					then
						nvm_echo "Now using system version of io.js: $(iojs --version 2>/dev/null)$(nvm_print_npm_version)"
					fi
					return
				elif [ "${NVM_SILENT:-0}" -ne 1 ]
				then
					nvm_err 'System version of node not found.'
				fi
				return 127
			elif [ "_${VERSION}" = "_∞" ]
			then
				if [ "${NVM_SILENT:-0}" -ne 1 ]
				then
					nvm_err "The alias \"${PROVIDED_VERSION}\" leads to an infinite loop. Aborting."
				fi
				return 8
			fi
			if [ "${VERSION}" = 'N/A' ]
			then
				if [ "${NVM_SILENT:-0}" -ne 1 ]
				then
					nvm_ensure_version_installed "${PROVIDED_VERSION}" "${IS_VERSION_FROM_NVMRC}"
				fi
				return 3
			elif ! nvm_ensure_version_installed "${VERSION}" "${IS_VERSION_FROM_NVMRC}"
			then
				return $?
			fi
			local NVM_VERSION_DIR
			NVM_VERSION_DIR="$(nvm_version_path "${VERSION}")" 
			PATH="$(nvm_change_path "${PATH}" "/bin" "${NVM_VERSION_DIR}")" 
			if nvm_has manpath
			then
				if [ -z "${MANPATH-}" ]
				then
					local MANPATH
					MANPATH=$(manpath) 
				fi
				MANPATH="$(nvm_change_path "${MANPATH}" "/share/man" "${NVM_VERSION_DIR}")" 
				export MANPATH
			fi
			export PATH
			\hash -r
			export NVM_BIN="${NVM_VERSION_DIR}/bin" 
			export NVM_INC="${NVM_VERSION_DIR}/include/node" 
			if [ "${NVM_SYMLINK_CURRENT-}" = true ]
			then
				command rm -f "${NVM_DIR}/current" && ln -s "${NVM_VERSION_DIR}" "${NVM_DIR}/current"
			fi
			local NVM_USE_OUTPUT
			NVM_USE_OUTPUT='' 
			if [ "${NVM_SILENT:-0}" -ne 1 ]
			then
				if nvm_is_iojs_version "${VERSION}"
				then
					NVM_USE_OUTPUT="Now using io.js $(nvm_strip_iojs_prefix "${VERSION}")$(nvm_print_npm_version)" 
				else
					NVM_USE_OUTPUT="Now using node ${VERSION}$(nvm_print_npm_version)" 
				fi
			fi
			if [ "_${VERSION}" != "_system" ]
			then
				local NVM_USE_CMD
				NVM_USE_CMD="nvm use --delete-prefix" 
				if [ -n "${PROVIDED_VERSION}" ]
				then
					NVM_USE_CMD="${NVM_USE_CMD} ${VERSION}" 
				fi
				if [ "${NVM_SILENT:-0}" -eq 1 ]
				then
					NVM_USE_CMD="${NVM_USE_CMD} --silent" 
				fi
				if ! nvm_die_on_prefix "${NVM_DELETE_PREFIX}" "${NVM_USE_CMD}" "${NVM_VERSION_DIR}"
				then
					return 11
				fi
			fi
			if [ -n "${NVM_USE_OUTPUT-}" ] && [ "${NVM_SILENT:-0}" -ne 1 ]
			then
				nvm_echo "${NVM_USE_OUTPUT}"
			fi ;;
		("run") local provided_version
			local has_checked_nvmrc
			has_checked_nvmrc=0 
			local IS_VERSION_FROM_NVMRC
			IS_VERSION_FROM_NVMRC=0 
			local NVM_SILENT
			local NVM_SILENT_ARG
			local NVM_LTS
			while [ $# -gt 0 ]
			do
				case "$1" in
					(--silent) NVM_SILENT=1 
						NVM_SILENT_ARG='--silent' 
						shift ;;
					(--lts) NVM_LTS='*' 
						shift ;;
					(--lts=*) NVM_LTS="${1##--lts=}" 
						shift ;;
					(*) if [ -n "$1" ]
						then
							break
						else
							shift
						fi ;;
				esac
			done
			if [ $# -lt 1 ] && [ -z "${NVM_LTS-}" ]
			then
				NVM_SILENT="${NVM_SILENT:-0}" nvm_rc_version && has_checked_nvmrc=1 
				if [ -n "${NVM_RC_VERSION-}" ]
				then
					VERSION="$(nvm_version "${NVM_RC_VERSION-}")"  || :
				fi
				unset NVM_RC_VERSION
				if [ "${VERSION:-N/A}" = 'N/A' ]
				then
					nvm --help >&2
					return 127
				fi
			fi
			if [ -z "${NVM_LTS-}" ]
			then
				provided_version="$1" 
				if [ -n "${provided_version}" ]
				then
					VERSION="$(nvm_version "${provided_version}")"  || :
					if [ "_${VERSION:-N/A}" = '_N/A' ] && ! nvm_is_valid_version "${provided_version}"
					then
						provided_version='' 
						if [ $has_checked_nvmrc -ne 1 ]
						then
							NVM_SILENT="${NVM_SILENT:-0}" nvm_rc_version && has_checked_nvmrc=1 
						fi
						provided_version="${NVM_RC_VERSION}" 
						IS_VERSION_FROM_NVMRC=1 
						VERSION="$(nvm_version "${NVM_RC_VERSION}")"  || :
						unset NVM_RC_VERSION
					else
						shift
					fi
				fi
			fi
			local NVM_IOJS
			if nvm_is_iojs_version "${VERSION}"
			then
				NVM_IOJS=true 
			fi
			local EXIT_CODE
			nvm_is_zsh && setopt local_options shwordsplit
			local LTS_ARG
			if [ -n "${NVM_LTS-}" ]
			then
				LTS_ARG="--lts=${NVM_LTS-}" 
				VERSION='' 
			fi
			if [ "_${VERSION}" = "_N/A" ]
			then
				nvm_ensure_version_installed "${provided_version}" "${IS_VERSION_FROM_NVMRC}"
			elif [ "${NVM_IOJS}" = true ]
			then
				nvm exec "${NVM_SILENT_ARG-}" "${LTS_ARG-}" "${VERSION}" iojs "$@"
			else
				nvm exec "${NVM_SILENT_ARG-}" "${LTS_ARG-}" "${VERSION}" node "$@"
			fi
			EXIT_CODE="$?" 
			return $EXIT_CODE ;;
		("exec") local NVM_SILENT
			local NVM_LTS
			while [ $# -gt 0 ]
			do
				case "$1" in
					(--silent) NVM_SILENT=1 
						shift ;;
					(--lts) NVM_LTS='*' 
						shift ;;
					(--lts=*) NVM_LTS="${1##--lts=}" 
						shift ;;
					(--) break ;;
					(--*) nvm_err "Unsupported option \"$1\"."
						return 55 ;;
					(*) if [ -n "$1" ]
						then
							break
						else
							shift
						fi ;;
				esac
			done
			local provided_version
			provided_version="$1" 
			if [ "${NVM_LTS-}" != '' ]
			then
				provided_version="lts/${NVM_LTS:-*}" 
				VERSION="${provided_version}" 
			elif [ -n "${provided_version}" ]
			then
				VERSION="$(nvm_version "${provided_version}")"  || :
				if [ "_${VERSION}" = '_N/A' ] && ! nvm_is_valid_version "${provided_version}"
				then
					NVM_SILENT="${NVM_SILENT:-0}" nvm_rc_version && has_checked_nvmrc=1 
					provided_version="${NVM_RC_VERSION}" 
					unset NVM_RC_VERSION
					VERSION="$(nvm_version "${provided_version}")"  || :
				else
					shift
				fi
			fi
			nvm_ensure_version_installed "${provided_version}"
			EXIT_CODE=$? 
			if [ "${EXIT_CODE}" != "0" ]
			then
				return $EXIT_CODE
			fi
			if [ "${NVM_SILENT:-0}" -ne 1 ]
			then
				if [ "${NVM_LTS-}" = '*' ]
				then
					nvm_echo "Running node latest LTS -> $(nvm_version "${VERSION}")$(nvm use --silent "${VERSION}" && nvm_print_npm_version)"
				elif [ -n "${NVM_LTS-}" ]
				then
					nvm_echo "Running node LTS \"${NVM_LTS-}\" -> $(nvm_version "${VERSION}")$(nvm use --silent "${VERSION}" && nvm_print_npm_version)"
				elif nvm_is_iojs_version "${VERSION}"
				then
					nvm_echo "Running io.js $(nvm_strip_iojs_prefix "${VERSION}")$(nvm use --silent "${VERSION}" && nvm_print_npm_version)"
				else
					nvm_echo "Running node ${VERSION}$(nvm use --silent "${VERSION}" && nvm_print_npm_version)"
				fi
			fi
			NODE_VERSION="${VERSION}" "${NVM_DIR}/nvm-exec" "$@" ;;
		("ls" | "list") local PATTERN
			local NVM_NO_COLORS
			local NVM_NO_ALIAS
			while [ $# -gt 0 ]
			do
				case "${1}" in
					(--)  ;;
					(--no-colors) NVM_NO_COLORS="${1}"  ;;
					(--no-alias) NVM_NO_ALIAS="${1}"  ;;
					(--*) nvm_err "Unsupported option \"${1}\"."
						return 55 ;;
					(*) PATTERN="${PATTERN:-$1}"  ;;
				esac
				shift
			done
			if [ -n "${PATTERN-}" ] && [ -n "${NVM_NO_ALIAS-}" ]
			then
				nvm_err '`--no-alias` is not supported when a pattern is provided.'
				return 55
			fi
			local NVM_LS_OUTPUT
			local NVM_LS_EXIT_CODE
			NVM_LS_OUTPUT=$(nvm_ls "${PATTERN-}") 
			NVM_LS_EXIT_CODE=$? 
			NVM_NO_COLORS="${NVM_NO_COLORS-}" nvm_print_versions "${NVM_LS_OUTPUT}"
			if [ -z "${NVM_NO_ALIAS-}" ] && [ -z "${PATTERN-}" ]
			then
				if [ -n "${NVM_NO_COLORS-}" ]
				then
					nvm alias --no-colors
				else
					nvm alias
				fi
			fi
			return $NVM_LS_EXIT_CODE ;;
		("ls-remote" | "list-remote") local NVM_LTS
			local PATTERN
			local NVM_NO_COLORS
			while [ $# -gt 0 ]
			do
				case "${1-}" in
					(--)  ;;
					(--lts) NVM_LTS='*'  ;;
					(--lts=*) NVM_LTS="${1##--lts=}"  ;;
					(--no-colors) NVM_NO_COLORS="${1}"  ;;
					(--*) nvm_err "Unsupported option \"${1}\"."
						return 55 ;;
					(*) if [ -z "${PATTERN-}" ]
						then
							PATTERN="${1-}" 
							if [ -z "${NVM_LTS-}" ]
							then
								case "${PATTERN}" in
									('lts/*') NVM_LTS='*' 
										PATTERN=''  ;;
									(lts/*) NVM_LTS="${PATTERN##lts/}" 
										PATTERN=''  ;;
								esac
							fi
						fi ;;
				esac
				shift
			done
			local NVM_OUTPUT
			local EXIT_CODE
			NVM_OUTPUT="$(NVM_LTS="${NVM_LTS-}" nvm_remote_versions "${PATTERN}" &&:)" 
			EXIT_CODE=$? 
			if [ -n "${NVM_OUTPUT}" ]
			then
				NVM_NO_COLORS="${NVM_NO_COLORS-}" nvm_print_versions "${NVM_OUTPUT}"
				return $EXIT_CODE
			fi
			NVM_NO_COLORS="${NVM_NO_COLORS-}" nvm_print_versions "N/A"
			return 3 ;;
		("current") nvm_version current ;;
		("which") local NVM_SILENT
			local provided_version
			while [ $# -ne 0 ]
			do
				case "${1}" in
					(--silent) NVM_SILENT=1  ;;
					(--)  ;;
					(*) provided_version="${1-}"  ;;
				esac
				shift
			done
			if [ -z "${provided_version-}" ]
			then
				NVM_SILENT="${NVM_SILENT:-0}" nvm_rc_version
				if [ -n "${NVM_RC_VERSION}" ]
				then
					provided_version="${NVM_RC_VERSION}" 
					VERSION=$(nvm_version "${NVM_RC_VERSION}")  || :
				fi
				unset NVM_RC_VERSION
			elif [ "${provided_version}" != 'system' ]
			then
				VERSION="$(nvm_version "${provided_version}")"  || :
			else
				VERSION="${provided_version-}" 
			fi
			if [ -z "${VERSION}" ]
			then
				nvm --help >&2
				return 127
			fi
			if [ "_${VERSION}" = '_system' ]
			then
				if nvm_has_system_iojs > /dev/null 2>&1 || nvm_has_system_node > /dev/null 2>&1
				then
					local NVM_BIN
					NVM_BIN="$(nvm use system >/dev/null 2>&1 && command which node)" 
					if [ -n "${NVM_BIN}" ]
					then
						nvm_echo "${NVM_BIN}"
						return
					fi
					return 1
				fi
				nvm_err 'System version of node not found.'
				return 127
			elif [ "${VERSION}" = '∞' ]
			then
				nvm_err "The alias \"${2}\" leads to an infinite loop. Aborting."
				return 8
			fi
			nvm_ensure_version_installed "${provided_version}"
			EXIT_CODE=$? 
			if [ "${EXIT_CODE}" != "0" ]
			then
				return $EXIT_CODE
			fi
			local NVM_VERSION_DIR
			NVM_VERSION_DIR="$(nvm_version_path "${VERSION}")" 
			nvm_echo "${NVM_VERSION_DIR}/bin/node" ;;
		("alias") local NVM_ALIAS_DIR
			NVM_ALIAS_DIR="$(nvm_alias_path)" 
			local NVM_CURRENT
			NVM_CURRENT="$(nvm_ls_current)" 
			command mkdir -p "${NVM_ALIAS_DIR}/lts"
			local ALIAS
			local TARGET
			local NVM_NO_COLORS
			ALIAS='--' 
			TARGET='--' 
			while [ $# -gt 0 ]
			do
				case "${1-}" in
					(--)  ;;
					(--no-colors) NVM_NO_COLORS="${1}"  ;;
					(--*) nvm_err "Unsupported option \"${1}\"."
						return 55 ;;
					(*) if [ "${ALIAS}" = '--' ]
						then
							ALIAS="${1-}" 
						elif [ "${TARGET}" = '--' ]
						then
							TARGET="${1-}" 
						fi ;;
				esac
				shift
			done
			if [ -z "${TARGET}" ]
			then
				nvm unalias "${ALIAS}"
				return $?
			elif echo "${ALIAS}" | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,.venv,venv} -q "#"
			then
				nvm_err 'Aliases with a comment delimiter (#) are not supported.'
				return 1
			elif [ "${TARGET}" != '--' ]
			then
				if [ "${ALIAS#*\/}" != "${ALIAS}" ]
				then
					nvm_err 'Aliases in subdirectories are not supported.'
					return 1
				fi
				VERSION="$(nvm_version "${TARGET}")"  || :
				if [ "${VERSION}" = 'N/A' ]
				then
					nvm_err "! WARNING: Version '${TARGET}' does not exist."
				fi
				nvm_make_alias "${ALIAS}" "${TARGET}"
				NVM_NO_COLORS="${NVM_NO_COLORS-}" NVM_CURRENT="${NVM_CURRENT-}" DEFAULT=false nvm_print_formatted_alias "${ALIAS}" "${TARGET}" "${VERSION}"
			else
				if [ "${ALIAS-}" = '--' ]
				then
					unset ALIAS
				fi
				nvm_list_aliases "${ALIAS-}"
			fi ;;
		("unalias") local NVM_ALIAS_DIR
			NVM_ALIAS_DIR="$(nvm_alias_path)" 
			command mkdir -p "${NVM_ALIAS_DIR}"
			if [ $# -ne 1 ]
			then
				nvm --help >&2
				return 127
			fi
			if [ "${1#*\/}" != "${1-}" ]
			then
				nvm_err 'Aliases in subdirectories are not supported.'
				return 1
			fi
			local NVM_IOJS_PREFIX
			local NVM_NODE_PREFIX
			NVM_IOJS_PREFIX="$(nvm_iojs_prefix)" 
			NVM_NODE_PREFIX="$(nvm_node_prefix)" 
			local NVM_ALIAS_EXISTS
			NVM_ALIAS_EXISTS=0 
			if [ -f "${NVM_ALIAS_DIR}/${1-}" ]
			then
				NVM_ALIAS_EXISTS=1 
			fi
			if [ $NVM_ALIAS_EXISTS -eq 0 ]
			then
				case "$1" in
					("stable" | "unstable" | "${NVM_IOJS_PREFIX}" | "${NVM_NODE_PREFIX}" | "system") nvm_err "${1-} is a default (built-in) alias and cannot be deleted."
						return 1 ;;
				esac
				nvm_err "Alias ${1-} doesn't exist!"
				return
			fi
			local NVM_ALIAS_ORIGINAL
			NVM_ALIAS_ORIGINAL="$(nvm_alias "${1}")" 
			command rm -f "${NVM_ALIAS_DIR}/${1}"
			nvm_echo "Deleted alias ${1} - restore it with \`nvm alias \"${1}\" \"${NVM_ALIAS_ORIGINAL}\"\`" ;;
		("install-latest-npm") if [ $# -ne 0 ]
			then
				nvm --help >&2
				return 127
			fi
			nvm_install_latest_npm ;;
		("reinstall-packages" | "copy-packages") if [ $# -ne 1 ]
			then
				nvm --help >&2
				return 127
			fi
			local PROVIDED_VERSION
			PROVIDED_VERSION="${1-}" 
			if [ "${PROVIDED_VERSION}" = "$(nvm_ls_current)" ] || [ "$(nvm_version "${PROVIDED_VERSION}" ||:)" = "$(nvm_ls_current)" ]
			then
				nvm_err 'Can not reinstall packages from the current version of node.'
				return 2
			fi
			local VERSION
			if [ "_${PROVIDED_VERSION}" = "_system" ]
			then
				if ! nvm_has_system_node && ! nvm_has_system_iojs
				then
					nvm_err 'No system version of node or io.js detected.'
					return 3
				fi
				VERSION="system" 
			else
				VERSION="$(nvm_version "${PROVIDED_VERSION}")"  || :
			fi
			local NPMLIST
			NPMLIST="$(nvm_npm_global_modules "${VERSION}")" 
			local INSTALLS
			local LINKS
			INSTALLS="${NPMLIST%% //// *}" 
			LINKS="${NPMLIST##* //// }" 
			nvm_echo "Reinstalling global packages from ${VERSION}..."
			if [ -n "${INSTALLS}" ]
			then
				nvm_echo "${INSTALLS}" | command xargs npm install -g --quiet
			else
				nvm_echo "No installed global packages found..."
			fi
			nvm_echo "Linking global packages from ${VERSION}..."
			if [ -n "${LINKS}" ]
			then
				(
					set -f
					IFS='
' 
					for LINK in ${LINKS}
					do
						set +f
						unset IFS
						if [ -n "${LINK}" ]
						then
							case "${LINK}" in
								('/'*) (
										nvm_cd "${LINK}" && npm link
									) ;;
								(*) (
										nvm_cd "$(npm root -g)/../${LINK}" && npm link
									) ;;
							esac
						fi
					done
				)
			else
				nvm_echo "No linked global packages found..."
			fi ;;
		("clear-cache") command rm -f "${NVM_DIR}/v*" "$(nvm_version_dir)" 2> /dev/null
			nvm_echo 'nvm cache cleared.' ;;
		("version") nvm_version "${1}" ;;
		("version-remote") local NVM_LTS
			local PATTERN
			while [ $# -gt 0 ]
			do
				case "${1-}" in
					(--)  ;;
					(--lts) NVM_LTS='*'  ;;
					(--lts=*) NVM_LTS="${1##--lts=}"  ;;
					(--*) nvm_err "Unsupported option \"${1}\"."
						return 55 ;;
					(*) PATTERN="${PATTERN:-${1}}"  ;;
				esac
				shift
			done
			case "${PATTERN-}" in
				('lts/*') NVM_LTS='*' 
					unset PATTERN ;;
				(lts/*) NVM_LTS="${PATTERN##lts/}" 
					unset PATTERN ;;
			esac
			NVM_VERSION_ONLY=true NVM_LTS="${NVM_LTS-}" nvm_remote_version "${PATTERN:-node}" ;;
		("--version" | "-v") nvm_echo '0.40.0' ;;
		("unload") nvm deactivate > /dev/null 2>&1
			unset -f nvm nvm_iojs_prefix nvm_node_prefix nvm_add_iojs_prefix nvm_strip_iojs_prefix nvm_is_iojs_version nvm_is_alias nvm_has_non_aliased nvm_ls_remote nvm_ls_remote_iojs nvm_ls_remote_index_tab nvm_ls nvm_remote_version nvm_remote_versions nvm_install_binary nvm_install_source nvm_clang_version nvm_get_mirror nvm_get_download_slug nvm_download_artifact nvm_install_npm_if_needed nvm_use_if_needed nvm_check_file_permissions nvm_print_versions nvm_compute_checksum nvm_get_checksum_binary nvm_get_checksum_alg nvm_get_checksum nvm_compare_checksum nvm_version nvm_rc_version nvm_match_version nvm_ensure_default_set nvm_get_arch nvm_get_os nvm_print_implicit_alias nvm_validate_implicit_alias nvm_resolve_alias nvm_ls_current nvm_alias nvm_binary_available nvm_change_path nvm_strip_path nvm_num_version_groups nvm_format_version nvm_ensure_version_prefix nvm_normalize_version nvm_is_valid_version nvm_normalize_lts nvm_ensure_version_installed nvm_cache_dir nvm_version_path nvm_alias_path nvm_version_dir nvm_find_nvmrc nvm_find_up nvm_find_project_dir nvm_tree_contains_path nvm_version_greater nvm_version_greater_than_or_equal_to nvm_print_npm_version nvm_install_latest_npm nvm_npm_global_modules nvm_has_system_node nvm_has_system_iojs nvm_download nvm_get_latest nvm_has nvm_install_default_packages nvm_get_default_packages nvm_curl_use_compression nvm_curl_version nvm_auto nvm_supports_xz nvm_echo nvm_err nvm_grep nvm_cd nvm_die_on_prefix nvm_get_make_jobs nvm_get_minor_version nvm_has_solaris_binary nvm_is_merged_node_version nvm_is_natural_num nvm_is_version_installed nvm_list_aliases nvm_make_alias nvm_print_alias_path nvm_print_default_alias nvm_print_formatted_alias nvm_resolve_local_alias nvm_sanitize_path nvm_has_colors nvm_process_parameters nvm_node_version_has_solaris_binary nvm_iojs_version_has_solaris_binary nvm_curl_libz_support nvm_command_info nvm_is_zsh nvm_stdout_is_terminal nvm_npmrc_bad_news_bears nvm_sanitize_auth_header nvm_get_colors nvm_set_colors nvm_print_color_code nvm_wrap_with_color_code nvm_format_help_message_colors nvm_echo_with_colors nvm_err_with_colors nvm_get_artifact_compression nvm_install_binary_extract nvm_extract_tarball nvm_process_nvmrc nvm_nvmrc_invalid_msg nvm_write_nvmrc > /dev/null 2>&1
			unset NVM_RC_VERSION NVM_NODEJS_ORG_MIRROR NVM_IOJS_ORG_MIRROR NVM_DIR NVM_CD_FLAGS NVM_BIN NVM_INC NVM_MAKE_JOBS NVM_COLORS INSTALLED_COLOR SYSTEM_COLOR CURRENT_COLOR NOT_INSTALLED_COLOR DEFAULT_COLOR LTS_COLOR > /dev/null 2>&1 ;;
		("set-colors") local EXIT_CODE
			nvm_set_colors "${1-}"
			EXIT_CODE=$? 
			if [ "$EXIT_CODE" -eq 17 ]
			then
				nvm --help >&2
				nvm_echo
				nvm_err_with_colors "\033[1;37mPlease pass in five \033[1;31mvalid color codes\033[1;37m. Choose from: rRgGbBcCyYmMkKeW\033[0m"
			fi ;;
		(*) nvm --help >&2
			return 127 ;;
	esac
}
nvm_add_iojs_prefix () {
	nvm_echo "$(nvm_iojs_prefix)-$(nvm_ensure_version_prefix "$(nvm_strip_iojs_prefix "${1-}")")"
}
nvm_alias () {
	local ALIAS
	ALIAS="${1-}" 
	if [ -z "${ALIAS}" ]
	then
		nvm_err 'An alias is required.'
		return 1
	fi
	ALIAS="$(nvm_normalize_lts "${ALIAS}")" 
	if [ -z "${ALIAS}" ]
	then
		return 2
	fi
	local NVM_ALIAS_PATH
	NVM_ALIAS_PATH="$(nvm_alias_path)/${ALIAS}" 
	if [ ! -f "${NVM_ALIAS_PATH}" ]
	then
		nvm_err 'Alias does not exist.'
		return 2
	fi
	command awk 'NF' "${NVM_ALIAS_PATH}"
}
nvm_alias_path () {
	nvm_echo "$(nvm_version_dir old)/alias"
}
nvm_auto () {
	local NVM_MODE
	NVM_MODE="${1-}" 
	local VERSION
	local NVM_CURRENT
	if [ "_${NVM_MODE}" = '_install' ]
	then
		VERSION="$(nvm_alias default 2>/dev/null || nvm_echo)" 
		if [ -n "${VERSION}" ] && ! [ "_${VERSION}" = '_N/A' ] && nvm_is_valid_version "${VERSION}"
		then
			nvm install "${VERSION}" > /dev/null
		elif nvm_rc_version > /dev/null 2>&1
		then
			nvm install > /dev/null
		fi
	elif [ "_$NVM_MODE" = '_use' ]
	then
		NVM_CURRENT="$(nvm_ls_current)" 
		if [ "_${NVM_CURRENT}" = '_none' ] || [ "_${NVM_CURRENT}" = '_system' ]
		then
			VERSION="$(nvm_resolve_local_alias default 2>/dev/null || nvm_echo)" 
			if [ -n "${VERSION}" ] && ! [ "_${VERSION}" = '_N/A' ] && nvm_is_valid_version "${VERSION}"
			then
				nvm use --silent "${VERSION}" > /dev/null
			elif nvm_rc_version > /dev/null 2>&1
			then
				nvm use --silent > /dev/null
			fi
		else
			nvm use --silent "${NVM_CURRENT}" > /dev/null
		fi
	elif [ "_${NVM_MODE}" != '_none' ]
	then
		nvm_err 'Invalid auto mode supplied.'
		return 1
	fi
}
nvm_binary_available () {
	nvm_version_greater_than_or_equal_to "$(nvm_strip_iojs_prefix "${1-}")" v0.8.6
}
nvm_cache_dir () {
	nvm_echo "${NVM_DIR}/.cache"
}
nvm_cd () {
	\cd "$@"
}
nvm_change_path () {
	if [ -z "${1-}" ]
	then
		nvm_echo "${3-}${2-}"
	elif ! nvm_echo "${1-}" | nvm_grep -q "${NVM_DIR}/[^/]*${2-}" && ! nvm_echo "${1-}" | nvm_grep -q "${NVM_DIR}/versions/[^/]*/[^/]*${2-}"
	then
		nvm_echo "${3-}${2-}:${1-}"
	elif nvm_echo "${1-}" | nvm_grep -Eq "(^|:)(/usr(/local)?)?${2-}:.*${NVM_DIR}/[^/]*${2-}" || nvm_echo "${1-}" | nvm_grep -Eq "(^|:)(/usr(/local)?)?${2-}:.*${NVM_DIR}/versions/[^/]*/[^/]*${2-}"
	then
		nvm_echo "${3-}${2-}:${1-}"
	else
		nvm_echo "${1-}" | command sed -e "s#${NVM_DIR}/[^/]*${2-}[^:]*#${3-}${2-}#" -e "s#${NVM_DIR}/versions/[^/]*/[^/]*${2-}[^:]*#${3-}${2-}#"
	fi
}
nvm_check_file_permissions () {
	nvm_is_zsh && setopt local_options nonomatch
	for FILE in "$1"/* "$1"/.[!.]* "$1"/..?*
	do
		if [ -d "$FILE" ]
		then
			if [ -n "${NVM_DEBUG-}" ]
			then
				nvm_err "${FILE}"
			fi
			if [ ! -L "${FILE}" ] && ! nvm_check_file_permissions "${FILE}"
			then
				return 2
			fi
		elif [ -e "$FILE" ] && [ ! -w "$FILE" ] && [ ! -O "$FILE" ]
		then
			nvm_err "file is not writable or self-owned: $(nvm_sanitize_path "$FILE")"
			return 1
		fi
	done
	return 0
}
nvm_clang_version () {
	clang --version | command awk '{ if ($2 == "version") print $3; else if ($3 == "version") print $4 }' | command sed 's/-.*$//g'
}
nvm_command_info () {
	local COMMAND
	local INFO
	COMMAND="${1}" 
	if type "${COMMAND}" | nvm_grep -q hashed
	then
		INFO="$(type "${COMMAND}" | command sed -E 's/\(|\)//g' | command awk '{print $4}')" 
	elif type "${COMMAND}" | nvm_grep -q aliased
	then
		INFO="$(which "${COMMAND}") ($(type "${COMMAND}" | command awk '{ $1=$2=$3=$4="" ;print }' | command sed -e 's/^\ *//g' -Ee "s/\`|'//g"))" 
	elif type "${COMMAND}" | nvm_grep -q "^${COMMAND} is an alias for"
	then
		INFO="$(which "${COMMAND}") ($(type "${COMMAND}" | command awk '{ $1=$2=$3=$4=$5="" ;print }' | command sed 's/^\ *//g'))" 
	elif type "${COMMAND}" | nvm_grep -q "^${COMMAND} is /"
	then
		INFO="$(type "${COMMAND}" | command awk '{print $3}')" 
	else
		INFO="$(type "${COMMAND}")" 
	fi
	nvm_echo "${INFO}"
}
nvm_compare_checksum () {
	local FILE
	FILE="${1-}" 
	if [ -z "${FILE}" ]
	then
		nvm_err 'Provided file to checksum is empty.'
		return 4
	elif ! [ -f "${FILE}" ]
	then
		nvm_err 'Provided file to checksum does not exist.'
		return 3
	fi
	local COMPUTED_SUM
	COMPUTED_SUM="$(nvm_compute_checksum "${FILE}")" 
	local CHECKSUM
	CHECKSUM="${2-}" 
	if [ -z "${CHECKSUM}" ]
	then
		nvm_err 'Provided checksum to compare to is empty.'
		return 2
	fi
	if [ -z "${COMPUTED_SUM}" ]
	then
		nvm_err "Computed checksum of '${FILE}' is empty."
		nvm_err 'WARNING: Continuing *without checksum verification*'
		return
	elif [ "${COMPUTED_SUM}" != "${CHECKSUM}" ] && [ "${COMPUTED_SUM}" != "\\${CHECKSUM}" ]
	then
		nvm_err "Checksums do not match: '${COMPUTED_SUM}' found, '${CHECKSUM}' expected."
		return 1
	fi
	nvm_err 'Checksums matched!'
}
nvm_compute_checksum () {
	local FILE
	FILE="${1-}" 
	if [ -z "${FILE}" ]
	then
		nvm_err 'Provided file to checksum is empty.'
		return 2
	elif ! [ -f "${FILE}" ]
	then
		nvm_err 'Provided file to checksum does not exist.'
		return 1
	fi
	if nvm_has_non_aliased "sha256sum"
	then
		nvm_err 'Computing checksum with sha256sum'
		command sha256sum "${FILE}" | command awk '{print $1}'
	elif nvm_has_non_aliased "shasum"
	then
		nvm_err 'Computing checksum with shasum -a 256'
		command shasum -a 256 "${FILE}" | command awk '{print $1}'
	elif nvm_has_non_aliased "sha256"
	then
		nvm_err 'Computing checksum with sha256 -q'
		command sha256 -q "${FILE}" | command awk '{print $1}'
	elif nvm_has_non_aliased "gsha256sum"
	then
		nvm_err 'Computing checksum with gsha256sum'
		command gsha256sum "${FILE}" | command awk '{print $1}'
	elif nvm_has_non_aliased "openssl"
	then
		nvm_err 'Computing checksum with openssl dgst -sha256'
		command openssl dgst -sha256 "${FILE}" | command awk '{print $NF}'
	elif nvm_has_non_aliased "bssl"
	then
		nvm_err 'Computing checksum with bssl sha256sum'
		command bssl sha256sum "${FILE}" | command awk '{print $1}'
	elif nvm_has_non_aliased "sha1sum"
	then
		nvm_err 'Computing checksum with sha1sum'
		command sha1sum "${FILE}" | command awk '{print $1}'
	elif nvm_has_non_aliased "sha1"
	then
		nvm_err 'Computing checksum with sha1 -q'
		command sha1 -q "${FILE}"
	fi
}
nvm_curl_libz_support () {
	curl -V 2> /dev/null | nvm_grep "^Features:" | nvm_grep -q "libz"
}
nvm_curl_use_compression () {
	nvm_curl_libz_support && nvm_version_greater_than_or_equal_to "$(nvm_curl_version)" 7.21.0
}
nvm_curl_version () {
	curl -V | command awk '{ if ($1 == "curl") print $2 }' | command sed 's/-.*$//g'
}
nvm_die_on_prefix () {
	local NVM_DELETE_PREFIX
	NVM_DELETE_PREFIX="${1-}" 
	case "${NVM_DELETE_PREFIX}" in
		(0 | 1)  ;;
		(*) nvm_err 'First argument "delete the prefix" must be zero or one'
			return 1 ;;
	esac
	local NVM_COMMAND
	NVM_COMMAND="${2-}" 
	local NVM_VERSION_DIR
	NVM_VERSION_DIR="${3-}" 
	if [ -z "${NVM_COMMAND}" ] || [ -z "${NVM_VERSION_DIR}" ]
	then
		nvm_err 'Second argument "nvm command", and third argument "nvm version dir", must both be nonempty'
		return 2
	fi
	if [ -n "${PREFIX-}" ] && [ "$(nvm_version_path "$(node -v)")" != "${PREFIX}" ]
	then
		nvm deactivate > /dev/null 2>&1
		nvm_err "nvm is not compatible with the \"PREFIX\" environment variable: currently set to \"${PREFIX}\""
		nvm_err 'Run `unset PREFIX` to unset it.'
		return 3
	fi
	local NVM_OS
	NVM_OS="$(nvm_get_os)" 
	local NVM_NPM_CONFIG_x_PREFIX_ENV
	NVM_NPM_CONFIG_x_PREFIX_ENV="$(command awk 'BEGIN { for (name in ENVIRON) if (toupper(name) == "NPM_CONFIG_PREFIX") { print name; break } }')" 
	if [ -n "${NVM_NPM_CONFIG_x_PREFIX_ENV-}" ]
	then
		local NVM_CONFIG_VALUE
		eval "NVM_CONFIG_VALUE=\"\$${NVM_NPM_CONFIG_x_PREFIX_ENV}\""
		if [ -n "${NVM_CONFIG_VALUE-}" ] && [ "_${NVM_OS}" = "_win" ]
		then
			NVM_CONFIG_VALUE="$(cd "$NVM_CONFIG_VALUE" 2>/dev/null && pwd)" 
		fi
		if [ -n "${NVM_CONFIG_VALUE-}" ] && ! nvm_tree_contains_path "${NVM_DIR}" "${NVM_CONFIG_VALUE}"
		then
			nvm deactivate > /dev/null 2>&1
			nvm_err "nvm is not compatible with the \"${NVM_NPM_CONFIG_x_PREFIX_ENV}\" environment variable: currently set to \"${NVM_CONFIG_VALUE}\""
			nvm_err "Run \`unset ${NVM_NPM_CONFIG_x_PREFIX_ENV}\` to unset it."
			return 4
		fi
	fi
	local NVM_NPM_BUILTIN_NPMRC
	NVM_NPM_BUILTIN_NPMRC="${NVM_VERSION_DIR}/lib/node_modules/npm/npmrc" 
	if nvm_npmrc_bad_news_bears "${NVM_NPM_BUILTIN_NPMRC}"
	then
		if [ "_${NVM_DELETE_PREFIX}" = "_1" ]
		then
			npm config --loglevel=warn delete prefix --userconfig="${NVM_NPM_BUILTIN_NPMRC}"
			npm config --loglevel=warn delete globalconfig --userconfig="${NVM_NPM_BUILTIN_NPMRC}"
		else
			nvm_err "Your builtin npmrc file ($(nvm_sanitize_path "${NVM_NPM_BUILTIN_NPMRC}"))"
			nvm_err 'has a `globalconfig` and/or a `prefix` setting, which are incompatible with nvm.'
			nvm_err "Run \`${NVM_COMMAND}\` to unset it."
			return 10
		fi
	fi
	local NVM_NPM_GLOBAL_NPMRC
	NVM_NPM_GLOBAL_NPMRC="${NVM_VERSION_DIR}/etc/npmrc" 
	if nvm_npmrc_bad_news_bears "${NVM_NPM_GLOBAL_NPMRC}"
	then
		if [ "_${NVM_DELETE_PREFIX}" = "_1" ]
		then
			npm config --global --loglevel=warn delete prefix
			npm config --global --loglevel=warn delete globalconfig
		else
			nvm_err "Your global npmrc file ($(nvm_sanitize_path "${NVM_NPM_GLOBAL_NPMRC}"))"
			nvm_err 'has a `globalconfig` and/or a `prefix` setting, which are incompatible with nvm.'
			nvm_err "Run \`${NVM_COMMAND}\` to unset it."
			return 10
		fi
	fi
	local NVM_NPM_USER_NPMRC
	NVM_NPM_USER_NPMRC="${HOME}/.npmrc" 
	if nvm_npmrc_bad_news_bears "${NVM_NPM_USER_NPMRC}"
	then
		if [ "_${NVM_DELETE_PREFIX}" = "_1" ]
		then
			npm config --loglevel=warn delete prefix --userconfig="${NVM_NPM_USER_NPMRC}"
			npm config --loglevel=warn delete globalconfig --userconfig="${NVM_NPM_USER_NPMRC}"
		else
			nvm_err "Your user’s .npmrc file ($(nvm_sanitize_path "${NVM_NPM_USER_NPMRC}"))"
			nvm_err 'has a `globalconfig` and/or a `prefix` setting, which are incompatible with nvm.'
			nvm_err "Run \`${NVM_COMMAND}\` to unset it."
			return 10
		fi
	fi
	local NVM_NPM_PROJECT_NPMRC
	NVM_NPM_PROJECT_NPMRC="$(nvm_find_project_dir)/.npmrc" 
	if nvm_npmrc_bad_news_bears "${NVM_NPM_PROJECT_NPMRC}"
	then
		if [ "_${NVM_DELETE_PREFIX}" = "_1" ]
		then
			npm config --loglevel=warn delete prefix
			npm config --loglevel=warn delete globalconfig
		else
			nvm_err "Your project npmrc file ($(nvm_sanitize_path "${NVM_NPM_PROJECT_NPMRC}"))"
			nvm_err 'has a `globalconfig` and/or a `prefix` setting, which are incompatible with nvm.'
			nvm_err "Run \`${NVM_COMMAND}\` to unset it."
			return 10
		fi
	fi
}
nvm_download () {
	if nvm_has "curl"
	then
		local CURL_COMPRESSED_FLAG="" 
		local CURL_HEADER_FLAG="" 
		if [ -n "${NVM_AUTH_HEADER:-}" ]
		then
			sanitized_header=$(nvm_sanitize_auth_header "${NVM_AUTH_HEADER}") 
			CURL_HEADER_FLAG="--header \"Authorization: ${sanitized_header}\"" 
		fi
		if nvm_curl_use_compression
		then
			CURL_COMPRESSED_FLAG="--compressed" 
		fi
		eval "curl -q --fail ${CURL_COMPRESSED_FLAG:-} ${CURL_HEADER_FLAG:-} $*"
	elif nvm_has "wget"
	then
		ARGS=$(nvm_echo "$@" | command sed -e 's/--progress-bar /--progress=bar /' \
                            -e 's/--compressed //' \
                            -e 's/--fail //' \
                            -e 's/-L //' \
                            -e 's/-I /--server-response /' \
                            -e 's/-s /-q /' \
                            -e 's/-sS /-nv /' \
                            -e 's/-o /-O /' \
                            -e 's/-C - /-c /') 
		if [ -n "${NVM_AUTH_HEADER:-}" ]
		then
			ARGS="${ARGS} --header \"${NVM_AUTH_HEADER}\"" 
		fi
		eval wget $ARGS
	fi
}
nvm_download_artifact () {
	local FLAVOR
	case "${1-}" in
		(node | iojs) FLAVOR="${1}"  ;;
		(*) nvm_err 'supported flavors: node, iojs'
			return 1 ;;
	esac
	local KIND
	case "${2-}" in
		(binary | source) KIND="${2}"  ;;
		(*) nvm_err 'supported kinds: binary, source'
			return 1 ;;
	esac
	local TYPE
	TYPE="${3-}" 
	local MIRROR
	MIRROR="$(nvm_get_mirror "${FLAVOR}" "${TYPE}")" 
	if [ -z "${MIRROR}" ]
	then
		return 2
	fi
	local VERSION
	VERSION="${4}" 
	if [ -z "${VERSION}" ]
	then
		nvm_err 'A version number is required.'
		return 3
	fi
	if [ "${KIND}" = 'binary' ] && ! nvm_binary_available "${VERSION}"
	then
		nvm_err "No precompiled binary available for ${VERSION}."
		return
	fi
	local SLUG
	SLUG="$(nvm_get_download_slug "${FLAVOR}" "${KIND}" "${VERSION}")" 
	local COMPRESSION
	COMPRESSION="$(nvm_get_artifact_compression "${VERSION}")" 
	local CHECKSUM
	CHECKSUM="$(nvm_get_checksum "${FLAVOR}" "${TYPE}" "${VERSION}" "${SLUG}" "${COMPRESSION}")" 
	local tmpdir
	if [ "${KIND}" = 'binary' ]
	then
		tmpdir="$(nvm_cache_dir)/bin/${SLUG}" 
	else
		tmpdir="$(nvm_cache_dir)/src/${SLUG}" 
	fi
	command mkdir -p "${tmpdir}/files" || (
		nvm_err "creating directory ${tmpdir}/files failed"
		return 3
	)
	local TARBALL
	TARBALL="${tmpdir}/${SLUG}.${COMPRESSION}" 
	local TARBALL_URL
	if nvm_version_greater_than_or_equal_to "${VERSION}" 0.1.14
	then
		TARBALL_URL="${MIRROR}/${VERSION}/${SLUG}.${COMPRESSION}" 
	else
		TARBALL_URL="${MIRROR}/${SLUG}.${COMPRESSION}" 
	fi
	if [ -r "${TARBALL}" ]
	then
		nvm_err "Local cache found: $(nvm_sanitize_path "${TARBALL}")"
		if nvm_compare_checksum "${TARBALL}" "${CHECKSUM}" > /dev/null 2>&1
		then
			nvm_err "Checksums match! Using existing downloaded archive $(nvm_sanitize_path "${TARBALL}")"
			nvm_echo "${TARBALL}"
			return 0
		fi
		nvm_compare_checksum "${TARBALL}" "${CHECKSUM}"
		nvm_err "Checksum check failed!"
		nvm_err "Removing the broken local cache..."
		command rm -rf "${TARBALL}"
	fi
	nvm_err "Downloading ${TARBALL_URL}..."
	nvm_download -L -C - "${PROGRESS_BAR}" "${TARBALL_URL}" -o "${TARBALL}" || (
		command rm -rf "${TARBALL}" "${tmpdir}"
		nvm_err "Binary download from ${TARBALL_URL} failed, trying source."
		return 4
	)
	if nvm_grep '404 Not Found' "${TARBALL}" > /dev/null
	then
		command rm -rf "${TARBALL}" "${tmpdir}"
		nvm_err "HTTP 404 at URL ${TARBALL_URL}"
		return 5
	fi
	nvm_compare_checksum "${TARBALL}" "${CHECKSUM}" || (
		command rm -rf "${tmpdir}/files"
		return 6
	)
	nvm_echo "${TARBALL}"
}
nvm_echo () {
	command printf %s\\n "$*" 2> /dev/null
}
nvm_echo_with_colors () {
	command printf %b\\n "$*" 2> /dev/null
}
nvm_ensure_default_set () {
	local VERSION
	VERSION="$1" 
	if [ -z "${VERSION}" ]
	then
		nvm_err 'nvm_ensure_default_set: a version is required'
		return 1
	elif nvm_alias default > /dev/null 2>&1
	then
		return 0
	fi
	local OUTPUT
	OUTPUT="$(nvm alias default "${VERSION}")" 
	local EXIT_CODE
	EXIT_CODE="$?" 
	nvm_echo "Creating default alias: ${OUTPUT}"
	return $EXIT_CODE
}
nvm_ensure_version_installed () {
	local PROVIDED_VERSION
	PROVIDED_VERSION="${1-}" 
	local IS_VERSION_FROM_NVMRC
	IS_VERSION_FROM_NVMRC="${2-}" 
	if [ "${PROVIDED_VERSION}" = 'system' ]
	then
		if nvm_has_system_iojs || nvm_has_system_node
		then
			return 0
		fi
		nvm_err "N/A: no system version of node/io.js is installed."
		return 1
	fi
	local LOCAL_VERSION
	local EXIT_CODE
	LOCAL_VERSION="$(nvm_version "${PROVIDED_VERSION}")" 
	EXIT_CODE="$?" 
	local NVM_VERSION_DIR
	if [ "${EXIT_CODE}" != "0" ] || ! nvm_is_version_installed "${LOCAL_VERSION}"
	then
		if VERSION="$(nvm_resolve_alias "${PROVIDED_VERSION}")" 
		then
			nvm_err "N/A: version \"${PROVIDED_VERSION} -> ${VERSION}\" is not yet installed."
		else
			local PREFIXED_VERSION
			PREFIXED_VERSION="$(nvm_ensure_version_prefix "${PROVIDED_VERSION}")" 
			nvm_err "N/A: version \"${PREFIXED_VERSION:-$PROVIDED_VERSION}\" is not yet installed."
		fi
		nvm_err ""
		if [ "${IS_VERSION_FROM_NVMRC}" != '1' ]
		then
			nvm_err "You need to run \`nvm install ${PROVIDED_VERSION}\` to install and use it."
		else
			nvm_err 'You need to run `nvm install` to install and use the node version specified in `.nvmrc`.'
		fi
		return 1
	fi
}
nvm_ensure_version_prefix () {
	local NVM_VERSION
	NVM_VERSION="$(nvm_strip_iojs_prefix "${1-}" | command sed -e 's/^\([0-9]\)/v\1/g')" 
	if nvm_is_iojs_version "${1-}"
	then
		nvm_add_iojs_prefix "${NVM_VERSION}"
	else
		nvm_echo "${NVM_VERSION}"
	fi
}
nvm_err () {
	nvm_echo "$@" >&2
}
nvm_err_with_colors () {
	nvm_echo_with_colors "$@" >&2
}
nvm_extract_tarball () {
	if [ "$#" -ne 4 ]
	then
		nvm_err 'nvm_extract_tarball requires exactly 4 arguments'
		return 5
	fi
	local NVM_OS
	NVM_OS="${1-}" 
	local VERSION
	VERSION="${2-}" 
	local TARBALL
	TARBALL="${3-}" 
	local TMPDIR
	TMPDIR="${4-}" 
	local tar_compression_flag
	tar_compression_flag='z' 
	if nvm_supports_xz "${VERSION}"
	then
		tar_compression_flag='J' 
	fi
	local tar
	tar='tar' 
	if [ "${NVM_OS}" = 'aix' ]
	then
		tar='gtar' 
	fi
	if [ "${NVM_OS}" = 'openbsd' ]
	then
		if [ "${tar_compression_flag}" = 'J' ]
		then
			command xzcat "${TARBALL}" | "${tar}" -xf - -C "${TMPDIR}" -s '/[^\/]*\///' || return 1
		else
			command "${tar}" -x${tar_compression_flag}f "${TARBALL}" -C "${TMPDIR}" -s '/[^\/]*\///' || return 1
		fi
	else
		command "${tar}" -x${tar_compression_flag}f "${TARBALL}" -C "${TMPDIR}" --strip-components 1 || return 1
	fi
}
nvm_find_nvmrc () {
	local dir
	dir="$(nvm_find_up '.nvmrc')" 
	if [ -e "${dir}/.nvmrc" ]
	then
		nvm_echo "${dir}/.nvmrc"
	fi
}
nvm_find_project_dir () {
	local path_
	path_="${PWD}" 
	while [ "${path_}" != "" ] && [ "${path_}" != '.' ] && [ ! -f "${path_}/package.json" ] && [ ! -d "${path_}/node_modules" ]
	do
		path_=${path_%/*} 
	done
	nvm_echo "${path_}"
}
nvm_find_up () {
	local path_
	path_="${PWD}" 
	while [ "${path_}" != "" ] && [ "${path_}" != '.' ] && [ ! -f "${path_}/${1-}" ]
	do
		path_=${path_%/*} 
	done
	nvm_echo "${path_}"
}
nvm_format_version () {
	local VERSION
	VERSION="$(nvm_ensure_version_prefix "${1-}")" 
	local NUM_GROUPS
	NUM_GROUPS="$(nvm_num_version_groups "${VERSION}")" 
	if [ "${NUM_GROUPS}" -lt 3 ]
	then
		nvm_format_version "${VERSION%.}.0"
	else
		nvm_echo "${VERSION}" | command cut -f1-3 -d.
	fi
}
nvm_get_arch () {
	local HOST_ARCH
	local NVM_OS
	local EXIT_CODE
	local LONG_BIT
	NVM_OS="$(nvm_get_os)" 
	if [ "_${NVM_OS}" = "_sunos" ]
	then
		if HOST_ARCH=$(pkg_info -Q MACHINE_ARCH pkg_install) 
		then
			HOST_ARCH=$(nvm_echo "${HOST_ARCH}" | command tail -1) 
		else
			HOST_ARCH=$(isainfo -n) 
		fi
	elif [ "_${NVM_OS}" = "_aix" ]
	then
		HOST_ARCH=ppc64 
	else
		HOST_ARCH="$(command uname -m)" 
		LONG_BIT="$(getconf LONG_BIT 2>/dev/null)" 
	fi
	local NVM_ARCH
	case "${HOST_ARCH}" in
		(x86_64 | amd64) NVM_ARCH="x64"  ;;
		(i*86) NVM_ARCH="x86"  ;;
		(aarch64 | armv8l) NVM_ARCH="arm64"  ;;
		(*) NVM_ARCH="${HOST_ARCH}"  ;;
	esac
	if [ "_${LONG_BIT}" = "_32" ] && [ "${NVM_ARCH}" = "x64" ]
	then
		NVM_ARCH="x86" 
	fi
	if [ "$(uname)" = "Linux" ] && [ "${NVM_ARCH}" = arm64 ] && [ "$(command od -An -t x1 -j 4 -N 1 "/sbin/init" 2>/dev/null)" = ' 01' ]
	then
		NVM_ARCH=armv7l 
		HOST_ARCH=armv7l 
	fi
	if [ -f "/etc/alpine-release" ]
	then
		NVM_ARCH=x64-musl 
	fi
	nvm_echo "${NVM_ARCH}"
}
nvm_get_artifact_compression () {
	local VERSION
	VERSION="${1-}" 
	local NVM_OS
	NVM_OS="$(nvm_get_os)" 
	local COMPRESSION
	COMPRESSION='tar.gz' 
	if [ "_${NVM_OS}" = '_win' ]
	then
		COMPRESSION='zip' 
	elif nvm_supports_xz "${VERSION}"
	then
		COMPRESSION='tar.xz' 
	fi
	nvm_echo "${COMPRESSION}"
}
nvm_get_checksum () {
	local FLAVOR
	case "${1-}" in
		(node | iojs) FLAVOR="${1}"  ;;
		(*) nvm_err 'supported flavors: node, iojs'
			return 2 ;;
	esac
	local MIRROR
	MIRROR="$(nvm_get_mirror "${FLAVOR}" "${2-}")" 
	if [ -z "${MIRROR}" ]
	then
		return 1
	fi
	local SHASUMS_URL
	if [ "$(nvm_get_checksum_alg)" = 'sha-256' ]
	then
		SHASUMS_URL="${MIRROR}/${3}/SHASUMS256.txt" 
	else
		SHASUMS_URL="${MIRROR}/${3}/SHASUMS.txt" 
	fi
	nvm_download -L -s "${SHASUMS_URL}" -o - | command awk "{ if (\"${4}.${5}\" == \$2) print \$1}"
}
nvm_get_checksum_alg () {
	local NVM_CHECKSUM_BIN
	NVM_CHECKSUM_BIN="$(nvm_get_checksum_binary 2>/dev/null)" 
	case "${NVM_CHECKSUM_BIN-}" in
		(sha256sum | shasum | sha256 | gsha256sum | openssl | bssl) nvm_echo 'sha-256' ;;
		(sha1sum | sha1) nvm_echo 'sha-1' ;;
		(*) nvm_get_checksum_binary
			return $? ;;
	esac
}
nvm_get_checksum_binary () {
	if nvm_has_non_aliased 'sha256sum'
	then
		nvm_echo 'sha256sum'
	elif nvm_has_non_aliased 'shasum'
	then
		nvm_echo 'shasum'
	elif nvm_has_non_aliased 'sha256'
	then
		nvm_echo 'sha256'
	elif nvm_has_non_aliased 'gsha256sum'
	then
		nvm_echo 'gsha256sum'
	elif nvm_has_non_aliased 'openssl'
	then
		nvm_echo 'openssl'
	elif nvm_has_non_aliased 'bssl'
	then
		nvm_echo 'bssl'
	elif nvm_has_non_aliased 'sha1sum'
	then
		nvm_echo 'sha1sum'
	elif nvm_has_non_aliased 'sha1'
	then
		nvm_echo 'sha1'
	else
		nvm_err 'Unaliased sha256sum, shasum, sha256, gsha256sum, openssl, or bssl not found.'
		nvm_err 'Unaliased sha1sum or sha1 not found.'
		return 1
	fi
}
nvm_get_colors () {
	local COLOR
	local SYS_COLOR
	local COLORS
	COLORS="${NVM_COLORS:-bygre}" 
	case $1 in
		(1) COLOR=$(nvm_print_color_code "$(echo "$COLORS" | awk '{ print substr($0, 1, 1); }')")  ;;
		(2) COLOR=$(nvm_print_color_code "$(echo "$COLORS" | awk '{ print substr($0, 2, 1); }')")  ;;
		(3) COLOR=$(nvm_print_color_code "$(echo "$COLORS" | awk '{ print substr($0, 3, 1); }')")  ;;
		(4) COLOR=$(nvm_print_color_code "$(echo "$COLORS" | awk '{ print substr($0, 4, 1); }')")  ;;
		(5) COLOR=$(nvm_print_color_code "$(echo "$COLORS" | awk '{ print substr($0, 5, 1); }')")  ;;
		(6) SYS_COLOR=$(nvm_print_color_code "$(echo "$COLORS" | awk '{ print substr($0, 2, 1); }')") 
			COLOR=$(nvm_echo "$SYS_COLOR" | command tr '0;' '1;')  ;;
		(*) nvm_err "Invalid color index, ${1-}"
			return 1 ;;
	esac
	nvm_echo "$COLOR"
}
nvm_get_default_packages () {
	local NVM_DEFAULT_PACKAGE_FILE
	NVM_DEFAULT_PACKAGE_FILE="${NVM_DIR}/default-packages" 
	if [ -f "${NVM_DEFAULT_PACKAGE_FILE}" ]
	then
		command awk -v filename="${NVM_DEFAULT_PACKAGE_FILE}" '
      /^[[:space:]]*#/ { next }                     # Skip lines that begin with #
      /^[[:space:]]*$/ { next }                     # Skip empty lines
      /[[:space:]]/ && !/^[[:space:]]*#/ {
        print "Only one package per line is allowed in `" filename "`. Please remove any lines with multiple space-separated values." > "/dev/stderr"
        err = 1
        exit 1
      }
      {
        if (NR > 1 && !prev_space) printf " "
        printf "%s", $0
        prev_space = 0
      }
    ' "${NVM_DEFAULT_PACKAGE_FILE}"
	fi
}
nvm_get_download_slug () {
	local FLAVOR
	case "${1-}" in
		(node | iojs) FLAVOR="${1}"  ;;
		(*) nvm_err 'supported flavors: node, iojs'
			return 1 ;;
	esac
	local KIND
	case "${2-}" in
		(binary | source) KIND="${2}"  ;;
		(*) nvm_err 'supported kinds: binary, source'
			return 2 ;;
	esac
	local VERSION
	VERSION="${3-}" 
	local NVM_OS
	NVM_OS="$(nvm_get_os)" 
	local NVM_ARCH
	NVM_ARCH="$(nvm_get_arch)" 
	if ! nvm_is_merged_node_version "${VERSION}"
	then
		if [ "${NVM_ARCH}" = 'armv6l' ] || [ "${NVM_ARCH}" = 'armv7l' ]
		then
			NVM_ARCH="arm-pi" 
		fi
	fi
	if nvm_version_greater '14.17.0' "${VERSION}" || (
			nvm_version_greater_than_or_equal_to "${VERSION}" '15.0.0' && nvm_version_greater '16.0.0' "${VERSION}"
		)
	then
		if [ "_${NVM_OS}" = '_darwin' ] && [ "${NVM_ARCH}" = 'arm64' ]
		then
			NVM_ARCH=x64 
		fi
	fi
	if [ "${KIND}" = 'binary' ]
	then
		nvm_echo "${FLAVOR}-${VERSION}-${NVM_OS}-${NVM_ARCH}"
	elif [ "${KIND}" = 'source' ]
	then
		nvm_echo "${FLAVOR}-${VERSION}"
	fi
}
nvm_get_latest () {
	local NVM_LATEST_URL
	local CURL_COMPRESSED_FLAG
	if nvm_has "curl"
	then
		if nvm_curl_use_compression
		then
			CURL_COMPRESSED_FLAG="--compressed" 
		fi
		NVM_LATEST_URL="$(curl ${CURL_COMPRESSED_FLAG:-} -q -w "%{url_effective}\\n" -L -s -S https://latest.nvm.sh -o /dev/null)" 
	elif nvm_has "wget"
	then
		NVM_LATEST_URL="$(wget -q https://latest.nvm.sh --server-response -O /dev/null 2>&1 | command awk '/^  Location: /{DEST=$2} END{ print DEST }')" 
	else
		nvm_err 'nvm needs curl or wget to proceed.'
		return 1
	fi
	if [ -z "${NVM_LATEST_URL}" ]
	then
		nvm_err "https://latest.nvm.sh did not redirect to the latest release on GitHub"
		return 2
	fi
	nvm_echo "${NVM_LATEST_URL##*/}"
}
nvm_get_make_jobs () {
	if nvm_is_natural_num "${1-}"
	then
		NVM_MAKE_JOBS="$1" 
		nvm_echo "number of \`make\` jobs: ${NVM_MAKE_JOBS}"
		return
	elif [ -n "${1-}" ]
	then
		unset NVM_MAKE_JOBS
		nvm_err "$1 is invalid for number of \`make\` jobs, must be a natural number"
	fi
	local NVM_OS
	NVM_OS="$(nvm_get_os)" 
	local NVM_CPU_CORES
	case "_${NVM_OS}" in
		("_linux") NVM_CPU_CORES="$(nvm_grep -c -E '^processor.+: [0-9]+' /proc/cpuinfo)"  ;;
		("_freebsd" | "_darwin" | "_openbsd") NVM_CPU_CORES="$(sysctl -n hw.ncpu)"  ;;
		("_sunos") NVM_CPU_CORES="$(psrinfo | wc -l)"  ;;
		("_aix") NVM_CPU_CORES="$(pmcycles -m | wc -l)"  ;;
	esac
	if ! nvm_is_natural_num "${NVM_CPU_CORES}"
	then
		nvm_err 'Can not determine how many core(s) are available, running in single-threaded mode.'
		nvm_err 'Please report an issue on GitHub to help us make nvm run faster on your computer!'
		NVM_MAKE_JOBS=1 
	else
		nvm_echo "Detected that you have ${NVM_CPU_CORES} CPU core(s)"
		if [ "${NVM_CPU_CORES}" -gt 2 ]
		then
			NVM_MAKE_JOBS=$((NVM_CPU_CORES - 1)) 
			nvm_echo "Running with ${NVM_MAKE_JOBS} threads to speed up the build"
		else
			NVM_MAKE_JOBS=1 
			nvm_echo 'Number of CPU core(s) less than or equal to 2, running in single-threaded mode'
		fi
	fi
}
nvm_get_minor_version () {
	local VERSION
	VERSION="$1" 
	if [ -z "${VERSION}" ]
	then
		nvm_err 'a version is required'
		return 1
	fi
	case "${VERSION}" in
		(v | .* | *..* | v*[!.0123456789]* | [!v]*[!.0123456789]* | [!v0123456789]* | v[!0123456789]*) nvm_err 'invalid version number'
			return 2 ;;
	esac
	local PREFIXED_VERSION
	PREFIXED_VERSION="$(nvm_format_version "${VERSION}")" 
	local MINOR
	MINOR="$(nvm_echo "${PREFIXED_VERSION}" | nvm_grep -e '^v' | command cut -c2- | command cut -d . -f 1,2)" 
	if [ -z "${MINOR}" ]
	then
		nvm_err 'invalid version number! (please report this)'
		return 3
	fi
	nvm_echo "${MINOR}"
}
nvm_get_mirror () {
	local NVM_MIRROR
	NVM_MIRROR='' 
	case "${1}-${2}" in
		(node-std) NVM_MIRROR="${NVM_NODEJS_ORG_MIRROR:-https://nodejs.org/dist}"  ;;
		(iojs-std) NVM_MIRROR="${NVM_IOJS_ORG_MIRROR:-https://iojs.org/dist}"  ;;
		(*) nvm_err 'unknown type of node.js or io.js release'
			return 1 ;;
	esac
	case "${NVM_MIRROR}" in
		(*\`* | *\\* | *\'* | *\(* | *' '*) nvm_err '$NVM_NODEJS_ORG_MIRROR and $NVM_IOJS_ORG_MIRROR may only contain a URL'
			return 2 ;;
	esac
	if ! nvm_echo "${NVM_MIRROR}" | command awk '{ $0 ~ "^https?://[a-zA-Z0-9./_-]+$" }'
	then
		nvm_err '$NVM_NODEJS_ORG_MIRROR and $NVM_IOJS_ORG_MIRROR may only contain a URL'
		return 2
	fi
	nvm_echo "${NVM_MIRROR}"
}
nvm_get_os () {
	local NVM_UNAME
	NVM_UNAME="$(command uname -a)" 
	local NVM_OS
	case "${NVM_UNAME}" in
		(Linux\ *) NVM_OS=linux  ;;
		(Darwin\ *) NVM_OS=darwin  ;;
		(SunOS\ *) NVM_OS=sunos  ;;
		(FreeBSD\ *) NVM_OS=freebsd  ;;
		(OpenBSD\ *) NVM_OS=openbsd  ;;
		(AIX\ *) NVM_OS=aix  ;;
		(CYGWIN* | MSYS* | MINGW*) NVM_OS=win  ;;
	esac
	nvm_echo "${NVM_OS-}"
}
nvm_grep () {
	GREP_OPTIONS='' command grep "$@"
}
nvm_has () {
	type "${1-}" > /dev/null 2>&1
}
nvm_has_colors () {
	local NVM_NUM_COLORS
	if nvm_has tput
	then
		NVM_NUM_COLORS="$(tput -T "${TERM:-vt100}" colors)" 
	fi
	[ "${NVM_NUM_COLORS:--1}" -ge 8 ] && [ "${NVM_NO_COLORS-}" != '--no-colors' ]
}
nvm_has_non_aliased () {
	nvm_has "${1-}" && ! nvm_is_alias "${1-}"
}
nvm_has_solaris_binary () {
	local VERSION="${1-}" 
	if nvm_is_merged_node_version "${VERSION}"
	then
		return 0
	elif nvm_is_iojs_version "${VERSION}"
	then
		nvm_iojs_version_has_solaris_binary "${VERSION}"
	else
		nvm_node_version_has_solaris_binary "${VERSION}"
	fi
}
nvm_has_system_iojs () {
	[ "$(nvm deactivate >/dev/null 2>&1 && command -v iojs)" != '' ]
}
nvm_has_system_node () {
	[ "$(nvm deactivate >/dev/null 2>&1 && command -v node)" != '' ]
}
nvm_install_binary () {
	local FLAVOR
	case "${1-}" in
		(node | iojs) FLAVOR="${1}"  ;;
		(*) nvm_err 'supported flavors: node, iojs'
			return 4 ;;
	esac
	local TYPE
	TYPE="${2-}" 
	local PREFIXED_VERSION
	PREFIXED_VERSION="${3-}" 
	if [ -z "${PREFIXED_VERSION}" ]
	then
		nvm_err 'A version number is required.'
		return 3
	fi
	local nosource
	nosource="${4-}" 
	local VERSION
	VERSION="$(nvm_strip_iojs_prefix "${PREFIXED_VERSION}")" 
	local NVM_OS
	NVM_OS="$(nvm_get_os)" 
	if [ -z "${NVM_OS}" ]
	then
		return 2
	fi
	local TARBALL
	local TMPDIR
	local PROGRESS_BAR
	local NODE_OR_IOJS
	if [ "${FLAVOR}" = 'node' ]
	then
		NODE_OR_IOJS="${FLAVOR}" 
	elif [ "${FLAVOR}" = 'iojs' ]
	then
		NODE_OR_IOJS="io.js" 
	fi
	if [ "${NVM_NO_PROGRESS-}" = "1" ]
	then
		PROGRESS_BAR="-sS" 
	else
		PROGRESS_BAR="--progress-bar" 
	fi
	nvm_echo "Downloading and installing ${NODE_OR_IOJS-} ${VERSION}..."
	TARBALL="$(PROGRESS_BAR="${PROGRESS_BAR}" nvm_download_artifact "${FLAVOR}" binary "${TYPE-}" "${VERSION}" | command tail -1)" 
	if [ -f "${TARBALL}" ]
	then
		TMPDIR="$(dirname "${TARBALL}")/files" 
	fi
	if nvm_install_binary_extract "${NVM_OS}" "${PREFIXED_VERSION}" "${VERSION}" "${TARBALL}" "${TMPDIR}"
	then
		if [ -n "${ALIAS-}" ]
		then
			nvm alias "${ALIAS}" "${provided_version}"
		fi
		return 0
	fi
	if [ "${nosource-}" = '1' ]
	then
		nvm_err 'Binary download failed. Download from source aborted.'
		return 0
	fi
	nvm_err 'Binary download failed, trying source.'
	if [ -n "${TMPDIR-}" ]
	then
		command rm -rf "${TMPDIR}"
	fi
	return 1
}
nvm_install_binary_extract () {
	if [ "$#" -ne 5 ]
	then
		nvm_err 'nvm_install_binary_extract needs 5 parameters'
		return 1
	fi
	local NVM_OS
	local PREFIXED_VERSION
	local VERSION
	local TARBALL
	local TMPDIR
	NVM_OS="${1}" 
	PREFIXED_VERSION="${2}" 
	VERSION="${3}" 
	TARBALL="${4}" 
	TMPDIR="${5}" 
	local VERSION_PATH
	[ -n "${TMPDIR-}" ] && command mkdir -p "${TMPDIR}" && VERSION_PATH="$(nvm_version_path "${PREFIXED_VERSION}")"  || return 1
	if [ "${NVM_OS}" = 'win' ]
	then
		VERSION_PATH="${VERSION_PATH}/bin" 
		command unzip -q "${TARBALL}" -d "${TMPDIR}" || return 1
	else
		nvm_extract_tarball "${NVM_OS}" "${VERSION}" "${TARBALL}" "${TMPDIR}"
	fi
	command mkdir -p "${VERSION_PATH}" || return 1
	if [ "${NVM_OS}" = 'win' ]
	then
		command mv "${TMPDIR}/"*/* "${VERSION_PATH}" || return 1
		command chmod +x "${VERSION_PATH}"/node.exe || return 1
		command chmod +x "${VERSION_PATH}"/npm || return 1
		command chmod +x "${VERSION_PATH}"/npx 2> /dev/null
	else
		command mv "${TMPDIR}/"* "${VERSION_PATH}" || return 1
	fi
	command rm -rf "${TMPDIR}"
	return 0
}
nvm_install_default_packages () {
	local DEFAULT_PACKAGES
	DEFAULT_PACKAGES="$(nvm_get_default_packages)" 
	EXIT_CODE=$? 
	if [ $EXIT_CODE -ne 0 ] || [ -z "${DEFAULT_PACKAGES}" ]
	then
		return $EXIT_CODE
	fi
	nvm_echo "Installing default global packages from ${NVM_DIR}/default-packages..."
	nvm_echo "npm install -g --quiet ${DEFAULT_PACKAGES}"
	if ! nvm_echo "${DEFAULT_PACKAGES}" | command xargs npm install -g --quiet
	then
		nvm_err "Failed installing default packages. Please check if your default-packages file or a package in it has problems!"
		return 1
	fi
}
nvm_install_latest_npm () {
	nvm_echo 'Attempting to upgrade to the latest working version of npm...'
	local NODE_VERSION
	NODE_VERSION="$(nvm_strip_iojs_prefix "$(nvm_ls_current)")" 
	if [ "${NODE_VERSION}" = 'system' ]
	then
		NODE_VERSION="$(node --version)" 
	elif [ "${NODE_VERSION}" = 'none' ]
	then
		nvm_echo "Detected node version ${NODE_VERSION}, npm version v${NPM_VERSION}"
		NODE_VERSION='' 
	fi
	if [ -z "${NODE_VERSION}" ]
	then
		nvm_err 'Unable to obtain node version.'
		return 1
	fi
	local NPM_VERSION
	NPM_VERSION="$(npm --version 2>/dev/null)" 
	if [ -z "${NPM_VERSION}" ]
	then
		nvm_err 'Unable to obtain npm version.'
		return 2
	fi
	local NVM_NPM_CMD
	NVM_NPM_CMD='npm' 
	if [ "${NVM_DEBUG-}" = 1 ]
	then
		nvm_echo "Detected node version ${NODE_VERSION}, npm version v${NPM_VERSION}"
		NVM_NPM_CMD='nvm_echo npm' 
	fi
	local NVM_IS_0_6
	NVM_IS_0_6=0 
	if nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 0.6.0 && nvm_version_greater 0.7.0 "${NODE_VERSION}"
	then
		NVM_IS_0_6=1 
	fi
	local NVM_IS_0_9
	NVM_IS_0_9=0 
	if nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 0.9.0 && nvm_version_greater 0.10.0 "${NODE_VERSION}"
	then
		NVM_IS_0_9=1 
	fi
	if [ $NVM_IS_0_6 -eq 1 ]
	then
		nvm_echo '* `node` v0.6.x can only upgrade to `npm` v1.3.x'
		$NVM_NPM_CMD install -g npm@1.3
	elif [ $NVM_IS_0_9 -eq 0 ]
	then
		if nvm_version_greater_than_or_equal_to "${NPM_VERSION}" 1.0.0 && nvm_version_greater 2.0.0 "${NPM_VERSION}"
		then
			nvm_echo '* `npm` v1.x needs to first jump to `npm` v1.4.28 to be able to upgrade further'
			$NVM_NPM_CMD install -g npm@1.4.28
		elif nvm_version_greater_than_or_equal_to "${NPM_VERSION}" 2.0.0 && nvm_version_greater 3.0.0 "${NPM_VERSION}"
		then
			nvm_echo '* `npm` v2.x needs to first jump to the latest v2 to be able to upgrade further'
			$NVM_NPM_CMD install -g npm@2
		fi
	fi
	if [ $NVM_IS_0_9 -eq 1 ] || [ $NVM_IS_0_6 -eq 1 ]
	then
		nvm_echo '* node v0.6 and v0.9 are unable to upgrade further'
	elif nvm_version_greater 1.1.0 "${NODE_VERSION}"
	then
		nvm_echo '* `npm` v4.5.x is the last version that works on `node` versions < v1.1.0'
		$NVM_NPM_CMD install -g npm@4.5
	elif nvm_version_greater 4.0.0 "${NODE_VERSION}"
	then
		nvm_echo '* `npm` v5 and higher do not work on `node` versions below v4.0.0'
		$NVM_NPM_CMD install -g npm@4
	elif [ $NVM_IS_0_9 -eq 0 ] && [ $NVM_IS_0_6 -eq 0 ]
	then
		local NVM_IS_4_4_OR_BELOW
		NVM_IS_4_4_OR_BELOW=0 
		if nvm_version_greater 4.5.0 "${NODE_VERSION}"
		then
			NVM_IS_4_4_OR_BELOW=1 
		fi
		local NVM_IS_5_OR_ABOVE
		NVM_IS_5_OR_ABOVE=0 
		if [ $NVM_IS_4_4_OR_BELOW -eq 0 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 5.0.0
		then
			NVM_IS_5_OR_ABOVE=1 
		fi
		local NVM_IS_6_OR_ABOVE
		NVM_IS_6_OR_ABOVE=0 
		local NVM_IS_6_2_OR_ABOVE
		NVM_IS_6_2_OR_ABOVE=0 
		if [ $NVM_IS_5_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 6.0.0
		then
			NVM_IS_6_OR_ABOVE=1 
			if nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 6.2.0
			then
				NVM_IS_6_2_OR_ABOVE=1 
			fi
		fi
		local NVM_IS_9_OR_ABOVE
		NVM_IS_9_OR_ABOVE=0 
		local NVM_IS_9_3_OR_ABOVE
		NVM_IS_9_3_OR_ABOVE=0 
		if [ $NVM_IS_6_2_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 9.0.0
		then
			NVM_IS_9_OR_ABOVE=1 
			if nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 9.3.0
			then
				NVM_IS_9_3_OR_ABOVE=1 
			fi
		fi
		local NVM_IS_10_OR_ABOVE
		NVM_IS_10_OR_ABOVE=0 
		if [ $NVM_IS_9_3_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 10.0.0
		then
			NVM_IS_10_OR_ABOVE=1 
		fi
		local NVM_IS_12_LTS_OR_ABOVE
		NVM_IS_12_LTS_OR_ABOVE=0 
		if [ $NVM_IS_10_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 12.13.0
		then
			NVM_IS_12_LTS_OR_ABOVE=1 
		fi
		local NVM_IS_13_OR_ABOVE
		NVM_IS_13_OR_ABOVE=0 
		if [ $NVM_IS_12_LTS_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 13.0.0
		then
			NVM_IS_13_OR_ABOVE=1 
		fi
		local NVM_IS_14_LTS_OR_ABOVE
		NVM_IS_14_LTS_OR_ABOVE=0 
		if [ $NVM_IS_13_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 14.15.0
		then
			NVM_IS_14_LTS_OR_ABOVE=1 
		fi
		local NVM_IS_14_17_OR_ABOVE
		NVM_IS_14_17_OR_ABOVE=0 
		if [ $NVM_IS_14_LTS_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 14.17.0
		then
			NVM_IS_14_17_OR_ABOVE=1 
		fi
		local NVM_IS_15_OR_ABOVE
		NVM_IS_15_OR_ABOVE=0 
		if [ $NVM_IS_14_LTS_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 15.0.0
		then
			NVM_IS_15_OR_ABOVE=1 
		fi
		local NVM_IS_16_OR_ABOVE
		NVM_IS_16_OR_ABOVE=0 
		if [ $NVM_IS_15_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 16.0.0
		then
			NVM_IS_16_OR_ABOVE=1 
		fi
		local NVM_IS_16_LTS_OR_ABOVE
		NVM_IS_16_LTS_OR_ABOVE=0 
		if [ $NVM_IS_16_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 16.13.0
		then
			NVM_IS_16_LTS_OR_ABOVE=1 
		fi
		local NVM_IS_17_OR_ABOVE
		NVM_IS_17_OR_ABOVE=0 
		if [ $NVM_IS_16_LTS_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 17.0.0
		then
			NVM_IS_17_OR_ABOVE=1 
		fi
		local NVM_IS_18_OR_ABOVE
		NVM_IS_18_OR_ABOVE=0 
		if [ $NVM_IS_17_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 18.0.0
		then
			NVM_IS_18_OR_ABOVE=1 
		fi
		local NVM_IS_18_17_OR_ABOVE
		NVM_IS_18_17_OR_ABOVE=0 
		if [ $NVM_IS_18_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 18.17.0
		then
			NVM_IS_18_17_OR_ABOVE=1 
		fi
		local NVM_IS_19_OR_ABOVE
		NVM_IS_19_OR_ABOVE=0 
		if [ $NVM_IS_18_17_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 19.0.0
		then
			NVM_IS_19_OR_ABOVE=1 
		fi
		local NVM_IS_20_5_OR_ABOVE
		NVM_IS_20_5_OR_ABOVE=0 
		if [ $NVM_IS_19_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 20.5.0
		then
			NVM_IS_20_5_OR_ABOVE=1 
		fi
		if [ $NVM_IS_4_4_OR_BELOW -eq 1 ] || {
				[ $NVM_IS_5_OR_ABOVE -eq 1 ] && nvm_version_greater 5.10.0 "${NODE_VERSION}"
			}
		then
			nvm_echo '* `npm` `v5.3.x` is the last version that works on `node` 4.x versions below v4.4, or 5.x versions below v5.10, due to `Buffer.alloc`'
			$NVM_NPM_CMD install -g npm@5.3
		elif [ $NVM_IS_4_4_OR_BELOW -eq 0 ] && nvm_version_greater 4.7.0 "${NODE_VERSION}"
		then
			nvm_echo '* `npm` `v5.4.1` is the last version that works on `node` `v4.5` and `v4.6`'
			$NVM_NPM_CMD install -g npm@5.4.1
		elif [ $NVM_IS_6_OR_ABOVE -eq 0 ]
		then
			nvm_echo '* `npm` `v5.x` is the last version that works on `node` below `v6.0.0`'
			$NVM_NPM_CMD install -g npm@5
		elif {
				[ $NVM_IS_6_OR_ABOVE -eq 1 ] && [ $NVM_IS_6_2_OR_ABOVE -eq 0 ]
			} || {
				[ $NVM_IS_9_OR_ABOVE -eq 1 ] && [ $NVM_IS_9_3_OR_ABOVE -eq 0 ]
			}
		then
			nvm_echo '* `npm` `v6.9` is the last version that works on `node` `v6.0.x`, `v6.1.x`, `v9.0.x`, `v9.1.x`, or `v9.2.x`'
			$NVM_NPM_CMD install -g npm@6.9
		elif [ $NVM_IS_10_OR_ABOVE -eq 0 ]
		then
			if nvm_version_greater 4.4.4 "${NPM_VERSION}"
			then
				nvm_echo '* `npm` `v4.4.4` or later is required to install npm v6.14.18'
				$NVM_NPM_CMD install -g npm@4
			fi
			nvm_echo '* `npm` `v6.x` is the last version that works on `node` below `v10.0.0`'
			$NVM_NPM_CMD install -g npm@6
		elif [ $NVM_IS_12_LTS_OR_ABOVE -eq 0 ] || {
				[ $NVM_IS_13_OR_ABOVE -eq 1 ] && [ $NVM_IS_14_LTS_OR_ABOVE -eq 0 ]
			} || {
				[ $NVM_IS_15_OR_ABOVE -eq 1 ] && [ $NVM_IS_16_OR_ABOVE -eq 0 ]
			}
		then
			nvm_echo '* `npm` `v7.x` is the last version that works on `node` `v13`, `v15`, below `v12.13`, or `v14.0` - `v14.15`'
			$NVM_NPM_CMD install -g npm@7
		elif {
				[ $NVM_IS_12_LTS_OR_ABOVE -eq 1 ] && [ $NVM_IS_13_OR_ABOVE -eq 0 ]
			} || {
				[ $NVM_IS_14_LTS_OR_ABOVE -eq 1 ] && [ $NVM_IS_14_17_OR_ABOVE -eq 0 ]
			} || {
				[ $NVM_IS_16_OR_ABOVE -eq 1 ] && [ $NVM_IS_16_LTS_OR_ABOVE -eq 0 ]
			} || {
				[ $NVM_IS_17_OR_ABOVE -eq 1 ] && [ $NVM_IS_18_OR_ABOVE -eq 0 ]
			}
		then
			nvm_echo '* `npm` `v8.6` is the last version that works on `node` `v12`, `v14.13` - `v14.16`, or `v16.0` - `v16.12`'
			$NVM_NPM_CMD install -g npm@8.6
		elif [ $NVM_IS_18_17_OR_ABOVE -eq 0 ] || {
				[ $NVM_IS_19_OR_ABOVE -eq 1 ] && [ $NVM_IS_20_5_OR_ABOVE -eq 0 ]
			}
		then
			nvm_echo '* `npm` `v9.x` is the last version that works on `node` `< v18.17`, `v19`, or `v20.0` - `v20.4`'
			$NVM_NPM_CMD install -g npm@9
		else
			nvm_echo '* Installing latest `npm`; if this does not work on your node version, please report a bug!'
			$NVM_NPM_CMD install -g npm
		fi
	fi
	nvm_echo "* npm upgraded to: v$(npm --version 2>/dev/null)"
}
nvm_install_npm_if_needed () {
	local VERSION
	VERSION="$(nvm_ls_current)" 
	if ! nvm_has "npm"
	then
		nvm_echo 'Installing npm...'
		if nvm_version_greater 0.2.0 "${VERSION}"
		then
			nvm_err 'npm requires node v0.2.3 or higher'
		elif nvm_version_greater_than_or_equal_to "${VERSION}" 0.2.0
		then
			if nvm_version_greater 0.2.3 "${VERSION}"
			then
				nvm_err 'npm requires node v0.2.3 or higher'
			else
				nvm_download -L https://npmjs.org/install.sh -o - | clean=yes npm_install=0.2.19 sh
			fi
		else
			nvm_download -L https://npmjs.org/install.sh -o - | clean=yes sh
		fi
	fi
	return $?
}
nvm_install_source () {
	local FLAVOR
	case "${1-}" in
		(node | iojs) FLAVOR="${1}"  ;;
		(*) nvm_err 'supported flavors: node, iojs'
			return 4 ;;
	esac
	local TYPE
	TYPE="${2-}" 
	local PREFIXED_VERSION
	PREFIXED_VERSION="${3-}" 
	if [ -z "${PREFIXED_VERSION}" ]
	then
		nvm_err 'A version number is required.'
		return 3
	fi
	local VERSION
	VERSION="$(nvm_strip_iojs_prefix "${PREFIXED_VERSION}")" 
	local NVM_MAKE_JOBS
	NVM_MAKE_JOBS="${4-}" 
	local ADDITIONAL_PARAMETERS
	ADDITIONAL_PARAMETERS="${5-}" 
	local NVM_ARCH
	NVM_ARCH="$(nvm_get_arch)" 
	if [ "${NVM_ARCH}" = 'armv6l' ] || [ "${NVM_ARCH}" = 'armv7l' ]
	then
		if [ -n "${ADDITIONAL_PARAMETERS}" ]
		then
			ADDITIONAL_PARAMETERS="--without-snapshot ${ADDITIONAL_PARAMETERS}" 
		else
			ADDITIONAL_PARAMETERS='--without-snapshot' 
		fi
	fi
	if [ -n "${ADDITIONAL_PARAMETERS}" ]
	then
		nvm_echo "Additional options while compiling: ${ADDITIONAL_PARAMETERS}"
	fi
	local NVM_OS
	NVM_OS="$(nvm_get_os)" 
	local make
	make='make' 
	local MAKE_CXX
	case "${NVM_OS}" in
		('freebsd' | 'openbsd') make='gmake' 
			MAKE_CXX="CC=${CC:-cc} CXX=${CXX:-c++}"  ;;
		('darwin') MAKE_CXX="CC=${CC:-cc} CXX=${CXX:-c++}"  ;;
		('aix') make='gmake'  ;;
	esac
	if nvm_has "clang++" && nvm_has "clang" && nvm_version_greater_than_or_equal_to "$(nvm_clang_version)" 3.5
	then
		if [ -z "${CC-}" ] || [ -z "${CXX-}" ]
		then
			nvm_echo "Clang v3.5+ detected! CC or CXX not specified, will use Clang as C/C++ compiler!"
			MAKE_CXX="CC=${CC:-cc} CXX=${CXX:-c++}" 
		fi
	fi
	local TARBALL
	local TMPDIR
	local VERSION_PATH
	if [ "${NVM_NO_PROGRESS-}" = "1" ]
	then
		PROGRESS_BAR="-sS" 
	else
		PROGRESS_BAR="--progress-bar" 
	fi
	nvm_is_zsh && setopt local_options shwordsplit
	TARBALL="$(PROGRESS_BAR="${PROGRESS_BAR}" nvm_download_artifact "${FLAVOR}" source "${TYPE}" "${VERSION}" | command tail -1)"  && [ -f "${TARBALL}" ] && TMPDIR="$(dirname "${TARBALL}")/files"  && if ! (
			command mkdir -p "${TMPDIR}" && nvm_extract_tarball "${NVM_OS}" "${VERSION}" "${TARBALL}" "${TMPDIR}" && VERSION_PATH="$(nvm_version_path "${PREFIXED_VERSION}")"  && nvm_cd "${TMPDIR}" && nvm_echo '$>'./configure --prefix="${VERSION_PATH}" $ADDITIONAL_PARAMETERS'<' && ./configure --prefix="${VERSION_PATH}" $ADDITIONAL_PARAMETERS && $make -j "${NVM_MAKE_JOBS}" ${MAKE_CXX-} && command rm -f "${VERSION_PATH}" 2> /dev/null && $make -j "${NVM_MAKE_JOBS}" ${MAKE_CXX-} install
		)
	then
		nvm_err "nvm: install ${VERSION} failed!"
		command rm -rf "${TMPDIR-}"
		return 1
	fi
}
nvm_iojs_prefix () {
	nvm_echo 'iojs'
}
nvm_iojs_version_has_solaris_binary () {
	local IOJS_VERSION
	IOJS_VERSION="$1" 
	local STRIPPED_IOJS_VERSION
	STRIPPED_IOJS_VERSION="$(nvm_strip_iojs_prefix "${IOJS_VERSION}")" 
	if [ "_${STRIPPED_IOJS_VERSION}" = "${IOJS_VERSION}" ]
	then
		return 1
	fi
	nvm_version_greater_than_or_equal_to "${STRIPPED_IOJS_VERSION}" v3.3.1
}
nvm_is_alias () {
	\alias "${1-}" > /dev/null 2>&1
}
nvm_is_iojs_version () {
	case "${1-}" in
		(iojs-*) return 0 ;;
	esac
	return 1
}
nvm_is_merged_node_version () {
	nvm_version_greater_than_or_equal_to "$1" v4.0.0
}
nvm_is_natural_num () {
	if [ -z "$1" ]
	then
		return 4
	fi
	case "$1" in
		(0) return 1 ;;
		(-*) return 3 ;;
		(*) [ "$1" -eq "$1" ] 2> /dev/null ;;
	esac
}
nvm_is_valid_version () {
	if nvm_validate_implicit_alias "${1-}" 2> /dev/null
	then
		return 0
	fi
	case "${1-}" in
		("$(nvm_iojs_prefix)" | "$(nvm_node_prefix)") return 0 ;;
		(*) local VERSION
			VERSION="$(nvm_strip_iojs_prefix "${1-}")" 
			nvm_version_greater_than_or_equal_to "${VERSION}" 0 ;;
	esac
}
nvm_is_version_installed () {
	if [ -z "${1-}" ]
	then
		return 1
	fi
	local NVM_NODE_BINARY
	NVM_NODE_BINARY='node' 
	if [ "_$(nvm_get_os)" = '_win' ]
	then
		NVM_NODE_BINARY='node.exe' 
	fi
	if [ -x "$(nvm_version_path "$1" 2>/dev/null)/bin/${NVM_NODE_BINARY}" ]
	then
		return 0
	fi
	return 1
}
nvm_is_zsh () {
	[ -n "${ZSH_VERSION-}" ]
}
nvm_list_aliases () {
	local ALIAS
	ALIAS="${1-}" 
	local NVM_CURRENT
	NVM_CURRENT="$(nvm_ls_current)" 
	local NVM_ALIAS_DIR
	NVM_ALIAS_DIR="$(nvm_alias_path)" 
	command mkdir -p "${NVM_ALIAS_DIR}/lts"
	if [ "${ALIAS}" != "${ALIAS#lts/}" ]
	then
		nvm_alias "${ALIAS}"
		return $?
	fi
	nvm_is_zsh && unsetopt local_options nomatch
	(
		local ALIAS_PATH
		for ALIAS_PATH in "${NVM_ALIAS_DIR}/${ALIAS}"*
		do
			NVM_NO_COLORS="${NVM_NO_COLORS-}" NVM_CURRENT="${NVM_CURRENT}" nvm_print_alias_path "${NVM_ALIAS_DIR}" "${ALIAS_PATH}" &
		done
		wait
	) | command sort
	(
		local ALIAS_NAME
		for ALIAS_NAME in "$(nvm_node_prefix)" "stable" "unstable" "$(nvm_iojs_prefix)"
		do
			{
				if [ ! -f "${NVM_ALIAS_DIR}/${ALIAS_NAME}" ] && {
						[ -z "${ALIAS}" ] || [ "${ALIAS_NAME}" = "${ALIAS}" ]
					}
				then
					NVM_NO_COLORS="${NVM_NO_COLORS-}" NVM_CURRENT="${NVM_CURRENT}" nvm_print_default_alias "${ALIAS_NAME}"
				fi
			} &
		done
		wait
	) | command sort
	(
		local LTS_ALIAS
		for ALIAS_PATH in "${NVM_ALIAS_DIR}/lts/${ALIAS}"*
		do
			{
				LTS_ALIAS="$(NVM_NO_COLORS="${NVM_NO_COLORS-}" NVM_LTS=true nvm_print_alias_path "${NVM_ALIAS_DIR}" "${ALIAS_PATH}")" 
				if [ -n "${LTS_ALIAS}" ]
				then
					nvm_echo "${LTS_ALIAS}"
				fi
			} &
		done
		wait
	) | command sort
	return
}
nvm_ls () {
	local PATTERN
	PATTERN="${1-}" 
	local VERSIONS
	VERSIONS='' 
	if [ "${PATTERN}" = 'current' ]
	then
		nvm_ls_current
		return
	fi
	local NVM_IOJS_PREFIX
	NVM_IOJS_PREFIX="$(nvm_iojs_prefix)" 
	local NVM_NODE_PREFIX
	NVM_NODE_PREFIX="$(nvm_node_prefix)" 
	local NVM_VERSION_DIR_IOJS
	NVM_VERSION_DIR_IOJS="$(nvm_version_dir "${NVM_IOJS_PREFIX}")" 
	local NVM_VERSION_DIR_NEW
	NVM_VERSION_DIR_NEW="$(nvm_version_dir new)" 
	local NVM_VERSION_DIR_OLD
	NVM_VERSION_DIR_OLD="$(nvm_version_dir old)" 
	case "${PATTERN}" in
		("${NVM_IOJS_PREFIX}" | "${NVM_NODE_PREFIX}") PATTERN="${PATTERN}-"  ;;
		(*) if nvm_resolve_local_alias "${PATTERN}"
			then
				return
			fi
			PATTERN="$(nvm_ensure_version_prefix "${PATTERN}")"  ;;
	esac
	if [ "${PATTERN}" = 'N/A' ]
	then
		return
	fi
	local NVM_PATTERN_STARTS_WITH_V
	case $PATTERN in
		(v*) NVM_PATTERN_STARTS_WITH_V=true  ;;
		(*) NVM_PATTERN_STARTS_WITH_V=false  ;;
	esac
	if [ $NVM_PATTERN_STARTS_WITH_V = true ] && [ "_$(nvm_num_version_groups "${PATTERN}")" = "_3" ]
	then
		if nvm_is_version_installed "${PATTERN}"
		then
			VERSIONS="${PATTERN}" 
		elif nvm_is_version_installed "$(nvm_add_iojs_prefix "${PATTERN}")"
		then
			VERSIONS="$(nvm_add_iojs_prefix "${PATTERN}")" 
		fi
	else
		case "${PATTERN}" in
			("${NVM_IOJS_PREFIX}-" | "${NVM_NODE_PREFIX}-" | "system")  ;;
			(*) local NUM_VERSION_GROUPS
				NUM_VERSION_GROUPS="$(nvm_num_version_groups "${PATTERN}")" 
				if [ "${NUM_VERSION_GROUPS}" = "2" ] || [ "${NUM_VERSION_GROUPS}" = "1" ]
				then
					PATTERN="${PATTERN%.}." 
				fi ;;
		esac
		nvm_is_zsh && setopt local_options shwordsplit
		nvm_is_zsh && unsetopt local_options markdirs
		local NVM_DIRS_TO_SEARCH1
		NVM_DIRS_TO_SEARCH1='' 
		local NVM_DIRS_TO_SEARCH2
		NVM_DIRS_TO_SEARCH2='' 
		local NVM_DIRS_TO_SEARCH3
		NVM_DIRS_TO_SEARCH3='' 
		local NVM_ADD_SYSTEM
		NVM_ADD_SYSTEM=false 
		if nvm_is_iojs_version "${PATTERN}"
		then
			NVM_DIRS_TO_SEARCH1="${NVM_VERSION_DIR_IOJS}" 
			PATTERN="$(nvm_strip_iojs_prefix "${PATTERN}")" 
			if nvm_has_system_iojs
			then
				NVM_ADD_SYSTEM=true 
			fi
		elif [ "${PATTERN}" = "${NVM_NODE_PREFIX}-" ]
		then
			NVM_DIRS_TO_SEARCH1="${NVM_VERSION_DIR_OLD}" 
			NVM_DIRS_TO_SEARCH2="${NVM_VERSION_DIR_NEW}" 
			PATTERN='' 
			if nvm_has_system_node
			then
				NVM_ADD_SYSTEM=true 
			fi
		else
			NVM_DIRS_TO_SEARCH1="${NVM_VERSION_DIR_OLD}" 
			NVM_DIRS_TO_SEARCH2="${NVM_VERSION_DIR_NEW}" 
			NVM_DIRS_TO_SEARCH3="${NVM_VERSION_DIR_IOJS}" 
			if nvm_has_system_iojs || nvm_has_system_node
			then
				NVM_ADD_SYSTEM=true 
			fi
		fi
		if ! [ -d "${NVM_DIRS_TO_SEARCH1}" ] || ! (
				command ls -1qA "${NVM_DIRS_TO_SEARCH1}" | nvm_grep -q .
			)
		then
			NVM_DIRS_TO_SEARCH1='' 
		fi
		if ! [ -d "${NVM_DIRS_TO_SEARCH2}" ] || ! (
				command ls -1qA "${NVM_DIRS_TO_SEARCH2}" | nvm_grep -q .
			)
		then
			NVM_DIRS_TO_SEARCH2="${NVM_DIRS_TO_SEARCH1}" 
		fi
		if ! [ -d "${NVM_DIRS_TO_SEARCH3}" ] || ! (
				command ls -1qA "${NVM_DIRS_TO_SEARCH3}" | nvm_grep -q .
			)
		then
			NVM_DIRS_TO_SEARCH3="${NVM_DIRS_TO_SEARCH2}" 
		fi
		local SEARCH_PATTERN
		if [ -z "${PATTERN}" ]
		then
			PATTERN='v' 
			SEARCH_PATTERN='.*' 
		else
			SEARCH_PATTERN="$(nvm_echo "${PATTERN}" | command sed 's#\.#\\\.#g;')" 
		fi
		if [ -n "${NVM_DIRS_TO_SEARCH1}${NVM_DIRS_TO_SEARCH2}${NVM_DIRS_TO_SEARCH3}" ]
		then
			VERSIONS="$(command find "${NVM_DIRS_TO_SEARCH1}"/* "${NVM_DIRS_TO_SEARCH2}"/* "${NVM_DIRS_TO_SEARCH3}"/* -name . -o -type d -prune -o -path "${PATTERN}*" \
        | command sed -e "
            s#${NVM_VERSION_DIR_IOJS}/#versions/${NVM_IOJS_PREFIX}/#;
            s#^${NVM_DIR}/##;
            \\#^[^v]# d;
            \\#^versions\$# d;
            s#^versions/##;
            s#^v#${NVM_NODE_PREFIX}/v#;
            \\#${SEARCH_PATTERN}# !d;
          " \
          -e 's#^\([^/]\{1,\}\)/\(.*\)$#\2.\1#;' \
        | command sort -t. -u -k 1.2,1n -k 2,2n -k 3,3n \
        | command sed -e 's#\(.*\)\.\([^\.]\{1,\}\)$#\2-\1#;' \
                      -e "s#^${NVM_NODE_PREFIX}-##;" \
      )" 
		fi
	fi
	if [ "${NVM_ADD_SYSTEM-}" = true ]
	then
		if [ -z "${PATTERN}" ] || [ "${PATTERN}" = 'v' ]
		then
			VERSIONS="${VERSIONS}
system" 
		elif [ "${PATTERN}" = 'system' ]
		then
			VERSIONS="system" 
		fi
	fi
	if [ -z "${VERSIONS}" ]
	then
		nvm_echo 'N/A'
		return 3
	fi
	nvm_echo "${VERSIONS}"
}
nvm_ls_current () {
	local NVM_LS_CURRENT_NODE_PATH
	if ! NVM_LS_CURRENT_NODE_PATH="$(command which node 2>/dev/null)" 
	then
		nvm_echo 'none'
	elif nvm_tree_contains_path "$(nvm_version_dir iojs)" "${NVM_LS_CURRENT_NODE_PATH}"
	then
		nvm_add_iojs_prefix "$(iojs --version 2>/dev/null)"
	elif nvm_tree_contains_path "${NVM_DIR}" "${NVM_LS_CURRENT_NODE_PATH}"
	then
		local VERSION
		VERSION="$(node --version 2>/dev/null)" 
		if [ "${VERSION}" = "v0.6.21-pre" ]
		then
			nvm_echo 'v0.6.21'
		else
			nvm_echo "${VERSION:-none}"
		fi
	else
		nvm_echo 'system'
	fi
}
nvm_ls_remote () {
	local PATTERN
	PATTERN="${1-}" 
	if nvm_validate_implicit_alias "${PATTERN}" 2> /dev/null
	then
		local IMPLICIT
		IMPLICIT="$(nvm_print_implicit_alias remote "${PATTERN}")" 
		if [ -z "${IMPLICIT-}" ] || [ "${IMPLICIT}" = 'N/A' ]
		then
			nvm_echo "N/A"
			return 3
		fi
		PATTERN="$(NVM_LTS="${NVM_LTS-}" nvm_ls_remote "${IMPLICIT}" | command tail -1 | command awk '{ print $1 }')" 
	elif [ -n "${PATTERN}" ]
	then
		PATTERN="$(nvm_ensure_version_prefix "${PATTERN}")" 
	else
		PATTERN=".*" 
	fi
	NVM_LTS="${NVM_LTS-}" nvm_ls_remote_index_tab node std "${PATTERN}"
}
nvm_ls_remote_index_tab () {
	local LTS
	LTS="${NVM_LTS-}" 
	if [ "$#" -lt 3 ]
	then
		nvm_err 'not enough arguments'
		return 5
	fi
	local FLAVOR
	FLAVOR="${1-}" 
	local TYPE
	TYPE="${2-}" 
	local MIRROR
	MIRROR="$(nvm_get_mirror "${FLAVOR}" "${TYPE}")" 
	if [ -z "${MIRROR}" ]
	then
		return 3
	fi
	local PREFIX
	PREFIX='' 
	case "${FLAVOR}-${TYPE}" in
		(iojs-std) PREFIX="$(nvm_iojs_prefix)-"  ;;
		(node-std) PREFIX=''  ;;
		(iojs-*) nvm_err 'unknown type of io.js release'
			return 4 ;;
		(*) nvm_err 'unknown type of node.js release'
			return 4 ;;
	esac
	local SORT_COMMAND
	SORT_COMMAND='command sort' 
	case "${FLAVOR}" in
		(node) SORT_COMMAND='command sort -t. -u -k 1.2,1n -k 2,2n -k 3,3n'  ;;
	esac
	local PATTERN
	PATTERN="${3-}" 
	if [ "${PATTERN#"${PATTERN%?}"}" = '.' ]
	then
		PATTERN="${PATTERN%.}" 
	fi
	local VERSIONS
	if [ -n "${PATTERN}" ] && [ "${PATTERN}" != '*' ]
	then
		if [ "${FLAVOR}" = 'iojs' ]
		then
			PATTERN="$(nvm_ensure_version_prefix "$(nvm_strip_iojs_prefix "${PATTERN}")")" 
		else
			PATTERN="$(nvm_ensure_version_prefix "${PATTERN}")" 
		fi
	else
		unset PATTERN
	fi
	nvm_is_zsh && setopt local_options shwordsplit
	local VERSION_LIST
	VERSION_LIST="$(nvm_download -L -s "${MIRROR}/index.tab" -o - \
    | command sed "
        1d;
        s/^/${PREFIX}/;
      " \
  )" 
	local LTS_ALIAS
	local LTS_VERSION
	command mkdir -p "$(nvm_alias_path)/lts"
	{
		command awk '{
        if ($10 ~ /^\-?$/) { next }
        if ($10 && !a[tolower($10)]++) {
          if (alias) { print alias, version }
          alias_name = "lts/" tolower($10)
          if (!alias) { print "lts/*", alias_name }
          alias = alias_name
          version = $1
        }
      }
      END {
        if (alias) {
          print alias, version
        }
      }' | while read -r LTS_ALIAS_LINE
		do
			LTS_ALIAS="${LTS_ALIAS_LINE%% *}" 
			LTS_VERSION="${LTS_ALIAS_LINE#* }" 
			nvm_make_alias "${LTS_ALIAS}" "${LTS_VERSION}" > /dev/null 2>&1
		done
	} <<EOF
$VERSION_LIST
EOF
	if [ -n "${LTS-}" ]
	then
		LTS="$(nvm_normalize_lts "lts/${LTS}")" 
		LTS="${LTS#lts/}" 
	fi
	VERSIONS="$({ command awk -v lts="${LTS-}" '{
        if (!$1) { next }
        if (lts && $10 ~ /^\-?$/) { next }
        if (lts && lts != "*" && tolower($10) !~ tolower(lts)) { next }
        if ($10 !~ /^\-?$/) {
          if ($10 && $10 != prev) {
            print $1, $10, "*"
          } else {
            print $1, $10
          }
        } else {
          print $1
        }
        prev=$10;
      }' \
    | nvm_grep -w "${PATTERN:-.*}" \
    | $SORT_COMMAND; } << EOF
$VERSION_LIST
EOF
)" 
	if [ -z "${VERSIONS}" ]
	then
		nvm_echo 'N/A'
		return 3
	fi
	nvm_echo "${VERSIONS}"
}
nvm_ls_remote_iojs () {
	NVM_LTS="${NVM_LTS-}" nvm_ls_remote_index_tab iojs std "${1-}"
}
nvm_make_alias () {
	local ALIAS
	ALIAS="${1-}" 
	if [ -z "${ALIAS}" ]
	then
		nvm_err "an alias name is required"
		return 1
	fi
	local VERSION
	VERSION="${2-}" 
	if [ -z "${VERSION}" ]
	then
		nvm_err "an alias target version is required"
		return 2
	fi
	nvm_echo "${VERSION}" | tee "$(nvm_alias_path)/${ALIAS}" > /dev/null
}
nvm_match_version () {
	local NVM_IOJS_PREFIX
	NVM_IOJS_PREFIX="$(nvm_iojs_prefix)" 
	local PROVIDED_VERSION
	PROVIDED_VERSION="$1" 
	case "_${PROVIDED_VERSION}" in
		("_${NVM_IOJS_PREFIX}" | '_io.js') nvm_version "${NVM_IOJS_PREFIX}" ;;
		('_system') nvm_echo 'system' ;;
		(*) nvm_version "${PROVIDED_VERSION}" ;;
	esac
}
nvm_node_prefix () {
	nvm_echo 'node'
}
nvm_node_version_has_solaris_binary () {
	local NODE_VERSION
	NODE_VERSION="$1" 
	local STRIPPED_IOJS_VERSION
	STRIPPED_IOJS_VERSION="$(nvm_strip_iojs_prefix "${NODE_VERSION}")" 
	if [ "_${STRIPPED_IOJS_VERSION}" != "_${NODE_VERSION}" ]
	then
		return 1
	fi
	nvm_version_greater_than_or_equal_to "${NODE_VERSION}" v0.8.6 && ! nvm_version_greater_than_or_equal_to "${NODE_VERSION}" v1.0.0
}
nvm_normalize_lts () {
	local LTS
	LTS="${1-}" 
	case "${LTS}" in
		(lts/-[123456789] | lts/-[123456789][0123456789]*) local N
			N="$(echo "${LTS}" | cut -d '-' -f 2)" 
			N=$((N+1)) 
			if [ $? -ne 0 ]
			then
				nvm_echo "${LTS}"
				return 0
			fi
			local NVM_ALIAS_DIR
			NVM_ALIAS_DIR="$(nvm_alias_path)" 
			local RESULT
			RESULT="$(command ls "${NVM_ALIAS_DIR}/lts" | command tail -n "${N}" | command head -n 1)" 
			if [ "${RESULT}" != '*' ]
			then
				nvm_echo "lts/${RESULT}"
			else
				nvm_err 'That many LTS releases do not exist yet.'
				return 2
			fi ;;
		(*) nvm_echo "${LTS}" ;;
	esac
}
nvm_normalize_version () {
	command awk 'BEGIN {
    split(ARGV[1], a, /\./);
    printf "%d%06d%06d\n", a[1], a[2], a[3];
    exit;
  }' "${1#v}"
}
nvm_npm_global_modules () {
	local NPMLIST
	local VERSION
	VERSION="$1" 
	NPMLIST=$(nvm use "${VERSION}" >/dev/null && npm list -g --depth=0 2>/dev/null | command sed 1,1d | nvm_grep -v 'UNMET PEER DEPENDENCY') 
	local INSTALLS
	INSTALLS=$(nvm_echo "${NPMLIST}" | command sed -e '/ -> / d' -e '/\(empty\)/ d' -e 's/^.* \(.*@[^ ]*\).*/\1/' -e '/^npm@[^ ]*.*$/ d' | command xargs) 
	local LINKS
	LINKS="$(nvm_echo "${NPMLIST}" | command sed -n 's/.* -> \(.*\)/\1/ p')" 
	nvm_echo "${INSTALLS} //// ${LINKS}"
}
nvm_npmrc_bad_news_bears () {
	local NVM_NPMRC
	NVM_NPMRC="${1-}" 
	if [ -n "${NVM_NPMRC}" ] && [ -f "${NVM_NPMRC}" ] && nvm_grep -Ee '^(prefix|globalconfig) *=' < "${NVM_NPMRC}" > /dev/null
	then
		return 0
	fi
	return 1
}
nvm_num_version_groups () {
	local VERSION
	VERSION="${1-}" 
	VERSION="${VERSION#v}" 
	VERSION="${VERSION%.}" 
	if [ -z "${VERSION}" ]
	then
		nvm_echo "0"
		return
	fi
	local NVM_NUM_DOTS
	NVM_NUM_DOTS=$(nvm_echo "${VERSION}" | command sed -e 's/[^\.]//g') 
	local NVM_NUM_GROUPS
	NVM_NUM_GROUPS=".${NVM_NUM_DOTS}" 
	nvm_echo "${#NVM_NUM_GROUPS}"
}
nvm_nvmrc_invalid_msg () {
	local error_text
	error_text="invalid .nvmrc!
all non-commented content (anything after # is a comment) must be either:
  - a single bare nvm-recognized version-ish
  - or, multiple distinct key-value pairs, each key/value separated by a single equals sign (=)

additionally, a single bare nvm-recognized version-ish must be present (after stripping comments)." 
	local warn_text
	warn_text="non-commented content parsed:
${1}" 
	nvm_err "$(nvm_wrap_with_color_code 'r' "${error_text}")

$(nvm_wrap_with_color_code 'y' "${warn_text}")"
}
nvm_print_alias_path () {
	local NVM_ALIAS_DIR
	NVM_ALIAS_DIR="${1-}" 
	if [ -z "${NVM_ALIAS_DIR}" ]
	then
		nvm_err 'An alias dir is required.'
		return 1
	fi
	local ALIAS_PATH
	ALIAS_PATH="${2-}" 
	if [ -z "${ALIAS_PATH}" ]
	then
		nvm_err 'An alias path is required.'
		return 2
	fi
	local ALIAS
	ALIAS="${ALIAS_PATH##"${NVM_ALIAS_DIR}"\/}" 
	local DEST
	DEST="$(nvm_alias "${ALIAS}" 2>/dev/null)"  || :
	if [ -n "${DEST}" ]
	then
		NVM_NO_COLORS="${NVM_NO_COLORS-}" NVM_LTS="${NVM_LTS-}" DEFAULT=false nvm_print_formatted_alias "${ALIAS}" "${DEST}"
	fi
}
nvm_print_color_code () {
	case "${1-}" in
		('0') return 0 ;;
		('r') nvm_echo '0;31m' ;;
		('R') nvm_echo '1;31m' ;;
		('g') nvm_echo '0;32m' ;;
		('G') nvm_echo '1;32m' ;;
		('b') nvm_echo '0;34m' ;;
		('B') nvm_echo '1;34m' ;;
		('c') nvm_echo '0;36m' ;;
		('C') nvm_echo '1;36m' ;;
		('m') nvm_echo '0;35m' ;;
		('M') nvm_echo '1;35m' ;;
		('y') nvm_echo '0;33m' ;;
		('Y') nvm_echo '1;33m' ;;
		('k') nvm_echo '0;30m' ;;
		('K') nvm_echo '1;30m' ;;
		('e') nvm_echo '0;37m' ;;
		('W') nvm_echo '1;37m' ;;
		(*) nvm_err "Invalid color code: ${1-}"
			return 1 ;;
	esac
}
nvm_print_default_alias () {
	local ALIAS
	ALIAS="${1-}" 
	if [ -z "${ALIAS}" ]
	then
		nvm_err 'A default alias is required.'
		return 1
	fi
	local DEST
	DEST="$(nvm_print_implicit_alias local "${ALIAS}")" 
	if [ -n "${DEST}" ]
	then
		NVM_NO_COLORS="${NVM_NO_COLORS-}" DEFAULT=true nvm_print_formatted_alias "${ALIAS}" "${DEST}"
	fi
}
nvm_print_formatted_alias () {
	local ALIAS
	ALIAS="${1-}" 
	local DEST
	DEST="${2-}" 
	local VERSION
	VERSION="${3-}" 
	if [ -z "${VERSION}" ]
	then
		VERSION="$(nvm_version "${DEST}")"  || :
	fi
	local VERSION_FORMAT
	local ALIAS_FORMAT
	local DEST_FORMAT
	local INSTALLED_COLOR
	local SYSTEM_COLOR
	local CURRENT_COLOR
	local NOT_INSTALLED_COLOR
	local DEFAULT_COLOR
	local LTS_COLOR
	INSTALLED_COLOR=$(nvm_get_colors 1) 
	SYSTEM_COLOR=$(nvm_get_colors 2) 
	CURRENT_COLOR=$(nvm_get_colors 3) 
	NOT_INSTALLED_COLOR=$(nvm_get_colors 4) 
	DEFAULT_COLOR=$(nvm_get_colors 5) 
	LTS_COLOR=$(nvm_get_colors 6) 
	ALIAS_FORMAT='%s' 
	DEST_FORMAT='%s' 
	VERSION_FORMAT='%s' 
	local NEWLINE
	NEWLINE='\n' 
	if [ "_${DEFAULT}" = '_true' ]
	then
		NEWLINE=' (default)\n' 
	fi
	local ARROW
	ARROW='->' 
	if nvm_has_colors
	then
		ARROW='\033[0;90m->\033[0m' 
		if [ "_${DEFAULT}" = '_true' ]
		then
			NEWLINE=" \033[${DEFAULT_COLOR}(default)\033[0m\n" 
		fi
		if [ "_${VERSION}" = "_${NVM_CURRENT-}" ]
		then
			ALIAS_FORMAT="\033[${CURRENT_COLOR}%s\033[0m" 
			DEST_FORMAT="\033[${CURRENT_COLOR}%s\033[0m" 
			VERSION_FORMAT="\033[${CURRENT_COLOR}%s\033[0m" 
		elif nvm_is_version_installed "${VERSION}"
		then
			ALIAS_FORMAT="\033[${INSTALLED_COLOR}%s\033[0m" 
			DEST_FORMAT="\033[${INSTALLED_COLOR}%s\033[0m" 
			VERSION_FORMAT="\033[${INSTALLED_COLOR}%s\033[0m" 
		elif [ "${VERSION}" = '∞' ] || [ "${VERSION}" = 'N/A' ]
		then
			ALIAS_FORMAT="\033[${NOT_INSTALLED_COLOR}%s\033[0m" 
			DEST_FORMAT="\033[${NOT_INSTALLED_COLOR}%s\033[0m" 
			VERSION_FORMAT="\033[${NOT_INSTALLED_COLOR}%s\033[0m" 
		fi
		if [ "_${NVM_LTS-}" = '_true' ]
		then
			ALIAS_FORMAT="\033[${LTS_COLOR}%s\033[0m" 
		fi
		if [ "_${DEST%/*}" = "_lts" ]
		then
			DEST_FORMAT="\033[${LTS_COLOR}%s\033[0m" 
		fi
	elif [ "_${VERSION}" != '_∞' ] && [ "_${VERSION}" != '_N/A' ]
	then
		VERSION_FORMAT='%s *' 
	fi
	if [ "${DEST}" = "${VERSION}" ]
	then
		command printf -- "${ALIAS_FORMAT} ${ARROW} ${VERSION_FORMAT}${NEWLINE}" "${ALIAS}" "${DEST}"
	else
		command printf -- "${ALIAS_FORMAT} ${ARROW} ${DEST_FORMAT} (${ARROW} ${VERSION_FORMAT})${NEWLINE}" "${ALIAS}" "${DEST}" "${VERSION}"
	fi
}
nvm_print_implicit_alias () {
	if [ "_$1" != "_local" ] && [ "_$1" != "_remote" ]
	then
		nvm_err "nvm_print_implicit_alias must be specified with local or remote as the first argument."
		return 1
	fi
	local NVM_IMPLICIT
	NVM_IMPLICIT="$2" 
	if ! nvm_validate_implicit_alias "${NVM_IMPLICIT}"
	then
		return 2
	fi
	local NVM_IOJS_PREFIX
	NVM_IOJS_PREFIX="$(nvm_iojs_prefix)" 
	local NVM_NODE_PREFIX
	NVM_NODE_PREFIX="$(nvm_node_prefix)" 
	local NVM_COMMAND
	local NVM_ADD_PREFIX_COMMAND
	local LAST_TWO
	case "${NVM_IMPLICIT}" in
		("${NVM_IOJS_PREFIX}") NVM_COMMAND="nvm_ls_remote_iojs" 
			NVM_ADD_PREFIX_COMMAND="nvm_add_iojs_prefix" 
			if [ "_$1" = "_local" ]
			then
				NVM_COMMAND="nvm_ls ${NVM_IMPLICIT}" 
			fi
			nvm_is_zsh && setopt local_options shwordsplit
			local NVM_IOJS_VERSION
			local EXIT_CODE
			NVM_IOJS_VERSION="$(${NVM_COMMAND})"  && :
			EXIT_CODE="$?" 
			if [ "_${EXIT_CODE}" = "_0" ]
			then
				NVM_IOJS_VERSION="$(nvm_echo "${NVM_IOJS_VERSION}" | command sed "s/^${NVM_IMPLICIT}-//" | nvm_grep -e '^v' | command cut -c2- | command cut -d . -f 1,2 | uniq | command tail -1)" 
			fi
			if [ "_$NVM_IOJS_VERSION" = "_N/A" ]
			then
				nvm_echo 'N/A'
			else
				${NVM_ADD_PREFIX_COMMAND} "${NVM_IOJS_VERSION}"
			fi
			return $EXIT_CODE ;;
		("${NVM_NODE_PREFIX}") nvm_echo 'stable'
			return ;;
		(*) NVM_COMMAND="nvm_ls_remote" 
			if [ "_$1" = "_local" ]
			then
				NVM_COMMAND="nvm_ls node" 
			fi
			nvm_is_zsh && setopt local_options shwordsplit
			LAST_TWO=$($NVM_COMMAND | nvm_grep -e '^v' | command cut -c2- | command cut -d . -f 1,2 | uniq)  ;;
	esac
	local MINOR
	local STABLE
	local UNSTABLE
	local MOD
	local NORMALIZED_VERSION
	nvm_is_zsh && setopt local_options shwordsplit
	for MINOR in $LAST_TWO
	do
		NORMALIZED_VERSION="$(nvm_normalize_version "$MINOR")" 
		if [ "_0${NORMALIZED_VERSION#?}" != "_$NORMALIZED_VERSION" ]
		then
			STABLE="$MINOR" 
		else
			MOD="$(awk 'BEGIN { print int(ARGV[1] / 1000000) % 2 ; exit(0) }' "${NORMALIZED_VERSION}")" 
			if [ "${MOD}" -eq 0 ]
			then
				STABLE="${MINOR}" 
			elif [ "${MOD}" -eq 1 ]
			then
				UNSTABLE="${MINOR}" 
			fi
		fi
	done
	if [ "_$2" = '_stable' ]
	then
		nvm_echo "${STABLE}"
	elif [ "_$2" = '_unstable' ]
	then
		nvm_echo "${UNSTABLE:-"N/A"}"
	fi
}
nvm_print_npm_version () {
	if nvm_has "npm"
	then
		local NPM_VERSION
		NPM_VERSION="$(npm --version 2>/dev/null)" 
		if [ -n "${NPM_VERSION}" ]
		then
			command printf " (npm v${NPM_VERSION})"
		fi
	fi
}
nvm_print_versions () {
	local NVM_CURRENT
	NVM_CURRENT=$(nvm_ls_current) 
	local INSTALLED_COLOR
	local SYSTEM_COLOR
	local CURRENT_COLOR
	local NOT_INSTALLED_COLOR
	local DEFAULT_COLOR
	local LTS_COLOR
	local NVM_HAS_COLORS
	NVM_HAS_COLORS=0 
	INSTALLED_COLOR=$(nvm_get_colors 1) 
	SYSTEM_COLOR=$(nvm_get_colors 2) 
	CURRENT_COLOR=$(nvm_get_colors 3) 
	NOT_INSTALLED_COLOR=$(nvm_get_colors 4) 
	DEFAULT_COLOR=$(nvm_get_colors 5) 
	LTS_COLOR=$(nvm_get_colors 6) 
	if nvm_has_colors
	then
		NVM_HAS_COLORS=1 
	fi
	command awk -v remote_versions="$(printf '%s' "${1-}" | tr '\n' '|')" -v installed_versions="$(nvm_ls | tr '\n' '|')" -v current="$NVM_CURRENT" -v installed_color="$INSTALLED_COLOR" -v system_color="$SYSTEM_COLOR" -v current_color="$CURRENT_COLOR" -v default_color="$DEFAULT_COLOR" -v old_lts_color="$DEFAULT_COLOR" -v has_colors="$NVM_HAS_COLORS" '
function alen(arr, i, len) { len=0; for(i in arr) len++; return len; }
BEGIN {
  fmt_installed = has_colors ? (installed_color ? "\033[" installed_color "%15s\033[0m" : "%15s") : "%15s *";
  fmt_system = has_colors ? (system_color ? "\033[" system_color "%15s\033[0m" : "%15s") : "%15s *";
  fmt_current = has_colors ? (current_color ? "\033[" current_color "->%13s\033[0m" : "%15s") : "->%13s *";

  latest_lts_color = current_color;
  sub(/0;/, "1;", latest_lts_color);

  fmt_latest_lts = has_colors && latest_lts_color ? ("\033[" latest_lts_color " (Latest LTS: %s)\033[0m") : " (Latest LTS: %s)";
  fmt_old_lts = has_colors && old_lts_color ? ("\033[" old_lts_color " (LTS: %s)\033[0m") : " (LTS: %s)";

  split(remote_versions, lines, "|");
  split(installed_versions, installed, "|");
  rows = alen(lines);

  for (n = 1; n <= rows; n++) {
    split(lines[n], fields, "[[:blank:]]+");
    cols = alen(fields);
    version = fields[1];
    is_installed = 0;

    for (i in installed) {
      if (version == installed[i]) {
        is_installed = 1;
        break;
      }
    }

    fmt_version = "%15s";
    if (version == current) {
      fmt_version = fmt_current;
    } else if (version == "system") {
      fmt_version = fmt_system;
    } else if (is_installed) {
      fmt_version = fmt_installed;
    }

    padding = (!has_colors && is_installed) ? "" : "  ";

    if (cols == 1) {
      formatted = sprintf(fmt_version, version);
    } else if (cols == 2) {
      formatted = sprintf((fmt_version padding fmt_old_lts), version, fields[2]);
    } else if (cols == 3 && fields[3] == "*") {
      formatted = sprintf((fmt_version padding fmt_latest_lts), version, fields[2]);
    }

    output[n] = formatted;
  }

  for (n = 1; n <= rows; n++) {
    print output[n]
  }

  exit
}'
}
nvm_process_nvmrc () {
	local NVMRC_PATH="$1" 
	local lines
	local unpaired_line
	lines=$(command sed 's/#.*//' "$NVMRC_PATH" | command sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | nvm_grep -v '^$') 
	if [ -z "$lines" ]
	then
		nvm_nvmrc_invalid_msg "${lines}"
		return 1
	fi
	local keys='' 
	local values='' 
	while IFS= read -r line
	do
		if [ -z "${line}" ]
		then
			continue
		elif [ -z "${line%%=*}" ]
		then
			if [ -n "${unpaired_line}" ]
			then
				nvm_nvmrc_invalid_msg "${lines}"
				return 1
			fi
			unpaired_line="${line}" 
		elif case "$line" in
				(*'='*) true ;;
				(*) false ;;
			esac
		then
			key="${line%%=*}" 
			value="${line#*=}" 
			key=$(nvm_echo "${key}" | command sed 's/^[[:space:]]*//;s/[[:space:]]*$//') 
			value=$(nvm_echo "${value}" | command sed 's/^[[:space:]]*//;s/[[:space:]]*$//') 
			if [ "${key}" = 'node' ]
			then
				nvm_nvmrc_invalid_msg "${lines}"
				return 1
			fi
			if nvm_echo "${keys}" | nvm_grep -q -E "(^| )${key}( |$)"
			then
				nvm_nvmrc_invalid_msg "${lines}"
				return 1
			fi
			keys="${keys} ${key}" 
			values="${values} ${value}" 
		else
			if [ -n "${unpaired_line}" ]
			then
				nvm_nvmrc_invalid_msg "${lines}"
				return 1
			fi
			unpaired_line="${line}" 
		fi
	done <<EOF
$lines
EOF
	if [ -z "${unpaired_line}" ]
	then
		nvm_nvmrc_invalid_msg "${lines}"
		return 1
	fi
	nvm_echo "${unpaired_line}"
}
nvm_process_parameters () {
	local NVM_AUTO_MODE
	NVM_AUTO_MODE='use' 
	while [ "$#" -ne 0 ]
	do
		case "$1" in
			(--install) NVM_AUTO_MODE='install'  ;;
			(--no-use) NVM_AUTO_MODE='none'  ;;
		esac
		shift
	done
	nvm_auto "${NVM_AUTO_MODE}"
}
nvm_prompt_info () {
	which nvm &> /dev/null || return
	local nvm_prompt=${$(nvm current)#v} 
	echo "${ZSH_THEME_NVM_PROMPT_PREFIX}${nvm_prompt:gs/%/%%}${ZSH_THEME_NVM_PROMPT_SUFFIX}"
}
nvm_rc_version () {
	export NVM_RC_VERSION='' 
	local NVMRC_PATH
	NVMRC_PATH="$(nvm_find_nvmrc)" 
	if [ ! -e "${NVMRC_PATH}" ]
	then
		if [ "${NVM_SILENT:-0}" -ne 1 ]
		then
			nvm_err "No .nvmrc file found"
		fi
		return 1
	fi
	if ! NVM_RC_VERSION="$(nvm_process_nvmrc "${NVMRC_PATH}")" 
	then
		return 1
	fi
	if [ -z "${NVM_RC_VERSION}" ]
	then
		if [ "${NVM_SILENT:-0}" -ne 1 ]
		then
			nvm_err "Warning: empty .nvmrc file found at \"${NVMRC_PATH}\""
		fi
		return 2
	fi
	if [ "${NVM_SILENT:-0}" -ne 1 ]
	then
		nvm_echo "Found '${NVMRC_PATH}' with version <${NVM_RC_VERSION}>"
	fi
}
nvm_remote_version () {
	local PATTERN
	PATTERN="${1-}" 
	local VERSION
	if nvm_validate_implicit_alias "${PATTERN}" 2> /dev/null
	then
		case "${PATTERN}" in
			("$(nvm_iojs_prefix)") VERSION="$(NVM_LTS="${NVM_LTS-}" nvm_ls_remote_iojs | command tail -1)"  && : ;;
			(*) VERSION="$(NVM_LTS="${NVM_LTS-}" nvm_ls_remote "${PATTERN}")"  && : ;;
		esac
	else
		VERSION="$(NVM_LTS="${NVM_LTS-}" nvm_remote_versions "${PATTERN}" | command tail -1)" 
	fi
	if [ -n "${NVM_VERSION_ONLY-}" ]
	then
		command awk 'BEGIN {
      n = split(ARGV[1], a);
      print a[1]
    }' "${VERSION}"
	else
		nvm_echo "${VERSION}"
	fi
	if [ "${VERSION}" = 'N/A' ]
	then
		return 3
	fi
}
nvm_remote_versions () {
	local NVM_IOJS_PREFIX
	NVM_IOJS_PREFIX="$(nvm_iojs_prefix)" 
	local NVM_NODE_PREFIX
	NVM_NODE_PREFIX="$(nvm_node_prefix)" 
	local PATTERN
	PATTERN="${1-}" 
	local NVM_FLAVOR
	if [ -n "${NVM_LTS-}" ]
	then
		NVM_FLAVOR="${NVM_NODE_PREFIX}" 
	fi
	case "${PATTERN}" in
		("${NVM_IOJS_PREFIX}" | "io.js") NVM_FLAVOR="${NVM_IOJS_PREFIX}" 
			unset PATTERN ;;
		("${NVM_NODE_PREFIX}") NVM_FLAVOR="${NVM_NODE_PREFIX}" 
			unset PATTERN ;;
	esac
	if nvm_validate_implicit_alias "${PATTERN-}" 2> /dev/null
	then
		nvm_err 'Implicit aliases are not supported in nvm_remote_versions.'
		return 1
	fi
	local NVM_LS_REMOTE_EXIT_CODE
	NVM_LS_REMOTE_EXIT_CODE=0 
	local NVM_LS_REMOTE_PRE_MERGED_OUTPUT
	NVM_LS_REMOTE_PRE_MERGED_OUTPUT='' 
	local NVM_LS_REMOTE_POST_MERGED_OUTPUT
	NVM_LS_REMOTE_POST_MERGED_OUTPUT='' 
	if [ -z "${NVM_FLAVOR-}" ] || [ "${NVM_FLAVOR-}" = "${NVM_NODE_PREFIX}" ]
	then
		local NVM_LS_REMOTE_OUTPUT
		NVM_LS_REMOTE_OUTPUT="$(NVM_LTS="${NVM_LTS-}" nvm_ls_remote "${PATTERN-}") "  && :
		NVM_LS_REMOTE_EXIT_CODE=$? 
		NVM_LS_REMOTE_PRE_MERGED_OUTPUT="${NVM_LS_REMOTE_OUTPUT%%v4\.0\.0*}" 
		NVM_LS_REMOTE_POST_MERGED_OUTPUT="${NVM_LS_REMOTE_OUTPUT#"$NVM_LS_REMOTE_PRE_MERGED_OUTPUT"}" 
	fi
	local NVM_LS_REMOTE_IOJS_EXIT_CODE
	NVM_LS_REMOTE_IOJS_EXIT_CODE=0 
	local NVM_LS_REMOTE_IOJS_OUTPUT
	NVM_LS_REMOTE_IOJS_OUTPUT='' 
	if [ -z "${NVM_LTS-}" ] && {
			[ -z "${NVM_FLAVOR-}" ] || [ "${NVM_FLAVOR-}" = "${NVM_IOJS_PREFIX}" ]
		}
	then
		NVM_LS_REMOTE_IOJS_OUTPUT=$(nvm_ls_remote_iojs "${PATTERN-}")  && :
		NVM_LS_REMOTE_IOJS_EXIT_CODE=$? 
	fi
	VERSIONS="$(nvm_echo "${NVM_LS_REMOTE_PRE_MERGED_OUTPUT}
${NVM_LS_REMOTE_IOJS_OUTPUT}
${NVM_LS_REMOTE_POST_MERGED_OUTPUT}" | nvm_grep -v "N/A" | command sed '/^ *$/d')" 
	if [ -z "${VERSIONS}" ]
	then
		nvm_echo 'N/A'
		return 3
	fi
	nvm_echo "${VERSIONS}" | command sed 's/ *$//g'
	return $NVM_LS_REMOTE_EXIT_CODE || $NVM_LS_REMOTE_IOJS_EXIT_CODE
}
nvm_resolve_alias () {
	if [ -z "${1-}" ]
	then
		return 1
	fi
	local PATTERN
	PATTERN="${1-}" 
	local ALIAS
	ALIAS="${PATTERN}" 
	local ALIAS_TEMP
	local SEEN_ALIASES
	SEEN_ALIASES="${ALIAS}" 
	local NVM_ALIAS_INDEX
	NVM_ALIAS_INDEX=1 
	while true
	do
		ALIAS_TEMP="$( (nvm_alias "${ALIAS}" 2>/dev/null | command head -n "${NVM_ALIAS_INDEX}" | command tail -n 1) || nvm_echo)" 
		if [ -z "${ALIAS_TEMP}" ]
		then
			break
		fi
		if command printf "${SEEN_ALIASES}" | nvm_grep -q -e "^${ALIAS_TEMP}$"
		then
			ALIAS="∞" 
			break
		fi
		SEEN_ALIASES="${SEEN_ALIASES}\\n${ALIAS_TEMP}" 
		ALIAS="${ALIAS_TEMP}" 
	done
	if [ -n "${ALIAS}" ] && [ "_${ALIAS}" != "_${PATTERN}" ]
	then
		local NVM_IOJS_PREFIX
		NVM_IOJS_PREFIX="$(nvm_iojs_prefix)" 
		local NVM_NODE_PREFIX
		NVM_NODE_PREFIX="$(nvm_node_prefix)" 
		case "${ALIAS}" in
			('∞' | "${NVM_IOJS_PREFIX}" | "${NVM_IOJS_PREFIX}-" | "${NVM_NODE_PREFIX}") nvm_echo "${ALIAS}" ;;
			(*) nvm_ensure_version_prefix "${ALIAS}" ;;
		esac
		return 0
	fi
	if nvm_validate_implicit_alias "${PATTERN}" 2> /dev/null
	then
		local IMPLICIT
		IMPLICIT="$(nvm_print_implicit_alias local "${PATTERN}" 2>/dev/null)" 
		if [ -n "${IMPLICIT}" ]
		then
			nvm_ensure_version_prefix "${IMPLICIT}"
		fi
	fi
	return 2
}
nvm_resolve_local_alias () {
	if [ -z "${1-}" ]
	then
		return 1
	fi
	local VERSION
	local EXIT_CODE
	VERSION="$(nvm_resolve_alias "${1-}")" 
	EXIT_CODE=$? 
	if [ -z "${VERSION}" ]
	then
		return $EXIT_CODE
	fi
	if [ "_${VERSION}" != '_∞' ]
	then
		nvm_version "${VERSION}"
	else
		nvm_echo "${VERSION}"
	fi
}
nvm_sanitize_auth_header () {
	nvm_echo "$1" | command sed 's/[^a-zA-Z0-9:;_. -]//g'
}
nvm_sanitize_path () {
	local SANITIZED_PATH
	SANITIZED_PATH="${1-}" 
	if [ "_${SANITIZED_PATH}" != "_${NVM_DIR}" ]
	then
		SANITIZED_PATH="$(nvm_echo "${SANITIZED_PATH}" | command sed -e "s#${NVM_DIR}#\${NVM_DIR}#g")" 
	fi
	if [ "_${SANITIZED_PATH}" != "_${HOME}" ]
	then
		SANITIZED_PATH="$(nvm_echo "${SANITIZED_PATH}" | command sed -e "s#${HOME}#\${HOME}#g")" 
	fi
	nvm_echo "${SANITIZED_PATH}"
}
nvm_set_colors () {
	if [ "${#1}" -eq 5 ] && nvm_echo "$1" | nvm_grep -E "^[rRgGbBcCyYmMkKeW]{1,}$" > /dev/null
	then
		local INSTALLED_COLOR
		local LTS_AND_SYSTEM_COLOR
		local CURRENT_COLOR
		local NOT_INSTALLED_COLOR
		local DEFAULT_COLOR
		INSTALLED_COLOR="$(echo "$1" | awk '{ print substr($0, 1, 1); }')" 
		LTS_AND_SYSTEM_COLOR="$(echo "$1" | awk '{ print substr($0, 2, 1); }')" 
		CURRENT_COLOR="$(echo "$1" | awk '{ print substr($0, 3, 1); }')" 
		NOT_INSTALLED_COLOR="$(echo "$1" | awk '{ print substr($0, 4, 1); }')" 
		DEFAULT_COLOR="$(echo "$1" | awk '{ print substr($0, 5, 1); }')" 
		if ! nvm_has_colors
		then
			nvm_echo "Setting colors to: ${INSTALLED_COLOR} ${LTS_AND_SYSTEM_COLOR} ${CURRENT_COLOR} ${NOT_INSTALLED_COLOR} ${DEFAULT_COLOR}"
			nvm_echo "WARNING: Colors may not display because they are not supported in this shell."
		else
			nvm_echo_with_colors "Setting colors to: $(nvm_wrap_with_color_code "${INSTALLED_COLOR}" "${INSTALLED_COLOR}")$(nvm_wrap_with_color_code "${LTS_AND_SYSTEM_COLOR}" "${LTS_AND_SYSTEM_COLOR}")$(nvm_wrap_with_color_code "${CURRENT_COLOR}" "${CURRENT_COLOR}")$(nvm_wrap_with_color_code "${NOT_INSTALLED_COLOR}" "${NOT_INSTALLED_COLOR}")$(nvm_wrap_with_color_code "${DEFAULT_COLOR}" "${DEFAULT_COLOR}")"
		fi
		export NVM_COLORS="$1" 
	else
		return 17
	fi
}
nvm_stdout_is_terminal () {
	[ -t 1 ]
}
nvm_strip_iojs_prefix () {
	local NVM_IOJS_PREFIX
	NVM_IOJS_PREFIX="$(nvm_iojs_prefix)" 
	if [ "${1-}" = "${NVM_IOJS_PREFIX}" ]
	then
		nvm_echo
	else
		nvm_echo "${1#"${NVM_IOJS_PREFIX}"-}"
	fi
}
nvm_strip_path () {
	if [ -z "${NVM_DIR-}" ]
	then
		nvm_err '${NVM_DIR} not set!'
		return 1
	fi
	command printf %s "${1-}" | command awk -v NVM_DIR="${NVM_DIR}" -v RS=: '
  index($0, NVM_DIR) == 1 {
    path = substr($0, length(NVM_DIR) + 1)
    if (path ~ "^(/versions/[^/]*)?/[^/]*'"${2-}"'.*$") { next }
  }
  # The final RT will contain a colon if the input has a trailing colon, or a null string otherwise
  { printf "%s%s", sep, $0; sep=RS } END { printf "%s", RT }'
}
nvm_supports_xz () {
	if [ -z "${1-}" ]
	then
		return 1
	fi
	local NVM_OS
	NVM_OS="$(nvm_get_os)" 
	if [ "_${NVM_OS}" = '_darwin' ]
	then
		local MACOS_VERSION
		MACOS_VERSION="$(sw_vers -productVersion)" 
		if nvm_version_greater "10.9.0" "${MACOS_VERSION}"
		then
			return 1
		fi
	elif [ "_${NVM_OS}" = '_freebsd' ]
	then
		if ! [ -e '/usr/lib/liblzma.so' ]
		then
			return 1
		fi
	else
		if ! command which xz > /dev/null 2>&1
		then
			return 1
		fi
	fi
	if nvm_is_merged_node_version "${1}"
	then
		return 0
	fi
	if nvm_version_greater_than_or_equal_to "${1}" "0.12.10" && nvm_version_greater "0.13.0" "${1}"
	then
		return 0
	fi
	if nvm_version_greater_than_or_equal_to "${1}" "0.10.42" && nvm_version_greater "0.11.0" "${1}"
	then
		return 0
	fi
	case "${NVM_OS}" in
		(darwin) nvm_version_greater_than_or_equal_to "${1}" "2.3.2" ;;
		(*) nvm_version_greater_than_or_equal_to "${1}" "1.0.0" ;;
	esac
	return $?
}
nvm_tree_contains_path () {
	local tree
	tree="${1-}" 
	local node_path
	node_path="${2-}" 
	if [ "@${tree}@" = "@@" ] || [ "@${node_path}@" = "@@" ]
	then
		nvm_err "both the tree and the node path are required"
		return 2
	fi
	local previous_pathdir
	previous_pathdir="${node_path}" 
	local pathdir
	pathdir=$(dirname "${previous_pathdir}") 
	while [ "${pathdir}" != '' ] && [ "${pathdir}" != '.' ] && [ "${pathdir}" != '/' ] && [ "${pathdir}" != "${tree}" ] && [ "${pathdir}" != "${previous_pathdir}" ]
	do
		previous_pathdir="${pathdir}" 
		pathdir=$(dirname "${previous_pathdir}") 
	done
	[ "${pathdir}" = "${tree}" ]
}
nvm_use_if_needed () {
	if [ "_${1-}" = "_$(nvm_ls_current)" ]
	then
		return
	fi
	nvm use "$@"
}
nvm_validate_implicit_alias () {
	local NVM_IOJS_PREFIX
	NVM_IOJS_PREFIX="$(nvm_iojs_prefix)" 
	local NVM_NODE_PREFIX
	NVM_NODE_PREFIX="$(nvm_node_prefix)" 
	case "$1" in
		("stable" | "unstable" | "${NVM_IOJS_PREFIX}" | "${NVM_NODE_PREFIX}") return ;;
		(*) nvm_err "Only implicit aliases 'stable', 'unstable', '${NVM_IOJS_PREFIX}', and '${NVM_NODE_PREFIX}' are supported."
			return 1 ;;
	esac
}
nvm_version () {
	local PATTERN
	PATTERN="${1-}" 
	local VERSION
	if [ -z "${PATTERN}" ]
	then
		PATTERN='current' 
	fi
	if [ "${PATTERN}" = "current" ]
	then
		nvm_ls_current
		return $?
	fi
	local NVM_NODE_PREFIX
	NVM_NODE_PREFIX="$(nvm_node_prefix)" 
	case "_${PATTERN}" in
		("_${NVM_NODE_PREFIX}" | "_${NVM_NODE_PREFIX}-") PATTERN="stable"  ;;
	esac
	VERSION="$(nvm_ls "${PATTERN}" | command tail -1)" 
	if [ -z "${VERSION}" ] || [ "_${VERSION}" = "_N/A" ]
	then
		nvm_echo "N/A"
		return 3
	fi
	nvm_echo "${VERSION}"
}
nvm_version_dir () {
	local NVM_WHICH_DIR
	NVM_WHICH_DIR="${1-}" 
	if [ -z "${NVM_WHICH_DIR}" ] || [ "${NVM_WHICH_DIR}" = "new" ]
	then
		nvm_echo "${NVM_DIR}/versions/node"
	elif [ "_${NVM_WHICH_DIR}" = "_iojs" ]
	then
		nvm_echo "${NVM_DIR}/versions/io.js"
	elif [ "_${NVM_WHICH_DIR}" = "_old" ]
	then
		nvm_echo "${NVM_DIR}"
	else
		nvm_err 'unknown version dir'
		return 3
	fi
}
nvm_version_greater () {
	command awk 'BEGIN {
    if (ARGV[1] == "" || ARGV[2] == "") exit(1)
    split(ARGV[1], a, /\./);
    split(ARGV[2], b, /\./);
    for (i=1; i<=3; i++) {
      if (a[i] && a[i] !~ /^[0-9]+$/) exit(2);
      if (b[i] && b[i] !~ /^[0-9]+$/) { exit(0); }
      if (a[i] < b[i]) exit(3);
      else if (a[i] > b[i]) exit(0);
    }
    exit(4)
  }' "${1#v}" "${2#v}"
}
nvm_version_greater_than_or_equal_to () {
	command awk 'BEGIN {
    if (ARGV[1] == "" || ARGV[2] == "") exit(1)
    split(ARGV[1], a, /\./);
    split(ARGV[2], b, /\./);
    for (i=1; i<=3; i++) {
      if (a[i] && a[i] !~ /^[0-9]+$/) exit(2);
      if (a[i] < b[i]) exit(3);
      else if (a[i] > b[i]) exit(0);
    }
    exit(0)
  }' "${1#v}" "${2#v}"
}
nvm_version_path () {
	local VERSION
	VERSION="${1-}" 
	if [ -z "${VERSION}" ]
	then
		nvm_err 'version is required'
		return 3
	elif nvm_is_iojs_version "${VERSION}"
	then
		nvm_echo "$(nvm_version_dir iojs)/$(nvm_strip_iojs_prefix "${VERSION}")"
	elif nvm_version_greater 0.12.0 "${VERSION}"
	then
		nvm_echo "$(nvm_version_dir old)/${VERSION}"
	else
		nvm_echo "$(nvm_version_dir new)/${VERSION}"
	fi
}
nvm_wrap_with_color_code () {
	local CODE
	CODE="$(nvm_print_color_code "${1}" 2>/dev/null ||:)" 
	local TEXT
	TEXT="${2-}" 
	if nvm_has_colors && [ -n "${CODE}" ]
	then
		nvm_echo_with_colors "\033[${CODE}${TEXT}\033[0m"
	else
		nvm_echo "${TEXT}"
	fi
}
nvm_write_nvmrc () {
	local VERSION_STRING
	VERSION_STRING=$(nvm_version "${1-$VERSION_STRING}") 
	if [ "$VERSION_STRING" = '∞' ] || [ "$VERSION_STRING" = 'N/A' ]
	then
		return 1
	fi
	echo "$VERSION_STRING" | tee "$PWD"/.nvmrc > /dev/null || {
		if [ "${NVM_SILENT:-0}" -ne 1 ]
		then
			nvm_err "Warning: Unable to write version number ($VERSION_STRING) to .nvmrc"
		fi
		return 3
	}
	if [ "${NVM_SILENT:-0}" -ne 1 ]
	then
		nvm_echo "Wrote version number ($VERSION_STRING) to .nvmrc"
	fi
}
omz () {
	setopt localoptions noksharrays
	[[ $# -gt 0 ]] || {
		_omz::help
		return 1
	}
	local command="$1" 
	shift
	(( ${+functions[_omz::$command]} )) || {
		_omz::help
		return 1
	}
	_omz::$command "$@"
}
omz_diagnostic_dump () {
	emulate -L zsh
	builtin echo "Generating diagnostic dump; please be patient..."
	local thisfcn=omz_diagnostic_dump 
	local -A opts
	local opt_verbose opt_noverbose opt_outfile
	local timestamp=$(date +%Y%m%d-%H%M%S) 
	local outfile=omz_diagdump_$timestamp.txt 
	builtin zparseopts -A opts -D -- "v+=opt_verbose" "V+=opt_noverbose"
	local verbose n_verbose=${#opt_verbose} n_noverbose=${#opt_noverbose} 
	(( verbose = 1 + n_verbose - n_noverbose ))
	if [[ ${#*} > 0 ]]
	then
		opt_outfile=$1 
	fi
	if [[ ${#*} > 1 ]]
	then
		builtin echo "$thisfcn: error: too many arguments" >&2
		return 1
	fi
	if [[ -n "$opt_outfile" ]]
	then
		outfile="$opt_outfile" 
	fi
	_omz_diag_dump_one_big_text &> "$outfile"
	if [[ $? != 0 ]]
	then
		builtin echo "$thisfcn: error while creating diagnostic dump; see $outfile for details"
	fi
	builtin echo
	builtin echo Diagnostic dump file created at: "$outfile"
	builtin echo
	builtin echo To share this with OMZ developers, post it as a gist on GitHub
	builtin echo at "https://gist.github.com" and share the link to the gist.
	builtin echo
	builtin echo "WARNING: This dump file contains all your zsh and omz configuration files,"
	builtin echo "so don't share it publicly if there's sensitive information in them."
	builtin echo
}
omz_history () {
	local clear list stamp REPLY
	zparseopts -E -D c=clear l=list f=stamp E=stamp i=stamp t:=stamp
	if [[ -n "$clear" ]]
	then
		print -nu2 "This action will irreversibly delete your command history. Are you sure? [y/N] "
		builtin read -E
		[[ "$REPLY" = [yY] ]] || return 0
		print -nu2 >| "$HISTFILE"
		fc -p "$HISTFILE"
		print -u2 History file deleted.
	elif [[ $# -eq 0 ]]
	then
		builtin fc "${stamp[@]}" -l 1
	else
		builtin fc "${stamp[@]}" -l "$@"
	fi
}
omz_termsupport_precmd () {
	[[ "${DISABLE_AUTO_TITLE:-}" != true ]] || return 0
	title "$ZSH_THEME_TERM_TAB_TITLE_IDLE" "$ZSH_THEME_TERM_TITLE_IDLE"
}
omz_termsupport_preexec () {
	[[ "${DISABLE_AUTO_TITLE:-}" != true ]] || return 0
	emulate -L zsh
	setopt extended_glob
	local -a cmdargs
	cmdargs=("${(z)2}") 
	if [[ "${cmdargs[1]}" = fg ]]
	then
		local job_id jobspec="${cmdargs[2]#%}" 
		case "$jobspec" in
			(<->) job_id=${jobspec}  ;;
			("" | % | +) job_id=${(k)jobstates[(r)*:+:*]}  ;;
			(-) job_id=${(k)jobstates[(r)*:-:*]}  ;;
			([?]*) job_id=${(k)jobtexts[(r)*${(Q)jobspec}*]}  ;;
			(*) job_id=${(k)jobtexts[(r)${(Q)jobspec}*]}  ;;
		esac
		if [[ -n "${jobtexts[$job_id]}" ]]
		then
			1="${jobtexts[$job_id]}" 
			2="${jobtexts[$job_id]}" 
		fi
	fi
	local CMD="${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}" 
	local LINE="${2:gs/%/%%}" 
	title "$CMD" "%100>...>${LINE}%<<"
}
omz_urldecode () {
	emulate -L zsh
	local encoded_url=$1 
	local caller_encoding=$langinfo[CODESET] 
	local LC_ALL=C 
	export LC_ALL
	local tmp=${encoded_url:gs/+/ /} 
	tmp=${tmp:gs/\\/\\\\/} 
	tmp=${tmp:gs/%/\\x/} 
	local decoded="$(printf -- "$tmp")" 
	local -a safe_encodings
	safe_encodings=(UTF-8 utf8 US-ASCII) 
	if [[ -z ${safe_encodings[(r)$caller_encoding]} ]]
	then
		decoded=$(echo -E "$decoded" | iconv -f UTF-8 -t $caller_encoding) 
		if [[ $? != 0 ]]
		then
			echo "Error converting string from UTF-8 to $caller_encoding" >&2
			return 1
		fi
	fi
	echo -E "$decoded"
}
omz_urlencode () {
	emulate -L zsh
	setopt norematchpcre
	local -a opts
	zparseopts -D -E -a opts r m P
	local in_str="$@" 
	local url_str="" 
	local spaces_as_plus
	if [[ -z $opts[(r)-P] ]]
	then
		spaces_as_plus=1 
	fi
	local str="$in_str" 
	local encoding=$langinfo[CODESET] 
	local safe_encodings
	safe_encodings=(UTF-8 utf8 US-ASCII) 
	if [[ -z ${safe_encodings[(r)$encoding]} ]]
	then
		str=$(echo -E "$str" | iconv -f $encoding -t UTF-8) 
		if [[ $? != 0 ]]
		then
			echo "Error converting string from $encoding to UTF-8" >&2
			return 1
		fi
	fi
	local i byte ord LC_ALL=C 
	export LC_ALL
	local reserved=';/?:@&=+$,' 
	local mark='_.!~*''()-' 
	local dont_escape="[A-Za-z0-9" 
	if [[ -z $opts[(r)-r] ]]
	then
		dont_escape+=$reserved 
	fi
	if [[ -z $opts[(r)-m] ]]
	then
		dont_escape+=$mark 
	fi
	dont_escape+="]" 
	local url_str="" 
	for ((i = 1; i <= ${#str}; ++i )) do
		byte="$str[i]" 
		if [[ "$byte" =~ "$dont_escape" ]]
		then
			url_str+="$byte" 
		else
			if [[ "$byte" == " " && -n $spaces_as_plus ]]
			then
				url_str+="+" 
			elif [[ "$PREFIX" = *com.termux* ]]
			then
				url_str+="$byte" 
			else
				ord=$(( [##16] #byte )) 
				url_str+="%$ord" 
			fi
		fi
	done
	echo -E "$url_str"
}
open_command () {
	local open_cmd
	case "$OSTYPE" in
		(darwin*) open_cmd='open'  ;;
		(cygwin*) open_cmd='cygstart'  ;;
		(linux*) [[ "$(uname -r)" != *icrosoft* ]] && open_cmd='nohup xdg-open'  || {
				open_cmd='cmd.exe /c start ""' 
				[[ -e "$1" ]] && {
					1="$(wslpath -w "${1:a}")"  || return 1
				}
				[[ "$1" = (http|https)://* ]] && {
					1="$(echo "$1" | sed -E 's/([&|()<>^])/^\1/g')"  || return 1
				}
			} ;;
		(msys*) open_cmd='start ""'  ;;
		(*) echo "Platform $OSTYPE not supported"
			return 1 ;;
	esac
	if [[ -n "$BROWSER" && "$1" = (http|https)://* ]]
	then
		"$BROWSER" "$@"
		return
	fi
	${=open_cmd} "$@" &> /dev/null
}
parse_git_dirty () {
	local STATUS
	local -a FLAGS
	FLAGS=('--porcelain') 
	if [[ "$(__git_prompt_git config --get oh-my-zsh.hide-dirty)" != "1" ]]
	then
		if [[ "${DISABLE_UNTRACKED_FILES_DIRTY:-}" == "true" ]]
		then
			FLAGS+='--untracked-files=no' 
		fi
		case "${GIT_STATUS_IGNORE_SUBMODULES:-}" in
			(git)  ;;
			(*) FLAGS+="--ignore-submodules=${GIT_STATUS_IGNORE_SUBMODULES:-dirty}"  ;;
		esac
		STATUS=$(__git_prompt_git status ${FLAGS} 2> /dev/null | tail -n 1) 
	fi
	if [[ -n $STATUS ]]
	then
		echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
	else
		echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
	fi
}
proxyoff () {
	unset http_proxy
	unset https_proxy
	unset HTTP_PROXY
	unset HTTPS_PROXY
	unset socks5_proxy
	unset socks_proxy
	unset SOCKS_PROXY
	unset SOCKS5_PROXY
	git config --global --unset http.proxy
	git config --global --unset https.proxy
	unalias curl
}
proxyon () {
	export PROXYIP=192.168.222.241 
	export http_proxy=http://$PROXYIP:10874 
	export https_proxy=$http_proxy 
	export HTTP_PROXY=$http_proxy 
	export HTTPS_PROXY=$http_proxy 
	alias curl="curl -x $http_proxy"
	git config --global http.proxy $http_proxy
	git config --global https.proxy $http_proxy
	export socks5_proxy="socks5://$PROXYIP:10874" 
	export socks_proxy=$socks5_proxy 
	export SOCKS_PROXY=$socks5_proxy 
	export SOCKS5_PROXY=$socks5_proxy 
}
pullApk () {
	pkg=$1 
	apkPath=$(adb shell pm path $pkg | cut -d':' -f 2) 
	echo "apk path: $apkPath"
	apkVerName=$(getAppVerName $pkg) 
	apkVerCode=$(getAppVerCode $pkg) 
	echo "apk ver name: $apkVerName"
	echo "apk ver code: $apkVerCode"
	adb pull ${apkPath} ${pkg}-${apkVerName}-${apkVerCode}.apk
}
pyenv_prompt_info () {
	return 1
}
rbenv_prompt_info () {
	echo -n "${ZSH_THEME_RUBY_PROMPT_PREFIX}"
	echo -n "system: $(ruby -v | cut -f-2 -d ' ' | sed 's/%/%%/g')"
	echo "${ZSH_THEME_RUBY_PROMPT_SUFFIX}"
}
reboot2 () {
	echo -n "Are you sure you want to reboot? [y/N] "
	read -r REPLY
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		/usr/sbin/reboot
	fi
}
regexp-replace () {
	argv=("$1" "$2" "$3") 
	4=0 
	[[ -o re_match_pcre ]] && 4=1 
	emulate -L zsh
	local MATCH MBEGIN MEND
	local -a match mbegin mend
	if (( $4 ))
	then
		zmodload zsh/pcre || return 2
		pcre_compile -- "$2" && pcre_study || return 2
		4=0 6= 
		local ZPCRE_OP
		while pcre_match -b -n $4 -- "${(P)1}"
		do
			5=${(e)3} 
			argv+=(${(s: :)ZPCRE_OP} "$5") 
			4=$((argv[-2] + (argv[-3] == argv[-2]))) 
		done
		(($# > 6)) || return
		set +o multibyte
		5= 6=1 
		for 2 3 4 in "$@[7,-1]"
		do
			5+=${(P)1[$6,$2]}$4 
			6=$(($3 + 1)) 
		done
		5+=${(P)1[$6,-1]} 
	else
		4=${(P)1} 
		while [[ -n $4 ]]
		do
			if [[ $4 =~ $2 ]]
			then
				5+=${4[1,MBEGIN-1]}${(e)3} 
				if ((MEND < MBEGIN))
				then
					((MEND++))
					5+=${4[1]} 
				fi
				4=${4[MEND+1,-1]} 
				6=1 
			else
				break
			fi
		done
		[[ -n $6 ]] || return
		5+=$4 
	fi
	eval $1=\$5
}
retryCommand () {
	local command="$*" 
	while ! eval "$command"
	do
		echo "Command '$command' failed. Retrying..."
		sleep 1
	done
	echo "Command '$command' succeeded!"
}
ruby_prompt_info () {
	echo "$(rvm_prompt_info || rbenv_prompt_info || chruby_prompt_info)"
}
run () {
	until $*
	do
		sleep 1
	done
}
rvm_prompt_info () {
	[ -f $HOME/.rvm/bin/rvm-prompt ] || return 1
	local rvm_prompt
	rvm_prompt=$($HOME/.rvm/bin/rvm-prompt ${=ZSH_THEME_RVM_PROMPT_OPTIONS} 2>/dev/null) 
	[[ -z "${rvm_prompt}" ]] && return 1
	echo "${ZSH_THEME_RUBY_PROMPT_PREFIX}${rvm_prompt:gs/%/%%}${ZSH_THEME_RUBY_PROMPT_SUFFIX}"
}
spectrum_bls () {
	setopt localoptions nopromptsubst
	local ZSH_SPECTRUM_TEXT=${ZSH_SPECTRUM_TEXT:-Arma virumque cano Troiae qui primus ab oris} 
	for code in {000..255}
	do
		print -P -- "$code: ${BG[$code]}${ZSH_SPECTRUM_TEXT}%{$reset_color%}"
	done
}
spectrum_ls () {
	setopt localoptions nopromptsubst
	local ZSH_SPECTRUM_TEXT=${ZSH_SPECTRUM_TEXT:-Arma virumque cano Troiae qui primus ab oris} 
	for code in {000..255}
	do
		print -P -- "$code: ${FG[$code]}${ZSH_SPECTRUM_TEXT}%{$reset_color%}"
	done
}
svn_prompt_info () {
	return 1
}
take () {
	if [[ $1 =~ ^(https?|ftp).*\.(tar\.(gz|bz2|xz)|tgz)$ ]]
	then
		takeurl "$1"
	elif [[ $1 =~ ^(https?|ftp).*\.(zip)$ ]]
	then
		takezip "$1"
	elif [[ $1 =~ ^([A-Za-z0-9]\+@|https?|git|ssh|ftps?|rsync).*\.git/?$ ]]
	then
		takegit "$1"
	else
		takedir "$@"
	fi
}
takedir () {
	mkdir -p $@ && cd ${@:$#}
}
takegit () {
	git clone "$1"
	cd "$(basename ${1%%.git})"
}
takeurl () {
	local data thedir
	data="$(mktemp)" 
	curl -L "$1" > "$data"
	tar xf "$data"
	thedir="$(tar tf "$data" | head -n 1)" 
	rm "$data"
	cd "$thedir"
}
takezip () {
	local data thedir
	data="$(mktemp)" 
	curl -L "$1" > "$data"
	unzip "$data" -d "./"
	thedir="$(unzip -l "$data" | awk 'NR==4 {print $4}' | sed 's/\/.*//')" 
	rm "$data"
	cd "$thedir"
}
tf_prompt_info () {
	return 1
}
title () {
	setopt localoptions nopromptsubst
	[[ -n "${INSIDE_EMACS:-}" && "$INSIDE_EMACS" != vterm ]] && return
	: ${2=$1}
	case "$TERM" in
		(cygwin | xterm* | putty* | rxvt* | konsole* | ansi | mlterm* | alacritty* | st* | foot* | contour* | wezterm*) print -Pn "\e]2;${2:q}\a"
			print -Pn "\e]1;${1:q}\a" ;;
		(screen* | tmux*) print -Pn "\ek${1:q}\e\\" ;;
		(*) if [[ "$TERM_PROGRAM" == "iTerm.app" ]]
			then
				print -Pn "\e]2;${2:q}\a"
				print -Pn "\e]1;${1:q}\a"
			else
				if (( ${+terminfo[fsl]} && ${+terminfo[tsl]} ))
				then
					print -Pn "${terminfo[tsl]}$1${terminfo[fsl]}"
				fi
			fi ;;
	esac
}
try_alias_value () {
	alias_value "$1" || echo "$1"
}
unbundled_annotate () {
	"annotate" "$@"
}
unbundled_cap () {
	"cap" "$@"
}
unbundled_capify () {
	"capify" "$@"
}
unbundled_cucumber () {
	"cucumber" "$@"
}
unbundled_foodcritic () {
	"foodcritic" "$@"
}
unbundled_guard () {
	"guard" "$@"
}
unbundled_hanami () {
	"hanami" "$@"
}
unbundled_irb () {
	"irb" "$@"
}
unbundled_jekyll () {
	"jekyll" "$@"
}
unbundled_kitchen () {
	"kitchen" "$@"
}
unbundled_knife () {
	"knife" "$@"
}
unbundled_middleman () {
	"middleman" "$@"
}
unbundled_nanoc () {
	"nanoc" "$@"
}
unbundled_pry () {
	"pry" "$@"
}
unbundled_puma () {
	"puma" "$@"
}
unbundled_rackup () {
	"rackup" "$@"
}
unbundled_rainbows () {
	"rainbows" "$@"
}
unbundled_rake () {
	"rake" "$@"
}
unbundled_rspec () {
	"rspec" "$@"
}
unbundled_rubocop () {
	"rubocop" "$@"
}
unbundled_shotgun () {
	"shotgun" "$@"
}
unbundled_sidekiq () {
	"sidekiq" "$@"
}
unbundled_spec () {
	"spec" "$@"
}
unbundled_spork () {
	"spork" "$@"
}
unbundled_spring () {
	"spring" "$@"
}
unbundled_strainer () {
	"strainer" "$@"
}
unbundled_tailor () {
	"tailor" "$@"
}
unbundled_taps () {
	"taps" "$@"
}
unbundled_thin () {
	"thin" "$@"
}
unbundled_thor () {
	"thor" "$@"
}
unbundled_unicorn () {
	"unicorn" "$@"
}
unbundled_unicorn_rails () {
	"unicorn_rails" "$@"
}
uninstall_oh_my_zsh () {
	command env ZSH="$ZSH" sh "$ZSH/tools/uninstall.sh"
}
up-line-or-beginning-search () {
	# undefined
	builtin autoload -XU
}
updateJdkPath () {
	PATH=`echo $PATH | sed -e "s+$JAVA_HOME_8+$JAVA_HOME+g"` 
	PATH=`echo $PATH | sed -e "s+$JAVA_HOME_11+$JAVA_HOME+g"` 
	PATH=`echo $PATH | sed -e "s+$JAVA_HOME_17+$JAVA_HOME+g"` 
	PATH=`echo $PATH | sed -e "s+$JAVA_HOME_21+$JAVA_HOME+g"` 
	if [[ $PATH != *$JAVA_HOME* ]]
	then
		PATH=$JAVA_HOME/bin:$PATH 
	fi
	export PATH=$PATH 
}
upgrade_oh_my_zsh () {
	echo "${fg[yellow]}Note: \`$0\` is deprecated. Use \`omz update\` instead.$reset_color" >&2
	omz update
}
url-quote-magic () {
	# undefined
	builtin autoload -XUz
}
vi_mode_prompt_info () {
	return 1
}
virtualenv_prompt_info () {
	return 1
}
work_in_progress () {
	command git -c log.showSignature=false log -n 1 2> /dev/null | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,.venv,venv} -q -- "--wip--" && echo "WIP!!"
}
zrecompile () {
	setopt localoptions extendedglob noshwordsplit noksharrays
	local opt check quiet zwc files re file pre ret map tmp mesg pats
	tmp=() 
	while getopts ":tqp" opt
	do
		case $opt in
			(t) check=yes  ;;
			(q) quiet=yes  ;;
			(p) pats=yes  ;;
			(*) if [[ -n $pats ]]
				then
					tmp=($tmp $OPTARG) 
				else
					print -u2 zrecompile: bad option: -$OPTARG
					return 1
				fi ;;
		esac
	done
	shift OPTIND-${#tmp}-1
	if [[ -n $check ]]
	then
		ret=1 
	else
		ret=0 
	fi
	if [[ -n $pats ]]
	then
		local end num
		while (( $# ))
		do
			end=$argv[(i)--] 
			if [[ end -le $# ]]
			then
				files=($argv[1,end-1]) 
				shift end
			else
				files=($argv) 
				argv=() 
			fi
			tmp=() 
			map=() 
			OPTIND=1 
			while getopts :MR opt $files
			do
				case $opt in
					([MR]) map=(-$opt)  ;;
					(*) tmp=($tmp $files[OPTIND])  ;;
				esac
			done
			shift OPTIND-1 files
			(( $#files )) || continue
			files=($files[1] ${files[2,-1]:#*(.zwc|~)}) 
			(( $#files )) || continue
			zwc=${files[1]%.zwc}.zwc 
			shift 1 files
			(( $#files )) || files=(${zwc%.zwc}) 
			if [[ -f $zwc ]]
			then
				num=$(zcompile -t $zwc | wc -l) 
				if [[ num-1 -ne $#files ]]
				then
					re=yes 
				else
					re= 
					for file in $files
					do
						if [[ $file -nt $zwc ]]
						then
							re=yes 
							break
						fi
					done
				fi
			else
				re=yes 
			fi
			if [[ -n $re ]]
			then
				if [[ -n $check ]]
				then
					[[ -z $quiet ]] && print $zwc needs re-compilation
					ret=0 
				else
					[[ -z $quiet ]] && print -n "re-compiling ${zwc}: "
					if [[ -z "$quiet" ]] && {
							[[ ! -f $zwc ]] || mv -f $zwc ${zwc}.old
						} && zcompile $map $tmp $zwc $files
					then
						print succeeded
					elif ! {
							{
								[[ ! -f $zwc ]] || mv -f $zwc ${zwc}.old
							} && zcompile $map $tmp $zwc $files 2> /dev/null
						}
					then
						[[ -z $quiet ]] && print "re-compiling ${zwc}: failed"
						ret=1 
					fi
				fi
			fi
		done
		return ret
	fi
	if (( $# ))
	then
		argv=(${^argv}/*.zwc(ND) ${^argv}.zwc(ND) ${(M)argv:#*.zwc}) 
	else
		argv=(${^fpath}/*.zwc(ND) ${^fpath}.zwc(ND) ${(M)fpath:#*.zwc}) 
	fi
	argv=(${^argv%.zwc}.zwc) 
	for zwc
	do
		files=(${(f)"$(zcompile -t $zwc)"}) 
		if [[ $files[1] = *\(mapped\)* ]]
		then
			map=-M 
			mesg='succeeded (old saved)' 
		else
			map=-R 
			mesg=succeeded 
		fi
		if [[ $zwc = */* ]]
		then
			pre=${zwc%/*}/ 
		else
			pre= 
		fi
		if [[ $files[1] != *$ZSH_VERSION ]]
		then
			re=yes 
		else
			re= 
		fi
		files=(${pre}${^files[2,-1]:#/*} ${(M)files[2,-1]:#/*}) 
		[[ -z $re ]] && for file in $files
		do
			if [[ $file -nt $zwc ]]
			then
				re=yes 
				break
			fi
		done
		if [[ -n $re ]]
		then
			if [[ -n $check ]]
			then
				[[ -z $quiet ]] && print $zwc needs re-compilation
				ret=0 
			else
				[[ -z $quiet ]] && print -n "re-compiling ${zwc}: "
				tmp=(${^files}(N)) 
				if [[ $#tmp -ne $#files ]]
				then
					[[ -z $quiet ]] && print 'failed (missing files)'
					ret=1 
				else
					if [[ -z "$quiet" ]] && mv -f $zwc ${zwc}.old && zcompile $map $zwc $files
					then
						print $mesg
					elif ! {
							mv -f $zwc ${zwc}.old && zcompile $map $zwc $files 2> /dev/null
						}
					then
						[[ -z $quiet ]] && print "re-compiling ${zwc}: failed"
						ret=1 
					fi
				fi
			fi
		fi
	done
	return ret
}
zsh_stats () {
	fc -l 1 | awk '{ CMD[$2]++; count++; } END { for (a in CMD) print CMD[a] " " CMD[a]*100/count "% " a }' | grep -v "./" | sort -nr | head -n 20 | column -c3 -s " " -t | nl
}

# setopts 18
setopt alwaystoend
setopt autocd
setopt autopushd
setopt completeinword
setopt extendedhistory
setopt noflowcontrol
setopt nohashdirs
setopt histexpiredupsfirst
setopt histignoredups
setopt histignorespace
setopt histverify
setopt interactivecomments
setopt login
setopt longlistjobs
setopt promptsubst
setopt pushdignoredups
setopt pushdminus
setopt sharehistory

# aliases 331
alias -- -='cd -'
alias -g ...=../..
alias -g ....=../../..
alias -g .....=../../../..
alias -g ......=../../../../..
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'
alias _='sudo '
alias annotate=bundled_annotate
alias axel='axel -c -n 20'
alias ba='bundle add'
alias bck='bundle check'
alias bcn='bundle clean'
alias be='bundle exec'
alias bi=bundle_install
alias bin/rake='noglob bin/rake'
alias bl='bundle list'
alias bo='bundle open'
alias bout='bundle outdated'
alias bp='bundle package'
alias brake='noglob bundle exec rake'
alias bu='bundle update'
alias cap=bundled_cap
alias capify=bundled_capify
alias cucumber=bundled_cucumber
alias current_branch=$'\n    print -Pu2 "%F{yellow}[oh-my-zsh] \'%F{red}current_branch%F{yellow}\' is deprecated, using \'%F{green}git_current_branch%F{yellow}\' instead.%f"\n    git_current_branch'
alias egrep='grep -E'
alias fgrep='grep -F'
alias foodcritic=bundled_foodcritic
alias fsh-alias=fast-theme
alias g=git
alias ga='git add'
alias gaa='git add --all'
alias gam='git am'
alias gama='git am --abort'
alias gamc='git am --continue'
alias gams='git am --skip'
alias gamscp='git am --show-current-patch'
alias gap='git apply'
alias gapa='git add --patch'
alias gapt='git apply --3way'
alias gau='git add --update'
alias gav='git add --verbose'
alias gb='git branch'
alias gbD='git branch --delete --force'
alias gba='git branch --all'
alias gbd='git branch --delete'
alias gbg='LANG=C git branch -vv | grep ": gone\]"'
alias gbgD='LANG=C git branch --no-color -vv | grep ": gone\]" | cut -c 3- | awk '\''{print $1}'\'' | xargs git branch -D'
alias gbgd='LANG=C git branch --no-color -vv | grep ": gone\]" | cut -c 3- | awk '\''{print $1}'\'' | xargs git branch -d'
alias gbl='git blame -w'
alias gbm='git branch --move'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'
alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsn='git bisect new'
alias gbso='git bisect old'
alias gbsr='git bisect reset'
alias gbss='git bisect start'
alias gc='git commit --verbose'
alias gc!='git commit --verbose --amend'
alias gcB='git checkout -B'
alias gca='git commit --verbose --all'
alias gca!='git commit --verbose --all --amend'
alias gcam='git commit --all --message'
alias gcan!='git commit --verbose --all --no-edit --amend'
alias gcann!='git commit --verbose --all --date=now --no-edit --amend'
alias gcans!='git commit --verbose --all --signoff --no-edit --amend'
alias gcas='git commit --all --signoff'
alias gcasm='git commit --all --signoff --message'
alias gcb='git checkout -b'
alias gcd='git checkout $(git_develop_branch)'
alias gcf='git config --list'
alias gcfu='git commit --fixup'
alias gcl='git clone --recurse-submodules'
alias gclean='git clean --interactive -d'
alias gclf='git clone --recursive --shallow-submodules --filter=blob:none --also-filter-submodules'
alias gcm='git checkout $(git_main_branch)'
alias gcmsg='git commit --message'
alias gcn='git commit --verbose --no-edit'
alias gcn!='git commit --verbose --no-edit --amend'
alias gco='git checkout'
alias gcor='git checkout --recurse-submodules'
alias gcount='git shortlog --summary --numbered'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gcs='git commit --gpg-sign'
alias gcsm='git commit --signoff --message'
alias gcss='git commit --gpg-sign --signoff'
alias gcssm='git commit --gpg-sign --signoff --message'
alias gd='git diff'
alias gdca='git diff --cached'
alias gdct='git describe --tags $(git rev-list --tags --max-count=1)'
alias gdcw='git diff --cached --word-diff'
alias gds='git diff --staged'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdup='git diff @{upstream}'
alias gdw='git diff --word-diff'
alias geca='gem cert --add'
alias gecb='gem cert --build'
alias geclup='gem cleanup -n'
alias gecr='gem cert --remove'
alias gegi='gem generate_index'
alias geh='gem help'
alias gei='gem info'
alias geiall='gem info --all'
alias gein='gem install'
alias gel='gem lock'
alias geli='gem list'
alias geo='gem open'
alias geoe='gem open -e'
alias getCurrentActivity='adb shell dumpsys activity activities | grep mTopFullscreenOpaqueWindowState | cut -d'\''{'\'' -f 2 | cut -d'\'' '\'' -f 3 | cut -d'\''}'\'' -f 1'
alias geun='gem uninstall'
alias gf='git fetch'
alias gfa='git fetch --all --tags --prune --jobs=10'
alias gfg='git ls-files | grep'
alias gfo='git fetch origin'
alias gg='git gui citool'
alias gga='git gui citool --amend'
alias ggpull='git pull origin "$(git_current_branch)"'
alias ggpur=ggu
alias ggpush='git push origin "$(git_current_branch)"'
alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'
alias ghh='git help'
alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias git-svn-dcommit-push='git svn dcommit && git push github $(git_main_branch):svntrunk'
alias gitproxy=gitx
alias gitx='git -c '\''http.proxy=http://192.168.222.241:10874'\'
alias gk='\gitk --all --branches &!'
alias gke='\gitk --all $(git log --walk-reflogs --pretty=%h) &!'
alias gl='git pull'
alias glg='git log --stat'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glgp='git log --stat --patch'
alias glo='git log --oneline --decorate'
alias glod='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"'
alias glods='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias glol='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'
alias glola='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all'
alias glols='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat'
alias glp=_git_log_prettily
alias gluc='git pull upstream $(git_current_branch)'
alias glum='git pull upstream $(git_main_branch)'
alias gm='git merge'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gmff='git merge --ff-only'
alias gmom='git merge origin/$(git_main_branch)'
alias gms='git merge --squash'
alias gmtl='git mergetool --no-prompt'
alias gmtlvim='git mergetool --no-prompt --tool=vimdiff'
alias gmum='git merge upstream/$(git_main_branch)'
alias gp='git push'
alias gpd='git push --dry-run'
alias gpf='git push --force-with-lease --force-if-includes'
alias gpf!='git push --force'
alias gpoat='git push origin --all && git push origin --tags'
alias gpod='git push origin --delete'
alias gpr='git pull --rebase'
alias gpra='git pull --rebase --autostash'
alias gprav='git pull --rebase --autostash -v'
alias gpristine='git reset --hard && git clean --force -dfx'
alias gprom='git pull --rebase origin $(git_main_branch)'
alias gpromi='git pull --rebase=interactive origin $(git_main_branch)'
alias gprum='git pull --rebase upstream $(git_main_branch)'
alias gprumi='git pull --rebase=interactive upstream $(git_main_branch)'
alias gprv='git pull --rebase -v'
alias gpsup='git push --set-upstream origin $(git_current_branch)'
alias gpsupf='git push --set-upstream origin $(git_current_branch) --force-with-lease --force-if-includes'
alias gpu='git push upstream'
alias gpv='git push --verbose'
alias gr='git remote'
alias gra='git remote add'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbd='git rebase $(git_develop_branch)'
alias grbi='git rebase --interactive'
alias grbm='git rebase $(git_main_branch)'
alias grbo='git rebase --onto'
alias grbom='git rebase origin/$(git_main_branch)'
alias grbs='git rebase --skip'
alias grbum='git rebase upstream/$(git_main_branch)'
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,.venv,venv}'
alias grev='git revert'
alias greva='git revert --abort'
alias grevc='git revert --continue'
alias grf='git reflog'
alias grh='git reset'
alias grhh='git reset --hard'
alias grhk='git reset --keep'
alias grhs='git reset --soft'
alias grm='git rm'
alias grmc='git rm --cached'
alias grmv='git remote rename'
alias groh='git reset origin/$(git_current_branch) --hard'
alias grrm='git remote remove'
alias grs='git restore'
alias grset='git remote set-url'
alias grss='git restore --source'
alias grst='git restore --staged'
alias grt='cd "$(git rev-parse --show-toplevel || echo .)"'
alias gru='git reset --'
alias grup='git remote update'
alias grv='git remote --verbose'
alias gsb='git status --short --branch'
alias gsd='git svn dcommit'
alias gsh='git show'
alias gsi='git submodule init'
alias gsps='git show --pretty=short --show-signature'
alias gsr='git svn rebase'
alias gss='git status --short'
alias gst='git status'
alias gsta='git stash push'
alias gstaa='git stash apply'
alias gstall='git stash --all'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --patch'
alias gstu='gsta --include-untracked'
alias gsu='git submodule update'
alias gsw='git switch'
alias gswc='git switch --create'
alias gswd='git switch $(git_develop_branch)'
alias gswm='git switch $(git_main_branch)'
alias gta='git tag --annotate'
alias gtl='gtl(){ git tag --sort=-v:refname -n --list "${1}*" }; noglob gtl'
alias gts='git tag --sign'
alias gtv='git tag | sort -V'
alias guard=bundled_guard
alias gunignore='git update-index --no-assume-unchanged'
alias gunwip='git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1'
alias gwch='git log --patch --abbrev-commit --pretty=medium --raw'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'
alias gwipe='git reset --hard && git clean --force -df'
alias gwt='git worktree'
alias gwta='git worktree add'
alias gwtls='git worktree list'
alias gwtmv='git worktree move'
alias gwtrm='git worktree remove'
alias hanami=bundled_hanami
alias history=omz_history
alias irb=bundled_irb
alias jekyll=bundled_jekyll
alias jimweirich=rake
alias kitchen=bundled_kitchen
alias knife=bundled_knife
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls --color=tty'
alias lsa='ls -lah'
alias md='mkdir -p'
alias middleman=bundled_middleman
alias nanoc=bundled_nanoc
alias pad='poetry add'
alias pbld='poetry build'
alias pch='poetry check'
alias pcmd='poetry list'
alias pconf='poetry config --list'
alias pexp='poetry export --without-hashes > requirements.txt'
alias pin='poetry init'
alias pinst='poetry install'
alias plck='poetry lock'
alias pnew='poetry new'
alias ppath='poetry env info --path'
alias pplug='poetry self show plugins'
alias ppub='poetry publish'
alias prm='poetry remove'
alias prun='poetry run'
alias pry=bundled_pry
alias psad='poetry self add'
alias psh='poetry shell'
alias pshw='poetry show'
alias pslt='poetry show --latest'
alias psup='poetry self update'
alias psync='poetry install --sync'
alias ptree='poetry show --tree'
alias puma=bundled_puma
alias pup='poetry update'
alias pvinf='poetry env info'
alias pvoff='poetry config virtualenvs.create false'
alias pvrm='poetry env remove'
alias pvu='poetry env use'
alias rackup=bundled_rackup
alias rainbows=bundled_rainbows
alias rake=bundled_rake
alias rb=ruby
alias rd=rmdir
alias reboot=reboot2
alias rfind='find . -name "*.rb" | xargs grep -n'
alias rrun='ruby -e'
alias rserver='ruby -run -e httpd . -p 8080'
alias rspec=bundled_rspec
alias rubies='ruby -v'
alias rubocop=bundled_rubocop
alias run-help=man
alias sbrake='noglob sudo bundle exec rake'
alias sgem='sudo gem'
alias shotgun=bundled_shotgun
alias sidekiq=bundled_sidekiq
alias spec=bundled_spec
alias spork=bundled_spork
alias spring=bundled_spring
alias srake='noglob sudo rake'
alias strainer=bundled_strainer
alias tailor=bundled_tailor
alias taps=bundled_taps
alias thin=bundled_thin
alias thor=bundled_thor
alias unicorn=bundled_unicorn
alias unicorn_rails=bundled_unicorn_rails
alias vi=vim
alias which-command=whence

# exports 113
export ANDROID_HOME=/Develop/Android/Sdk
export ANDROID_SDK_HOME=/Develop/Android/Sdk
export ANDROID_SDK_ROOT=/Develop/Android/Sdk
export API_TIMEOUT_MS=3000000
export AndroidBuildToolsVer=36.1.0
export BUN_INSTALL=/home/shakarover/.bun
export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable
export CHROMIUM_BUILDTOOLS_PATH=/Sources/chromium/depot_tools
export CLAUDE_CODE_ATTRIBUTION_HEADER=0
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
export CODEX_CI=1
export CODEX_HOME=/home/shakarover/.codex/superpowers-auto-20260316/tests/codex/.codex-home
export CODEX_MANAGED_BY_NPM=1
export CODEX_THREAD_ID=019cf205-93e5-7293-ace4-849951eafb7d
export COLORTERM=''
export DBUS_SESSION_BUS_ADDRESS='unix:path=/run/user/1000/bus'
export DEBUGINFOD_URLS='https://debuginfod.ubuntu.com '
export DEFAULTS_PATH=/usr/share/gconf/ubuntu.default.path
export DESKTOP_SESSION=ubuntu
export DISABLE_ERROR_REPORTING=1
export DISABLE_TELEMETRY=1
export DISPLAY=:1
export ENABLE_LSP_TOOLS=1
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
export GDMSESSION=ubuntu
export GH_PAGER=cat
export GIT_PAGER=cat
export GIT_SSL_NO_VERIFY=true
export GNOME_DESKTOP_SESSION_ID=this-is-deprecated
export GNOME_KEYRING_CONTROL=/run/user/1000/keyring
export GNOME_SHELL_SESSION_MODE=ubuntu
export GNOME_TERMINAL_SCREEN=/org/gnome/Terminal/screen/796c6948_ddd9_4c55_a438_b540c7f36074
export GNOME_TERMINAL_SERVICE=:1.538
export GOENV_ROOT=/Develop/.goenv
export GOENV_SHELL=zsh
export GOPATH=/home/shakarover/go/1.25.4
export GOPROXY=https://goproxy.io
export GOROOT=/Develop/.goenv/versions/1.25.4
export GPG_AGENT_INFO=/run/user/1000/gnupg/S.gpg-agent:0:1
export GRADLE_HOME=/home/shakarover/.gradle/wrapper/dists/gradle-9.2.1-bin/2t0n5ozlw9xmuyvbp7dnzaxug/gradle-9.2.1/
export GRADLE_VER=gradle-9.2.1-bin
export GSM_SKIP_SSH_AGENT_WORKAROUND=true
export GTK_MODULES=gail:atk-bridge
export GitLabSources=/Sources/gitlab.com
export GithubSources=/Sources/github.com
export HF_ENDPOINT=https://hf-mirror.com
export HOME=/home/shakarover
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export JAVA_HOME_11=/usr/lib/jvm/java-11-openjdk-amd64
export JAVA_HOME_17=/usr/lib/jvm/java-17-openjdk-amd64
export JAVA_HOME_21=/usr/lib/jvm/java-21-openjdk-amd64
export JAVA_HOME_8=/usr/lib/jvm/java-8-openjdk-amd64
export JEB_HOME=/Develop/tools/JEB
export JULIA_PKG_SERVER=https://mirrors.ustc.edu.cn/julia
export JVMROOT=/usr/lib/jvm
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LESS=-R
export LLMS_OPEN_API_KEY=sk-fYWq6uYYFiZe7pWlavOjydoeNeidtkVPaL0UbXc2UghmcgCD
export LLMS_OPEN_BASE_URL=https://a.llms.plus
export LOGNAME=shakarover
export LSCOLORS=Gxfxcxdxbxegedabagacad
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:'
export MANDATORY_PATH=/usr/share/gconf/ubuntu.mandatory.path
export MEMORY_PRESSURE_WATCH=/sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/session.slice/org.gnome.SettingsDaemon.MediaKeys.service/memory.pressure
export MEMORY_PRESSURE_WRITE='c29tZSAyMDAwMDAgMjAwMDAwMAA='
export ModelscopeDir=/Sources/modelscope.cn
export NO_AUTH_BOTO_CONFIG=/home/shakarover/.boto
export NO_COLOR=1
export NVM_BIN=/home/shakarover/.nvm/versions/node/v22.22.0/bin
export NVM_CD_FLAGS=-q
export NVM_DIR=/home/shakarover/.nvm
export NVM_INC=/home/shakarover/.nvm/versions/node/v22.22.0/include/node
export OPENCLAW_ANTHROPIC_AUTH_TOKEN=sk-PTl5RZ9Y4bdm3ueltuL2jSa3aynFBQi5440hMvkJbMR7iUcV
export OPENCLAW_ANTHROPIC_BASE_URL=https://a.llms.plus/
export OPENCLAW_GEMINI_AUTH_TOKEN=sk-ikAXpcWOpPHtdBuNnTNne1yim47S2e2g7tQlra2tOCJxTfJD
export OPENCLAW_GEMINI_BASE_URL=https://a.llms.plus/
export OPENCLAW_OPENAI_AUTH_TOKEN=sk-tMRUQyET0OB1zlXA0XqaB70ugEnGIiV5rAGWUgmkv7WhypDI
export OPENCLAW_OPENAI_BASE_URL=https://a.llms.plus/
export PAGER=cat
export PNPM_HOME=/home/shakarover/.local/share/pnpm
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export QT_ACCESSIBILITY=1
export QT_IM_MODULE=ibus
export RUSTUP_DIST_SERVER=https://rsproxy.cn
export RUSTUP_UPDATE_ROOT=https://rsproxy.cn/rustup
export SESSION_MANAGER=local/ShakaUbuntu:@/tmp/.ICE-unix/18600,unix/ShakaUbuntu:/tmp/.ICE-unix/18600
export SHELL=/usr/bin/zsh
export SHIMPHUB_API_KEY=shumphub-8eoTJgbinMbS5nGKJQJXacd+EtaW4YFSouRvmXxg
export SHRIMPHUB_ADMIN_KEY=shumphub-admin-SGTqx3RhitRog6GDw44smBe8ylb7iWdrwIlQdpLFh8
export SSH_AUTH_SOCK=/run/user/1000/keyring/ssh
export SYSTEMD_EXEC_PID=18890
export TAVILY_API_KEY=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
export TERM=dumb
export USER=shakarover
export UV_DEFAULT_INDEX=https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple
export VTE_VERSION=7600
export WINDOWPATH=2
export XAUTHORITY=/run/user/1000/gdm/Xauthority
export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg
export XDG_CURRENT_DESKTOP=ubuntu:GNOME
export XDG_DATA_DIRS=/usr/share/ubuntu:/usr/share/gnome:/usr/local/share/:/usr/share/:/var/lib/snapd/desktop
export XDG_MENU_PREFIX=gnome-
export XDG_RUNTIME_DIR=/run/user/1000
export XDG_SESSION_CLASS=user
export XDG_SESSION_DESKTOP=ubuntu
export XDG_SESSION_TYPE=x11
export XMODIFIERS='@im=ibus'
export ZSH=/home/shakarover/.oh-my-zsh
export no_proxy=localhost,192.168.222.241/8,127.0.0.0/8,::1
