// --------------------------------------------------------------------
// --------------------------------------------------------------------
//
// DDS eaxmple code
// Switches set the frequency, use SW as a binary number
// DDS F = (SW*(2^14))*(audio clock rate)/(2^32) = SW*(audio clock rate)*(2^-18)
// As configured here SW*46000*(2^-18)
//
// The sine ROM generator program is appended as a comment
//
// Edit: This code will be used as a starting point for making a synthesizer.
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
// Bruce R Land, Cornell University, April 2014
// --------------------------------------------------------------------
// Andrew Lubawy, Miami University, December 2015
// --------------------------------------------------------------------

module sine_wave (
    // Clock Input
    input         CLOCK2_50,    // 27 MHz
    input         CLOCK_50,    // 50 MHz
    input         EXT_CLOCK,   // External Clock
    // Push Button
    input  [3:0]  KEY,         // Pushbutton[3:0]
    // DPDT Switch
    input  [17:0] SW,          // Toggle Switch[17:0]
    // 7-SEG Display
    output [6:0]  HEX0,        // Seven Segment Digit 0
    output [6:0]  HEX1,        // Seven Segment Digit 1
    output [6:0]  HEX2,        // Seven Segment Digit 2
    output [6:0]  HEX3,        // Seven Segment Digit 3
    output [6:0]  HEX4,        // Seven Segment Digit 4
    output [6:0]  HEX5,        // Seven Segment Digit 5
    output [6:0]  HEX6,        // Seven Segment Digit 6
    output [6:0]  HEX7,        // Seven Segment Digit 7
    // LED
    output [8:0]  LEDG,        // LED Green[8:0]
    output [17:0] LEDR,        // LED Red[17:0]
    // UART
    output        UART_TXD,    // UART Transmitter
    input         UART_RXD,    // UART Receiver
    // IRDA
    output        IRDA_TXD,    // IRDA Transmitter
    input         IRDA_RXD,    // IRDA Receiver
    // SDRAM Interface
    inout  [15:0] DRAM_DQ,     // SDRAM Data bus 16 Bits
    output [11:0] DRAM_ADDR,   // SDRAM Address bus 12 Bits
    output        DRAM_LDQM,   // SDRAM Low-byte Data Mask 
    output        DRAM_UDQM,   // SDRAM High-byte Data Mask
    output        DRAM_WE_N,   // SDRAM Write Enable
    output        DRAM_CAS_N,  // SDRAM Column Address Strobe
    output        DRAM_RAS_N,  // SDRAM Row Address Strobe
    output        DRAM_CS_N,   // SDRAM Chip Select
    output        DRAM_BA_0,   // SDRAM Bank Address 0
    output        DRAM_BA_1,   // SDRAM Bank Address 0
    output        DRAM_CLK,    // SDRAM Clock
    output        DRAM_CKE,    // SDRAM Clock Enable
    // Flash Interface
    inout  [7:0]  FL_DQ,       // FLASH Data bus 8 Bits
    output [21:0] FL_ADDR,     // FLASH Address bus 22 Bits
    output        FL_WE_N,     // FLASH Write Enable
    output        FL_RST_N,    // FLASH Reset
    output        FL_OE_N,     // FLASH Output Enable
    output        FL_CE_N,     // FLASH Chip Enable
    // SRAM Interface
    inout  [15:0] SRAM_DQ,     // SRAM Data bus 16 Bits
    output [17:0] SRAM_ADDR,   // SRAM Address bus 18 Bits
    output        SRAM_UB_N,   // SRAM High-byte Data Mask 
    output        SRAM_LB_N,   // SRAM Low-byte Data Mask 
    output        SRAM_WE_N,   // SRAM Write Enable
    output        SRAM_CE_N,   // SRAM Chip Enable
    output        SRAM_OE_N,   // SRAM Output Enable
    // ISP1362 Interface
    inout  [15:0] OTG_DATA,    // ISP1362 Data bus 16 Bits
    output [1:0]  OTG_ADDR,    // ISP1362 Address 2 Bits
    output        OTG_CS_N,    // ISP1362 Chip Select
    output        OTG_RD_N,    // ISP1362 Write
    output        OTG_WR_N,    // ISP1362 Read
    output        OTG_RST_N,   // ISP1362 Reset
    output        OTG_FSPEED,  // USB Full Speed, 0 = Enable, Z = Disable
    output        OTG_LSPEED,  // USB Low Speed,  0 = Enable, Z = Disable
    input         OTG_INT0,    // ISP1362 Interrupt 0
    input         OTG_INT1,    // ISP1362 Interrupt 1
    input         OTG_DREQ0,   // ISP1362 DMA Request 0
    input         OTG_DREQ1,   // ISP1362 DMA Request 1
    output        OTG_DACK0_N, // ISP1362 DMA Acknowledge 0
    output        OTG_DACK1_N, // ISP1362 DMA Acknowledge 1
    // LCD Module 16X2
    inout  [7:0]  LCD_DATA,    // LCD Data bus 8 bits
    output        LCD_ON,      // LCD Power ON/OFF
    output        LCD_BLON,    // LCD Back Light ON/OFF
    output        LCD_RW,      // LCD Read/Write Select, 0 = Write, 1 = Read
    output        LCD_EN,      // LCD Enable
    output        LCD_RS,      // LCD Command/Data Select, 0 = Command, 1 = Data
    // SD Card Interface
    inout         SD_DAT,      // SD Card Data
    inout         SD_DAT3,     // SD Card Data 3
    inout         SD_CMD,      // SD Card Command Signal
    output        SD_CLK,      // SD Card Clock
    // I2C
    inout         I2C_SDAT,    // I2C Data
    output        I2C_SCLK,    // I2C Clock
    // PS2
    input         PS2_DAT,     // PS2 Data
    input         PS2_CLK,     // PS2 Clock
    // USB JTAG link
    input         TDI,         // CPLD -> FPGA (data in)
    input         TCK,         // CPLD -> FPGA (clk)
    input         TCS,         // CPLD -> FPGA (CS)
    output        TDO,         // FPGA -> CPLD (data out)
    // VGA
    output        VGA_CLK,     // VGA Clock
    output        VGA_HS,      // VGA H_SYNC
    output        VGA_VS,      // VGA V_SYNC
    output        VGA_BLANK,   // VGA BLANK
    output        VGA_SYNC,    // VGA SYNC
    output [9:0]  VGA_R,       // VGA Red[9:0]
    output [9:0]  VGA_G,       // VGA Green[9:0]
    output [9:0]  VGA_B,       // VGA Blue[9:0]
    // Ethernet Interface
    inout  [15:0] ENET_DATA,   // DM9000A DATA bus 16Bits
    output        ENET_CMD,    // DM9000A Command/Data Select, 0 = Command, 1 = Data
    output        ENET_CS_N,   // DM9000A Chip Select
    output        ENET_WR_N,   // DM9000A Write
    output        ENET_RD_N,   // DM9000A Read
    output        ENET_RST_N,  // DM9000A Reset
    input         ENET_INT,    // DM9000A Interrupt
    output        ENET_CLK,    // DM9000A Clock 25 MHz
    // Audio CODEC
    inout         AUD_ADCLRCK, // Audio CODEC ADC LR Clock
    input         AUD_ADCDAT,  // Audio CODEC ADC Data
    inout         AUD_DACLRCK, // Audio CODEC DAC LR Clock
    output        AUD_DACDAT,  // Audio CODEC DAC Data
    inout         AUD_BCLK,    // Audio CODEC Bit-Stream Clock
    output        AUD_XCK,     // Audio CODEC Chip Clock
    // TV Decoder
    input  [7:0]  TD_DATA,     // TV Decoder Data bus 8 bits
    input         TD_HS,       // TV Decoder H_SYNC
    input         TD_VS,       // TV Decoder V_SYNC
    output        TD_RESET,    // TV Decoder Reset
    // GPIO
    inout  [35:0] GPIO_0,      // GPIO Connection 0
    inout  [35:0] GPIO_1       // GPIO Connection 1
);

   //Turn off all displays.
   assign HEX0 = 7'h7F;
   assign HEX1 = 7'h7F;
   assign HEX2 = 7'h7F;
   assign HEX3 = 7'h7F;
   assign HEX4 = 7'h7F;
   assign HEX5 = 7'h7F;
   assign HEX6 = 7'h7F;
   assign HEX7 = 7'h7F;
   //assign LEDR = 18'h0;
   assign LEDG = 9'h0;
   
   //Set all GPIO to tri-state.
   assign GPIO_0 = 36'hzzzzzzzzz;
   assign GPIO_1 = 36'hzzzzzzzzz;

   //Disable audio codec.
   //assign AUD_DACDAT = 1'b0;
   //assign AUD_XCK    = 1'b0;

   //Disable DRAM.
   assign DRAM_ADDR  = 12'h0;
   assign DRAM_BA_0  = 1'b0;
   assign DRAM_BA_1  = 1'b0;
   assign DRAM_CAS_N = 1'b1;
   assign DRAM_CKE   = 1'b0;
   assign DRAM_CLK   = 1'b0;
   assign DRAM_CS_N  = 1'b1;
   assign DRAM_DQ    = 16'hzzzz;
   assign DRAM_LDQM  = 1'b0;
   assign DRAM_RAS_N = 1'b1;
   assign DRAM_UDQM  = 1'b0;
   assign DRAM_WE_N  = 1'b1;

   //Disable Ethernet.
   assign ENET_CLK   = 1'b0;
   assign ENET_CS_N  = 1'b1;
   assign ENET_CMD   = 1'b0;
   assign ENET_DATA  = 16'hzzzz;
   assign ENET_RD_N  = 1'b1;
   assign ENET_RST_N = 1'b1;
   assign ENET_WR_N  = 1'b1;

   //Disable flash.
   assign FL_ADDR  = 22'h0;
   assign FL_CE_N  = 1'b1;
   assign FL_DQ    = 8'hzz;
   assign FL_OE_N  = 1'b1;
   assign FL_RST_N = 1'b1;
   assign FL_WE_N  = 1'b1;

   //Disable LCD.
   assign LCD_BLON = 1'b0;
   assign LCD_DATA = 8'hzz;
   assign LCD_EN   = 1'b0;
   assign LCD_ON   = 1'b0;
   assign LCD_RS   = 1'b0;
   assign LCD_RW   = 1'b0;

   //Disable OTG.
   assign OTG_ADDR    = 2'h0;
   assign OTG_CS_N    = 1'b1;
   assign OTG_DACK0_N = 1'b1;
   assign OTG_DACK1_N = 1'b1;
   assign OTG_FSPEED  = 1'b1;
   assign OTG_DATA    = 16'hzzzz;
   assign OTG_LSPEED  = 1'b1;
   assign OTG_RD_N    = 1'b1;
   assign OTG_RST_N   = 1'b1;
   assign OTG_WR_N    = 1'b1;

   //Disable SDRAM.
   assign SD_DAT = 1'bz;
   assign SD_CLK = 1'b0;

   //Disable SRAM.
   assign SRAM_ADDR = 18'h0;
   assign SRAM_CE_N = 1'b1;
   assign SRAM_DQ   = 16'hzzzz;
   assign SRAM_LB_N = 1'b1;
   assign SRAM_OE_N = 1'b1;
   assign SRAM_UB_N = 1'b1;
   assign SRAM_WE_N = 1'b1;

   //Disable VGA.
   //assign VGA_CLK   = 1'b0;
   assign VGA_BLANK = 1'b0;
   assign VGA_SYNC  = 1'b0;
   assign VGA_HS    = 1'b0;
   assign VGA_VS    = 1'b0;
   assign VGA_R     = 10'h0;
   assign VGA_G     = 10'h0;
   assign VGA_B     = 10'h0;

   //Disable all other peripherals.
   //assign I2C_SCLK = 1'b0;
   assign IRDA_TXD = 1'b0;
   //assign TD_RESET = 1'b0;
   assign TDO = 1'b0;
   assign UART_TXD = 1'b0;
   

