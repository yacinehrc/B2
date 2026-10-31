// Auto-refresh du chat : toutes les 3 s on redemande la liste des messages au serveur
const zoneMessages = document.getElementById('zone-messages');

function allerEnBas() {
    zoneMessages.scrollTop = zoneMessages.scrollHeight;
}

// Vrai si l'utilisateur est (presque) tout en bas de la conversation
function estEnBas() {
    return zoneMessages.scrollHeight - zoneMessages.scrollTop - zoneMessages.clientHeight < 80;
}

// Dernier HTML reçu, pour ne rien toucher s'il n'y a pas de nouveau message
let dernierHtml = null;

async function rafraichirMessages() {
    try {
        // X-Requested-With marque la requête comme AJAX : si la session a expiré,
        // Symfony ne la retiendra pas comme "page à ouvrir après la connexion"
        const reponse = await fetch(zoneMessages.dataset.url, {
            headers: { 'X-Requested-With': 'XMLHttpRequest' },
        });

        // Erreur ou redirection vers /connexion : on ne touche à rien
        if (!reponse.ok || reponse.redirected) {
            return;
        }

        const html = await reponse.text();
        if (html === dernierHtml) {
            return;
        }
        dernierHtml = html;

        // On ne renvoie pas en bas quelqu'un qui relit d'anciens messages
        const etaitEnBas = estEnBas();
        zoneMessages.innerHTML = html;
        if (etaitEnBas) {
            allerEnBas();
        }
    } catch (erreur) {
        // Problème réseau : on réessaiera au prochain tour
    }
}

if (zoneMessages) {
    allerEnBas();
    setInterval(rafraichirMessages, 3000);
}
