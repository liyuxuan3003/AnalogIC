#!/usr/bin/env wolframscript
(* ::Package:: *)

ClearAll["Global`*"]


SetDirectory[NotebookDirectory[]];
Needs["MaTeX`"];


nbFileName="Chapter03A_03.fig.wls";
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
	lambda->xlambda,gamma->xgamma,PhiF->xPhiF,VDD->xVDD};
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


listTrans1={VDS->Vout,VGS->Vin,VTH->VTH0,WLr->1};


xVoutsat=Vout//.FullSimplify@Solve[(xIDsat//.listTrans1)==ID,Vout][[1]]


xVoutlin=Vout//.Solve[(xIDlin//.listTrans1)==ID,Vout][[3]]


xVin1=Re[Vin1//.FullSimplify@Solve[((xIDlin//.listTrans1)==ID)//.{Vout->Vin1-VTH0,Vin->Vin1},Vin1][[1]]]


xVout=Piecewise[{
	{-1,0<Vin<=VTH0},
	{xVoutsat,VTH0<Vin<=Vin1},
	{xVoutlin,Vin1<Vin<=VDD}
}];


xAV=Piecewise[{{10,0<Vin<=VTH0},{D[xVout,Vin],VTH0<=Vin<VDD}}]
xAVsat=D[xVoutsat,Vin]


fig1=Plot[Evaluate[{VTH0,Vin1}//.Join[{Vin1->xVin1},listVal]],{ID,0m,0.5m},
	PlotRange->{-0.25,4+0.25},
	PlotStyle->{Blue,Red},
	FrameTicks->{xTicksProp[{0,0.5,0.1},{2,1},m],xTicks[{0,4,1},{1,0}]},
	GridLines->{xGrids[{0,0.5m,0.1m}],xGrids[{0,4,0.5}]},
	Epilog->{
		Text[xText["\:9971\:548c\:533a",10],{0.15m,1.3}],
		Text[xText["\:7ebf\:6027\:533a",10],{0.15m,2.5}],
		Text[xText["\:622a\:6b62\:533a",10],{0.15m,0.4}],
		Text[xLaTeX["V_{in1}",1],{0.4m,0.25+xVin1//.Join[{ID->0.4m},listVal]}],
		Text[xLaTeX["V_{TH}",1],{0.4m,-0.25+xVTH0//.listVal}]
	},
	Filling->{1->{2}},
	FillingStyle->{Directive[Black,Opacity[0.1]]},
	Evaluate@xFigConfig,
	Evaluate@xFigLabel["(W/L)_1/(W/L)_2","V_{TH}, V_{in1}~(\\si{V})"]]


listID={0.05m,0.10m,0.20m,0.40m}


pointList2B=Table[Point[{Vin,xVoutsat}]//.Join[{Vin->xVin1},listVal],{ID,listID}];
fig2=Plot[Evaluate@Table[xVout//.Join[{Vin1->xVin1},listVal],{ID,listID}],{Vin,0,VDD//.listVal},
	PlotPoints->5000,MaxRecursion->1,
	PlotRange->{-0.25,0.25+VDD//.listVal},
	GridLines->{xGrids[{0,4,0.5}],xGrids[{0,4,0.5}]},
	FrameTicks->{xTicks[{0,4,1},{1,0}],xTicks[{0,4,1},{1,0}]},
	Prolog->{
		Blue,Thin,Dashed,
		Line[{{xVTH0,-1},{xVTH0,+5}}]
	},
	Epilog->{
		Red,PointSize[0.015],Evaluate@pointList2B,
		White,PointSize[0.010],Evaluate@pointList2B,
		Text[xLaTeX["\\textcolor{blue}{V_{TH}}",0.8],{xVTH0+0.17,3.25}],
		Text[xLaTeX["\\textcolor{red}{V_{in1}}",0.8],{3.15,2.25}]
	},
	PlotLegends->Placed[LineLegend[{
		xLaTeX["I_D=0.05\\si{mA}",0.8],
		xLaTeX["I_D=0.10\\si{mA}",0.8],
		xLaTeX["I_D=0.20\\si{mA}",0.8],
		xLaTeX["I_D=0.40\\si{mA}",0.8]},
		LegendFunction->"Panel",
		LegendLayout -> {"Column",1}],{Left,Bottom}],
	Evaluate@xFigLabel["V_{in}~(\\si{V})","V_{out}~(\\si{V})"],
	Evaluate@xFigConfig]


pointList3B=Table[Point[{Vin,xAVsat}]//.Join[{Vin->xVin1},listVal],{ID,listID}];
fig3=Plot[Evaluate@Table[xAV//.Join[{Vin1->xVin1},listVal],{ID,listID}],{Vin,0,VDD//.listVal},
	PlotRange->{-42,2},PlotPoints->2000,Exclusions->"Discontinuities",
	GridLines->{xGrids[{0,4,0.5}],xGrids[{-40,0,5}]},
	FrameTicks->{xTicks[{0,4,1},{1,0}],xTicks[{-40,0,10},{2,0}]},
	Prolog->{
		Blue,Thin,Dashed,
		Line[{{xVTH0,-60},{xVTH0,+50}}]
	},
	Epilog->{
		Red,PointSize[0.015],Evaluate@pointList3B,
		White,PointSize[0.010],Evaluate@pointList3B,
		Text[xLaTeX["\\textcolor{blue}{V_{TH}}",0.8],{xVTH0+0.17,-7.5}],
		Text[xLaTeX["\\textcolor{red}{V_{in1}}",0.8],{3.2,-12}]
	},
	PlotLegends->Placed[LineLegend[{
		xLaTeX["I_D=0.05\\si{mA}",0.8],
		xLaTeX["I_D=0.10\\si{mA}",0.8],
		xLaTeX["I_D=0.20\\si{mA}",0.8],
		xLaTeX["I_D=0.40\\si{mA}",0.8]},
		LegendFunction->"Panel",
		LegendLayout -> {"Column",1}],{Right,Bottom}],
	Exclusions->None,
	Evaluate@xFigLabel["V_{in}~(\\si{V})","A_V"],
	Evaluate@xFigConfig]


fig={fig1,fig2,fig3}


figWithName=Transpose[{fig,nbPDFNameList[[1;;Length[fig]]]}];
ReleaseHold[(Hold[Export[#[[2]],#[[1]],ImageResolution->2000]]&)/@figWithName]
