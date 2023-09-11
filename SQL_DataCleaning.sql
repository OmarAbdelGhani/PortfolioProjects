use PortfolioProject

select *
from NashvilleHousing


---------------------Standardize Date Format

alter table NashvilleHousing
add SaleDateConverted date

update NashvilleHousing
set SaleDateConverted = convert(date,SaleDate)

select SaleDateConverted
from NashvilleHousing
/*
update [Nashville Housing]
set SaleDate = convert(date,SaleDate)
select SaleDate
from [Nashville Housing]
*/

---------------Populate PropertyAdress

  select *
  from NashvilleHousing
  --where PropertyAddress is null
  order by ParcelID

  select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
  from NashvilleHousing a
  join NashvilleHousing b
	on a.ParcelID=b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID=b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]

select PropertyAddress
from NashvilleHousing
where PropertyAddress is null


--Breaking out Adress into Different Columns (Adress,City)

select PropertyAddress
from NashvilleHousing

select 
	SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Adress,
	SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as City
from NashvilleHousing

alter table NashvilleHousing
add PropertySplitAdress Nvarchar(255)

alter table NashvilleHousing
add PropertySplitCity Nvarchar(255)

Update NashvilleHousing
set PropertySplitAdress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))

select PropertyAddress,PropertySplitAdress,PropertySplitCity
from NashvilleHousing



---------------Breaking OwnerAdress into (Adress,City,State)

select OwnerAddress
from NashvilleHousing

select
	PARSENAME(REPLACE(OwnerAddress,',','.'),3)
	,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
	,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
	from NashvilleHousing

alter table NashvilleHousing
add OwnerSplitAdress Nvarchar(255)

alter table NashvilleHousing
add OwnerSplitCity Nvarchar(255)

alter table NashvilleHousing
add OwnerSplitState Nvarchar(255)

Update NashvilleHousing
set OwnerSplitAdress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Update NashvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Update NashvilleHousing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

select OwnerAddress,OwnerSplitAdress,OwnerSplitCity,OwnerSplitState
from NashvilleHousing


--------------Change Y & N to Yes & No in SoldAsVacant 

select distinct(SoldAsVacant)
from NashvilleHousing

select SoldAsVacant
, case when SoldAsVacant = 'Y' THEN 'Yes'
		when SoldAsVacant = 'N' THEN 'No'
		else SoldAsVacant
	end
from NashvilleHousing
where SoldAsVacant = 'Y' or SoldAsVacant='N'

update NashvilleHousing
set SoldAsVacant = 
	case when SoldAsVacant = 'Y' THEN 'Yes'
		when SoldAsVacant = 'N' THEN 'No'
		else SoldAsVacant
	end

select SoldAsVacant,count(*)
from NashvilleHousing
group by SoldAsVacant


-----------------Removing Duplicates

With RowNumCTE
AS (
select *,
	ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 Order by
					 UniqueID
					 ) row_num
from NashvilleHousing
--order by ParcelID
)

--Delete 
--from RowNumCTE
--where row_num > 1

select *
from RowNumCTE
where row_num >1


-----------------Delete unused Columns

Alter table NashvilleHousing
drop column OwnerAddress,PropertyAddress,TaxDistrict

Alter table NashvilleHousing
drop column SaleDate

select * 
from NashvilleHousing