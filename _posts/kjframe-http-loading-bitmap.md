title: 用KJFrame的KJHttp请求无法加载图片
date: 2015-05-27 00:32:54
categories: 技术
tags:
- android
- KJFrame
- http
- bitmap
---
KJFrame框架对Http请求和sqlite的ORM封装的挺简单实用的，所以前几天的hackathon比赛就用了这个框架，不过最后用KJHttp进行请求后，发现`onSuccess(Bitmap t)`接口似乎不会调用，最后也没测试时间了也就没解决这个问题了。

回过头来看看KJFram的源码发现
{% codeblock lang:java FormRequest.java %}
@Override
protected void deliverResponse(Map<String, String> headers, byte[] response) {
    if (mCallback != null) {
        mCallback.onSuccess(headers, response);
    }
}
{% endcodeblock %}
和volley相同的方式调用`HttpCallBack`的
{% codeblock lang:java HttpCallBack.java %}
public void onSuccess(Map<String, String> headers, byte[] t) {
    onSuccess(t);
}

public void onSuccess(byte[] t) {
    if (t != null) {
        onSuccess(new String(t));
    }
}

public void onSuccess(String t) {}

public void onSuccess(Bitmap t) {}
{% endcodeblock %}
很明显，这里你就算重写了`onSuccess(Bitmap t)`也不会调用。

---
看过源码后才发现有个`KJBitmap`类专门用来处理图片请求，并且使用的是`BitmapCallBack`
{% codeblock lang:java KJBitmap.java %}
	/**
     * 真正去加载一个图片
     */
    private void doDisplay(final View imageView, final String imageUrl,
            int width, int height, final Drawable loadBitmap,
            final Drawable errorBitmap, final BitmapCallBack callback) {
        checkViewExist(imageView);

        imageView.setTag(imageUrl);

        BitmapCallBack mCallback = new BitmapCallBack() {
            @Override
            public void onPreLoad() {
                if (callback != null) {
                    callback.onPreLoad();
                }
            }

            @Override
            public void onSuccess(Bitmap bitmap) {
                if (imageUrl.equals(imageView.getTag())) {
                    doSuccess(imageView, bitmap, loadBitmap);
                    if (callback != null) {
                        callback.onSuccess(bitmap);
                    }
                }
            }

            @Override
            public void onFailure(Exception e) {
                doFailure(imageView, errorBitmap);
                if (callback != null) {
                    callback.onFailure(e);
                }
            }

            @Override
            public void onFinish() {
                try {
                    doLoadingViews.remove(imageView);
                } catch (Exception e) {
                }
                if (callback != null) {
                    callback.onFinish();
                }
            }
        };

        if (imageUrl.startsWith("http")) {
            displayer.get(imageUrl, width, height, mCallback);
        } else {
            new DiskImageRequest().load(imageUrl, width, width, mCallback);
        }
    }
{% endcodeblock %}

---
最后倒是想吐槽一下，把HttpCallBack里得到的`byte[]`数据转换成`Bitmap`调用`onSucess(Bitmap t)`不行吗。。