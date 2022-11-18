/*
 *  TOPPERS Software
 *      Toyohashi Open Platform for Embedded Real-Time Systems
 *
 *  Copyright (C) 2000-2003 by Embedded and Real-Time Systems Laboratory
 *                              Toyohashi Univ. of Technology, JAPAN
 *  Copyright (C) 2005,2006 by Embedded and Real-Time Systems Laboratory
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
 *  @(#) $Id: start.S 2728 2015-12-30 01:46:11Z ertl-honda $
 */

/*
 *		�J�[�l���Ή��̃X�^�[�g�A�b�v���W���[���imsp430x�p�j
 */
#define	TOPPERS_MACRO_ONLY
#include "kernel_impl.h"

	.section .handlers,"a"
	.global	start
start:
	/*
	 *  �v���Z�b�T���[�h�ƃX�^�b�N�|�C���^�̏�����
	 */
;	mova	#0x4400,r1
	mova	&_kernel_istkpt,sp

	/*
	 *  hardware_init_hook�̌ďo���i0�łȂ��ꍇ�j
	 *
	 *  �^�[�Q�b�g�n�[�h�E�F�A�Ɉˑ����ĕK�v�ȏ���������������ꍇ�́C
	 *  hardware_init_hook�Ƃ����֐���p�ӂ���D
	 */
	mova	#hardware_init_hook,r12
	tsta	r12
	jeq		0f
	calla	r12
0:

	/*
	 *  data�Z�N�V�����̏������iROM���Ή��j
	 */
	mova	#__idata_start, r12
	mov.w	#__data_start, r13
	mov.w	#__data_end, r14
	jmp		2f
1:
	mov.w	@r12+,r15
	mov.w	r15,@r13
	add.w	#2,r13
2:
	cmp		r13,r14
	jne		1b

	/*
	 *  bss�Z�N�V�����̃N���A
	 */
	mova	#__bss_start, r13
	mov.w	#__bss_end, r14
	clr.w	r12
	jmp		4f
3:
	mov.w	r12,@r13
	add.w	#2,r13
4:
	cmp		r13,r14
	jne		3b

	/*
	 *  software_init_hook�̌ďo���i0�łȂ��ꍇ�j
	 *
	 *  �\�t�g�E�F�A���i���Ƀ��C�u�����j�Ɉˑ����ĕK�v�ȏ�����������
	 *  ����ꍇ�́Csoftware_init_hook�Ƃ����֐���p�ӂ���΂悢�D
	 */
	mova	#software_init_hook,r12
	tsta	r12
	jeq		5f
	calla	r12
5:

	bra		#sta_ker