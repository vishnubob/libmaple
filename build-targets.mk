# main project target
EXTRA_INCLUDES := -I./h8ball -DFIXED_POINT=16
SRCROOT := h8ball
$(BUILD_PATH)/%.o: $(SRCROOT)/%.c
	$(CXX) $(CFLAGS) $(EXTRA_INCLUDES) $(CXXFLAGS) $(LIBMAPLE_INCLUDES) $(WIRISH_INCLUDES) -o $@ -c $< 
$(BUILD_PATH)/%.o: $(SRCROOT)/%.cpp
	$(CXX) $(CFLAGS) $(EXTRA_INCLUDES) $(CXXFLAGS) $(LIBMAPLE_INCLUDES) $(WIRISH_INCLUDES) -o $@ -c $< 

OBJECTS := $(BUILD_PATH)/Adafruit_ILI9340.o $(BUILD_PATH)/Adafruit_GFX.o $(BUILD_PATH)/h8ball.o $(BUILD_PATH)/kiss_fftr.o $(BUILD_PATH)/kiss_fft.o

$(BUILD_PATH)/libmaple.a: $(BUILDDIRS) $(TGT_BIN)
	- rm -f $@
	$(AR) crv $(BUILD_PATH)/libmaple.a $(TGT_BIN)

library: $(BUILD_PATH)/libmaple.a

