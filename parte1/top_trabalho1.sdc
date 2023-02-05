# Criando um clock virtual chamado "virtclk"

create_clock -name {clock} -period 5.000 -waveform { 0.000 2.500 } [get_ports clock]

# Configurando delay de entrada e de saida

set_input_delay -clock clock 0.0 [all_inputs]

set_output_delay -clock clock 0.0 [all_outputs]