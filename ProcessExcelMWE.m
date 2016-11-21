function ProcessExcelMWE()
% Converts all BioHarness generated Excel files of posture data into
% downsampled Matlab files of acceleration data.
% Currently this is a "minimum working example" as it requires manual
% creation of the file containing correction data and file names. A future
% TODO is to create a script which can generate these (semi)-automatically.


% Skip this automation step for now. TODO: maybe come back and write this
% in a more automated way eventually.
% % Change to the folder containing the data files.
% working_dir = pwd;
% data_dir = uigetdir;
% cd(data_dir);
% 
% % Load the data file in this folder.
% % This should be a .mat file in struct format. The first line should give
% % the title of each compatible Excel file in the folder. The second line
% % should consist of 1s and 0s, for whether the files has already been 
% % processed or not.
% data = load(file_listing.mat);
% number_files = length(data);

data = uigetfile('*.xlsx','Select all files to process','MultiSelect','on');

number_files = length(data);

% Process each Excel file.
for i = 1:number_files
    fileName = data{i};
    % Determine how many sheets are in the file
    [~,sheets] = xlsfinfo(fileName);
    number_sheets = length(sheets);
    % Store each of the components of the data.
    % NOTE: These data files are huge. XLSRead is very slow.This will take 
    % a long time.
    for j = 3:number_sheets   % This assumes the data begins on sheet 3.
        times(j-2) = xlsread(fileName,j,'A:A');
        acc_v(j-2) = xlsread(fileName,j,'B:B');
        acc_l(j-2) = xlsread(fileName,j,'C:C');
        acc_s(j-2) = xlsread(fileName,j,'D:D');
    end
    disp('File read succsessfully.')
    
    % Straighten out the vectors:
    time_vec = times(:);  clear times;
    acc_v_vec = acc_v(:); clear acc_v;
    acc_l_vec = acc_l(:); clear acc_l;
    acc_s_vec = acc_s(:); clear acc_s;
    
    % Downsample the data to 1hz from 100hz
    % WARNING: this requires the signal processing toolbox!
    times = downsample(time_vec,100);
    acc_v = downsample(acc_v_vec,100);
    acc_l = downsample(acc_l_vec,100);
    acc_s = downsample(acc_s_vec,100);
    
    % Compute the associated posture
    theta = AccelToPosture(acc_l,acc_s,acc_v);
    
    % Apply the correction factor
    if length(theta) > 45
        correction_factor = mean(theta(15:45));
        theta = theta + correction_factor;
    else
        disp('Cannot apply correction to',filename);
    end
    
    % Save the downsampled data to a .mat file.
    downsampled_data = [times,acc_v,acc_l,acc_s,theta];
    save_name = strcat(name,'_downsampled','.mat');
    save(save_name,downsampled_data);
    
    % Do the CEVA
    bins = zeros(1,9);
    bins = AccelerationCEVA(theta);
    disp(bins);
end

end
    