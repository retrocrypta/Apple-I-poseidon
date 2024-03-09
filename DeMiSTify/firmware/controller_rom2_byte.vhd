
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller_rom2 is
generic
	(
		ADDR_WIDTH : integer := 15 -- Specify your actual ROM size to save LEs and unnecessary block RAM usage.
	);
port (
	clk : in std_logic;
	reset_n : in std_logic := '1';
	addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
	q : out std_logic_vector(31 downto 0);
	-- Allow writes - defaults supplied to simplify projects that don't need to write.
	d : in std_logic_vector(31 downto 0) := X"00000000";
	we : in std_logic := '0';
	bytesel : in std_logic_vector(3 downto 0) := "1111"
);
end entity;

architecture rtl of controller_rom2 is

	signal addr1 : integer range 0 to 2**ADDR_WIDTH-1;

	--  build up 2D array to hold the memory
	type word_t is array (0 to 3) of std_logic_vector(7 downto 0);
	type ram_t is array (0 to 2 ** ADDR_WIDTH - 1) of word_t;

	signal ram : ram_t:=
	(

     0 => (x"58",x"a6",x"cc",x"87"),
     1 => (x"da",x"e6",x"49",x"c7"),
     2 => (x"05",x"98",x"70",x"87"),
     3 => (x"49",x"6e",x"87",x"c8"),
     4 => (x"c1",x"02",x"99",x"c1"),
     5 => (x"4b",x"c1",x"87",x"c3"),
     6 => (x"c2",x"7e",x"bf",x"ec"),
     7 => (x"49",x"bf",x"e9",x"cc"),
     8 => (x"c8",x"87",x"f6",x"e2"),
     9 => (x"d4",x"cc",x"49",x"66"),
    10 => (x"02",x"98",x"70",x"87"),
    11 => (x"cc",x"c2",x"87",x"d8"),
    12 => (x"c1",x"49",x"bf",x"e1"),
    13 => (x"e5",x"cc",x"c2",x"b9"),
    14 => (x"fb",x"fd",x"71",x"59"),
    15 => (x"49",x"ee",x"cb",x"87"),
    16 => (x"cc",x"87",x"ee",x"cb"),
    17 => (x"49",x"c7",x"58",x"a6"),
    18 => (x"70",x"87",x"d8",x"e5"),
    19 => (x"c5",x"ff",x"05",x"98"),
    20 => (x"c1",x"49",x"6e",x"87"),
    21 => (x"fd",x"fe",x"05",x"99"),
    22 => (x"02",x"9b",x"73",x"87"),
    23 => (x"49",x"ff",x"87",x"d0"),
    24 => (x"c1",x"87",x"cd",x"fc"),
    25 => (x"fa",x"e4",x"49",x"da"),
    26 => (x"48",x"a6",x"c4",x"87"),
    27 => (x"cc",x"c2",x"78",x"c1"),
    28 => (x"c0",x"05",x"bf",x"e9"),
    29 => (x"fd",x"c3",x"87",x"e9"),
    30 => (x"87",x"e7",x"e4",x"49"),
    31 => (x"e4",x"49",x"fa",x"c3"),
    32 => (x"49",x"74",x"87",x"e1"),
    33 => (x"71",x"99",x"ff",x"c3"),
    34 => (x"fc",x"49",x"c0",x"1e"),
    35 => (x"49",x"74",x"87",x"dc"),
    36 => (x"71",x"29",x"b7",x"c8"),
    37 => (x"fc",x"49",x"c1",x"1e"),
    38 => (x"86",x"c8",x"87",x"d0"),
    39 => (x"74",x"87",x"ec",x"c8"),
    40 => (x"99",x"ff",x"c3",x"49"),
    41 => (x"71",x"2c",x"b7",x"c8"),
    42 => (x"02",x"9c",x"74",x"b4"),
    43 => (x"cc",x"c2",x"87",x"dd"),
    44 => (x"ca",x"49",x"bf",x"e5"),
    45 => (x"98",x"70",x"87",x"c7"),
    46 => (x"c0",x"87",x"c4",x"05"),
    47 => (x"c2",x"87",x"d2",x"4c"),
    48 => (x"ec",x"c9",x"49",x"e0"),
    49 => (x"e9",x"cc",x"c2",x"87"),
    50 => (x"c2",x"87",x"c6",x"58"),
    51 => (x"c0",x"48",x"e5",x"cc"),
    52 => (x"c2",x"49",x"74",x"78"),
    53 => (x"87",x"cd",x"05",x"99"),
    54 => (x"e3",x"49",x"eb",x"c3"),
    55 => (x"49",x"70",x"87",x"c5"),
    56 => (x"cf",x"02",x"99",x"c2"),
    57 => (x"a5",x"d8",x"c1",x"87"),
    58 => (x"02",x"bf",x"6e",x"7e"),
    59 => (x"4b",x"87",x"c5",x"c0"),
    60 => (x"0f",x"73",x"49",x"fb"),
    61 => (x"99",x"c1",x"49",x"74"),
    62 => (x"c3",x"87",x"cd",x"05"),
    63 => (x"e2",x"e2",x"49",x"f4"),
    64 => (x"c2",x"49",x"70",x"87"),
    65 => (x"87",x"cf",x"02",x"99"),
    66 => (x"7e",x"a5",x"d8",x"c1"),
    67 => (x"c0",x"02",x"bf",x"6e"),
    68 => (x"fa",x"4b",x"87",x"c5"),
    69 => (x"74",x"0f",x"73",x"49"),
    70 => (x"05",x"99",x"c8",x"49"),
    71 => (x"f5",x"c3",x"87",x"ce"),
    72 => (x"87",x"ff",x"e1",x"49"),
    73 => (x"99",x"c2",x"49",x"70"),
    74 => (x"87",x"e5",x"c0",x"02"),
    75 => (x"bf",x"d1",x"df",x"c2"),
    76 => (x"87",x"ca",x"c0",x"02"),
    77 => (x"c2",x"88",x"c1",x"48"),
    78 => (x"c0",x"58",x"d5",x"df"),
    79 => (x"d8",x"c1",x"87",x"ce"),
    80 => (x"02",x"6a",x"4a",x"a5"),
    81 => (x"4b",x"87",x"c5",x"c0"),
    82 => (x"0f",x"73",x"49",x"ff"),
    83 => (x"c1",x"48",x"a6",x"c4"),
    84 => (x"c4",x"49",x"74",x"78"),
    85 => (x"ce",x"c0",x"05",x"99"),
    86 => (x"49",x"f2",x"c3",x"87"),
    87 => (x"70",x"87",x"c4",x"e1"),
    88 => (x"02",x"99",x"c2",x"49"),
    89 => (x"c2",x"87",x"ec",x"c0"),
    90 => (x"7e",x"bf",x"d1",x"df"),
    91 => (x"a8",x"b7",x"c7",x"48"),
    92 => (x"87",x"cb",x"c0",x"03"),
    93 => (x"80",x"c1",x"48",x"6e"),
    94 => (x"58",x"d5",x"df",x"c2"),
    95 => (x"c1",x"87",x"cf",x"c0"),
    96 => (x"6e",x"7e",x"a5",x"d8"),
    97 => (x"c5",x"c0",x"02",x"bf"),
    98 => (x"49",x"fe",x"4b",x"87"),
    99 => (x"a6",x"c4",x"0f",x"73"),
   100 => (x"c3",x"78",x"c1",x"48"),
   101 => (x"ca",x"e0",x"49",x"fd"),
   102 => (x"c2",x"49",x"70",x"87"),
   103 => (x"e5",x"c0",x"02",x"99"),
   104 => (x"d1",x"df",x"c2",x"87"),
   105 => (x"c9",x"c0",x"02",x"bf"),
   106 => (x"d1",x"df",x"c2",x"87"),
   107 => (x"c0",x"78",x"c0",x"48"),
   108 => (x"d8",x"c1",x"87",x"cf"),
   109 => (x"bf",x"6e",x"7e",x"a5"),
   110 => (x"87",x"c5",x"c0",x"02"),
   111 => (x"73",x"49",x"fd",x"4b"),
   112 => (x"48",x"a6",x"c4",x"0f"),
   113 => (x"fa",x"c3",x"78",x"c1"),
   114 => (x"d6",x"df",x"ff",x"49"),
   115 => (x"c2",x"49",x"70",x"87"),
   116 => (x"e9",x"c0",x"02",x"99"),
   117 => (x"d1",x"df",x"c2",x"87"),
   118 => (x"b7",x"c7",x"48",x"bf"),
   119 => (x"c9",x"c0",x"03",x"a8"),
   120 => (x"d1",x"df",x"c2",x"87"),
   121 => (x"c0",x"78",x"c7",x"48"),
   122 => (x"d8",x"c1",x"87",x"cf"),
   123 => (x"bf",x"6e",x"7e",x"a5"),
   124 => (x"87",x"c5",x"c0",x"02"),
   125 => (x"73",x"49",x"fc",x"4b"),
   126 => (x"48",x"a6",x"c4",x"0f"),
   127 => (x"4b",x"c0",x"78",x"c1"),
   128 => (x"48",x"cc",x"df",x"c2"),
   129 => (x"ee",x"cb",x"50",x"c0"),
   130 => (x"87",x"e5",x"c4",x"49"),
   131 => (x"c2",x"58",x"a6",x"cc"),
   132 => (x"bf",x"97",x"cc",x"df"),
   133 => (x"87",x"de",x"c1",x"05"),
   134 => (x"f0",x"c3",x"49",x"74"),
   135 => (x"cd",x"c0",x"05",x"99"),
   136 => (x"49",x"da",x"c1",x"87"),
   137 => (x"87",x"fb",x"dd",x"ff"),
   138 => (x"c1",x"02",x"98",x"70"),
   139 => (x"4b",x"c1",x"87",x"c8"),
   140 => (x"49",x"4c",x"bf",x"e8"),
   141 => (x"c8",x"99",x"ff",x"c3"),
   142 => (x"b4",x"71",x"2c",x"b7"),
   143 => (x"bf",x"e9",x"cc",x"c2"),
   144 => (x"d4",x"da",x"ff",x"49"),
   145 => (x"49",x"66",x"c8",x"87"),
   146 => (x"70",x"87",x"f2",x"c3"),
   147 => (x"c6",x"c0",x"02",x"98"),
   148 => (x"cc",x"df",x"c2",x"87"),
   149 => (x"c2",x"50",x"c1",x"48"),
   150 => (x"bf",x"97",x"cc",x"df"),
   151 => (x"87",x"d6",x"c0",x"05"),
   152 => (x"f0",x"c3",x"49",x"74"),
   153 => (x"c5",x"ff",x"05",x"99"),
   154 => (x"49",x"da",x"c1",x"87"),
   155 => (x"87",x"f3",x"dc",x"ff"),
   156 => (x"fe",x"05",x"98",x"70"),
   157 => (x"9b",x"73",x"87",x"f8"),
   158 => (x"87",x"dc",x"c0",x"02"),
   159 => (x"c2",x"48",x"a6",x"c8"),
   160 => (x"78",x"bf",x"d1",x"df"),
   161 => (x"cb",x"49",x"66",x"c8"),
   162 => (x"7e",x"a1",x"75",x"91"),
   163 => (x"c0",x"02",x"bf",x"6e"),
   164 => (x"c8",x"4b",x"87",x"c6"),
   165 => (x"0f",x"73",x"49",x"66"),
   166 => (x"c0",x"02",x"66",x"c4"),
   167 => (x"df",x"c2",x"87",x"c8"),
   168 => (x"f1",x"49",x"bf",x"d1"),
   169 => (x"cc",x"c2",x"87",x"e5"),
   170 => (x"c0",x"02",x"bf",x"ed"),
   171 => (x"c2",x"49",x"87",x"dd"),
   172 => (x"98",x"70",x"87",x"cb"),
   173 => (x"87",x"d3",x"c0",x"02"),
   174 => (x"bf",x"d1",x"df",x"c2"),
   175 => (x"87",x"cb",x"f1",x"49"),
   176 => (x"eb",x"f2",x"49",x"c0"),
   177 => (x"ed",x"cc",x"c2",x"87"),
   178 => (x"f4",x"78",x"c0",x"48"),
   179 => (x"87",x"c5",x"f2",x"8e"),
   180 => (x"5c",x"5b",x"5e",x"0e"),
   181 => (x"71",x"1e",x"0e",x"5d"),
   182 => (x"cd",x"df",x"c2",x"4c"),
   183 => (x"cd",x"c1",x"49",x"bf"),
   184 => (x"d1",x"c1",x"4d",x"a1"),
   185 => (x"74",x"7e",x"69",x"81"),
   186 => (x"87",x"cf",x"02",x"9c"),
   187 => (x"74",x"4b",x"a5",x"c4"),
   188 => (x"cd",x"df",x"c2",x"7b"),
   189 => (x"e4",x"f1",x"49",x"bf"),
   190 => (x"74",x"7b",x"6e",x"87"),
   191 => (x"87",x"c4",x"05",x"9c"),
   192 => (x"87",x"c2",x"4b",x"c0"),
   193 => (x"49",x"73",x"4b",x"c1"),
   194 => (x"d4",x"87",x"e5",x"f1"),
   195 => (x"87",x"c7",x"02",x"66"),
   196 => (x"70",x"87",x"de",x"49"),
   197 => (x"c0",x"87",x"c2",x"4a"),
   198 => (x"f1",x"cc",x"c2",x"4a"),
   199 => (x"f4",x"f0",x"26",x"5a"),
   200 => (x"00",x"00",x"00",x"87"),
   201 => (x"00",x"00",x"00",x"00"),
   202 => (x"00",x"00",x"00",x"00"),
   203 => (x"00",x"00",x"00",x"00"),
   204 => (x"4a",x"71",x"1e",x"00"),
   205 => (x"49",x"bf",x"c8",x"ff"),
   206 => (x"26",x"48",x"a1",x"72"),
   207 => (x"c8",x"ff",x"1e",x"4f"),
   208 => (x"c0",x"fe",x"89",x"bf"),
   209 => (x"c0",x"c0",x"c0",x"c0"),
   210 => (x"87",x"c4",x"01",x"a9"),
   211 => (x"87",x"c2",x"4a",x"c0"),
   212 => (x"48",x"72",x"4a",x"c1"),
   213 => (x"48",x"72",x"4f",x"26"),
		others => (others => x"00")
	);
	signal q1_local : word_t;

	-- Altera Quartus attributes
	attribute ramstyle: string;
	attribute ramstyle of ram: signal is "no_rw_check";

begin  -- rtl

	addr1 <= to_integer(unsigned(addr(ADDR_WIDTH-1 downto 0)));

	-- Reorganize the read data from the RAM to match the output
	q(7 downto 0) <= q1_local(3);
	q(15 downto 8) <= q1_local(2);
	q(23 downto 16) <= q1_local(1);
	q(31 downto 24) <= q1_local(0);

	process(clk)
	begin
		if(rising_edge(clk)) then 
			if(we = '1') then
				-- edit this code if using other than four bytes per word
				if (bytesel(3) = '1') then
					ram(addr1)(3) <= d(7 downto 0);
				end if;
				if (bytesel(2) = '1') then
					ram(addr1)(2) <= d(15 downto 8);
				end if;
				if (bytesel(1) = '1') then
					ram(addr1)(1) <= d(23 downto 16);
				end if;
				if (bytesel(0) = '1') then
					ram(addr1)(0) <= d(31 downto 24);
				end if;
			end if;
			q1_local <= ram(addr1);
		end if;
	end process;
  
end rtl;

