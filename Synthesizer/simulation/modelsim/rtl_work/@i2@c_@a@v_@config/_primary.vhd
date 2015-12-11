library verilog;
use verilog.vl_types.all;
entity I2C_AV_Config is
    generic(
        CLK_Freq        : integer := 50000000;
        I2C_Freq        : integer := 20000;
        LUT_SIZE        : integer := 13;
        Dummy_DATA      : integer := 0;
        SET_LIN_L       : integer := 1;
        SET_LIN_R       : integer := 2;
        SET_HEAD_L      : integer := 3;
        SET_HEAD_R      : integer := 4;
        A_PATH_CTRL     : integer := 5;
        D_PATH_CTRL     : integer := 6;
        POWER_ON        : integer := 7;
        SET_FORMAT      : integer := 8;
        SAMPLE_CTRL     : integer := 9;
        SET_ACTIVE      : integer := 10;
        SET_VIDEO       : integer := 11
    );
    port(
        iCLK            : in     vl_logic;
        iRST_N          : in     vl_logic;
        I2C_SCLK        : out    vl_logic;
        I2C_SDAT        : inout  vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of CLK_Freq : constant is 1;
    attribute mti_svvh_generic_type of I2C_Freq : constant is 1;
    attribute mti_svvh_generic_type of LUT_SIZE : constant is 1;
    attribute mti_svvh_generic_type of Dummy_DATA : constant is 1;
    attribute mti_svvh_generic_type of SET_LIN_L : constant is 1;
    attribute mti_svvh_generic_type of SET_LIN_R : constant is 1;
    attribute mti_svvh_generic_type of SET_HEAD_L : constant is 1;
    attribute mti_svvh_generic_type of SET_HEAD_R : constant is 1;
    attribute mti_svvh_generic_type of A_PATH_CTRL : constant is 1;
    attribute mti_svvh_generic_type of D_PATH_CTRL : constant is 1;
    attribute mti_svvh_generic_type of POWER_ON : constant is 1;
    attribute mti_svvh_generic_type of SET_FORMAT : constant is 1;
    attribute mti_svvh_generic_type of SAMPLE_CTRL : constant is 1;
    attribute mti_svvh_generic_type of SET_ACTIVE : constant is 1;
    attribute mti_svvh_generic_type of SET_VIDEO : constant is 1;
end I2C_AV_Config;
