#include <stdint.h>
#include "kiss_fftr.h"
#include "RingBuffer.h"
#include "SPI.h"
#include "Adafruit_GFX.h"
#include "Adafruit_ILI9340.h"
#include <wirish/wirish.h>

// Force init to be called *first*, i.e. before static object allocation.
// Otherwise, statically allocated objects that need libmaple may fail.
__attribute__((constructor)) void premain() {
    init();
}

unsigned long testFillScreen();

// LCD
#define DISPLAY_SPI_PORT 2
#define _CS 20
#define _DC 22
#define _RST 21
Adafruit_ILI9340 tft = Adafruit_ILI9340(_CS, _DC, _RST, DISPLAY_SPI_PORT);

// Accel
#define AXIS_COUNT 3

#define X_POS   (1 << 0)
#define X_NEG   (1 << 1)
#define Y_POS   (1 << 2)
#define Y_NEG   (1 << 3)
#define Z_POS   (1 << 4)
#define Z_NEG   (1 << 5)

const int AxisPins[3] = {10, 9, 8};
char AxisLabels[3] = {'X', 'Y', 'Z'};
int AxisData[3] = {0, 0, 0};

class Accelerometer
{
public:
    Accelerometer(uint32_t bandwidth, uint32_t overlap=0, uint32_t retain=5) :
        stepcnt(0), samplecnt(0),
        _bandwidth(bandwidth), _overlap(overlap), _sampled(false), _retain(retain)
    {
        for(int axis = 0; axis < AXIS_COUNT; ++axis)
        {
            _steps[axis] = new OverwriteRingBuffer<int16_t>(_bandwidth + _overlap + 1);
            _samples[axis] = new OverwriteRingBuffer<int16_t>(_retain);
        }
        // Create the configurations for FFT and iFFT...
        fftConfiguration = kiss_fftr_alloc(_retain, 0, NULL, NULL);
    }

    void step()
    {
        _step = (_step + 1) % (_bandwidth - _overlap); 
        stepcnt += 1;
        for(int axis = 0; axis < AXIS_COUNT; ++axis)
        {
            uint16_t val = analogRead(AxisPins[axis]);
            _steps[axis]->push_back(val);
        }
        if (_step != 0)
            return;
        toggleLED();
        samplecnt += 1;
        for(int axis = 0; axis < AXIS_COUNT; ++axis)
        {
            float sum = 0;
            for(int sidx = 0; sidx < _bandwidth; ++sidx)
            {
                sum += _steps[axis]->peek_front(sidx);
            }
            uint16_t avg = sum / _bandwidth;
            _samples[axis]->push_back(avg);
            _steps[axis]->move_front(_bandwidth - _overlap);
        }
    }

    void debug_dump()
    {
        for(int axis = 0; axis < AXIS_COUNT; ++axis)
        {
            SerialUSB.print(AxisLabels[axis]);
            SerialUSB.print("(steps): ");
            _steps[axis]->debug_dump();
            SerialUSB.println("");
        }
        for(int axis = 0; axis < AXIS_COUNT; ++axis)
        {
            SerialUSB.print(AxisLabels[axis]);
            SerialUSB.print("(samples): ");
            _samples[axis]->debug_dump();
            SerialUSB.println("");
        }
        SerialUSB.println("");
    }

    void fft()
    {
        // Allocate space for the FFT results (frequency bins)...
        kiss_fft_cpx fftBins[_retain / 2 + 1];
        int16_t timeDomainData[_retain];
        for(int axis = 0; axis < AXIS_COUNT; ++axis)
        {
            for(int idx = 0; idx < _retain; ++idx)
            {
                timeDomainData[idx] = peek_sample(axis, idx);
            }
            kiss_fftr(fftConfiguration, const_cast<const int16_t*>(timeDomainData), fftBins);
            for(int idx = 0; idx < _retain / 2 + 1; ++idx)
            {
                SerialUSB.print(idx);
                SerialUSB.print(" [r:");
                SerialUSB.print(fftBins[idx].r);
                SerialUSB.print(" i:");
                SerialUSB.print(fftBins[idx].i);
                SerialUSB.print("] ");
            }
            SerialUSB.println("");
        }
        kiss_fftr_free(fftConfiguration);
    }

