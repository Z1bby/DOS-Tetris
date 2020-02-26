.386
instructions		SEGMENT		use16
					ASSUME		cs:instructions
variables proc
		ret
vector8			dd		?
vector9			dd		?
game_over		db		0
random_number	dd		?
colors			dw		4f1eh, 6636h, 0248h, 0808h		; left8bit=border_color, right8bit=inside_color.
tile_size		dw		8
;#region shapes
;		SHAPE O:
;				[ ][ ][ ][ ]
;				[ ][1][2][ ]
;				[ ][3][4][ ]
;				[ ][ ][ ][ ]
shape_O_X		dd		01020102h
shape_O_Y		dd		01010202h		
;		SHAPE I:
;				[ ][ ][ ][ ]	[ ][ ][1][ ]
;				[1][2][3][4]	[ ][ ][2][ ]
;				[ ][ ][ ][ ]	[ ][ ][3][ ]
;				[ ][ ][ ][ ]	[ ][ ][4][ ]
shape_I_X		dd		00010203h, 02020202h
shape_I_Y		dd		01010101h, 00010203h
;		SHAPE T:
;				[ ][ ][ ][ ]	[ ][ ][1][ ]	[ ][ ][1][ ]	[ ][ ][1][ ]
;				[ ][1][2][3]	[ ][2][3][ ]	[ ][2][3][4]	[ ][ ][2][3]
;				[ ][ ][4][ ]	[ ][ ][4][ ]	[ ][ ][ ][ ]	[ ][ ][4][ ]
;				[ ][ ][ ][ ]	[ ][ ][ ][ ]	[ ][ ][ ][ ]	[ ][ ][ ][ ]
shape_T_X		dd		01020302h, 02010202h, 02010203h, 02020302h
shape_T_Y		dd		01010102h, 00010102h, 00010101h, 00010102h
;		SHAPE L:
;				[ ][ ][ ][ ]	[ ][1][2][ ]	[ ][ ][ ][1]	[ ][ ][1][ ]
;				[ ][1][2][3]	[ ][ ][3][ ]	[ ][2][3][4]	[ ][ ][2][ ]
;				[ ][4][ ][ ]	[ ][ ][4][ ]	[ ][ ][ ][ ]	[ ][ ][3][4]
;				[ ][ ][ ][ ]	[ ][ ][ ][ ]	[ ][ ][ ][ ]	[ ][ ][ ][ ]
shape_L_X		dd		01020301h, 01020202h, 03010203h, 02020203h
shape_L_Y		dd		01010102h, 00000102h, 00010101h, 00010202h
;		SHAPE J:
;				[ ][ ][ ][ ]	[ ][ ][1][ ]	[ ][1][ ][ ]	[ ][ ][1][2]
;				[ ][1][2][3]	[ ][ ][2][ ]	[ ][2][3][4]	[ ][ ][3][ ]
;				[ ][ ][ ][4]	[ ][3][4][ ]	[ ][ ][ ][ ]	[ ][ ][4][ ]
;				[ ][ ][ ][ ]	[ ][ ][ ][ ]	[ ][ ][ ][ ]	[ ][ ][ ][ ]
shape_J_X		dd		01020303h, 02020102h, 01010203h, 02030202h
shape_J_Y		dd		01010102h, 00010202h, 00010101h, 00000102h
;		SHAPE S:
;				[ ][ ][ ][ ]	[ ][ ][1][ ]
;				[ ][ ][1][2]	[ ][ ][2][3]
;				[ ][3][4][ ]	[ ][ ][ ][4]
;				[ ][ ][ ][ ]	[ ][ ][ ][ ]
shape_S_X		dd		02030102h, 02020303h
shape_S_Y		dd		01010202h, 00010102h
;		SHAPE Z:
;				[ ][ ][ ][ ]	[ ][ ][ ][1]
;				[ ][1][2][ ]	[ ][ ][2][3]
;				[ ][ ][3][4]	[ ][ ][4][ ]
;				[ ][ ][ ][ ]	[ ][ ][ ][ ]
shape_Z_X		dd		01020203h, 03020302h
shape_Z_Y		dd		01010202h, 00010102h
;#endregion
;#region player 1
p1_top_left_next	dw		?
p1_top_left		dw		?
p1_key_R		dw		?
p1_key_L		dw		?
p1_key_D		dw		?
p1_key_RR		dw		?
p1_key_LR		dw		?
p1_pressing_R	db		0
p1_pressing_L	db		0
p1_pressing_D	db		0
p1_pressing_RR	db		0
p1_pressing_RL	db		0
p1_moving_R		db		0
p1_moving_L		db		0
p1_color		dw		?
p1_delay		db		0
p1_shape		db		?
p1_rotation		db		?
p1_board		dw		210 dup (0)
p1_shape_X		db		?
p1_shape_Y		db		?
p1_tiles_X		db		4 dup (?)
p1_tiles_Y		db		4 dup (?)
p1_pixel_positions		dw		4 dup (?)
p1_speed		db		?
p1_speed_step	db		?
p1_move_step	db		0
p1_rand_number	dd		?
p1_next_shape	db		?
p1_can_move_D	db		1
;#endregion
;#region player 2
p2_top_left_next	dw		?
p2_top_left		dw		?
p2_key_R		dw		?
p2_key_L		dw		?
p2_key_D		dw		?
p2_key_RR		dw		?
p2_key_LR		dw		?
p2_pressing_R	db		0
p2_pressing_L	db		0
p2_pressing_D	db		0
p2_pressing_RR	db		0
p2_pressing_RL	db		0
p2_moving_R		db		0
p2_moving_L		db		0
p2_color		dw		?
p2_delay		db		0
p2_shape		db		?
p2_rotation		db		?
p2_board		dw		210 dup (0)
p2_shape_X		db		?
p2_shape_Y		db		?
p2_tiles_X		db		4 dup (?)
p2_tiles_Y		db		4 dup (?)
p2_pixel_positions		dw		4 dup (?)
p2_speed		db		?
p2_speed_step	db		?
p2_move_step	db		0
p2_rand_number	dd		?
p2_next_shape	db		?
p2_can_move_D	db		1
;#endregion
variables endp

; p1 and p2 will get the same 32 bit random number
; to calculate new random pieces, but the same for each player
start_random_numbers proc
		push		eax
		push		cx
		push		dx

		mov			ah, 2ch
		int			21h		; ch=hours, cl=minutes, dh=seconds, dl=hundredths
		
		mov			eax, 0
		mov			ax, dx
		mov			ch, 0
		mul			cx
		rcl			eax, 16
		add			ax, cx

		add			dx, 0abbah
		add			cx, 0deadh
		xor			dx, 0acdch
		xor			cx, 0d1eh

		rcl			eax, 13
		xor			ax, dx
		rcl			eax, 7
		xor			ax, cx

		mov			cs:p1_rand_number, eax
		mov			cs:p2_rand_number, eax

		pop			dx
		pop			cx
		pop			eax
		ret
