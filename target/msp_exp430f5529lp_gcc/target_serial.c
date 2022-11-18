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
 *		�V���A��I/O�f�o�C�X�iSIO�j�h���C�o�imsp-exp430f5529lp�p�j
 */

#include <kernel.h>
#include <t_syslog.h>
#include "driverlib.h"
#include "target_syssvc.h"
#include "target_serial.h"

/*
 * ���W�X�^�ݒ�l
 */
#define INDEX_PORT(x)   ((x) - 1)
#define GET_SIOPCB(x)   (&siopcb_table[INDEX_PORT(x)])

/*
 *  �V���A���|�[�g�̊Ǘ��u���b�N
 */
struct sio_port_control_block {
    ID port;
    uint16_t reg;
    intptr_t exinf;
};

/*
 * �V���A��I/O�|�[�g�Ǘ��u���b�N�G���A
 */
SIOPCB siopcb_table[TNUM_PORT];

static const uint32_t sioreg_table[TNUM_PORT] = {
    USCI_A1_BASE,
};

/*
 *  SIO�h���C�o�̏�����
 */
void
sio_initialize(intptr_t exinf)
{
    int i;

    for (i = 0; i < TNUM_PORT; i++) {
        siopcb_table[i].port = i;
        siopcb_table[i].reg = sioreg_table[i];
        siopcb_table[i].exinf = 0;
    }
}

/*
 *  �V���A��I/O�|�[�g�̃I�[�v��
 */
SIOPCB *
sio_opn_por(ID siopid, intptr_t exinf)
{
	SIOPCB	*siopcb;
//	bool_t	opnflg;
//	ER		ercd;

    if (siopid > TNUM_PORT) {
        return NULL;
    }

    siopcb = GET_SIOPCB(siopid);
    siopcb->exinf = exinf;

/*
    USCI_A_UART_disable(siopcb->reg);

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

    USCI_A_UART_init(siopcb->reg, &param);

    //Enable UART module for operation
    USCI_A_UART_enable(siopcb->reg);

    //Disable Receive Interrupt
    USCI_A_UART_clearInterrupt(
            siopcb->reg,
            USCI_A_UART_TRANSMIT_INTERRUPT
    );
    USCI_A_UART_clearInterrupt(
            siopcb->reg,
            USCI_A_UART_RECEIVE_INTERRUPT
    );
*/
/*
    USCI_A_UART_disableInterrupt(
            siopcb->reg,
            USCI_A_UART_TRANSMIT_INTERRUPT
    );
    USCI_A_UART_disableInterrupt(
            siopcb->reg,
            USCI_A_UART_RECEIVE_INTERRUPT
    );
*/
    return(siopcb);
}

/*
 *  �V���A��I/O�|�[�g�̃N���[�Y
 */
void
sio_cls_por(SIOPCB *p_siopcb)
{
    //Disable Receive Interrupt
    USCI_A_UART_disableInterrupt(
            p_siopcb->reg,
            USCI_A_UART_TRANSMIT_INTERRUPT
    );
    USCI_A_UART_disableInterrupt(
            p_siopcb->reg,
            USCI_A_UART_RECEIVE_INTERRUPT
    );
    USCI_A_UART_disable(p_siopcb->reg);
}

/*
 *  SIO�̊����݃T�[�r�X���[�`��
 */
void
sio_isr(intptr_t exinf)
{
    SIOPCB* siopcb = GET_SIOPCB(exinf);

    if (USCI_A_UART_getInterruptStatus(siopcb->reg, USCI_A_UART_RECEIVE_INTERRUPT_FLAG)) {
        sio_irdy_rcv(siopcb->exinf);
    } else {
        USCI_A_UART_clearInterrupt(siopcb->reg, USCI_A_UART_TRANSMIT_INTERRUPT_FLAG);
        sio_irdy_snd(siopcb->exinf);
    }
}

/*
 *  �V���A��I/O�|�[�g�ւ̕������M
 */
bool_t
sio_snd_chr(SIOPCB *siopcb, char c)
{
    USCI_A_UART_transmitData(siopcb->reg, c);
	return true;
}

/*
 *  �V���A��I/O�|�[�g����̕�����M
 */
int_t
sio_rcv_chr(SIOPCB *siopcb)
{
    int_t c = -1;

    c = USCI_A_UART_receiveData(siopcb->reg);

	return c;
}

/*
 *  �V���A��I/O�|�[�g����̃R�[���o�b�N�̋���
 */
void
sio_ena_cbr(SIOPCB *siopcb, uint_t cbrtn)
{
    switch (cbrtn) {
    case SIO_RDY_SND:
        USCI_A_UART_enableInterrupt(
                siopcb->reg,
                USCI_A_UART_TRANSMIT_INTERRUPT
        );
        break;
    case SIO_RDY_RCV:
        USCI_A_UART_enableInterrupt(
                siopcb->reg,
                USCI_A_UART_RECEIVE_INTERRUPT
        );
        break;
    default:
        break;
    }
}

/*
 *  �V���A��I/O�|�[�g����̃R�[���o�b�N�̋֎~
 */
void
sio_dis_cbr(SIOPCB *siopcb, uint_t cbrtn)
{
    switch (cbrtn) {
    case SIO_RDY_SND:
        USCI_A_UART_disableInterrupt(
                siopcb->reg,
                USCI_A_UART_TRANSMIT_INTERRUPT
        );
        break;
    case SIO_RDY_RCV:
        USCI_A_UART_disableInterrupt(
                siopcb->reg,
                USCI_A_UART_RECEIVE_INTERRUPT
        );
        break;
    default:
        break;
    }
}
