# Azure Functions

## EventHub Binding

Run the following command on the ./functions folder to add the Events Hub Extensions package to the Function so we can use it as a Trigger and an Output binding.

    dotnet add package Microsoft.Azure.WebJobs.Extensions.EventHubs --version 5.0

## Reference a compiled assembly

Put the assembly (.dll) in a folder under the root of the ./functions folder then reference it in the functions project file (.csproj) as shown below:

    <ItemGroup>
        <Reference Include="CoinAPI.REST.V1">
            <HintPath>./assemblies/CoinAPI.REST.V1.dll</HintPath>
        </Reference>
    </ItemGroup>

## Demo Use Case

In the demo contained in this workspace, there is a set of Azure Functions in the ./functions folder.

### CreateCryptoDataStream

This Function pulls data from the CoinAPI RESTful APIs, shapes the data, and then streams the data to a EventHub for further processing.

#### Example of a returned Asset entity

The number of total Assets returned with the list assets method: 14708

    {
        "asset_id": "BTC",
        "name": "Bitcoin",
        "type_is_crypto": true,
        "data_quote_start": "2014-02-24T17:43:05Z",
        "data_quote_end": "2022-02-25T21:41:53.9319297Z",
        "data_orderbook_start": "2014-02-24T17:43:05Z",
        "data_orderbook_end": "2020-08-05T14:38:38.3413202Z",
        "data_trade_start": "2010-07-17T23:09:17Z",
        "data_trade_end": "2022-02-25T21:43:19.569Z",
        "data_quote_count": null,
        "data_trade_count": null,
        "data_symbols_count": 78613,
        "volume_1hrs_usd": 1395957636431.97,
        "volume_1day_usd": 58822682774313.03,
        "volume_1mth_usd": 3004871336305931.48,
        "price_usd": 39035.215623934581686054259276
    }

