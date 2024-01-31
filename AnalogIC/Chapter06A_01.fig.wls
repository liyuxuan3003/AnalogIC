#!/usr/bin/env wolframscript
(* ::Package:: *)

ClearAll["Global`*"]


SetDirectory[NotebookDirectory[]];
Needs["MaTeX`"];


nbFileName="Chapter06A_01.fig.wls";
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


R1=(1-A)^(-1);
R2=(1-1/A)^(-1);
C1=(1-A);
C2=(1-1/A);


fig1=Plot[{R1,R2},{A,-4,4},Exclusions->{A==1},PlotRange->{-5.5,5.5},
	FrameTicks->{xTicks[{-4,4,1},{1,0}],xTicks[{-5,5,1},{1,0}]},
	PlotStyle->{Red,Blue},
	Evaluate@xFigLabel["A","R_n/R"],
	Evaluate@xFigConfig,
	Epilog->{Thickness[0.002],Dashed,Line[{{-4,1},{4,1}}]},
	PlotLegends->Placed[LineLegend[{
		xLaTeX["R_1/R",0.8],
		xLaTeX["R_2/R",0.8]},
		LegendFunction->"Panel",
		LegendLayout -> {"Column",1}],{Left,Bottom}]
]


fig2=Plot[{C1,C2},{A,-4,4},Exclusions->{A==0},PlotRange->{-5.5,5.5},
	FrameTicks->{xTicks[{-4,4,1},{1,0}],xTicks[{-5,5,1},{1,0}]},
	PlotStyle->{Red,Blue},
	Evaluate@xFigLabel["A","C_n/C"],
	Evaluate@xFigConfig,
	Epilog->{Thickness[0.002],Dashed,Line[{{-4,1},{4,1}}]},
	PlotLegends->Placed[LineLegend[{
		xLaTeX["C_1/C",0.8],
		xLaTeX["C_2/C",0.8]},
		LegendFunction->"Panel",
		LegendLayout -> {"Column",1}],{Left,Bottom}]
]


fig={fig1,fig2}


figWithName=Transpose[{fig,nbPDFNameList[[1;;Length[fig]]]}];
ReleaseHold[(Hold[Export[#[[2]],#[[1]],ImageResolution->2000]]&)/@figWithName]
