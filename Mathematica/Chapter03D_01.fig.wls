#!/usr/bin/env wolframscript
(* ::Package:: *)

ClearAll["Global`*"]


SetDirectory[NotebookDirectory[]];
Needs["MaTeX`"];


nbFileName="Chapter03D_01.fig.wls";
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


xIR=(VDD-Vout)/RD;


xVTH=VTH0+gamma(Sqrt[2PhiF-VBS]-Sqrt[2PhiF]);


ltBase={lambda->0,gamma->0,mu->muN,WLr->1,VTH->xVTH,VTH0->VTH0N};
ltM1=Join[ltBase,{VGS->Vin,VDS->VX,VBS->0}];
ltM2=Join[ltBase,{VGS->Vb-VX,VDS->Vout-VX,VBS->-VX}];


xIDlinM1=xIDlin//.ltM1;
xIDlinM2=xIDlin//.ltM2;
xIDsatM1=xIDsat//.ltM1;
xIDsatM2=xIDsat//.ltM2;


lVb={1.00 xVDD,0.75 xVDD,0.50 xVDD};
lRD={1k,2k,4k,8k,16k,32k};


(xIDsatM1==xIDsatM2==xIR)//.Join[listVal,{RD->1k}]


solSS=FullSimplify@Solve[{xIDsatM1==xIDsatM2==xIR},{VX,Vout}][[1]];
solSL=FullSimplify@Solve[{xIDsatM1==xIDlinM2==xIR},{VX,Vout}][[1]];
solLS=FullSimplify@Solve[{xIDlinM1==xIDsatM2==xIR},{VX,Vout}][[1]];
solLL=Solve[{xIDlinM1==xIDlinM2==xIR},{VX,Vout}][[4]];


(VX-Vin==VTH)//.solSS


