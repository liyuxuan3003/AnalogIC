# !%config InlineBackend.figure_format = 'svg'

from PyLTSpice import *
from cycler import cycler
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import os

import numpy as np

def LDiff(x,y):
    d=np.diff(y)/np.diff(x)
    d=np.append(d,d[-1])
    return d

def LDCross(y1,y2):
    return np.argmin(np.abs(y1-y2))

folder="./build"
filename="Chapter06A_01"

fileGhost=os.path.join(folder,filename+".fig.pdf")
fileASC=filename+".fig.asc"
fileNET=filename+".fig.net"
def fileExport(id): return os.path.join(folder,filename+"_"+str(id)+".fig.pdf")

xNMOS=r".model xNMOS NMOS(LEVEL=1,VTO=0.7,TOX=9e-9,GAMMA=0.45,PHI=0.90,UO=350,LAMBDA=0.1,LD=0.08e-6,PB=0.9,CJ=0.56e-3,CJSW=0.35e-11,MJ=0.45,MJSW=0.2,CGDO=0.4e-9,CGSO=0.4e-9,JS=1.0e-8)"
xPMOS=r".model xPMOS PMOS(LEVEL=1,VTO=-0.8,TOX=9e-9,GAMMA=0.40,PHI=0.80,UO=100,LAMBDA=0.2,LD=0.09e-6,PB=0.9,CJ=0.94e-3,CJSW=0.32e-11,MJ=0.50,MJSW=0.3,CGDO=0.3e-9,CGSO=0.3e-9,JS=0.5e-8)"

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

xVTHN0=+0.7
xVTHP0=-0.8
xVb=1.2
xVDD=4

runner=SimRunner(output_folder=folder,simulator=LTspice)
netlist=SpiceEditor(fileASC)
netlist.add_instruction(xNMOS)
netlist.add_instruction(xPMOS)
netlist.set_component_value("Vin","AC 0.001")
netlist.set_component_value("VDD",str(xVDD))
netlist.set_element_model("M1","xNMOS L=0.5u W=0.5u")

graphNum=1
idAV=0

for i in range(graphNum):
    plt.figure(i,figsize=(5,5*0.618))

netlist.add_instruction(r".ac dec 100 1 1Meg")
raw,log=runner.run_now(netlist,run_filename="Temp.net")
data=RawRead(raw)

xF=data.get_trace("frequency").get_wave(0)
xVout=data.get_trace("V(Vout)").get_wave(0)

plt.figure(idAV)
plt.plot(xF,xVout)

# for id in range(graphNum):
#     plt.figure(id)
#     axes=plt.gca()
#     axes.grid(linewidth=0.25)
#     axes.tick_params(labeltop=True,labelright=True,top=True,right=True)
#     axes.set_xlim(-4.1,4.1)
#     axes.xaxis.set_major_locator(ticker.MultipleLocator(1))
#     axes.tick_params(labeltop=True,labelright=True,top=True,right=True)
#     axes.set_xlabel(r"$V_{in}~(\si{V})$")
#     plt.savefig(fileExport(id),bbox_inches ='tight')

# 5,2,4,1

os.remove(fileNET)