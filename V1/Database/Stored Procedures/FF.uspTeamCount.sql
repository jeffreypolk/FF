SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [FF].[uspTeamCount]
(
	@LeagueId int, 
	@Year int
)
AS

	SELECT 
		COUNT(TeamId) 
	FROM 
		FF.Team T 
	WHERE 
		T.LeagueId = @LeagueId 
		AND T.[Year] = @Year
		
	RETURN

GO
GRANT EXECUTE ON [FF].[uspTeamCount] TO [DataUser] AS [dbo]
GO
