// Configuration de Vite, le plugin React traduit le JSX et TSX en JS et active le HMR (Hot Module Replacement).

import react from "@vitejs/plugin-react";
import { defineConfig } from "vite";

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
});
