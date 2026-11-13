// App.tsx : le composant principal de l'application, affiche le menu, la page qui correspond à l'adresse, le pied de page et la notification.

// Import de tous les composants et types nécessaires pour l'application
import { useState } from "react";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Header from "./components/Header";
import Footer from "./components/Footer";
import Accueil from "./pages/Accueil";
import Produits from "./pages/Produits";
import Panier from "./pages/Panier";
import Commande from "./pages/Commande";
import type { PanierItem, Produit } from "./types";
// import "./App.css"; → Importait le CSS de la page démo de Vite, je l'ai supprimé étant inutile au projet
import Notification from "./components/Notification";

// 2 States : panier = les produits ajoutés au panier, notification = le produit ajouté au panier à afficher dans la notification
function App() {
  const [panier, setPanier] = useState<PanierItem[]>([]); // Hook : le panier

  const [notification, setNotification] = useState({ id: 0, titre: "" });

  // Ajouter un produit (ou +1 s'il y est déjà)
  function ajouterAuPanier(produit: Produit) {
    const existe = panier.find((item) => item.produit.id === produit.id); // Vérifie si le produit est déjà dans le panier, sinon undifined

    if (existe) {
      setPanier(
        panier.map((item) =>
          item.produit.id === produit.id // Si le produit est déjà dans le panier, on augmente sa quantité de 1
            ? { ...item, quantite: item.quantite + 1 }
            : item,
        ),
      );
    } else {
      // Sinon, on l'ajoute au panier avec une quantité de 1
      setPanier([...panier, { produit: produit, quantite: 1 }]);
    }
    // On met à jour la notification avec l'id du produit et son titre, pour que le composant Notification puisse l'afficher
    setNotification({ id: notification.id + 1, titre: produit.title });
  }

  // Enlever 1 (et supprimer la ligne si on tombe à 0)
  function diminuerQuantite(id: number) {
    setPanier(
      panier
        .map((item) =>
          item.produit.id === id
            ? { ...item, quantite: item.quantite - 1 }
            : item,
        )
        .filter((item) => item.quantite > 0),
    );
  }

  // Supprimer complètement un produit
  function retirerDuPanier(id: number) {
    setPanier(panier.filter((item) => item.produit.id !== id));
  }

  // Tout vider
  function viderPanier() {
    setPanier([]);
  }

  // Nombre d'articles et total, calculés à partir du panier
  let nbArticles = 0;
  let total = 0;
  for (const item of panier) {
    nbArticles += item.quantite;
    total += item.produit.price * item.quantite;
  }

  // <BrowserRouter> → Permet de gérer la navigation entre les pages de l'application, en SPA
  // <Header nbArticles={nbArticles} /> → Affiche le menu avec le nombre d'articles dans le panier
  // <Routes> → Contient toutes les routes de l'application, chaque route correspond à une page
  // <Route path="/" element={<Accueil />} /> → Affiche la page d'accueil
  // <Header> et <Footer> sont placés en dehors de <Routes> pour qu'ils soient affichés sur toutes les pages, et non pas seulement sur la page d'accueil.
  return (
    <BrowserRouter>
      <Header nbArticles={nbArticles} />
      <Routes>
        <Route path="/" element={<Accueil />} />
        <Route
          path="/produits"
          element={<Produits onAjouter={ajouterAuPanier} />}
        />
        <Route
          path="/panier"
          element={
            <Panier
              panier={panier}
              total={total}
              onAjouter={ajouterAuPanier}
              onDiminuer={diminuerQuantite}
              onRetirer={retirerDuPanier}
              onVider={viderPanier}
            />
          }
        />
        <Route
          path="/commande"
          element={
            <Commande
              total={total}
              nbArticles={nbArticles}
              onValider={viderPanier}
            />
          }
        />
        <Route
          path="*"
          element={
            <main>
              <h1>Page introuvable</h1>
            </main>
          }
        />
      </Routes>
      <Footer />

      {notification.id > 0 && ( // La notif. n'est affichée que si notification.id > 0, sa key change à chaque ajout au panier, donc React recrée le composant Notification à chaque ajout, et la notif. disparaît après 3 secondes.
        <Notification key={notification.id} titre={notification.titre} />
      )}
    </BrowserRouter>
  );
}
export default App;
