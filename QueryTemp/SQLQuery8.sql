ALTER TABLE [dbo].[Transactions]
ADD [CategoryId] INT NOT NULL;

ALTER TABLE [dbo].[Transactions]
ADD CONSTRAINT FK_Transactions_Categories
FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[Categories] ([Id]) ON DELETE CASCADE;
