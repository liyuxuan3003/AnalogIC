# !%config InlineBackend.figure_format = 'svg'

from PyLTSpice import *
from cycler import cycler
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import os

import numpy as np

folder="./build"
filename="Chapter04A_03"

fileGhost=os.path.join(folder,filename+".fig.pdf")
fileASC=filename+".fig.asc"
fileNET=filename+".fig.net"
def fileExport(id): return os.path.join(folder,filename+"_"+str(id)+".fig.pdf")

xNMOS=r".model xNMOS NMOS(LEVEL=1,VTO=0.7,TOX=9e-9,GAMMA=0.45,PHI=0.90,UO=350,LAMBDA=0.1)"
xPMOS=r".model xPMOS PMOS(LEVEL=1,VTO=-0.8,TOX=9e-9,GAMMA=0.40,PHI=0.80,UO=100,LAMBDA=0.2)"

xColorList=['lightcoral','sandybrown','gold','yellowgreen','mediumaquamarine','skyblue','mediumpurple']
xColorCycle=cycler(color=xColorList)

xArrowProp=dict(facecolor='black', shrink=0.05,width=0.02,headlength=6,headwidth=3)

os.makedirs(folder,exist_ok=True)
open(fileGhost,"w")

plt.rc('text',usetex=True)
plt.rc('text.latex',preamble=" ".join([
    r'\usepackage{ctex}',
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
netlist.set_component_value("RD1","10k")
netlist.set_component_value("RD2","10k")
netlist.set_component_value("RSS","40k")
netlist.set_component_value("Vin1","0")
netlist.set_component_value("VinCM1","2")
netlist.set_component_value("VDD","4")
netlist.set_component_value("ISS","0.3m")
netlist.set_element_model("M1","xNMOS")
netlist.set_element_model("M2","xNMOS")

xVTH0=0.7

graphNum=4
idVoutCMRD=0
idVoutDMRD=1
idAVCDRD=2
idAVCMRD=3

for i in range(graphNum):
    plt.figure(i,figsize=(5,5*0.618))

netlist1=netlist
netlist1.add_instruction(r".dc VinCM1 0 4 0.001")
raw,log=runner.run_now(netlist1,run_filename="Temp.net")
data=RawRead(raw)

xVinRSS=data.get_trace("V(VinCM)").get_wave(0)
xVoutRSS=data.get_trace("V(Vout1)").get_wave(0)
xZero=xVinRSS-xVinRSS
xAVCMRSS=np.diff(xVoutRSS)/np.diff(xVinRSS)
xAVCMRSS=np.append(xAVCMRSS,xAVCMRSS[-1])

netlist2=netlist
netlist.set_element_model("M1","xNMOS L=1 W=2")
netlist.set_element_model("M2","xNMOS L=2 W=1")
netlist2.add_instruction(r".dc VinCM1 0 4 0.001")
raw,log=runner.run_now(netlist2,run_filename="Temp.net")
data=RawRead(raw)

xVinRD=data.get_trace("V(VinCM)").get_wave(0)
xVout1RD=data.get_trace("V(Vout1)").get_wave(0)
xVout2RD=data.get_trace("V(Vout2)").get_wave(0)
xVoutDMRD=(xVout1RD-xVout2RD)
xVoutCMRD=(xVout1RD+xVout2RD)/2
xAVCDRD=np.diff(xVoutDMRD)/np.diff(xVinRD)
xAVCDRD=np.append(xAVCDRD,xAVCDRD[-1])
xAVCMRD=np.diff(xVoutCMRD)/np.diff(xVinRD)
xAVCMRD=np.append(xAVCMRD,xAVCMRD[-1])

plt.figure(idVoutCMRD)
plt.plot(xVinRSS,xVoutRSS,c='gray',ls='dotted',label="$V_{out,CM}, g_{m1}=g_{m2}$")
plt.plot(xVinRD,xVout1RD,c='r',label="$V_{out1}$")
plt.plot(xVinRD,xVout2RD,c='b',label="$V_{out2}$")
plt.plot(xVinRD,xVoutCMRD,c='k',label="$V_{out,CM}$")

plt.figure(idVoutDMRD)
plt.plot(xVinRSS,xZero,c='gray',ls='dotted',label="$V_{out,DM}, g_{m1}=g_{m2}$")
plt.plot(xVinRD,xVoutDMRD,c='k',label="$V_{out,DM}$")

plt.figure(idAVCDRD)
plt.plot(xVinRSS,xZero,c='gray',ls='dotted',label="$A_{CM-DM}, g_{m1}=g_{m2}$")
plt.plot(xVinRD,xAVCDRD,c='k',label="$A_{CM-DM}$")

plt.figure(idAVCMRD)
plt.plot(xVinRSS,xAVCMRSS,c='gray',ls='dotted',label="$A_{CM}, g_{m1}=g_{m2}$")
plt.plot(xVinRD,xAVCMRD,c='k',label="$A_{CM}$")

for id in range(graphNum):
    plt.figure(id)
    axes=plt.gca()
    axes.grid(linewidth=0.25)
    axes.tick_params(labeltop=True,labelright=True,top=True,right=True)
    if id in [idVoutCMRD,idVoutDMRD,idAVCDRD,idAVCMRD]:
        axes.set_xlim(0,4)
        axes.xaxis.set_major_locator(ticker.MultipleLocator(1))
        axes.set_xlabel(r"$V_{in,CM}~(\si{V})$")
        axes.legend(loc="lower right")
    if id==idVoutDMRD:
        axes.set_ylim(-4.2,0.2)
        axes.yaxis.set_major_locator(ticker.MultipleLocator(1))
        axes.set_ylabel(r"$V_{out,DM}=V_{out}~(\si{V})$")
    if id==idVoutCMRD:
        axes.set_ylim(-0.2,4.2)
        axes.yaxis.set_major_locator(ticker.MultipleLocator(1))
        axes.set_ylabel(r"$V_{out,CM},V_{out1},V_{out2}~(\si{V})$")
    if id==idAVCDRD:
        axes.set_ylim(-2.1,1.1)
        axes.yaxis.set_major_locator(ticker.MultipleLocator(0.5))
        axes.set_ylabel(r"$A_{CM-DM}$")
    if id==idAVCMRD:
        axes.set_ylim(-2.1,1.1)
        axes.yaxis.set_major_locator(ticker.MultipleLocator(0.5))
        axes.set_ylabel(r"$A_{CM}$")
    plt.savefig(fileExport(id),bbox_inches ='tight')
    
os.remove(fileNET)