start_random_numbers endp
; most functions an argument ss:[bp+4]
; if [bp+4] == 1 then function works for player 1
; else it works for player 2
update_random_number proc
		push		bp
		mov			bp, sp
		push		eax
		push		bx

		cmp			byte ptr ss:[bp+4], 1
		jne			update_p2_number
		mov			bx, offset cs:p1_rand_number
		jmp			start_updating_random_number
update_p2_number:
		mov			bx, offset cs:p2_rand_number
start_updating_random_number:
		mov			eax, cs:[bx]
		xor			ax, cs:[bx+1]
		rol			eax, 14			; just doing something here
		add			eax, cs:[bx]
		mov			cs:[bx], eax

		pop			bx
		pop			eax
		pop			bp
		ret
update_random_number endp

keyboard_function proc
		push		ax

		in			al, 60h			; al = scan code of pressed/released key	
		cmp			al, 77
		je			p2_right_pressed
		cmp			al, 205
		je			p2_right_released
		cmp			al, 75
		je			p2_left_pressed
		cmp			al, 203
		je			p2_left_released
		cmp			al, 80
		je			p2_down_pressed
		cmp			al, 208
		je			p2_down_released
		cmp			al, 72
		je			p2_RR_pressed
		cmp			al, 53
		je			p2_RR_pressed
		cmp			al, 52
		je			p2_RL_pressed
		cmp			al, 32
		je			p1_right_pressed
		cmp			al, 160
		je			p1_right_released
		cmp			al, 30
		je			p1_left_pressed
		cmp			al, 158
		je			p1_left_released
		cmp			al, 31
		je			p1_down_pressed
		cmp			al, 159
		je			p1_down_released
		cmp			al, 17
		je			p1_RR_pressed
		cmp			al, 21
		je			p1_RR_pressed
		cmp			al, 20
		je			p1_RL_pressed
		cmp			al, 57
		je			space_pressed
		cmp			al, 1
		je			escape_pressed
		cmp			al, 11
		jb			number_pressed

		jmp			keyboard_function_end
number_pressed:
		dec			al
		mov			cs:p1_speed, al
		mov			cs:p2_speed, al
		jmp			keyboard_function_end
p2_right_pressed:
		mov			byte ptr cs:p2_pressing_R, 1
		jmp			keyboard_function_end
p2_right_released:
		mov			byte ptr cs:p2_pressing_R, 0
		mov			byte ptr cs:p2_moving_R, 0
		jmp			keyboard_function_end
p2_left_pressed:
		mov			byte ptr cs:p2_pressing_L, 1
		jmp			keyboard_function_end
p2_left_released:
		mov			byte ptr cs:p2_pressing_L, 0
		mov			byte ptr cs:p2_moving_L, 0
		jmp			keyboard_function_end
p2_down_pressed:
		cmp			byte ptr cs:p2_can_move_D, 1
		jne			keyboard_function_end
		mov			byte ptr cs:p2_pressing_D, 1
		jmp			keyboard_function_end
p2_down_released:
		mov			byte ptr cs:p2_can_move_D, 1
		mov			byte ptr cs:p2_pressing_D, 0
		jmp			keyboard_function_end
p2_RR_pressed:
		mov			byte ptr cs:p2_pressing_RR, 1
		jmp			keyboard_function_end
p2_RL_pressed:
		mov			byte ptr cs:p2_pressing_RL, 1
		jmp			keyboard_function_end
p1_right_pressed:
		mov			byte ptr cs:p1_pressing_R, 1
		jmp			keyboard_function_end
p1_right_released:
		mov			byte ptr cs:p1_pressing_R, 0
		mov			byte ptr cs:p1_moving_R, 0
		jmp			keyboard_function_end
p1_left_pressed:
		mov			byte ptr cs:p1_pressing_L, 1
		jmp			keyboard_function_end
p1_left_released:
		mov			byte ptr cs:p1_pressing_L, 0
		mov			byte ptr cs:p1_moving_L, 0
		jmp			keyboard_function_end
p1_down_pressed:
		cmp			byte ptr cs:p1_can_move_D, 1
		jne			keyboard_function_end
		mov			byte ptr cs:p1_pressing_D, 1
		jmp			keyboard_function_end
p1_down_released:
		mov			byte ptr cs:p1_can_move_D, 1
		mov			byte ptr cs:p1_pressing_D, 0
		jmp			keyboard_function_end
p1_RR_pressed:
		mov			byte ptr cs:p1_pressing_RR, 1
		jmp			keyboard_function_end
p1_RL_pressed:
		mov			byte ptr cs:p1_pressing_RL, 1
		jmp			keyboard_function_end
space_pressed:
		call		clear_boards
		jmp			keyboard_function_end
escape_pressed:
		mov			byte ptr cs:game_over, 1
keyboard_function_end:
		pop			ax
		jmp			dword ptr cs:vector9
		ret
keyboard_function endp

clock_function proc
		push		bp
		mov			bp, sp
		push		cx

		cmp			byte ptr cs:p1_pressing_RR, 1
		jne			check_p1_RL
		mov			byte ptr cs:p1_pressing_RR, 0		; set to 0 in order to prevent double rotation from one button press
		push		0101h		; 8bit = 1/-1 -> left/right, 8bit = 1/2 -> player1/player2
		call		rotate
		add			sp, 2
check_p1_RL:
		cmp			byte ptr cs:p1_pressing_RL, 1
		jne			check_p2_RR
		mov			byte ptr cs:p1_pressing_RL, 0
		push		0ff01h
		call		rotate
		add			sp, 2
check_p2_RR:
		cmp			byte ptr cs:p2_pressing_RR, 1
		jne			check_p2_RL
		mov			byte ptr cs:p2_pressing_RR, 0
		push		0102h
		call		rotate
		add			sp, 2
check_p2_RL:
		cmp			byte ptr cs:p2_pressing_RL, 1
		jne			check_p1_delay
		mov			byte ptr cs:p2_pressing_RL, 0
		push		0ff02h
		call		rotate
		add			sp, 2

	; when pressing right/left key for the first time
	; piece moves one step, waits a couple of frames
	; and then moves each 2 frames. thats why there is delay

check_p1_delay:
		cmp			byte ptr cs:p1_delay, 0
		je			check_p2_delay
		dec			byte ptr cs:p1_delay
check_p2_delay:
		cmp			byte ptr cs:p2_delay, 0
		je			checked_p2_delay
		dec			byte ptr cs:p2_delay
checked_p2_delay:
		; checking if pressing right key means something like this:
		; if (pressing_R && !moving_R || pressing_R && !delay) {
		;		(moving_R) ? delay=2 : delay=5 ;
		;		moving_R = 1;
		;		move_right(); }
		cmp			byte ptr cs:p1_pressing_R, 1
		jne			p1_is_not_pressing_R
		cmp			byte ptr cs:p1_moving_R, 1		; moving_R is set to 1 after making first step, and to 0 after releasing key
		je			p1_keep_pressing_R
		mov			byte ptr cs:p1_delay, 3		; that's the delay after first step
		mov			byte ptr cs:p1_moving_R, 1
		push		word ptr 1		; p1_right_key was just pressed
		call		move_right
		add			sp, 2
		jmp			p1_is_not_pressing_L
