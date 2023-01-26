-- joins
SELECT * FROM USERS JOIN SESSIONS ON USERS.ID = SESSIONS.USER_ID;
SELECT * FROM LECTURES JOIN LECTURES_USERS ON LECTURES.ID = LECTURES_USERS.LECTURE_ID JOIN USERS ON LECTURES_USERS.USERS_ID = USERS.ID;
SELECT * FROM OPINIONS JOIN LECTURES ON OPINIONS.LECTURE_ID = LECTURES.ID JOIN USERS ON OPINIONS.USER_ID = USERS.ID;
SELECT * FROM OFFERS JOIN LECTURES ON OFFERS.OFFERED_LECTURE_ID = LECTURES.ID JOIN USERS ON OFFERS.SELLER_ID = USERS.ID;
SELECT * FROM LECTURES_HISTORY JOIN LECTURES ON LECTURES_HISTORY.LECTURE_ID = LECTURES.ID JOIN USERS ON LECTURES_HISTORY.USER_ID = USERS.ID;
SELECT * FROM OFFERS_HISTORY JOIN LECTURES ON OFFERS_HISTORY.OFFERED_LECTURE_ID = LECTURES.ID JOIN USERS ON OFFERS_HISTORY.SELLER_ID = USERS.ID;

SELECT USERS.NAME, LECTURES.NAME, LECTURES_HISTORY.ASSIGNMENT_DATE
FROM USERS
JOIN LECTURES_USERS ON USERS.ID = LECTURES_USERS.USERS_ID
JOIN LECTURES ON LECTURES_USERS.LECTURE_ID = LECTURES.ID
JOIN LECTURES_HISTORY ON LECTURES_USERS.LECTURE_ID = LECTURES_HISTORY.LECTURE_ID AND USERS.ID = LECTURES_HISTORY.USER_ID;

SELECT USERS.NAME, LECTURES.NAME, LECTURES_USERS.LECTURE_ID
FROM USERS
JOIN LECTURES_USERS ON USERS.ID = LECTURES_USERS.USERS_ID
JOIN LECTURES ON LECTURES_USERS.LECTURE_ID = LECTURES.ID;

SELECT LECTURES.NAME, OPINIONS.CONTENT, OPINIONS.CREATED_AT
FROM LECTURES
JOIN OPINIONS ON LECTURES.ID = OPINIONS.LECTURE_ID



-- grouping

-- number of lectures  per day of week
SELECT DAY_OF_WEEK, COUNT(*) FROM LECTURES GROUP BY DAY_OF_WEEK;

-- number of lectures each user is assigned to
SELECT USERS_ID, COUNT(*) FROM LECTURES_USERS GROUP BY USERS_ID;

SELECT LECTURE_ID, AVG(length(CONTENT)) FROM OPINIONS GROUP BY LECTURE_ID;
-- get average length of opinion for each lecture

SELECT LECTURE_ID, COUNT(*) FROM OPINIONS GROUP BY LECTURE_ID;
-- get number of opinions for each lecture

SELECT LECTURE_ID, COUNT(*) FROM OPINIONS GROUP BY LECTURE_ID HAVING COUNT(*) > 1;
-- get number of opinions for each lecture with more than 1 opinion

SELECT DAY_OF_WEEK, SUM(DURATION) FROM LECTURES GROUP BY DAY_OF_WEEK;
-- get total duration of lectures per day of week


-- filters
SELECT * FROM LECTURES WHERE NAME = 'J. niemiecki';
SELECT * FROM SESSIONS WHERE USER_ID = 1;
SELECT * FROM OPINIONS WHERE LECTURE_ID = 2;
SELECT * FROM OFFERS WHERE OFFERED_LECTURE_ID = 2 AND RETURNED_LECTURE_ID = 1;
SELECT * FROM LECTURES_USERS WHERE USERS_ID = 2;


-- triggers
-- lecture history
INSERT INTO LECTURES_USERS VALUES(1, 2);
commit;
select * from LECTURES_HISTORY where TYPE like 'SIGN_UP';

delete from LECTURES_USERS where USERS_ID = 1 and LECTURE_ID = 2;
commit;
select * from LECTURES_HISTORY where TYPE = 'OPT_OUT';

-- offer history
INSERT INTO OFFERS VALUES(OFFERS_ID_SEQUENCE.nextval, 2, 1, 1);
commit;
select * from OFFERS_HISTORY where OPERATION_TYPE = 'CREATE';

delete from OFFERS where RETURNED_LECTURE_ID = 2  and OFFERED_LECTURE_ID = 1 AND SELLER_ID = 1;
commit;
select * from OFFERS_HISTORY where OPERATION_TYPE = 'DELETE';

