package com.braden.oeminfo;

public class OemInfoNative {
    // ~ Static fields/initializers

    static {
        System.loadLibrary("oeminfo");
    }

    // ~ Methods

    /**
    * open OEMINFO file.
    */
    public static native void openOemInfo();

    /**
    * close OEMINFO file.
    */
    public static native void closeOemInfo();

    /**
    * set element in Block in OEMINFO partition, by blockName & elemName & elem's val.
    */
    public static native int  setElem(String blockName,String elemName, byte[]val);

    /**
    * get element of Block in OEMINFO partition, by blockName & elemName.
    */
    public static native byte[]  getElem(String blockName,String elemName);

    /**
     * set data in Block
     */
    public static native int  setData(String blockName,int start, int length, byte[]val);

    /**
    * get data in Block
    */
    public static native byte[]  getData(String blockName,int start ,int length);

}

