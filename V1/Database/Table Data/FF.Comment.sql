SET QUOTED_IDENTIFIER ON
GO
ALTER TABLE [FF].[Comment] NOCHECK CONSTRAINT ALL
GO
SET IDENTITY_INSERT [FF].[Comment] ON
GO
INSERT INTO [FF].[Comment] ([CommentId], [Text], [TeamId], [PostDate]) VALUES (3, 'first comment', 1, '12/4/2011 3:21:12 PM')
INSERT INTO [FF].[Comment] ([CommentId], [Text], [TeamId], [PostDate]) VALUES (4, 'second comment', 2, '12/4/2011 3:41:02 PM')
GO
SET IDENTITY_INSERT [FF].[Comment] OFF
GO
