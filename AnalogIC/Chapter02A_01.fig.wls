#!/usr/bin/env wolframscript
(* ::Package:: *)

ClearAll["Global`*"]


SetDirectory[NotebookDirectory[]];
Needs["MaTeX`"];


nbFileName="Chapter02A_01.fig.wls";
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


xVTH0=0.7;
xVTH=VTH0;
xkB=1.3806488 10^(-23);
xq=1.602176565 10^(-19);
xT=300;
xVT=(kB T)/q;
xtox=9 10^(-9);
xeox=3.9;
xe0=8.854187817 10^(-12);
xCox=eox e0/tox;
xmu=350 100^(-2);
xW=0.5 10^(-6);
xL=0.5 10^(-6);
xlambda=0.1;
xalpha=2 mu Cox (xi VT)^2/Exp[2];
xxi=1.5;
xgamma=0.45
xPhiF=0.9/2
listVal={VTH0->xVTH0,VTH->xVTH,kB->xkB,q->xq,T->xT,VT->xVT,
	tox->xtox,eox->xeox,e0->xe0,Cox->xCox,
	mu->xmu,W->xW,L->xL,alpha->xalpha,xi->xxi,
	gamma->xgamma,PhiF->xPhiF};
listValSTD=Join[listVal,{lambda->0}];
listValLAM=Join[listVal,{lambda->xlambda}];


xIDoff=0;
xIDlin=mu Cox (W/L)((VGS-VTH)VDS-VDS^2/2)(1+lambda VDS);
xIDsat=mu Cox (W/L)((VGS-VTH)^2/2)(1+lambda VDS);
xID=Piecewise[{
	{xIDoff,VGS<=VTH},
	{xIDlin,VGS>VTH && VDS<=VGS-VTH},
	{xIDsat,VGS>VTH && VDS>VGS-VTH}
}];


xIDsub=alpha (W/L) Exp[(VGS-VTH)/(xi VT)];
xIDs=Piecewise[{
	{xIDsub,VGS-VTH<=2xi VT},
	{xIDsat,VGS-VTH>2xi VT}
}];


xVTHBody=VTH+gamma(Sqrt[2PhiF-VBS]-Sqrt[2PhiF])
xeta=-D[xVTHBody,VBS]


xgmlin=D[xIDlin,VGS]
xgmsat=D[xIDsat,VGS]
xgolin=D[xIDlin,VDS]
xgosat=D[xIDsat,VDS]


xgm=Piecewise[{
	{0,VGS<=VTH},
	{xgmlin,VGS>VTH && VDS<=VGS-VTH},
	{xgmsat,VGS>VTH && VDS>VGS-VTH}
}];
xgo=Piecewise[{
	{0,VGS<=VTH},
	{xgolin,VGS>VTH && VDS<=VGS-VTH},
	{xgosat,VGS>VTH && VDS>VGS-VTH}
}];


{2 xi VT}//.listVal


m=10^(-3);
k=10^(3);
M=10^(6);


