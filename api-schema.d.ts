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

	type ProductTaxon = {
		id: number;
		productId: number;
		taxonId: number;
		createdAt: string;
		updatedAt: string;
	}

	type Taxon = {
		id: number;
		taxonomyId: number;
		parentId?: number;
		name: string;
		slug: string;
		position: number;
		createdAt: string;
		updatedAt: string;
	}

	type Taxonomy = {
		id: number;
		name: string;
		slug: string;
		createdAt: string;
		updatedAt: string;
	}

	type User = {
		id: number;
		name?: string;
		email: string;
		createdAt: string;
		updatedAt: string;
		role: string;
	}

	type Wishlist = {
		id: number;
		userId: number;
		name: string;
		createdAt: string;
		updatedAt: string;
	}

	type WishlistItem = {
		id: number;
		wishlistId: number;
		productId: number;
		createdAt: string;
		updatedAt: string;
	}


}
