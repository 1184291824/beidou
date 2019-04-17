
%---------------------------------------------
%       Program initialization
%---------------------------------------------
clc;
clear;

%---------------------------------------------
%       Set basic parameters
%---------------------------------------------
num_of_big = 4;  % 4*4 antenna array
num_of_small = 2; % 2*2 Subarray
center_angle = 80;  % The central angle is 80 degrees (angle system)
p = 0.015;  % period
lambda = 0.0375;  % wavelength
phi_scan = '1';  % ���phi_scan��'1'������ɨ�裬�����Ҫɨ��phi�����뽫phi_scan����Ϊ'180'

%---------------------------------------------
%       Read files
%---------------------------------------------

RCS1 = [xlsread('.\date_source\Rcs.xlsx', 'Sheet1', ['JK1:MW', phi_scan]), xlsread('.\date_source\Rcs.xlsx', 'Sheet1', ['A1:CL', phi_scan])];
RCS2 = [xlsread('.\date_source\Rcs.xlsx', 'Sheet2', ['JK1:MW', phi_scan]), xlsread('.\date_source\Rcs.xlsx', 'Sheet2', ['A1:CL', phi_scan])];
RCS3 = [xlsread('.\date_source\Rcs.xlsx', 'Sheet3', ['JK1:MW', phi_scan]), xlsread('.\date_source\Rcs.xlsx', 'Sheet3', ['A1:CL', phi_scan])];
RCS4 = [xlsread('.\date_source\Rcs.xlsx', 'Sheet4', ['JK1:MW', phi_scan]), xlsread('.\date_source\Rcs.xlsx', 'Sheet4', ['A1:CL', phi_scan])];
PHI = [14.9604,-75.5002,-154.2015,-242.6656]./180*pi;
subscript_mat = [1 2 3 2;3 3 1 3;3 3 4 2;2 1 4 2];
subscript_mat = repeat_mat(subscript_mat, 8, 4);

%---------------------------------------------
%       Data preprocessing
%---------------------------------------------
RCS = {RCS1 RCS2 RCS3 RCS4};  % ����ͼԪ��
side_length = num_of_big * num_of_small;  % ���л���
center_angle = center_angle / 180 * pi;  % Բ�Ľ�
R =  side_length * p / center_angle;  % ��֪n��p����Բ�Ľǣ����ݻ�����ʽ���R
k = 2 * pi / lambda;   % ������

h0 = R * cos( center_angle / 2 );  % �����Ҹ�
hn = R * cos((R * center_angle / 2 - p*([1:side_length] - 1/2)) / R) - h0; 
p0 = R * sin( center_angle / 2 );  % ���ҳ�
pn =- R * sin((R * center_angle/2 - p*([1:side_length] - 1/2)) / R) + p0;

phi_scan = str2double(phi_scan);  % ��ԭ���ַ��͵�phi_scanת��Ϊdouble��

f = ones(phi_scan,181);

%---------------------------------------------
%       ���㷽��ͼ
%---------------------------------------------
PHI_h = 2 * k * hn - pi;
for phi = 1:phi_scan
    i = 0; 
    for theta = linspace(-90,90,181)
        i = i+1;
        sum = 0;
        Arc_theta = theta/180*pi;
        Arc_phi = phi/180*pi;
        PHI_p = k * sin(Arc_theta) * (cos(Arc_phi) * pn + sin(Arc_phi) * p*(m-1/2));
        %%%%%%%%�Ż���������%%%%%%%%
        sum = sum + Rcs(subscript_mat(m,n), theta+91)*exp(-1i * (PHI_h+PHI_p+PHI_i + PHI(subscript_mat(m,n))) );  % ��������
    end
end
f(2,:) = abs(f(2,:));
f(2,:) = 20*log10(f(2,:));

plot(f(1,:), f(2,:),'LineWidth',3);     %��ͼ������ɾ
% hold on
% plot(zsh(1,:),zsh(2,:),'LineWidth',3)   %����ע��
% hold on
% plot(feko(1,:),feko(2,:),'LineWidth',3) %����ע��
% legend('lsy&mzx','zsh','feko')
% legend('lsy&mzx','zsh')
yy = ylabel('RCS(dB)');
xx = xlabel('Theta(deg)');
set(xx,'FontSize',20);
set(yy,'FontSize',20);


time_now = datestr(now,30);
ff = f';
file_name = ['\data_result\result_XOZ_',time_now,'.xlsx'];
xlswrite(file_name,ff);