select * from project1..Data



-- Converting SaleDate into Date datatype

alter table project1..data
add SalesDate Date;

update project1..data
set SalesDate = convert(date,SaleDate)



-- Filling the Null Values in PropertyAddress

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from project1..data as a
join project1..data as b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from project1..data as a
join project1..data as b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null



-- Splitting PropertyAddress & OwnerAddress into Address, City, Country

alter table project1..data
add PropertyAddress1 varchar(250);

alter table project1..data
add PropertyCity varchar(250);

update project1..data
set PropertyAddress1 = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

update project1..data
set PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress))

select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
from project1..data

alter table project1..data
add OwnerAddress1 varchar(250);

alter table project1..data
add OwnerCity varchar(250);

alter table project1..data
add OwnerCountry varchar(250);

update project1..data
set OwnerAddress1 = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

update project1..data
set OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

update project1..data
set OwnerCountry = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)



-- Converting Y & N to Yes and No in SoldAsVacant column

select distinct (SoldAsVacant)
from project1..data

select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
from project1..data

update project1..data
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
from project1..data



-- Removing useless columns fro table
delete from project1..data
where OwnerName is null;

alter table project1..data
drop column PropertyAddress, SaleDate, OwnerAddress


select * from project1..data;