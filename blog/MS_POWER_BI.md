# Setting up Power BI

## RDP access

On Ubuntu you can use Remmina Remote Desktop Client.

## Installing Power BI

While on the Windows Server [download Power BI Desktop](https://powerbi.microsoft.com/en-us/get-started/) from their website and install it.

## Installing Phoenix ODBC Driver

While on the Windows Server [download the Hortonworks Phoenix ODBC driver](http://public-repo-1.hortonworks.com/HDP/phoenix-odbc/1.0.0.1000/windows/HortonworksPhoenixODBC64.msi) and install it.

## Create an ODBC data source direct to Phoenix

_Note: this option only works if the HDP has not been Kerberised._

While on the Windows Server:

1. Search for and open `ODBC Data Sources (64-bit)`.
1. On the `User DSN` tab click `Add...`
1. Select the `Hortonworks Phoenix ODBC Driver` and click `Finish`.
1. Enter the details as follows:
  * Data Source Name: `Direct Phoenix Connection`
  * Host: `http://<the HDP URL>`
  * Port: `8765`
1. Click `Test...` and make sure it returns a `SUCCESS` message.

## Create an ODBC data source through Knox to Phoenix

While on the Windows Server:

1. Search for and open `ODBC Data Sources (64-bit)`.
1. On the `User DSN` tab click `Add...`
1. Select the `Hortonworks Phoenix ODBC Driver` and click `Finish`.
1. Enter the details as follows:
  * Data Source Name: `Phoenix Connection Via Knox`
  * Host: `https://<the HDP URL>`
  * Port: `8443`
  * HTTP path: `gateway/sandbox/avatica`
  * Authentication mechanism: `Username and Password`
  * Username: `guest`
  * Password: `guest-password`
1. Click `Test...` and make sure it returns a `SUCCESS` message.

## Get the data in Power BI

1. Click on `Get Data` and then click `More`.
1. Select `Other` and `ODBC`, then click `Connect`.
1. Select one of the ODBC connection set up in the previous step as the DSN.
1. Expand the `Advanced options` and enter the SQL statement:

  ```
  SELECT DOMAIN, AVG(CORE) Average_CPU_Usage, AVG(DB) Average_DB_Usage  FROM WEB_STAT GROUP BY DOMAIN ORDER BY DOMAIN DESC
  ```
1. Click `OK`.
1. Enter the username and password as `guest` and `guest-password`.
