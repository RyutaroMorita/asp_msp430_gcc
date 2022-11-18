/*
 *  TOPPERS/ASP Kernel
 *      Toyohashi Open Platform for Embedded Real-Time Systems/
 *      Advanced Standard Profile Kernel
 *
 *  Copyright (C) 2000-2003 by Embedded and Real-Time Systems Laboratory
 *                              Toyohashi Univ. of Technology, JAPAN
 *  Copyright (C) 2005-2010 by Embedded and Real-Time Systems Laboratory
 *              Graduate School of Information Science, Nagoya Univ., JAPAN
 *
 *  ��L���쌠�҂́C�ȉ���(1)�`(4)�̏����𖞂����ꍇ�Ɍ���C�{�\�t�g�E�F
 *  �A�i�{�\�t�g�E�F�A�����ς������̂��܂ށD�ȉ������j���g�p�E�����E��
 *  �ρE�Ĕz�z�i�ȉ��C���p�ƌĂԁj���邱�Ƃ𖳏��ŋ�������D
 *  (1) �{�\�t�g�E�F�A���\�[�X�R�[�h�̌`�ŗ��p����ꍇ�ɂ́C��L�̒���
 *      ���\���C���̗��p��������щ��L�̖��ۏ؋K�肪�C���̂܂܂̌`�Ń\�[
 *      �X�R�[�h���Ɋ܂܂�Ă��邱�ƁD
 *  (2) �{�\�t�g�E�F�A���C���C�u�����`���ȂǁC���̃\�t�g�E�F�A�J���Ɏg
 *      �p�ł���`�ōĔz�z����ꍇ�ɂ́C�Ĕz�z�ɔ����h�L�������g�i���p
 *      �҃}�j���A���Ȃǁj�ɁC��L�̒��쌠�\���C���̗��p��������щ��L
 *      �̖��ۏ؋K����f�ڂ��邱�ƁD
 *  (3) �{�\�t�g�E�F�A���C�@��ɑg�ݍ��ނȂǁC���̃\�t�g�E�F�A�J���Ɏg
 *      �p�ł��Ȃ��`�ōĔz�z����ꍇ�ɂ́C���̂����ꂩ�̏����𖞂�����
 *      �ƁD
 *    (a) �Ĕz�z�ɔ����h�L�������g�i���p�҃}�j���A���Ȃǁj�ɁC��L�̒�
 *        �쌠�\���C���̗��p��������щ��L�̖��ۏ؋K����f�ڂ��邱�ƁD
 *    (b) �Ĕz�z�̌`�Ԃ��C�ʂɒ�߂���@�ɂ���āCTOPPERS�v���W�F�N�g��
 *        �񍐂��邱�ƁD
 *  (4) �{�\�t�g�E�F�A�̗��p�ɂ�蒼�ړI�܂��͊ԐړI�ɐ����邢���Ȃ鑹
 *      �Q������C��L���쌠�҂����TOPPERS�v���W�F�N�g��Ɛӂ��邱�ƁD
 *      �܂��C�{�\�t�g�E�F�A�̃��[�U�܂��̓G���h���[�U����̂����Ȃ闝
 *      �R�Ɋ�Â�����������C��L���쌠�҂����TOPPERS�v���W�F�N�g��
 *      �Ɛӂ��邱�ƁD
 *
 *  �{�\�t�g�E�F�A�́C���ۏ؂Œ񋟂���Ă�����̂ł���D��L���쌠�҂�
 *  ���TOPPERS�v���W�F�N�g�́C�{�\�t�g�E�F�A�Ɋւ��āC����̎g�p�ړI
 *  �ɑ΂���K�������܂߂āC�����Ȃ�ۏ؂��s��Ȃ��D�܂��C�{�\�t�g�E�F
 *  �A�̗��p�ɂ�蒼�ړI�܂��͊ԐړI�ɐ����������Ȃ鑹�Q�Ɋւ��Ă��C��
 *  �̐ӔC�𕉂�Ȃ��D
 *
 *	2022/10/12 Ryutaro Morita
 */

