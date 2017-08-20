SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [FF].[uspDraftedPlayerCount]
(
	@LeagueId int, 
	@Year int
)
AS

	SELECT 
		COUNT(PlayerId) 
	FROM 
		FF.PlayerTeam PT INNER JOIN FF.Team T ON PT.TeamId = T.TeamId 
	WHERE 
		T.LeagueId = @LeagueId
		AND T.[Year] = @Year
	
	RETURN

GO
GRANT EXECUTE ON [FF].[uspDraftedPlayerCount] TO [DataUser] AS [dbo]
GO
