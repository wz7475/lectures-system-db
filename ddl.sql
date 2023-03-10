-- USERS
begin
    execute immediate 'drop table USERS cascade constraints';
exception
    when others then if sqlcode != -942 then raise; end if;
end;
/
CREATE TABLE USERS
(
    ID       NUMBER(19)
        CONSTRAINT USERS_PK PRIMARY KEY,
    NAME     VARCHAR2(255) UNIQUE NOT NULL,
    PASSWORD VARCHAR2(255)        NOT NULL,
    IS_ADMIN NUMBER(1)            NOT NULL
);

-- SESSIONS
begin
    execute immediate 'drop table SESSIONS cascade constraints';
exception
    when others then if sqlcode != -942 then raise; end if;
end;
/
CREATE TABLE SESSIONS
(
    ID      RAW(16)
        CONSTRAINT SESSIONS_PK PRIMARY KEY,
    USER_ID NUMBER(19) NOT NULL
        CONSTRAINT USERS_FK REFERENCES USERS (ID) ON DELETE CASCADE
);


-- LECTURES
begin
    execute immediate 'drop table LECTURES cascade constraints';
exception
    when others then if sqlcode != -942 then raise; end if;
end;
/
CREATE TABLE LECTURES
(
    ID          NUMBER(19)
        CONSTRAINT LECTURES_PK PRIMARY KEY,
    BEGIN_TIME  DATE          NOT NULL,
    DAY_OF_WEEK NUMBER(5)     NOT NULL,
    DURATION    NUMBER(21)    NOT NULL,
    NAME        VARCHAR2(255) NOT NULL,
    CONSTRAINT DAY_OF_WEEK_VAL CHECK ( DAY_OF_WEEK BETWEEN 0 AND 6 ),
    CONSTRAINT UNIQUE_LECTURE UNIQUE (BEGIN_TIME, DAY_OF_WEEK, DURATION, NAME)
);

-- LECTURES_USERS
begin
    execute immediate 'drop table LECTURES_USERS cascade constraints';
exception
    when others then if sqlcode != -942 then raise; end if;
end;
/
CREATE TABLE LECTURES_USERS
(
    LECTURE_ID NUMBER(19) NOT NULL
        CONSTRAINT LECTURE_LU_FK REFERENCES LECTURES (ID) ON DELETE CASCADE,
    USERS_ID   NUMBER(19) NOT NULL
        CONSTRAINT USERS_LU_FK REFERENCES USERS (ID) ON DELETE CASCADE,
    CONSTRAINT UNIQUE_ASSIGNMENT UNIQUE (LECTURE_ID, USERS_ID)
);

-- OPINIONS
begin
    execute immediate 'drop table OPINIONS cascade constraints';
exception
    when others then if sqlcode != -942 then raise; end if;
end;
/
CREATE TABLE OPINIONS
(
    ID         NUMBER(19)     NOT NULL
        CONSTRAINT OPINION_PK PRIMARY KEY,
    CONTENT    VARCHAR2(1024) NOT NULL,
    CREATED_AT TIMESTAMP(6)   NOT NULL,
    LECTURE_ID NUMBER(19)     NOT NULL
        CONSTRAINT LECTURE_OP_FK REFERENCES LECTURES (ID) ON DELETE CASCADE,
    USER_ID    NUMBER(19)     NOT NULL
        CONSTRAINT USER_OP_FK REFERENCES USERS (ID) ON DELETE CASCADE
);

-- OFFERS
begin
    execute immediate 'drop table OFFERS cascade constraints';
exception
    when others then if sqlcode != -942 then raise; end if;
end;
/
CREATE TABLE OFFERS
(
    ID                  NUMBER(19) NOT NULL
        CONSTRAINT OFFER_PK PRIMARY KEY,
    OFFERED_LECTURE_ID  NUMBER(19) NOT NULL
        CONSTRAINT OFFERED_LECTURE_FK REFERENCES LECTURES (ID) ON DELETE CASCADE,
    RETURNED_LECTURE_ID NUMBER(19) NOT NULL
        CONSTRAINT RETURNED_LECTURE_FK REFERENCES LECTURES (ID) ON DELETE CASCADE,
    SELLER_ID           NUMBER(19) NOT NULL
        CONSTRAINT SELLER_FK REFERENCES USERS (ID) ON DELETE CASCADE,
    CONSTRAINT UNIQUE_OFFER UNIQUE (OFFERED_LECTURE_ID, RETURNED_LECTURE_ID, SELLER_ID)
);

-- LECTURES_HISTORY
-- A record in this table is created when a user is assigned to a lecture

-- drop table if exists
begin
    execute immediate 'drop table LECTURES_HISTORY';
    execute immediate 'DROP SEQUENCE LECTURES_HISTORY_ID_SEQUENCE';
exception
    when others then if sqlcode != -942 then raise; end if;
end;
/
CREATE TABLE LECTURES_HISTORY
(
    ID              NUMBER(19)
        CONSTRAINT LH_PK PRIMARY KEY,
    LECTURE_ID      NUMBER(19)
        CONSTRAINT LECTURE_LH_FK REFERENCES LECTURES (ID) ON DELETE SET NULL,
    USER_ID         NUMBER(19)
        CONSTRAINT USER_LH_FK REFERENCES USERS (ID) ON DELETE SET NULL,
    ASSIGNMENT_DATE DATE NOT NULL,
    TYPE            VARCHAR2(255) NOT NULL
);
CREATE SEQUENCE LECTURES_HISTORY_ID_SEQUENCE START WITH 0 INCREMENT BY 1 MINVALUE 0;

-- OFFERS_HISTORY
-- A record in this table is created when an offer is accepted and lectures assignments are swapped
begin
    -- drop table if exists
    execute immediate 'DROP TABLE OFFERS_HISTORY CASCADE CONSTRAINTS';
    execute immediate 'DROP SEQUENCE OFFERS_HISTORY_ID_SEQUENCE';
    execute immediate 'DROP SEQUENCE OFFERS_ID_SEQUENCE';
exception
    when others then
        if sqlcode != -942 then
            raise;
        end if;
end;
/
CREATE TABLE OFFERS_HISTORY
(
    ID                  NUMBER(19)
        CONSTRAINT OH_PK PRIMARY KEY,
    OFFERED_LECTURE_ID  NUMBER(19)
        CONSTRAINT OFFERED_LECTURE_OH_FK REFERENCES LECTURES (ID) ON DELETE SET NULL,
    RETURNED_LECTURE_ID NUMBER(19)
        CONSTRAINT RETURNED_LECTURE_OH_FK REFERENCES LECTURES (ID) ON DELETE SET NULL,
    SELLER_ID           NUMBER(19)
        CONSTRAINT SELLER_USER_OH_FK REFERENCES USERS (ID) ON DELETE SET NULL,
    BUYER_ID            NUMBER(19)
        CONSTRAINT BUYER_USER_OH_FK REFERENCES USERS (ID) ON DELETE SET NULL,
    ACCEPTANCE_DATE     DATE NOT NULL,
    operation_type     VARCHAR2(255) NOT NULL
);

CREATE SEQUENCE OFFERS_HISTORY_ID_SEQUENCE START WITH 0 INCREMENT BY 1 MINVALUE 0;

CREATE SEQUENCE OFFERS_ID_SEQUENCE START WITH 10 INCREMENT BY 1 MINVALUE 0;
-- only for test purposes, id is generated by java code