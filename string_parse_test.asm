
section .data
    align 16
    mask_0 db 3, 255, 2, 255, 1, 255, 0, 255, 8, 255, 7, 255, 6, 255, 5, 255
    mask_1 db 4, 255, 3, 255, 2, 255, 1, 255, 8, 255, 7, 255, 6, 255, 255, 255
    mask_2 db 5, 255, 4, 255, 3, 255, 2, 255, 8, 255, 7, 255, 255, 255, 255, 255
    mask_3 db 6, 255, 5, 255, 4, 255, 3, 255, 8, 255, 255, 255, 255, 255, 255, 255

    mask_4 db 3, 255, 2, 255, 1, 255, 255, 255, 8, 255, 7, 255, 6, 255, 5, 255
    mask_5 db 4, 255, 3, 255, 2, 255, 255, 255, 8, 255, 7, 255, 6, 255, 255, 255
    mask_6 db 5, 255, 3, 255, 3, 255, 255, 255, 8, 255, 7, 255, 255, 255, 255, 255
    mask_7 db 6, 255, 5, 255, 4, 255, 255, 255, 8, 255, 255, 255, 255, 255, 255, 255

    mask_8 db 3, 255, 2, 255, 255, 255, 255, 255, 8, 255, 7, 255, 6, 255, 5, 255
    mask_9 db 4, 255, 3, 255, 255, 255, 255, 255, 8, 255, 7, 255, 6, 255, 255, 255
    mask_a db 5, 255, 3, 255, 255, 255, 255, 255, 8, 255, 7, 255, 255, 255, 255, 255
    mask_b db 6, 255, 5, 255, 255, 255, 255, 255, 8, 255, 255, 255, 255, 255, 255, 255

    mask_c db 3, 255, 255, 255, 255, 255, 255, 255, 8, 255, 7, 255, 6, 255, 5, 255
    mask_d db 4, 255, 255, 255, 255, 255, 255, 255, 8, 255, 7, 255, 6, 255, 255, 255
    mask_e db 5, 255, 255, 255, 255, 255, 255, 255, 8, 255, 7, 255, 255, 255, 255, 255
    mask_f db 6, 255, 255, 255, 255, 255, 255, 255, 8, 255, 255, 255, 255, 255, 255, 255

    
    align 16
    sixteen_spaces db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20

    align 16
    zmask_0 db 48, 0, 48, 0, 48, 0, 48, 0, 48, 0, 48, 0, 48, 0, 48, 0
    zmask_1 db 48, 0, 48, 0, 48, 0, 48, 0, 48, 0, 48, 0, 48, 0, 0, 0
    zmask_2 db 48, 0, 48, 0, 48, 0, 48, 0, 48, 0, 48, 0, 0, 0, 0, 0
    zmask_3 db 48, 0, 48, 0, 48, 0, 48, 0, 48, 0, 0, 0, 0, 0, 0, 0

    zmask_4 db 48, 0, 48, 0, 48, 0, 0, 0, 48, 0, 48, 0, 48, 0, 48, 0
    zmask_5 db 48, 0, 48, 0, 48, 0, 0, 0, 48, 0, 48, 0, 48, 0, 0, 0
    zmask_6 db 48, 0, 48, 0, 48, 0, 0, 0, 48, 0, 48, 0, 0, 0, 0, 0
    zmask_7 db 48, 0, 48, 0, 48, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 0

    zmask_8 db 48, 0, 48, 0, 0, 0, 0, 0, 48, 0, 48, 0, 48, 0, 48, 0
    zmask_9 db 48, 0, 48, 0, 0, 0, 0, 0, 48, 0, 48, 0, 48, 0, 0, 0
    zmask_a db 48, 0, 48, 0, 0, 0, 0, 0, 48, 0, 48, 0, 0, 0, 0, 0
    zmask_b db 48, 0, 48, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 0

    zmask_c db 48, 0, 0, 0, 0, 0, 0, 0, 48, 0, 48, 0, 48, 0, 48, 0
    zmask_d db 48, 0, 0, 0, 0, 0, 0, 0, 48, 0, 48, 0, 48, 0, 0, 0
    zmask_e db 48, 0, 0, 0, 0, 0, 0, 0, 48, 0, 48, 0, 0, 0, 0, 0
    zmask_f db 48, 0, 0, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 0

    
    align 16
    packed_decade_mul dw 1, 10, 100, 1000, 1, 10, 100, 1000
    
    test_str        db "PX 42 233 debeaf", 0
    test_str_len    equ $ - test_str
    
    color_mask      dq 0xffffffffffff
    
    big_number      dq 1000000000

