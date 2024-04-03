CREATE OR ALTER PROC GetPaymentM @month varchar(10)
/**Take an Input string thisMonth or preMonth and Outputs total payments
either this or previous month**/
AS
BEGIN
IF @month like  'thi%' 
	BEGIN
		DECLARE @a DATE, @Y INT, @M INT
		SET @a =(SELECT MAX(paymentDate) FROM payment)
		SET @M = MONTH(@a)
		SET @Y = YEAR(@a)

		SELECT SUM(amount)
		FROM Payment
		WHERE YEAR(paymentDate) = @Y AND MONTH(paymentDate) = @M
	END
IF @month like 'pre%'
	BEGIN
		DECLARE @a DATE, @Y INT, @M INT
		SET @a =(SELECT MAX(paymentDate) FROM payment)
		SET @M = MONTH(@a) - 1
		SET @Y = YEAR(@a)

		SELECT SUM(amount)
		FROM Payment
		WHERE YEAR(paymentDate) = @Y AND MONTH(paymentDate) = @M
	END
END
exec GetPaymentM 'thi'


GO

-- Getting the frequency of any entity in any table
CREATE OR ALTER PROC count_entity @column VARCHAR(20), @table VARCHAR(20), @topN INT = 100000
AS
BEGIN
	DECLARE @SqlQuery NVARCHAR(MAX);
	SET @SqlQuery = 'SELECT TOP(' + CONVERT(NVARCHAR(50), @topN) + ')' + QUOTENAME(@column) + ' AS ' + QUOTENAME(@column) + ',' +
					'COUNT(' + QUOTENAME(@column) + ') AS [Count of ' + @column + ']' +
        ' FROM ' +@table +
        ' GROUP BY ' + QUOTENAME(@column) +
        ' ORDER BY 2 DESC;';

	EXEC sp_executesql @SqlQuery;
END

GO

EXEC count_entity customerid, rental, 10
EXEC count_entity customerid, rental

EXEC count_entity filmid, inventory

GO
--Who are the topN customers by rental frequency?
CREATE OR ALTER PROC topNcustmersByRentalFrequency @topN INT
AS
BEGIN
	DECLARE @SqlQuery NVARCHAR(MAX);
	SET @SqlQuery = 'SELECT TOP(' + CONVERT(NVARCHAR(50), @topN) + ')' +
	'c.firstName+'' ''+c.lastName AS full_name, COUNT(r.customerId) AS rental_frequency
	FROM Rental r, Customer c
	WHERE c.customerId = r.customerId
	GROUP BY firstName, lastName
	ORDER BY rental_frequency DESC'

	EXEC sp_executesql @SqlQuery;
END

go
EXEC topNcustmersByRentalFrequency 10

GO

--What is the average rental duration per customer?
CREATE OR ALTER PROC avg_rental_duration @customer_id INT = NULL
AS
BEGIN
    DECLARE @SqlQuery NVARCHAR(MAX);
    
    -- Build the dynamic SQL statement
    SET @SqlQuery = 'SELECT * FROM dbo.vRentalPeriod WHERE 1=1';

    -- Add condition for customer_id if it's provided
    IF @customer_id IS NOT NULL
    BEGIN
        SET @SqlQuery = @SqlQuery + ' AND customer_id = @ParamCustomerID';
    END

    -- Execute the dynamic SQL
    EXEC sp_executesql @SqlQuery, N'@ParamCustomerID INT', @customer_id;
END

GO
EXEC avg_rental_duration 17
EXEC avg_rental_duration

GO
--How many new customers did we acquire each month?
CREATE OR ALTER PROC customers_per_month 
    @month INT = NULL, 
    @year INT = NULL
