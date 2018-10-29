function task1_plot(IRF, collector, response, shock, VAR_config, FLAGcumsum, pic_config)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % task1_plot Produce Figure 3
    %
    % Inputs
    % IRF
    % collector - draw info from numerical IRF
    % reponse - variable number of response
    % shock - variable number of shock
    % VAR_config - object generated by SVAR_config.m
    % FLAGcumsum - logical flag for cumulative sum
    % pic_config - object generated by pic_config.m
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    debug = 0;
    if debug == 1
        VAR_config = t1_VAR_config;
        pic_config = picture_config;
        IRF = t1_IRF;
        collector = t1_collector;
        FLAGcumsum = false;
        response = 1;
        shock = 3;
    end
 
    % Unspool
    drawMatrix = VAR_config.drawMatrix;
    nhorizon = VAR_config.nhorizon;
    names = VAR_config.names;
 
    fig_fontsize = pic_config.fontsize;
    fig_width = pic_config.width;
    fig_height = pic_config.height;
    pic_dir = pic_config.directory;
 
    colormat = {'blue', 'red', 'green'};
    figure('Name', 'Numerical Bounds')
    for ii = 1:size(drawMatrix, 1)
     
        if FLAGcumsum == false
         
            upper_bound(:, :, :, ii) = permute(max(IRF(:, :, :, 1: 1:collector(ii, 1)), [], 4), [3 1 2]);
            lower_bound(:, :, :, ii) = permute(min(IRF(:, :, :, 1: 1:collector(ii, 1)), [], 4), [3 1 2]);
         
            % Cumsum
        elseif FLAGcumsum == true
         
            upper_bound(:, :, :, ii) = cumsum(permute(max(IRF(:, :, :, 1: 1:collector(ii, 1)), [], 4), [3 1 2]), 1);
            lower_bound(:, :, :, ii) = cumsum(permute(min(IRF(:, :, :, 1: 1:collector(ii, 1)), [], 4), [3 1 2]), 1);
        end
     
        % Plot upper
        plot(0 : nhorizon - 1, upper_bound(1:nhorizon, response, shock, ii), ...
        'LineWidth', 1, 'Color', colormat{ii});
        hold on;
        % Plot lower
        plot(0 : nhorizon - 1, lower_bound(1:nhorizon, response, shock, ii), ...
        'LineWidth', 1, 'Color', colormat{ii});
        % Legend
        t1_leg(ii) = plot(NaN, NaN, 'DisplayName', ...
          ['Draws $= ' num2str(collector(ii, 1)) '$'], ... %['Total = ' num2str(id_collector(ii, 3)) ' Accepted = ' num2str(id_collector(ii, 1))], ...
          'LineWidth', 1, 'Color', colormat{ii});
    end
 
    t1_leg2 = legend(t1_leg);
    set(t1_leg2, 'Interpreter', 'latex')
    ylabel(['Response of $' names{response} '$'], 'fontsize', 12, 'Interpreter', 'latex');
    xlabel('Horizon', 'fontsize', 12, 'Interpreter', 'latex');
    %title(['Bands on identified set; \epsilon = ' num2str(VAR_config.epsilon) ', \delta = ' num2str(VAR_config.delta)], 'fontsize', 12)
    % Resize 12 is font size, 10 is length, 3 is width
    latex_fig(fig_fontsize, fig_width, fig_height);
    tightfig();
    print(gcf, '-depsc2', fullfile(pic_dir, ['num_only.eps']))
 
end

