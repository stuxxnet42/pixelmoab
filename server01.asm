

;TODO replace mov 0

%define     AF_INET         2
%define     SOCK_DGRAM      2
%define     IPPROTO_UDP     17
%define     PORT            0xca26        ; port 9930 (mind the byte order!)
%define     INADDR_ANY      0
%define     BUFLEN          4096
%define     O_RDWR          2
%define     SCREENSIZE      1920*1080*4
%define     NO_PIXEL        1920*1080
%define     SCR_WIDTH       1920
%define     SCR_HEIGHT      1080
%define     PROT_READ       1
%define     PROT_WRITE      2
%define     PROT_RW         3
%define     MAP_SHARED      1


;; sockaddr_in definition
struc sockaddr_in
    .sin_family resw 1
    .sin_port resw 1
    .sin_addr resd 1
    .sin_zero resb 8
endstruc

section .data
    fb_path             db "/dev/fb0", 0
    fb_path_len         equ $ - fb_path

    s_init_err_m        db "Failed to initialise socket", 0x0a, 0
    s_init_err_len      equ $ - s_init_err_m
    
    s_init_suc_m        db "Socket initialized", 0x0a, 0
    s_init_suc_len      equ $ - s_init_suc_m

    s_bind_err_m        db "Failed to bind socket", 0x0a, 0
    s_bind_err_len      equ $ - s_bind_err_m
    
    s_bind_suc_m        db "Socket bound", 0x0a, 0
    s_bind_suc_len      equ $ - s_bind_suc_m

    s_read_err_m        db "Socket read error", 0x0a, 0
    s_read_err_len      equ $ - s_read_err_m
    
    s_read_suc_m        db "Socket read success", 0x0a, 0
    s_read_suc_len      equ $ - s_read_suc_m
    
    fb_open_err_m       db "fb open error", 0x0a, 0
    fb_open_err_len     equ $ - fb_open_err_m
    
    fb_open_suc_m       db "fb open success", 0x0a, 0
    fb_open_suc_len     equ $ - fb_open_suc_m

    fb_map_err_m       db "fb map error", 0x0a, 0
    fb_map_err_len     equ $ - fb_map_err_m
    
    fb_map_suc_m       db "fb map success", 0x0a, 0
    fb_map_suc_len     equ $ - fb_map_suc_m
    
    px_parse_err_m     db "pixel parse error", 0x0a, 0
    px_parse_err_len   equ $ - px_parse_err_m
    
    px_parse_suc_m     db "pixel parse success", 0x0a, 0
    px_parse_suc_len   equ $ - px_parse_suc_m
    
    
    my_addr istruc sockaddr_in
        at sockaddr_in.sin_family, dw AF_INET
        at sockaddr_in.sin_port, dw PORT
        at sockaddr_in.sin_addr, dd 0             ; localhost
        at sockaddr_in.sin_zero, dd 0, 0
    iend
    my_addr_len         equ $ - my_addr
    
    
    
    cli_addr istruc sockaddr_in
        at sockaddr_in.sin_family, dw AF_INET
        at sockaddr_in.sin_port, dw PORT
        at sockaddr_in.sin_addr, dd 0             ; localhost
        at sockaddr_in.sin_zero, dd 0, 0
    iend
    cli_addr_len         equ $ - cli_addr
    

section .bss
    frame0  resq 1
    frame1  resq 1
    fb_fd   resq 1
    fb_mm   resq 1
    sockfd  resq 1       ;socket fd
    



section .text
global _start


_start:
    mov word [sockfd], 0
    call _open_fb
    call _map_fb
    call _malloc
    call _socket
    call _bind
    
    .read_loop:
        ;call _recvfrom
        call _read
        mov rdi, [frame0]
        call _parse_msg
        cmp rax, 0
        jl .bad_msg
        ;call _px_parse_suc
        call _write_fb_pixel
    jmp .read_loop
    
    jmp _exit
    .bad_msg:
        call _px_parse_err
    jmp .read_loop


