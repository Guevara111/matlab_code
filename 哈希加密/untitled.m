%%
%DES

plaintext = round(rand(1,64));
[ciphertext,key] = DES(plaintext);       % Encryption syntex 1
[ciphertext1,key] = DES(plaintext,'ENC'); % Encryption syntex 2
deciphertext1 = DES(ciphertext1,'DEC',key);% Decryption syntex

key56 = round(rand(1,56));
[ciphertext2,key64] = DES(plaintext,'ENC',key56);% Encryption syntex 3 (56-bit key)
deciphertext2 = DES(ciphertext2,'DEC',key64);     % Decryption syntex   (64-bit key)
ciphertext3 = DES(plaintext,'ENC',key64);       % Encryption syntex 3 (64-bit key)
deciphertext3 = DES(ciphertext3,'DEC',key56);     % Decryption syntex   (56-bit key)

% plot results
subplot(4,2,1),plot(plaintext),ylim([-.5,1.5]),xlim([1,64]),title('plaintext')
subplot(4,2,2),plot(ciphertext),ylim([-.5,1.5]),xlim([1,64]),title('ciphertext')
subplot(4,2,3),plot(deciphertext1),ylim([-.5,1.5]),xlim([1,64]),title('deciphertext1')
subplot(4,2,4),plot(ciphertext1),ylim([-.5,1.5]),xlim([1,64]),title('ciphertext1')
subplot(4,2,5),plot(deciphertext2),ylim([-.5,1.5]),xlim([1,64]),title('deciphertext2')
subplot(4,2,6),plot(ciphertext2),ylim([-.5,1.5]),xlim([1,64]),title('ciphertext2')
subplot(4,2,7),plot(deciphertext3),ylim([-.5,1.5]),xlim([1,64]),title('deciphertext3')
subplot(4,2,8),plot(ciphertext3),ylim([-.5,1.5]),xlim([1,64]),title('ciphertext3')

%%