    float g_scale(float val)
    {
        //return max(-1.0, min(1.0, ((val - 2048.0) / 2048.0) * 3.0));
        //return ((val / 4096.0 * 6.0) - 3.0) / 3.0;
        return val / 4096.0;
    }

    float roll(int8_t x, int8_t y, int8_t z)
    {
        return atan2(-y, -z) * 180.0 / M_PI;
    }

    float pitch(uint8_t x, uint8_t y, uint8_t z)
    {
        float gx = x;
        float gy = y;
        float gz = z;
        return atan2(gx, sqrt(gy*gy + gz*gz)) * 180.0 / M_PI;
    }

    float roll()
    {
        int8_t x = peek_sample(0);
        int8_t y = peek_sample(1);
        int8_t z = peek_sample(2);
        return roll(x, y, z);
    }
        
    float pitch()
    {
        int8_t x = peek_sample(0);
        int8_t y = peek_sample(1);
        int8_t z = peek_sample(2);
        return pitch(x, y, z);
    }


    int16_t peek_sample(int axis, int offset=0)
    {
        return _samples[axis]->peek_front(offset);
    }
        
    int16_t axis_sample(int axis, int samples=1, int offset=0)
    {
        if ((samples <= 0) || (samples > _bandwidth))
        {
            samples = _bandwidth;
        }
        float sum = 0;
        for(int sidx = offset; sidx < samples; ++sidx)
        {
            sum += _samples[axis]->peek_back(sidx);
        }
        int16_t avg = sum / (samples - offset);
        return avg - 2048;
    }

public:
    int stepcnt;
    int samplecnt;
private:
    volatile int _last[AXIS_COUNT];
    volatile int _delta[AXIS_COUNT];
    int _bandwidth;
    int _overlap;
    volatile bool _sampled;
    int _retain;
    volatile int _step;

    float _vmap[AXIS_COUNT];
    OverwriteRingBuffer<int16_t>* _steps[AXIS_COUNT];
    OverwriteRingBuffer<int16_t>* _samples[AXIS_COUNT];
    kiss_fftr_cfg fftConfiguration;
};

Accelerometer accel(10, 5, 20);

class GestureModel
{
public:

    void step()
    {
    }

    void shake()
    {
    }

private:
};

GestureModel gesture;

void display_message(const char *msg) 
{
    tft.println(msg);
}

void timer_callback()
{
    accel.step();
}

// We'll use timer 2
HardwareTimer sensor_timer(2);

void setup() 
{
    //while (!SerialUSB.available()) {};
    for(int axis = 0; axis < AXIS_COUNT; ++axis)
    {
        pinMode(AxisPins[axis], INPUT_ANALOG);
    }
    pinMode(BOARD_LED_PIN, OUTPUT);
    // in microseconds; should give 1000Hz toggles
    int _sensor_rate = 1000; 
    // Pause the timer while we're configuring it
    sensor_timer.pause();
    // Set up period
    sensor_timer.setPeriod(_sensor_rate); // in microseconds
    // Set up an interrupt on channel 1
    sensor_timer.setChannel1Mode(TIMER_OUTPUT_COMPARE);
    // Interrupt 1 count after each update
    sensor_timer.setCompare(TIMER_CH1, 1);  
    sensor_timer.attachCompare1Interrupt(timer_callback);
    // Refresh the timer's count, prescale, and overflow
    sensor_timer.refresh();
    // Start the timer counting
    sensor_timer.resume();
}

void capture(unsigned long count)
{
    int data[3];
    while(count)
    {
        for(unsigned char idx = 0; idx < AXIS_COUNT; ++idx)
        {
            data[idx] = analogRead(AxisPins[idx]);
        }
        for(unsigned char idx = 0; idx < AXIS_COUNT; ++idx)
        {
            int val = data[idx];
            SerialUSB.write(val & 0xFF);
            SerialUSB.write((val >> 8) & 0xFF);
        }
        --count;
    }
}

