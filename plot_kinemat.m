c=conditions(1:9);
for t=1:9
figure(t)
%currentFig=gcf;
title(['CONDITION',num2str(c(t))])
   for i = 1:13
 AH(i) = subplot(3,6,i);
 plot((abs(fft(hilbert(kinemtx_kal{1,t}(:,i))))));
 caption = sprintf('SENSOR #%d', i);
 title(caption)
   end
   allYlim = get(AH,{'Ylim'});
   allYlim = cat(2,allYlim{:});
   set(AH,'Ylim',[min(allYlim), max(allYlim)]);
   
   
   %title(currentFig.Children(end),['CONDITION',num2str(c(t))]);
   sgtitle(['CONDITION',num2str(c(t))])
end