CREATE TABLE Teams (
team_id INT PRIMARY KEY,
team_name VARCHAR(50) NOT NULL,
country VARCHAR(50),
captain_id INT
);
--------------------
INSERT INTO Teams (team_id, team_name, country, captain_id)
VALUES (1, 'Cloud9', 'USA', 1),
(2, 'Fnatic', 'Sweden', 2),
(3, 'SK Telecom T1', 'South Korea', 3),
(4, 'Team Liquid', 'USA', 4),
(5, 'G2 Esports', 'Spain', 5);
--------------------
CREATE TABLE Players (
player_id INT PRIMARY KEY,
player_name VARCHAR(50) NOT NULL,
team_id INT,
role VARCHAR(50),
salary INT,
FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);
--------------------
INSERT INTO Players (player_id, player_name, team_id, role, salary)
VALUES (1, 'Shroud', 1, 'Rifler', 100000),
(2, 'JW', 2, 'AWP', 90000),
(3, 'Faker', 3, 'Mid laner', 120000),
(4, 'Stewie2k', 4, 'Rifler', 95000),
(5, 'Perkz', 5, 'Mid laner', 110000),
(6, 'Castle09', 1, 'AWP', 120000),
(7, 'Pike', 2, 'Mid Laner', 70000),
(8, 'Daron', 3, 'Rifler', 125000),
(9, 'Felix', 4, 'Mid Laner', 95000),
(10, 'Stadz', 5, 'Rifler', 98000),
(11, 'KL34', 1, 'Mid Laner', 83000),
(12, 'ForceZ', 2, 'Rifler', 130000),
(13, 'Joker', 3, 'AWP', 128000),
(14, 'Hari', 4, 'AWP', 90000),
(15, 'Wringer', 5, 'Mid laner', 105000);
--------------------
CREATE TABLE Matches (
match_id INT PRIMARY KEY,
team1_id INT,
team2_id INT,
match_date DATE,
winner_id INT,
score_team1 INT,
score_team2 INT,
FOREIGN KEY (team1_id) REFERENCES Teams(team_id),
FOREIGN KEY (team2_id) REFERENCES Teams(team_id),
FOREIGN KEY (winner_id) REFERENCES Teams(team_id)
);
--------------------
INSERT INTO Matches (match_id, team1_id, team2_id, match_date, winner_id, score_team1, score_team2)
VALUES (1, 1, 2, '2022-01-01', 1, 16, 14),
(2, 3, 5, '2022-02-01', 3, 14, 9),
(3, 4, 1, '2022-03-01', 1, 17, 13),
(4, 2, 5, '2022-04-01', 5, 13, 12),
(5, 3, 4, '2022-05-01', 3, 16, 10),
(6, 1, 3, '2022-02-01', 3, 13, 17),
(7, 2, 4, '2022-03-01', 2, 12, 9),
(8, 5, 1, '2022-04-01', 1, 11, 15),
(9, 2, 3, '2022-05-01', 3, 9, 10),
(10, 4, 5, '2022-01-01', 4, 13, 10);

-- 1. What are the names of the players whose salary is greater than 100,000?
select player_name,salary from players where salary>100000 order by salary;
-- 2. What is the team name of the player with player_id = 3?
select team_name from players inner join teams using(team_id) where player_id=3;
-- 3. What is the total number of players in each team?
select team_id,team_name,count(player_id) as no_of_players from players inner join teams using(team_id) group by team_name;
-- 4. What is the team name and captain name of the team with team_id = 2?
select t.team_id,team_name,p.player_name as captain from teams t inner join players p on t.captain_id=p.player_id and t.team_id=2; 
-- 5. What are the player names and their roles in the team with team_id = 1?
select team_id,player_name,`role` from  players where team_id=1; 
-- 6. What are the team names and the number of matches they have won?
select m.winner_id as team_id,team_name,count(winner_id) as no_of_matches_won from matches m inner join teams t on m.winner_id=t.team_id group by winner_id;
-- 7. What is the average salary of players in the teams with country 'USA'?
select country,round(avg(salary),2) as avg_team_player_salary from players inner join teams using(team_id) where country='USA';
-- 8. Which team won the most matches?
with team_ranks as
(
select m.winner_id as team_id,team_name,count(winner_id) as no_of_matches_won,dense_rank() over(order by count(winner_id) desc) as rnk
from matches m inner join teams t on m.winner_id=t.team_id 
group by winner_id)

select team_name,no_of_matches_won as highest_matches_won from team_ranks where rnk=1;
-- 9. What are the team names and the number of players in each team whose salary is greater than 100,000?

select team_name,count(player_id) as no_of_players from teams inner join players using(team_id) where salary>100000 group by team_name;

-- 10. What is the date and the score of the match with match_id = 3?
select match_id,match_date,score_team1,score_team2 from matches where match_id=3;