makedepend:
	makedepend -fbuild-targets.mk -- $(CFLAGS) $(EXTRA_INCLUDES) $(LIBMAPLE_INCLUDES) $(WIRISH_INCLUDES) -- $(SRCROOT)/*.c $(SRCROOT)/*.cpp $(SRCROOT)/*.h wirish/*.cpp wirish/*.h wirish/*.c

.PHONY: library

$(BUILD_PATH)/$(BOARD).elf: $(BUILDDIRS) $(TGT_BIN) $(OBJECTS)
	$(CXX) $(LDFLAGS) -o $@ $(TGT_BIN) $(OBJECTS) -Wl,-Map,$(BUILD_PATH)/$(BOARD).map

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

h8ball/kiss_fft.o: h8ball/_kiss_fft_guts.h h8ball/kiss_fft.h
h8ball/kiss_fft.o: /usr/include/stdint.h /usr/include/stdlib.h
h8ball/kiss_fft.o: /usr/include/Availability.h
h8ball/kiss_fft.o: /usr/include/AvailabilityInternal.h /usr/include/_types.h
h8ball/kiss_fft.o: /usr/include/sys/_types.h /usr/include/sys/cdefs.h
h8ball/kiss_fft.o: /usr/include/sys/_symbol_aliasing.h
h8ball/kiss_fft.o: /usr/include/sys/_posix_availability.h
h8ball/kiss_fft.o: /usr/include/machine/_types.h /usr/include/i386/_types.h
h8ball/kiss_fft.o: /usr/include/sys/wait.h /usr/include/sys/signal.h
h8ball/kiss_fft.o: /usr/include/sys/appleapiopts.h
h8ball/kiss_fft.o: /usr/include/machine/signal.h /usr/include/i386/signal.h
h8ball/kiss_fft.o: /usr/include/i386/_structs.h /usr/include/sys/_structs.h
h8ball/kiss_fft.o: /usr/include/machine/_structs.h
h8ball/kiss_fft.o: /usr/include/sys/resource.h /usr/include/machine/endian.h
h8ball/kiss_fft.o: /usr/include/i386/endian.h /usr/include/sys/_endian.h
h8ball/kiss_fft.o: /usr/include/libkern/_OSByteOrder.h
h8ball/kiss_fft.o: /usr/include/libkern/i386/_OSByteOrder.h
h8ball/kiss_fft.o: /usr/include/alloca.h /usr/include/machine/types.h
h8ball/kiss_fft.o: /usr/include/i386/types.h /usr/include/stdio.h
h8ball/kiss_fft.o: /usr/include/secure/_stdio.h /usr/include/secure/_common.h
h8ball/kiss_fft.o: /usr/include/math.h /usr/include/string.h
h8ball/kiss_fft.o: /usr/include/strings.h /usr/include/secure/_string.h
h8ball/kiss_fft.o: /usr/include/sys/types.h /usr/include/limits.h
h8ball/kiss_fft.o: /usr/include/machine/limits.h /usr/include/i386/limits.h
h8ball/kiss_fft.o: /usr/include/i386/_limits.h /usr/include/sys/syslimits.h
h8ball/kiss_fft.o: ./wirish/include/wirish/wirish.h
h8ball/kiss_fft.o: ./libmaple/include/libmaple/stm32.h
h8ball/kiss_fft.o: ./libmaple/stm32f1/include/series/stm32.h
h8ball/kiss_fft.o: ./wirish/include/wirish/boards.h
h8ball/kiss_fft.o: ./libmaple/include/libmaple/libmaple_types.h
h8ball/kiss_fft.o: ./wirish/include/wirish/wirish_types.h
h8ball/kiss_fft.o: ./libmaple/include/libmaple/gpio.h
h8ball/kiss_fft.o: ./libmaple/stm32f1/include/series/gpio.h
h8ball/kiss_fft.o: ./libmaple/include/libmaple/exti.h
h8ball/kiss_fft.o: ./libmaple/stm32f1/include/series/exti.h
h8ball/kiss_fft.o: ./libmaple/include/libmaple/rcc.h
h8ball/kiss_fft.o: ./libmaple/stm32f1/include/series/rcc.h
h8ball/kiss_fft.o: ./libmaple/include/libmaple/timer.h
h8ball/kiss_fft.o: ./libmaple/stm32f1/include/series/timer.h
h8ball/kiss_fft.o: ./libmaple/include/libmaple/libmaple.h
h8ball/kiss_fft.o: ./libmaple/include/libmaple/util.h
h8ball/kiss_fft.o: ./libmaple/include/libmaple/delay.h
h8ball/kiss_fft.o: ./libmaple/include/libmaple/nvic.h
h8ball/kiss_fft.o: ./libmaple/stm32f1/include/series/nvic.h
h8ball/kiss_fft.o: ./libmaple/include/libmaple/bitband.h
h8ball/kiss_fft.o: ./libmaple/include/libmaple/adc.h
h8ball/kiss_fft.o: ./libmaple/stm32f1/include/series/adc.h
h8ball/kiss_fft.o: ./wirish/boards/maple_mini/include/board/board.h
h8ball/kiss_fft.o: ./wirish/include/wirish/io.h
h8ball/kiss_fft.o: ./wirish/include/wirish/bit_constants.h
h8ball/kiss_fft.o: ./wirish/include/wirish/pwm.h
h8ball/kiss_fft.o: ./wirish/include/wirish/ext_interrupts.h
h8ball/kiss_fft.o: ./wirish/include/wirish/wirish_debug.h
h8ball/kiss_fft.o: ./wirish/include/wirish/wirish_math.h
h8ball/kiss_fft.o: ./wirish/include/wirish/wirish_time.h
h8ball/kiss_fft.o: ./libmaple/include/libmaple/systick.h
h8ball/kiss_fft.o: ./wirish/include/wirish/HardwareSPI.h
h8ball/kiss_fft.o: ./libmaple/include/libmaple/spi.h
h8ball/kiss_fft.o: ./libmaple/stm32f1/include/series/spi.h
h8ball/kiss_fft.o: ./wirish/include/wirish/HardwareSerial.h
h8ball/kiss_fft.o: ./wirish/include/wirish/Print.h
h8ball/kiss_fft.o: ./wirish/include/wirish/HardwareTimer.h
h8ball/kiss_fft.o: ./wirish/include/wirish/usb_serial.h
h8ball/kiss_fftr.o: h8ball/kiss_fftr.h /usr/include/stdint.h
h8ball/kiss_fftr.o: h8ball/kiss_fft.h /usr/include/stdlib.h
h8ball/kiss_fftr.o: /usr/include/Availability.h
h8ball/kiss_fftr.o: /usr/include/AvailabilityInternal.h /usr/include/_types.h
h8ball/kiss_fftr.o: /usr/include/sys/_types.h /usr/include/sys/cdefs.h
h8ball/kiss_fftr.o: /usr/include/sys/_symbol_aliasing.h
h8ball/kiss_fftr.o: /usr/include/sys/_posix_availability.h
h8ball/kiss_fftr.o: /usr/include/machine/_types.h /usr/include/i386/_types.h
h8ball/kiss_fftr.o: /usr/include/sys/wait.h /usr/include/sys/signal.h
h8ball/kiss_fftr.o: /usr/include/sys/appleapiopts.h
h8ball/kiss_fftr.o: /usr/include/machine/signal.h /usr/include/i386/signal.h
h8ball/kiss_fftr.o: /usr/include/i386/_structs.h /usr/include/sys/_structs.h
h8ball/kiss_fftr.o: /usr/include/machine/_structs.h
h8ball/kiss_fftr.o: /usr/include/sys/resource.h /usr/include/machine/endian.h
h8ball/kiss_fftr.o: /usr/include/i386/endian.h /usr/include/sys/_endian.h
h8ball/kiss_fftr.o: /usr/include/libkern/_OSByteOrder.h
h8ball/kiss_fftr.o: /usr/include/libkern/i386/_OSByteOrder.h
h8ball/kiss_fftr.o: /usr/include/alloca.h /usr/include/machine/types.h
h8ball/kiss_fftr.o: /usr/include/i386/types.h /usr/include/stdio.h
h8ball/kiss_fftr.o: /usr/include/secure/_stdio.h
h8ball/kiss_fftr.o: /usr/include/secure/_common.h /usr/include/math.h
h8ball/kiss_fftr.o: /usr/include/string.h /usr/include/strings.h
h8ball/kiss_fftr.o: /usr/include/secure/_string.h /usr/include/sys/types.h
h8ball/kiss_fftr.o: h8ball/_kiss_fft_guts.h /usr/include/limits.h
h8ball/kiss_fftr.o: /usr/include/machine/limits.h /usr/include/i386/limits.h
h8ball/kiss_fftr.o: /usr/include/i386/_limits.h /usr/include/sys/syslimits.h
h8ball/Adafruit_GFX.o: h8ball/Adafruit_GFX.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/WProgram.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/wirish.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/stm32.h
h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/stm32.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/boards.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/libmaple_types.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/wirish_types.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/gpio.h
h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/gpio.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/exti.h
h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/exti.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/rcc.h
h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/rcc.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/timer.h
h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/timer.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/libmaple.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/util.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/delay.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/nvic.h
h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/nvic.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/bitband.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/adc.h
h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/adc.h
h8ball/Adafruit_GFX.o: ./wirish/boards/maple_mini/include/board/board.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/io.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/bit_constants.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/pwm.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/ext_interrupts.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/wirish_debug.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/wirish_math.h
h8ball/Adafruit_GFX.o: /usr/include/math.h /usr/include/sys/cdefs.h
h8ball/Adafruit_GFX.o: /usr/include/sys/_symbol_aliasing.h
h8ball/Adafruit_GFX.o: /usr/include/sys/_posix_availability.h
h8ball/Adafruit_GFX.o: /usr/include/Availability.h
h8ball/Adafruit_GFX.o: /usr/include/AvailabilityInternal.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/wirish_time.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/systick.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/HardwareSPI.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/spi.h
h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/spi.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/HardwareSerial.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/Print.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/HardwareTimer.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/usb_serial.h
h8ball/Adafruit_GFX.o: /usr/include/stdint.h h8ball/glcdfont.c
h8ball/Adafruit_ILI9340.o: h8ball/Adafruit_ILI9340.h h8ball/Adafruit_GFX.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/WProgram.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/wirish.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/stm32.h
h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/stm32.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/boards.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/libmaple_types.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/wirish_types.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/gpio.h
h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/gpio.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/exti.h
h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/exti.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/rcc.h
h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/rcc.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/timer.h
h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/timer.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/libmaple.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/util.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/delay.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/nvic.h
h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/nvic.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/bitband.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/adc.h
h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/adc.h
h8ball/Adafruit_ILI9340.o: ./wirish/boards/maple_mini/include/board/board.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/io.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/bit_constants.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/pwm.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/ext_interrupts.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/wirish_debug.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/wirish_math.h
h8ball/Adafruit_ILI9340.o: /usr/include/math.h /usr/include/sys/cdefs.h
h8ball/Adafruit_ILI9340.o: /usr/include/sys/_symbol_aliasing.h
h8ball/Adafruit_ILI9340.o: /usr/include/sys/_posix_availability.h
h8ball/Adafruit_ILI9340.o: /usr/include/Availability.h
h8ball/Adafruit_ILI9340.o: /usr/include/AvailabilityInternal.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/wirish_time.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/systick.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/HardwareSPI.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/spi.h
h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/spi.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/HardwareSerial.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/Print.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/HardwareTimer.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/usb_serial.h
h8ball/Adafruit_ILI9340.o: /usr/include/stdint.h /usr/include/limits.h
h8ball/Adafruit_ILI9340.o: /usr/include/machine/limits.h
h8ball/Adafruit_ILI9340.o: /usr/include/i386/limits.h
h8ball/Adafruit_ILI9340.o: /usr/include/i386/_limits.h
h8ball/Adafruit_ILI9340.o: /usr/include/sys/syslimits.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/SPI.h
h8ball/h8ball.o: /usr/include/stdint.h h8ball/kiss_fftr.h h8ball/kiss_fft.h
h8ball/h8ball.o: /usr/include/stdlib.h /usr/include/Availability.h
h8ball/h8ball.o: /usr/include/AvailabilityInternal.h /usr/include/_types.h
h8ball/h8ball.o: /usr/include/sys/_types.h /usr/include/sys/cdefs.h
h8ball/h8ball.o: /usr/include/sys/_symbol_aliasing.h
h8ball/h8ball.o: /usr/include/sys/_posix_availability.h
h8ball/h8ball.o: /usr/include/machine/_types.h /usr/include/i386/_types.h
h8ball/h8ball.o: /usr/include/sys/wait.h /usr/include/sys/signal.h
h8ball/h8ball.o: /usr/include/sys/appleapiopts.h
h8ball/h8ball.o: /usr/include/machine/signal.h /usr/include/i386/signal.h
h8ball/h8ball.o: /usr/include/i386/_structs.h /usr/include/sys/_structs.h
h8ball/h8ball.o: /usr/include/machine/_structs.h /usr/include/sys/resource.h
h8ball/h8ball.o: /usr/include/machine/endian.h /usr/include/i386/endian.h
h8ball/h8ball.o: /usr/include/sys/_endian.h
h8ball/h8ball.o: /usr/include/libkern/_OSByteOrder.h
h8ball/h8ball.o: /usr/include/libkern/i386/_OSByteOrder.h
h8ball/h8ball.o: /usr/include/alloca.h /usr/include/machine/types.h
h8ball/h8ball.o: /usr/include/i386/types.h /usr/include/stdio.h
h8ball/h8ball.o: /usr/include/secure/_stdio.h /usr/include/secure/_common.h
h8ball/h8ball.o: /usr/include/math.h /usr/include/string.h
h8ball/h8ball.o: /usr/include/strings.h /usr/include/secure/_string.h
h8ball/h8ball.o: /usr/include/sys/types.h h8ball/RingBuffer.h
h8ball/h8ball.o: ./wirish/include/wirish/wirish.h
h8ball/h8ball.o: ./libmaple/include/libmaple/stm32.h
h8ball/h8ball.o: ./libmaple/stm32f1/include/series/stm32.h
h8ball/h8ball.o: ./wirish/include/wirish/boards.h
h8ball/h8ball.o: ./libmaple/include/libmaple/libmaple_types.h
h8ball/h8ball.o: ./wirish/include/wirish/wirish_types.h
h8ball/h8ball.o: ./libmaple/include/libmaple/gpio.h
h8ball/h8ball.o: ./libmaple/stm32f1/include/series/gpio.h
h8ball/h8ball.o: ./libmaple/include/libmaple/exti.h
h8ball/h8ball.o: ./libmaple/stm32f1/include/series/exti.h
h8ball/h8ball.o: ./libmaple/include/libmaple/rcc.h
h8ball/h8ball.o: ./libmaple/stm32f1/include/series/rcc.h
h8ball/h8ball.o: ./libmaple/include/libmaple/timer.h
h8ball/h8ball.o: ./libmaple/stm32f1/include/series/timer.h
h8ball/h8ball.o: ./libmaple/include/libmaple/libmaple.h
h8ball/h8ball.o: ./libmaple/include/libmaple/util.h
h8ball/h8ball.o: ./libmaple/include/libmaple/delay.h
h8ball/h8ball.o: ./libmaple/include/libmaple/nvic.h
h8ball/h8ball.o: ./libmaple/stm32f1/include/series/nvic.h
h8ball/h8ball.o: ./libmaple/include/libmaple/bitband.h
h8ball/h8ball.o: ./libmaple/include/libmaple/adc.h
h8ball/h8ball.o: ./libmaple/stm32f1/include/series/adc.h
h8ball/h8ball.o: ./wirish/boards/maple_mini/include/board/board.h
h8ball/h8ball.o: ./wirish/include/wirish/io.h
h8ball/h8ball.o: ./wirish/include/wirish/bit_constants.h
h8ball/h8ball.o: ./wirish/include/wirish/pwm.h
h8ball/h8ball.o: ./wirish/include/wirish/ext_interrupts.h
h8ball/h8ball.o: ./wirish/include/wirish/wirish_debug.h
h8ball/h8ball.o: ./wirish/include/wirish/wirish_math.h
h8ball/h8ball.o: ./wirish/include/wirish/wirish_time.h
h8ball/h8ball.o: ./libmaple/include/libmaple/systick.h
h8ball/h8ball.o: ./wirish/include/wirish/HardwareSPI.h
h8ball/h8ball.o: ./libmaple/include/libmaple/spi.h
h8ball/h8ball.o: ./libmaple/stm32f1/include/series/spi.h
h8ball/h8ball.o: ./wirish/include/wirish/HardwareSerial.h
h8ball/h8ball.o: ./wirish/include/wirish/Print.h
h8ball/h8ball.o: ./wirish/include/wirish/HardwareTimer.h
h8ball/h8ball.o: ./wirish/include/wirish/usb_serial.h
h8ball/h8ball.o: ./libmaple/include/libmaple/SPI.h h8ball/Adafruit_GFX.h
h8ball/h8ball.o: ./wirish/include/wirish/WProgram.h h8ball/Adafruit_ILI9340.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/WProgram.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/wirish.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/stm32.h
h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/stm32.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/boards.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/libmaple_types.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/wirish_types.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/gpio.h
h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/gpio.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/exti.h
h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/exti.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/rcc.h
h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/rcc.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/timer.h
h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/timer.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/libmaple.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/util.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/delay.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/nvic.h
h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/nvic.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/bitband.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/adc.h
h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/adc.h
h8ball/Adafruit_GFX.o: ./wirish/boards/maple_mini/include/board/board.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/io.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/bit_constants.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/pwm.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/ext_interrupts.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/wirish_debug.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/wirish_math.h
h8ball/Adafruit_GFX.o: /usr/include/math.h /usr/include/sys/cdefs.h
h8ball/Adafruit_GFX.o: /usr/include/sys/_symbol_aliasing.h
h8ball/Adafruit_GFX.o: /usr/include/sys/_posix_availability.h
h8ball/Adafruit_GFX.o: /usr/include/Availability.h
h8ball/Adafruit_GFX.o: /usr/include/AvailabilityInternal.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/wirish_time.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/systick.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/HardwareSPI.h
h8ball/Adafruit_GFX.o: ./libmaple/include/libmaple/spi.h
h8ball/Adafruit_GFX.o: ./libmaple/stm32f1/include/series/spi.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/HardwareSerial.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/Print.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/HardwareTimer.h
h8ball/Adafruit_GFX.o: ./wirish/include/wirish/usb_serial.h
h8ball/Adafruit_GFX.o: /usr/include/stdint.h
h8ball/Adafruit_ILI9340.o: h8ball/Adafruit_GFX.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/WProgram.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/wirish.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/stm32.h
h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/stm32.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/boards.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/libmaple_types.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/wirish_types.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/gpio.h
h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/gpio.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/exti.h
h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/exti.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/rcc.h
h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/rcc.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/timer.h
h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/timer.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/libmaple.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/util.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/delay.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/nvic.h
h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/nvic.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/bitband.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/adc.h
h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/adc.h
h8ball/Adafruit_ILI9340.o: ./wirish/boards/maple_mini/include/board/board.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/io.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/bit_constants.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/pwm.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/ext_interrupts.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/wirish_debug.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/wirish_math.h
h8ball/Adafruit_ILI9340.o: /usr/include/math.h /usr/include/sys/cdefs.h
h8ball/Adafruit_ILI9340.o: /usr/include/sys/_symbol_aliasing.h
h8ball/Adafruit_ILI9340.o: /usr/include/sys/_posix_availability.h
h8ball/Adafruit_ILI9340.o: /usr/include/Availability.h
h8ball/Adafruit_ILI9340.o: /usr/include/AvailabilityInternal.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/wirish_time.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/systick.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/HardwareSPI.h
h8ball/Adafruit_ILI9340.o: ./libmaple/include/libmaple/spi.h
h8ball/Adafruit_ILI9340.o: ./libmaple/stm32f1/include/series/spi.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/HardwareSerial.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/Print.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/HardwareTimer.h
h8ball/Adafruit_ILI9340.o: ./wirish/include/wirish/usb_serial.h
h8ball/Adafruit_ILI9340.o: /usr/include/stdint.h
h8ball/RingBuffer.o: /usr/include/stdint.h ./wirish/include/wirish/wirish.h
h8ball/RingBuffer.o: ./libmaple/include/libmaple/stm32.h
h8ball/RingBuffer.o: ./libmaple/stm32f1/include/series/stm32.h
h8ball/RingBuffer.o: ./wirish/include/wirish/boards.h
h8ball/RingBuffer.o: ./libmaple/include/libmaple/libmaple_types.h
h8ball/RingBuffer.o: ./wirish/include/wirish/wirish_types.h
h8ball/RingBuffer.o: ./libmaple/include/libmaple/gpio.h
h8ball/RingBuffer.o: ./libmaple/stm32f1/include/series/gpio.h
h8ball/RingBuffer.o: ./libmaple/include/libmaple/exti.h
h8ball/RingBuffer.o: ./libmaple/stm32f1/include/series/exti.h
h8ball/RingBuffer.o: ./libmaple/include/libmaple/rcc.h
h8ball/RingBuffer.o: ./libmaple/stm32f1/include/series/rcc.h
h8ball/RingBuffer.o: ./libmaple/include/libmaple/timer.h
h8ball/RingBuffer.o: ./libmaple/stm32f1/include/series/timer.h
h8ball/RingBuffer.o: ./libmaple/include/libmaple/libmaple.h
h8ball/RingBuffer.o: ./libmaple/include/libmaple/util.h
h8ball/RingBuffer.o: ./libmaple/include/libmaple/delay.h
h8ball/RingBuffer.o: ./libmaple/include/libmaple/nvic.h
h8ball/RingBuffer.o: ./libmaple/stm32f1/include/series/nvic.h
h8ball/RingBuffer.o: ./libmaple/include/libmaple/bitband.h
h8ball/RingBuffer.o: ./libmaple/include/libmaple/adc.h
h8ball/RingBuffer.o: ./libmaple/stm32f1/include/series/adc.h
h8ball/RingBuffer.o: ./wirish/boards/maple_mini/include/board/board.h
h8ball/RingBuffer.o: ./wirish/include/wirish/io.h
h8ball/RingBuffer.o: ./wirish/include/wirish/bit_constants.h
h8ball/RingBuffer.o: ./wirish/include/wirish/pwm.h
h8ball/RingBuffer.o: ./wirish/include/wirish/ext_interrupts.h
h8ball/RingBuffer.o: ./wirish/include/wirish/wirish_debug.h
h8ball/RingBuffer.o: ./wirish/include/wirish/wirish_math.h
h8ball/RingBuffer.o: /usr/include/math.h /usr/include/sys/cdefs.h
h8ball/RingBuffer.o: /usr/include/sys/_symbol_aliasing.h
h8ball/RingBuffer.o: /usr/include/sys/_posix_availability.h
h8ball/RingBuffer.o: /usr/include/Availability.h
h8ball/RingBuffer.o: /usr/include/AvailabilityInternal.h
h8ball/RingBuffer.o: ./wirish/include/wirish/wirish_time.h
h8ball/RingBuffer.o: ./libmaple/include/libmaple/systick.h
h8ball/RingBuffer.o: ./wirish/include/wirish/HardwareSPI.h
h8ball/RingBuffer.o: ./libmaple/include/libmaple/spi.h
h8ball/RingBuffer.o: ./libmaple/stm32f1/include/series/spi.h
h8ball/RingBuffer.o: ./wirish/include/wirish/HardwareSerial.h
h8ball/RingBuffer.o: ./wirish/include/wirish/Print.h
h8ball/RingBuffer.o: ./wirish/include/wirish/HardwareTimer.h
h8ball/RingBuffer.o: ./wirish/include/wirish/usb_serial.h
h8ball/_kiss_fft_guts.o: h8ball/kiss_fft.h /usr/include/stdint.h
h8ball/_kiss_fft_guts.o: /usr/include/stdlib.h /usr/include/Availability.h
h8ball/_kiss_fft_guts.o: /usr/include/AvailabilityInternal.h
h8ball/_kiss_fft_guts.o: /usr/include/_types.h /usr/include/sys/_types.h
h8ball/_kiss_fft_guts.o: /usr/include/sys/cdefs.h
h8ball/_kiss_fft_guts.o: /usr/include/sys/_symbol_aliasing.h
h8ball/_kiss_fft_guts.o: /usr/include/sys/_posix_availability.h
h8ball/_kiss_fft_guts.o: /usr/include/machine/_types.h
h8ball/_kiss_fft_guts.o: /usr/include/i386/_types.h /usr/include/sys/wait.h
h8ball/_kiss_fft_guts.o: /usr/include/sys/signal.h
h8ball/_kiss_fft_guts.o: /usr/include/sys/appleapiopts.h
h8ball/_kiss_fft_guts.o: /usr/include/machine/signal.h
h8ball/_kiss_fft_guts.o: /usr/include/i386/signal.h
h8ball/_kiss_fft_guts.o: /usr/include/i386/_structs.h
h8ball/_kiss_fft_guts.o: /usr/include/sys/_structs.h
h8ball/_kiss_fft_guts.o: /usr/include/machine/_structs.h
h8ball/_kiss_fft_guts.o: /usr/include/sys/resource.h
h8ball/_kiss_fft_guts.o: /usr/include/machine/endian.h
h8ball/_kiss_fft_guts.o: /usr/include/i386/endian.h
h8ball/_kiss_fft_guts.o: /usr/include/sys/_endian.h
h8ball/_kiss_fft_guts.o: /usr/include/libkern/_OSByteOrder.h
h8ball/_kiss_fft_guts.o: /usr/include/libkern/i386/_OSByteOrder.h
h8ball/_kiss_fft_guts.o: /usr/include/alloca.h /usr/include/machine/types.h
h8ball/_kiss_fft_guts.o: /usr/include/i386/types.h /usr/include/stdio.h
h8ball/_kiss_fft_guts.o: /usr/include/secure/_stdio.h
h8ball/_kiss_fft_guts.o: /usr/include/secure/_common.h /usr/include/math.h
h8ball/_kiss_fft_guts.o: /usr/include/string.h /usr/include/strings.h
h8ball/_kiss_fft_guts.o: /usr/include/secure/_string.h
h8ball/_kiss_fft_guts.o: /usr/include/sys/types.h /usr/include/limits.h
h8ball/_kiss_fft_guts.o: /usr/include/machine/limits.h
h8ball/_kiss_fft_guts.o: /usr/include/i386/limits.h
h8ball/_kiss_fft_guts.o: /usr/include/i386/_limits.h
h8ball/_kiss_fft_guts.o: /usr/include/sys/syslimits.h
h8ball/kiss_fft.o: /usr/include/stdint.h /usr/include/stdlib.h
h8ball/kiss_fft.o: /usr/include/Availability.h
h8ball/kiss_fft.o: /usr/include/AvailabilityInternal.h /usr/include/_types.h
h8ball/kiss_fft.o: /usr/include/sys/_types.h /usr/include/sys/cdefs.h
h8ball/kiss_fft.o: /usr/include/sys/_symbol_aliasing.h
h8ball/kiss_fft.o: /usr/include/sys/_posix_availability.h
h8ball/kiss_fft.o: /usr/include/machine/_types.h /usr/include/i386/_types.h
h8ball/kiss_fft.o: /usr/include/sys/wait.h /usr/include/sys/signal.h
h8ball/kiss_fft.o: /usr/include/sys/appleapiopts.h
h8ball/kiss_fft.o: /usr/include/machine/signal.h /usr/include/i386/signal.h
h8ball/kiss_fft.o: /usr/include/i386/_structs.h /usr/include/sys/_structs.h
h8ball/kiss_fft.o: /usr/include/machine/_structs.h
h8ball/kiss_fft.o: /usr/include/sys/resource.h /usr/include/machine/endian.h
h8ball/kiss_fft.o: /usr/include/i386/endian.h /usr/include/sys/_endian.h
h8ball/kiss_fft.o: /usr/include/libkern/_OSByteOrder.h
h8ball/kiss_fft.o: /usr/include/libkern/i386/_OSByteOrder.h
h8ball/kiss_fft.o: /usr/include/alloca.h /usr/include/machine/types.h
h8ball/kiss_fft.o: /usr/include/i386/types.h /usr/include/stdio.h
h8ball/kiss_fft.o: /usr/include/secure/_stdio.h /usr/include/secure/_common.h
h8ball/kiss_fft.o: /usr/include/math.h /usr/include/string.h
h8ball/kiss_fft.o: /usr/include/strings.h /usr/include/secure/_string.h
h8ball/kiss_fft.o: /usr/include/sys/types.h
h8ball/kiss_fftr.o: /usr/include/stdint.h h8ball/kiss_fft.h
h8ball/kiss_fftr.o: /usr/include/stdlib.h /usr/include/Availability.h
h8ball/kiss_fftr.o: /usr/include/AvailabilityInternal.h /usr/include/_types.h
h8ball/kiss_fftr.o: /usr/include/sys/_types.h /usr/include/sys/cdefs.h
h8ball/kiss_fftr.o: /usr/include/sys/_symbol_aliasing.h
h8ball/kiss_fftr.o: /usr/include/sys/_posix_availability.h
h8ball/kiss_fftr.o: /usr/include/machine/_types.h /usr/include/i386/_types.h
h8ball/kiss_fftr.o: /usr/include/sys/wait.h /usr/include/sys/signal.h
h8ball/kiss_fftr.o: /usr/include/sys/appleapiopts.h
h8ball/kiss_fftr.o: /usr/include/machine/signal.h /usr/include/i386/signal.h
h8ball/kiss_fftr.o: /usr/include/i386/_structs.h /usr/include/sys/_structs.h
h8ball/kiss_fftr.o: /usr/include/machine/_structs.h
h8ball/kiss_fftr.o: /usr/include/sys/resource.h /usr/include/machine/endian.h
h8ball/kiss_fftr.o: /usr/include/i386/endian.h /usr/include/sys/_endian.h
h8ball/kiss_fftr.o: /usr/include/libkern/_OSByteOrder.h
h8ball/kiss_fftr.o: /usr/include/libkern/i386/_OSByteOrder.h
h8ball/kiss_fftr.o: /usr/include/alloca.h /usr/include/machine/types.h
h8ball/kiss_fftr.o: /usr/include/i386/types.h /usr/include/stdio.h
h8ball/kiss_fftr.o: /usr/include/secure/_stdio.h
h8ball/kiss_fftr.o: /usr/include/secure/_common.h /usr/include/math.h
h8ball/kiss_fftr.o: /usr/include/string.h /usr/include/strings.h
h8ball/kiss_fftr.o: /usr/include/secure/_string.h /usr/include/sys/types.h
wirish/HardwareSPI.o: ./wirish/include/wirish/HardwareSPI.h
wirish/HardwareSPI.o: ./libmaple/include/libmaple/libmaple_types.h
wirish/HardwareSPI.o: ./libmaple/include/libmaple/spi.h
wirish/HardwareSPI.o: ./libmaple/include/libmaple/rcc.h
wirish/HardwareSPI.o: ./libmaple/stm32f1/include/series/rcc.h
wirish/HardwareSPI.o: ./libmaple/include/libmaple/nvic.h
wirish/HardwareSPI.o: ./libmaple/include/libmaple/util.h
wirish/HardwareSPI.o: ./libmaple/stm32f1/include/series/nvic.h
wirish/HardwareSPI.o: ./libmaple/include/libmaple/stm32.h
wirish/HardwareSPI.o: ./libmaple/stm32f1/include/series/stm32.h
wirish/HardwareSPI.o: ./libmaple/stm32f1/include/series/spi.h
wirish/HardwareSPI.o: ./wirish/include/wirish/boards.h
wirish/HardwareSPI.o: ./wirish/include/wirish/wirish_types.h
wirish/HardwareSPI.o: ./libmaple/include/libmaple/gpio.h
wirish/HardwareSPI.o: ./libmaple/stm32f1/include/series/gpio.h
wirish/HardwareSPI.o: ./libmaple/include/libmaple/exti.h
wirish/HardwareSPI.o: ./libmaple/stm32f1/include/series/exti.h
wirish/HardwareSPI.o: ./libmaple/include/libmaple/timer.h
wirish/HardwareSPI.o: ./libmaple/stm32f1/include/series/timer.h
wirish/HardwareSPI.o: ./libmaple/include/libmaple/libmaple.h
wirish/HardwareSPI.o: ./libmaple/include/libmaple/delay.h
wirish/HardwareSPI.o: ./libmaple/include/libmaple/bitband.h
wirish/HardwareSPI.o: ./libmaple/include/libmaple/adc.h
wirish/HardwareSPI.o: ./libmaple/stm32f1/include/series/adc.h
wirish/HardwareSPI.o: ./wirish/boards/maple_mini/include/board/board.h
wirish/HardwareSPI.o: ./wirish/include/wirish/wirish.h
wirish/HardwareSPI.o: ./wirish/include/wirish/io.h
wirish/HardwareSPI.o: ./wirish/include/wirish/bit_constants.h
wirish/HardwareSPI.o: ./wirish/include/wirish/pwm.h
wirish/HardwareSPI.o: ./wirish/include/wirish/ext_interrupts.h
wirish/HardwareSPI.o: ./wirish/include/wirish/wirish_debug.h
wirish/HardwareSPI.o: ./wirish/include/wirish/wirish_math.h
wirish/HardwareSPI.o: /usr/include/math.h /usr/include/sys/cdefs.h
wirish/HardwareSPI.o: /usr/include/sys/_symbol_aliasing.h
wirish/HardwareSPI.o: /usr/include/sys/_posix_availability.h
wirish/HardwareSPI.o: /usr/include/Availability.h
wirish/HardwareSPI.o: /usr/include/AvailabilityInternal.h
wirish/HardwareSPI.o: ./wirish/include/wirish/wirish_time.h
wirish/HardwareSPI.o: ./libmaple/include/libmaple/systick.h
wirish/HardwareSPI.o: ./wirish/include/wirish/HardwareSerial.h
wirish/HardwareSPI.o: ./wirish/include/wirish/Print.h
wirish/HardwareSPI.o: ./wirish/include/wirish/HardwareTimer.h
wirish/HardwareSPI.o: ./wirish/include/wirish/usb_serial.h
wirish/HardwareSPI.o: /usr/include/stdint.h
wirish/HardwareSerial.o: ./wirish/include/wirish/HardwareSerial.h
wirish/HardwareSerial.o: ./libmaple/include/libmaple/libmaple_types.h
wirish/HardwareSerial.o: ./wirish/include/wirish/Print.h
wirish/HardwareSerial.o: ./wirish/include/wirish/boards.h
wirish/HardwareSerial.o: ./wirish/include/wirish/wirish_types.h
wirish/HardwareSerial.o: ./libmaple/include/libmaple/gpio.h
wirish/HardwareSerial.o: ./libmaple/stm32f1/include/series/gpio.h
wirish/HardwareSerial.o: ./libmaple/include/libmaple/stm32.h
wirish/HardwareSerial.o: ./libmaple/stm32f1/include/series/stm32.h
wirish/HardwareSerial.o: ./libmaple/include/libmaple/exti.h
wirish/HardwareSerial.o: ./libmaple/stm32f1/include/series/exti.h
wirish/HardwareSerial.o: ./libmaple/include/libmaple/rcc.h
wirish/HardwareSerial.o: ./libmaple/stm32f1/include/series/rcc.h
wirish/HardwareSerial.o: ./libmaple/include/libmaple/timer.h
wirish/HardwareSerial.o: ./libmaple/stm32f1/include/series/timer.h
wirish/HardwareSerial.o: ./libmaple/include/libmaple/libmaple.h
wirish/HardwareSerial.o: ./libmaple/include/libmaple/util.h
wirish/HardwareSerial.o: ./libmaple/include/libmaple/delay.h
wirish/HardwareSerial.o: ./libmaple/include/libmaple/nvic.h
wirish/HardwareSerial.o: ./libmaple/stm32f1/include/series/nvic.h
wirish/HardwareSerial.o: ./libmaple/include/libmaple/bitband.h
wirish/HardwareSerial.o: ./libmaple/include/libmaple/adc.h
wirish/HardwareSerial.o: ./libmaple/stm32f1/include/series/adc.h
wirish/HardwareSerial.o: ./wirish/boards/maple_mini/include/board/board.h
wirish/HardwareSerial.o: ./libmaple/include/libmaple/usart.h
wirish/HardwareSerial.o: ./libmaple/include/libmaple/ring_buffer.h
wirish/HardwareSerial.o: ./libmaple/stm32f1/include/series/usart.h
wirish/HardwareTimer.o: ./wirish/include/wirish/HardwareTimer.h
wirish/HardwareTimer.o: ./libmaple/include/libmaple/timer.h
wirish/HardwareTimer.o: ./libmaple/stm32f1/include/series/timer.h
wirish/HardwareTimer.o: ./libmaple/include/libmaple/libmaple_types.h
wirish/HardwareTimer.o: ./libmaple/include/libmaple/libmaple.h
wirish/HardwareTimer.o: ./libmaple/include/libmaple/stm32.h
wirish/HardwareTimer.o: ./libmaple/stm32f1/include/series/stm32.h
wirish/HardwareTimer.o: ./libmaple/include/libmaple/util.h
wirish/HardwareTimer.o: ./libmaple/include/libmaple/delay.h
wirish/HardwareTimer.o: ./libmaple/include/libmaple/rcc.h
wirish/HardwareTimer.o: ./libmaple/stm32f1/include/series/rcc.h
wirish/HardwareTimer.o: ./libmaple/include/libmaple/nvic.h
wirish/HardwareTimer.o: ./libmaple/stm32f1/include/series/nvic.h
wirish/HardwareTimer.o: ./libmaple/include/libmaple/bitband.h
wirish/HardwareTimer.o: ./wirish/include/wirish/ext_interrupts.h
wirish/HardwareTimer.o: ./wirish/include/wirish/wirish_math.h
wirish/HardwareTimer.o: /usr/include/math.h /usr/include/sys/cdefs.h
wirish/HardwareTimer.o: /usr/include/sys/_symbol_aliasing.h
wirish/HardwareTimer.o: /usr/include/sys/_posix_availability.h
wirish/HardwareTimer.o: /usr/include/Availability.h
wirish/HardwareTimer.o: /usr/include/AvailabilityInternal.h
wirish/HardwareTimer.o: ./wirish/boards/maple_mini/include/board/board.h
wirish/Print.o: ./wirish/include/wirish/Print.h
wirish/Print.o: ./libmaple/include/libmaple/libmaple_types.h
wirish/Print.o: ./wirish/include/wirish/wirish_math.h /usr/include/math.h
wirish/Print.o: /usr/include/sys/cdefs.h /usr/include/sys/_symbol_aliasing.h
wirish/Print.o: /usr/include/sys/_posix_availability.h
wirish/Print.o: /usr/include/Availability.h
wirish/Print.o: /usr/include/AvailabilityInternal.h /usr/include/limits.h
wirish/Print.o: /usr/include/machine/limits.h /usr/include/i386/limits.h
wirish/Print.o: /usr/include/i386/_limits.h /usr/include/sys/syslimits.h
wirish/boards.o: ./wirish/include/wirish/boards.h
wirish/boards.o: ./libmaple/include/libmaple/libmaple_types.h
wirish/boards.o: ./wirish/include/wirish/wirish_types.h
wirish/boards.o: ./libmaple/include/libmaple/gpio.h
wirish/boards.o: ./libmaple/stm32f1/include/series/gpio.h
wirish/boards.o: ./libmaple/include/libmaple/stm32.h
wirish/boards.o: ./libmaple/stm32f1/include/series/stm32.h
wirish/boards.o: ./libmaple/include/libmaple/exti.h
wirish/boards.o: ./libmaple/stm32f1/include/series/exti.h
wirish/boards.o: ./libmaple/include/libmaple/rcc.h
wirish/boards.o: ./libmaple/stm32f1/include/series/rcc.h
wirish/boards.o: ./libmaple/include/libmaple/timer.h
wirish/boards.o: ./libmaple/stm32f1/include/series/timer.h
wirish/boards.o: ./libmaple/include/libmaple/libmaple.h
wirish/boards.o: ./libmaple/include/libmaple/util.h
wirish/boards.o: ./libmaple/include/libmaple/delay.h
wirish/boards.o: ./libmaple/include/libmaple/nvic.h
wirish/boards.o: ./libmaple/stm32f1/include/series/nvic.h
wirish/boards.o: ./libmaple/include/libmaple/bitband.h
wirish/boards.o: ./libmaple/include/libmaple/adc.h
wirish/boards.o: ./libmaple/stm32f1/include/series/adc.h
wirish/boards.o: ./wirish/boards/maple_mini/include/board/board.h
wirish/boards.o: ./libmaple/include/libmaple/flash.h
wirish/boards.o: ./libmaple/stm32f1/include/series/flash.h
wirish/boards.o: ./libmaple/include/libmaple/systick.h
wirish/boards.o: wirish/boards_private.h
wirish/ext_interrupts.o: ./wirish/include/wirish/ext_interrupts.h
wirish/ext_interrupts.o: ./libmaple/include/libmaple/libmaple_types.h
wirish/ext_interrupts.o: ./libmaple/include/libmaple/nvic.h
wirish/ext_interrupts.o: ./libmaple/include/libmaple/util.h
wirish/ext_interrupts.o: ./libmaple/stm32f1/include/series/nvic.h
wirish/ext_interrupts.o: ./libmaple/include/libmaple/stm32.h
wirish/ext_interrupts.o: ./libmaple/stm32f1/include/series/stm32.h
wirish/ext_interrupts.o: ./libmaple/include/libmaple/gpio.h
wirish/ext_interrupts.o: ./libmaple/stm32f1/include/series/gpio.h
wirish/ext_interrupts.o: ./libmaple/include/libmaple/exti.h
wirish/ext_interrupts.o: ./libmaple/stm32f1/include/series/exti.h
wirish/ext_interrupts.o: ./libmaple/include/libmaple/rcc.h
wirish/ext_interrupts.o: ./libmaple/stm32f1/include/series/rcc.h
wirish/ext_interrupts.o: ./wirish/include/wirish/boards.h
wirish/ext_interrupts.o: ./wirish/include/wirish/wirish_types.h
wirish/ext_interrupts.o: ./libmaple/include/libmaple/timer.h
wirish/ext_interrupts.o: ./libmaple/stm32f1/include/series/timer.h
wirish/ext_interrupts.o: ./libmaple/include/libmaple/libmaple.h
wirish/ext_interrupts.o: ./libmaple/include/libmaple/delay.h
wirish/ext_interrupts.o: ./libmaple/include/libmaple/bitband.h
wirish/ext_interrupts.o: ./libmaple/include/libmaple/adc.h
wirish/ext_interrupts.o: ./libmaple/stm32f1/include/series/adc.h
wirish/ext_interrupts.o: ./wirish/boards/maple_mini/include/board/board.h
wirish/pwm.o: ./wirish/include/wirish/pwm.h
wirish/pwm.o: ./libmaple/include/libmaple/libmaple_types.h
wirish/pwm.o: ./libmaple/include/libmaple/timer.h
wirish/pwm.o: ./libmaple/stm32f1/include/series/timer.h
wirish/pwm.o: ./libmaple/include/libmaple/libmaple.h
wirish/pwm.o: ./libmaple/include/libmaple/stm32.h
wirish/pwm.o: ./libmaple/stm32f1/include/series/stm32.h
wirish/pwm.o: ./libmaple/include/libmaple/util.h
wirish/pwm.o: ./libmaple/include/libmaple/delay.h
wirish/pwm.o: ./libmaple/include/libmaple/rcc.h
wirish/pwm.o: ./libmaple/stm32f1/include/series/rcc.h
wirish/pwm.o: ./libmaple/include/libmaple/nvic.h
wirish/pwm.o: ./libmaple/stm32f1/include/series/nvic.h
wirish/pwm.o: ./libmaple/include/libmaple/bitband.h
wirish/pwm.o: ./wirish/include/wirish/boards.h
wirish/pwm.o: ./wirish/include/wirish/wirish_types.h
wirish/pwm.o: ./libmaple/include/libmaple/gpio.h
wirish/pwm.o: ./libmaple/stm32f1/include/series/gpio.h
wirish/pwm.o: ./libmaple/include/libmaple/exti.h
wirish/pwm.o: ./libmaple/stm32f1/include/series/exti.h
wirish/pwm.o: ./libmaple/include/libmaple/adc.h
wirish/pwm.o: ./libmaple/stm32f1/include/series/adc.h
wirish/pwm.o: ./wirish/boards/maple_mini/include/board/board.h
wirish/usb_serial.o: ./wirish/include/wirish/usb_serial.h
wirish/usb_serial.o: ./wirish/include/wirish/Print.h
wirish/usb_serial.o: ./libmaple/include/libmaple/libmaple_types.h
wirish/usb_serial.o: ./wirish/include/wirish/boards.h
wirish/usb_serial.o: ./wirish/include/wirish/wirish_types.h
wirish/usb_serial.o: ./libmaple/include/libmaple/gpio.h
wirish/usb_serial.o: ./libmaple/stm32f1/include/series/gpio.h
wirish/usb_serial.o: ./libmaple/include/libmaple/stm32.h
wirish/usb_serial.o: ./libmaple/stm32f1/include/series/stm32.h
wirish/usb_serial.o: ./libmaple/include/libmaple/exti.h
wirish/usb_serial.o: ./libmaple/stm32f1/include/series/exti.h
wirish/usb_serial.o: ./libmaple/include/libmaple/rcc.h
wirish/usb_serial.o: ./libmaple/stm32f1/include/series/rcc.h
wirish/usb_serial.o: ./libmaple/include/libmaple/timer.h
wirish/usb_serial.o: ./libmaple/stm32f1/include/series/timer.h
wirish/usb_serial.o: ./libmaple/include/libmaple/libmaple.h
wirish/usb_serial.o: ./libmaple/include/libmaple/util.h
wirish/usb_serial.o: ./libmaple/include/libmaple/delay.h
wirish/usb_serial.o: ./libmaple/include/libmaple/nvic.h
wirish/usb_serial.o: ./libmaple/stm32f1/include/series/nvic.h
wirish/usb_serial.o: ./libmaple/include/libmaple/bitband.h
wirish/usb_serial.o: ./libmaple/include/libmaple/adc.h
wirish/usb_serial.o: ./libmaple/stm32f1/include/series/adc.h
wirish/usb_serial.o: ./wirish/boards/maple_mini/include/board/board.h
wirish/usb_serial.o: /usr/include/string.h /usr/include/_types.h
wirish/usb_serial.o: /usr/include/sys/_types.h /usr/include/sys/cdefs.h
wirish/usb_serial.o: /usr/include/sys/_symbol_aliasing.h
wirish/usb_serial.o: /usr/include/sys/_posix_availability.h
wirish/usb_serial.o: /usr/include/machine/_types.h /usr/include/i386/_types.h
wirish/usb_serial.o: /usr/include/Availability.h
wirish/usb_serial.o: /usr/include/AvailabilityInternal.h
wirish/usb_serial.o: /usr/include/strings.h /usr/include/secure/_string.h
wirish/usb_serial.o: /usr/include/secure/_common.h /usr/include/stdint.h
wirish/usb_serial.o: ./libmaple/include/libmaple/usb_cdcacm.h
wirish/usb_serial.o: ./libmaple/include/libmaple/usb.h
wirish/usb_serial.o: ./wirish/include/wirish/wirish.h
wirish/usb_serial.o: ./wirish/include/wirish/io.h
wirish/usb_serial.o: ./wirish/include/wirish/bit_constants.h
wirish/usb_serial.o: ./wirish/include/wirish/pwm.h
wirish/usb_serial.o: ./wirish/include/wirish/ext_interrupts.h
wirish/usb_serial.o: ./wirish/include/wirish/wirish_debug.h
wirish/usb_serial.o: ./wirish/include/wirish/wirish_math.h
wirish/usb_serial.o: /usr/include/math.h
wirish/usb_serial.o: ./wirish/include/wirish/wirish_time.h
wirish/usb_serial.o: ./libmaple/include/libmaple/systick.h
wirish/usb_serial.o: ./wirish/include/wirish/HardwareSPI.h
wirish/usb_serial.o: ./libmaple/include/libmaple/spi.h
wirish/usb_serial.o: ./libmaple/stm32f1/include/series/spi.h
wirish/usb_serial.o: ./wirish/include/wirish/HardwareSerial.h
wirish/usb_serial.o: ./wirish/include/wirish/HardwareTimer.h
wirish/wirish_analog.o: ./wirish/include/wirish/io.h
wirish/wirish_analog.o: ./libmaple/include/libmaple/libmaple_types.h
wirish/wirish_analog.o: ./wirish/include/wirish/boards.h
wirish/wirish_analog.o: ./wirish/include/wirish/wirish_types.h
wirish/wirish_analog.o: ./libmaple/include/libmaple/gpio.h
wirish/wirish_analog.o: ./libmaple/stm32f1/include/series/gpio.h
wirish/wirish_analog.o: ./libmaple/include/libmaple/stm32.h
wirish/wirish_analog.o: ./libmaple/stm32f1/include/series/stm32.h
wirish/wirish_analog.o: ./libmaple/include/libmaple/exti.h
wirish/wirish_analog.o: ./libmaple/stm32f1/include/series/exti.h
wirish/wirish_analog.o: ./libmaple/include/libmaple/rcc.h
wirish/wirish_analog.o: ./libmaple/stm32f1/include/series/rcc.h
wirish/wirish_analog.o: ./libmaple/include/libmaple/timer.h
wirish/wirish_analog.o: ./libmaple/stm32f1/include/series/timer.h
wirish/wirish_analog.o: ./libmaple/include/libmaple/libmaple.h
wirish/wirish_analog.o: ./libmaple/include/libmaple/util.h
wirish/wirish_analog.o: ./libmaple/include/libmaple/delay.h
wirish/wirish_analog.o: ./libmaple/include/libmaple/nvic.h
wirish/wirish_analog.o: ./libmaple/stm32f1/include/series/nvic.h
wirish/wirish_analog.o: ./libmaple/include/libmaple/bitband.h
wirish/wirish_analog.o: ./libmaple/include/libmaple/adc.h
wirish/wirish_analog.o: ./libmaple/stm32f1/include/series/adc.h
wirish/wirish_analog.o: ./wirish/boards/maple_mini/include/board/board.h
wirish/wirish_digital.o: ./wirish/include/wirish/io.h
wirish/wirish_digital.o: ./libmaple/include/libmaple/libmaple_types.h
wirish/wirish_digital.o: ./wirish/include/wirish/boards.h
wirish/wirish_digital.o: ./wirish/include/wirish/wirish_types.h
wirish/wirish_digital.o: ./libmaple/include/libmaple/gpio.h
wirish/wirish_digital.o: ./libmaple/stm32f1/include/series/gpio.h
wirish/wirish_digital.o: ./libmaple/include/libmaple/stm32.h
wirish/wirish_digital.o: ./libmaple/stm32f1/include/series/stm32.h
wirish/wirish_digital.o: ./libmaple/include/libmaple/exti.h
wirish/wirish_digital.o: ./libmaple/stm32f1/include/series/exti.h
wirish/wirish_digital.o: ./libmaple/include/libmaple/rcc.h
wirish/wirish_digital.o: ./libmaple/stm32f1/include/series/rcc.h
wirish/wirish_digital.o: ./libmaple/include/libmaple/timer.h
wirish/wirish_digital.o: ./libmaple/stm32f1/include/series/timer.h
wirish/wirish_digital.o: ./libmaple/include/libmaple/libmaple.h
wirish/wirish_digital.o: ./libmaple/include/libmaple/util.h
wirish/wirish_digital.o: ./libmaple/include/libmaple/delay.h
wirish/wirish_digital.o: ./libmaple/include/libmaple/nvic.h
wirish/wirish_digital.o: ./libmaple/stm32f1/include/series/nvic.h
wirish/wirish_digital.o: ./libmaple/include/libmaple/bitband.h
wirish/wirish_digital.o: ./libmaple/include/libmaple/adc.h
wirish/wirish_digital.o: ./libmaple/stm32f1/include/series/adc.h
wirish/wirish_digital.o: ./wirish/boards/maple_mini/include/board/board.h
wirish/wirish_digital.o: ./wirish/include/wirish/wirish_time.h
wirish/wirish_digital.o: ./libmaple/include/libmaple/systick.h
wirish/wirish_math.o: /usr/include/stdlib.h /usr/include/Availability.h
wirish/wirish_math.o: /usr/include/AvailabilityInternal.h
wirish/wirish_math.o: /usr/include/_types.h /usr/include/sys/_types.h
wirish/wirish_math.o: /usr/include/sys/cdefs.h
wirish/wirish_math.o: /usr/include/sys/_symbol_aliasing.h
wirish/wirish_math.o: /usr/include/sys/_posix_availability.h
wirish/wirish_math.o: /usr/include/machine/_types.h
wirish/wirish_math.o: /usr/include/i386/_types.h /usr/include/sys/wait.h
wirish/wirish_math.o: /usr/include/sys/signal.h
wirish/wirish_math.o: /usr/include/sys/appleapiopts.h
wirish/wirish_math.o: /usr/include/machine/signal.h
wirish/wirish_math.o: /usr/include/i386/signal.h /usr/include/i386/_structs.h
wirish/wirish_math.o: /usr/include/sys/_structs.h
wirish/wirish_math.o: /usr/include/machine/_structs.h
wirish/wirish_math.o: /usr/include/sys/resource.h
wirish/wirish_math.o: /usr/include/machine/endian.h
wirish/wirish_math.o: /usr/include/i386/endian.h /usr/include/sys/_endian.h
wirish/wirish_math.o: /usr/include/libkern/_OSByteOrder.h
wirish/wirish_math.o: /usr/include/libkern/i386/_OSByteOrder.h
wirish/wirish_math.o: /usr/include/alloca.h /usr/include/machine/types.h
wirish/wirish_math.o: /usr/include/i386/types.h
wirish/wirish_math.o: ./wirish/include/wirish/wirish_math.h
wirish/wirish_math.o: /usr/include/math.h
wirish/wirish_shift.o: ./wirish/include/wirish/wirish.h
wirish/wirish_shift.o: ./libmaple/include/libmaple/stm32.h
wirish/wirish_shift.o: ./libmaple/stm32f1/include/series/stm32.h
wirish/wirish_shift.o: ./wirish/include/wirish/boards.h
wirish/wirish_shift.o: ./libmaple/include/libmaple/libmaple_types.h
wirish/wirish_shift.o: ./wirish/include/wirish/wirish_types.h
wirish/wirish_shift.o: ./libmaple/include/libmaple/gpio.h
wirish/wirish_shift.o: ./libmaple/stm32f1/include/series/gpio.h
wirish/wirish_shift.o: ./libmaple/include/libmaple/exti.h
wirish/wirish_shift.o: ./libmaple/stm32f1/include/series/exti.h
wirish/wirish_shift.o: ./libmaple/include/libmaple/rcc.h
wirish/wirish_shift.o: ./libmaple/stm32f1/include/series/rcc.h
wirish/wirish_shift.o: ./libmaple/include/libmaple/timer.h
wirish/wirish_shift.o: ./libmaple/stm32f1/include/series/timer.h
wirish/wirish_shift.o: ./libmaple/include/libmaple/libmaple.h
wirish/wirish_shift.o: ./libmaple/include/libmaple/util.h
wirish/wirish_shift.o: ./libmaple/include/libmaple/delay.h
wirish/wirish_shift.o: ./libmaple/include/libmaple/nvic.h
wirish/wirish_shift.o: ./libmaple/stm32f1/include/series/nvic.h
wirish/wirish_shift.o: ./libmaple/include/libmaple/bitband.h
wirish/wirish_shift.o: ./libmaple/include/libmaple/adc.h
wirish/wirish_shift.o: ./libmaple/stm32f1/include/series/adc.h
wirish/wirish_shift.o: ./wirish/boards/maple_mini/include/board/board.h
wirish/wirish_shift.o: ./wirish/include/wirish/io.h
wirish/wirish_shift.o: ./wirish/include/wirish/bit_constants.h
wirish/wirish_shift.o: ./wirish/include/wirish/pwm.h
wirish/wirish_shift.o: ./wirish/include/wirish/ext_interrupts.h
wirish/wirish_shift.o: ./wirish/include/wirish/wirish_debug.h
wirish/wirish_shift.o: ./wirish/include/wirish/wirish_math.h
wirish/wirish_shift.o: /usr/include/math.h /usr/include/sys/cdefs.h
wirish/wirish_shift.o: /usr/include/sys/_symbol_aliasing.h
wirish/wirish_shift.o: /usr/include/sys/_posix_availability.h
wirish/wirish_shift.o: /usr/include/Availability.h
wirish/wirish_shift.o: /usr/include/AvailabilityInternal.h
wirish/wirish_shift.o: ./wirish/include/wirish/wirish_time.h
wirish/wirish_shift.o: ./libmaple/include/libmaple/systick.h
wirish/wirish_shift.o: ./wirish/include/wirish/HardwareSPI.h
wirish/wirish_shift.o: ./libmaple/include/libmaple/spi.h
wirish/wirish_shift.o: ./libmaple/stm32f1/include/series/spi.h
wirish/wirish_shift.o: ./wirish/include/wirish/HardwareSerial.h
wirish/wirish_shift.o: ./wirish/include/wirish/Print.h
wirish/wirish_shift.o: ./wirish/include/wirish/HardwareTimer.h
wirish/wirish_shift.o: ./wirish/include/wirish/usb_serial.h
wirish/wirish_shift.o: /usr/include/stdint.h
wirish/wirish_time.o: ./wirish/include/wirish/wirish_time.h
wirish/wirish_time.o: ./libmaple/include/libmaple/libmaple_types.h
wirish/wirish_time.o: ./libmaple/include/libmaple/systick.h
wirish/wirish_time.o: ./libmaple/include/libmaple/util.h
wirish/wirish_time.o: ./wirish/include/wirish/boards.h
wirish/wirish_time.o: ./wirish/include/wirish/wirish_types.h
wirish/wirish_time.o: ./libmaple/include/libmaple/gpio.h
wirish/wirish_time.o: ./libmaple/stm32f1/include/series/gpio.h
wirish/wirish_time.o: ./libmaple/include/libmaple/stm32.h
wirish/wirish_time.o: ./libmaple/stm32f1/include/series/stm32.h
wirish/wirish_time.o: ./libmaple/include/libmaple/exti.h
wirish/wirish_time.o: ./libmaple/stm32f1/include/series/exti.h
wirish/wirish_time.o: ./libmaple/include/libmaple/rcc.h
wirish/wirish_time.o: ./libmaple/stm32f1/include/series/rcc.h
wirish/wirish_time.o: ./libmaple/include/libmaple/timer.h
wirish/wirish_time.o: ./libmaple/stm32f1/include/series/timer.h
wirish/wirish_time.o: ./libmaple/include/libmaple/libmaple.h
wirish/wirish_time.o: ./libmaple/include/libmaple/delay.h
wirish/wirish_time.o: ./libmaple/include/libmaple/nvic.h
wirish/wirish_time.o: ./libmaple/stm32f1/include/series/nvic.h
wirish/wirish_time.o: ./libmaple/include/libmaple/bitband.h
wirish/wirish_time.o: ./libmaple/include/libmaple/adc.h
wirish/wirish_time.o: ./libmaple/stm32f1/include/series/adc.h
wirish/wirish_time.o: ./wirish/boards/maple_mini/include/board/board.h
wirish/boards_private.o: ./libmaple/include/libmaple/rcc.h
wirish/boards_private.o: ./libmaple/include/libmaple/libmaple_types.h
wirish/boards_private.o: ./libmaple/stm32f1/include/series/rcc.h
wirish/boards_private.o: ./libmaple/include/libmaple/adc.h
wirish/boards_private.o: ./libmaple/include/libmaple/libmaple.h
wirish/boards_private.o: ./libmaple/include/libmaple/stm32.h
wirish/boards_private.o: ./libmaple/stm32f1/include/series/stm32.h
wirish/boards_private.o: ./libmaple/include/libmaple/util.h
wirish/boards_private.o: ./libmaple/include/libmaple/delay.h
wirish/boards_private.o: ./libmaple/include/libmaple/bitband.h
wirish/boards_private.o: ./libmaple/stm32f1/include/series/adc.h
wirish/start_c.o: /usr/include/stddef.h /usr/include/_types.h
wirish/start_c.o: /usr/include/sys/_types.h /usr/include/sys/cdefs.h
wirish/start_c.o: /usr/include/sys/_symbol_aliasing.h
wirish/start_c.o: /usr/include/sys/_posix_availability.h
wirish/start_c.o: /usr/include/machine/_types.h /usr/include/i386/_types.h
wirish/syscalls.o: ./libmaple/include/libmaple/libmaple.h
wirish/syscalls.o: ./libmaple/include/libmaple/libmaple_types.h
wirish/syscalls.o: ./libmaple/include/libmaple/stm32.h
wirish/syscalls.o: ./libmaple/stm32f1/include/series/stm32.h
wirish/syscalls.o: ./libmaple/include/libmaple/util.h
wirish/syscalls.o: ./libmaple/include/libmaple/delay.h
wirish/syscalls.o: /usr/include/sys/stat.h /usr/include/sys/_types.h
wirish/syscalls.o: /usr/include/sys/cdefs.h
wirish/syscalls.o: /usr/include/sys/_symbol_aliasing.h
wirish/syscalls.o: /usr/include/sys/_posix_availability.h
wirish/syscalls.o: /usr/include/machine/_types.h /usr/include/i386/_types.h
wirish/syscalls.o: /usr/include/Availability.h
wirish/syscalls.o: /usr/include/AvailabilityInternal.h
wirish/syscalls.o: /usr/include/sys/_structs.h
wirish/syscalls.o: /usr/include/machine/_structs.h
wirish/syscalls.o: /usr/include/i386/_structs.h
wirish/syscalls.o: /usr/include/sys/appleapiopts.h /usr/include/errno.h
wirish/syscalls.o: /usr/include/sys/errno.h /usr/include/stddef.h
wirish/syscalls.o: /usr/include/_types.h
