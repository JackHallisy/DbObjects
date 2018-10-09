Drop database HW10
Go 

create database HW10;
USE HW10;
GO

Drop Table dbo.Employees;
Go


Create Table dbo.Employees(ID int Not Null Identity Primary Key,
BadgeNum int Not Null Unique,
Title Varchar(20) Null,
DateHired DateTime2 Not Null);
GO

Create Trigger dbo.Employees_Insert
On dbo.Employees
After Insert, Update
As
	Set NoCount On;
	Declare @BadgeNum int = 0;
	Select @BadgeNum = Inserted.BadgeNum
	From Inserted;
	--Print @BadgeNum
	
	Begin
	IF (@BadgeNum >= 0 and @BadgeNum <= 300) Begin
	Update dbo.Employees Set Title = 'Clerk'
	Where @BadgeNum = BadgeNum
	END

	If (@BadgeNum > 300 and @BadgeNum <= 600) Begin 
	Update dbo.Employees Set Title = 'Office Employee'
	Where @BadgeNum = BadgeNum
	END

	If (@BadgeNum > 600 and @BadgeNum < 700) Begin
	Update dbo.Employees Set Title = 'null'
	Where @BadgeNum = BadgeNum
	END

	If (@BadgeNum >= 700 and @BadgeNum <= 800) Begin
	Update dbo.Employees Set Title = 'Manager'
	Where @BadgeNum = BadgeNum
	END

	If (@BadgeNum > 800 and @BadgeNum < 900) Begin
	Update dbo.Employees Set Title = 'null'
	Where @BadgeNum = BadgeNum
	END

	If (@BadgeNum >= 900 and @BadgeNum <= 1000) Begin
	Update dbo.Employees Set Title = 'Director'
	Where @BadgeNum = BadgeNum
	END
End;

Go

---------------------------Random Number Generator---------------------
Declare @counter int;
Declare @BadgeNum int;
Set @Counter = 1;

While @counter < 26
Begin
	Set @BadgeNum = Cast(Rand()* 1000 As int);
	If Not Exists (Select BadgeNum From dbo.Employees
	Where BadgeNum = @BadgeNum)

	Insert Into dbo.Employees(BadgeNum, Title, DateHired)
	Values(@BadgeNum, Null, GetDate());
		Set @Counter = @counter + 1
End;
			


--Select * From dbo.Employees;

---------------------------------------Add Cursor--From Book--------------------

Declare @BadgeNum int; 
Declare @Title Varchar(20);
Declare @DateHired DateTime2;

Declare EmployCursor Cursor Fast_Forward For
	Select BadgeNum, Title, DateHired
	From dbo.Employees;

Open EmployCursor;

Fetch Next From EmployCursor Into @BadgeNum, @Title, @DateHired;
While @@FETCH_STATUS = 0 Begin
	Print 'BadgeNum = ' +  Convert(Varchar(4), @BadgeNum) + ' Title = ' + @Title + '  DateHired = ' + Convert(Varchar(20), @DateHired)
	Fetch Next From EmployCursor;
End

Close EmployCursor;
Deallocate EmployCursor;
Go
