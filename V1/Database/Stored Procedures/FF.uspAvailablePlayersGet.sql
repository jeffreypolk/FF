SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [FF].[uspAvailablePlayersGet]
(
	@LeagueId int, 
	@Year int
)
AS

SELECT 
	p.*, 
	0 AS TeamId, '' AS Team, 
	0 AS Round, 0 AS Overall, 
	team.Bye 
FROM 
	FF.Player p INNER JOIN FF.NFLTeam team ON p.NFLTeam = team.Code
WHERE 
	p.Year = @Year
	AND p.PlayerId NOT IN (
		SELECT PlayerId 
		FROM FF.PlayerTeam PT INNER JOIN FF.Team T ON PT.TeamId = T.TeamId 
		WHERE T.LeagueId = @LeagueId
		AND T.[Year] = @Year
	)
	
	RETURN

GO
GRANT EXECUTE ON [FF].[uspAvailablePlayersGet] TO [DataUser] AS [dbo]
GO
