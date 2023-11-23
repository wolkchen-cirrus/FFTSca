inputs = "water";

folder = fileparts(mfilename('fullpath'));
addpath(genpath(folder));
data_dir = "C:\Users\jg17acv\University of Hertfordshire\PI Group - Documents\Projects\UCASS\Calibration\CalibrationScripts\JG-UCASSCal-20211118\glmt_output\" + inputs;
path = dir(data_dir);
path = {path.name};
row_del = [];
for i=1:size(path, 2)
    if isfolder(path{i}) == true
        row_del = [row_del, i];
    elseif ~contains(path{i}, '.dat')
        row_del = [row_del, i];
    end
end
path(row_del) = [];  
C_sca = zeros(size(path, 2), 1);
rad = zeros(size(path, 2), 1);
for i=1:size(path, 2)
    data = readmatrix(path{i});
    if isempty(data)
        continue
    end
    len = floor(size(data, 1)/2);
    ang = flip(abs(data(1:len, 1)));
    sca = flip(data(1:len, 3)).*sin(ang*pi/180).*Weight(ang*pi/180);
    rad(i) = str2double(strjoin(regexp(path{i}, '\d*', 'Match'), '.'));
    C_sca(i) = trapz((ang*pi/180), sca)*1e-12;
end
scs_tab = [rad, C_sca];
scs_tab = scs_tab(all(scs_tab,2),:);
scs_tab = sortrows(scs_tab);
name = input("name?");
if ~isempty(name)
    writematrix(scs_tab, data_dir + name)
end
plot(scs_tab(:,1), scs_tab(:, 2))
