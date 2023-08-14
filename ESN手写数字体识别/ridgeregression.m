function [ W ] = ridgeregression( X, Y, esn)
W = Y.'*X.'/(X*X'+esn.lambda*eye(esn.Nr+1+esn.inputDim)); 
end

