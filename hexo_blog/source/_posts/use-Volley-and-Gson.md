title: 如何结合Volley和Gson的使用
date: 2015-05-03 18:33:33
categories: develop
tags: 
- android
- Volley
- Gson
---
Volley和Gson都是谷歌开发的java库，一个处理网络请求，一个处理json，对于网络app来说这2个经常会一起使用，但谷歌似乎不考虑开发两者结合使用的api，所以就需要我们自己来写了。

自定义Request
---
为了使请求能设置request体的参数，然后直接返回我们需要的对象，这时候需要重写Request，谷歌给出了一个重写Request的示例：
{% codeblock lang:java GsonRequest %}
public class GsonRequest<T> extends Request<T> {
    private final Gson gson = new Gson();
    private final Class<T> clazz;
    private final Map<String, String> headers;
    private final Listener<T> listener;

    /**
     * Make a GET request and return a parsed object from JSON.
     *
     * @param url URL of the request to make
     * @param clazz Relevant class object, for Gson's reflection
     * @param headers Map of request headers
     */
    public GsonRequest(String url, Class<T> clazz, Map<String, String> headers,
            Listener<T> listener, ErrorListener errorListener) {
        super(Method.GET, url, errorListener);
        this.clazz = clazz;
        this.headers = headers;
        this.listener = listener;
    }

    @Override
    public Map<String, String> getHeaders() throws AuthFailureError {
        return headers != null ? headers : super.getHeaders();
    }

    @Override
    protected void deliverResponse(T response) {
        listener.onResponse(response);
    }

    @Override
    protected Response<T> parseNetworkResponse(NetworkResponse response) {
        try {
            String json = new String(
                    response.data,
                    HttpHeaderParser.parseCharset(response.headers));
            return Response.success(
                    gson.fromJson(json, clazz),
                    HttpHeaderParser.parseCacheHeaders(response));
        } catch (UnsupportedEncodingException e) {
            return Response.error(new ParseError(e));
        } catch (JsonSyntaxException e) {
            return Response.error(new ParseError(e));
        }
    }
}
{% endcodeblock %}
如果需要设置参数，重写getParams()即可。

自定义数组json Request
---
这里如果直接用`List<MyClass>`来作为 T 的类型是不对的，由于java的类型擦除机制，你从`List<MyClass>`获得的Class类是不包含`MyClass`信息的，gson解析时会抛出错误。

很明显这个GsonRequest无法处理数组形式的json，但是我又想用一个通用的类来处理数组形式的json，要怎么改呢。
我这里提出几个方案供参考。

1. 继承`Request<String>`
在`parseNetworkResponse`里得到的response转换为字符串后放到`Response.success()`函数中返回
然后在`deliverResponse`函数里将字符串转换为对象然后调用接口函数。
不过我个人不喜欢这种做法，因为`deliverResponse`是在UI线程中处理的，解析非常大的json时可能会卡ui，我更喜欢把json的处理放在在工作线程中处理的`parseNetworkResponse`函数中。

2. 分别处理
我是将普通json和数组json分开处理，对于数组类型我传入的参数为
{% codeblock lang:java %}
GsonRequest(Context context, int method, String url, Class<T> clazz, Map<String,String> headers,
                       OnListResponseListener<T> listener, Response.ErrorListener errorListener)
{% endcodeblock %}
这里我自定义了一个接口`OnListResponseListener<T>`，用于传递解析好的数组对象，`Context`对象是为了得到*MainLooper*，而使回调函数能在ui线程中进行，方便更新ui。
然后设置一个数组标记`isArray = true`
{% codeblock lang:java GsonRequest重写的2个方法 https://github.com/Frezc/BangumiTimeMachine/blob/master/app/src/main/java/frezc/bangumitimemachine/app/network/http/GsonRequest.java GsonRequest.java %}
@Override
    protected Response<T> parseNetworkResponse(NetworkResponse networkResponse) {
        try {
            String json;
            if("gzip".equals(networkResponse.headers.get("Content-Encoding"))) {
                json = NetWorkTool.GZipDecoderToString(networkResponse.data);
            }else {
                json = new String(networkResponse.data,
                        HttpHeaderParser.parseCharset(networkResponse.headers));
            }
            Log.i("GsonRequest",json);
            if(isArray){
                final List<T> list = new ArrayList<T>();
                JsonParser parser = new JsonParser();
                JsonArray jsonArray = parser.parse(json).getAsJsonArray();
                for(JsonElement obj : jsonArray){
                    T t = gson.fromJson(obj, clazz);
                    list.add(t);
                }
                new Handler(context.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        if (listListener != null) {
                            listListener.onResponse(list);
                        }
                    }
                });
                return Response.success(list.get(0), HttpHeaderParser.parseCacheHeaders(networkResponse));
            }else {
                return Response.success(gson.fromJson(json, clazz),
                        HttpHeaderParser.parseCacheHeaders(networkResponse));
            }
        } catch (UnsupportedEncodingException e) {
            return Response.error(new ParseError(e));
        } catch (JsonSyntaxException e) {
            return Response.error(new ParseError(e));
        }
    }

    @Override
    protected void deliverResponse(T t) {
        if(listener != null) {
            listener.onResponse(t);
        }
    }
{% endcodeblock %}
`parseNetworkResponse`里先将返回的Gzip压缩的格式解码，再生成String，然后对于数组我是用过JsonParser转换成JsonArray再进行遍历生成每一个对象，最后在`MainLooper`里调用对应回调函数。

3. 通过Type接口
查看Gson的fromJson函数的源码
{% codeblock lang:java https://github.com/google/gson/blob/master/gson/src/main/java/com/google/gson/Gson.java Gson.java %}
  public <T> T fromJson(String json, Class<T> classOfT) throws JsonSyntaxException {
    Object object = fromJson(json, (Type) classOfT);
    return Primitives.wrap(classOfT).cast(object);
  }
  
  public <T> T fromJson(String json, Type typeOfT) throws JsonSyntaxException {
    if (json == null) {
      return null;
    }
    StringReader reader = new StringReader(json);
    T target = (T) fromJson(reader, typeOfT);
    return target;
  }
{% endcodeblock %}
可见Gson终究是调用`fromJson(StringReader , Type )`来生成对象的，那么我们可以在创建`GsonRequest`时将传入`Class<T>`改为`Type`。
对于json对象传入`(Type)(MyClass.class)`，对于json数组传入`new TypeToken(ArrayList<MyClass>)(){}.getType()`。如：
{% codeblock lang:java %}
        request = new GsonRequest_<ArrayList<WeekSubjects>>(Request.Method.GET,
                NetParams.CALENDAR_URL, new TypeToken<ArrayList<WeekSubjects>>(){}.getType(),headers,this,this);
{% endcodeblock %}
`Response.success`调用时将获得的Obeject对象强制转换为 *T*。
其他地方和原来一样即可。
GsonRequest具体例子看 [GsonRequest_](https://github.com/Frezc/BangumiTimeMachine/blob/master/app/src/main/java/frezc/bangumitimemachine/app/network/http/GsonRequest_.java)