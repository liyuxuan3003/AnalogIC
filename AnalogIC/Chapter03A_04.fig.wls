#!/usr/bin/env wolframscript
(* ::Package:: *)

ClearAll["Global`*"]


SetDirectory[NotebookDirectory[]];
Needs["MaTeX`"];


nbFileName="Chapter03A_04.fig.wls";
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
listValBase={kB->xkB,q->xq,T->xT,VT->xVT,tox->xtox,eox->xeox,e0->xe0,Cox->xCox,alpha->xalpha,xi->xxi};


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


listVal={kB->xkB,q->xq,T->xT,VT->xVT,tox->xtox,eox->xeox,e0->xe0,Cox->xCox,alpha->xalpha,xi->xxi,
	VTH0N->xVTH0N,muN->xmuN,lambdaN->xlambdaN,gammaN->xgammaN,PhiFN->xPhiFN,
	VTH0P->xVTH0P,muP->xmuP,lambdaP->xlambdaP,gammaP->xgammaP,PhiFP->xPhiFP
};


xIDoff=0;
xIDlin=mu Cox WLr((VGS-VTH)VDS-VDS^2/2)(1+lambda VDS);
xIDsat=mu Cox WLr((VGS-VTH)^2/2)(1+lambda VDS);
xIDN=Piecewise[{
	{xIDoff,VGS<=VTH},
	{xIDlin,VGS>VTH && VDS<=VGS-VTH},
	{xIDsat,VGS>VTH && VDS>VGS-VTH}
}];
xIDP=Piecewise[{
	{-xIDoff,VGS>=VTH},
	{-xIDlin,VGS<VTH && VDS>=VGS-VTH},
	{-xIDsat,VGS<VTH && VDS<VGS-VTH}
}];


xVTH=VTH0+gamma(Sqrt[2PhiF-VBS]-Sqrt[2PhiF]);
xeta=-D[xVTH,VBS];


xVDD=4;


listTransN={VDS->Vout,VGS->Vin,VTH->VTH0N,lambda->lambdaN,mu->muN,WLr->WLrN};
listTransP={VDS->Vout-VDD,VGS->Vin-VDD,VTH->VTH0P,lambda->lambdaP,mu->muP,WLr->WLrP};


