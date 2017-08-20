SET QUOTED_IDENTIFIER ON
GO
ALTER TABLE [FF].[LeagueYear] NOCHECK CONSTRAINT ALL
GO
INSERT INTO [FF].[LeagueYear] ([LeagueId], [Year], [Rounds]) VALUES (1, 2012, 14)
INSERT INTO [FF].[LeagueYear] ([LeagueId], [Year], [Rounds]) VALUES (1, 2013, 14)
INSERT INTO [FF].[LeagueYear] ([LeagueId], [Year], [Rounds]) VALUES (1, 2014, 14)
INSERT INTO [FF].[LeagueYear] ([LeagueId], [Year], [Rounds]) VALUES (2, 2012, 14)
INSERT INTO [FF].[LeagueYear] ([LeagueId], [Year], [Rounds]) VALUES (2, 2013, 14)
GO
