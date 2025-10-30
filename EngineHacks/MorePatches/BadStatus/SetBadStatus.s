@���N��Ԃ̕ύX
@
@40 0D [UNIT] [SICK] [ASM+1]
@41 0D 00 [SICK] [ASM+1]  (Load SVAL1 ID)
@4B 0D 00 [SICK] [ASM+1]  (Load SVALB coord)
@
@Author 7743
@
.align 4
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
@
@
.thumb


	.equ MemorySlot, 0x30004B8 
	.equ GetUnitByEventParameter, 0x0800BC51
	
	.global SetBadStatus
	.type   SetBadStatus, function

SetBadStatus:
	push	{r4-r7,lr}



	ldr		r7, =MemorySlot 
	ldr 	r0, [r7, #4*0x01]
	blh 	GetUnitByEventParameter
	cmp  r0,#0x00
	beq  Term                 @�擾�ł��Ȃ�������I��

	ldr 	r3, [r7, #4*0x03]
	mov 	r1, r3 
	
	mov  r2,#0x0f             @check bad status
	and  r1,r2                
	cmp  r1,#0x00
	beq  Change               @��ԂȂ��ɂ���炵��

	ldr         r1, [r7, #4*0x03]
	mov  r2,#0xf0             @check turn
	and  r2,r3                
	cmp  r2,#0x00
	bne  Change               @�^�[���w�肳��Ă���̂ł��̂܂܍̗p.

	mov  r2,#0x30             @�^�[���������Ă��Ȃ��̂ŁA3�^�[���Ɏ����ݒ�
	orr  r1,r2
	@b    Change

Change:
	@r0  ram unit pointer
	@r1  status.
	mov  r2,#0x30
	strb r1,[r0,r2]

Term:
@	blh  0x08019ecc   @RefreshFogAndUnitMaps    {J}
@	blh  0x08027144   @SMS_UpdateFromGameData   {J}
@	blh  0x08019914   @UpdateGameTilesGraphics  {J}
	blh  0x0801a1f4   @RefreshFogAndUnitMaps    {U}
	blh  0x080271a0   @SMS_UpdateFromGameData   {U}
	blh  0x08019c3c   @UpdateGameTilesGraphics  {U}

	mov	r0, #0
	pop {r4-r7}
	pop {pc}