p1_keep_pressing_R:
		cmp			byte ptr cs:p1_delay, 0
		jne			p1_is_not_pressing_L
		push		word ptr 1
		call		move_right
		add			sp, 2
p1_is_not_pressing_R:
		cmp			byte ptr cs:p1_pressing_L, 1
		jne			p1_is_not_pressing_L
		cmp			byte ptr cs:p1_moving_L, 1
		je			p1_keep_pressing_L
		mov			byte ptr cs:p1_delay, 3
		mov			byte ptr cs:p1_moving_L, 1
		push		word ptr 1
		call		move_left
		add			sp, 2
		jmp			p1_is_not_pressing_L
p1_keep_pressing_L:
		cmp			byte ptr cs:p1_delay, 0
		jne			p1_is_not_pressing_L
		push		word ptr 1
		call		move_left
		add			sp, 2
p1_is_not_pressing_L:
		cmp			byte ptr cs:p2_pressing_R, 1
		jne			p2_is_not_pressing_R
		cmp			byte ptr cs:p2_moving_R, 1
		je			p2_keep_pressing_R
		mov			byte ptr cs:p2_delay, 3
		mov			byte ptr cs:p2_moving_R, 1
		push		word ptr 2
		call		move_right
		add			sp, 2
		jmp			p2_is_not_pressing_L
p2_keep_pressing_R:
		cmp			byte ptr cs:p2_delay, 0
		jne			p2_is_not_pressing_L
		push		word ptr 2
		call		move_right
		add			sp, 2
p2_is_not_pressing_R:
		cmp			byte ptr cs:p2_pressing_L, 1
		jne			p2_is_not_pressing_L
		cmp			byte ptr cs:p2_moving_L, 1
		je			p2_keep_pressing_L
		mov			byte ptr cs:p2_delay, 3
		mov			byte ptr cs:p2_moving_L, 1
		push		word ptr 2
		call		move_left
		add			sp, 2
		jmp			p2_is_not_pressing_L
p2_keep_pressing_L:
		cmp			byte ptr cs:p2_delay, 0
		jne			p2_is_not_pressing_L
		push		word ptr 2
		call		move_left
		add			sp, 2
p2_is_not_pressing_L:

		cmp			byte ptr cs:p1_pressing_D, 1
		jne			check_p2_down
		mov			byte ptr cs:p1_speed_step, 1
check_p2_down:
		cmp			byte ptr cs:p2_pressing_D, 1
		jne			checked_pressing_down
		mov			byte ptr cs:p2_speed_step, 1
checked_pressing_down:

		sub			byte ptr cs:p1_speed_step, 1
		jnz			skip_p1_falling
		mov			cl, cs:p1_speed
		mov			cs:p1_speed_step, cl
		push		word ptr 1
		call		erase_shape
		add			sp, 2
		push		word ptr 1
		call		gravitation
		add			sp, 2
		push		word ptr 1
		call		draw_shape
		add			sp, 2
skip_p1_falling:
		sub			byte ptr cs:p2_speed_step, 1
		jnz			skip_p2_falling
		mov			cl, cs:p2_speed
		mov			cs:p2_speed_step, cl
		push		word ptr 2
		call		erase_shape
		add			sp, 2
		push		word ptr 2
		call		gravitation
		add			sp, 2
		push		word ptr 2
		call		draw_shape
		add			sp, 2
skip_p2_falling:

		pop			cx
		pop			bp
		jmp			dword ptr cs:vector8
		ret
clock_function endp

draw_mini_grid proc
		push		ax
		push		bx
		push		cx
		push		dx
		push		si
		push		es
	;this function was used in the beginning to print board arrays for p1 and p2
		mov			ax, 0a000h
		mov			es, ax

		mov			si, offset p1_board

		mov			dx, 21
		mov			bx, 3350
p1_grid_y:
		mov			cx, 10
p1_grid_x:
		mov			al, byte ptr cs:[si]
		mov			es:[bx], al
		add			si, 2
		inc			bx
		loop		p1_grid_x
		add			bx, 310
		sub			dx, 1
		jnz			p1_grid_y

		mov			si, offset p2_board
		mov			dx, 21
		mov			bx, 12950
p2_grid_y:
		mov			cx, 10
p2_grid_x:
		mov			al, byte ptr cs:[si]
		mov			es:[bx], al
		add			si, 2
		inc			bx
		loop		p2_grid_x
		add			bx, 310
		sub			dx, 1
		jnz			p2_grid_y

		pop			es
		pop			si
		pop			dx
		pop			cx
		pop			bx
		pop			ax
		ret
draw_mini_grid endp

rotate proc
		push		bp
		mov			bp, sp
		sub			sp, 10
	;ss:[bp-4] = new coordinates_X
	;ss:[bp-8] = new coordinates_Y
	;ss:[bp-9] = new rotation
	;ss:[bp+4] = 1/2   ->   player1/2 rotating
	;ss:[bp+5] = 1/-1   ->  right/left
		push		eax
		push		bx
		push		cx
		push		dx
		push		di
		push		si

		cmp			byte ptr ss:[bp+4], 1
		jne			p2_rotating
		mov			bx, offset p1_shape_X
		mov			si, offset p1_board
		jmp			start_rotating
p2_rotating:
		mov			bx, offset p2_shape_X
		mov			si, offset p2_board
start_rotating:
	; rotating in a nutshell:
	; what is the shape?
	; how is it rotated now?
	; remember the offset of coordinates of new rotated shape (and also the step of rotation)
	; add current shape offset and check if rotation doesn't hit any tiles
	; if no, update coordinates to new rotated ones
	; 200 lines, thank you, probably (definitely) could be (much) fewer 
		cmp			byte ptr cs:[bx-422], 0
		je			rotating_I
		cmp			byte ptr cs:[bx-422], 1		; O shape, exit function
		je			cant_rotate
		cmp			byte ptr cs:[bx-422], 2
		je			rotating_T
		cmp			byte ptr cs:[bx-422], 3
		je			rotating_L
		cmp			byte ptr cs:[bx-422], 4
		je			rotating_Z
		cmp			byte ptr cs:[bx-422], 5
		je			rotating_J
		;cmp			byte ptr cs:[bx-422], 6
		;je			rotating_S
;rotating_S:
		cmp			byte ptr cs:[bx-421], 0		; what is current rotation state
		jne			rotating_S_1
;rotating_S_0:
		mov			di, 4
		mov			byte ptr ss:[bp-9], 1
		jmp			set_S_coordinates
rotating_S_1:
		mov			di, 0
		mov			byte ptr ss:[bp-9], 0
set_S_coordinates:
		mov			eax, cs:[shape_S_X+di]
		mov			ss:[bp-4], eax
		mov			eax, cs:[shape_S_Y+di]
		mov			ss:[bp-8], eax
		jmp			add_shape_offset
		
