/*
 *  TOPPERS/ASP Kernel
 *      Toyohashi Open Platform for Embedded Real-Time Systems/
 *      Advanced Standard Profile Kernel
 *
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
 *	2022/10/12 Ryutaro Morita
 */

/*
 *		�^�C�}�h���C�o�imsp-exp430f5529lp�p�j
 */

#include "kernel_impl.h"
#include "time_event.h"
#include <sil.h>
#include "target_timer.h"
#include "driverlib.h"

/*
 *  �^�C�}�̋N������
 */
void
target_timer_initialize(intptr_t exinf)
{
	CLOCK	cyc = TO_CLOCK(TIC_NUME, TIC_DENO);

	/*
	 *  �^�C�}������ݒ肵�C�^�C�}�̓�����J�n����D
	 */
	assert(cyc <= MAX_CLOCK);

    Timer_A_clearTimerInterrupt(TIMER_A0_BASE);

    Timer_A_initUpModeParam param = {0};
        param.clockSource = TIMER_A_CLOCKSOURCE_SMCLK;
        param.clockSourceDivider = TIMER_A_CLOCKSOURCE_DIVIDER_32;
        // count up to the following number (period)
        param.timerPeriod = (uint16_t)cyc;
        param.timerInterruptEnable_TAIE = TIMER_A_TAIE_INTERRUPT_DISABLE;
        param.captureCompareInterruptEnable_CCR0_CCIE =
                TIMER_A_CAPTURECOMPARE_INTERRUPT_ENABLE;
        param.timerClear = TIMER_A_DO_CLEAR;
        param.startTimer = true;

    Timer_A_initUpMode(TIMER_A0_BASE, &param);

	/*
	 *  �^�C�}�����ݗv�����N���A����D
	 */
	x_clear_int(INTNO_TIMER);
}

/*
 *  �^�C�}�̒�~����
 */
void
target_timer_terminate(intptr_t exinf)
{
	/*
	 *  �^�C�}�̓�����~����D
	 */
//	dga_write((void *) TADR_DGA_CSR12, CSR12_STOP);
}

/*
 *  �^�C�}�����݃n���h��
 */
void
target_timer_handler(void)
{
	i_begin_int(INTNO_TIMER);
	signal_time();					/* �^�C���e�B�b�N�̋��� */
	i_end_int(INTNO_TIMER);
}