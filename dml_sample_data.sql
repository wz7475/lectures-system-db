-- Create 1 admin and 1 regular user

INSERT INTO USERS VALUES (1, 'admin', '12345', 1);
INSERT INTO USERS VALUES (2, 'user', '12345', 0);
INSERT INTO USERS VALUES (3, 'user2', '12345', 0);
commit;
-- 12345 are sample values, database  reveived and returns a hash of the password
-- hashes are handled by java application not by database

-- Create 2 sample lectures

INSERT INTO LECTURES VALUES(1, TO_DATE('1970-01-01 12:15:00', 'yyyy-mm-dd hh24:mi:ss'), 2, 5400000, 'J. angielski');
INSERT INTO LECTURES VALUES(2, TO_DATE('1970-01-01 14:00:00', 'yyyy-mm-dd hh24:mi:ss'), 2, 5400000, 'J. niemiecki');
commit;
-- Open session for admin

INSERT INTO SESSIONS VALUES(SYS_GUID(), 1);
commit;
-- Assign user to German

INSERT INTO LECTURES_USERS VALUES(2, 2);
commit;
-- yet another user to English
insert into lectures_users values(1, 3);
commit;
-- Create a new user's offer to swap German with English

INSERT INTO OFFERS VALUES(1, 2, 1, 2);
commit;
-- Create a new opinion on German posted by user

INSERT INTO OPINIONS VALUES(1, 'I did not like it, I should have signed up for English instead.',
                            TO_TIMESTAMP('2022-01-20 12:00:00', 'yyyy-mm-dd hh24:mi:ss'), 2, 2);
commit;