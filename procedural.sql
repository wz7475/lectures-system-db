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

CREATE OR REPLACE TRIGGER tg_offers_history
    AFTER INSERT OR DELETE
    ON offers
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO offers_history
        VALUES (offers_history_id_sequence.nextval, :new.offered_lecture_id, :new.returned_lecture_id, :new.seller_id,
                NULL, SYSDATE, 'CREATE');
    END IF;

    IF DELETING THEN
        IF NOT EXISTS(SELECT 1 FROM offers_history oh WHERE oh.id = :old.id AND oh.operation_type = 'EXCHANGE') THEN
            INSERT INTO offers_history
            VALUES (offers_history_id_sequence.nextval, :old.offered_lecture_id, :old.returned_lecture_id,
                    :old.seller_id, NULL, SYSDATE, 'DELETE');
        END IF;
    END IF;
END;

-- ================ ================ ================ ================
--                             PROCEDURES
-- ================ ================ ================ ================
CREATE OR REPLACE PROCEDURE change_password(p_id NUMBER, p_password VARCHAR(64)) AS
    v_password NUMBER;
BEGIN
    v_password := hash_value(p_password);
    UPDATE users SET password = v_password WHERE id = p_id;
END;

CREATE OR REPLACE PROCEDURE accept_offer(p_offer_id NUMBER, p_buyer_id NUMBER) AS
BEGIN
    -- @TODO: Change lectures between users
    -- @TODO: Delete offer
    -- @TODO: Add offer to offers_history
END;

-- ================ ================ ================ ================
--                             FUNCTIONS
-- ================ ================ ================ ================
CREATE OR REPLACE FUNCTION hash_value(p_value VARCHAR(128)) RETURN NUMBER AS
    v_hash NUMBER;
BEGIN
    SELECT ora_hash(p_value, 4294967295, 1296852950) INTO v_hash FROM dual;
    RETURN v_hash;
END;

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