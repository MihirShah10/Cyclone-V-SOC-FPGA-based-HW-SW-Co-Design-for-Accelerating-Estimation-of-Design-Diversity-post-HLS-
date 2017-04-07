library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;



ENTITY HPSFPGA IS
PORT(
---------FPGA Connections-------------
CLOCK_50: IN STD_LOGIC;
SW:IN STD_LOGIC_VECTOR(4 downto 0);
LEDR: OUT STD_LOGIC_VECTOR(4 downto 0);
GPIO_0: INOUT STD_LOGIC_VECTOR (22 downto 0);
GPIO_1: INOUT STD_LOGIC_VECTOR (18 downto 0);

---------HPS Connections---------------
HPS_CONV_USB_N:INOUT STD_LOGIC;
HPS_DDR3_ADDR:OUT STD_LOGIC_VECTOR(14 downto 0);
HPS_DDR3_BA: OUT STD_LOGIC_VECTOR(2 downto 0);
HPS_DDR3_CAS_N: OUT STD_LOGIC;
HPS_DDR3_CKE:OUT STD_LOGIC;
HPS_DDR3_CK_N: OUT STD_LOGIC;
HPS_DDR3_CK_P: OUT STD_LOGIC;
HPS_DDR3_CS_N: OUT STD_LOGIC;
HPS_DDR3_DM: OUT STD_LOGIC_VECTOR(3 downto 0);
HPS_DDR3_DQ: INOUT STD_LOGIC_VECTOR(31 downto 0);
HPS_DDR3_DQS_N: INOUT STD_LOGIC_VECTOR(3 downto 0);
HPS_DDR3_DQS_P: INOUT STD_LOGIC_VECTOR(3 downto 0);
HPS_DDR3_ODT: OUT STD_LOGIC;
HPS_DDR3_RAS_N: OUT STD_LOGIC;
HPS_DDR3_RESET_N: OUT  STD_LOGIC;
HPS_DDR3_RZQ: IN  STD_LOGIC;
HPS_DDR3_WE_N: OUT STD_LOGIC;
HPS_ENET_GTX_CLK: OUT STD_LOGIC;
HPS_ENET_INT_N:INOUT STD_LOGIC;
HPS_ENET_MDC:OUT STD_LOGIC;
HPS_ENET_MDIO:INOUT STD_LOGIC;
HPS_ENET_RX_CLK: IN STD_LOGIC;
HPS_ENET_RX_DATA: IN STD_LOGIC_VECTOR(3 downto 0);
HPS_ENET_RX_DV: IN STD_LOGIC;
HPS_ENET_TX_DATA: OUT STD_LOGIC_VECTOR(3 downto 0);
HPS_ENET_TX_EN: OUT STD_LOGIC;
HPS_KEY: INOUT STD_LOGIC;
HPS_SD_CLK: OUT STD_LOGIC;
HPS_SD_CMD: INOUT STD_LOGIC;
HPS_SD_DATA: INOUT STD_LOGIC_VECTOR(3 downto 0);
HPS_UART_RX: IN   STD_LOGIC;
HPS_UART_TX: OUT STD_LOGIC;
HPS_USB_CLKOUT: IN STD_LOGIC;
HPS_USB_DATA:INOUT STD_LOGIC_VECTOR(7 downto 0);
HPS_USB_DIR: IN STD_LOGIC;
HPS_USB_NXT: IN STD_LOGIC;
HPS_USB_STP: OUT STD_LOGIC

);
END HPSFPGA;