/*
 *		�v���Z�b�T�ˑ����W���[�� �A�Z���u�����ꕔ�imsp430x�p�j
 */

#define	TOPPERS_MACRO_ONLY
#define UINT_C(val)			(val)		/* uint_t�^�̒萔�����}�N�� */
#define ULONG_C(val)		(val)		/* ulong_t�^�̒萔�����}�N�� */
#define CAST(type, val)		(val)		/* �^�L���X�g���s���}�N�� */
#include "kernel_impl.h"
#include "offset.h"

/*
 *  �^�X�N�f�B�X�p�b�`��
 */
	.text
	.globl dispatch
dispatch:
	/*
	 *  ���̃��[�`���́C�^�X�N�R���e�L�X�g�ECPU���b�N��ԁE�f�B�X�p�b�`
	 *  ����ԁE�i���f����́j�����ݗD��x�}�X�N�S������ԂŌĂяo��
	 *  ���D
	 */
	pushm.a	#8,r11						/* ���W�X�^��ۑ�(r11,r10,r9,r8,r7,r6,r5,r4) */
	mova	&p_runtsk,r12				/* p_runtsk��r12�� */
	mova	sp,TCB_msp(r12)				/* �^�X�N�X�^�b�N��ۑ� */
	mova	#dispatch_r,r13
	mova	r13,TCB_pc(r12)				/* ���s�ĊJ�Ԓn��ۑ� */
	jmp		dispatcher

dispatch_r:
	popm.a	#8,r11						/* ���W�X�^�𕜋A(r4,r5,r6,r7,r8,r9,r10,r11) */
	bit.w	#TCB_enatex_bit, TCB_enatex(r12)
	jeq		dispatch_r_1				/* enatex��false�Ȃ烊�^�[�� */
	tst.w	TCB_texptn(r12)				/* texptn��0�Ȃ烊�^�[�� */
	jeq		dispatch_r_1
	tst.w	&ipmflg						/* ipmflg��true�ł����            */
	jeq		dispatch_r_1
	bra		#call_texrtn				/*  �^�X�N��O�������[�`���̌ďo�� */

dispatch_r_1:
	reta

;	rts

/*
 *  �f�B�X�p�b�`���̓���J�n�iprc_support.S�j
 */
	.globl start_dispatch
start_dispatch:
	/*
	 *  ���̃��[�`���́C�J�[�l���N�����ɁC���ׂĂ̊����݂��֎~�������
	 * �i�����݃��b�N��ԂƓ����j�ŌĂяo�����D�܂��C�����݃��[�h�i��
	 *  �^�X�N�R���e�L�X�g�Ɠ����j�ŌĂяo����邱�Ƃ�z�肵�Ă���D
	 *
	 *  prc_initialize�ŁClock_flag��true�ɁCsaved_iipm��IIPM_ENAALL��
	 *  ���������Ă��邽�߁C�J�[�l���Ǘ��O�̊����݂������邱�ƂŁC
	 *  CPU���b�N��ԁE�i���f����́j�����ݗD��x�}�X�N�S������ԂɂȂ�D
	 *  �܂��Cinitialize_task��disdsp��false�ɏ��������Ă��邽�߁C�f�B
	 *  �X�p�b�`����ԂɂȂ��Ă���D
	 */
	clr.w	r12							/* �}�X�^���[�h�� */
	mov.w	r12,&int_cnt
	jmp		dispatcher_0

/*
 *  ���݂̃R���e�L�X�g���̂Ăăf�B�X�p�b�`
 */
	.globl exit_and_dispatch
exit_and_dispatch:
	/* �f�B�X�p�b�`���{�́idispatcher�j�� */

/*
 *  �f�B�X�p�b�`���{��
 */
