#include <stdint.h>
#include <SdFat.h>
#include <HardwareSPI.h>
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


typedef struct shake_rec_t {
    int axis;
    float hz;
    float mag;
} shake_rec;

unsigned long testFillScreen();

// timeouts
#define IDLE_TIMEOUT        5000
#define DISPLAY_TIMEOUT     1000

// LCD
#define DISPLAY_SPI_PORT    2
#define _DC                 18
#define _RST                17
#define _SD_CS              16
#define _LCD_CS             15
#define _BL                 19

// SPI
HardwareSPI spi(DISPLAY_SPI_PORT);
Adafruit_ILI9340 tft = Adafruit_ILI9340(_LCD_CS, _DC, _RST, &spi);
//Adafruit_ILI9340 tft = Adafruit_ILI9340(_LCD_CS, _DC, _RST, DISPLAY_SPI_PORT);
Sd2Card card(spi, false);
SdVolume volume;
SdFile root;
SdFile file;


// Accel
#define AXIS_COUNT 3
#define X_AXIS 0
#define Y_AXIS 1
#define Z_AXIS 2

#define SENSOR_SAMPLE_RATE 1024

const int AxisPins[3] = {9, 10, 11};
char AxisLabels[3] = {'X', 'Y', 'Z'};
int AxisData[3] = {0, 0, 0};

#define TRAILS 10
OverwriteRingBuffer<int> rb_x(TRAILS);
OverwriteRingBuffer<int> rb_y(TRAILS);

class Phrases
{
public:
    void init()
    {
        //enable();
        if (!card.init()) SerialUSB.println("card.init failed");
        if (!volume.init(&card)) SerialUSB.println("volume.init failed");
        if (!root.openRoot(&volume)) SerialUSB.println("openRoot failed");
        //disable();
    }

    void enable() { digitalWrite(_SD_CS, LOW); }
    void disable() { digitalWrite(_SD_CS, HIGH); }

    void write_count(int32_t count)
    {
        //enable();
        if (!file.open(&root, "count.dat", O_WRITE | O_CREAT | O_TRUNC))
        {
            SerialUSB.println("Can't write count.dat");
        } else
        {
            write_int(file, count);
            file.close();
        }
        //disable();
    }

    int32_t read_count()
    {
        int32_t ret = 0;
        //enable();
        if (file.open(&root, "count.dat", O_READ))
        {
            ret = read_int(file);
            file.close();
        }
        //disable();
        return ret;
    }

    void write_index(int32_t index)
    {
        //enable();
        //SerialUSB.print("writing index ");
        //SerialUSB.println(index);
        if (!file.open(&root, "index.dat", O_WRITE | O_CREAT | O_APPEND))
        {
            SerialUSB.println("Can't write index.dat");
        } else
        {
            write_int(file, index);
            file.close();
        }
        //disable();
    }

    int32_t read_index(int32_t pos)
    {
        int32_t ret = 0;
        uint32_t offset = pos * sizeof(int32_t);
        //enable();
        if (!file.open(&root, "index.dat", O_READ))
        {
            SerialUSB.println("Can't read index.dat");
        } else
        {
            file.seekSet(offset);
            ret = read_int(file);
            file.close();
        }
        //disable();
        return ret;
    }
        
    void write_phrase(const char* phrase)
    {
        //enable();
        if (!file.open(&root, "phrases.dat", O_WRITE | O_CREAT | O_APPEND))
        {
            SerialUSB.println("Can't write phrases.dat");
        } else
        {
            size_t pos = file.fileSize();
            for(size_t idx = 0; idx < strlen(phrase); ++idx)
            {
                file.write(phrase[idx]);
            }
            file.write((uint8_t)0);
            file.close();
            write_index(pos);
            write_count(read_count() + 1);
        }
        //disable();
    }

    void read_phrase(int32_t index, char *phrase)
    {
        size_t offset = read_index(index);
        //enable();
        if (!file.open(&root, "phrases.dat", O_READ))
        {
            SerialUSB.println("Can't read phrases.dat");
        } else
        {
            file.seekSet(offset);
            char *ptr = phrase;
            while (1)
            {
                *ptr = file.read();
                if (*ptr == 0)
                {
                    break;
                }
                ptr++;
            }
            file.close();
        }
        //disable();
    }

