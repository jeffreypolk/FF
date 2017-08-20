SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [FF].[PlayerInfo](
	[ManagerId] [int] NOT NULL,
	[PlayerId] [int] NOT NULL,
	[Keywords] [varchar](1000) NULL,
	[Comments] [varchar](1000) NULL,
 CONSTRAINT [PK_PlayerInfo] PRIMARY KEY CLUSTERED 
(
	[ManagerId] ASC,
	[PlayerId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GRANT DELETE ON [FF].[PlayerInfo] TO [DataUser] AS [dbo]
GRANT INSERT ON [FF].[PlayerInfo] TO [DataUser] AS [dbo]
GRANT SELECT ON [FF].[PlayerInfo] TO [DataUser] AS [dbo]
GRANT UPDATE ON [FF].[PlayerInfo] TO [DataUser] AS [dbo]
GO
