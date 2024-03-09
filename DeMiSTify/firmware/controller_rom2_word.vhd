library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller_rom2 is
generic	(
	ADDR_WIDTH : integer := 8; -- ROM's address width (words, not bytes)
	COL_WIDTH  : integer := 8;  -- Column width (8bit -> byte)
	NB_COL     : integer := 4  -- Number of columns in memory
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

architecture arch of controller_rom2 is

-- type word_t is std_logic_vector(31 downto 0);
type ram_type is array (0 to 2 ** ADDR_WIDTH - 1) of std_logic_vector(NB_COL * COL_WIDTH - 1 downto 0);

signal ram : ram_type :=
(

     0 => x"58a6cc87",
     1 => x"dae649c7",
     2 => x"05987087",
     3 => x"496e87c8",
     4 => x"c10299c1",
     5 => x"4bc187c3",
     6 => x"c27ebfec",
     7 => x"49bfe9cc",
     8 => x"c887f6e2",
     9 => x"d4cc4966",
    10 => x"02987087",
    11 => x"ccc287d8",
    12 => x"c149bfe1",
    13 => x"e5ccc2b9",
    14 => x"fbfd7159",
    15 => x"49eecb87",
    16 => x"cc87eecb",
    17 => x"49c758a6",
    18 => x"7087d8e5",
    19 => x"c5ff0598",
    20 => x"c1496e87",
    21 => x"fdfe0599",
    22 => x"029b7387",
    23 => x"49ff87d0",
    24 => x"c187cdfc",
    25 => x"fae449da",
    26 => x"48a6c487",
    27 => x"ccc278c1",
    28 => x"c005bfe9",
    29 => x"fdc387e9",
    30 => x"87e7e449",
    31 => x"e449fac3",
    32 => x"497487e1",
    33 => x"7199ffc3",
    34 => x"fc49c01e",
    35 => x"497487dc",
    36 => x"7129b7c8",
    37 => x"fc49c11e",
    38 => x"86c887d0",
    39 => x"7487ecc8",
    40 => x"99ffc349",
    41 => x"712cb7c8",
    42 => x"029c74b4",
    43 => x"ccc287dd",
    44 => x"ca49bfe5",
    45 => x"987087c7",
    46 => x"c087c405",
    47 => x"c287d24c",
    48 => x"ecc949e0",
    49 => x"e9ccc287",
    50 => x"c287c658",
    51 => x"c048e5cc",
    52 => x"c2497478",
    53 => x"87cd0599",
    54 => x"e349ebc3",
    55 => x"497087c5",
    56 => x"cf0299c2",
    57 => x"a5d8c187",
    58 => x"02bf6e7e",
    59 => x"4b87c5c0",
    60 => x"0f7349fb",
    61 => x"99c14974",
    62 => x"c387cd05",
    63 => x"e2e249f4",
    64 => x"c2497087",
    65 => x"87cf0299",
    66 => x"7ea5d8c1",
    67 => x"c002bf6e",
    68 => x"fa4b87c5",
    69 => x"740f7349",
    70 => x"0599c849",
    71 => x"f5c387ce",
    72 => x"87ffe149",
    73 => x"99c24970",
    74 => x"87e5c002",
    75 => x"bfd1dfc2",
    76 => x"87cac002",
    77 => x"c288c148",
    78 => x"c058d5df",
    79 => x"d8c187ce",
    80 => x"026a4aa5",
    81 => x"4b87c5c0",
    82 => x"0f7349ff",
    83 => x"c148a6c4",
    84 => x"c4497478",
    85 => x"cec00599",
    86 => x"49f2c387",
    87 => x"7087c4e1",
    88 => x"0299c249",
    89 => x"c287ecc0",
    90 => x"7ebfd1df",
    91 => x"a8b7c748",
    92 => x"87cbc003",
    93 => x"80c1486e",
    94 => x"58d5dfc2",
    95 => x"c187cfc0",
    96 => x"6e7ea5d8",
    97 => x"c5c002bf",
    98 => x"49fe4b87",
    99 => x"a6c40f73",
   100 => x"c378c148",
   101 => x"cae049fd",
   102 => x"c2497087",
   103 => x"e5c00299",
   104 => x"d1dfc287",
   105 => x"c9c002bf",
   106 => x"d1dfc287",
   107 => x"c078c048",
   108 => x"d8c187cf",
   109 => x"bf6e7ea5",
   110 => x"87c5c002",
   111 => x"7349fd4b",
   112 => x"48a6c40f",
   113 => x"fac378c1",
   114 => x"d6dfff49",
   115 => x"c2497087",
   116 => x"e9c00299",
   117 => x"d1dfc287",
   118 => x"b7c748bf",
   119 => x"c9c003a8",
   120 => x"d1dfc287",
   121 => x"c078c748",
   122 => x"d8c187cf",
   123 => x"bf6e7ea5",
   124 => x"87c5c002",
   125 => x"7349fc4b",
   126 => x"48a6c40f",
   127 => x"4bc078c1",
   128 => x"48ccdfc2",
   129 => x"eecb50c0",
   130 => x"87e5c449",
   131 => x"c258a6cc",
   132 => x"bf97ccdf",
   133 => x"87dec105",
   134 => x"f0c34974",
   135 => x"cdc00599",
   136 => x"49dac187",
   137 => x"87fbddff",
   138 => x"c1029870",
   139 => x"4bc187c8",
   140 => x"494cbfe8",
   141 => x"c899ffc3",
   142 => x"b4712cb7",
   143 => x"bfe9ccc2",
   144 => x"d4daff49",
   145 => x"4966c887",
   146 => x"7087f2c3",
   147 => x"c6c00298",
   148 => x"ccdfc287",
   149 => x"c250c148",
   150 => x"bf97ccdf",
   151 => x"87d6c005",
   152 => x"f0c34974",
   153 => x"c5ff0599",
   154 => x"49dac187",
   155 => x"87f3dcff",
   156 => x"fe059870",
   157 => x"9b7387f8",
   158 => x"87dcc002",
   159 => x"c248a6c8",
   160 => x"78bfd1df",
   161 => x"cb4966c8",
   162 => x"7ea17591",
   163 => x"c002bf6e",
   164 => x"c84b87c6",
   165 => x"0f734966",
   166 => x"c00266c4",
   167 => x"dfc287c8",
   168 => x"f149bfd1",
   169 => x"ccc287e5",
   170 => x"c002bfed",
   171 => x"c24987dd",
   172 => x"987087cb",
   173 => x"87d3c002",
   174 => x"bfd1dfc2",
   175 => x"87cbf149",
   176 => x"ebf249c0",
   177 => x"edccc287",
   178 => x"f478c048",
   179 => x"87c5f28e",
   180 => x"5c5b5e0e",
   181 => x"711e0e5d",
   182 => x"cddfc24c",
   183 => x"cdc149bf",
   184 => x"d1c14da1",
   185 => x"747e6981",
   186 => x"87cf029c",
   187 => x"744ba5c4",
   188 => x"cddfc27b",
   189 => x"e4f149bf",
   190 => x"747b6e87",
   191 => x"87c4059c",
   192 => x"87c24bc0",
   193 => x"49734bc1",
   194 => x"d487e5f1",
   195 => x"87c70266",
   196 => x"7087de49",
   197 => x"c087c24a",
   198 => x"f1ccc24a",
   199 => x"f4f0265a",
   200 => x"00000087",
   201 => x"00000000",
   202 => x"00000000",
   203 => x"00000000",
   204 => x"4a711e00",
   205 => x"49bfc8ff",
   206 => x"2648a172",
   207 => x"c8ff1e4f",
   208 => x"c0fe89bf",
   209 => x"c0c0c0c0",
   210 => x"87c401a9",
   211 => x"87c24ac0",
   212 => x"48724ac1",
   213 => x"48724f26",
  others => ( x"00000000")
);

-- Xilinx Vivado attributes
attribute ram_style: string;
attribute ram_style of ram: signal is "block";

signal q_local : std_logic_vector((NB_COL * COL_WIDTH)-1 downto 0);

signal wea : std_logic_vector(NB_COL - 1 downto 0);

begin

	output:
	for i in 0 to NB_COL - 1 generate
		q((i + 1) * COL_WIDTH - 1 downto i * COL_WIDTH) <= q_local((i+1) * COL_WIDTH - 1 downto i * COL_WIDTH);
	end generate;
    
    -- Generate write enable signals
    -- The Block ram generator doesn't like it when the compare is done in the if statement it self.
    wea <= bytesel when we = '1' else (others => '0');

    process(clk)
    begin
        if rising_edge(clk) then
            q_local <= ram(to_integer(unsigned(addr)));
            for i in 0 to NB_COL - 1 loop
                if (wea(NB_COL-i-1) = '1') then
                    ram(to_integer(unsigned(addr)))((i + 1) * COL_WIDTH - 1 downto i * COL_WIDTH) <= d((i + 1) * COL_WIDTH - 1 downto i * COL_WIDTH);
                end if;
            end loop;
        end if;
    end process;

end arch;
