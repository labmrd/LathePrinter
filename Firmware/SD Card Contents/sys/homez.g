; homez.g
; called to home the Z axis
;
; generated by RepRapFirmware Configuration Tool v2.1.8 on Fri Jan 17 2020 10:35:56 GMT-0600 (Central Standard Time)
G91                     ; relative positioning
G1 H1 Z-1000 F3500
G1 H2 Z5 F3500
G1 H1 Z-10 F500
G1 H2 Z5 F1000
G90                     ; absolute positioning
G92 Z0