# main project target
CFLAGS += -I./h8ball -DBOARD=maple_mini -DFIXED_POINT=16 $(LIBMAPLE_INCLUDES) $(WIRISH_INCLUDES)
SRCROOT := h8ball

#$(BUILD_PATH)/%.o: %.c
#	mkdir -p `dirname $@`; $(CXX) $(CFLAGS) $(EXTRA_INCLUDES) $(CXXFLAGS) $(LIBMAPLE_INCLUDES) $(WIRISH_INCLUDES) -o $@ -c $< 
#$(BUILD_PATH)/%.o: %.cpp
#	mkdir -p `dirname $@`; $(CXX) $(CFLAGS) $(EXTRA_INCLUDES) $(CXXFLAGS) $(LIBMAPLE_INCLUDES) $(WIRISH_INCLUDES) -o $@ -c $< 

H8BALL_OBJECTS := \
	$(BUILD_PATH)/$(SRCROOT)/Adafruit_ILI9340.o \
	$(BUILD_PATH)/$(SRCROOT)/Adafruit_GFX.o \
	$(BUILD_PATH)/$(SRCROOT)/kiss_fftr.o \
	$(BUILD_PATH)/$(SRCROOT)/kiss_fft.o \
	$(BUILD_PATH)/$(SRCROOT)/Sd2Card.o \
	$(BUILD_PATH)/$(SRCROOT)/SdFile.o \
	$(BUILD_PATH)/$(SRCROOT)/SdVolume.o \
	$(BUILD_PATH)/$(SRCROOT)/h8ball.o 
TGT_BIN += $(H8BALL_OBJECTS)

$(BUILD_PATH)/libmaple.a: $(BUILDDIRS) $(TGT_BIN)
	- rm -f $@
	$(AR) crv $(BUILD_PATH)/libmaple.a $(TGT_BIN)

library: $(BUILD_PATH)/libmaple.a

