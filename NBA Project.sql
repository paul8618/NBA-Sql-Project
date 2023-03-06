select * 
FROM [NBA SQL Project]..games 
WHERE Season = 2022


SELECT *
FROM [NBA SQL Project]..teams


-- Add a column as Team name using Team ID 

Alter table [NBA SQL Project]..games 
ADD Home_Team_Name varchar(50) 

Alter table [NBA SQL Project]..games 
ADD Away_Team_Name varchar(50) 

SELECT g.HOME_TEAM_ID, g.away_team_name, g.Home_team_name, t.TEAM_ID
FROM [NBA SQL Project]..games g
LEFT JOIN [NBA SQL Project]..teams t ON g.HOME_TEAM_ID = t.TEAM_ID
Order by 

Update g set g.home_team_name = t.nickname
FROM [NBA SQL Project]..games g
JOIN [NBA SQL Project]..teams t ON g.HOME_TEAM_ID = t.TEAM_ID

Update g set g.away_team_name = t.nickname
FROM [NBA SQL Project]..games g
JOIN [NBA SQL Project]..teams t ON g.TEAM_ID_away = t.TEAM_ID

-- sort the team based on win percentage in 2022 
-- win percent = total wins/total games 

-- To find total number of games by team = total home games + total away games 



-- Total Away Games by Team using CTE and Join Function  

WITH Away as (
SELECT away_team_name, Count(*) as Total_Away_Games
FROM [NBA SQL Project]..games g
Where SEASON = 2022
Group By away_team_name
)


SELECT Home_team_name, Count(*) as Total_Home_Games, a.total_away_games, (Count(*) + a.total_away_games) as Total_Games_Played
FROM [NBA SQL Project]..games g
JOIN Away a ON g.home_team_name = a.away_team_name
Where SEASON = 2022
Group By Home_team_name, total_away_games


--Total Wins by Team 

SELECT Count(Home_team_wins) as Total_Wins, HOME_Team_Name
FROM [NBA SQL Project]..games
WHERE Season = 2022 and Home_team_wins = 1
GROUP BY Home_Team_Name


-- Win percentage: Total wins/Total Games using subquery and Multiple Join function and create a new table (nba2022pct) with the results 


SELECT t.Home_team_name, t.Total_Home_Games, t.Total_Away_Games, t.Total_Games_Played, w.Total_Wins, Round((cast(w.Total_Wins as Float)/cast(t.Total_Games_Played as float) * 100),2) as Win_Percentage into [NBA SQL Project]..sqlnba2022pct
FROM 
(
    SELECT Home_team_name, Count(*) as Total_Home_Games, a.total_away_games, (Count(*) + a.total_away_games) as Total_Games_Played
    FROM [NBA SQL Project]..games g
    JOIN (
        SELECT away_team_name, Count(*) as Total_Away_Games
        FROM [NBA SQL Project]..games
        Where SEASON = 2022
        Group By away_team_name
    ) a ON g.home_team_name = a.away_team_name
    Where SEASON = 2022
    Group By Home_team_name, total_away_games
) t
JOIN 
(
    SELECT Count(Home_team_wins) as Total_Wins, HOME_Team_Name
    FROM [NBA SQL Project]..games
    WHERE Season = 2022 and Home_team_wins = 1
    GROUP BY Home_Team_Name
) w ON t.Home_team_name = w.Home_Team_Name;



Select *
FROM [NBA SQL Project]..nba2022pct


-- find the highest scorer on each team in 2022 

SELECT * 
FROM [NBA SQL Project]..games_details

select * 
FROM [NBA SQL Project]..games 
WHERE Season = 2022


SELECT distinct team_city, Player_name, round(Avg(Pts), 2) as average_pts_per_game
FROM [NBA SQL Project]..games_details gd Join [NBA SQL Project]..games g ON gd.game_Id = g.game_id
Where g.SEASON = 2022
Group By Player_name, team_city
Order By average_pts_per_game DESC


-- add City name to games table

Alter table [NBA SQL Project]..nba2022pct 
ADD City varchar(50) 

Update [NBA SQL Project]..nba2022pct 
Set city = t.city
FROM [NBA SQL Project]..nba2022pct n
Join [NBA SQL Project]..teams t on n.Home_team_name = t.NICKNAME 

select *
FROM [NBA SQL Project]..nba2022pct 

-- To determine the top socrer of each team and their average points per game 
WITH cte AS (
    SELECT team_city, Player_name as Top_Scorer, round(Avg(Pts), 2) as average_pts_per_game,
           ROW_NUMBER() OVER (PARTITION BY team_city ORDER BY round(Avg(Pts), 2) DESC) AS rn
    FROM [NBA SQL Project]..games_details gd 
    JOIN [NBA SQL Project]..games g ON gd.game_Id = g.game_id
    WHERE g.SEASON = 2022
    GROUP BY Player_name, team_city
)
SELECT city, Home_team_name, Total_Games_played, Total_wins, Win_Percentage, Top_Scorer, Average_pts_per_game
FROM cte 
JOIN [NBA SQL Project]..nba2022pct p ON cte.team_city = p.city
WHERE rn = 1
ORDER BY average_pts_per_game DESC;

select* 
FROM [NBA SQL Project]..sqlnba2022pct








