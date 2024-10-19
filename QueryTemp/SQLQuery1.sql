ALTER TABLE [dbo].[Transactions]
ADD [CategoryId] INT NOT NULL;

ALTER TABLE [dbo].[Transactions]
ADD CONSTRAINT FK_Transactions_Categories
FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[Categories] ([Id]) ON DELETE CASCADE;

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



-- Insert 100 categories into Categories table
INSERT INTO [dbo].[Categories] (Name, Type) VALUES 
('Investment', 'Income'),
('Gift', 'Income'),
('Bonus', 'Income'),
('Side Job', 'Income'),
('Interest', 'Income'),
('Dividend', 'Income'),
('Loan', 'Income'),
('Rental Income', 'Income'),
('Refund', 'Income'),
('Cashback', 'Income'),
('Other Income', 'Income'),
('Dining', 'Expense'),
('Shopping', 'Expense'),
('Education', 'Expense'),
('Subscription', 'Expense'),
('Insurance', 'Expense'),
('Charity', 'Expense'),
('Fees', 'Expense'),
('Taxes', 'Expense'),
('Maintenance', 'Expense'),
('Office Supplies', 'Expense'),
('Fuel', 'Expense'),
('Travel', 'Expense'),
('Hotel', 'Expense'),
('Airfare', 'Expense'),
('Public Transport', 'Expense'),
('Parking', 'Expense'),
('Car Rental', 'Expense'),
('Books', 'Expense'),
('Technology', 'Expense'),
('Hardware', 'Expense'),
('Software', 'Expense'),
('Internet', 'Expense'),
('Phone', 'Expense'),
('Cable TV', 'Expense'),
('Gym', 'Expense'),
('Sports', 'Expense'),
('Leisure', 'Expense'),
('Vacation', 'Expense'),
('Clothing', 'Expense'),
('Cosmetics', 'Expense'),
('Personal Care', 'Expense'),
('Pets', 'Expense'),
('Furniture', 'Expense'),
('Home Improvement', 'Expense'),
('Garden', 'Expense'),
('Child Care', 'Expense'),
('Elderly Care', 'Expense'),
('Subscriptions', 'Expense'),
('Streaming Services', 'Expense'),
('Alcohol', 'Expense'),
('Cigarettes', 'Expense'),
('Lottery', 'Expense'),
('Betting', 'Expense'),
('Legal', 'Expense'),
('Professional Services', 'Expense'),
('Marketing', 'Expense'),
('Consulting', 'Expense'),
('Web Hosting', 'Expense'),
('Domain', 'Expense'),
('Cloud Services', 'Expense'),
('Advertising', 'Expense'),
('Research', 'Expense'),
('Development', 'Expense'),
('Testing', 'Expense'),
('Design', 'Expense'),
('Prototyping', 'Expense'),
('Recruitment', 'Expense'),
('Training', 'Expense'),
('Team Building', 'Expense'),
('Conference', 'Expense'),
('Workshop', 'Expense'),
('Travel Insurance', 'Expense'),
('Health Insurance', 'Expense'),
('Life Insurance', 'Expense'),
('Car Insurance', 'Expense'),
('Home Insurance', 'Expense'),
('Loan Repayment', 'Expense'),
('Credit Card Payment', 'Expense'),
('Mortgage', 'Expense'),
('Child Support', 'Expense'),
('Alimony', 'Expense'),
('Pension Contribution', 'Expense'),
('Savings Deposit', 'Income'),
('Emergency Fund', 'Income'),
('Retirement Fund', 'Income'),
('Investment Fund', 'Income'),
('Stocks', 'Income'),
('Bonds', 'Income'),
('Mutual Funds', 'Income'),
('Cryptocurrency', 'Income'),
('Art Investment', 'Income');

delete from [dbo].[Transactions]

INSERT INTO [dbo].[Transactions] (Date, Description, Amount, Type, CategoryId) VALUES
('2024-01-15', 'Monthly Salary', 5000.00, 'Income', 1),         -- Salary
('2024-01-18', 'Freelance Project', 1200.00, 'Income', 3),     -- Freelance
('2024-01-20', 'Grocery Shopping', -150.00, 'Expense', 4),      -- Groceries
('2024-01-22', 'Electricity Bill', -75.00, 'Expense', 5),       -- Utilities
('2024-01-25', 'Monthly Rent', -1200.00, 'Expense', 6),         -- Rent
('2024-02-01', 'Gas for Car', -50.00, 'Expense', 32),           -- Fuel
('2024-02-03', 'Dining Out', -80.00, 'Expense', 12),            -- Dining
('2024-02-07', 'Online Course Fee', -300.00, 'Expense', 73),    -- Education
('2024-02-10', 'Gym Membership', -50.00, 'Expense', 95),        -- Gym
('2024-02-15', 'Annual Insurance Premium', -400.00, 'Expense', 41),  -- Insurance Premium
('2024-02-20', 'Bonus Received', 1000.00, 'Income', 43),       -- Bonuses
('2024-02-25', 'Refund from Store', 200.00, 'Income', 45),     -- Refunds
('2024-03-01', 'Gift for Friend', -100.00, 'Expense', 16),      -- Gifts
('2024-03-03', 'Book Purchase', -25.00, 'Expense', 89),         -- Books
('2024-03-05', 'Birthday Party', -200.00, 'Expense', 19),       -- Birthday
('2024-03-10', 'Consulting Fee', 800.00, 'Income', 117),       -- Consulting
('2024-03-15', 'Monthly Subscription', -15.00, 'Expense', 74),   -- Subscription
('2024-03-20', 'Gift Received', 250.00, 'Income', 44),          -- Gifts Received
('2024-03-25', 'Home Repair', -300.00, 'Expense', 36),           -- Repairs
('2024-03-30', 'Interest from Savings', 50.00, 'Income', 46),   -- Interest
('2024-04-01', 'Travel Expenses', -500.00, 'Expense', 82);       -- Travel