AS
BEGIN
    DECLARE @SqlQuery NVARCHAR(MAX);

    SET @SqlQuery = 'SELECT COUNT(customerid) AS number_of_customers, 
                            MONTH(paymentDate) AS month_num, 
                            YEAR(paymentDate) AS year_num 
                    FROM Payment
                    WHERE 1 = 1'; -- Always true condition to start the WHERE clause

    -- Add filters based on the parameters
    IF @month IS NOT NULL
    BEGIN
        SET @SqlQuery = @SqlQuery + ' AND MONTH(paymentDate) = ' + CONVERT(NVARCHAR(50), @month);
    END

    IF @year IS NOT NULL
    BEGIN
        SET @SqlQuery = @SqlQuery + ' AND YEAR(paymentDate) = ' + CONVERT(NVARCHAR(50), @year);
    END

    -- Grouping and ordering
    SET @SqlQuery = @SqlQuery + ' GROUP BY MONTH(paymentDate), YEAR(paymentDate) 
                                  ORDER BY year_num, month_num';

    -- Execute the dynamic SQL
    EXEC sp_executesql @SqlQuery;
END


GO
EXEC customers_per_month 3,2014
EXEC customers_per_month 3
EXEC customers_per_month
GO

--Top 10 Last update
CREATE VIEW Top10LastUpdatePaymentsView AS
SELECT TOP (10) [paymentId], [rentalId], [customerId], [staffId], [amount], [paymentDate], [lastUpdate]
FROM [sakila].[dbo].[Payment]
ORDER BY [lastUpdate] DESC;

GO
-- the last payment 
CREATE VIEW LastPaymentView AS
SELECT TOP (1) [paymentId], [rentalId], [customerId], [staffId], [amount], [paymentDate], [lastUpdate]
FROM [sakila].[dbo].[Payment]
ORDER BY [paymentDate] DESC;

GO

-- get total payment by Year
CREATE VIEW TotalPaymentByMonthView AS
SELECT
    YEAR(paymentDate) AS PaymentYear,
    SUM(amount) AS TotalPayment
FROM
    [sakila].[dbo].[Payment]
GROUP BY
    YEAR(paymentDate)

GO


--- all data relation on paymnet
CREATE VIEW PaymentHistoryView AS
SELECT 
    p.paymentId,
    c.customerId,
    CONCAT(c.firstName, ' ', c.lastName) AS customer_name,
    p.amount,
    p.paymentDate,
    r.rentalId,
    r.rentalDate
FROM Payment p
JOIN Rental r ON p.rentalId = r.rentalId
JOIN Customer c ON p.customerId = c.customerId;

GO

-- Total payment Summery Per Month
CREATE VIEW MonthlyPaymentSummaryView AS
SELECT 
    YEAR(paymentDate) AS payment_year,
    MONTH(paymentDate) AS payment_month,
    COUNT(paymentDate) AS total_payments,
    SUM(amount) AS total_amount_paid
FROM payment
GROUP BY YEAR(paymentDate), MONTH(paymentDate)

GO


-- VIEW FOR FILM REPORTING
CREATE OR ALTER VIEW Films_View
AS

SELECT
    F.filmId,
    F.title,
    F.description,
    F.releaseYear,
    F.languageId AS filmLanguageId,
    F.rentalDuration,
    F.length,
    F.replacementCost,
    F.rating,
    F.rentalRate,
    F.specialFeatures,
    F.lastUpdate AS filmLastUpdate,
    FC.categoryId,
    FC.lastUpdate AS filmCategoryLastUpdate,
    C.name AS categoryName,
    C.lastUpdate AS categoryLastUpdate,
    L.name AS languageName,
    L.languageId AS languageId,
    L.lastUpdate AS languageLastUpdate
FROM
    Film F
JOIN
    filmCategory FC ON F.filmId = FC.filmId
JOIN
    Category C ON FC.categoryId = C.categoryId
JOIN
    Language L ON F.languageId = L.languageId


--add inStock column for Film table
ALTER TABLE Film 
ADD InStock int

GO

--inserting random values into InSrock column
DECLARE @n int = 1
WHILE @n <= 1000
BEGIN
	UPDATE Film
	SET InStock = FLOOR(RAND()*100)
	WHERE filmId = @n

	SET @n = @n + 1
END