void Prompt(void)
{
    static long v = 0;
    if (!SerialUSB.available()) return;
    char ch = SerialUSB.read();
    SerialUSB.println(ch);

    switch(ch) 
    {
        /* numbers / values */
        case '0'...'9':
            v = v * 10 + ch - '0';
            break;
        case '-':
            v *= -1;
            break;
        case 'z':
            v = 0;
            break;
        case 'p':
            SerialUSB.print("Sample Count: ");
            SerialUSB.print(accel.samplecnt);
            SerialUSB.println("");
            SerialUSB.print("Step Count: ");
            SerialUSB.print(accel.stepcnt);
            SerialUSB.println("");
            accel.debug_dump();
            SerialUSB.println("");
            break;
        case 'c':
            unsigned long count;
            count = SerialUSB.read();
            count |= (unsigned long)SerialUSB.read() << 8;
            count |= (unsigned long)SerialUSB.read() << 16;
            count |= (unsigned long)SerialUSB.read() << 24;
            capture(count);
            break;
        case 'w':
            // watch
            while (1)
            {
                if (SerialUSB.available())
                {
                    SerialUSB.read();
                    break;
                }
                for (int axis=0; axis < AXIS_COUNT; ++axis)
                {
                    SerialUSB.print("[");
                    SerialUSB.print(AxisLabels[axis]);
                    SerialUSB.print(": ");
                    //SerialUSB.print(accel.axis_sample(axis, 1));
                    SerialUSB.print(accel.peek_sample(axis));
                    SerialUSB.print(", ");
                    SerialUSB.print(accel.g_scale(accel.peek_sample(axis)));
                    /*
                    SerialUSB.print(", ");
                    SerialUSB.print(analogRead(AxisPins[axis]));
                    */
                    SerialUSB.print("] ");
                }
                SerialUSB.print(" roll: ");
                SerialUSB.print(accel.roll());
                SerialUSB.print(" pitch: ");
                SerialUSB.print(accel.pitch());
                SerialUSB.println();
                accel.fft();
                delay(100);
            }
            break;
        case 'T':
            testFillScreen();
            break;
        default:
            SerialUSB.println("wat");
    }
    SerialUSB.println("");
    SerialUSB.print("v=");
    SerialUSB.print(v);
    SerialUSB.print("> ");
}

void loop()
{
    Prompt();
}

/***************************************************
  This is an example sketch for the Adafruit 2.2" SPI display.
  This library works with the Adafruit 2.2" TFT Breakout w/SD card
  ----> http://www.adafruit.com/products/1480
 
  Check out the links above for our tutorials and wiring diagrams
  These displays use SPI to communicate, 4 or 5 pins are required to
  interface (RST is optional)
  Adafruit invests time and resources providing this open source code,
  please support Adafruit and open-source hardware by purchasing
  products from Adafruit!

  Written by Limor Fried/Ladyada for Adafruit Industries.
  MIT license, all text above must be included in any redistribution
 ****************************************************/
 

unsigned long testFillScreen() {
  unsigned long start = micros();
  tft.fillScreen(ILI9340_BLACK);
  tft.fillScreen(ILI9340_RED);
  tft.fillScreen(ILI9340_GREEN);
  tft.fillScreen(ILI9340_BLUE);
  tft.fillScreen(ILI9340_BLACK);
  return micros() - start;
}

unsigned long testText() {
  tft.fillScreen(ILI9340_BLACK);
  unsigned long start = micros();
  tft.setCursor(0, 0);
  tft.setTextColor(ILI9340_WHITE);  tft.setTextSize(1);
  tft.println("Hello World!");
  tft.setTextColor(ILI9340_YELLOW); tft.setTextSize(2);
  tft.println(1234.56);
  tft.setTextColor(ILI9340_RED);    tft.setTextSize(3);
  tft.println(0xDEADBEEF, HEX);
  tft.println();
  tft.setTextColor(ILI9340_GREEN);
  tft.setTextSize(5);
  tft.println("Groop");
  tft.setTextSize(2);
  tft.println("I implore thee,");
  tft.setTextSize(1);
  tft.println("my foonting turlingdromes.");
  tft.println("And hooptiously drangle me");
  tft.println("with crinkly bindlewurdles,");
  tft.println("Or I will rend thee");
  tft.println("in the gobberwarts");
  tft.println("with my blurglecruncheon,");
  tft.println("see if I don't!");
  return micros() - start;
}

