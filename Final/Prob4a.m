clear all, clc, close all;

I = 10;
time = 500;

a_start = 0.1;
b_start = 0.1;

a = a_start:0.005:a_start + 0.2;
b = b_start:0.005:b_start + 0.2;
% b = 0.12;

c = -45;
d = 2;

ab = [[0.02, 0.2]; [0.2, 0.3]; [0.3, 0.4]; [0.5, 0.6]];
times = 1:time+1;

figure();
for i=1:size(ab, 1)
    v = ik_neuron(I, time, ab(i, 1), ab(i, 2), c, d);
    loc_max = islocalmax(v);
    subplot(1,size(ab, 1), i);
    plot(times, v, times(loc_max), v(loc_max), 'r*');
end


% 
% for i=1:length(a)
%     for j=1:length(b)
%         for l=1:length(d)
%             v = ik_neuron(I, time, a(i), b(j), c, d(l));
%             loc_max = islocalmax(v);
% 
%             std_v = var(v(loc_max));
%             % if (15 <= avg_time_int && avg_time_int <= 25) && (40 <= avg_v_pk) && (avg_v_pk <= 60)
%             %     break;
%             % end
%             if (std_v <= 5)
%                 break;
%             end
% 
%         end
%     end
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% v = ik_neuron(I, time, 0.06, 0.12, -45, 6);
% high a (greater than 0.10) and low d (~3) lead to more rapid spiking but also more irregular peak
% voltages
% v = ik_neuron(I, time, 0.075, 0.2, -45, 1);
% v = ik_neuron(I, time, 0.05500, 0.30, -45, 1);

%% interesting...
% v = ik_neuron(I, time, 0.5, 0.30, -45, 5);

%% after solving the error:
% v = ik_neuron(I, time, 0.20, 0.20, -65, 5);
% v = ik_neuron(I, time, 0.09, 0.135, -65, 0.5);

% loc_max = islocalmax(v);
% figure();
% times = 1:time+1;
% plot(times, v, times(loc_max), v(loc_max), 'r*');

% a = 0.07;
% figure();
% for i=1:length(b)
%     v = ik_neuron(I, time, a, b(i), c, d);
%     subplot(2, length(b)/2, i);
%     plot(1:time+1, v);
%     title(b(i));
% end
% 
% v = ik_neuron(I, time, a, b, c, d);
% figure();
% plot(1:time+1, v);