rotating_J:
		mov			al, ss:[bp+5]
		add			al, byte ptr cs:[bx-421]
		cmp			al, -1
		jne			check_if_J_rotation_overflow
		mov			al, 3
		jmp			J_rotation_is_set
check_if_J_rotation_overflow:
		cmp			al, 4
		jne			J_rotation_is_set
		mov			al, 0
J_rotation_is_set:
		mov			byte ptr ss:[bp-9], al
		movzx		di, byte ptr ss:[bp-9]
		shl			di, 2
		mov			eax, cs:[shape_J_X+di]
		mov			ss:[bp-4], eax
		mov			eax, cs:[shape_J_Y+di]
		mov			ss:[bp-8], eax
		jmp			add_shape_offset		
rotating_L:
		mov			al, ss:[bp+5]
		add			al, byte ptr cs:[bx-421]
		cmp			al, -1
		jne			check_if_L_rotation_overflow
		mov			al, 3
		jmp			L_rotation_is_set
check_if_L_rotation_overflow:
		cmp			al, 4
		jne			L_rotation_is_set
		mov			al, 0
L_rotation_is_set:
		mov			byte ptr ss:[bp-9], al
		movzx		di, byte ptr ss:[bp-9]
		shl			di, 2
		mov			eax, cs:[shape_L_X+di]
		mov			ss:[bp-4], eax
		mov			eax, cs:[shape_L_Y+di]
		mov			ss:[bp-8], eax
		jmp			add_shape_offset
rotating_T:
		mov			al, ss:[bp+5]
		add			al, byte ptr cs:[bx-421]
		cmp			al, -1
		jne			check_if_T_rotation_overflow
		mov			al, 3
		jmp			T_rotation_is_set
check_if_T_rotation_overflow:
		cmp			al, 4
		jne			T_rotation_is_set
		mov			al, 0
T_rotation_is_set:
		mov			byte ptr ss:[bp-9], al
		movzx		di, byte ptr ss:[bp-9]
		shl			di, 2
		mov			eax, cs:[shape_T_X+di]
		mov			ss:[bp-4], eax
		mov			eax, cs:[shape_T_Y+di]
		mov			ss:[bp-8], eax
		jmp			add_shape_offset
rotating_Z:
		cmp			byte ptr cs:[bx-421], 0
		jne			rotating_Z_1
;rotating_Z_0:
		mov			di, 4
		mov			byte ptr ss:[bp-9], 1
		jmp			set_Z_coordinates
rotating_Z_1:
		mov			di, 0
		mov			byte ptr ss:[bp-9], 0
set_Z_coordinates:
		mov			eax, cs:[shape_Z_X+di]
		mov			ss:[bp-4], eax
		mov			eax, cs:[shape_Z_Y+di]
		mov			ss:[bp-8], eax
		jmp			add_shape_offset
rotating_I:
		cmp			byte ptr cs:[bx-421], 0
		jne			rotating_I_1
;rotating_I_0:
		mov			di, 4
		mov			byte ptr ss:[bp-9], 1
		jmp			set_I_coordinates
rotating_I_1:
		mov			di, 0
		mov			byte ptr ss:[bp-9], 0
set_I_coordinates:
		mov			eax, cs:[shape_I_X+di]
		mov			ss:[bp-4], eax
		mov			eax, cs:[shape_I_Y+di]
		mov			ss:[bp-8], eax
		jmp			add_shape_offset
add_shape_offset:
		mov			di, 4
		mov			al, cs:[bx]
		mov			ah, cs:[bx+1]
		adding_shape_offset_loop:
		add			ss:[bp+di-5], al			; increase new coordinate X
		add			ss:[bp+di-9], ah			; increase new coordinate Y
		cmp			byte ptr ss:[bp+di-5], 0	; if x<0 or x>9
		jb			cant_rotate
		cmp			byte ptr ss:[bp+di-5], 10
		jae			cant_rotate
		cmp			byte ptr ss:[bp+di-9], 21
		jae			cant_rotate
		sub			di, 1
		jnz			adding_shape_offset_loop

		mov			di, 4
checking_if_can_rotate:
		movzx		ax, byte ptr ss:[bp+di-9]
		mov			cl, 10
		mul			cl
		mov			cl, ss:[bp+di-5]
		add			ax, cx
		shl			ax, 1
		xchg		ax, bx
		cmp			word ptr cs:[si+bx], 0
		xchg		ax, bx
		jne			cant_rotate
		sub			di, 1
		jnz			checking_if_can_rotate
;can_rotate:
		push		word ptr ss:[bp+4]
		call		erase_shape
		add			sp, 2

		mov			al, ss:[bp-9]
		mov			cs:[bx-421], al
		mov			eax, ss:[bp-4]
		mov			cs:[bx+2], eax
		mov			eax, ss:[bp-8]
		mov			cs:[bx+6], eax

		push		word ptr ss:[bp+4]
		call		draw_shape
		add			sp, 2
cant_rotate:
		pop			si
		pop			di
		pop			dx
		pop			cx
		pop			bx
		pop			eax
		add			sp, 10
		pop			bp
		ret
rotate endp

move_right proc
		push		bp
		mov			bp, sp
	;ss:[bp+4] = 1/2   ->   player1/2 falling
		push		ax
		push		bx
		push		cx
		push		si
		push		di
		cmp			byte ptr ss:[bp+4], 1
		jnz			moving_right_for_p2
		mov			bx, offset p1_tiles_X
		mov			si, offset p1_board
		jmp			start_moving_right
moving_right_for_p2:	
		mov			bx, offset p2_tiles_X
		mov			si, offset p2_board
start_moving_right:
		mov			di, 4
check_if_hit_right_wall:
		cmp			byte ptr cs:[bx+di-1], 9		; x3 == 9?, x2 == 9?, x1 == 9?, x0 == 9?
		je			the_end_of_moving_right
		sub			di, 1
		jnz			check_if_hit_right_wall

		mov			di, 4
check_if_hit_right_tile:
		movzx		ax, byte ptr cs:[bx+di+3]		; board[x+1][y] = board[10*y + x+1]. ax=10*y+x+1
		mov			cl, 10
		mul			cl
		mov			cl, cs:[bx+di-1]
		inc			cl
		add			al, cl
		shl			ax, 1							; multiply ax (board array index) * 2, because board values are 16 bit
		xchg		ax, bx
		cmp			word ptr cs:[si+bx], 0
		xchg		ax, bx
		jne			other_pieces_are_blocking_right
		sub			di, 1
		jnz			check_if_hit_right_tile

		push		word ptr ss:[bp+4]
		call		erase_shape
		add			sp, 2

		mov			di, 4
move_piece_right:
		inc			byte ptr cs:[bx+di-1]
		sub			di, 1
		jnz			move_piece_right
		inc			byte ptr cs:[bx-2]			; shape_X++

		add			byte ptr cs:[si-3], 2			; add delay, 2;   you can move 1 step per 2 frames

		push		word ptr ss:[bp+4]
		call		draw_shape
		add			sp, 2
		jmp			the_end_of_moving_right
