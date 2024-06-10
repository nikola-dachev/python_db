CREATE FUNCTION fn_full_name(first_name VARCHAR(50), last_name VARCHAR(50))
RETURNS VARCHAR
LANGUAGE plpgsql

AS 
$$

DECLARE full_name VARCHAR(100);

BEGIN 

SELECT CONCAT(INITCAP(first_name), ' ', INITCAP(last_name)) INTO full_name;

RETURN full_name;

END;
$$



CREATE FUNCTION fn_calculate_future_value(initial_sum INT, yearly_interest_rate DECIMAL, number_of_years INT)
RETURNS DECIMAL
LANGUAGE plpgsql

AS 
$$

DECLARE future_value DECIMAL;

BEGIN
SELECT initial_sum *((1+yearly_interest_rate) ^(number_of_years)) INTO future_value;

RETURN TRUNC(future_value,4);
END;
$$


CREATE FUNCTION fn_is_word_comprised(set_of_letters VARCHAR(50), word VARCHAR(50))
RETURNS BOOLEAN
LANGUAGE plpgsql

AS 
$$

BEGIN 

RETURN TRIM(LOWER(word), LOWER(set_of_letters)) = '';

END;
$$



CREATE FUNCTION fn_is_game_over(is_game_over BOOLEAN)
RETURNS TABLE(name VARCHAR(50), game_type_id INT, is_finished BOOLEAN)
LANGUAGE plpgsql
AS 
$$

BEGIN
RETURN QUERY(
    SELECT g.name,
    g.game_type_id,
    g.is_finished
    FROM games AS g
    WHERE g.is_finished = is_game_over
);
END 
$$


CREATE FUNCTION fn_difficulty_level(level INT)
RETURNS VARCHAR(50)
LANGUAGE plpgsql
AS 
$$
DECLARE difficulty_level VARCHAR;

BEGIN
 
IF (level <=40) THEN difficulty_level := 'Normal Difficulty';
ELSIF (level BETWEEN 41 AND 60) THEN difficulty_level := 'Nightmare Difficulty';
ELSE difficulty_level := 'Hell Difficulty';
END IF;

RETURN difficulty_level;

END;
$$;

SELECT 
user_id, 
level, 
cash, 
fn_difficulty_level(level) AS difficulty_level
FROM users_games
ORDER BY user_id;



CREATE PROCEDURE sp_deposit_money(account_id INT, money_amount NUMERIC)
LANGUAGE plpgsql
AS 
$$
BEGIN 
UPDATE accounts 
SET balance = balance + money_amount
WHERE id = account_id;
END
$$



CREATE PROCEDURE sp_withdraw_money(account_id INT, money_amount NUMERIC)
LANGUAGE plpgsql
AS 
$$
DECLARE current_balance NUMERIC;
BEGIN
current_balance := (SELECT balance FROM accounts WHERE id = account_id);
IF(current_balance- money_amount) >= 0 THEN 
UPDATE accounts 
SET balance = balance - money_amount
WHERE id = account_id;
ELSE RAISE NOTICE 'insufficient balance %', money_amount;
END IF;
END 
$$


CREATE PROCEDURE sp_transfer_money(sender_id INT, receiver_id INT, amount NUMERIC)
LANGUAGE plpgsql
AS 
$$
DECLARE current_balance NUMERIC;
BEGIN
CALL sp_withdraw_money(sender_id, amount);
CALL sp_deposit_money(receiver_id, amount);
current_balance :=(SELECT balance FROM accounts WHERE id = sender_id);
IF (current_balance - amount) < 0 THEN 
ROLLBACK;
END IF;
END
$$

DROP PROCEDURE sp_retrieving_holders_with_balance_higher_than;


CREATE TABLE logs(
    id SERIAL PRIMARY KEY,
    account_id INT,
    old_sum NUMERIC(20,4),
    new_sum NUMERIC(20,4)
);

CREATE FUNCTION trigger_fn_insert_new_entry_into_logs()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
BEGIN
INSERT INTO logs(account_id, old_sum, new_sum)
VALUES(old.id, old.balance,new.balance);
RETURN NEW;
END;
$$

CREATE TRIGGER tr_account_balance_change
AFTER UPDATE OF balance ON accounts
FOR EACH ROW
WHEN (new.balance <> old.balance)
EXECUTE FUNCTION trigger_fn_insert_new_entry_into_logs()