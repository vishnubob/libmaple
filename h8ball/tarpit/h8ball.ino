#include "SPI.h"
#include "TimerOne.h"
#include "Adafruit_GFX.h"
#include "Adafruit_ILI9340.h"

// LCD
#define _sclk 13
#define _miso 12
#define _mosi 11
#define _cs 10
#define _rst 9
#define _dc 8
Adafruit_ILI9340 tft = Adafruit_ILI9340(_cs, _dc, _rst);

// Accel
#define AXIS_COUNT 3

#define X_POS   (1 << 0)
#define X_NEG   (1 << 1)
#define Y_POS   (1 << 2)
#define Y_NEG   (1 << 3)
#define Z_POS   (1 << 4)
#define Z_NEG   (1 << 5)

const int AxisPins[3] = {A0, A1, A2};
char AxisLabels[3] = {'X', 'Y', 'Z'};
int AxisData[3] = {0, 0, 0};

class Accelerometer
{
public:
    void step()
    {
        int val;
        for(size_t idx = 0; idx < AXIS_COUNT; ++idx)
        {
            val = analogRead(AxisPins[idx]);
            _delta[idx] += (_last[idx] - val);
            _last[idx] = val;
        }
    }

    int get_delta(int idx)
    {
        cli();
        int ret = _delta[idx];
        _delta[idx] = 0;
        sei();
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
            Serial.println("Move start");
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
                Serial.print("Move end ");
                Serial.println(now - _move_start);
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

void setup() 
{
    Serial.begin((unsigned long)115200); 
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
        Serial.println("shake!");
}

void loop()
{
    if (!Serial.available())
    {
        return;
    }
    unsigned long count;
    count = Serial.read();
    count |= (unsigned long)Serial.read() << 8;
    count |= (unsigned long)Serial.read() << 16;
    count |= (unsigned long)Serial.read() << 24;
    capture(count);
}

void capture(unsigned long count)
{
    int data[3];
    while(count)
    {
        cli();
        for(unsigned char idx = 0; idx < AXIS_COUNT; ++idx)
        {
            data[idx] = analogRead(AxisPins[idx]);
        }
        sei();
        for(unsigned char idx = 0; idx < AXIS_COUNT; ++idx)
        {
            int val = data[idx];
            Serial.write(val & 0xFF);
            Serial.write((val >> 8) & 0xFF);
        }
        --count;
    }
}