dispatcher:
	/*
	 *  ���̃��[�`���́C�^�X�N�R���e�L�X�g�ECPU���b�N��ԁE�f�B�X�p�b�`
	 *  ����ԁE�i���f����́j�����ݗD��x�}�X�N�S������ԂŌĂяo��
	 *  ���D
	 *
	 *  ���Ȃ킿�C�}�X�^���[�h�Elock_flag��true�Edisdsp��false�Edspflg
	 *  ��true�Esaved_iipm��IIPM_ENAALL�ƂȂ��Ă���D���s�ĊJ�Ԓn�ւ���
	 *  �̏�Ԃ̂܂ܕ��򂷂�D
	 */
#ifdef LOG_DSP_ENTER
	mova	&p_runtsk,r12				/* p_runtsk���p�����[�^�� */
	calla	#log_dsp_enter

#endif /* LOG_DSP_ENTER */
dispatcher_0:
	mova	&p_schedtsk,r12				/* p_schedtsk��p_runtsk�� */
	mova	r12,&p_runtsk
	tst.a	r12							/* p_runtsk��NULL�Ȃ�dispatcher_1�� */
	jeq		dispatcher_1
	mova	TCB_msp(r12),sp				/* �^�X�N�X�^�b�N�𕜋A */
#ifdef LOG_DSP_LEAVE
	mova	&p_runtsk,r12				/* p_runtsk���p�����[�^�� */
	calla	#log_dsp_leave
	mova	&p_runtsk,r12
#endif /* LOG_DSP_LEAVE */
	mova	TCB_pc(r12), r13
	bra		r13

dispatcher_1:
	/*
	 *  CPU���b�N��Ԃ��������鏀��������D
	 */
	mov.w	#1,&int_cnt					/* �����݃��[�h�� */					/* 7/13 �C�� */
	mova	&_kernel_istkpt,sp			/* �����ݗp�̃X�^�b�N�֐ؑւ� */		/* 7/13 �C�� */
	mov.w	sr,r12
	clr.w	&lock_flag

dispatcher_2:
	/*
	 *  �����݂������C�����݃��[�h�ɐ؂芷���āC�����݂�҂D
	 *
	 *  �����Ŋ����݃��[�h�ɐ؂芷����̂́C�����Ŕ������銄���ݏ�����
	 *  �ǂ̃X�^�b�N���g�����Ƃ������̉����ƁC�����݃n���h�����ł̃^
	 *  �X�N�f�B�X�p�b�`�̖h�~�Ƃ���2�̈Ӗ�������D
	 *
	 *  �v���Z�b�T�������ݑ҂��Ɉڍs�����鏈���ƁC�����݋��Ƃ́C�s��
	 *  ���ɍs�Ȃ��K�v������D�����s���ɍs�Ȃ�Ȃ��ꍇ�C�����݂���
	 *  ��������Ɋ����݂�����C���̒��Ń^�X�N�����s�\��ԂɂȂ��
	 *  ���s���ׂ��^�X�N������ɂ�������炸�v���Z�b�T�������ݑ҂��ɂ�
	 *  ���Ă��܂��D
	 *
	 *  �����ݑ҂��̊Ԃ́Cp_runtsk��NULL�i��0�j�ɐݒ肵�Ȃ���΂Ȃ��
	 *  ���D���̂悤�ɐݒ肵�Ȃ��ƁC�����݃n���h������iget_tid���Ăяo
	 *  �����ۂ̓��삪�d�l�ɍ��v���Ȃ��Ȃ�D
	 */
	nop									/* �����ݑ҂� */