wire	VGA_CTRL_CLK;
wire	AUD_CTRL_CLK;
wire	DLY_RST;

assign	TD_RESET	=	1'b1;	//	Allow 27 MHz
assign	AUD_ADCLRCK	=	AUD_DACLRCK;
assign	AUD_XCK		=	AUD_CTRL_CLK;

Reset_Delay			r0	(	.iCLK(CLOCK_50),.oRESET(DLY_RST)	);

VGA_Audio_PLL 		p1	(	.areset(~DLY_RST),.inclk0(CLOCK2_50),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(VGA_CLK)	);

I2C_AV_Config 		u3	(	//	Host Side
							.iCLK(CLOCK_50),
							.iRST_N(KEY[0]),
							//	I2C Side
							.I2C_SCLK(I2C_SCLK),
							.I2C_SDAT(I2C_SDAT)	);

AUDIO_DAC_ADC 			u4	(	//	Audio Side
							.oAUD_BCK(AUD_BCLK),
							.oAUD_DATA(AUD_DACDAT),
							.oAUD_LRCK(AUD_DACLRCK),
							.oAUD_inL(audio_inL), // audio data from ADC 
							.oAUD_inR(audio_inR), // audio data from ADC 
							.iAUD_ADCDAT(AUD_ADCDAT),
							.iAUD_extL(audio_outL), // audio data to DAC
							.iAUD_extR(audio_outR), // audio data to DAC
							//	Control Signals
				         .iCLK_18_4(AUD_CTRL_CLK),
							.iRST_N(DLY_RST)
							);

