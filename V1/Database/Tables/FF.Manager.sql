SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [FF].[Manager](
	[ManagerId] [int] IDENTITY(1,1) NOT NULL,
	[AuthId] [uniqueidentifier] NOT NULL,
	[Name] [varchar](50) NULL,
 CONSTRAINT [PK_Manager] PRIMARY KEY CLUSTERED 
(
	[ManagerId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GRANT DELETE ON [FF].[Manager] TO [DataUser] AS [dbo]
GRANT INSERT ON [FF].[Manager] TO [DataUser] AS [dbo]
GRANT SELECT ON [FF].[Manager] TO [DataUser] AS [dbo]
GRANT UPDATE ON [FF].[Manager] TO [DataUser] AS [dbo]
ALTER TABLE [FF].[Manager] ADD  CONSTRAINT [DF_Manager_AuthId]  DEFAULT (newid()) FOR [AuthId]
GO
