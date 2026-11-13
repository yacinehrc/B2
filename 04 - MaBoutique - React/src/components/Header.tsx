// Fichier pour le header de l'application, qui contient le logo et les liens vers les pages principales.
// Peu importe la page, le header est toujours affiché en haut de la page.

import { Link } from "react-router-dom"; // Permet de naviguer sans recharger la page.

// Le header attend une prop, en l'occurrence le nombre d'articles dans le panier, pour l'afficher dans le lien vers le panier.
type Props = {
  nbArticles: number;
};

function Header({ nbArticles }: Props) {
  return (
    // Le header contient le logo et les liens vers les pages principales de l'application.
    <header className="header">
      <Link to="/" className="logo">
        MaBoutique - React
      </Link>
      <nav>
        <Link to="/">Accueil</Link>
        <Link to="/produits">Catalogue</Link>
        <Link to="/panier">
          Panier{" "}
          <span className="compteur" key={nbArticles}>
            {nbArticles}
          </span>
        </Link>
      </nav>
    </header>
  );
}
export default Header;
