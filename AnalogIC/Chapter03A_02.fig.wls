#!/usr/bin/env wolframscript
(* ::Package:: *)

ClearAll["Global`*"]


SetDirectory[NotebookDirectory[]];
Needs["MaTeX`"];


nbFileName="Chapter03A_02.fig.wls";
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


xVTH0=0.7;
xkB=1.3806488 10^(-23);
xq=1.602176565 10^(-19);
xT=300;
xVT=(kB T)/q;
xtox=9 10^(-9);
xeox=3.9;
xe0=8.854187817 10^(-12);
xCox=eox e0/tox;
xmu=350 100^(-2);
xWLr=1;
xlambda=0.1;
xalpha=2 mu Cox (xi VT)^2/Exp[2];
xxi=1.5;
xgamma=0.45
xPhiF=0.9/2
xVDD=4
listVal={VTH0->xVTH0,kB->xkB,q->xq,T->xT,VT->xVT,
	tox->xtox,eox->xeox,e0->xe0,Cox->xCox,
	mu->xmu,WLr->xWLr,alpha->xalpha,xi->xxi,
	gamma->xgamma,PhiF->xPhiF,VDD->xVDD};
listValSTD=Join[listVal,{lambda->0}];
listValLAM=Join[listVal,{lambda->xlambda}];


xIDoff=0;
xIDlin=mu Cox WLr((VGS-VTH)VDS-VDS^2/2)(1+lambda VDS);
xIDsat=mu Cox WLr((VGS-VTH)^2/2)(1+lambda VDS);
xID=Piecewise[{
	{xIDoff,VGS<=VTH},
	{xIDlin,VGS>VTH && VDS<=VGS-VTH},
	{xIDsat,VGS>VTH && VDS>VGS-VTH}
}];


xVTH=Normal@Series[VTH0+gamma(Sqrt[2PhiF-VBS]-Sqrt[2PhiF]),{VBS,0,1}];
xeta=-D[xVTH,VBS];


listTrans1={VDS->Vout,VGS->Vin,VTH->VTH0,lambda->0,WLr->WLr1};
listTrans2={VDS->VDD-Vout,VGS->VDD-Vout,VTH->VTH0,VBS->-Vout,lambda->0,WLr->WLr2};


xVoutsat=Vout//.FullSimplify@Solve[(xIDsat//.listTrans1)==(xIDsat//.listTrans2),Vout][[1]]


xVoutlin=Vout//.FullSimplify@Solve[(xIDlin//.listTrans1)==(xIDsat//.listTrans2),Vout][[1]]


xVin1=Vin1//.FullSimplify@Solve[((xIDsat//.listTrans1)==(xIDsat//.listTrans2))//.{Vout->Vin1-VTH0,Vin->Vin1},Vin1][[2]]


