classdef eegsignal
    %EEGSIGNAL IS A CLASS HAVING THE ACTUAL SIGNAL AND ITS TRIALS
    %   rawsignal
    %   filteredsignal
    %   Imagine & Trial
    %   class
    
    properties
        rawsignal
        filteredsignal
        Imagine
        imaginepoints
        trialpoints
        trial
        Trial
        pause
        class
        Class
        classLablesforTrain
        classLablesforTest
        cltRandperm
        TrainLabels
        TestLabels
        registererror
        triallengthes
        imaginelengthes
        %LAGTIME Stors the lags for each trial.
        lagtime
        signaltype
    end
    
    methods

        function inputclass = initialparameters(inputclass, nooffiles,nooftrials)
                inputclass.filteredsignal  = cell(1,nooffiles);
                inputclass.class            = cell(1,nooffiles);
                inputclass.trial             = cell(nooftrials,nooffiles);
                inputclass.triallengthes  = cell(1,nooffiles);
                inputclass.Imagine        = cell(1,nooffiles);       
                inputclass.rawsignal      = cell(1,nooffiles);
                inputclass.lagtime         =  zeros(1,1,1);
                eegSignal.Trial.normal   = [ ] ; 
                eegSignal.Trial.average = [ ] ;               %trial(claas,channel)
                eegSignal.Trial.DD        = [ ] ;                 %
                eegSignal.Trial.DD2      = [ ] ; 
                eegSignal.Trial.diffch    = [ ] ; 
                eegSignal.Trial.fft        = [ ] ; 
        end
        function eegSignal = randommaker(eegSignal, nooffiles,kfold)
 
                        eegSignal.classLablesforTrain = [ ] ;
                        eegSignal.classLablesforTest = [ ] ;
                        for o = 1 : 5
                            for q = ( o - 1 )*nooffiles*(kfold-1) + 1 : ( o )*nooffiles*(kfold-1)
                                eegSignal.classLablesforTrain( q ) = o;
                            end
                            for q = ( o - 1 )*nooffiles + 1 : ( o )*nooffiles
                                eegSignal.classLablesforTest( q ) = o;
                            end
                        end
        end
        
        function eegSignal = loadandfilterfiles(eegSignal,eegProperties,signalProperties)
          %function to load eeg signal  

                [eegSignal] = rawsignalinitialization(eegSignal,'onefile', eegProperties,signalProperties,processProperties) ;

%                 fileno = 1;
%                 while fileno <= eegProperties.nooffiles
%                               
%                     eegSignal.class{fileno}      = zeros(5,9);   
%                     for clssno = 1 : eegProperties.noofclass
%                            eegSignal.class{fileno}(clssno,:) = find(eegSignal.Class{fileno} == clssno ) ;
%                     end
%                     fileno = fileno + 1 ;
%                 end
        end
        
        function eegSignal = makeLables (eegSignal, crossValidation , kfold, trialnoPclass)
         % function to make train and test lables each time
                 total = [1:trialnoPclass,1:trialnoPclass];
                 eegSignal.TestLabels = total(crossValidation : trialnoPclass - kfold + crossValidation);
                 eegSignal.TrainLabels = total(trialnoPclass + 1 - kfold + crossValidation : trialnoPclass + crossValidation - 1);
        end

    end
end

