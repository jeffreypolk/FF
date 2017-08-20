SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [FF].[Comment](
	[CommentId] [int] IDENTITY(1,1) NOT NULL,
	[Text] [varchar](max) NOT NULL,
	[TeamId] [int] NOT NULL,
	[PostDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Comment] PRIMARY KEY CLUSTERED 
(
	[CommentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GRANT DELETE ON [FF].[Comment] TO [DataUser] AS [dbo]
GRANT INSERT ON [FF].[Comment] TO [DataUser] AS [dbo]
GRANT SELECT ON [FF].[Comment] TO [DataUser] AS [dbo]
GRANT UPDATE ON [FF].[Comment] TO [DataUser] AS [dbo]
ALTER TABLE [FF].[Comment] ADD  CONSTRAINT [DF_Comment_PostDate]  DEFAULT (getdate()) FOR [PostDate]
GO
