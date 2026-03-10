file = 'C:\data\ds004100\sub-HUP190\ses-presurgery\ieeg\sub-HUP190_ses-presurgery_task-ictal_acq-seeg_run-01_ieeg.edf'
data  = edfread(file);

channels_tsv_path="C:\data\ds004100\sub-HUP190\ses-presurgery\ieeg\sub-HUP190_ses-presurgery_task-ictal_acq-seeg_run-01_channels.tsv"
ch = readtable(channels_tsv_path, 'FileType','text', 'Delimiter','\t');

% column names are usually: name, type, units, status, status_description, ...
brainTypes = ["SEEG","ECOG","EEG"];
keep = ismember(string(ch.type), brainTypes) & ~strcmpi(string(ch.status), "bad");

brainNames = string(ch.name(keep));

data_c=data(:,brainNames)

% data_c: 274x149 container where each entry holds a 1024x1 double vector
% Goal: downsample each 1024->512 by pair-mean, then stack seconds vertically:
% X will be (274*512) x 149, then run t-SNE and plot.

% ---- 1) Make sure we have a plain cell array we can index into ----
if istable(data_c) || istimetable(data_c)
    data_c = table2cell(data_c);
end

[nSec, nCh] = size(data_c);

Fs  = 1024;
ds  = 2;                 % downsample factor (pair-mean)
nS  = Fs/ds;             % 512 samples per second after downsampling

X = zeros(nSec*nS, nCh, 'single');         % 140288 x 149
secId = repelem((1:nSec)', nS, 1);         % label each row by which second it came from

% ---- 2) Build X exactly as you described ----
for s = 1:nSec
    row0 = (s-1)*nS;
    for c = 1:nCh
        v = data_c{s,c};          % likely a 1x1 cell containing 1024x1 double
        if iscell(v), v = v{1}; end
        v = double(v(:));         % ensure numeric column vector

        % pair-mean downsample: (v1+v2)/2, (v3+v4)/2, ...
        v2 = (v(1:2:end-1) + v(2:2:end)) / 2;   % 512x1

        X(row0+(1:nS), c) = single(v2);
    end
end

% ---- 3) Optional: standardize per channel so amplitude doesn't dominate ----
X = zscore(double(X));   % zero-mean/unit-std per column (channel)

% ---- 4) Optional: subsample rows to make t-SNE faster (set step=1 to keep all) ----
step = 1;                % try 1 (all), 2, 4, 8 ...
keep = 1:step:size(X,1);
Xk = X(keep,:);
secK = secId(keep);

% ---- 5) t-SNE + plot ----
rng default
Y = tsne(Xk, ...
    'NumDimensions', 2, ...
    'Perplexity', 30, ...
    'NumPCAComponents', 50, ...   % speeds up + denoises a bit
    'Standardize', false);        % already zscored above

scatter(Y(:,1), Y(:,2), 6, secK, 'filled');
xlabel('t-SNE 1'); ylabel('t-SNE 2');
title(sprintf('t-SNE of SEEG snapshots during seizure', step));
colorbar
