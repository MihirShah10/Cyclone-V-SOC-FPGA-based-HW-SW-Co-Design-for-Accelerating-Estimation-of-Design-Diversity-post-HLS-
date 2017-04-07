library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;



ENTITY ma_1 IS

PORT (
		a0 : in std_logic;
		b0 : in std_logic;
		c0 : in std_logic;
		d0 : in std_logic;
		y0 : out std_logic
);

END ma_1;

ARCHITECTURE main OF ma_1 IS
SIGNAL R1,R2,R3,R4: STD_LOGIC;

BEGIN

R1 <= (a0 OR b0);
R2 <= (R1 and c0);
R3 <= (c0 or b0);
R4 <= (R3 and d0);
y0 <= (R2 or R4 );

END main;