# !%config InlineBackend.figure_format = 'svg'

from PyLTSpice import *
from cycler import cycler
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import os

import numpy as np

folder="./build"
filename="Chapter04A_01"

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
netlist.set_component_value("Vin1","0")
netlist.set_component_value("VinCM1","2")
netlist.set_component_value("VDD","4")
netlist.set_component_value("ISS","0.3m")
netlist.set_element_model("M1","xNMOS")
netlist.set_element_model("M2","xNMOS")

xVTH0=0.7

graphNum=11
idVoutS=0
idVoutD=1
idVP=2
idIDS=3
idIDD=4
idAV=5
idGM=6
idRE=7
idVoutCM=8
idIDCM=9
idAVCM=10

for i in range(graphNum):
    plt.figure(i,figsize=(5,5*0.618))

# 差模分析
netlist1=netlist
netlist1.add_instruction(r".dc Vin1 -2 2 0.001")
raw,log=runner.run_now(netlist1,run_filename="Temp.net")
data=RawRead(raw)

xVin1=data.get_trace("V(Vin1)").get_wave(0)
xVin2=data.get_trace("V(Vin2)").get_wave(0)
xVin=xVin1-xVin2

xVout1=data.get_trace("V(Vout1)").get_wave(0)
xVout2=data.get_trace("V(Vout2)").get_wave(0)
xVP=data.get_trace("V(VP)").get_wave(0)
xVout=xVout1-xVout2

xVDS1=xVout1-xVP
xVGSTH1=xVin1-xVP-xVTH0

xVDS2=xVout2-xVP
xVGSTH2=xVin2-xVP-xVTH0

pBR=np.argmin(np.abs(xVGSTH1-xVDS1))
pAL=np.argmin(np.abs(xVGSTH1-0))
pBL=np.argmin(np.abs(xVGSTH2-xVDS2))
pAR=np.argmin(np.abs(xVGSTH2-0))
pArr=np.array([pAL,pBL,pAR,pBR])

xAV=np.diff(xVout)/np.diff(xVin)
xAV=np.append(xAV,xAV[-1])

plt.figure(idVoutS)
plt.plot(xVin,xVout1,c="#FF0000",label="$V_{out1}$")
plt.plot(xVin,xVout2,c="#0000FF",label="$V_{out2}$")
plt.plot(xVin,xVin1,c="#FFBBBB",ls="dotted",lw=1,label="$V_{in1}$")
plt.plot(xVin,xVin2,c="#BBBBFF",ls="dotted",lw=1,label="$V_{in2}$")
plt.plot(xVin,xVP,c="#AAAAAA",ls="dashed",lw=0.5,label="$V_{P}$")

plt.figure(idVoutD)
plt.plot(xVin,xVout,c='#000000')

plt.figure(idVP)
plt.plot(xVin,xVP,c='#000000')

plt.figure(idAV)
plt.plot(xVin,xAV,c='#000000')
plt.plot(xVin[pArr],xAV[pArr],marker='o',markersize=4,c='w',mec='black',ls='')

plt.figure(idRE)

plt.plot(xVin,xVDS1,c="#FF0000",label="$V_{DS1}$")
plt.plot(xVin,xVDS2,c="#0000FF",label="$V_{DS2}$")
plt.plot(xVin,xVGSTH1,c="#FFBBBB",ls="dotted",lw=1,label="$V_{GS1}-V_{TH1}$")
plt.plot(xVin,xVGSTH2,c="#BBBBFF",ls="dotted",lw=1,label="$V_{GS2}-V_{TH2}$")
plt.plot(xVin[[pAL,pBR]],xVGSTH1[[pAL,pBR]],marker='o',markersize=4,c='w',mec='r',ls='')
plt.plot(xVin[[pAR,pBL]],xVGSTH2[[pAR,pBL]],marker='o',markersize=4,c='w',mec='b',ls='')


xID1=data.get_trace("Id(M1)").get_wave(0)
xID2=data.get_trace("Id(M2)").get_wave(0)
xID=xID1-xID2

xGM=np.diff(xID)/np.diff(xVin)
xGM=np.append(xGM,xGM[-1])

plt.figure(idIDS)
plt.plot(xVin,xID1,c="#FF0000",label="$I_{D1}$")
plt.plot(xVin,xID2,c="#0000FF",label="$I_{D2}$")

