function [] = polezero_plot(b, a, s_or_z, ROC)
    % Check if we're working in the s-plane or z-plane
    if s_or_z == 's'
        domain = 's';
    elseif s_or_z == 'z'
        domain = 'z';
    else
        error("Invalid input for s_or_z. Use 's' for s-plane or 'z' for z-plane.");
    end
    
    % Calculate the poles and zeros
    zeros = roots(b);
    poles = roots(a);
    
    % Create the plot
    figure;
    hold on;
    
    % Plot the unit circle for z-plane
    if domain == 'z'
        theta = linspace(0, 2*pi, 300);
        plot(cos(theta), sin(theta), 'w--', 'LineWidth', 1.5); % Unit circle
    end
    
    % Plot the zeros (o) and poles (x)
    plot(real(zeros), imag(zeros), 'go', 'MarkerSize', 10, 'LineWidth', 2);
    plot(real(poles), imag(poles), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
    
    % Handle ROC shading
    if domain == 's'
        if ROC(1) == -Inf
        x_fill_start = -1e9; % Adjust to simulate negative infinity
        else
            x_fill_start = ROC(1);
        end
        
        if ROC(2) == Inf
            x_fill_end = 1e9; % Adjust to simulate positive infinity
        else
            x_fill_end = ROC(2);
        end
    
    % Fill the region between x_fill_start and x_fill_end
    x_fill = [x_fill_start, x_fill_end, x_fill_end, x_fill_start];
    y_fill = [-1e9, -1e9, 1e9, 1e9];  % Imaginary axis range
   
    fill(x_fill, y_fill, 'yellow', 'FaceAlpha', 0.3); % Light yellow for ROC
    else
        % ROC in the z-plane is typically a disk or annular region
        r_min = ROC(1); % Inner boundary (e.g., |z| > r_min)
        r_max = ROC(2); % Outer boundary (e.g., |z| < r_max)
        
        theta = linspace(0, 2*pi, 300);
        if r_min == 0
            r_min = 0.01; % Prevent zero-radius fill
        end
        
        x_fill_inner = r_min * cos(theta);
        y_fill_inner = r_min * sin(theta);
        x_fill_outer = r_max * cos(theta);
        y_fill_outer = r_max * sin(theta);
        
        if isinf(r_max)
            fill([x_fill_inner, fliplr(x_fill_inner)], [y_fill_inner, fliplr(-y_fill_inner)], 'yellow', 'FaceAlpha', 0.3);
        else
            fill([x_fill_inner, fliplr(x_fill_outer)], [y_fill_inner, fliplr(y_fill_outer)], 'yellow', 'FaceAlpha', 0.3);
        end
    end
    
    if domain == 's'
        if ROC(1) == -Inf && ROC(2) == Inf
            roc_condition = 'RoC = Entire complex plane';
        elseif ROC(1) == -Inf
            roc_condition = sprintf('RoC: Re(s) < %.4f', ROC(2));
        elseif ROC(2) == Inf
            roc_condition = sprintf('RoC: Re(s) > %.4f', ROC(1));
        else
            roc_condition = sprintf('RoC: %.4f < Re(s) < %.4f', ROC(1), ROC(2));
        end
    else
        if ROC(1) == 0 && isinf(ROC(2))
            roc_condition = 'RoC: Entire z-plane except z=0';
        elseif ROC(2) == Inf
            roc_condition = sprintf('RoC: |z| > %.4f', ROC(1));
        elseif ROC(1) == 0
            roc_condition = sprintf('RoC: |z| < %.4f', ROC(2));
        else
            roc_condition = sprintf('RoC: %.4f < |z| < %.4f', ROC(1), ROC(2));
        end
    end
    
    % Automatically determine best position for text
    text_pos_x = max(real([zeros; poles; 0])) + 0.3;
    text_pos_y = max(imag([zeros; poles; 0])) + 0.3;
    
    text(text_pos_x, text_pos_y, roc_condition, 'FontSize', 7, 'BackgroundColor', 'white', 'EdgeColor', 'black');
        % Graph formatting
   
    axis equal;
    xlabel(['Re(' domain ')']);
    ylabel(['Im(' domain ')']);
    title(['Pole-Zero Plot in ' upper(domain) '-Plane']);
    if domain == 's'
        c = min(abs(ROC(1)),abs(ROC(2)));
        xlim([-(c*7) c*7]) % scaling based on ROC
    end
    grid on;
    
    hold off;
end
