IF OBJECT_ID('[dbo].[Users]', 'U') IS NULL
CREATE TABLE [dbo].[Users]
(
    UserId BIGINT NOT NULL IDENTITY PRIMARY KEY,
    Email NVARCHAR(100)
);
GO

IF NOT EXISTS (
    SELECT * FROM [dbo.[Users] WHERE Email = 'griehmmj@gmail.com'
)
INSERT INTO [dbo].[Users] (Email)
VALUES ('griehmmj@gmail.com')
GO