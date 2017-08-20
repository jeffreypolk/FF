SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [FF].[NFLTeam](
	[Location] [varchar](50) NULL,
	[Name] [varchar](50) NULL,
	[Code] [varchar](50) NULL,
	[Bye] [int] NULL,
	[Rank] [int] NULL,
	[Inception] [int] NULL
) ON [PRIMARY]

GRANT DELETE ON [FF].[NFLTeam] TO [DataUser] AS [dbo]
GRANT INSERT ON [FF].[NFLTeam] TO [DataUser] AS [dbo]
GRANT SELECT ON [FF].[NFLTeam] TO [DataUser] AS [dbo]
GRANT UPDATE ON [FF].[NFLTeam] TO [DataUser] AS [dbo]
GO
