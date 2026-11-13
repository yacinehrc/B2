// Objectif : affiche ce qu'on lui donne et affiche les fonctions de l'App et n'a donc aucun State

import { Link } from "react-router-dom";
import type { PanierItem, Produit } from "../types";

type Props = {
  // Props par défaut toutes vides au début
  panier: PanierItem[];
  total: number;
  onAjouter: (produit: Produit) => void;
  onDiminuer: (id: number) => void;
  onRetirer: (id: number) => void;
  onVider: () => void;
};

function Panier({
  panier,
  total,
  onAjouter,
  onDiminuer,
  onRetirer,
  onVider,
}: Props) {
  // Page panier
  if (panier.length === 0) {
    // Panier vide = Renvoie vers la page Catalogue avec un message "Ton panier est vide"
    return (
      <main>
        <h1>Mon panier</h1>
        <p>Ton panier est vide.</p>
        <br />
        <Link to="/produits" className="bouton">
          Voir le catalogue
        </Link>
      </main>
    );
  }

  return (
    <main>
      <h1>Mon panier</h1>
      <ul className="liste-panier">
        {panier.map((item) => (
          // 46. {item.produit.id} est l'id du produit, qui est unique, donc on peut l'utiliser comme clé pour chaque élément de la liste.
          // 57. Le sous-total de la ligne (prix * quantité), calculé avant l'arrondi grâce aux parenthèses, puis le bouton qui retire la ligne entière

          <li key={item.produit.id}>
            <img src={item.produit.image} alt={item.produit.title} />
            <span className="nom">{item.produit.title}</span>

            <div className="quantite">
              <button onClick={() => onDiminuer(item.produit.id)}>−</button>
              <span>{item.quantite}</span>
              <button onClick={() => onAjouter(item.produit)}>+</button>
            </div>
            <span className="sous-total">
              {(item.produit.price * item.quantite).toFixed(2)} €
            </span>
            <button
              className="btn-secondaire"
              onClick={() => onRetirer(item.produit.id)}
            >
              Retirer
            </button>
          </li>
        ))}
      </ul>

      <p className="total">Total : {total.toFixed(2)} €</p>

      <div className="actions">
        <button className="btn-secondaire" onClick={onVider}>
          Vider le panier
        </button>
        <Link to="/commande" className="bouton">
          Passer commande
        </Link>
      </div>
    </main>
  );
}
export default Panier;
