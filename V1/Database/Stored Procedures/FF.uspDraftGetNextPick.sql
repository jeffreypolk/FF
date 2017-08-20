SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [FF].[uspDraftGetNextPick]
(
	@LeagueId int, 
	@Year int
)
AS
	DECLARE @NextPick int, @NextRound int, @NextTeam int, @Rounds int, @Teams int

	DECLARE @picks TABLE (NextPick int not null)
	
	-- add bounds
	INSERT @picks VALUES (0)
	INSERT @picks VALUES (168)
	
	-- add the used picks
	INSERT @picks 
	SELECT Overall 
	FROM FF.PlayerTeam pt INNER JOIN FF.Team t ON pt.TeamId = t.TeamId
	WHERE t.Year = @Year
	AND t.LeagueId = @LeagueId

	-- figure out the lowest pick available
	SELECT TOP 1 @NextPick = LastSeqNumber + 1
	from (
		select (SELECT TOP 1 NextPick FROM @picks WHERE NextPick < a.NextPick ORDER BY NextPick DESC) as LastSeqNumber,
		a.NextPick as NextSeqNumber
		from @picks a
		left join @picks b on a.NextPick = b.NextPick + 1
		where b.NextPick IS NULL
	) a
	WHERE LastSeqNumber IS NOT NULL
	ORDER BY LastSeqNumber
	
	-- get the number of rounds
	SELECT @Rounds = Rounds
	FROM FF.LeagueYear
	WHERE LeagueId = @LeagueId
	AND Year = @Year

	-- get the number of teams
	SELECT @Teams = COUNT(TeamId)
	FROM FF.Team
	WHERE LeagueId = @LeagueId
	AND Year = @Year

	-- get the pick, round and team
	SELECT @NextPick = Pick, @NextRound = Round, @NextTeam = Team
	FROM FF.DraftPickIndex
	WHERE MaxRounds = @Rounds
	AND MaxTeams = @Teams
	AND Pick = @NextPick

	-- translate the next team into a team id
	SELECT @NextTeam = t.TeamId
	FROM FF.Team t
	WHERE t.LeagueId = @LeagueId
	AND t.Year = @Year
	AND t.DraftOrder = @NextTeam

	-- return data
	SELECT @NextPick AS NextPick, @NextRound AS NextRound, @NextTeam AS NextTeam

	RETURN

GO
GRANT EXECUTE ON [FF].[uspDraftGetNextPick] TO [DataUser] AS [dbo]
GO
