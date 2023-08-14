clc
clear
close all

load fisheriris
X = meas;
Y = species;
BaggedEnsemble = generic_random_forests(X,Y,60,'classification')
predict(BaggedEnsemble,[5 3 5 1.8])