xVout=Piecewise[{
	{xVoutsat//.{Vin->VTH0},0<Vin<=VTH0},
	{xVoutsat,VTH0<Vin<=Vin1},
	{xVoutlin,Vin1<Vin<=VDD}
}];


xAV=D[xVout,Vin]
xAVsat=D[xVoutsat,Vin]


fig1=Plot[Evaluate[{VTH0,Vin1}//.Join[{WLr2->1,Vin1->xVin1},listVal]],{WLr1,0,8},
	PlotRange->{-0.25,4.25},
	PlotStyle->{Blue,Red},
	FrameTicks->{xTicks[{0,8,1},{2,0}],xTicks[{0,4,1},{1,0}]},
	GridLines->{xGrids[{0,8,1}],xGrids[{0,4,0.5}]},
	Epilog->{
		Text[xText["\:9971\:548c\:533a",10],{2.5,1.3}],
		Text[xText["\:7ebf\:6027\:533a",10],{2.5,2.5}],
		Text[xText["\:622a\:6b62\:533a",10],{2.5,0.4}],
		Text[xLaTeX["V_{in1}",1],{6.5,0.2+xVin1//.{WLr2->1,WLr1->6.5,Vin1->xVin1}//.listVal}],
		Text[xLaTeX["V_{TH}",1],{6.5,-0.25+xVTH0//.listVal}]
	},
	Filling->{1->{2}},
	FillingStyle->{Directive[Black,Opacity[0.1]]},
	Evaluate@xFigConfig,
	Evaluate@xFigLabel["(W/L)_1/(W/L)_2","V_{TH}, V_{in1}~(\\si{V})"]]


listWLr={1.001,2,4,8}
listWLropt={1,2,4,8}


pointList2A={Point[{VTH0,VDD-VTH0}//.listVal]}
pointList2B=Table[Point[{Vin,xVoutsat}]//.Join[{WLr2->1,Vin->xVin1},listVal]//.listVal,{WLr1,listWLr}];
Plot[Evaluate@Table[xVout//.Join[{WLr2->1,Vin1->xVin1},listVal],{WLr1,{1.001,2,4,8}}],{Vin,0,VDD//.listVal},
	PlotRange->{-0.25,0.25+VDD//.listVal},
	GridLines->{xGrids[{0,4,0.5}],xGrids[{0,4,0.5}]},
	FrameTicks->{xTicks[{0,4,1},{1,0}],xTicks[{0,4,1},{1,0}]},
	Epilog->{
		Red,PointSize[0.015],Evaluate@pointList2B,
		White,PointSize[0.010],Evaluate@pointList2B,
		Blue,PointSize[0.015],Evaluate@pointList2A,
		White,PointSize[0.010],Evaluate@pointList2A,
		Text[xLaTeX["\\textcolor{blue}{V_{TH}}",0.8],{xVTH0-0.1,3}],
		Text[xLaTeX["\\textcolor{red}{V_{in1}}",0.8],{1.35,0.75}],
		Text[xLaTeX["V_{DD}-V_{TH}",0.8],{0.35,3.5}]
	},
	PlotLegends->Placed[LineLegend[{
		xLaTeX["(W/L)_1/(W/L)_2=1",0.8],
		xLaTeX["(W/L)_1/(W/L)_2=2",0.8],
		xLaTeX["(W/L)_1/(W/L)_2=4",0.8],
		xLaTeX["(W/L)_1/(W/L)_2=8",0.8]},
		LegendFunction->"Panel",
		LegendLayout -> {"Column",1}],{Right,Top}],
	Evaluate@xFigLabel["V_{in}~(\\si{V})","V_{out}~(\\si{V})"],
	Evaluate@xFigConfig]


pointList3B=Table[Point[{Vin,xAVsat}]//.Join[{WLr2->1,Vin->xVin1},listVal]//.listVal,{WLr1,listWLr}]


pointList3A={Point[{VTH0,0}//.listVal]}
pointList3B=Table[Point[{Vin,xAVsat}]//.Join[{WLr2->1,Vin->xVin1},listVal]//.listVal,{WLr1,listWLr}];
Plot[Evaluate@Table[xAV//.Join[{WLr2->1,Vin1->xVin1},listVal],{WLr1,{1.001,2,4,8}}],{Vin,0,VDD//.listVal},
	PlotRange->{-3.25,0.25},
	GridLines->{xGrids[{0,4,0.5}],xGrids[{-3,0,0.5}]},
	FrameTicks->{xTicks[{0,4,1},{1,0}],xTicks[{-3,0,1},{1,0}]},
	Epilog->{
		Red,PointSize[0.015],Evaluate@pointList3B,
		White,PointSize[0.010],Evaluate@pointList3B,
		Blue,PointSize[0.015],Evaluate@pointList3A,
		White,PointSize[0.010],Evaluate@pointList3A,
		Text[xLaTeX["\\textcolor{blue}{V_{TH}}",0.8],{xVTH0+0.17,-0.15}],
		Text[xLaTeX["\\textcolor{red}{V_{in1}}",0.8],{1.76,-2.85}]
	},
	PlotLegends->Placed[LineLegend[{
		xLaTeX["(W/L)_1/(W/L)_2=1",0.8],
		xLaTeX["(W/L)_1/(W/L)_2=2",0.8],
		xLaTeX["(W/L)_1/(W/L)_2=4",0.8],
		xLaTeX["(W/L)_1/(W/L)_2=8",0.8]},
		LegendFunction->"Panel",
		LegendLayout -> {"Column",1}],{Right,Bottom}],
	Exclusions->None,
	Evaluate@xFigLabel["V_{in}~(\\si{V})","A_V"],
	Evaluate@xFigConfig]


fig={}


figWithName=Transpose[{fig,nbPDFNameList[[1;;Length[fig]]]}];
ReleaseHold[(Hold[Export[#[[2]],#[[1]],ImageResolution->2000]]&)/@figWithName]
