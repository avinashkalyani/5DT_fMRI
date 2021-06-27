function [f, tim]= getDATA(trig, nrep, startTime,count,timeInterval,result, warnings)
% [result, warnings] = loadlibrary('fglove64', 'fglove.h', 'alias', 'glovelib');

% Open the glove on device usb0 (this can be replaced with a com port eg. COM1)
glovePointer = calllib('glovelib', 'fdOpen', 'usb0');
numSensors = calllib('glovelib', 'fdGetNumSensors', glovePointer);
%timeInterval = 0.005; 
%f={};
%% Collect data
voltage = 0;
%count = 1;~isequal(trial,nrep)
x = datetime('now')+minutes(1/3);
while x>datetime('now')
   
for i=1:numSensors
    sensorValue(i) = calllib('glovelib', 'fdGetSensorRaw', glovePointer,i);
    disp(sensorValue); % To measure current the command is MEASURE:CURRENT:DC?
    voltage = sensorValue;%(count)=sensorValue;
      %#ok<SAGROW>
    %WaitSecs(timeInterval);
    %tim(count) =  GetSecs-startTime;
    
end
f(count,:)= voltage;
tim(count) =  GetSecs;
count = count +1;
clear voltage
end