    void reset()
    {
        //enable();
        if (file.open(&root, "phrases.dat", O_WRITE))
        {
            file.remove();
            file.close();
        }
        if (file.open(&root, "index.dat", O_WRITE))
        {
            file.remove();
            file.close();
        }
        if (file.open(&root, "count.dat", O_WRITE))
        {
            file.remove();
            file.close();
        }
        //disable();
    }

    void get_random_phrase(char *phrase)
    {
        randomSeed(analogRead(4));
        SerialUSB.print("there are ");
        SerialUSB.print(read_count());
        SerialUSB.println(" phrases available. ");
        int32_t idx = random(0, read_count());
        SerialUSB.print("picked ");
        SerialUSB.print(idx);
        SerialUSB.println(" as the phrase.");
        read_phrase(idx, phrase);
    }

private:
    int32_t read_int(SdFile &f)
    {
        int32_t val = f.read();
        val |= (int32_t)f.read() << 8;
        val |= (int32_t)f.read() << 16;
        val |= (int32_t)f.read() << 24;
        return val;
    }

    void write_int(SdFile &f, int32_t val)
    {
        f.write(val & 0xFF);
        f.write((val >> 8) & 0xFF);
        f.write((val >> 16) & 0xFF);
        f.write((val >> 24) & 0xFF);
    }

private:
    uint32_t    _count;
};

Phrases phrases;

void _draw_triangle(int x_offset=0, int y_offset=0, int linewidth=2, int margin=10, int color_r=0, int color_g=0, int color_b=0) 
{
    for(int lwidth = 1; lwidth < max(2, linewidth); ++lwidth)
    {
        int _x_offset = (lwidth * margin);
        //int _y_offset = (lwidth * margin);
        int min_x = _x_offset + x_offset;
        int max_x = tft.width() - _x_offset + x_offset;
        //int max_y = tft.height() - _y_offset;
        //int min_y = _x_offset;
        //int mid_x = tft.width()/ 2;
        int mid_y = tft.height() / 2;
        //int tenth_x = tft.width()/ 10;
        int tenth_y = tft.height() / 10;
        //tft.drawTriangle(
        tft.fillTriangle(
            max_x, mid_y + y_offset, 
            min_x, tenth_y + y_offset, 
            min_x, (9 * tenth_y) + y_offset, 
            tft.Color565(color_r, color_g, color_b));
        break;
    }
}

void draw_triangle(int x_offset=0, int y_offset=0, int linewidth=3, int margin=30) 
{
    /*
    if (x_offset == rb_x.peek_back() && y_offset == rb_y.peek_back())
    {
        return;
    }
    */
    rb_x.push_back(x_offset);
    rb_y.push_back(y_offset);
    for(int idx = 0; idx < TRAILS; ++idx)
    {
        int blue = (int)((idx + 1.0) / (float)TRAILS * (float)0xff);
        int mix = 0xff - blue;
        _draw_triangle(rb_x.peek_front(idx), rb_y.peek_front(idx), linewidth, margin, mix, mix, blue);
    }
    //int _temp_x = rb_x.pop_front();
    //int _temp_y = rb_y.pop_front();
}

class Timeout
{
public:
    Timeout(uint32_t length=0) { set_timeout_millis(length); reset(); }
    void set_timeout_millis(uint32_t length) { _timeout = length; reset(); }
    void set_timeout_seconds(uint32_t length) { set_timeout_millis(length * 1000); reset(); }
    void reset(uint32_t delta=0) { _alarm = _timeout + delta + millis(); }
    bool expiration_check() { return (millis() > _alarm); }

private:
    uint32_t    _alarm;
    uint32_t    _timeout;
};

