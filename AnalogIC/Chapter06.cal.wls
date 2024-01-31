#!/usr/bin/env wolframscript
(* ::Package:: *)

Expand[RD RS(RD^(-1)+CGD s +CDB s)(RS^(-1)+CGD s+CGS s)-RD RS CGD s (CGD s-gm),s]


A=(CGD CGS+CDB CGD+CDB CGS)RD RS
B=(CGD+CDB)RD+(CGD+CGS)RS+CGD gm RD RS


FullSimplify@Solve[1/(w1 w2)==A&&(1/w1+1/w2)==B,{w1,w2}]


ComplexPlot[(s-1)/((1+s/2)(1+s/6)),{s,-8-8I,8+8I},PlotRange->{0,100}]


|
