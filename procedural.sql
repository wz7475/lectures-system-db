-- ================ ================ ================ ================
--                              TRIGGERS
-- ================ ================ ================ ================
CREATE OR REPLACE TRIGGER tg_lectures_history
    AFTER INSERT OR DELETE
    ON lectures
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO lectures_history VALUES (); -- @TODO: Fill values
    END IF;

    IF DELETING THEN
        INSERT INTO lectures_history VALUES (); -- @TODO: Fill values
    END IF;
END;

CREATE OR REPLACE TRIGGER tg_offers_history
    AFTER INSERT OR DELETE
    ON offers
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO offers_history VALUES (); -- @TODO: Fill values
    END IF;

    IF DELETING THEN
        -- @TODO: Fill condition
        IF NOT EXISTS(SELECT 1 FROM offers_history oh WHERE oh.id = :old.id AND oh.type == '?') THEN
            INSERT INTO offers_history VALUES (); -- @TODO: Fill values
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

CREATE OR REPLACE PROCEDURE change_offer(p_offer_id NUMBER, p_buyer_id NUMBER) AS
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
    v_offer NUMBER;
BEGIN
    -- @TODO: Use cursor to find offer (oldest one)
    RETURN v_offer;
END;