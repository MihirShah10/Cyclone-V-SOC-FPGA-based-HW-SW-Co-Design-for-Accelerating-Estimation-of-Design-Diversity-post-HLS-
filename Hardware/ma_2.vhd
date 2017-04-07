library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;



ENTITY ma_2 IS

PORT (
		a1 : in std_logic;
		b1 : in std_logic;
		c1 : in std_logic;
		d1 : in std_logic;
		y1 : out std_logic
);

END ma_2;

ARCHITECTURE main OF ma_2 IS

SIGNAL J1,J2,J3,J4,J5: STD_LOGIC;
SIGNAL A1_NOT,B1_NOT,C1_NOT,D1_NOT: STD_LOGIC;

BEGIN

A1_NOT <= not(a1);
B1_NOT <= not(b1);
C1_NOT <= not(c1);
D1_NOT <= not(d1);

J1 <= (A1_NOT and B1_NOT);
J2 <= (J1 or C1_NOT);
J3 <= (C1_NOT or B1_NOT);
J4 <= (J3 OR D1_NOT);
J5 <= (J2 and J4);
y1 <= not(J5);

END main;