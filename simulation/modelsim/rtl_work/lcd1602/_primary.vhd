library verilog;
use verilog.vl_types.all;
entity lcd1602 is
    generic(
        setDisplay      : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi1, Hi1, Hi1, Hi0, Hi0, Hi0);
        openDisplay     : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi1, Hi1, Hi1, Hi1, Hi0, Hi0);
        setClearScreen  : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1);
        setCursor       : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0)
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        lcd_rs          : out    vl_logic;
        lcd_en          : out    vl_logic;
        lcd_rw          : out    vl_logic;
        lcd_data        : out    vl_logic_vector(7 downto 0);
        data0           : in     vl_logic_vector(7 downto 0);
        data1           : in     vl_logic_vector(7 downto 0);
        data2           : in     vl_logic_vector(7 downto 0);
        data3           : in     vl_logic_vector(7 downto 0);
        data4           : in     vl_logic_vector(7 downto 0);
        data5           : in     vl_logic_vector(7 downto 0);
        data6           : in     vl_logic_vector(7 downto 0);
        data7           : in     vl_logic_vector(7 downto 0);
        data8           : in     vl_logic_vector(7 downto 0);
        data9           : in     vl_logic_vector(7 downto 0);
        data10          : in     vl_logic_vector(7 downto 0);
        data11          : in     vl_logic_vector(7 downto 0);
        data12          : in     vl_logic_vector(7 downto 0);
        data13          : in     vl_logic_vector(7 downto 0);
        data14          : in     vl_logic_vector(7 downto 0);
        data15          : in     vl_logic_vector(7 downto 0);
        data16          : in     vl_logic_vector(7 downto 0);
        data17          : in     vl_logic_vector(7 downto 0);
        data18          : in     vl_logic_vector(7 downto 0);
        data19          : in     vl_logic_vector(7 downto 0);
        data20          : in     vl_logic_vector(7 downto 0);
        data21          : in     vl_logic_vector(7 downto 0);
        data22          : in     vl_logic_vector(7 downto 0);
        data23          : in     vl_logic_vector(7 downto 0);
        data24          : in     vl_logic_vector(7 downto 0);
        data25          : in     vl_logic_vector(7 downto 0);
        data26          : in     vl_logic_vector(7 downto 0);
        data27          : in     vl_logic_vector(7 downto 0);
        data28          : in     vl_logic_vector(7 downto 0);
        data29          : in     vl_logic_vector(7 downto 0);
        data30          : in     vl_logic_vector(7 downto 0);
        data31          : in     vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of setDisplay : constant is 1;
    attribute mti_svvh_generic_type of openDisplay : constant is 1;
    attribute mti_svvh_generic_type of setClearScreen : constant is 1;
    attribute mti_svvh_generic_type of setCursor : constant is 1;
end lcd1602;
