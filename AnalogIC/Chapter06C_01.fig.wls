#!/usr/bin/env wolframscript
(* ::Package:: *)

ClearAll["Global`*"]


SetDirectory[NotebookDirectory[]];
Needs["MaTeX`"];


nbFileName="Chapter06C_01.fig.wls";
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
	mu->xmu,W->xW,L->xL,Ex->xE,alpha->xalpha,xi->xxi,lambda->xlambda,
	gamma->xgamma,PhiF->xPhiF,LD->xLD,
	PB->xPB,Cj0->xCJ0,Cjsw0->xCJSW0,MJ->xMJ,MJSW->xMJSW,
	Cov->xCov
};


xgm=mu Cox (W/L)(VGS-VTH);
xgo=mu Cox (W/L)((VGS-VTH)^2 lambda/2);
xro=go^(-1);
xeta=0.237;
xgmb=eta gm;


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
	gm->xgm,go->xgo,ro->xro,eta->xeta,gmb->xgmb,
	C1->xC1,C2->xC2,C4->xC4,Cj->xCj,Cjsw->xCjsw,
	CGSoff->xCGSoff,CGSlin->xCGSlin,CGSsat->xCGSsat,CGS->xCGS,
	CGDoff->xCGDoff,CGDlin->xCGDlin,CGDsat->xCGDsat,CGD->xCGD,
	CGBoff->xCGBoff,CGBlin->xCGBlin,CGBsat->xCGBsat,CGB->xCGB,
	CBS->xCBS,
	CBD->xCBD,
	VBS->0
};


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
xvro=ro//.leval
xvgmb=gmb//.leval
lval={CGS->xvCGS,CGD->xvCGD,CGB->xvCGB,CBS->xvCBS,CBD->xvCBD,gm->xvgm,gmb->xvgmb,ro->xvro,RD->xRD};


