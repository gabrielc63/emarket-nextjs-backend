declare namespace APISchema {
	type Product = {
		id: number;
		name: string;
		slug: string;
		sku?: string;
		description?: string;
		priceCents: number;
		currency: string;
		stockQuantity: number;
		status: string;
		createdAt: string;
		updatedAt: string;
	}

	type User = {
		id: number;
		name?: string;
		email?: string;
		createdAt: string;
		updatedAt: string;
	}


}
