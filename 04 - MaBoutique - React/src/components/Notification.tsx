type Props = {
  titre: string; // Le nom du produit qui vient d'être ajouté au panier
};

// Composant Notification qui affiche un message de confirmation lorsqu'un produit est ajouté au panier.
function Notification({ titre }: Props) {
  return (
    <div className="notification" role="status">
      <span className="notification-icone">✓</span>
      <div>
        <strong>Article ajouté au panier !</strong>
        <p>{titre}</p>
      </div>
    </div>
  );
}

export default Notification;