class Accelerometer
{
public:
    Accelerometer(uint32_t bandwidth, uint32_t overlap=0, uint32_t retain=5) :
        stepcnt(0), samplecnt(0),
        _bandwidth(bandwidth), _overlap(overlap), _sampled(false), _retain(retain),
        _bincnt(retain / 2 + 1)
    {
        for(int axis = 0; axis < AXIS_COUNT; ++axis)
        {
            _steps[axis] = new OverwriteRingBuffer<int16_t>(_bandwidth + _overlap + 1);
            _samples[axis] = new OverwriteRingBuffer<int16_t>(_retain);
        }
        // Create the configurations for FFT and iFFT...
        fftConfiguration = kiss_fftr_alloc(_retain, 0, NULL, NULL);
        fftBins = new kiss_fft_cpx[_bincnt];
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

    void fft(int axis)
    {
        int16_t timeDomainData[_retain];
        for(int idx = 0; idx < _retain; ++idx)
        {
            timeDomainData[idx] = peek_sample(axis, idx);
        }
        kiss_fftr(fftConfiguration, const_cast<const int16_t*>(timeDomainData), fftBins);
    }

    float getmag(kiss_fft_cpx *cpx, float scale=1024.0)
    {
        float _r = (float)cpx->r / scale;
        float _i = (float)cpx->i / scale;
        return _r * _r + _i * _i;
    }

    shake_rec *get_max_bin(int axis, shake_rec *rec = NULL, float threshold=0.01)
    {
        shake_rec max_rec = {0, 0, 0};
        fft(axis);
        for(int bin = 1; bin < _bincnt; ++bin)
        {
            float mag = getmag(fftBins + bin);
            if (bin != 0 && bin < _bincnt - 1)
                mag *= 2;
            if (mag > threshold && mag > max_rec.mag)
            {
                max_rec.axis = axis;
                max_rec.mag = mag;
                max_rec.hz = bin;
            }
        }
        if (max_rec.mag > threshold)
        {
            if (!rec)
                rec = new shake_rec;
            rec->axis = max_rec.axis;
            rec->mag = max_rec.mag;
            rec->hz = (float)max_rec.hz * ((float)SENSOR_SAMPLE_RATE / (float)_bandwidth) / (float)_retain;
        }
        return rec;
    }

    shake_rec *get_shake(shake_rec *rec=NULL, float mag_cutoff=0.01, float hz_cutoff=.1)
    {
        shake_rec _rec = {0, 0, 0};
        shake_rec max_rec = {0, 0, 0};
        for (int axis = 0; axis < AXIS_COUNT; ++axis)
        {
            get_max_bin(axis, &_rec);
            if (_rec.mag > max_rec.mag)
            {
                max_rec.axis = axis;
                max_rec.mag = _rec.mag;
                max_rec.hz = _rec.hz;
            }
        }
        if (max_rec.mag > mag_cutoff)
        {
            if (!rec)
                rec = new shake_rec;
            rec->axis = max_rec.axis;
            rec->mag = max_rec.mag;
            rec->hz = max_rec.hz;
            return rec;
        }
        return NULL;
    }

    float g_scale(float val)
    {
        return max(-1.0, min(1.0, ((val - 2048.0) / 2048.0) * 3.0));
        //return ((val / 4096.0 * 6.0) - 3.0) / 3.0;
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


    float peek_g(int axis, int offset=0)
    {
        return g_scale(peek_sample(axis, offset));
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
    int _bincnt;

    float _vmap[AXIS_COUNT];
    OverwriteRingBuffer<int16_t>* _steps[AXIS_COUNT];
    OverwriteRingBuffer<int16_t>* _samples[AXIS_COUNT];
    kiss_fftr_cfg fftConfiguration;
    kiss_fft_cpx *fftBins;
};

Accelerometer accel(4, 2, 256);

void timer_callback()
{
    accel.step();
}

// We'll use timer 2
HardwareTimer sensor_timer(2);

void setup() 
{
    //while (!SerialUSB.available()) {};
    pinMode(_SD_CS, OUTPUT);
    spi.begin(SPI_18MHZ, MSBFIRST, 0);
    tft.begin();
    tft.setRotation(1);
    //tft.fillScreen(tft.Color565(0xff, 0x0, 0x0));
    //while (!SerialUSB.available()) {};
    phrases.enable();
    phrases.init();
    phrases.disable();
    for(int axis = 0; axis < AXIS_COUNT; ++axis)
    {
        pinMode(AxisPins[axis], INPUT_ANALOG);
    }
    pinMode(BOARD_LED_PIN, OUTPUT);
    // backlight
    pinMode(_BL, OUTPUT);
    digitalWrite(_BL, HIGH);
    // in microseconds; should give 1000Hz toggles
    int _sensor_rate = SENSOR_SAMPLE_RATE; 
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
    delay(250);
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
    char string_buffer[1024];
    static long v = 0;
    if (!SerialUSB.available()) return;
    char ch = SerialUSB.read();
    char *ptr;
    size_t count, i;
    //SerialUSB.println(ch);

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
        case 'R':
            phrases.enable();
            phrases.reset();
            phrases.disable();
            SerialUSB.print("OK");
            break;
        case 'A':
            ptr = string_buffer;
            for (int idx=0; idx < v; ++idx)
            {
                *ptr++ = SerialUSB.read();
            }
            *ptr = (char)0;
            //SerialUSB.print("This is what I got: ");
            //SerialUSB.println(string_buffer);
            phrases.enable();
            phrases.write_phrase(string_buffer);
            phrases.disable();
            v = 0;
            break;
        case 'G':
            phrases.enable();
            phrases.get_random_phrase(string_buffer);
            phrases.disable();
            SerialUSB.println(string_buffer);
            break;
        case 'c':
            count = SerialUSB.read();
            count |= (unsigned long)SerialUSB.read() << 8;
            count |= (unsigned long)SerialUSB.read() << 16;
            count |= (unsigned long)SerialUSB.read() << 24;
            capture(count);
            break;
        case 'L':
            count = SerialUSB.read();
            count |= (size_t)SerialUSB.read() << 8;
            count |= (size_t)SerialUSB.read() << 16;
            count |= (size_t)SerialUSB.read() << 24;
            /*
            for(i = 0; i < count; ++i)
            {
                string_buffer[i] = SerialUSB.read();
            }
            */
            SerialUSB.read(string_buffer, count);
            string_buffer[count] = '\0';
            SerialUSB.print("OK");
            phrases.enable();
            phrases.write_phrase(string_buffer);
            phrases.disable();
            break;
        case 's':
            while (1)
            {
                if (SerialUSB.available())
                {
                    SerialUSB.read();
                    break;
                }
                shake_rec s_rec;
                if (accel.get_shake(&s_rec))
                {
                    SerialUSB.print("shake: [");
                    SerialUSB.print(AxisLabels[s_rec.axis]);
                    SerialUSB.print("]: ");
                    SerialUSB.print(s_rec.mag);
                    SerialUSB.print(" @");
                    SerialUSB.print(s_rec.hz);
                    SerialUSB.print("Hz, ");
                    SerialUSB.print(accel.g_scale(accel.peek_sample(s_rec.axis)));
                    SerialUSB.print("G");
                    SerialUSB.println("");
                }
            }
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
                    SerialUSB.print("] ");
                }
                SerialUSB.print(" roll: ");
                SerialUSB.print(accel.roll());
                SerialUSB.print(" pitch: ");
                SerialUSB.print(accel.pitch());
                SerialUSB.println();
            }
            break;
        case 'T':
            testFillScreen();
            break;
        default:
            SerialUSB.println("wat");
    }
    /*
    SerialUSB.println("");
    SerialUSB.print("v=");
    SerialUSB.print(v);
    SerialUSB.print("> ");
    */
}

