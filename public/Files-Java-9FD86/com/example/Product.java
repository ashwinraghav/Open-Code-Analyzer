package com.example;

// Product class is used to do the product related operations
public class Product {

	public Product() {
		super();
	}

	public double calculateTaxes(ProductBean[] products) 
	{
		double totalSalesTax = 0.0;
		boolean isProdImported = false;
		boolean isProdSalesTaxable = false;
		for (int i = 0; i < products.length; i++) 
		{
			ProductBean product = products[i];
			double importDuty = 0.0;
			double salesTax = 0.0;
			double itemPrice = product.getItemPrice();
			isProdImported = product.isImported();
			if (isProdImported == true) 
			{
				importDuty = itemPrice * 0.05;
			}
			isProdSalesTaxable = product.isSalesTax();
			if (isProdSalesTaxable == true) 
			{
				salesTax = itemPrice * 0.1;
			}
			totalSalesTax = totalSalesTax + (round(itemPrice + importDuty + salesTax) - itemPrice);
			itemPrice = round(itemPrice + importDuty + salesTax);
			product.setItemPrice(itemPrice);
		}
		return totalSalesTax;
	}

	private static double round(double value) 
	{
		int decimals = 2;
		double roundFactor = 1.0;
		while (decimals > 0) 
		{
			roundFactor *= 10.0;
			--decimals;
		}
		double tempValue = (value * roundFactor) + 0.5;
		int roundedValue = (int) (tempValue / 10) * 10;
		int digit = (int) tempValue - roundedValue;
		if (digit <= 4 & digit > 0) 
		{
			digit = 5;
			roundedValue = roundedValue + digit;
		}
		else 
		{
			roundedValue = (int) tempValue;
		}
		return roundedValue / roundFactor;
	}
}
