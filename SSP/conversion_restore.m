clear all;

files = dir('*.wav');  %將所有wav檔input
for i = 1:length(files)
    [y,fs] = audioread(files(i).name);
    y = y(:,1); %單聲道轉雙聲道
    y1 = resample(y,16000,fs);  % 將採樣率轉為 16 bits
    audiowrite(['output\' files(i).name], y1, 16000); %儲存重採檔案
end

