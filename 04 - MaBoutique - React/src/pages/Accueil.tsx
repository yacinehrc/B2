// Page d'accueil du site e-commerce, affichée par App.tsx à l'adresse "/", sert comme un index.html en HTML

import { Link } from "react-router-dom";

function Accueil() {
  return (
    <main className="accueil">
      <h1>Bienvenue sur MaBoutique - React</h1>
      <p>Vêtements, bijoux, électronique : trouve tout ce qu'il te faut.</p>
      <Link to="/produits" className="bouton">
        Voir le catalogue
      </Link>
    </main>
  );
}
export default Accueil;
