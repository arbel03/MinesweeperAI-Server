function [TrainingInd, ValidationInd,TestInd] = GetIndices(NumExamples,NumCategories)


NumExamplesInCategory = floor(NumExamples/NumCategories);

NumTrainingExamples = round(0.7*NumExamplesInCategory);
NumValAndTestExamples = round(0.15*NumExamplesInCategory);

TrainingInd = [];
ValidationInd = [];
TestInd = [];
for i = 1:NumCategories
    PermIndicesPerCategory(i,:) = randperm(NumExamplesInCategory);
    PermIndicesPerCategory(i,:) = PermIndicesPerCategory(i,:)+(i-1)*NumExamplesInCategory;
    TrainingInd = [TrainingInd, PermIndicesPerCategory(i,1:NumTrainingExamples)];
    ValidationInd = [ValidationInd, PermIndicesPerCategory(i,NumTrainingExamples+1:NumTrainingExamples+NumValAndTestExamples)];   
    TestInd = [TestInd, PermIndicesPerCategory(i,NumTrainingExamples+NumValAndTestExamples+1:end)];   
    
end






