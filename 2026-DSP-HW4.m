




%%(a)
clear; clc; close all; format long g;
%%1
omega_p = pi/3;
omega_s = 0.4*pi;
target_gain = 0.01;
omega_cut = (omega_p + omega_s) / 2;


%%2
found = false;
N = 1; 

while ~found
    order = 2 * N;
    win = hann(order + 1);
    b = fir1(order, omega_cut/pi, 'low', win);


    h_ws = sum(b .* exp(-1i * omega_s * (0:order)));
    gain_ws = abs(h_ws);

    if gain_ws <= target_gain
        found = true;
    else
        N = N + 1;
    end
end
fprintf('【搜尋結果】\n');
fprintf('最小 N 值: %d\n', N);
fprintf('濾波器總階數 (2N): %d\n', 2*N);
fprintf('在 0.4pi 處的增益: %.4f (約 %.2f dB)\n', gain_ws, 20*log10(gain_ws));

%%3
[H, W] = freqz(b, 1, 4096); 
mag_db = 20*log10(abs(H));

figure;
plot(W/pi, mag_db, 'LineWidth', 2, 'DisplayName', 'FIR Response'); 
grid on; hold on;


plot(0.4, -40, 'ro', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'Stopband Spec');
line([1/3 1/3], [-100 10], 'Color', 'g', 'LineStyle', '--', 'LineWidth', 1.2, 'DisplayName', '\omega_p = \pi/3');
line([0.4 0.4], [-100 10], 'Color', 'm', 'LineStyle', '--', 'LineWidth', 1.2, 'DisplayName', '\omega_s = 0.4\pi');

xlim([0.3, 0.5]);
ylim([-60, 5]); 

xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Magnitude (dB)');
title(['Transition Band Detail (N = ', num2str(N), ')']);

legend('Location', 'northeast');




%%(b)
clear; clc; close all; format long g;
%1
omega_p = pi/3;               
omega_s_range = linspace(0.4*pi, 0.5*pi, 50); 
target_gain = 0.01;           
N_required = zeros(size(omega_s_range));

%2
for i = 1:length(omega_s_range)
    ws = omega_s_range(i);
    omega_cut = (omega_p + ws) / 2;
    found = false;
    current_N = 1; 
    while ~found
        order = 2 * current_N;
        win = hann(order + 1);
        b = fir1(order, omega_cut/pi, 'low', win);
        h_ws = sum(b .* exp(-1i * ws * (0:order)));
        if abs(h_ws) <= target_gain
            found = true;
            N_required(i) = current_N;
        else
            current_N = current_N + 1;
        end
    end
end

%3
figure('Color', [0.1 0.1 0.1]);
set(gca, 'Color', [0.1 0.1 0.1], 'XColor', 'w', 'YColor', 'w', 'GridColor', 'w'); 
plot(omega_s_range/pi, N_required, 'b-o', 'LineWidth', 2, ...
    'MarkerSize', 6, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', [0 0.5 1]); 
grid on; hold on;
ws_04 = 0.4;
N_04 = N_required(abs(omega_s_range/pi - 0.4) < 1e-4);
plot(ws_04, N_04, 'rs', 'MarkerSize', 12, 'LineWidth', 2.5);
text(ws_04 + 0.005, N_04 + 2, ['N = ', num2str(N_04)], 'Color', [1 0.3 0.3], 'FontWeight', 'bold', 'FontSize', 12);

xlabel('Stopband Edge \omega_s / \pi', 'Color', 'w');
ylabel('Minimum Required N', 'Color', 'w');
title('Relationship between \omega_s and N (Hann Window)', 'Color', 'w');

xlim([0.39, 0.51]);
ylim([15, 55]);















%%(c)
clear; close all;

%
omega_p = pi/3;
omega_s = 0.4*pi;
omega_cut = (omega_p + omega_s) / 2;
target_db = -40;

%
N_fir = 46; 
order_fir = 2 * N_fir;
win = hann(order_fir + 1);
b_fir = fir1(order_fir, omega_cut/pi, 'low', win);

%
N_iir = 21;
[b_iir, a_iir] = butter(N_iir, omega_p/pi);

%
[h_fir, w] = freqz(b_fir, 1, 2048);
[h_iir, ~] = freqz(b_iir, a_iir, 2048);

%
figure('Color', [0.1 0.1 0.1]);
set(gca, 'Color', [0.1 0.1 0.1], 'XColor', 'w', 'YColor', 'w', 'GridColor', 'w');
hold on;

plot(w/pi, 20*log10(abs(h_iir)), 'r', 'LineWidth', 2, 'DisplayName', 'Butterworth (N=21)');
plot(w/pi, 20*log10(abs(h_fir)), 'b', 'LineWidth', 2, 'DisplayName', 'Hann FIR (N=46)');

%
line([0 1], [target_db target_db], 'Color', [0.7 0.7 0.7], 'LineStyle', '--', 'LineWidth', 1.5, 'DisplayName', 'Spec -40dB');


grid on;
xlabel('Normalized Frequency (\times\pi rad/sample)', 'Color', 'w');
ylabel('Magnitude (dB)', 'Color', 'w');
title('Magnitude Response Comparison', 'Color', 'w');
legend('TextColor', 'w', 'Location', 'northeast');
ylim([-100 10]);
xlim([0 1]);




%%
figure('Color', [0.1 0.1 0.1]);
set(gca, 'Color', [0.1 0.1 0.1], 'XColor', 'w', 'YColor', 'w', 'GridColor', 'w');
hold on;

%
plot(w/pi, unwrap(angle(h_iir))/pi, 'r', 'LineWidth', 2, 'DisplayName', 'Butterworth (Non-linear)');
plot(w/pi, unwrap(angle(h_fir))/pi, 'b', 'LineWidth', 2, 'DisplayName', 'Hann FIR (Linear Phase)');

grid on;
xlabel('Normalized Frequency (\times\pi rad/sample)', 'Color', 'w');
ylabel('Phase (\times\pi rad)', 'Color', 'w');
title('Phase Response Comparison', 'Color', 'w');
legend('TextColor', 'w', 'Location', 'northeast');
xlim([0 1]);


[gd_fir, ~] = grpdelay(b_fir, 1, w);
fprintf('FIR Filter Group Delay: %.1f samples (Fixed)\n', mean(gd_fir));


















