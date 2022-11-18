/*
 *  TOPPERS/ASP Kernel
 *      Toyohashi Open Platform for Embedded Real-Time Systems/
 *      Advanced Standard Profile Kernel
 *
 *  Copyright (C) 2000-2003 by Embedded and Real-Time Systems Laboratory
 *                              Toyohashi Univ. of Technology, JAPAN
 *  Copyright (C) 2005-2011 by Embedded and Real-Time Systems Laboratory
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
 *		�^�[�Q�b�g�ˑ����W���[���imsp-exp430f5529lp�p�j
 */

#include "kernel_impl.h"
#include <sil.h>
#include <msp430.h>
#include "driverlib.h"

/*
 *  �v���Z�b�T���ʂ̂��߂̕ϐ��i�}���`�v���Z�b�T�Ή��j
 */
uint_t	board_id;			/* �{�[�hID */
void	*board_addr;		/* ���[�J���������̐擪�A�h���X */

/*
 *  �N�����̃n�[�h�E�F�A����������
 */
void
hardware_init_hook(void) {
    //Stop WDT
    WDT_A_hold(WDT_A_BASE);
}

void
usart_early_init()
{
	GPIO_setAsPeripheralModuleFunctionInputPin(
			GPIO_PORT_P4,
			GPIO_PIN4+GPIO_PIN5
	);

	// From Table 36-4 in the family user's manual where UCOS16 = 0 and
	//            baudrate = 9600
	//            clock freq = 4MHz
	// UCBRx = 416, UCBRFx = 6, UCBRSx = 0, UCOS16 = 0
	// http://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/MSP430BaudRateConverter/index.html
	USCI_A_UART_initParam param = {0};
	param.selectClockSource = USCI_A_UART_CLOCKSOURCE_SMCLK;
	param.clockPrescalar = 416;                                             // UCBRx
	param.firstModReg = 6;                                                  // UCBRFx
	param.secondModReg = 0;                                                 // UCBRSx
	param.parity = USCI_A_UART_NO_PARITY;
	param.msborLsbFirst = USCI_A_UART_LSB_FIRST;
	param.numberofStopBits = USCI_A_UART_ONE_STOP_BIT;
	param.uartMode = USCI_A_UART_MODE;
	param.overSampling = USCI_A_UART_LOW_FREQUENCY_BAUDRATE_GENERATION;     // UCOS16 = 0

	USCI_A_UART_init(USCI_A1_BASE, &param);

	//Enable UART module for operation
	USCI_A_UART_enable(USCI_A1_BASE);
}

/*
 *  �^�[�Q�b�g�ˑ��̏�����
 */
// for Debug
uint32_t mclk = 0;
uint32_t smclk = 0;
uint32_t aclk = 0;
void
target_initialize(void)
{
	/*
	 *  �v���Z�b�T�ˑ��̏�����
	 */
	prc_initialize();

	/*
	 *  �R�A�d�̓��[�h�̏�����
	 */
	// up to  8 MHz => PMM_CORE_LEVEL_0
	// up to 12 MHz => PMM_CORE_LEVEL_1
	// up to 20 MHz => PMM_CORE_LEVEL_2
	// up to 25 MHz => PMM_CORE_LEVEL_3
	PMM_setVCore(PMM_CORE_LEVEL_3);

    /*
     *  GPIO�̏�����
     */
	//P1.0 output ACLK
    // Important First Steps: Configure Pins for Crystals!
    // All to port P5
    // PIN5 -> XT1 OUT
    // PIN4 -> XT1 IN
    // PIN3 -> XT2 OUT
    // PIN2 -> XT2 IN
    GPIO_setAsPeripheralModuleFunctionInputPin(
        GPIO_PORT_P5,
        GPIO_PIN4+GPIO_PIN2
    );
    GPIO_setAsPeripheralModuleFunctionOutputPin(
        GPIO_PORT_P5,
        GPIO_PIN5+GPIO_PIN3
    );

    /*
     *  �N���b�N�̏�����
     */
	// Inform the system of the crystal frequencie
    UCS_setExternalClockSource(
       32768,               // Frequency of XT1 in Hz.
       4000000              // Frequency of XT2 in Hz.
    );

    // Initialize the crystals
    UCS_turnOnXT2(
       UCS_XT2_DRIVE_4MHZ_8MHZ
    );
    UCS_turnOnLFXT1(
        UCS_XT1_DRIVE_0,
        UCS_XCAP_3
    );

    UCS_initClockSignal(
        UCS_FLLREF,         // The reference for Frequency Locked Loop
        UCS_XT2CLK_SELECT,  // Select XT2
//        UCS_XT1CLK_SELECT,  // Select XT1
//        UCS_DCOCLK_SELECT,
        UCS_CLOCK_DIVIDER_4 // FLL ref. will be 1MHz (4MHz XT2/4)
    );
    UCS_initFLLSettle(
        24000000/1000,
        24000000/(4000000/4)
//        25000000/(32000)
    );

    // MCLK = 24MHz
    UCS_initClockSignal(
        UCS_MCLK,
        UCS_DCOCLK_SELECT,
        UCS_CLOCK_DIVIDER_1
    );

    // SMCLK = 4MHz
    UCS_initClockSignal(
        UCS_SMCLK,
        UCS_XT2CLK_SELECT,
        UCS_CLOCK_DIVIDER_1
    );

    // ACLK = 32.768kHz
    UCS_initClockSignal(
        UCS_ACLK,
        UCS_XT1CLK_SELECT,
//        UCS_XT2CLK_SELECT,
        UCS_CLOCK_DIVIDER_1
    );

    // for Debug
    aclk=UCS_getACLK();
    mclk=UCS_getMCLK();
    smclk=UCS_getSMCLK();

    usart_early_init();
}

/*
 *  �^�[�Q�b�g�ˑ��̏I������
 */
void
target_exit(void)
{
	/*
	 *  �v���Z�b�T�ˑ��̏I������
	 */
	prc_terminate();
	while(1);
}

/*
 *  �V�X�e�����O�̒჌�x���o�͂̂��߂̕����o��
 */
void
target_fput_log(char c)
{
    if (c == '\n') {
        USCI_A_UART_transmitData(USCI_A1_BASE, '\r');
    }
    USCI_A_UART_transmitData(USCI_A1_BASE, c);
    while (USCI_A_UART_queryStatusFlags(USCI_A1_BASE, USCI_A_UART_BUSY));
}

/*
 *  �����ݗv�����C���̑����̐ݒ�
 *
 *  ASP�J�[�l���ł̗��p��z�肵�āC�p�����[�^�G���[�̓A�T�[�V�����Ń`�F�b
 *  �N���Ă���Dcfg_int�T�[�r�X�R�[����݂���ꍇ�ɂ́C�G���[��Ԃ��悤
 *  �ɂ��ׂ��ł��낤�D
 */
void
x_config_int(INTNO intno, ATR intatr, PRI intpri)
{
	assert(VALID_INTNO_CFGINT(intno));
	assert(TMIN_INTPRI <= intpri && intpri <= TMAX_INTPRI);
}
