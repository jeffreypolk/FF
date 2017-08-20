SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [FF].[PlayerTeam](
	[PlayerTeamId] [int] IDENTITY(1,1) NOT NULL,
	[PlayerId] [int] NOT NULL,
	[TeamId] [int] NOT NULL,
	[Round] [int] NOT NULL,
	[Overall] [int] NOT NULL,
	[IsKeeper] [bit] NOT NULL,
 CONSTRAINT [PK_PlayerTeam] PRIMARY KEY CLUSTERED 
(
	[PlayerTeamId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GRANT DELETE ON [FF].[PlayerTeam] TO [DataUser] AS [dbo]
GRANT INSERT ON [FF].[PlayerTeam] TO [DataUser] AS [dbo]
GRANT SELECT ON [FF].[PlayerTeam] TO [DataUser] AS [dbo]
GRANT UPDATE ON [FF].[PlayerTeam] TO [DataUser] AS [dbo]
ALTER TABLE [FF].[PlayerTeam] ADD  CONSTRAINT [DF_PlayerTeam_IsKeeper]  DEFAULT ((0)) FOR [IsKeeper]
GO
