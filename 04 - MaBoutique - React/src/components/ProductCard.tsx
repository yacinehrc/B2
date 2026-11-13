import { Link } from "react-router-dom"; // Récup. de la nav. SPA
import type { Produit } from "../types"; // Récup. du modèle Produit

type Props = {
  produit: Produit; // Produit à afficher
  onAjouter: (produit: Produit) => void; // Fonction qui prend un produit et ne renvoie rien (void)
};

function ProductCard({ produit, onAjouter }: Props) {
  // Fait afficher la carte d'un produit par App.tsx, en lui passant le produit et la fonction onAjouter
  return (
    // 19. Construction de l'adresse de la page Produit avec l'id du produit, pour que le composant ProductPage.tsx puisse récupérer l'id du produit à afficher.
    // 20. Le composant Link de react-router-dom permet de naviguer vers la page Produit sans recharger la page, en SPA (Single Page Application).
    // 21. Le composant Link prend en paramètre l'adresse de la page Produit, construite avec l'id du produit, et affiche le titre du produit.
    // 23. .slice(0, 80) garde les 80 premiers caractères de la description du produit, pour ne pas afficher toute la description dans la carte.
    // 24. toFixed(2) affiche le prix du produit avec 2 décimales, pour que le prix soit toujours affiché avec 2 chiffres après la virgule.

    <div className="carte">
      <Link to={`/produit/${produit.id}`}>
        <img src={produit.image} alt={produit.title} />
        <h3>{produit.title}</h3>
      </Link>
      <p className="description">{produit.description.slice(0, 80)}...</p>
      <p className="prix">{produit.price.toFixed(2)} €</p>
      <button onClick={() => onAjouter(produit)}>Ajouter au panier</button>
    </div>
  );
}
export default ProductCard;
