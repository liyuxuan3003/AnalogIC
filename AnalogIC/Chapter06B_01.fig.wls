#!/usr/bin/env wolframscript
(* ::Package:: *)

ClearAll["Global`*"]


SetDirectory[NotebookDirectory[]];
Needs["MaTeX`"];


nbFileName="Chapter06B_01.fig.wls";
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
xVTH=VTH0+gamma(Sqrt[2PhiF-VBS]-Sqrt[2PhiF]);
listVal={VTH0->xVTH0,VTH->xVTH,kB->xkB,q->xq,T->xT,VT->xVT,
	tox->xtox,eox->xeox,e0->xe0,Cox->xCox,
	mu->xmu,W->xW,L->xL,E->xE,alpha->xalpha,xi->xxi,
	gamma->xgamma,PhiF->xPhiF,LD->xLD,
	PB->xPB,Cj0->xCJ0,Cjsw0->xCJSW0,MJ->xMJ,MJSW->xMJSW,
	Cov->xCov
};


xgm=mu Cox (W/L)(VGS-VTH)


xC1=W L Cox
xC2=W Cov
xC4=W E Cj+2(W+LD)Cjsw
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


xCBS=C4//.{C4->xC4,Cjsw->xCjsw,Cj->xCj,VD->VBS};


xCBD=C4//.{C4->xC4,Cjsw->xCjsw,Cj->xCj,VD->VBS-VDS};


listFunc={
	gm->xgm,
	C1->xC1,C2->xC2,C4->xC4,Cj->xCj,Cjsw->xCjsw,
	CGSoff->xCGSoff,CGSlin->xCGSlin,CGSsat->xCGSsat,CGS->xCGS,
	CGDoff->xCGDoff,CGDlin->xCGDlin,CGDsat->xCGDsat,CGD->xCGD,
	CGBoff->xCGBoff,CGBlin->xCGBlin,CGBsat->xCGBsat,CGB->xCGB,
	CBS->xCBS,
	CBD->xCBD,
	VBS->0
};


{xCGSsat,xCGDsat,xCBS,xCBD}//.listFunc


f=10^(-15);
p=10^(-12);
n=10^(-9);
u=10^(-6);
m=10^(-3);
k=10^(3);
M=10^(6);


leval=Join[listFunc,listVal,{VDS->3,VGS->3}];


xvCGS=CGS//.leval
xvCGD=CGD//.leval
xvCGB=CGB//.leval
xvCBS=CBS//.leval
xvCBD=CBD//.leval
xvgm=gm//.leval
xRD=20k;
lval={CGS->xvCGS,CGD->xvCGD,CGB->xvCGB,CBS->xvCBS,CBD->xvCBD,gm->xvgm,RD->xRD};


PR=((#1 #2)/(#1+#2))&


xH=((CGD s-gm)RD)/(RS RD (CGS CGD+CGS CBD+CGD CBD)s^2+(RS(1+gm RD)CGD+RS CGS+RD(CGD+CBD))s+1);
xHPoles=FunctionPoles[xH,s];
xHZeros=FunctionPoles[xH^(-1),s];
xwp1=xHPoles[[2]][[1]]
xwp2=xHPoles[[1]][[1]]
xwz1=xHZeros[[1]][[1]]
xwp1mi=1/(RS(CGS+(1+gm RD)CGD));
xwp2mi=1/(RD(CBD+CGD));
xwp2rsh=FullSimplify[1/(PR[RD,(1/gm)((CGD+CGS)/(CGD))](CBD+PR[CGD,CGS]))]
xwp1dh=1/(RS(CGS+(1+gm RD)CGD)+RD(CGD+CBD));
xwp2dh=1/(RS RD (CGS CGD+CGS CBD+CGD CBD)) 1/xwp1dh;


(* ::InheritFromParent:: *)
(*(-CBD RD-CGD RD-CGD RS-CGS RS-CGD gm RD RS+\[Sqrt](-4 (CBD CGD RD RS+CBD CGS RD RS+CGD CGS RD RS)+(CBD RD+CGD RD+CGD RS+CGS RS+CGD gm RD RS)^2))/(2 (CBD CGD RD RS+CBD CGS RD RS+CGD CGS RD RS))*)


(* ::InheritFromParent:: *)
(*(-CBD RD-CGD RD-CGD RS-CGS RS-CGD gm RD RS-\[Sqrt](-4 (CBD CGD RD RS+CBD CGS RD RS+CGD CGS RD RS)+(CBD RD+CGD RD+CGD RS+CGS RS+CGD gm RD RS)^2))/(2 (CBD CGD RD RS+CBD CGS RD RS+CGD CGS RD RS))*)


(* ::InheritFromParent:: *)
(*(CGD+CGS+CGD gm RD)/(CBD CGD RD+CBD CGS RD+CGD CGS RD)*)


{CGS RS,RS(1+gm RD)CGD+RD(CGD+CBD)}//.lval//.{RS->20k}


LogLogPlot[Evaluate[Abs/@{xwp1,xwp1mi,xwp2,xwp2mi,xwp2rsh}//.lval],{RS,100,1M},Evaluate@xFigConfig]


xwp1


(* ::InheritFromParent:: *)
(*(-CBD RD-CGD RD-CGD RS-CGS RS-CGD gm RD RS+\[Sqrt](-4 (CBD CGD RD RS+CBD CGS RD RS+CGD CGS RD RS)+(CBD RD+CGD RD+CGD RS+CGS RS+CGD gm RD RS)^2))/(2 (CBD CGD RD RS+CBD CGS RD RS+CGD CGS RD RS))*)


LogLogPlot[Evaluate[Abs/@{xwp1,xwp1mi,xwp2,xwp2mi,xwp2rsh}//.lval],{RS,100,1M},Evaluate@xFigConfig]


RBColorList=Table[Blend[{Red,Blue},x],{x,0,1,1/(#1-1)}]&;


fig={}


figWithName=Transpose[{fig,nbPDFNameList[[1;;Length[fig]]]}];
ReleaseHold[(Hold[Export[#[[2]],#[[1]],ImageResolution->2000]]&)/@figWithName]