//	eint
	bis.w	#0x0058,sr					/* ���荞�݋���LPM1�ւ̈ڍs��s���ɍs�� */
										/* �^�C�}��SMCLK���g�p���Ă��邽��LPM1�܂ł����������Ȃ� */
	nop
	dint
	nop
	mov.w	r12,sr						/* ���̏�Ԃɖ߂� */
	nop
	tst.w	&reqflg						/* reqflg��false�Ȃ�dispatcher_2�� */
	jeq		dispatcher_2
	clr.w	&reqflg						/* reqflg��false�� */

	/*
	 *  CPU���b�N��Ԃɖ߂��D�����ݑ҂��̊ԂɎ��s���������݃n���h���ɂ�
	 *  ��Csaved_iipm��������������\�������邽�߁C���̒l�ɖ߂��K
	 *  �v������Ddispatcher�����s����鎞�́Csaved_iipm��IIPM_ENAALL
	 *  �ƂȂ��Ă��邽�߁C�����ł�saved_iipm��IIPM_ENAALL�i��0�j�ɖ߂�
	 *  �΂悢�D
	 */
	clr.w	r12							/* �}�X�^���[�h�� */					/* 7/13 �C�� */
	mov.w	r12,&int_cnt														/* 7/13 �C�� */
	clr.w	&saved_iipm					/* saved_iipm��0�ɂ��� */
	mov.w	#1,&lock_flag				/* CPU���b�N��Ԃ� */
	jmp		dispatcher_0

/*
 *  �J�[�l���̏I�������̌ďo��
 *
 *  M68040�ł́C���[�h�؊����ɂ��X�^�b�N���؂芷��邽�߁C�����I�ȃX
 *  �^�b�N�؊����͕K�v�Ȃ��D�ŏ����犄���݃��[�h�ł������ꍇ���C������
 *  ���ł悢�D
 */
	.globl call_exit_kernel
call_exit_kernel:
	mov.w	#1,&int_cnt					/* �����݃��[�h�� */
;	mova	#0x4400,sp
	mova	&_kernel_istkpt,sp
	bra		#exit_kernel				/* �J�[�l���̏I���������Ă� */

/*
 *  �^�X�N�J�n������
 *
 *  dispatcher����Ăяo����邽�߁CTCB�̃A�h���X��r12�ɓ����Ă���
 */
	.text
	.globl start_r
start_r:
	clr.w	&lock_flag					/* CPU���b�N������Ԃ� */
	nop
	eint
	nop
	mova	TCB_p_tinib(r12),r13		/* p_runtsk->p_tinib��r13�� */
	mov.w	TINIB_exinf(r13),r12
	mova	#ext_tsk,r14
	pushm.a	#1,r14
	mova	TINIB_task(r13), r14		/* �^�X�N�̋N���Ԓn��r14�� */
	bra		r14

/*
 *  �����݃G���g���ir15�ɃG���g���ԍ�������j
 */
	.global inthdr_entry
inthdr_entry:
	pushm.a	#3,r14						/* �X�N���b�`���W�X�^��ۑ�(r14,r13,r12) */

	mov.w	&int_cnt,r12
	inc.w	r12							/* �����݃��[�h�� */
	mov.w	r12,&int_cnt
	cmp.w	#1,r12						/* ���Z�O��0�łȂ���Α��d������ */
	jne		inthdr_entry_0_d

	mova	sp,&int_sp
;	mova	#0x4400,sp
	mova	&_kernel_istkpt,sp
	jmp		inthdr_entry_0

inthdr_entry_0_d:
	jmp		inthdr_entry_0

inthdr_entry_0:
;	nop
;	eint
;	nop
	mova	#_kernel_exc_tbl,r12
	mov.w	r15,r13
0:
	tst.w	r13
	jeq		1f

	add.w	#4,r12
	dec.w	r13
	jmp		0b

1:
#ifdef LOG_INH_LEAVE
	pushm.a	#1,r15						/* for Debug */
#endif

#ifdef LOG_INH_ENTER
	pushm.a	#4,r15						/* �X�N���b�`���W�X�^��ۑ�(r15,r14,r13,r12) */
	mov,w	r15,r12
	call	log_inh_enter				/* log_exc_enter���Ăяo�� */

	popm.a	#4,r15						/* �X�N���b�`���W�X�^�𕜋A(r12,r13,r14,r15) */
