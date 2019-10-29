public class HttpUtil {

    public static HttpResponse doGet(String baseUrl, String endpoint, Map<String, String> headers){
        return doCallout(baseUrl,endpoint,'GET',null,headers);
    }
    
    private static HttpResponse doCallout(String baseUrl, String endpoint, String method, String body, Map<String, String> headers){
        if(String.isEmpty(baseUrl)) return null;
        String url = baseUrl;
        if(!String.isEmpty(endpoint)) url+= endpoint;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod(method);
        if(body != null) req.setBody(body);
        setHeaders(req,headers);
        return h.send(req);
    }

    private static void setHeaders(HttpRequest req, Map<String, String> headers){
        if(headers == null) return;
        for(String key: headers.keySet()){
            req.setHeader(key, headers.get(key));
        }
    }
}