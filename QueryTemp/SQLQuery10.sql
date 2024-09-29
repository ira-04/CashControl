CREATE TABLE [dbo].[Transactions] (
    [Id]          INT             IDENTITY (1, 1) NOT NULL,
    [Date]        DATE            NOT NULL,
    [Description] NVARCHAR (255)  NOT NULL,
    [Amount]      DECIMAL (18, 2) NOT NULL,
    [Type]        NVARCHAR (10)   NOT NULL,
    [CategoryId]  INT             NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[Categories] ([Id]) ON DELETE CASCADE
);
