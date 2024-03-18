classdef eegproperties
    %EEGPROPERTIES Construct a class that has information about the EEG
    %signal file.
    %   EEGPROPERTIES.CHANNELS: a single channel or a vector of channels.
    %   Bear in mind that choosing only one channel could lead to potential
    %   errors to some features like Common Spatial Pattern or when it is
    %   set to search for the best features.
    %   EEGPROPERTIES/NOOFCLASS defines the number of classes that are
    %   being used and classified. minimum is 2 classes and the current
    %   version of the code supports up to 5 classes. Use with caution if
    %   you have more classes.
    %   EEGPROPERTIES/VERSUS if a two class classification is chosen then
    %   the number in versus would define the class that other classes are
    %   being compared to it. if this is empty a four class classification
    %   would be used if the number of classes allows and if not the last
    %   class would be set to versus.
    %   EEGPROPERTIES/NOOFFILES defines the number of classes that you want
    %   to be processed together. this should be atleast 1 file.
    %   EEGPROPERTIES/NOOFTRIALS no of trials in each file
    %   EEGPROPERTIES/TRIALNOPCLASS no of trials per each class in each file.
    %   EEGPROPERTIES/CLASSROW the row in eeg raw file matrix that denotes
    %   the class number for each trial.
    %   EEGPROPERTIES.IMAGINEROW the row in eeg raw file matrix that denotes
    %   the start of imagination or asked function from the subject in
    %   each trial.
    %   EEGPROPERTIES/TRIALROW the row in eeg raw file matrix that denotes
    %   the marker of start of each trial in each file.
    %   EEGPROPERTIES/EEGROWS the rows in eeg raw file matrix that denote
    %   to actual eeg signal.
    %   EEGPROPERTIES/REGISTERERRORROW the row in eeg raw file matrix that
    %   denotes the marker of error that has been mrecorded.
    %   EEGPROPERTIES/CONTROLCLASS the row in eeg raw file matrix that
    %   denotes the control class.
    %
%           Version 2.2.1 Modification Feb. 02 2021
%                       signalproperties class merged into proce
    
    properties
%   EEG Channel numbers you want to select. It could be all or a part of
%   EEG electrodes. E.G. 1:16 or 2:64 etc.
        channels
        %INPUTMETHODE can be "'onefie'" or "'different'"
        inputmethod
%   Number of Classes you want to select. It is better to select all
%   classes available. if you had 2 Imagination classes and one control
%   class noofclass would be 3.
        noofclass
%   The class you want to classify against in two-class classification
        versus
%   Number of files of EEG recording that should be processed together
        nooffiles
%   Number of trials in each recording (each file)
        nooftrials
%   Number of trials in each recording that belong to one class
        trialnoPclass
%   Row number that has class numbers in the file
        classrow
%   Row number that has starting point marker of imagination or desired eeg
        imaginerow
%   Row number that has the starting and ending point of each trial.
        trialrow
%   Row numbers that denotes to actual eeg signal
        eegrows
%   Row number that has registered error (if any)
        registererrorrow
%   The Class number that is the contorl class (EEG with no particular task)
        controlclass
%   Marker denoting the start and end of each trial. It can be chosen:
%   'trialno' which is when the number of trial is written
%   'one' is when number 1 is recorded along the trial
%   'start/stop' is when a single vector of start and one stop is recorded
%   in the row.
        trialmarker
%   Marker which is recorded during each Imagination or desired function.
%   It can be chosen:
%   'trialno' which is when the number of trial is written
%   'one' is when number 1 is recorded along the trial
%   'start/stop' is when a single vector of start and one stop is recorded
%   in the row.        
        imaginemarker
        %
        pauserow
% Sample EEg could be chosen between "'safa'" which was right
% handed and "'sajjad'" which was left handed or "none" for loading
        sampleeeg
        
        synctrials
        
        
        windowlength
        
        windowsliding
        
        filtertype
        
        filterproperties
        
        samplingrate
        
     
    end
    
methods (Static)
        
        function validfilters = availablefilters()
            validfilters = {'Butterworth','wmspca','none'};
        end
