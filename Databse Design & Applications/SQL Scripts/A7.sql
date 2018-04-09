/* William Brown
   CIS 310-01
   Assignment 7
   3/6/2017
*/
--103
SELECT Movie_Title,
	   Movie_Year,
	   Movie_Genre
FROM MOVIE

--104
SELECT Movie_Year,
	   Movie_Title,
	   Movie_Cost 
FROM MOVIE
ORDER BY Movie_Year DESC

--105
SELECT Movie_Title,
	   Movie_Year,
	   Movie_Genre
FROM MOVIE
ORDER BY Movie_Genre ASC, Movie_Year DESC

--106
SELECT Movie_Num,
	   Movie_Title,
	   Price_Code
FROM MOVIE
WHERE Movie_Title LIKE 'R%'

--107
SELECT Movie_Title,
	   Movie_Year,
	   Movie_Cost
FROM MOVIE
WHERE Movie_Title LIKE '%hope%'
ORDER BY Movie_Title

--108
SELECT Movie_Title,
	   Movie_Year,
	   Movie_Genre
FROM MOVIE
WHERE Movie_Genre = 'ACTION'

--109
SELECT Movie_Num,
	   Movie_Title,
	   Movie_Cost
FROM MOVIE
WHERE Movie_Cost > 40


--110
SELECT Movie_Num,
	   Movie_Title,
	   Movie_Cost,
	   Movie_Genre
FROM MOVIE
WHERE Movie_Genre = 'ACTION' OR 
	  (Movie_Genre = 'COMEDY' AND Movie_Cost < 50)
ORDER BY Movie_Genre ASC

--111
SELECT Mem_Num,
	   --CONCAT(Mem_FName,' ',Mem_LName) AS 'Mem_Name',
	   Mem_FName,
	   Mem_LName,
	   Mem_Street,
	   Mem_State,
	   Mem_Balance
FROM MEMBERSHIP
WHERE Mem_State = 'TN' 
  AND Mem_Balance < 5 
  AND Mem_Street LIKE '%Avenue'

--112
SELECT Movie_Genre,
	   COUNT(*) AS 'Number of Movies'
FROM MOVIE
GROUP BY Movie_Genre

--113
SELECT AVG(Movie_Cost) AS 'Average Movie Cost'
FROM MOVIE

--114
SELECT Movie_Genre,
	   AVG(Movie_Cost) AS 'Average Movie Cost'
FROM MOVIE
GROUP BY Movie_Genre

--115
SELECT M.Movie_Title,
	   M.Movie_Genre,
	   P.Price_Description,
	   P.Price_RentFee
FROM MOVIE M 
	INNER JOIN PRICE P ON M.Price_Code = P.Price_Code

--116
SELECT M.Movie_Genre,
	   AVG(P.Price_RentFee) AS 'Average Rental Fee'
FROM MOVIE M
	INNER JOIN PRICE P ON M.Price_Code = P.Price_Code
GROUP BY Movie_Genre

--117
SELECT Movie_Title,
	   (M.Movie_Cost/P.Price_RentFee) AS 'Breakeven Rentals'
FROM MOVIE M
	INNER JOIN PRICE P ON M.Price_Code = P.Price_Code

--118
SELECT Movie_Title,
	   Movie_Year
FROM MOVIE M
	INNER JOIN PRICE P ON M.Price_Code = P.Price_Code

--119
SELECT Movie_Title,
	   Movie_Genre,
	   Movie_Cost
FROM MOVIE
WHERE Movie_Cost BETWEEN 44.99 AND 49.99

--120
SELECT Movie_Title,
	   P.Price_Description,
	   P.Price_RentFee,
	   Movie_Genre
FROM MOVIE M
	INNER JOIN PRICE P ON M.Price_Code = P.Price_Code
WHERE Movie_Genre IN ('FAMILY','COMEDY', 'DRAMA')

--121
SELECT M.Mem_Num,
	   --CONCAT(Mem_LName,', ',Mem_FName) AS 'Mem_Name',
	   Mem_FName,
	   Mem_LName,
	   Mem_Balance
FROM MEMBERSHIP M
	INNER JOIN RENTAL R ON M.Mem_Num = R.Mem_Num

--122
SELECT MIN(Mem_Balance) AS 'Minimum Balance',
	   MAX(Mem_Balance) AS 'Maximum Balance',
	   AVG(Mem_Balance) AS 'Average Balance'
FROM MEMBERSHIP M
	INNER JOIN RENTAL R ON M.Mem_Num = R.Mem_Num

--123
SELECT R.Rent_Num,
	   R.Rent_Date,
	   DR.Vid_Num,
	   M.Movie_Title,
	   DR.Detail_DueDate,
	   DR.Detail_ReturnDate
FROM RENTAL R
	INNER JOIN DETAILRENTAL DR ON R.Rent_Num = DR.Rent_Num
	INNER JOIN VIDEO V ON DR.Vid_Num = V.Vid_Num
	INNER JOIN MOVIE M ON V.Movie_Num = M.Movie_Num
WHERE DR.Detail_ReturnDate > DR.Detail_DueDate
ORDER BY R.Rent_Num, M.Movie_Title

--124
SELECT R.Rent_Num,
	   R.Rent_Date,
	   M.Movie_Title,
	   DR.Detail_Fee
FROM RENTAL R
	INNER JOIN DETAILRENTAL DR ON R.Rent_Num = DR.Rent_Num
	INNER JOIN VIDEO V ON DR.Vid_Num = V.Vid_Num
	INNER JOIN MOVIE M ON V.Movie_Num = M.Movie_Num
WHERE DR.Detail_ReturnDate <= DR.Detail_DueDate

--125
SELECT Movie_Num,
	   M.Movie_Genre,
	   AVG(Movie_Cost) AS 'Average Cost',
	   Movie_Cost,
	   Movie_Cost-AVG(Movie_Cost)/AVG(Movie_Cost)*100 AS 'Percent Difference'
FROM MOVIE M,
	 (SELECT Movie_Genre,
			 AVG(Movie_Cost) AS 'Average Cost by Genre'
	  FROM MOVIE
	  GROUP BY Movie_Genre) S
WHERE M.Movie_Genre = S.Movie_Genre
GROUP BY Movie_Num, M.Movie_Genre, M.Movie_Cost