ARCHITECTURE MAIN OF HPSFPGA IS

 component hps_fpga is
        port (
            clk_clk                         : in    std_logic                     := 'X';             -- clk
            reset_reset_n                   : in    std_logic                     := 'X';             -- reset_n
            memory_mem_a                    : out   std_logic_vector(14 downto 0);                    -- mem_a
            memory_mem_ba                   : out   std_logic_vector(2 downto 0);                     -- mem_ba
            memory_mem_ck                   : out   std_logic;                                        -- mem_ck
            memory_mem_ck_n                 : out   std_logic;                                        -- mem_ck_n
            memory_mem_cke                  : out   std_logic;                                        -- mem_cke
            memory_mem_cs_n                 : out   std_logic;                                        -- mem_cs_n
            memory_mem_ras_n                : out   std_logic;                                        -- mem_ras_n
            memory_mem_cas_n                : out   std_logic;                                        -- mem_cas_n
            memory_mem_we_n                 : out   std_logic;                                        -- mem_we_n
            memory_mem_reset_n              : out   std_logic;                                        -- mem_reset_n
            memory_mem_dq                   : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
            memory_mem_dqs                  : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
            memory_mem_dqs_n                : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
            memory_mem_odt                  : out   std_logic;                                        -- mem_odt
            memory_mem_dm                   : out   std_logic_vector(3 downto 0);                     -- mem_dm
            memory_oct_rzqin                : in    std_logic                     := 'X';             -- oct_rzqin
            hps_0_h2f_reset_reset_n         : out   std_logic;                                        -- reset_n
            led_external_connection_export  : out   std_logic_vector(4 downto 0);                     -- export
            sw_external_connection_export   : in    std_logic_vector(4 downto 0)  := (others => 'X'); -- export
            hps_io_hps_io_emac1_inst_TX_CLK : out   std_logic;                                        -- hps_io_emac1_inst_TX_CLK
            hps_io_hps_io_emac1_inst_TXD0   : out   std_logic;                                        -- hps_io_emac1_inst_TXD0
            hps_io_hps_io_emac1_inst_TXD1   : out   std_logic;                                        -- hps_io_emac1_inst_TXD1
            hps_io_hps_io_emac1_inst_TXD2   : out   std_logic;                                        -- hps_io_emac1_inst_TXD2
            hps_io_hps_io_emac1_inst_TXD3   : out   std_logic;                                        -- hps_io_emac1_inst_TXD3
            hps_io_hps_io_emac1_inst_RXD0   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD0
            hps_io_hps_io_emac1_inst_MDIO   : inout std_logic                     := 'X';             -- hps_io_emac1_inst_MDIO
            hps_io_hps_io_emac1_inst_MDC    : out   std_logic;                                        -- hps_io_emac1_inst_MDC
            hps_io_hps_io_emac1_inst_RX_CTL : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CTL
            hps_io_hps_io_emac1_inst_TX_CTL : out   std_logic;                                        -- hps_io_emac1_inst_TX_CTL
            hps_io_hps_io_emac1_inst_RX_CLK : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CLK
            hps_io_hps_io_emac1_inst_RXD1   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD1
            hps_io_hps_io_emac1_inst_RXD2   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD2
            hps_io_hps_io_emac1_inst_RXD3   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD3
            hps_io_hps_io_sdio_inst_CMD     : inout std_logic                     := 'X';             -- hps_io_sdio_inst_CMD
            hps_io_hps_io_sdio_inst_D0      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D0
            hps_io_hps_io_sdio_inst_D1      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D1
            hps_io_hps_io_sdio_inst_CLK     : out   std_logic;                                        -- hps_io_sdio_inst_CLK
            hps_io_hps_io_sdio_inst_D2      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D2
            hps_io_hps_io_sdio_inst_D3      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D3
            hps_io_hps_io_usb1_inst_D0      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D0
            hps_io_hps_io_usb1_inst_D1      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D1
            hps_io_hps_io_usb1_inst_D2      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D2
            hps_io_hps_io_usb1_inst_D3      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D3
            hps_io_hps_io_usb1_inst_D4      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D4
            hps_io_hps_io_usb1_inst_D5      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D5
            hps_io_hps_io_usb1_inst_D6      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D6
            hps_io_hps_io_usb1_inst_D7      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D7
            hps_io_hps_io_usb1_inst_CLK     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_CLK
            hps_io_hps_io_usb1_inst_STP     : out   std_logic;                                        -- hps_io_usb1_inst_STP
            hps_io_hps_io_usb1_inst_DIR     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_DIR
            hps_io_hps_io_usb1_inst_NXT     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_NXT
            hps_io_hps_io_uart0_inst_RX     : in    std_logic                     := 'X';             -- hps_io_uart0_inst_RX
            hps_io_hps_io_uart0_inst_TX     : out   std_logic;                                         -- hps_io_uart0_inst_TX
            input_ma1_external_connection_export  : out   std_logic_vector(22 downto 0);                     -- export
            output_ma1_external_connection_export : in    std_logic_vector(18 downto 0)  := (others => 'X')  -- export
				);
    end component hps_fpga;

