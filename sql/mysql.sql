CREATE TABLE IF NOT EXISTS member (
    id           INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name         VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS ip_gps(
    time                  DATETIME NOT NULL,
    ip                    VARCHAR(20) NOT NULL,
    latitude              DOUBLE NOT NULL,
    longitude             DOUBLE NOT NULL,
  PRIMARY KEY (time, ip)
) engine=innodb DEFAULT CHARSET=utf8;
