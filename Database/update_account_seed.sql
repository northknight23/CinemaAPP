USE CINEMADB;

UPDATE ACCOUNT SET PasswordHash = N'$2a$11$owbIr8t4FIYM3r81U/JK0O0V5MLlfXJa/djDOQmVSVdcPqK87v4KS' WHERE Username = 'admin';
UPDATE ACCOUNT SET PasswordHash = N'$2a$11$dRQp5JaD0YBLEgrMHeqJLOC5xpUM7lzjWl350Bgx3k.Q94fPpqLlm' WHERE Username = 'nv01';
UPDATE ACCOUNT SET PasswordHash = N'$2a$11$A5GcF5swCNAcRZKr0Y38yO6v4wbmekzetJk0coXPymW55eidc3nT.' WHERE Username = 'nv02';
UPDATE ACCOUNT SET PasswordHash = N'$2a$11$ph0xpcdHwytfB4/c1JoYK.ogvA5w6JMdAN9i9SwAq4Fsp2cOEalTu' WHERE Username = 'nv03';
UPDATE ACCOUNT SET PasswordHash = N'$2a$11$r6EVPRbd7ih80X.TmTnTjeQe0AtU0Uw1HWMeAMbgXBUTU4C6qlRdO' WHERE Username = 'nv04';

