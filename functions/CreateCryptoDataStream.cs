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
        public static async Task Run([TimerTrigger("0 */15 * * * *")] TimerInfo myTimer,
                                     [EventHub("dest", Connection = "EventHubConnectionAppSetting")]IAsyncCollector<string> outputEvents,
                                     ILogger log)
        {
            log.LogInformation($"C# Timer trigger function CreateCryptoDataStream began executing at: {DateTime.Now}");

            var coinApiKey = System.Environment.GetEnvironmentVariable("CoinApiKeyAppSetting", EnvironmentVariableTarget.Process);

            var coinApiEndpointTester = new CoinApiRestEndpointsTester(coinApiKey)
            {
                Log = s => log.LogInformation(s)
            };

            log.LogInformation("Calling the CoinAPI List Asset method");

            var assets = await coinApiEndpointTester.Metadata_list_assetsAsync();

            log.LogInformation($"The number of Assets returned: {assets.Data.Count} ");

            int i = 0;

            foreach (var asset in assets.Data.Where(x=> x.type_is_crypto))
            {
                var streamEvent = new CrytoAssetStreamEvent(asset);

                string json = JsonConvert.SerializeObject(streamEvent);

                log.LogInformation($"Sending event: {json}");

                await outputEvents.AddAsync(json);

                i++;
            }

            log.LogInformation($"The number of Assets streamed: {assets.Data.Count} ");

            log.LogInformation($"C# Timer trigger function CreateCryptoDataStream finished executing at: {DateTime.Now}");
        }
    }

    public class CrytoAssetStreamEvent
    {
        public string Symbol { get; set; }
        public decimal? Price { get; set; }
        public DateTime PriceTimeStamp { get => DateTime.Now; }

        public CrytoAssetStreamEvent(Asset asset)
        {
            Symbol = asset.asset_id;
            Price = asset.price_usd;
        }
    }
}
