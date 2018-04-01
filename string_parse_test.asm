
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
    
    test_str        db "PX 5678 123 debeaf", 0
    test_str_len    equ $ - test_str
    
    color_mask      dq 0xffffffffffff

section .text
global _start

_start:
    mov rsi, test_str
    lea rdi, [test_str_len]
    call _parse_msg2








_parse_msg2: ;rsi = char* data, rdi = size_t pos
    movdqu      xmm0, [rsi + rdi - 17]
    movdqa      xmm1, oword [sixteen_spaces]
    vpcmpeqb    xmm2, xmm0, xmm1                ;find spaces
    vpmovmskb   rax, xmm2                       ;mov bitmask to rax
    
    ;mov         rbx, rax                   ;copy bitmask to rbx
    ;shr         rbx, 6
    ;and         rbx, 1
    
    ;jz          .error                     ;bad data (no space before the color
    
    
    movq        rcx, xmm0                       ;copy color to rcx
    and         rcx, color_mask                 ;select only the color bytes
    
    shl         ax, 7                          ;shift bitmask
    or          ax, 0x40                       ;insert marker
    xor         ebx, ebx
    lzcnt       bx, ax                        ;get number of Y digits
    
    inc         bx                             ;temporary increment for shifting
    shlx        eax, eax, ebx

    lzcnt       ax, ax                        ;get number of X digits
    
    ;dec         bx                             ;undo increment
    neg         ax
    neg         bx
    add         ax, 4         
    add         bx, 5         
    
    shl         eax, 2
    
    or          rax, rbx                        ;index for mask table
    
    and         rax, 0xf                        ;make sure we dont index out of range
    
    shl         rax, 4
    
    movdqa      xmm3, oword [mask_0 + rax]      ;get correct mask
    vpshufb     xmm0, xmm0, xmm3                ;extract X and Y
    
    movdqa      xmm1, oword [zmask_0 + rax]
    vpsubb      xmm0, xmm0, xmm1                ;xmm0 now contains 0X0X0X0X0Y0Y0Y0Y (already subtracted '0' from all of them)
    
    vpmullw     xmm0, xmm0, [packed_decade_mul] ;multiply by 1, 10, 100, 1000 etc
    
    vphaddw     xmm0, xmm0, xmm0
    vphaddw     xmm0, xmm0, xmm0                ;add horizontally
    
    movq        rax, xmm0
    mov         ebx, eax
    shr         ebx, 16
    and         ebx, 0xffff
    and         eax, 0xffff
    
    
    ret

