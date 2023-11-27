#!/usr/bin/env wolframscript
(* ::Package:: *)

ClearAll["Global`*"]


SetDirectory[NotebookDirectory[]];
Needs["MaTeX`"];


nbFileName="Chapter03B_02.fig.wls";
nbPDFName="build/"<>StringReplace[nbFileName,"wls"->"pdf"];
nbPDFNameList=(StringReplace[nbPDFName,".fig"->#<>".fig"]&)/@Alphabet[];
Export[nbPDFName,""]


xLaTeX=(MaTeX[
	#1,Magnification->#2,
	"Preamble"->{"\\usepackage{xcolor}","\\usepackage{siunitx}","\\usepackage{physics}","\\usepackage{upgreek}"}])&;
xLabelFont={FontColor->Black,FontFamily->"Latin Modern",FontSize->5};


xFigConfig={
	Frame->True,GridLines->Automatic,ImageSize->Automatic->300,
	FrameStyle->BlackFrame,PlotStyle->ColorData[10],BaseStyle->xLabelFont};
xFigLabel=(FrameLabel->{xLaTeX[#1,0.8],xLaTeX[#2,0.8]})&;


xFig3DConfig={
	ViewPoint->{-100,-80,65},PlotPoints -> 50,MaxRecursion -> 5,
	ExclusionsStyle->{None,{Black,Thin}},ColorFunction->ColorData["DarkRainbow"],
	BaseStyle->xLabelFont};
xFig3DLabel=(AxesLabel->{xLaTeX[#1,0.8],xLaTeX[#2,0.8],xLaTeX[#3,0.8]})&;


xTicks=(Table[{x,xLaTeX[ToString[PaddedForm[x,{#2[[1]],#2[[2]]}]],0.5]},{x,#1[[1]],#1[[2]],#1[[3]]}])&;
xTicksProp=(Table[{x #3,xLaTeX[ToString[PaddedForm[x,{#2[[1]],#2[[2]]}]],0.5]},{x,#1[[1]],#1[[2]],#1[[3]]}])&;
xTicksLog=(Table[{10^x,xLaTeX["10^{"<>ToString[x]<>"}",0.5]},{x,#1[[1]],#1[[2]],#1[[3]]}])&;
xTicksLog1=(Table[{10^x,xLaTeX["1\\times 10^{"<>ToString[x]<>"}",0.5]},{x,#1[[1]],#1[[2]],#1[[3]]}])&;
xTicksLog2=(Table[{2 10^x,xLaTeX["2\\times 10^{"<>ToString[x]<>"}",0.5]},{x,#1[[1]],#1[[2]],#1[[3]]}])&;
xTicksLog5=(Table[{5 10^x,xLaTeX["5\\times 10^{"<>ToString[x]<>"}",0.5]},{x,#1[[1]],#1[[2]],#1[[3]]}])&;


xGrids=(Table[x,{x,#1[[1]],#1[[2]],#1[[3]]}])&;
xGridsLog=(Flatten[Table[Table[{If[#2[[1]]<=(n 10^x)<=#2[[2]],(n 10^x),{}]},{n,1,9,1}],{x,#1[[1]],#1[[2]],#1[[3]]}]])&;


xText=Style[#1,FontSize->#2,FontFamily->"Noto Serif CJK SC"]&;


m=10^(-3);
k=10^(3);
M=10^(6);


xkB=1.3806488 10^(-23);
xq=1.602176565 10^(-19);
xT=300;
xVT=(kB T)/q;
xtox=9 10^(-9);
xeox=3.9;
xe0=8.854187817 10^(-12);
xCox=eox e0/tox;
xalpha=2 mu Cox (xi VT)^2/Exp[2];
xxi=1.5;
xVDD=4;


xVTH0N=+0.7;
xVTH0P=-0.8;
xmuN=350 100^(-2);
xmuP=100 100^(-2);
xlambdaN=+0.1;
xlambdaP=-0.2;
xgammaN=+0.45;
xgammaP=-0.40;
xPhiFN=+0.9/2;
xPhiFP=-0.8/2;


listVal={kB->xkB,q->xq,T->xT,VT->xVT,tox->xtox,eox->xeox,e0->xe0,Cox->xCox,alpha->xalpha,xi->xxi,VDD->xVDD,
	VTH0N->xVTH0N,muN->xmuN,lambdaN->xlambdaN,gammaN->xgammaN,PhiFN->xPhiFN,
	VTH0P->xVTH0P,muP->xmuP,lambdaP->xlambdaP,gammaP->xgammaP,PhiFP->xPhiFP
};


xIDoff=0;
xIDlin=mu Cox WLr((VGS-VTH)VDS-VDS^2/2)(1+lambda VDS);
xIDsat=mu Cox WLr((VGS-VTH)^2/2)(1+lambda VDS);


xIDRS=IDx


xVTH=VTH0+gamma(Sqrt[2PhiF-VBS]-Sqrt[2PhiF]);
xeta=-D[xVTH,VBS];


listTransN={VDS->VDD-Vout,VGS->Vin-Vout,VTH->VTH0N,lambda->0,mu->muN,WLr->WLrN,ID->xIDRS};


xVoutsat=FullSimplify[Vout//.Solve[(xIDsat//.listTransN)==(xIDRS),Vout][[1]]];
xVout=Piecewise[{
	{0,0<Vin<=VTH0N},
	{xVoutsat,VTH0N<Vin<=VDD  && xVoutsat>=0}
}];


xAV=D[xVout,Vin];
xAVsat=D[xVoutsat,Vin];


listID={0.01m,0.02m,0.04m,0.08m};


listPlotVal={WLrN->1}


pointList2A=Point[{VTH0N,0}]//.listVal;
fig2=Plot[Evaluate[Table[Re[xVout]//.Join[listVal,listPlotVal],{IDx,listID}]],{Vin,0,xVDD},
	PlotPoints->500,Exclusions->None,
	PlotRange->{-0.25,xVDD+0.25},
	GridLines->{xGrids[{0,4,0.5}],xGrids[{0,4,0.5}]},
	FrameTicks->{xTicks[{0,4,1},{1,0}],xTicks[{0,4,1},{1,0}]},
	Epilog->{
		Blue,PointSize[0.015],Evaluate@pointList2A,
		White,PointSize[0.010],Evaluate@pointList2A,
		Text[xLaTeX["\\textcolor{blue}{V_{TH}}",0.8],{0.70,0.25}]
	},
	PlotLegends->Placed[LineLegend[{
		xLaTeX["I_S=0.01\\si{mA}",0.8],
		xLaTeX["I_S=0.02\\si{mA}",0.8],
		xLaTeX["I_S=0.04\\si{mA}",0.8],
		xLaTeX["I_S=0.08\\si{mA}",0.8]},
		LegendFunction->"Panel",
		LegendLayout -> {"Column",1}],{Left,Top}],
	Evaluate@xFigLabel["V_{in}~(\\si{V})","V_{out}~(\\si{V})"],
	Evaluate@xFigConfig]


pointList3A=Point[{VTH0N,0}]//.listVal;
fig3=Plot[1,{Vin,0,xVDD},
	PlotRange->{-0.1,1.1},
	PlotStyle->Black,
	GridLines->{xGrids[{0,4,0.5}],xGrids[{0,1,0.1}]},
	FrameTicks->{xTicks[{0,4,1},{1,0}],xTicks[{0,1,0.2},{2,1}]},
	Exclusions->None,
	Evaluate@xFigLabel["V_{in}~(\\si{V})","A_V"],
	Evaluate@xFigConfig]


fig={fig2,fig3}


figWithName=Transpose[{fig,nbPDFNameList[[1;;Length[fig]]]}];
ReleaseHold[(Hold[Export[#[[2]],#[[1]],ImageResolution->2000]]&)/@figWithName]
