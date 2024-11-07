function U = model_Uw(parameters,X,f,k,Sw,Q,numLayers)

XYT = [X;f;k;Sw;Q];

% First fully connect operation.
weights = parameters.Pw1_Weights;
bias = parameters.Pw1_Bias;
U = fullyconnect(XYT,weights,bias);

% tanh and fully connect operations for remaining layers.
for i=2:numLayers
    name = "Pw" + i;

    U = tanh(U);

    weights = parameters.(name + "_Weights");
    bias = parameters.(name + "_Bias");
    U = fullyconnect(U, weights, bias);
end

U = sigmoid(U).*0.998+0.001;

end