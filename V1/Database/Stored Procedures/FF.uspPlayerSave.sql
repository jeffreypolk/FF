SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [FF].[uspPlayerSave]
(
	@ManagerId int, 
	@PlayerId int, 
	@Year int, 
	@Name varchar(100), 
	@Position varchar(10), 
	@NFLTeam varchar(3), 
	@Age int,
	@Experience int, 
	@DepthChart int, 
	@Keywords varchar(1000), 
	@Comments varchar(1000)
)
AS
	IF @PlayerId = 0 BEGIN
	
		INSERT INTO FF.Player (Name, Position, NFLTeam, [Year], Age, [Experience], DepthChart) 
		VALUES (@Name, @Position, @NFLTeam, @Year, @Age, @Experience, @DepthChart)
		SET @PlayerId = SCOPE_IDENTITY()
		
	END ELSE BEGIN
	
		UPDATE FF.Player SET
		Name = @Name,
		Position = @Position,
		NFLTeam = @NFLTeam, 
		[Year] = @Year, 
		Age = @Age, 
		Experience = @Experience, 
		DepthChart = @DepthChart 
		WHERE PlayerId = @PlayerId
	END

	IF EXISTS(
		SELECT ManagerId 
		FROM FF.PlayerInfo 
		WHERE ManagerId = @ManagerId 
		AND PlayerId = @PlayerId
	) BEGIN
		
		UPDATE FF.PlayerInfo SET
		Comments = @Comments, 
		Keywords = @Keywords
		WHERE ManagerId = @ManagerId
		AND PlayerId = @PlayerId
	
	END ELSE BEGIN
		INSERT INTO FF.PlayerInfo (ManagerId, PlayerId, Keywords, Comments) 
		VALUES (@ManagerId, @PlayerId, @Keywords, @Comments)	
	END
	
	RETURN

GO
GRANT EXECUTE ON [FF].[uspPlayerSave] TO [DataUser] AS [dbo]
GO