#endif /* LOG_EXC_ENTER */

	calla	@r12						/* C���[�`���Ăяo�� */

#ifdef LOG_INH_LEAVE
	popm.a	#1,r15						/* �X�N���b�`���W�X�^�𕜋A(r15) */
	mov,w	r15,r12
	call	log_inh_leave				/* log_exc_leave���Ăяo�� */

#endif /* LOG_INH_LEAVE */

	nop
	eint
	nop

/*
 *  �����݃n���h���o������
 *
 *  ret_int�́C�����݃n���h������߂�������Ɏ��s���郋�[�`���ŁC
 *  INTHDR_ENTRY�}�N���œW�J���銄���݃n���h���̓��������ŁC�����݃n��
 *  �h������̖߂�Ԓn�ɐݒ肳���D
 */
	.text
	.globl ret_int
ret_int:
	dint
	nop
//	popm.a	#1,r15						/* for Debug */
	mov.w	&int_cnt,r12				/* �߂�悪�����݃��[�h�Ȃ� */
	dec.w	r12
	mov.w	r12,&int_cnt
	tst.w	r12
	jne		ret_int_1_d					/*           �����Ƀ��^�[�� */

	/*
	 *  �J�[�l���Ǘ��̊����݂��֎~����D���̎��_�ł́CCPU���b�N��Ԃ�
	 *  �͂Ȃ�Ȃ��ilock_flag��saved_iipm�͍X�V���Ȃ��j�D
	 *
	 *  reqflg���`�F�b�N����O�Ɋ����݂��֎~����̂́Creqflg���`�F�b�N
	 *  ��������Ɋ����݃n���h�����N������C���̒��Ńf�B�X�p�b�`���v��
	 *  ���ꂽ�ꍇ�ɁC�����Ƀf�B�X�p�b�`����Ȃ��Ƃ�����肪�����邽��
	 *  �ł���D
	 */

	/*
	 *  ���̃��[�`���̓J�[�l���Ǘ��̊����݂���N������邽�߁C�����ł́C
	 *  �����ݗD��x�}�X�N��TIPM_LOCK�����Ⴂ�Ƒz��ł���D
	 */
	tst.w	&reqflg						/* reqflg��true�ł����ret_int_2�� */
	jne		ret_int_2

	mova	&int_sp,sp

ret_int_1:
	/*
	 *  �����ݏ�������̃��^�[���ɂ��CCPU���b�N������ԂɈڍs����悤
	 *  ��������D�����ݗD��x�}�X�N�́CRTE���߂ɂ�茳�̒l�ɖ߂邽�߁C
	 *  lock_flag��false�ɂ��Ă����΂悢�ilock_flag��false�ɂ���̂́C
	 *  CPU���b�N��Ԃ̂܂܊����݃n���h������߂������̑΍�j�D
	 */
	clr.w	&lock_flag					/* CPU���b�N�����̏��� */
	popm.a	#4,r15						/* �X�N���b�`���W�X�^�𕜋A(r12,r13,r14,r15) */
	bic.w	#0x00F0,0(SP)				/* ���荞�ݕ��A���LPM1��Active�Ɏ��O�ɐݒ� */
	reti

ret_int_1_d:
	jmp		ret_int_1

ret_int_2:
	mova	&int_sp,sp

