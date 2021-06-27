% Load the library with the alias glovelib
[result, warnings] = loadlibrary('fglove64', 'fglove.h', 'alias', 'glovelib');

% Open the glove on device usb0 (this can be replaced with a com port eg. COM1)
glovePointer = calllib('glovelib', 'fdOpen', 'usb0');
% Check the number of sensors
numSensors = calllib('glovelib', 'fdGetNumSensors', glovePointer);

sensor = 1;
% Get the value of the first sensor
sensorValue = calllib('glovelib', 'fdGetSensorRaw', glovePointer, sensor);