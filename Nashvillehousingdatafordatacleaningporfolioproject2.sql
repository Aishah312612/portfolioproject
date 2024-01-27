/****** Script for SelectTopNRows command from SSMS  ******/
]
    
 
 ---Cleaning Data in Sql Queries

  select *  
  FROM [portfolioproject].[dbo].[NashvilleHousing]

  ---Standardize Date Format

  select SaleDateConverted, Convert(Date,SaleDate)
FROM [portfolioproject].[dbo].[NashvilleHousing]


ALTER TABLE [NashvilleHousing]
add SaleDateConverted Date;

update  [NashvilleHousing]
Set SaleDateConverted = Convert(Date,SaleDate)

---Populate property Address data

 select *
FROM [portfolioproject].[dbo].[NashvilleHousing]
--Where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyAddress,b.PropertyAddress)
FROM [portfolioproject].[dbo].[NashvilleHousing] a
join [portfolioproject].[dbo].[NashvilleHousing] b
on a.ParcelID = b.ParcelID 
and a.[uniqueID ] <> b.[uniqueID ]
where a.PropertyAddress is null


update a
Set PropertyAddress = ISNULL(a.propertyAddress,b.PropertyAddress)
FROM [portfolioproject].[dbo].[NashvilleHousing] a
join [portfolioproject].[dbo].[NashvilleHousing] b
on a.ParcelID = b.ParcelID 
and a.[uniqueID ] <> b.[uniqueID ]
where a.PropertyAddress is null 


----Breaking out Address into Individual Columns (Address, City, States)

select PropertyAddress
FROM [portfolioproject].[dbo].[NashvilleHousing]
--Where PropertyAddress is null
--order by ParcelID

select
Substring(PropertyAddress, 1, Charindex(',', PropertyAddress) -1) as Address
, Substring(PropertyAddress, Charindex(',', PropertyAddress) +1, len(propertyAddress)) as Address  
FROM [portfolioproject].[dbo].[NashvilleHousing]

ALTER TABLE [NashvilleHousing]
add PropertysplitAddress Varchar(255);

update  [NashvilleHousing]
Set PropertysplitAddress = substring(PropertyAddress, 1, Charindex(',', PropertyAddress) -1)

ALTER TABLE [NashvilleHousing]
add PropertysplitCity varchar(255);

update  [NashvilleHousing]
Set PropertysplitCity = Substring(PropertyAddress, Charindex(',', PropertyAddress) +1, len(propertyAddress))

select *
FROM [portfolioproject].[dbo].[NashvilleHousing]

select OwnerAddress
FROM [portfolioproject].[dbo].[NashvilleHousing]

select 
ParseName(Replace(OwnerAddress, ',', '.'),3)
,ParseName(Replace(OwnerAddress, ',', '.'),2)
,ParseName(Replace(OwnerAddress, ',', '.'),1)
FROM [portfolioproject].[dbo].[NashvilleHousing]



ALTER TABLE [NashvilleHousing]
add OwnersplitAddress Varchar(255);

update  [NashvilleHousing]
Set OwnersplitAddress = ParseName(Replace(OwnerAddress, ',', '.'),3)

ALTER TABLE [NashvilleHousing]
add OwnersplitCity varchar(255);

update  [NashvilleHousing]
Set OwnersplitCity = ParseName(Replace(OwnerAddress, ',', '.'),2)

ALTER TABLE [NashvilleHousing]
add OwnersplitState varchar(255);

update  [NashvilleHousing]
Set OwnersplitState = ParseName(Replace(OwnerAddress, ',', '.'),1)

select *
FROM [portfolioproject].[dbo].[NashvilleHousing]


---change Y and N Yes and No In "sold as vacant" fied

Select Distinct (Soldasvacant), Count(Soldasvacant)
FROM [portfolioproject].[dbo].[NashvilleHousing]
Group by Soldasvacant
order by 2

select Soldasvacant
, case when  Soldasvacant = 'Y' Then 'Yes'
       when  Soldasvacant = 'N' Then 'NO'
	   Else  Soldasvacant
	   END
FROM [portfolioproject].[dbo].[NashvilleHousing]

update  [NashvilleHousing]
Set  Soldasvacant = case when  Soldasvacant = 'Y' Then 'Yes'
       when  Soldasvacant = 'N' Then 'NO'
	   Else  Soldasvacant
	   END

---Remove Dublicate
With RownumCTE as(
select *,
  Row_Number() Over(
  Partition by ParcelID, 
               PropertyAddress,
			   Saleprice,
			   Saledate,
			   LegalReference
			   ORDER BY
			     UniqueID
				 ) row_num

FROM [portfolioproject].[dbo].[NashvilleHousing]
--ORDER BY ParcelID
)
select *
from RownumCTE
where row_num > 1
--order by PropertyAddress


---Delete unused Column
select * 
FROM [portfolioproject].[dbo].[NashvilleHousing]

Alter Table [portfolioproject].[dbo].[NashvilleHousing]
Drop column OwnerAddress, TaxDistrict, propertyAddress

Alter Table [portfolioproject].[dbo].[NashvilleHousing]
Drop column SaleDate
