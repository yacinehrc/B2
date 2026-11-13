import { useState } from "react";
import type { ChangeEvent, FormEvent } from "react"; // Types d'événements pour les formulaires (ChangeEvent pour les champs de saisie, FormEvent pour l'envoie du formulaire)
import { Link } from "react-router-dom";

type Props = {
  total: number;
  nbArticles: number;
  onValider: () => void;
};

// Règles de validation (expressions régulières) pour sécuriser les champs du formulaire
// À-ÿ = les lettres accentuées (é, è, à, ç, ï...)
const REGEX_NOM = /^[A-Za-zÀ-ÿ' -]{2,50}$/; // lettres, espaces, tirets, apostrophes
const REGEX_EMAIL = /^[^\s@]+@[^\s@]+\.[A-Za-z]{2,}$/; // texte@texte.extension
const REGEX_ADRESSE = /^[0-9A-Za-zÀ-ÿ',. -]{5,100}$/; // lettres, chiffres et ponctuation simple
const REGEX_CODE_POSTAL = /^[0-9]{5}$/; // exactement 5 chiffres
const REGEX_VILLE = /^[A-Za-zÀ-ÿ' -]{2,50}$/; // lettres, espaces, tirets, apostrophes

function Commande({ total, nbArticles, onValider }: Props) {
  const [form, setForm] = useState({
    nom: "",
    email: "",
    adresse: "",
    codePostal: "",
    ville: "",
  });

  // 3 States : form = les champs du formulaire, erreur = message d'erreur à afficher, validee = si le formulaire a été validé
  const [erreur, setErreur] = useState("");
  const [validee, setValidee] = useState(false);

  // e.target est le champ modifié, e.target.name est le nom du champ (nom, email, adresse, codePostal, ville),
  // e.target.value est la valeur du champ ("Alice", "alice@example.com", "123 Rue de la Paix", "75001", "Paris")
  function modifierChamp(e: ChangeEvent<HTMLInputElement>) {
    setForm({ ...form, [e.target.name]: e.target.value });
  }

  // Fonction appelée lors de l'envoi du formulaire
  function envoyerCommande(e: FormEvent<HTMLFormElement>) {
    e.preventDefault(); // Empêche le rechargement de la page lors de l'envoi du formulaire

    // On enlève les espaces en trop au début et à la fin
    const nom = form.nom.trim();
    const email = form.email.trim();
    const adresse = form.adresse.trim();
    const codePostal = form.codePostal.trim();
    const ville = form.ville.trim();

    // Vérification des champs du formulaire avec les expressions régulières définies plus haut.
    if (
      nom === "" ||
      email === "" ||
      adresse === "" ||
      codePostal === "" ||
      ville === ""
    ) {
      setErreur("Merci de remplir tous les champs.");
      return;
    }
    if (!REGEX_NOM.test(nom)) {
      setErreur(
        "Le nom ne doit contenir que des lettres, espaces, tirets ou apostrophes (2 à 50 caractères).",
      );
      return;
    }
    if (!REGEX_EMAIL.test(email)) {
      setErreur(
        "L'adresse e-mail n'est pas valide (exemple : nom@domaine.fr).",
      );
      return;
    }
    if (!REGEX_ADRESSE.test(adresse)) {
      setErreur(
        "L'adresse ne doit contenir que des lettres, chiffres, espaces, virgules, points, tirets ou apostrophes (5 à 100 caractères).",
      );
      return;
    }
    if (!REGEX_CODE_POSTAL.test(codePostal)) {
      setErreur("Le code postal doit contenir exactement 5 chiffres.");
      return;
    }
    if (!REGEX_VILLE.test(ville)) {
      setErreur(
        "La ville ne doit contenir que des lettres, espaces, tirets ou apostrophes (2 à 50 caractères).",
      );
      return;
    }

    // Si tout est bon, on met à jour le state form avec les valeurs nettoyées, on efface le message d'erreur, on passe validee à true et on appelle la fonction onValider() passée en props
    setForm({ nom, email, adresse, codePostal, ville });
    setErreur("");
    setValidee(true);
    onValider();
  }

  // Si le formulaire a été validé, on affiche un message de confirmation avec les informations de livraison et un bouton pour retourner à l'accueil
  if (validee) {
    return (
      <main>
        <h1>Merci {form.nom} !</h1>
        <p>Ta commande a bien été enregistrée.</p>
        <p>
          Livraison au : {form.adresse}, {form.codePostal} {form.ville}
        </p>
        <br />
        <Link to="/" className="bouton">
          Retour à l'accueil
        </Link>
      </main>
    );
  }

  if (nbArticles === 0) {
    // Si le panier est vide, on ne peut pas passer de commande, et on affiche un message "Ton panier est vide" avec un bouton de lien vers le catalogue
    return (
      <main>
        <h1>Commande</h1>
        <p>Ton panier est vide.</p>
        <br />
        <Link to="/produits" className="bouton">
          Voir le catalogue
        </Link>
      </main>
    );
  }

  // Formulaire avec des champs contrôlés (value et onChange) pour que React gère l'état des champs, et un bouton de validation qui appelle la fonction envoyerCommande() lors de l'envoi du formulaire.
  // Les "onChange={}" permettent de màj chaque frappe dans le State form
  // {erreur && <p className="erreur">{erreur}</p>} → N'affiche le message que s'il existe (erreur est une chaîne vide si pas d'erreur, donc falsy, et le message n'est pas affiché)
  return (
    <main>
      <h1>Informations de livraison</h1>
      <p className="recap">
        {nbArticles} article(s) — Total : {total.toFixed(2)} €
      </p>

      <form className="formulaire" onSubmit={envoyerCommande}>
        <label>
          Nom complet
          <input
            name="nom"
            value={form.nom}
            onChange={modifierChamp}
            maxLength={50}
          />
        </label>
        <label>
          E-mail
          <input
            type="email"
            name="email"
            value={form.email}
            onChange={modifierChamp}
            maxLength={100}
          />
        </label>
        <label>
          Adresse
          <input
            name="adresse"
            value={form.adresse}
            onChange={modifierChamp}
            maxLength={100}
          />
        </label>
        <label>
          Code postal
          <input
            name="codePostal"
            value={form.codePostal}
            onChange={modifierChamp}
            maxLength={5}
            inputMode="numeric"
          />
        </label>
        <label>
          Ville
          <input
            name="ville"
            value={form.ville}
            onChange={modifierChamp}
            maxLength={50}
          />
        </label>

        {erreur && <p className="erreur">{erreur}</p>}

        <button type="submit">Valider la commande</button>
      </form>
    </main>
  );
}
export default Commande;
