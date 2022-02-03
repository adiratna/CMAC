% Jaringan CMAC Untuk Fungsi Non-Linear
% Jaringan CMAC dilatih dengan pasangan runtut (sequence). Input-output
% dinyatakan sebagai pasangan vektor X dan Y.
% X = [1, 2, 3, 4] dan Y = [1, 4, 9, 16]
% Digunakan parameter kuantisasi yang sama (\inc)=0,1 untuk semua
% masukan.Cacah memori bobotnya (cm) = 40. Bobot awal bernilai acak dan
% terdistribusi seragam. Learning rate (\beta)=1, artinya diperlukan 1
% epoch. Parameter generalisasi (C) yaitu 10 dan 5, fungsinya akan dilihat
% pengaruhnya terhadap error bila jaringan di uji dengan data yang berbeda.
% xuji = [1 1,5 2,5 4]

% Solusi 

clc;
clear;
c = 10    % Parameter generalisasi = 10
q = 0.1     % Parameter kuantisasi = 0.1
cdp = 4;    % Cacah data pelatihan = 4
cm = 40;    % Cacah memori = 40
beta = 1;   % laju pelatihan (learning rate)
rand('seed',0);    % Memanggil bilangan acak
w = rand(40,1);     % Bobot awal acak terdistribusi seragam
x = [1 2 3 4];      % Vektor input pelatihan
yd = [1 4 9 16]     % Vektor output target
s = x;              % Ambil vektor masukan
sp =(1/q)*s;        % Dibagi dengan parameter kuantisasi
wb = w;             % Tentukan vektor bobot awal secara acak
for j = 1:cdp       % Mulai pelatihan
    wp = 0;         % Bobot awal = 0
    for i = 1:c     % Untuk semua layer (c=10)
        a(i) = sp(j) - mod((sp(j)-i),c);   % Virtual address
        ap(i) = mod(a(i),cm);                % Physical address dari 40 lokasi
        wp = wp+wb(ap(i)+1);                % Jumlahkan bobot
        xw(i) = ap(i)+1;                    % Physical address selanjutnya
    end;
    
    ys = (1/c)*wp;                          % Output CMAC
    dw = beta*(yd(j)-ys);                   % Perubahan bobot
    for n = 1:c                             % Untuk 10 bobot
      wb(xw(n)) = w(xw(n))+dw;                     % Pembaruan bobot
    end;
end

su = [1 1.5 2.5 4];                         % 4 data uji
sp = (1/q)*su;                              % Kuantisasi data uji
for j = 1:cdp                               % Untuk 4 data uji
    wp = 0;                                 % Bobot awal = 0
    for i = 1:c                             % Untuk 10 layer
        a(i) = sp(j)-mod((sp(j)-i),c);       % Menentukan virtual address
        ap(i) = mod(a(i),cm);               % Menentukan physical address
        wp = wp+wb(ap(i)+1);                % Jumlahkan bobot
    end;
    ys(j) = (1/c)*wp;                       % Hitung output CMAC
end;

plot(x,yd,su,ys);                           % Gambaran output CMAC
title('Kurva Pelatihan dan Kurva Uji');
xlabel('Masukan (x)');
ylabel('Keluaran (y)');
gtext('yd');
gtext('ys');

    
     