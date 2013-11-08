/*
 * 2011-4-12 o≧﹏≦o Powered by EXvision
 */

import flex.messaging.io.SerializationContext;

public class AMF3SerializationContext extends SerializationContext
{

	/**
	 * 
	 */
	private static final long serialVersionUID = -6180491156919859871L;

	public AMF3SerializationContext()
	{
		this.ignorePropertyErrors = false;
		this.logPropertyErrors = true;
	}

}
