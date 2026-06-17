using System;
using System.Net.Http;
using System.Text.Json.Nodes;

using MimeTypes;
using RestSharp;

#pragma warning disable CS0162


/*
 * Use 'normal' mode if you have an API Key from the API4AI Developer Portal. This is the method that users should normally prefer.
 *
 * Use 'rapidapi' if you want to try api4ai via RapidAPI marketplace.
 * For more details visit:
 *   https://rapidapi.com/api4ai-api4ai-default/api/brand-recognition/details
 */

const String MODE = "normal";


/*
 * Your API4AI key. Fill this variable with the proper value if you have one.
 */
const String API4AI_KEY = "";


/*
 * Your RapidAPI key. Fill this variable with the proper value if you want
 * to try api4ai via RapidAPI marketplace.
 */
const String RAPIDAPI_KEY = "";

String url;
Dictionary<String, String> headers = new Dictionary<String, String>();

switch (MODE) {
    case "normal":
        url = "https://api4ai.cloud/brand-det/v2/results?detailed=True";
        headers.Add("X-API-KEY", API4AI_KEY);
        break;
    case "rapidapi":
        url = "https://brand-recognition.p.rapidapi.com/v2/results?detailed=True";
        headers.Add("X-RapidAPI-Key", RAPIDAPI_KEY);
        break;
    default:
        Console.WriteLine($"[e] Unsupported mode: {MODE}");
        return 1;
}

// Prepare request.
String image = args.Length > 0 ? args[0] : "https://static.api4.ai/samples/brand-det-2.jpg";
var client = new RestClient(new RestClientOptions(url) { ThrowOnAnyError = true });
var request = new RestRequest();
if (image.Contains("://")) {
    request.AddParameter("url", image);
} else {
    request.AddFile("image", image, MimeTypeMap.GetMimeType(Path.GetExtension(image)));
}
request.AddHeaders(headers);

// Perform request.
var jsonResponse = (await client.ExecutePostAsync(request)).Content!;

// Print raw response.
Console.WriteLine($"[i] Raw response:\n{jsonResponse}\n");

// Parse response and print recognized brands.
JsonNode docRoot = JsonNode.Parse(jsonResponse)!.Root;
JsonArray brands = docRoot["results"]![0]!["entities"]![0]!["array"]!.AsArray();
Console.WriteLine("[i] Recognized brands:");
foreach (var brand in brands) {
    string name = brand["name"]!.ToString();
    string sizeCategory = brand["size_category"]!.ToString();
    Console.WriteLine($"  - {name}: {sizeCategory}");
}

return 0;