other_pieces_are_blocking_right:
		mov			byte ptr cs:[si-3], 0			; mov delay, 0;   allows you to make tucks easier
the_end_of_moving_right:

		pop			di
		pop			si
		pop			cx
		pop			bx
		pop			ax
		pop			bp
		ret
move_right endp
move_left proc
		push		bp
		mov			bp, sp
	;ss:[bp+4] = 1/2   ->   player1/2 falling
		push		ax
		push		bx
		push		cx
		push		si
		push		di

		cmp			byte ptr ss:[bp+4], 1
		jnz			moving_left_for_p2
		mov			bx, offset p1_tiles_X
		mov			si, offset p1_board
		jmp			start_moving_left
moving_left_for_p2:	
		mov			bx, offset p2_tiles_X
		mov			si, offset p2_board
start_moving_left:
		mov			di, 4
check_if_hit_left_wall:
		cmp			byte ptr cs:[bx+di-1], 0
		je			the_end_of_moving_left
		sub			di, 1
		jnz			check_if_hit_left_wall

		mov			di, 4
check_if_hit_left_tile:
		movzx		ax, byte ptr cs:[bx+di+3]
		mov			cl, 10
		mul			cl
		mov			cl, cs:[bx+di-1]
		dec			cl
		add			al, cl
		shl			ax, 1
		xchg		ax, bx
		cmp			word ptr cs:[si+bx], 0
		xchg		ax, bx
		jne			other_pieces_are_blocking_left
		sub			di, 1
		jnz			check_if_hit_left_tile
		
		push		word ptr ss:[bp+4]
		call		erase_shape
		add			sp, 2

		mov			di, 4
move_piece_left:
		dec			byte ptr cs:[bx+di-1]
		sub			di, 1
		jnz			move_piece_left
		dec			byte ptr cs:[bx-2]			; shape_X--

		add			byte ptr cs:[si-3], 2
		
		push		word ptr ss:[bp+4]
		call		draw_shape
		add			sp, 2
		jmp			the_end_of_moving_left
other_pieces_are_blocking_left:
		mov			byte ptr cs:[si-3], 0
the_end_of_moving_left:

		

		pop			di
		pop			si
		pop			cx
		pop			bx
		pop			ax
		pop			bp
		ret
		ret
move_left endp
gravitation proc
		push		bp
		mov			bp, sp
	;ss:[bp+4] = 1/2   ->   player1/2 falling
		push		ax
		push		bx
		push		cx
		push		si
		push		di
		
		push		word ptr ss:[bp+4]
		call		erase_shape
		add			sp, 2

		cmp			byte ptr ss:[bp+4], 1
		jnz			gravitation_for_p2
		mov			bx, offset cs:p1_tiles_X
		mov			si, offset cs:p1_board
		mov			byte ptr cs:p1_can_move_D, 1
		jmp			start_gravitation
gravitation_for_p2:	
		mov			bx, offset cs:p2_tiles_X
		mov			si, offset cs:p2_board
		mov			byte ptr cs:p2_can_move_D, 1
start_gravitation:
		mov			di, 4
check_if_hit_bottom:
		cmp			byte ptr cs:[bx+di+3], 20			; tiles_Y[3], tiles_Y[2], tiles_Y[1], tiles_Y[0]
		je			update_board_and_make_new_shape
		sub			di, 1
		jnz			check_if_hit_bottom

		mov			di, 4
check_if_hit_tile:
		movzx		ax, byte ptr cs:[bx+di+3]			; tiles_Y[3], tiles_Y[2], tiles_Y[1], tiles_Y[0]
		inc			al
		mov			cl, 10
		mul			cl
		mov			cl, cs:[bx+di-1]					; tiles_X[3], ...[2], ...[1], ...[0]
		add			al, cl
		shl			ax, 1								; *2 because word = 2 bytes
		xchg		ax, bx								; bx = y*10 + x = tile index in 1D array
		cmp			word ptr cs:[si+bx], 0				; if 0 then there is nothing under this tile
		xchg		ax, bx
		jne			update_board_and_make_new_shape
		sub			di, 1
		jnz			check_if_hit_tile

		mov			di, 4				; if you are here then piece will fall down
move_piece_down:
		inc			byte ptr cs:[bx+di+3]
		sub			di, 1
		jnz			move_piece_down
		inc			byte ptr cs:[bx-1]			; shape_Y++
		jmp			gravitation_has_succeeded

update_board_and_make_new_shape:
		mov			byte ptr cs:[bx+24], 0			; can_move_down
		mov			byte ptr cs:[bx-432], 0			; is_pressing_down
		mov			byte ptr cs:[si-3], 1			; delay 0
		mov			di, 4
engraving_the_boad_array:
		movzx		ax, byte ptr cs:[bx+di+3]			; tiles_Y[3], tiles_Y[2], tiles_Y[1], tiles_Y[0]
		mov			cl, 10
		mul			cl
		mov			cl, cs:[bx+di-1]					; tiles_X[3], ...[2], ...[1], ...[0]
		add			al, cl
		shl			ax, 1
		xchg		ax, bx								; bx = y*10 + x = tile index in 1D array
		mov			cx, cs:[si-5]						; tile_color
		mov			cs:[si+bx], cx	
		xchg		ax, bx
		sub			di, 1
		jnz			engraving_the_boad_array

		push		word ptr ss:[bp+4]
		call		clear_lines
		add			sp, 2
		push		word ptr ss:[bp+4]
		call		draw_board
		add			sp, 2
		push		word ptr ss:[bp+4]
		call		make_new_shape
		add			sp, 2
gravitation_has_succeeded:
		
		push		word ptr ss:[bp+4]
		call		draw_shape
		add			sp, 2

		pop			di
		pop			si
		pop			cx
		pop			bx
		pop			ax
		pop			bp
		ret
gravitation endp

clear_boards proc
		push		ax
		push		bx
		push		cx

		mov			al, 2
		mov			bx, 0
clear_boards_set_BX:
		cmp			al, 2
		jne			clear_p2_board
		mov			bx, offset cs:p1_board
		jmp			begin_clearing_board
clear_p2_board:
		mov			bx, offset cs:p2_board
begin_clearing_board:
		mov			cx, 210
clear_boards_loop:
		mov			word ptr cs:[bx], 0
		add			bx, 2
		loop		clear_boards_loop
		sub			al, 1
		jnz			clear_boards_set_BX

		push		word ptr 1
		call		draw_board
		add			sp, 2
		push		word ptr 2
		call		draw_board
		add			sp, 2
		pop			cx
		pop			bx
		pop			ax
		ret
clear_boards endp

clear_lines proc
		push		bp
		mov			bp, sp
	;ss:[bp+4] = 1/2 -> p1/p2_board
		push		ax
		push		bx
		push		si
		push		di
		
		mov			al, 0				; if al = 1 then line was cleared
		cmp			byte ptr ss:[bp+4], 1
		jne			clear_p2_lines
		mov			bx, offset cs:p1_board
		jmp			start_clearing_lines
