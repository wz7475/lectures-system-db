-- Create 1 admin and 1 regular user

INSERT INTO USERS VALUES (1, 'admin', '12345', 1);
INSERT INTO USERS VALUES (2, 'user', '12345', 0);

-- Create 2 sample lectures

INSERT INTO LECTURES VALUES(1, TO_DATE('1970-01-01 12:15:00', 'yyyy-mm-dd hh24:mi:ss'), 2, 5400000, 'J. angielski');
INSERT INTO LECTURES VALUES(2, TO_DATE('1970-01-01 14:00:00', 'yyyy-mm-dd hh24:mi:ss'), 2, 5400000, 'J. niemiecki');

-- Open session for admin

INSERT INTO SESSIONS VALUES(SYS_GUID(), 1);

-- Assign user to German

INSERT INTO LECTURES_USERS VALUES(2, 2);

-- Create a new user's offer to swap German with English

INSERT INTO OFFERS VALUES(1, 2, 1, 2);

-- Create a new opinion on German posted by user

INSERT INTO OPINIONS VALUES(1, 'I did not like it, I should have signed up for English instead.', TO_TIMESTAMP('2022-01-20 12:00:00', 'yyyy-mm-dd hh24:mi:ss'), 2, 2);

commit;