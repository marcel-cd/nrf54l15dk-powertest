export ZEPHYR_TOOLCHAIN_VARIANT := zephyr
export ZEPHYR_SDK_INSTALL_DIR := ${HOME}/_bin/zephyr-sdk-0.17.0
export ZEPHYR_BASE := ${HOME}/_dev/_lib/ncs_2_8_0/zephyr
PATH := ${PATH}:${ZEPHYR_BASE}/scripts:
JLINK_ROOT := /usr/bin


ifndef ZEPHYR_BASE
$(error The ZEPHYR_BASE environment variable must be set)
endif

JLINK_SERIAL := 1057728293
BOARD ?= nrf54l15dk/nrf54l15/cpuflpr
BUILDDIR ?= build

# multi-os support
ifdef OS
   # Windows commands
   RMDIR = rmdir /s /q
else
   ifeq ($(shell uname), Linux)
      # Linux commands
      RMDIR = rm -rf
   endif
endif

.PHONY: build debug-build flash recover clean index

# targets
# ---------------------------------------------------------------------------
build:
	west config build.cmake-args -- "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" && west build -p -o=-j0 -b ${BOARD} --build-dir ${BUILDDIR} --sysbuild -- -DSB_CONFIG_VPR_LAUNCHER=n

recover:
	west flash --recover -i ${JLINK_SERIAL} --build-dir ${BUILDDIR}

flash:
	west flash -i ${JLINK_SERIAL} --build-dir ${BUILDDIR}

clean:
	$(RMDIR) $(BUILDDIR)

clean-test:
	$(RM_TWISTER)

ztest:
	$(ZTEST)

utest:
	$(UTEST)