clear_p2_lines:
		mov			bx, offset cs:p2_board
start_clearing_lines:
		mov			di, 20			; dont check top line (which is 21th, only to be equal to zero). thats why offset from start = 20 = width*sizeof(board[0])
look_for_lines_to_clear:
		mov			cx, 10
check_if_should_clear_line:	; here di%20 = 0. it's the beginning of line
		cmp			word ptr cs:[bx+di], 0
		je			checked_if_should_clear
		add			di, 2
		loop		check_if_should_clear_line
checked_if_should_clear:
		cmp			cx, 0
		je			clear_the_line
		shl			cx, 1
		add			di, cx
		jmp			look_for_lines_loop_end
clear_the_line:
		mov			si, di
		sub			si, 2
clear_the_line_loop:
		mov			ax, cs:[bx+si-20]
		mov			cs:[bx+si], ax
		sub			si, 2
		cmp			si, 18
		ja			clear_the_line_loop
		mov			al, 1
look_for_lines_loop_end:
		cmp			di, 420
		jb			look_for_lines_to_clear

		cmp			al, 1
		jne			no_lines_cleared
		mov			al, cs:[bx+438]		; if cleared line, then speed_step = 4*speed
		shl			al, 2				; because if you score point you also get time to think 
		mov			cs:[bx+439], al
no_lines_cleared:

		pop			di
		pop			si
		pop			bx
		pop			ax
		pop			bp
		ret
clear_lines endp

map_coordinates_to_pixel_positions proc
		push		bp
		mov			bp, sp
	;ss:[bp+4] = 1/2 -> coordinates of player1/2
		push		ax
		push		bx
		push		cx
		push		dx
		push		di
		push		si
		
		cmp			byte ptr ss:[bp+4], 1
		jne			coordinates_of_p2
		mov			bx, offset cs:p1_tiles_X
		mov			di, offset cs:p1_pixel_positions
		mov			si, cs:p1_top_left
		jmp			begin_mapping
coordinates_of_p2:
		mov			bx, offset cs:p2_tiles_X
		mov			di, offset cs:p2_pixel_positions
		mov			si, cs:p2_top_left
begin_mapping:
		mov			cx, 4
mapping_coordinates_loop:
		mov			ax,	320						; ax = 320
		movzx		dx, byte ptr cs:[bx+4]
		mul			dx							; ax = tiles_Y*320
		movzx		dx, byte ptr cs:[bx]
		add			ax, dx						; ax = tiles_Y*320 + tiles_X
		mov			dx, cs:tile_size
		mul			dx							; ax = tiles_Y*tile_size*320 + tiles_X*tile_size
		add			ax, si
		mov			cs:[di], ax
		inc			bx
		add			di, 2
		loop		mapping_coordinates_loop

		pop			si
		pop			di
		pop			dx
		pop			cx
		pop			bx
		pop			ax
		pop			bp
		ret
map_coordinates_to_pixel_positions endp
draw_shape proc
		push		bp
		mov			bp, sp
	;ss:[bp+4] = 1/2 -> shape of player1/2
		push		ax
		push		bx
		push		cx
		push		si
		
		push		word ptr ss:[bp+4]
		call		map_coordinates_to_pixel_positions
		add			sp, 2

		cmp			byte ptr ss:[bp+4], 1
		jne			draw_shape_p2
		mov			bx, offset cs:p1_pixel_positions
		mov			si, offset cs:p1_tiles_Y
		mov			ax, cs:p1_color
		jmp			begin_drawing_shape
draw_shape_p2:
		mov			bx, offset cs:p2_pixel_positions
		mov			si, offset cs:p2_tiles_Y
		mov			ax, cs:p2_color
begin_drawing_shape:
		
		mov			cx, 4
		dec			word ptr cs:tile_size	; did it to have 1 pixel gap between everything
drawing_shape_loop:
		cmp			byte ptr cs:[si], 0
		je			dont_draw_this_tile
		push		word ptr cs:[bx]
		push		ax
		call		draw_square
		add			sp, 4
dont_draw_this_tile:
		inc			si
		add			bx, 2
		loop		drawing_shape_loop
		inc			word ptr cs:tile_size

		pop			si
		pop			cx
		pop			bx
		pop			ax
		pop			bp
		ret
draw_shape endp
draw_next_shape proc
		push		bp
		mov			bp, sp
		sub			sp, 2
	;ss:[bp-2] = next shape color
	;ss:[bp+4] = 1/2 -> shape of player1/2
		push		ax
		push		bx
		push		cx
		push		dx
		push		si
		push		di

		cmp			byte ptr ss:[bp+4], 1
		jne			next_shape_of_p2
		mov			al, cs:p1_next_shape
		mov			bx, cs:p1_top_left_next
		jmp			start_drawing_next_shape
next_shape_of_p2:
		mov			al, cs:p2_next_shape
		mov			bx, cs:p2_top_left_next
start_drawing_next_shape:

		cmp			al, 0
		je			next_shape_I
		cmp			al, 1
		je			next_shape_O
		cmp			al, 2
		je			next_shape_T
		cmp			al, 3
		je			next_shape_L
		cmp			al, 4
		je			next_shape_Z
		cmp			al, 5
		je			next_shape_J
;next_shape_S:	
		mov			dx, cs:[colors+4]
		mov			ss:[bp-2], dx
		mov			si, offset cs:shape_S_X
		mov			di, offset cs:shape_S_Y
		jmp			next_shape_map_coordinates
next_shape_J:
		mov			dx, cs:[colors+4]
		mov			ss:[bp-2], dx
		mov			si, offset cs:shape_J_X
		mov			di, offset cs:shape_J_Y
		jmp			next_shape_map_coordinates
next_shape_Z:
		mov			dx, cs:[colors+2]
		mov			ss:[bp-2], dx
		mov			si, offset cs:shape_Z_X
		mov			di, offset cs:shape_Z_Y
		jmp			next_shape_map_coordinates
next_shape_L:
		mov			dx, cs:[colors+2]
		mov			ss:[bp-2], dx
		mov			si, offset cs:shape_L_X
		mov			di, offset cs:shape_L_Y
		jmp			next_shape_map_coordinates
next_shape_T:
		mov			dx, cs:[colors]
		mov			ss:[bp-2], dx
		mov			si, offset cs:shape_T_X
		mov			di, offset cs:shape_T_Y
		jmp			next_shape_map_coordinates
next_shape_O:
		mov			dx, cs:[colors]
		mov			ss:[bp-2], dx
		mov			si, offset cs:shape_O_X
		mov			di, offset cs:shape_O_Y
		jmp			next_shape_map_coordinates
next_shape_I:
		mov			dx, cs:[colors]
		mov			ss:[bp-2], dx
		mov			si, offset cs:shape_I_X
		mov			di, offset cs:shape_I_Y
		jmp			next_shape_map_coordinates
