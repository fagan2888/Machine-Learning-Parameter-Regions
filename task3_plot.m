function task3_plot(IRF, indexmatrix, collector, response, shock, VAR_config, FLAGcumsum, pic_config, point_id)
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % task3_plot Produce Figure 6
    %
    % Inputs
    % IRF
    % indexmatrix
    % collector - draw info from numerical IRF
    % reponse - variable number of response
    % shock - variable number of shock
    % VAR_config - object generated by SVAR_config.m
    % FLAGcumsum - logical flag for cumulative sum
    % pic_config - object generated by pic_config.m
    % point_ID - indictator of whether to include median response
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    % Unspool
    drawMatrix = VAR_config.drawMatrix;
    nhorizon = VAR_config.nhorizon;
    names = VAR_config.names;
 
    fig_fontsize = pic_config.fontsize;
    fig_width = pic_config.width;
    fig_height = pic_config.height;
    pic_dir = pic_config.directory;
 
    figure('Name', 'HPD')
 
    colormat = {'blue', 'red'}; % Shotguns
    ogcolor = {'green', 'yellow'}; % Orginal IRF color
 
    if FLAGcumsum == 0
        plot_IRF = squeeze(IRF(response, shock, 1:nhorizon, :));
     
    elseif FLAGcumsum == 1
        plot_IRF = cumsum(squeeze(IRF(response, shock, 1:nhorizon, :)));
     
    end
 
    for ii = size(collector, 1): - 1:1 % reverse order for better pictures
        if FLAGcumsum == 0
            plot_og_IRF = squeeze(IRF(response, shock, 1:nhorizon, indexmatrix(1, ii)));
        elseif FLAGcumsum == 1
            plot_og_IRF = cumsum(squeeze(IRF(response, shock, 1:nhorizon, indexmatrix(1, ii))));
        end
     
        % Shotgun plots
        plot(0:nhorizon - 1, plot_IRF(:, indexmatrix(1:collector(ii, 1), ii)), ...
        'LineWidth', 1, 'Color', colormat{ii});
        hold on;
     
        % Legend
        if point_id == 1
            t3_leg(2 * (ii - 1) + 1) = plot(NaN, NaN, 'DisplayName', ['Draws = ' num2str(collector(ii, 1))], 'LineWidth', 1, 'Color', colormat{ii});
        end
        t3_leg(ii) = plot(NaN, NaN, 'DisplayName', ['Draws = ' num2str(collector(ii, 1))], 'LineWidth', 1, 'Color', colormat{ii});
     
        % Black bands
        plot(0:nhorizon - 1, max(plot_IRF(:, indexmatrix(1:collector(ii, 1), ii)), [], 2), 'k-', ...
          0:nhorizon - 1, min(plot_IRF(:, indexmatrix(1:collector(ii, 1), ii)), [], 2), 'k-', 'linewidth', 2)
     
        if point_id == 1
            % IRF Mode
            plot(0:nhorizon - 1, plot_og_IRF, 'LineWidth', 2, 'Color', 'green');
            t3_leg(2 * ii) = plot(NaN, NaN, 'DisplayName', ['Median IRF (' num2str(collector(ii, 1)) ')'], ...
              'LineWidth', 3, 'Color', ogcolor{ii});
        end
    end
 
    % Its legend
    t3_leg2 = legend(t3_leg);
    set(t3_leg2, 'Interpreter', 'latex')
 
    %title(['Highest posterior density'], 'fontsize', 12)
    ylabel(['Response of $' names{response} '$'], 'fontsize', 12, 'Interpreter', 'latex');
    xlabel('Horizon', 'fontsize', 12, 'Interpreter', 'latex');
 
 
    latex_fig(fig_fontsize, fig_width, fig_height);
    tightfig();
    if point_id == 1
        print(gcf, '-depsc2', fullfile(pic_dir, 'hpd_pointid.eps'))
    else
        print(gcf, '-depsc2', fullfile(pic_dir, 'hpd.eps'))
    end
end


