// Ce fichier ne s'excécute pas, il sert à TypeScript pour vérifier le code et à l'IDE pour l'autocomplétion.

export type Produit = {
  // Modèle (typage) de produit
  id: number;
  title: string;
  price: number;
  description: string;
  category: string;
  image: string;
};

export type PanierItem = {
  // Modèle (typage) d'élément du panier
  produit: Produit;
  quantite: number;
};