next_shape_map_coordinates:

		dec			bx
		shl			cs:tile_size, 2
		inc			cs:tile_size
		push		bx
		push		0808h
		call		draw_square
		add			sp, 4
		dec			cs:tile_size
		shr			cs:tile_size, 2
		inc			bx

		mov			cx, 4
drawing_next_shape_loop:
		mov			ax, 320
		movzx		dx, byte ptr cs:[di]
		mul			dx
		movzx		dx, byte ptr cs:[si]
		add			ax, dx
		mov			dx, cs:tile_size
		mul			dx
		add			ax, bx

		dec			word ptr cs:tile_size
		push		ax
		push		word ptr ss:[bp-2]
		call		draw_square
		add			sp, 4
		inc			word ptr cs:tile_size
		inc			si
		inc			di
		loop		drawing_next_shape_loop

		pop			di
		pop			si
		pop			dx
		pop			cx
		pop			bx
		pop			ax
		add			sp, 2
		pop			bp
		ret
draw_next_shape endp
erase_shape proc
		push		bp
		mov			bp, sp
	;ss:[bp+4] = 1/2 -> shape of player1/2
		push		bx
		push		cx
		push		si

		cmp			byte ptr ss:[bp+4], 1
		jne			erase_shape_p2
		mov			bx, offset cs:p1_pixel_positions
		mov			si, offset cs:p1_tiles_Y
		jmp			begin_erasing_shape
erase_shape_p2:
		mov			bx, offset cs:p2_pixel_positions
		mov			si, offset cs:p2_tiles_Y
begin_erasing_shape:
		
		mov			cx, 4
		dec			word ptr cs:tile_size
erasing_shape_loop:
		cmp			byte ptr cs:[si], 0
		je			dont_erase_this_tile
		push		word ptr cs:[bx]
		push		word ptr 0
		call		draw_square
		add			sp, 4
dont_erase_this_tile:
		inc			si
		add			bx, 2
		loop		erasing_shape_loop
		inc			word ptr cs:tile_size

		pop			si
		pop			cx
		pop			bx
		pop			bp
		ret
erase_shape endp
make_new_shape proc
		push		bp
		mov			bp, sp
	;ss:[bp+4] = 1 or 2 -> shape for player1 or player2
		push		eax
		push		bx
		push		cx

		cmp			byte ptr ss:[bp+4], 1
		jne			shape_for_p2
		mov			bx, offset cs:p1_shape_X
		jmp			creating_shape
shape_for_p2:
		mov			bx, offset cs:p2_shape_X
creating_shape:
		mov			byte ptr cs:[bx-421], 0		; rotation = 0
		mov			byte ptr cs:[bx], 3		; x coordinate
		mov			byte ptr cs:[bx+1], 0	; y coordinate
		mov			ah, cs:[bx+25]
		mov			cs:[bx-422], ah				; p1/p2_shape = next_shape
		cmp			ah, 0
		je			make_line_shape
		cmp			ah, 1
		je			make_O_shape
		cmp			ah, 2
		je			make_T_shape
		cmp			ah, 3
		je			make_L_shape
		cmp			ah, 4
		je			make_Z_shape
		cmp			ah, 5
		je			make_J_shape
		;cmp			ah, 6
		;je			make_S_shape
;make_S_shape:
		mov			ax, cs:[colors+4]
		mov			cs:[bx-425], ax
		mov			eax, cs:shape_S_X
		mov			cs:[bx+2], eax
		mov			eax, cs:shape_S_Y
		mov			cs:[bx+6], eax
		jmp			correct_tile_coordinates
make_J_shape:
		mov			ax, cs:[colors+4]
		mov			cs:[bx-425], ax
		mov			eax, cs:shape_J_X
		mov			cs:[bx+2], eax
		mov			eax, cs:shape_J_Y
		mov			cs:[bx+6], eax
		jmp			correct_tile_coordinates
make_Z_shape:
		mov			ax, cs:[colors+2]
		mov			cs:[bx-425], ax
		mov			eax, cs:shape_Z_X
		mov			cs:[bx+2], eax
		mov			eax, cs:shape_Z_Y
		mov			cs:[bx+6], eax
		jmp			correct_tile_coordinates
make_L_shape:
		mov			ax, cs:[colors+2]
		mov			cs:[bx-425], ax
		mov			eax, cs:shape_L_X
		mov			cs:[bx+2], eax
		mov			eax, cs:shape_L_Y
		mov			cs:[bx+6], eax
		jmp			correct_tile_coordinates
make_T_shape:
		mov			ax, cs:colors
		mov			cs:[bx-425], ax
		mov			eax, cs:shape_T_X
		mov			cs:[bx+2], eax
		mov			eax, cs:shape_T_Y
		mov			cs:[bx+6], eax
		jmp			correct_tile_coordinates
make_O_shape:
		mov			ax, cs:colors
		mov			cs:[bx-425], ax
		mov			eax, cs:shape_O_X
		mov			cs:[bx+2], eax
		mov			eax, cs:shape_O_Y
		mov			cs:[bx+6], eax
		jmp			correct_tile_coordinates
make_line_shape:
		mov			ax, cs:colors
		mov			cs:[bx-425], ax
		mov			eax, cs:shape_I_X
		mov			cs:[bx+2], eax
		mov			eax, cs:shape_I_Y
		mov			cs:[bx+6], eax
		jmp			correct_tile_coordinates

correct_tile_coordinates:
		mov			cx, 4
correct_tile_coordinates_loop:
		add			byte ptr cs:[bx+2], 3
		inc			bx
		loop		correct_tile_coordinates_loop
		
		push		word ptr ss:[bp+4]
		call		update_random_number
		add			sp, 2

		sub			bx, 4
		movzx		ax, byte ptr cs:[bx+21]
		mov			cl, 7
		div			cl
		mov			cs:[bx+25], ah

		push		word ptr ss:[bp+4]
		call		draw_next_shape
		add			sp, 2

		pop			cx
		pop			bx
		pop			eax
		pop			bp
		ret
make_new_shape endp

draw_board proc
		push		bp
		mov			bp, sp
		push		ax
		push		bx
		push		cx
		push		dx
		push		di

		cmp			byte ptr ss:[bp+4], 1
		jne			draw_p2_board
		mov			bx, offset cs:p1_board
		jmp			start_drawing_board
draw_p2_board:
		mov			bx, offset cs:p2_board
start_drawing_board:
		mov			dx, 0
		mov			di, cs:[bx-24]		; p1/p2_top_left
		mov			ax, 320
		mov			cx, cs:tile_size
		mul			cx
		add			di, ax
		mov			ax, 310
		mov			cx, cs:tile_size
		mul			cx					; ax = tile_size*screen_width - 10*tile_size = new line
		
		add			bx, 20
		mov			dx, cs:tile_size
		dec			word ptr cs:tile_size
		mov			ch, 20
drawing_board_Y:
		mov			cl, 10
drawing_board_X:
		push		di
		push		word ptr cs:[bx]
		call		draw_square
		add			sp, 4
		add			bx, 2
		add			di, dx
		sub			cl, 1
		jnz			drawing_board_X
		add			di, ax
		sub			ch, 1
		jnz			drawing_board_Y
		inc			word ptr cs:tile_size

		pop			di
		pop			dx
		pop			cx
		pop			bx
		pop			ax
		pop			bp
		ret
