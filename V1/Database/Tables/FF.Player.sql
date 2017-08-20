SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [FF].[Player](
	[PlayerId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[NFLTeam] [varchar](50) NOT NULL,
	[Position] [varchar](50) NOT NULL,
	[Age] [int] NOT NULL,
	[Experience] [int] NOT NULL,
	[ADP] [decimal](10, 2) NOT NULL,
	[DepthChart] [int] NOT NULL,
	[Year] [int] NOT NULL,
 CONSTRAINT [PK_Player] PRIMARY KEY CLUSTERED 
(
	[PlayerId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GRANT DELETE ON [FF].[Player] TO [DataUser] AS [dbo]
GRANT INSERT ON [FF].[Player] TO [DataUser] AS [dbo]
GRANT SELECT ON [FF].[Player] TO [DataUser] AS [dbo]
GRANT UPDATE ON [FF].[Player] TO [DataUser] AS [dbo]
ALTER TABLE [FF].[Player] ADD  CONSTRAINT [DF_Player_Age]  DEFAULT ((0)) FOR [Age]
ALTER TABLE [FF].[Player] ADD  CONSTRAINT [DF_Player_Experience]  DEFAULT ((0)) FOR [Experience]
ALTER TABLE [FF].[Player] ADD  CONSTRAINT [DF_Player_ADP]  DEFAULT ((999)) FOR [ADP]
ALTER TABLE [FF].[Player] ADD  CONSTRAINT [DF_Player_DepthChart]  DEFAULT ((0)) FOR [DepthChart]
ALTER TABLE [FF].[Player] ADD  CONSTRAINT [DF_Player_Year]  DEFAULT (datepart(year,getdate())) FOR [Year]
GO