section .text
global _start

_start:
    mov r9, 0
    mov r10, qword [big_number]
    .loop:
        mov rsi, test_str
        lea rdi, [test_str_len]
        call _parse_msg2
    inc r9
    cmp r9, r10
    jl .loop
    mov rax, 60
    syscall







_parse_msg2: ;rsi = char* data, rdi = size_t pos
    movdqu      xmm0, [rsi + rdi - 17]          ;load the string into xmm0
    movdqa      xmm1, oword [sixteen_spaces]    ;move spaces for comparison into register
    vpcmpeqb    xmm2, xmm0, xmm1                ;find spaces
    vpmovmskb   rax, xmm2                       ;mov bitmask to rax
                                                ;rax now contains a "1 bit" for each byte which was a space
                                                ;and a "0 bit" for each byte which was not
    
    
    movq        rcx, xmm0                       ;copy color to rcx
    and         rcx, color_mask                 ;select only the color bytes
    
    shl         ax, 7                           ;shift bitmask to find the position of the first relevant space
    or          ax, 0x40                        ;insert marker for further shifting.
                                                ;this is needed as we'd actually want to insert 1s from the right
                                                ;to know where the original lowest bit was
                                                ;sadly this isnt possible, so we just insert a marker bit
                                                ;at the position that was the -1st bit before shifting

    xor         ebx, ebx                        ;empty ebx 
    lzcnt       bx, ax                          ;get number of Y digits
    
    inc         bx                              ;temporary increment for shifting as we need to shift
                                                ;one further than the position of the space to shift the
                                                ;"1 bit" out of the register
                                                
                                                
    shlx        eax, eax, ebx                   ;perform the variable shift depending on the number of Y digits

    lzcnt       ax, ax                          ;get number of X digits
                                                ;the number of zeros up to the marker, we originally inserted
                                                ;is the number of X digits
    
    ;dec         bx                             ;undo increment
    
                                                ;for indexing the mask table we need to calculate
                                                ; 4*(4 - no_Xdigits) + (4 - no_Ydigits)
                                                ;we do this by negating and adding, but since we incremented bx earlier
                                                ;we now have to subtract from 5 and not 4
    neg         ax
    neg         bx
    add         ax, 4         
    add         bx, 5         
    
    shl         eax, 2                          ;multiply (4-no_Xdigits) by 4
    
    or          rax, rbx                        ;index for mask table
    
    and         rax, 0xf                        ;make sure we dont index out of range
    
    shl         rax, 4                          ;TODO: lea?
                                                ;for indexint we need to multiply by 16 
                                                ;as each row in our LUT is 16 bytes
    
    movdqa      xmm3, oword [mask_0 + rax]      ;get correct mask
    vpshufb     xmm0, xmm0, xmm3                ;extract X and Y
                                                ;X and Y are now filling a 16 bit int for each digit
                                                ;whereas they used to only fill 8bits
                                                ;the reason is that we need to multiply one of each numbers digits
                                                ;by 1000 so the result would overflow.
                                                
    
    movdqa      xmm1, oword [zmask_0 + rax]     ;get a mask of zero chars
    vpsubb      xmm0, xmm0, xmm1                ;xmm0 now contains 0X0X0X0X0Y0Y0Y0Y (already subtracted '0' from all of them)
    
    vpmullw     xmm0, xmm0, [packed_decade_mul] ;multiply by 1, 10, 100, 1000 etc
    
    vphaddw     xmm0, xmm0, xmm0                ;first horizontal reduction to get X0 + X1, X2 + X3, Y0 + Y1, Y2 + Y3
    vphaddw     xmm0, xmm0, xmm0                ;second horizontal reduction we now have X and Y
                                                ;in the lower two 16 bit words of xmm0
    
    movq        rax, xmm0                       ;copy X and Y to rax
    mov         ebx, eax                        ;copy to ebx
    shr         ebx, 16                         ;extract the high word
    and         ebx, 0xffff                     ;mask off Y
    and         eax, 0xffff                     ;mask off X
    
    
    ret

