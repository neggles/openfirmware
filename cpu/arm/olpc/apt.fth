\ SPDX-License-Identifier: MIT
purpose: Developer utilities for OLPC boards

: flash-update  " flash! http:\\172.21.10.99\new.rom" eval  ;
: flash-update-usb   " flash! u:\new.rom" eval  ;

: ec-update  " flash-ec http:\\172.21.10.99\ecimage.bin" eval  ;
: ec-update-usb   " flash-ec! u:\ecimage.bin" eval  ;

\ Load WiFi network name and password from manufacturing data tags.
\ Can be set via `add-tag NN <name>` and `add-tag PP <password>`.
\ If unset, the default is "OLPCOFW" for the name and no password.
stand-init: wifi
   " NN" find-tag  if  ?-null  $essid  then  \ network name
   " PP" find-tag  if  ?-null  $wpa    then  \ pass phrase
;

\ LICENSE_BEGIN
\ Copyright (c) 2013 FirmWorks
\ Copyright (c) 2025 Andi Powers-Holmes <aholmes@omnom.net>
\
\ Permission is hereby granted, free of charge, to any person obtaining
\ a copy of this software and associated documentation files (the
\ "Software"), to deal in the Software without restriction, including
\ without limitation the rights to use, copy, modify, merge, publish,
\ distribute, sublicense, and/or sell copies of the Software, and to
\ permit persons to whom the Software is furnished to do so, subject to
\ the following conditions:
\
\ The above copyright notice and this permission notice shall be
\ included in all copies or substantial portions of the Software.
\
\ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
\ EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
\ MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
\ NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
\ LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
\ OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
\ WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
\
\ LICENSE_END