depends:
	makedepend -p$(BUILD_PATH)/ -fbuild-targets.mk -- $(CFLAGS) $(EXTRA_INCLUDES) $(LIBMAPLE_INCLUDES) $(WIRISH_INCLUDES) -- $(SRCROOT)/*.c $(SRCROOT)/*.cpp $(SRCROOT)/*.h wirish/*.cpp wirish/*.h wirish/*.c

.PHONY: library depends

$(BUILD_PATH)/$(BOARD).elf: $(BUILDDIRS) $(TGT_BIN) 
	$(CXX) $(LDFLAGS) -o $@ -L$(BUILD_PATH) $(TGT_BIN) -Wl,-Map,$(BUILD_PATH)/$(BOARD).map

$(BUILD_PATH)/$(BOARD).bin: $(BUILD_PATH)/$(BOARD).elf
	$(SILENT_OBJCOPY) $(OBJCOPY) -v -Obinary $(BUILD_PATH)/$(BOARD).elf $@ 1>/dev/null
	$(SILENT_DISAS) $(DISAS) -d $(BUILD_PATH)/$(BOARD).elf > $(BUILD_PATH)/$(BOARD).disas
	@echo " "
	@echo "Object file sizes:"
	@find $(BUILD_PATH) -iname *.o | xargs $(SIZE) -t > $(BUILD_PATH)/$(BOARD).sizes
	@cat $(BUILD_PATH)/$(BOARD).sizes
	@echo " "
	@echo "Final Size:"
	@$(SIZE) $<
	@echo $(MEMORY_TARGET) > $(BUILD_PATH)/build-type

$(BUILDDIRS):
	@mkdir -p $@

MSG_INFO:
	@echo "================================================================================"
	@echo ""
	@echo "  Build info:"
	@echo "     BOARD:          " $(BOARD)
	@echo "     MCU:            " $(MCU)
	@echo "     MEMORY_TARGET:  " $(MEMORY_TARGET)
	@echo ""
	@echo "  See 'make help' for all possible targets"
	@echo ""
	@echo "================================================================================"
	@echo ""
# DO NOT DELETE

build/h8ball/kiss_fft.o: h8ball/_kiss_fft_guts.h h8ball/kiss_fft.h
build/h8ball/kiss_fft.o: /usr/include/stdint.h /usr/include/stdlib.h
build/h8ball/kiss_fft.o: /usr/include/Availability.h
build/h8ball/kiss_fft.o: /usr/include/AvailabilityInternal.h
build/h8ball/kiss_fft.o: /usr/include/_types.h /usr/include/sys/_types.h
build/h8ball/kiss_fft.o: /usr/include/sys/cdefs.h
build/h8ball/kiss_fft.o: /usr/include/sys/_symbol_aliasing.h
build/h8ball/kiss_fft.o: /usr/include/sys/_posix_availability.h
build/h8ball/kiss_fft.o: /usr/include/machine/_types.h
build/h8ball/kiss_fft.o: /usr/include/i386/_types.h /usr/include/sys/wait.h
build/h8ball/kiss_fft.o: /usr/include/sys/signal.h
build/h8ball/kiss_fft.o: /usr/include/sys/appleapiopts.h
build/h8ball/kiss_fft.o: /usr/include/machine/signal.h
build/h8ball/kiss_fft.o: /usr/include/i386/signal.h
build/h8ball/kiss_fft.o: /usr/include/i386/_structs.h
build/h8ball/kiss_fft.o: /usr/include/sys/_structs.h
build/h8ball/kiss_fft.o: /usr/include/machine/_structs.h
build/h8ball/kiss_fft.o: /usr/include/sys/resource.h
build/h8ball/kiss_fft.o: /usr/include/machine/endian.h
build/h8ball/kiss_fft.o: /usr/include/i386/endian.h
build/h8ball/kiss_fft.o: /usr/include/sys/_endian.h
build/h8ball/kiss_fft.o: /usr/include/libkern/_OSByteOrder.h
build/h8ball/kiss_fft.o: /usr/include/libkern/i386/_OSByteOrder.h
build/h8ball/kiss_fft.o: /usr/include/alloca.h /usr/include/machine/types.h
build/h8ball/kiss_fft.o: /usr/include/i386/types.h /usr/include/stdio.h
build/h8ball/kiss_fft.o: /usr/include/secure/_stdio.h
build/h8ball/kiss_fft.o: /usr/include/secure/_common.h /usr/include/math.h
build/h8ball/kiss_fft.o: /usr/include/string.h /usr/include/strings.h
build/h8ball/kiss_fft.o: /usr/include/secure/_string.h
build/h8ball/kiss_fft.o: /usr/include/sys/types.h /usr/include/limits.h
build/h8ball/kiss_fft.o: /usr/include/machine/limits.h
build/h8ball/kiss_fft.o: /usr/include/i386/limits.h
build/h8ball/kiss_fft.o: /usr/include/i386/_limits.h
build/h8ball/kiss_fft.o: /usr/include/sys/syslimits.h
build/h8ball/kiss_fft.o: ./wirish/include/wirish/wirish.h
build/h8ball/kiss_fft.o: ./libmaple/include/libmaple/stm32.h
build/h8ball/kiss_fft.o: ./libmaple/stm32f1/include/series/stm32.h
build/h8ball/kiss_fft.o: ./wirish/include/wirish/boards.h
build/h8ball/kiss_fft.o: ./libmaple/include/libmaple/libmaple_types.h
build/h8ball/kiss_fft.o: ./wirish/include/wirish/wirish_types.h
build/h8ball/kiss_fft.o: ./libmaple/include/libmaple/gpio.h
build/h8ball/kiss_fft.o: ./libmaple/stm32f1/include/series/gpio.h
build/h8ball/kiss_fft.o: ./libmaple/include/libmaple/exti.h
build/h8ball/kiss_fft.o: ./libmaple/stm32f1/include/series/exti.h
build/h8ball/kiss_fft.o: ./libmaple/include/libmaple/rcc.h
build/h8ball/kiss_fft.o: ./libmaple/stm32f1/include/series/rcc.h
build/h8ball/kiss_fft.o: ./libmaple/include/libmaple/timer.h
build/h8ball/kiss_fft.o: ./libmaple/stm32f1/include/series/timer.h
build/h8ball/kiss_fft.o: ./libmaple/include/libmaple/libmaple.h
build/h8ball/kiss_fft.o: ./libmaple/include/libmaple/util.h
build/h8ball/kiss_fft.o: ./libmaple/include/libmaple/delay.h
build/h8ball/kiss_fft.o: ./libmaple/include/libmaple/nvic.h
build/h8ball/kiss_fft.o: ./libmaple/stm32f1/include/series/nvic.h
build/h8ball/kiss_fft.o: ./libmaple/include/libmaple/bitband.h
build/h8ball/kiss_fft.o: ./libmaple/include/libmaple/adc.h
build/h8ball/kiss_fft.o: ./libmaple/stm32f1/include/series/adc.h
build/h8ball/kiss_fft.o: ./wirish/boards/maple_mini/include/board/board.h
build/h8ball/kiss_fft.o: ./wirish/include/wirish/io.h
build/h8ball/kiss_fft.o: ./wirish/include/wirish/bit_constants.h
build/h8ball/kiss_fft.o: ./wirish/include/wirish/pwm.h
build/h8ball/kiss_fft.o: ./wirish/include/wirish/ext_interrupts.h
build/h8ball/kiss_fft.o: ./wirish/include/wirish/wirish_debug.h
build/h8ball/kiss_fft.o: ./wirish/include/wirish/wirish_math.h
build/h8ball/kiss_fft.o: ./wirish/include/wirish/wirish_time.h
build/h8ball/kiss_fft.o: ./libmaple/include/libmaple/systick.h
build/h8ball/kiss_fft.o: ./wirish/include/wirish/HardwareSPI.h
build/h8ball/kiss_fft.o: ./libmaple/include/libmaple/spi.h
build/h8ball/kiss_fft.o: ./libmaple/stm32f1/include/series/spi.h
build/h8ball/kiss_fft.o: ./wirish/include/wirish/HardwareSerial.h
build/h8ball/kiss_fft.o: ./wirish/include/wirish/Print.h
build/h8ball/kiss_fft.o: ./wirish/include/wirish/HardwareTimer.h
build/h8ball/kiss_fft.o: ./wirish/include/wirish/usb_serial.h
build/h8ball/kiss_fftr.o: h8ball/kiss_fftr.h /usr/include/stdint.h
build/h8ball/kiss_fftr.o: h8ball/kiss_fft.h /usr/include/stdlib.h
build/h8ball/kiss_fftr.o: /usr/include/Availability.h
build/h8ball/kiss_fftr.o: /usr/include/AvailabilityInternal.h
build/h8ball/kiss_fftr.o: /usr/include/_types.h /usr/include/sys/_types.h
build/h8ball/kiss_fftr.o: /usr/include/sys/cdefs.h
build/h8ball/kiss_fftr.o: /usr/include/sys/_symbol_aliasing.h
build/h8ball/kiss_fftr.o: /usr/include/sys/_posix_availability.h
build/h8ball/kiss_fftr.o: /usr/include/machine/_types.h
build/h8ball/kiss_fftr.o: /usr/include/i386/_types.h /usr/include/sys/wait.h
build/h8ball/kiss_fftr.o: /usr/include/sys/signal.h
build/h8ball/kiss_fftr.o: /usr/include/sys/appleapiopts.h
build/h8ball/kiss_fftr.o: /usr/include/machine/signal.h
build/h8ball/kiss_fftr.o: /usr/include/i386/signal.h
build/h8ball/kiss_fftr.o: /usr/include/i386/_structs.h
build/h8ball/kiss_fftr.o: /usr/include/sys/_structs.h
build/h8ball/kiss_fftr.o: /usr/include/machine/_structs.h
build/h8ball/kiss_fftr.o: /usr/include/sys/resource.h
build/h8ball/kiss_fftr.o: /usr/include/machine/endian.h
build/h8ball/kiss_fftr.o: /usr/include/i386/endian.h
build/h8ball/kiss_fftr.o: /usr/include/sys/_endian.h
build/h8ball/kiss_fftr.o: /usr/include/libkern/_OSByteOrder.h
build/h8ball/kiss_fftr.o: /usr/include/libkern/i386/_OSByteOrder.h
build/h8ball/kiss_fftr.o: /usr/include/alloca.h /usr/include/machine/types.h
build/h8ball/kiss_fftr.o: /usr/include/i386/types.h /usr/include/stdio.h
build/h8ball/kiss_fftr.o: /usr/include/secure/_stdio.h
build/h8ball/kiss_fftr.o: /usr/include/secure/_common.h /usr/include/math.h
build/h8ball/kiss_fftr.o: /usr/include/string.h /usr/include/strings.h
build/h8ball/kiss_fftr.o: /usr/include/secure/_string.h
build/h8ball/kiss_fftr.o: /usr/include/sys/types.h h8ball/_kiss_fft_guts.h
build/h8ball/kiss_fftr.o: /usr/include/limits.h /usr/include/machine/limits.h
build/h8ball/kiss_fftr.o: /usr/include/i386/limits.h
build/h8ball/kiss_fftr.o: /usr/include/i386/_limits.h
build/h8ball/kiss_fftr.o: /usr/include/sys/syslimits.h
build/h8ball/Adafruit_GFX.o: h8ball/Adafruit_GFX.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/WProgram.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/wirish.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/stm32.h
build/h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/stm32.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/boards.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/libmaple_types.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/wirish_types.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/gpio.h
build/h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/gpio.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/exti.h
build/h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/exti.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/rcc.h
build/h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/rcc.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/timer.h
build/h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/timer.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/libmaple.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/util.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/delay.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/nvic.h
build/h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/nvic.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/bitband.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/adc.h
build/h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/adc.h
build/h8ball/Adafruit_GFX.o: ./wirish/boards/maple_mini/include/board/board.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/io.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/bit_constants.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/pwm.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/ext_interrupts.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/wirish_debug.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/wirish_math.h
build/h8ball/Adafruit_GFX.o: /usr/include/math.h /usr/include/sys/cdefs.h
build/h8ball/Adafruit_GFX.o: /usr/include/sys/_symbol_aliasing.h
build/h8ball/Adafruit_GFX.o: /usr/include/sys/_posix_availability.h
build/h8ball/Adafruit_GFX.o: /usr/include/Availability.h
build/h8ball/Adafruit_GFX.o: /usr/include/AvailabilityInternal.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/wirish_time.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/systick.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/HardwareSPI.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/spi.h
build/h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/spi.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/HardwareSerial.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/Print.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/HardwareTimer.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/usb_serial.h
build/h8ball/Adafruit_GFX.o: /usr/include/stdint.h h8ball/glcdfont.c
build/h8ball/Adafruit_ILI9340.o: h8ball/Adafruit_ILI9340.h
build/h8ball/Adafruit_ILI9340.o: h8ball/Adafruit_GFX.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/WProgram.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/wirish.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/stm32.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/stm32.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/boards.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/libmaple_types.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/wirish_types.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/gpio.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/gpio.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/exti.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/exti.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/rcc.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/rcc.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/timer.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/timer.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/libmaple.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/util.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/delay.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/nvic.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/nvic.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/bitband.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/adc.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/adc.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/boards/maple_mini/include/board/board.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/io.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/bit_constants.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/pwm.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/ext_interrupts.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/wirish_debug.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/wirish_math.h
build/h8ball/Adafruit_ILI9340.o: /usr/include/math.h /usr/include/sys/cdefs.h
build/h8ball/Adafruit_ILI9340.o: /usr/include/sys/_symbol_aliasing.h
build/h8ball/Adafruit_ILI9340.o: /usr/include/sys/_posix_availability.h
build/h8ball/Adafruit_ILI9340.o: /usr/include/Availability.h
build/h8ball/Adafruit_ILI9340.o: /usr/include/AvailabilityInternal.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/wirish_time.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/systick.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/HardwareSPI.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/spi.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/spi.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/HardwareSerial.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/Print.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/HardwareTimer.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/usb_serial.h
build/h8ball/Adafruit_ILI9340.o: /usr/include/stdint.h /usr/include/limits.h
build/h8ball/Adafruit_ILI9340.o: /usr/include/machine/limits.h
build/h8ball/Adafruit_ILI9340.o: /usr/include/i386/limits.h
build/h8ball/Adafruit_ILI9340.o: /usr/include/i386/_limits.h
build/h8ball/Adafruit_ILI9340.o: /usr/include/sys/syslimits.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/SPI.h
build/h8ball/h8ball.o: /usr/include/stdint.h h8ball/kiss_fftr.h
build/h8ball/h8ball.o: h8ball/kiss_fft.h /usr/include/stdlib.h
build/h8ball/h8ball.o: /usr/include/Availability.h
build/h8ball/h8ball.o: /usr/include/AvailabilityInternal.h
build/h8ball/h8ball.o: /usr/include/_types.h /usr/include/sys/_types.h
build/h8ball/h8ball.o: /usr/include/sys/cdefs.h
build/h8ball/h8ball.o: /usr/include/sys/_symbol_aliasing.h
build/h8ball/h8ball.o: /usr/include/sys/_posix_availability.h
build/h8ball/h8ball.o: /usr/include/machine/_types.h
build/h8ball/h8ball.o: /usr/include/i386/_types.h /usr/include/sys/wait.h
build/h8ball/h8ball.o: /usr/include/sys/signal.h
build/h8ball/h8ball.o: /usr/include/sys/appleapiopts.h
build/h8ball/h8ball.o: /usr/include/machine/signal.h
build/h8ball/h8ball.o: /usr/include/i386/signal.h
build/h8ball/h8ball.o: /usr/include/i386/_structs.h
build/h8ball/h8ball.o: /usr/include/sys/_structs.h
build/h8ball/h8ball.o: /usr/include/machine/_structs.h
build/h8ball/h8ball.o: /usr/include/sys/resource.h
build/h8ball/h8ball.o: /usr/include/machine/endian.h
build/h8ball/h8ball.o: /usr/include/i386/endian.h /usr/include/sys/_endian.h
build/h8ball/h8ball.o: /usr/include/libkern/_OSByteOrder.h
build/h8ball/h8ball.o: /usr/include/libkern/i386/_OSByteOrder.h
build/h8ball/h8ball.o: /usr/include/alloca.h /usr/include/machine/types.h
build/h8ball/h8ball.o: /usr/include/i386/types.h /usr/include/stdio.h
build/h8ball/h8ball.o: /usr/include/secure/_stdio.h
build/h8ball/h8ball.o: /usr/include/secure/_common.h /usr/include/math.h
build/h8ball/h8ball.o: /usr/include/string.h /usr/include/strings.h
build/h8ball/h8ball.o: /usr/include/secure/_string.h /usr/include/sys/types.h
build/h8ball/h8ball.o: h8ball/RingBuffer.h ./wirish/include/wirish/wirish.h
build/h8ball/h8ball.o: ./libmaple/include/libmaple/stm32.h
build/h8ball/h8ball.o: ./libmaple/stm32f1/include/series/stm32.h
build/h8ball/h8ball.o: ./wirish/include/wirish/boards.h
build/h8ball/h8ball.o: ./libmaple/include/libmaple/libmaple_types.h
build/h8ball/h8ball.o: ./wirish/include/wirish/wirish_types.h
build/h8ball/h8ball.o: ./libmaple/include/libmaple/gpio.h
build/h8ball/h8ball.o: ./libmaple/stm32f1/include/series/gpio.h
build/h8ball/h8ball.o: ./libmaple/include/libmaple/exti.h
build/h8ball/h8ball.o: ./libmaple/stm32f1/include/series/exti.h
build/h8ball/h8ball.o: ./libmaple/include/libmaple/rcc.h
build/h8ball/h8ball.o: ./libmaple/stm32f1/include/series/rcc.h
build/h8ball/h8ball.o: ./libmaple/include/libmaple/timer.h
build/h8ball/h8ball.o: ./libmaple/stm32f1/include/series/timer.h
build/h8ball/h8ball.o: ./libmaple/include/libmaple/libmaple.h
build/h8ball/h8ball.o: ./libmaple/include/libmaple/util.h
build/h8ball/h8ball.o: ./libmaple/include/libmaple/delay.h
build/h8ball/h8ball.o: ./libmaple/include/libmaple/nvic.h
build/h8ball/h8ball.o: ./libmaple/stm32f1/include/series/nvic.h
build/h8ball/h8ball.o: ./libmaple/include/libmaple/bitband.h
build/h8ball/h8ball.o: ./libmaple/include/libmaple/adc.h
build/h8ball/h8ball.o: ./libmaple/stm32f1/include/series/adc.h
build/h8ball/h8ball.o: ./wirish/boards/maple_mini/include/board/board.h
build/h8ball/h8ball.o: ./wirish/include/wirish/io.h
build/h8ball/h8ball.o: ./wirish/include/wirish/bit_constants.h
build/h8ball/h8ball.o: ./wirish/include/wirish/pwm.h
build/h8ball/h8ball.o: ./wirish/include/wirish/ext_interrupts.h
build/h8ball/h8ball.o: ./wirish/include/wirish/wirish_debug.h
build/h8ball/h8ball.o: ./wirish/include/wirish/wirish_math.h
build/h8ball/h8ball.o: ./wirish/include/wirish/wirish_time.h
build/h8ball/h8ball.o: ./libmaple/include/libmaple/systick.h
build/h8ball/h8ball.o: ./wirish/include/wirish/HardwareSPI.h
build/h8ball/h8ball.o: ./libmaple/include/libmaple/spi.h
build/h8ball/h8ball.o: ./libmaple/stm32f1/include/series/spi.h
build/h8ball/h8ball.o: ./wirish/include/wirish/HardwareSerial.h
build/h8ball/h8ball.o: ./wirish/include/wirish/Print.h
build/h8ball/h8ball.o: ./wirish/include/wirish/HardwareTimer.h
build/h8ball/h8ball.o: ./wirish/include/wirish/usb_serial.h
build/h8ball/h8ball.o: ./libmaple/include/libmaple/SPI.h
build/h8ball/h8ball.o: h8ball/Adafruit_GFX.h
build/h8ball/h8ball.o: ./wirish/include/wirish/WProgram.h
build/h8ball/h8ball.o: h8ball/Adafruit_ILI9340.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/WProgram.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/wirish.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/stm32.h
build/h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/stm32.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/boards.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/libmaple_types.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/wirish_types.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/gpio.h
build/h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/gpio.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/exti.h
build/h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/exti.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/rcc.h
build/h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/rcc.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/timer.h
build/h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/timer.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/libmaple.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/util.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/delay.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/nvic.h
build/h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/nvic.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/bitband.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/adc.h
build/h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/adc.h
build/h8ball/Adafruit_GFX.o: ./wirish/boards/maple_mini/include/board/board.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/io.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/bit_constants.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/pwm.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/ext_interrupts.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/wirish_debug.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/wirish_math.h
build/h8ball/Adafruit_GFX.o: /usr/include/math.h /usr/include/sys/cdefs.h
build/h8ball/Adafruit_GFX.o: /usr/include/sys/_symbol_aliasing.h
build/h8ball/Adafruit_GFX.o: /usr/include/sys/_posix_availability.h
build/h8ball/Adafruit_GFX.o: /usr/include/Availability.h
build/h8ball/Adafruit_GFX.o: /usr/include/AvailabilityInternal.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/wirish_time.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/systick.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/HardwareSPI.h
build/h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/spi.h
build/h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/spi.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/HardwareSerial.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/Print.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/HardwareTimer.h
build/h8ball/Adafruit_GFX.o: ./wirish/include/wirish/usb_serial.h
build/h8ball/Adafruit_GFX.o: /usr/include/stdint.h
build/h8ball/Adafruit_ILI9340.o: h8ball/Adafruit_GFX.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/WProgram.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/wirish.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/stm32.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/stm32.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/boards.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/libmaple_types.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/wirish_types.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/gpio.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/gpio.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/exti.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/exti.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/rcc.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/rcc.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/timer.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/timer.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/libmaple.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/util.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/delay.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/nvic.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/nvic.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/bitband.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/adc.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/adc.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/boards/maple_mini/include/board/board.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/io.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/bit_constants.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/pwm.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/ext_interrupts.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/wirish_debug.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/wirish_math.h
build/h8ball/Adafruit_ILI9340.o: /usr/include/math.h /usr/include/sys/cdefs.h
build/h8ball/Adafruit_ILI9340.o: /usr/include/sys/_symbol_aliasing.h
build/h8ball/Adafruit_ILI9340.o: /usr/include/sys/_posix_availability.h
build/h8ball/Adafruit_ILI9340.o: /usr/include/Availability.h
build/h8ball/Adafruit_ILI9340.o: /usr/include/AvailabilityInternal.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/wirish_time.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/systick.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/HardwareSPI.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/spi.h
build/h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/spi.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/HardwareSerial.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/Print.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/HardwareTimer.h
build/h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/usb_serial.h
build/h8ball/Adafruit_ILI9340.o: /usr/include/stdint.h
build/h8ball/RingBuffer.o: /usr/include/stdint.h
build/h8ball/RingBuffer.o: ./wirish/include/wirish/wirish.h
build/h8ball/RingBuffer.o: ./libmaple/include/libmaple/stm32.h
build/h8ball/RingBuffer.o: ./libmaple/stm32f1/include/series/stm32.h
build/h8ball/RingBuffer.o: ./wirish/include/wirish/boards.h
build/h8ball/RingBuffer.o: ./libmaple/include/libmaple/libmaple_types.h
build/h8ball/RingBuffer.o: ./wirish/include/wirish/wirish_types.h
build/h8ball/RingBuffer.o: ./libmaple/include/libmaple/gpio.h
build/h8ball/RingBuffer.o: ./libmaple/stm32f1/include/series/gpio.h
build/h8ball/RingBuffer.o: ./libmaple/include/libmaple/exti.h
build/h8ball/RingBuffer.o: ./libmaple/stm32f1/include/series/exti.h
build/h8ball/RingBuffer.o: ./libmaple/include/libmaple/rcc.h
build/h8ball/RingBuffer.o: ./libmaple/stm32f1/include/series/rcc.h
build/h8ball/RingBuffer.o: ./libmaple/include/libmaple/timer.h
build/h8ball/RingBuffer.o: ./libmaple/stm32f1/include/series/timer.h
build/h8ball/RingBuffer.o: ./libmaple/include/libmaple/libmaple.h
build/h8ball/RingBuffer.o: ./libmaple/include/libmaple/util.h
build/h8ball/RingBuffer.o: ./libmaple/include/libmaple/delay.h
build/h8ball/RingBuffer.o: ./libmaple/include/libmaple/nvic.h
build/h8ball/RingBuffer.o: ./libmaple/stm32f1/include/series/nvic.h
build/h8ball/RingBuffer.o: ./libmaple/include/libmaple/bitband.h
build/h8ball/RingBuffer.o: ./libmaple/include/libmaple/adc.h
build/h8ball/RingBuffer.o: ./libmaple/stm32f1/include/series/adc.h
build/h8ball/RingBuffer.o: ./wirish/boards/maple_mini/include/board/board.h
build/h8ball/RingBuffer.o: ./wirish/include/wirish/io.h
build/h8ball/RingBuffer.o: ./wirish/include/wirish/bit_constants.h
build/h8ball/RingBuffer.o: ./wirish/include/wirish/pwm.h
build/h8ball/RingBuffer.o: ./wirish/include/wirish/ext_interrupts.h
build/h8ball/RingBuffer.o: ./wirish/include/wirish/wirish_debug.h
build/h8ball/RingBuffer.o: ./wirish/include/wirish/wirish_math.h
build/h8ball/RingBuffer.o: /usr/include/math.h /usr/include/sys/cdefs.h
build/h8ball/RingBuffer.o: /usr/include/sys/_symbol_aliasing.h
build/h8ball/RingBuffer.o: /usr/include/sys/_posix_availability.h
build/h8ball/RingBuffer.o: /usr/include/Availability.h
build/h8ball/RingBuffer.o: /usr/include/AvailabilityInternal.h
build/h8ball/RingBuffer.o: ./wirish/include/wirish/wirish_time.h
build/h8ball/RingBuffer.o: ./libmaple/include/libmaple/systick.h
build/h8ball/RingBuffer.o: ./wirish/include/wirish/HardwareSPI.h
build/h8ball/RingBuffer.o: ./libmaple/include/libmaple/spi.h
build/h8ball/RingBuffer.o: ./libmaple/stm32f1/include/series/spi.h
build/h8ball/RingBuffer.o: ./wirish/include/wirish/HardwareSerial.h
build/h8ball/RingBuffer.o: ./wirish/include/wirish/Print.h
build/h8ball/RingBuffer.o: ./wirish/include/wirish/HardwareTimer.h
build/h8ball/RingBuffer.o: ./wirish/include/wirish/usb_serial.h
build/h8ball/_kiss_fft_guts.o: h8ball/kiss_fft.h /usr/include/stdint.h
build/h8ball/_kiss_fft_guts.o: /usr/include/stdlib.h
build/h8ball/_kiss_fft_guts.o: /usr/include/Availability.h
build/h8ball/_kiss_fft_guts.o: /usr/include/AvailabilityInternal.h
build/h8ball/_kiss_fft_guts.o: /usr/include/_types.h
build/h8ball/_kiss_fft_guts.o: /usr/include/sys/_types.h
build/h8ball/_kiss_fft_guts.o: /usr/include/sys/cdefs.h
build/h8ball/_kiss_fft_guts.o: /usr/include/sys/_symbol_aliasing.h
build/h8ball/_kiss_fft_guts.o: /usr/include/sys/_posix_availability.h
build/h8ball/_kiss_fft_guts.o: /usr/include/machine/_types.h
build/h8ball/_kiss_fft_guts.o: /usr/include/i386/_types.h
build/h8ball/_kiss_fft_guts.o: /usr/include/sys/wait.h
build/h8ball/_kiss_fft_guts.o: /usr/include/sys/signal.h
build/h8ball/_kiss_fft_guts.o: /usr/include/sys/appleapiopts.h
build/h8ball/_kiss_fft_guts.o: /usr/include/machine/signal.h
build/h8ball/_kiss_fft_guts.o: /usr/include/i386/signal.h
build/h8ball/_kiss_fft_guts.o: /usr/include/i386/_structs.h
build/h8ball/_kiss_fft_guts.o: /usr/include/sys/_structs.h
build/h8ball/_kiss_fft_guts.o: /usr/include/machine/_structs.h
build/h8ball/_kiss_fft_guts.o: /usr/include/sys/resource.h
build/h8ball/_kiss_fft_guts.o: /usr/include/machine/endian.h
build/h8ball/_kiss_fft_guts.o: /usr/include/i386/endian.h
build/h8ball/_kiss_fft_guts.o: /usr/include/sys/_endian.h
build/h8ball/_kiss_fft_guts.o: /usr/include/libkern/_OSByteOrder.h
build/h8ball/_kiss_fft_guts.o: /usr/include/libkern/i386/_OSByteOrder.h
build/h8ball/_kiss_fft_guts.o: /usr/include/alloca.h
build/h8ball/_kiss_fft_guts.o: /usr/include/machine/types.h
build/h8ball/_kiss_fft_guts.o: /usr/include/i386/types.h /usr/include/stdio.h
build/h8ball/_kiss_fft_guts.o: /usr/include/secure/_stdio.h
build/h8ball/_kiss_fft_guts.o: /usr/include/secure/_common.h
build/h8ball/_kiss_fft_guts.o: /usr/include/math.h /usr/include/string.h
build/h8ball/_kiss_fft_guts.o: /usr/include/strings.h
build/h8ball/_kiss_fft_guts.o: /usr/include/secure/_string.h
build/h8ball/_kiss_fft_guts.o: /usr/include/sys/types.h /usr/include/limits.h
build/h8ball/_kiss_fft_guts.o: /usr/include/machine/limits.h
build/h8ball/_kiss_fft_guts.o: /usr/include/i386/limits.h
build/h8ball/_kiss_fft_guts.o: /usr/include/i386/_limits.h
build/h8ball/_kiss_fft_guts.o: /usr/include/sys/syslimits.h
build/h8ball/kiss_fft.o: /usr/include/stdint.h /usr/include/stdlib.h
build/h8ball/kiss_fft.o: /usr/include/Availability.h
build/h8ball/kiss_fft.o: /usr/include/AvailabilityInternal.h
build/h8ball/kiss_fft.o: /usr/include/_types.h /usr/include/sys/_types.h
build/h8ball/kiss_fft.o: /usr/include/sys/cdefs.h
build/h8ball/kiss_fft.o: /usr/include/sys/_symbol_aliasing.h
build/h8ball/kiss_fft.o: /usr/include/sys/_posix_availability.h
build/h8ball/kiss_fft.o: /usr/include/machine/_types.h
build/h8ball/kiss_fft.o: /usr/include/i386/_types.h /usr/include/sys/wait.h
build/h8ball/kiss_fft.o: /usr/include/sys/signal.h
build/h8ball/kiss_fft.o: /usr/include/sys/appleapiopts.h
build/h8ball/kiss_fft.o: /usr/include/machine/signal.h
build/h8ball/kiss_fft.o: /usr/include/i386/signal.h
build/h8ball/kiss_fft.o: /usr/include/i386/_structs.h
build/h8ball/kiss_fft.o: /usr/include/sys/_structs.h
build/h8ball/kiss_fft.o: /usr/include/machine/_structs.h
build/h8ball/kiss_fft.o: /usr/include/sys/resource.h
build/h8ball/kiss_fft.o: /usr/include/machine/endian.h
build/h8ball/kiss_fft.o: /usr/include/i386/endian.h
build/h8ball/kiss_fft.o: /usr/include/sys/_endian.h
build/h8ball/kiss_fft.o: /usr/include/libkern/_OSByteOrder.h
build/h8ball/kiss_fft.o: /usr/include/libkern/i386/_OSByteOrder.h
build/h8ball/kiss_fft.o: /usr/include/alloca.h /usr/include/machine/types.h
build/h8ball/kiss_fft.o: /usr/include/i386/types.h /usr/include/stdio.h
build/h8ball/kiss_fft.o: /usr/include/secure/_stdio.h
build/h8ball/kiss_fft.o: /usr/include/secure/_common.h /usr/include/math.h
build/h8ball/kiss_fft.o: /usr/include/string.h /usr/include/strings.h
build/h8ball/kiss_fft.o: /usr/include/secure/_string.h
build/h8ball/kiss_fft.o: /usr/include/sys/types.h
build/h8ball/kiss_fftr.o: /usr/include/stdint.h h8ball/kiss_fft.h
build/h8ball/kiss_fftr.o: /usr/include/stdlib.h /usr/include/Availability.h
build/h8ball/kiss_fftr.o: /usr/include/AvailabilityInternal.h
build/h8ball/kiss_fftr.o: /usr/include/_types.h /usr/include/sys/_types.h
build/h8ball/kiss_fftr.o: /usr/include/sys/cdefs.h
build/h8ball/kiss_fftr.o: /usr/include/sys/_symbol_aliasing.h
build/h8ball/kiss_fftr.o: /usr/include/sys/_posix_availability.h
build/h8ball/kiss_fftr.o: /usr/include/machine/_types.h
build/h8ball/kiss_fftr.o: /usr/include/i386/_types.h /usr/include/sys/wait.h
build/h8ball/kiss_fftr.o: /usr/include/sys/signal.h
build/h8ball/kiss_fftr.o: /usr/include/sys/appleapiopts.h
build/h8ball/kiss_fftr.o: /usr/include/machine/signal.h
build/h8ball/kiss_fftr.o: /usr/include/i386/signal.h
build/h8ball/kiss_fftr.o: /usr/include/i386/_structs.h
build/h8ball/kiss_fftr.o: /usr/include/sys/_structs.h
build/h8ball/kiss_fftr.o: /usr/include/machine/_structs.h
build/h8ball/kiss_fftr.o: /usr/include/sys/resource.h
build/h8ball/kiss_fftr.o: /usr/include/machine/endian.h
build/h8ball/kiss_fftr.o: /usr/include/i386/endian.h
build/h8ball/kiss_fftr.o: /usr/include/sys/_endian.h
build/h8ball/kiss_fftr.o: /usr/include/libkern/_OSByteOrder.h
build/h8ball/kiss_fftr.o: /usr/include/libkern/i386/_OSByteOrder.h
build/h8ball/kiss_fftr.o: /usr/include/alloca.h /usr/include/machine/types.h
build/h8ball/kiss_fftr.o: /usr/include/i386/types.h /usr/include/stdio.h
build/h8ball/kiss_fftr.o: /usr/include/secure/_stdio.h
build/h8ball/kiss_fftr.o: /usr/include/secure/_common.h /usr/include/math.h
build/h8ball/kiss_fftr.o: /usr/include/string.h /usr/include/strings.h
build/h8ball/kiss_fftr.o: /usr/include/secure/_string.h
build/h8ball/kiss_fftr.o: /usr/include/sys/types.h
build/wirish/HardwareSPI.o: ./wirish/include/wirish/HardwareSPI.h
build/wirish/HardwareSPI.o: ./libmaple/include/libmaple/libmaple_types.h
build/wirish/HardwareSPI.o: ./libmaple/include/libmaple/spi.h
build/wirish/HardwareSPI.o: ./libmaple/include/libmaple/rcc.h
build/wirish/HardwareSPI.o: ./libmaple/stm32f1/include/series/rcc.h
build/wirish/HardwareSPI.o: ./libmaple/include/libmaple/nvic.h
build/wirish/HardwareSPI.o: ./libmaple/include/libmaple/util.h
build/wirish/HardwareSPI.o: ./libmaple/stm32f1/include/series/nvic.h
build/wirish/HardwareSPI.o: ./libmaple/include/libmaple/stm32.h
build/wirish/HardwareSPI.o: ./libmaple/stm32f1/include/series/stm32.h
build/wirish/HardwareSPI.o: ./libmaple/stm32f1/include/series/spi.h
build/wirish/HardwareSPI.o: ./wirish/include/wirish/boards.h
build/wirish/HardwareSPI.o: ./wirish/include/wirish/wirish_types.h
build/wirish/HardwareSPI.o: ./libmaple/include/libmaple/gpio.h
build/wirish/HardwareSPI.o: ./libmaple/stm32f1/include/series/gpio.h
build/wirish/HardwareSPI.o: ./libmaple/include/libmaple/exti.h
build/wirish/HardwareSPI.o: ./libmaple/stm32f1/include/series/exti.h
build/wirish/HardwareSPI.o: ./libmaple/include/libmaple/timer.h
build/wirish/HardwareSPI.o: ./libmaple/stm32f1/include/series/timer.h
build/wirish/HardwareSPI.o: ./libmaple/include/libmaple/libmaple.h
build/wirish/HardwareSPI.o: ./libmaple/include/libmaple/delay.h
build/wirish/HardwareSPI.o: ./libmaple/include/libmaple/bitband.h
build/wirish/HardwareSPI.o: ./libmaple/include/libmaple/adc.h
build/wirish/HardwareSPI.o: ./libmaple/stm32f1/include/series/adc.h
build/wirish/HardwareSPI.o: ./wirish/boards/maple_mini/include/board/board.h
build/wirish/HardwareSPI.o: ./wirish/include/wirish/wirish.h
build/wirish/HardwareSPI.o: ./wirish/include/wirish/io.h
build/wirish/HardwareSPI.o: ./wirish/include/wirish/bit_constants.h
build/wirish/HardwareSPI.o: ./wirish/include/wirish/pwm.h
build/wirish/HardwareSPI.o: ./wirish/include/wirish/ext_interrupts.h
build/wirish/HardwareSPI.o: ./wirish/include/wirish/wirish_debug.h
build/wirish/HardwareSPI.o: ./wirish/include/wirish/wirish_math.h
build/wirish/HardwareSPI.o: /usr/include/math.h /usr/include/sys/cdefs.h
build/wirish/HardwareSPI.o: /usr/include/sys/_symbol_aliasing.h
build/wirish/HardwareSPI.o: /usr/include/sys/_posix_availability.h
build/wirish/HardwareSPI.o: /usr/include/Availability.h
build/wirish/HardwareSPI.o: /usr/include/AvailabilityInternal.h
build/wirish/HardwareSPI.o: ./wirish/include/wirish/wirish_time.h
build/wirish/HardwareSPI.o: ./libmaple/include/libmaple/systick.h
build/wirish/HardwareSPI.o: ./wirish/include/wirish/HardwareSerial.h
build/wirish/HardwareSPI.o: ./wirish/include/wirish/Print.h
build/wirish/HardwareSPI.o: ./wirish/include/wirish/HardwareTimer.h
build/wirish/HardwareSPI.o: ./wirish/include/wirish/usb_serial.h
build/wirish/HardwareSPI.o: /usr/include/stdint.h
build/wirish/HardwareSerial.o: ./wirish/include/wirish/HardwareSerial.h
build/wirish/HardwareSerial.o: ./libmaple/include/libmaple/libmaple_types.h
build/wirish/HardwareSerial.o: ./wirish/include/wirish/Print.h
build/wirish/HardwareSerial.o: ./wirish/include/wirish/boards.h
build/wirish/HardwareSerial.o: ./wirish/include/wirish/wirish_types.h
build/wirish/HardwareSerial.o: ./libmaple/include/libmaple/gpio.h
build/wirish/HardwareSerial.o: ./libmaple/stm32f1/include/series/gpio.h
build/wirish/HardwareSerial.o: ./libmaple/include/libmaple/stm32.h
build/wirish/HardwareSerial.o: ./libmaple/stm32f1/include/series/stm32.h
build/wirish/HardwareSerial.o: ./libmaple/include/libmaple/exti.h
build/wirish/HardwareSerial.o: ./libmaple/stm32f1/include/series/exti.h
build/wirish/HardwareSerial.o: ./libmaple/include/libmaple/rcc.h
build/wirish/HardwareSerial.o: ./libmaple/stm32f1/include/series/rcc.h
build/wirish/HardwareSerial.o: ./libmaple/include/libmaple/timer.h
build/wirish/HardwareSerial.o: ./libmaple/stm32f1/include/series/timer.h
build/wirish/HardwareSerial.o: ./libmaple/include/libmaple/libmaple.h
build/wirish/HardwareSerial.o: ./libmaple/include/libmaple/util.h
build/wirish/HardwareSerial.o: ./libmaple/include/libmaple/delay.h
build/wirish/HardwareSerial.o: ./libmaple/include/libmaple/nvic.h
build/wirish/HardwareSerial.o: ./libmaple/stm32f1/include/series/nvic.h
build/wirish/HardwareSerial.o: ./libmaple/include/libmaple/bitband.h
build/wirish/HardwareSerial.o: ./libmaple/include/libmaple/adc.h
build/wirish/HardwareSerial.o: ./libmaple/stm32f1/include/series/adc.h
build/wirish/HardwareSerial.o: ./wirish/boards/maple_mini/include/board/board.h
build/wirish/HardwareSerial.o: ./libmaple/include/libmaple/usart.h
build/wirish/HardwareSerial.o: ./libmaple/include/libmaple/ring_buffer.h
build/wirish/HardwareSerial.o: ./libmaple/stm32f1/include/series/usart.h
build/wirish/HardwareTimer.o: ./wirish/include/wirish/HardwareTimer.h
build/wirish/HardwareTimer.o: ./libmaple/include/libmaple/timer.h
build/wirish/HardwareTimer.o: ./libmaple/stm32f1/include/series/timer.h
build/wirish/HardwareTimer.o: ./libmaple/include/libmaple/libmaple_types.h
build/wirish/HardwareTimer.o: ./libmaple/include/libmaple/libmaple.h
build/wirish/HardwareTimer.o: ./libmaple/include/libmaple/stm32.h
build/wirish/HardwareTimer.o: ./libmaple/stm32f1/include/series/stm32.h
build/wirish/HardwareTimer.o: ./libmaple/include/libmaple/util.h
build/wirish/HardwareTimer.o: ./libmaple/include/libmaple/delay.h
build/wirish/HardwareTimer.o: ./libmaple/include/libmaple/rcc.h
build/wirish/HardwareTimer.o: ./libmaple/stm32f1/include/series/rcc.h
build/wirish/HardwareTimer.o: ./libmaple/include/libmaple/nvic.h
build/wirish/HardwareTimer.o: ./libmaple/stm32f1/include/series/nvic.h
build/wirish/HardwareTimer.o: ./libmaple/include/libmaple/bitband.h
build/wirish/HardwareTimer.o: ./wirish/include/wirish/ext_interrupts.h
build/wirish/HardwareTimer.o: ./wirish/include/wirish/wirish_math.h
build/wirish/HardwareTimer.o: /usr/include/math.h /usr/include/sys/cdefs.h
build/wirish/HardwareTimer.o: /usr/include/sys/_symbol_aliasing.h
build/wirish/HardwareTimer.o: /usr/include/sys/_posix_availability.h
build/wirish/HardwareTimer.o: /usr/include/Availability.h
build/wirish/HardwareTimer.o: /usr/include/AvailabilityInternal.h
build/wirish/HardwareTimer.o: ./wirish/boards/maple_mini/include/board/board.h
build/wirish/Print.o: ./wirish/include/wirish/Print.h
build/wirish/Print.o: ./libmaple/include/libmaple/libmaple_types.h
build/wirish/Print.o: ./wirish/include/wirish/wirish_math.h
build/wirish/Print.o: /usr/include/math.h /usr/include/sys/cdefs.h
build/wirish/Print.o: /usr/include/sys/_symbol_aliasing.h
build/wirish/Print.o: /usr/include/sys/_posix_availability.h
build/wirish/Print.o: /usr/include/Availability.h
build/wirish/Print.o: /usr/include/AvailabilityInternal.h
build/wirish/Print.o: /usr/include/limits.h /usr/include/machine/limits.h
build/wirish/Print.o: /usr/include/i386/limits.h /usr/include/i386/_limits.h
build/wirish/Print.o: /usr/include/sys/syslimits.h
build/wirish/boards.o: ./wirish/include/wirish/boards.h
build/wirish/boards.o: ./libmaple/include/libmaple/libmaple_types.h
build/wirish/boards.o: ./wirish/include/wirish/wirish_types.h
build/wirish/boards.o: ./libmaple/include/libmaple/gpio.h
build/wirish/boards.o: ./libmaple/stm32f1/include/series/gpio.h
build/wirish/boards.o: ./libmaple/include/libmaple/stm32.h
build/wirish/boards.o: ./libmaple/stm32f1/include/series/stm32.h
build/wirish/boards.o: ./libmaple/include/libmaple/exti.h
build/wirish/boards.o: ./libmaple/stm32f1/include/series/exti.h
build/wirish/boards.o: ./libmaple/include/libmaple/rcc.h
build/wirish/boards.o: ./libmaple/stm32f1/include/series/rcc.h
build/wirish/boards.o: ./libmaple/include/libmaple/timer.h
build/wirish/boards.o: ./libmaple/stm32f1/include/series/timer.h
build/wirish/boards.o: ./libmaple/include/libmaple/libmaple.h
build/wirish/boards.o: ./libmaple/include/libmaple/util.h
build/wirish/boards.o: ./libmaple/include/libmaple/delay.h
build/wirish/boards.o: ./libmaple/include/libmaple/nvic.h
build/wirish/boards.o: ./libmaple/stm32f1/include/series/nvic.h
build/wirish/boards.o: ./libmaple/include/libmaple/bitband.h
build/wirish/boards.o: ./libmaple/include/libmaple/adc.h
build/wirish/boards.o: ./libmaple/stm32f1/include/series/adc.h
build/wirish/boards.o: ./wirish/boards/maple_mini/include/board/board.h
build/wirish/boards.o: ./libmaple/include/libmaple/flash.h
build/wirish/boards.o: ./libmaple/stm32f1/include/series/flash.h
build/wirish/boards.o: ./libmaple/include/libmaple/systick.h
build/wirish/boards.o: wirish/boards_private.h
build/wirish/ext_interrupts.o: ./wirish/include/wirish/ext_interrupts.h
build/wirish/ext_interrupts.o: ./libmaple/include/libmaple/libmaple_types.h
build/wirish/ext_interrupts.o: ./libmaple/include/libmaple/nvic.h
build/wirish/ext_interrupts.o: ./libmaple/include/libmaple/util.h
build/wirish/ext_interrupts.o: ./libmaple/stm32f1/include/series/nvic.h
build/wirish/ext_interrupts.o: ./libmaple/include/libmaple/stm32.h
build/wirish/ext_interrupts.o: ./libmaple/stm32f1/include/series/stm32.h
build/wirish/ext_interrupts.o: ./libmaple/include/libmaple/gpio.h
build/wirish/ext_interrupts.o: ./libmaple/stm32f1/include/series/gpio.h
build/wirish/ext_interrupts.o: ./libmaple/include/libmaple/exti.h
build/wirish/ext_interrupts.o: ./libmaple/stm32f1/include/series/exti.h
build/wirish/ext_interrupts.o: ./libmaple/include/libmaple/rcc.h
build/wirish/ext_interrupts.o: ./libmaple/stm32f1/include/series/rcc.h
build/wirish/ext_interrupts.o: ./wirish/include/wirish/boards.h
build/wirish/ext_interrupts.o: ./wirish/include/wirish/wirish_types.h
build/wirish/ext_interrupts.o: ./libmaple/include/libmaple/timer.h
build/wirish/ext_interrupts.o: ./libmaple/stm32f1/include/series/timer.h
build/wirish/ext_interrupts.o: ./libmaple/include/libmaple/libmaple.h
build/wirish/ext_interrupts.o: ./libmaple/include/libmaple/delay.h
build/wirish/ext_interrupts.o: ./libmaple/include/libmaple/bitband.h
build/wirish/ext_interrupts.o: ./libmaple/include/libmaple/adc.h
build/wirish/ext_interrupts.o: ./libmaple/stm32f1/include/series/adc.h
build/wirish/ext_interrupts.o: ./wirish/boards/maple_mini/include/board/board.h
build/wirish/pwm.o: ./wirish/include/wirish/pwm.h
build/wirish/pwm.o: ./libmaple/include/libmaple/libmaple_types.h
build/wirish/pwm.o: ./libmaple/include/libmaple/timer.h
build/wirish/pwm.o: ./libmaple/stm32f1/include/series/timer.h
build/wirish/pwm.o: ./libmaple/include/libmaple/libmaple.h
build/wirish/pwm.o: ./libmaple/include/libmaple/stm32.h
build/wirish/pwm.o: ./libmaple/stm32f1/include/series/stm32.h
build/wirish/pwm.o: ./libmaple/include/libmaple/util.h
build/wirish/pwm.o: ./libmaple/include/libmaple/delay.h
build/wirish/pwm.o: ./libmaple/include/libmaple/rcc.h
build/wirish/pwm.o: ./libmaple/stm32f1/include/series/rcc.h
build/wirish/pwm.o: ./libmaple/include/libmaple/nvic.h
build/wirish/pwm.o: ./libmaple/stm32f1/include/series/nvic.h
build/wirish/pwm.o: ./libmaple/include/libmaple/bitband.h
build/wirish/pwm.o: ./wirish/include/wirish/boards.h
build/wirish/pwm.o: ./wirish/include/wirish/wirish_types.h
build/wirish/pwm.o: ./libmaple/include/libmaple/gpio.h
build/wirish/pwm.o: ./libmaple/stm32f1/include/series/gpio.h
build/wirish/pwm.o: ./libmaple/include/libmaple/exti.h
build/wirish/pwm.o: ./libmaple/stm32f1/include/series/exti.h
build/wirish/pwm.o: ./libmaple/include/libmaple/adc.h
build/wirish/pwm.o: ./libmaple/stm32f1/include/series/adc.h
build/wirish/pwm.o: ./wirish/boards/maple_mini/include/board/board.h
build/wirish/usb_serial.o: ./wirish/include/wirish/usb_serial.h
build/wirish/usb_serial.o: ./wirish/include/wirish/Print.h
build/wirish/usb_serial.o: ./libmaple/include/libmaple/libmaple_types.h
build/wirish/usb_serial.o: ./wirish/include/wirish/boards.h
build/wirish/usb_serial.o: ./wirish/include/wirish/wirish_types.h
build/wirish/usb_serial.o: ./libmaple/include/libmaple/gpio.h
build/wirish/usb_serial.o: ./libmaple/stm32f1/include/series/gpio.h
build/wirish/usb_serial.o: ./libmaple/include/libmaple/stm32.h
build/wirish/usb_serial.o: ./libmaple/stm32f1/include/series/stm32.h
build/wirish/usb_serial.o: ./libmaple/include/libmaple/exti.h
build/wirish/usb_serial.o: ./libmaple/stm32f1/include/series/exti.h
build/wirish/usb_serial.o: ./libmaple/include/libmaple/rcc.h
build/wirish/usb_serial.o: ./libmaple/stm32f1/include/series/rcc.h
build/wirish/usb_serial.o: ./libmaple/include/libmaple/timer.h
build/wirish/usb_serial.o: ./libmaple/stm32f1/include/series/timer.h
build/wirish/usb_serial.o: ./libmaple/include/libmaple/libmaple.h
build/wirish/usb_serial.o: ./libmaple/include/libmaple/util.h
build/wirish/usb_serial.o: ./libmaple/include/libmaple/delay.h
build/wirish/usb_serial.o: ./libmaple/include/libmaple/nvic.h
build/wirish/usb_serial.o: ./libmaple/stm32f1/include/series/nvic.h
build/wirish/usb_serial.o: ./libmaple/include/libmaple/bitband.h
build/wirish/usb_serial.o: ./libmaple/include/libmaple/adc.h
build/wirish/usb_serial.o: ./libmaple/stm32f1/include/series/adc.h
build/wirish/usb_serial.o: ./wirish/boards/maple_mini/include/board/board.h
build/wirish/usb_serial.o: /usr/include/string.h /usr/include/_types.h
build/wirish/usb_serial.o: /usr/include/sys/_types.h /usr/include/sys/cdefs.h
build/wirish/usb_serial.o: /usr/include/sys/_symbol_aliasing.h
build/wirish/usb_serial.o: /usr/include/sys/_posix_availability.h
build/wirish/usb_serial.o: /usr/include/machine/_types.h
build/wirish/usb_serial.o: /usr/include/i386/_types.h
build/wirish/usb_serial.o: /usr/include/Availability.h
build/wirish/usb_serial.o: /usr/include/AvailabilityInternal.h
build/wirish/usb_serial.o: /usr/include/strings.h
build/wirish/usb_serial.o: /usr/include/secure/_string.h
build/wirish/usb_serial.o: /usr/include/secure/_common.h
build/wirish/usb_serial.o: /usr/include/stdint.h
build/wirish/usb_serial.o: ./libmaple/include/libmaple/usb_cdcacm.h
build/wirish/usb_serial.o: ./libmaple/include/libmaple/usb.h
build/wirish/usb_serial.o: ./wirish/include/wirish/wirish.h
build/wirish/usb_serial.o: ./wirish/include/wirish/io.h
build/wirish/usb_serial.o: ./wirish/include/wirish/bit_constants.h
build/wirish/usb_serial.o: ./wirish/include/wirish/pwm.h
build/wirish/usb_serial.o: ./wirish/include/wirish/ext_interrupts.h
build/wirish/usb_serial.o: ./wirish/include/wirish/wirish_debug.h
build/wirish/usb_serial.o: ./wirish/include/wirish/wirish_math.h
build/wirish/usb_serial.o: /usr/include/math.h
build/wirish/usb_serial.o: ./wirish/include/wirish/wirish_time.h
build/wirish/usb_serial.o: ./libmaple/include/libmaple/systick.h
build/wirish/usb_serial.o: ./wirish/include/wirish/HardwareSPI.h
build/wirish/usb_serial.o: ./libmaple/include/libmaple/spi.h
build/wirish/usb_serial.o: ./libmaple/stm32f1/include/series/spi.h
build/wirish/usb_serial.o: ./wirish/include/wirish/HardwareSerial.h
build/wirish/usb_serial.o: ./wirish/include/wirish/HardwareTimer.h
build/wirish/wirish_analog.o: ./wirish/include/wirish/io.h
build/wirish/wirish_analog.o: ./libmaple/include/libmaple/libmaple_types.h
build/wirish/wirish_analog.o: ./wirish/include/wirish/boards.h
build/wirish/wirish_analog.o: ./wirish/include/wirish/wirish_types.h
build/wirish/wirish_analog.o: ./libmaple/include/libmaple/gpio.h
build/wirish/wirish_analog.o: ./libmaple/stm32f1/include/series/gpio.h
build/wirish/wirish_analog.o: ./libmaple/include/libmaple/stm32.h
build/wirish/wirish_analog.o: ./libmaple/stm32f1/include/series/stm32.h
build/wirish/wirish_analog.o: ./libmaple/include/libmaple/exti.h
build/wirish/wirish_analog.o: ./libmaple/stm32f1/include/series/exti.h
build/wirish/wirish_analog.o: ./libmaple/include/libmaple/rcc.h
build/wirish/wirish_analog.o: ./libmaple/stm32f1/include/series/rcc.h
build/wirish/wirish_analog.o: ./libmaple/include/libmaple/timer.h
build/wirish/wirish_analog.o: ./libmaple/stm32f1/include/series/timer.h
build/wirish/wirish_analog.o: ./libmaple/include/libmaple/libmaple.h
build/wirish/wirish_analog.o: ./libmaple/include/libmaple/util.h
build/wirish/wirish_analog.o: ./libmaple/include/libmaple/delay.h
build/wirish/wirish_analog.o: ./libmaple/include/libmaple/nvic.h
build/wirish/wirish_analog.o: ./libmaple/stm32f1/include/series/nvic.h
build/wirish/wirish_analog.o: ./libmaple/include/libmaple/bitband.h
build/wirish/wirish_analog.o: ./libmaple/include/libmaple/adc.h
build/wirish/wirish_analog.o: ./libmaple/stm32f1/include/series/adc.h
build/wirish/wirish_analog.o: ./wirish/boards/maple_mini/include/board/board.h
build/wirish/wirish_digital.o: ./wirish/include/wirish/io.h
build/wirish/wirish_digital.o: ./libmaple/include/libmaple/libmaple_types.h
build/wirish/wirish_digital.o: ./wirish/include/wirish/boards.h
build/wirish/wirish_digital.o: ./wirish/include/wirish/wirish_types.h
build/wirish/wirish_digital.o: ./libmaple/include/libmaple/gpio.h
build/wirish/wirish_digital.o: ./libmaple/stm32f1/include/series/gpio.h
build/wirish/wirish_digital.o: ./libmaple/include/libmaple/stm32.h
build/wirish/wirish_digital.o: ./libmaple/stm32f1/include/series/stm32.h
build/wirish/wirish_digital.o: ./libmaple/include/libmaple/exti.h
build/wirish/wirish_digital.o: ./libmaple/stm32f1/include/series/exti.h
build/wirish/wirish_digital.o: ./libmaple/include/libmaple/rcc.h
build/wirish/wirish_digital.o: ./libmaple/stm32f1/include/series/rcc.h
build/wirish/wirish_digital.o: ./libmaple/include/libmaple/timer.h
build/wirish/wirish_digital.o: ./libmaple/stm32f1/include/series/timer.h
build/wirish/wirish_digital.o: ./libmaple/include/libmaple/libmaple.h
build/wirish/wirish_digital.o: ./libmaple/include/libmaple/util.h
build/wirish/wirish_digital.o: ./libmaple/include/libmaple/delay.h
build/wirish/wirish_digital.o: ./libmaple/include/libmaple/nvic.h
build/wirish/wirish_digital.o: ./libmaple/stm32f1/include/series/nvic.h
build/wirish/wirish_digital.o: ./libmaple/include/libmaple/bitband.h
build/wirish/wirish_digital.o: ./libmaple/include/libmaple/adc.h
build/wirish/wirish_digital.o: ./libmaple/stm32f1/include/series/adc.h
build/wirish/wirish_digital.o: ./wirish/boards/maple_mini/include/board/board.h
build/wirish/wirish_digital.o: ./wirish/include/wirish/wirish_time.h
build/wirish/wirish_digital.o: ./libmaple/include/libmaple/systick.h
build/wirish/wirish_math.o: /usr/include/stdlib.h /usr/include/Availability.h
build/wirish/wirish_math.o: /usr/include/AvailabilityInternal.h
build/wirish/wirish_math.o: /usr/include/_types.h /usr/include/sys/_types.h
build/wirish/wirish_math.o: /usr/include/sys/cdefs.h
build/wirish/wirish_math.o: /usr/include/sys/_symbol_aliasing.h
build/wirish/wirish_math.o: /usr/include/sys/_posix_availability.h
build/wirish/wirish_math.o: /usr/include/machine/_types.h
build/wirish/wirish_math.o: /usr/include/i386/_types.h
build/wirish/wirish_math.o: /usr/include/sys/wait.h /usr/include/sys/signal.h
build/wirish/wirish_math.o: /usr/include/sys/appleapiopts.h
build/wirish/wirish_math.o: /usr/include/machine/signal.h
build/wirish/wirish_math.o: /usr/include/i386/signal.h
build/wirish/wirish_math.o: /usr/include/i386/_structs.h
build/wirish/wirish_math.o: /usr/include/sys/_structs.h
build/wirish/wirish_math.o: /usr/include/machine/_structs.h
build/wirish/wirish_math.o: /usr/include/sys/resource.h
build/wirish/wirish_math.o: /usr/include/machine/endian.h
build/wirish/wirish_math.o: /usr/include/i386/endian.h
build/wirish/wirish_math.o: /usr/include/sys/_endian.h
build/wirish/wirish_math.o: /usr/include/libkern/_OSByteOrder.h
build/wirish/wirish_math.o: /usr/include/libkern/i386/_OSByteOrder.h
build/wirish/wirish_math.o: /usr/include/alloca.h
build/wirish/wirish_math.o: /usr/include/machine/types.h
build/wirish/wirish_math.o: /usr/include/i386/types.h
build/wirish/wirish_math.o: ./wirish/include/wirish/wirish_math.h
build/wirish/wirish_math.o: /usr/include/math.h
build/wirish/wirish_shift.o: ./wirish/include/wirish/wirish.h
build/wirish/wirish_shift.o: ./libmaple/include/libmaple/stm32.h
build/wirish/wirish_shift.o: ./libmaple/stm32f1/include/series/stm32.h
build/wirish/wirish_shift.o: ./wirish/include/wirish/boards.h
build/wirish/wirish_shift.o: ./libmaple/include/libmaple/libmaple_types.h
build/wirish/wirish_shift.o: ./wirish/include/wirish/wirish_types.h
build/wirish/wirish_shift.o: ./libmaple/include/libmaple/gpio.h
build/wirish/wirish_shift.o: ./libmaple/stm32f1/include/series/gpio.h
build/wirish/wirish_shift.o: ./libmaple/include/libmaple/exti.h
build/wirish/wirish_shift.o: ./libmaple/stm32f1/include/series/exti.h
build/wirish/wirish_shift.o: ./libmaple/include/libmaple/rcc.h
build/wirish/wirish_shift.o: ./libmaple/stm32f1/include/series/rcc.h
build/wirish/wirish_shift.o: ./libmaple/include/libmaple/timer.h
build/wirish/wirish_shift.o: ./libmaple/stm32f1/include/series/timer.h
build/wirish/wirish_shift.o: ./libmaple/include/libmaple/libmaple.h
build/wirish/wirish_shift.o: ./libmaple/include/libmaple/util.h
build/wirish/wirish_shift.o: ./libmaple/include/libmaple/delay.h
build/wirish/wirish_shift.o: ./libmaple/include/libmaple/nvic.h
build/wirish/wirish_shift.o: ./libmaple/stm32f1/include/series/nvic.h
build/wirish/wirish_shift.o: ./libmaple/include/libmaple/bitband.h
build/wirish/wirish_shift.o: ./libmaple/include/libmaple/adc.h
build/wirish/wirish_shift.o: ./libmaple/stm32f1/include/series/adc.h
build/wirish/wirish_shift.o: ./wirish/boards/maple_mini/include/board/board.h
build/wirish/wirish_shift.o: ./wirish/include/wirish/io.h
build/wirish/wirish_shift.o: ./wirish/include/wirish/bit_constants.h
build/wirish/wirish_shift.o: ./wirish/include/wirish/pwm.h
build/wirish/wirish_shift.o: ./wirish/include/wirish/ext_interrupts.h
build/wirish/wirish_shift.o: ./wirish/include/wirish/wirish_debug.h
build/wirish/wirish_shift.o: ./wirish/include/wirish/wirish_math.h
build/wirish/wirish_shift.o: /usr/include/math.h /usr/include/sys/cdefs.h
build/wirish/wirish_shift.o: /usr/include/sys/_symbol_aliasing.h
build/wirish/wirish_shift.o: /usr/include/sys/_posix_availability.h
build/wirish/wirish_shift.o: /usr/include/Availability.h
build/wirish/wirish_shift.o: /usr/include/AvailabilityInternal.h
build/wirish/wirish_shift.o: ./wirish/include/wirish/wirish_time.h
build/wirish/wirish_shift.o: ./libmaple/include/libmaple/systick.h
build/wirish/wirish_shift.o: ./wirish/include/wirish/HardwareSPI.h
build/wirish/wirish_shift.o: ./libmaple/include/libmaple/spi.h
build/wirish/wirish_shift.o: ./libmaple/stm32f1/include/series/spi.h
build/wirish/wirish_shift.o: ./wirish/include/wirish/HardwareSerial.h
build/wirish/wirish_shift.o: ./wirish/include/wirish/Print.h
build/wirish/wirish_shift.o: ./wirish/include/wirish/HardwareTimer.h
build/wirish/wirish_shift.o: ./wirish/include/wirish/usb_serial.h
build/wirish/wirish_shift.o: /usr/include/stdint.h
build/wirish/wirish_time.o: ./wirish/include/wirish/wirish_time.h
build/wirish/wirish_time.o: ./libmaple/include/libmaple/libmaple_types.h
build/wirish/wirish_time.o: ./libmaple/include/libmaple/systick.h
build/wirish/wirish_time.o: ./libmaple/include/libmaple/util.h
build/wirish/wirish_time.o: ./wirish/include/wirish/boards.h
build/wirish/wirish_time.o: ./wirish/include/wirish/wirish_types.h
build/wirish/wirish_time.o: ./libmaple/include/libmaple/gpio.h
build/wirish/wirish_time.o: ./libmaple/stm32f1/include/series/gpio.h
build/wirish/wirish_time.o: ./libmaple/include/libmaple/stm32.h
build/wirish/wirish_time.o: ./libmaple/stm32f1/include/series/stm32.h
build/wirish/wirish_time.o: ./libmaple/include/libmaple/exti.h
build/wirish/wirish_time.o: ./libmaple/stm32f1/include/series/exti.h
build/wirish/wirish_time.o: ./libmaple/include/libmaple/rcc.h
build/wirish/wirish_time.o: ./libmaple/stm32f1/include/series/rcc.h
build/wirish/wirish_time.o: ./libmaple/include/libmaple/timer.h
build/wirish/wirish_time.o: ./libmaple/stm32f1/include/series/timer.h
build/wirish/wirish_time.o: ./libmaple/include/libmaple/libmaple.h
build/wirish/wirish_time.o: ./libmaple/include/libmaple/delay.h
build/wirish/wirish_time.o: ./libmaple/include/libmaple/nvic.h
build/wirish/wirish_time.o: ./libmaple/stm32f1/include/series/nvic.h
build/wirish/wirish_time.o: ./libmaple/include/libmaple/bitband.h
build/wirish/wirish_time.o: ./libmaple/include/libmaple/adc.h
build/wirish/wirish_time.o: ./libmaple/stm32f1/include/series/adc.h
build/wirish/wirish_time.o: ./wirish/boards/maple_mini/include/board/board.h
build/wirish/boards_private.o: ./libmaple/include/libmaple/rcc.h
build/wirish/boards_private.o: ./libmaple/include/libmaple/libmaple_types.h
build/wirish/boards_private.o: ./libmaple/stm32f1/include/series/rcc.h
build/wirish/boards_private.o: ./libmaple/include/libmaple/adc.h
build/wirish/boards_private.o: ./libmaple/include/libmaple/libmaple.h
build/wirish/boards_private.o: ./libmaple/include/libmaple/stm32.h
build/wirish/boards_private.o: ./libmaple/stm32f1/include/series/stm32.h
build/wirish/boards_private.o: ./libmaple/include/libmaple/util.h
build/wirish/boards_private.o: ./libmaple/include/libmaple/delay.h
build/wirish/boards_private.o: ./libmaple/include/libmaple/bitband.h
build/wirish/boards_private.o: ./libmaple/stm32f1/include/series/adc.h
build/wirish/start_c.o: /usr/include/stddef.h /usr/include/_types.h
build/wirish/start_c.o: /usr/include/sys/_types.h /usr/include/sys/cdefs.h
build/wirish/start_c.o: /usr/include/sys/_symbol_aliasing.h
build/wirish/start_c.o: /usr/include/sys/_posix_availability.h
build/wirish/start_c.o: /usr/include/machine/_types.h
build/wirish/start_c.o: /usr/include/i386/_types.h
build/wirish/syscalls.o: ./libmaple/include/libmaple/libmaple.h
build/wirish/syscalls.o: ./libmaple/include/libmaple/libmaple_types.h
build/wirish/syscalls.o: ./libmaple/include/libmaple/stm32.h
build/wirish/syscalls.o: ./libmaple/stm32f1/include/series/stm32.h
build/wirish/syscalls.o: ./libmaple/include/libmaple/util.h
build/wirish/syscalls.o: ./libmaple/include/libmaple/delay.h
build/wirish/syscalls.o: /usr/include/sys/stat.h /usr/include/sys/_types.h
build/wirish/syscalls.o: /usr/include/sys/cdefs.h
build/wirish/syscalls.o: /usr/include/sys/_symbol_aliasing.h
build/wirish/syscalls.o: /usr/include/sys/_posix_availability.h
build/wirish/syscalls.o: /usr/include/machine/_types.h
build/wirish/syscalls.o: /usr/include/i386/_types.h
build/wirish/syscalls.o: /usr/include/Availability.h
build/wirish/syscalls.o: /usr/include/AvailabilityInternal.h
build/wirish/syscalls.o: /usr/include/sys/_structs.h
build/wirish/syscalls.o: /usr/include/machine/_structs.h
build/wirish/syscalls.o: /usr/include/i386/_structs.h
build/wirish/syscalls.o: /usr/include/sys/appleapiopts.h /usr/include/errno.h
build/wirish/syscalls.o: /usr/include/sys/errno.h /usr/include/stddef.h
build/wirish/syscalls.o: /usr/include/_types.h
