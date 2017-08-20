SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [FF].[uspNFLTeamsAddToPlayer] 
	@Year int
AS
BEGIN
	DECLARE @CurrentYear int = DATEPART(year, getdate());

	INSERT INTO FF.Player (ADP, Age, DepthChart, Experience, Name, NFLTeam, Position, Year)
	SELECT 999,  (@CurrentYear - Inception), 1, (@CurrentYear - Inception), Name, Code, 'DEF', @Year
	FROM FF.NFLTeam
END

GO
GRANT EXECUTE ON [FF].[uspNFLTeamsAddToPlayer] TO [DataUser] AS [dbo]
GO
