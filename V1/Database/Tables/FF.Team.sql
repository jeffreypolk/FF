SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [FF].[Team](
	[TeamId] [int] IDENTITY(1,1) NOT NULL,
	[LeagueId] [int] NOT NULL,
	[ManagerId] [int] NOT NULL,
	[Name] [varchar](50) NULL,
	[DraftOrder] [int] NOT NULL,
	[LogoUrl] [varchar](300) NULL,
	[Year] [int] NOT NULL,
	[IsCommish] [bit] NOT NULL,
	[Wins] [int] NOT NULL,
	[Loses] [int] NOT NULL,
	[Ties] [int] NOT NULL,
	[PointsFor] [decimal](6, 2) NOT NULL,
	[PointsAgainst] [decimal](6, 2) NOT NULL,
	[Finish] [int] NOT NULL,
	[Moves] [int] NOT NULL,
 CONSTRAINT [PK_Team] PRIMARY KEY CLUSTERED 
(
	[TeamId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GRANT DELETE ON [FF].[Team] TO [DataUser] AS [dbo]
GRANT INSERT ON [FF].[Team] TO [DataUser] AS [dbo]
GRANT SELECT ON [FF].[Team] TO [DataUser] AS [dbo]
GRANT UPDATE ON [FF].[Team] TO [DataUser] AS [dbo]
ALTER TABLE [FF].[Team] ADD  CONSTRAINT [DF_Team_LeagueId]  DEFAULT ((1)) FOR [LeagueId]
ALTER TABLE [FF].[Team] ADD  CONSTRAINT [DF_Team_DraftOrder]  DEFAULT ((0)) FOR [DraftOrder]
ALTER TABLE [FF].[Team] ADD  CONSTRAINT [DF_Team_Year]  DEFAULT (datepart(year,getdate())) FOR [Year]
ALTER TABLE [FF].[Team] ADD  CONSTRAINT [DF_Team_IsCommish]  DEFAULT ((0)) FOR [IsCommish]
ALTER TABLE [FF].[Team] ADD  CONSTRAINT [DF_Team_Wins]  DEFAULT ((0)) FOR [Wins]
ALTER TABLE [FF].[Team] ADD  CONSTRAINT [DF_Team_Loses]  DEFAULT ((0)) FOR [Loses]
ALTER TABLE [FF].[Team] ADD  CONSTRAINT [DF_Team_Ties]  DEFAULT ((0)) FOR [Ties]
ALTER TABLE [FF].[Team] ADD  CONSTRAINT [DF_Team_Points]  DEFAULT ((0)) FOR [PointsFor]
ALTER TABLE [FF].[Team] ADD  CONSTRAINT [DF_Team_PointsAgainst]  DEFAULT ((0)) FOR [PointsAgainst]
ALTER TABLE [FF].[Team] ADD  CONSTRAINT [DF_Team_Finish]  DEFAULT ((0)) FOR [Finish]
ALTER TABLE [FF].[Team] ADD  CONSTRAINT [DF_Team_Moves]  DEFAULT ((0)) FOR [Moves]
GO