plt.figure(idIDD)
plt.plot(xVin,xID,c="#000000")

plt.figure(idGM)
plt.plot(xVin,xGM,c='#000000')
plt.plot(xVin[pArr],xGM[pArr],marker='o',markersize=4,c='w',mec='black',ls='')

# 共模分析
netlist2=netlist
netlist2.add_instruction(r".dc VinCM1 0 4 0.001")
raw,log=runner.run_now(netlist1,run_filename="Temp.net")
data=RawRead(raw)

xVinCM=data.get_trace("V(VinCM)").get_wave(0)
xVoutCM=data.get_trace("V(Vout1)").get_wave(0)
xVPCM=data.get_trace("V(VP)").get_wave(0)
xIDCM=data.get_trace("Id(M1)").get_wave(0)
xAVCM=np.diff(xVoutCM)/np.diff(xVinCM)
xAVCM=np.append(xAVCM,xAVCM[-1])

plt.figure(idVoutCM)
plt.plot(xVinCM,xVoutCM,c='black',label="$V_{out,CM}$")
plt.plot(xVinCM,xVPCM,c="#AAAAAA",ls="dashed",lw=0.5,label="$V_{P}$")

plt.figure(idIDCM)
plt.plot(xVinCM,xIDCM,c='black')

plt.figure(idAVCM)
plt.plot(xVinCM,xAVCM,c='black')

