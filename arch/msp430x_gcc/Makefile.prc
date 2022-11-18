#
#		Makefile�̃v���Z�b�T�ˑ����imsp430x�p�j
#

#
#  GNU�J�����̃^�[�Q�b�g�A�[�L�e�N�`���̒�`
#
GCC_TARGET = msp430-elf

#
#  �v���Z�b�T�ˑ����f�B���N�g�����̒�`
#
PRCDIR = $(SRCDIR)/arch/$(PRC)_$(TOOL)

#
#  �R���p�C���I�v�V����
#
INCLUDES := $(INCLUDES) \
		    -I$(SRCDIR)/arch/$(PRC)_$(TOOL)/include_gcc \
			-I$(SRCDIR)/arch/$(PRC)_$(TOOL)/driverlib/MSP430F5xx_6xx
COPTS := $(COPTS) -mhwmult=f5series -mmcu=msp430f5529 -mlarge -mcode-region=none -mdata-region=lower \
			-Wno-int-to-pointer-cast \
			-Wno-maybe-uninitialized \
			-Wno-parentheses
LDFLAGS := $(LDFLAGS) -nostartfiles

#
#  �J�[�l���Ɋւ����`
#
KERNEL_DIR := $(KERNEL_DIR) $(PRCDIR) \
			  $(SRCDIR)/arch/$(PRC)_$(TOOL)/driverlib/MSP430F5xx_6xx
KERNEL_ASMOBJS := $(KERNEL_ASMOBJS) prc_support.o
KERNEL_COBJS := $(KERNEL_COBJS) prc_config.o

#
#  �R���t�B�M�����[�^�֌W�̕ϐ��̒�`
#
CFG_TABS := $(CFG_TABS) --cfg1-def-table $(PRCDIR)/prc_def.csv

#
#  �I�t�Z�b�g�t�@�C�������̂��߂̒�`
#
OFFSET_TF = $(PRCDIR)/prc_offset.tf
