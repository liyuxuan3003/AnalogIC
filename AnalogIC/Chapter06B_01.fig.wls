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
	mu->xmu,W->xW,L->xL,Ex->xE,alpha->xalpha,xi->xxi,
	gamma->xgamma,PhiF->xPhiF,LD->xLD,
	PB->xPB,Cj0->xCJ0,Cjsw0->xCJSW0,MJ->xMJ,MJSW->xMJSW,
	Cov->xCov
};


xgm=mu Cox (W/L)(VGS-VTH)


xC1=W L Cox
xC2=W Cov
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
xwp1=xHPoles[[2]][[1]];
xwp2=xHPoles[[1]][[1]];
xwz1=xHZeros[[1]][[1]];
xwp1mi=1/(RS(CGS+(1+gm RD)CGD));
xwp2mi=1/(RD(CBD+CGD));
xwp2rsh=FullSimplify[1/(PR[RD,(1/gm)((CGD+CGS)/(CGD))](CBD+PR[CGD,CGS]))];
xwp1dh=1/(RS(CGS+(1+gm RD)CGD)+RD(CGD+CBD));
xwp2dh=1/(RS RD (CGS CGD+CGS CBD+CGD CBD)) 1/xwp1dh;


{CGS RS,RS(1+gm RD)CGD+RD(CGD+CBD)}//.lval//.{RS->20k}


