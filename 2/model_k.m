function [U] = model_k(parameters,f,q,Pc_end,Swmean,k2,numLayers)

XYT = [f;q;Pc_end;Swmean;k2];

% First fully connect operation.
weights = parameters.k1_Weights;
bias = parameters.k1_Bias;
U = fullyconnect(XYT,weights,bias);

% tanh and fully connect operations for remaining layers.
for i=2:numLayers
    name = "k" + i;

    U = tanh(U);

    weights = parameters.(name + "_Weights");
    bias = parameters.(name + "_Bias");
    U = fullyconnect(U, weights, bias);
end

U = exp(sigmoid(U).*(10+1)-1);

end