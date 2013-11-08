/*
 * 2012-6-20 o≧﹏≦o Powered by EXvision
 */

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataOutput;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;


import flex.messaging.io.SerializationContext;
import flex.messaging.io.amf.Amf3Input;
import flex.messaging.io.amf.Amf3Output;

public class AMF3CodecUtils
{

	private static final int CAP = 8 * 1024;

	private static final SerializationContext context = new AMF3SerializationContext();

	public static byte[] rawEncode(Object message)
	{
		if (message == null)
		{
			return null;
		}
		ByteArrayOutputStream out = new ByteArrayOutputStream(CAP);
		try
		{
			// write message
			amf3Encode(message, out);

			byte[] raw = out.toByteArray();
			out.close();

			out = null;

			return raw;
		}
		catch (IOException e)
		{
			return null;
		}
	}


	public static Object rawDecode(byte[] data)
	{
		Object message = null;
		ByteArrayInputStream input = new ByteArrayInputStream(data);
		message = amf3Decode(input);
		input = null;
		return message;
	}


	private static void amf3Encode(Object message, OutputStream out)
	{
		Amf3Output amf3out = null;
		amf3out = new Amf3Output(context);
		amf3out.setOutputStream(out);
		try
		{
			amf3out.writeObject(message);
			amf3out.writeObjectEnd();

			amf3out.close();
			amf3out = null;
		}
		catch (Exception e)
		{
		}
	}

	private static Object amf3Decode(InputStream input)
	{
		Object message = null;
		Amf3Input amf3in = new Amf3Input(context);
		amf3in.setInputStream(input);
		try
		{
			if (amf3in.available() == 0)
			{
			}
			else
			{
				message = amf3in.readObject();
			}
		}
		catch (Exception e)
		{
			return null;
		}
		finally
		{
			try
			{
				amf3in.close();
			}
			catch (IOException e)
			{
				return null;
			}

			amf3in = null;
			input = null;
		}
		return message;
	}
}
