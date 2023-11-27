#!/usr/bin/env wolframscript
(* ::Package:: *)

ClearAll["Global`*"]


SetDirectory[NotebookDirectory[]];
Needs["MaTeX`"];


nbFileName="Chapter03A_05.fig.wls";
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


xIDRD=(VDD-Vout)/RD


xVTH=VTH0+gamma(Sqrt[2PhiF-VBS]-Sqrt[2PhiF]);
xeta=-D[xVTH,VBS];


listTransN={VDS->Vout-ID RS,VGS->Vin-ID RS,VTH->VTH0N,lambda->0,mu->muN,WLr->WLrN,ID->xIDRD};


xVoutsat=FullSimplify[Vout//.Solve[(xIDsat//.listTransN)==(xIDRD),Vout][[2]]];
xVoutlin=FullSimplify[Vout//.Solve[(xIDlin//.listTransN)==(xIDRD),Vout][[2]]];
xVin1=Re[FullSimplify[Vin1//.Solve[((xIDsat//.listTransN)==(xIDRD))//.{Vin->Vin1,Vout->Vin1-VTH0N},Vin1]][[2]]];
listVin={Vin1->xVin1};
xVout=Piecewise[{
	{xVDD,0<Vin<=VTH0N},
	{xVoutsat,VTH0N<Vin<=Vin1},
	{xVoutlin,Vin1<Vin<=VDD}
}];


xAV=D[xVout,Vin];
xAVsat=D[xVoutsat,Vin];


xVin1//.Join[listVal,listVin]//.{RD->10k,WLrN->1,RS->40k}


xVout//.Join[listVal,listVin]//.{RD->10k,WLrN->1,RS->20k,Vin->3.8}


listRS={0.001k,20k,40k,80k,160k,320k};


listPlotVal={RD->80.001k,WLrN->1}


listRS[[1;;4]]


{VTH0N,Vin1}//.Join[listVin,listVal,listPlotVal]


Text[xLaTeX["V_{in1}",1],{85k,0.25+Vin1//.Join[listVin,listVal,listPlotVal]}]


fig1=Plot[Evaluate[{VTH0N,Vin1}//.Join[listVin,listVal,listPlotVal]],{RS,0,200k},
	PlotRange->{-0.25,4.25},
	PlotStyle->{Blue,Red},
	FrameTicks->{xTicksProp[{0,200,20},{3,0},k],xTicks[{0,4,1},{1,0}]},
	GridLines->{xGrids[{0,200k,20k}],xGrids[{0,4,0.5}]},
	Epilog->{
		Text[xText["\:9971\:548c\:533a",10],{40k,1.3}],
		Text[xText["\:7ebf\:6027\:533a",10],{40k,3.25}],
		Text[xText["\:622a\:6b62\:533a",10],{40k,0.4}],
		Text[xLaTeX["V_{in1}",1],{170k,0.25+Vin1//.Join[{RS->170k},listVin,listVal,listPlotVal]}],
		Text[xLaTeX["V_{TH}",1],{170k,-0.25+VTH0N//.Join[{RS->170k},listVin,listVal,listPlotVal]}]
	},
	Filling->{1->{2}},
	FillingStyle->{Directive[Black,Opacity[0.1]]},
	Evaluate@xFigConfig,
	Evaluate@xFigLabel["R_S~(\\si{k\\ohm})","V_{TH}, V_{in1}~(\\si{V})"]]


pointList2A=Point[{VTH0N,VDD}]//.Join[listVin,listVal];
pointList2B=Table[Point[{Vin1,xVoutsat//.{Vin->Vin1}}]//.Join[listVin,listVal,listPlotVal],{RS,listRS[[1;;6]]}];
fig2=Plot[Evaluate[Table[Re[xVout]//.Join[listVin,listVal,listPlotVal],{RS,listRS}]],{Vin,0,xVDD},
	PlotPoints->500,
	PlotRange->{-0.25,xVDD+0.25},
	GridLines->{xGrids[{0,4,0.5}],xGrids[{0,4,0.5}]},
	FrameTicks->{xTicks[{0,4,1},{1,0}],xTicks[{0,4,1},{1,0}]},
	Epilog->{
		Blue,PointSize[0.015],Evaluate@pointList2A,
		White,PointSize[0.010],Evaluate@pointList2A,
		Red,PointSize[0.015],Evaluate@pointList2B,
		White,PointSize[0.010],Evaluate@pointList2B,
		Text[xLaTeX["\\textcolor{blue}{V_{TH}}",0.8],{0.70,3.75}],
		Text[xLaTeX["\\textcolor{red}{V_{in1}}",0.8],{2.25,1.75}],
		Text[xLaTeX["R_D=80\\si{k\\ohm}",0.8],{3.5,1.7}]
	},
	PlotLegends->Placed[LineLegend[{
		xLaTeX["R_S=0\\si{k\\ohm}",0.8],
		xLaTeX["R_S=20\\si{k\\ohm}",0.8],
		xLaTeX["R_S=40\\si{k\\ohm}",0.8],
		xLaTeX["R_S=80\\si{k\\ohm}",0.8],
		xLaTeX["R_S=160\\si{k\\ohm}",0.8],
		xLaTeX["R_S=320\\si{k\\ohm}",0.8]},
		LegendFunction->"Panel",
		LegendLayout -> {"Column",1}],{Left,Bottom}],
	Evaluate@xFigLabel["V_{in}~(\\si{V})","V_{out}~(\\si{V})"],
	Evaluate@xFigConfig]


pointList3A=Point[{VTH0N,0}]//.Join[listVin,listVal];
pointList3B=Table[Point[{Vin1,xAV//.{Vin->Vin1}}]//.Join[listVin,listVal,listPlotVal],{RS,listRS[[1;;6]]}];
fig3=Plot[Evaluate[Table[Re[xAV]//.Join[listVin,listVal,listPlotVal],{RS,listRS}]],{Vin,0,xVDD},
	PlotRange->{-10.5,0.5},PlotPoints->2000,Exclusions->"Discontinuities",
	GridLines->{xGrids[{0,4,0.5}],xGrids[{-10,0,1}]},
	FrameTicks->{xTicks[{0,4,1},{1,0}],xTicks[{-10,0,2},{1,0}]},
	Epilog->{
		Blue,PointSize[0.015],Evaluate@pointList3A,
		White,PointSize[0.010],Evaluate@pointList3A,
		Red,PointSize[0.015],Evaluate@pointList3B,
		White,PointSize[0.010],Evaluate@pointList3B,
		Text[xLaTeX["R_D=80\\si{k\\ohm}",0.8],{0.5,-8.5}],
		Text[xLaTeX["\\textcolor{blue}{V_{TH}}",0.8],{xVTH0N-0.15,-0.5}],
		Text[xLaTeX["\\textcolor{red}{V_{in1}}",0.8],{1.65,-8.5}],
	},
	PlotLegends->Placed[LineLegend[{
		xLaTeX["R_S=0\\si{k\\ohm}",0.8],
		xLaTeX["R_S=20\\si{k\\ohm}",0.8],
		xLaTeX["R_S=40\\si{k\\ohm}",0.8],
		xLaTeX["R_S=80\\si{k\\ohm}",0.8],
		xLaTeX["R_S=160\\si{k\\ohm}",0.8],
		xLaTeX["R_S=320\\si{k\\ohm}",0.8]},
		LegendFunction->"Panel",
		LegendLayout -> {"Column",1}],{Right,Bottom}],
	Exclusions->None,
	Evaluate@xFigLabel["V_{in}~(\\si{V})","A_V"],
	Evaluate@xFigConfig]


fig={fig1,fig2,fig3}


figWithName=Transpose[{fig,nbPDFNameList[[1;;Length[fig]]]}];
ReleaseHold[(Hold[Export[#[[2]],#[[1]],ImageResolution->2000]]&)/@figWithName]
