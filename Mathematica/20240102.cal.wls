#!/usr/bin/env wolframscript
(* ::Package:: *)

s=Solve[-(gm2+gmb2)VX+(Vout-VX)/rO2==gm1 Vin+VX/rO1==-Vout/RD,{Vin,Vout}]


xVin=Vin//.s[[1]]
xVout=Vout//.s[[1]]


FullSimplify[xVout/xVin]
