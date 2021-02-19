% http://mirlab.org/jang/books/audiosignalprocessing/speechFeatureMfcc_chinese.asp?title=12-2%20MFCC
clear all;

%%預強調（Pre-emphasis）:
%將語音訊號 s(n) 通過一個高通濾波器：H(z)=1-a*z-1 其中 a 介於 0.9 和 1.0 之間。
% 若以時域的運算式來表示，預強調後的訊號 s2(n) 為 s2(n) = s(n) - a*s(n-1)
%這個目的就是為了消除發聲過程中聲帶和嘴唇的效應，來補償語音信號受到發音系統所壓抑的高頻部分。
% （另一種說法則是要突顯在高頻的共振峰。）下面這個範例可以示範預強調所產生的效果：

[y, fs] = audioread('0010.wav'); 
au = audioread('0010.wav'); 
au = [y, fs] ;
y = y(1:16000*3)
a=0.95;
y2 = filter([1, -a], 1, y);
time=(1:length(y))/fs;
au2=au; au2.signal=y2;
audiowrite(au2, '0010_preEmphasis.wav'); 

subplot(2,1,1);
plot(time, y);
title('Original wave: s(n)');
subplot(2,1,2);
plot(time, y2);
title(sprintf('After pre-emphasis: s_2(n)=s(n)-a*s(n-1), a=%f', a));

subplot(2,1,1);
set(gca, 'unit', 'pixel');
axisPos=get(gca, 'position');
uicontrol('string', 'Play', 'position', [axisPos(1:2), 60, 20], 'callback', 'sound(y, fs)');
subplot(2,1,2);
set(gca, 'unit', 'pixel');
axisPos=get(gca, 'position');
uicontrol('string', 'Play', 'position', [axisPos(1:2), 60, 20], 'callback', 'sound(y2, fs)');
