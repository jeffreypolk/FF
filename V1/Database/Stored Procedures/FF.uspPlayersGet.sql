SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [FF].[uspPlayersGet]
(
	@ManagerId int, 
	@LeagueId int,
	@Year int
)
AS

-- players not drafted by this league
SELECT 
	p.*, 
	FF.NFLTeam.Bye, 
	0 AS TeamId,
	0 AS Overall, 
	0 AS [Round],
	'' AS Team,	
	ISNULL(pinfo.Keywords, '') AS Keywords, 
	ISNULL(pinfo.Comments, '') AS Comments
FROM 
	FF.Player p INNER JOIN FF.NFLTeam ON p.NFLTeam = FF.NFLTeam.Code
	LEFT OUTER JOIN FF.PlayerInfo pinfo ON p.PlayerId = pinfo.PlayerId AND pinfo.ManagerId = @ManagerId
WHERE 
	p.[Year] = @Year
	AND p.PlayerId NOT IN (SELECT PlayerId FROM FF.PlayerTeam WHERE TeamId IN (SELECT TeamId FROM FF.Team WHERE LeagueId = @LeagueId))
	
UNION ALL 

-- players drafted by this league
SELECT 
	p.*, 
	FF.NFLTeam.Bye, 
	pt.TeamId, 
	pt.Overall,
	pt.[Round], 
	t.Name AS Team,	
	ISNULL(pinfo.Keywords, '') AS Keywords, 
	ISNULL(pinfo.Comments, '') AS Comments
FROM 
	FF.Player p INNER JOIN FF.NFLTeam ON p.NFLTeam = FF.NFLTeam.Code
	INNER JOIN FF.PlayerTeam pt ON p.PlayerId = pt.PlayerId
	INNER JOIN FF.Team t ON pt.TeamId = t.TeamId
	LEFT OUTER JOIN FF.PlayerInfo pinfo ON p.PlayerId = pinfo.PlayerId AND pinfo.ManagerId = @ManagerId
	
WHERE 
	p.[Year] = 2012
	AND t.LeagueId = @LeagueId
	
ORDER BY 
	p.ADP
	
	RETURN

	RETURN

GO
GRANT EXECUTE ON [FF].[uspPlayersGet] TO [DataUser] AS [dbo]
GO
