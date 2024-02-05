#!/usr/bin/env wolframscript
(* ::Package:: *)

ClearAll["Global`*"]


SetDirectory[NotebookDirectory[]];
Needs["MaTeX`"];


nbFileName="Chapter02F_01.fig.wls";
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
	ViewPoint->{-100,-80,65},PlotPoints->50,MaxRecursion ->5,
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
xesi=11.9;
xe0=8.854187817 10^(-12);
xCox=eox e0/tox;
xmu=350 100^(-2);
xW=0.5 10^(-6);
xL=0.5 10^(-6);
xE=1.0 10^(-6);
xlambda=0.1;
xalpha=2 mu Cox (xi VT)^2/Exp[2];
xxi=1.5;
xgamma=0.45;
xPhiF=0.9/2;
xLD=0.08 10^(-6);
xPB=0.9;
xCJ0=0.56 10^(-3);
xCJSW0=0.35 10^(-11);
xMJ=0.45;
xMJSW=0.2;
xCov=0.4 10^(-9);
xNsub=9 10^(14);
xVTH=VTH0+gamma(Sqrt[2PhiF-VBS]-Sqrt[2PhiF]);
listVal={VTH0->xVTH0,VTH->xVTH,kB->xkB,q->xq,T->xT,VT->xVT,
	tox->xtox,eox->xeox,esi->xesi,e0->xe0,Cox->xCox,
	mu->xmu,W->xW,L->xL,Ex->xE,alpha->xalpha,xi->xxi,
	gamma->xgamma,PhiF->xPhiF,LD->xLD,Nsub->xNsub,
	PB->xPB,Cj0->xCJ0,Cjsw0->xCJSW0,MJ->xMJ,MJSW->xMJSW,
	Cov->xCov
};


xC1=W L Cox
xC2=W Cov
xC3=W L Sqrt[q esi e0 Nsub/(4 PhiF)]
xC4=W Ex Cj+2(W+Ex)Cjsw
xCj=Cj0/(1-VD/PB)^MJ
xCjsw=Cjsw0/(1-VD/PB)^MJSW


xCGSoff=(C2);
xCGSlin=(C2+(2C1/3)(1-(VGS-VDS-VTH)^2/(2(VGS-VTH)-VDS)^2));
xCGSsat=(C2+(2C1/3));
xCGS=Piecewise[{
	{CGSoff,VGS<=VTH},
	{CGSlin,VGS>VTH && VDS<=VGS-VTH},
	{CGSsat,VGS>VTH && VDS>VGS-VTH}
}];


xCGDoff=(C2);
xCGDlin=(C2+(2C1/3)(1-(VGS-VTH)^2/(2(VGS-VTH)-VDS)^2));
xCGDsat=(C2);
xCGD=Piecewise[{
	{CGDoff,VGS<=VTH},
	{CGDlin,VGS>VTH && VDS<=VGS-VTH},
	{CGDsat,VGS>VTH && VDS>VGS-VTH}
}];


xCGBoff=C1;
xCGBlin=0;
xCGBsat=0;
xCGB=Piecewise[{
	{CGBoff,VGS<=VTH},
	{CGBlin,VGS>VTH && VDS<=VGS-VTH},
	{CGBsat,VGS>VTH && VDS>VGS-VTH}
}];


xCSB=C4//.{C4->xC4,Cjsw->xCjsw,Cj->xCj,VD->VBS};


xCDB=C4//.{C4->xC4,Cjsw->xCjsw,Cj->xCj,VD->VBS-VDS};


xCSB


listFunc={
	C1->xC1,C2->xC2,C3->xC3,C4->xC4,Cj->xCj,Cjsw->xCjsw,
	CGSoff->xCGSoff,CGSlin->xCGSlin,CGSsat->xCGSsat,CGS->xCGS,
	CGDoff->xCGDoff,CGDlin->xCGDlin,CGDsat->xCGDsat,CGD->xCGD,
	CGBoff->xCGBoff,CGBlin->xCGBlin,CGBsat->xCGBsat,CGB->xCGB,
	CSB->xCSB,
	CDB->xCDB,
	VBS->0
};