void process_idle_event()
{
    digitalWrite(_BL, LOW);
    tft.fillScreen(0x0000);
}

void process_unidle_event()
{
    digitalWrite(_BL, HIGH);
}

void display_message(const char *msg)
{
    tft.setTextColor(ILI9340_WHITE);
    tft.setTextSize(3);
    //tft.setCursor(tft.width() / 2, tft.height() / 2);
    tft.setCursor(40, 0);
    tft.println(msg);
}

void process_shake_event(shake_rec *s_rec=NULL)
{
    tft.fillScreen(tft.Color565(0x00, 0x0, 0x66));
    char string_buffer[1024];
    Timeout display_timeout(DISPLAY_TIMEOUT);
    display_timeout.reset();

    //tft.fillScreen(ILI9340_BLUE);
    while(!display_timeout.expiration_check())
    {
        if(accel.get_shake(s_rec))
        {
            display_timeout.reset();
        }
    }
    phrases.enable();
    phrases.get_random_phrase(string_buffer);
    phrases.disable();
    display_message(string_buffer);
}

void loop()
{
    Timeout idle_timeout(IDLE_TIMEOUT);
    shake_rec s_rec;
    //tft.fillScreen(0xAAB0);

    while (1)
    {
        if (accel.get_shake(&s_rec))
        {
            process_unidle_event();
            process_shake_event(&s_rec);
            idle_timeout.reset();
        }
        if (idle_timeout.expiration_check())
        {
            process_idle_event();
        }
        Prompt();
    }
}

unsigned long testFillScreen() {
  unsigned long start = micros();
  tft.fillScreen(ILI9340_BLACK);
  tft.fillScreen(ILI9340_RED);
  tft.fillScreen(ILI9340_GREEN);
  tft.fillScreen(ILI9340_BLUE);
  tft.fillScreen(ILI9340_BLACK);
  return micros() - start;
}

int main()
{
    setup();
    while (1)
    {
        loop();
        //Prompt();
    }
    return 0;
}
