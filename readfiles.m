phi_scan = '1';  % ���phi_scan��'1'������ɨ�裬�����Ҫɨ��phi�����뽫phi_scan����Ϊ'180'

RCS1 = [xlsread('.\date_source\Rcs.xlsx', 'Sheet1', ['JK1:MW', phi_scan]), xlsread('.\date_source\Rcs.xlsx', 'Sheet1', ['A1:CL', phi_scan])];
RCS2 = [xlsread('.\date_source\Rcs.xlsx', 'Sheet2', ['JK1:MW', phi_scan]), xlsread('.\date_source\Rcs.xlsx', 'Sheet2', ['A1:CL', phi_scan])];
RCS3 = [xlsread('.\date_source\Rcs.xlsx', 'Sheet3', ['JK1:MW', phi_scan]), xlsread('.\date_source\Rcs.xlsx', 'Sheet3', ['A1:CL', phi_scan])];
RCS4 = [xlsread('.\date_source\Rcs.xlsx', 'Sheet4', ['JK1:MW', phi_scan]), xlsread('.\date_source\Rcs.xlsx', 'Sheet4', ['A1:CL', phi_scan])];

RCS(:,:,1)=RCS1;
RCS(:,:,2)=RCS2;
RCS(:,:,3)=RCS3;
RCS(:,:,4)=RCS4;