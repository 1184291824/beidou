
%---------------------------------------------
%       Program initialization
%---------------------------------------------
clc;
clearvars -except RCS;

%---------------------------------------------
%       Set basic parameters
%---------------------------------------------
num_of_big = 4;  % 4*4 antenna array
num_of_small = 2; % 2*2 Subarray
center_angle = 80;  % The central angle is 80 degrees (angle system)
p = 0.015;  % period
lambda = 0.0375;  % wavelength
phi_scan = '1';  % ���phi_scan��'1'������ɨ�裬�����Ҫɨ��phi�����뽫phi_scan����Ϊ'180'
plotOrNot = true ;  % �Ƿ�ͼ
xlsOrNot = false;  % �Ƿ����xls�ļ�
xlsName = 'result';

%---------------------------------------------
%       Read files
%---------------------------------------------

PHI = [14.9604,-75.5002,-154.2015,-242.6656]./180*pi;
subscript_mat = [1 2 3 2;3 3 1 3;3 3 4 2;2 1 4 2];
subscript_mat = kron(subscript_mat, ones(num_of_small));

%---------------------------------------------
%       Data preprocessing
%---------------------------------------------

side_length = num_of_big * num_of_small;  % ���л���
center_angle = center_angle / 180 * pi;  % Բ�Ľ�
R =  side_length * p / center_angle;  % ��֪n��p����Բ�Ľǣ����ݻ�����ʽ���R
k = 2 * pi / lambda;   % ������

h0 = R * cos( center_angle / 2 );  % �����Ҹ�
hn = R * cos((R * center_angle / 2 - p*((1:side_length) - 1/2)) / R) - h0; 
p0 = R * sin( center_angle / 2 );  % ���ҳ�
pn =- R * sin((R * center_angle/2 - p*((1:side_length) - 1/2)) / R) + p0;
m = linspace(1, side_length, side_length)';

phi_scan = str2double(phi_scan);  % ��ԭ���ַ��͵�phi_scanת��Ϊdouble��

f = ones(phi_scan,181);

%---------------------------------------------
%       ���㷽��ͼ
%---------------------------------------------
PHI_h = kron(2 * k * hn - pi, ones(side_length,1));
 for phi = 1:phi_scan
    for theta = linspace(-90,90,181)
        Arc_theta = theta/180*pi;
        Arc_phi = (phi-1)/180*pi;
        PHI_p = k * sin(Arc_theta) * (cos(Arc_phi) * pn + sin(Arc_phi) * p*(m-1/2));
        f(phi, theta+91) = sum(sum( reshape( RCS(phi, theta+91, subscript_mat), [side_length,side_length] ) .* exp(-1i * (PHI_h + PHI_p + PHI(subscript_mat) ) ) ) ,2 ); 
    end
 end
f= 20*log10(abs(f));

%---------------------------------------------
%       ��ͼ
%---------------------------------------------

if plotOrNot == true
    if phi_scan == 1
        plot( -90:90, f(1,:), 'LineWidth', 3 );
        title = '1D����ͼ';
    else
        theta=linspace(0,pi);
        phi=linspace(0,2*pi);
        [tt,pp]=meshgrid(theta,phi);
        [x,y,z] = sph2cart(pp,pi/2-tt,f);
        surf(x,y,z)
        shading flat
    end
    yy = ylabel('RCS(dB)');
    xx = xlabel('Theta(deg)');
    set(xx,'FontSize',20);
    set(yy,'FontSize',20);
end

%---------------------------------------------
%       ����ļ�
%---------------------------------------------

if xlsOrNot == true
    ff = f';
    file_name = ['\data_result\',xlsName,'.xlsx'];
    xlswrite(file_name,ff);
end
