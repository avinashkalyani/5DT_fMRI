%function displayAnimatedGif(fullFileName)
%Usage: displayAnimatedGif('myGif.gif')
[gifImage cmap] = imread('giphy.gif', 'Frames', 'all');
info=imfinfo('giphy.gif');
numFrames = size(gifImage,4);
close all

for k=1:numFrames
    imshow(gifImage(:,:,1,k), info(k).ColorTable);
    drawnow
    pause(0.05);
    x(k)=Screen(GetImage);
end
