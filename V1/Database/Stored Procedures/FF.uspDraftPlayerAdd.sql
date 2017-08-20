SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [FF].[uspDraftPlayerAdd]
(
	@LeagueId int, 
	@Year int, 
	@TeamId int, 
	@PlayerId int, 
	@Round int, 
	@Overall int, 
	@IsKeeper int
)
AS
	
	IF EXISTS (
		SELECT PlayerId 
		FROM FF.PlayerTeam pt INNER JOIN FF.Team t ON pt.TeamId = t.TeamId
		WHERE t.Year = @Year
		AND t.LeagueId = @LeagueId
		AND pt.Overall = @Overall
	
	) BEGIN
		RAISERROR('A player is already drafted at this position', 16, 1);

	END ELSE BEGIN
		
		INSERT INTO FF.PlayerTeam (PlayerId, TeamId, [Round], Overall, IsKeeper) 
		VALUES (@PlayerId, @TeamId, @Round, @Overall, @IsKeeper)

		EXEC FF.uspDraftGetNextPick @LeagueId, @Year

	END
			
	RETURN

GO
GRANT EXECUTE ON [FF].[uspDraftPlayerAdd] TO [DataUser] AS [dbo]
GO