fig1=LogLogPlot[Evaluate[Abs/@{xwp1,xwp2,xwz1,xwp1dh,xwp2dh}//.lval],{RS,100,1M},
PlotRange->{5 10^(7),2 10^(13)},
FrameTicks->{xTicksLog[{2,6,1}],xTicksLog[{8,13,1}]},
GridLines->{xGridsLog[{2,6,1},{100,1M}],xGridsLog[{8,13,1},{10^(8),10^(13)}]},
Evaluate@xFigLabel["R_S~(\\si{\\ohm})","|\\omega|"],
PlotStyle->{
	Red,Blue,Gray,
	Directive[Darker[Red],Dashed,Thickness[0.003]],
	Directive[Darker[Blue],Dashed,Thickness[0.003]]},
PlotLegends->Placed[LineLegend[{
		xLaTeX["-\\omega_{p1}",0.7],
		xLaTeX["-\\omega_{p2}",0.7],
		xLaTeX["+\\omega_z",0.7],
		xLaTeX["-\\omega_{p1}~\\text{Dominant Pole}",0.7],
		xLaTeX["-\\omega_{p2}~\\text{Dominant Pole}",0.7]
	},
	LegendMarkerSize->{{22,1}},
	LegendFunction->"Panel",
	LegendLayout -> {"Column",2}],{Left,Bottom}],
Evaluate@xFigConfig]


fig2=LogLogPlot[Evaluate[Abs/@{xwp1,xwp2,xwp2rsh,xwp1mi,xwp2mi}//.lval],{RS,100,1M},
PlotRange->{5 10^(7),2 10^(13)},
FrameTicks->{xTicksLog[{2,6,1}],xTicksLog[{8,13,1}]},
GridLines->{xGridsLog[{2,6,1},{100,1M}],xGridsLog[{8,13,1},{10^(8),10^(13)}]},
Evaluate@xFigLabel["R_S~(\\si{\\ohm})","|\\omega|"],
PlotStyle->{
	Red,Blue,Directive[Lighter[Blue],Dashed,Thickness[0.004]],
	Directive[Red,Dashed,Thickness[0.004]],
	Directive[Blue,Dashed,Thickness[0.004]]},
PlotLegends->Placed[LineLegend[{
		xLaTeX["-\\omega_{p1}",0.7],
		xLaTeX["-\\omega_{p2}",0.7],
		xLaTeX["-\\omega_{p2}~R_S\\to\\infty",0.7],
		xLaTeX["-\\omega_{p1}~\\text{Miller}",0.7],
		xLaTeX["-\\omega_{p2}~\\text{Miller}",0.7]
	},
	LegendMarkerSize->{{22,1}},
	LegendFunction->"Panel",
	LegendLayout -> {"Column",2}],{Left,Bottom}],
Evaluate@xFigConfig]


xBF1=1;
xBF2=(Abs[xwp1]^1/(w)^1)(xBF1/.{w->Abs[xwp1]});
xBF3=(Abs[xwp2]^2/(w)^2)(xBF2/.{w->Abs[xwp2]});
xBF4=(Abs[xwz1]^1/(w)^1)(xBF3/.{w->Abs[xwz1]});
xBode=Piecewise[{
	{xBF1,0<w<=Abs[xwp1]},
	{xBF2,Abs[xwp1]<w<=Abs[xwp2]},
	{xBF3,Abs[xwp2]<w<=Abs[xwz1]},
	{xBF4,Abs[xwz1]<w}
}];


xRS=20k;
lB=Join[lval,{RS->xRS}];
xH0=Re[xH/.lB/.{s->I w}/.{w->1}];
xAbs=Abs[(xH/xH0)//.lB/.{s->I w}];
xAbsAppr=xBode//.lB;
listw=Table[x//.lB,{x,{xwp1,xwp2,xwz1}}];


Table[ScientificForm[x//.lB,4],{x,{xwp1,xwp2,xwz1}}]


fig3=LogLogPlot[{xAbsAppr,xAbs},{w,10^9,10^(14)},
PlotStyle->{Black,Directive[Red,Thickness[0.003]]},
PlotRange->{5 10^(-6),2 10^(0)},
FrameTicks->{xTicksLog[{9,14,1}],xTicksLog[{-5,0,1}]},
GridLines->{xGridsLog[{9,14,1},{10^9,10^14}],xGridsLog[{-5,0,1},{10^(-5),10^(0)}]},
Evaluate@xFigLabel["\\omega","|A/A_0|"],
PlotLegends->Placed[LineLegend[{
		xText["\:5e45\:9891\:54cd\:5e94\:ff08\:8fd1\:4f3c\:ff09",8],
		xText["\:5e45\:9891\:54cd\:5e94\:ff08\:7cbe\:786e\:ff09",8]
	},
	LegendMarkerSize->{{22,1}},
	LegendFunction->"Panel",
	LegendLayout -> {"Column",1}],{Left,Bottom}],
Prolog->{
	Dashed,Gray,Thickness[0.002],
	Table[Line[{{Log[Abs[x]],Log[2 10^0]},{Log[Abs[x]],Log[5 10^-6]}}]//.lval/.{RS->xRS},{x,{xwp1,xwp2,xwz1}}],
	Text[xLaTeX["\\omega_{p1}=-2.003\\times 10^{10}",0.6],{Log[Abs[listw[[1]]/4]],Log[4 10^-1]}],
	Text[xLaTeX["\\omega_{p2}=-3.824\\times 10^{11}",0.6],{Log[Abs[listw[[2]]/4]],Log[1.4 10^-2]}],
	Text[xLaTeX["\\omega_{z}=+1.544\\times 10^{12}",0.6],{Log[Abs[listw[[3]] 4]],Log[1.4 10^-4]}],
	Text[xLaTeX["-20\\mathrm{dB}\\cdot\\mathrm{dec}^{-1}",0.4],{Log[1 10^11],Log[8 10^-1]}],
	Text[xLaTeX["-40\\mathrm{dB}\\cdot\\mathrm{dec}^{-1}",0.4],{Log[8 10^11],Log[8 10^-1]}],
	Text[xLaTeX["-20\\mathrm{dB}\\cdot\\mathrm{dec}^{-1}",0.4],{Log[4.5 10^12],Log[8 10^-1]}],
},
Evaluate@xFigConfig]


fig4=LogLinearPlot[Arg[xH//.lval/.{RS->xRS,s-> I w}]/Pi,{w,10^9,10^14},
PlotStyle->{Black},
PlotRange->{-1.1,1.1},
FrameTicks->{xTicksLog[{9,14,1}],xTicksProp[{-1,1,0.25},{3,2},1]},
GridLines->{xGridsLog[{9,14,1},{10^9,10^14}],xGrids[{-1,1,0.25}]},
Evaluate@xFigLabel["\\omega","\\arg (A)/\\pi"],
Epilog->{
	Dashed,Gray,Thickness[0.002],
	Table[Line[{{Log[Abs[x]],1.1 Pi},{Log[Abs[x]],-1.1}}]//.lB,{x,{xwp1,xwp2,xwz1}}],
	Text[xLaTeX["\\omega_{p1}=-2.003\\times 10^{10}",0.6],{Log[Abs[listw[[1]]/4]],0.6}],
	Text[xLaTeX["\\omega_{p2}=-3.824\\times 10^{11}",0.6],{Log[Abs[listw[[2]]/4]],0.1}],
	Text[xLaTeX["\\omega_{z}=+1.544\\times 10^{12}",0.6],{Log[Abs[listw[[3]] 4]],-0.6}],
},
PlotLegends->Placed[LineLegend[{
		xText["\:76f8\:9891\:54cd\:5e94",8]
	},
	LegendMarkerSize->{{22,1}},
	LegendFunction->"Panel",
	LegendLayout -> {"Column",1}],{Left,Bottom}],
Evaluate@xFigConfig]


(*xZin=(s CGS+ s RD(CGD+CBD)+1)/(s^2 CGS CGD (1+gm RD+s RD CBD));*)


xZin=FullSimplify@PR[(1+s RD (CGD+CBD))/((1+gm RD+s RD CBD)s CGD),1/(s CGS)]


xZinApx=FullSimplify@PR[1/((1+gm RD)s CGD),1/(s CGS)]


xZinR=FullSimplify@PR[1/gm,RD]


Re[xZin]//.lB/.{s->I w}//.{w->10^15}


{Abs@Re[xZinApx]}//.lB/.{s->I w}/.{w->10^20}


LogLinearPlot[Evaluate[{Abs@Re[xZinApx]}//.lB/.{s->I w}],
{w,10^9,10^14},PlotRange->All,
Evaluate@xFigConfig]


fig5=LogLogPlot[Evaluate[{Abs@Re[xZin],5 10^-3,Abs@xZinR,Abs@Im[xZin],Abs@Im[xZinApx]}//.lB/.{s->I w}],
{w,10^9,10^14},
PlotRange->{2 10^-3,2 10^6},
FrameTicks->{xTicksLog[{9,14,1}],xTicksLog[{-2,6,1}]},
GridLines->{xGridsLog[{9,14,1},{10^9,10^14}],xGridsLog[{-2,6,1},{10^-2,10^6}]},
PlotStyle->{Red,Directive[Red,Dashed],Directive[Darker[Red],Thickness[0.004]],Blue,Directive[Blue,Dashed]},
PlotLegends->Placed[LineLegend[{
		xLaTeX["+R_{in}",0.7],
		xLaTeX["+R_{in}~\\text{Miller}=0",0.7],
		xLaTeX["+R_{in}~C_{GD}\\to\\infty",0.7],
		xLaTeX["-X_{in}",0.7],
		xLaTeX["-X_{in}~\\text{Miller}",0.7]
	},
	LegendMarkerSize->{{22,1}},
	LegendFunction->"Panel",
	LegendLayout -> {"Column",2}],{Left,0.25}],
Epilog->{Text[xLaTeX["\\textcolor{red}{+R_{in}~\\text{Miller}=0}",0.8],{Log[1.5 10^13],Log[1.2 10^-2]}]},
Evaluate@xFigLabel["\\omega","Z_{in}~(\\si{\\ohm})"],
Evaluate@xFigConfig]


fig={fig1,fig2,fig3,fig4,fig5}


figWithName=Transpose[{fig,nbPDFNameList[[1;;Length[fig]]]}];
ReleaseHold[(Hold[Export[#[[2]],#[[1]],ImageResolution->2000]]&)/@figWithName]