PR=((#1 #2)/(#1+#2))&


eq1=Vout CBS s-VGS CGS s-gm VGS==0
eq2=(VGS+Vout-Vin)RS^(-1)+VGS CGS s+(VGS+Vout)CGD s==0
svgs=Solve[eq1,{VGS}][[1]]
FullSimplify@Solve[eq2//.svgs,{Vout}]


xpA=RS gm^(-1)(CGD CGS +CGS CBS+CBS CGD);
xpB=RS CGD+gm^(-1)(CGS+CBS);
xAs=(CGS gm^(-1)s+1)/(pA s^2+pB s+1)//.{pA->xpA,pB->xpB};
xAsPoles=FunctionPoles[xAs,s];
xAsZeros=FunctionPoles[xAs^(-1),s];
xwp1=xAsPoles[[2]][[1]];
xwp2=xAsPoles[[1]][[1]];
xwz1=xAsZeros[[1]][[1]];
xwp1dh=-(1/pB)//.{pA->xpA,pB->xpB};
xwp2dh=-(pB/pA)//.{pA->xpA,pB->xpB};
xZin=PR[(s CGS+s CBS+gm+gmb)/(s CGS(s CBS+gmb)),1/(s CGD)];
xZin1=PR[(s CGS+gm+gmb)/(s CGS gmb),1/(s CGD)];
xZin2=PR[(s CGS+s CBS+gm)/(s^2 CGS CBS),1/(s CGD)];
xZout=PR[(1+s CGS RS)/(s CGS(1+gmb RS)+gm+gmb),1/(s CBS)];
xZout1=1/(gm+gmb);
xZout2=(RS)/(1+gmb RS);


fig1=LogLogPlot[Evaluate[Abs/@Join[Re/@{xwp1,xwp2,xwz1,xwp1dh,xwp2dh},Im/@{xwp1}]//.lval],{RS,100,1M},
PlotRange->{5 10^(8),2 10^(14)},PlotPoints->1000,MaxRecursion->10,
FrameTicks->{xTicksLog[{2,6,1}],xTicksLog[{8,14,1}]},
GridLines->{xGridsLog[{2,6,1},{100,1M}],xGridsLog[{9,14,1},{10^(9),10^(14)}]},
Evaluate@xFigLabel["R_S~(\\si{\\ohm})","\\omega"],
PlotStyle->{
	Red,Blue,Gray,
	Directive[Darker[Darker[Red]],Dashed,Thickness[0.003]],
	Directive[Darker[Darker[Blue]],Dashed,Thickness[0.003]],
	Darker[Green]
},
PlotLegends->Placed[LineLegend[{
		xLaTeX["-\\Re\\omega_{p1}",0.7],
		xLaTeX["-\\Re\\omega_{p2}",0.7],
		xLaTeX["-\\Re\\omega_z",0.7],
		xLaTeX["-\\Re\\omega_{p1}~\\text{Dominant Pole}",0.7],
		xLaTeX["-\\Re\\omega_{p2}~\\text{Dominant Pole}",0.7],
		xLaTeX["\\pm\\Im\\omega_{p1,p2}",0.7]
	},
	LegendMarkerSize->{{22,1}},
	LegendFunction->"Panel",
	LegendLayout -> {"Column",2}],{Right,Top}],
Evaluate@xFigConfig]


LogLinearPlot[
	Evaluate[Join[Re/@{xZin,xZin1,xZin2}]//.lval/.{s->I w}],{w,10^9,10^14},
	Evaluate@xFigConfig]


fig2=LogLogPlot[Evaluate[Abs/@Join[Re/@{xZin,xZin1,xZin2},Im/@{xZin,xZin1,xZin2}]//.lval/.{s->I w}],
{w,10^9,10^14},
PlotRange->{5 10^-3,2 10^7},
FrameTicks->{xTicksLog[{9,14,1}],xTicksLog[{-2,7,1}]},
GridLines->{xGridsLog[{9,14,1},{10^9,10^14}],xGridsLog[{-2,7,1},{10^-2,10^7}]},
PlotStyle->{
	Red,
	Directive[Lighter[Red],Dashed,Thickness[0.004]],
	Directive[Lighter[Red],Dotted,Thickness[0.004]],
	Blue,
	Directive[Lighter[Blue],Dashed,Thickness[0.004]],
	Directive[Lighter[Blue],Dotted,Thickness[0.004]]
},
PlotLegends->Placed[LineLegend[{
		xLaTeX["-R_{in}",0.7],
		xLaTeX["+R_{in}~\\omega\\downarrow",0.7],
		xLaTeX["-R_{in}~\\omega\\uparrow",0.7],
		xLaTeX["-X_{in}",0.7],
		xLaTeX["-X_{in}~\\omega\\downarrow",0.7],
		xLaTeX["-X_{in}~\\omega\\uparrow",0.7]
	},
	LegendMarkerSize->{{22,1}},
	LegendFunction->"Panel",
	LegendLayout -> {"Column",2}],{Left,Bottom}],
Evaluate@xFigLabel["\\omega","R_{in}~X_{in}~(\\si{\\ohm})"],
Evaluate@xFigConfig]


fig3=LogLogPlot[Evaluate[Abs/@{xZin,xZin1,xZin2}//.lval/.{s->I w}],
{w,10^9,10^14},
PlotRange->{5 10^-3,2 10^7},
FrameTicks->{xTicksLog[{9,14,1}],xTicksLog[{-2,7,1}]},
GridLines->{xGridsLog[{9,14,1},{10^9,10^14}],xGridsLog[{-2,7,1},{10^-2,10^7}]},
PlotStyle->{
	Black,
	Directive[Gray,Dashed,Thickness[0.004]],
	Directive[Gray,Dotted,Thickness[0.004]]
},
PlotLegends->Placed[LineLegend[{
		xLaTeX["|Z_{in}|",0.7],
		xLaTeX["|Z_{in}|~\\omega\\downarrow",0.7],
		xLaTeX["|Z_{in}|~\\omega\\uparrow",0.7]
	},
	LegendMarkerSize->{{22,1}},
	LegendFunction->"Panel",
	LegendLayout -> {"Column",1}],{Right,Top}],
Evaluate@xFigLabel["\\omega","|Z_{in}|~(\\si{\\ohm})"],
Evaluate@xFigConfig]


fig4=LogLinearPlot[Evaluate[(Arg[#]/Pi)&/@{xZin,xZin1,xZin2}//.lval/.{s->I w}],
{w,10^9,10^14},
PlotRange->{-1.1,1.1},
FrameTicks->{xTicksLog[{9,14,1}],xTicksProp[{-1,1,0.25},{3,2},1]},
GridLines->{xGridsLog[{9,14,1},{10^9,10^14}],xGrids[{-1,1,0.25}]},
Evaluate@xFigLabel["\\omega","\\arg(Z_{in})/\\pi"],
PlotStyle->{
	Black,
	Directive[Gray,Dashed,Thickness[0.004]],
	Directive[Gray,Dotted,Thickness[0.004]]
},
PlotLegends->Placed[LineLegend[{
		xLaTeX["\\arg(Z_{in})",0.7],
		xLaTeX["\\arg(Z_{in})~\\omega\\downarrow",0.7],
		xLaTeX["\\arg(Z_{in})~\\omega\\uparrow",0.7]
	},
	LegendMarkerSize->{{22,1}},
	LegendFunction->"Panel",
	LegendLayout -> {"Column",1}],{Right,Top}],
Evaluate@xFigLabel["\\omega","|Z_{in}|~(\\si{\\ohm})"],
Evaluate@xFigConfig]


xZoutTable=Table[xZout//.lval/.{s->I w},{RS,{1k,20k}}];
fig5=LogLogPlot[Evaluate[Abs/@Join[Re/@{xZoutTable},Im/@{xZoutTable}]//.lval/.{s->I w}],
{w,10^9,10^14},
PlotRange->{5 10^-3,2 10^7},PlotPoints->1000,MaxRecursion->15,
FrameTicks->{xTicksLog[{9,14,1}],xTicksLog[{-2,7,1}]},
GridLines->{xGridsLog[{9,14,1},{10^9,10^14}],xGridsLog[{-2,7,1},{10^-2,10^7}]},
PlotStyle->{
	Red,
	Directive[Red,Dashed,Thickness[0.004]],
	Blue,
	Directive[Blue,Dashed,Thickness[0.004]]
},
PlotLegends->Placed[LineLegend[{
		xLaTeX["+R_{in}~R_S=1 \\si{k\\ohm}",0.7],
		xLaTeX["+R_{in}~R_S=20 \\si{k\\ohm}",0.7],
		xLaTeX["-X_{in}~R_S=1 \\si{k\\ohm}",0.7],
		xLaTeX["\\pm X_{in}~R_S=20 \\si{k\\ohm}",0.7],
	},
	LegendMarkerSize->{{22,1}},
	LegendFunction->"Panel",
	LegendLayout -> {"Column",3}],{Left,Top}],
Epilog->{
	Blue,
	Text[xLaTeX["\\textcolor{blue}{(+)}",0.8],{Log[1.3 10^11],Log[10^-1]}],
	Text[xLaTeX["\\textcolor{blue}{(-)}",0.8],{Log[3.5 10^11],Log[10^-1]}]
},
Evaluate@xFigLabel["\\omega","R_{out}~X_{out}~(\\si{\\ohm})"],
Evaluate@xFigConfig]


fig6=LogLogPlot[Evaluate[Abs/@{Join[xZoutTable,{xZout1}]}//.lval/.{s->I w}],
{w,10^9,10^14},
PlotRange->{5 10^-3,2 10^7},
FrameTicks->{xTicksLog[{9,14,1}],xTicksLog[{-2,7,1}]},
GridLines->{xGridsLog[{9,14,1},{10^9,10^14}],xGridsLog[{-2,7,1},{10^-2,10^7}]},
PlotStyle->{
	Black,
	Directive[Gray,Dashed,Thickness[0.004]],
	Directive[Lighter[Lighter[Blue]],Thickness[0.002]],
	Directive[Black,Thickness[0.001]],
	Directive[Gray,Dashed,Thickness[0.001]]
},
PlotLegends->Placed[LineLegend[{
		xLaTeX["|Z_{out}|~R_S=1\\si{k\\ohm}",0.7],
		xLaTeX["|Z_{out}|~R_S=20\\si{k\\ohm}",0.7],
		xLaTeX["1/(g_m+g_{mb})",0.7]
	},
	LegendMarkerSize->{{22,1}},
	LegendFunction->"Panel",
	LegendLayout -> {"Column",2}],{Left,Bottom}],
Evaluate@xFigLabel["\\omega","|Z_{out}|~(\\si{\\ohm})"],
Evaluate@xFigConfig]


fig7=LogLinearPlot[Evaluate[(Arg[#]/Pi)&/@{xZoutTable}//.lval/.{s->I w}],
{w,10^9,10^14},
PlotRange->{-1.1,1.1},
FrameTicks->{xTicksLog[{9,14,1}],xTicksProp[{-1,1,0.25},{3,2},1]},
GridLines->{xGridsLog[{9,14,1},{10^9,10^14}],xGrids[{-1,1,0.25}]},
Evaluate@xFigLabel["\\omega","\\arg(Z_{out})/\\pi"],
PlotStyle->{
	Black,
	Directive[Gray,Dashed,Thickness[0.004]],
	Directive[Gray,Dotted,Thickness[0.004]]
},
PlotLegends->Placed[LineLegend[{
		xLaTeX["\\arg(Z_{in})~R_S=1\\si{k\\ohm}",0.7],
		xLaTeX["\\arg(Z_{in})~R_S=20\\si{k\\ohm}",0.7]
	},
	LegendMarkerSize->{{22,1}},
	LegendFunction->"Panel",
	LegendLayout -> {"Column",1}],{Right,Top}],
Evaluate@xFigLabel["\\omega","|Z_{in}|~(\\si{\\ohm})"],
Evaluate@xFigConfig]


fig={fig1,fig2,fig3,fig4,fig5,fig6,fig7}


figWithName=Transpose[{fig,nbPDFNameList[[1;;Length[fig]]]}];
ReleaseHold[(Hold[Export[#[[2]],#[[1]],ImageResolution->2000]]&)/@figWithName]
