map = brewermap(2,'Set1'); 



figure
histf(10*log10(Gm_max_inicio),'facecolor',map(1,:),'facealpha',.5,'edgecolor','none')
hold on
histf(10*log10(Gm_max),'facecolor',map(2,:),'facealpha',.5,'edgecolor','none')
box off
axis tight
legalpha('Normal','[1.9 0.1]','location','northwest')
legend boxoff