// La page utilise 2 Hooks React (Hook = fonction qui permet d'utiliser des fonctionnalités de React dans un composant fonctionnel) : useState et useEffect

import { useEffect, useState } from "react";
import ProductCard from "../components/ProductCard";
import type { Produit } from "../types";

type Props = {
  onAjouter: (produit: Produit) => void;
};

function Produits({ onAjouter }: Props) {
  // Page catalogue
  const [produits, setProduits] = useState<Produit[]>([]); // Liste reçue de l'API, vide au début (définit ligne 7)
  const [chargement, setChargement] = useState(true); // Tant qu'on attend la réponse de l'API, on affiche un message de chargement
  const [erreur, setErreur] = useState(""); // Si l'API ne répond pas, on affiche un message d'erreur

  useEffect(() => {
    fetch("https://fakestoreapi.com/products") // Appel à l'API pour récupérer la liste des produits
      .then((reponse) => reponse.json()) // Transforme la réponse en JSON
      .then((data) => {
        // Range dans le State les produits et termine le chargement, React ré-affiche alors la page
        setProduits(data);
        setChargement(false);
      })
      .catch(() => {
        // En cas de problème avec l'API, on affiche un message d'erreur et termine le chargement
        setErreur("Impossible de charger les produits.");
        setChargement(false);
      });
  }, []);

  if (chargement)
    return (
      <main>
        <p>Chargement des produits...</p>
      </main>
    );
  if (erreur)
    // Si l'API ne répond pas, on affiche un message d'erreur
    return (
      <main>
        <p className="erreur">{erreur}</p>
      </main>
    );

  return (
    <main>
      <h1>Notre catalogue</h1>
      <div className="grille">
        {produits.map(
          (
            produit, // .map crée une ProductCard par produit, chacune avec un id unique (key), la fonction onAjouter est transmise à chaque carte
          ) => (
            <ProductCard
              key={produit.id}
              produit={produit}
              onAjouter={onAjouter}
            />
          ),
        )}
      </div>
    </main>
  );
}
export default Produits;
