clear all;

%% feature_extraction
input_dir = ['data/record/'];
output_dir = ['features/'];


if exist(output_dir, 'dir')
    rmdir(output_dir, 's');
end
mkdir(output_dir);


files = dir([input_dir '*.wav']);
num_of_files = length(files);
for i = 1:num_of_files
    [y, fs] = audioread([files(i).folder '/' files(i).name]);
    [cepstra, aspectrum, pspectrum] = melfcc(y, fs, 'wintime', 0.032, 'hoptime', 0.016, 'dither', 1);
    delta_cepstra = deltas(cepstra);
    delta_delta_cepstra = deltas(delta_cepstra);  %delta:動差、變化量
    mfcc = [cepstra; delta_cepstra; delta_delta_cepstra];
    save([output_dir '/' files(i).name '.txt'], 'mfcc', '-ascii');
end
toc

%% DTW

clear all;

for i = 1:5
    ref{i} = load(['features/' '10_0' num2str(i) '_01.wav.txt']);
end


for i = 1:5
    test{i} = load(['features/' '10_0' num2str(i) '_03.wav.txt']);
    gt(i) = i+1;
end


for i = 1: length(test)
    for j = 1: length(ref)
        [dist, d, D] = dtw(test{i}', ref{j}');
        dist1(i,j) = dist;
    end
end

[val, ind] = min(dist1');
cfm = confusionmat(gt, ind);
acc = sum(diag(cfm)) / sum(sum(cfm)) * 100


%% feature vicual
input_dir = ['data/record/'];
[y, fs] = audioread([input_dir '10_01_01.wav']);


framesize_time = 32;
framesize = framesize_time * fs / 1000;
shiftsize_time = 16;
shiftsize = shiftsize_time * fs / 1000;
original_matrix = buffer(y, framesize, (framesize - shiftsize), 'nodelay');

[num_of_samples, num_of_frames] = size(original_matrix);

hamming_window = hamming(num_of_samples);

for i = 1:num_of_frames
    hamming_matrix(:, i) = original_matrix(:, i) .* hamming_window;
end



figure(1)
plot((1:length(y)) / shiftsize, y);
title('Waveform');
xlabel('Frame');
ylabel('Amplitude');
axis ([-inf inf -max(abs(y)) max(abs(y))]);
print('-djpeg', '-f1', '-r300', 'SSP-01');




figure(2)
subplot(5, 1, 1);
plot((1:length(y)) / shiftsize, y);
title('Waveform');
xlabel('Frame');
ylabel('Amplitude');
axis ([-inf inf -max(abs(y)) max(abs(y))]);

subplot(5, 1, 2);
plot(energy, 'b');
hold on;
plot(movmean(energy, 5), 'r');
legend('original', 'smoothing');
title('Energy');
xlabel('Frame');
ylabel('Intensity');
axis tight;

subplot(5, 1, 3);
plot(ZCR / framesize, 'b');
hold on;
plot(movmean(ZCR / framesize, 5), 'r');
legend('original', 'smoothing');
title('Zero Crossing Rate');
xlabel('Frame');
ylabel('Rate');
axis ([-inf inf 0 1]);

subplot(5, 1, 4);
plot(original_pitch, 'b');
hold on;
plot(movmean(original_pitch, 5), 'r');
legend('original', 'smoothing');
title('Pitch');
xlabel('Frame');
ylabel('Hz');
axis tight;

subplot(5, 1, 5);
plot((1:length(y)) / shiftsize, y);
axis ([-inf inf -max(abs(y)) max(abs(y))]);
hold on;
plot([begin_ind, begin_ind], [-max(abs(y)), max(abs(y))], 'r');
plot([end_ind, end_ind], [-max(abs(y)), max(abs(y))], 'g');
title('End point detection');
xlabel('Frame');
ylabel('Amplitude');
axis tight;





















