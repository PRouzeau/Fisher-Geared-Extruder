;modified data for geared extruder - add at the end of your config file, or modify lines 

M569 P4 S0				; Drive 4:  extruder goes backwards. Reverse from original due to geared transmission
M566 E600				; Maximum instant speed changes mm/minute  extruder max speed change from 1200 to 600
M906 E1000				; Set motor currents (mA) Extruder I from 1200 to 1000 - geared - do not set too low for good retract
M201 E2000				; Accelerations (mm/s^2)  Extruder acceleration from 4000 to 2000 - geared
M92 E420.0				; extrusion rate, with geared extruder - copied from Ormerod, nearly exact

; and in your slicer profile, retract speed reduced to 80mm/s