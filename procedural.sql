-- ================ ================ ================ ================
--                              TRIGGERS
-- ================ ================ ================ ================
CREATE OR REPLACE TRIGGER tg_lectures_history
    AFTER INSERT OR DELETE
    ON lectures_users
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO lectures_history
        VALUES (lectures_history_id_sequence.nextval, :new.lecture_id, :new.users_id, SYSDATE, 'SIGN_UP');
    END IF;
--
    IF DELETING THEN
        INSERT INTO lectures_history
        VALUES (lectures_history_id_sequence.nextval, :old.lecture_id, :old.users_id, SYSDATE, 'OPT_OUT');
    END IF;
END;
/
drop trigger tg_lectures_history;


CREATE OR REPLACE TRIGGER tg_offers_history
    AFTER INSERT OR DELETE
    ON offers
    FOR EACH ROW
DECLARE
    v_count NUMBER := 0;
BEGIN
    IF INSERTING THEN
        INSERT INTO offers_history
        VALUES (offers_history_id_sequence.nextval, :new.offered_lecture_id, :new.returned_lecture_id, :new.seller_id,
                NULL, SYSDATE, 'CREATE');
    END IF;

    IF DELETING THEN
        SELECT count(*) INTO v_count FROM offers_history oh WHERE oh.offered_lecture_id = :old.offered_lecture_id AND oh.returned_lecture_id = :old.returned_lecture_id AND oh.operation_type = 'EXCHANGE';

        IF (v_count = 0) THEN
            INSERT INTO offers_history
            VALUES (offers_history_id_sequence.nextval, :old.offered_lecture_id, :old.returned_lecture_id,
                    :old.seller_id, NULL, SYSDATE, 'DELETE');
        END IF;
    END IF;
END;
/

-- ================ ================ ================ ================
--                             PROCEDURES
-- ================ ================ ================ ================
CREATE OR REPLACE PROCEDURE change_password(p_id NUMBER, p_password VARCHAR2) AS
    v_password NUMBER;
BEGIN
    v_password := hash_value(p_password);
    UPDATE users SET password = v_password WHERE id = p_id;
END;
/

CREATE OR REPLACE PROCEDURE accept_offer(p_offer_id NUMBER, p_buyer_id NUMBER) AS
    v_offer offers%ROWTYPE;
BEGIN
    SELECT * INTO v_offer FROM offers WHERE id = p_offer_id;

    UPDATE lectures_users SET users_id = v_offer.seller_id WHERE lecture_id = v_offer.offered_lecture_id;
    UPDATE lectures_users SET users_id = p_buyer_id WHERE lecture_id = v_offer.returned_lecture_id;

    INSERT INTO offers_history
    VALUES (offers_history_id_sequence.nextval, v_offer.offered_lecture_id, v_offer.returned_lecture_id,
            v_offer.seller_id, p_buyer_id, SYSDATE, 'EXCHANGE');

    DELETE offers WHERE id = v_offer.id;
END;
/

-- ================ ================ ================ ================
--                             FUNCTIONS
-- ================ ================ ================ ================
CREATE OR REPLACE FUNCTION hash_value(p_value VARCHAR2) RETURN NUMBER AS
    v_hash NUMBER;
BEGIN
    SELECT ora_hash(p_value, 4294967295, 1296852950) INTO v_hash FROM dual;
    RETURN v_hash;
END;
/

CREATE OR REPLACE FUNCTION find_best_offer(p_buyer_id NUMBER) RETURN NUMBER AS
    v_offer NUMBER := -1;
BEGIN
    FOR r_user_offer IN (SELECT * FROM offers WHERE seller_id = p_buyer_id)
        LOOP
            FOR r_offer IN (SELECT *
                            FROM offers
                            WHERE seller_id != p_buyer_id
                              AND offered_lecture_id = r_user_offer.returned_lecture_id
                              AND returned_lecture_id = r_user_offer.offered_lecture_id)
                LOOP
                    IF (v_offer = -1) THEN
                        v_offer := r_offer.id;
                    ELSIF (r_offer.id < v_offer) THEN
                        v_offer := r_offer.id;
                    END IF;
                END LOOP;
        END LOOP;

    RETURN v_offer;
END;