_malloc:
    mov rax, 9          ; mmap2
    mov rdi, 0          ; addr = NULL
    mov rsi, 4096       ; len = 4096
    mov rdx, 0x7        ; prot = PROT_READ|PROT_WRITE|PROT_EXEC
    mov r10, 0x22       ; flags = MAP_PRIVATE|MAP_ANONYMOUS
    mov r8, -1          ; fd = -1
    mov r9, 0           ; offset = 0 (4096*0)
    syscall             ; make call
    
    mov qword [frame0], rax
    ret

_open_fb:
    mov rax, 2          ;open
    mov rdi, fb_path
    mov rsi, O_RDWR     ;flags
    mov rdx, 0
    syscall
    
    cmp rax, 0
    jl _fb_open_err
    
    mov qword [fb_fd], rax
    
    call _fb_open_suc
    ret

;uint8_t *fbp = mmap(0, screensize, PROT_READ | PROT_WRITE, MAP_SHARED, fb_fd, (off_t)0);
_map_fb:
    mov rax, 9
    mov rdi, 0
    mov rsi, SCREENSIZE
    mov rdx, PROT_RW
    mov r10, MAP_SHARED
    mov r8, [fb_fd]
    mov r9, 0
    syscall
    
    cmp rax, 0
    jl _fb_map_err
    
    mov qword [fb_mm], rax
    
    call _fb_map_suc
    ret




_write_fb:
    mov rcx, 0              ;counter
    mov rdi, NO_PIXEL
    mov rbx, [fb_mm]
    mov eax, 0xff00ff00
    .write_loop:
        lea rdx, [rbx + rcx*4]
        mov [rdx], eax
        inc rcx
        cmp rcx, rdi
    jne .write_loop
    ret

_write_fb_pixel:
    mov rcx, rax
    and rcx, 0xffffff ;color
    mov rdx, rax
    shr rdx, 32
    and rdx, 0xffff ;Y
    shr rax, 48
    and rax, 0xffff ;X
    imul rdx, rdx, 1920
    add rdx, rax
    mov rbx, [fb_mm]
    lea rdx, [rbx + rdx*4]
    mov [rdx], rcx
    ret


_str_to_int: ;rdi = uchar* data, rsi = uint length
    xor ecx, ecx
    xor eax, eax
    .loop:
        cmp esi, ecx
        jbe .return
        movzx edx, BYTE[rdi+rcx]
        inc rcx
        imul eax, eax, 10
        lea r8d, [rdx-48]
        cmp r8b, 9
        ja .return_error
        lea eax, [rax-48+rdx]
        jmp .loop
    
    .return_error:
        or eax, -1
    .return:
        ret

_hex_str_to_int: ;rdi = uchar* data, rsi = uint length
    xor r9d, r9d
    xor eax, eax
    .loop:
        cmp esi, r9d
        jbe .return
        mov dl, BYTE [rdi+r9]
        sal eax, 4
        lea ecx, [rdx-48]
        cmp cl, 9
        ja .parse_digit
        movzx r8d, dl
        lea ecx, [r8-48]
        or eax, ecx
        inc r9
        jmp .loop
        
    .parse_digit:
        lea ecx, [rdx-97]
        cmp cl, 5
        ja .return_error
        movzx ecx, dl
        lea edx, [rcx-87]
        or eax, edx
        inc r9
        jmp .loop
        
    .return_error:
        or eax, -1
    .return:
        ret


