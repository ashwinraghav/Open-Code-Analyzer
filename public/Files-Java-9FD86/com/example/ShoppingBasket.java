package com.example;

public class ShoppingBasket {

	public static void main(String[] args) 
	{
		String inputStr = null;
		if (args.length > 0) 
		{
			inputStr = (String) args[0];
			if (inputStr == null) 
			{
				System.out.println("Please enter the input choice...");
				System.exit(0);
			}
		} else 
		{
			System.out.println("Please enter the input choice...");
			System.exit(0);
		}
		int inputNo = 0;
		try 
		{
			inputNo = Integer.parseInt(inputStr);
		} 
		catch (NumberFormatException nfe) 
		{
			System.out.println("Please enter the number as a choice...");
			System.exit(0);
		}

		ProductBean[] input = new ProductBean[5];
		ShoppingBasket shoppingBasket = new ShoppingBasket();
		switch (inputNo) 
		{
			case 1 :
				input = shoppingBasket.createInput1();
				break;
			case 2 :
				input = shoppingBasket.createInput2();
				break;
			case 3 :
				input = shoppingBasket.createInput3();
				break;
			default :
				System.out.println("Please enter the option 1, 2 or 3");
				System.exit(0);
		}
		shoppingBasket.processRequest(input);
	}

	public void processRequest(ProductBean[] productsbean) 
	{
		Product product = new Product();
		double salesTax = (double) product.calculateTaxes(productsbean);
		Receipt receipt = new Receipt();
		receipt.showReceipt(productsbean, salesTax);
	}

	public ProductBean[] createInput1() 
	{
		boolean[] imported = { false, false, false };
		String[] itemNames = { "Book", "Music CD", "Chocolate Bar" };
		boolean[] salesTax = { false, true, false };
		double[] unitPrices = { 12.49, 14.99, 0.85 };

		ProductBean[] productsbean = new ProductBean[3];

		for (int i = 0; i < productsbean.length; i++) {
			ProductBean productBean = new ProductBean();
			productBean.setImported(imported[i]);
			productBean.setItemName(itemNames[i]);
			productBean.setSalesTax(salesTax[i]);
			productBean.setItemPrice(unitPrices[i]);
			productsbean[i] = productBean;
		}
		return productsbean;
	}

	public ProductBean[] createInput2() 
	{
		boolean[] imported = { true, true };
		String[] itemNames = { "ImportedBox of Chocolates", "Imported bottle of Perfume" };
		boolean[] salesTax = { false, true };
		double[] unitPrices = { 10.00, 47.50 };

		ProductBean[] productsbean = new ProductBean[2];

		for (int i = 0; i < productsbean.length; i++) {
			ProductBean productBean = new ProductBean();
			productBean.setImported(imported[i]);
			productBean.setItemName(itemNames[i]);
			productBean.setSalesTax(salesTax[i]);
			productBean.setItemPrice(unitPrices[i]);
			productsbean[i] = productBean;
		}
		return productsbean;
	}

	public ProductBean[] createInput3() 
	{
		boolean[] imported = { true, false, false, true };
		String[] itemNames = { "Imported bottle of perfume", "Bottle of Prefume", "Packet of Headache pills", "Imported box of chocolates" };
		boolean[] salesTax = { true, true, false, false };
		double[] unitPrices = { 27.99, 18.99, 9.75, 11.25 };

		ProductBean[] productsbean = new ProductBean[4];

		for (int i = 0; i < productsbean.length; i++) {
			ProductBean productBean = new ProductBean();
			productBean.setImported(imported[i]);
			productBean.setItemName(itemNames[i]);
			productBean.setSalesTax(salesTax[i]);
			productBean.setItemPrice(unitPrices[i]);
			productsbean[i] = productBean;
		}
		return productsbean;

	}

}
