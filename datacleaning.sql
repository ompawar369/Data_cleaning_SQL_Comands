--------------------------------------------------------------------------------------------------------------

-- cleaning Data in SQL Queries
select * from Datacleaning..Housing

-- Standardzie date format 
select SaleDate , convert(date,SaleDate) as real_date
from Datacleaning..Housing


--------------------------------------------------------------------------------------------------------------
--create the column in Table 
alter table Datacleaning..Housing
add SaleDatecoverted Date;
--Update the created column in Table 
Update Datacleaning..Housing
set SaleDatecoverted = convert (date, SaleDate)

-- to drop the whole column
alter table Datacleaning..Housing
drop column Address1

--------------------------------------------------------------------------------------------------------------
--Populate property address data 
select *
from Datacleaning..Housing
--where propertyAddress is null
order by ParcelID

--------------------------------------------------------------------------------------------------------------

select a.ParcelID, a.PropertyAddress, b. ParcelID, b.PropertyAddress , isnull (a.PropertyAddress, b.PropertyAddress)
from Datacleaning..Housing a
join Datacleaning..Housing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID]<> b.[UniqueID]
	where a.propertyAddress is null


Update a
set propertyaddress = isnull (a.PropertyAddress, b.PropertyAddress)
from Datacleaning..Housing a
join Datacleaning..Housing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID]<> b.[UniqueID]
where a.PropertyAddress is null 


--------------------------------------------------------------------------------------------------------------


--Breaking out Address into INdividual colums 

select PropertyAddress
from Datacleaning..Housing



select 
substring(PropertyAddress, 1 , CHARINDEX(',', PropertyAddress)-1) as address,
substring (PropertyAddress ,  charindex(',', PropertyAddress) +1 , len(PropertyAddress)) as addressssss
from Datacleaning..Housing


--------------------------------------------------------------------------------------------------------------


--insert the column in to table
alter table Datacleaning..Housing
add PropertySliteAddress varchar(255);
--Update the created column in Table 
Update Datacleaning..Housing
set PropertySliteAddress = substring(PropertyAddress, 1 , CHARINDEX(',', PropertyAddress)-1);


select * from Datacleaning..Housing


alter table Datacleaning..Housing
add PropertySlitecity varchar(255);
--Update the created column in Table 
Update Datacleaning..Housing
set PropertySlitecity = substring (PropertyAddress ,  charindex(',', PropertyAddress) +1 , len(PropertyAddress));



--upto this 
---------------------------------------------------------------------------------------------------------------------

select 
parsename(replace(owneraddress , ',','.' ),3)
,parsename(replace(owneraddress , ',','.' ),2)
,parsename(replace(owneraddress , ',','.' ),1)
from Datacleaning..housing 




alter table Datacleaning..Housing
add Ownersliteaddress varchar(255);
--Update the created column in Table 
Update Datacleaning..Housing
set Ownersliteaddress = parsename(replace(owneraddress , ',','.' ),3)



alter table Datacleaning..Housing
add Ownerslitecity varchar(255);
--Update the created column in Table 
Update Datacleaning..Housing
set Ownerslitecity = parsename(replace(owneraddress , ',','.' ),2)



alter table Datacleaning..Housing
add PropertySlitestate varchar(255);
--Update the created column in Table 
Update Datacleaning..Housing
set PropertySlitestate = parsename(replace(owneraddress , ',','.' ),1)


---------------------------------------------------------------------------------------------------------------------
-- Changing Y and N to Yes and NO in "Sold as vacant" field


select distinct(SoldAsVacant), count (SoldAsVacant)
from Datacleaning..Housing
group by SoldAsVacant
order by 2


select soldasvacant, 
case when soldasvacant='Y' then 'Yes'  when soldasvacant='N' then 'No'
else soldasvacant 
end
from Datacleaning..Housing


update Datacleaning..Housing
set SoldAsVacant = case when soldasvacant='Y' then 'Yes'  when soldasvacant='N' then 'No'
else soldasvacant 
end

---------------------------------------------------------------------------------------------------------------------
-- remove Dulicates 
With RowNumCTE as
(
select * ,
ROW_NUMBER() over (
partition by parcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate, 
			 legalReference
			 order by 
				uniqueID
				) row_num
from Datacleaning..Housing
--order by ParcelID
)
select *
from RowNumCTE
where row_num > 1
--order by PropertyAddress


--------------------------------------------------------------------------------------------------------------











