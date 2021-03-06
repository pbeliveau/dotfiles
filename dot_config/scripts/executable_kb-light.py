#!/usr/bin/env python3

import dbus
import sys


def kb_light_set(delta):
    bus = dbus.SystemBus()
    kbd_backlight_proxy = bus.get_object('org.freedesktop.UPower',
                                         '/org/freedesktop/UPower/KbdBacklight')
    kbd_backlight = dbus.Interface(kbd_backlight_proxy,
                                   'org.freedesktop.UPower.KbdBacklight')

    current = kbd_backlight.GetBrightness()
    maximum = kbd_backlight.GetMaxBrightness()
    new = max(0, current + delta)

    if 0 <= new <= maximum:
        current = new
        kbd_backlight.SetBrightness(current)

    # Return current backlight level percentage
    return 100 * current / maximum

if __name__ == '__main__':
    if len(sys.argv) == 2:
        if sys.argv[1] == "--up" or sys.argv[1] == "+":
            # ./kb-light.py (+|-up) to increment
            print(kb_light_set(1))
        elif sys.argv[1] == "--down" or sys.argv[1] == "-":
            # ./kb-light.py (-|-down) to decrement
            print(kb_light_set(-1))
        else:
            print("Unknown argument:", sys.argv[1])
    else:
        print("Script takes exactly one argument.", len(sys.argv) - 1,
              "arguments provided.")
