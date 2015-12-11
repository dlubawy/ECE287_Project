transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Drew/Documents/School/ECE287/ece287_project/Synthesizer {C:/Users/Drew/Documents/School/ECE287/ece287_project/Synthesizer/AUDIO_DAC_ADC.v}
vlog -vlog01compat -work work +incdir+C:/Users/Drew/Documents/School/ECE287/ece287_project/Synthesizer {C:/Users/Drew/Documents/School/ECE287/ece287_project/Synthesizer/I2C_AV_Config.v}
vlog -vlog01compat -work work +incdir+C:/Users/Drew/Documents/School/ECE287/ece287_project/Synthesizer {C:/Users/Drew/Documents/School/ECE287/ece287_project/Synthesizer/I2C_Controller.v}
vlog -vlog01compat -work work +incdir+C:/Users/Drew/Documents/School/ECE287/ece287_project/Synthesizer {C:/Users/Drew/Documents/School/ECE287/ece287_project/Synthesizer/Reset_Delay.v}
vlog -vlog01compat -work work +incdir+C:/Users/Drew/Documents/School/ECE287/ece287_project/Synthesizer {C:/Users/Drew/Documents/School/ECE287/ece287_project/Synthesizer/VGA_Audio_PLL.v}
vlog -vlog01compat -work work +incdir+C:/Users/Drew/Documents/School/ECE287/ece287_project/Synthesizer {C:/Users/Drew/Documents/School/ECE287/ece287_project/Synthesizer/synthesizer.v}

