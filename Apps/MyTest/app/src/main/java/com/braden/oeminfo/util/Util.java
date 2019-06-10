package com.braden.oeminfo.util;

public class Util {
    /**
    * whether string is empty
    * @param s
    * @return true
    */
    public static boolean isEmpty(String s) {
        if (s == null) {
            return true;
        } else {
            return s.trim().length() <= 0;
        }
    }

    /**
    * trim string to empty
    * @param s
    * @return trimed string
    */
    public static String trimToEmpty(String s) {
        if (s == null) {
            return "";
        } else {
            return s;
        }
    }

    /**
     * byte to String
     * @param val
     * @return
     */
    public static String byteToString(byte[] input) {
        if (input ==null)
            return "";
        int index=0;
        for (index= 0; (index < input.length) && (input[index] != 0); index++) {
        }
        String strPassword=new String (input,0,index);
        return strPassword;
    }
    /**
     * int get to byte
     * for example intValue = 156  return [-100, 0, 0, 0]
     * @param intValue
     * @return
     */
    public static byte[] int2Byte(int intValue){
        byte[] b=new byte[4];
        for (int i=0;i<4;i++) {
            b[i]=(byte)(intValue>>8*(i) & 0xFF);
        }
        return b;
    }
    /**
     * byte get to int
     * for example b = [-100, 0, 0, 0]  return 156
     * @param b
     * @return
     */
    public static int byte2Int(byte[] b){
        if (b == null)
            return 0;
        int intValue=0;
        for(int i=0;i<b.length;i++){
            intValue +=(b[i] & 0xFF)<<(8*(i));
        }
        return intValue;
    }

    /**
       * @param bytes an array of bytes
       *
       * @return hex string representation of bytes array
       */
    private String bytesToHexString(byte[] bytes, boolean toUpperCase) {
       if (bytes == null) return null;

       StringBuilder ret = new StringBuilder(2*bytes.length);

       for (int i = 0 ; i < bytes.length ; i++) {
           int b;

           b = 0x0f & (bytes[i] >> 4);

           ret.append("0123456789abcdef".charAt(b));

           b = 0x0f & bytes[i];

           ret.append("0123456789abcdef".charAt(b));
       }

       return toUpperCase ? ret.toString().toUpperCase() : ret.toString();
    }

    /**
        * Converts a hex String to a byte array.
        *
        * @param s A string of hexadecimal characters, must be an even number of
        *          chars long
        *
        * @return byte array representation
        *
        * @throws RuntimeException on invalid format
        */
    private byte[] hexStringToBytes(String s, boolean toUpperCase) {
        byte[] ret;

        if (s == null) return null;

        String ss = toUpperCase ? s.toUpperCase() : s;

        int sz = ss.length();

        ret = new byte[sz/2];

        for (int i=0 ; i <sz ; i+=2) {
            ret[i/2] = (byte) ((hexCharToInt(ss.charAt(i)) << 4)
                                | hexCharToInt(ss.charAt(i+1)));
        }

        return ret;
    }

    private int hexCharToInt(char c) {
        if (c >= '0' && c <= '9') return (c - '0');
        if (c >= 'A' && c <= 'F') return (c - 'A' + 10);
        if (c >= 'a' && c <= 'f') return (c - 'a' + 10);

        throw new RuntimeException ("invalid hex char '" + c + "'");
    }

}