ret_int_3:
	/*
	 *  �����ւ́CCPU��O�n���h���̏o��������������򂵂Ă���D
	 *
	 *  �����ł́C�߂�悪�^�X�N�ł���C�X�^�b�N�́C��O�X�^�b�N�t���[
	 *  ���̏�ɃX�N���b�`���W�X�^�݂̂��ۑ����ꂽ��ԂɂȂ��Ă���D��
	 *  ���C�v���Z�b�T�́C�}�X�^���[�h�E�J�[�l���Ǘ��̊����݂��֎~����
	 *  ��ԂƂȂ��Ă���D
	 */
	clr.w	&reqflg						/* reqflg��false�� */

	/*
	 *  CPU���b�N��ԂɈڍs���C�����ݗD��x�}�X�N�������ݏ����O�̒l�ɐ�
	 *	�肷��D�J�[�l���Ǘ��̊����݂͂��łɋ֎~���Ă���̂ŁClock_flag
	 *  ��saved_iipm���X�V����Dsaved_iipm�́C�߂��̊����ݗD��x�}�X
	 *  �N�i�̓����\���j�ɐݒ肷��D
	 *
	 *  ���̎��_��CPU���b�N��ԂƂ���̂́Cdispatcher�֕��򂷂鎞�ƁC
	 *  call_texrtn���Ăяo�����ɁCCPU���b�N��ԂɂȂ��Ă���K�v������
	 *  ���߂ł���D
	 */
	mov.w	#1,&lock_flag				/* lock_flag��true�� */

	/*
	 *  dspflg��false�ł���ꍇ�ƁCp_runtsk��p_schedtsk�������ꍇ�ɂ́C
	 *  �f�B�X�p�b�`���s��Ȃ��D���̃`�F�b�N���K�v�Ȃ̂́C�^�X�N��O��
	 *  �����[�`���̌ďo�����K�v�ȏꍇ�ɁC�f�B�X�p�b�`���K�v�Ȃ��Ă��C
	 *  reqflg��true�ɂ��邽�߂ł���D
	 */
	mova	&p_runtsk,r12				/* p_runtsk��r12�� */
	tst.w	&dspflg						/* dspflg��false�Ȃ�ret_int_4�� */
	jeq		ret_int_4
	mova	&p_schedtsk,r13
	cmpa	r12,r13						/* p_runtsk��p_schedtsk�������Ȃ� */
	jeq		ret_int_4					/*                    ret_int_4�� */

	pushm.a	#8,r11						/* �c��̃��W�X�^��ۑ�(r11,r10,r9,r8,r7,r6,r5,r4) */
	mova	sp,TCB_msp(r12)				/* �^�X�N�X�^�b�N��ۑ� */
	mova	#ret_int_r,r13
	mova	r13,TCB_pc(r12)				/* ���s�ĊJ�Ԓn��ۑ� */
	jmp		dispatcher

ret_int_r:
	popm.a	#8,r11						/* ���W�X�^�𕜋A(r4,r5,r6,r7,r8,r9,r10,r11) */

ret_int_4:
	/*
	 *  enatex��true�ŁCtexptn��0�łȂ��Cipmflg��true�ł���΁C�^�X�N
	 *  ��O�������[�`�����Ăяo���D
	 */
	bit.w	#TCB_enatex_bit, TCB_enatex(r12)
	jeq		ret_int_5					/* enatex��false�Ȃ�ret_int_5�� */
	tst.w	TCB_texptn(r12)				/* texptn��0�Ȃ�ret_int_5�� */
	jeq		ret_int_5
	tst.w	&ipmflg						/* ipmflg��false�Ȃ�ret_int_5�� */
	jeq		ret_int_5
	calla	#call_texrtn				/*  �^�X�N��O�������[�`���̌ďo�� */

ret_int_5:
	/*
	 *  �����ݏ�������̃��^�[���ɂ��CCPU���b�N������ԂɈڍs�����
	 *  ����������D�����ݗD��x�}�X�N�́CRTE���߂ɂ�茳�̒l�ɖ߂邽
	 *  �߁Clock_flag��false�ɂ��Ă����΂悢�D
	 */
	clr.w	&lock_flag					/* CPU���b�N�����̏��� */
	popm.a	#4,r15						/* �X�N���b�`���W�X�^�𕜋A(r12,r13,r14,r15) */
	bic.w	#0x00F0,0(SP)				/* ���荞�ݕ��A���LPM1��Active�Ɏ��O�ɐݒ� */
	reti