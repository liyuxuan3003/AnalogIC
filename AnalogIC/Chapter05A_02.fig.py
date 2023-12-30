# !%config InlineBackend.figure_format = 'svg'

from PyLTSpice import *
from cycler import cycler
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import os

import numpy as np

folder="./build"
filename="Chapter05A_02"

fileGhost=os.path.join(folder,filename+".fig.pdf")
fileASC=filename+".fig.asc"
fileNET=filename+".fig.net"
def fileExport(id): return os.path.join(folder,filename+"_"+str(id)+".fig.pdf")

xNMOS=r".model xNMOS NMOS(LEVEL=1,VTO=0.7,TOX=9e-9,GAMMA=0.45,PHI=0.90,UO=350,LAMBDA=0.10)"
xPMOS=r".model xPMOS PMOS(LEVEL=1,VTO=-0.8,TOX=9e-9,GAMMA=0.40,PHI=0.80,UO=100,LAMBDA=0.20)"
xNMOSLO=r".model xNMOSLO NMOS(LEVEL=1,VTO=0.7,TOX=9e-9,GAMMA=0.45,PHI=0.90,UO=350)"
xPMOSLO=r".model xPMOSLO PMOS(LEVEL=1,VTO=-0.8,TOX=9e-9,GAMMA=0.40,PHI=0.80,UO=100)"
modelList=[xNMOS,xPMOS,xNMOSLO,xPMOSLO]

xVTHN0=0.7

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
for model in modelList:
    netlist.add_instruction(model)
netlist.set_element_model("M1","xNMOS")
netlist.set_element_model("M2","xNMOS")
netlist.set_element_model("M3","xNMOS")
netlist.set_element_model("M4","xNMOS")
netlist.set_component_value("VDD","4")
netlist.set_component_value("Vout","0")
netlist.set_component_value("IREF","0.1m")
netlist.add_instruction(r".dc Vout 0 4 0.001")

graphNum=4
idIout=0
idVDn=1
idVRE2=2
idVRE4=3

for i in range(graphNum):
    plt.figure(i,figsize=(5,5*0.618))

netlist1=netlist
raw,log=runner.run_now(netlist1,run_filename="Temp.net")
data=RawRead(raw)
xVout=data.get_trace("Vout").get_wave(0)
xIout=data.get_trace("Id(M2)").get_wave(0)
xVD1=data.get_trace("V(VD1)").get_wave(0)
xVD2=data.get_trace("V(VD2)").get_wave(0)
xVD3=data.get_trace("V(VD3)").get_wave(0)
xVD4=data.get_trace("V(VD4)").get_wave(0)

xVDS2=xVD2
xVGT2=xVD1-xVTHN0

xVDS4=xVD4-xVD2
xVGT4=xVD3-xVD2-xVTHN0

p2=np.argmin(np.abs(xVGT2-xVDS2))
p4=np.argmin(np.abs(xVGT4-xVDS4))

plt.figure(idIout)
plt.plot(xVout,xIout,c='black',label=r'$I_{out}, \lambda\neq 0$')
plt.plot(xVout[[p2,p4]],xIout[[p2,p4]],marker='o',markersize=4,c='w',mec='k',ls='')

plt.figure(idVDn)
plt.plot(xVout,xVD1,c='r',label='$V_{D1}$')
plt.plot(xVout,xVD2,c='b',label='$V_{D2}$')
plt.plot(xVout,xVD3,c='r',ls='dashed',label='$V_{D3}$')
plt.plot(xVout,xVD4,c='b',ls='dashed',label='$V_{D4}$')

plt.figure(idVRE2)
plt.plot(xVout,xVDS2,c='green',label='$V_{DS2}$')
plt.plot(xVout,xVGT2,c='purple',label='$V_{GS2}-V_{TH}$')
plt.plot(xVout[[p2]],xVDS2[[p2]],marker='o',markersize=4,c='w',mec='k',ls='')

plt.figure(idVRE4)
plt.plot(xVout,xVDS4,c='green',label='$V_{DS4}$')
plt.plot(xVout,xVGT4,c='purple',label='$V_{GS4}-V_{TH}$')
plt.plot(xVout[[p4]],xVDS4[[p4]],marker='o',markersize=4,c='w',mec='k',ls='')

for id in range(graphNum):
    plt.figure(id)
    axes=plt.gca()
    axes.grid(linewidth=0.25)
    axes.tick_params(labeltop=True,labelright=True,top=True,right=True)
    axes.set_xlim(0,4)
    axes.xaxis.set_major_locator(ticker.MultipleLocator(1))
    axes.set_xlabel(r"$V_{out}~(\si{V})$")
    if id==idIout:
        axes.set_ylim(-0.01*1e-3,0.21*1e-3)
        axes.set_ylabel(r"$I_{out}~(\si{mA})$")
        axes.yaxis.set_major_formatter(lambda x, pos:"$"+"{:.2f}".format(x/1e-3)+"$")
        axes.yaxis.set_major_locator(ticker.MultipleLocator(0.05*1e-3))
        axes.legend(loc="lower right")
        axes.text(0.5,0.11*1e-3,"$I_{REF}$",c='r')
        axes.hlines(0.1*1e-3,0,4,colors='red',lw=0.5,ls='dotted')
    if id in [idVDn,idVRE2,idVRE4]:
        axes.set_ylim(-0.2,4.2)
        axes.yaxis.set_major_locator(ticker.MultipleLocator(1))
    if id==idVDn:
        axes.set_ylabel(r"$V_{D}~(\si{V})$")
        axes.legend(loc="lower right")
    if id==idVRE2:
        axes.set_ylabel(r"$V_{DS2},V_{GS2}-V_{TH}~(\si{V})$")
        axes.legend(loc="upper right")
    if id==idVRE4:
        axes.set_ylabel(r"$V_{DS4},V_{GS4}-V_{TH}~(\si{V})$")
        axes.legend(loc="upper right")
    plt.savefig(fileExport(id),bbox_inches ='tight')
    
os.remove(fileNET)