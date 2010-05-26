' This file is part of 'Buiten Wedstrijd Installatie' - HBSV Assumburg
' (C) 2009 Paul Hooijenga - <phooijenga@gmail.com>
' $Id$
'

#include "lcd_header.bas"	' 2 BYTEs
#include "key_header.bas"	' 2 BYTEs

DEFINE red		PORT[1]
DEFINE orange 	PORT[2]
DEFINE green 	PORT[3]
DEFINE buzzer 	PORT[4]
DEFINE A 		PORT[5]
DEFINE B 		PORT[6]
DEFINE C 		PORT[7]
DEFINE D 		PORT[8]

DEFINE menu_option	BYTE '5
DEFINE i			BYTE
DEFINE j			BYTE
DEFINE rounds		BYTE
DEFINE archer		BYTE ' 9
DEFINE green_time	WORD ' 10 - 11
DEFINE t			WORD ' 12 - 13
DEFINE time_left	WORD ' 14 - 15

DEFINE options		BYTE[20]
DEFINE half			BIT[161]
DEFINE long			BIT[162]
DEFINE proef		BIT[163]
DEFINE round_proef	BIT[164]
DEFINE round_ab		BIT[165]
DEFINE panic_red	BIT[166]
DEFINE panic_orange	BIT[167]
DEFINE panic_green	BIT[168]
DEFINE opschiet		BIT[169]

' Magic Constants
DEFINE TICKS_PER_SECOND 50
DEFINE RED_TIME			500		' 10 sec
DEFINE ORANGE_TIME		1500	' 30 sec
DEFINE GREEN_TIME_LONG 	12000	' 240 sec
DEFINE GREEN_TIME_SHORT 6000	' 120 sec
DEFINE COLLECT_MIN_TIME 300	' 60 sec
DEFINE PANIC_RED_TIME	1000	' 20 sec
DEFINE PANIC_BACK_TIME	1500	' 30 sec

' Initialize LCD Screen
GOSUB lcd_init

' Store our custom chars in the LCD's Memory
GOSUB custom_chars_setup

' Default Settings
half = OFF
long = OFF
proef = ON
opschiet = OFF

' Start at Metric Option
menu_option = 0

#include "menu.bas"

#start_proef
	IF long = ON THEN green_time = GREEN_TIME_LONG ELSE green_time = GREEN_TIME_SHORT
	'IF opschiet = ON THEN green_time = GREEN_TIME_OPSCHIET
	
	IF proef = OFF THEN GOTO start_round_1
	
	round_proef = ON
	IF long THEN rounds = 1 ELSE rounds = 2
	IF opschiet THEN rounds = 1
	
	FOR i = 1 TO rounds
		round_ab = ON
		GOSUB round
	NEXT i
	
#start_round_1
	round_proef = OFF
	round_ab = ON
	
	IF long THEN rounds = 6 ELSE rounds = 12
	IF half THEN rounds = rounds / 2
		
	FOR i = 1 TO rounds
		GOSUB round
	NEXT i

	A = OFF
	B = OFF
	C = OFF
	D = OFF
	
	GOTO menu_render_controls

#include "round.bas"
#include "panic.bas"

#include "lcd_chars.bas"
#include "lcd_routines.bas"
#include "key_routines.bas"
#include "signal_routines.bas"
#include "test_routines.bas"

