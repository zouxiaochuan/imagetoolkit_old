classdef lmClassifierSVMLight < lmAClassifierOffline
    
    properties
        mOptions;
        mIsDecision;
        mPath;
    end
    
    methods
        function obj = lmClassifierSVMLight(path,options,isDec)
            obj.mPath = path;
            
            if nargin < 2
                obj.mOptions = '-s 1 -c 1 -v 0';
            else
                obj.mOptions = options;
            end
            
            if nargin < 3
                obj.mIsDecision = false;
            else
                obj.mIsDecision = isDec;
            end
        end
        
        function [labelPredict, obj] = classify(obj,dataTest,dataTrain,labelTrain)
            [~,filenameTrain,~] = fileparts(tempname());
            [~,filenameModel,~] = fileparts(tempname());
            [~,filenameTest,~] = fileparts(tempname());
            [~,filenameResult,~] = fileparts(tempname());
            
            svmwrite(filenameTrain,labelTrain,dataTrain,'w');
            svmwrite(filenameTest,ones(size(dataTest,2),1),dataTest,'w');
            
            %train
            cmd = fullfile(obj.mPath,'svm_learn');
            cmd = [ cmd ' ' obj.mOptions ' ' filenameTrain ' ' filenameModel];
            
            [retcd,cmdret] = system(cmd);
            
            if retcd ~= 0
                throw(MException('lmClassifier:svmlight',cmdret));
            end
            
            %classify
            cmd = fullfile(obj.mPath,'svm_classify');
            cmd = [ cmd ' -v 0 ' filenameTest ' ' filenameModel ' ' filenameResult];
            [retcd,cmdret] = system(cmd);
            if retcd ~= 0
                throw(MException('lmClassifier:svmlight',cmdret));
            end
            
            file = fopen(filenameResult,'r');
            predict = fscanf(file,'%f',size(dataTest,2));
            
            labelPredict = predict;
            if obj.mIsDecision
            else
                labelPredict(labelPredict>0) = 1;
                labelPredict(labelPredict<=0)=-1;
            end
                
            fclose(file);
            
            delete(filenameTrain,filenameModel,filenameTest,filenameResult);
        end
    end
    
end

