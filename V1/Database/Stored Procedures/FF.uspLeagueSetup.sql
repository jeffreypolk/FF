USE [polkspot]
GO

/****** Object:  StoredProcedure [FF].[uspLeagueSetup]    Script Date: 8/16/2015 1:54:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Description:	sets up leagues for a new year by copying last year's info 
-- =============================================
CREATE PROCEDURE [FF].[uspLeagueSetup]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @ThisYear int = DATEPART(yyyy, getdate());
	DECLARE @LastYear int = @ThisYear - 1

	INSERT INTO FF.LeagueYear (LeagueId, Year, Rounds)
	SELECT LeagueId, @ThisYear, Rounds
	FROM FF.LeagueYear 
	WHERE Year = @LastYear

	INSERT INTO FF.Team (LeagueId, ManagerId, Name, DraftOrder, LogoUrl, Year, IsCommish)
	SELECT LeagueId, ManagerId, Name, 0, LogoUrl, @ThisYear, IsCommish
	FROM FF.Team 
	WHERE Year = @LastYear

END

GO

