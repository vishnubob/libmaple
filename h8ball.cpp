#include "SPI.h"
#include "Adafruit_GFX.h"
#include "Adafruit_ILI9340.h"
#include <wirish/wirish.h>

// Force init to be called *first*, i.e. before static object allocation.
// Otherwise, statically allocated objects that need libmaple may fail.
__attribute__((constructor)) void premain() {
    init();
}

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
    void step()
    {
        int val;
        for(int idx = 0; idx < AXIS_COUNT; ++idx)
        {
            val = analogRead(AxisPins[idx]);
            _delta[idx] += (_last[idx] - val);
            _last[idx] = val;
        }
    }

    int get_delta(int idx)
    {
        int ret = _delta[idx];
        _delta[idx] = 0;
        return ret;
    }

    unsigned char classify(int threshold)
    {
        unsigned char ret = 0;
        int val;

        val = get_delta(0);
        if (val > threshold)
        {
            ret |= X_POS;
        } else
        if (val < -threshold)
        {
            ret |= X_NEG;
        }

        val = get_delta(1);
        if (val > threshold)
        {
            ret |= Y_POS;
        } else
        if (val < -threshold)
        {
            ret |= Y_NEG;
        }

        val = get_delta(2);
        if (val > threshold)
        {
            ret |= Z_POS;
        } else
        if (val < -threshold)
        {
            ret |= Z_NEG;
        }
        return ret;
    }

private:
    volatile int _last[AXIS_COUNT];
    volatile int _delta[AXIS_COUNT];
    volatile bool _cycle;
};

Accelerometer accel;

class GestureModel
{
public:
    GestureModel(): _movement(false), _pending(false)
    {
        _move_start = millis();
        _move_end = millis();
        _hysteresis = 100;
    }

    void step()
    {
        unsigned info = accel.classify(1);
        bool movement = (info != 0);
        unsigned long now = millis();
        if (movement && !_movement)
        {
            // we started to move
            SerialUSB.println("Move start");
            _move_start = now;
            _movement = movement;
        } else
        if (!movement && _movement)
        {
            // have we sat still long enough?
            if ((_move_start + _hysteresis) < now)
            {
                // we stopped moving
                _move_end = now;
                SerialUSB.print("Move end ");
                SerialUSB.println(now - _move_start);
                _pending = true;
                _movement = movement;
            }
        }
    }

    bool shake()
    {
        if (_pending && !_movement && (_move_end - _move_start) > 500)
        {
            _pending = false;
            return true;
        }
        return false;
    }

private:
    unsigned long _move_start;
    unsigned long _move_end;
    unsigned long _hysteresis;
    bool _movement;
    bool _pending;
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

void _setup() 
{
    /*
    tft.begin();
    tft.fillScreen(ILI9340_BLACK);
    tft.setCursor(0, 0);
    tft.setTextColor(ILI9340_WHITE);
    tft.setTextSize(1);
    */

    //Timer1.initialize(5000);
    //Timer1.attachInterrupt(timer_callback);
}

void _loop() 
{
    gesture.step();
    if (gesture.shake())
        SerialUSB.println("shake!");
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

void __loop()
{
    if (!SerialUSB.available())
    {
        return;
    }
    unsigned long count;
    count = SerialUSB.read();
    count |= (unsigned long)SerialUSB.read() << 8;
    count |= (unsigned long)SerialUSB.read() << 16;
    count |= (unsigned long)SerialUSB.read() << 24;
    capture(count);
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

void setup() {
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

void loop(void) {
  for(uint8_t rotation=0; rotation<4; rotation++) {
    tft.setRotation(rotation);
    testText();
    delay(2000);
  }
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