xVoutSL=Vout//.Solve[(xIDsat//.listTransN)==(xIDlin//.listTransP),Vout][[3]];
xVoutSS=Vout//.Solve[(xIDsat//.listTransN)==(xIDsat//.listTransP),Vout][[1]];
xVoutLS=Vout//.Solve[(xIDlin//.listTransN)==(xIDsat//.listTransP),Vout][[3]];
xVin1=Re[Vin1//.Solve[((xIDsat//.listTransN)==(xIDsat//.listTransP))//.{Vin->Vin1,Vout->Vin1-VTH0P},Vin1][[1]]];
xVin2=Re[Vin2//.Solve[((xIDsat//.listTransN)==(xIDsat//.listTransP))//.{Vin->Vin2,Vout->Vin2-VTH0N},Vin2][[1]]];
listVin={Vin1->xVin1,Vin2->xVin2,VDD->xVDD};
xVout=Piecewise[{
	{xVDD,0<Vin<=VTH0N},
	{xVoutSL,VTH0N<Vin<=Vin1},
	{xVoutSS,Vin1<Vin<=Vin2},
	{xVoutLS,Vin2<Vin<=VDD+VTH0P},
	{0,VDD+VTH0P<Vin<=VDD}
}];
{Vin1,Vin2}//.Join[listVin,listVal,{WLrN->1,WLrP->1}]


xAV=D[xVout,Vin];
xAVsat=D[xVoutSS,Vin];


listWL={{WLrN->4,WLrP->1},{WLrN->1,WLrP->1},{WLrN->1,WLrP->4}};


fig1=Plot[Evaluate[{VTH0N,Vin1,Vin2,VDD+VTH0P}//.Join[listVin,listVal,{WLrN->1}]],{WLrP,0,4},
	PlotRange->{-0.25,xVDD+0.25},
	PlotPoints->500,
	PlotStyle->{Blue,Blend[{Blue,White},0.5],Blend[{Red,White},0.5],Red},
	FrameTicks->{xTicks[{0,4,1},{1,9}],xTicks[{0,4,1},{1,0}]},
	GridLines->{xGrids[{0,4,0.25}],xGrids[{0,4,0.5}]},
	Epilog->{
		Text[xText["NMOS\:7ebf\:6027  PMOS\:622a\:6b62",8],{2,3.7}],
		Text[xText["NMOS\:7ebf\:6027  PMOS\:9971\:548c",8],{2,2.75}],
		Text[xText["NMOS\:9971\:548c  PMOS\:7ebf\:6027",8],{2,1.25}],
		Text[xText["NMOS\:622a\:6b62  PMOS\:7ebf\:6027",8],{2,0.3}],
		Text[Style[xText["NMOS\:9971\:548c  PMOS\:9971\:548c",10],Red],{1,2.3}],
		Arrowheads[0.02],Thickness[0.002],Red,
		Arrow[{{1,2.1},{1,1.62}}],
		Text[xLaTeX["V_{THP}",1],{3.5,+0.2+xVDD+xVTH0P}],
		Text[xLaTeX["V_{inP}",1],{3.5,2.25}],
		Text[xLaTeX["V_{inN}",1],{3.5,1.70}],
		Text[xLaTeX["V_{THN}",1],{3.5,-0.2+xVTH0N}]
	},
	Filling->{2->{3}},
	FillingStyle->{Directive[Red,Opacity[0.1]]},
	Evaluate@xFigConfig,
	Evaluate@xFigLabel["(W/L)_1/(W/L)_2","V_{TH}, V_{in1}~(\\si{V})"]]


pointList2A=Point[{VTH0N,VDD}]//.Join[listVin,listVal]/.listWL;
pointList2B=Point[{Vin1,xVoutSS}]//.Join[listVin,listVal,{Vin->Vin1}]/.listWL;
pointList2C=Point[{Vin2,xVoutSS}]//.Join[listVin,listVal,{Vin->Vin2}]/.listWL;
pointList2D=Point[{VDD+VTH0P,0}]//.Join[listVin,listVal]/.listWL;
fig2=Plot[Evaluate[Re[xVout]//.Join[listVin,listVal]/.listWL],{Vin,0,xVDD},
	PlotPoints->500,
	PlotRange->{-0.25,xVDD+0.25},
	GridLines->{xGrids[{0,4,0.5}],xGrids[{0,4,0.5}]},
	FrameTicks->{xTicks[{0,4,1},{1,0}],xTicks[{0,4,1},{1,0}]},
	Epilog->{
		Blue,PointSize[0.015],Evaluate@pointList2A,
		White,PointSize[0.010],Evaluate@pointList2A,
		Blend[{Blue,White},0.5],PointSize[0.015],Evaluate@pointList2B,
		White,PointSize[0.010],Evaluate@pointList2B,
		Blend[{Red,White},0.5],PointSize[0.015],Evaluate@pointList2C,
		White,PointSize[0.010],Evaluate@pointList2C,
		Red,PointSize[0.015],Evaluate@pointList2D,
		White,PointSize[0.010],Evaluate@pointList2D
	},
	PlotLegends->Placed[LineLegend[{
		xLaTeX["(W/L)_1/(W/L)_2=4.00",0.8],
		xLaTeX["(W/L)_1/(W/L)_2=1.00",0.8],
		xLaTeX["(W/L)_1/(W/L)_2=0.25",0.8]},
		LegendFunction->"Panel",
		LegendLayout -> {"Column",1}],{Right,Top}],
	Evaluate@xFigLabel["V_{in}~(\\si{V})","V_{out}~(\\si{V})"],
	Evaluate@xFigConfig]


pointList3A=Point[{VTH0N,0}]//.Join[listVin,listVal]/.listWL;
pointList3B=Point[{Vin1,xAVsat}]//.Join[listVin,listVal,{Vin->Vin1}]/.listWL;
pointList3C=Point[{Vin2,xAVsat}]//.Join[listVin,listVal,{Vin->Vin2}]/.listWL;
pointList3D=Point[{VDD+VTH0P,0}]//.Join[listVin,listVal]/.listWL;
fig3=Plot[Evaluate[Re[xAV]//.Join[listVin,listVal]/.listWL],{Vin,0,xVDD},
	PlotRange->{-27,2},PlotPoints->2000,Exclusions->"Discontinuities",
	GridLines->{xGrids[{0,4,0.5}],xGrids[{-25,0,5}]},
	FrameTicks->{xTicks[{0,4,1},{1,0}],xTicks[{-25,0,5},{2,0}]},
	Epilog->{
		Blue,PointSize[0.015],Evaluate@pointList3A,
		White,PointSize[0.010],Evaluate@pointList3A,
		Blend[{Blue,White},0.5],PointSize[0.015],Evaluate@pointList3B,
		White,PointSize[0.010],Evaluate@pointList3B,
		Blend[{Red,White},0.5],PointSize[0.015],Evaluate@pointList3C,
		White,PointSize[0.010],Evaluate@pointList3C,
		Red,PointSize[0.015],Evaluate@pointList3D,
		White,PointSize[0.010],Evaluate@pointList3D,
	},
	PlotLegends->Placed[LineLegend[{
		xLaTeX["(W/L)_1/(W/L)_2=4.00",0.8],
		xLaTeX["(W/L)_1/(W/L)_2=1.00",0.8],
		xLaTeX["(W/L)_1/(W/L)_2=0.25",0.8]},
		LegendFunction->"Panel",
		LegendLayout -> {"Column",1}],{Right,Bottom}],
	Exclusions->None,
	Evaluate@xFigLabel["V_{in}~(\\si{V})","A_V"],
	Evaluate@xFigConfig]


fig={fig1,fig2,fig3}


figWithName=Transpose[{fig,nbPDFNameList[[1;;Length[fig]]]}];
ReleaseHold[(Hold[Export[#[[2]],#[[1]],ImageResolution->2000]]&)/@figWithName]