solVin1=FullSimplify@Solve[(VX-Vin==-VTH)//.solSS,{Vin}][[1]];
solVin2=FullSimplify@Solve[(Vout-Vb==-VTH)//.solSS,{Vin}][[2]];
solVin1l=Solve[(VX-Vin==-VTH)//.solSL,{Vin}][[2]];
solVin2l=Solve[(Vout-Vb==-VTH)//.solLS,{Vin}][[2]];
xVin1=Vin//.solVin1;
xVin2=Vin//.solVin2;
xVin1l=Vin//.solVin1l;
xVin2l=Vin//.solVin2l;
Evaluate@Table[{xVin1,xVin2,xVin1l,xVin2l}//.Join[listVal,ltBase,{Vb->xVDD}],{RD,lRD}]


Plot[Evaluate[{xVin1,xVin2,xVin1l,xVin2l}//.Join[listVal,ltBase,{Vb->xVDD}]],{RD,0,50k},PlotRange->{0,xVDD},Evaluate@xFigConfig]


A=Simplify[Vout//.solLL]


A


xVout=Piecewise[{
	{VDD,0<=Vin<VTH},
	{Vout//.solSS,VTH<=Vin<Min[xVin1,xVin2]},
	{Vout//.solLS,xVin1<xVin2 && xVin1<=Vin<VDD},
	{Vout//.solSL,xVin1>xVin2 && xVin2<=Vin<VDD}
}]//.ltBase;


xVout//.Join[listVal,{RD->4k,Vb->xVDD,Vin->3.9}]


Plot[Evaluate@Table[xVout//.Join[listVal,{Vb->xVDD}],{RD,lRD}],{Vin,0,xVDD},Evaluate@xFigConfig,PlotRange->{0,4},PlotPoints->10,MaxRecursion->1]


xVoutlin=FullSimplify[Vout//.Solve[(xIDlin//.listTransN)==(xIDRD),Vout][[1]]];
xVoutsat=FullSimplify[Vout//.Solve[(xIDsat//.listTransN)==(xIDRD),Vout][[1]]];
xVin1=FullSimplify[Vin1//.Solve[(xIDsat==xIDRD)//.Join[listTransN,{Vout->Vb-VTH,Vin->Vin1}],Vin1][[1]]];
xVout=Piecewise[{
	{xVoutlin,0<Vin<=Vin1},
	{xVoutsat,Vin1<Vin<=Vb-VTH},
	{xVDD,Vb-VTH<Vin<=VDD}
}];


xAV=D[xVout,Vin];
xAVsat=D[xVoutsat,Vin];


listRD={1k,2k,4k,8k,16k,32k,64k};


listPlotVal={WLrN->1,Vb->xVDD,Vin1->xVin1};
listFig=Join[listVal,listTransN,listPlotVal];


fig1=Plot[Evaluate[{VDD-VTH,Vin1}//.listFig],{RD,0k,100k},
	PlotRange->{-0.25,4+0.25},
	PlotStyle->{Blue,Red},
	FrameTicks->{xTicksProp[{0,100,20},{3,0},k],xTicks[{0,4,1},{1,0}]},
	GridLines->{xGrids[{0,100k,20k}],xGrids[{0,4,0.5}]},
	Epilog->{
		Text[xText["\:9971\:548c\:533a",10],{30k,1.75}],
		Text[xText["\:7ebf\:6027\:533a",10],{30k,3.00}],
		Text[xText["\:622a\:6b62\:533a",10],{30k,3.75}],
		Text[xLaTeX["V_{in1}",1],{90k,2.6}],
		Text[xLaTeX["V_{TH}",1],{90k,3.6}]
	},
	Filling->{1->{2}},
	FillingStyle->{Directive[Black,Opacity[0.1]]},
	Evaluate@xFigConfig,
	Evaluate@xFigLabel["R_D~(\\si{k\\ohm})","V_{in1}, V_{TH}~(\\si{V})"]]


fig2Func=Re[xVout]//.listFig;
pointList2A=Point[{Vb-VTH0N,VDD}]//.listFig;
pointList2B=Table[Point[{Vin1,xVoutsat}//.Join[listFig,{Vin->xVin1}]],{RD,listRD}];
pointList2=Join[{pointList2A},pointList2B];
fig2=Plot[Evaluate[Table[fig2Func,{RD,listRD}]],{Vin,0,xVDD},
	PlotPoints->500,Exclusions->None,
	PlotRange->{-0.25,xVDD+0.25},
	GridLines->{xGrids[{0,4,0.5}],xGrids[{0,4,0.5}]},
	FrameTicks->{xTicks[{0,4,1},{1,0}],xTicks[{0,4,1},{1,0}]},
	Epilog->{
		PointSize[0.015],
		Blue,Evaluate@pointList2A,
		Red ,Evaluate@pointList2B,
		PointSize[0.010],White,pointList2,
		Text[xLaTeX["\\textcolor{blue}{V_{TH}}",0.8],{3.3,3.7}],
		Text[xLaTeX["\\textcolor{red}{V_{in1}}",0.8],{0.3,3.15}]
	},
	PlotLegends->Placed[LineLegend[{
		xLaTeX["R_D=1\\si{k\\ohm}",0.8],
		xLaTeX["R_D=2\\si{k\\ohm}",0.8],
		xLaTeX["R_D=4\\si{k\\ohm}",0.8],
		xLaTeX["R_D=8\\si{k\\ohm}",0.8],
		xLaTeX["R_D=16\\si{k\\ohm}",0.8],
		xLaTeX["R_D=32\\si{k\\ohm}",0.8]},
		LegendFunction->"Panel",
		LegendLayout -> {"Column",2}],{Right,Bottom}],
	Evaluate@xFigLabel["V_{in}~(\\si{V})","V_{out}~(\\si{V})"],
	Evaluate@xFigConfig]


fig3Func=Re[xAV]//.listFig;
pointList3A=Point[{Vb-VTH0N,0}]//.listFig;
pointList3B=Table[Point[{Vin1,xAV}//.Join[listFig,{Vin->xVin1}]],{RD,listRD}];
pointList3=Join[{pointList3A},pointList3B];
fig3=Plot[Evaluate[Table[fig3Func,{RD,listRD}]],{Vin,0,xVDD},
	PlotPoints->500,Exclusions->None,
	PlotRange->{-0.25,xVDD+0.25},
	GridLines->{xGrids[{0,4,0.5}],xGrids[{0,4,0.5}]},
	FrameTicks->{xTicks[{0,4,1},{1,0}],xTicks[{0,4,1},{1,0}]},
	Epilog->{
		PointSize[0.015],
		Blue,Evaluate@pointList3A,
		Red ,Evaluate@pointList3B,
		PointSize[0.010],White,pointList3,
		Text[xLaTeX["\\textcolor{blue}{V_{TH}}",0.8],{3.45,0.25}],
		Text[xLaTeX["\\textcolor{red}{V_{in1}}",0.8],{2.90,3.75}]
	},
	PlotLegends->Placed[LineLegend[{
		xLaTeX["R_D=1\\si{k\\ohm}",0.8],
		xLaTeX["R_D=2\\si{k\\ohm}",0.8],
		xLaTeX["R_D=4\\si{k\\ohm}",0.8],
		xLaTeX["R_D=8\\si{k\\ohm}",0.8],
		xLaTeX["R_D=16\\si{k\\ohm}",0.8],
		xLaTeX["R_D=32\\si{k\\ohm}",0.8]},
		LegendFunction->"Panel",
		LegendLayout -> {"Column",2}],{Left,Top}],
	Evaluate@xFigLabel["V_{in}~(\\si{V})","A_V"],
	Evaluate@xFigConfig]


fig={fig1,fig2,fig3}


figWithName=Transpose[{fig,nbPDFNameList[[1;;Length[fig]]]}];
ReleaseHold[(Hold[Export[#[[2]],#[[1]],ImageResolution->2000]]&)/@figWithName]
