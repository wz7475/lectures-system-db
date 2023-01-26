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
