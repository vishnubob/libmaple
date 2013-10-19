# main project target
$(BUILD_PATH)/h8ball.o: $(SRCROOT)/h8ball.cpp 
	$(CXX) $(CFLAGS) -I./Adafruit-GFX-Library -I./Adafruit_ILI9340 $(CXXFLAGS) $(LIBMAPLE_INCLUDES) $(WIRISH_INCLUDES) -o $@ -c $< 
$(SRCROOT)/Adafruit_ILI9340/Adafruit_ILI9340.o: $(SRCROOT)/Adafruit_ILI9340/Adafruit_ILI9340.cpp 
	$(CXX) $(CFLAGS) -I./Adafruit-GFX-Library -I./Adafruit_ILI9340 $(CXXFLAGS) $(LIBMAPLE_INCLUDES) $(WIRISH_INCLUDES) -o $@ -c $< 
$(SRCROOT)/Adafruit-GFX-Library/Adafruit_GFX.o: $(SRCROOT)/Adafruit-GFX-Library/Adafruit_GFX.cpp
	$(CXX) $(CFLAGS) -I./Adafruit-GFX-Library -I./Adafruit_ILI9340 $(CXXFLAGS) $(LIBMAPLE_INCLUDES) $(WIRISH_INCLUDES) -o $@ -c $< 

OBJECTS := $(SRCROOT)/Adafruit_ILI9340/Adafruit_ILI9340.o $(SRCROOT)/Adafruit-GFX-Library/Adafruit_GFX.o $(BUILD_PATH)/h8ball.o 

$(BUILD_PATH)/libmaple.a: $(BUILDDIRS) $(TGT_BIN)
	- rm -f $@
	$(AR) crv $(BUILD_PATH)/libmaple.a $(TGT_BIN)

library: $(BUILD_PATH)/libmaple.a

#.PHONY: library

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
