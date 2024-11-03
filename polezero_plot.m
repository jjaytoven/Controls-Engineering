function [] = polezero_plot(b, a, s_or_z, ROC)
    % Check if we're working in the s-plane or z-plane
    if s_or_z == 'z'
        error('z-plane plotting not implemented. Use s-plane for now.');
    elseif s_or_z ~= 's'
        error('Invalid input for s_or_z. Use ''s'' for s-plane.');
    end
    
    % Calculate the poles and zeros
    zeros = roots(b);
    poles = roots(a);
    
    % Create the plot
    figure;
    hold on;
    
    % Plot the zeros (o) and poles (x)
    plot(real(zeros), imag(zeros), 'go', 'MarkerSize', 10, 'LineWidth', 2);
    plot(real(poles), imag(poles), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
    
    % Plot ROC (fill the region based on the ROC provided)
    % The ROC is shaded between ROC(1) and ROC(2)
    % Adjust ROC(1) or ROC(2) if they are +/- Inf
    if ROC(1) == -Inf
        x_fill_start = -10; % Adjust to simulate negative infinity
    else
        x_fill_start = ROC(1);
    end
    
    if ROC(2) == Inf
        x_fill_end = 10; % Adjust to simulate positive infinity
    else
        x_fill_end = ROC(2);
    end
    
    % Fill the region between x_fill_start and x_fill_end
    x_fill = [x_fill_start, x_fill_end, x_fill_end, x_fill_start];
    y_fill = [-10, -10, 10, 10];  % Imaginary axis range
    
    fill(x_fill, y_fill, 'yellow', 'FaceAlpha', 0.3); % Light yellow for ROC
    %{
    % Label poles and zeros with their values
    for i = 1:length(poles)
        text(real(poles(i)) + 0.2, imag(poles(i)), sprintf('%.4f', poles(i)), 'Color', 'r', 'FontSize', 10);
    end
    for i = 1:length(zeros)
        text(real(zeros(i)) + 0.2, imag(zeros(i)), sprintf('%.4f', zeros(i)), 'Color', 'g', 'FontSize', 10);
    end
    
    % Display the transfer function H(s) as text
    text(-7, 6, ['H(s) = ', sprintf('\\frac{s^3 + 2s^2 + 5s - 3}{s^4 + 4s^3 - 3s^2 + 8s - 1}')], 'FontSize', 14, 'Interpreter', 'latex');
    
    % Display the ROC condition
    if ROC(1) == -Inf && ROC(2) == Inf
        roc_condition = 'RoC = Entire complex plane';
    elseif ROC(1) == -Inf
        roc_condition = sprintf('RoC = Re(s) < %.4f', ROC(2));
    elseif ROC(2) == Inf
        roc_condition = sprintf('RoC = Re(s) > %.4f', ROC(1));
    else
        roc_condition = sprintf('RoC = %.4f < Re(s) < %.4f', ROC(1), ROC(2));
    end
    
    text(-7, -6, roc_condition, 'FontSize', 12, 'BackgroundColor', 'white');
    %}
    % Graph formatting
    axis square;
    xlabel('Re(s)');
    ylabel('Im(s)');
    xlim([-10,10])
    title('Pole-Zero Plot with ROC');
    grid on;
    
    hold off;
end