unsigned long testLines(uint16_t color) {
  unsigned long start, t;
  int           x1, y1, x2, y2,
                w = tft.width(),
                h = tft.height();

  tft.fillScreen(ILI9340_BLACK);

  x1 = y1 = 0;
  y2    = h - 1;
  start = micros();
  for(x2=0; x2<w; x2+=6) tft.drawLine(x1, y1, x2, y2, color);
  x2    = w - 1;
  for(y2=0; y2<h; y2+=6) tft.drawLine(x1, y1, x2, y2, color);
  t     = micros() - start; // fillScreen doesn't count against timing

  tft.fillScreen(ILI9340_BLACK);

  x1    = w - 1;
  y1    = 0;
  y2    = h - 1;
  start = micros();
  for(x2=0; x2<w; x2+=6) tft.drawLine(x1, y1, x2, y2, color);
  x2    = 0;
  for(y2=0; y2<h; y2+=6) tft.drawLine(x1, y1, x2, y2, color);
  t    += micros() - start;

  tft.fillScreen(ILI9340_BLACK);

  x1    = 0;
  y1    = h - 1;
  y2    = 0;
  start = micros();
  for(x2=0; x2<w; x2+=6) tft.drawLine(x1, y1, x2, y2, color);
  x2    = w - 1;
  for(y2=0; y2<h; y2+=6) tft.drawLine(x1, y1, x2, y2, color);
  t    += micros() - start;

  tft.fillScreen(ILI9340_BLACK);

  x1    = w - 1;
  y1    = h - 1;
  y2    = 0;
  start = micros();
  for(x2=0; x2<w; x2+=6) tft.drawLine(x1, y1, x2, y2, color);
  x2    = 0;
  for(y2=0; y2<h; y2+=6) tft.drawLine(x1, y1, x2, y2, color);

  return micros() - start;
}

unsigned long testFastLines(uint16_t color1, uint16_t color2) {
  unsigned long start;
  int           x, y, w = tft.width(), h = tft.height();

  tft.fillScreen(ILI9340_BLACK);
  start = micros();
  for(y=0; y<h; y+=5) tft.drawFastHLine(0, y, w, color1);
  for(x=0; x<w; x+=5) tft.drawFastVLine(x, 0, h, color2);

  return micros() - start;
}

unsigned long testRects(uint16_t color) {
  unsigned long start;
  int           n, i, i2,
                cx = tft.width()  / 2,
                cy = tft.height() / 2;

  tft.fillScreen(ILI9340_BLACK);
  n     = min(tft.width(), tft.height());
  start = micros();
  for(i=2; i<n; i+=6) {
    i2 = i / 2;
    tft.drawRect(cx-i2, cy-i2, i, i, color);
  }

  return micros() - start;
}

unsigned long testFilledRects(uint16_t color1, uint16_t color2) {
  unsigned long start, t = 0;
  int           n, i, i2,
                cx = tft.width()  / 2 - 1,
                cy = tft.height() / 2 - 1;

  tft.fillScreen(ILI9340_BLACK);
  n = min(tft.width(), tft.height());
  for(i=n; i>0; i-=6) {
    i2    = i / 2;
    start = micros();
    tft.fillRect(cx-i2, cy-i2, i, i, color1);
    t    += micros() - start;
    // Outlines are not included in timing results
    tft.drawRect(cx-i2, cy-i2, i, i, color2);
  }

  return t;
}

unsigned long testFilledCircles(uint8_t radius, uint16_t color) {
  unsigned long start;
  int x, y, w = tft.width(), h = tft.height(), r2 = radius * 2;

  tft.fillScreen(ILI9340_BLACK);
  start = micros();
  for(x=radius; x<w; x+=r2) {
    for(y=radius; y<h; y+=r2) {
      tft.fillCircle(x, y, radius, color);
    }
  }

  return micros() - start;
}

unsigned long testCircles(uint8_t radius, uint16_t color) {
  unsigned long start;
  int           x, y, r2 = radius * 2,
                w = tft.width()  + radius,
                h = tft.height() + radius;

  // Screen is not cleared for this one -- this is
  // intentional and does not affect the reported time.
  start = micros();
  for(x=0; x<w; x+=r2) {
    for(y=0; y<h; y+=r2) {
      tft.drawCircle(x, y, radius, color);
    }
  }

  return micros() - start;
}