;"PX 1020 1042 ffaa00"
_parse_msg: ;rdi = uchar* data
      cmp BYTE  [rdi], 80
      jne .L20
      cmp BYTE  [rdi+1], 88
      jne .L20
      cmp BYTE  [rdi+2], 32
      jne .L20
      lea rdx, [rdi+3]
      push r14
      push r13
      push r12
      push rbp
      xor esi, esi
      push rbx
      mov rax, rdx
    .L7:
      cmp BYTE  [rax], 32
      lea ebx, [rsi+1]
      je .L25
      add rax, 1
      cmp ebx, 4
      mov esi, ebx
      jne .L7
    .L4:
      pop rbx
      mov rax, -1
      pop rbp
      pop r12
      pop r13
      pop r14
      ret
    .L25:
      mov r13, rdi
      mov rdi, rdx
      call _str_to_int
      movsx rbp, eax
      movsx rax, ebx
      test ebp, ebp
      lea r14, [rax+3]
      js .L4
      add rax, r13
      xor esi, esi
      cmp BYTE  [rax+3], 32
      lea ebx, [rsi+1]
      je .L26
    .L8:
      add rax, 1
      cmp ebx, 4
      mov esi, ebx
      je .L4
      cmp BYTE  [rax+3], 32
      lea ebx, [rsi+1]
      jne .L8
    .L26:
      lea rdi, [r13+0+r14]
      movsx rbx, ebx
      add rbx, r14
      call _str_to_int
      test eax, eax
      mov r12d, eax
      js .L4
      lea rdi, [r13+0+rbx]
      mov esi, 6
      call _hex_str_to_int
      test eax, eax
      js .L4
      mov rdx, rbp
      movsx rbp, r12d
      cdqe
      sal rdx, 16
      or rbp, rdx
      sal rbp, 32
      pop rbx
      or rax, rbp
      pop rbp
      pop r12
      pop r13
      pop r14
      ret
    .L20:
      mov rax, -1
      ret
    
    


_socket:
    mov rax, 41             ;socket syscall
    mov rdi, AF_INET        ;ipv4 socket
    mov rsi, SOCK_DGRAM
    mov rdx, IPPROTO_UDP    ;UDP
    syscall
    
    cmp rax, 0              ;check socket creation
    jle _s_init_err
    
    mov [sockfd], rax       ;get socket file descriptor
    
    call _s_init_suc
    
    ret


_bind:
    mov rax, 49             ;bind syscall
    mov rdi, [sockfd]       ;socket fd
    mov rsi, my_addr        ;my_addr struct
    mov rdx, my_addr_len    ;sizeof(my_addr)
    syscall

    cmp rax, 0
    jl _s_bind_err
    
    call _s_bind_suc
    
    ret

_read:
    mov rax, 0
    mov rdi, [sockfd]
    mov rsi, [frame0]
    mov rdx, BUFLEN
    syscall
    
    cmp rax, 0
    jl _s_read_err

    ;call _s_read_suc
    
    ;mov rsi, [frame0]
    ;mov rdx, BUFLEN
    
    ;call _print
    ret

_close:
    mov rax, 3
    mov rdi, [sockfd]
    syscall
    
    jmp _exit





_s_init_err:
    mov rsi, s_init_err_m
    mov rdx, s_init_err_len
    call _print
    jmp _exit

_s_init_suc:
    mov rsi, s_init_suc_m
    mov rdx, s_init_suc_len
    call _print
    ret




_s_bind_err:
    mov rsi, s_bind_err_m
    mov rdx, s_bind_err_len
    call _print
    jmp _exit

_s_bind_suc:
    mov rsi, s_bind_suc_m
    mov rdx, s_bind_suc_len
    call _print
    ret




_s_read_err:
    mov rsi, s_read_err_m
    mov rdx, s_read_err_len
    call _print
    jmp _exit

_s_read_suc:
    mov rsi, s_read_suc_m
    mov rdx, s_read_suc_len
    call _print
    ret


_fb_open_err:
    mov rsi, fb_open_err_m
    mov rdx, fb_open_err_len
    call _print
    jmp _exit

_fb_open_suc:
    mov rsi, fb_open_suc_m
    mov rdx, fb_open_suc_len
    call _print
    ret


_fb_map_err:
    mov rsi, fb_map_err_m
    mov rdx, fb_map_err_len
    call _print
    jmp _exit

_fb_map_suc:
    mov rsi, fb_map_suc_m
    mov rdx, fb_map_suc_len
    call _print
    ret


_px_parse_err:
    mov rsi, px_parse_err_m
    mov rdx, px_parse_err_len
    call _print
    ret

_px_parse_suc:
    mov rsi, px_parse_suc_m
    mov rdx, px_parse_suc_len
    call _print
    ret



_print:         ;prints msg in rsi
    mov rax, 1
    mov rdi, 1
    syscall
    ret


_exit:
    mov rax, 60
    syscall