for id in range(graphNum):
    plt.figure(id)
    axes=plt.gca()
    axes.grid(linewidth=0.25)
    axes.tick_params(labeltop=True,labelright=True,top=True,right=True)
    if id in [idVoutS,idVoutD,idVP,idIDD,idIDS,idAV,idGM,idRE]:
        axes.set_xlabel(r"$V_{in}~(\si{V})$")
        axes.set_xlim(-4,4)
        axes.xaxis.set_major_locator(ticker.MultipleLocator(1))
    if id in [idVoutCM,idIDCM,idAVCM]:
        axes.set_xlabel(r"$V_{in,CM}~(\si{V})$")
        axes.set_xlim(0,4)
        axes.xaxis.set_major_locator(ticker.MultipleLocator(1))
    if id==idVoutS:
        axes.set_ylim(-0.2,4.2)
        axes.yaxis.set_major_locator(ticker.MultipleLocator(1))
        axes.set_ylabel(r"$V_{out1},V_{out2}~(\si{V})$")
        axes.legend(loc="center left")
        axes.annotate("$V_{DD}$",xy=(-2,4),xytext=(-0.5,4),va='center',arrowprops=xArrowProp)
        axes.annotate("$V_{DD}-R_{D}I_{SS}$",xy=(-2,1),xytext=(-0.5,1),va='center',arrowprops=xArrowProp)
        axes.annotate("$V_{out,CM}=V_{DD}-R_{D}I_{SS}/2$",xy=(0.1,2.5),xytext=(0.6,2.5),va='center',arrowprops=xArrowProp)
        axes.annotate("$V_{in,CM}=V_{DD}/2$",xy=(0.1,2),xytext=(0.7,2),va='center',arrowprops=xArrowProp)
    if id==idVoutD:
        axes.set_ylim(-4.2,4.2)
        axes.yaxis.set_major_locator(ticker.MultipleLocator(1))
        axes.set_ylabel(r"$V_{out}~(\si{V})$")
        axes.annotate("$+R_{D}I_{SS}$",xy=(-2,+3),xytext=(0,+3),va='center',ha='center',arrowprops=xArrowProp)
        axes.annotate("$-R_{D}I_{SS}$",xy=(+2,-3),xytext=(0,-3),va='center',ha='center',arrowprops=xArrowProp)
    if id==idVP:
        axes.set_ylim(-0.05,0.25)
        axes.yaxis.set_major_locator(ticker.MultipleLocator(0.1))
        axes.set_ylabel(r"$V_{P}~(\si{V})$")
        axes.annotate(r"$V_P\approx 0$",xy=(0,0),xytext=(0,0.05),va='center',ha='center',arrowprops=xArrowProp)
    if id==idIDS:
        axes.set_ylim(-0.03*1e-3,0.33*1e-3)
        axes.yaxis.set_major_formatter(lambda x, pos:"$"+"{:.1f}".format(x/1e-3)+"$")
        axes.yaxis.set_major_locator(ticker.MultipleLocator(0.1*1e-3))
        axes.set_ylabel(r"$I_{D1},I_{D2}~(\si{mA})$")
        axes.legend(loc="center left")
        axes.annotate(r"$I_{SS}$",xy=(-2,0.3*1e-3),xytext=(1.2,0.3*1e-3),va='center',arrowprops=xArrowProp)
        axes.annotate(r"$I_{SS}/2$",xy=(0.1,0.15*1e-3),xytext=(1.2,0.15*1e-3),va='center',arrowprops=xArrowProp)
    if id==idIDD:
        axes.set_ylim(-0.36*1e-3,0.36*1e-3)
        axes.yaxis.set_major_formatter(lambda x, pos:"$"+"{:.1f}".format(x/1e-3)+"$")
        axes.yaxis.set_major_locator(ticker.MultipleLocator(0.1*1e-3))
        axes.set_ylabel(r"$I_{D1}~(\si{mA})$")
        axes.annotate(r"$+I_{SS}$",xy=(+2,+0.3*1e-3),xytext=(0,+0.3*1e-3),va='center',ha='center',arrowprops=xArrowProp)
        axes.annotate(r"$-I_{SS}$",xy=(-2,-0.3*1e-3),xytext=(0,-0.3*1e-3),va='center',ha='center',arrowprops=xArrowProp)
    if id==idGM:
        axes.set_ylim(-0.02*1e-3,0.22*1e-3)
        axes.yaxis.set_major_formatter(lambda x, pos:"$"+"{:.1f}".format(x/1e-3)+"$")
        axes.yaxis.set_major_locator(ticker.MultipleLocator(0.05*1e-3))
        axes.set_ylabel(r"$G_{m}~(\si{mS})$")
    if id==idAV:
        axes.set_ylim(-2.2,0.2)
        axes.yaxis.set_major_locator(ticker.MultipleLocator(0.5))
        axes.set_ylabel(r"$A_{DM}$")
    if id==idRE:
        axes.set_ylim(-1.2,4.2)
        axes.yaxis.set_major_locator(ticker.MultipleLocator(1))
        axes.set_ylabel(r"$V_{DS},V_{GS}-V_{TH}~(\si{V})$")
        axes.legend(loc="lower center")
        axes.vlines(xVin[pArr],-1.5,4.5,colors='gray',lw=0.8,ls='dashed')
        axes.text(-3.1,0,r"$-V_{ina}$",ha='center',va='center',c='r')
        axes.text(+3.1,0,r"$+V_{ina}$",ha='center',va='center',c='b')
        axes.text(-1.5,1.7,r"$-V_{inb}$",ha='center',va='center',c='b')
        axes.text(+1.5,1.7,r"$+V_{inb}$",ha='center',va='center',c='r')
    if id==idVoutCM:
        axes.set_ylim(-0.2,4.2)
        axes.yaxis.set_major_locator(ticker.MultipleLocator(1))
        axes.set_ylabel(r"$V_{out,CM},V_P~(\si{V})$")
        axes.annotate("$V_{DD}$",xy=(0.25,4),xytext=(2,4),va='center',ha='center',arrowprops=xArrowProp)
        axes.annotate("$V_{DD}-R_DI_{SS}/2$",xy=(1.25,2.5),xytext=(1.25,1.75),ha='center',va='center',arrowprops=xArrowProp)
        axes.legend(loc="lower left")
    if id==idIDCM:
        axes.set_ylim(-0.03*1e-3,0.33*1e-3)
        axes.yaxis.set_major_formatter(lambda x, pos:"$"+"{:.1f}".format(x/1e-3)+"$")
        axes.yaxis.set_major_locator(ticker.MultipleLocator(0.1*1e-3))
        axes.set_ylabel(r"$I_{D,CM}~(\si{mA})$")
        axes.annotate(r"$I_{SS}/2$",xy=(1.25,+0.15*1e-3),xytext=(0.5,+0.15*1e-3),va='center',ha='center',arrowprops=xArrowProp)
    if id==idAVCM:
        axes.set_ylim(-2.2,0.2)
        axes.yaxis.set_major_locator(ticker.MultipleLocator(0.5))
        axes.set_ylabel(r"$A_{CM}$")
    plt.savefig(fileExport(id),bbox_inches ='tight')

os.remove(fileNET)