

CREATE DATABASE  movie_dashboard;
USE movie_dashboard;


CREATE TABLE directors (
    director_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

CREATE TABLE genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(50)
);

CREATE TABLE movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    release_year INT,
    genre_id INT,
    director_id INT,
    runtime INT,
    rating DECIMAL(3,1),
    personal_rating DECIMAL(3,1),
    watch_count INT,
    format VARCHAR(30),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id),
    FOREIGN KEY (director_id) REFERENCES directors(director_id)
);


CREATE TABLE actors (
    actor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);


CREATE TABLE movie_actors (
    movie_id INT,
    actor_id INT,
    PRIMARY KEY (movie_id, actor_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
    FOREIGN KEY (actor_id) REFERENCES actors(actor_id)
);


CREATE TABLE watch_history (
    watch_id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT,
    watch_date DATE,
    rating_given DECIMAL(3,1),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);


INSERT INTO directors (first_name, last_name) VALUES
('Christopher', 'Nolan'),
('Steven', 'Spielberg'),
('Quentin', 'Tarantino'),
('James', 'Cameron');


INSERT INTO genres (genre_name) VALUES
('Action'),
('Drama'),
('Sci-Fi'),
('Thriller'),
('Comedy');


INSERT INTO movies (title, release_year, genre_id, director_id, runtime, rating, personal_rating, watch_count, format)
VALUES
('Inception', 2010, 3, 1, 148, 8.8, 9.5, 5, 'Blu-ray'),
('Interstellar', 2014, 3, 1, 169, 8.6, 9.2, 3, 'Digital'),
('Jurassic Park', 1993, 1, 2, 127, 8.1, 8.5, 2, 'DVD'),
('Titanic', 1997, 2, 4, 195, 7.8, 8.0, 4, 'Blu-ray'),
('Pulp Fiction', 1994, 4, 3, 154, 8.9, 9.0, 3, 'Digital'),
('The Dark Knight', 2008, 1, 1, 152, 9.0, 9.6, 6, 'Digital');


INSERT INTO actors (first_name, last_name) VALUES
('Leonardo', 'DiCaprio'),
('Christian', 'Bale'),
('Samuel', 'Jackson'),
('Matthew', 'McConaughey');


INSERT INTO movie_actors (movie_id, actor_id) VALUES
(1, 1),
(2, 4),
(3, 3),
(4, 1),
(5, 3),
(6, 2);


INSERT INTO watch_history (movie_id, watch_date, rating_given) VALUES
(1, '2024-01-15', 9.0),
(1, '2024-03-20', 9.5),
(2, '2024-02-10', 9.0),
(3, '2024-04-05', 8.5),
(4, '2024-05-18', 8.0),
(5, '2024-06-22', 9.0),
(6, '2024-07-11', 9.5);


SELECT 
    COUNT(*) AS total_movies,
    ROUND(AVG(personal_rating), 2) AS avg_personal_rating,
    SUM(watch_count) AS total_watches,
    COUNT(DISTINCT director_id) AS unique_directors,
    COUNT(DISTINCT genre_id) AS genres_represented
FROM movies;


SELECT 
    m.movie_id,
    m.title,
    m.release_year,
    g.genre_name,
    CONCAT(d.first_name, ' ', d.last_name) AS director,
    m.runtime,
    m.rating AS imdb_rating,
    m.personal_rating,
    m.watch_count,
    m.format
FROM movies AS m
LEFT JOIN genres AS g ON m.genre_id = g.genre_id
LEFT JOIN directors AS d ON m.director_id = d.director_id
ORDER BY m.personal_rating DESC;


SELECT 
    CONCAT(d.first_name, ' ', d.last_name) AS director,
    COUNT(m.movie_id) AS movie_count,
    ROUND(AVG(m.personal_rating), 2) AS avg_personal_rating,
    SUM(m.watch_count) AS total_watches,
    ROUND(AVG(m.rating), 2) AS avg_imdb_rating
FROM directors AS d
LEFT JOIN movies AS m ON d.director_id = m.director_id
GROUP BY d.director_id, d.first_name, d.last_name
HAVING movie_count > 0
ORDER BY avg_personal_rating DESC;


SELECT 
    g.genre_name,
    COUNT(m.movie_id) AS movie_count,
    ROUND(AVG(m.personal_rating), 2) AS avg_personal_rating,
    ROUND(AVG(m.watch_count), 2) AS avg_watch_count,
    SUM(m.watch_count) AS total_watches
FROM genres AS g
LEFT JOIN movies AS m ON g.genre_id = m.genre_id
GROUP BY g.genre_id, g.genre_name
HAVING movie_count > 0
ORDER BY avg_personal_rating DESC;


SELECT 
    DATE_FORMAT(w.watch_date, '%Y-%m') AS watch_month,
    COUNT(*) AS watches,
    ROUND(AVG(w.rating_given), 2) AS avg_rating
FROM watch_history AS w
GROUP BY DATE_FORMAT(w.watch_date, '%Y-%m')
ORDER BY watch_month DESC;


SELECT 
    CONCAT(a.first_name, ' ', a.last_name) AS actor,
    COUNT(DISTINCT ma.movie_id) AS movie_count,
    GROUP_CONCAT(DISTINCT m.title ORDER BY m.release_year SEPARATOR ', ') AS movies
FROM actors AS a
JOIN movie_actors AS ma ON a.actor_id = ma.actor_id
JOIN movies AS m ON ma.movie_id = m.movie_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY movie_count DESC;


SELECT 
    title,
    rating AS imdb_rating,
    personal_rating,
    (personal_rating - rating) AS rating_difference,
    CASE 
        WHEN personal_rating > rating THEN 'Like more than average'
        WHEN personal_rating < rating THEN 'Like less than average'
        ELSE 'Same as average'
    END AS preference
FROM movies
ORDER BY ABS(personal_rating - rating) DESC;


