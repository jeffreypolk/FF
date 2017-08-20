SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [FF].[uspDraftPlayerRemove]
(
	@LeagueId int, 
	@PlayerId varchar(100)
)
AS

	DECLARE @Year int

	SELECT @Year = T.Year 
	FROM FF.PlayerTeam PT INNER JOIN FF.Team T ON PT.TeamId = T.TeamId
	WHERE PT.PlayerId = @PlayerId
	AND T.LeagueId = @LeagueId

	DELETE PT
	FROM FF.PlayerTeam PT INNER JOIN FF.Team T ON PT.TeamId = T.TeamId
	WHERE PT.PlayerId = @PlayerId
	AND T.LeagueId = @LeagueId

	EXEC FF.uspDraftGetNextPick @LeagueId, @Year
	
	RETURN

GO
GRANT EXECUTE ON [FF].[uspDraftPlayerRemove] TO [DataUser] AS [dbo]
GO