f=10^(-15);
p=10^(-12);
n=10^(-9);
u=10^(-6);
m=10^(-3);
k=10^(3);
M=10^(6);


lst=Join[listFunc,listVal];


plotRange={-0.1f,1.1f};


plotColor={ColorFunction->Function[{x,y,z},ColorData["DarkRainbow"][z/f]],ColorFunctionScaling->False};


plotLegend=BarLegend[{"DarkRainbow",{0.0,1.0}},LabelStyle->{FontFamily->"Century",FontSize->8,FontColor->Black}]


fig1=Plot3D[CGS//.lst,{VDS,0,4},{VGS,0,4},
	Exclusions->{(VGS==VTH)//.lst,(VDS==VGS-VTH)//.lst},
	Evaluate@plotColor,
	Evaluate@xFig3DConfig,
	Evaluate@xFig3DLabel["V_{DS}~(\\si{V})","V_{GS}~(\\si{V})","C_{GS}~(\\si{fF})"],
	PlotRange->plotRange,
	Ticks->{xTicks[{0,4,1},{2,1}],xTicks[{0,4,1},{2,1}],xTicksProp[{0,1.0,0.2},{2,1},f]}]


fig2=Plot3D[CGD//.lst,{VDS,0,4},{VGS,0,4},
	Exclusions->{(VGS==VTH)//.lst,(VDS==VGS-VTH)//.lst},
	Evaluate@plotColor,
	Evaluate@xFig3DConfig,
	Evaluate@xFig3DLabel["V_{DS}~(\\si{V})","V_{GS}~(\\si{V})","C_{GD}~(\\si{fF})"],
	PlotRange->plotRange,
	Ticks->{xTicks[{0,4,1},{2,1}],xTicks[{0,4,1},{2,1}],xTicksProp[{0,1.0,0.2},{2,1},f]}]


fig3=Plot3D[CGB//.lst,{VDS,0,4},{VGS,0,4},
	Exclusions->{(VGS==VTH)//.lst,(VDS==VGS-VTH)//.lst},
	Evaluate@plotColor,
	Evaluate@xFig3DConfig,
	Evaluate@xFig3DLabel["V_{DS}~(\\si{V})","V_{GS}~(\\si{V})","C_{GB}~(\\si{fF})"],
	PlotRange->plotRange,
	Ticks->{xTicks[{0,4,1},{2,1}],xTicks[{0,4,1},{2,1}],xTicksProp[{0,1.0,0.2},{2,1},f]}]


fig4=Plot3D[CSB//.lst,{VDS,0,4},{VGS,0,4},
	Exclusions->{(VGS==VTH)//.lst,(VDS==VGS-VTH)//.lst},
	Evaluate@plotColor,
	Evaluate@xFig3DConfig,
	Evaluate@xFig3DLabel["V_{DS}~(\\si{V})","V_{GS}~(\\si{V})","C_{BS}~(\\si{fF})"],
	PlotRange->plotRange,
	Ticks->{xTicks[{0,4,1},{2,1}],xTicks[{0,4,1},{2,1}],xTicksProp[{0,1.0,0.2},{2,1},f]}]


fig5=Plot3D[CDB//.lst,{VDS,0,4},{VGS,0,4},
	Exclusions->{(VGS==VTH)//.lst,(VDS==VGS-VTH)//.lst},
	Evaluate@plotColor,
	Evaluate@xFig3DConfig,
	Evaluate@xFig3DLabel["V_{DS}~(\\si{V})","V_{GS}~(\\si{V})","C_{BD}~(\\si{fF})"],
	PlotRange->plotRange,
	Ticks->{xTicks[{0,4,1},{2,1}],xTicks[{0,4,1},{2,1}],xTicksProp[{0,1.0,0.2},{2,1},f]}]


{CGS,CGD,CSB,CDB}//.lst//.{VDS->2,VGS->2}


RBColorList=Table[Blend[{Red,Blue},x],{x,0,1,1/(#1-1)}]&;


fig={fig1,fig2,fig3,fig4,fig5,plotLegend}


figWithName=Transpose[{fig,nbPDFNameList[[1;;Length[fig]]]}];
ReleaseHold[(Hold[Export[#[[2]],#[[1]],ImageResolution->2000]]&)/@figWithName]
