using System;
using System.Threading.Tasks;
using System.Linq;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;
using CoinAPI.REST.V1;
using Newtonsoft.Json;

namespace DataModel.Demo
{
    public static class CreateCryptoDataStream
    {
        [FunctionName("CreateCryptoDataStream")]
        public static async Task Run([TimerTrigger("0 */1 * * * *")] TimerInfo myTimer,
                                     [EventHub("dest", Connection = "EventHubConnectionAppSetting")]IAsyncCollector<string> outputEvents,
                                     ILogger log)
        {
            log.LogInformation($"C# Timer trigger function CreateCryptoDataStream executed at: {DateTime.Now}");

            var coinApiKey = System.Environment.GetEnvironmentVariable("CoinApiKey", EnvironmentVariableTarget.Process);

            var coinApiEndpointTester = new CoinApiRestEndpointsTester(coinApiKey)
            {
                Log = s => log.LogInformation(s)
            };

            log.LogDebug("Calling the CoinAPI List Asset method.");

            var assets = await coinApiEndpointTester.Metadata_list_assetsAsync();

            log.LogInformation($"The number of Assets returned: {assets.Data.Count} ");

            foreach (var asset in assets.Data.Where(x=> x.type_is_crypto))
            {
                var streamEvent = new CrytoAssetStreamEvent(asset);

                string json = JsonConvert.SerializeObject(streamEvent);

                log.LogInformation(json);
            }
        }
    }

    public struct CrytoAssetStreamEvent
    {
        string Symbol { get; set;}
        decimal? Price { get; set;}
        DateTime PriceTimeStamp {get => DateTime.Now;}

        public CrytoAssetStreamEvent(Asset asset)
        {
            Symbol = asset.asset_id;
            Price = asset.price_usd;
        }
    }
}
