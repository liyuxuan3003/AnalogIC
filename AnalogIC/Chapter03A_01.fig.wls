#!/usr/bin/env wolframscript
(* ::Package:: *)

ClearAll["Global`*"]


SetDirectory[NotebookDirectory[]];
Needs["MaTeX`"];


nbFileName="Chapter03A_01.fig.wls";
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
xWLr=1;
xlambda=0.1;
xalpha=2 mu Cox (xi VT)^2/Exp[2];
xxi=1.5;
xgamma=0.45
xPhiF=0.9/2
xVDD=4
listVal={VTH0->xVTH0,VTH->xVTH,kB->xkB,q->xq,T->xT,VT->xVT,
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


listTrans={VDS->Vout,VGS->Vin};


xIDr=(VDD-Vout)/RD;


xVin1=FullSimplify[Vin1//.Solve[(xIDsat==xIDr)//.{lambda->0}//.listTrans//.{Vout->Vin1-VTH,Vin->Vin1},Vin1][[2]]]


Series[Sqrt[1+x],{x,0,3}]


xVoutsat=FullSimplify[Vout//.Solve[(xIDsat==xIDr)//.{lambda->0}//.listTrans,Vout][[1]]]


xVoutlin=FullSimplify[Vout//.Solve[(xIDlin==xIDr)//.{lambda->0}//.listTrans,Vout][[1]]]


xVoutoff=VDD


xVout=Piecewise[{
	{xVoutoff,Vin<=VTH},
	{xVoutsat,VTH<Vin<=Vin1},
	{xVoutlin,Vin1<Vin}
}]


xAV=D[xVout,Vin]


xAVsat=D[xVoutsat,Vin]


fig1=Plot[Evaluate[{VTH,xVin1}//.listValSTD],{RD,0,100k},
	PlotRange->{-0.25,4.25},
	PlotStyle->{Blue,Red},
	FrameTicks->{xTicksProp[{0,100,10},{3,0},k],xTicks[{0,4,1},{1,0}]},
	GridLines->{xGrids[{0,100k,10k}],xGrids[{0,4,0.5}]},
	Epilog->{
		Text[xText["\:9971\:548c\:533a",10],{30k,1.3}],
		Text[xText["\:7ebf\:6027\:533a",10],{30k,2.5}],
		Text[xText["\:622a\:6b62\:533a",10],{30k,0.4}],
		Text[xLaTeX["V_{in1}",1],{85k,0.25+xVin1//.{RD->85k}//.listValSTD}],
		Text[xLaTeX["V_{TH}",1],{85k,-0.25+xVTH//.{RD->85k}//.listValSTD}]
	},
	Filling->{1->{2}},
	FillingStyle->{Directive[Black,Opacity[0.1]]},
	Evaluate@xFigConfig,
	Evaluate@xFigLabel["R_D~(\\si{k\\ohm})","V_{TH}, V_{in1}~(\\si{V})"]]


listRD={10k,20k,40k,80k}


pointList2A={Point[{VTH,VDD}//.listVal]}
pointList2B=Table[Point[{Vin,xVoutsat}]//.{Vin->xVin1}//.listVal,{RD,listRD}];
fig2=Plot[Evaluate@Table[xVout//.{Vin1->xVin1}//.listValSTD,{RD,listRD}],{Vin,0,VDD//.listVal},
	PlotRange->{-0.25,4.25},
	GridLines->{xGrids[{0,4,0.5}],xGrids[{0,4,0.5}]},
	FrameTicks->{xTicks[{0,4,1},{1,0}],xTicks[{0,4,1},{1,0}]},
	Epilog->{
		Red,PointSize[0.015],Evaluate@pointList2B,
		White,PointSize[0.010],Evaluate@pointList2B,
		Blue,PointSize[0.015],Evaluate@pointList2A,
		White,PointSize[0.010],Evaluate@pointList2A,
		Text[xLaTeX["\\textcolor{blue}{V_{TH}}",0.8],{xVTH0,3.75}],
		Text[xLaTeX["\\textcolor{red}{V_{in1}}",0.8],{1.25,0.65}],
		Text[xLaTeX["V_{DD}",0.8],{0.2,3.75}]
	},
	PlotLegends->Placed[LineLegend[{
		xLaTeX["R_D=10\\si{k\\ohm}",0.8],
		xLaTeX["R_D=20\\si{k\\ohm}",0.8],
		xLaTeX["R_D=40\\si{k\\ohm}",0.8],
		xLaTeX["R_D=80\\si{k\\ohm}",0.8]},
		LegendFunction->"Panel",
		LegendLayout -> {"Column",1}],{Right,Top}],
	Evaluate@xFigLabel["V_{in}~(\\si{V})","V_{out}~(\\si{V})"],
	Evaluate@xFigConfig]


pointList3A={Point[{VTH,0}//.listVal]}
pointList3B=Table[Point[{Vin,xAVsat}]//.{Vin->xVin1}//.listVal,{RD,listRD}];
fig3=Plot[Evaluate@Table[xAV//.{Vin1->xVin1}//.listValSTD,{RD,listRD}],{Vin,0,VDD//.listVal},
	PlotPoints->1000,
	PlotRange->{-10.5,0.5},
	GridLines->{xGrids[{0,4,0.5}],xGrids[{-10,0,1}]},
	Epilog->{
		Red,PointSize[0.015],Evaluate@pointList3B,
		White,PointSize[0.010],Evaluate@pointList3B,
		Blue,PointSize[0.015],Evaluate@pointList3A,
		White,PointSize[0.010],Evaluate@pointList3A,
		Text[xLaTeX["\\textcolor{blue}{V_{TH}}",0.8],{xVTH0-0.15,-0.5}],
		Text[xLaTeX["\\textcolor{red}{V_{in1}}",0.8],{1.65,-8.5}],
	},
	FrameTicks->{xTicks[{0,4,1},{1,0}],xTicks[{-10,0,2},{1,0}]},
	PlotLegends->Placed[LineLegend[{
		xLaTeX["R_D=10\\si{k\\ohm}",0.8],
		xLaTeX["R_D=20\\si{k\\ohm}",0.8],
		xLaTeX["R_D=40\\si{k\\ohm}",0.8],
		xLaTeX["R_D=80\\si{k\\ohm}",0.8]},
		LegendFunction->"Panel",
		LegendLayout -> {"Column",1}],{Right,Bottom}],
	Evaluate@xFigLabel["V_{in}~(\\si{V})","A_V"],
	Evaluate@xFigConfig]


fig={fig1,fig2,fig3}


figWithName=Transpose[{fig,nbPDFNameList[[1;;Length[fig]]]}];
ReleaseHold[(Hold[Export[#[[2]],#[[1]],ImageResolution->2000]]&)/@figWithName]
