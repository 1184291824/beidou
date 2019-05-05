% function [ output_args ] = main_function( subscript_mat )

%---------------------------------------------
%       Program initialization
%---------------------------------------------
% clc;
% clearvars -except RCS;

%---------------------------------------------
%       Set basic parameters
%---------------------------------------------
PHI = [113,33.045,-54.0469,-138.001; 90.3073, -61.5098, -123.967, -156.333; 64.3471, -121.966, -149.545, -164.283]./180*pi;
% PHI = [113,33.045,-54.0469,-138.001; 113,33.045,-54.0469,-138.001; 113,33.045,-54.0469,-138.001]./180*pi;
subscript_mat = [4,3,1,3;2,1,3,4;2,2,1,2;3,4,3,4];
num_of_big = 4;  % 4*4 antenna array
num_of_small = 4; % 2*2 Subarray
center_angle = 80;  % The central angle is 80 degrees (angle system)
p = 0.012;  % period
lambda = 3*10^8./[8*10^9,10*10^9,12*10^9];  % wavelength
phi_scan = '180';  % ���phi_scan��'1'������ɨ�裬�����Ҫɨ��phi�����뽫phi_scan����Ϊ'180'
%---------------------------------------------
%       Read files
%---------------------------------------------
  
subscript_mat = kron(subscript_mat, ones(num_of_small));

%---------------------------------------------
%       Data preprocessing
%---------------------------------------------

side_length = num_of_big * num_of_small;  % ���л���
center_angle = center_angle / 180 * pi;  % Բ�Ľ�
R =  side_length * p / center_angle;  % ��֪n��p����Բ�Ľǣ����ݻ�����ʽ���R
% k = 2 * pi ./ lambda;   % ������

h0 = R * cos( center_angle / 2 );  % �����Ҹ�
hn = R * cos((R * center_angle / 2 - p*((1:side_length) - 1/2)) / R) - h0; 
p0 = R * sin( center_angle / 2 );  % ���ҳ�
pn =- R * sin((R * center_angle/2 - p*((1:side_length) - 1/2)) / R) + p0;
m = linspace(1, side_length, side_length)';

phi_scan = str2double(phi_scan);  % ��ԭ���ַ��͵�phi_scanת��Ϊdouble��

f = ones(phi_scan,181 ,3);

%---------------------------------------------
%       ���㷽��ͼ
%---------------------------------------------
for fre = 1:3
k = 2 * pi ./ lambda(fre);   % ������
PHI_h = kron(2 * k * hn - pi, ones(side_length,1));
% for fre = 1:3
    for phi = 1:phi_scan
        for theta = linspace(-90,90,181)
            Arc_theta = theta/180*pi;
            Arc_phi = (phi-1)/180*pi;
            PHI_p = k * sin(Arc_theta) * (cos(Arc_phi) * pn + sin(Arc_phi) * p*(m-1/2));
            f(phi, theta+91, fre) = sum(sum( reshape( RCS(fre, phi, theta+91, subscript_mat), [side_length,side_length] ) .* exp(-1i * (PHI_h + PHI_p +reshape( PHI(fre,subscript_mat) , [side_length,side_length] ) ) ) ) ,2 );
        end
    end
end
f= 20*log10(abs(f));

% f1 = f(91,:,1);
f1 = f(1,:,1);
f2 = f(1,:,2);
f3 = f(1,:,3);

out  = [f1;f2;f3];

%---------------------------------------------
%       ����ļ�
%---------------------------------------------

% if xlsOrNot == true
    ff = out';
    file_name = ['\data_result\','DuoPinDian','.xlsx'];
    xlswrite(file_name,ff);
% end
% end

plot( -90:90, ff(:,3), 'LineWidth', 3 );

yy = ylabel('RCS(dB)');
xx = xlabel('Theta(deg)');
set(xx,'FontSize',20);
set(yy,'FontSize',20);



 