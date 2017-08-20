SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [FF].[uspPlayerKeywordsGet]
(
	@ManagerId int, 
	@Year int
)
AS
	SELECT 
		DISTINCT Keywords 
	FROM 
		FF.PlayerInfo pinfo INNER JOIN FF.Player p ON pinfo.PlayerId = p.PlayerId
	WHERE 
		ManagerId = @ManagerId 
		AND p.[Year] = @Year
		AND Keywords IS NOT NULL 
		AND Keywords <> ''
	
	RETURN

GO
GRANT EXECUTE ON [FF].[uspPlayerKeywordsGet] TO [DataUser] AS [dbo]
GO
