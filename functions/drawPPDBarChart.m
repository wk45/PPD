function drawPPDBarChart(IndicatorMatrix, Heights, lam, labelMax, idx_opt)
    
    figure
    IMfull = ~isnan(Heights);
    IMtrunc = ~isnan(IndicatorMatrix);
    
    
    imagesc(linspace(lam(1),lam(end),length(lam)),linspace(1,labelMax-2,labelMax-2),zeros(size(IMfull')))
    colormap(hot(0))
    
    BarColors(IMfull,lam,[0.8 0.8 0.8])
    BarColors(IMtrunc,lam,[0.3 0.3 0.3])
    
    for j = 1:labelMax
        yline(j+0.5,'--')
    end
    
    xline(lam(idx_opt),'m--','linewidth',2)
    hold off

    xlim([lam(1),lam(end)])
    ylim([0.5,labelMax+0.5])

    yticks(1:labelMax);
    
    xlabel('$\lambda$','Interpreter','latex')
    ylabel('Peak Index')
    
    set(gca,'FontSize',14);
end

