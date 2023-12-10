# !%config InlineBackend.figure_format = 'svg'

from PyLTSpice import *
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import os

import numpy as np

filename="Chapter03D_01"
folder="./build"

os.makedirs(folder,exist_ok=True)
open(os.path.join(folder,filename+".fig.pdf"),"w")

plt.rc('text',usetex=True)
plt.rc('text.latex',preamble=" ".join([
    r'\usepackage{amsmath}',
    r'\usepackage{physics}',
    r'\usepackage{siunitx}',
    r'\usepackage{xcolor}']))

runner=SimRunner(output_folder="./build",simulator=LTspice)
netlist=SpiceEditor(filename+".fig.asc")
netlist.add_instruction(r".model xNMOS NMOS(LEVEL=1,VTO=0.7,TOX=9e-9,GAMMA=0.45,PHI=0.90,UO=350,LAMBDA=0.1)")
netlist.add_instruction(r".model xPMOS PMOS(LEVEL=1,VTO=-0.8,TOX=9e-9,GAMMA=0.40,PHI=0.80,UO=100,LAMBDA=0.2)")
netlist.add_instruction(r".dc Vin 0 4 0.001")
netlist.set_component_value("RD","1")
netlist.set_component_value("Vin","0")
netlist.set_component_value("Vb","4")
netlist.set_component_value("VDD","4")
netlist.set_element_model("M1","xNMOS")
netlist.set_element_model("M2","xNMOS")

listRD=["1k","2k","4k","8k","16k","32k"]
listVb=["4","3"]

for i in range(len(listVb)*2):
    plt.figure(i,figsize=(6,6*0.618))

for i in range(len(listVb)):
    for xRD in listRD:
        netlist.set_component_value("RD",xRD)
        netlist.set_component_value("Vb",listVb[i])
        raw,log=runner.run_now(netlist,run_filename="Temp.net")
        data=RawRead(raw)
        xVin=data.get_trace("Vin").get_wave(0)
        xVout=data.get_trace("V(Vout)").get_wave(0)
        xAV=np.diff(xVout)/np.diff(xVin)    
        plt.figure(i*2)
        plt.plot(xVin,xVout,label="$"+"R_D="+xRD.removesuffix("k")+r"\si{k\ohm}"+"$")
        plt.figure(i*2+1)
        plt.plot(xVin[0:-1],xAV,label="$"+"R_D="+xRD.removesuffix("k")+r"\si{k\ohm}"+"$")

for i in range(len(listVb)):
    for j in range(2):
        plt.figure(i*2+j)
        plt.title("\small $"+"V_b="+listVb[i]+r"~\si{V}"+"$")
        axes=plt.gca()
        axes.grid(linewidth=0.25)
        axes.set_xlim(-0.1,4.1)
        axes.xaxis.set_major_locator(ticker.MultipleLocator(1))
        axes.yaxis.set_major_locator(ticker.MultipleLocator(1))
        axes.tick_params(labeltop=True,labelright=True,top=True,right=True)
        axes.set_xlabel(r"$V_{in}~(\si{V})$")
        axes.legend(loc="lower left")
        if j==0:
            axes.set_ylim(-0.1,4.1)
            axes.set_ylabel(r"$V_{out}~(\si{V})$")
        if j==1:
            axes.set_ylim(-5.1,0.1)
            axes.set_ylabel(r"$A_V$")
        plt.savefig(os.path.join(folder,filename+"_"+str(i*2+j)+".fig.pdf"))

os.remove(filename+".fig.net")