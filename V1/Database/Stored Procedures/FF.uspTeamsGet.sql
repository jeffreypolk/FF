SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [FF].[uspTeamsGet]
(
	@LeagueId int, 
	@Year int
)
AS

	SELECT 
		T.*, 
		M.Name AS Manager 
	FROM 
		FF.Team T INNER JOIN FF.Manager M ON T.ManagerId = M.ManagerId 
	WHERE 
		T.LeagueId = @LeagueId 
		AND T.[Year] = @Year
		
	ORDER BY 
		T.DraftOrder
		
	RETURN

GO
GRANT EXECUTE ON [FF].[uspTeamsGet] TO [DataUser] AS [dbo]
GO
