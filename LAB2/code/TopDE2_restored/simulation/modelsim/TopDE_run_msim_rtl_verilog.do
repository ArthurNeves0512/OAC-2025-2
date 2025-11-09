transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/raulm/OneDrive/Documents/code/oac/OAC-2025-2/LAB2/code/TopDE2_restored {C:/Users/raulm/OneDrive/Documents/code/oac/OAC-2025-2/LAB2/code/TopDE2_restored/Parametros.v}
vlog -sv -work work +incdir+C:/Users/raulm/OneDrive/Documents/code/oac/OAC-2025-2/LAB2/code/TopDE2_restored {C:/Users/raulm/OneDrive/Documents/code/oac/OAC-2025-2/LAB2/code/TopDE2_restored/ramI.v}
vlog -sv -work work +incdir+C:/Users/raulm/OneDrive/Documents/code/oac/OAC-2025-2/LAB2/code/TopDE2_restored {C:/Users/raulm/OneDrive/Documents/code/oac/OAC-2025-2/LAB2/code/TopDE2_restored/ramD.v}
vlog -sv -work work +incdir+C:/Users/raulm/OneDrive/Documents/code/oac/OAC-2025-2/LAB2/code {C:/Users/raulm/OneDrive/Documents/code/oac/OAC-2025-2/LAB2/code/Control.v}
vlog -sv -work work +incdir+C:/Users/raulm/OneDrive/Documents/code/oac/OAC-2025-2/LAB2/code {C:/Users/raulm/OneDrive/Documents/code/oac/OAC-2025-2/LAB2/code/ALUControl.v}
vlog -sv -work work +incdir+C:/Users/raulm/OneDrive/Documents/code/oac/OAC-2025-2/LAB2/code/TopDE2_restored {C:/Users/raulm/OneDrive/Documents/code/oac/OAC-2025-2/LAB2/code/TopDE2_restored/Uniciclo.v}
vlog -sv -work work +incdir+C:/Users/raulm/OneDrive/Documents/code/oac/OAC-2025-2/LAB2/code/TopDE2_restored {C:/Users/raulm/OneDrive/Documents/code/oac/OAC-2025-2/LAB2/code/TopDE2_restored/ALU.v}
vlog -sv -work work +incdir+C:/Users/raulm/OneDrive/Documents/code/oac/OAC-2025-2/LAB2/code/TopDE2_restored {C:/Users/raulm/OneDrive/Documents/code/oac/OAC-2025-2/LAB2/code/TopDE2_restored/Registers.v}
vlog -sv -work work +incdir+C:/Users/raulm/OneDrive/Documents/code/oac/OAC-2025-2/LAB2/code/TopDE2_restored {C:/Users/raulm/OneDrive/Documents/code/oac/OAC-2025-2/LAB2/code/TopDE2_restored/ImmGen.v}