/// audio stuff /////////////////////////////////////////////////
// The data for the DACs
wire signed [15:0] audio_outL, audio_outR ;

// DDS sine wave generator
// for two phase-locked outputs
reg [31:0]	DDS_accum, DDS_incr;
wire signed [15:0] sine_out, sine_out_90;

// output two sine waves in quadrature
assign audio_outR = sine_out;
assign audio_outL = sine_out_90;

// DDS accumulator at audio rate
always@(posedge AUD_DACLRCK) begin
	// generate variable frequency
	// DDS F = (SW*2^14)*(audio clock rate)/(2^32)
	// 
	DDS_accum = DDS_accum + {SW[17:0], 14'b0} ;
end

//hook up the ROM table for sine generation
sync_rom sineTable(CLOCK_50, DDS_accum[31:24], sine_out);
//hook up the ROM table for 90 degrees phase shift (64/256)
sync_rom sineTable_90(CLOCK_50, DDS_accum[31:24]+8'd64, sine_out_90);

endmodule

//////////////////////////////////////////////////
////////////	Sin Wave ROM Table	//////////////
//////////////////////////////////////////////////
// produces a 2's comp, 16-bit, approximation
// of a sine wave, given an input phase (address)
module sync_rom (clock, address, sine);
input clock;
input [7:0] address;
output [15:0] sine;
reg signed [15:0] sine;
always@(posedge clock)
begin
    case(address)
    		8'h00: sine = 16'h0000 ;
			8'h01: sine = 16'h0192 ;
			8'h02: sine = 16'h0323 ;
			8'h03: sine = 16'h04b5 ;
			8'h04: sine = 16'h0645 ;
			8'h05: sine = 16'h07d5 ;
			8'h06: sine = 16'h0963 ;
			8'h07: sine = 16'h0af0 ;
			8'h08: sine = 16'h0c7c ;
			8'h09: sine = 16'h0e05 ;
			8'h0a: sine = 16'h0f8c ;
			8'h0b: sine = 16'h1111 ;
			8'h0c: sine = 16'h1293 ;
			8'h0d: sine = 16'h1413 ;
			8'h0e: sine = 16'h158f ;
			8'h0f: sine = 16'h1708 ;
			8'h10: sine = 16'h187d ;
			8'h11: sine = 16'h19ef ;
			8'h12: sine = 16'h1b5c ;
			8'h13: sine = 16'h1cc5 ;
			8'h14: sine = 16'h1e2a ;
			8'h15: sine = 16'h1f8b ;
			8'h16: sine = 16'h20e6 ;
			8'h17: sine = 16'h223c ;
			8'h18: sine = 16'h238d ;
			8'h19: sine = 16'h24d9 ;
			8'h1a: sine = 16'h261f ;
			8'h1b: sine = 16'h275f ;
			8'h1c: sine = 16'h2899 ;
			8'h1d: sine = 16'h29cc ;
			8'h1e: sine = 16'h2afa ;
			8'h1f: sine = 16'h2c20 ;
			8'h20: sine = 16'h2d40 ;
			8'h21: sine = 16'h2e59 ;
			8'h22: sine = 16'h2f6b ;
			8'h23: sine = 16'h3075 ;
			8'h24: sine = 16'h3178 ;
			8'h25: sine = 16'h3273 ;
			8'h26: sine = 16'h3366 ;
			8'h27: sine = 16'h3452 ;
			8'h28: sine = 16'h3535 ;
			8'h29: sine = 16'h3611 ;
			8'h2a: sine = 16'h36e4 ;
			8'h2b: sine = 16'h37ae ;
			8'h2c: sine = 16'h3870 ;
			8'h2d: sine = 16'h3929 ;
			8'h2e: sine = 16'h39da ;
			8'h2f: sine = 16'h3a81 ;
			8'h30: sine = 16'h3b1f ;
			8'h31: sine = 16'h3bb5 ;
			8'h32: sine = 16'h3c41 ;
			8'h33: sine = 16'h3cc4 ;
			8'h34: sine = 16'h3d3d ;
			8'h35: sine = 16'h3dad ;
			8'h36: sine = 16'h3e14 ;
			8'h37: sine = 16'h3e70 ;
			8'h38: sine = 16'h3ec4 ;
			8'h39: sine = 16'h3f0d ;
			8'h3a: sine = 16'h3f4d ;
			8'h3b: sine = 16'h3f83 ;
			8'h3c: sine = 16'h3fb0 ;
			8'h3d: sine = 16'h3fd2 ;
			8'h3e: sine = 16'h3feb ;
			8'h3f: sine = 16'h3ffa ;
			8'h40: sine = 16'h3fff ;
			8'h41: sine = 16'h3ffa ;
			8'h42: sine = 16'h3feb ;
			8'h43: sine = 16'h3fd2 ;
			8'h44: sine = 16'h3fb0 ;
			8'h45: sine = 16'h3f83 ;
			8'h46: sine = 16'h3f4d ;
			8'h47: sine = 16'h3f0d ;
			8'h48: sine = 16'h3ec4 ;
			8'h49: sine = 16'h3e70 ;
			8'h4a: sine = 16'h3e14 ;
			8'h4b: sine = 16'h3dad ;
			8'h4c: sine = 16'h3d3d ;
			8'h4d: sine = 16'h3cc4 ;
			8'h4e: sine = 16'h3c41 ;
			8'h4f: sine = 16'h3bb5 ;
			8'h50: sine = 16'h3b1f ;
			8'h51: sine = 16'h3a81 ;
			8'h52: sine = 16'h39da ;
			8'h53: sine = 16'h3929 ;
			8'h54: sine = 16'h3870 ;
			8'h55: sine = 16'h37ae ;
			8'h56: sine = 16'h36e4 ;
			8'h57: sine = 16'h3611 ;
			8'h58: sine = 16'h3535 ;
			8'h59: sine = 16'h3452 ;
			8'h5a: sine = 16'h3366 ;
			8'h5b: sine = 16'h3273 ;
			8'h5c: sine = 16'h3178 ;
			8'h5d: sine = 16'h3075 ;
			8'h5e: sine = 16'h2f6b ;
			8'h5f: sine = 16'h2e59 ;
			8'h60: sine = 16'h2d40 ;
			8'h61: sine = 16'h2c20 ;
			8'h62: sine = 16'h2afa ;
			8'h63: sine = 16'h29cc ;
			8'h64: sine = 16'h2899 ;
			8'h65: sine = 16'h275f ;
			8'h66: sine = 16'h261f ;
			8'h67: sine = 16'h24d9 ;
			8'h68: sine = 16'h238d ;
			8'h69: sine = 16'h223c ;
			8'h6a: sine = 16'h20e6 ;
			8'h6b: sine = 16'h1f8b ;
			8'h6c: sine = 16'h1e2a ;
			8'h6d: sine = 16'h1cc5 ;
			8'h6e: sine = 16'h1b5c ;
			8'h6f: sine = 16'h19ef ;
			8'h70: sine = 16'h187d ;
			8'h71: sine = 16'h1708 ;
			8'h72: sine = 16'h158f ;
			8'h73: sine = 16'h1413 ;
			8'h74: sine = 16'h1293 ;
			8'h75: sine = 16'h1111 ;
			8'h76: sine = 16'h0f8c ;
			8'h77: sine = 16'h0e05 ;
			8'h78: sine = 16'h0c7c ;
			8'h79: sine = 16'h0af0 ;
			8'h7a: sine = 16'h0963 ;
			8'h7b: sine = 16'h07d5 ;
			8'h7c: sine = 16'h0645 ;
			8'h7d: sine = 16'h04b5 ;
			8'h7e: sine = 16'h0323 ;
			8'h7f: sine = 16'h0192 ;
			8'h80: sine = 16'h0000 ;
			8'h81: sine = 16'hfe6e ;
			8'h82: sine = 16'hfcdd ;
			8'h83: sine = 16'hfb4b ;
			8'h84: sine = 16'hf9bb ;
			8'h85: sine = 16'hf82b ;
			8'h86: sine = 16'hf69d ;
			8'h87: sine = 16'hf510 ;
			8'h88: sine = 16'hf384 ;
			8'h89: sine = 16'hf1fb ;
			8'h8a: sine = 16'hf074 ;
			8'h8b: sine = 16'heeef ;
			8'h8c: sine = 16'hed6d ;
			8'h8d: sine = 16'hebed ;
			8'h8e: sine = 16'hea71 ;
			8'h8f: sine = 16'he8f8 ;
			8'h90: sine = 16'he783 ;
			8'h91: sine = 16'he611 ;
			8'h92: sine = 16'he4a4 ;
			8'h93: sine = 16'he33b ;
			8'h94: sine = 16'he1d6 ;
			8'h95: sine = 16'he075 ;
			8'h96: sine = 16'hdf1a ;
			8'h97: sine = 16'hddc4 ;
			8'h98: sine = 16'hdc73 ;
			8'h99: sine = 16'hdb27 ;
			8'h9a: sine = 16'hd9e1 ;
			8'h9b: sine = 16'hd8a1 ;
			8'h9c: sine = 16'hd767 ;
			8'h9d: sine = 16'hd634 ;
			8'h9e: sine = 16'hd506 ;
			8'h9f: sine = 16'hd3e0 ;
			8'ha0: sine = 16'hd2c0 ;
			8'ha1: sine = 16'hd1a7 ;
			8'ha2: sine = 16'hd095 ;
			8'ha3: sine = 16'hcf8b ;
			8'ha4: sine = 16'hce88 ;
			8'ha5: sine = 16'hcd8d ;
			8'ha6: sine = 16'hcc9a ;
			8'ha7: sine = 16'hcbae ;
			8'ha8: sine = 16'hcacb ;
			8'ha9: sine = 16'hc9ef ;
			8'haa: sine = 16'hc91c ;
			8'hab: sine = 16'hc852 ;
			8'hac: sine = 16'hc790 ;
			8'had: sine = 16'hc6d7 ;
			8'hae: sine = 16'hc626 ;
			8'haf: sine = 16'hc57f ;
			8'hb0: sine = 16'hc4e1 ;
			8'hb1: sine = 16'hc44b ;
			8'hb2: sine = 16'hc3bf ;
			8'hb3: sine = 16'hc33c ;
			8'hb4: sine = 16'hc2c3 ;
			8'hb5: sine = 16'hc253 ;
			8'hb6: sine = 16'hc1ec ;
			8'hb7: sine = 16'hc190 ;
			8'hb8: sine = 16'hc13c ;
			8'hb9: sine = 16'hc0f3 ;
			8'hba: sine = 16'hc0b3 ;
			8'hbb: sine = 16'hc07d ;
			8'hbc: sine = 16'hc050 ;
			8'hbd: sine = 16'hc02e ;
			8'hbe: sine = 16'hc015 ;
			8'hbf: sine = 16'hc006 ;
			8'hc0: sine = 16'hc001 ;
			8'hc1: sine = 16'hc006 ;
			8'hc2: sine = 16'hc015 ;
			8'hc3: sine = 16'hc02e ;
			8'hc4: sine = 16'hc050 ;
			8'hc5: sine = 16'hc07d ;
			8'hc6: sine = 16'hc0b3 ;
			8'hc7: sine = 16'hc0f3 ;
			8'hc8: sine = 16'hc13c ;
			8'hc9: sine = 16'hc190 ;
			8'hca: sine = 16'hc1ec ;
			8'hcb: sine = 16'hc253 ;
			8'hcc: sine = 16'hc2c3 ;
			8'hcd: sine = 16'hc33c ;
			8'hce: sine = 16'hc3bf ;
			8'hcf: sine = 16'hc44b ;
			8'hd0: sine = 16'hc4e1 ;
			8'hd1: sine = 16'hc57f ;
			8'hd2: sine = 16'hc626 ;
			8'hd3: sine = 16'hc6d7 ;
			8'hd4: sine = 16'hc790 ;
			8'hd5: sine = 16'hc852 ;
			8'hd6: sine = 16'hc91c ;
			8'hd7: sine = 16'hc9ef ;
			8'hd8: sine = 16'hcacb ;
			8'hd9: sine = 16'hcbae ;
			8'hda: sine = 16'hcc9a ;
			8'hdb: sine = 16'hcd8d ;
			8'hdc: sine = 16'hce88 ;
			8'hdd: sine = 16'hcf8b ;
			8'hde: sine = 16'hd095 ;
			8'hdf: sine = 16'hd1a7 ;
			8'he0: sine = 16'hd2c0 ;
			8'he1: sine = 16'hd3e0 ;
			8'he2: sine = 16'hd506 ;
			8'he3: sine = 16'hd634 ;
			8'he4: sine = 16'hd767 ;
			8'he5: sine = 16'hd8a1 ;
			8'he6: sine = 16'hd9e1 ;
			8'he7: sine = 16'hdb27 ;
			8'he8: sine = 16'hdc73 ;
			8'he9: sine = 16'hddc4 ;
			8'hea: sine = 16'hdf1a ;
			8'heb: sine = 16'he075 ;
			8'hec: sine = 16'he1d6 ;
			8'hed: sine = 16'he33b ;
			8'hee: sine = 16'he4a4 ;
			8'hef: sine = 16'he611 ;
			8'hf0: sine = 16'he783 ;
			8'hf1: sine = 16'he8f8 ;
			8'hf2: sine = 16'hea71 ;
			8'hf3: sine = 16'hebed ;
			8'hf4: sine = 16'hed6d ;
			8'hf5: sine = 16'heeef ;
			8'hf6: sine = 16'hf074 ;
			8'hf7: sine = 16'hf1fb ;
			8'hf8: sine = 16'hf384 ;
			8'hf9: sine = 16'hf510 ;
			8'hfa: sine = 16'hf69d ;
			8'hfb: sine = 16'hf82b ;
			8'hfc: sine = 16'hf9bb ;
			8'hfd: sine = 16'hfb4b ;
			8'hfe: sine = 16'hfcdd ;
			8'hff: sine = 16'hfe6e ;
	endcase
end
endmodule
//////////////////////////////////////////////////
// sine ROM generator in Matlab
/*
x = 1:256;
% Sin : scale to 15-bits 
% 2's complement!
y = fix(((2^14)-1)*sin(2*pi*(x-1)/256)); 
for i=x
    if y(i)<0
        y(i) = 2^16 + y(i);
    end
    fprintf('\t\t\t8''h%02x: sine = 16''h%04x ;\n', x(i)-1 ,y(i))  
end
*/	 
///////////////////////////////////////////////////
// wave generated from wav file of C note need to test
/*
			8'h00: sine = 16'hf006 ;
			8'h01: sine = 16'h215f ;
			8'h02: sine = 16'hf946 ;
			8'h03: sine = 16'hd6d4 ;
			8'h04: sine = 16'h1ac7 ;
			8'h05: sine = 16'h0f4d ;
			8'h06: sine = 16'hf809 ;
			8'h07: sine = 16'he6a1 ;
			8'h08: sine = 16'h0469 ;
			8'h09: sine = 16'h2bd2 ;
			8'h0a: sine = 16'he7fb ;
			8'h0b: sine = 16'hee21 ;
			8'h0c: sine = 16'h0ec1 ;
			8'h0d: sine = 16'hfe5f ;
			8'h0e: sine = 16'h0117 ;
			8'h0f: sine = 16'hee88 ;
			8'h10: sine = 16'h0ec8 ;
			8'h11: sine = 16'h1c2c ;
			8'h12: sine = 16'he097 ;
			8'h13: sine = 16'hf255 ;
			8'h14: sine = 16'h1585 ;
			8'h15: sine = 16'hff5c ;
			8'h16: sine = 16'hff78 ;
			8'h17: sine = 16'hf22c ;
			8'h18: sine = 16'h1348 ;
			8'h19: sine = 16'h03ce ;
			8'h1a: sine = 16'hec01 ;
			8'h1b: sine = 16'hf92f ;
			8'h1c: sine = 16'h16f2 ;
			8'h1d: sine = 16'hffc8 ;
			8'h1e: sine = 16'hf5fc ;
			8'h1f: sine = 16'hfc5d ;
			8'h20: sine = 16'h0d67 ;
			8'h21: sine = 16'h0051 ;
			8'h22: sine = 16'hf126 ;
			8'h23: sine = 16'hfbdd ;
			8'h24: sine = 16'h1409 ;
			8'h25: sine = 16'hfd24 ;
			8'h26: sine = 16'hf7c3 ;
			8'h27: sine = 16'h0023 ;
			8'h28: sine = 16'h088d ;
			8'h29: sine = 16'hff25 ;
			8'h2a: sine = 16'hf14b ;
			8'h2b: sine = 16'h05d5 ;
			8'h2c: sine = 16'h0c70 ;
			8'h2d: sine = 16'hfb66 ;
			8'h2e: sine = 16'hf941 ;
			8'h2f: sine = 16'h0124 ;
			8'h30: sine = 16'h07cd ;
			8'h31: sine = 16'hfbbc ;
			8'h32: sine = 16'hf4aa ;
			8'h33: sine = 16'h0acb ;
			8'h34: sine = 16'h05ab ;
			8'h35: sine = 16'hfbcd ;
			8'h36: sine = 16'hfad6 ;
			8'h37: sine = 16'h0076 ;
			8'h38: sine = 16'h0722 ;
			8'h39: sine = 16'hfaed ;
			8'h3a: sine = 16'hf7ae ;
			8'h3b: sine = 16'h0c5e ;
			8'h3c: sine = 16'h02b8 ;
			8'h3d: sine = 16'hfaf3 ;
			8'h3e: sine = 16'hfbb6 ;
			8'h3f: sine = 16'h0267 ;
			8'h40: sine = 16'h05ee ;
			8'h41: sine = 16'hfa50 ;
			8'h42: sine = 16'hf976 ;
			8'h43: sine = 16'h0c10 ;
			8'h44: sine = 16'hff14 ;
			8'h45: sine = 16'hfca7 ;
			8'h46: sine = 16'hfd4f ;
			8'h47: sine = 16'h0126 ;
			8'h48: sine = 16'h0552 ;
			8'h49: sine = 16'hfab2 ;
			8'h4a: sine = 16'hfb54 ;
			8'h4b: sine = 16'h0a85 ;
			8'h4c: sine = 16'hfe2d ;
			8'h4d: sine = 16'hfc83 ;
			8'h4e: sine = 16'hfe9a ;
			8'h4f: sine = 16'h0243 ;
			8'h50: sine = 16'h0297 ;
			8'h51: sine = 16'hfa9a ;
			8'h52: sine = 16'h0064 ;
			8'h53: sine = 16'h076d ;
			8'h54: sine = 16'hfd77 ;
			8'h55: sine = 16'hfd6e ;
			8'h56: sine = 16'hfee2 ;
			8'h57: sine = 16'h02d3 ;
			8'h58: sine = 16'h012a ;
			8'h59: sine = 16'hfac3 ;
			8'h5a: sine = 16'h02d6 ;
			8'h5b: sine = 16'h03c7 ;
			8'h5c: sine = 16'hfe40 ;
			8'h5d: sine = 16'hfe2d ;
			8'h5e: sine = 16'hfe76 ;
			8'h5f: sine = 16'h0318 ;
			8'h60: sine = 16'h00a0 ;
			8'h61: sine = 16'hfb14 ;
			8'h62: sine = 16'h0417 ;
			8'h63: sine = 16'h020b ;
			8'h64: sine = 16'hff44 ;
			8'h65: sine = 16'hfe58 ;
			8'h66: sine = 16'hfecf ;
			8'h67: sine = 16'h0301 ;
			8'h68: sine = 16'h004e ;
			8'h69: sine = 16'hfb6a ;
			8'h6a: sine = 16'h04e8 ;
			8'h6b: sine = 16'h0077 ;
			8'h6c: sine = 16'hfed9 ;
			8'h6d: sine = 16'hfeee ;
			8'h6e: sine = 16'hff11 ;
			8'h6f: sine = 16'h02b1 ;
			8'h70: sine = 16'hff8e ;
			8'h71: sine = 16'hfc9e ;
			8'h72: sine = 16'h0445 ;
			8'h73: sine = 16'hff6a ;
			8'h74: sine = 16'hff34 ;
			8'h75: sine = 16'hff3b ;
			8'h76: sine = 16'hff3b ;
			8'h77: sine = 16'h02c1 ;
			8'h78: sine = 16'hfdf8 ;
			8'h79: sine = 16'hfeaf ;
			8'h7a: sine = 16'h038c ;
			8'h7b: sine = 16'hfed4 ;
			8'h7c: sine = 16'h003d ;
			8'h7d: sine = 16'hfe2c ;
			8'h7e: sine = 16'h0079 ;
			8'h7f: sine = 16'h0273 ;
			8'h80: sine = 16'hfdac ;
			8'h81: sine = 16'h000a ;
			8'h82: sine = 16'h011e ;
			8'h83: sine = 16'hff6e ;
			8'h84: sine = 16'h012d ;
			8'h85: sine = 16'hfd7d ;
			8'h86: sine = 16'h00ee ;
			8'h87: sine = 16'h01cc ;
			8'h88: sine = 16'hfd9b ;
			8'h89: sine = 16'h00e9 ;
			8'h8a: sine = 16'h009c ;
			8'h8b: sine = 16'hff71 ;
			8'h8c: sine = 16'h01be ;
			8'h8d: sine = 16'hfd76 ;
			8'h8e: sine = 16'hffdd ;
			8'h8f: sine = 16'h02dd ;
			8'h90: sine = 16'hfdd9 ;
			8'h91: sine = 16'hff6a ;
			8'h92: sine = 16'h0162 ;
			8'h93: sine = 16'h0010 ;
			8'h94: sine = 16'hffa2 ;
			8'h95: sine = 16'hfea7 ;
			8'h96: sine = 16'h0117 ;
			8'h97: sine = 16'h009c ;
			8'h98: sine = 16'hfdf9 ;
			8'h99: sine = 16'h022b ;
			8'h9a: sine = 16'hfeed ;
			8'h9b: sine = 16'hffdf ;
			8'h9c: sine = 16'h0043 ;
			8'h9d: sine = 16'hfefd ;
			8'h9e: sine = 16'h00c5 ;
			8'h9f: sine = 16'h012d ;
			8'ha0: sine = 16'hfe52 ;
			8'ha1: sine = 16'h012e ;
			8'ha2: sine = 16'hfffe ;
			8'ha3: sine = 16'h006b ;
			8'ha4: sine = 16'hff2e ;
			8'ha5: sine = 16'hfef5 ;
			8'ha6: sine = 16'h00de ;
			8'ha7: sine = 16'h00dc ;
			8'ha8: sine = 16'hffa0 ;
			8'ha9: sine = 16'hfeb0 ;
			8'haa: sine = 16'h0139 ;
			8'hab: sine = 16'h0099 ;
			8'hac: sine = 16'hfe20 ;
			8'had: sine = 16'h006b ;
			8'hae: sine = 16'h00bb ;
			8'haf: sine = 16'hffb5 ;
			8'hb0: sine = 16'h00b9 ;
			8'hb1: sine = 16'hfed5 ;
			8'hb2: sine = 16'h0061 ;
			8'hb3: sine = 16'h00a6 ;
			8'hb4: sine = 16'hfe15 ;
			8'hb5: sine = 16'hffea ;
			8'hb6: sine = 16'h0194 ;
			8'hb7: sine = 16'h0031 ;
			8'hb8: sine = 16'hfef3 ;
			8'hb9: sine = 16'hff91 ;
			8'hba: sine = 16'h015f ;
			8'hbb: sine = 16'h0080 ;
			8'hbc: sine = 16'hfe5f ;
			8'hbd: sine = 16'h009e ;
			8'hbe: sine = 16'h008a ;
			8'hbf: sine = 16'hff9e ;
			8'hc0: sine = 16'hffe4 ;
			8'hc1: sine = 16'hff0a ;
			8'hc2: sine = 16'h014c ;
			8'hc3: sine = 16'h00ff ;
			8'hc4: sine = 16'hfe2d ;
			8'hc5: sine = 16'h004f ;
			8'hc6: sine = 16'h00c1 ;
			8'hc7: sine = 16'hff57 ;
			8'hc8: sine = 16'h0038 ;
			8'hc9: sine = 16'h007e ;
			8'hca: sine = 16'hffff ;
			8'hcb: sine = 16'h0074 ;
			8'hcc: sine = 16'hfeeb ;
			8'hcd: sine = 16'hffc5 ;
			8'hce: sine = 16'h0142 ;
			8'hcf: sine = 16'hff54 ;
			8'hd0: sine = 16'hfef1 ;
			8'hd1: sine = 16'h0096 ;
			8'hd2: sine = 16'h010d ;
			8'hd3: sine = 16'hffdb ;
			8'hd4: sine = 16'hffa8 ;
			8'hd5: sine = 16'hffaf ;
			8'hd6: sine = 16'h00e9 ;
			8'hd7: sine = 16'hffac ;
			8'hd8: sine = 16'hff80 ;
			8'hd9: sine = 16'h00a3 ;
			8'hda: sine = 16'h00e1 ;
			8'hdb: sine = 16'hff57 ;
			8'hdc: sine = 16'hff67 ;
			8'hdd: sine = 16'hffc4 ;
			8'hde: sine = 16'h015f ;
			8'hdf: sine = 16'hffb7 ;
			8'he0: sine = 16'hfebe ;
			8'he1: sine = 16'h00ec ;
			8'he2: sine = 16'h00d2 ;
			8'he3: sine = 16'hfed4 ;
			8'he4: sine = 16'h0064 ;
			8'he5: sine = 16'hffd3 ;
			8'he6: sine = 16'h0016 ;
			8'he7: sine = 16'h005c ;
			8'he8: sine = 16'hff28 ;
			8'he9: sine = 16'h0073 ;
			8'hea: sine = 16'h006f ;
			8'heb: sine = 16'hff49 ;
			8'hec: sine = 16'hfff2 ;
			8'hed: sine = 16'h0086 ;
			8'hee: sine = 16'hffe1 ;
			8'hef: sine = 16'h0009 ;
			8'hf0: sine = 16'hff9c ;
			8'hf1: sine = 16'h0036 ;
			8'hf2: sine = 16'h0066 ;
			8'hf3: sine = 16'hff64 ;
			8'hf4: sine = 16'h0018 ;
			8'hf5: sine = 16'h0023 ;
			8'hf6: sine = 16'hffff ;
			8'hf7: sine = 16'hffdd ;
			8'hf8: sine = 16'h0010 ;
			8'hf9: sine = 16'hffe8 ;
			8'hfa: sine = 16'h0022 ;
			8'hfb: sine = 16'hffd3 ;
			8'hfc: sine = 16'h0022 ;
			8'hfd: sine = 16'h0000 ;
			8'hfe: sine = 16'h0000 ;
			8'hff: sine = 16'h0000 ;
*/
///////////////////////////////////////////////////