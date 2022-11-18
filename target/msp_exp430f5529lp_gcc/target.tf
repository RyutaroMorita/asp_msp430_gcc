$
$ 		�p�X2�̃^�[�Q�b�g�ˑ��e���v���[�g�imsp-exp430f5529lp�p�j
$

$
$  �L���Ȋ����ݔԍ��C�����݃n���h���ԍ�
$
$INTNO_VALID = { 0,1,...,62 }$
$INHNO_VALID = INTNO_VALID$

$
$  ATT_ISR�Ŏg�p�ł��銄���ݔԍ��Ƃ���ɑΉ����銄���݃n���h���ԍ�
$
$INTNO_ATTISR_VALID = INTNO_VALID$
$INHNO_ATTISR_VALID = INHNO_VALID$

$
$  DEF_INT�^DEF_EXC�Ŏg�p�ł��銄���݃n���h���ԍ��^CPU��O�n���h���ԍ�
$
$INHNO_DEFINH_VALID = INHNO_VALID$

$
$  CFG_INT�Ŏg�p�ł��銄���ݔԍ��Ɗ����ݗD��x
$
$INTNO_CFGINT_VALID = INTNO_VALID$
$INTPRI_CFGINT_VALID = { -7,-6,...,-1 }$

$
$  �W���e���v���[�g�t�@�C���̃C���N���[�h
$
$INCLUDE "kernel/kernel.tf"$

/*$NL$
$SPC$*  Target-dependent Definitions (msp-exp430f5529lp)$NL$
$SPC$*/$NL$
$NL$

$
$   CFG_INT�̃^�[�Q�b�g�ˑ��̃G���[�`�F�b�N��_kernel_bitpat_cfgint�̐���
$
$bitpat_cfgint = 0$
const uint32_t	_kernel_bitpat_cfgint = UINT32_C($FORMAT("0x%08x", bitpat_cfgint)$);
$NL$

$NL$
$FOREACH inhno INTNO_VALID$
	extern void $FORMAT("_kernel_int_handler_%d(void);", +inhno)$$NL$
	asm(".section .handlers,\"a\" \n\t"$NL$
	$FORMAT("\"_kernel_int_handler_%d: \\n\\t\"", +inhno)$$NL$
	"	pushm.a #1,r15 \n\t"$NL$
	$FORMAT("\"	mov.w #%d,r15 \\n\\t\"", +inhno)$$NL$
	"	bra #inthdr_entry \n\t");$NL$
	$NL$
$END$

const FP _kernel_exc_tbl[] = $NL$
{$NL$
$FOREACH inhno INTNO_VALID$
	$IF LENGTH(INH.INHNO[inhno])$
		$TAB$(FP)($INH.INTHDR[inhno]$),
	$ELSE$
		$TAB$(FP)(_kernel_default_int_handler),
	$END$
	$SPC$$FORMAT("/* %d */", +inhno)$$NL$
$END$
};$NL$

$NL$
asm(".section .vectors,\"a\" \n\t"$NL$
$FOREACH inhno INTNO_VALID$
	$FORMAT("\"	.word _kernel_int_handler_%d \\n\\t\"", +inhno)$$NL$
$END$
"	.word start \n\t"$NL$
".section .text \n\t"$NL$
);$NL$
