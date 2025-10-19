CREATE TABLE users (
  user_id    VARCHAR(10)  PRIMARY KEY,
  user_name  VARCHAR(100) NOT NULL,
  user_email VARCHAR(255) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE locations (
  location_id   INT AUTO_INCREMENT PRIMARY KEY,
  name          VARCHAR(200) NOT NULL,
  city          VARCHAR(120),
  region        VARCHAR(120),
  country       VARCHAR(120),
  UNIQUE KEY uq_location (name, city, region, country)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE following (
  follower_user_id VARCHAR(10) NOT NULL,
  followed_user_id VARCHAR(10) NOT NULL,
  followed_since   DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (follower_user_id, followed_user_id),
  KEY ix_following_followed (followed_user_id),
  CONSTRAINT fk_following_follower
    FOREIGN KEY (follower_user_id) REFERENCES users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_following_followed
    FOREIGN KEY (followed_user_id) REFERENCES users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE user_check_in (
  user_check_in_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id          VARCHAR(10) NOT NULL,
  location_id      INT NOT NULL,
  checked_at       DATETIME DEFAULT CURRENT_TIMESTAMP,
  note             VARCHAR(255),
  KEY ix_uci_user (user_id),
  KEY ix_uci_location (location_id),
  CONSTRAINT fk_uci_user
    FOREIGN KEY (user_id)     REFERENCES users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_uci_location
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
