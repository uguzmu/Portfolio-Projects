-- Data Cleaning Project
-- The PropertyAddress column cannot be empty. By using the matching ParcelID across multiple records,
-- it will be used to fill in the missing data in PropertyAddress, and the table will be updated using the UPDATE command.

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM pryecto_portafolio_2.dbo.HousingData a
JOIN pryecto_portafolio_2.dbo.HousingData b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM pryecto_portafolio_2.dbo.HousingData a
JOIN pryecto_portafolio_2.dbo.HousingData b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress IS NULL

-- Now we will split the PropertyAddress column into two separate columns, using ',' as the delimiter.

SELECT PARSENAME(REPLACE(PropertyAddress,',','.'),2),
PARSENAME(REPLACE(PropertyAddress,',','.'),1)
FROM pryecto_portafolio_2.dbo.HousingData

-- Using ALTER TABLE and UPDATE, two new columns are created and added to the original table.

ALTER TABLE pryecto_portafolio_2.dbo.HousingData
ADD Property_Address NVARCHAR(255)

UPDATE pryecto_portafolio_2.dbo.HousingData
SET Property_Address = PARSENAME(REPLACE(PropertyAddress,',','.'),2)

ALTER TABLE pryecto_portafolio_2.dbo.HousingData
ADD Property_City NVARCHAR(255)

UPDATE pryecto_portafolio_2.dbo.HousingData
SET Property_City = PARSENAME(REPLACE(PropertyAddress,',','.'),1)

SELECT *
FROM pryecto_portafolio_2.dbo.HousingData

-- Now we will do the same, splitting the OwnerAddress column into three separate columns.

SELECT PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM pryecto_portafolio_2.dbo.HousingData

ALTER TABLE pryecto_portafolio_2.dbo.HousingData
ADD Owner_Address NVARCHAR(255)

UPDATE pryecto_portafolio_2.dbo.HousingData
SET Owner_Address = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE pryecto_portafolio_2.dbo.HousingData
ADD Owner_City NVARCHAR(255)

UPDATE pryecto_portafolio_2.dbo.HousingData
SET Owner_City = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE pryecto_portafolio_2.dbo.HousingData
ADD Owner_State NVARCHAR(255)

UPDATE pryecto_portafolio_2.dbo.HousingData
SET Owner_State = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

-- In the Sold As Vacant column, the values 0 and 1 are used to specify whether the property was sold vacant or not.
-- These values 0 and 1 will be changed to Yes and No.

SELECT
CASE 
	WHEN SoldAsVacant = '0' THEN 'No'
	WHEN SoldAsVacant = '1' THEN 'Yes'
END
FROM pryecto_portafolio_2.dbo.HousingData

-- Here the data type of the SoldAsVacant column is modified to allow converting the values 0 and 1 to No and Yes.

ALTER TABLE pryecto_portafolio_2.dbo.HousingData
ALTER COLUMN SoldAsVacant NVARCHAR(3);

UPDATE pryecto_portafolio_2.dbo.HousingData
SET SoldAsVacant = CASE 
	WHEN SoldAsVacant = '0' THEN 'No'
	WHEN SoldAsVacant = '1' THEN 'Yes'
END

-- Duplicates are removed.

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM pryecto_portafolio_2.dbo.HousingData
--order by ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

Select *
From pryecto_portafolio_2.dbo.HousingData

-- Unnecessary columns are removed.

Select *
From pryecto_portafolio_2.dbo.HousingData


ALTER TABLE pryecto_portafolio_2.dbo.HousingData
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate