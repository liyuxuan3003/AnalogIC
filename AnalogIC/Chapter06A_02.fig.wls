#!/usr/bin/env wolframscript
(* ::Package:: *)

ClearAll["Global`*"]


SetDirectory[NotebookDirectory[]];
Needs["MaTeX`"];


nbFileName="Chapter06A_02.fig.wls";
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


N[20 Log[10,Sqrt[2]/2]]


xLoPass=1/(1-s/wc);
xHiPass=(-s/wc)/(1-s/wc);
xLoPassApx=Piecewise[{{1,w<1},{1/w,w>1}}];
xHiPassApx=Piecewise[{{w,w<1},{1,w>1}}];


fig1=LogLogPlot[{xLoPassApx,Abs[xLoPass//.{s->I w,wc->-1}]},{w,10^-3,10^3},
FrameTicks->{xTicksLog[{-3,3,1}],xTicksLog[{-3,1,1}]},
GridLines->{xGridsLog[{-3,3,1},{10^-3,10^3}],xGridsLog[{-3,0,1},{10^-3,10^0}]},
Evaluate@xFigLabel["\\omega","|A|"],
PlotStyle->{Directive[Gray,Dashed],Directive[Black]},
PlotRange->{5 10^-4,2 10^0},
Epilog->{
	Dotted,Red,Thickness[0.004],
	Line[{{Log[1],Log[5]},{Log[1],Log[5 10^-4]}}],
	Line[{{Log[10^-4],Log[Sqrt[2]/2]},{Log[10^4],Log[Sqrt[2]/2]}}],
	Red,PointSize[0.015],
	Point[{Log[1],Log[1]}],Point[{Log[1],Log[Sqrt[2]/2]}],
	White,PointSize[0.010],
	Point[{Log[1],Log[1]}],Point[{Log[1],Log[Sqrt[2]/2]}],
	Text[xLaTeX["\\textcolor{red}{\\omega=\\omega_c}",1],{Log[1/3],Log[1.4 10^-1]}],
	Text[xLaTeX["\\textcolor{red}{-3\\mathrm{dB}}",0.8],{Log[3 10^2],Log[1]}],
	Text[xLaTeX["\\textcolor{black}{-20\\mathrm{dB}\\cdot\\mathrm{dec}^{-1}}",0.8],{Log[2 10^2],Log[5 10^-2]}]
},
Evaluate@xFigConfig]


fig2=LogLogPlot[{xHiPassApx,Abs[xHiPass//.{s->I w,wc->-1}]},{w,10^-3,10^3},
FrameTicks->{xTicksLog[{-3,3,1}],xTicksLog[{-3,1,1}]},
GridLines->{xGridsLog[{-3,3,1},{10^-3,10^3}],xGridsLog[{-3,0,1},{10^-3,10^0}]},
Evaluate@xFigLabel["\\omega","|A|"],
PlotStyle->{Directive[Gray,Dashed],Directive[Black]},
PlotRange->{5 10^-4,2 10^0},
Epilog->{
	Dotted,Red,Thickness[0.004],
	Line[{{Log[1],Log[5]},{Log[1],Log[5 10^-4]}}],
	Line[{{Log[10^-4],Log[Sqrt[2]/2]},{Log[10^4],Log[Sqrt[2]/2]}}],
	Red,PointSize[0.015],
	Point[{Log[1],Log[1]}],Point[{Log[1],Log[Sqrt[2]/2]}],
	White,PointSize[0.010],
	Point[{Log[1],Log[1]}],Point[{Log[1],Log[Sqrt[2]/2]}],
	Text[xLaTeX["\\textcolor{red}{\\omega=\\omega_c}",1],{Log[3],Log[1.4 10^-1]}],
	Text[xLaTeX["\\textcolor{red}{-3\\mathrm{dB}}",0.8],{Log[1/3 10^-2],Log[1]}],
	Text[xLaTeX["\\textcolor{black}{+20\\mathrm{dB}\\cdot\\mathrm{dec}^{-1}}",0.8],{Log[1/2 10^-2],Log[5 10^-2]}]
},
Evaluate@xFigConfig]


fig3=ComplexPlot[xLoPass//.{wc->-1},{s,-2-2I,2+2I},
ColorFunction->"MaxAbs",Axes->True,GridLines->Automatic,
FrameTicks->{xTicks[{-2,2,1},{1,0}],xTicks[{-2,2,1},{1,0}]},
Evaluate@xFigLabel["\\mathrm{Re}~s=\\sigma","\\mathrm{Im}~s=\\omega"],
ImageSize->Automatic->250
]


fig4=ComplexPlot[xHiPass//.{wc->-1},{s,-2-2I,2+2I},
ColorFunction->"MaxAbs",Axes->True,GridLines->Automatic,
FrameTicks->{xTicks[{-2,2,1},{1,0}],xTicks[{-2,2,1},{1,0}]},
Evaluate@xFigLabel["\\mathrm{Re}~s=\\sigma","\\mathrm{Im}~s=\\omega"],
ImageSize->Automatic->250
]


funcList={(1+I w)^-1,(1-I w)^-1,(1+I w),(1-I w)};


fig5=ReleaseHold[Hold[LogLogPlot[Abs[func],{w,10^-2,10^2},
FrameTicks->{xTicksLog[{-3,3,1}],xTicksLog[{-2,2,1}]},
GridLines->{xGridsLog[{-3,3,1},{10^-3,10^3}],xGridsLog[{-2,2,1},{10^-2,10^2}]},
Evaluate@xFigLabel["\\omega","|A|"],
PlotStyle->{Black},
PlotRange->{5 10^-3,2 10^2},
AspectRatio->1,
ImageSize->Automatic->100,
Evaluate@xFigConfig
]]/.(({func->#}&)/@funcList)]


fig6=ReleaseHold[Hold[LogLinearPlot[Arg[func]/Pi,{w,10^-2,10^2},
FrameTicks->{xTicksLog[{-3,3,1}],xTicks[{-0.5,0.5,0.25},{3,2}]},
GridLines->{xGridsLog[{-3,3,1},{10^-3,10^3}],Automatic},
Evaluate@xFigLabel["\\omega","\\mathrm{arg}~A/\\pi"],
PlotStyle->{Black},
PlotRange->{-0.55,0.55},
AspectRatio->1,
ImageSize->Automatic->100,
Evaluate@xFigConfig
]]/.(({func->#}&)/@funcList)]


fig=Join[{fig1,fig2,fig3,fig4},fig5,fig6]


figWithName=Transpose[{fig,nbPDFNameList[[1;;Length[fig]]]}];
ReleaseHold[(Hold[Export[#[[2]],#[[1]],ImageResolution->2000]]&)/@figWithName]