unsigned long testTriangles() {
  unsigned long start;
  int           n, i, cx = tft.width()  / 2 - 1,
                      cy = tft.height() / 2 - 1;

  tft.fillScreen(ILI9340_BLACK);
  n     = min(cx, cy);
  start = micros();
  for(i=0; i<n; i+=5) {
    tft.drawTriangle(
      cx    , cy - i, // peak
      cx - i, cy + i, // bottom left
      cx + i, cy + i, // bottom right
      tft.Color565(0, 0, i));
  }

  return micros() - start;
}

unsigned long testFilledTriangles() {
  unsigned long start, t = 0;
  int           i, cx = tft.width()  / 2 - 1,
                   cy = tft.height() / 2 - 1;

  tft.fillScreen(ILI9340_BLACK);
  start = micros();
  for(i=min(cx,cy); i>10; i-=5) {
    start = micros();
    tft.fillTriangle(cx, cy - i, cx - i, cy + i, cx + i, cy + i,
      tft.Color565(0, i, i));
    t += micros() - start;
    tft.drawTriangle(cx, cy - i, cx - i, cy + i, cx + i, cy + i,
      tft.Color565(i, i, 0));
  }

  return t;
}

unsigned long testRoundRects() {
  unsigned long start;
  int           w, i, i2,
                cx = tft.width()  / 2 - 1,
                cy = tft.height() / 2 - 1;

  tft.fillScreen(ILI9340_BLACK);
  w     = min(tft.width(), tft.height());
  start = micros();
  for(i=0; i<w; i+=6) {
    i2 = i / 2;
    tft.drawRoundRect(cx-i2, cy-i2, i, i, i/8, tft.Color565(i, 0, 0));
  }

  return micros() - start;
}

unsigned long testFilledRoundRects() {
  unsigned long start;
  int           i, i2,
                cx = tft.width()  / 2 - 1,
                cy = tft.height() / 2 - 1;

  tft.fillScreen(ILI9340_BLACK);
  start = micros();
  for(i=min(tft.width(), tft.height()); i>20; i-=6) {
    i2 = i / 2;
    tft.fillRoundRect(cx-i2, cy-i2, i, i, i/8, tft.Color565(0, i, 0));
  }

  return micros() - start;
}

void display_test() {
  SerialUSB.println("Adafruit 2.2\" SPI TFT Test!"); 
 
  tft.begin();

  SerialUSB.println(("Benchmark                Time (microseconds)"));
  SerialUSB.print(("Screen fill              "));
  SerialUSB.println(testFillScreen());
  delay(500);

  SerialUSB.print(("Text                     "));
  SerialUSB.println(testText());
  delay(3000);

  SerialUSB.print(("Lines                    "));
  SerialUSB.println(testLines(ILI9340_CYAN));
  delay(500);

  SerialUSB.print(("Horiz/Vert Lines         "));
  SerialUSB.println(testFastLines(ILI9340_RED, ILI9340_BLUE));
  delay(500);

  SerialUSB.print(("Rectangles (outline)     "));
  SerialUSB.println(testRects(ILI9340_GREEN));
  delay(500);

  SerialUSB.print(("Rectangles (filled)      "));
  SerialUSB.println(testFilledRects(ILI9340_YELLOW, ILI9340_MAGENTA));
  delay(500);

  SerialUSB.print(("Circles (filled)         "));
  SerialUSB.println(testFilledCircles(10, ILI9340_MAGENTA));

  SerialUSB.print(("Circles (outline)        "));
  SerialUSB.println(testCircles(10, ILI9340_WHITE));
  delay(500);

  SerialUSB.print(("Triangles (outline)      "));
  SerialUSB.println(testTriangles());
  delay(500);

  SerialUSB.print(("Triangles (filled)       "));
  SerialUSB.println(testFilledTriangles());
  delay(500);

  SerialUSB.print(("Rounded rects (outline)  "));
  SerialUSB.println(testRoundRects());
  delay(500);

  SerialUSB.print(("Rounded rects (filled)   "));
  SerialUSB.println(testFilledRoundRects());
  delay(500);

  SerialUSB.println(("Done!"));
}

int main()
{
    setup();
    while (1)
    {
        loop();
    }
    return 0;
}

