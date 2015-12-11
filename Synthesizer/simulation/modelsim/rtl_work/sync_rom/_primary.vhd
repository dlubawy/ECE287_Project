library verilog;
use verilog.vl_types.all;
entity sync_rom is
    port(
        clock           : in     vl_logic;
        address         : in     vl_logic_vector(7 downto 0);
        sine            : out    vl_logic_vector(15 downto 0)
    );
end sync_rom;
