function [] = slider_plot()
% Plot different plots according to slider location.
S.fh = figure('units','pixels',...
              'position',[300 300 300 300],...
              'menubar','none',...
              'name','slider_plot',...
              'numbertitle','off',...
              'resize','off');    
S.x = 0:.01:1;  % For plotting.         
S.ax = axes('unit','pix',...
            'position',[20 80 260 210]);
plot(S.x,S.x,'r');        
S.sl = uicontrol('style','slide',...
                 'unit','pix',...
                 'position',[20 10 260 30],...
                 'min',1,'max',3,'val',1,...
                 'sliderstep',[1/2 1/2],...
                 'callback',{@sl_call,S});  
function [] = sl_call(varargin)
% Callback for the slider.
[h,S] = varargin{[1,3]};  % calling handle and data structure.
cla
switch round(get(h,'value'))
      case 1
          cla
          plot(S.ax,S.x,S.x.^1,'r')
      case 2
          cla
          plot(S.ax,S.x,S.x.^2,'b')        
      case 3
          cla
          plot(S.ax,S.x,S.x.^3,'k')         
      otherwise
          disp('cannot plot')
  end