component system_w_scan is 
                 port ( 
                       CLK: in std_logic;
                       TRI_E: in std_logic;
                       SCAN_ENABLE: in std_logic;
                       TEST_DATA: in std_logic_vector(15 downto 0);
                       SIPO_OUT: out std_logic_vector(15 downto 0);
                       SIGNAL_A: in std_logic;
                       SIGNAL_B: in std_logic;
                       SIGNAL_C: in std_logic;
                       SIGNAL_D: in std_logic;
                       SIGNAL_Y0: out std_logic;
                       SIGNAL_Y1: out std_logic;
                       CTRL_FB: out std_logic;
							  SIPO_CLEAR: in std_logic
                       );
				end component system_w_scan;
	 
SIGNAL HPS_H2F_RST:STD_LOGIC;
	
BEGIN

u1 : component system_w_scan port map ( 
                        CLK => CLOCK_50,
                        TRI_E=> GPIO_0(0) ,
                        SCAN_ENABLE => GPIO_0(1),
                        TEST_DATA => GPIO_0(21 downto 6),
                        SIPO_OUT => GPIO_1(18 downto 3),
                        SIGNAL_A => GPIO_0(2),
                        SIGNAL_B => GPIO_0(3),
                        SIGNAL_C => GPIO_0(4),
                        SIGNAL_D => GPIO_0(5),
                        SIGNAL_Y0 => GPIO_1(0),
                        SIGNAL_Y1 => GPIO_1(1),
                        CTRL_FB => GPIO_1(2),
								SIPO_CLEAR => GPIO_0(22)
                       ); 


										
										
