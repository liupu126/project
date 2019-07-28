import java.text.SimpleDateFormat;
import java.util.Date;
import java.lang.System;
import java.text.ParseException;

/* For test
 * Compile: javac Test.java
 * Execute: java Test
 */
public class Test {

	public static void main(String[] args) {
		try {
			String str1 = "2018/4/6";
			SimpleDateFormat f1 = new SimpleDateFormat("yy/MM/dd");
			Date date1 = f1.parse(str1);

			String str2 = null;
			SimpleDateFormat f2 = new SimpleDateFormat("MM/dd/yy");
			str2 = f2.format(date1);

			System.out.println("str1 = " + str1); // 2018/4/6
			System.out.println("str2 = " + str2); // 04/06/18
		}
		catch (ParseException e)
		{
			System.out.println("Error: ParseException");
		}

		//BEGIN: check NullPointerException or not, if Boolean object is null(not initialized)
		Boolean b=null;
		System.out.println("###");
		try {
			if(!b)// if b==null, throw NullPointerException here
			{
				System.out.println("123");
			}
			else
			{
				System.out.println("456");
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		System.out.println("***");
		//END: check NullPointerException or not, if Boolean object is null(or not initialized)
	}

}
