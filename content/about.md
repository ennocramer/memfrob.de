+++
title = "About"
weight = 99

[extra]
icon = "info-circled"
+++

    void *memfrob(void *s, size_t n);

    The memfrob() function encrypts the first n bytes of the
    memory area s by exclusive-ORing each character with the
    number 42. The effect can be reversed by using memfrob()
    on the encrypted memory area.

-- memfrob(3) manual page
