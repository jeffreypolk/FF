SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [FF].[uspManagerStatsGet]
(
	@LeagueId int,
	@MinYear int, 
	@MaxYear int
)
AS			
	SELECT
		ManagerId, 
		Name, 
		Wins, 
		Loses, 
		Ties, 
		Games, 
		CASE Games WHEN 0 THEN 0 ELSE CONVERT(decimal(10, 1), CONVERT(decimal, Wins) / CONVERT(decimal, Games) * 100) END AS WinPct
	FROM  (
		SELECT 
			M.ManagerId,
			M.Name AS Name,
			SUM(T.Wins) AS Wins,
			SUM(T.Loses) AS Loses,
			SUM(T.Ties) AS Ties, 
			SUM(T.Wins + T.Loses + T.Ties) AS Games
		FROM 
			FF.Manager M INNER JOIN FF.Team T ON M.ManagerId = T.ManagerId 
		WHERE 
			T.LeagueId = @LeagueId
			AND T.Year >= @MinYear
			AND T.Year <= CASE @MaxYear WHEN 0 THEN 9999 ELSE @MaxYear END
		GROUP BY
			M.ManagerId, 
			M.Name
		) AS stat 
	ORDER BY
		WinPct DESC
		
	RETURN

GO
GRANT EXECUTE ON [FF].[uspManagerStatsGet] TO [DataUser] AS [dbo]
GO