RBColorList=Table[Blend[{Red,Blue},x],{x,0,1,1/(#1-1)}]&;


fig1a=Plot3D[xID//.listValSTD,{VDS,0,4},{VGS,0,4},
	Exclusions->{(VGS==VTH)//.listVal,(VDS==VGS-VTH)//.listVal},
	Evaluate@xFig3DConfig,
	Evaluate@xFig3DLabel["V_{DS}~(\\si{V})","V_{GS}~(\\si{V})","I_D~(\\si{mA})"],
	PlotRange->{-0.05m,0.8m},
	Ticks->{xTicks[{0,4,1},{2,1}],xTicks[{0,4,1},{2,1}],xTicksProp[{0,0.8,0.2},{2,1},m]}]
fig1b=Plot3D[xID//.listValLAM,{VDS,0,4},{VGS,0,4},
	Exclusions->{(VGS==VTH)//.listVal,(VDS==VGS-VTH)//.listVal},
	Evaluate@xFig3DConfig,
	Evaluate@xFig3DLabel["V_{DS}~(\\si{V})","V_{GS}~(\\si{V})","I_D~(\\si{mA})"],
	PlotRange->{-0.05m,1.05m},
	Ticks->{xTicks[{0,4,1},{2,1}],xTicks[{0,4,1},{2,1}],xTicksProp[{0,1.0,0.2},{2,1},m]}]


xIDsepVDS=xID//.{VGS->VDS+VTH};
fig2a=Plot[Evaluate@Join[{xIDsepVDS//.listValSTD},Table[xID//.listValSTD,{VGS,{1,2,3,4}}]],{VDS,0,4},
	PlotRange->{-0.05m,+0.85m},
	PlotStyle->Join[{Directive[Black,Dashed]},RBColorList[6][[{2,3,4,5}]]],
	FrameTicks->{xTicks[{0,4,1},{2,1}],xTicksProp[{0,0.8,0.1},{2,1},m]},
	GridLines->{xGrids[{0,4,0.5}],xGrids[{0.0m,0.8m,0.1m}]},
	Epilog->{
		Text[xLaTeX["V_{GS}=1\\si{V}",0.65],{3.75,0.03m+xID//.listValSTD//.{VGS->1,VDS->3.75}}],
		Text[xLaTeX["V_{GS}=2\\si{V}",0.65],{3.75,0.03m+xID//.listValSTD//.{VGS->2,VDS->3.75}}],
		Text[xLaTeX["V_{GS}=3\\si{V}",0.65],{3.75,0.03m+xID//.listValSTD//.{VGS->3,VDS->3.75}}],
		Text[xLaTeX["V_{GS}=4\\si{V}",0.65],{3.75,0.03m+xID//.listValSTD//.{VGS->4,VDS->3.75}}],
		Text[xText["\:7ebf\:6027\:533a",10],{2.25,0.55m}],
		Text[xText["\:9971\:548c\:533a",10],{3.25,0.55m}],
		Text[xText["\:6df1\:5ea6\:7ebf\:6027\:533a",10],{0.37,0.35m}],
		Arrowheads[0.03],
		Arrow[{{0.22,0.31m},{0.22,0.12m}}]
	},
	Evaluate@xFigLabel["V_{DS}~(\\si{V})","I_D~(\\si{mA})"],
	Evaluate@xFigConfig]
fig2b=Plot[Evaluate@Join[{xIDsepVDS//.listValLAM},Table[xID//.listValLAM,{VGS,{1,2,3,4}}]],{VDS,0,4},
	PlotRange->{-0.05m,+1.15m},
	PlotStyle->Join[{Directive[Black,Dashed]},RBColorList[6][[{2,3,4,5}]]],
	FrameTicks->{xTicks[{0,4,1},{2,1}],xTicksProp[{0,1.1,0.1},{2,1},m]},
	GridLines->{xGrids[{0,4,0.5}],xGrids[{0.0m,1.1m,0.1m}]},
	Epilog->{
		Text[xLaTeX["V_{GS}=1\\si{V}",0.65],{3.75,0.05m+xID//.listValLAM//.{VGS->1,VDS->3.75}}],
		Text[xLaTeX["V_{GS}=2\\si{V}",0.65],{3.75,0.05m+xID//.listValLAM//.{VGS->2,VDS->3.75}}],
		Text[xLaTeX["V_{GS}=3\\si{V}",0.65],{3.75,0.05m+xID//.listValLAM//.{VGS->3,VDS->3.75}}],
		Text[xLaTeX["V_{GS}=4\\si{V}",0.65],{3.75,0.05m+xID//.listValLAM//.{VGS->4,VDS->3.75}}],
		Text[xText["\:7ebf\:6027\:533a",10],{2.25,0.65m}],
		Text[xText["\:9971\:548c\:533a",10],{3.25,0.65m}],
		Text[xText["\:6df1\:5ea6\:7ebf\:6027\:533a",10],{0.37,0.35m}],
		Arrowheads[0.03],
		Arrow[{{0.22,0.31m},{0.22,0.12m}}]
	},
	Evaluate@xFigLabel["V_{DS}~(\\si{V})","I_D~(\\si{mA})"],
	Evaluate@xFigConfig]


xIDsepVGS=xID//.{VDS->VGS-VTH};
fig3a=Plot[Evaluate@Table[xID//.listValSTD,{VDS,{1,2,4}}],{VGS,0,4},
	PlotRange->{-0.05m,+0.85m},
	PlotStyle->RBColorList[6][[{2,3,5}]],
	FrameTicks->{xTicks[{0,4,1},{2,1}],xTicksProp[{0,0.8,0.1},{2,1},m]},
	GridLines->{xGrids[{0,4,0.5}],xGrids[{0.0m,0.8m,0.1m}]},
	Epilog->{
		Text[xLaTeX["V_{DS}=1\\si{V}",0.65],{3.75,-0.07m+xID//.listValSTD//.{VDS->1,VGS->3.75}}],
		Text[xLaTeX["V_{DS}=2\\si{V}",0.65],{3.75,-0.10m+xID//.listValSTD//.{VDS->2,VGS->3.75}}],
		Text[xLaTeX["V_{DS}=4\\si{V}",0.65],{3.75,+0.13m+xID//.listValSTD//.{VDS->4,VGS->3.75}}],
		Text[xLaTeX["\\textcolor{gray}{V_{TH}}",0.9],{VTH-0.18,0.75m}]//.listVal,
		Dashed,Gray,Thickness[0.002],
		Line[{{VTH,-0.05m},{VTH,1.15m}}]//.listVal
	},
	Evaluate@xFigLabel["V_{GS}~(\\si{V})","I_D~(\\si{mA})"],
	Evaluate@xFigConfig]
fig3b=Plot[Evaluate@Table[xID//.listValLAM,{VDS,{1,2,4}}],{VGS,0,4},
	PlotRange->{-0.05m,+1.15m},
	PlotStyle->RBColorList[6][[{2,3,5}]],
	FrameTicks->{xTicks[{0,4,1},{2,1}],xTicksProp[{0,1.1,0.1},{2,1},m]},
	GridLines->{xGrids[{0,4,0.5}],xGrids[{0.0m,1.1m,0.1m}]},
	Epilog->{
		Text[xLaTeX["V_{DS}=1\\si{V}",0.65],{3.75,-0.09m+xID//.listValLAM//.{VDS->1,VGS->3.75}}],
		Text[xLaTeX["V_{DS}=2\\si{V}",0.65],{3.75,-0.12m+xID//.listValLAM//.{VDS->2,VGS->3.75}}],
		Text[xLaTeX["V_{DS}=4\\si{V}",0.65],{3.75,+0.15m+xID//.listValLAM//.{VDS->4,VGS->3.75}}],
		Text[xLaTeX["\\textcolor{gray}{V_{TH}}",0.9],{VTH-0.18,0.95m}]//.listVal,
		Dashed,Gray,Thickness[0.002],
		Line[{{VTH,-0.05m},{VTH,1.15m}}]//.listVal
	},
	Evaluate@xFigLabel["V_{GS}~(\\si{V})","I_D~(\\si{mA})"],
	Evaluate@xFigConfig]


fig4a=Plot[xIDs//.listValSTD,{VGS,0,4},
	PlotRange->{-0.05m,+0.85m},PlotStyle->Black,
	FrameTicks->{xTicks[{0,4,1},{2,1}],xTicksProp[{0,0.8,0.1},{2,1},m]},
	GridLines->{xGrids[{0,4,0.5}],xGrids[{-0.04m,0.84m,0.02m}]},
	Epilog->{
		Black,Thickness[0.002],
		Line[{{VTH+2xi VT,-0.05m},{VTH+2xi VT,0.85m}}]//.listVal,
		Gray,Dashed,Thickness[0.002],
		Line[{{VTH,-0.05m},{VTH,0.85m}}]//.listVal,
		Text[xLaTeX["\\textcolor{gray}{V_{TH}}",0.9],{VTH-0.18,0.75m}]//.listVal,
		Text[xLaTeX["V_{TH}+2\\xi V_T",0.9],{VTH+2xi VT+0.4,0.75m}]//.listVal,
		Black,
		Text[xText["\:9971\:548c\:533a",10],{VTH+2xi VT+0.25,0.1m}]//.listVal,
		Text[xText["\:4e9a\:9608\:503c\:533a",10],{VTH+2xi VT-0.32,0.1m}]//.listVal,
		Black,PointSize[0.015],
		Point[{(VTH+2xi VT)//.listValSTD,xIDs//.{VGS->VTH+2xi VT}//.listValSTD}],
		White,PointSize[0.010],
		Point[{(VTH+2xi VT)//.listValSTD,xIDs//.{VGS->VTH+2xi VT}//.listValSTD}]
	},
	Evaluate@xFigLabel["V_{GS}~(\\si{V})","I_D~(\\si{mA})"],
	Evaluate@xFigConfig]


fig4b=LogPlot[xIDs//.listValSTD,{VGS,0.00,4},
	PlotRange->{10^(-16),10^(-2)},PlotStyle->Black,
	FrameTicks->{xTicks[{0,4,1},{2,1}],xTicksLog[{-15,-3,3}]},
	GridLines->{xGrids[{0,4,0.5}],xGridsLog[{-16,-2,1},{10^(-16),10^(-2)}]},
	Epilog->{
		Black,Thickness[0.002],
		Line[{{VTH+2xi VT,Log[10^(-16)]},{VTH+2xi VT,Log[10^(-2)]}}]//.listVal,
		Gray,Dashed,Thickness[0.002],
		Line[{{VTH,Log[10^(-16)]},{VTH,Log[10^(-2)]}}]//.listVal,
		Text[xLaTeX["\\textcolor{gray}{V_{TH}}",0.9],{VTH-0.18,Log[4 10^(-4)]}]//.listVal,
		Text[xLaTeX["V_{TH}+2\\xi V_T",0.9],{VTH+2xi VT+0.4,Log[4 10^(-4)]}]//.listVal,
		Black,
		Text[xText["\:9971\:548c\:533a",10],{VTH+2xi VT+0.25,Log[2 10^(-14)]}]//.listVal,
		Text[xText["\:4e9a\:9608\:503c\:533a",10],{VTH+2xi VT-0.32,Log[2 10^(-14)]}]//.listVal,
		Black,PointSize[0.015],
		Point[{(VTH+2xi VT)//.listValSTD,Log[xIDs//.{VGS->VTH+2xi VT}//.listValSTD]}],
		White,PointSize[0.010],
		Point[{(VTH+2xi VT)//.listValSTD,Log[xIDs//.{VGS->VTH+2xi VT}//.listValSTD]}]
	},
	Evaluate@xFigLabel["V_{GS}~(\\si{V})","I_D~(\\si{A})"],
	Evaluate@xFigConfig]


fig5a=Plot[Evaluate[{xIDsub,xID//.{VDS->4}}//.listValSTD],{VGS,0,4},
	PlotRange->{-0.05m,+0.85m},
	PlotStyle->RBColorList[6][[{1,5}]],
	FrameTicks->{xTicks[{0,4,1},{2,1}],xTicksProp[{0,0.8,0.1},{2,1},m]},
	GridLines->{xGrids[{0,4,0.5}],xGrids[{-0.04m,0.84m,0.02m}]},
	Epilog->{
		Black,Thickness[0.002],
		Line[{{VTH+2xi VT,-0.05m},{VTH+2xi VT,0.85m}}]//.listVal,
		Gray,Dashed,Thickness[0.002],
		Line[{{VTH,-0.05m},{VTH,0.85m}}]//.listVal,
		Text[xLaTeX["\\textcolor{gray}{V_{TH}}",0.9],{VTH-0.18,0.75m}]//.listVal,
		Text[xLaTeX["V_{TH}+2\\xi V_T",0.9],{VTH+2xi VT+0.4,0.75m}]//.listVal,
		Black,PointSize[0.015],
		Point[{(VTH+2xi VT)//.listValSTD,xIDs//.{VGS->VTH+2xi VT}//.listValSTD}],
		White,PointSize[0.010],
		Point[{(VTH+2xi VT)//.listValSTD,xIDs//.{VGS->VTH+2xi VT}//.listValSTD}]
	},
	PlotLegends->Placed[LineLegend[
		{xText["\:6307\:6570\:5f8b",10],xText["\:5e73\:65b9\:5f8b",10]},
		LegendFunction->"Panel",
		LegendLayout -> {"Column",1}],{Right,Bottom}],
	Evaluate@xFigLabel["V_{GS}~(\\si{V})","I_D~(\\si{mA})"],
	Evaluate@xFigConfig]


fig5b=LogPlot[Evaluate[{xIDsub,xID//.{VDS->4}}//.listValSTD],{VGS,0.00,4},
	PlotRange->{10^(-16),10^(-2)},
	PlotStyle->RBColorList[6][[{1,5}]],
	PlotPoints->500,
	FrameTicks->{xTicks[{0,4,1},{2,1}],xTicksLog[{-15,-3,3}]},
	GridLines->{xGrids[{0,4,0.5}],xGridsLog[{-16,-2,1},{10^(-16),10^(-2)}]},
	Epilog->{
		Black,Thickness[0.002],
		Line[{{VTH+2xi VT,Log[10^(-16)]},{VTH+2xi VT,Log[10^(-2)]}}]//.listVal,
		Gray,Dashed,Thickness[0.002],
		Line[{{VTH,Log[10^(-16)]},{VTH,Log[10^(-2)]}}]//.listVal,
		Text[xLaTeX["\\textcolor{gray}{V_{TH}}",0.9],{VTH-0.18,Log[4 10^(-4)]}]//.listVal,
		Text[xLaTeX["V_{TH}+2\\xi V_T",0.9],{VTH+2xi VT+0.4,Log[4 10^(-4)]}]//.listVal,
		Black,PointSize[0.015],
		Point[{(VTH+2xi VT)//.listValSTD,Log[xIDs//.{VGS->VTH+2xi VT}//.listValSTD]}],
		White,PointSize[0.010],
		Point[{(VTH+2xi VT)//.listValSTD,Log[xIDs//.{VGS->VTH+2xi VT}//.listValSTD]}]
	},
	PlotLegends->Placed[LineLegend[
		{xText["\:6307\:6570\:5f8b",10],xText["\:5e73\:65b9\:5f8b",10]},
		LegendFunction->"Panel",
		LegendLayout -> {"Column",1}],{Right,Bottom}],
	Evaluate@xFigLabel["V_{GS}~(\\si{V})","I_D~(\\si{A})"],
	Evaluate@xFigConfig]


plotColor={ColorFunction->Function[{x,y,z},ColorData["GreenBrownTerrain"][z/(0.6m)]],ColorFunctionScaling->False};


fig6a=Plot3D[xgm//.listValSTD,{VDS,0,4},{VGS,0,4},
	Exclusions->{(VGS==VTH)//.listVal,(VDS==VGS-VTH)//.listVal},
	Evaluate@plotColor,
	Evaluate@xFig3DConfig,
	Evaluate@xFig3DLabel["V_{DS}~(\\si{V})","V_{GS}~(\\si{V})","g_m~(\\si{mS})"],
	PlotRange->{-0.05m,0.65m},
	Ticks->{xTicks[{0,4,1},{2,1}],xTicks[{0,4,1},{2,1}],xTicksProp[{0,0.6,0.2},{2,1},m]}]
fig6b=Plot3D[xgo//.listValSTD,{VDS,0,4},{VGS,0,4},
	Exclusions->{(VGS==VTH)//.listVal,(VDS==VGS-VTH)//.listVal},
	Evaluate@plotColor,
	Evaluate@xFig3DConfig,
	Evaluate@xFig3DLabel["V_{DS}~(\\si{V})","V_{GS}~(\\si{V})","g_O~(\\si{mS})"],
	PlotRange->{-0.05m,0.65m},
	Ticks->{xTicks[{0,4,1},{2,1}],xTicks[{0,4,1},{2,1}],xTicksProp[{0,0.6,0.2},{2,1},m]}]


fig7a=Plot3D[xgm//.listValLAM,{VDS,0,4},{VGS,0,4},
	Exclusions->{(VGS==VTH)//.listVal,(VDS==VGS-VTH)//.listVal},
	Evaluate@plotColor,
	Evaluate@xFig3DConfig,
	Evaluate@xFig3DLabel["V_{DS}~(\\si{V})","V_{GS}~(\\si{V})","g_m~(\\si{mS})"],
	PlotRange->{-0.05m,0.65m},
	Ticks->{xTicks[{0,4,1},{2,1}],xTicks[{0,4,1},{2,1}],xTicksProp[{0,0.6,0.2},{2,1},m]}]
fig7b=Plot3D[xgo//.listValLAM,{VDS,0,4},{VGS,0,4},
	Exclusions->{(VGS==VTH)//.listVal,(VDS==VGS-VTH)//.listVal},
	Evaluate@plotColor,
	Evaluate@xFig3DConfig,
	Evaluate@xFig3DLabel["V_{DS}~(\\si{V})","V_{GS}~(\\si{V})","g_O~(\\si{mS})"],
	PlotRange->{-0.05m,0.65m},
	Ticks->{xTicks[{0,4,1},{2,1}],xTicks[{0,4,1},{2,1}],xTicksProp[{0,0.6,0.2},{2,1},m]}]


fig8a=Plot[Evaluate@Table[xgo//.listValSTD,{VDS,{0,1}}],{VGS,0,4},
	PlotRange->{-0.05m,0.55m},
	FrameTicks->{xTicks[{0,4,1},{2,1}],xTicksProp[{0,0.5,0.1},{2,1},m]},
	GridLines->{xGrids[{0,4,0.5}],xGrids[{0.0m,0.5m,0.05m}]},
	PlotStyle->{Black,Directive[{Gray,Dashed}]},
	Epilog->{
		Dashed,Gray,Thickness[0.002],
		Line[{{VTH,-0.05m},{VTH,1.15m}}]//.listVal,
		Text[xLaTeX["\\textcolor{gray}{V_{TH}}",0.9],{VTH-0.18,0.475m}]//.listVal
	},
	PlotLegends->Placed[LineLegend[
		{xLaTeX["V_{DS}=0\\si{V}",0.8],xLaTeX["V_{DS}=1\\si{V}",0.8]},
		LegendFunction->"Panel",
		LegendLayout -> {"Column",1}],{Center,Top}],
	Evaluate@xFigConfig,
	Evaluate@xFigLabel["V_{GS}~(\\si{V})","g_O~(\\si{mS})"]]
fig8b=Plot[Evaluate@Table[Simplify@Piecewise[{{xgo^(-1),VGS>VTH},{100k,True}}]//.listValSTD,{VDS,{0,1}}],{VGS,0,4},
	PlotRange->{-5k,55k},
	Exclusions->None,
	FrameTicks->{xTicks[{0,4,1},{2,1}],xTicksProp[{0,50,10},{2,1},k]},
	GridLines->{xGrids[{0,4,0.5}],xGrids[{0k,50k,5k}]},
	PlotStyle->{Black,Directive[{Gray,Dashed}]},
	Epilog->{
		Dashed,Gray,Thickness[0.002],
		Line[{{VTH,-5k},{VTH,55k}}]//.listVal,
		Text[xLaTeX["\\textcolor{gray}{V_{TH}}",0.9],{VTH-0.18,47.5k}]//.listVal
	},
	PlotLegends->Placed[LineLegend[
		{xLaTeX["V_{DS}=0\\si{V}",0.8],xLaTeX["V_{DS}=1\\si{V}",0.8]},
		LegendFunction->"Panel",
		LegendLayout -> {"Column",1}],{Right,Top}],
	Evaluate@xFigConfig,
	Evaluate@xFigLabel["V_{GS}~(\\si{V})","r_O~(\\si{k\\ohm})"]]


fig8c=Plot[Evaluate@Table[xgm//.listValSTD,{VDS,{4,3}}],{VGS,0,4},
	PlotRange->{-0.05m,0.55m},
	FrameTicks->{xTicks[{0,4,1},{2,1}],xTicksProp[{0,0.5,0.1},{2,1},m]},
	GridLines->{xGrids[{0,4,0.5}],xGrids[{0.0m,0.5m,0.05m}]},
	PlotStyle->{Black,Directive[{Gray,Dashed}]},
	PlotLegends->Placed[LineLegend[
		{xLaTeX["V_{DS}=4\\si{V}",0.8],xLaTeX["V_{DS}=3\\si{V}",0.8]},
		LegendFunction->"Panel",
		LegendLayout -> {"Column",1}],{Center,Top}],
	Epilog->{
		Dashed,Gray,Thickness[0.002],
		Line[{{VTH,-0.05m},{VTH,1.15m}}]//.listVal,
		Text[xLaTeX["\\textcolor{gray}{V_{TH}}",0.9],{VTH-0.18,0.475m}]//.listVal
	},
	Evaluate@xFigConfig,
	Evaluate@xFigLabel["V_{GS}~(\\si{V})","g_m~(\\si{mS})"]]


fig9a=Plot[Evaluate@Table[xgo//.listValLAM,{VDS,{4,3}}],{VGS,0,4},
	PlotRange->{-0.05m,0.55m},
	FrameTicks->{xTicks[{0,4,1},{2,1}],xTicksProp[{0,0.5,0.1},{2,1},m]},
	GridLines->{xGrids[{0,4,0.5}],xGrids[{0.0m,0.5m,0.05m}]},
	PlotStyle->{Black,Directive[{Gray,Dashed}]},
	PlotLegends->Placed[LineLegend[
		{xLaTeX["V_{DS}=4\\si{V}",0.8],xLaTeX["V_{DS}=3\\si{V}",0.8]},
		LegendFunction->"Panel",
		LegendLayout -> {"Column",1}],{Center,Top}],
	Epilog->{
		Dashed,Gray,Thickness[0.002],
		Line[{{VTH,-0.05m},{VTH,1.15m}}]//.listVal,
		Text[xLaTeX["\\textcolor{gray}{V_{TH}}",0.9],{VTH-0.18,0.475m}]//.listVal
	},
	Evaluate@xFigConfig,
	Evaluate@xFigLabel["V_{GS}~(\\si{V})","g_O~(\\si{mS})"]]
fig9b=Plot[Evaluate@Table[Simplify@Piecewise[{{xgo^(-1),VGS>VTH},{10M,True}}]//.listValLAM,{VDS,{4,3}}],{VGS,0,4},
	PlotRange->{-50k,550k},
	Exclusions->None,
	FrameTicks->{xTicks[{0,4,1},{2,1}],xTicksProp[{0,500,100},{2,1},k]},
	GridLines->{xGrids[{0,4,0.5}],xGrids[{0k,500k,50k}]},
	PlotStyle->{Black,Directive[{Gray,Dashed}]},
	PlotLegends->Placed[LineLegend[
		{xLaTeX["V_{DS}=4\\si{V}",0.8],xLaTeX["V_{DS}=3\\si{V}",0.8]},
		LegendFunction->"Panel",
		LegendLayout -> {"Column",1}],{Right,Top}],
	Epilog->{
		Dashed,Gray,Thickness[0.002],
		Line[{{VTH,-50k},{VTH,550k}}]//.listVal,
		Text[xLaTeX["\\textcolor{gray}{V_{TH}}",0.9],{VTH-0.18,475k}]//.listVal
	},
	Evaluate@xFigConfig,
	Evaluate@xFigLabel["V_{GS}~(\\si{V})","r_O~(\\si{k\\ohm})"]]


fig10=Plot[xVTHBody//.listVal,{VBS,-4,+1},
	PlotStyle->Black,
	FrameTicks->{xTicks[{-4,+4,1},{2,1}],xTicks[{0.3,1.3,0.1},{2,1}]},
	GridLines->{xGrids[{-4,1,0.5}],xGrids[{0.3,1.3,0.05}]},
	Epilog->{
		Text[xLaTeX["V_{TH0}=0.7\\si{V}",0.9],{-0.55,-0.05+xVTHBody//.listVal//.{VBS->0}}],
		Black,PointSize[0.015],Point[{0,xVTHBody//.listVal//.{VBS->0}}],
		White,PointSize[0.010],Point[{0,xVTHBody//.listVal//.{VBS->0}}]
	},
	Evaluate@xFigLabel["V_{BS}~(\\si{V})","V_{TH}~(\\si{V})"],
	Evaluate@xFigConfig]


xeta//.listVal//.{VBS->0}


fig11=Plot[xeta//.listVal,{VBS,-4,+1},
	PlotStyle->Black,
	PlotRange->{0,1},
	FrameTicks->{xTicks[{-4,1,1},{2,1}],xTicks[{0.0,1.0,0.1},{2,1}]},
	GridLines->{xGrids[{-4,1,0.5}],xGrids[{0.0,1.0,0.1}]},
	Epilog->{
		Text[xLaTeX["\\eta=0.237",0.9],{-0.5,0.02+xeta//.listVal//.{VBS->0}}],
		Black,PointSize[0.015],Point[{0,xeta//.listVal//.{VBS->0}}],
		White,PointSize[0.010],Point[{0,xeta//.listVal//.{VBS->0}}]
	},
	Evaluate@xFigLabel["V_{BS}~(\\si{V})","\\eta=g_{mb}/g_m"],
	Evaluate@xFigConfig]


fig={fig1a,fig2a,fig3a,fig1b,fig2b,fig3b,fig4a,fig4b,fig5a,fig5b,fig6a,fig6b,fig7a,fig7b,fig8a,fig8b,fig8c,fig9a,fig9b,fig10,fig11}


figWithName=Transpose[{fig,nbPDFNameList[[1;;Length[fig]]]}];
ReleaseHold[(Hold[Export[#[[2]],#[[1]],ImageResolution->2000]]&)/@figWithName]
