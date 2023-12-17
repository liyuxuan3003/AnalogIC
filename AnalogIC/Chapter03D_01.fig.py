# !%config InlineBackend.figure_format = 'svg'

from PyLTSpice import *
from cycler import cycler
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import os

import numpy as np

folder="./build"
filename="Chapter03D_01"

fileGhost=os.path.join(folder,filename+".fig.pdf")
fileASC=filename+".fig.asc"
fileNET=filename+".fig.net"
def fileExport(id): return os.path.join(folder,filename+"_"+str(id)+".fig.pdf")

xNMOS=r".model xNMOS NMOS(LEVEL=1,VTO=0.7,TOX=9e-9,GAMMA=0.45,PHI=0.90,UO=350,LAMBDA=0.1)"
xPMOS=r".model xPMOS PMOS(LEVEL=1,VTO=-0.8,TOX=9e-9,GAMMA=0.40,PHI=0.80,UO=100,LAMBDA=0.2)"

xColorCycle=cycler(color=['lightcoral','sandybrown','gold','yellowgreen','mediumaquamarine','skyblue','mediumpurple'])
# cycler("color", plt.cm.Set2.colors)

os.makedirs(folder,exist_ok=True)
open(fileGhost,"w")

plt.rc('text',usetex=True)
plt.rc('text.latex',preamble=" ".join([
    r'\usepackage{amsmath}',
    r'\usepackage{physics}',
    r'\usepackage{siunitx}',
    r'\usepackage{xcolor}']))

plt.rc('xtick', labelsize=6)
plt.rc('ytick', labelsize=6)

plt.rcParams["axes.prop_cycle"]=xColorCycle


runner=SimRunner(output_folder=folder,simulator=LTspice)
netlist=SpiceEditor(fileASC)
netlist.add_instruction(xNMOS)
netlist.add_instruction(xPMOS)
netlist.add_instruction(r".dc Vin 0 4 0.001")
netlist.set_component_value("RD","1")
netlist.set_component_value("Vin","0")
netlist.set_component_value("Vb","4")
netlist.set_component_value("VDD","4")
netlist.set_element_model("M1","xNMOS")
netlist.set_element_model("M2","xNMOS")

listRD=["1k","2k","4k","8k","16k","32k"]
listVb=["4","3"]

graphNum=4

idVout=0
idAV=1
idVX=2
idID=3

for i in range(len(listVb)*graphNum):
    plt.figure(i,figsize=(5,5*0.618))

for i in range(len(listVb)):
    for xRD in listRD:
        netlist.set_component_value("RD",xRD)
        netlist.set_component_value("Vb",listVb[i])
        raw,log=runner.run_now(netlist,run_filename="Temp.net")
        data=RawRead(raw)
        xVin=data.get_trace("Vin").get_wave(0)
        xVout=data.get_trace("V(Vout)").get_wave(0)
        xVX=data.get_trace("V(VX)").get_wave(0)
        xID=data.get_trace("Id(M1)").get_wave(0)
        xAV=np.diff(xVout)/np.diff(xVin)
        xAV=np.append(xAV,xAV[-1])
        label="$"+"R_D="+xRD.removesuffix("k")+r"\si{k\ohm}"+"$"
        plt.figure(i*graphNum+idVout)
        plt.plot(xVin,xVout,label=label)
        plt.figure(i*graphNum+idAV)
        plt.plot(xVin,xAV,label=label)
        plt.figure(i*graphNum+idVX)
        plt.plot(xVin,xVX,label=label)
        plt.figure(i*graphNum+idID)
        plt.plot(xVin,xID,label=label)

for i in range(len(listVb)):
    textVb=r"$V_b="+listVb[i]+r"\si{V}$"
    for j in range(graphNum):
        plt.figure(i*graphNum+j)
        axes=plt.gca()
        axes.grid(linewidth=0.25)
        axes.set_xlim(-0.1,4.1)
        axes.xaxis.set_major_locator(ticker.MultipleLocator(1))
        axes.tick_params(labeltop=True,labelright=True,top=True,right=True)
        axes.set_xlabel(r"$V_{in}~(\si{V})$")
        if j==idVout:
            axes.set_ylim(-0.1,4.1)
            axes.yaxis.set_major_locator(ticker.MultipleLocator(1))
            axes.set_ylabel(r"$V_{out}~(\si{V})$")
            axes.legend(loc="lower left")
            axes.text(0.5,3.5,textVb,ha="center")
        if j==idAV:
            axes.set_ylim(-5.1,0.1)
            axes.yaxis.set_major_locator(ticker.MultipleLocator(1))
            axes.set_ylabel(r"$A_V$")
            axes.legend(loc="lower right")
            axes.text(0.5,-1.5,textVb,ha="center")
        if j==idVX:
            axes.set_ylim(-0.1,4.1)
            axes.yaxis.set_major_locator(ticker.MultipleLocator(1))
            axes.set_ylabel(r"$V_{X}~(\si{V})$")
            axes.legend(loc="upper right")
            axes.text(0.5,3.5,textVb,ha="center")
        if j==idID:
            axes.set_ylim(-0.01*1e-3,0.41*1e-3)
            axes.yaxis.set_major_locator(ticker.MultipleLocator(0.1*1e-3))
            axes.yaxis.set_major_formatter(lambda x, pos:"$"+"{:.1f}".format(x/1e-3)+"$")
            axes.set_ylabel(r"$I_D~(\si{mA})$")
            axes.legend(loc="upper left")
            axes.text(0.5,0.15*1e-3,textVb,ha="center")
        plt.savefig(fileExport(i*graphNum+j),bbox_inches ='tight')

os.remove(fileNET)