end
    
    methods
        
        function inputclass = initialize(inputclass)
            if ~isa(inputclass.filterproperties,'struct')
                inputclass.filterproperties = validatefilters(inputclass);
            end
        end
        
        function flag = validateeegproperties(inputclass)
            flag = 1;
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            if (~isa(inputclass.channels,'double') || ~isa(inputclass.nooffiles,'double') || ~isa(inputclass.versus,'double')|| ~isa(inputclass.noofclass,'double'))
                flag = 0 ;
            elseif (isnan(inputclass.channels) | isnan(inputclass.nooffiles) | isnan(inputclass.versus) | isnan(inputclass.noofclass))
                flag = 0 ;
            end
        end
        function inputclass = checksample(inputclass)
            try
                if ~startsWith(inputclass.sampleeeg,'sa') 
                    inputclass.sampleeeg = 'none';
                end
            catch
                 inputclass.sampleeeg = 'none';
            end
        end
        function filterproperties = validatefilters(inputclass)
                    switch inputclass.filtertype
                        case 'Butterworth'
                                prompt1 = ' lowerboundery of preprocessing filter: please enter a positive number: \n ';
                                if isa(prompt1 , 'double')
                                 lowerboundery = input(prompt1);
                                end
                                prompt1 = ' Upperboundery for preprocessing filter: please enter a positive number: \n ';
                                if isa(prompt1 , 'double')
                                 upperboundery = input(prompt1);
                                end
                                prompt1 = ' Upperboundery for preprocessing filter: please enter a positive number: \n ';
                                if isa(prompt1 , 'double')
                                 filterdegree = input(prompt1);
                                end

                        case 'wmspca'
                                prompt1 = ' function name for wavelet decomposition: \n ';
                                 wname = input(prompt1);
                                 prompt1 = ' Decomposition level for wavelet: \n ';
                                 if isa(prompt1 , 'double')
                                    wname = input(prompt1);
                                 end

                    end
                    switch inputclass.filtertype
                        case 'Butterworth'
                                 filterproperties = struct('filterdegree',filterdegree,'lowerboundery', lowerboundery, 'upperboundery',upperboundery);
                        case 'wmspca'
                                 filterproperties = struct('wname',wname,'level',level);

                    end
        end
        
        function trialnoPclass = trPcl (inputclass)
            trialnoPclass = inputclass.nooftrials / inputclass.noofclass ;
        end
        
        function inputclass = filleegproperties(inputclass)
            fprintf('Since you have not created an eegproperties class please answer the following questions:\n');
            prompt1 = 'What are the EEG channles you want to be processed? E.g. 1:16 \n';
            inputclass.channels = input(prompt1);
            prompt2 = 'How many classees you have or want to be processed? \n';
            inputclass.noofclass = input(prompt2);
            prompt3 = 'Which class do you want other classes to be Classified againts? Versus: \n';
            inputclass.versus = input(prompt3);
            prompt4 = 'How many files do you have? (How many different EEG Recording?) default = 1\n';
            inputclass.nooffiles = input(prompt4);
            prompt5 = 'How many trials are in one file?';
            inputclass.nooftrials = input(prompt5);
            inputclass.trialnoPclass = trPcl(inputclass.noofclass,inputclass.nooftrials);
            prompt6 = 'Which row denotes the class numbers? (insert Nan if you use another method)\n';
            inputclass.classrow = input(prompt6);
            prompt7 = 'Which row has the marker for starting Point of Imagination or the asked function? (insert Nan if you use another method)\n';
            inputclass.imaginerow = input(prompt7);
            prompt8 = 'What row has the marker for starting Point of each trials? (insert Nan if you use another method)\n';
            inputclass.trialrow = input(prompt8);
            prompt9 = 'Which rows denote the EEG signal? E.g. 2:65 or 1:32\n';
            inputclass.eegrows = input(prompt9);
            prompt10 = 'which row has the registered error marker? (if not enter Nan)\n';
            inputclass.registererrorrow = input(prompt10);
            prompt11 = 'Which class is the control class? E.g. 5 or 3\n';
            inputclass.controlclass = input(prompt11);
        end
    end
end
