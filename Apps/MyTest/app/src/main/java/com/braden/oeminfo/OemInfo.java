package com.braden.oeminfo;

public class OemInfo {

    // ~ Methods

    /**
     *  Set elem's value of certain block.
     *  @param blockName:   block name, MUST be the same as SyncByte's value.
     *  @param elemName:    elem name, MUST be the same as the block's field name.
     *  @param val:         value to be set
     *
     *  @return  0, success; other value, fail.
     */
    public static int  setElem(String blockName,String elemName, byte[]val)
    {
        OemInfoNative.openOemInfo();
        int ret = OemInfoNative.setElem(blockName, elemName, val);
        OemInfoNative.closeOemInfo();

        return ret;
    }

    /**
     *  Get elem's value of certain block.
     *  @param blockName:   block name, MUST be the same as SyncByte's value.
     *  @param elemName:    elem name, MUST be the same as the block's field name.
     *
     *  @return  elem's value
     */
    public static byte[]  getElem(String blockName,String elemName)
    {
        OemInfoNative.openOemInfo();
        byte[] val = OemInfoNative.getElem(blockName, elemName);
        OemInfoNative.closeOemInfo();

        return val;
    }

    /**
     *  Set data of certain block.
     *  @param blockName:   block name, MUST be the same as SyncByte's value.
     *  @param start:       offset in the struct
     *  @param length:      data's length to be set
     *  @param val:         data to be set
     *
     *  @return  0, success; other value, fail.
     */
    public static int  setData(String blockName,int start, int length, byte[]val)
    {
        OemInfoNative.openOemInfo();
        int ret = OemInfoNative.setData(blockName, start, length, val);
        OemInfoNative.closeOemInfo();

        return ret;
    }

    /**
     *  Get data from certain block.
     *  @param blockName:   block name, MUST be the same as SyncByte's value.
     *  @param start:       offset in the struct
     *  @param length:      data's length to be read
     *
     *  @return  data from start to start+length, [start, start+ength).
     */
    public static byte[]  getData(String blockName,int start ,int length)
    {
        OemInfoNative.openOemInfo();
        byte[] val = OemInfoNative.getData(blockName, start , length);
        OemInfoNative.closeOemInfo();

        return val;
    }
}

