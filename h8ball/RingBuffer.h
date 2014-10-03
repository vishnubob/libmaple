#ifndef __RING_BUFFER_T__
#define __RING_BUFFER_T__

#include <stdint.h>
#include <wirish/wirish.h>

template <class T>
class RingBuffer
{
public:
    RingBuffer(size_t _cp) :
        _buffer(0)
    {
        _capacity = _cp;
        _buffer = new T[_capacity];
        _buffer_end = _buffer + _capacity;
        _head = _buffer;
        _tail = _head;
    }

    ~RingBuffer()
    {
        if (_buffer) 
            delete _buffer;
    }

    bool is_full()
    {
        uint32_t hd = (_head - _buffer);
        uint32_t tl = (_tail - _buffer);
        return ((hd + 1) % _capacity) == tl;
    }

    bool is_empty()
    {
        return (_head == _tail);
    }

    bool push_back(const T item)
    {
        /* spinwait */
        while (is_full()) {}
        *_head = item;
        _head += 1;
        if (_head >= _buffer_end)
            _head = _buffer;
        return true;
    }

    T* peek_back()
    {
        if (is_empty())
            return NULL;
        T* ret = const_cast<T*>(_head);
        return ret;
    }

    T* peek_front()
    {
        if (is_empty())
            return NULL;
        T* ret = const_cast<T*>(_tail);
        return ret;
    }

    T* pop_front()
    {
        if (is_empty())
            return NULL;
        T* ret = const_cast<T*>(_tail);
        _tail += 1;
        if(_tail >= _buffer_end)
            _tail = _buffer;
        return ret;
    }

private:
    size_t                  _capacity;
    T                       **_buffer;
    T                       *_buffer_end;
    T volatile              *_head;
    T volatile              *_tail;
};

template <class T>
class OverwriteRingBuffer
{
public:
    OverwriteRingBuffer(size_t _cp) :
        _buffer(0)
    {
        _capacity = _cp;
        _buffer = new T[_capacity];
        _buffer_end = _buffer + _capacity;
        _head = _buffer;
        _tail = _head;
    }

    ~OverwriteRingBuffer()
    {
        if (_buffer) 
            delete _buffer;
    }

    bool is_full()
    {
        uint32_t hd = (_head - _buffer);
        uint32_t tl = (_tail - _buffer);
        return ((hd + 1) % _capacity) == tl;
    }

    bool is_empty()
    {
        return (_head == _tail);
    }

    bool push_back(const T item)
    {
        *_head = item;
        _head += 1;
        if (_head >= _buffer_end)
            _head = _buffer;
        if (_head == _tail)
            move_front(1);
        return true;
    }

    T pop_front()
    {
        if (is_empty())
            return *_buffer;
        _tail += 1;
        if(_tail >= _buffer_end)
            _tail = _buffer;
        return (*_tail);
    }

    T& peek_front(size_t offset=0)
    {
        uint32_t tl = _tail - _buffer;
        uint32_t idx = (tl + offset) % _capacity;
        return _buffer[idx];
    }

    T& peek_back(size_t offset=0)
    {
        uint32_t hd = (_head - _buffer);
        uint32_t idx = (hd - offset) % _capacity;
        return _buffer[idx];
    }

    void move_front(size_t offset)
    {
        _tail += offset;
        if(_tail >= _buffer_end)
            _tail = _buffer;
    }

    void debug_dump()
    {
        uint32_t hd = (_head - _buffer);
        uint32_t tl = (_tail - _buffer);
        SerialUSB.println(_capacity);
        for (size_t idx = 0; idx < _capacity; ++idx)
        {
            if (idx == hd) 
            {
                SerialUSB.print("{");
                SerialUSB.print(_buffer[idx]);
                SerialUSB.print("}");
            } else
            if (idx == tl) 
            {
                SerialUSB.print("(");
                SerialUSB.print(_buffer[idx]);
                SerialUSB.print(")");
            } else
            {
                SerialUSB.print(_buffer[idx]);
            }
            // comma
            if ((idx + 1) < _capacity)
            {
                SerialUSB.print(",");
            }
        }
    }

private:
    size_t                  _capacity;
    T                       *_buffer;
    T                       *_buffer_end;
    T volatile              *_head;
    T volatile              *_tail;
};

#endif // __RING_BUFFER_T__
