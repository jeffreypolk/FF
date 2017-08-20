SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [FF].[uspDraftedPlayersGet]
(
	@LeagueId int, 
	@Year int
)
AS



SELECT 
	P.*, 
	PT.TeamId, 
	T.Name AS Team, 
	CASE 
		WHEN T.DraftOrder < 10 THEN '0' + CONVERT(varchar(100), T.DraftOrder) + ' - ' + T.Name 
		ELSE CONVERT(varchar(100), T.DraftOrder) + ' - ' + T.Name 
	END AS TeamGroupName, 
	PT.Round, 
	PT.Overall, 
	NFLT.Bye, 
	PT.IsKeeper 
FROM 
	FF.Player P INNER JOIN FF.PlayerTeam PT ON P.PlayerId = PT.PlayerId 
	INNER JOIN FF.Team T ON PT.TeamId = T.TeamId
	INNER JOIN FF.NFLTeam NFLT ON P.NFLTeam = NFLT.Code
WHERE
	T.LeagueId = @LeagueId
	AND T.[Year] = @Year
	
RETURN

GO
GRANT EXECUTE ON [FF].[uspDraftedPlayersGet] TO [DataUser] AS [dbo]
GO
