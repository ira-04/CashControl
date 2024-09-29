CREATE TABLE [dbo].[Categories] (
    [Id]   INT            IDENTITY (1, 1) NOT NULL,
    [Name] NVARCHAR (100) NOT NULL,
    [Type] NVARCHAR (10) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

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


INSERT INTO [dbo].[Categories] (Name, Type) VALUES 
('Salary', 'Income'),
('Business', 'Income'),
('Freelance', 'Income'),
('Groceries', 'Expense'),
('Utilities', 'Expense'),
('Rent', 'Expense'),
('Transportation', 'Expense'),
('Entertainment', 'Expense'),
('Health', 'Expense'),
('Savings', 'Income');
