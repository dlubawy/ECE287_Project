library verilog;
use verilog.vl_types.all;
entity I2C_Controller is
    port(
        CLOCK           : in     vl_logic;
        I2C_SCLK        : out    vl_logic;
        I2C_SDAT        : inout  vl_logic;
        I2C_DATA        : in     vl_logic_vector(23 downto 0);
        GO              : in     vl_logic;
        \END\           : out    vl_logic;
        W_R             : in     vl_logic;
        ACK             : out    vl_logic;
        RESET           : in     vl_logic;
        SD_COUNTER      : out    vl_logic_vector(5 downto 0);
        SDO             : out    vl_logic
    );
end I2C_Controller;
