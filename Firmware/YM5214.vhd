
----------------------------------------------------------------
-- Emulation chip Yamaha YM5214 (MSX) v1.00.0002
----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity YM5214 is
  port(
  RD_n		: IN std_logic;
  IORQ_n	: IN std_logic;
  M1_n		: IN std_logic;
  A3		: IN std_logic;
  A4		: IN std_logic;
  A5		: IN std_logic;
  A6		: IN std_logic; 
  A7		: IN std_logic;
  A14		: IN std_logic; 
  A15		: IN std_logic;
  WE_n		: OUT std_logic;
  RESET_n	: IN std_logic;
  CS0L		: IN std_logic;
  CS0H		: IN std_logic;
  CS1L		: IN std_logic;
  CS1H		: IN std_logic;
  CS2L		: IN std_logic;
  CS2H		: IN std_logic;
  CS3L		: IN std_logic;
  CS3H		: IN std_logic;
  MERQ_n	: IN std_logic;
  RFSH_n	: IN std_logic;
  CLK		: IN std_logic;
  WAIT_n	: OUT std_logic;
  PRT_n		: OUT std_logic;
  VDP_n		: OUT std_logic;
  SSG		: OUT std_logic;
  PPI_n		: OUT std_logic;
  RAS_n		: OUT std_logic;
  MPX		: OUT std_logic;
  CAS2_n	: OUT std_logic;
  CAS3_n	: OUT std_logic;
  ROMCS_n	: OUT std_logic;
  CS1_n		: OUT std_logic;
  CS2_n		: OUT std_logic;
  SLT1_n	: OUT std_logic;
  SLT2_n	: OUT std_logic;
  SLT3_n	: OUT std_logic     
  );
end YM5214;

architecture RTL of YM5214 is

  signal M1w_r		 : std_logic;
  signal Wo_r		 : std_logic;
  signal SM1w		 : std_logic;
  signal PPI		 : std_logic;
  signal PPI_RDY	 : std_logic; 
  signal SLTSL_MAPPER_n	 : std_logic; 
  signal YY			: std_logic_vector(1 downto 0);
  signal RAS	 : std_logic; 
  signal MPXt	 : std_logic;
  signal CASp	 : std_logic;  
  signal CASt	 : std_logic;

begin
  ----------------------------------------------------------------
  -- I/O
  ----------------------------------------------------------------
  PRT_n <= '0' when M1_n='1' and IORQ_n='0' and A7='1' and A6='0' and A5='0' and A4='1' and A3='0'
      else '1';
  VDP_n <= '0' when M1_n='1' and IORQ_n='0' and A7='1' and A6='0' and A5='0' and A4='1' and A3='1'
      else '1';
  SSG   <= '1' when M1_n='1' and IORQ_n='0' and A7='1' and A6='0' and A5='1' and A4='0' and A3='0'                 
      else '0';
  PPI   <= '1' when M1_n='1' and IORQ_n='0' and A7='1' and A6='0' and A5='1' and A4='0' and A3='1'
      else '0';  
  PPI_n <= not PPI;

  PPI_RDY <= '1' when RESET_n = '1' and (PPI = '1' or PPI_RDY = '1')
        else '0';
  YY	<= "00" when PPI_RDY = '0'
      else CS0H & CS0L when A15='0' and A14='0'
      else CS1H & CS1L when A15='0' and A14='1'
      else CS2H & CS2L when A15='1' and A14='0'
      else CS3H & CS3L;
  ROMCS_n <= '0' when A15='0' and RFSH_n='1' and MERQ_n='0' and YY="00"
        else '1'; 
  SLTSL_MAPPER_n <= '0' when A15='1' and RFSH_n='1' and MERQ_n='0' and YY="00"
        else '1';
  SLT1_n <= '0' when RFSH_n='1' and MERQ_n='0' and YY="01"
       else '1';  
  SLT2_n <= '0' when RFSH_n='1' and MERQ_n='0' and YY="10"
       else '1';  
  SLT3_n <= '0' when RFSH_n='1' and MERQ_n='0' and YY="11"
       else '1';  
  ----------------------------------------------------------------
  -- CS1/CS2
  ----------------------------------------------------------------     
  CS1_n <= '0' when MERQ_n='0' and RD_n='0' and A15='0' and A14='1'
      else '1';     
  CS2_n <= '0' when MERQ_n='0' and RD_n='0' and A15='1' and A14='0'
      else '1';       
  ----------------------------------------------------------------
  -- Mapper (DRAM control)
  ----------------------------------------------------------------
  WE_n <='1' when MERQ_n='0' and RD_n='0'
	else '0';
  RAS_n <= not RAS;
  RAS <= '1' when MERQ_n='0' and (RFSH_n='0' or SLTSL_MAPPER_n='0')
    else '0'; 
  process(CLK, RAS, MERQ_n, MPXt)
  begin
    if (MERQ_n = '1') then MPXt <= '0';
    elsif (CLK'event and CLK = '1') then MPXt <= RAS;
    end if;  
  end process;
  MPX <= MPXt;
  CASp <= '0' when SLTSL_MAPPER_n = '0' and MPXt = '1' else '1';
  process(CLK, CASp, MERQ_n, CASt)
  begin
    if (MERQ_n = '1') then CASt <= '1';
    elsif (CLK'event and CLK = '0') then CASt <= CASp;
    end if;
  end process;
  CAS3_n <= '0' when CASt='0' and A15='1' and A14='1'
       else '1';
  CAS2_n <= '0' when CASt='0' and A15='1' and A14='0'
       else '1';
   ----------------------------------------------------------------
  -- Slignal Wait
  ----------------------------------------------------------------
  process(CLK, M1_n, M1w_r, SM1w)
  begin
    if (SM1w = '0') then Wo_r <= '1';
    elsif (CLK'event and CLK = '1') then Wo_r <= M1_n;
    end if;
  end process;
  process(CLK, M1w_r, SM1w)
  begin
    if (CLK'event and CLK = '1') then SM1w <= Wo_r;
    end if;
  end process;
  WAIT_n <= '0' when Wo_r ='0'
       else 'Z';

end RTL;

  