// Objectif : dessiner l'application dans la page HTML

import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import "./index.css"; // Charge le style pour toute l'application
import App from "./App.tsx";

// createRoot().render() dessine le composant App dans cette boite.
createRoot(document.getElementById("root")!).render(
  // Trouve l'élément HTML avec l'id "root" et y dessine l'application React, le ! confirme à TypeScript que l'élément existe

  // Mode de vérification en développement pour détecter les problèmes potentiels dans l'application.
  <StrictMode>
    <App />
  </StrictMode>,
);
