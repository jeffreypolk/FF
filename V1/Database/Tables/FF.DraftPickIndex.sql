SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [FF].[DraftPickIndex](
	[DraftPickIndexId] [int] IDENTITY(1,1) NOT NULL,
	[MaxTeams] [int] NOT NULL,
	[MaxRounds] [int] NOT NULL,
	[Pick] [int] NOT NULL,
	[Team] [int] NOT NULL,
	[Round] [int] NOT NULL,
 CONSTRAINT [PK_DraftPickIndex] PRIMARY KEY CLUSTERED 
(
	[DraftPickIndexId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GRANT DELETE ON [FF].[DraftPickIndex] TO [DataUser] AS [dbo]
GRANT INSERT ON [FF].[DraftPickIndex] TO [DataUser] AS [dbo]
GRANT SELECT ON [FF].[DraftPickIndex] TO [DataUser] AS [dbo]
GRANT UPDATE ON [FF].[DraftPickIndex] TO [DataUser] AS [dbo]
GO