u0 : component hps_fpga
        port map (
            clk_clk                         => CLOCK_50,                         --                     clk.clk
            reset_reset_n                   => '1',                   --                   reset.reset_n
            memory_mem_a                    => HPS_DDR3_ADDR,                    --                  memory.mem_a
            memory_mem_ba                   => HPS_DDR3_BA,                   --                        .mem_ba
            memory_mem_ck                   => HPS_DDR3_CK_P,                   --                        .mem_ck
            memory_mem_ck_n                 => HPS_DDR3_CK_N,                 --                        .mem_ck_n
            memory_mem_cke                  => HPS_DDR3_CKE,                  --                        .mem_cke
            memory_mem_cs_n                 => HPS_DDR3_CS_N,                 --                        .mem_cs_n
            memory_mem_ras_n                => HPS_DDR3_RAS_N,                --                        .mem_ras_n
            memory_mem_cas_n                => HPS_DDR3_CAS_N,                --                        .mem_cas_n
            memory_mem_we_n                 => HPS_DDR3_WE_N,                 --                        .mem_we_n
            memory_mem_reset_n              => HPS_DDR3_RESET_N,              --                        .mem_reset_n
            memory_mem_dq                   => HPS_DDR3_DQ,                   --                        .mem_dq
            memory_mem_dqs                  => HPS_DDR3_DQS_P,                  --                        .mem_dqs
            memory_mem_dqs_n                => HPS_DDR3_DQS_N,                --                        .mem_dqs_n
            memory_mem_odt                  => HPS_DDR3_ODT,                  --                        .mem_odt
            memory_mem_dm                   => HPS_DDR3_DM,                   --                        .mem_dm
            memory_oct_rzqin                => HPS_DDR3_RZQ,                --                        .oct_rzqin
            hps_0_h2f_reset_reset_n         => HPS_H2F_RST,         --         hps_0_h2f_reset.reset_n
            led_external_connection_export  => LEDR,  -- led_external_connection.export
            sw_external_connection_export   => SW,   --  sw_external_connection.export
            hps_io_hps_io_emac1_inst_TX_CLK => HPS_ENET_GTX_CLK, --                  hps_io.hps_io_emac1_inst_TX_CLK
            hps_io_hps_io_emac1_inst_TXD0   => HPS_ENET_TX_DATA(0),   --                        .hps_io_emac1_inst_TXD0
            hps_io_hps_io_emac1_inst_TXD1   => HPS_ENET_TX_DATA(1),   --                        .hps_io_emac1_inst_TXD1
            hps_io_hps_io_emac1_inst_TXD2   => HPS_ENET_TX_DATA(2),   --                        .hps_io_emac1_inst_TXD2
            hps_io_hps_io_emac1_inst_TXD3   => HPS_ENET_TX_DATA(3),   --                        .hps_io_emac1_inst_TXD3
            hps_io_hps_io_emac1_inst_RXD0   => HPS_ENET_RX_DATA(0),   --                        .hps_io_emac1_inst_RXD0
            hps_io_hps_io_emac1_inst_MDIO   => HPS_ENET_MDIO,   --                        .hps_io_emac1_inst_MDIO
            hps_io_hps_io_emac1_inst_MDC    => HPS_ENET_MDC,    --                        .hps_io_emac1_inst_MDC
            hps_io_hps_io_emac1_inst_RX_CTL => HPS_ENET_RX_DV, --                        .hps_io_emac1_inst_RX_CTL
            hps_io_hps_io_emac1_inst_TX_CTL => HPS_ENET_TX_EN, --                        .hps_io_emac1_inst_TX_CTL
            hps_io_hps_io_emac1_inst_RX_CLK => HPS_ENET_RX_CLK, --                        .hps_io_emac1_inst_RX_CLK
            hps_io_hps_io_emac1_inst_RXD1   => HPS_ENET_RX_DATA(1),   --                        .hps_io_emac1_inst_RXD1
            hps_io_hps_io_emac1_inst_RXD2   => HPS_ENET_RX_DATA(2),   --                        .hps_io_emac1_inst_RXD2
            hps_io_hps_io_emac1_inst_RXD3   => HPS_ENET_RX_DATA(3),   --                        .hps_io_emac1_inst_RXD3
            hps_io_hps_io_sdio_inst_CMD     => HPS_SD_CMD,     --                        .hps_io_sdio_inst_CMD
            hps_io_hps_io_sdio_inst_D0      => HPS_SD_DATA(0),      --                        .hps_io_sdio_inst_D0
            hps_io_hps_io_sdio_inst_D1      => HPS_SD_DATA(1),      --                        .hps_io_sdio_inst_D1
            hps_io_hps_io_sdio_inst_CLK     => HPS_SD_CLK,     --                        .hps_io_sdio_inst_CLK
            hps_io_hps_io_sdio_inst_D2      => HPS_SD_DATA(2),      --                        .hps_io_sdio_inst_D2
            hps_io_hps_io_sdio_inst_D3      => HPS_SD_DATA(3),      --                        .hps_io_sdio_inst_D3
            hps_io_hps_io_usb1_inst_D0      => HPS_USB_DATA(0),      --                        .hps_io_usb1_inst_D0
            hps_io_hps_io_usb1_inst_D1      => HPS_USB_DATA(1),      --                        .hps_io_usb1_inst_D1
            hps_io_hps_io_usb1_inst_D2      => HPS_USB_DATA(2),      --                        .hps_io_usb1_inst_D2
            hps_io_hps_io_usb1_inst_D3      => HPS_USB_DATA(3),      --                        .hps_io_usb1_inst_D3
            hps_io_hps_io_usb1_inst_D4      => HPS_USB_DATA(4),      --                        .hps_io_usb1_inst_D4
            hps_io_hps_io_usb1_inst_D5      => HPS_USB_DATA(5),      --                        .hps_io_usb1_inst_D5
            hps_io_hps_io_usb1_inst_D6      => HPS_USB_DATA(6),      --                        .hps_io_usb1_inst_D6
            hps_io_hps_io_usb1_inst_D7      => HPS_USB_DATA(7),      --                        .hps_io_usb1_inst_D7
            hps_io_hps_io_usb1_inst_CLK     => HPS_USB_CLKOUT,     --                        .hps_io_usb1_inst_CLK
            hps_io_hps_io_usb1_inst_STP     => HPS_USB_STP,     --                        .hps_io_usb1_inst_STP
            hps_io_hps_io_usb1_inst_DIR     => HPS_USB_DIR,     --                        .hps_io_usb1_inst_DIR
            hps_io_hps_io_usb1_inst_NXT     => HPS_USB_NXT,     --                        .hps_io_usb1_inst_NXT
            hps_io_hps_io_uart0_inst_RX     => HPS_UART_RX,     --                        .hps_io_uart0_inst_RX
            hps_io_hps_io_uart0_inst_TX     => HPS_UART_TX,      --                        .hps_io_uart0_inst_TX
				input_ma1_external_connection_export  => GPIO_0,  --  input_ma1_external_connection.export
            output_ma1_external_connection_export => GPIO_1  -- output_ma1_external_connection.export
		  
		  );

END MAIN;