draw_board endp
draw_border proc
		push		bp
		mov			bp, sp
	;ss:[bp+4] = top left pixel of position x=0, y=0
		push		ax
		push		bx
		push		cx
		push		dx
	; board = border of multiple gray squares
		mov			bx, ss:[bp+4]		; bx = position current square
		sub			bx, cs:tile_size
		sub			bx, 321					; 1 pixel left and 1 pixel up. creates 1 pixel gap between board left/top wall and position x=0/y=0

		mov			cx, 12
		mov			dx, cs:tile_size
drawing_top_border:
		push		bx
		push		word ptr cs:[colors+6]
		call		draw_square
		add			sp, 4
		add			bx, dx
		loop		drawing_top_border
		inc			bx
		sub			bx, dx
		push		bx
		push		word ptr cs:[colors+6]
		call		draw_square
		add			sp, 4

		mov			cx, 21
		mov			ax, 320
		mul			dx				; ax = pixel vertical gap between adjacent squares
drawing_right_border:
		add			bx, ax
		push		bx
		push		word ptr cs:[colors+6]
		call		draw_square
		add			sp, 4
		loop		drawing_right_border
		add			bx, 320			; 1 pixel down creates 1 pixel gap between lying shape and bottom border
		push		bx
		push		word ptr cs:[colors+6]
		call		draw_square
		add			sp, 4

		mov			dx, tile_size
		mov			cx, 11
drawing_bottom_border:
		sub			bx, dx
		push		bx
		push		word ptr cs:[colors+6]
		call		draw_square
		add			sp, 4
		loop		drawing_bottom_border
		dec			bx
		push		bx
		push		word ptr cs:[colors+6]
		call		draw_square
		add			sp, 4


		mov			ax, 320
		mul			dx
		mov			cx, 21
drawing_left_border:
		sub			bx, ax
		push		bx
		push		word ptr cs:[colors+6]
		call		draw_square
		add			sp, 4
		loop		drawing_left_border

		pop			ax
		pop			bx
		pop			cx
		pop			dx
		pop			bp
		ret
draw_border endp
draw_square proc
		push		bp
		mov			bp, sp
		push		ax
		push		bx
		push		cx
		push		dx
		push		es
	;word ptr ss:[bp+6] = position of square top left pixel
	;byte ptr ss:[bp+5] = color of square border
	;byte ptr ss:[bp+4] = color of square
		mov			ax, 0a000h
		mov			es, ax
		mov			cx, cs:tile_size		; using it because I'm lazy to use function parameter here... writing tetris in assembly...
		mov			bx, ss:[bp+6]			; position of current pixel
		mov			dl, ss:[bp+5]
top_border:
		mov			es:[bx], dl
		inc			bx
		loop		top_border
		mov			ax, 320					; screen is 320 pixels wide
		mov			dx, cs:tile_size		; height of square
		sub			dx, 2					; because border is 2 pixels high
		mul			dx						; (height-2) * 320 = position (offset) of bottom left corner
draw_y:
		mov			bx, ss:[bp+6]
		add			bx, ax
		mov			dl, ss:[bp+5]
		mov			es:[bx], dl			; draw left border
		inc			bx					; next pixel
		mov			cx, cs:tile_size
		sub			cx, 2				; middle is smaller by 2 because left and right border are 2 pixels
draw_x:
		mov			dl, ss:[bp+4]
		mov			es:[bx], dl
		inc			bx
		loop		draw_x
		mov			dl, ss:[bp+5]
		mov			es:[bx], dl			;draw right border
		sub			ax, 320
		jnz			draw_y

		mov			cx, cs:tile_size
		mov			bx, ss:[bp+6]
		mov			ax, 320
		mov			dx, cs:tile_size
		dec			dx
		mul			dx
		add			bx, ax
		mov			dl, ss:[bp+5]		; ax = height*320 = bottom left corner
bottom_border:
		mov			es:[bx],dl
		inc			bx
		loop		bottom_border

		pop			es
		pop			dx
		pop			cx
		pop			bx
		pop			ax
		pop			bp
		ret
draw_square endp

game_init proc
		push		bp
		mov			bp, sp

		call		start_random_numbers
		
		mov			word ptr cs:p1_top_left, 3890			; position of top left pixel of player1 board
		mov			word ptr cs:p2_top_left, 4030
		mov			word ptr cs:p1_top_left_next, 3526		; position of top left pixel of p1 small box with next piece in it
		mov			word ptr cs:p2_top_left_next, 3804

		push		word ptr cs:p1_top_left
		call		draw_border
		add			sp, 2
		push		word ptr cs:p2_top_left
		call		draw_border
		add			sp, 2
		
		movzx		ax, byte ptr cs:p1_rand_number
		mov			cl, 7
		div			cl
		mov			cs:p1_next_shape, ah
		push		word ptr 1
		call		update_random_number
		add			sp, 2
		movzx		ax, byte ptr cs:p2_rand_number
		mov			cl, 7
		div			cl
		mov			cs:p2_next_shape, ah
		push		word ptr 2
		call		update_random_number
		add			sp, 2

		push		word ptr 1
		call		make_new_shape
		add			sp, 2
		push		word ptr 2
		call		make_new_shape
		add			sp, 2

		push		word ptr 1
		call		draw_shape
		add			sp, 2
		push		word ptr 2
		call		draw_shape
		add			sp, 2
		
		mov			byte ptr cs:p1_speed, 3
		mov			byte ptr cs:p2_speed, 3
		mov			byte ptr cs:p1_speed_step, 20
		mov			byte ptr cs:p2_speed_step, 20

		pop			bp
		ret
game_init endp

START:
		mov			ah, 0
		mov			al, 13h
		int			10h
		call		game_init
		mov			al, 0
		mov			ah, 5
		int			10

		mov			bx, 0
		mov			es, bx
		mov			eax, es:[32]
		mov			cs:vector8, eax
		mov			ax, SEG clock_function
		mov			bx, OFFSET clock_function
		cli
		mov			es:[32], bx				; clock interrupt will call clock_function
		mov			es:[34], ax
		sti

		mov			eax, es:[36]
		mov			cs:vector9, eax
		mov			ax, SEG keyboard_function
		mov			bx, OFFSET keyboard_function
		cli
		mov			es:[36], bx				; keyboard interrupt will call keyboard_function
		mov			es:[38], ax
		sti
waiting:
		cmp			byte ptr cs:game_over, 0
		je			waiting

		mov			ah, 0
		mov			al, 3
		int			10h

		mov			eax, cs:vector8
		cli
		mov			es:[32], eax
		sti

		mov			eax, cs:vector9
		cli
		mov			es:[36], eax
		sti

		mov			ax, 4c00h
		int			21h
instructions		ENDS

memory				SEGMENT stack
		db			256 dup (?)
memory				ENDS

END START
