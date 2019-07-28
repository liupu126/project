import java.lang.System;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.lang.Exception;

/* Format Key Attestation keybox file.
 *
 * Compile: javac KAKeyBoxFormat.java
 * Execute: java KAKeyBoxFormat <project_name> <sn_no> <sn_no_start> <sn_no_end> <input_file>
 *
 * History:
 *		2018/05/14	Braden Liu	Create file.
 *		2018/05/16	Braden Liu	Generate output filename automatically.
 */
public class KAKeyBoxFormat {
	public static final String BEGIN_STR = "-----BEGIN";
	public static final char NEW_LINE = '\n';

	public static void main(String[] args) {
		if (args == null || args.length < 5 )
		{
			System.out.println("Error: No Enough Parameters!");
			System.out.println("Usage: java KAKeyBoxFormat <project_name> <sn_no> <sn_no_start> <sn_no_end> <input_file>");
			return;
		}

		/*
		 * Generate output filename
		 */
		final String PROJECT_NAME = args[0];
		final String SN_NO = args[1];
		final String SN_NO_START = args[2];
		final String SN_NO_END = args[3];
		final String INPUT_FILE = args[4];
		final String NEW_SUFFIX = ".keybox";
		final String OLD_SUFFIX = ".output";

		final String input_file = new File(INPUT_FILE).getName();
		final int suffix_index = input_file.lastIndexOf(OLD_SUFFIX);
		if (suffix_index == -1)
		{
			System.out.println("Error: input filename suffix must be " + OLD_SUFFIX + " !");
			return;
		}
		final String output_file =
			PROJECT_NAME + "-" + SN_NO + "-" + SN_NO_START + "-" + SN_NO_END + "-" + input_file.substring(0, suffix_index);

		//final String output_file_tmp = "formal.tmp";
		//final String output_file_formal = "formal.keybox";
		final String output_file_tmp = output_file + ".tmp";
		final String output_file_formal = output_file + NEW_SUFFIX;
		int line = 0;
		String str = null;
		int index;
		boolean format_fail = false;

		/*
		 *Remove files which already exist
		 */
		File tmpFile = new File(output_file_tmp);
		File formalFile = new File(output_file_formal);
		boolean dflag = false; // delete flag
		if (tmpFile.exists())
		{
			dflag = tmpFile.delete();
			if (dflag == false)
			{
				System.out.println("Error: Delete file " + tmpFile.toString() + " failed!");
				return;
			}
		}
		if (formalFile.exists())
		{
			dflag = formalFile.delete();
			if (dflag == false)
			{
				System.out.println("Error: Delete file " + formalFile.toString() + " failed!");
				return;
			}
		}

		/*
		 * Transform "...>-----BEGIN" line to:
		 * " ...>
		 *   -----BEGIN"
		 */
		BufferedReader reader = null;
		BufferedWriter writer = null;
		try {
			reader = new BufferedReader(new FileReader(INPUT_FILE));
			writer = new BufferedWriter(new FileWriter(tmpFile));
			while((str = reader.readLine()) != null)
			{
				line++;
				if (line%10000==0)
				{
					System.out.println("Info: Processing line=" + line);
				}

				if ((index = str.indexOf(BEGIN_STR)) != -1)
				{
					writer.write(str, 0, index);
					writer.write(NEW_LINE);
					writer.write(str, index, str.length()-index);
					writer.write(NEW_LINE);
				}
				else
				{
					writer.write(str, 0, str.length());
					writer.write(NEW_LINE);
				}
			}

			writer.flush();
		}
		catch (Exception e)
		{
			e.printStackTrace();
			format_fail = true;
		}
		finally
		{
			try {
				writer.close();
				reader.close();
			}
			catch (Exception e)
			{
				e.printStackTrace();
			}
		}

		if (format_fail)
		{
			System.out.println("Error: Format failed!");
		}
		else
		{
			System.out.println("Info: Format successfully!");
			// Rename file
			boolean flag = tmpFile.renameTo(formalFile);
			if (flag) {
				System.out.println("Info: File renamed successfully");
				System.out.println("Info: Output file name -> " + formalFile);
			} else {
				System.out.println("Error: Rename operation failed");
			}
		}

		return;
	}
}
