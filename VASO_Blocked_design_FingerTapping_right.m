clear all
% this program waits for ONE trigger at the beginning to start
% this program runs a blocked design for hand, face, foot mapping
% there are 20 trials (8 x hand (4 x left), 8 x foot (4 x left), 4 x
% tongue)
% for a TR of 2 sec it expects 302 TRs (10 Minutes)

% used for VASO test pilot 21.02.2020
% ask for participant number and randomization
    Subject=input('Participant Number? Enter value between 001 and 999 ---> '); clc;
    Run=input('Run Number? Enter value (1) ---> '); clc;
[result, warnings] = loadlibrary('fglove64', 'fglove.h', 'alias', 'glovelib');

% Open the glove on device usb0 (this can be replaced with a com port eg. COM1)
glovePointer = calllib('glovelib', 'fdOpen', 'usb0');
% define trigger code
    triggerCode = 116;

% define stimulus parameters
    int_trigger = 1; % value beween 1 and 15
    int_trigger2 = 2; % value beween 1 and 15
    time = 2; % 2 equals 1 ms
    trigger = 0; % starts counting at 0
    
% define experimental parameters (%show default values)
    numberOfRestTRs = 0; % number of TRs after stimulation
    noOfRepetitions = 21; % number of repetitions: BOLD: 11, VASO/BOLD: 21
    pause = 17; % pause between trials is 15 seconds
    trialLength = 20; % length of trial is 12 seconds
    instructionsLength = 3; % length of instruction screen is 3 seconds
    PauseInstructions = 'Pause';
    
% define parameters
    HandLeft = 0;
    HandRight = 0;
    FootLeft = 0;
    FootRight = 0;
    Tongue = 0;
    Pause = 0;
    Instructions = 0;

% define trial order and randomize
% check if there are two zeros in a row (in which case there would be three
% repetitions)
    N = 1;
    while N>0
        conditions = [1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4 5 5 5 5 ];
        conditions = conditions(randperm(length(conditions)));
        difference = diff(conditions);
        N = numel(regexp(char(double(difference~=0)+'0'),'00+'));
    end    

%%%%%% show fixation cross
%% Screen
    [window2,r2]=Screen(0,'OpenWindow',[150 150 150],[0 0  2024 1024]); % 2024 1024 for laptop, 1724 1024 for MRI
    black=BlackIndex(window2);
    white=WhiteIndex(window2);

% show fixation cross
    Screen(window2,'Flip');
    Screen(window2,'TextSize',50);
    [nx, ny, bbox] = DrawFormattedText(window2, '+', 'center','center', white, 40,[],[],2); 
    Screen(window2,'Flip'); %break lines after 40

%%%%%%%%%%%%%%%%%%%% wait for trigger signal (defined above)
    t=1;
while t==1;
    [buttonPress,Time] = GetChar;
   if buttonPress==triggerCode 
        t = t+1;
        trigger = trigger+1;
        if trigger==1 % trigger is only = 1 after first trigger came
        startTime=GetSecs; % start time begins with first trigger
        
        end
    end
end
       
%%%%%%%%%%%%%% start experiment
    % set parameters
    trial=1; % one trial is one full cycle of all digits
  count = 1;
while trial<noOfRepetitions
        
   % set parameters
        loopStartTime(trial)=GetSecs-startTime;

   % determine condition 
        condition = conditions(trial);
   
   % define instructions (i.e. condition)
        if condition==1
                instructions = 'Rechten Daumen vorbereiten';
                movement = 'Rechten Daumen tappen!';
                HandRight = HandRight+1;
            elseif condition==2
                instructions = 'Rechten Daumen vorbereiten';
                movement = 'Rechten Daumen tappen!';
                HandLeft = HandLeft+1;
            elseif condition==3
                instructions = 'Rechten Daumen vorbereiten';
                movement = 'Rechten Daumen tappen!';
                FootRight = FootRight+1;
            elseif condition==4
                instructions = 'Rechten Daumen vorbereiten';
                movement = 'Rechten Daumen tappen!';
                FootLeft = FootLeft+1;
            elseif condition==5
                instructions = 'Rechten Daumen vorbereiten';
                movement = 'Rechten Daumen tappen!';
                Tongue = Tongue+1;
        end
            Pause = Pause+1;
            Instructions = Instructions+1;
    
    % show instructions
        Screen(window2,'Flip');
        Screen(window2,'TextSize',50);[nx, ny, bbox] = DrawFormattedText(window2, instructions, 'center','center', white, 40,[],[],2); Screen(window2,'Flip'); %break lines after 40
        % get onsets instructions
        timeInstructions(Instructions)=GetSecs-startTime;
        % limit time of instruction screen
        WaitSecs(instructionsLength); % precision of 1 ms   
        
     % show fixation cross where they move
        Screen(window2,'Flip');
        Screen(window2,'TextSize',50);[nx, ny, bbox] = DrawFormattedText(window2, movement, 'center','center', white, 40,[],[],2); Screen(window2,'Flip'); %break lines after 40
        % get onsets
        if condition == 1
            timeHandRight(HandRight)=GetSecs-startTime;
            elseif condition == 2
                timeHandLeft(HandLeft)=GetSecs-startTime;
            elseif condition == 3
                timeFootRight(FootRight)=GetSecs-startTime;
            elseif condition == 4
                timeFootLeft(FootLeft)=GetSecs-startTime;
            elseif condition == 5
                timeTongue(Tongue)=GetSecs-startTime;
        end        
        % length of movement block
        WaitSecs(trialLength); % precision of 1 ms 
        
    % show instructions
        Screen(window2,'Flip');
        Screen(window2,'TextSize',50);[nx, ny, bbox] = DrawFormattedText(window2, PauseInstructions, 'center','center', white, 40,[],[],2); Screen(window2,'Flip'); %break lines after
        % get onsets
        timePause(Pause)=GetSecs-startTime;
        % interval between two trials
        WaitSecs(pause); % precision of 1 ms    
%%        
  time =  GetSecs;

% Collect data


    %timeInterval = 0.005; 
    sensorValue = calllib('glovelib', 'fdGetSensorRaw', glovePointer, 4);
    disp(sensorValue); % To measure current the command is MEASURE:CURRENT:DC?
    voltage(count) = sensorValue;  %#ok<SAGROW>
    %pause(timeInterval);
    count = count +1;
    
   clear timeInterval

    trial=trial+1;
    
end  % ends the experiment

totalTimeExperiment = GetSecs-startTime;

WaitSecs(2);

% show end screen
    Screen(window2,'Flip');
    Screen(window2,'TextSize',30);
    instructions='Vielen Dank, das Experiment ist zu Ende!';
    [nx, ny, bbox] = DrawFormattedText(window2, instructions, 'center','center', white, 40,[],[],2); Screen(window2,'Flip'); %break lines after 40
    WaitSecs(3);

% clear screen
    Screen('CloseAll')
 
% change format and name for onset files
    timeThumb = timeHandRight';
    timeIndexFinger = timeHandLeft';
    timeMiddleFinger = timeFootRight';
    timeRingFinger = timeFootLeft';
    timeLittleFinger = timeTongue';
    timePause = timePause';
    timeInstructions = timeInstructions';
    
% save data
    save (['Blocked_design_FingerTapping_right_SubjectNo' num2str(Subject) 'Run' num2str(Run) '.mat'],'conditions','startTime','totalTimeExperiment','timeThumb','timeIndexFinger','timeMiddleFinger','timeRingFinger','timeInstructions','timeLittleFinger','timePause');  
    

   