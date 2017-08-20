SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [FF].[uspDraftReset]
(
	@LeagueId int, 
	@Year int
)
AS
	DELETE FROM FF.PlayerTeam 
	WHERE TeamId IN (
		SELECT TeamId 
		FROM FF.Team 
		WHERE LeagueId = @LeagueId
		AND [Year] = @Year
	)
	
	EXEC FF.uspDraftGetNextPick @LeagueId, @Year

	RETURN

GO
GRANT EXECUTE ON [FF].[uspDraftReset] TO [DataUser] AS [dbo]
GO
