; Autor reseni: Marek Hric xhricma00

; Projekt 2 - INP 2024
; Vigenerova sifra na architekture MIPS64

; DATA SEGMENT
                .data
msg:            .asciiz "marekhric" 
key:            .byte   8, 18, 9; h, r, i
cipher:         .space  31

params_sys5:    .space  8 

; CODE SEGMENT
                .text

main:           
                addi    r8, r0, 0; m_offest message and cipher offset
                addi    r9, r0, 0; k_offset key offset
                addi    r10, r0, 0; control variable 0|1 (if add or sub)
                addi    r11, r0, 3; key length for modulo
                addi    r12, r0, 26; alphabet length
                addi    r13, r0, 97; ascii a
                addi    r14, r0, 122; ascii z
                addi    r15, r0, 0; control variable 0|1 (if char needs to be fixed)

            main_n:

                lb      r4, msg(r8); load msg[m_offset]
                beq     r4, r0, end_main; if msg[m_offset] == 0 break
                lb      r5, key(r9); load key[k_offset]

                beq     r10, r0, addition; if control == 0
                bne     r10, r0, substraction; if control == 1
            return_add_sub:

                b       fix_char; jump to fix char, if < 'a' or > 'z'
            return_fix_char:
                b       inc_k_offset; jump to increment key offset
            return_inc_k_offset:
                
                sb      r4, cipher(r8); save to cipher
                addi    r8, r8, 1; increment m_offset
                
                b       main_n; loop

            end_main:
                sb      r0, cipher(r8); null terminate the string
                addi    r4, r0, cipher; save cipher address
                jal     print_string 
                b       end; jump to end

            addition:
                add     r4, r4, r5; msg[m_offset] + key[k_offset]
                addi    r10, r0, 1; set control to 1
                b       return_add_sub; jump to return_add_sub

            substraction:
                sub     r4, r4, r5; msg[m_offset] - key[k_offset]
                addi    r10, r0, 0; set control to 0
                b       return_add_sub; jump to return_add_sub

            inc_k_offset:
                addi    r9, r9, 1; increment key offset
                div     r9, r11; key offset / 3
                mfhi    r9; k_offset % 3
                lb      r5, key(r9); load key[k_offset]
                b       return_inc_k_offset; jump to return_inc_k_offset

            fix_char:
                slt     r15, r4, r13; r15 = char < 'a'
                bne     r15, r0, fix_char_add
                slt     r15, r14, r4; r15 = char > 'z'
                bne     r15, r0, fix_char_sub
                b       fix_char_end; ret if valid char

            fix_char_add:
                add     r4, r4, r12
                b       fix_char_end

            fix_char_sub:
                sub     r4, r4, r12


            fix_char_end:
                b       return_fix_char; return 

            end:
                ; reset registers
                addi    r5, r0, 0
                addi    r8, r0, 0
                addi    r9, r0, 0
                addi    r10, r0, 0
                addi    r11, r0, 0
                addi    r12, r0, 0
                addi    r13, r0, 0
                addi    r14, r0, 0
                addi    r15, r0, 0



; NASLEDUJICI KOD NEMODIFIKUJTE!

                syscall 0   ; halt

print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address
