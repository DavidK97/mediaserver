CREATE TABLE IF NOT EXISTS tag(
    name VARCHAR PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS album(
    name VARCHAR PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS creator(
    name VARCHAR PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS type(
    name VARCHAR PRIMARY KEY
);

INSERT INTO type VALUES ('Image');
INSERT INTO type VALUES ('Video');
INSERT INTO type VALUES ('Animation');

CREATE TABLE IF NOT EXISTS media(
    id SERIAL PRIMARY KEY,
    name VARCHAR UNIQUE,
    thumbnail VARCHAR UNIQUE,
    type VARCHAR REFERENCES type(name),
    favorite BOOLEAN
);

CREATE TABLE IF NOT EXISTS media_of_album(
    media_id int REFERENCES media(id),
    album VARCHAR REFERENCES album(name),
    UNIQUE(media_id, album)
);

CREATE TABLE IF NOT EXISTS media_of_tag(
    media_id int REFERENCES media(id),
    tag VARCHAR REFERENCES tag(name),
    UNIQUE(media_id, tag)
);

CREATE TABLE IF NOT EXISTS media_of_creator(
    media_id int REFERENCES media(id),
    creator VARCHAR REFERENCES creator(name),
    UNIQUE(media_id, creator)
);