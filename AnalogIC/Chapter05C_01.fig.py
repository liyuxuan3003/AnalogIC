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
filename="Chapter05C_01"

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

xVTHN0=+0.7
xVTHP0=-0.8
xVb=1.2
xVDD=4

runner=SimRunner(output_folder=folder,simulator=LTspice)
netlist=SpiceEditor(fileASC)
netlist.add_instruction(xNMOS)
netlist.add_instruction(xPMOS)
netlist.set_component_value("Vin1","0")
netlist.set_component_value("VinCM1","2")
netlist.set_component_value("VDD",str(xVDD))
netlist.set_component_value("Vb",str(xVb))
netlist.set_element_model("M1","xNMOS")
netlist.set_element_model("M2","xNMOS")
netlist.set_element_model("M3","xPMOS")
netlist.set_element_model("M4","xPMOS")
netlist.set_element_model("M5","xNMOS")

graphNum=8
idVout=0
idADM=1
idISS=2
idM1=3
idM2=4
idM3=5
idM4=6
idM5=7

for i in range(graphNum):
    plt.figure(i,figsize=(5,5*0.618))

# 差模分析
netlist1=netlist
netlist1.add_instruction(r".dc Vin1 -2 2 0.0001")
raw,log=runner.run_now(netlist1,run_filename="Temp.net")
data=RawRead(raw)

xVin1=data.get_trace("V(Vin1)").get_wave(0)
xVin2=data.get_trace("V(Vin2)").get_wave(0)
xVin=xVin1-xVin2

xVout=data.get_trace("V(Vout)").get_wave(0)
xVP=data.get_trace("V(VP)").get_wave(0)
xVQ=data.get_trace("V(VQ)").get_wave(0)

xISS=data.get_trace("Id(M5)").get_wave(0)
xI1=data.get_trace("Id(M1)").get_wave(0)
xI2=data.get_trace("Id(M2)").get_wave(0)

xADM=LDiff(xVin,xVout)

xVGT1=xVin1-xVP-xVTHN0
xVGT2=xVin2-xVP-xVTHN0
xVGT3=xVQ-xVDD-xVTHP0
xVGT4=xVQ-xVDD-xVTHP0
xVGT5=np.ones(np.size(xVin))*(xVb-xVTHN0)

xVDS1=xVQ-xVP
xVDS2=xVout-xVP
xVDS3=xVQ-xVDD
xVDS4=xVout-xVDD
xVDS5=xVP

xidM=[idM1,idM2,idM3,idM4,idM5]
xVGT=[xVGT1,xVGT2,xVGT3,xVGT4,xVGT5]
xVDS=[xVDS1,xVDS2,xVDS3,xVDS4,xVDS5]
pcl=[]
pclr=[]
pzl=[]
pzlr=[]


for i in range(len(xidM)):
    plt.figure(idM1+i)
    plt.plot(xVin,xVGT[i],c='purple',label="$V_{GS"+str(i+1)+"}-V_{TH"+str(i+1)+"}$")
    plt.plot(xVin,xVDS[i],c='green',label="$V_{DS"+str(i+1)+"}$")
    pc=LDCross(xVGT[i],xVDS[i])
    pz=LDCross(xVGT[i],0)
    pcl.append(pc)
    pzl.append(pz)
    if xidM[i]!=idM3:   
        pclr.append(pc)
        plt.plot(xVin[[pc]],xVDS[i][[pc]],marker='o',markersize=4,c='w',mec='k',ls='')
    if xidM[i] in [idM1,idM2]:   
        pzlr.append(pz)
        plt.plot(xVin[[pz]],xVGT[i][[pz]],marker='o',markersize=4,c='w',mec='gray',ls='')
    
plt.figure(idVout)
plt.plot(xVin,xVP,c='gray',label="$V_P$")
plt.plot(xVin,xVQ,c='r',label="$V_{out1}=V_F$")
plt.plot(xVin,xVout,c='b',label="$V_{out2}=V_{out}$")

pvoutz=LDCross(xVin,0)
plt.plot(xVin[[pvoutz]],xVout[[pvoutz]],marker='o',markersize=4,c='w',mec='b',ls='')

np.argwhere('0')

plt.figure(idADM)
plt.plot(xVin,xADM,c='b',label="$A_{DM}$")
for x in [xADM]:
    plt.plot(xVin[[pclr]],x[[pclr]],marker='o',markersize=4,c='w',mec='k',ls='')

for x in [xADM]:
    plt.plot(xVin[[pzlr]],x[[pzlr]],marker='o',markersize=4,c='w',mec='gray',ls='')

plt.figure(idISS)
plt.plot(xVin,xISS,c='gray',label="$I_{SS}$")
plt.plot(xVin,xI1,c='r',label="$I_{D1}$")
plt.plot(xVin,xI2,c='b',label="$I_{D2}=I_{out}$")

for id in range(graphNum):
    plt.figure(id)
    axes=plt.gca()
    axes.grid(linewidth=0.25)
    axes.tick_params(labeltop=True,labelright=True,top=True,right=True)
    axes.set_xlim(-4.1,4.1)
    axes.xaxis.set_major_locator(ticker.MultipleLocator(1))
    axes.tick_params(labeltop=True,labelright=True,top=True,right=True)
    axes.set_xlabel(r"$V_{in}~(\si{V})$")
    if id==idVout:
        plt.legend(loc="lower right")
        axes.set_ylim(-0.1,4.1)
        axes.yaxis.set_major_locator(ticker.MultipleLocator(1))
        axes.set_ylabel(r"$V_{out},V_{P}~(\si{V})$")
    if id==idADM:
        plt.legend(loc="upper right")
        axes.set_ylim(-0.5,25.5)
        axes.yaxis.set_major_locator(ticker.MultipleLocator(5))
        axes.set_ylabel(r"$A_{DM}~(\si{V})$")
        axes.text(-0.6,23,"$M_2$")
        axes.text(0.2,20.5,"$M_4$")
        axes.text(-0.75,2,"$M_5$",ha='center',va='center')
        axes.text(2,1.5,"$M_1$",ha='center',va='center')
        axes.text(0.7,1.5,"$M_2$",c='gray',ha='center',va='center')
        axes.text(-2.7,1.5,"$M_1$",c='gray',ha='center',va='center')
    if id==idISS:
        plt.legend(loc="center right")
        axes.set_ylim(-0.5*1e-6,25.5*1e-6)
        axes.yaxis.set_major_locator(ticker.MultipleLocator(5*1e-6))
        axes.yaxis.set_major_formatter(lambda x, pos:"$"+"{:.0f}".format(x/1e-6)+"$")
        axes.set_ylabel(r"$I_{D},I_{SS}~(\si{uA})$")
    if id in xidM:
        axes.set_ylim(-4.2,4.2)
        axes.yaxis.set_major_locator(ticker.MultipleLocator(1))
        axes.set_ylabel(r"$V_{DS},V_{GS}-V_{TH}~(\si{V})$")
    if id in [idM1,idM2,idM5]:
        plt.legend(loc='lower left')
    if id in [idM3,idM4]:
        plt.legend(loc='lower right')
    plt.savefig(fileExport(id),bbox_inches ='tight')

# 5,2,4,1

os.remove(fileNET)