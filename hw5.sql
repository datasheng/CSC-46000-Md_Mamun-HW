

-- ============================================
-- Q2: CREATE TABLE users
-- ============================================
CREATE TABLE users (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  user_code  VARCHAR(10)  NOT NULL UNIQUE,
  name       VARCHAR(100) NOT NULL,
  email      VARCHAR(255) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================
-- Accounts table (referenced by user_check_in)
-- ============================================
CREATE TABLE accounts (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  user_id      INT NOT NULL,
  handle       VARCHAR(50)  NOT NULL UNIQUE,
  profile_url  VARCHAR(255) NOT NULL UNIQUE,
  account_type VARCHAR(50)  NOT NULL,
  created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_accounts_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================
-- Locations table
-- ============================================
CREATE TABLE locations (
  id      INT AUTO_INCREMENT PRIMARY KEY,
  name    VARCHAR(120) NOT NULL,
  city    VARCHAR(120),
  country VARCHAR(120),
  UNIQUE KEY uq_location_triplet (name, city, country)
) ENGINE=InnoDB;

-- ============================================
-- Q3: Following (junction between users)
-- ============================================
CREATE TABLE following (
  follower_user_id INT NOT NULL,
  followee_user_id INT NOT NULL,
  followed_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (follower_user_id, followee_user_id),
  CONSTRAINT fk_following_follower
    FOREIGN KEY (follower_user_id) REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_following_followee
    FOREIGN KEY (followee_user_id) REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DELIMITER $$
CREATE TRIGGER trg_following_no_self_insert
BEFORE INSERT ON following
FOR EACH ROW
BEGIN
  IF NEW.follower_user_id = NEW.followee_user_id THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'A user cannot follow themselves.';
  END IF;
END$$

CREATE TRIGGER trg_following_no_self_update
BEFORE UPDATE ON following
FOR EACH ROW
BEGIN
  IF NEW.follower_user_id = NEW.followee_user_id THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'A user cannot follow themselves.';
  END IF;
END$$
DELIMITER ;

-- ============================================
-- Q4: User Check-In
-- ============================================
CREATE TABLE user_check_in (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  user_id      INT NOT NULL,
  location_id  INT NOT NULL,
  account_id   INT NULL,
  checked_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  note         VARCHAR(255),
  CONSTRAINT fk_uci_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_uci_location
    FOREIGN KEY (location_id) REFERENCES locations(id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_uci_account
    FOREIGN KEY (account_id) REFERENCES accounts(id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================
-- Q6: Populate sample data (3-5 rows each)
-- ============================================

-- Users
INSERT INTO users (user_code, name, email)
VALUES 
  ('T312', 'Alex Turner',  'AlexT@company.com'),
  ('L520', 'Mia Chen',     'MiaChen@domain.co.uk'),
  ('Q789', 'Leo Sanchez',  'Leo.Sanchez@webmail.com'),
  ('P120', 'Sophia Wong',  'SophiaW@yahoo.com');

-- Accounts
INSERT INTO accounts (user_id, handle, profile_url, account_type)
VALUES
  (1, 'xy5z09', 'mySoMe.com/xy5z09', 'Photographer'),
  (2, 'bh3f67', 'mySoMe.com/bh3f67', 'Public Figure'),
  (3, 'lp9x34', 'mySoMe.com/lp9x34', 'Business'),
  (4, 'fw8m21', 'mySoMe.com/fw8m21', 'Model');

-- Locations
INSERT INTO locations (name, city, country)
VALUES
  ('Big Ben',            'London',   'UK'),
  ('Brandenburg Gate',   'Berlin',   'Germany'),
  ('Times Square',       'New York', 'USA'),
  ('Sydney Opera House', 'Sydney',   'AUS'),
  ('Marina Bay Sands',   'Singapore','Singapore');

-- Following
INSERT INTO following (follower_user_id, followee_user_id)
VALUES
  (3, 1),
  (4, 1),
  (1, 3),
  (2, 3),
  (2, 4);

-- User Check-In
INSERT INTO user_check_in (user_id, location_id, account_id, note)
VALUES
  (2, 1, 2, 'Visited the clock tower'),
  (2, 2, 2, 'Sightseeing in Berlin'),
  (3, 3, 3, 'Business trip to NYC'),
  (4, 4, 4, 'Opera night'),
  (4, 5, 4, 'Bay views');

-- ============================================
-- Q5: Query users without check-ins + follower count
-- ============================================
SELECT
  u.name AS user_name,
  COUNT(DISTINCT f.follower_user_id) AS follower_count
FROM users AS u
LEFT JOIN following AS f
  ON f.followee_user_id = u.id
WHERE NOT EXISTS (
  SELECT 1 FROM user_check_in AS uc WHERE uc.user_id = u.id
)
GROUP BY u.id, u.name
ORDER BY u.name ASC, follower_count DESC;
