package com.example;

import java.text.NumberFormat;

//Receipt class process the receipt operations
public class Receipt {
	public void showReceipt(ProductBean[] productsbean,	double salesTax) 
	{
		String productDetails = "";
		double total = 0.0;
		for (int i = 0; i < productsbean.length; i++) 
		{
			ProductBean product = productsbean[i];
			productDetails = productDetails + product.getDetails(product);
			total = total + product.getItemPrice();
		}
		System.out.print(productDetails);
		System.out.println("Sales Taxes : " + round(salesTax, 2));
		System.out.println("Total : " + round(total, 2));
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
