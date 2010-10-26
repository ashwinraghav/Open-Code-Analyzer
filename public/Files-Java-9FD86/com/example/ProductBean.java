package com.example;

import java.text.NumberFormat;

//productbean class is used to set and get the values of product
public class ProductBean {
	private boolean isImported;
	private String itemName;
	private boolean isSalesTax;
	private double itemPrice;
	
	public boolean isImported() {
		return isImported;
	}

	public boolean isSalesTax() {
		return isSalesTax;
	}

	public String getItemName() {
		return itemName;
	}

	public double getItemPrice() {
		return itemPrice;
	}

	public void setImported(boolean b) {
		isImported = b;
	}

	public void setSalesTax(boolean b) {
		isSalesTax = b;
	}

	public void setItemName(String string) {
		itemName = string;
	}

	public void setItemPrice(double d) {
		itemPrice = d;
	}
	
	public String getDetails(ProductBean product)
	{
		String productDetails = "";
		productDetails = productDetails + product.getItemName() + " : "+round(product.getItemPrice(), 2)+"\n";
	
		return productDetails;
	}
		
	private String round(double value, int decimal) 
	{
		String roundedValue = "";
		NumberFormat numberFormat = NumberFormat.getInstance();
		numberFormat.setMaximumFractionDigits(decimal);
		numberFormat.setMinimumFractionDigits(decimal);
		roundedValue = numberFormat.format(value).toString();
		return roundedValue;
	}
}

